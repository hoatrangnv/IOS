//
//  DoiTuongChiTietGiaoDichThanhToanDienThoai.m
//  ViViMASS
//
//  Created by DucBui on 6/17/15.
//
//

#import "DoiTuongChiTietGiaoDichThanhToanDienThoai.h"

@implementation DoiTuongChiTietGiaoDichThanhToanDienThoai

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super initWithDict:dict];
    if(self)
    {
        NSString *tuVi = [dict valueForKey:@"companyCode"];
        if (tuVi) {
            self.vi = tuVi;
        }
        else
            self.vi = @"";
        
        NSNumber *loaiThueBao = [dict valueForKey:@"loaiThueBao"];
        if(loaiThueBao)
            self.loaiThueBao = loaiThueBao;
        else
            self.loaiThueBao = [NSNumber numberWithInt:-1];
        
        NSString *maGiaoDich = [dict valueForKey:@"maGiaoDich"];
        if(maGiaoDich)
            self.maGiaoDich = maGiaoDich;
        else
            self.maGiaoDich = @"";
        
        NSString *moTa = [dict valueForKey:@"moTa"];
        if(moTa)
            self.moTa = moTa;
        else
            self.moTa = @"";
        
        NSNumber *nhaMang = [dict valueForKey:@"nhaMang"];
        if(nhaMang)
            self.nhaMang = nhaMang;
        else
            self.nhaMang = [NSNumber numberWithInt:-1];
        
        NSString *soDienThoai = [dict valueForKey:@"soDienThoai"];
        if(soDienThoai)
            self.soDienThoai = soDienThoai;
        else
            self.soDienThoai = @"";
        
        NSNumber *soTien = [dict valueForKey:@"soTien"];
        if(soTien)
            self.soTien = soTien;
        else
            self.soTien = [NSNumber numberWithDouble:0.0f];
        
        NSNumber *thoiGian = [dict valueForKey:@"thoiGian"];
        if(thoiGian)
            self.thoiGian = thoiGian;
        else
            self.thoiGian = [NSNumber numberWithLongLong:0];
        
        NSNumber *trangThaiGuiServer = [dict valueForKey:@"trangThaiGuiServer"];
        if(trangThaiGuiServer)
            self.trangThaiGuiServer = trangThaiGuiServer;
        else
            self.trangThaiGuiServer = [NSNumber numberWithInt:-1];
        
        
        
    }
    return self;
}

- (NSString *)layChiTietHienThi
{
    NSMutableString *sXauHTML = [[[NSMutableString alloc] init] autorelease];
    [sXauHTML appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Số điện thoại", _soDienThoai];
    if([_loaiThueBao intValue] == TRA_TRUOC)
        [sXauHTML appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Loại thuê bao", @"Trả trước"];
    else if([_loaiThueBao intValue] == TRA_SAU_HOAC_TRA_TRUOC_VIETNAMMOBILE_GMOBILE)
        [sXauHTML appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Loại thuê bao", @"Trả sau"];
    
    if([_nhaMang intValue] == NHA_MANG_VIETTEL)
        [sXauHTML appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Nhà mạng", @"Viettel"];
    else if([_nhaMang intValue] == NHA_MANG_VIETNAMMOBILE)
        [sXauHTML appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Nhà mạng", @"Vietnamobile"];
    else if([_nhaMang intValue] == NHA_MANG_MOBI)
        [sXauHTML appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Nhà mạng", @"Mobifone"];
    else if([_nhaMang intValue] == NHA_MANG_VINA)
        [sXauHTML appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Nhà mạng", @"Vinaphone"];
    else if([_nhaMang intValue] == NHA_MANG_GMOBILE)
        [sXauHTML appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Nhà mạng", @"Gmobile"];
    if([_soTien doubleValue] > 0)
        [sXauHTML appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Số tiền", [Common hienThiTienTe_1:[_soTien doubleValue]]];
    double fSoPhi = [Common layPhiChuyenTienCuaSoTien:[_soTien doubleValue] kieuChuyenTien:KIEU_CHUYEN_TIEN_NAP_THE_DIEN_THOAI maNganHang:@""];
    if(fSoPhi > 0)
        [sXauHTML appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Số phí", [Common hienThiTienTe_1:fSoPhi]];
    
    return sXauHTML;
}


- (NSString *)layKieuGiaoDich
{
    return @"Thanh toán điện thoại";
}

- (double)laySoTienGiaoDich
{
    return [_soTien doubleValue];
}

- (NSString *)layNoiDung
{
    return _moTa;
}

- (double)laySoTienPhiGiaoDich
{
    double fSoPhi = [Common layPhiChuyenTienCuaSoTien:[_soTien doubleValue] kieuChuyenTien:KIEU_CHUYEN_TIEN_NAP_THE_DIEN_THOAI maNganHang:@""];
    return fSoPhi;
}

- (void)dealloc
{
    [_loaiThueBao release];
    [_maGiaoDich release];
    [_moTa release];
    [_nhaMang release];
    [_soDienThoai release];
    [_soTien release];
    [_thoiGian release];
    [_trangThaiGuiServer release];
    [super dealloc];
}

@end
