//
//  UIView+Autosize.m
//  ViMASS
//
//  Created by Hoang Pham Huu on 8/6/13.
//
//

#import "UIView+Autosize.h"

@implementation UIView (Autosize)

-(void)resizeToFitSubviewsWithFixedWidth:(CGFloat)width andPadding:(CGFloat)padding
{
    float w = 0;
    float h = 0;
    
    for (UIView *v in [self subviews]) {
        float fw = v.frame.origin.x + v.frame.size.width;
        float fh = v.frame.origin.y + v.frame.size.height;
        w = MAX(fw, w);
        h = MAX(fh, h);
    }
    if (self.frame.size.height != h) {
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, width, h + padding)];
    }
}


@end
