//
//  DucNT_ViewOTPConfirm.h
//  ViMASS
//
//  Created by MacBookPro on 7/23/14.
//
//

#import <UIKit/UIKit.h>
#import "ExTextField.h"
#import "DucNT_ServicePost.h"
#import "TPKeyboardAvoidAcessory.h"

enum OTP
{
    KIEU_OTP_DANG_KY_TAI_KHOAN = 0,
    KIEU_OTP_DANG_KY_TOKEN = 1,
    KIEU_OTP_QUEN_MAT_KHAU_TAI_KHOAN = 2,
    KIEU_OTP_QUEN_MAT_KHAU_TOKEN = 3,
    KIEU_OTP_DANG_KY_TOKEN_TAI_KHOAN_KHAC = 4
};

@interface DucNT_ViewOTPConfirm : UIView<DucNT_ServicePostDelegate>
{
    NSTimer *mTimer;
}

@property (assign, nonatomic) NSInteger mTongSoThoiGian;

@property (retain, nonatomic) IBOutlet TPKeyboardAvoidAcessory *viewScroll;
@property (retain, nonatomic) IBOutlet UILabel *lbThongBao;
@property (retain, nonatomic) IBOutlet ExTextField *edtOTPConfirm;
@property (retain, nonatomic) IBOutlet UIButton *btnCancel;
@property (retain, nonatomic) IBOutlet UIButton *btnOK;
@property (retain, nonatomic) IBOutlet UIView *viewMain;
@property (retain, nonatomic) IBOutlet ExTextField *mtfThoiGianConLai;

- (IBAction)suKienConfirm:(id)sender;
- (IBAction)suKienCancel:(id)sender;

@property (retain, nonatomic) NSString *sSoPhone;
@property (retain, nonatomic) NSString *sSeed;
@property (retain, nonatomic) NSString *sMatKhau;
@property (nonatomic, assign) int nLoaiOTP;
@property (retain, nonatomic) NSString *mDinhDanhKetNoi;

-(id)initwithNib;

-(void)khoiTaoThamSoTaiKhoan:(int)nKieuOTP withPhone:(NSString *)sPhone;
-(void)khoiTaoThamSoToken:(int)nKieuOTP withSeedStart:(NSString *)sSeedStart withPhone:(NSString *)sPhone withPass:(NSString *)sMK;
@end
