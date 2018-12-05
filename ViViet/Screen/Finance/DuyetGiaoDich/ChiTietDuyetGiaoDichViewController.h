//
//  ChiTietDuyetGiaoDichViewController.h
//  ViViMASS
//
//  Created by DucBui on 6/11/15.
//
//

#import "GiaoDichViewController.h"
#import "DoiTuongGiaoDich.h"
#import "UmiTextView.h"
#import "TPKeyboardAvoidAcessory.h"

@protocol ChiTietDuyetGiaoDichViewControllerDelegate <NSObject>

- (void)suKienDuyetGiaoDichThanhCong;
- (void)suKienHuyDuyetGiaoDichThanhCong;

@end

@interface ChiTietDuyetGiaoDichViewController : GiaoDichViewController
@property (retain, nonatomic) IBOutlet UIView *mViewThoiGianConLai;
@property (retain, nonatomic) IBOutlet UIView *mViewNhapToken2;
@property (retain, nonatomic) IBOutlet UIView *mViewChuaNutXacNhan;
@property (retain, nonatomic) IBOutlet UIView *mViewChuaNoiDung;
@property (retain, nonatomic) IBOutlet UIWebView *mwvHienThi;
@property (retain, nonatomic) IBOutlet UIButton *mbtnDuyet;
@property (retain, nonatomic) IBOutlet UIButton *mbtnHuy;
@property (retain, nonatomic) IBOutlet UmiTextView *mtvNoiDung;
@property (retain, nonatomic) IBOutlet TPKeyboardAvoidAcessory *mscvHienThi;
@property (retain, nonatomic) IBOutlet UITableView *mtbDsGiaoDich;
@property (assign, nonatomic) id<ChiTietDuyetGiaoDichViewControllerDelegate> mDelegate;
@property (retain, nonatomic) IBOutlet UIView *mViewTongSoTien;
@property (retain, nonatomic) IBOutlet UILabel *mTongSoTien;
@property (retain, nonatomic) IBOutlet UILabel *mlblTongSoPhi;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *heightWebHienThi;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *heightTableView;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *heightViewNoiDung;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *heightViewTongSoTien;

@property (nonatomic, retain) DoiTuongGiaoDich *mDoiTuongGiaoDich;
@end
