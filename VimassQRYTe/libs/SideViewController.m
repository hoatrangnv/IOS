//
//  SideViewController.m
//  test_web_reader
//
//  Created by Ngo Ba Thuong on 11/22/13.
//  Copyright (c) 2013 ViMASS. All rights reserved.
//

#import "SideViewController.h"
#define SideViewController_Outside 0.f
#define SideViewController_Inside 1.f

//
// time = 0 la trang view o ngoai le. 1 la trang thai view hoan toan visible
//
typedef void (^SideViewControllerStateFunction)(CGFloat time, SideViewController *ctrl, int side);


@implementation SideViewController
{
    UIView *v_left, *v_right, *v_main;
    int opening_side;
    SideViewControllerStateFunction fn ;
}

- (void)setLeft:(UIView *)left
{
    if (v_left != left)
    {
        [v_left removeFromSuperview];
        [v_left release];
        
        v_left = [left retain];
    }
}

- (void)setRight:(UIView *)right
{
    if (v_right != right)
    {
        [v_right removeFromSuperview];
        [v_right release];
        v_right = [right retain];
    }
}

- (BOOL)isOpen
{
    return opening_side != 0;
}

- (void)open_side:(int)side animate:(BOOL)animate;
{
    [self open_side:side animate:animate callback:nil];
}

- (void)open_side:(int)side animate:(BOOL)animate callback:(void (^)(SideViewController *controller))callback;
{
    opening_side = side;
    if (animate == NO)
    {
        fn (SideViewController_Inside, self, side);
        if (callback)
            callback (self);
    }
    else
    {
        fn (SideViewController_Outside, self, side);
        [UIView animateWithDuration:0.35
                         animations:^
        {
            fn (SideViewController_Inside, self, side);
        }
        completion:^(BOOL finished)
        {
            if (callback)
                callback (self);
        }];
    }
}

- (void)close_animate:(BOOL)animate;
{
    [self close_animate:animate callback:nil];
}

- (void)close_animate:(BOOL)animate callback:(void (^)(SideViewController *controller))callback;
{
    if (opening_side == 0)
        return;
    opening_side = 0;
    
    if (animate == NO)
    {
        fn (SideViewController_Outside, self, opening_side);
        if (callback)
            callback (self);
    }
    else
    {
        fn (SideViewController_Inside, self, opening_side);
        [UIView animateWithDuration:0.35
                         animations:^
         {
             fn (SideViewController_Outside, self, opening_side);
         }
                         completion:^(BOOL finished)
         {
             if (callback)
                 callback (self);
         }];
    }
}

- (void)fn_default:(CGFloat)time side:(int)side
{
    // em chữa lại để Side:RIGHT nữa
    UIView *panel = nil;
    int vector = 0;
    switch (side)
    {
        case -1:
        {
            panel = v_left;
            vector = -1;
            break;
        }
        case 1:
        {
            panel = v_right;
            vector = 1;
            break;
        }
        case 0:
        {
            // 1 trong 2 cái != nil
            if (v_left != nil)
            {
                panel = v_left;
                vector = -1;
            }else if(v_right != nil)
            {
                panel = v_right;
                vector = 1;
            }
            break;
        }
        default:
            break;
    }
    
//    UIView *panel = side > 0 ? v_right : v_left;
    if (panel == nil)
        return;
    
    UIView *root = v_main.superview;
    
    CGRect r;
    if (panel.superview == nil)
    {
        [v_main.superview addSubview:panel];
    }
    if (time == SideViewController_Outside)
    {
        if (panel.superview == v_main.superview)
        {
            [panel.superview bringSubviewToFront:panel];
        }
    }
    else if (time == SideViewController_Inside)
    {
        if (panel.superview == v_main.superview)
        {
            [panel.superview bringSubviewToFront:panel];
        }
    }
    
    if (time < 0)
        time = 0.f;
    else if (time > 1.f)
        time = 1.f;
    
    r = v_main.frame;
    r.origin.x = time * roundf(0.25 * r.size.width) * (vector > 0 ? -1.f : 1.f);//(side > 0 ? -1.f : 1.f);
    v_main.frame = r;
    
    r = v_main.frame;
    r.origin.x = r.size.width * (vector > 0 ? 1.f - time : time - 1.f);//(side > 0 ? 1.f - time : time - 1.f);
    r = [root convertRect:r fromView:v_main.superview];
    r = [root convertRect:r toView:panel.superview];
    panel.frame = r;
}

- (id)init
{
    if (self = [super init])
    {
        fn = ^(CGFloat time, SideViewController *ctrl, int side)
        {
            return [ctrl fn_default:time side:side];
        };
        fn = [fn copy];
    }
    return self;
}

- (void)dealloc
{
    [fn release];
    if (v_left.superview != nil)
    {
        [v_left removeFromSuperview];
    }
    self.left = nil;
    
    if (v_right.superview != nil)
    {
        [v_right removeFromSuperview];
    }
    self.right = nil;
    
    self.main = nil;
    
    [super dealloc];
}

@synthesize left = v_left;
@synthesize right = v_right;
@synthesize main = v_main;

@end


#pragma mark - SideViewContainer

@interface SideViewContainer ()
@property (nonatomic, retain) SideViewController *side_controller;
@end
@implementation SideViewContainer
{
}

-(void)setMain:(UIView *)main side:(Side)side
{
    self.side_controller.main = main;
    if (main != nil)
    {
        if (side == SideLeft) {
            self.side_controller.left = self;
        }else
        {
            self.side_controller.right = self;
        }
    }
    else
    {
        if (side == SideLeft) {
            self.side_controller.left = nil;
        }else
        {
            self.side_controller.right = nil;
        }
    }
    _side = side;
}

- (void)setMain:(UIView *)main
{
    self.side_controller.main = main;
    if (main != nil)
    {
        self.side_controller.left = self;
        _side = SideLeft;
    }
    else
    {
        self.side_controller.left = nil;
        _side = SideLeft;
    }
}

- (void)open_animate:(BOOL)animate callback:(void (^)(void))callback
{
    __block void (^callback1)(void) = nil;
    if (callback)
        callback1 = [callback copy];
    
    [self.side_controller open_side:_side animate:animate callback:^(SideViewController *controller)
    {
        if (callback1)
        {
            callback1();
            [callback1 release];
        }
    }];
}

- (void)close_animate:(BOOL)animate callback:(void (^)())callback
{
    __block void (^callback1)(void) = nil;
    if (callback)
        callback1 = [callback copy];
    
    [self.side_controller close_animate:animate callback:^(SideViewController *controller)
    {
        if (callback1)
        {
            callback1();
            [callback1 release];
        }
    }];
}

- (void)init_SideViewContainer
{
    self.side_controller = [[[SideViewController alloc] init] autorelease];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self init_SideViewContainer];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self init_SideViewContainer];
    }
    return self;
}

- (void)dealloc
{
    self.side_controller = nil;
    [super dealloc];
}

@synthesize side_controller;

@end
