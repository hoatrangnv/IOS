//
//  ChuyenTienViewController.h
//  ViViMASS
//
//  Created by DucBT on 2/3/15.
//
//

#import "GiaoDich/GiaoDichViewController.h"
#import "ExTextField.h"
#import "UmiTextView.h"
#import "TPKeyboardAvoidAcessory.h"

@interface ChuyenTienViewController : GiaoDichViewController


@property (retain, nonatomic) IBOutlet TPKeyboardAvoidAcessory *scrMain;
@property (retain, nonatomic) IBOutlet ExTextField *mtfTenTKRutTien;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoTien;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoPhi;
@property (retain, nonatomic) IBOutlet UmiTextView *mtvNoiDungGiaoDich;
@property (retain, nonatomic) IBOutlet ExTextField *mtfTenNguoiThuHuong;
@property (retain, nonatomic) IBOutlet ExTextField *mtfTenVietTatNganHang;

@property (retain, nonatomic) DucNT_TaiKhoanThuongDungObject *mTaiKhoanThuongDung;

- (IBAction)suKienChonSoTay:(id)sender;
@end
