//
//  FixIOS7StatusBarRootView.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 12/4/13.
//
//

#import "FixIOS7StatusBarRootView.h"
#import "Common.h"

@implementation FixIOS7StatusBarRootView

- (void)fix
{
    if (self.superview != nil)
    {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7"))
        {
            CGRect frame = self.frame;
            
            frame.origin.y = 20;
            frame.size.height = self.superview.bounds.size.height - 20;
            super.frame = frame;
        }
    }
}

@end
