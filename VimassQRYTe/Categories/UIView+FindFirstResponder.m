//
//  UIView+FindFirstResponder.m
//  ViMASS
//
//  Created by Hoang Pham Huu on 8/30/13.
//
//

#import "UIView+FindFirstResponder.h"

@implementation UIView (FindFirstResponder)
- (UIView *)findFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView findFirstResponder];
        
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
    
    return nil;
}
@end
