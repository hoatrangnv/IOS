//
//  DucNT_ChuyenTienDenTaiKhoanViewController.h
//  ViMASS
//
//  Created by MacBookPro on 7/30/14.
//
//

#import "GiaoDichViewController.h"
#import "DucNT_ServicePost.h"
#import "ExTextField.h"
#import "DucNT_TaiKhoanThuongDungObject.h"
#import "UmiTextView.h"
#import "TPKeyboardAvoidAcessory.h"

@interface DucNT_ChuyenTienDenTaiKhoanViewController : GiaoDichViewController

@property (retain, nonatomic) IBOutlet ExTextField *edtNganHang;
@property (retain, nonatomic) IBOutlet ExTextField *edtTenChuTaiKhoan;
@property (retain, nonatomic) IBOutlet ExTextField *edtSoTaiKhoan;
@property (retain, nonatomic) IBOutlet ExTextField *edtSoTien;
@property (retain, nonatomic) IBOutlet ExTextField *mtfChiNhanh;
@property (retain, nonatomic) IBOutlet ExTextField *mtfChiNhanhKhac;
@property (retain, nonatomic) IBOutlet UmiTextView *tvNoiDung;
@property (retain, nonatomic) IBOutlet UIButton *btnLuuTaiKhoanThuongDung;

@property (retain, nonatomic) IBOutlet ExTextField *mtfPhiGiaoDich;
//@property (retain, nonatomic) IBOutlet UILabel *mlblPhi;
@property (retain, nonatomic) IBOutlet UIView *viewThongTin;
@property (retain, nonatomic) IBOutlet UIView *viewToken;
@property (retain, nonatomic) IBOutlet UIView *viewButtonOption;
@property (retain, nonatomic) IBOutlet ExTextField *mtfNoiDug;
@property (retain, nonatomic) IBOutlet TPKeyboardAvoidAcessory *scrMain;

@property (retain, nonatomic) IBOutlet UIView *viewTaiKhoan;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *heightViewMain;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *heightChiNhanh;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *heightChiNhanhKhac;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *topSpaceTenChuTaiKhoan;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *heightViewThongTin;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *topChiNhanhKhac;


- (IBAction)suKienLuuTaiKhoanThuongDung:(id)sender;
- (IBAction)suKienLayDanhSachThuongDung:(id)sender;


@property (retain, nonatomic) NSArray *mDanhSachNganHang;
@property (retain, nonatomic) DucNT_TaiKhoanThuongDungObject *mTaiKhoanThuongDung;

@end
