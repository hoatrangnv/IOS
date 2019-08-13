//
//  ViewNhapTenDaiDienXacThucThemTaiKhoanThuongDung.h
//  ViViMASS
//
//  Created by DucBT on 2/2/15.
//
//

#import <UIKit/UIKit.h>
#import "ExTextField.h"
#import "DucNT_TaiKhoanThuongDungObject.h"
#import "DucNT_TaiKhoanViObject.h"

@protocol ViewNhapTenDaiDienXacThucThemTaiKhoanThuongDungDelegate <NSObject>

- (void)xuLySuKienBamNutVanTay;

@end

@interface ViewNhapTenDaiDienXacThucThemTaiKhoanThuongDung : UIView
@property (retain, nonatomic) IBOutlet UILabel *mlblXacThucBoi;
@property (retain, nonatomic) IBOutlet UILabel *mlblTenHienThi;
@property (retain, nonatomic) IBOutlet ExTextField *mtfMatKhauToken;
@property (retain, nonatomic) IBOutlet UIButton *mbtnThucHien;
@property (retain, nonatomic) IBOutlet UIButton *mbtnTKThuong;
@property (retain, nonatomic) IBOutlet UIButton *mbtnTKRutTien;
@property (retain, nonatomic) IBOutlet ExTextField *mtfTenHienThi;
@property (retain, nonatomic) IBOutlet UIView *mViewChonTaiKhoanThuong_RutTien;
@property (retain, nonatomic) IBOutlet UIView *mViewMain;

@property (retain, nonatomic) IBOutlet UIButton *mbtnToken;
@property (retain, nonatomic) IBOutlet UIButton *mbtnSMS;
@property (retain, nonatomic) IBOutlet UIButton *mbtnEmail;
@property (retain, nonatomic) IBOutlet UIButton *mbtnVanTay;

@property (nonatomic, retain) DucNT_TaiKhoanThuongDungObject *mTaiKhoanThuongDung;
@property (retain, nonatomic) DucNT_TaiKhoanViObject *mThongTinVi;
@property (assign, nonatomic) id<ViewNhapTenDaiDienXacThucThemTaiKhoanThuongDungDelegate> mDelegate;


@end
