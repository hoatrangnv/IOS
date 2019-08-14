//
//  NapViTuTheNganHangViewController.h
//  ViViMASS
//
//  Created by DucBui on 4/20/15.
//
//

#import "GiaoDichViewController.h"
#import "ExTextField.h"
#import "UmiTextView.h"
#import "RadioButton/RadioButton.h"
#import "DucNT_LoginSceen.h"

@interface NapViTuTheNganHangViewController : GiaoDichViewController

@property (retain, nonatomic) IBOutlet UIScrollView *mScrv;
//@property (retain, nonatomic) IBOutlet UIView *mViewMain;
@property (retain, nonatomic) IBOutlet UIButton *mbtnTiepTuc;
@property (retain, nonatomic) IBOutlet UIWebView *webTaiKhoan;

//View thong tin buoc 1
@property (retain, nonatomic) IBOutlet UIView *mViewThongTinBuoc1;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoViCanNapTien;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoTien;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoPhi;
@property (retain, nonatomic) IBOutlet UmiTextView *mtvNoiDung;
@property (retain, nonatomic) IBOutlet ExTextField *mtfNoiDung;
@property (retain, nonatomic) IBOutlet ExTextField *mtfChonNganHang;
@property (retain, nonatomic) IBOutlet UIButton *mbtnDanhBaViCanNap;
@property (retain, nonatomic) IBOutlet UIButton *btnSoLuuDirect;
@property (retain, nonatomic) IBOutlet UIButton *btnSoTayNoiDia;


//View thong tin buoc 2
@property (retain, nonatomic) IBOutlet UIView *mViewThongTinBuoc2;
@property (retain, nonatomic) IBOutlet UIView *mViewChuaNutDanhBaVaThuongDung;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoThe;
@property (retain, nonatomic) IBOutlet ExTextField *mtfTenChuThe;
@property (retain, nonatomic) IBOutlet ExTextField *mtfNamMoThe;
@property (retain, nonatomic) IBOutlet ExTextField *mtfThangMoThe;
@property (retain, nonatomic) IBOutlet RadioButton *mbtnChonMaXacThucNhanQuaSMS;
@property (retain, nonatomic) IBOutlet RadioButton *mbtnChonMaXacThucSuDungToken;

//View xac nhan otp
@property (retain, nonatomic) IBOutlet UIView *mViewXacNhanOtp;
@property (retain, nonatomic) IBOutlet UIView *mViewChuaThongBao;
@property (retain, nonatomic) IBOutlet ExTextField *mtfXacNhan;

@property (retain, nonatomic) IBOutlet UIView *viewTop;
@property (retain, nonatomic) IBOutlet UIButton *btnTheNoiDia;
@property (retain, nonatomic) IBOutlet UIButton *btnTheQuocTe;
@property (retain, nonatomic) IBOutlet UIButton *btnTheCao;
@property (retain, nonatomic) IBOutlet UIButton *btnTheLienKet;

//View the quoc te
@property (retain, nonatomic) IBOutlet UIView *viewQuocTe;
@property (retain, nonatomic) IBOutlet UIView *viewQuocTe2;
@property (retain, nonatomic) IBOutlet ExTextField *edViCanNapQT;
@property (retain, nonatomic) IBOutlet ExTextField *edLoaiThe;
@property (retain, nonatomic) IBOutlet ExTextField *edSoThe;
@property (retain, nonatomic) IBOutlet ExTextField *edSoTienQT;
@property (retain, nonatomic) IBOutlet UILabel *lblPhiQT;
@property (retain, nonatomic) IBOutlet ExTextField *edNoiDungQT;
@property (retain, nonatomic) IBOutlet UmiTextView *tvNoiDungQT;
@property (retain, nonatomic) IBOutlet UIButton *btnSoLuuQT;

//@property (retain, nonatomic) IBOutlet ExTextField *edDiaChiQT;
//@property (retain, nonatomic) IBOutlet UmiTextView *tvDiaChiQT;
@property (retain, nonatomic) IBOutlet ExTextField *edCVV;
@property (retain, nonatomic) IBOutlet ExTextField *edThang;
@property (retain, nonatomic) IBOutlet ExTextField *edNam;
@property (retain, nonatomic) IBOutlet ExTextField *edHo;
//@property (retain, nonatomic) IBOutlet ExTextField *edTen;
//@property (retain, nonatomic) IBOutlet ExTextField *edThanhPho;
//@property (retain, nonatomic) IBOutlet ExTextField *edQuocGia;
//@property (retain, nonatomic) IBOutlet ExTextField *edMaBuuChinh;
//@property (retain, nonatomic) IBOutlet ExTextField *edSDTQT;
//@property (retain, nonatomic) IBOutlet ExTextField *edEmailQT;

//view nap the cao
@property (retain, nonatomic) IBOutlet UIView *viewNapTheCao;
@property (retain, nonatomic) IBOutlet ExTextField *edViTheCao;
@property (retain, nonatomic) IBOutlet ExTextField *edLoaiTheCao;
@property (retain, nonatomic) IBOutlet ExTextField *edSoSerial;
@property (retain, nonatomic) IBOutlet ExTextField *edMaThe;
@property (retain, nonatomic) IBOutlet ExTextField *edNoiDungTheCao;
@property (retain, nonatomic) IBOutlet UILabel *lblPhiTheCao;
@property (retain, nonatomic) IBOutlet UIButton *btnGuiXacNhan;

//view top
@property (retain, nonatomic) IBOutlet UILabel *lblTheNoiDia;
@property (retain, nonatomic) IBOutlet UILabel *lblTheQuocTe;
@property (retain, nonatomic) IBOutlet UIButton *btnTheLuu;

//view the luu
@property (retain, nonatomic) IBOutlet UIView *viewTheLuu;
@property (retain, nonatomic) IBOutlet ExTextField *edViCanNapTheLuu;
@property (retain, nonatomic) IBOutlet ExTextField *edSoTienTheLuu;
@property (retain, nonatomic) IBOutlet ExTextField *edNoiDungTheLuu;
@property (retain, nonatomic) IBOutlet ExTextField *edChonTheTheLuu;
@property (retain, nonatomic) IBOutlet UIView *viewCVV;
@property (retain, nonatomic) IBOutlet ExTextField *edCVVTheLuu;
@property (retain, nonatomic) IBOutlet UmiTextView *tvNoiDungTheLuu;
@property (retain, nonatomic) IBOutlet UIView *viewLoading;
@property (retain, nonatomic) IBOutlet UILabel *lblPhiTheLuu;
@property (retain, nonatomic) IBOutlet UILabel *lblDemGiay;
@property (retain, nonatomic) IBOutlet UIButton *btnSuaTheLuu;
@property (retain, nonatomic) IBOutlet UIButton *btnXoaTheLuu;
@property (retain, nonatomic) IBOutlet UIButton *btnSoTayThuongDung;
@property (retain, nonatomic) IBOutlet UIButton *btnSoTayThuongDungLoaiThe;
//view the lien ket
@property (retain, nonatomic) IBOutlet UIView *viewTaiKhoanLienKet;
@property (retain, nonatomic) IBOutlet UILabel *lblBankLienKet;
@property (retain, nonatomic) IBOutlet UILabel *lblChuTKLienKet;
@property (retain, nonatomic) IBOutlet UILabel *lblSoTKLienKet;
@property (retain, nonatomic) IBOutlet UILabel *lblUserTKLK;
@property (retain, nonatomic) IBOutlet UILabel *lblMKTKLK;
@property (retain, nonatomic) IBOutlet UILabel *lblViCanNapTKLK;
@property (retain, nonatomic) IBOutlet ExTextField *edSoTienLienKet;
@property (retain, nonatomic) IBOutlet UIView *viewXacThucTKLK;
@property (retain, nonatomic) IBOutlet ExTextField *edMaTKLK1;
@property (retain, nonatomic) IBOutlet ExTextField *edMaTKLK2;
@property (retain, nonatomic) IBOutlet ExTextField *edMaTKLK3;
@property (retain, nonatomic) IBOutlet UILabel *lblXacThucTKLK;
@property (retain, nonatomic) IBOutlet UILabel *lblThongBaoTKLK;
@property (retain, nonatomic) IBOutlet UIButton *btnTiepTucTKLK;
@property (retain, nonatomic) IBOutlet UIButton *btnSoTayTKLK;
@property (retain, nonatomic) IBOutlet UILabel *lblThongBaoKhongCoTKLK;
@property (retain, nonatomic) IBOutlet UIView *viewSoTienTKLK;

- (IBAction)thayDoiSoTienTKLienKet:(id)sender;
- (IBAction)suKienChonDanhBaTheQuocTe:(id)sender;
- (IBAction)suKienChonDanhBaTheCao:(id)sender;
- (IBAction)suKienChonThLuu:(id)sender;
- (IBAction)suKienChonDanhBaTheLuu:(id)sender;
- (IBAction)suKienChonSoTayDirect:(id)sender;
- (IBAction)suKienChonSoTayTKLK:(id)sender;

- (IBAction)suKienChonTheNoiDia:(id)sender;
- (IBAction)suKienChonTheQuocTe:(id)sender;
- (IBAction)suKienChonTheCao:(id)sender;
- (IBAction)suKienChonXemZipCode:(id)sender;
- (IBAction)suKienChonSuaThongTinTheLuu:(id)sender;
- (IBAction)suKienXoaTheLuu:(id)sender;
- (IBAction)suKienChonViThuongDung:(id)sender;
- (IBAction)suKienChonTaiKhoanLienKet:(id)sender;
- (IBAction)suKienChonTiepTucTaiKhoanLienKet:(id)sender;
- (IBAction)suKienChonThucHienNapTienTKLK:(id)sender;
- (IBAction)suKienChonHuyNapTienTKLK:(id)sender;

@end
