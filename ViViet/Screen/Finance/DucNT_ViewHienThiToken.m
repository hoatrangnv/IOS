//
//  DucNT_ViewHienThiToken.m
//  ViMASS
//
//  Created by MacBookPro on 7/9/14.
//
//

#import "DucNT_ViewHienThiToken.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "RoundAlert.h"
#import "Alert+Block.h"
#import "Common.h"

@implementation DucNT_ViewHienThiToken
{
    NSTimer *timer;
    bool bChayLanDau;
}

@synthesize mbtnVanTay;
@synthesize edtID;
@synthesize edtPassToken;
@synthesize edtTimer;
@synthesize lbToken;
@synthesize btnTestOTP;
@synthesize viewKhung;

#pragma mark - init
/*
 * gọi theo như hiện tại hoặc gọi hàm này ở viewcontroller
 * DucNT_ViewHienThiToken *view =  [DucNT_ViewHienThiToken ducnt_ViewHienThiToken];
 * sẽ ko vào initWithFrame mà vào initWithCode
 * gọi awakeFromNib để load dữ liệu ban đầu (= view did load bên controller);
 */
-(id)initWithNib
{
    self = [[[[NSBundle mainBundle] loadNibNamed:@"DucNT_ViewHienThiToken" owner:self options:nil] objectAtIndex:0] retain];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    NSString *sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    
    edtID.text = sTaiKhoan;
    
    timer = nil;
    [viewKhung.layer setCornerRadius:3];
    [viewKhung.layer setMasksToBounds:YES];
    bChayLanDau = true;
    [edtTimer setAlpha:0.0f];
    edtPassToken.max_length = 6;
    edtPassToken.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[@"mat_khau_token" localizableString] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    
    [self startTimer];
    [btnTestOTP setHidden:YES];
    if([self kiemTraCoChucNangQuetVanTay])
    {
        [self xuLyKhiCoChucNangQuetVanTay];
    }
    else
    {
        [self xuLyKhiKhongCoChucNangQuetVanTay];
    }
    
    [_btnDoiToken setTitle:[@"doi_mat_khau_token" localizableString] forState:UIControlStateNormal];
}

- (void)dealloc {
    if(timer)
    {
        NSLog(@"%s >> %s line: %d >> logHerr ",__FILE__,__FUNCTION__ ,__LINE__);
        [timer invalidate];
        timer = nil;
    }
    if(edtID)
        [edtID release];
    if(lbToken)
        [lbToken release];
    if(edtPassToken)
        [edtPassToken release];
    if(edtTimer)
        [edtTimer release];
    if(btnTestOTP)
        [btnTestOTP release];
    if(viewKhung)
        [viewKhung release];
    [mbtnVanTay release];
    [_btnDoiToken release];
    [super dealloc];
}

- (IBAction)suKienKetThucBanPhim:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)suKienBamNutXacThucVanTay:(UIButton *)sender
{
    [self xuLySuKienHienThiChucNangVanTayVoiTieuDe:[@"su_dung_van_tay_dang_nhap_tai_khoan_token_VIMASS" localizableString]];
}

#pragma mark - vantay

- (void)xuLyKhiCoChucNangQuetVanTay
{
    [mbtnVanTay setHidden:NO];
}

- (void)xuLyKhiKhongCoChucNangQuetVanTay
{
    [mbtnVanTay setHidden:YES];
}

- (BOOL)kiemTraCoChucNangQuetVanTay
{
    LAContext *laContext = [[[LAContext alloc] init] autorelease];
    NSError *error = nil;
    if([laContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
    {
        if (error != NULL) {
            // handle error
        } else {
            
            if (@available(iOS 11.0.1, *)) {
                if (laContext.biometryType == LABiometryTypeFaceID) {
                    [self.mbtnVanTay setImage:[UIImage imageNamed:@"face-id"] forState:UIControlStateNormal];
                    NSLog(@"FaceId support");
                    return YES;
                } else if (laContext.biometryType == LABiometryTypeTouchID) {
                    //localizedReason = "Unlock using Touch ID"
                    [self.mbtnVanTay setImage:[UIImage imageNamed:@"finger"] forState:UIControlStateNormal];
                    NSLog(@"TouchId support");
                    return YES;
                } else {
                    //localizedReason = "Unlock using Application Passcode"
                    NSLog(@"No Biometric support");
                    return NO;
                }
            } else {
                // Fallback on earlier versions
            }
            
            
            [laContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"Test Reason" reply:^(BOOL success, NSError * _Nullable error) {
                
                if (error != NULL) {
                    // handle error
                } else if (success) {
                    // handle success response
                } else {
                    // handle false response
                }
            }];
        }
        return NO;
    }
    return NO;
}

- (void)xuLySuKienHienThiChucNangVanTayVoiTieuDe:(NSString*)sTieuDe
{
    if([DucNT_Token daTonTaiMatKhauVanTay])
    {
        __block DucNT_ViewHienThiToken *weakSelf = self;
        [RoundAlert show];
        LAContext *laContext = [[[LAContext alloc] init] autorelease];
        NSError *error = nil;
        if([laContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
        {
            if (error != NULL) {
                // handle error
                dispatch_async(dispatch_get_main_queue(), ^{
                    [RoundAlert hide];
                });
            } else {
                if (@available(iOS 11.0.1, *)) {
                    if (laContext.biometryType == LABiometryTypeFaceID) {
                        //localizedReason = "Unlock using Face ID"
                        NSLog(@"FaceId support");
                    } else if (laContext.biometryType == LABiometryTypeTouchID) {
                        //localizedReason = "Unlock using Touch ID"
                        NSLog(@"TouchId support");
                    } else {
                        //localizedReason = "Unlock using Application Passcode"
                        NSLog(@"No Biometric support");
                    }
                } else {
                    // Fallback on earlier versions
                }
                [laContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:sTieuDe reply:^(BOOL success, NSError * _Nullable error) {
                    if (error != NULL) {
                        // handle error
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [RoundAlert hide];
                            if(error.code == LAErrorAuthenticationFailed){
                                [weakSelf hienThiThongBaoDienMatKhau];
                            }
                        });
                    } else if (success) {
                        // handle success response
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [RoundAlert hide];
                            [self xuLySuKienXacThucVanTayThanhCong];
                        });
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [RoundAlert hide];
                        });
                    }
                }];
            }
        }
    }
    else
    {
        [UIAlertView alert:[@"thong_bao_chua_co_xac_thuc_van_tay_token" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
    }
}

- (void)hienThiThongBaoDienMatKhau
{
    [UIAlertView alert:[@"thong_bao_xac_thuc_van_tay_khong_dung" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
    [mbtnVanTay setHidden:YES];
}

- (void)xuLySuKienXacThucVanTayThanhCong
{
    NSString *sMatKhauVanTay = [DucNT_Token layMatKhauVanTayToken];
    [edtPassToken setText:sMatKhauVanTay];
}



#pragma mark - hiển thị OTP theo thời gian
-(void)startTimer
{
     timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

-(void)updateTimer
{
    if(edtPassToken.text.length == 6)
    {
        NSInteger nCounter = time(NULL)%30;
        edtTimer.text = [NSString stringWithFormat:@" %@ %ld %@",[@"regLocSer - remaining" localizableString], (long)(30 - nCounter), [@"so_giay" localizableString]];
        if(bChayLanDau)
        {
            NSString *sSeed = [DucNT_Token layThongTinTrongKeyChain:[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP]];
            NSString *sOTP = [DucNT_Token OTPFromPIN:edtPassToken.text seed:sSeed];
            NSLog(@"%s >> %s line: %d >> otp: %@ - %ld",__FILE__,__FUNCTION__ ,__LINE__, sOTP, time(NULL)/30);
            lbToken.text = [self splitOTP:sOTP];
            [edtTimer setAlpha:1.0f];
            bChayLanDau = false;
        }
        else{
            if(time(NULL)%30 == 0)
            {
                NSString *sSeed = [DucNT_Token layThongTinTrongKeyChain:[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP]];
                NSString *sOTP = [DucNT_Token OTPFromPIN:edtPassToken.text seed:sSeed];
                NSLog(@"%s >> %s line: %d >> otp: %@ ",__FILE__,__FUNCTION__ ,__LINE__, sOTP);
                lbToken.text = [self splitOTP:sOTP];
            }
        }
    }
    else
    {
        bChayLanDau = true;
        lbToken.text = @"000 000";
        edtTimer.text =[NSString stringWithFormat:@"%@ %@ %@", [@"regLocSer - remaining" localizableString], @"0", [@"so_giay" localizableString]];
        [edtTimer setAlpha:0.0f];
    }
}


-(void)stopTimer
{
    if(timer)
    {
        [timer invalidate];
        timer = nil;
    }
}

-(NSString *)splitOTP:(NSString *)sOTP
{
    NSMutableString *splitOTP = [NSMutableString stringWithString:sOTP];
    [splitOTP insertString:@" " atIndex:3];
    return splitOTP;
}

#pragma mark - test kiểm tra OTP chính xác (note: bỏ dòng 130 hàm splitOTP khi kiểm tra + setHiden = no)
- (IBAction)testOTPConfirm:(id)sender
{
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:self];
    [connect connectGet:[NSString stringWithFormat:@"%@%@", LINK_BASE, @"/auth/getAuth?"] withContent:[NSString stringWithFormat:@"phone=%@%@%@%@",[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP], @"&otp=", lbToken.text , @"&tokenType=1"]];
    [connect release];
}

- (IBAction)suKienClickSetting:(id)sender {
    if (self.delegate) {
        [self.delegate suKienClickSetting];
    }
}

#pragma mark - xử lý kết nối
-(void)ketNoiThanhCong:(NSString *)sKetQua
{
    NSLog(@"%s >> %s line: %d >> sKQ: %@ ",__FILE__,__FUNCTION__ ,__LINE__, sKetQua);
}

#pragma mark - private
- (BOOL)kiemTraLaSoDienThoai:(NSString*)sXau
{
    NSError *error = nil;
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:PATTERN_PHONE
                                                                      options:NSRegularExpressionCaseInsensitive
                                                                        error:&error];
    NSString *s = sXau;
    NSArray *arr = [regex matchesInString:s
                                  options:0
                                    range:NSMakeRange(0,s.length)];
    [regex release];
    if (arr != nil && error == nil && arr.count == 1)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
