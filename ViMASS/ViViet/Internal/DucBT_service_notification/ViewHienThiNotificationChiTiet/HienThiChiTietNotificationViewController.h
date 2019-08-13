//
//  HienThiChiTietNotificationViewController.h
//  ViMASS
//
//  Created by Mac Mini on 9/24/14.
//
//

#import "GiaoDichViewController.h"
#import "DoiTuongNotification.h"

@protocol HienThiChiTietNotificationViewControllerDelegate <NSObject>

- (void)xacNhanTinMuonTien:(DoiTuongNotification*)doiTuongNotification;
- (void)layDuocChiTietTinNotification:(DoiTuongNotification*)doiTuongNotification;

@end

@interface HienThiChiTietNotificationViewController : GiaoDichViewController

- (id)initWithAlertID:(NSString*)alertID;

@property (nonatomic, retain) DoiTuongNotification *mDoiTuongNotification;
@property (nonatomic, assign) id<HienThiChiTietNotificationViewControllerDelegate> mDelegate;
@property (retain, nonatomic) IBOutlet UIButton *mbtnTuChoi;
@property (retain, nonatomic) IBOutlet UIButton *mbtnDongY;
@property (retain, nonatomic) IBOutlet UIView *mViewLuaChon;
@property (retain, nonatomic) IBOutlet UIView *viewXacThuc;
@property (retain, nonatomic) IBOutlet UIWebView *webThanhToan;
@property (nonatomic, retain) NSString *sIDDatVeGiaCaoMayBay;
- (IBAction)suKienChonCloseViewXacThuc:(id)sender;
@end
