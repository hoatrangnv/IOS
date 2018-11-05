//
//  KazeSliderEx.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 1/22/13.
//
//

#import "KazeSliderEx.h"

@implementation KazeSliderEx
{
    UIView  *_topView, *_rightView, *_bottomView, *_leftView;
    UIPanGestureRecognizer *_pan;
    UIViewController *_viewController;
}

+ (KazeSliderEx *)sliderWithViewTop:(UIView *)top right:(UIView *)right bottom:(UIView *)bottom left:(UIView *)left
andViewController:(UIViewController *)viewController
{
    KazeSliderEx * slider = [[KazeSliderEx alloc] init];
    slider->_viewController = viewController;
    slider.topView = top;
    slider.rightView = right;
    slider.bottomView = bottom;
    slider.leftView = left;
    
    
    return [slider autorelease];
}

- (void)initGesture
{
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDrag:)];
}

- (void)didDrag:(UIGestureRecognizer *) gesture
{
    NSLog(@"shit");
}

- (void)addView:(UIView *)v
{
    UIView * rootView = _viewController.navigationController.view.window.rootViewController.view;
    [rootView.superview insertSubview:v belowSubview:rootView];
}
- (void)setTopView:(UIView *)topView
{
    if (_topView != topView)
    {
        [_topView release];
        _topView = [topView retain];
        [_topView addGestureRecognizer:_pan];
        [self addView:topView];
    }
}
- (void)setRightView:(UIView *)rightView
{
    if (_rightView != rightView)
    {
        [_rightView release];
        _rightView = [rightView retain];
        [_rightView addGestureRecognizer:_pan];
        [self addView:rightView];
    }
}
- (void)setBottomView:(UIView *)bottomView
{
    if (_bottomView != bottomView)
    {
        [_bottomView release];
        _bottomView = [bottomView retain];
        [self addView:bottomView];
        [_bottomView addGestureRecognizer:_pan];
    }
}
- (void)setleftView:(UIView *)leftView
{
    if (_leftView != leftView)
    {
        [_leftView release];
        _leftView = [leftView retain];
        [self addView:leftView];
        [_leftView addGestureRecognizer:_pan];
    }
}
- (id)init
{
    if (self = [super init])
    {
        [self initGesture];
    }
    return self;
}

- (void)dealloc
{
    self.topView = nil;
    self.rightView = nil;
    self.bottomView = nil;
    self.leftView = nil;
    [_pan release];
    [super dealloc];
}

@synthesize topView = _topView;
@synthesize rightView = _rightView;
@synthesize bottomView = _bottomView;
@synthesize leftView = _leftView;

@end
