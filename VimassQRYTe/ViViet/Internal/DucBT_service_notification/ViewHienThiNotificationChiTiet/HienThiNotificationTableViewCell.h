//
//  HienThiNotificationTableViewCell.h
//  BIDV
//
//  Created by Mac Mini on 9/22/14.
//
//

#import <UIKit/UIKit.h>
#import "DoiTuongNotification.h"

@class HienThiNotificationTableViewCell;
@protocol HienThiNotificationTableViewCellDelegate <NSObject>

- (void)xuLySuKienBamNutDaiDien:(UIButton*)sender;
- (void)xuLySuKienBamNutDongYMuonTienTai:(HienThiNotificationTableViewCell*)cell;
- (void)xuLySuKienBamNutTuChoiMuonTienTai:(HienThiNotificationTableViewCell*)cell;


@end

@interface HienThiNotificationTableViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *mlblTieuDe;
@property (retain, nonatomic) IBOutlet UILabel *mlblChuThich;
@property (retain, nonatomic) IBOutlet UILabel *mlblThoiGian;
@property (retain, nonatomic) IBOutlet UIButton *mbtnDaiDien;
@property (retain, nonatomic) IBOutlet UILabel *mlblTrangThai;
@property (retain, nonatomic) IBOutlet UIView *mViewHienThiThongTin;
@property (retain, nonatomic) IBOutlet UIView *mViewXacNhan;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *heightButtonDongY;

@property (nonatomic, assign) id<HienThiNotificationTableViewCellDelegate> mDelegate;
@property (nonatomic, assign) BOOL mTrangThaiXoa;

@property (nonatomic, assign) int mViTri;

@property (nonatomic, retain) DoiTuongNotification *mDoiTuongNotification;


- (CGFloat)height;

@end
