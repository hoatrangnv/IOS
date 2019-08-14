//
//  ViewThuongDungTietKiem.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 5/5/16.
//
//

#import <UIKit/UIKit.h>
#import "ExTextField.h"
#import "UmiTextView.h"
#import "DucNT_TaiKhoanThuongDungObject.h"

@protocol ViewThuongDungTietKiemDelegate <NSObject>

- (void)capNhatLaiGiaoDienTietKiem;

@end

@interface ViewThuongDungTietKiem : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (retain, nonatomic) DucNT_TaiKhoanThuongDungObject *mTaiKhoanThuongDung;
@property (assign, nonatomic) id<ViewThuongDungTietKiemDelegate> delegate;
@property (nonatomic, retain) NSArray *mDanhSachNganHangGuiTietKiem;

@property (retain, nonatomic) IBOutlet ExTextField *edNameAlias;
@property (retain, nonatomic) IBOutlet ExTextField *mtfNganHangGui;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoTien;
@property (retain, nonatomic) IBOutlet ExTextField *mtfKyHanGui;
@property (retain, nonatomic) IBOutlet ExTextField *mtfKyLinhLai;
@property (retain, nonatomic) IBOutlet ExTextField *mtfCachThucQuayVong;
@property (retain, nonatomic) IBOutlet UILabel *mlblLaiSuat;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoPhi;
@property (retain, nonatomic) IBOutlet UILabel *mlblTienLai;
@property (retain, nonatomic) IBOutlet ExTextField *mtfNhanGocVaLaiVe;
@property (retain, nonatomic) IBOutlet UIView *mVIewNhanGocVaLaiVe;

//Ngan hang nhan tien
@property (retain, nonatomic) IBOutlet UIView *mViewChonNganHangNhanTienGocVaLaiTietKiem;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoTaiKhoanRutTienVe;
@property (retain, nonatomic) IBOutlet ExTextField *mtfTenChuTaiKhoan;
@property (retain, nonatomic) IBOutlet ExTextField *mtfNganHangRutTienVe;

//The
@property (retain, nonatomic) IBOutlet UIView *mViewRutGocVaLaiVeThe;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoThe;

- (void)capNhatThongTin;
- (BOOL)kiemTraNoiDung;
- (DucNT_TaiKhoanThuongDungObject*)getTaiKhoanThuongDungDayLenServer;

@end
