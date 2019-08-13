//
//  ViewXacThuc.h
//  ViViMASS
//
//  Created by DucBT on 1/23/15.
//
//

#import <UIKit/UIKit.h>
#import "ExTextField.h"
#import "DucNT_ServicePost.h"
#import "DucNT_TaiKhoanViObject.h"

@protocol ViewXacThucDelegate <NSObject>

- (void)xuLySuKienXacThucVoiKieu:(NSInteger)nKieuXacThuc token:(NSString*)sToken otp:(NSString*)sOtp;
- (void)xuLySuKienBamNutVanTay;

@end

@interface ViewXacThuc : UIView <UIAlertViewDelegate, DucNT_ServicePostDelegate>

@property (retain, nonatomic) IBOutlet UIButton *mbtnToken;
@property (retain, nonatomic) IBOutlet UIButton *mbtnSMS;
@property (retain, nonatomic) IBOutlet UIButton *mbtnEmail;
@property (retain, nonatomic) IBOutlet UIButton *mbtnThucHien;
@property (retain, nonatomic) IBOutlet ExTextField *mtfMaXacThuc;
@property (retain, nonatomic) IBOutlet UIView *mViewMain;
@property (retain, nonatomic) IBOutlet UIButton *mbtnVanTay;
@property (retain, nonatomic) IBOutlet UILabel *lblTitle;

@property (assign, nonatomic) NSInteger mTongSoThoiGian;
@property (retain, nonatomic) DucNT_TaiKhoanViObject *mThongTinVi;
@property (assign, nonatomic) id<ViewXacThucDelegate> mDelegate;

- (void)xuLyKhiXacThucVanTayThanhCong;
- (void)ketThucDemThoiGian;

@end
