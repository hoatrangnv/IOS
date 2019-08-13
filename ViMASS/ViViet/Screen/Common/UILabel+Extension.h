//
//  UILabel+Extension.h
//  ViMASS
//
//  Created by Ngo Ba Thuong on 11/17/12.
//
//

#import <UIKit/UIKit.h>
typedef enum
{
    UITextVerticalAlignmentTop,
    UITextVerticalAlignmentMiddle,
    UITextVerticalAlignmentBottom
    
} UITextVerticalAlignment;

@interface UILabel (Extension)

-(void)alignWithAlignment:(UITextVerticalAlignment)valign inMaxSize:(CGSize)size;

@end
