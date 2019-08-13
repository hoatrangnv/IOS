//
//  Drawer.h
//  testsliderex
//
//  Created by Ngo Ba Thuong on 3/11/13.
//  Copyright (c) 2013 Ngo Ba Thuong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MarginGestureRecognizer.h"

@class Drawer;

@protocol DrawerDelegate <NSObject>
@optional

-(void)didClose;
-(void)didOpen;

- (void)drawer_did_close:(Drawer *)drawer;

@end

@interface Drawer : UIView
{
    @public
     MarginGestureRecognizer *_gesture;
}
@property (nonatomic, assign) BOOL static_left;
@property (nonatomic, assign) BOOL static_right;

@property (nonatomic, assign) IBOutlet UIView *content;
@property (nonatomic, retain) IBOutlet UIView *left;
@property (nonatomic, retain) IBOutlet UIView *right;
@property (nonatomic, assign) IBOutlet id<DrawerDelegate> delegate;

@property (nonatomic, assign) BOOL     enableTouch;


- (void)refresh;
- (void)close:(void(^)()) finished;
- (void)openLeft;
- (void)openRight;

@end
