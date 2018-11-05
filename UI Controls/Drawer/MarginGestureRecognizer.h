//
//  mygesture.h
//  test1
//
//  Created by Ngo Ba Thuong on 3/9/13.
//  Copyright (c) 2013 Ngo Ba Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MarginGestureRecognizer_Side)
{
    MarginGestureRecognizer_Side_Top = 1,
    MarginGestureRecognizer_Side_Right = 1 << 2,
    MarginGestureRecognizer_Side_Bottom = 1 << 3,
    MarginGestureRecognizer_Side_Left = 1 << 4,
    MarginGestureRecognizer_Side_LeftRight = MarginGestureRecognizer_Side_Left | MarginGestureRecognizer_Side_Right,
    MarginGestureRecognizer_Side_TopBottom = MarginGestureRecognizer_Side_Top | MarginGestureRecognizer_Side_Top,
    MarginGestureRecognizer_Side_Full = 0xFFFFFF
    
};

@interface MarginGestureRecognizer :  UIGestureRecognizer <UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL fullscreen;
@property (nonatomic, assign) MarginGestureRecognizer_Side side;
@property (nonatomic, assign) CGFloat margin;

-(void) setContrainTouch:(BOOL(^)(CGPoint p)) isPossibleForTouch;

-(id)initWithTarget:(id)target
             action:(SEL)action
            andView:(UIView *)view;

@end


