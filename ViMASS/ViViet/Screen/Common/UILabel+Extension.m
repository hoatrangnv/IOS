//
//  UILabel+Extension.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 11/17/12.
//
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)

-(void)alignWithAlignment:(UITextVerticalAlignment)valign inMaxSize:(CGSize)size
{
    CGSize testSize = size;
    testSize.height = 99999;
    
    CGFloat aFontSize = self.font.pointSize;
    
    CGSize sz;
    for (; aFontSize > self.minimumScaleFactor; aFontSize--)
    {
        UIFont *font = [UIFont fontWithName:self.font.fontName size:aFontSize];
        sz = [self.text sizeWithFont:font constrainedToSize:testSize lineBreakMode:self.lineBreakMode];
        if (sz.height > size.height)
            continue;
        break;
    }
    if (sz.height > size.height)
    {
        sz.height = size.height;
    }
    if (aFontSize != self.font.pointSize)
    {
        self.font = [UIFont fontWithName:self.font.fontName size:aFontSize];
    }
    CGRect finalFrame = self.frame;
    finalFrame.size = sz;
    switch (valign) {
        case UITextVerticalAlignmentBottom:
            finalFrame.origin.y = finalFrame.origin.y + finalFrame.size.height - size.height;
            break;
        case UITextVerticalAlignmentMiddle:
            finalFrame.size = size;
            break;
        case UITextVerticalAlignmentTop:
            break;
        default:
            break;
    }
    self.frame = finalFrame;
}

@end
