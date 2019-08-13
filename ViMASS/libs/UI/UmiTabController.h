//
//  UmiTabController.h
//  ViMASS
//
//  Created by Ngo Ba Thuong on 10/24/13.
//
//

#import <Foundation/Foundation.h>
@class UmiTabController;

@protocol UmiTabControllerDelegate <NSObject>
@optional
#pragma mark - Events

- (BOOL)UmiTabController:(UmiTabController *)tab_controller will_select_tab:(int)index;
- (void)UmiTabController:(UmiTabController *)tab_controller did_select_tab:(int)index;

@end

@interface UmiTabController : NSObject

@property (nonatomic, assign) IBOutlet id<UmiTabControllerDelegate> delegate;
@property (nonatomic, assign) IBOutlet UIView *container;
@property (nonatomic, retain) NSArray *view_controllers;
@property (nonatomic, assign) int selected_tab;
@property (nonatomic, assign) UIEdgeInsets edge_insets;

@end
