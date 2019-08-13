//
//  UIView+EntranceElastic.h
//  coreanime
//
//  Created by Thuong Ngo Ba on 8/6/12.
//  Copyright (c) 2012 CMC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (EntranceElastic)

- (void)elasticGrowingInDuration:(CGFloat)duration;

- (void)zoomInDuration:(CGFloat)duration spawning_point:(CGPoint)spawning_point end_point:(CGPoint) end_point;

- (void)zoomOutDuration:(CGFloat)duration spawning_point:(CGPoint)spawning_point end_point:(CGPoint) end_point oncomplete:(void (^)(void))oncomplete;

@end
