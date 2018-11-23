//
//  BaseScreen.m
//  CameraUploadApp
//
//  Created by QUANGHIEP on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseScreen.h"
#import "AppDelegate.h"
#import "Static.h"
#import "BPButton.h"
#import "LocalizationSystem.h"
#import "UIViewController+Common.h"
#import "HiNavigationBar.h"
#import "Common.h"

#import <objc/runtime.h>
#import "UILabel+Helpers.h"
#import "DichVuNotification.h"


@interface BaseScreen ()

@end

@implementation UINavigationController (Rotate)

//-(BOOL)shouldAutorotate
//{
//    return [[self.viewControllers lastObject] shouldAutorotate];
//}

//-(NSUInteger)supportedInterfaceOrientations
//{
//    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
//}
@end

@implementation BaseScreen
{
    // If this variable > 0, we show the loading screen, if <= 0 we hide the loading screen.
    int _isLoadingCount;
    
    // for IOS 7
    BOOL statusBar_hidden;
}

+ (AppDelegate *)app
{
    return (AppDelegate*)([UIApplication sharedApplication].delegate);
}

+(void)create:(void (^)(BaseScreen *controller))oncreate
  privateInfo:(NSDictionary *)privateInfo
{
    //    if ([[self class] respondsToSelector:@selector(create_with_params:oncreate:)])
    //    {
    //        [self create_with_params:privateInfo oncreate:oncreate];
    //        return;
    //    }
    
    // BE overrided by subclass
    
    BaseScreen *vc = [[[self class] alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
    vc->_createBlock = [oncreate copy];
    vc->_createBlock([vc autorelease]);
    [vc->_createBlock release];
    vc->_createBlock = nil;
}

+ (void)create_with_params:(NSDictionary *)params
                  oncreate:(void (^)(BaseScreen *view_controller))oncreate_callback;
{
    if ([[self class] respondsToSelector:@selector(create:privateInfo:)])
    {
        [[self class] create:oncreate_callback privateInfo:params];
        return;
    }
    BaseScreen *vc = [[[self class] alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
    oncreate_callback ([vc autorelease]);
}

+(void)drawerTouchEnableOrDisable:(BOOL)enable
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    for (UIViewController *vc in app.navigationController.viewControllers)
    {
        if ([vc.view isKindOfClass:[Drawer class]])
        {
            ((Drawer*)vc.view).enableTouch = enable;
        }
    }
}

#pragma mark - HamKhongDungTren ViVimass
- (void) didRotate:(NSNotification *)notification
{
    
}

- (void)getAuthMethod:(void (^)(NSString *authMethod))callback
{
    
}

- (void)confirm_OTP:(void (^)(NSString *errcode))callback
{
    
}

- (void)select_security_question:(void (^)(NSString *ID, NSString *question))callback
{
    
}

- (void)didSelectSetting
{
    
}

-(NSUInteger)supportedInterfaceOrientations
{
    //    UIInterfaceOrientation current_orientation = [[UIApplication sharedApplication] statusBarOrientation];
    //    if ([YoutubePlayer isFullScreen])
    //    {
    //        return UIInterfaceOrientationMaskAll;
    //    }
    //
    //    if ([YoutubePlayer isPlayingVideo])
    //    {
    //        if (current_orientation == UIInterfaceOrientationPortrait)
    //        {
    //            return UIInterfaceOrientationMaskAll;
    //        }
    //    }
    //    if ([ImageViewerController isShowingImagesGallery])
    //    {
    //        return UIInterfaceOrientationMaskAll;
    //    }
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Loading screen helpers

-(BOOL)isLoading
{
    return _isLoadingCount > 0;
}

-(void)setIsLoading:(BOOL)isLoading
{
    _isLoadingCount += isLoading ? 1 : -1;
    if (_isLoadingCount < 0)
        _isLoadingCount = 0;
    NSLog(@"_isLoadingCount = %d : isLoading = %@",_isLoadingCount,isLoading ?@"YES" : @"NO");
    if (_isLoadingCount == 1 && isLoading)
    {
        [self showLoadingScreen];
    }
    else if (_isLoadingCount == 0)
    {
        [self hideLoadingScreen];
    }
}

- (void) logout:(BOOL)popToRoot
{
    app.global.accountNo = @"";
    current_account = nil;
    
    if (popToRoot)
        [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void) promptWithTitle:(NSString *)title
                  andTag:(int)tag
         andKeyboardType:(UIKeyboardType)kbType
        withSecuredField:(BOOL)secured
{
    NSString * str = LocalizedString(title);
    
    DDAlertPrompt *alert = [[[DDAlertPrompt alloc] initWithTitle:str
                                                        delegate:self
                                               cancelButtonTitle:LocalizedString(@"OK")
                                                otherButtonTitle:LocalizedString(@"Cancel")
                                                         andType:secured ? DDAlertPrompt_PASSWORD : DDAlertPrompt_USERNAME] autorelease];
    
    [alert setTag:tag];
    [alert show];
}

- (void) promptWithTitle:(NSString *)title
         andKeyboardType:(UIKeyboardType)kbType
        withSecuredField:(BOOL)secured
                   block:(AlertBlock) block
{
    NSString * str = AMLocalizedString(title, title);
    
    DDAlertPrompt *alert = [[[DDAlertPrompt alloc] initWithTitle:str
                                                        delegate:nil
                                               cancelButtonTitle:LocalizedString(@"OK")
                                                otherButtonTitle:LocalizedString(@"Cancel")
                                                         andType:secured ? DDAlertPrompt_PASSWORD : DDAlertPrompt_USERNAME] autorelease];
    
    [alert showWithBlock:block];
}

-(void)addHomeBarButton
{
    [self addSettingButtonAtSide:-1];
    [self show_vitoken_button:YES];
}

-(void)addDefauleBarButton
{
    [self addBackButton:NO];
}

-(void) addButtonBack
{
    //    [self addBackButton:NO];
}
-(void)didSelectBackButton
{
    if (self.enableBarButton == NO)
        return;
    
    if ([UIApplication sharedApplication].statusBarHidden == YES)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        CGRect status_frame = app.navigationController.navigationBar.frame;
        status_frame.origin = CGPointMake(0, 20);
        app.navigationController.navigationBar.frame = status_frame;
    }
    [[self navigationController] popViewControllerAnimated:YES];
    
}
- (void)show_vitoken_button:(BOOL)show
{
    if (show == NO)
    {
        [self add_transparent_baritem:YES];
        return;
    }
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 25);
    [button setImage:[UIImage imageNamed:@"nav_vitoken"] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [button addTarget:self action:@selector(did_select_vitoken_button) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    
    self.navigationItem.rightBarButtonItems = @[leftItem];
}


-(void) addSettingButtonAtSide:(int)side
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button setImage:[UIImage imageNamed:@"setting-bar-button"]forState:UIControlStateNormal];
    
    button.backgroundColor = [UIColor clearColor];
    button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [button addTarget:self action:@selector(didSelectSetting) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    
    UIBarButtonItem *negativeSeperator = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7"))
        negativeSeperator.width = -5;
    else
        negativeSeperator.width = -16;
    
    if (side > 0)
        //        self.navigationItem.rightBarButtonItems = @[leftItem, leftItem1];
        self.navigationItem.rightBarButtonItems = @[negativeSeperator, leftItem];
    else
        self.navigationItem.leftBarButtonItems = @[negativeSeperator, leftItem];
}


-(void) addButton:(NSString*)imageNamed selector:(SEL)selector atSide:(int)side
{
    //    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageNamed] style:UIBarButtonItemStyleDone target:self action:selector];
    //    UIBarButtonItem *negativeSeperator = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
    //    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
    //        [btnTemp.widthAnchor constraintEqualToConstant:40].active = YES;
    //        [btnTemp.heightAnchor constraintEqualToConstant:40].active = YES;
    //    }
    //    if (SYSTEM_VERSION_LESS_THAN(@"11"))
    //        negativeSeperator.width = -10;
    //    else
    //        negativeSeperator.width = -15;
    //    if (side > 0)
    //        self.navigationItem.rightBarButtonItems = @[negativeSeperator, item];
    //    else
    //        self.navigationItem.leftBarButtonItems = @[item, negativeSeperator];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button setImage:[UIImage imageNamed:imageNamed]forState:UIControlStateNormal];
    
    button.backgroundColor = [UIColor clearColor];
    //    button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    
    UIBarButtonItem *negativeSeperator = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
        negativeSeperator.width = -15;
        [button.widthAnchor constraintEqualToConstant:30].active = YES;
        [button.heightAnchor constraintEqualToConstant:30].active = YES;
    }
    else
        negativeSeperator.width = -10;
    
    if (side > 0)
        self.navigationItem.rightBarButtonItems = @[negativeSeperator, leftItem];
    else
        self.navigationItem.leftBarButtonItems = @[negativeSeperator, leftItem];
}


-(void) addSettingButton
{
    [self addSettingButtonAtSide:1];
}


-(void)didSelectExitButton
{
    if (self.enableBarButton == NO)
        return;
    
    NSLog(@"----%s - exit button clicked----",__FUNCTION__);
    [self confirm:@"@exit - Are you sure?" title:nil block:^(UIAlertView *alert, int indexClicked) {
        if (indexClicked == 1)
            exit(0);
    }];
    
}

-(void) addButtonCateLeft
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44, 44);
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(didSelectCateLeft) forControlEvents:UIControlEventTouchUpInside];
    
    [button setImage:[UIImage imageNamed:@"bar_button_cate_left"] forState:UIControlStateNormal];
    button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    UIBarButtonItem *leftItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    leftItem.width = 44;
    
    UIBarButtonItem *negativeSeperator = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7"))
        negativeSeperator.width = -5;
    else
        negativeSeperator.width = -16;
    
    self.navigationItem.leftBarButtonItems = @[negativeSeperator, leftItem];
    [self.navigationItem setHidesBackButton:YES];
    
    return;
    
}
-(void)didSelectCateLeft
{
    if (self.enableBarButton == NO)
        return;
    
    if ([self.view isKindOfClass:[Drawer class]])
    {
        [((Drawer *)self.view) openLeft];
    }
}

#pragma mark - LoadingScreen
- (void) showLoadingScreen
{
    [RoundAlert show];
}
- (void) hideLoadingScreen
{
    [RoundAlert hide];
}

#pragma mark - LoadLaguage
-(void) reloadLaguage:(NSString*) laguage
{
    NSString * temp =  [[app dicLaguage] objectForKey:laguage];
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:temp, nil] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (int)languageID
{
    int lang = 0;
    NSNumber *tmp = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:kOptionLanguage];
    if (tmp != nil && [tmp isKindOfClass:[NSNumber class]])
        lang = [tmp intValue] % 2;
    
    return lang;
}
- (NSString *)languageName
{
    NSString *names[] = {@"vi", @"en"};
    return names[self.languageID];
}

#pragma mark - Default error handle

+(NSString *) cerror:(NSString *)code va:(va_list)va
{
    NSString * des = LocalizedString(code);
    
    if ([des isEqualToString:code] == YES)
    {
        NSString *msg_code_common = [code stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:@"XX"];
        des = LocalizedString(msg_code_common);
        if ([des isEqualToString:msg_code_common] == YES)
        {
            return [NSString stringWithFormat:LocalizedString(@"unkown_msg_code_description"), code];
        }
    }
    
    //
    // Phai dung ham nay boi vi neu muon format ma argument theo vi tri %1$s ...
    // thi dung ham NSString format khong lay duoc theo vi tri, ma cu lay lan luot cacs tham
    // so truyen vao.
    //
    char *tmp = malloc(10000);
    tmp[0] = 0;
    const char *fmt = [des cStringUsingEncoding:NSUTF8StringEncoding];
    long l = vsnprintf(tmp, 10000, fmt, va);
    
    des = [[NSString alloc] initWithBytes:tmp length:l encoding:NSUTF8StringEncoding];
    free(tmp);
    
    return des;
}


#pragma mark - View hierarchy

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        loadingScreen = [[RoundAlert alloc] initWithFrame:CGRectMake(0 , 0, 230, 100)];
        [loadingScreen setMessage:AMLocalizedString(@"Please wait...!",nil)];
    }
    return self;
}

- (UILabel *)titleLabel
{
    LoadingTitleView *v = (LoadingTitleView *)self.navigationItem.titleView;
    return v.title_view;
}

- (LoadingTitleView *)title_view
{
    LoadingTitleView *v = (LoadingTitleView *)self.navigationItem.titleView;
    return v;
}

-(void)setTitle:(NSString *)title
{
    //    if (title && title.length > 1 && [[title substringToIndex:1] compare:@"@"] == NSOrderedSame)
    //    {
    //        title = title.localizableString;
    //    }
    //    LoadingTitleView *v = (LoadingTitleView *)self.navigationItem.titleView;
    //    if (v == nil)
    //    {
    //        v = [LoadingTitleView create];
    //        id x = self;
    //        v.delegate = x;
    //        self.navigationItem.titleView = v;
    //    }
    //    v.title = title;
    //    [v stop_loading];
}

- (void)add_transparent_baritem:(BOOL)right
{
    UIBarButtonItem *negativeSeperator = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
    negativeSeperator.width = -12;
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44, 44);
    button.backgroundColor = [UIColor clearColor];
    button.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    UIBarButtonItem *leftItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    
    if (right)
        self.navigationItem.rightBarButtonItems = @[negativeSeperator, leftItem];
    else
        self.navigationItem.leftBarButtonItems = @[negativeSeperator, leftItem];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    if (!self.mThongTinTaiKhoanVi) {
    if ([[DucNT_LuuRMS layThongTinTrongRMSTheoKey:KEY_LOGIN_STATE] boolValue] && !self.mThongTinTaiKhoanVi) {
        self.mThongTinTaiKhoanVi = [DucNT_LuuRMS layThongTinTaiKhoanVi];
    }
    //    }
    [self localizeViews];
    
#ifndef UIRectEdgeNone
#define UIRectEdgeNone 0
#endif
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    //
    //    [[UINavigationBar appearance] setBarTintColor:[UIColor redColor]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _enableBarButton = YES;
    //    [self initAutoLocalizeView];
    
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didRotate:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveRemoteNotification:)
                                                 name:UIApplicationLaunchOptionsRemoteNotificationKey
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadGiaoDien:)
                                                 name:ID_NOTIFICATION_RELOAD_GIAO_DIEN
                                               object:nil];
    //
    // Disable swipe back gesture in ios7
    //
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        UIGestureRecognizer *ges = [self.navigationController interactivePopGestureRecognizer];
        ges.enabled = NO;
    }
    
    if([self kiemTraCoChucNangQuetVanTay])
    {
        [self xuLyKhiCoChucNangQuetVanTay];
        if (self.enableFaceID) {
            [self xuLyKhiCoChucNangFaceID];
        }
    }
    else
    {
        [self xuLyKhiKhongCoChucNangQuetVanTay];
    }
}
#pragma mark - vantay

- (void)xuLyKhiCoChucNangQuetVanTay
{
    
}

- (void)xuLyKhiKhongCoChucNangQuetVanTay
{
    
}

- (BOOL)kiemTraCoChucNangQuetVanTay
{
    NSLog(@"%s - START", __FUNCTION__);
    LAContext *laContext = [[[LAContext alloc] init] autorelease];
    NSError *error = nil;
    if([laContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
    {
        if (error != NULL) {
            NSLog(@"%s - error : %@", __FUNCTION__, error.description);
        } else {
            NSLog(@"%s - error == nil", __FUNCTION__);
            if (@available(iOS 11.0, *)) {
                if (laContext.biometryType == LABiometryTypeFaceID) {
                    //localizedReason = "Unlock using Face ID"
                    self.enableFaceID = YES;
                    return YES;
                } else if (laContext.biometryType == LABiometryTypeTouchID) {
                    //localizedReason = "Unlock using Touch ID"
                    self.enableFaceID = NO;
                    return YES;
                } else {
                    //localizedReason = "Unlock using Application Passcode"
                    self.enableFaceID = YES;
                    return NO;
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
    self.enableFaceID = NO;
    return NO;
}

- (void)xuLySuKienHienThiChucNangDangNhapVanTayVoiTieuDe:(NSString*)sTieuDe
{
    LAContext *laContext = [[[LAContext alloc] init] autorelease];
    NSError *error = nil;
    __block BaseScreen *weakSelf = self;
    [RoundAlert show];
    
    if([laContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
    {
        if (error != NULL) {
            // handle error
        } else {
            
            if (@available(iOS 11.0.1, *)) {
                if (laContext.biometryType == LABiometryTypeFaceID) {
                    //localizedReason = "Unlock using Face ID"
                    NSLog(@"FaceId support");
                } else if (laContext.biometryType == LABiometryTypeTouchID) {
                    //localizedReason = "Unlock using Touch ID"
                    NSLog(@"TouchId support");
                } else {
                    //localizedReason = "Unlock using Application Passcode"
                    NSLog(@"No Biometric support");
                }
            } else {
                // Fallback on earlier versions
            }
            
            
            [laContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:sTieuDe reply:^(BOOL success, NSError * _Nullable error) {
                
                if (error != NULL) {
                    // handle error
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [RoundAlert hide];
                        if(error.code == LAErrorAuthenticationFailed) {
                            [weakSelf hienThiThongBaoDienMatKhau];
                        } else if (error.code == LAErrorUserCancel) {
                            [weakSelf huyXacThucVanTay];
                        }
                    });
                } else if (success) {
                    // handle success response
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self xuLySuKienXacThucVanTayThanhCong];
                    });
                } else {
                    // handle false response
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [RoundAlert hide];
                    });
                }
            }];
        }
    }
}

- (void)xuLySuKienHienThiChucNangVanTayVoiTieuDe:(NSString*)sTieuDe
{
    [self.view endEditing:YES];
    if([DucNT_Token daTonTaiMatKhauVanTay])
    {
        NSLog(@"%s - START 1", __FUNCTION__);
        LAContext *context = [[[LAContext alloc] init] autorelease];
        NSError *err = nil;
        if (@available(iOS 11.0, *)) {
            [context setLocalizedCancelTitle:@"Sử dụng xác thực khác"];
            if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&err]) {
                if (err != NULL) {
                    NSLog(@"%s - error : %@", __FUNCTION__, err.description);
                } else {
                    if (context.biometryType == LABiometryTypeFaceID) {
                        NSLog(@"%s - ho tro face id", __FUNCTION__);
                    }
                    else if (context.biometryType == LABiometryTypeTouchID) {
                        NSLog(@"%s - ho tro touch id", __FUNCTION__);
                    } else {
                        NSLog(@"%s - khong ho tro gi ca", __FUNCTION__);
                    }
                    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:sTieuDe reply:^(BOOL success, NSError * _Nullable error) {
                        if (error != NULL) {
                            NSLog(@"%s - error : %@", __FUNCTION__, error.description);
                            if (error.code == LAErrorUserCancel) {
                                [self updateXacThucKhac];
                            }
                        } else if (success) {
                            NSLog(@"%s - xac thuc thanh cong", __FUNCTION__);
                            [self xuLySuKienXacThucVanTayThanhCong];
                        } else {
                            NSLog(@"%s - handle false response", __FUNCTION__);
                            // handle false response
                        }
                    }];
                }
                
            }
        } else {
            if([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&err])
            {
                NSLog(@"%s - START 2", __FUNCTION__);
                __block BaseScreen *weakSelf = self;
    //            [RoundAlert show];
                [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                        localizedReason:sTieuDe
                                  reply:^(BOOL success, NSError *error)
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{

                         if (error) {
                             switch (error.code) {
                                 case LAErrorUserCancel:
                                     NSLog(@"info:%@: %@, LAErrorUserCancel", NSStringFromClass([self class]),NSStringFromSelector(_cmd));
                                     [weakSelf updateXacThucKhac];
                                     break;
                                 case LAErrorAuthenticationFailed:
                                     NSLog(@"info:%@: %@, LAErrorAuthenticationFailed", NSStringFromClass([self class]),NSStringFromSelector(_cmd));
                                     [weakSelf hienThiThongBaoDienMatKhau];
                                     break;
                                 case LAErrorPasscodeNotSet:
                                     NSLog(@"info:%@: %@, LAErrorPasscodeNotSet", NSStringFromClass([self class]),NSStringFromSelector(_cmd));
                                     break;
                                 case LAErrorUserFallback:
                                     NSLog(@"info:%@: %@, LAErrorUserFallback", NSStringFromClass([self class]),NSStringFromSelector(_cmd));
                                     break;
                                 default:
                                     break;
                             }
    //                         [RoundAlert hide];
                             return;
                         }
                         if(success)
                         {
                             NSLog(@"%s - xac thuc van tay thanh cong", __FUNCTION__);
                             [self xuLySuKienXacThucVanTayThanhCong];
                         }
                     });
                 }];
            }
        }
    }
    else
    {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:[@"thong_bao_chua_co_xac_thuc_van_tay_token" localizableString]];
    }
}

- (void)hienThiThongBaoDienMatKhau
{
    
}

- (void)xuLySuKienXacThucVanTayThanhCong
{
    
}
- (void)huyXacThucVanTay {
    
}
#pragma mark - su kien nhan notification
-(void)didReceiveRemoteNotification:(NSDictionary *)Info
{
    NSLog(@"%s - START", __FUNCTION__);
}

#pragma mark - suKienReloadGiaoDien
- (void)reloadGiaoDien:(NSNotification *)notification
{
    
}

#pragma mark - hienThiHopThoai
- (void)hienThiHopThoaiHaiNutBamKieu:(int)nKieu cauThongBao:(NSString*)sCauThongBao
{
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:[@"thong_bao" localizableString] message:sCauThongBao delegate:self cancelButtonTitle:[@"huy" localizableString] otherButtonTitles:[@"dong_y" localizableString], nil] autorelease];
    alertView.tag = nKieu;
    [alertView show];
}

- (void)hienThiHopThoaiMotNutBamKieu:(int)nKieu cauThongBao:(NSString*)sCauThongBao
{
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:[@"thong_bao" localizableString] message:sCauThongBao delegate:self cancelButtonTitle:[@"dong" localizableString] otherButtonTitles:nil, nil] autorelease];
    alertView.tag = nKieu;
    [alertView show];
}

#pragma mark - DEALLOC

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

/**
 * for : SET HIDDEN status bar for IOS 7
 **/
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

-(void)hideStatusBar
{
    //    if ([UIApplication sharedApplication].statusBarHidden == NO)
    //    {
    //        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
    //            // iOS 7
    //            statusBar_hidden = YES;
    //            [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    //        } else {
    //            // iOS 6
    //            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    //        }
    //
    //        CGRect status_frame = app.navigationController.navigationBar.frame;
    //        status_frame.origin = CGPointZero;
    //        app.navigationController.navigationBar.frame = status_frame;
    //    }
}

-(void)showStatusBar
{
    //    if ([UIApplication sharedApplication].statusBarHidden == YES)
    //    {
    //        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
    //            // iOS 7
    //            statusBar_hidden = NO;
    //            [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    //        } else {
    //            // iOS 6
    //            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    //        }
    //        CGRect status_frame = app.navigationController.navigationBar.frame;
    //        status_frame.origin = CGPointMake(0, 20);
    //        //        status_frame.size.height -= 20;
    //        app.navigationController.navigationBar.frame = status_frame;
    //    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationLaunchOptionsRemoteNotificationKey
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ID_NOTIFICATION_RELOAD_GIAO_DIEN
                                                  object:nil];
    if(_mThongTinTaiKhoanVi)
        [_mThongTinTaiKhoanVi release];
    
    self.viewToText = nil;
    self.security_questions = nil;
    
    if(loadingScreen)
        [loadingScreen release];
    NSLog(@"dealloc %@", NSStringFromClass(self.class));
    [super dealloc];
    //    NSLog(@"end dealloc %@", NSStringFromClass(self.class));
}

@synthesize viewToText;
@synthesize security_questions = security_questions;

@end
