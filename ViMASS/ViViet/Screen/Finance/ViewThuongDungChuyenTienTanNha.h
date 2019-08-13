//
//  ViewThuongDungChuyenTienTanNha.h
//  ViViMASS
//
//  Created by DucBui on 7/17/15.
//
//

#import <UIKit/UIKit.h>
#import "DucNT_TaiKhoanThuongDungObject.h"
#import "ExTextField.h"
#import "UmiTextView.h"

@interface ViewThuongDungChuyenTienTanNha : UIView

@property (retain, nonatomic) IBOutlet ExTextField *mtfHoTenNguoiNhan;
@property (retain, nonatomic) IBOutlet ExTextField *mtfCMNDNguoiNhan;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoTien;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoDienThoaiNguoiNhan;
@property (retain, nonatomic) IBOutlet ExTextField *mtfTinhThanhPho;
@property (retain, nonatomic) IBOutlet ExTextField *mtfTenDuong;
@property (retain, nonatomic) IBOutlet UmiTextView *mtvNoiDung;
@property (retain, nonatomic) IBOutlet ExTextField *mtfQuanHuyen;
@property (retain, nonatomic) IBOutlet ExTextField *mtfPhuongXa;
@property (retain, nonatomic) IBOutlet UIView *viewChiTietDuongPho;
@property (retain, nonatomic) IBOutlet ExTextField *mtfNameAlias;

@property (retain, nonatomic) DucNT_TaiKhoanThuongDungObject *mTaiKhoanThuongDung;

- (BOOL)validate;
- (DucNT_TaiKhoanThuongDungObject*)getTaiKhoanThuongDungDayLenServer;

@end
