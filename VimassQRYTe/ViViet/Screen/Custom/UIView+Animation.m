//
//  UIView+Animation.m
//  UIAnimationSamples
//
//  Created by Ray Wenderlich on 11/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "UIView+Animation.h"

@implementation UIView (Animation)

- (void) moveTo:(CGPoint)destination duration:(float)secs option:(UIViewAnimationOptions)option
{
    [UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{
                         self.frame = CGRectMake(destination.x,destination.y, self.frame.size.width, self.frame.size.height);
                     }
                     completion:nil];
}

- (void) downUnder:(float)secs option:(UIViewAnimationOptions)option
{
    [UIView animateWithDuration:secs delay:0.0 options:option
         animations:^{
             self.transform = CGAffineTransformRotate(self.transform, M_PI);
         }
         completion:nil];
}

- (void) addSubviewWithZoomInAnimation:(UIView*)view duration:(float)secs option:(UIViewAnimationOptions)option
{
    // first reduce the view to 1/100th of its original dimension
    CGAffineTransform trans = CGAffineTransformScale(view.transform, 0.01, 0.01);
    view.transform = trans;	// do it instantly, no animation
    [self addSubview:view];
    // now return the view to normal dimension, animating this tranformation
    [UIView animateWithDuration:secs delay:0.0 options:option
        animations:^{
            view.transform = CGAffineTransformScale(view.transform, 100.0, 100.0);
        }
        completion:nil];	
}

- (void) removeWithZoomOutAnimation:(float)secs option:(UIViewAnimationOptions)option
{
	[UIView animateWithDuration:secs delay:0.0 options:option
    animations:^{
        self.transform = CGAffineTransformScale(self.transform, 0.01, 0.01);
    }
    completion:^(BOOL finished) { 
        [self removeFromSuperview]; 
    }];
}

// add with a fade-in effect
- (void) addSubviewWithFadeAnimation:(UIView*)view duration:(float)secs option:(UIViewAnimationOptions)option
{
	view.alpha = 0.0;	// make the view transparent
	[self addSubview:view];	// add it
	[UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{view.alpha = 1.0;}
                     completion:nil];	// animate the return to visible 
}

// remove self making it "drain" from the sink!
- (void) removeWithSinkAnimation:(int)steps
{
	NSTimer *timer = nil;
	if (steps > 0 && steps < 100)	// just to avoid too much steps
		self.tag = steps;
	else
		self.tag = 50;
	timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(removeWithSinkAnimationRotateTimer:) userInfo:nil repeats:YES];
}
- (void) removeWithSinkAnimationRotateTimer:(NSTimer*) timer
{
	CGAffineTransform trans = CGAffineTransformRotate(CGAffineTransformScale(self.transform, 0.9, 0.9),0.314);
	self.transform = trans;
	self.alpha = self.alpha * 0.98;
	self.tag = self.tag - 1;
	if (self.tag <= 0)
	{
		[timer invalidate];
		[self removeFromSuperview];
	}
}

/* @author : Chung NV added
 *
 */
#define kZOOM_OUT_MAX_SCALE     1.2
#define kZOOM_OUT_MIN_SCALE     0.1
#define kZOOM_OUT_MAX_TIME      0.4

-(void)showByZoomOut
{
    self.transform = CGAffineTransformMakeScale(kZOOM_OUT_MIN_SCALE,kZOOM_OUT_MIN_SCALE);
    self.alpha = 0.2;
    
    [UIView animateWithDuration:kZOOM_OUT_MAX_TIME animations:^{
        self.transform = CGAffineTransformMakeScale(kZOOM_OUT_MAX_SCALE,kZOOM_OUT_MAX_SCALE);
        self.alpha = 0.9;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.1 animations:^{
            self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            self.alpha = 1;
        }];
        
    }];
}
-(void)dismisByZoomIn:(BOOL) disapper
{
    [UIView animateWithDuration:0.1 animations:^{
        self.transform = CGAffineTransformMakeScale(kZOOM_OUT_MAX_SCALE,kZOOM_OUT_MAX_SCALE);
        self.alpha = 0.9;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:kZOOM_OUT_MAX_TIME animations:^{
            self.transform = CGAffineTransformMakeScale(kZOOM_OUT_MIN_SCALE,kZOOM_OUT_MIN_SCALE);
            self.alpha = 1;
        } completion:^(BOOL finished) {
            if (disapper)
                [self removeFromSuperview];
        }];
        
    }];
}

@end
