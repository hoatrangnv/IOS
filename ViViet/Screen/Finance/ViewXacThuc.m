//
//  ViewXacThuc.m
//  ViViMASS
//
//  Created by DucBT on 1/23/15.
//
//

#import "Common.h"
#import "JSONKit.h"
#import "DucNT_LuuRMS.h"
#import "ViewXacThuc.h"
#import "Alert+Block.h"
#import "DucNT_Token.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "RoundAlert.h"

@implementation ViewXacThuc 
{
    NSTimer *mTimer;
    NSString *mDinhDanhKetNoi;
    int mTypeAuthenticate;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - life circle

- (void)awakeFromNib
{
    mTypeAuthenticate = TYPE_AUTHENTICATE_TOKEN;
    self.mtfMaXacThuc.max_length = 6;
    self.mtfMaXacThuc.placeholder = [@"mat_khau_token" localizableString];
    [self.mtfMaXacThuc setTextError:[@"@mat_khau_token_khong_dc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    [self.mtfMaXacThuc setTextError:[@"@mat_khau_token_require" localizableString] forType:ExTextFieldTypeViTokenPassword];
    self.mtfMaXacThuc.inputAccessoryView = nil;
    [self.mbtnThucHien setTitle:[@"button_thuc_hien" localizableString] forState:UIControlStateNormal];
    [self khoiTaoGiaoDienChuyenTien];
}


- (void)setMThongTinVi:(DucNT_TaiKhoanViObject *)mThongTinVi
{
    if(_mThongTinVi)
        [_mThongTinVi release];
    _mThongTinVi = [mThongTinVi retain];
    int isToken = [_mThongTinVi.nIsToken intValue];
    if(isToken > 0)
    {
        [self suKienBamNutToken:self.mbtnToken];
    }
}

#pragma mark - khoiTao
- (void)khoiTaoGiaoDienChuyenTien
{
    [self.mbtnToken setTitle:@"TOKEN" forState:UIControlStateNormal];
    [self.mbtnToken setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
    [self.mbtnSMS setTitle:@"SMS" forState:UIControlStateNormal];
    [self.mbtnSMS setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
    [self.mbtnEmail setTitle:@"EMAIL" forState:UIControlStateNormal];
    [self.mbtnEmail setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
    
    self.mbtnSMS.selected = NO;
    self.mbtnToken.selected = NO;
    self.mbtnEmail.selected = NO;
    self.mbtnEmail.enabled = YES;
    self.mbtnSMS.enabled = YES;
    self.mbtnToken.enabled = YES;
    [self.mtfMaXacThuc setText:@""];
}

#pragma mark - Touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if(touch.view != self.mViewMain)
    {
        [self ketThucDemThoiGian];
        [self setHidden:YES];
//        [self removeFromSuperview];
    }
}

#pragma mark - suKien

- (IBAction)suKienBamNutThucHien:(UIButton *)sender
{
    if([self.mtfMaXacThuc validate])
    {
        if([self.mDelegate respondsToSelector:@selector(xuLySuKienXacThucVoiKieu:token:otp:)])
        {
            NSString *sToken = @"";
            NSString *sOtp = @"";
            if(mTypeAuthenticate == TYPE_AUTHENTICATE_TOKEN)
            {
                NSString *sSeed = [DucNT_Token laySeedTokenHienTai];
                if(sSeed.length > 0)
                {
                    sToken = [DucNT_Token OTPFromPIN:self.mtfMaXacThuc.text seed:sSeed];
                }
                else
                {
                    [[[[UIAlertView alloc] initWithTitle:[@"@thong_bao" localizableString]  message:[@"@can_tao_token" localizableString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
                    return;
                }
            }
            else
            {
                sOtp = self.mtfMaXacThuc.text;
            }
            [self.mDelegate xuLySuKienXacThucVoiKieu:mTypeAuthenticate token:sToken otp:sOtp];
        }
    }
    else
    {
        [self.mtfMaXacThuc show_error];
    }
}

- (IBAction)suKienBamNutToken:(UIButton *)sender
{
    if([self.mThongTinVi.nIsToken intValue] > 0)
    {
        if(!self.mbtnToken.selected)
        {
            mTypeAuthenticate = TYPE_AUTHENTICATE_TOKEN;
            [self.mbtnToken setSelected:YES];
            [self.mbtnToken setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            
            if(self.mbtnSMS.enabled)
            {
                [self.mbtnSMS setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
                [self.mbtnSMS setTitleColor:nil forState:UIControlStateNormal];
                [self.mbtnSMS setSelected:NO];
            }
            
            if(self.mbtnEmail.enabled)
            {
                [self.mbtnEmail setSelected:NO];
                [self.mbtnEmail setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
                [self.mbtnEmail setTitleColor:nil forState:UIControlStateNormal];
            }
            
            self.mtfMaXacThuc.placeholder = [@"mat_khau_token" localizableString];
            [self.mtfMaXacThuc setTextError:[@"@mat_khau_token_khong_dc_de_trong" localizableString]
                                    forType:ExTextFieldTypeEmpty];
        }
    }
    else
    {
        [UIAlertView alert:[@"thong_bao_loi_chua_dang_ky_token" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
    }
}

- (IBAction)suKienBamNutSMS:(UIButton *)sender
{
    if(![self.mThongTinVi.sPhoneAuthenticate isEqualToString:@""])
    {
        if(!self.mbtnSMS.selected)
        {
            [self hienThiHopThoaiHaiNutBamKieu:HOP_THOAI_XAC_NHAN_XAC_THUC_SMS cauThongBao:[NSString stringWithFormat:@"%@ %@", [@"thong_bao_ma_xac_thuc_duoc_gui_ve_so_dien_thoai" localizableString], self.mThongTinVi.sPhoneAuthenticate]];
        }
    }
    else
    {
        [self.mtfMaXacThuc show_error];
        [UIAlertView alert:[@"thong_bao_chua_dang_ky_so_dien_thoai" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
    }
}

- (IBAction)suKienBamNutEmail:(UIButton *)sender
{
    if(![self.mThongTinVi.sThuDienTu isEqualToString:@""])
    {
        if(!self.mbtnEmail.selected)
        {
            [self hienThiHopThoaiHaiNutBamKieu:HOP_THOAI_XAC_NHAN_XAC_THUC_EMAIL cauThongBao:[NSString stringWithFormat:@"%@ %@", [@"thong_bao_ma_xac_thuc_duoc_gui_ve_thu_dien_tu" localizableString], self.mThongTinVi.sThuDienTu]];
        }
    }
    else
    {
        [self.mtfMaXacThuc show_error];
        [UIAlertView alert:[@"thong_bao_chua_dang_ky_thu_dien_tu" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
    }
}

- (IBAction)suKienBamNutMatKhauVanTay:(id)sender
{
    if([self.mDelegate respondsToSelector:@selector(xuLySuKienBamNutVanTay)])
    {
        [self.mDelegate xuLySuKienBamNutVanTay];
    }
}

#pragma mark - hienThiHopThoai
- (void)hienThiHopThoaiHaiNutBamKieu:(int)nKieu cauThongBao:(NSString*)sCauThongBao
{
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:[@"thong_bao" localizableString] message:sCauThongBao delegate:self cancelButtonTitle:[@"huy" localizableString] otherButtonTitles:[@"dong_y" localizableString], nil] autorelease];
    alertView.tag = nKieu;
    [alertView show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        if(alertView.tag == HOP_THOAI_XAC_NHAN_XAC_THUC_SMS)
        {
            [self xuLySuKienXacThucBangSMS];
        }
        else if(alertView.tag == HOP_THOAI_XAC_NHAN_XAC_THUC_EMAIL)
        {
            [self xuLySuKienXacThucBangEmail];
        }
        
    }
}
#pragma mark - DucNT_ServicePostDelegate
-(void)ketNoiThanhCong:(NSString *)sKetQua
{
    NSDictionary *dicKetQua = [sKetQua objectFromJSONString];
    int nCode = [[dicKetQua objectForKey:@"msgCode"] intValue];
    NSString *message = [dicKetQua objectForKey:@"msgContent"];
    if([mDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_LAY_MA_XAC_THUC])
    {
        if(nCode == 31)
        {
            //Chay giay thong bao
            self.mTongSoThoiGian = THOI_GIAN_CHO_XAC_THUC_SMS;
            [self batDauDemThoiGian];
        }
        else if(nCode == 32)
        {
            self.mTongSoThoiGian = THOI_GIAN_CHO_XAC_THUC_EMAIL;
            [self batDauDemThoiGian];
        }
        else
        {
            [UIAlertView alert:message withTitle:[@"thong_bao" localizableString] block:nil];
        }
    }
}

#pragma mark - xuLyTimer
- (void)batDauDemThoiGian
{
    _mbtnVanTay.enabled = NO;
    mTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(capNhatDemThoiGian) userInfo:nil repeats:YES];
}

- (void)ketThucDemThoiGian
{
    _mbtnVanTay.enabled = YES;
    [self khoiTaoGiaoDienChuyenTien];
    int isToken = [_mThongTinVi.nIsToken intValue];
    if(isToken > 0)
    {
        [self suKienBamNutToken:self.mbtnToken];
    }
    if(mTimer)
    {
        [mTimer invalidate];
        mTimer = nil;
    }
}

- (void)capNhatDemThoiGian
{
    _mTongSoThoiGian --;
    if(mTypeAuthenticate == TYPE_AUTHENTICATE_SMS)
    {
        self.mbtnSMS.enabled = NO;
        [self.mbtnSMS setTitle:[NSString stringWithFormat:@"%ld s", (long)self.mTongSoThoiGian] forState:UIControlStateNormal];
        self.mbtnSMS.enabled = YES;
    }
    else if(mTypeAuthenticate == TYPE_AUTHENTICATE_EMAIL)
    {
        self.mbtnEmail.enabled = NO;
        [self.mbtnEmail setTitle:[NSString stringWithFormat:@"%ld s", (long)self.mTongSoThoiGian] forState:UIControlStateNormal];
        self.mbtnEmail.enabled = YES;
    }
    if(_mTongSoThoiGian == 0)
    {
        [self ketThucDemThoiGian];
    }
}


#pragma mark - xu ly su kien

- (void)xuLySuKienXacThucBangEmail
{
    if(!self.mbtnEmail.selected)
    {
        mTypeAuthenticate = TYPE_AUTHENTICATE_EMAIL;
        [self.mbtnEmail setSelected:YES];
        [self.mbtnEmail setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        self.mTongSoThoiGian = THOI_GIAN_CHO_XAC_THUC_EMAIL;
        [self.mbtnEmail setTitle:[NSString stringWithFormat:@"%ld s", (long)self.mTongSoThoiGian] forState:UIControlStateNormal];
        
        if(self.mbtnToken.enabled)
        {
            [self.mbtnToken setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
            [self.mbtnToken setTitleColor:nil forState:UIControlStateNormal];
            [self.mbtnToken setSelected:NO];
            [self.mbtnToken setEnabled:NO];
        }
        
        if(self.mbtnSMS.enabled)
        {
            [self.mbtnSMS setSelected:NO];
            [self.mbtnSMS setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
            [self.mbtnSMS setTitleColor:nil forState:UIControlStateNormal];
            [self.mbtnSMS setEnabled:NO];
        }
        
        self.mtfMaXacThuc.placeholder = [@"ma_xac_thuc" localizableString];
        [self.mtfMaXacThuc setTextError:[@"ma_xac_thuc_khong_duoc_de_trong" localizableString]
                                forType:ExTextFieldTypeEmpty];
        
        
        NSString *sEmailAuthenticate = self.mThongTinVi.sThuDienTu;
        int nKieuNhanXacThuc = 0;

        nKieuNhanXacThuc = FUNC_XOA_TAI_KHOAN_THUONG_DUNG;
        [self xuLyKetNoiLayMaXacThucChuyenDenTaiKhoan:sEmailAuthenticate kieuXacThuc:nKieuNhanXacThuc];
    }
}

- (void)xuLySuKienXacThucBangSMS
{
    if(!self.mbtnSMS.selected)
    {
        mTypeAuthenticate = TYPE_AUTHENTICATE_SMS;
        [self.mbtnSMS setSelected:YES];
        [self.mbtnSMS setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        self.mTongSoThoiGian = THOI_GIAN_CHO_XAC_THUC_SMS;
        [self.mbtnSMS setTitle:[NSString stringWithFormat:@"%ld s", (long)self.mTongSoThoiGian] forState:UIControlStateNormal];
        
        if(self.mbtnToken.enabled)
        {
            [self.mbtnToken setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
            [self.mbtnToken setTitleColor:nil forState:UIControlStateNormal];
            [self.mbtnToken setSelected:NO];
            [self.mbtnToken setEnabled:NO];
        }
        
        if(self.mbtnEmail.enabled)
        {
            [self.mbtnEmail setSelected:NO];
            [self.mbtnEmail setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
            [self.mbtnEmail setTitleColor:nil forState:UIControlStateNormal];
            [self.mbtnEmail setEnabled:NO];
        }
        
        self.mtfMaXacThuc.placeholder = [@"ma_xac_thuc" localizableString];
        [self.mtfMaXacThuc setTextError:[@"ma_xac_thuc_khong_duoc_de_trong" localizableString]
                                forType:ExTextFieldTypeEmpty];
        
        NSString *sPhoneAuthenticate = self.mThongTinVi.sPhoneAuthenticate;
        int nKieuNhanXacThuc = 0;

        nKieuNhanXacThuc = FUNC_XOA_TAI_KHOAN_THUONG_DUNG;
        
        [self xuLyKetNoiLayMaXacThucChuyenDenTaiKhoan:sPhoneAuthenticate kieuXacThuc:nKieuNhanXacThuc];
    }
}

#pragma mark - xu ly ket noi

- (void)xuLyKetNoiLayMaXacThucChuyenDenTaiKhoan:(NSString*)sSendTo kieuXacThuc:(int)nKieu
{
    NSString *sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    int typeAuthenticate = 1;
    //    if(![Common kiemTraLaSoDienThoai:sSendTo])
    if([Common kiemTraLaMail:sSendTo])
        typeAuthenticate = 2;
    
    NSMutableString *sUrl = [[NSMutableString alloc] init];
    [sUrl appendFormat:@"https://vimass.vn/vmbank/services/account/getOTP?"];
    [sUrl appendFormat:@"id=%@&", sTaiKhoan];
    [sUrl appendFormat:@"appId=%d&", APP_ID];
    [sUrl appendFormat:@"funcId=%d&", nKieu];
    [sUrl appendFormat:@"typeAuthenticate=%d&", typeAuthenticate];
    [sUrl appendFormat:@"sendTo=%@", sSendTo];
    
    mDinhDanhKetNoi = DINH_DANH_KET_NOI_LAY_MA_XAC_THUC;
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:self];
    [connect connectGet:sUrl withContent:@""];
    [connect release];
    [sUrl release];
}

- (void)xuLyKhiXacThucVanTayThanhCong
{
    mTypeAuthenticate = TYPE_AUTHENTICATE_TOKEN;
    if([self.mDelegate respondsToSelector:@selector(xuLySuKienXacThucVoiKieu:token:otp:)])
    {
        NSString *sToken = @"";
        NSString *sOtp = @"";
        if(mTypeAuthenticate == TYPE_AUTHENTICATE_TOKEN)
        {
            NSString *sSeed = [DucNT_Token laySeedTokenHienTai];
            NSString *token = [DucNT_Token layMatKhauVanTayToken];
            if(sSeed.length > 0)
            {
                sToken = [DucNT_Token OTPFromPIN:token seed:sSeed];
            }
            else
            {
                [[[[UIAlertView alloc] initWithTitle:[@"@thong_bao" localizableString]  message:[@"@can_tao_token" localizableString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
                return;
            }
        }
        else
        {
            sOtp = @"";
        }
        [self.mDelegate xuLySuKienXacThucVoiKieu:mTypeAuthenticate token:sToken otp:sOtp];
    }
}


#pragma mark - dealloc
- (void)dealloc {
    NSLog(@"%s ====>", __FUNCTION__);
    if(_mThongTinVi)
        [_mThongTinVi release];
    [_mbtnToken release];
    [_mbtnSMS release];
    [_mbtnEmail release];
    [_mbtnThucHien release];
    [_mtfMaXacThuc release];
    [_mViewMain release];
    [_mbtnVanTay release];
    [_lblTitle release];
    [super dealloc];
}
@end
