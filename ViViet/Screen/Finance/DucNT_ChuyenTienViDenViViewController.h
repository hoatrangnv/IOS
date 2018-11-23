//
//  DucNT_ChuyenTienViDenViViewController.h
//  ViMASS
//
//  Created by MacBookPro on 7/8/14.
//
//

#import <UIKit/UIKit.h>
#import "BaseScreen.h"
#import "DucNT_Token.h"
#import "DucNT_LuuRMS.h"
#import "DucNT_ServicePost.h"
#import "ExTextField.h"
#import "UmiTextView.h"
#import "GiaoDichViewController.h"
#import "TPKeyboardAvoidAcessory.h"
#import "DucNT_TaiKhoanThuongDungObject.h"

@interface DucNT_ChuyenTienViDenViViewController : GiaoDichViewController

@property (retain, nonatomic) IBOutlet TPKeyboardAvoidAcessory *scrMain;
@property (retain, nonatomic) IBOutlet UIButton *mbtnLuuTaiKhoanThuongDung;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoVi;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoTien;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoPhi;
@property (retain, nonatomic) IBOutlet UmiTextView *mtvNoiDungGiaoDich;
@property (retain, nonatomic) IBOutlet ExTextField *mtfNoiDung;
@property (retain, nonatomic) DucNT_TaiKhoanThuongDungObject *mTaiKhoanThuongDung;
@property (retain, nonatomic) IBOutlet UIImageView *imgvQRCode;
@property (retain, nonatomic) IBOutlet UIImageView *imgvAvatar;
@property (retain, nonatomic) IBOutlet UILabel *lblTenChuVi;
@property (retain, nonatomic) IBOutlet UISwitch *switchHienSoVi;
@property (retain, nonatomic) IBOutlet UIView *viewVi;
@property (retain, nonatomic) IBOutlet UIWebView *webTaiKhoan;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *heightViewMain;
@property (retain, nonatomic) IBOutlet UIView *viewQR;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *heightContentView;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *heightViewQR;

- (IBAction)suKienThayDoiViChuyenDen:(id)sender;
- (IBAction)suKienChonTab1:(id)sender;
- (IBAction)suKienChonTab2:(id)sender;
- (IBAction)suKienChonTab3:(id)sender;

@end
