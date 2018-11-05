//
//  GiaoDienChinhHeader.h
//  ViViMASS
//
//  Created by DucBT on 1/7/15.
//
//

#import <UIKit/UIKit.h>
#import "DucNT_TaiKhoanViObject.h"

@protocol GiaoDienChinhHeaderDelegate <NSObject>
@required
- (void)xuLySuKienBamNutNapTien;
- (void)xuLySuKienBamNutChuyenTien;
- (void)xuLySuKienbamNutRutTien;
- (void)xuLySuKienBamNutMuonTien;
- (void)xuLySuKienXemSaoKe:(UIButton*)sender;

@end

@interface GiaoDienChinhHeader : UIView

@property (retain, nonatomic) IBOutlet UILabel *mlblTenTaiKhoan;
@property (retain, nonatomic) IBOutlet UILabel *mlblSoTienTrongTaiKhoan;
@property (retain, nonatomic) IBOutlet UILabel *mlblSoTienKhuyenMaiTrongTaiKhoan;
@property (retain, nonatomic) IBOutlet UILabel *mlblTheQuaTang;
@property (retain, nonatomic) IBOutlet UILabel *mlblSoTheQuaTang;
@property (retain, nonatomic) IBOutlet UILabel *mlblKhuyenMai;
@property (retain, nonatomic) IBOutlet UIButton *mbtnMuonTien;
@property (retain, nonatomic) IBOutlet UIButton *mbtnRutTien;
@property (retain, nonatomic) IBOutlet UIButton *mbtnChuyenTien;
@property (retain, nonatomic) IBOutlet UIView *mViewHienThiThongTinTaiKhoan;
@property (retain, nonatomic) IBOutlet UIView *mViewChuaThongTInSaoKe;

@property (retain, nonatomic) DucNT_TaiKhoanViObject *mThongTinTaiKhoanVi;
@property (assign, nonatomic) id<GiaoDienChinhHeaderDelegate> mDelegate;

- (void)capNhatSoDu:(double)fSoDu soDuKhuyenMai:(double)fSoDuKhuyenMai theQuaTang:(double)fTheQuaTang;
- (void)khoiTaoGiaoDienHeader;

@end
