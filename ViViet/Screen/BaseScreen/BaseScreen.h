//
//  BaseScreen.h
//  CameraUploadApp
//
//  Created by Ngo Ba Thuong on December 16, 2012
//  Copyright (c) 2012 Vi Viet Corp. All rights reserved.
//

#import "Drawer.h"
#import "RoundAlert.h"
#import "DucNT_Token.h"
#import "AppDelegate.h"
#import "DucNT_LuuRMS.h"
#import "DDAlertPrompt.h"
#import "LoadingTitleView.h"
#import "DucNT_TaiKhoanViObject.h"
#import "UIViewController+Common.h"
#import "UIImageView+WebCache.h"
#import "Common.h"
#import <LocalAuthentication/LocalAuthentication.h>



#define ID_NOTIFICATION_RELOAD_GIAO_DIEN @"ID_NOTIFICATION_RELOAD_GIAO_DIEN"
@class AppDelegate;

@interface BaseScreen : UIViewController<UIAlertViewDelegate>
{   
    AppDelegate *app;
    RoundAlert * loadingScreen;
    void (^_createBlock)(BaseScreen *controller);
    NSMutableArray *security_questions;

    void (^oncreate_callback)(BaseScreen *view_controller);
}
@property (nonatomic, retain) DucNT_TaiKhoanViObject *mThongTinTaiKhoanVi;

+ (AppDelegate *)app;

+ (void)create_with_params:(NSDictionary *)params
                  oncreate:(void (^)(BaseScreen *view_controller))oncreate_callback;

+ (void)create:(void (^)(BaseScreen *controller)) oncreate
   privateInfo:(NSDictionary*) privateInfo;

- (void)select_security_question:(void (^)(NSString *ID, NSString *question))callback;

- (void)getAuthMethod:(void (^)(NSString *authMethod))callback;
- (void)confirm_OTP:(void (^)(NSString *errcode))callback;

- (void) promptWithTitle:(NSString *)title
                  andTag:(int)tag
         andKeyboardType:(UIKeyboardType)kbType
        withSecuredField:(BOOL)secured;

- (void) promptWithTitle:(NSString *)title
         andKeyboardType:(UIKeyboardType)kbType
        withSecuredField:(BOOL)secured
                   block:(AlertBlock) block;
- (void)addDefauleBarButton;
- (void)addHomeBarButton;

- (void) addButtonCateLeft;
- (void) addSettingButtonAtSide:(int)side;
- (void) show_vitoken_button:(BOOL)show;
- (void) addSettingButton;
- (void) didSelectExitButton;
- (void) logout:(BOOL) popToRoot;
- (void) addButtonBack;
- (void)didSelectCateLeft;
- (void)didSelectSetting;
- (void) addButton:(NSString*)imageNamed selector:(SEL)selector atSide:(int)side;

- (void) reloadLaguage:(NSString*) laguage;
- (void)add_transparent_baritem:(BOOL)right;


- (void)reloadGiaoDien:(NSNotification *)notification;
- (void)didReceiveRemoteNotification:(NSDictionary *)Info;
- (void) showLoadingScreen;
- (void) hideLoadingScreen;
- (UILabel *)titleLabel;

- (void)hienThiHopThoaiHaiNutBamKieu:(int)nKieu cauThongBao:(NSString*)sCauThongBao;
- (void)hienThiHopThoaiMotNutBamKieu:(int)nKieu cauThongBao:(NSString*)sCauThongBao;

#pragma mark - VanTay
- (BOOL)kiemTraCoChucNangQuetVanTay;
- (void)xuLyKhiCoChucNangQuetVanTay;
- (void)xuLyKhiCoChucNangFaceID;
- (void)hienThiThongBaoDienMatKhau;
- (void)xuLyKhiKhongCoChucNangQuetVanTay;
- (void)xuLySuKienHienThiChucNangVanTayVoiTieuDe:(NSString*)sTieuDe;
- (void)xuLySuKienHienThiChucNangDangNhapVanTayVoiTieuDe:(NSString*)sTieuDe;
- (void)xuLySuKienXacThucVanTayThanhCong;
- (void)huyXacThucVanTay;

//@property (nonatomic, readonly) LoadingTitleView *title_view;

//
// Kiem tra vai loi co ban trong tai chinh
// Khi tra ve YES nghia la ma loi da dc xu ly.
//

#define kCheckFinancialErrorInfoKey_Receiver @"rec"
#define kCheckFinancialErrorInfoKey_Account @"rec"

//
// Kiem tra xem co loi xay ra khong. Neu co loi can su dung thong tin them de hien thi ra
// message box, truyen vao bien "info" duoi dang mang voi key duoc dinh nghia o tren
// Co the truyen vao danh sach cac ma code tu xu ly.
//
//- (BOOL)check_error:(Msg *)msg on_dismiss:(void (^)(void))on_dismiss, ...;
//+ (BOOL)check_error:(Msg *)msg on_dismiss:(void (^)(void))on_dismiss, ...;
//- (BOOL)is_financial_error:(NSString *)code, ...;
@property (nonatomic, retain) NSMutableArray *security_questions;
//
// Current language: 0: vi; 1: en;
//
@property (nonatomic, readonly) int languageID;
@property (nonatomic, readonly) NSString *languageName;

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL enableBarButton;
@property (nonatomic, assign) BOOL enableFaceID;
@property (nonatomic, retain) NSMutableArray *viewToText;
+(void) drawerTouchEnableOrDisable:(BOOL) enable;
- (void) didRotate:(NSNotification *)notification;
- (void) hideStatusBar;
- (void) showStatusBar;

@end
