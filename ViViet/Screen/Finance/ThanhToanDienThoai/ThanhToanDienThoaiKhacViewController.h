//
//  ThanhToanDienThoaiKhacViewController.h
//  ViViMASS
//
//  Created by DucBT on 3/24/15.
//
//

#import "TPKeyboardAvoidAcessory.h"
#import "GiaoDichViewController.h"
#import "DoiTuongThanhToanCuocDienThoaiViettel.h"

@interface ThanhToanDienThoaiKhacViewController : GiaoDichViewController

@property (retain, nonatomic) IBOutlet TPKeyboardAvoidAcessory *mscrv;

@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *mbtnSoTien;
@property (retain, nonatomic) IBOutlet UIView *mViewSoTien;
@property (retain, nonatomic) IBOutlet UIView *mViewThoiGianConLai;
@property (retain, nonatomic) IBOutlet UIView *mViewLuaChon;

//View SoLuong_Phi
@property (retain, nonatomic) IBOutlet UIView *mViewSoLuong_Phi;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoLuong;
@property (retain, nonatomic) IBOutlet UIButton *mbtnChonSoLuong;
//@property (retain, nonatomic) IBOutlet UILabel *mlblPhi;
@property (retain, nonatomic) IBOutlet UIView *mViewSoLuong;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *heightViewSoLuongPhi;

//View SoDienThoai_TraCuu
@property (retain, nonatomic) IBOutlet UIView *mViewSoDienThoai_TraCuu;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoDienThoai;
@property (retain, nonatomic) IBOutlet UIButton *mbtnTraCuu;

@property (retain, nonatomic) IBOutlet UILabel *mlblKhuyenMai;
@property (retain, nonatomic) IBOutlet ExTextField *mtfLuaChon;

@property (retain, nonatomic) IBOutlet UITableView *mtbHienThiLuaChon;
@property (retain, nonatomic) IBOutlet UITableView *mtbSoLuong;
@property (nonatomic, assign) NSInteger mNhaMang;
@property (retain, nonatomic) IBOutlet UIWebView *mwvHienThiLuuY;
@property (retain, nonatomic) IBOutlet UIButton *btnViettel;
@property (retain, nonatomic) IBOutlet UIButton *btnVina;
@property (retain, nonatomic) IBOutlet UIButton *btnMobi;
@property (retain, nonatomic) IBOutlet UIButton *btnKhac;
@property (retain, nonatomic) IBOutlet UIView *viewSoPhiVaKhuyenMai;
@property (retain, nonatomic) IBOutlet ExTextField *soTienViettel;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *heightSoTienViettel;
//@property (retain, nonatomic) IBOutlet UIButton *btnTraCuuViettel;
@property (retain, nonatomic) IBOutlet ExTextField *edSoTienTraSauViettel;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *heightSoTienTraSauViettel;
@property (retain, nonatomic) DoiTuongThanhToanCuocDienThoaiViettel *mDoiTuongThanhToanCuocDienThoaiViettel;
@property (retain, nonatomic) IBOutlet UIButton *btnTraCuuTraSau;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *heightBtnTraCuuTraSau;
@property (retain, nonatomic) IBOutlet UIView *viewTimeTraCuuTraSau;
@property (retain, nonatomic) IBOutlet UITextView *tvTimeTraCuuTraSau;
@property (retain, nonatomic) IBOutlet UIView *mViewNenThongBao;
@property (retain, nonatomic) IBOutlet UIView *mViewTieuDeThongBao;
@property (retain, nonatomic) IBOutlet UIView *mViewChuaThongBao;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *heightMain;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *heightViewSoTien;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *topSoTienViettel;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *topBtnTraCuu;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *topViewXacThuc;

- (IBAction)suKienBamNutChonSoTien:(id)sender;
- (IBAction)suKienChonNhaMangViettel:(id)sender;
- (IBAction)suKienChonNhaMangVina:(id)sender;
- (IBAction)suKienChonNhaMangMobi:(id)sender;
- (IBAction)suKienChonNhaMangKhac:(id)sender;
- (IBAction)suKienBamNutTraCuuViettel:(id)sender;
- (IBAction)suKienChonSoTay:(id)sender;
- (IBAction)suKienBamNutTraCuuTraSau:(id)sender;

@end
