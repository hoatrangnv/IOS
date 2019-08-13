//
//  TraCuuTienDienViewController.h
//  ViViMASS
//
//  Created by DucBT on 4/8/15.
//
//

#import "GiaoDichViewController.h"
#import "ExTextField.h"
#import "MoTaChiTietKhachHang.h"

@interface TraCuuTienDienViewController : GiaoDichViewController

@property (retain, nonatomic) IBOutlet UIScrollView *mScrv;
@property (retain, nonatomic) IBOutlet ExTextField *mtfMaKhachHang;
@property (retain, nonatomic) IBOutlet UIButton *mbtnDanhBa;
@property (retain, nonatomic) IBOutlet UIButton *mbtnTraCuu;
@property (retain, nonatomic) IBOutlet UIWebView *mwvHienThiNoiDungHoaDon;
@property (retain, nonatomic) IBOutlet UIWebView *mwvHienThiDanhSachMaDienLucChoPhep;
@property (retain, nonatomic) IBOutlet UIView *mViewHienThiMaKhachHang;
@property (retain, nonatomic) IBOutlet UIView *mViewHienThiDanhSachMaDienLuc;
@property (retain, nonatomic) IBOutlet UIView *mViewHienThiThongBaoHoaDonDien;
@property (retain, nonatomic) IBOutlet UIView *mViewChuaThongBao;
@property (retain, nonatomic) IBOutlet UITextView *mtvNoiDungThongBao;
@property (retain, nonatomic) IBOutlet UIView *mViewTieuDeThongBao;
@property (retain, nonatomic) IBOutlet UILabel *mlblThongBaoDoi;
@property (retain, nonatomic) IBOutlet UIView *mViewNenThongBao;


@property (nonatomic, retain) NSString *mIdShow;
- (IBAction)suKienChonSoTay:(id)sender;
- (IBAction)nhapMaKhachHang:(id)sender;
@end
