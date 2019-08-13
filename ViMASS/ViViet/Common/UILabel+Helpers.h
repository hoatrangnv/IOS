//
//  UILabel+Helpers.h
//  ViMASS
//
//  Created by Ngo Ba Thuong on 4/12/13.
//
//

#import <UIKit/UIKit.h>

@interface UILabel (Helpers)

// Giam font size cua label den khi nao text nam trong frame cua label
- (void)adjustCurrentFontSize:(CGFloat)min_size;

-(CGRect) fit_text;
-(CGRect) wrap_text;
-(CGRect) wrap_text:(int) numberLines;

- (CGRect)adjust_height;

-(void) display_justify;

@end
