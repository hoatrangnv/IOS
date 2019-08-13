//
//  GiaoDienDangNhapMoi.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 9/1/16.
//
//

#import "GiaoDichViewController.h"
#import "DucNT_ServicePost.h"
#import "DucNT_RegisterViewViewController.h"
#import "DucNT_LuuRMS.h"
#import "ExTextField.h"
#import "Common.h"
#import "FixIOS7StatusBarRootView.h"

@interface GiaoDienDangNhapMoi : GiaoDichViewController<DucNT_ServicePostDelegate, UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UIView *mViewChuaNutLuaChonVi;
@property (retain, nonatomic) IBOutlet UIView *viewDangNhap;
@property (retain, nonatomic) IBOutlet UIButton *mbtnViCaNhan;
@property (retain, nonatomic) IBOutlet UIButton *mbtnViDoanhNghiep;
@property (retain, nonatomic) IBOutlet ExTextField *edtMainInfo;
@property (retain, nonatomic) IBOutlet ExTextField *edtPass;
@property (retain, nonatomic) IBOutlet UIButton *btnLuuMatKhau;
@property (retain, nonatomic) IBOutlet UIButton *btnDangNhap;
@property (retain, nonatomic) IBOutlet UIButton *btnQuenMatKhau;
@property (retain, nonatomic) IBOutlet UIButton *btnDangKy;
@property (retain, nonatomic) IBOutlet UIView *viewChuaButton;
@property (retain, nonatomic) IBOutlet UIButton *mbtnDangNhapGoogle;
@property (retain, nonatomic) IBOutlet ExTextField *mtfMaDoanhNghiep;
@property (retain, nonatomic) IBOutlet UIButton *mbtnDangNhapBangVanTay;

- (IBAction)suKienChonViCaNhan:(id)sender;
- (IBAction)suKienChonViDoanhNghiep:(id)sender;
- (IBAction)suKienLuuMatKhau:(id)sender;
- (IBAction)suKienDangNhap:(id)sender;
- (IBAction)suKienQuenMatKhau:(id)sender;
- (IBAction)suKienDangKy:(id)sender;
- (IBAction)suKienDangNhapBangFacebook:(UIButton *)sender;
- (IBAction)suKienDangNhapBangGoogle:(UIButton *)sender;
- (IBAction)suKienBamNutHuongDan:(id)sender;
@end
