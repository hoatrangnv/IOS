//
//  GiaoDienChinhHeader.m
//  ViViMASS
//
//  Created by DucBT on 1/7/15.
//
//

#import "Common.h"
#import "DucNT_LuuRMS.h"
#import "GiaoDienChinhHeader.h"

@implementation GiaoDienChinhHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)_init
{
    self.mlblTheQuaTang.text = [@"the_qua_tang" localizableString];
    self.mlblKhuyenMai.text = [@"khuyen_mai" localizableString];
    [self.mbtnChuyenTien setTitle:[@"nap_tien" localizableString] forState:UIControlStateNormal];
    [self.mbtnMuonTien setTitle:[@"muon_tien" localizableString] forState:UIControlStateNormal];
    [self.mbtnRutTien setTitle:[@"rut_tien" localizableString] forState:UIControlStateNormal];
}

#pragma mark - get & set
- (void)setMThongTinTaiKhoanVi:(DucNT_TaiKhoanViObject *)mThongTinTaiKhoanVi
{
    if(_mThongTinTaiKhoanVi)
    {
        [_mThongTinTaiKhoanVi release];
    }
    
    _mThongTinTaiKhoanVi = [mThongTinTaiKhoanVi retain];
    [self khoiTaoGiaoDienHeader];
}

- (void)awakeFromNib
{
    [self _init];
    [self khoiTaoGiaoDienHeader];
}

- (void)capNhatSoDu:(double)fSoDu soDuKhuyenMai:(double)fSoDuKhuyenMai theQuaTang:(double)fTheQuaTang
{
    self.mlblSoTienTrongTaiKhoan.text = [Common hienThiTienTe_1:fSoDu];
    self.mlblSoTienKhuyenMaiTrongTaiKhoan.text = [Common hienThiTienTe_1:fSoDuKhuyenMai];
    self.mlblSoTheQuaTang.text = [NSString stringWithFormat:@"%d", (int)fTheQuaTang];
}

- (void)khoiTaoGiaoDienHeader
{
    bool bDaDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue];
    if(bDaDangNhap)
    {
        [self.mViewHienThiThongTinTaiKhoan setHidden:NO];
    }
    else
    {
        [self.mViewHienThiThongTinTaiKhoan setHidden:YES];
    }
    if(_mThongTinTaiKhoanVi)
    {
        NSString *sTenCMND = _mThongTinTaiKhoanVi.sNameAlias;
        self.mlblTenTaiKhoan.text = sTenCMND;
        [self capNhatSoDu:0 soDuKhuyenMai:0 theQuaTang:0];
    }

}

#pragma mark - suKien
- (IBAction)suKienBamNutChuyenTien:(UIButton *)sender {
    if([self.mDelegate respondsToSelector:@selector(xuLySuKienBamNutNapTien)])
    {
        [self.mDelegate xuLySuKienBamNutNapTien];
    }
}
- (IBAction)suKienBamNutRutTien:(id)sender {
    if([self.mDelegate respondsToSelector:@selector(xuLySuKienbamNutRutTien)])
    {
        [self.mDelegate xuLySuKienbamNutRutTien];
    }
}
- (IBAction)suKienBamNutMuonTien:(id)sender {
    if([self.mDelegate respondsToSelector:@selector(xuLySuKienBamNutMuonTien)])
    {
        [self.mDelegate xuLySuKienBamNutMuonTien];
    }
}

- (IBAction)suKienBamNutXemSaoKe:(UIButton *)sender
{
    if([self.mDelegate respondsToSelector:@selector(xuLySuKienXemSaoKe:)])
    {
        [self.mDelegate xuLySuKienXemSaoKe:sender];
    }
}

#pragma mark - dealloc
- (void)dealloc
{
    [_mlblTenTaiKhoan release];
    [_mlblSoTienTrongTaiKhoan release];
    [_mlblSoTienKhuyenMaiTrongTaiKhoan release];
    [_mlblKhuyenMai release];
    [_mbtnMuonTien release];
    [_mbtnRutTien release];
    [_mbtnChuyenTien release];
    [_mViewHienThiThongTinTaiKhoan release];
    [_mlblTheQuaTang release];
    [_mlblSoTheQuaTang release];
    [_mViewChuaThongTInSaoKe release];
    [super dealloc];
}
@end
