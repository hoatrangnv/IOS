//
//  ThemTaiKhoanThuongDungViewController.h
//  ViViMASS
//
//  Created by DucBT on 1/21/15.
//
//

#import "GiaoDichViewController.h"
#import "DucNT_TaiKhoanThuongDungObject.h"

@protocol ThemTaiKhoanThuongDungViewControllerDelegate <NSObject>

- (void)xuLySuKienThem_CapNhatTaiKhoanThuongDungThanhCong;

@end

@interface ThemTaiKhoanThuongDungViewController : GiaoDichViewController

@property (nonatomic, assign) int mKieuThemTaiKhoanThuongDung;
@property (nonatomic, assign) id<ThemTaiKhoanThuongDungViewControllerDelegate> mDelegate;
@property (nonatomic, retain) DucNT_TaiKhoanThuongDungObject *mTaiKhoanThuongDung;

@end
