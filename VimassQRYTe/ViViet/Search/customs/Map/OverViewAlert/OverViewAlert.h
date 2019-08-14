//
//  OverViewAlert.h
//  ViMASS
//
//  Created by Chung NV on 7/27/13.
//
//

#import <UIKit/UIKit.h>

@interface OverViewAlert : UIView
+(void) showWithMessage:(NSString *) message
             actionText:(NSString *) actionText
                 action:(void(^)()) action;
@end
