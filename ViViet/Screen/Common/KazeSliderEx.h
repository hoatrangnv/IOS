//
//  KazeSliderEx.h
//  ViMASS
//
//  Created by Ngo Ba Thuong on 1/22/13.
//
//

#import <Foundation/Foundation.h>

@interface KazeSliderEx : NSObject


+(KazeSliderEx *) sliderWithViewTop:(UIView *)top
                              right:(UIView *)right
                             bottom:(UIView *)bottom
                               left:(UIView *)left
                  andViewController:(UIViewController *)viewController;

@property (nonatomic, retain) UIView *leftView;
@property (nonatomic, retain) UIView *rightView;
@property (nonatomic, retain) UIView *topView;
@property (nonatomic, retain) UIView *bottomView;

@end
