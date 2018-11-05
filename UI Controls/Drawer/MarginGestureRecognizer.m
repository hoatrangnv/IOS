//
//  MarginGestureRecognizer.m
//  test1
//
//  Created by Ngo Ba Thuong on 3/9/13.
//  Copyright (c) 2013 Ngo Ba Thuong. All rights reserved.
//

#import "MarginGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>
#import <objc/runtime.h>

#define THRESHOLD 0

#define log(str) printf (__FUNCTION__);printf ("@%d: %s\n", __LINE__, str)

@implementation MarginGestureRecognizer
{
    BOOL _fullscreen;
    MarginGestureRecognizer_Side _side;
    UIView *_view;
    CGFloat _margin;
    BOOL (^_isPossibleForTouch)(CGPoint p);
}
-(void)setContrainTouch:(BOOL (^)(CGPoint))isPossibleForTouch
{
    [_isPossibleForTouch release];
    _isPossibleForTouch = [isPossibleForTouch copy];
}
-(id)initWithTarget:(id)target action:(SEL)action andView:(UIView *)view
{
    if (self = [super initWithTarget:target action:action])
    {
        self.delaysTouchesBegan = YES;
        self.delegate = self;
        _view = view;
        _margin = 320;
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
    
    const char * other_gesture_class = class_getName([otherGestureRecognizer class]);
    BOOL rslt = YES;
    
    
    if (strcmp("UIScrollViewPanGestureRecognizer", other_gesture_class) == 0)
    {
        rslt = NO;
    }
    else if (strcmp("UISwipeGestureRecognizer", other_gesture_class) == 0)
    {
        rslt = NO;
    }
    else if (strcmp("UIPanGestureRecognizer", other_gesture_class) == 0)
    {
        rslt = NO;
    }
    printf("recognize simultaneously with: %s - %s\n", other_gesture_class, rslt == NO ? "NO" : "YES");
    return rslt;
}

-(bool)isPossibleForTouch: (UITouch *)touch
{
//    if (_side == MarginGestureRecognizer_Side_Full)
//        return true;
    
    CGPoint p = [touch locationInView:_view];
    
    bool possible = false;
    possible = possible || ((_side & MarginGestureRecognizer_Side_Top) != 0 && p.y < _margin && p.y >= 0);
    possible = possible || ((_side & MarginGestureRecognizer_Side_Bottom) != 0 && p.y > _view.frame.size.height - _margin && p.y < _view.frame.size.height );
    possible = possible || ((_side & MarginGestureRecognizer_Side_Left) != 0 && p.x <= _margin && p.x >= 0);
    possible = possible || ((_side & MarginGestureRecognizer_Side_Right) != 0 && p.x >= _view.frame.size.width - _margin && p.x <= _view.frame.size.width);
    
    /* 
     *  Fix : touch fullScreen : _margin = 320
     *  touch RealTimeView : disable
     */
    if (_isPossibleForTouch)
    {
        possible = possible && _isPossibleForTouch(p);
    }
    return possible;
}
- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer
{
//    return NO;
    return YES;
}
-(BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer
{
    return YES;
//    return NO;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_fullscreen)
    {
        UITouch *touch;
        if (touches != nil && touches.allObjects != nil)
        {
            touch = [touches.allObjects lastObject];
            
            if ([self isPossibleForTouch:touch] == false)
            {
                self.state = UIGestureRecognizerStateFailed;
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"touchesMoved");
    if (self.state == UIGestureRecognizerStateBegan || self.state == UIGestureRecognizerStateChanged)
    {
        self.state = UIGestureRecognizerStateChanged;
        return;
    }
    
    if (touches.count >= 1)
    {
        UITouch *touch = [touches allObjects].lastObject;
        
        CGPoint c = [touch locationInView:_view];
        CGPoint p = [touch previousLocationInView:_view];
        
        float dx = fabs(c.x - p.x);
        float dy = fabs(c.y - p.y);
        
        bool recognized = false;
        
        if((_side & MarginGestureRecognizer_Side_Left) != 0 || (_side & MarginGestureRecognizer_Side_Right) != 0)
        {
            if (dx > dy && dx > THRESHOLD)
            {
                recognized = true;
            }
        }
        if((_side & MarginGestureRecognizer_Side_Top) != 0 || (_side & MarginGestureRecognizer_Side_Bottom) != 0)
        {
            if (dy > dx && dy > THRESHOLD)
            {
                recognized = true;
            }
        }
        
        if (recognized)
        {
            self.state = UIGestureRecognizerStateBegan;
        }
        else self.state = UIGestureRecognizerStateFailed;
    
    }
    return;
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.state != UIGestureRecognizerStateChanged)
    {
        self.state = UIGestureRecognizerStateCancelled;
        return;
    }
    self.state = UIGestureRecognizerStateEnded;
}

-(void)reset
{
    [super reset];
}
-(void)dealloc
{
    [super dealloc];
    [_isPossibleForTouch release];
}
@synthesize fullscreen = _fullscreen;
@synthesize side = _side;
@synthesize margin = _margin;

@end
