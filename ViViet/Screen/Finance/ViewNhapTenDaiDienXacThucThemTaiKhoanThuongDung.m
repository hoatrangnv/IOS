//
//  ViewNhapTenDaiDienXacThucThemTaiKhoanThuongDung.m
//  ViViMASS
//
//  Created by DucBT on 2/2/15.
//
//



#import "Common.h"
#import "RoundAlert.h"
#import "Alert+Block.h"
#import "DucNT_Token.h"
#import "DucNT_LuuRMS.h"
#import "BranchCoreData.h"
#import "BankCoreData.h"
#import "DucNT_ServicePost.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "ViewNhapTenDaiDienXacThucThemTaiKhoanThuongDung.h"


#define KIEU_CHUYEN_TIEN 0
#define KIEU_RUT_TIEN 1

@interface ViewNhapTenDaiDienXacThucThemTaiKhoanThuongDung () <UIAlertViewDelegate, DucNT_ServicePostDelegate>
{
    NSTimer *mTimer;
    NSString *mDinhDanhKetNoi;
    int mTypeAuthenticate;
    int mKieuChuyenTien;
}

@property (assign, nonatomic) NSInteger mTongSoThoiGian;
@property (retain, nonatomic) NSArray *mDanhSachNganHang;

@end

@implementation ViewNhapTenDaiDienXacThucThemTaiKhoanThuongDung


#pragma mark - set & get
- (void)setMTaiKhoanThuongDung:(DucNT_TaiKhoanThuongDungObject *)mTaiKhoanThuongDung
{
    if(_mTaiKhoanThuongDung)
        [_mTaiKhoanThuongDung release];
    _mTaiKhoanThuongDung = [mTaiKhoanThuongDung retain];
    int nType = _mTaiKhoanThuongDung.nType;
    if(nType == TAI_KHOAN_VI)
    {
        [_mViewChonTaiKhoanThuong_RutTien setHidden:YES];
        [_mlblTenHienThi setHidden:NO];
    }
    else if(nType == TAI_KHOAN_THE)
    {
        [_mViewChonTaiKhoanThuong_RutTien setHidden:YES];
        [_mlblTenHienThi setHidden:NO];
    }
    else if (nType == TAI_KHOAN_NGAN_HANG)
    {
        [_mViewChonTaiKhoanThuong_RutTien setHidden:NO];
        [_mlblTenHienThi setHidden:YES];
    }
    
    if(_mTaiKhoanThuongDung.nProvinceID > 0)
    {
        [self khoiTaoDanhSachNganHang:_mTaiKhoanThuongDung.nProvinceID];
    }
    else
    {
        [self khoiTaoDanhSachNganHang:1];
    }
}

- (void)setMThongTinVi:(DucNT_TaiKhoanViObject *)mThongTinVi
{
    if(_mThongTinVi)
        [_mThongTinVi release];
    _mThongTinVi = [mThongTinVi retain];
    if([_mThongTinVi.nIsToken intValue] > 0)
    {
        [self suKienBamNutToken:self.mbtnToken];
    }
}

#pragma mark - life circle

- (void)awakeFromNib
{
    [self khoiTaoBanDau];
    [self khoiTaoGiaoDienChuyenTien];
    if([self kiemTraCoChucNangQuetVanTay])
    {
        [self xuLyKhiCoChucNangQuetVanTay];
    }
    else
    {
        [self xuLyKhiKhongCoChucNangQuetVanTay];
    }
    
}

#pragma mark - khoi Tao

- (void)khoiTaoBanDau
{
//    mKieuChuyenTien = KIEU_CHUYEN_TIEN;
    [_mbtnTKThuong setTitle:[@"ten_hien_thi" localizableString] forState:UIControlStateNormal];
    [_mlblTenHienThi setText:[@"ten_hien_thi" localizableString]];
    
    [_mtfTenHienThi setPlaceholder:[@"nhap_ten_hien_thi" localizableString]];
    [self.mtfTenHienThi setTextError:[@"ten_hien_thi_khong_duoc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    [_mbtnTKRutTien setTitle:[@"ten_tk_rut_tien" localizableString] forState:UIControlStateNormal];

    [_mbtnThucHien setTitle:[@"button_thuc_hien" localizableString] forState:UIControlStateNormal];
    [self suKienBamNutTKThuong:nil];
}

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
    [self.mtfMatKhauToken setText:@""];
    self.mtfMatKhauToken.max_length = 6;
    self.mtfMatKhauToken.textAlignment = NSTextAlignmentCenter;
    self.mtfMatKhauToken.inputAccessoryView = nil;
    self.mtfMatKhauToken.placeholder = [@"mat_khau_token" localizableString];
    [self.mtfMatKhauToken setTextError:[@"@mat_khau_token_khong_dc_de_trong" localizableString]
                               forType:ExTextFieldTypeEmpty];
}

- (void)khoiTaoDanhSachNganHang:(int)nMaTinhThanh
{
    NSArray *arr_bank_id = [BranchCoreData getBankIDsByProvince:nMaTinhThanh];
    
    NSMutableArray * bank_ids = [[NSMutableArray alloc] init];
    for (NSDictionary *dic_bank_id in arr_bank_id)
    {
        [bank_ids addObject:[dic_bank_id objectForKey:@"bank_id"]];
    }
    self.mDanhSachNganHang = [BankCoreData getBanksByIDs:bank_ids];
    [bank_ids release];
}

#pragma mark - suKien

- (IBAction)suKienBamNutTKThuong:(id)sender
{
    if(mKieuChuyenTien != KIEU_CHUYEN_TIEN)
    {
        [_mtfTenHienThi setEnabled:YES];
        [_mtfTenHienThi setText:@""];
        mKieuChuyenTien = KIEU_CHUYEN_TIEN;
        [_mbtnTKThuong setBackgroundColor:[UIColor colorWithHexString:@"#0083ec"]];
        [_mbtnTKThuong setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_mbtnTKRutTien setBackgroundColor:[UIColor whiteColor]];
        [_mbtnTKRutTien setTitleColor:[UIColor blackColor ] forState:UIControlStateNormal];
        
    }
}

- (IBAction)suKienBamNutTKRutTien:(id)sender
{
    if(mKieuChuyenTien != KIEU_RUT_TIEN)
    {
        [_mtfTenHienThi setEnabled:NO];
        mKieuChuyenTien = KIEU_RUT_TIEN;
        [_mbtnTKRutTien setBackgroundColor:[UIColor colorWithHexString:@"#0083ec"]];
        [_mbtnTKRutTien setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_mbtnTKThuong setBackgroundColor:[UIColor whiteColor]];
        [_mbtnTKThuong setTitleColor:[UIColor blackColor ] forState:UIControlStateNormal];
        
        NSString *sTenVietTatNganHang = @"";
        NSString *sBonSoCuoiTheNganHang = @"";
        for(Banks *bank in self.mDanhSachNganHang)
        {
            if([bank.bank_id intValue] == _mTaiKhoanThuongDung.nBankId){
                NSArray *stringComponent = [bank.bank_sms componentsSeparatedByString:@"/"];
                sTenVietTatNganHang = [stringComponent objectAtIndex:0];
                break;
            }
        }
        
        NSString *sTempSoThe = _mTaiKhoanThuongDung.sBankNumber;
        if(sTempSoThe.length > 4)
        {
            NSInteger nStart = sTempSoThe.length - 4;
            NSInteger nLength = 4;
            sBonSoCuoiTheNganHang = [sTempSoThe substringWithRange:NSMakeRange(nStart, nLength)];
        }
        
        NSString *sTenDaiDien = @"";
        if(_mTaiKhoanThuongDung.nType == TAI_KHOAN_THE)
            sTenDaiDien = [NSString stringWithFormat:@"Thẻ %@ - %@", sTenVietTatNganHang, sBonSoCuoiTheNganHang];
        else if(_mTaiKhoanThuongDung.nType == TAI_KHOAN_NGAN_HANG)
            sTenDaiDien = [NSString stringWithFormat:@"TK %@ - %@", sTenVietTatNganHang, sBonSoCuoiTheNganHang];
        [_mtfTenHienThi setText:sTenDaiDien];
    }
}

- (IBAction)suKienBamNutThucHien:(UIButton *)sender
{
    if([self validate])
    {
        NSString *sToken = @"";
        NSString *sOtp = @"";
        if(mTypeAuthenticate == TYPE_AUTHENTICATE_TOKEN)
        {
            NSString *sSeed = [DucNT_Token laySeedTokenHienTai];
            if(sSeed.length > 0)
            {
                sToken = [DucNT_Token OTPFromPIN:self.mtfMatKhauToken.text seed:sSeed];
            }
            else
            {
                [[[[UIAlertView alloc] initWithTitle:[@"@thong_bao" localizableString]  message:[@"@can_tao_token" localizableString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
                return;
            }
        }
        else
        {
            sOtp = self.mtfMatKhauToken.text;
        }
        
        [self xuLyKetNoiTaoTKTDVoiKieu:mTypeAuthenticate token:sToken otp:sOtp];
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
            
            self.mtfMatKhauToken.secureTextEntry = YES;
            self.mtfMatKhauToken.placeholder = [@"mat_khau_token" localizableString];
            [self.mtfMatKhauToken setTextError:[@"@mat_khau_token_khong_dc_de_trong" localizableString]
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
        [UIAlertView alert:[@"thong_bao_chua_dang_ky_thu_dien_tu" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
    }
}

- (IBAction)suKienBamNutMatKhauVanTay:(id)sender
{
    if([self.mtfTenHienThi validate])
        [self xuLySuKienHienThiChucNangVanTayVoiTieuDe:[@"su_dung_van_tay_dang_nhap_tai_khoan_token_VIMASS" localizableString]];
    else
        [self.mtfTenHienThi show_error];
}

#pragma mark - xu Ly Van Tay

- (void)xuLyKhiCoChucNangQuetVanTay
{
    [self.mbtnVanTay setHidden:NO];
}

- (void)xuLyKhiKhongCoChucNangQuetVanTay
{
    [self.mbtnVanTay setHidden:YES];
}

- (BOOL)kiemTraCoChucNangQuetVanTay
{
    LAContext *laContext = [[[LAContext alloc] init] autorelease];
    NSError *err = nil;
    if([laContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&err])
    {
        return YES;
    }
    return NO;
}

- (void)xuLySuKienHienThiChucNangVanTayVoiTieuDe:(NSString*)sTieuDe
{
    if([DucNT_Token daTonTaiMatKhauVanTay])
    {
        LAContext *context = [[[LAContext alloc] init] autorelease];
        NSError *err = nil;
        if([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&err])
        {
            __block ViewNhapTenDaiDienXacThucThemTaiKhoanThuongDung *blockSELF = self;
            [RoundAlert show];
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                    localizedReason:sTieuDe
                              reply:^(BOOL success, NSError *error)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [RoundAlert hide];
                     if (error) {
                         switch (error.code) {
                             case LAErrorUserCancel:
                                 NSLog(@"info:%@: %@, LAErrorUserCancel", NSStringFromClass([self class]),NSStringFromSelector(_cmd));
                                 break;
                             case LAErrorAuthenticationFailed:
                                 NSLog(@"info:%@: %@, LAErrorAuthenticationFailed", NSStringFromClass([self class]),NSStringFromSelector(_cmd));
                                 [blockSELF hienThiThongBaoDienMatKhau];
                                 break;
                             case LAErrorPasscodeNotSet:
                                 NSLog(@"info:%@: %@, LAErrorPasscodeNotSet", NSStringFromClass([self class]),NSStringFromSelector(_cmd));
                                 break;
                             case LAErrorTouchIDNotAvailable:
                                 NSLog(@"info:%@: %@, LAErrorTouchIDNotAvailable", NSStringFromClass([self class]),NSStringFromSelector(_cmd));
                                 break;
                             case LAErrorTouchIDNotEnrolled:
                                 NSLog(@"info:%@: %@, LAErrorTouchIDNotEnrolled", NSStringFromClass([self class]),NSStringFromSelector(_cmd));
                                 break;
                             case LAErrorUserFallback:
                                 NSLog(@"info:%@: %@, LAErrorUserFallback", NSStringFromClass([self class]),NSStringFromSelector(_cmd));
                                 
                                 break;
                             default:
                                 break;
                         }
                         
                         return;
                     }
                     if(success)
                     {
                         [self xuLySuKienXacThucVanTayThanhCong];
                     }
                 });
             }];
        }
    }
    else
    {
        [UIAlertView alert:[@"thong_bao_chua_co_xac_thuc_van_tay_token" localizableString] withTitle:[@"@thong_bao" localizableString] block:nil];
    }
}

- (void)hienThiThongBaoDienMatKhau
{
    
}
- (void)xuLySuKienXacThucVanTayThanhCong
{
    mTypeAuthenticate = TYPE_AUTHENTICATE_TOKEN;
    NSString *sToken = @"";
    NSString *sOtp = @"";
    if(mTypeAuthenticate == TYPE_AUTHENTICATE_TOKEN)
    {
        NSString *sSeed = [DucNT_Token laySeedTokenHienTai];
        if(sSeed.length > 0)
        {
            sToken = [DucNT_Token OTPFromPIN:[DucNT_Token layMatKhauVanTayToken] seed:sSeed];
        }
        else
        {
            [[[[UIAlertView alloc] initWithTitle:[@"@thong_bao" localizableString]  message:[@"@can_tao_token" localizableString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
            return;
        }
    }
    else
    {
        sOtp = self.mtfMatKhauToken.text;
    }
    
    [self xuLyKetNoiTaoTKTDVoiKieu:mTypeAuthenticate token:sToken otp:sOtp];
}


#pragma mark - Touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if(touch.view == self)
    {
        [self ketThucDemThoiGian];
        
        [self removeFromSuperview];
    }
    else
    {
        [self endEditing:YES];
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
    else if(buttonIndex == 0)
    {
        if(alertView.tag == HOP_THOAI_XAC_NHAN_CHUYEN_TIEN_THANH_CONG)
        {
            [self.mtfTenHienThi setText:@""];
            [self.mtfMatKhauToken setText:@""];
            [self removeFromSuperview];
        }
    }
}

-(BOOL)validate
{
    NSArray *tfs = @[_mtfTenHienThi, _mtfMatKhauToken];
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
    else if ([mDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_THEM_CAP_NHAT_TAI_KHOAN_THUONG_DUNG])
    {
        if(nCode == 1)
        {
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:[@"thong_bao" localizableString] message:message delegate:self cancelButtonTitle:[@"dong" localizableString] otherButtonTitles:nil, nil] autorelease];
            alert.tag = HOP_THOAI_XAC_NHAN_CHUYEN_TIEN_THANH_CONG;
            [alert show];
        }
        else
        {
            [UIAlertView alert:message withTitle:[@"thong_bao" localizableString] block:nil];
        }
    }
}

#pragma mark - xu ly su kien

//- (void)xuLyHienThiTextTenDaiDienCuaTaiKhoanTheRutTien
//{
//    NSString *sTenVietTatNganHang = @"";
//    NSString *sBonSoCuoiTheNganHang = @"";
//    NSString *sThe = @"";
//    
//    if(mViTriNganHangDuocChon != -1)
//    {
//        Banks *bank = [self.mDanhSachNganHang objectAtIndex:mViTriNganHangDuocChon];
//        sTenVietTatNganHang = bank.bank_sms;
//    }
//    
//    NSString *sTempSoThe = [self.mtfSoThe.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    if(sTempSoThe.length > 4)
//    {
//        NSInteger nStart = sTempSoThe.length - 4;
//        NSInteger nLength = 4;
//        sBonSoCuoiTheNganHang = [sTempSoThe substringWithRange:NSMakeRange(nStart, nLength)];
//    }
//    
//    NSString *sTenDaiDien = [NSString stringWithFormat:@"TK %@ - %@", sTenVietTatNganHang, sBonSoCuoiTheNganHang];
//    self.mtfTenDaiDien.text = sTenDaiDien;
//}

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
        
        self.mtfMatKhauToken.secureTextEntry = NO;
        self.mtfMatKhauToken.placeholder = [@"ma_xac_thuc" localizableString];
        [self.mtfMatKhauToken setTextError:[@"ma_xac_thuc_khong_duoc_de_trong" localizableString]
                                forType:ExTextFieldTypeEmpty];
        
        
        NSString *sEmailAuthenticate = self.mThongTinVi.sThuDienTu;
        int nKieuNhanXacThuc = 0;
        
        nKieuNhanXacThuc = FUNC_THEM_CAP_NHAT_TAI_KHOAN_THUONG_DUNG;
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
        
        self.mtfMatKhauToken.secureTextEntry = NO;
        self.mtfMatKhauToken.placeholder = [@"ma_xac_thuc" localizableString];
        [self.mtfMatKhauToken setTextError:[@"ma_xac_thuc_khong_duoc_de_trong" localizableString]
                                forType:ExTextFieldTypeEmpty];
        
        NSString *sPhoneAuthenticate = self.mThongTinVi.sPhoneAuthenticate;
        int nKieuNhanXacThuc = 0;
        
        nKieuNhanXacThuc = FUNC_THEM_CAP_NHAT_TAI_KHOAN_THUONG_DUNG;
        
        [self xuLyKetNoiLayMaXacThucChuyenDenTaiKhoan:sPhoneAuthenticate kieuXacThuc:nKieuNhanXacThuc];
    }
}


#pragma mark - xuLyTimer
- (void)batDauDemThoiGian
{
    [_mbtnVanTay setHidden:YES];
    mTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(capNhatDemThoiGian) userInfo:nil repeats:YES];
}

- (void)ketThucDemThoiGian
{
    if([self kiemTraCoChucNangQuetVanTay])
    {
        [_mbtnVanTay setHidden:NO];
    }
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

- (void)xuLyKetNoiTaoTKTDVoiKieu:(NSInteger)nKieuXacThuc token:(NSString*)sToken otp:(NSString*)sOtp
{
    if(_mTaiKhoanThuongDung.nType == TAI_KHOAN_THE)
    {
        if(mKieuChuyenTien == KIEU_RUT_TIEN)
        {
            _mTaiKhoanThuongDung.nType = TAI_KHOAN_THE_RUT_TIEN;
        }
    }
    else if(_mTaiKhoanThuongDung.nType == TAI_KHOAN_NGAN_HANG)
        if(mKieuChuyenTien == KIEU_RUT_TIEN)
            _mTaiKhoanThuongDung.nType = TAI_KHOAN_NGAN_HANG_RUT_TIEN;
    _mTaiKhoanThuongDung.sAliasName = self.mtfTenHienThi.text;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[_mTaiKhoanThuongDung toDict]];
    [dict setValue:sOtp forKey:@"otpConfirm"];
    [dict setValue:[NSNumber numberWithInt:mTypeAuthenticate] forKey:@"typeAuthenticate"];
    [dict setValue:sToken forKey:@"token"];
    [dict setValue:[NSNumber numberWithInt:APP_ID] forKey:@"appId"];
    NSString *sMaDoanhNghiep = @"";
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sMaDoanhNghiep = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_COMPANY_ID];
        [dict setValue:sMaDoanhNghiep forKey:@"companyCode"];
    }
    mDinhDanhKetNoi = DINH_DANH_KET_NOI_THEM_CAP_NHAT_TAI_KHOAN_THUONG_DUNG;
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:self];
    [connect connect:@"https://vimass.vn/vmbank/services/account/addAccUsed" withContent:[dict JSONString]];
    [connect release];
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - dealloc
- (void)dealloc
{
    if(_mTaiKhoanThuongDung)
        [_mTaiKhoanThuongDung release];
    [_mlblXacThucBoi release];
    [_mbtnToken release];
    [_mbtnSMS release];
    [_mbtnEmail release];
    [_mtfMatKhauToken release];
    [_mbtnThucHien release];
    [_mbtnTKThuong release];
    [_mbtnTKRutTien release];
    [_mtfTenHienThi release];
    [_mViewChonTaiKhoanThuong_RutTien release];
    [_mbtnVanTay release];
    [_mlblTenHienThi release];
    [_mViewMain release];
    [super dealloc];
}
@end
