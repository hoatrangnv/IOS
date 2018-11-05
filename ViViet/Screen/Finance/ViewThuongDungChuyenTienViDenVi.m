//
//  ViewThuongDungViDenVi.m
//  ViViMASS
//
//  Created by DucBT on 1/21/15.
//
//

#import "Common.h"
#import "DucNT_LuuRMS.h"
#import "ViewThuongDungChuyenTienViDenVi.h"

@implementation ViewThuongDungChuyenTienViDenVi

#pragma mark - get & set

- (void)setMTaiKhoanThuongDung:(DucNT_TaiKhoanThuongDungObject *)mTaiKhoanThuongDung
{
    if(mTaiKhoanThuongDung)
    {
        if(_mTaiKhoanThuongDung)
            [_mTaiKhoanThuongDung release];
        _mTaiKhoanThuongDung = [mTaiKhoanThuongDung retain];
        [self.mtfTenDaiDien setText:_mTaiKhoanThuongDung.sAliasName];
        [self.mtfTenTaiKhoan setText:_mTaiKhoanThuongDung.sToAccWallet];
        self.mtfSoTien.text = [Common hienThiTienTe:_mTaiKhoanThuongDung.nAmount];
        [self.mtvNoiDungGiaoDich setText:_mTaiKhoanThuongDung.sDesc];
    }
}

- (DucNT_TaiKhoanThuongDungObject*)getTaiKhoanThuongDungDayLenServer
{
    DucNT_TaiKhoanThuongDungObject *taiKhoanThuongDung = nil;
    if([self validateShowError:NO])
    {
        if(_mTaiKhoanThuongDung)
        {
            taiKhoanThuongDung = _mTaiKhoanThuongDung;
        }
        else
        {
            taiKhoanThuongDung = [[[DucNT_TaiKhoanThuongDungObject alloc] init] autorelease];
        }
        taiKhoanThuongDung.nType = TAI_KHOAN_VI;
        taiKhoanThuongDung.sPhoneOwner = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
        taiKhoanThuongDung.sAliasName = self.mtfTenDaiDien.text;
        taiKhoanThuongDung.sToAccWallet = self.mtfTenTaiKhoan.text;
        taiKhoanThuongDung.sDesc = self.mtvNoiDungGiaoDich.text;
        NSString *sSoTien = [self.mtfSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""];
        taiKhoanThuongDung.nAmount = [sSoTien doubleValue];
    }
    return taiKhoanThuongDung;
}

#pragma mark - life circle
- (void)awakeFromNib
{
    [self khoiTaoGiaoDien];
}

#pragma mark - khoiTao
- (void)khoiTaoGiaoDien
{
    [self.mtfSoTien setPlaceholder:[NSString stringWithFormat:@"%@ (%@)",[@"so_tien_dong" localizableString], [@"co_the_bo_qua" localizableString]]];
    [self.mtfSoTien setTextError:[@"so_tien_khong_duoc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    [self.mtfSoTien setTextError:[@"@so_tien_khong_hop_le" localizableString]forType:ExTextFieldTypeMoney];
    [self.mtfSoTien setText:@""];
    self.mtfSoTien.inputAccessoryView = nil;

    [self.mtfTenTaiKhoan setPlaceholder:[@"tai_khoan_duoc_nhan" localizableString]];
    [self.mtfTenTaiKhoan setTextError:[@"ten_tai_khoan_khong_duoc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    [self.mtfTenTaiKhoan setText:@""];
    self.mtfTenTaiKhoan.inputAccessoryView = nil;

    [self.mtfTenDaiDien setPlaceholder:[@"ten_hien_thi" localizableString]];
    [self.mtfTenDaiDien setTextError:[@"ten_hien_thi_khong_duoc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    [self.mtfTenDaiDien setText:@""];
    self.mtfTenDaiDien.inputAccessoryView = nil;
    
    [self.mtfNoiDungGiaoDich setPlaceholder:[@"noi_dung_giao_dich" localizableString]];
    self.mtvNoiDungGiaoDich.inputAccessoryView = nil;
    self.mtvNoiDungGiaoDich.text = @"";
}

#pragma mark - suKien

- (void)setTaiKhoan:(NSString*)sTaiKhoan
{
    self.mtfTenTaiKhoan.text = sTaiKhoan;
}

- (IBAction)suKienBamNutDanhBa:(UIButton *)sender
{
    if([self.mDelegate respondsToSelector:@selector(xuLySuKienBamNutDanhBa)])
    {
        [self.mDelegate xuLySuKienBamNutDanhBa];
    }
}

- (BOOL)validate
{
    NSArray *tfs = @[_mtfTenDaiDien, _mtfTenTaiKhoan];
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

- (BOOL)validateShowError:(BOOL)showError
{
    NSArray *tfs = @[_mtfTenDaiDien, _mtfTenTaiKhoan];
    ExTextField *first = nil;
    BOOL flg = YES;
    for (ExTextField *tf in tfs)
    {
        flg = [tf validate] && flg;
        if (flg == NO && first == nil)
            first = tf;
    }
    if (first && showError)
        [first show_error];
    return flg;
}

- (IBAction)suKienThayDoiGiaTriSoTien:(id)sender
{
    NSString *sSoTien = [self.mtfSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *sText = [Common hienThiTienTeFromString:sSoTien];
    self.mtfSoTien.text = sText;
}


#pragma mark - dealloc
- (void)dealloc {
    [_mtfTenDaiDien release];
    [_mtfTenTaiKhoan release];
    [_mtfSoTien release];
    [_mtvNoiDungGiaoDich release];
    [_mtfNoiDungGiaoDich release];
    [super dealloc];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
@end
