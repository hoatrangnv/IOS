//
//  UIView+EmphasizeShaking.h
//  coreanime
//
//  Created by Thuong Ngo Ba on 8/6/12.
//  Copyright (c) 2012 CMC. All rights reserved.
//



@interface UIView (EmphasizeShaking)

-(void)shakingHorizontalInDuration:(CGFloat)duration withAmplitude: (CGFloat) amplitude andRepeat:(int)repeat;
-(void)shakingVerticalInDuration:(CGFloat)duration withAmplitude: (CGFloat) amplitude andRepeat:(int)repeat;

@end
