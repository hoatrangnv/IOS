    //
    //  ExScrollSlide.m
    //  Test
    //
    //  Created by Chung NV on 2/11/13.
    //  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
    //

#import "ScrollingMenu.h"
#import "BPButton.h"

#define kSUB_SCALE          100 / 100
#define kICON_IMAGE         @""
#define kICON_WIDTH         15
#define kICON_HEIGHT        5
#define kDEFAULT_TEXT_COLOR [UIColor whiteColor]
#define kDEFAULT_FONT       [UIFont boldSystemFontOfSize:14]

#define kTAG_BUTTON_STRING 123456

@implementation ScrollingMenu
#pragma mark - Init
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
        [self _init];

    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
        [self _init];
    
    return self;
}
-(id)init
{
    if (self = [super init])
        [self _init];        

    return self;
}

-(void) _init
{
    _padding            = 0;
    _textColor          = kDEFAULT_TEXT_COLOR;
    _textColorSelected  = [UIColor yellowColor];
    isFirstFill         = TRUE;
    _iconImage          = [UIImage imageNamed:@"bg1.png"];
    self->views               = [[NSMutableArray alloc] init];
    self.scrollEnabled  = FALSE;
    self.showsHorizontalScrollIndicator = FALSE;
    self.showsVerticalScrollIndicator = FALSE;

}
#pragma mark - Override Method
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self widthHeightOfItem];
}
#pragma mark - Public Method
/*
 * 1. Remove all old Items
 * 2. Add items in Array into scroller
 */
-(void)fillItems:(NSArray *)_items
{
    if (!_items || _items.count == 0)
        return;
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[UIButton class]]) {
            [v removeFromSuperview];
        }
    }
    if (!views)
        self->views = [[NSMutableArray alloc] init];
    [views removeAllObjects];
    for (id item in _items) {
        [self insertItem:item atIndex:10000];
    }
    return;
}

-(UIView*) getItemAtIndex:(int) _index
{
    if (!views) {
        self->views = [[NSMutableArray alloc] init];
    }
    if (views.count==0) {
        return nil;
    }
    if (_index >= views.count)
        return nil;
    if (_index < 0)
        return nil;
    return [views objectAtIndex:_index];
}


-(void)setSelectedIndex:(int)_index animated:(BOOL)animated
{
    if (_index > views.count) {
        _index = (int)views.count;
    }
    _currentIndex = _index;
    _currentItem = [self getItemAtIndex:_index];
    [self setDefalutTextColor];
//    [(UIButton*)_currentItem setTitleColor:_textColorSelected forState:UIControlStateNormal];
    [(UIButton*)_currentItem setSelected:TRUE];
    [self scrollOffSetToItemAtIndex:_index animated:animated];
    
        //icon
    CGPoint iconCenter = imgViewIcon.center;
    iconCenter.x = _currentItem.center.x;
    imgViewIcon.center = iconCenter;
    [self bringSubviewToFront:imgViewIcon];
}

-(void)insertItem:(id)_item 
          atIndex:(int)_atIndex
{
    if (!views) {
        self->views = [[NSMutableArray alloc] init];
    }
        // calc again : paddingTop,lblHeight
    [self widthHeightOfItem];
    
    if (_atIndex > views.count)
        _atIndex = (int)views.count;
    
    UIButton *button = nil;
    if ([_item isKindOfClass:[NSString class]])
        button = [UIButton createDefaultButton:_item];
    
    else if([_item isKindOfClass:[UIButton class]])
        button = (UIButton*)_item;
    
    else
        return;
        //add Action for BUTTON
    [button addTarget:self 
               action:@selector(buttonTouchUpInside:) 
     forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *oldView = [self getItemAtIndex:_atIndex];
    
    CGPoint oldPoint = oldView.frame.origin;
    CGSize contenSize = self.contentSize;
    
    if (oldView == nil)  // if oldView NOT exist ==> add to LAST
        oldPoint = CGPointMake(contenSize.width + _padding, paddingTop);
    
    for (int i = _atIndex; i< views.count; i++) {
        UIView * bt = [self getItemAtIndex:i];
        if (!bt) {
            continue;
        }
        CGRect f =bt.frame;
        f.origin.x += button.frame.size.width + _padding;
        bt.frame = f;
    }
    
    CGRect rect = button.frame;
    
    rect.origin = oldPoint;
  
    contenSize.width += rect.size.width + _padding;
    rect.size.height = lblHeight;
        
    
    [button setFrame:rect];
    
    [self addSubview:button];
    if (_atIndex > 0 && _atIndex < views.count) {
        [views insertObject:button atIndex:_atIndex];    
    }else {
        [views addObject:button];
    }
    self.contentSize = contenSize;
    [self addIconView];
}
-(void)removeItemAtIndex:(NSUInteger)_atIndex
{
    UIView *viewRemove = [self getItemAtIndex:(int)_atIndex];
    if (!viewRemove) {
        return;
    }
    
    float dx = viewRemove.frame.size.width + _padding;
    
    for (int i=(int)_atIndex+1; i< views.count; i++) {
        UIView *nextView = [self getItemAtIndex:i];
        if (!nextView) {
            continue;
        }
        CGRect nextFrame = nextView.frame;
        nextFrame.origin.x -=dx;
        nextView.frame = nextFrame;    }
    
    [views removeObject:viewRemove];
    [viewRemove removeFromSuperview];
    
    
    CGSize size = self.contentSize;
    size.width -= dx;
    self.contentSize = size;
}
-(void)removeItemFromIndex:(NSUInteger)_fromIndex toIndex:(NSUInteger)_toIndex
{
    if (_fromIndex > _toIndex) {
        return;
    }
    
    for (int i=(int)_toIndex; i>=_fromIndex; i--) {
        [self removeItemAtIndex:i];
    }
    
}
-(void)removeItemToIndex:(NSUInteger)_toIndex
{
    [self removeItemFromIndex:0 toIndex:_toIndex];
}
-(void)removeItemFromIndex:(NSUInteger)_fromIndex
{
    [self removeItemFromIndex:_fromIndex toIndex:views.count];
}

-(void)setFont:(UIFont *)font
{
    if (!font) {
        return;
    }
    for (UIButton *v in views) {
        v.titleLabel.font = font;
    }
}
-(void)setTextColor:(UIColor *)textColor
{
    if (!textColor) {
        return;
    }
    self.textColor = textColor;
    for (UIButton *bt in views) {
        bt.titleLabel.textColor = _textColor; 
    }
}
#pragma mark - SEL(s)
/*
 * selector of UIButton touch up inside
 */
-(void) buttonTouchUpInside:(UIButton*) sender
{
        //
    _currentItem  = sender;
    _currentIndex = (int)[views indexOfObject:sender];

        //animate icon
//    [self animateIconToButton:sender];
    if ([delegate_ respondsToSelector:@selector(exScrollViewSelectedChanged:)]) {
        [delegate_ exScrollViewSelectedChanged:self];
    }
    
        //scroll to center frame
        //    double distanceTop = sender.frame.origin.x - 
    
    [self setSelectedIndex:_currentIndex animated:TRUE];
}

#pragma mark - PRIVATE METHOD
-(void) scrollOffSetToItemAtIndex:(NSUInteger) _index animated:(BOOL) animated
{
    if (self.contentSize.width <= self.frame.size.width) {
        return;
    }
    
    if (_index > views.count) {
        _index = views.count;
    }
    UIView *item = [self getItemAtIndex:(int)_index];
    
    float offSetX = 0.0;
    
    float selfWidth  = self.frame.size.width;
    
    float  xDistanceToTop = item.center.x;    // distance from sender to TOP
    
    CGPoint contentOffset;
    

    if (xDistanceToTop < selfWidth/2) 
        offSetX = 0;
    
    else if(xDistanceToTop > self.contentSize.width - selfWidth/2)
        offSetX = self.contentSize.width - selfWidth; 
    
    else 
        offSetX = item.center.x - selfWidth/2;
    
    contentOffset = CGPointMake(offSetX,self.contentOffset.y);
    
    
    [self setContentOffset:contentOffset animated:animated];
}
-(UIView*) createItemView:(NSString*) _title
{
    UIButton *bt = [[UIButton alloc] init];
    [bt setTitle:_title forState:UIControlStateNormal];
    [bt sizeToFit];
    
    [[bt titleLabel] setTextColor:_textColor];
    [[bt titleLabel] setFont:kDEFAULT_FONT];
    [bt addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    return bt;
}
-(void) widthHeightOfItem
{
    lblHeight   = roundf(self.frame.size.height * kSUB_SCALE);
    paddingTop  = roundf(self.frame.size.height - lblHeight)/2;
}

-(void) addIconView
{
    return;
    if (!imgViewIcon) {
        imgViewIcon = [[UIImageView alloc] init];
        imgViewIcon.image = [UIImage imageNamed:kICON_IMAGE];
        imgViewIcon.frame = CGRectMake(0, 
                                       self.frame.size.height - kICON_HEIGHT, 
                                       kICON_WIDTH, 
                                       kICON_HEIGHT);
        
        imgViewIcon.backgroundColor = [UIColor whiteColor];
    }
    if (![self.subviews containsObject:imgViewIcon])
        [self addSubview:imgViewIcon];
    if (views && views.count > 0) {
        UIView *firstView = [self getItemAtIndex:0];
        CGPoint iconCenter = imgViewIcon.center;
        iconCenter.x = firstView.center.x;
        imgViewIcon.center = iconCenter;
    }
    
}
/*
 * set text label color to default color
 */
-(void) setDefalutTextColor
{
    for (UIView *v in [self subviews])
        if ([v isKindOfClass:[UIButton class]]){
            [((UIButton*)v) titleLabel].textColor = _textColor;
            [((UIButton*)v) setSelected:NO];
        }
            
    
}
#pragma mark - Dealloc & @synthsize
-(void)dealloc
{
    if (imgViewIcon)
        [imgViewIcon release];
        
    if (_textColorSelected)
        [_textColorSelected release];
        
    if (_textColor)
        [_textColor release];

    if (_font)
        [_font release];
    
    if (_iconImage)
        [_iconImage release];
    
    if (views)
        [views release];
    
    [super dealloc];
}

@synthesize delegate          = delegate_;
@synthesize iconImage         = _iconImage;
@synthesize padding           = _padding;
@synthesize textColor         = _textColor;
@synthesize textColorSelected = _textColorSelected;

@synthesize currentItem       = _currentItem;
@synthesize currentIndex      = _currentIndex;
@synthesize font              = _font;

//@synthesize views;
@end


@implementation UIButton(ScollerMenu)

+(UIButton *)createDefaultButton:(NSString *)title
{
    BPButton *bt = nil;
    bt = [[BPButton alloc] init];
    [bt setBackgroundImage:[UIImage imageNamed:@"tab_bg_not_selected"] forState:UIControlStateNormal];
    [bt setBackgroundImage:[UIImage imageNamed:@"tab_bg_selected"] forState:UIControlStateSelected];
    [bt setTitle:title forState:UIControlStateNormal];
    [bt sizeToFit];
    CGRect rect = bt.frame;
    rect.size.width += 14;
    bt.frame = rect;
    
    [[bt titleLabel] setTextColor:kDEFAULT_TEXT_COLOR];
    [[bt titleLabel] setFont:kDEFAULT_FONT];
    return [bt autorelease];
}

@end
