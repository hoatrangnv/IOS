//
//  ViewThuongDungChuyenTienDenTaiKhoanRutTien.h
//  ViViMASS
//
//  Created by DucBT on 1/28/15.
//
//

#import <UIKit/UIKit.h>
#import "ExTextField.h"
#import "UmiTextView.h"
#import "DucNT_TaiKhoanThuongDungObject.h"

@interface ViewThuongDungChuyenTienDenTaiKhoanRutTien : UIView

@property (retain, nonatomic) IBOutlet ExTextField *mtfTenDaiDien;
@property (retain, nonatomic) IBOutlet ExTextField *mtfTinhThanhPho;
@property (retain, nonatomic) IBOutlet ExTextField *mtfNganHang;
@property (retain, nonatomic) IBOutlet ExTextField *mtfTenChuTaiKhoan;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoTaiKhoan;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoTien;
@property (retain, nonatomic) IBOutlet ExTextField *mtfNoiDungGiaoDich;
@property (retain, nonatomic) IBOutlet UmiTextView *mtvNoiDungGiaoDich;

@property (retain, nonatomic) DucNT_TaiKhoanThuongDungObject *mTaiKhoanThuongDung;

- (BOOL)validate;
- (DucNT_TaiKhoanThuongDungObject*)getTaiKhoanThuongDungDayLenServer;

@end
