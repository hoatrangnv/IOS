
//
//  AppDelegate.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on December 7, 2012.
//  Copyright (c) 2012 Vi Viet. All rights reserved.
//
//#import "TestFlight.h"
#import "AppDelegate.h"
#import "LocalizationSystem.h"
#import "Common.h"
#import "HiNavigationBar.h"
#import "Static.h"
#import "Contacts.h"
#import <CommonCrypto/CommonDigest.h>
#import "CacheManager.h"
#import "Currency.h"
//#define TestFlightToken @"9d139ea5-d4db-4e17-900b-d5114903a152"
#import "UICKeyChainStore.h"
#import "ContactScreen.h"
//test
#import "QRCode_Model.h"
#import "VVEncrypt.h"
#import "Alert+Block.h"
#import "ViToken.h"
#import "ProvinceCoreData.h"
#import "LocalData.h"
#import "BankCoreData.h"
#import "BranchCoreData.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "quicklz.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "DDAlertPrompt.h"
#import "UIDevice+IdentifierAddition.h"
#import "AESCrypt.h"
#import "UpdateLocation.h"


#import "DucNT_LuuRMS.h"
#import "DichVuNotification.h"
#import "DoiTuongNotification.h"

#import "HienThiChatViewController.h"
#import "GiaoDienChinhV2.h"
#import <AudioToolbox/AudioToolbox.h>
#import "HomeCenterViewController.h"
#import "DucNT_LoginSceen.h"
#import "DucNT_LuuRMS.h"

NSString *current_account = @"";
NSString *active_token_serial = @"";
int token_type = -1;
BOOL hard_token_available = NO;
BOOL soft_token_available;
int current_account_type = -1;

NSString *baseURL = @"https://vimass.vn";

@interface AppDelegate () <DucNT_ServicePostDelegate, GPPDeepLinkDelegate>
{
    BOOL mTrangThaiNhanRemoteNotification;
}
@end

@implementation AppDelegate
{
    BOOL backgroundMode;
    BOOL beginPost;
    UIBackgroundTaskIdentifier identify;
    NSString *mDinhDanhKetNoi;
}



@synthesize account = _account;

// Check if the device has been connected to network or not. If the device connected to internet connection,
// show the login, otherwise allow app run in SMS mode
-(void)checkInternetConnection
{
//    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)
//        _hasInternetConnection = NO;
//    else
//        _hasInternetConnection = YES;
}

void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"uncaughtExceptionHandler = %@",exception);
}

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"%s - push ve roi", __FUNCTION__);
    // Read Google+ deep-link data.
    self.isVideoFullscreen = NO;
    [GPPDeepLink setDelegate:self];
    [GPPDeepLink readDeepLinkAfterInstall];
    
    //Dang ky notification
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        NSLog(@"%s - LINE: %d", __FUNCTION__, __LINE__);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    else
    {
        NSLog(@"%s - LINE: %d", __FUNCTION__, __LINE__);
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
    if (dicLaguage == nil)
    {
        NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"DefineLanguage" ofType:@"plist"];
        dicLaguage = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    }
    NSString * language = [[NSUserDefaults standardUserDefaults] objectForKey:LANGUAGE];
    if (language == nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"Tiếng Việt" forKey:LANGUAGE];
        LocalizationSetLanguage([dicLaguage objectForKey:@"Tiếng Việt"]);
    }
    else
    {
        LocalizationSetLanguage([dicLaguage objectForKey:language]);
    }
    if (!global)
    {
        global = [Globals new];
    }

    [self insert_banks_data];
    
    thread_load_contact = [[NSThread alloc] initWithTarget:self selector:@selector(thread_loadContact) object:nil];
    [thread_load_contact start];

    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    BOOL isLogin = [[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue];

    NSString *sKeyDangNhap = [DucNT_LuuRMS layThongTinDangNhap:KEY_DANG_NHAP];
    NSLog(@"%s - sKeyDangNhap : %@", __FUNCTION__, sKeyDangNhap);
    if(sKeyDangNhap.length > 0)
    {
        self.dictDangNhap = [sKeyDangNhap objectFromJSONString];
    }
    if([self.dictDangNhap count] > 0 && isLogin == YES){
        HomeCenterViewController *homeVC = [[HomeCenterViewController alloc]initWithNibName:@"HomeCenterViewController" bundle:nil];
        UINavigationController *navHome = [HiNavigationBar navigationControllerWithRootViewController: homeVC];
        self.window.rootViewController = navHome;
        [homeVC release];
    }
    else{
        [self showLogin];
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self.window setOpaque:YES];
    [self.window makeKeyAndVisible];
    [self getTypeShowNotification];
    return YES;
}

-(void)showLogin{
    DucNT_LoginSceen *loginVC = [[DucNT_LoginSceen alloc]initWithNibName:@"DucNT_LoginSceen" bundle:nil];
    UINavigationController *navHome =  [HiNavigationBar navigationControllerWithRootViewController: loginVC];;
    loginVC.view.frame = [UIScreen mainScreen].bounds;
    self.window.rootViewController = navHome;
    [loginVC release];
}
-(void)showHowScreen:(DucNT_TaiKhoanViObject *)mThongTinTaiKhoanVi{
    HomeCenterViewController *homeVC = [[HomeCenterViewController alloc]initWithNibName:@"HomeCenterViewController" bundle:nil];
    homeVC.mThongTinTaiKhoanVi = mThongTinTaiKhoanVi;
    [self.navigationController pushViewController:homeVC animated:YES];
}
- (void)getTypeShowNotification {
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://vimass.vn/vmbank/services/quanTriPush/mappingTypeShowVaPhanLoai"]];
    
    //create the Method "GET"
    [urlRequest setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 200)
        {
            NSString *sData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%s - sData : %@", __FUNCTION__, sData);
            [DucNT_LuuRMS luuTypeShowNotification:KEY_TYPE_SHOW_NOTIFICATION value:sData];
//            [DucNT_LuuRMS luuThongTinTrongRMSTheoKey:KEY_TYPE_SHOW_NOTIFICATION value:sData];
        }
        else
        {
            NSLog(@"Error");
        }
    }];
    [dataTask resume];
}

-(void) thread_loadContact
{
    [global loadContacts];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"thread_loadContact" object:@"load contact success"];
    
    [thread_load_contact release];
    thread_load_contact = nil;
}

-(void)insert_banks_data
{
    NSString *insertBankData = [[NSUserDefaults standardUserDefaults]
                                objectForKey:@"insertBankData"];
    if (insertBankData == nil)
    {
        NSThread *thread_load_banks_data = [[NSThread alloc] initWithTarget:self selector:@selector(threadDidLoadBanksData:) object:nil];
        [thread_load_banks_data start];
    }
}

-(void)threadDidLoadBanksData:(NSThread *) thread
{
    NSLog(@"----begin load banks data----");
    NSString *f = [[NSBundle mainBundle] pathForResource:@"getProvinces" ofType:@"txt"];
    NSString *provinces = [NSString stringWithContentsOfFile:f encoding:NSUTF8StringEncoding error:nil];
    [ProvinceCoreData addProvincesWithJSON:provinces];
    
    f = [[NSBundle mainBundle] pathForResource:@"getBanks" ofType:@"txt"];
    NSString *banks = [NSString stringWithContentsOfFile:f encoding:NSUTF8StringEncoding error:nil];
    [BankCoreData addBanksFromJSON:banks];
    
    f = [[NSBundle mainBundle] pathForResource:@"getBranches" ofType:@"txt"];
    NSString *branches = [NSString stringWithContentsOfFile:f encoding:NSUTF8StringEncoding error:nil];
    [BranchCoreData addBranchesFromJSON:branches];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"insert bank data success" forKey:@"insertBankData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [thread release];
    thread = nil;
    NSLog(@"-----end load banks data----");
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (self.isVideoFullscreen) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

//- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
//{
//    NSUInteger orientations = UIInterfaceOrientationMaskPortrait;
//    @try {
//        if(self.window.rootViewController)
//        {
//            UIViewController *presentedViewController = [[(UINavigationController *)self.window.rootViewController viewControllers] lastObject];
//            orientations = [presentedViewController supportedInterfaceOrientations];
//        }
//    }
//    @catch (NSException *exception)
//    {
//        NSLog(@"no problem");
//    }
//    
//    return orientations;
//}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSString *msg = url.absoluteString;
    NSString *content = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    content = [NSString stringWithFormat:@"Content of file at location [%@]:\n%@", msg, content];
    
    [[[[UIAlertView alloc] initWithTitle:@"Content" message:content delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
    return YES;
}

-(UINavigationController *)navigationController
{
    UINavigationController* nav = (UINavigationController*)self.window.rootViewController;
    return nav;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"%s - an app xuong background", __FUNCTION__);
    //Trang thai nhan remote de xac dinh vao app bang cach an vao notification hay khong
    mTrangThaiNhanRemoteNotification = NO;
    int nTongSoLuongTinChuaDoc = [[DichVuNotification shareService] laySoLuongTinChuaDocTrongChucNang:0];
    NSLog(@"%s - nTongSoLuongTinChuaDoc : %d", __FUNCTION__, nTongSoLuongTinChuaDoc);
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:nTongSoLuongTinChuaDoc];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"APP_TO_BACKGROUND" object:nil];
    return;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"%s - hien thi lai app", __FUNCTION__);
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"APP_TO_FOREGROUND" object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"%s - %s : START", __FILE__, __FUNCTION__);
//    if (thread_load_contact != nil) {
//        NSLog(@"%s - %s : load contact", __FILE__, __FUNCTION__);
//        [thread_load_contact start];
//    } else {
//        thread_load_contact = [[NSThread alloc] initWithTarget:self selector:@selector(thread_loadContact) object:nil];
//        [thread_load_contact start];
//    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@"tamnv_hienthi" forKey:@"0"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [FBAppEvents activateApp];

    [FBAppCall handleDidBecomeActive];

    mDinhDanhKetNoi = DINH_DANH_LAY_SO_LUONG_TIN_CHUA_DOC;
    [[DichVuNotification shareService] dichVuLaySoLuongTinChuaDocTrongKieu:0 noiNhanKetQua:self];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"%@ >> %@ line: %d >> OKE ", NSStringFromClass([self class]),NSStringFromSelector(_cmd),__LINE__);
    [FBSession.activeSession close];
}

#pragma mark - Dùng cho PushNotification
#pragma mark - RegisterForRemoteNotifications


#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    NSLog(@"%s =========================> thu xem push khong len so", __FUNCTION__);
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"])
    {
        NSLog(@"info:%@: %@, declineAction", NSStringFromClass([self class]),NSStringFromSelector(_cmd));
        
    }
    else if ([identifier isEqualToString:@"answerAction"])
    {
        NSLog(@"info:%@: %@, answerAction", NSStringFromClass([self class]),NSStringFromSelector(_cmd));
    }
}

#endif
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"%s - dang ky push notification : deviceToken : %@", __FUNCTION__, deviceToken);
    NSString *sDeviceToken = [NSString stringWithFormat:@"%@", deviceToken];
    sDeviceToken = [sDeviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    sDeviceToken = [sDeviceToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
    sDeviceToken = [sDeviceToken stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSString *sDeviceTokenTemp = [DucNT_LuuRMS layThongTinDangNhap:KEY_DEVICE_TOKEN];
    if(!sDeviceTokenTemp || sDeviceTokenTemp.length == 0 || ![sDeviceTokenTemp isEqualToString:sDeviceToken])
    {
        NSLog(@"%s - sDeviceToken : %@", __FUNCTION__, sDeviceToken);
        [DucNT_LuuRMS luuThongTinDangNhap:KEY_DEVICE_TOKEN value:sDeviceToken];
        if(![[DichVuNotification shareService] kiemTraDaDangKiThietBi])
        {
            NSLog(@"%s - =======> dang ky thiet bi", __FUNCTION__);
            mDinhDanhKetNoi = DINH_DANH_DANG_KI_THIET_BI;
            [[DichVuNotification shareService] dichVuDangKyThietBi:self];
        }
    }
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}



#pragma mark - didReceive(Remote/Local)Notification

//Hiện tại đang dùng remote notification
// Hien tai dang click vao notification se nhay vao did become active

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"%s =========> START - userInfo : %@", __FUNCTION__, userInfo);
    AudioServicesPlaySystemSound(1352);
    if ([application applicationState] == UIApplicationStateActive)
    {
        DoiTuongNotification *obj = [[DoiTuongNotification alloc] initWithDict:userInfo];
//        if([obj.funcID integerValue] == TIN_CHAT_RAO_VAT)
//        {
            [[NSNotificationCenter defaultCenter] postNotificationName: UIApplicationLaunchOptionsRemoteNotificationKey
                                                                object: self
                                                              userInfo: userInfo];
//        }

        [[DichVuNotification shareService] tangGiaTriBagdeNumberChoChucNang:[obj.funcID intValue]];
        [self reloadGiaoDienHome];
//        int nTongSoLuongTinChuaDoc = [[DichVuNotification shareService] laySoLuongTinChuaDocTrongChucNang:0];
//        NSLog(@"%s - nTongSoLuongTinChuaDoc : %d", __FUNCTION__, nTongSoLuongTinChuaDoc);
//        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:nTongSoLuongTinChuaDoc];
    }
    else if ([application applicationState] == UIApplicationStateBackground){
        NSLog(@"%s =========> START 2", __FUNCTION__);
//        DoiTuongNotification *obj = [[DoiTuongNotification alloc] initWithDict:userInfo];
//        [[DichVuNotification shareService] tangGiaTriBagdeNumberChoChucNang:[obj.funcID intValue]];
//        [self reloadGiaoDienHome];
//        int nTongSoLuongTinChuaDoc = [[DichVuNotification shareService] laySoLuongTinChuaDocTrongChucNang:0];
//        NSLog(@"%s - nTongSoLuongTinChuaDoc : %d", __FUNCTION__, nTongSoLuongTinChuaDoc);
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
}

//Cái này để dùng cho local notification và bây h chưa cần dùng đến.
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    AudioServicesPlaySystemSound(1352);
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive)
    {
        NSLog(@"info:%@: %@, Active", NSStringFromClass([self class]),NSStringFromSelector(_cmd));
    }
    else
    {
        NSLog(@"info:%@: %@, non active", NSStringFromClass([self class]),NSStringFromSelector(_cmd));
    }
}

#pragma mark - public

- (void) reloadGiaoDienHome
{
    mDinhDanhKetNoi = DINH_DANH_LAY_SO_LUONG_TIN_CHUA_DOC;
    [[DichVuNotification shareService] dichVuLaySoLuongTinChuaDocTrongKieu:0 noiNhanKetQua:self];
}


#pragma mark - DidBecomeActive se tra ra ket qua tai day.
#pragma mark - DucNT_ServicePostDelegate
- (void)ketNoiThanhCong:(NSString *) sKetQua
{
    NSLog(@"%s - mDinhDanhKetNoi : %@", __FUNCTION__, mDinhDanhKetNoi);
    NSLog(@"%s - sKetQua : %@", __FUNCTION__, sKetQua);
    NSDictionary *dicKetQua = [sKetQua objectFromJSONString];
    int nCode = [[dicKetQua objectForKey:@"msgCode"] intValue];
//    NSString *message = [dicKetQua objectForKey:@"msgContent"];
    if(nCode == 1)
    {
        if([mDinhDanhKetNoi isEqualToString:DINH_DANH_DANG_KI_THIET_BI])
        {
            [[DichVuNotification shareService] xacNhanDangKiThietBi];
        }
        else if([mDinhDanhKetNoi isEqualToString:DINH_DANH_LAY_SO_LUONG_TIN_CHUA_DOC])
        {
            NSArray *result = [dicKetQua objectForKey:@"result"];
            NSError *err = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:&err];
            if(err)
            {
                NSLog(@"Error:%@: %@, err : %@", NSStringFromClass([self class]),NSStringFromSelector(_cmd), err.localizedDescription);
            }
            else
            {
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

                [[DichVuNotification shareService] luuSoLuongTinChuaDoc:jsonString];

                [[NSNotificationCenter defaultCenter] postNotificationName: ID_NOTIFICATION_RELOAD_GIAO_DIEN
                                                                    object: self
                                                                  userInfo: nil];
                // chuc nang khong la tat ca cac chuc nang
//                int nTongSoLuongTinChuaDoc = [[DichVuNotification shareService] laySoLuongTinChuaDocTrongChucNang:0];
//                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:nTongSoLuongTinChuaDoc];
            }
        }
    }
    else
    {
    }
}

#pragma mark - Laguage

-(void) loadLanguage:(NSString *) _language
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:_language, nil] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - facebook
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    BOOL urlWasHandled = NO;
    if([url.scheme isEqualToString:@"fb1567434636808192"])
    {
        urlWasHandled =  [FBAppCall handleOpenURL:url
                      sourceApplication:sourceApplication
                        fallbackHandler:^(FBAppCall *call) {
                            NSString *query = [url query];
                            NSDictionary *params = [self parseURLParams:query];
                            // Check if target URL exists
                            NSString *appLinkDataString = [params valueForKey:@"al_applink_data"];
                            if (appLinkDataString) {
                                NSError *error = nil;
                                NSDictionary *applinkData =
                                [NSJSONSerialization JSONObjectWithData:[appLinkDataString dataUsingEncoding:NSUTF8StringEncoding]
                                                                options:0
                                                                  error:&error];
                                if (!error &&
                                    [applinkData isKindOfClass:[NSDictionary class]] &&
                                    applinkData[@"target_url"]) {
                                    self.refererAppLink = applinkData[@"referer_app_link"];
                                    NSString *targetURLString = applinkData[@"target_url"];
                                    // Show the incoming link in an alert
                                    // Your code to direct the user to the
                                    // appropriate flow within your app goes here
                                    [[[UIAlertView alloc] initWithTitle:@"Received link:"
                                                                message:targetURLString
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil] show];
                                }
                            }
                        }];
    }
    else if ([url.scheme isEqualToString:@"com.vimass.vivimass"])
    {
        urlWasHandled = [GPPURLHandler handleURL:url
                               sourceApplication:sourceApplication
                                      annotation:annotation];
    }

    
    return urlWasHandled;
}

// A function for parsing URL parameters
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val = [[kv objectAtIndex:1]
                         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}

#pragma mark - GPPDeepLinkDelegate
- (void)didReceiveDeepLink:(GPPDeepLink *)deepLink
{
    
}

#pragma mark - dealloc
- (void)dealloc
{
    [thread_realtime release];
    [_window release];
    [dicLaguage release];
    [global release];
    [super dealloc];
}

@synthesize window = _window;
@synthesize global;
@synthesize dicLaguage;
@synthesize hasInternetConnection = _hasInternetConnection;
@synthesize contactsVC;
@end
