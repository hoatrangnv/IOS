//
//  DoiTuongChiTietGiaoDichGuiTietKiem.m
//  ViViMASS
//
//  Created by DucBui on 7/10/15.
//
//

#import "DoiTuongChiTietGiaoDichGuiTietKiem.h"
#import "Common.h"

@implementation DoiTuongChiTietGiaoDichGuiTietKiem

- (id)initWithDict:(NSDictionary*)dict
{
    self = [super initWithDict:dict];
    if(self)
    {
        self.mSoTietKiem = [[SoTietKiem alloc] initWithDictionary:dict];
    }
    return self;
}

- (NSString*)layChiTietHienThi
{
    return [_mSoTietKiem layChiTietSoTietKiemKieuHTML];
}

- (NSString*)layKieuGiaoDich
{
    return @"";
}

- (double)laySoTienGiaoDich
{
    return [_mSoTietKiem.soTien doubleValue];
}

- (double)laySoTienPhiGiaoDich
{
    return [Common layPhiChuyenTienCuaSoTien:[self laySoTienGiaoDich] kieuChuyenTien:KIEU_CHUYEN_TIEN_DEN_VI maNganHang:@""];
}

- (NSString*)layNoiDung
{
    return @"";
}
@end
