//
//  DucNT_ViewOTPConfirm.m
//  ViMASS
//
//  Created by MacBookPro on 7/23/14.
//
//

#import "DucNT_ViewOTPConfirm.h"
#import "Common.h"
#import "DucNT_Token.h"
//#import "DucNT_FinanceController.h"
#import "DucNT_HienThiTokenViewController.h"

@implementation DucNT_ViewOTPConfirm {
    BOOL bClickOtp;
    BOOL isClickOk;
}

@synthesize btnCancel;
@synthesize btnOK;
@synthesize viewMain;
@synthesize edtOTPConfirm;
@synthesize lbThongBao;
@synthesize viewScroll;

@synthesize nLoaiOTP;
@synthesize sSoPhone;
@synthesize sMatKhau;
@synthesize sSeed;

static NSString *const LINK_XAC_NHAN_DANG_KY_TOKEN_VOI_TAI_KHOAN_KHAC = @"https://vimass.vn/vmbank/services/auth/confirmOTPCreateTokenWithOtherApp?";
static NSString *const DINH_DANH_KET_NOI_DOI_SO_DIEN_THOAI_TOKEN = @"DINH_DANH_KET_NOI_DOI_SO_DIEN_THOAI_TOKEN";

-(id)initwithNib
{
    self = [[[[NSBundle mainBundle] loadNibNamed:@"DucNT_ViewOTPConfirm" owner:self options:nil] objectAtIndex:0] retain];
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    bClickOtp = NO;
    isClickOk = NO;
    [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.75]];
    [self.viewMain.layer setCornerRadius:4];
    [self.viewMain.layer setMasksToBounds:YES];
    lbThongBao.text = [@"@title_xac_thuc_otp" localizableString];
    [btnOK setTitle:[@"@button_dong_y" localizableString] forState:UIControlStateNormal];
    [btnCancel setTitle:[@"@button_huy" localizableString] forState:UIControlStateNormal];
    [edtOTPConfirm setTextError:[@"@otp_khong_dc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    edtOTPConfirm.inputAccessoryView = nil;
    [self batDauDemThoiGian];
    [viewScroll setContentSize:CGSizeMake(320, viewScroll.frame.size.height)];
    [edtOTPConfirm becomeFirstResponder];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)dealloc {
    [DucNT_LuuRMS xoaThongTinRMSTheoKey:KEY_LOGIN_TEN_VIEWCONTROLLER_CAN_TOI];
    [DucNT_LuuRMS xoaThongTinRMSTheoKey:KEY_LOGIN_KIEU_CHUYEN_GIAO_DIEN];
    if(_mDinhDanhKetNoi)
        [_mDinhDanhKetNoi release];
    if(lbThongBao)
        [lbThongBao release];
    if(edtOTPConfirm)
        [edtOTPConfirm release];
    if(btnCancel)
        [btnCancel release];
    if(btnOK)
        [btnOK release];
    if(viewMain)
        [viewMain release];
    if(viewScroll)
        [viewScroll release];
    [_mtfThoiGianConLai release];
    [super dealloc];
}

- (IBAction)suKienConfirm:(id)sender {
    if (bClickOtp) {
        return;
    }
    isClickOk = YES;
    [self khoiTaoKetNoi];
}

- (IBAction)suKienCancel:(id)sender {
    [self removeFromSuperview];
}

#pragma mark - khởi tạo thông số
//Dùng cho tạo và quên mật khẩu tài khoản
-(void)khoiTaoThamSoTaiKhoan:(int)nKieuOTP withPhone:(NSString *)sPhone
{
    self.nLoaiOTP = nKieuOTP;
    self.sSoPhone = sPhone;
}

//Dùng cho tạo và quên mật khẩu token
-(void)khoiTaoThamSoToken:(int)nKieuOTP withSeedStart:(NSString *)sSeedStart withPhone:(NSString *)sPhone withPass:(NSString *)sMK
{
    NSLog(@"%s >> %s line: %d >> khoi tao tham so ",__FILE__,__FUNCTION__ ,__LINE__);
    self.nLoaiOTP = nKieuOTP;
    self.sSeed = sSeedStart;
    self.sSoPhone = sPhone;
    self.sMatKhau = sMK;
}

#pragma mark - khởi tạo kết nối
-(void)khoiTaoKetNoi
{
    NSLog(@"%s ==============> ket noi : self.nLoaiOTP : %d", __FUNCTION__, self.nLoaiOTP);
    if (!isClickOk) {
        return;
    }
    switch (self.nLoaiOTP) {
        case KIEU_OTP_DANG_KY_TAI_KHOAN:
            [self khoiTaoKetNoiDangKyTaiKhoan];
            break;
        case KIEU_OTP_DANG_KY_TOKEN:
            [self khoiTaoKetNoiDangKyToken];
            break;
        case KIEU_OTP_QUEN_MAT_KHAU_TAI_KHOAN:
            [self khoiTaoKetNoiQuenTaiKhoan];
            break;
        case KIEU_OTP_QUEN_MAT_KHAU_TOKEN:
            [self khoiTaoKetNoiQuenToken];
            break;
        case KIEU_OTP_DANG_KY_TOKEN_TAI_KHOAN_KHAC:
            [self khoiTaoKetNoiDangKyTokenTaiKhoanKhac];
            break;
        default:
            break;
    }
}

- (void)khoiTaoKetNoiDoiSoDienThoaiToken
{
    NSString *sID_ACC = [DucNT_LuuRMS layThongTinDangNhap:KEY_ID_ACC];
//    if(sID_ACC.length == 0)
//    {
//        [UIAlertView alert:@"" withTitle:[@"thong_bao" lowercaseString] block:nil];
//        return;
//    }
    self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_DOI_SO_DIEN_THOAI_TOKEN;
    NSString *SURL = [NSString stringWithFormat:@"https://vimass.vn/vmbank/services/auth/DoiSoDienThoaiTokenWithOtherApp?oldPhone=%@&id=%@&newPhone=%@", sSoPhone, sID_ACC, sSoPhone];
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:self];
    [connect connectGet:SURL withContent:@""];
    [connect release];
}

-(void)khoiTaoKetNoiDangKyTaiKhoan
{
    if([self validate])
    {
        NSDictionary *dictPost = @{
                                   @"phone":self.sSoPhone,
                                   @"otp":edtOTPConfirm.text
                                   };
        NSString *postString = [dictPost JSONString];
        NSLog(@"%s >> %s %d >> json: %@ ",__FILE__,__FUNCTION__ ,__LINE__, postString);
        DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
        [connect setDucnt_connectDelegate:self];
        [connect connect:@"https://vimass.vn/vmbank/services/account/confirmOTPToCreateNewAcc1" withContent:postString];
        [connect release];
    }
}

-(void)khoiTaoKetNoiDangKyTokenTaiKhoanKhac
{
    if([self validate])
    {
        NSString *sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
        NSString * otp = [DucNT_Token OTPFromPIN:edtOTPConfirm.text seed:self.sSeed];
        
        NSString * sUrlContent = [NSString stringWithFormat:@"phone=%@&otp=%@&id=%@", self.sSoPhone, otp, sTaiKhoan];
        DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
        [connect setDucnt_connectDelegate:self];
        [connect connectGet:LINK_XAC_NHAN_DANG_KY_TOKEN_VOI_TAI_KHOAN_KHAC withContent:sUrlContent];
        [connect release];
    }
}

-(void)khoiTaoKetNoiDangKyToken
{
    if([self validate])
    {
        NSString * otp = [DucNT_Token OTPFromPIN:edtOTPConfirm.text seed:self.sSeed];
        NSString * sUrlContent = [NSString stringWithFormat:@"phone=%@&otp=%@", self.sSoPhone, otp];
        DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
        [connect setDucnt_connectDelegate:self];
        [connect connectGet:@"https://vimass.vn/vmbank/services/auth/postBind?" withContent:sUrlContent];
        [connect release];
    }
}

-(void)khoiTaoKetNoiQuenTaiKhoan
{
    if([self validate])
    {
        NSDictionary *dicPost = @{
                                  @"phone":self.sSoPhone,
                                  @"otp":edtOTPConfirm.text
                                  };
        NSString *sPost = [dicPost JSONString];
        DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
        [connect setDucnt_connectDelegate:self];
        [connect connect:@"https://vimass.vn/vmbank/services/account/confirmOTPToForgetPassAcc1" withContent:sPost];
        [connect release];
    }
}

-(void)khoiTaoKetNoiQuenToken
{
    if([self validate])
    {
        NSString * otp = [DucNT_Token OTPFromPIN:edtOTPConfirm.text seed:self.sSeed];
        NSString * sUrlContent = [NSString stringWithFormat:@"phone=%@&otp=%@", self.sSoPhone, otp];
        DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
        [connect setDucnt_connectDelegate:self];
        [connect connectGet:@"https://vimass.vn/vmbank/services/auth/confirmOTPForgetPassSoftToken?" withContent:sUrlContent];
        [connect release];
    }
}

#pragma mark - khởi tạo cho textField
-(BOOL)validate
{
    NSArray *tfs = @[edtOTPConfirm];
    ExTextField *first = nil;
    BOOL flg = YES;
    for (ExTextField *tf in tfs)
    {
        flg = [tf validate] && flg;
        if (flg == NO && first == nil)
            first = tf;
    }
    if (first)
        [first show_error];
    
    return flg;
}

-(void)khoiTaoTextField
{
    [edtOTPConfirm setBackgroundImage:[Common stretchImage:@"login_txt_bg"] forState:UIControlStateNormal];
    [edtOTPConfirm setBackgroundImage:[Common stretchImage:@"login_txt_bg"] forState:UIControlStateHighlighted];
    [edtOTPConfirm setTextError:[@"@otp_khong_dc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
}

#pragma mark - xuLyTimer

- (void)batDauDemThoiGian
{
    mTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(capNhatDemThoiGian) userInfo:nil repeats:YES];
    self.mTongSoThoiGian = THOI_GIAN_CHO_XAC_THUC_SMS;
}

- (void)ketThucDemThoiGian
{
    if(mTimer)
    {
        [mTimer invalidate];
        mTimer = nil;
        [self removeFromSuperview];
    }
}

- (void)capNhatDemThoiGian
{
    _mTongSoThoiGian --;
    [self.mtfThoiGianConLai setText:[NSString stringWithFormat:@"Còn lại %ld s", (long)self.mTongSoThoiGian]];
    if(_mTongSoThoiGian == 0)
    {
        [self ketThucDemThoiGian];
    }
}


#pragma mark - service delegate
-(void)ketNoiThanhCong:(NSString *)sKetQua
{
    [edtOTPConfirm resignFirstResponder];
    if([self.mDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_DOI_SO_DIEN_THOAI_TOKEN])
    {
        return [self xuLyKetNoiDoiSoDienThoaiTokenThanhCong:sKetQua];
    }
    NSLog(@"%s >> %s line: %d >> sKQ: %@ ",__FILE__,__FUNCTION__ ,__LINE__, sKetQua);
    switch (nLoaiOTP)
    {
        case KIEU_OTP_DANG_KY_TAI_KHOAN:
            [self xuLyKetNoiTaiKhoanThanhCong:sKetQua];
            break;
        case KIEU_OTP_DANG_KY_TOKEN:
            [self xuLyKetNoiTokenThanhCong:sKetQua];
            break;
        case KIEU_OTP_QUEN_MAT_KHAU_TOKEN:
            /*Quy trình trả về giống hệt đăng ký*/
            [self xuLyKetNoiTokenThanhCong:sKetQua];
            break;
        case KIEU_OTP_QUEN_MAT_KHAU_TAI_KHOAN:
            /*Quy trình giống hệt đăng ký tài khoản*/
            [self xuLyKetNoiTaiKhoanThanhCong:sKetQua];
            break;
        case KIEU_OTP_DANG_KY_TOKEN_TAI_KHOAN_KHAC:
            [self xuLyKetNoiTaoTokenTaiKhoanKhacThanhCong:sKetQua];
            break;
        default:
            break;
    }
}

#pragma mark - xử lý kết quả kết nối

- (void)xuLyKetNoiDoiSoDienThoaiTokenThanhCong:(NSString*)sKQ
{
    NSDictionary *dicKetQua = [sKQ objectFromJSONString];
    int nCode = [[dicKetQua objectForKey:@"msgCode"] intValue];
    NSString *message = [dicKetQua objectForKey:@"msgContent"];
    if(nCode == 1)
    {
        [self xuLyVoiTokenThanhCong];
    }
    else
    {
        [[[[UIAlertView alloc] initWithTitle:[@"@thong_bao" localizableString]  message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
    }
}

- (void)xuLyKetNoiTaoTokenTaiKhoanKhacThanhCong:(NSString*)sKQ
{
    NSDictionary *dicKetQua = [sKQ objectFromJSONString];
    int nCode = [[dicKetQua objectForKey:@"msgCode"] intValue];
    NSString *message = [dicKetQua objectForKey:@"msgContent"];
    if(nCode == 1)
    {
        NSString * decrypt_seed = [DucNT_Token decryptSEED:self.sSeed withPin:edtOTPConfirm.text];
        NSString * user_seed = [DucNT_Token encryptSEED:decrypt_seed withPin:sMatKhau];
        [DucNT_Token luuSeedToken:user_seed];
        
        if(self.nLoaiOTP == KIEU_OTP_DANG_KY_TOKEN_TAI_KHOAN_KHAC)
        {
            [DucNT_LuuRMS luuThongTinDangNhap:KEY_LOGIN_SO_DIEN_THOAI_DANG_KI_TOKEN value:sSoPhone];
            [DucNT_LuuRMS luuThongTinDangNhap:KEY_LOGIN_TRANG_THAI_CO_TOKEN value:@"1"];
        }
        
        [self xuLyVoiTokenThanhCong];
    }
    else
    {
        [[[[UIAlertView alloc] initWithTitle:[@"@thong_bao" localizableString]  message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
    }
    
}

-(void) xuLyKetNoiTaiKhoanThanhCong:(NSString *)sKQ
{
    NSLog(@"%s >> %s line: %d >> sKQ: %@ ",__FILE__,__FUNCTION__ ,__LINE__, sKQ);
    NSDictionary *dicKetQua = [sKQ objectFromJSONString];
    int nCode = [[dicKetQua objectForKey:@"msgCode"] intValue];
    NSString *message = [dicKetQua objectForKey:@"msgContent"];
    if(nCode == 1)
    {
//        DucNT_LoginSceen *ctrl = [[DucNT_LoginSceen alloc] init];
//        ctrl.sTenViewController = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_TEN_VIEWCONTROLLER_CAN_TOI];
//        ctrl.sKieuChuyenGiaoDien = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_KIEU_CHUYEN_GIAO_DIEN];
//        [viewControllerParent.navigationController presentModalViewController:ctrl animated:YES];
//        [ctrl release];
        
        /*push notification về cho viewController -> chuyển lại về đăng nhập*/
        [[NSNotificationCenter defaultCenter] postNotificationName:@"XAC_THUC_OTP_THANH_CONG" object:nil];
        [self removeFromSuperview];
    }
    else
    {
        [[[[UIAlertView alloc] initWithTitle:[@"@thong_bao" localizableString]  message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            isClickOk = NO;
        });
    }
}

-(void)xuLyKetNoiTokenThanhCong:(NSString *)sKQ
{
    NSDictionary *dicKetQua = [sKQ objectFromJSONString];
    int nCode = [[dicKetQua objectForKey:@"msgCode"] intValue];
    NSString *message = [dicKetQua objectForKey:@"msgContent"];
    if(nCode == 1)
    {
        NSString * decrypt_seed = [DucNT_Token decryptSEED:self.sSeed withPin:edtOTPConfirm.text];
        NSString * user_seed = [DucNT_Token encryptSEED:decrypt_seed withPin:sMatKhau];
        [DucNT_Token luuSeedToken:user_seed];
        [DucNT_Token luuMatKhauVanTayToken:sMatKhau];
        
//      lưu lại trạng thái token luôn để tránh trường hợp phải đăng nhập lại mới lấy giá trị thay đổi
        if(self.nLoaiOTP == KIEU_OTP_DANG_KY_TOKEN)
        {
            [DucNT_LuuRMS luuThongTinDangNhap:KEY_LOGIN_SO_DIEN_THOAI_DANG_KI_TOKEN value:sSoPhone];
            [DucNT_LuuRMS luuThongTinDangNhap:KEY_LOGIN_TRANG_THAI_CO_TOKEN value:@"1"];
            [self xuLyVoiTokenThanhCong];
        }
        else if(self.nLoaiOTP == KIEU_OTP_QUEN_MAT_KHAU_TOKEN)
        {
            [DucNT_LuuRMS luuThongTinDangNhap:KEY_LOGIN_SO_DIEN_THOAI_DANG_KI_TOKEN value:sSoPhone];
            NSString *sTaiKhoanHienTai = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
            if(![Common kiemTraLaSoDienThoai:sTaiKhoanHienTai])
            {
                [self khoiTaoKetNoiDoiSoDienThoaiToken];
            }
            else
            {
                [self xuLyVoiTokenThanhCong];
            }
        }
    }
    else
    {
        [[[[UIAlertView alloc] initWithTitle:[@"@thong_bao" localizableString]  message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
    }
}

- (UIViewController *)getParentViewController {
    UIResponder *responder = self;
    while (![responder isKindOfClass:[UIViewController class]]) {
        responder = [responder nextResponder];
        if (nil == responder) {
            break;
        }
    }
    return (UIViewController *)responder;
}

- (void)xuLyVoiTokenThanhCong
{
    UIViewController *viewControllerParent = [self getParentViewController];
    UINavigationController *navController = viewControllerParent.navigationController;
    [[navController retain] autorelease];
    [navController popViewControllerAnimated:NO];
    DucNT_HienThiTokenViewController *hienThiToken = [[DucNT_HienThiTokenViewController alloc] initWithNibName:@"DucNT_HienThiTokenViewController" bundle:nil];
    [navController pushViewController:hienThiToken animated:YES];
    [hienThiToken release];
}


@end
