//
//  UniTabController.h
//  ViMASS
//
//  Created by Ngo Ba Thuong on 2/24/14.
//
//

#import <Foundation/Foundation.h>

@class UniTabController;

@protocol UniTabControllerDelegate <NSObject>
@optional

/**
 *
 * Notify current view controller & next view controller. Return NO to cancel
 *
 */
- (BOOL)UniTabController:(UniTabController *)controller willMoveFromTab:(int)current toTabIndex:(int)next;
- (void)UniTabController:(UniTabController *)controller didSelectTab:(int)index;


@end

@interface UniTabController : NSObject

@end
