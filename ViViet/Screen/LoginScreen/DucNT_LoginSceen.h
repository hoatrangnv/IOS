//
//  DucNT_LoginSceen.h
//  ViMASS
//
//  Created by MacBookPro on 7/5/14.
//
//

#import <UIKit/UIKit.h>
#import "GiaoDichViewController.h"
#import "DucNT_ServicePost.h"
#import "DucNT_RegisterViewViewController.h"
#import "DucNT_LuuRMS.h"
#import "ExTextField.h"
#import "Common.h"
#import "FixIOS7StatusBarRootView.h"
#import "DucNT_ForgotPassAccViewController.h"
#import "DucNT_RegisterViewViewController.h"
@interface DucNT_LoginSceen : GiaoDichViewController <DucNT_ServicePostDelegate, UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UIImageView *imgVimass;
@property (retain, nonatomic) IBOutlet UIView *viewDangNhap;
@property (retain, nonatomic) IBOutlet ExTextField *edtMainInfo;
@property (retain, nonatomic) IBOutlet ExTextField *edtPass;
@property (retain, nonatomic) IBOutlet UIButton *btnDangNhap;
@property (retain, nonatomic) IBOutlet UIButton *btnQuenMatKhau;
@property (retain, nonatomic) IBOutlet UIButton *btnDangKy;
@property (retain, nonatomic) IBOutlet UIButton *btnBack;
@property (retain, nonatomic) IBOutlet UILabel *lbTitle;
@property (retain, nonatomic) IBOutlet UITextView *txtGiayPhep;

@property (retain, nonatomic) IBOutlet UIButton *mbtnDangNhapFacebook;
@property (retain, nonatomic) IBOutlet UIButton *mbtnDangNhapGoogle;
@property (retain, nonatomic) IBOutlet ExTextField *mtfMaDoanhNghiep;
//@property (retain, nonatomic) IBOutlet UIView *mViewDangNhapThuong;
@property (retain, nonatomic) IBOutlet TPKeyboardAvoidAcessory *mscrvHienThi;
@property (retain, nonatomic) IBOutlet UIView *mViewCaNhan;
@property (retain, nonatomic) IBOutlet UISegmentedControl *mSegment;
@property (retain, nonatomic) IBOutlet UIButton *mbtnViCaNhan;
@property (retain, nonatomic) IBOutlet UIButton *mbtnViDoanhNghiep;
@property (retain, nonatomic) IBOutlet UIView *mViewChuaNutLuaChonVi;
@property (retain, nonatomic) IBOutlet UIButton *btnTaoDoanhNghiep;
@property (retain, nonatomic) IBOutlet UIView *viewChuaButton;
@property (retain, nonatomic) IBOutlet UIButton *mbtnDangNhapBangVanTay;

- (IBAction)suKienLuuMatKhau:(id)sender;
- (IBAction)suKienDangNhap:(id)sender;
- (IBAction)suKienQuenMatKhau:(id)sender;
- (IBAction)suKienDangKy:(id)sender;
- (IBAction)suKienBack:(id)sender;
- (IBAction)suKienDangNhapBangFacebook:(UIButton *)sender;
- (IBAction)suKienDangNhapBangGoogle:(UIButton *)sender;
- (IBAction)suKienChonTaoDoanhNghep:(id)sender;
- (IBAction)suKienBamNutHuongDan:(id)sender;
- (IBAction)suKienChonXemGiayPhep:(id)sender;


@property (retain, nonatomic) NSString *sTenViewController;
@property (retain, nonatomic) NSString *sKieuChuyenGiaoDien;
@end
