//
//  Drawer.m
//  testsliderex
//
//  Created by Ngo Ba Thuong on 3/11/13.
//  Copyright (c) 2013 Ngo Ba Thuong. All rights reserved.
//

#import "Drawer.h"
#import "MarginGestureRecognizer.h"

#define kSHADOWN_LEFT_TAG 755
#define kSHADOWN_RIGHT_TAG 729

#define ANIMATE_TIME 0.35
#define SHOWING_SIDE_LEFT -1
#define SHOWING_SIDE_RIGHT 1

#define kMARGIN_DEFAULT 0.0

@implementation Drawer
{
    UIView *_content, *_left, *_right, *_root;
    UIView *_root_overlay;
    id<DrawerDelegate> _delegate;
    
    
    bool initialized;
    
    CGPoint previous;
    int showing_side;
    int vector;
    
    bool closed;
    
    MarginGestureRecognizer *g_left, *g_right;
    BOOL waitAnimated;
}

-(void)layoutSubviews
{
    // Chung : fix origin y
    
    // height of Status bar
    CGFloat dy = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    CGRect r = _left.frame;
    
    r.size.height = _root.bounds.size.height;
    r.size.width  = _root.bounds.size.width;
    if ([_root isKindOfClass:[UIWindow class]])
    {
        r.origin.y = dy; // height of satus bar
        r.size.height = r.size.height - dy;
    }
    _left.frame = r;
    
    r = _right.frame;
    r.size.height = _root.bounds.size.height;
    r.size.width  = _root.bounds.size.width;
    if ([_root isKindOfClass:[UIWindow class]])
    {
        r.origin.y = dy; // height of satus bar
        r.size.height =r.size.height - dy;
    }
    _right.frame = r;
}

-(void)didMoveToWindow
{
    
    [self initialize];
}

-(void)initialize
{
    if (initialized)
        return;
    
    _enableTouch = TRUE;
    
    bool no_content = false;
    
    closed = true;
    
    initialized = true;
    if (_content == nil)
    {
        no_content = true;
        _content = self.window.rootViewController.view;
        _root = _content.superview;
    }
    else
    {
        _root = self;
    }
    
    self.left = _left;
    self.right = _right;
    
    /*
     *  touch RealTimeView area => disable
     */
//    _gesture = [[[MarginGestureRecognizer alloc] initWithTarget:self
//                                                         action:@selector(onDrag:)
//                                                        andView:_content] autorelease];
//    
//    MarginGestureRecognizer_Side side = 0;
//    if (_left != nil)
//    {
//        side = side | MarginGestureRecognizer_Side_Left;
//    }
//    if (_right != nil)
//    {
//        side = side | MarginGestureRecognizer_Side_Right;
//    }
//    
//    _gesture.side = side;
//    _gesture.fullscreen = TRUE;
//    _gesture.side= MarginGestureRecognizer_Side_Full;

    // When the content is the view of rootViewController, if we add the gesture to that view
    // we still can slide in other viewcontroller. So, in that case we have to add the gesture
    // to view of current viewcontroller
//    if (no_content)
//    {
//        UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
//        UIViewController *vc = [nav.viewControllers objectAtIndex:nav.viewControllers.count - 1];
//        [vc.view addGestureRecognizer:_gesture];
//    }
//    else
//    {
//        [_content addGestureRecognizer:_gesture];
//    }
//
//    _root_overlay = [[UIView alloc] initWithFrame:_content.bounds];
//    _root_overlay.userInteractionEnabled = YES;
//    _root_overlay.hidden = YES;
//    [_content addSubview:_root_overlay];
//    
//    UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectOverlay)] autorelease];
//    [_root_overlay addGestureRecognizer:tap];

//    MarginGestureRecognizer *g = [[[MarginGestureRecognizer alloc] initWithTarget:self action:@selector(onDrag:) andView:_root_overlay] autorelease];
//    g.side = side;
//    g.fullscreen = TRUE;
////    g.side= MarginGestureRecognizer_Side_Full;
//    g.margin = 320;
//    [_root_overlay addGestureRecognizer:g];

    _content.clipsToBounds = NO;
//    self->_gesture.fullscreen = NO;
    // Chung NV
    /*
     * fix bug : more shadown.
     */
    [self addShadown];
    
//    if (_left)
//    {
//        MarginGestureRecognizer *g = [[[MarginGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAtSide:) andView:_left] autorelease];
//        g_left = g;
//        
//        g.side = MarginGestureRecognizer_Side_Right;
////        g.fullscreen = TRUE;
//        g.margin = 50;
//        [_left addGestureRecognizer:g];
//    }
    if (_right)
    {
        MarginGestureRecognizer *g = [[[MarginGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAtSide:) andView:_right] autorelease];
        g.side = MarginGestureRecognizer_Side_Left;
        //        g.fullscreen = TRUE;
        g.margin = 320;
        [_right addGestureRecognizer:g];
        
    }
}

-(void)addShadown
{
    if (_content == nil)
        return;

    UIImageView *shadown = nil;
    UIView * v = [_content viewWithTag:kSHADOWN_LEFT_TAG];
    if (v != nil && [v isKindOfClass:[UIImageView class]])
        shadown = (UIImageView*)v;
    else
    {
        shadown = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadown_left"]];
        [_content addSubview:shadown];        
        shadown.tag = kSHADOWN_LEFT_TAG;
        shadown.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        shadown.hidden = NO;
        [shadown release];
    }
    CGRect r = _content.bounds;
    r.origin.x -= 40;
    r.size.width = 40;
    shadown.frame = r;
    shadown.alpha = 0.2;
    
    
    v = [_content viewWithTag:kSHADOWN_RIGHT_TAG];
    if (v != nil && [v isKindOfClass:[UIImageView class]])
        shadown = (UIImageView*)v;
    else
    {
        shadown = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadown_right"]];
        [_content addSubview:shadown];
        shadown.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        shadown.tag = kSHADOWN_RIGHT_TAG;
        shadown.hidden = NO;
        [shadown release];
    }
    r = _content.bounds;
    r.origin.x = r.size.width;
    r.size.width = 40;
    shadown.frame = r;
    shadown.alpha = 0.2;
}

-(void)didSelectOverlay
{
    [self close:nil];
}

- (void)refresh
{
    NSLog(@"\n\n\n\n\n\nFresh :D");
    return;
    if (_left.hidden == NO)
    {
        [self openLeft];
    }
    else if (_right.hidden == NO)
    {
//        [self openRight];
//        _content.hidden = NO;
//        CGRect r = _content.frame;
//        r.origin.x -= r.size.width;
//        _content.frame = r;
    }
    else
        [self close:nil];
}

-(void)close:(void (^)())finished
{
    if (waitAnimated)
        return;
    waitAnimated = YES;
    _content.hidden = NO;
    
    CGFloat t = fabs(_content.frame.origin.x) / (self.frame.size.width - kMARGIN_DEFAULT);
    
    CGFloat animate_time = ANIMATE_TIME * t;
    
    [UIView animateWithDuration:animate_time animations:^
     {
         [self state_at_offset:0 andSide:showing_side];
         
     } completion:^(BOOL f)
     {
         _root_overlay.hidden = YES;
//         _gesture.margin = 320;
         _left.hidden = YES;
         _right.hidden = YES;
         
         if ([self.delegate respondsToSelector:@selector(drawer_did_close:)])
         {
             [self.delegate drawer_did_close:self];
         }
         if (finished)
            finished();
         waitAnimated = NO;
     }];
}

-(void)open:(BOOL)left_right
{
    NSLog(@"%s >> %s line: %d >> Mở thanh menu trái ",__FILE__,__FUNCTION__ ,__LINE__);
    if ((left_right == SHOWING_SIDE_RIGHT && _left == nil) || (left_right == SHOWING_SIDE_LEFT && _right == nil))
        return;
    
    if (waitAnimated)
        return;
    waitAnimated = YES;
//    NSLog(@"left_right: %@", left_right ? @"YES" : @"NO");
    showing_side = left_right;
    
    CGFloat t = fabs(_content.frame.origin.x) / (self.frame.size.width - kMARGIN_DEFAULT);
//    NSLog(@"t = %f", t);
    CGFloat animate_time = ANIMATE_TIME * (1 - t);
    
    [UIView animateWithDuration:animate_time animations:^
     {
         [self state_at_offset:1 andSide:showing_side];
         
     } completion:^(BOOL finished)
     {
         _content.hidden = YES;
         _root_overlay.hidden = NO;
//         _gesture.margin = kMARGIN_DEFAULT;
         waitAnimated = NO;
     }];
}
-(void)openLeft
{
    [self open: 1];
}
-(void)openRight
{
    [self open: -1];
}

#pragma mark - Touch Action
-(void) onTouchBegan:(CGPoint) pBegin
{
    previous = pBegin;
    showing_side = 0;
    return;
}

-(void) onTouchMoved:(CGPoint) pMoved
{
    CGFloat dx = pMoved.x - previous.x;
    previous = pMoved;
    
    if (dx > 0)
        vector = 1;

    else if (dx < 0)
        vector = -1;
    
    if (vector > 0 && _left == nil && _right.hidden == YES)
    {
        //Not set left => disable
        return;
    }
    if (vector < 0 && _right == nil && _left.hidden == YES)
    {
        //Not set right => disable
        return;
    }
    
    if (_content.hidden == YES)
    {
        if (_right)
        showing_side = _right.hidden == NO ? SHOWING_SIDE_LEFT : SHOWING_SIDE_RIGHT;
        else if (_left)
            showing_side = _left.hidden == NO ? SHOWING_SIDE_RIGHT : SHOWING_SIDE_LEFT;
        
        _content.hidden = NO;
        
        CGRect r = _content.frame;
        
        r.origin.x = showing_side == SHOWING_SIDE_LEFT ? -r.size.width : r.size.width;
        _content.frame = r;
    }
    
    if (showing_side == 0)
        showing_side = _content.frame.origin.x + dx > 0 ? SHOWING_SIDE_RIGHT : SHOWING_SIDE_LEFT;

    else
    {
        if ((showing_side == SHOWING_SIDE_RIGHT && _content.frame.origin.x + dx < 0)
            || (showing_side == SHOWING_SIDE_LEFT && _content.frame.origin.x + dx > 0))
            dx = -_content.frame.origin.x;
        
    }
    
    CGFloat t = fabs(_content.frame.origin.x + dx) / (self.frame.size.width - kMARGIN_DEFAULT);
    [self state_at_offset:t andSide:showing_side];
}

-(void) onTouchEnded:(CGPoint) pEnded
{
    if (showing_side * vector < 0)
        [self close:nil];
    else if (showing_side * vector > 0)
        [self open:showing_side];
}

#pragma mark - SEL(s)
-(void)onDrag:(UIGestureRecognizer *)gesture
{
    if (_enableTouch == NO)
        return;
    
    if (gesture.state == UIGestureRecognizerStateBegan)
        [self onTouchBegan:[gesture locationInView:_root]];
    
    if (gesture.state == UIGestureRecognizerStateChanged)
        [self onTouchMoved:[gesture locationInView:_root]];
    
    if (gesture.state == UIGestureRecognizerStateEnded)
        [self onTouchEnded:CGPointZero];
}
/*
 * Action for click sides : _left,_right
 */
-(void)panGestureAtSide:(UIPanGestureRecognizer *) panGes
{
    if (_enableTouch == NO)
        return;
    
    if (panGes.state == UIGestureRecognizerStateBegan)
        [self onTouchBegan:[panGes locationInView:_root]];
    
    if (panGes.state == UIGestureRecognizerStateChanged)
        [self onTouchMoved:[panGes locationInView:_root]];
    
    if (panGes.state == UIGestureRecognizerStateEnded)
        [self onTouchEnded:CGPointZero];
}

#pragma mark -
-(void)state_at_offset:(CGFloat) t andSide:(int)dir
{
    if (t > 1)
        t = 1;
    // Before sliding
    if (showing_side < 0 && (_left.hidden == NO || _right.hidden == YES))
    {
        _left.hidden = YES;
        _right.hidden = NO;
    }
    else if (showing_side > 0 && (_right.hidden == NO || _left.hidden == YES))
    {
        _right.hidden = YES;
        _left.hidden = NO;
    }
    if (_root_overlay.hidden == YES)
    {
        _root_overlay.hidden = NO;
        _root_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    }
    
    _root_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:t*0.5];
    
    CGFloat W = self.frame.size.width;
    CGRect r = _content.frame;
    CGFloat x = (CGFloat)dir * (W - kMARGIN_DEFAULT) * t;
//    NSLog(@"x = %f. W = %f", x, W);
    x = floorf(x);
    if (_right != nil && x > W-kMARGIN_DEFAULT)
        x = W - kMARGIN_DEFAULT;
    if (_left != nil && x < kMARGIN_DEFAULT - W)
        x = kMARGIN_DEFAULT - W;
    r.origin.x = x;
    
    _content.frame = r;
//    NSLog(@"dir = %d", dir);
//    NSLog(@"r = %@", NSStringFromCGRect(r));
    if (dir < 0)
    {
        CGRect r = _content.frame;
        r.size.width -= kMARGIN_DEFAULT;
        r.origin.x = floorf((kMARGIN_DEFAULT/2 - W/2)*t + W/2 + kMARGIN_DEFAULT/2);
        
        // Chung
        r.origin.y = _right.frame.origin.y;
        r.size.height = _right.frame.size.height;
        _right.frame = r;
    }
    else if (dir > 0)
    {
        CGRect r = _content.frame;
        r.size.width -= kMARGIN_DEFAULT;
        r.origin.x = floorf ((W - kMARGIN_DEFAULT)/2*t - W/2 + kMARGIN_DEFAULT/2);
        
        // Chung
        r.origin.y = _left.frame.origin.y;
        r.size.height = _left.frame.size.height;
        _left.frame = r;
    }
}

-(void)onShowingSide:(int)dir
{
    printf("showing side: %d\n", dir);
}

-(void)setLeft:(UIView *)left
{
    if (left)
    {
        MarginGestureRecognizer *g = [[[MarginGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAtSide:) andView:left] autorelease];
        g_left = g;
        
        g.side = MarginGestureRecognizer_Side_Right;
        g.margin = 320;
        [left addGestureRecognizer:g];
    }
    
    if (self.static_left == YES)
    {
        if (_left != left)
        {
            [_left release];
            _left = [left retain];
        }
        if (_left.superview == nil)
        {
            [_root addSubview:_left];
            [_root bringSubviewToFront:_content];
        }
        return;
    }
    
    if (_left != left)
    {
        [_left removeFromSuperview];
        [_left release];
        
        _left = [left retain];
        _left.hidden = YES;
    }
    
    if (initialized)
    {
        [_root addSubview:_left];
        [_root bringSubviewToFront:_content];
    }
}
-(void)setRight:(UIView *)right
{
    if (_right != right)
    {
        [_right removeFromSuperview];
        [_right release];
    }
    
    _right = [right retain];
    _right.hidden = YES;
    if (initialized)
    {
        [_root addSubview:_right];
        [_root bringSubviewToFront:_content];
    }
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
    }
    return self;
}

-(void)dealloc
{
    if (_static_left == NO)
    {
        [_left removeGestureRecognizer:g_left];
        [_left removeFromSuperview];
    }
    [_left release];
    
    [_right removeFromSuperview];
    [_right release];
    
    [super dealloc];
}

@synthesize content     = _content;
@synthesize left        = _left;
@synthesize right       = _right;
@synthesize delegate    = _delegate;
@synthesize enableTouch = _enableTouch;

@end
