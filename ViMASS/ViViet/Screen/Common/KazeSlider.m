//
//  KazeSlider.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 12/19/12.
//
//

#import "KazeSlider.h"
#define kAnimateTime 0.3
#define kRightMargin 0

@implementation KazeSlider
{
    UIView *_gestureView;
    UIView *_root;
    CGPoint _lastTouchPoint;
    BOOL _showing;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initKazeSlider];
    }
    return self;
}

- (void)initKazeSlider
{
    _lastTouchPoint = CGPointMake(HUGE_VAL, HUGE_VAL);
}

- (void)show
{
    if (_showing)
        return;
    
    UIWindow *wd = [[UIApplication sharedApplication].windows objectAtIndex:0];
    _root = wd.rootViewController.view;
    
    @autoreleasepool
    {
        _gestureView = [[[UIView alloc] initWithFrame:wd.rootViewController.view.bounds] autorelease];
        _gestureView.backgroundColor = [UIColor clearColor];
        _gestureView.userInteractionEnabled = YES;
        [wd.rootViewController.view addSubview:_gestureView];
        
        UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOutside)] autorelease];
        [_gestureView addGestureRecognizer:tap];
        
        UIPanGestureRecognizer *drag = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDragOutside:)] autorelease];
        [_gestureView addGestureRecognizer:drag];
    }
    CGRect r = wd.frame;
    r.origin.y = 20;
    r.size.height -= 20;
    r.size.width -= 0;
    self.frame = r;
    //wd.backgroundColor = [UIColor clearColor];
    
    [wd insertSubview:self belowSubview:wd.subviews.lastObject];
    [self enter];
    _showing = YES;
}
#pragma mark - Gesture handle
- (void)didTapOutside
{
    [self dismiss];
}

- (void)didDragOutside:(UIPanGestureRecognizer *)gesture
{
    CGPoint p = [gesture locationInView:nil];
    
    if (_lastTouchPoint.x == HUGE_VAL)
    {
        _lastTouchPoint = p;
    }
    else if (gesture.numberOfTouches == 0)
    {
        _lastTouchPoint.x = HUGE_VAL;
        
        if (p.x > _root.frame.size.width/3)
        {
            [UIView animateWithDuration:kAnimateTime animations:^
             {
                 CGRect r = _root.frame;
                 r.origin.x = _root.frame.size.width - kRightMargin;
                 _root.frame = r;
             }];
        }
        else
        {
            [UIView animateWithDuration:kAnimateTime animations:^{
                CGRect r = _root.frame;
                r.origin.x = 0;
                _root.frame = r;
            } completion:^(BOOL finished)
             {
                 [self dismiss];
             }];
        }
    }
    else
    {
        CGFloat delta = p.x - _lastTouchPoint.x;
        CGRect r = _root.frame;
        r.origin.x = r.origin.x + delta;
        if (r.origin.x < 0)
            r.origin.x = 0;
        
        if (r.origin.x > r.size.width - kRightMargin)
            r.origin.x = r.size.width - kRightMargin;
        
        if (r.origin.x != _root.frame.origin.x)
        {
            _root.frame = r;
            _lastTouchPoint = p;
        }
    }
}

- (void)enter
{
    [UIView animateWithDuration:kAnimateTime animations:^
     {
         _gestureView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
         
         CGRect r = _root.frame;
         r.origin.x += r.size.width - kRightMargin;
         _root.frame = r;
         
     } completion:^(BOOL finished)
     {
     }];
}

- (void)dismiss
{
    [self will_dismiss];
    [UIView animateWithDuration:kAnimateTime animations:^
     {
         CGRect r = _root.frame;
         r.origin.x = 0;
         _root.frame = r;
         
         _gestureView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
         
     } completion:^(BOOL finished)
     {
         [self didDismiss];
         [_gestureView removeFromSuperview];
         _gestureView = nil;
         [self removeFromSuperview];
     }];
    _showing = NO;
}
//
// Subclass override to capture the event
//
- (void)will_dismiss
{
    
}
//
// Subclass override to capture the event
//
- (void)didDismiss
{
    
}
@end
