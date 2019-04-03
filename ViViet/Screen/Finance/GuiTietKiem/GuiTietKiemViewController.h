//
//  GuiTietKiemViewController.h
//  ViViMASS
//
//  Created by DucBui on 5/13/15.
//
//

#import "GiaoDichViewController.h"
#import "TPKeyboardAvoidAcessory.h"
#import "UmiTextView.h"

@interface GuiTietKiemViewController : GiaoDichViewController
@property (retain, nonatomic) IBOutlet TPKeyboardAvoidAcessory *mScrvHienThi;
@property (retain, nonatomic) IBOutlet ExTextField *mtfNganHangGui;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoTien;
@property (retain, nonatomic) IBOutlet ExTextField *mtfKyHanGui;
@property (retain, nonatomic) IBOutlet ExTextField *mtfKyLinhLai;
@property (retain, nonatomic) IBOutlet ExTextField *mtfCachThucQuayVong;
@property (retain, nonatomic) IBOutlet UILabel *mlblLaiSuat;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoCMND;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoPhi;
@property (retain, nonatomic) IBOutlet UILabel *mlblTienLai;
@property (retain, nonatomic) IBOutlet ExTextField *mtfTenNguoiGui;
@property (retain, nonatomic) IBOutlet ExTextField *mtfDiaChi;
@property (retain, nonatomic) IBOutlet UmiTextView *mtvDiaChi;
@property (retain, nonatomic) IBOutlet ExTextField *mtfNhanGocVaLaiVe;
@property (retain, nonatomic) IBOutlet UIView *mVIewNhanGocVaLaiVe;
@property (retain, nonatomic) IBOutlet UIView *mViewThoiGianConLai;
@property (retain, nonatomic) IBOutlet UILabel *lblNhanTienVe;

//Ngan hang nhan tien
@property (retain, nonatomic) IBOutlet UIView *mViewChonNganHangNhanTienGocVaLaiTietKiem;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoTaiKhoanRutTienVe;
@property (retain, nonatomic) IBOutlet ExTextField *mtfTenChuTaiKhoan;
@property (retain, nonatomic) IBOutlet ExTextField *mtfNganHangRutTienVe;

//The
@property (retain, nonatomic) IBOutlet UIView *mViewRutGocVaLaiVeThe;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoThe;
@property (retain, nonatomic) IBOutlet UILabel *lblNganHangNhanTien;
@property (retain, nonatomic) IBOutlet UILabel *lblSoTaiKhoan;
@property (retain, nonatomic) IBOutlet UILabel *lblChuTaiKhoan;
@property (retain, nonatomic) IBOutlet UILabel *lblPhiChuyenKhoan;
@property (retain, nonatomic) IBOutlet UILabel *lblSoThe;
@property (retain, nonatomic) IBOutlet UILabel *lblPhiChuyenKhoanThe;


@property (retain, nonatomic) IBOutlet UIButton *mbtnGuiTK;
@property (retain, nonatomic) IBOutlet UIButton *mbtnTraCuu;
@property (retain, nonatomic) IBOutlet UIButton *mbtnLaiSuat;
@property (retain, nonatomic) IBOutlet UIButton *mbtnThuongDung;
@property (retain, nonatomic) IBOutlet UIButton *btnSoTayTkBank;
@property (retain, nonatomic) IBOutlet UIButton *btnSoTayThe;

@property (retain, nonatomic) IBOutlet UIView *viewAddThem;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *heightViewAddThem;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *heightViewMain;
- (IBAction)suKienBamNutSoTayThuongDung:(id)sender;
- (IBAction)suKienBamNutHuongDan:(id)sender;

@end
