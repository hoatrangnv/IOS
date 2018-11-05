//
//  GiaoDichViewController.h
//  ViViMASS
//
//  Created by DucBT on 3/24/15.
//
//

#import "BaseScreen.h"
#import "ExTextField.h"
#import "GiaoDichMang.h"
#import "DucNT_ServicePost.h"
#import "MBProgressHUD.h"
#import "ViewQuangCao.h"

@interface GiaoDichViewController : BaseScreen <DucNT_ServicePostDelegate, ViewQuangCaoDelegate>

@property (assign, nonatomic) BOOL bChuyenGiaoDienQuangCao;
@property (assign, nonatomic) BOOL bHienViewXacThuc;
@property (assign, nonatomic) int mTypeAuthenticate;
@property (assign, nonatomic) int mFuncID;
@property (retain, nonatomic) NSString *mDinhDanhKetNoi;
@property (assign, nonatomic) bool bChuyenGiaoDien;

@property (retain, nonatomic) IBOutlet UIView *mViewMain;
@property (retain, nonatomic) IBOutlet ExTextField *mtfMatKhauToken;
@property (retain, nonatomic) IBOutlet UIButton *mbtnToken;
@property (retain, nonatomic) IBOutlet UIButton *mbtnSMS;
@property (retain, nonatomic) IBOutlet UIButton *mbtnEmail;
@property (retain, nonatomic) IBOutlet UIButton *mbtnThucHien;
@property (retain, nonatomic) IBOutlet UIButton *mbtnPKI;

@property (retain, nonatomic) IBOutlet ExTextField *mtfMatKhauTokenView;
@property (retain, nonatomic) IBOutlet UIButton *mbtnTokenView;
@property (retain, nonatomic) IBOutlet UIButton *mbtnSMSView;
@property (retain, nonatomic) IBOutlet UIButton *mbtnEmailView;
@property (retain, nonatomic) IBOutlet UIButton *mbtnThucHienView;

@property (retain, nonatomic) IBOutlet UIButton *mbtnVanTay;
@property (retain, nonatomic) IBOutlet UILabel *mlblSoDu;
@property (retain, nonatomic) IBOutlet UILabel *mlblSoDuKhuyenMai;
@property (retain, nonatomic) IBOutlet UISwitch *mswtKhuyenMai;
@property (retain, nonatomic) IBOutlet UIButton *btnSoTay;
@property (retain, nonatomic) IBOutlet UIButton *btnVanTayMini;
@property (retain, nonatomic) IBOutlet UIView *mViewNhapToken;
@property (retain, nonatomic) IBOutlet UIView *viewOptionTop;

@property (retain, nonatomic) IBOutlet UIImageView *imgTabTop;
@property (retain, nonatomic) IBOutlet UIButton *btnTabTop1;
@property (retain, nonatomic) IBOutlet UIButton *btnTabTop2;
@property (retain, nonatomic) IBOutlet UIButton *btnTabTop3;
@property (retain, nonatomic) IBOutlet UIWebView *webGioiThieuTaiKhoan;

- (void)hienThiLoading;
- (void)hienThiLoadingChuyenTien;
- (void)anLoading;
- (void)suKienDonePicker:(UIButton *)btn;
- (void)suKienCancelPicker:(UIButton *)btn;
- (void)refreshGiaoDienGiaoDich;
- (void)themButtonHuongDanSuDung:(SEL)action;
- (void)addButtonHuongDan;
- (void)suKienBamNutHuongDanGiaoDichViewController:(UIButton *)sender;
- (BOOL)validateVanTay;
- (void)addTitleView:(NSString *)sTitle;
- (void)xuLyThucHienKhiKiemTraThanhCongTraVeToken:(NSString*)sToken otp:(NSString*)sOtp;

- (void)xuLyKetNoiThanhCong:(NSString*)sDinhDanhKetNoi thongBao:(NSString*)sThongBao ketQua:(id)ketQua;

- (void)xuLyKetNoiThatBai:(NSString*)sDinhDanhKetNoi thongBao:(NSString*)sThongBao ketQua:(id)ketQua;
- (void)khoiTaoTextFeildTheoYChuTit:(ExTextField *)edTemp nTag:(int)nTag dataPicker : (id<UIPickerViewDataSource>) dataSource delegatePicker : (id<UIPickerViewDelegate>) delegate;
- (void)setAnimationChoSoTay:(UIButton *)btn;
- (void)addRightButtonForPicker:(ExTextField *)textView;
- (void)xuLyKetNoiLaySoDuTaiKhoan;
- (void)khoiTaoGiaoDienKhuyenMaiVaSoDu;
- (IBAction)suKienBamNutSMS:(UIButton *)sender;
- (IBAction)suKienBamNutEmail:(UIButton *)sender;
- (IBAction)suKienBamNutToken:(UIButton *)sender;
- (IBAction)suKienBamNutPKI:(UIButton *)sender;

- (void)xuLySuKienXacThucBangSMS;
- (void)xuLySuKienXacThucBangEmail;
- (void)xuLyKetNoiLayMaXacThucChuyenDenTaiKhoan:(NSString*)sSendTo kieuXacThuc:(int)nKieu;
- (void)suKienQuangCaoGoc:(NSString *)sNameImage;

- (IBAction)suKienBamNutVi:(UIButton *)sender;
- (IBAction)suKienBamNutLienKet:(UIButton *)sender;
- (IBAction)suKienBamNutTaiKhoan:(UIButton *)sender;
@end
