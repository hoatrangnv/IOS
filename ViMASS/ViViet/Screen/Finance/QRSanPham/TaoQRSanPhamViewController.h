//
//  TaoQRSanPhamViewController.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 12/5/17.
//

#import <UIKit/UIKit.h>
#import "ExTextField.h"
#import "GiaoDichViewController.h"
#import "TPKeyboardAvoidAcessory.h"
#import "UmiTextView.h"
@interface TaoQRSanPhamViewController : GiaoDichViewController

@property (nonatomic, assign) int nType;
@property (nonatomic, retain) NSString *maDaiLy;
@property (nonatomic, retain) NSDictionary *dictSanPham;
@property (retain, nonatomic) IBOutlet ExTextField *edTenSP;
@property (retain, nonatomic) IBOutlet ExTextField *edGiaTien;
@property (retain, nonatomic) IBOutlet ExTextField *edNoiDung;
@property (retain, nonatomic) IBOutlet UmiTextView *umiNoiDung;
@property (retain, nonatomic) IBOutlet UISwitch *swSoLuong;
@property (retain, nonatomic) IBOutlet UISwitch *swThongTin;
@property (retain, nonatomic) IBOutlet UISwitch *swLoiNhan;

@property (retain, nonatomic) IBOutlet TPKeyboardAvoidAcessory *scrollView;
@property (retain, nonatomic) IBOutlet UIImageView *imgvSP;
@property (retain, nonatomic) IBOutlet UmiTextView *umiThongBao;
@property (retain, nonatomic) IBOutlet ExTextField *tfThongBao;
@property (retain, nonatomic) IBOutlet UIView *viewEdit;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *heightViewEdit;
@property (retain, nonatomic) IBOutlet UIView *viewThoiGian;
@property (retain, nonatomic) IBOutlet UIView *viewXacThuc;
@property (retain, nonatomic) IBOutlet UIView *viewAddXacThuc;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *heightMainConstrant;
@property (retain, nonatomic) IBOutlet ExTextField *txtVilientket;
//HOANHNV UPDATE
@property (retain, nonatomic) IBOutlet ExTextField *edtVilienket1;
@property (retain, nonatomic) IBOutlet ExTextField *edtVilienket2;
@property (retain, nonatomic) IBOutlet ExTextField *edtVilienket3;
@property (retain, nonatomic) IBOutlet ExTextField *edtVilienket4;
@property (retain, nonatomic) IBOutlet ExTextField *edtVilienket5;

- (IBAction)suKienChonChupAnh:(id)sender;
- (IBAction)suKienChonLayAnh:(id)sender;
- (IBAction)suKienChonTaoQRSanPham:(id)sender;
- (IBAction)changeSoTien:(id)sender;
- (IBAction)suKienXoaSanPham:(id)sender;
- (IBAction)suKienXemGiaoDich:(id)sender;
- (IBAction)suKienDongViewXacThuc:(id)sender;

@end
