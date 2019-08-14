//
//  DoiTuongChiTietGiaoDichInternet.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 11/13/15.
//
//

#import "DoiTuongChiTietGiaoDichInternet.h"

@implementation DoiTuongChiTietGiaoDichInternet

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

        NSString *maThueBao = [dict valueForKey:@"maThueBao"];
        if(maThueBao)
            self.maThueBao = maThueBao;
        else
            self.maThueBao = @"";

        NSString *maGiaoDich = [dict valueForKey:@"maGiaoDich"];
        if(maGiaoDich)
            self.maGiaoDich = maGiaoDich;
        else
            self.maGiaoDich = @"";

        NSNumber *nhaMang = [dict valueForKey:@"maNhaCungCap"];
        if(nhaMang)
            self.maNhaCungCap = nhaMang;
        else
            self.maNhaCungCap = [NSNumber numberWithInt:-1];

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

    NSString *sNhaMang = @"";
    switch ([_maNhaCungCap intValue]) {
        case 1:
            sNhaMang = @"VNPT Hà Nội";
            break;
        case 2:
            sNhaMang = @"VNPT Hải Phòng";
            break;
        case 3:
            sNhaMang = @"VNPT Hồ Chí Minh";
            break;
        case 4:
            sNhaMang = @"FPT";
            break;
        case 5:
            sNhaMang = @"VIETTEL";
            break;
        case 6:
            sNhaMang = @"VNPT Hà Nội";
            break;
        default:
            break;
    }
    [sXauHTML appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Nhà cung cấp", sNhaMang];
    [sXauHTML appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Mã khách hàng", [_maThueBao uppercaseString]];
    [sXauHTML appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Số tiền", [NSString stringWithFormat:@"%@ %@",[Common hienThiTienTe:[_soTien doubleValue]], @"đ"]];
    return sXauHTML;
}

- (void)dealloc{
    [_vi release];
    [_maThueBao release];
    [_maGiaoDich release];
    [_maNhaCungCap release];
    [_soTien release];
    [_thoiGian release];
    [_trangThaiGuiServer release];
    [super dealloc];
}

@end
