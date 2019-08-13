//
//  UIView+EntranceElastic.m
//  coreanime
//
//  Created by Thuong Ngo Ba on 8/6/12.
//  Copyright (c) 2012 CMC. All rights reserved.
//

#import "UIView+EntranceElastic.h"

@implementation UIView (EntranceElastic)

- (CGAffineTransform)transformForOrientation
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (orientation == UIInterfaceOrientationLandscapeLeft)
    {
        return CGAffineTransformMakeRotation(M_PI*1.5);
    }
    else if (orientation == UIInterfaceOrientationLandscapeRight)
    {
        return CGAffineTransformMakeRotation(M_PI/2);
    }
    else if (orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        return CGAffineTransformMakeRotation(-M_PI);
    }
    
    return CGAffineTransformIdentity;
}

-(void)elasticGrowingInDuration:(CGFloat)duration
{
    CGFloat *context = malloc(sizeof (CGFloat));
    context[0] = duration;
    
    self.transform = CGAffineTransformScale([self transformForOrientation], 0.001, 0.001);
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationDuration:duration/1.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(entranceElastic1AnimationStopped:finished:context:)];
    self.transform = CGAffineTransformScale([self transformForOrientation], 1.1, 1.1);
    [UIView commitAnimations];
}

- (void)zoomInDuration:(CGFloat)duration spawning_point:(CGPoint)spawning_point end_point:(CGPoint) end_point;
{
    CGFloat *context = malloc(sizeof (CGFloat));
    context[0] = duration;
    
    CGAffineTransform mtrix = [self transformForOrientation];
    
    mtrix = CGAffineTransformTranslate (mtrix, 0, spawning_point.y - self.center.y);
    mtrix = CGAffineTransformScale(mtrix, 0, 0);
    
    self.transform = mtrix;
    
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationDelegate:self];
    
    mtrix = [self transformForOrientation];
    mtrix = CGAffineTransformTranslate (mtrix, 0, end_point.y - self.center.y);
    mtrix = CGAffineTransformScale(mtrix, 1.0, 1.0);
    
    
    self.transform = mtrix;
    
    [UIView commitAnimations];
}

- (void)zoomOutDuration:(CGFloat)duration spawning_point:(CGPoint)spawning_point end_point:(CGPoint) end_point oncomplete:(void (^)(void))oncomplete;
{
    void *context = [oncomplete copy];
    
    CGAffineTransform mtrix = [self transformForOrientation];
    
    mtrix = CGAffineTransformTranslate (mtrix, 0, end_point.y - self.center.y);
    mtrix = CGAffineTransformScale(mtrix, 1.0, 1.0);
    
    
    self.transform = mtrix;
    
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endZoomOut:finished:context:)];
    
    mtrix = [self transformForOrientation];
    
    mtrix = CGAffineTransformTranslate (mtrix, 0, spawning_point.y - self.center.y);
    mtrix = CGAffineTransformScale(mtrix, 0, 0);
    
    self.transform = mtrix;
    
    [UIView commitAnimations];
}

- (void)endZoomOut:(NSString *)animationID finished:(NSNumber *)finished context:(void *)thecontext
{
    void (^callback)(void) = thecontext;
    callback ();
    
    [callback release];
}

- (void)entranceElastic1AnimationStopped:(NSString *)animationID finished:(NSNumber *)finished context:(void *)thecontext
{
    CGFloat duration = ((CGFloat*)thecontext)[0];
    [UIView beginAnimations:nil context:thecontext];
    [UIView setAnimationDuration:duration/2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(entranceElastic2AnimationStopped:finished:context:)];
    self.transform = CGAffineTransformScale([self transformForOrientation], 0.9, 0.9);
    [UIView commitAnimations];
}

- (void)entranceElastic2AnimationStopped:(NSString *)animationID finished:(NSNumber *)finished context:(void *)thecontext
{
    CGFloat duration = ((CGFloat*)thecontext)[0];
    free (thecontext);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration/2];
    self.transform = [self transformForOrientation];
    [UIView commitAnimations];
}

@end
