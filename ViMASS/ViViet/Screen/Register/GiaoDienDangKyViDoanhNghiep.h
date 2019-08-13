//
//  GiaoDienDangKyViDoanhNghiep.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 12/23/15.
//
//

#import "GiaoDichViewController.h"
#import "TPKeyboardAvoidAcessory.h"
#import "UmiTextView.h"
#import "DucNT_ServicePost.h"
@interface GiaoDienDangKyViDoanhNghiep : GiaoDichViewController<DucNT_ServicePostDelegate>

@property (retain, nonatomic) IBOutlet UIView *viewScroll;
@property (retain, nonatomic) IBOutlet TPKeyboardAvoidAcessory *scrMain;
@property (retain, nonatomic) IBOutlet UIView *viewMain;
@property (retain, nonatomic) IBOutlet ExTextField *edMaDN;
@property (retain, nonatomic) IBOutlet UmiTextView *tfTenCongTy;
@property (retain, nonatomic) IBOutlet ExTextField *edTenDaiDien;
@property (retain, nonatomic) IBOutlet ExTextField *edSoDienThoai;
@property (retain, nonatomic) IBOutlet ExTextField *edEmail;
@property (retain, nonatomic) IBOutlet UIImageView *imgTruoc;
@property (retain, nonatomic) IBOutlet UIWebView *webDieuKhoan;
@property (retain, nonatomic) IBOutlet ExTextField *edTenCongTy;
@property (retain, nonatomic) IBOutlet UIImageView *imgSau;
- (IBAction)suKienChupAnhTruoc:(id)sender;
- (IBAction)suKienLayAnhTruoc:(id)sender;
- (IBAction)suKienChupAnhSau:(id)sender;
- (IBAction)suKienLayAnhSau:(id)sender;
- (IBAction)suKienDangKyTaiKhoan:(id)sender;

@end
