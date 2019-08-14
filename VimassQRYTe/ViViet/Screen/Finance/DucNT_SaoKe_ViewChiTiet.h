//
//  DucNT_SaoKe_ViewChiTiet.h
//  ViMASS
//
//  Created by MacBookPro on 7/11/14.
//
//

#import <UIKit/UIKit.h>
#import "DucNT_TaiKhoanViObject.h"
#import "GiaoDichMang.h"
#import "TPKeyboardAvoidAcessory.h"
@class DucNT_SaoKeObject;

@interface DucNT_SaoKe_ViewChiTiet : UIView <DucNT_ServicePostDelegate>

@property (retain, nonatomic) IBOutlet UIView *viewMain;
@property (retain, nonatomic) IBOutlet UILabel *lbFromAcc;
@property (retain, nonatomic) IBOutlet UILabel *lbToAcc;
@property (retain, nonatomic) IBOutlet UILabel *lbAmount;
@property (retain, nonatomic) IBOutlet UILabel *lbTime;
@property (retain, nonatomic) IBOutlet UITextView *tvDescrip;
@property (retain, nonatomic) IBOutlet UILabel *mtfTenNguoiThuHuong;
@property (retain, nonatomic) IBOutlet UILabel *mtfTenVietTatNganHang;
@property (retain, nonatomic) IBOutlet UILabel *mlblSoDu;
@property (retain, nonatomic) IBOutlet UILabel *mlblSoPhi;

@property (retain, nonatomic) IBOutlet UIView *mViewSoPhi;
@property (retain, nonatomic) IBOutlet UIView *mViewThoiGian;
@property (retain, nonatomic) IBOutlet UIView *mViewSoTien;
@property (retain, nonatomic) IBOutlet UIView *mViewTenNHVietTat;
@property (retain, nonatomic) IBOutlet UIView *mViewTenNguoiThuHuong;
@property (retain, nonatomic) IBOutlet UIView *ViewDen;
@property (retain, nonatomic) IBOutlet UIView *mViewSoTien_;
@property (retain, nonatomic) IBOutlet UIView *mViewThoiDiemVaSoDuVi;
@property (retain, nonatomic) IBOutlet UIView *mViewTieuDe;
@property (retain, nonatomic) IBOutlet UIButton *mbtnGuiMailVeThuDienTu;
@property (retain, nonatomic) IBOutlet TPKeyboardAvoidAcessory *scrMain;
@property (retain, nonatomic) IBOutlet UIView *viewLoading;

@property (nonatomic , retain) DucNT_TaiKhoanViObject *mThongTinTaiKhoan;
@property (nonatomic, retain) NSString *mXauHTMLGuiVeMail;
@property (retain, nonatomic) IBOutlet UIView *mViewGuiKhieuNai;
@property (retain, nonatomic) IBOutlet UIWebView *webNoiDung;
- (IBAction)suKienBamGuiKhieuNai:(id)sender;
- (IBAction)suKienBamNutClose:(id)sender;

-(id)initWithNib;

-(void)updateView:(NSString *)sFromAcc toAcc:(NSString *)sToAcc withAmount:(NSString *)sAmount withTime:(NSString *)sTime withDesc:(NSString *)sDescrip;
-(void)updateView:(DucNT_SaoKeObject*)item;

@end
