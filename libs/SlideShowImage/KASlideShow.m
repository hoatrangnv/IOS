//
//  KASlideShow.m
//
// Copyright 2013 Alexis Creuzot
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "KASlideShow.h"
#import "UIImageView+WebCache.h"

#define kSwipeTransitionDuration 0.25

typedef NS_ENUM(NSInteger, KASlideShowSlideMode) {
    KASlideShowSlideModeForward,
    KASlideShowSlideModeBackward
};

@interface KASlideShow()
@property (atomic) BOOL doStop;
@property (atomic) BOOL isAnimating;
@property (strong,nonatomic) UIImageView * topImageView;
@property (strong,nonatomic) UIImageView * bottomImageView;
@end

@implementation KASlideShow


- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setDefaultValues];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaultValues];
    }
    return self;
}

- (void)setImageMode:(UIViewContentMode) mode {
    [_topImageView setContentMode:mode];
    [_bottomImageView setContentMode:mode];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
	
	// Do not reposition the embedded imageViews.
	frame.origin.x = 0;
	frame.origin.y = 0;
	
    _topImageView.frame = frame;
    _bottomImageView.frame = frame;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!CGRectEqualToRect(self.bounds, _topImageView.bounds)) {
        _topImageView.frame = self.bounds;
    }
    
    if (!CGRectEqualToRect(self.bounds, _bottomImageView.bounds)) {
        _bottomImageView.frame = self.bounds;
    }
}

- (void) setDefaultValues
{
    self.clipsToBounds = YES;
    self.images = [NSMutableArray array];
    _currentIndex = 0;
    self.delay = 3;
    
    self.transitionDuration = 1;
    self.transitionType = KASlideShowTransitionFade;
    _doStop = YES;
    _isAnimating = NO;
    
    _topImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _bottomImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _topImageView.autoresizingMask = _bottomImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _topImageView.clipsToBounds = YES;
    _bottomImageView.clipsToBounds = YES;
    [self setImagesContentMode:UIViewContentModeScaleAspectFit];
    
    [self addSubview:_bottomImageView];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view":_bottomImageView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view":_bottomImageView}]];
    
    [self addSubview:_topImageView];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view":_topImageView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view":_topImageView}]];
}

- (void) setImagesContentMode:(UIViewContentMode)mode
{
    _topImageView.contentMode = mode;
    _bottomImageView.contentMode = mode;
}

- (UIViewContentMode) imagesContentMode
{
    return _topImageView.contentMode;
}

- (void) addGesture:(KASlideShowGestureType)gestureType
{
    switch (gestureType)
    {
        case KASlideShowGestureTap:
            [self addGestureTap];
            break;
        case KASlideShowGestureSwipe:
            [self addGestureSwipe];
            break;
        case KASlideShowGestureAll:
            [self addGestureTap];
            [self addGestureSwipe];
            break;
        default:
            break;
    }
}

- (void) addGestureOnline:(KASlideShowGestureType)gestureType
{
    switch (gestureType)
    {
        case KASlideShowGestureTap:
            [self addGestureTap];
            break;
        case KASlideShowGestureSwipe:
            [self addGestureSwipeOnline];
            break;
        case KASlideShowGestureAll:
            [self addGestureTapOnline];
            [self addGestureSwipeOnline];
            break;
        default:
            break;
    }
}

- (void) removeGestures
{
    self.gestureRecognizers = nil;
}

- (void) addImagesFromResources:(NSArray *) names
{
    for(NSString * name in names){
        [self addImage:[UIImage imageNamed:name]];
    }
}

- (void) setImagesDataSource:(NSMutableArray *)array {
    self.images = array;
    _topImageView.image = [array firstObject];
}

- (void) addImage:(UIImage*) image
{
    [self.images addObject:image];
    if([self.images count] == 1){
        _topImageView.image = image;
    }else if([self.images count] == 2){
        _bottomImageView.image = image;
    }
}

- (void) setImagesDataSourceOnline:(NSMutableArray *)array {
    if (_currentIndex >= array.count)
        _currentIndex = 0;
    if (self.images) {
        [self.images removeAllObjects];
    }
    for(NSString * name in array){
//
        NSString *sURL = [NSString stringWithFormat:@"https://vimass.vn/vmbank/services/media/getImage?id=%@", name];
//        NSLog(@"%s - sURL : %@", __FUNCTION__, sURL);
        [self addImageOnline:sURL];
    }
    if (_currentIndex < self.images.count) {
        NSString *sURL = [self.images objectAtIndex:_currentIndex];
        [_topImageView sd_setImageWithURL:[NSURL URLWithString:sURL] placeholderImage:[UIImage imageNamed:@"bg_home1.png"]];
    }
}

- (void) addImageOnline:(NSString *)sURL {
    [self.images addObject:sURL];
    if([self.images count] == 1){
        [_topImageView sd_setImageWithURL:[NSURL URLWithString:sURL] placeholderImage:[UIImage imageNamed:@"bg_home1.png"]];
    }else if([self.images count] == 2){
        [_bottomImageView sd_setImageWithURL:[NSURL URLWithString:sURL] placeholderImage:[UIImage imageNamed:@"bg_home1.png"]];
    }
}

- (void) emptyAndAddImagesFromResources:(NSArray *)names
{
    [self.images removeAllObjects];
    _currentIndex = 0;
    [self addImagesFromResources:names];
}

- (void) emptyAndAddImages:(NSArray *)images
{
    [self.images removeAllObjects];
    _currentIndex = 0;
    for (UIImage *image in images){
        [self addImage:image];
    }
}

- (void) startOnline {
    _doStop = NO;
//    NSLog(@"%s =============> _currentIndex : %lu", __FUNCTION__, (unsigned long)_currentIndex);
    [self nextOnline];
}

- (void) stopOnline {
    _doStop = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(nextOnline) object:nil];
}

- (void)luuIndexQuangCao {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setInteger:_currentIndex forKey:@"KEY_INDEX_CLICK_QC"];
    [user synchronize];
}

- (void) previousOnline {
    if(! _isAnimating && ([self.images count] >1 || self.dataSource)){

//        if ([self.delegate respondsToSelector:@selector(kaSlideShowWillShowPrevious:)]) [self.delegate kaSlideShowWillShowPrevious:self];

        // Previous image
        if (self.dataSource) {
            _topImageView.image = [self.dataSource slideShow:self imageForPosition:KASlideShowPositionTop];
            _bottomImageView.image = [self.dataSource slideShow:self imageForPosition:KASlideShowPositionBottom];
        } else {
            NSUInteger prevIndex;
            if(_currentIndex == 0){
                prevIndex = [self.images count] - 1;
            }else{
                prevIndex = (_currentIndex-1)%[self.images count];
            }
            NSString *sURL1 = self.images[_currentIndex];
            NSString *sURL2 = self.images[prevIndex];

            [self luuIndexQuangCao];

            [_topImageView sd_setImageWithURL:[NSURL URLWithString:sURL1] placeholderImage:nil];
            [_bottomImageView sd_setImageWithURL:[NSURL URLWithString:sURL2] placeholderImage:nil];
//            _topImageView.image = self.images[_currentIndex];
//            _bottomImageView.image = self.images[prevIndex];
            _currentIndex = prevIndex;
        }

        // Animate
        switch (self.transitionType) {
            case KASlideShowTransitionFade:
                [self animateFadeOnline];
                break;

            case KASlideShowTransitionSlide:
                [self animateSlideOnline:KASlideShowSlideModeBackward];
                break;
        }

        // Call delegate
//        if([self.delegate respondsToSelector:@selector(kaSlideShowDidShowPrevious:)]){
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, self.transitionDuration * NSEC_PER_SEC);
//            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                [self.delegate kaSlideShowDidShowPrevious:self];
//            });
//        }
    }
}

- (void)hienThiAnhTaiIndex {
    _doStop = NO;
    [self nextOnline];
}

- (void) nextOnline {
    if(! _isAnimating && ([self.images count] >1 || self.dataSource)) {
        // Next Image
        if (self.dataSource) {
            _topImageView.image = [self.dataSource slideShow:self imageForPosition:KASlideShowPositionTop];
            _bottomImageView.image = [self.dataSource slideShow:self imageForPosition:KASlideShowPositionBottom];
        } else {
            NSUInteger nextIndex = (_currentIndex+1) % [self.images count];
            NSString *sURL1 = self.images[_currentIndex];
            NSString *sURL2 = self.images[nextIndex];
            NSLog(@"%s - sURL1 : %@", __FUNCTION__, sURL1);
            [self luuIndexQuangCao];

            [_topImageView sd_setImageWithURL:[NSURL URLWithString:sURL1] placeholderImage:[UIImage imageNamed:@"bg_home1.png"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

            }];
            [_bottomImageView sd_setImageWithURL:[NSURL URLWithString:sURL2] placeholderImage:[UIImage imageNamed:@"bg_home1.png"]];
//            _bottomImageView.image = self.images[nextIndex];
            _currentIndex = nextIndex;
        }

        // Animate
        switch (self.transitionType) {
            case KASlideShowTransitionFade:
                [self animateFadeOnline];
                break;
            case KASlideShowTransitionSlide:
                [self animateSlideOnline:KASlideShowSlideModeForward];
                break;
        }

        // Call delegate

//        if (self.delegate) {
//            if([self.delegate respondsToSelector:@selector(kaSlideShowDidShowNext:)]){
//                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, self.transitionDuration * NSEC_PER_SEC);
//                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                    [self.delegate kaSlideShowDidShowNext:self];
//                });
//            }
//        }
    }
}

- (void) start
{
    _doStop = NO;
    [self next];
}

- (void) next
{
    if(! _isAnimating && ([self.images count] >1 || self.dataSource)) {
        
        if ([self.delegate respondsToSelector:@selector(kaSlideShowWillShowNext:)]) [self.delegate kaSlideShowWillShowNext:self];
        
        // Next Image
        if (self.dataSource) {
            _topImageView.image = [self.dataSource slideShow:self imageForPosition:KASlideShowPositionTop];
            _bottomImageView.image = [self.dataSource slideShow:self imageForPosition:KASlideShowPositionBottom];
        } else {
            NSUInteger nextIndex = (_currentIndex+1)%[self.images count];
            _topImageView.image = self.images[_currentIndex];
            _bottomImageView.image = self.images[nextIndex];
            _currentIndex = nextIndex;
        }
        
        // Animate
        switch (self.transitionType) {
            case KASlideShowTransitionFade:
                [self animateFade];
                break;
                
            case KASlideShowTransitionSlide:
                [self animateSlide:KASlideShowSlideModeForward];
                break;
                
        }
        
        // Call delegate
        if([self.delegate respondsToSelector:@selector(kaSlideShowDidShowNext:)]){
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, self.transitionDuration * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.delegate kaSlideShowDidShowNext:self];
            });
        }
    }
}

- (void) previous
{
    if(! _isAnimating && ([self.images count] >1 || self.dataSource)){
        
        if ([self.delegate respondsToSelector:@selector(kaSlideShowWillShowPrevious:)]) [self.delegate kaSlideShowWillShowPrevious:self];
        
        // Previous image
        if (self.dataSource) {
            _topImageView.image = [self.dataSource slideShow:self imageForPosition:KASlideShowPositionTop];
            _bottomImageView.image = [self.dataSource slideShow:self imageForPosition:KASlideShowPositionBottom];
        } else {
            NSUInteger prevIndex;
            if(_currentIndex == 0){
                prevIndex = [self.images count] - 1;
            }else{
                prevIndex = (_currentIndex-1)%[self.images count];
            }
            _topImageView.image = self.images[_currentIndex];
            _bottomImageView.image = self.images[prevIndex];
            _currentIndex = prevIndex;
        }
        
        // Animate
        switch (self.transitionType) {
            case KASlideShowTransitionFade:
                [self animateFade];
                break;
                
            case KASlideShowTransitionSlide:
                [self animateSlide:KASlideShowSlideModeBackward];
                break;
        }
        
        // Call delegate
        if([self.delegate respondsToSelector:@selector(kaSlideShowDidShowPrevious:)]){
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, self.transitionDuration * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.delegate kaSlideShowDidShowPrevious:self];
            });
        }
    }
}

- (void) animateFade
{
    _isAnimating = YES;

    [UIView animateWithDuration:self.transitionDuration
                     animations:^{
                         _topImageView.alpha = 0;
                     }
                     completion:^(BOOL finished){

                         _topImageView.image = _bottomImageView.image;
                         _topImageView.alpha = 1;

                         _isAnimating = NO;

                         if(! _doStop){
                             [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(next) object:nil];
                             [self performSelector:@selector(next) withObject:nil afterDelay:self.delay];
                         }
                     }];
}

- (void) animateFadeOnline
{
    _isAnimating = YES;
    
    [UIView animateWithDuration:self.transitionDuration
                     animations:^{
                         _topImageView.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         
                         _topImageView.image = _bottomImageView.image;
                         _topImageView.alpha = 1;
                         
                         _isAnimating = NO;
                         
                         if(! _doStop){
                             [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(nextOnline) object:nil];
                             [self performSelector:@selector(nextOnline) withObject:nil afterDelay:self.delay];
                         }
                     }];
}

- (void) animateSlideOnline:(KASlideShowSlideMode) mode
{
    _isAnimating = YES;

    if(mode == KASlideShowSlideModeBackward){
        _bottomImageView.transform = CGAffineTransformMakeTranslation(- _bottomImageView.frame.size.width, 0);
    }else if(mode == KASlideShowSlideModeForward){
        _bottomImageView.transform = CGAffineTransformMakeTranslation(_bottomImageView.frame.size.width, 0);
    }

    [UIView animateWithDuration:self.transitionDuration
                     animations:^{

                         if(mode == KASlideShowSlideModeBackward){
                             _topImageView.transform = CGAffineTransformMakeTranslation( _topImageView.frame.size.width, 0);
                             _bottomImageView.transform = CGAffineTransformMakeTranslation(0, 0);
                         }else if(mode == KASlideShowSlideModeForward){
                             _topImageView.transform = CGAffineTransformMakeTranslation(- _topImageView.frame.size.width, 0);
                             _bottomImageView.transform = CGAffineTransformMakeTranslation(0, 0);
                         }
                     }
                     completion:^(BOOL finished){

                         _topImageView.image = _bottomImageView.image;
                         _topImageView.transform = CGAffineTransformMakeTranslation(0, 0);

                         _isAnimating = NO;

                         if(! _doStop){
                             [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(nextOnline) object:nil];
                             [self performSelector:@selector(nextOnline) withObject:nil afterDelay:self.delay];
                         }
                     }];
}

- (void) animateSlide:(KASlideShowSlideMode) mode
{
    _isAnimating = YES;
    
    if(mode == KASlideShowSlideModeBackward){
        _bottomImageView.transform = CGAffineTransformMakeTranslation(- _bottomImageView.frame.size.width, 0);
    }else if(mode == KASlideShowSlideModeForward){
        _bottomImageView.transform = CGAffineTransformMakeTranslation(_bottomImageView.frame.size.width, 0);
    }
    
    [UIView animateWithDuration:self.transitionDuration
                     animations:^{
                         
                         if(mode == KASlideShowSlideModeBackward){
                             _topImageView.transform = CGAffineTransformMakeTranslation( _topImageView.frame.size.width, 0);
                             _bottomImageView.transform = CGAffineTransformMakeTranslation(0, 0);
                         }else if(mode == KASlideShowSlideModeForward){
                             _topImageView.transform = CGAffineTransformMakeTranslation(- _topImageView.frame.size.width, 0);
                             _bottomImageView.transform = CGAffineTransformMakeTranslation(0, 0);
                         }
                     }
                     completion:^(BOOL finished){
                         
                         _topImageView.image = _bottomImageView.image;
                         _topImageView.transform = CGAffineTransformMakeTranslation(0, 0);
                         
                         _isAnimating = NO;
                         
                         if(! _doStop){
                             [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(next) object:nil];
                             [self performSelector:@selector(next) withObject:nil afterDelay:self.delay];
                         }
                     }];
}


- (void) stop
{
    _doStop = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(next) object:nil];
}

- (KASlideShowState)state
{
    return !_doStop;
}

#pragma mark - Gesture Recognizers initializers
- (void) addGestureTap
{
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singleTapGestureRecognizer];
}

- (void) addGestureSwipe
{
    UISwipeGestureRecognizer* swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer* swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self addGestureRecognizer:swipeLeftGestureRecognizer];
    [self addGestureRecognizer:swipeRightGestureRecognizer];
}

- (void) addGestureSwipeOnline
{
    NSLog(@"%s - add swipe vao trong quang cao", __FUNCTION__);
    UISwipeGestureRecognizer* swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeOnline:)];
    swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;

    UISwipeGestureRecognizer* swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeOnline:)];
    swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;

    [self addGestureRecognizer:swipeLeftGestureRecognizer];
    [self addGestureRecognizer:swipeRightGestureRecognizer];
}

- (void) addGestureTapOnline
{
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapOnline:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singleTapGestureRecognizer];
}

#pragma mark - Gesture Recognizers handling
- (void)handleSingleTap:(id)sender
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *)sender;
    CGPoint pointTouched = [gesture locationInView:self.topImageView];
    
    if (pointTouched.x <= self.topImageView.center.x){
        [self previous];
    }else {
        [self next];
    }
}

- (void) handleSwipe:(id)sender
{
    UISwipeGestureRecognizer *gesture = (UISwipeGestureRecognizer *)sender;
    
    float oldTransitionDuration = self.transitionDuration;
    
    self.transitionDuration = kSwipeTransitionDuration;
    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        [self next];
    }
    else if (gesture.direction == UISwipeGestureRecognizerDirectionRight)
    {
        [self previous];
    }
    
    self.transitionDuration = oldTransitionDuration;
}

- (void) handleSingleTapOnline:(id)sender
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *)sender;
    CGPoint pointTouched = [gesture locationInView:self.topImageView];
    int nViTri = 0;
    CGPoint center = self.topImageView.center;
    if (pointTouched.x >= center.x - 50 && pointTouched.x <= center.x + 50 && pointTouched.y >= center.y - 50 && pointTouched.y <= center.y + 50) {
        nViTri = 4;
    }
    else {
        if (0 < pointTouched.x && pointTouched.x <= self.topImageView.center.x && 0 < pointTouched.y && pointTouched.y <= self.topImageView.center.y){
            nViTri = 0;
        }
        else if (pointTouched.x > self.topImageView.center.x && pointTouched.x < self.topImageView.frame.size.width && pointTouched.y > 0 && pointTouched.y < self.topImageView.center.y) {
            nViTri = 1;
        }
        else if (0 < pointTouched.x && pointTouched.x <= self.topImageView.center.x && pointTouched.y > self.topImageView.center.y && pointTouched.y < self.topImageView.frame.size.height) {
            nViTri = 2;
        }
        else if (pointTouched.x > self.topImageView.center.x && pointTouched.x <= self.topImageView.frame.size.width && pointTouched.y > self.topImageView.center.y && pointTouched.y < self.topImageView.frame.size.height) {
            nViTri = 3;
        }
    }
    NSLog(@"%s - tap tap", __FUNCTION__);
    if (self.delegate) {
        [self.delegate kaSlideShowTapOnImage:self.currentIndex nViTriChon:nViTri];
    }
}

- (void) handleSwipeOnline:(id)sender
{
    NSLog(@"%s - swipes", __FUNCTION__);
    UISwipeGestureRecognizer *gesture = (UISwipeGestureRecognizer *)sender;

    float oldTransitionDuration = self.transitionDuration;

    self.transitionDuration = kSwipeTransitionDuration;
    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        [self nextOnline];
    }
    else if (gesture.direction == UISwipeGestureRecognizerDirectionRight)
    {
        [self previousOnline];
    }

    self.transitionDuration = oldTransitionDuration;
}

@end

