//
//  GiaoDienThanhToanChungKhoan.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 4/12/16.
//
//

#import "GiaoDichViewController.h"
#import "UmiTextView.h"
#import "TPKeyboardAvoidAcessory.h"
#import "DucNT_LoginSceen.h"

@interface GiaoDienThanhToanChungKhoan : GiaoDichViewController
@property (retain, nonatomic) IBOutlet UIView *viewThanhToan;
@property (retain, nonatomic) IBOutlet ExTextField *edTaiKhoan;
@property (retain, nonatomic) IBOutlet ExTextField *edHoTen;
@property (retain, nonatomic) IBOutlet ExTextField *edMaKhachHang;
@property (retain, nonatomic) IBOutlet ExTextField *edSoTien;
@property (retain, nonatomic) IBOutlet UmiTextView *tvNoiDung;
@property (retain, nonatomic) IBOutlet TPKeyboardAvoidAcessory *scrMain;
- (IBAction)suKienNhapSoTienChungKhoan:(id)sender;
- (IBAction)suKienBamNutSoTayChungKhoan:(id)sender;

@end
