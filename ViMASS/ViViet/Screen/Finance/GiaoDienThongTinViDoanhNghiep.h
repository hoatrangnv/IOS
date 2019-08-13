//
//  GiaoDienThongTinViDoanhNghiep.h
//  ViViMASS
//
//  Created by nguyen tam on 9/15/15.
//
//

#import <UIKit/UIKit.h>
#import "GiaoDichViewController.h"
#import "TPKeyboardAvoidAcessory.h"

@interface GiaoDienThongTinViDoanhNghiep : GiaoDichViewController

@property (retain, nonatomic) IBOutlet ExTextField *edNameAlias;
@property (retain, nonatomic) IBOutlet TPKeyboardAvoidAcessory *scrView;
@property (retain, nonatomic) IBOutlet UIView* viewMain;
@property (retain, nonatomic) IBOutlet ExTextField *edMaDoanhNghiep;
@property (retain, nonatomic) IBOutlet ExTextField *edTenDoanhNghiep;
@property (retain, nonatomic) IBOutlet ExTextField *edNguoiDaiDien;
@property (retain, nonatomic) IBOutlet ExTextField *edSDT;
@property (retain, nonatomic) IBOutlet ExTextField *edEmail;
@property (retain, nonatomic) IBOutlet UITextView *edDsLap;
@property (retain, nonatomic) IBOutlet UITextView *edDsDuyet;
@property (retain, nonatomic) IBOutlet UIImageView *imgTruoc;
@property (retain, nonatomic) IBOutlet UIImageView *imgSau;
@property (retain, nonatomic) IBOutlet UIImageView *imgLogo;
//@property (retain, nonatomic) IBOutlet UIButton *mbtnXacThucBoiToken;
//@property (retain, nonatomic) IBOutlet UIButton *mbtnXacThucBoiEmail;
//@property (retain, nonatomic) IBOutlet UIButton *mbtnXacThucBoiSMS;
//@property (retain, nonatomic) IBOutlet UILabel *mlblXacThucBoi;
//@property (retain, nonatomic) IBOutlet ExTextField *mtfSoDienThoaiNhanMaXacThuc;

- (IBAction)suKienChupAnhMatTruoc:(id)sender;
- (IBAction)suKienLayAnhMatTruoc:(id)sender;
- (IBAction)suKienChupAnhMatSau:(id)sender;
- (IBAction)suKienLayAnhMatSau:(id)sender;
- (IBAction)suKienChupAnhLogo:(id)sender;
- (IBAction)suKienLayAnhLogo:(id)sender;
@end
