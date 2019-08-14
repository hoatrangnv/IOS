//
//  DoiTuongChiTietGiaoDichGuiTietKiem.m
//  ViViMASS
//
//  Created by DucBui on 6/11/15.
//
//

#import "DoiTuongChiTietGiaoDichRutTietKiem.h"
#import "GiaoDichMang.h"
#import "JSONKit.h"

@implementation DoiTuongChiTietGiaoDichRutTietKiem
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
        
        NSString *soSoTietKiem = [dict valueForKey:@"soSoTietKiem"];
        if (soSoTietKiem) {
            self.soSoTietKiem = soSoTietKiem;
        }
        else
            self.soSoTietKiem = @"";
    }
    return self;
}

- (void)setSecssion:(NSString *)secssion
{
    if (_secssion) {
        [_secssion release];
    }
    _secssion = [secssion retain];
    if(![_soSoTietKiem isEqualToString:@""] && ![_secssion isEqualToString:@""] && ![_mDinhDanhDoanhNghiep isEqualToString:@""])
    {
        NSData* data = [GiaoDichMang ketNoiLayChiTietSoTietKiem:_soSoTietKiem secssion:_secssion dinhDanhDoanhNghiep:_mDinhDanhDoanhNghiep];
        NSString *sKetQua = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        NSDictionary *dicKetQua = [sKetQua objectFromJSONString];
        int nCode = [[dicKetQua objectForKey:@"msgCode"] intValue];
        id result = [dicKetQua objectForKey:@"result"];
        if(nCode == 1)
        {
            SoTietKiem *soTietKiem = [[SoTietKiem alloc] initWithDictionary:result];
            if(soTietKiem)
            {
                self.mSoTietKiem = soTietKiem;
            }
        }
    }
    
}

- (NSString *)layNoiDung
{
    return @"";
}

- (double)laySoTienGiaoDich
{
    return [_mSoTietKiem.soTien doubleValue];
}

- (NSString *)layChiTietHienThi
{
    if(_mSoTietKiem)
        return [_mSoTietKiem layChiTietSoTietKiemKieuHTML];
    return @"";
}

- (NSString *)layKieuGiaoDich
{
    return @"Gửi tiết kiệm";
}


- (double)laySoTienPhiGiaoDich
{
    double fSoPhi = [Common layPhiChuyenTienCuaSoTien:[_mSoTietKiem.soTien doubleValue] kieuChuyenTien:KIEU_CHUYEN_TIEN_DEN_VI maNganHang:@""];
    return fSoPhi;
}

-(void)dealloc
{
    [_mDinhDanhDoanhNghiep release];
    [_soSoTietKiem release];
    [_secssion release];
    [super dealloc];
}

@end
