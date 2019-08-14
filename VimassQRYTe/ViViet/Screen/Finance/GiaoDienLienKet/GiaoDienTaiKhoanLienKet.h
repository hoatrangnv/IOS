//
//  GiaoDienTaiKhoanLienKet.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 10/4/16.
//
//

#import "GiaoDichViewController.h"

@interface GiaoDienTaiKhoanLienKet : GiaoDichViewController

@property (retain, nonatomic) IBOutlet ExTextField *edBank;
@property (retain, nonatomic) IBOutlet ExTextField *edChuTK;
@property (retain, nonatomic) IBOutlet ExTextField *edSoTK;
@property (retain, nonatomic) IBOutlet ExTextField *edTenDangNhap;
@property (retain, nonatomic) IBOutlet ExTextField *edMatKhau;
@property (retain, nonatomic) IBOutlet ExTextField *edSoThe;
@property (retain, nonatomic) IBOutlet ExTextField *edNgayMoThe;
@property (retain, nonatomic) IBOutlet ExTextField *edNamMoThe;
@property (retain, nonatomic) IBOutlet UILabel *lblKyTuDangNhap;
@property (retain, nonatomic) IBOutlet UILabel *lblMatKhauDangNhap;


@property (retain, nonatomic) IBOutlet UISegmentedControl *segOTP;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segLoaiTaiKhoan;
@property (retain, nonatomic) IBOutlet UISwitch *swMacDinh;

- (IBAction)suKienChonSoTay:(id)sender;
- (IBAction)suKienChonSwitchThe:(id)sender;
//- (IBAction)suKienChonSwitchTaiKhoan:(id)sender;
- (IBAction)suKienTouchInsideTaiKhoan:(id)sender;
@end
