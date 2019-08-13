//
//  RoundAlert.h
//
//  Created by Ngo Ba Thuong on 7/2/12.
//  Copyright (c) 2012 Anima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundAlert : UIView

#pragma mark - functionality

@property (nonatomic, copy)     NSString*   message;
@property (nonatomic, copy)     NSString*   cancelText;
@property (nonatomic, retain)   UIView*     iconView;

@property (nonatomic)           CGFloat     opacity;
@property (nonatomic, retain)   UIColor*    fillColor;

@property (nonatomic, retain)   id          target;

#pragma mark - methods


-(void)notifing: (SEL)sel ofTarget: (id)delegate;
-(void)show;
-(void)hide;


+(void) show;
+(void) hide;
@end
