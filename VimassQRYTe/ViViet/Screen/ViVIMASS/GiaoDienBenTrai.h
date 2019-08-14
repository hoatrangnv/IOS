//
//  GiaoDienBenTrai.h
//  ViViMASS
//
//  Created by DucBT on 1/5/15.
//
//

#import <UIKit/UIKit.h>
#import "ItemMenuTaiChinh.h"
#import "DucNT_TaiKhoanViObject.h"

@protocol GiaoDienBenTraiDelegate <NSObject>

- (void)xuLySuKienChonThongTinVi;
- (void)xuLySuKienDongViewBenTrai;
- (void)xuLySuKienChonItemMenuTaiChinh:(ItemMenuTaiChinh*)item;

@end

@interface GiaoDienBenTrai : UIView

@property (nonatomic, assign) id<GiaoDienBenTraiDelegate> mDelegate;
@property (retain, nonatomic) IBOutlet UIImageView *mimgvDaiDien;
@property (retain, nonatomic) IBOutlet UILabel *mlblTenChuTaiKhoan;
@property (retain, nonatomic) IBOutlet UILabel *mlblSoDienThoaiChuTaiKhoan;
@property (retain, nonatomic) IBOutlet UILabel *mlblSoTienTrongVi;
@property (retain, nonatomic) IBOutlet UILabel *lblKhuyenMai;
@property (retain, nonatomic) IBOutlet UITableView *mtbHienThi;
@property (retain, nonatomic) IBOutlet UIView *mViewThongTinTaiKhoan;
@property (retain, nonatomic) IBOutlet UITableView *mtbSubHienThi;

@property (retain, nonatomic) DucNT_TaiKhoanViObject *mThongTinTaiKhoanVi;

- (void)khoiTaoViewThongTinTaiKhoan;
- (void)capNhatSoDu:(double)fSoDu soDuKhuyenMai:(double)fSoDuKhuyenMai;
- (void)xuLyHienThiGiaoDien;

- (void)hienThiChuyenTien;
- (void)hienThiRutTien;
- (void)hienThiMuonTien;
- (void)reloadDataBagde;

@end
