//
//  DialogSkeletonView.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 8/8/13.
//
//

#import "DialogSkeletonView.h"
#import "UIView+EntranceElastic.h"
#import "UIView+Animation.h"

@implementation DialogSkeletonView
{
    UIButton *bg_btn;
}

- (void)cancel
{
    [bg_btn removeFromSuperview];
    
    [self zoomOutDuration:0.35 spawning_point:spawning_point end_point:end_point oncomplete:^
    {
        [self dialogWillDisappear];

        [self removeFromSuperview];

        [self dialogDidDisappear];
    }];
}

- (void)dialogWillDisappear;
{
}
- (void)dialogDidDisappear;
{
    
}

- (void)touch_background
{
    [self cancel];
}

- (void)showin:(UIView *)host;
{
    if (isnan(spawning_point.x) || isnan(spawning_point.y))
    {
        spawning_point = self.center;
    }
    
    if (isnan(end_point.x) || isnan(end_point.y))
    {
        end_point = self.center;
    }
    
    UIWindow* wd = host.window;
    
    bg_btn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    bg_btn.frame = wd.bounds;
    
    [bg_btn addTarget:self action:@selector(touch_background) forControlEvents:UIControlEventTouchUpInside];
    
    [wd addSubview:bg_btn];
    [wd addSubview:self];
    
    [self zoomInDuration:0.35 spawning_point:spawning_point end_point:end_point];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    [super initWithCoder:aDecoder];
    NSLog(@"hihi");
    spawning_point = CGPointMake(NAN, NAN);
    end_point = CGPointMake(NAN, NAN);
    
    return self;
}

- (void)dealloc
{
    NSLog(@"\nDialog deallocated\n");
    [bg_btn release];
    [super dealloc];
}

@end
