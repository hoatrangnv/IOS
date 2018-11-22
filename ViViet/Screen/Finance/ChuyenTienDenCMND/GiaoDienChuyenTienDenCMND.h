//
//  GiaoDienChuyenTienDenCMND.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 3/15/16.
//
//

#import "GiaoDichViewController.h"
#import "TPKeyboardAvoidAcessory.h"
#import "UmiTextView.h"

@interface GiaoDienChuyenTienDenCMND : GiaoDichViewController

@property (retain, nonatomic) IBOutlet TPKeyboardAvoidAcessory *scrMain;
@property (retain, nonatomic) IBOutlet ExTextField *edKhuVuc;
@property (retain, nonatomic) IBOutlet ExTextField *edQuanHuyen;
@property (retain, nonatomic) IBOutlet ExTextField *edNganHang;
@property (retain, nonatomic) IBOutlet UIView *viewThongTinNhan;
@property (retain, nonatomic) IBOutlet ExTextField *edNgayCap;
@property (retain, nonatomic) IBOutlet ExTextField *edTenCN;
@property (retain, nonatomic) IBOutlet ExTextField *edDiaChiCN;
@property (retain, nonatomic) IBOutlet ExTextField *edTenNguoiNhan;
@property (retain, nonatomic) IBOutlet ExTextField *edCMND;
@property (retain, nonatomic) IBOutlet ExTextField *edNoiCap;
@property (retain, nonatomic) IBOutlet ExTextField *edSoTien;
@property (retain, nonatomic) IBOutlet ExTextField *rfNoiDung;
@property (retain, nonatomic) IBOutlet UmiTextView *tvNoiDung;
@property (retain, nonatomic) IBOutlet UmiTextView *tvDiaChi;
@property (retain, nonatomic) IBOutlet ExTextField *edSDTNguoiNhan;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *heightEdQuanHuyen;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *heightViewMain;

- (IBAction)suKienTimChiNhanh:(id)sender;
- (IBAction)suKienThayDoiSoTien:(id)sender;
- (IBAction)suKienBamNutSoTay:(id)sender;

@end
