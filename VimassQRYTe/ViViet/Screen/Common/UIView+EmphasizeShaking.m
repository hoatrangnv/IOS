//
//  UIView+EmphasizeShaking.m
//  coreanime
//
//  Created by Thuong Ngo Ba on 8/6/12.
//  Copyright (c) 2012 CMC. All rights reserved.
//

#import "UIView+EmphasizeShaking.h"

typedef struct _tagEmphasizeShakingContext
{

CGFloat amplitude;
int     repeat;
bool    isHorizontal;
CGFloat duration;
int     direction;
int     totalHalfPath;
    
}EmphasizeShakingContext;

@implementation UIView (EmphasizeShaking)


-(void)shakingHorizontalInDuration:(CGFloat)duration withAmplitude: (CGFloat) amplitude andRepeat:(int)repeat
{
    EmphasizeShakingContext *context = malloc(sizeof (EmphasizeShakingContext));
    context->amplitude = amplitude;
    context->repeat = repeat;
    context->totalHalfPath = 2 * repeat - 1;
    context->isHorizontal = true;
    context->duration = duration;
    context->direction = -1;
    
    [self shaking:context];
}

-(void)shakingVerticalInDuration:(CGFloat)duration withAmplitude: (CGFloat) amplitude andRepeat:(int)repeat
{
    EmphasizeShakingContext *context = malloc(sizeof (EmphasizeShakingContext));
    context->amplitude = amplitude;
    context->repeat = repeat;
    context->totalHalfPath = 2 * repeat - 1;
    context->isHorizontal = false;
    context->duration = duration;
    context->direction = -1;
    
    [self shaking:context];
}

-(void)shaking: (EmphasizeShakingContext*)context
{
    CGAffineTransform tsf = CGAffineTransformTranslate(CGAffineTransformIdentity, context->isHorizontal ? -context->amplitude : 0, context->isHorizontal ? 0 : -context->amplitude);
    
    [UIView beginAnimations:nil context:context];    
    [UIView setAnimationDuration: context->duration / 4.0 / context->repeat];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(shaking2:finished:context:)];
    self.transform = tsf;
    
    [UIView commitAnimations];

}

- (void)shaking2:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([finished boolValue] && context)
    {
        EmphasizeShakingContext* thecontext = (EmphasizeShakingContext*) context;
        
        if (thecontext->totalHalfPath > 0)
        {
            thecontext->direction *= -1;
            thecontext->totalHalfPath--;
            CGAffineTransform tsf = CGAffineTransformTranslate(CGAffineTransformIdentity, thecontext->isHorizontal ? (thecontext->direction)*thecontext->amplitude : 0, thecontext->isHorizontal ? 0 : (thecontext->direction)*thecontext->amplitude);
            
            [UIView beginAnimations:nil context:context];    
            [UIView setAnimationDuration: thecontext->duration / 4.0 / thecontext->repeat];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(shaking2:finished:context:)];
            self.transform = tsf;
            
            [UIView commitAnimations];
        }
        else
        {
            CGAffineTransform tsf = CGAffineTransformIdentity;            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration: thecontext->duration / 4.0 / thecontext->repeat];
            self.transform = tsf;            
            [UIView commitAnimations];
            free(context);
        }
    }
    else if (context)
    {
        free(context);
    }
}
@end
