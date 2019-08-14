//
//  ChiTietTangQuaViewController.h
//  ViViMASS
//
//  Created by DucBT on 3/26/15.
//
//

#import "TPKeyboardAvoidAcessory.h"
#import "GiaoDichViewController.h"
#import "UmiTextView.h"
#import "ViewQuaTang.h"

@interface ChiTietTangQuaViewController : GiaoDichViewController

@property (retain, nonatomic) IBOutlet ExTextField *mtfTieuDe;
@property (retain, nonatomic) IBOutlet ExTextField *mtfTaiKhoanNhanQua;
@property (retain, nonatomic) IBOutlet UIButton *mbtnDanhBa;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *mDsBtnSoTien;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoTien;
@property (retain, nonatomic) IBOutlet ExTextField *mtfNoiDungChuyenTien;
@property (retain, nonatomic) IBOutlet UmiTextView *mtvNoiDungChuyenTien;
@property (retain, nonatomic) IBOutlet ExTextField *mtfThoiGianTangQua;
@property (retain, nonatomic) IBOutlet UIView *mViewChuaViewQuaTang;
@property (retain, nonatomic) IBOutlet TPKeyboardAvoidAcessory *mscrvHienThi;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoPhi;

@property (nonatomic, copy) ItemQuaTang *mItemQuaTang;
@property (nonatomic, retain) NSString *sToAccWallet;
- (IBAction)suKienBamNutDanhBa:(id)sender;
- (IBAction)suKienBamNutSoTien:(id)sender;
- (IBAction)suKienBamNutChonThoiGianTangQua:(id)sender;
- (IBAction)suKienChonSoTayQuaTang:(id)sender;

@end
