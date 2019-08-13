//
//  SideViewController.h
//  test_web_reader
//
//  Created by Ngo Ba Thuong on 11/22/13.
//  Copyright (c) 2013 ViMASS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    SideLeft = -1,
    SideRight = 1
}Side;

@interface SideViewController : NSObject

@property (nonatomic, retain) IBOutlet UIView *left;
@property (nonatomic, retain) IBOutlet UIView *right;
@property (nonatomic, retain) IBOutlet UIView *main;
@property (nonatomic, readonly) BOOL isOpen;


- (void)open_side:(int)side
          animate:(BOOL)animate;

- (void)open_side:(int)side
          animate:(BOOL)animate
         callback:(void (^)(SideViewController *controller))callback;

- (void)close_animate:(BOOL)animate;
- (void)close_animate:(BOOL)animate
             callback:(void (^)(SideViewController *controller))callback;

@end

//
// General implementation of sideviewcontroller
// Nhanh chong su dung sideviewcontroller class de tao hieu ung
//

@interface SideViewContainer : UIView

@property (nonatomic, assign) IBOutlet UIView *main;
@property (nonatomic, readonly) SideViewController *side_controller;
@property (nonatomic, assign) Side side;

-(void) setMain:(UIView *)main side:(Side) side;
- (void) open_animate:(BOOL)animate callback:(void (^)(void))callback;

- (void) close_animate:(BOOL)animate callback:(void (^)())callback;

@end
