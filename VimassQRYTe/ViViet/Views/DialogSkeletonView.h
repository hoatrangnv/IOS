//
//  DialogSkeletonView.h
//  ViMASS
//
//  Created by Ngo Ba Thuong on 8/8/13.
//
//

#import <UIKit/UIKit.h>

@interface DialogSkeletonView : UIView
{
    @protected
    CGPoint spawning_point;
    @protected
    CGPoint end_point;
}

- (void)showin:(UIView *)host;
- (void)cancel;

//
// Private methods
//

- (void)dialogWillDisappear;
- (void)dialogDidDisappear;

@end
