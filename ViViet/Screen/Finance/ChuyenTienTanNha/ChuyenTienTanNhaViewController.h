//
//  ChuyenTienTanNhaViewController.h
//  ViViMASS
//
//  Created by DucBui on 7/8/15.
//
//

#import "GiaoDichViewController.h"
#import "TPKeyboardAvoidAcessory.h"
#import "UmiTextView.h"
#import "DucNT_TaiKhoanThuongDungObject.h"

@interface ChuyenTienTanNhaViewController : GiaoDichViewController
@property (retain, nonatomic) IBOutlet TPKeyboardAvoidAcessory *mScrView;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoTien;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoPhi;
@property (retain, nonatomic) IBOutlet ExTextField *mtfTinhThanhPho;
@property (retain, nonatomic) IBOutlet ExTextField *mtfQuanHuyen;
@property (retain, nonatomic) IBOutlet ExTextField *mtfPhuongXa;
@property (retain, nonatomic) IBOutlet ExTextField *mtfTenDuong;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoDienThoaiNguoiNhan;
@property (retain, nonatomic) IBOutlet ExTextField *mtfHoTenNguoiNhan;
@property (retain, nonatomic) IBOutlet ExTextField *mtfCMNDNguoiNhan;
@property (retain, nonatomic) IBOutlet UIView *mViewTenDuongSonha;
@property (retain, nonatomic) IBOutlet UmiTextView *mtvNoiDung;
@property (retain, nonatomic) IBOutlet UmiTextView *mtvTenDuong;
@property (retain, nonatomic) DucNT_TaiKhoanThuongDungObject *mTaiKhoanThuongDung;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *heightViewMain;

- (IBAction)suKienBamNutThuongDung:(id)sender;
@end
