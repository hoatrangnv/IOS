//
//  AppDelegate.h
//  ViMASS
//
//  Created by Ngo Ba Thuong on December 7, 2012.
//  Copyright (c) 2012 Vi Viet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"
#import <MapKit/MapKit.h>

#import <FacebookSDK/FacebookSDK.h>
#import <GooglePlus/GooglePlus.h>
@class ContactScreen;
@class ViAccount;
@class DucNT_TaiKhoanViObject;
@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>
{
    BOOL _hasInternetConnection;
    NSThread *thread_realtime;
    NSThread *thread_load_contact;
}

@property (nonatomic, retain) ViAccount *account;
@property (nonatomic) BOOL isVideoFullscreen;
@property (nonatomic, readonly) BOOL hasInternetConnection;

-(void)checkInternetConnection;

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) Globals *global;
@property (nonatomic, retain) NSDictionary *dicLaguage;
@property (nonatomic, assign) ContactScreen *contactsVC;
@property (strong, nonatomic) NSDictionary *refererAppLink;


@property (retain, nonatomic) UIImageView *v_realtime;

-(void) loadLanguage:(NSString *) _language;

-(UINavigationController *) navigationController;

- (void) reloadGiaoDienHome;

// HOANHNV FIX FOR UPDATE ACCOUNT
@property (retain, nonatomic) DucNT_TaiKhoanViObject *objUpdateProfile;

@end
