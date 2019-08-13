//
//  DoiTuongChiTietGiaoDichTheoLo.m
//  ViViMASS
//
//  Created by DucBui on 6/25/15.
//
//

#import "DoiTuongChiTietGiaoDichTheoLo.h"
#import "DoiTuongChiTietGiaoDichChuyenTienDenVi.h"
#import "DoiTuongChiTietGiaoDichChuyenTienDenTaiKhoan.h"
#import "DoiTuongChiTietGiaoDichThanhToanDienThoai.h"
#import "DoiTuongChiTietGiaoDichRutTietKiem.h"
#import "DucNT_LuuRMS.h"

@implementation DoiTuongChiTietGiaoDichTheoLo

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super initWithDict:dict];
    if(self)
    {
        NSNumber *funcId = [dict valueForKey:@"funcId"];
        if(funcId)
            self.funcId = funcId;
        else
            self.funcId = [NSNumber numberWithInt:0];
        
        NSDictionary *giaoDich = [dict valueForKey:@"giaoDich"];
        if(giaoDich && [funcId intValue] > 0)
        {
            switch ([_funcId intValue]) {
                case FUNC_ID_CHUYEN_TIEN:
                    [self khoiTaoDoiTuongChiTietGiaoDichChuyenTienDenVi:giaoDich];
                    break;
                case FUNC_TRANSACTION_TO_BANK:
                    [self khoiTaoDoiTuongChiTietGiaoDichChuyenTienDenTheNganHang:giaoDich];
                    break;
                case FUNC_RUT_TIEN_TIET_KIEM:
                    [self khoiTaoDoiTuongChiTietGiaoDichRutTietKiem:giaoDich];
                    break;
                case FUNC_BILLING_CELLPHONE:
                    [self khoiTaoDoiTuongChiTietGiaoDichThanhToanDienThoai:giaoDich];
                    break;
                default:
                    break;
            }
        }
        
        NSString *moTa = [dict valueForKey:@"moTa"];
        if(moTa)
            self.moTa = moTa;
        else
            self.moTa = @"";
        
        NSNumber *trangThai = [dict valueForKey:@"trangThai"];
        if(trangThai)
            self.trangThai = trangThai;
        else
            self.trangThai = [NSNumber numberWithInt:-1];
    }
    return self;
}


- (void)khoiTaoDoiTuongChiTietGiaoDichChuyenTienDenVi:(NSDictionary*)dict
{
    DoiTuongChiTietGiaoDichChuyenTienDenVi *doiTuong = [[DoiTuongChiTietGiaoDichChuyenTienDenVi alloc] initWithDict:dict];
    self.mDoiTuongChiTietGiaoDich = doiTuong;
    [doiTuong release];
}

- (void)khoiTaoDoiTuongChiTietGiaoDichChuyenTienDenTheNganHang:(NSDictionary*)dict
{
    DoiTuongChiTietGiaoDichChuyenTienDenTaiKhoan *doiTuong = [[DoiTuongChiTietGiaoDichChuyenTienDenTaiKhoan alloc] initWithDict:dict];
    self.mDoiTuongChiTietGiaoDich = doiTuong;
    [doiTuong release];
}

- (void)khoiTaoDoiTuongChiTietGiaoDichRutTietKiem:(NSDictionary*)dict
{
    NSString *secssion = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_SECSSION];
    DoiTuongChiTietGiaoDichRutTietKiem *doiTuong = [[DoiTuongChiTietGiaoDichRutTietKiem alloc] initWithDict:dict];
    doiTuong.secssion = secssion;
    self.mDoiTuongChiTietGiaoDich = doiTuong;
    [doiTuong release];
}

- (void)khoiTaoDoiTuongChiTietGiaoDichThanhToanDienThoai:(NSDictionary*)dict
{
    DoiTuongChiTietGiaoDichThanhToanDienThoai *doiTuong = [[DoiTuongChiTietGiaoDichThanhToanDienThoai alloc] initWithDict:dict];
    self.mDoiTuongChiTietGiaoDich = doiTuong;
    [doiTuong release];
}

- (NSString *)layChiTietHienThi
{
    return @"";
}

- (void)dealloc
{
    [_funcId release];
    if(_mDoiTuongChiTietGiaoDich)
        [_mDoiTuongChiTietGiaoDich release];
    [_moTa release];
    [_trangThai release];
    [super dealloc];
}
@end
