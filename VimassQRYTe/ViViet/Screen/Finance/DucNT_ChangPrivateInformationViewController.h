//
//  DucNT_ChangPrivateInformationViewController.h
//  ViMASS
//
//  Created by MacBookPro on 7/16/14.
//
//

#import "GiaoDichViewController.h"
#import "ExTextField.h"
#import "DucNT_ServicePost.h"
#import "DucNT_ViewDatePicker.h"
#import "TPKeyboardAvoidAcessory.h"
#import "UmiTextVIew.h"

enum{
    TRANG_THAI_UP_DU_LIEU_THONG_TIN = 1,
    TRANG_THAI_UP_DU_LIEU_ANH = 2,
    TRANG_THAI_KET_NOI_LAY_MA_XAC_THUC = 3,
    TRANG_THAI_KET_NOI_CAP_NHAT_THONG_TIN = 4,
};

@interface DucNT_ChangPrivateInformationViewController : GiaoDichViewController<UIImagePickerControllerDelegate, DucNT_ServicePostDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (retain, nonatomic) IBOutlet UILabel *mlblTaiKhoan;
@property (retain, nonatomic) IBOutlet UILabel *mlblSoDienThoaiNhanMaXacThuc;
@property (retain, nonatomic) IBOutlet UILabel *mlblThuDienTuNhanMaXacThuc;
@property (retain, nonatomic) IBOutlet UILabel *mlblTenHienThi;
@property (retain, nonatomic) IBOutlet UILabel *mlblTenTrongCMND;
@property (retain, nonatomic) IBOutlet UILabel *mlblNgaySinh;
@property (retain, nonatomic) IBOutlet UILabel *mlblSoCMND;
@property (retain, nonatomic) IBOutlet UILabel *mlblNgayCap;
@property (retain, nonatomic) IBOutlet UILabel *mlblNoiCap;
@property (retain, nonatomic) IBOutlet UILabel *mlblNoiThuongTru;
@property (retain, nonatomic) IBOutlet UILabel *mlblAnhDaiDien;
@property (retain, nonatomic) IBOutlet UILabel *mlblAnhMatTruocCMND;
@property (retain, nonatomic) IBOutlet UILabel *mlblAnhMatSauCMND;
@property (retain, nonatomic) IBOutlet UILabel *mlblAnhChuKy;
@property (retain, nonatomic) IBOutlet ExTextField *edBank;
@property (retain, nonatomic) IBOutlet ExTextField *edSoTaiKhoanBank;
@property (retain, nonatomic) IBOutlet ExTextField *edChiNhanh;
@property (retain, nonatomic) IBOutlet UILabel *lblChiNhanh;
@property (retain, nonatomic) IBOutlet ExTextField *edChuTaiKhoan;


@property (retain, nonatomic) IBOutlet TPKeyboardAvoidAcessory *scrollView;
@property (retain, nonatomic) IBOutlet UIView *viewMain;
@property (retain, nonatomic) IBOutlet UIView *mViewToken;
@property (retain, nonatomic) IBOutlet UIView *mViewThongTIn;
@property (retain, nonatomic) IBOutlet UIView *mViewThoiGianConLai;

@property (retain, nonatomic) IBOutlet ExTextField *edtThuDienTu;
@property (retain, nonatomic) IBOutlet ExTextField *edtNgaySinh;

@property (retain, nonatomic) IBOutlet ExTextField *edtSoCMND;
@property (retain, nonatomic) IBOutlet ExTextField *edtNgayCapCMND;
@property (retain, nonatomic) IBOutlet ExTextField *edtNoiCapCMND;
@property (retain, nonatomic) IBOutlet ExTextField *edtDiaChiNha;
@property (retain, nonatomic) IBOutlet UmiTextView *tvDiaChiNha;
//HOANHNV UPDATE
@property (retain, nonatomic) IBOutlet ExTextField *edtVilienket1;
@property (retain, nonatomic) IBOutlet ExTextField *edtVilienket2;
@property (retain, nonatomic) IBOutlet ExTextField *edtVilienket3;
@property (retain, nonatomic) IBOutlet ExTextField *edtVilienket4;
@property (retain, nonatomic) IBOutlet ExTextField *edtVilienket5;

@property (retain, nonatomic) IBOutlet UIButton *btnChupAnhMatTruocCMND;
@property (retain, nonatomic) IBOutlet UIButton *btnLayAnhMatTruocCMND;
@property (retain, nonatomic) IBOutlet UIImageView *imvMatTruocCMND;
- (IBAction)suKienChupAnhMatTruocCMND:(id)sender;
- (IBAction)suKienLayAnhMatTruocCMND:(id)sender;

@property (retain, nonatomic) IBOutlet UIButton *btnChupAnhMatSauCMND;
@property (retain, nonatomic) IBOutlet UIButton *btnLayAnhMatSauCMND;
@property (retain, nonatomic) IBOutlet UIImageView *imvAnhMatSauCMND;
- (IBAction)suKienChupAnhMatSauCMND:(id)sender;
- (IBAction)suKienLayAnhMatSauCMND:(id)sender;

@property (retain, nonatomic) IBOutlet UIButton *btnChupAnhChuKy;
@property (retain, nonatomic) IBOutlet UIButton *btnLayAnhChuKy;
@property (retain, nonatomic) IBOutlet UIImageView *imvAnhChuKy;
- (IBAction)suKienChupAnhChuKy:(id)sender;
- (IBAction)suKienLayAnhChuKy:(id)sender;

@property (retain, nonatomic) IBOutlet UIButton *mbtnXacThucBoiToken;
@property (retain, nonatomic) IBOutlet UIButton *mbtnXacThucBoiEmail;
@property (retain, nonatomic) IBOutlet UIButton *mbtnXacThucBoiSMS;
@property (retain, nonatomic) IBOutlet UILabel *mlblXacThucBoi;
@property (retain, nonatomic) IBOutlet UIButton *mbtnVanTay;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoDienThoaiNhanMaXacThuc;
@property (retain, nonatomic) IBOutlet UIImageView *imgvQRCode;
@property (retain, nonatomic) IBOutlet UISwitch *checkNoiDungQR;


@property (retain, nonatomic) IBOutlet UIButton *mbtnChupAnhDaiDien;
@property (retain, nonatomic) IBOutlet UIButton *mbtnLayAnhDaiDien;
@property (retain, nonatomic) IBOutlet UIImageView *mimgAnhDaiDien;

- (IBAction)suKienChupAnhDaiDien:(id)sender;
- (IBAction)suKienLayAnhDaiDien:(id)sender;


@property (retain, nonatomic) IBOutlet ExTextField *edtMatKhauToken;
@property (retain, nonatomic) IBOutlet UIButton *btnThucHien;
- (IBAction)suKienThucHien:(id)sender;
- (IBAction)suKienThayDoiTenCMND:(id)sender;
- (IBAction)suKienOnOffNoiDungQR:(id)sender;

@end
