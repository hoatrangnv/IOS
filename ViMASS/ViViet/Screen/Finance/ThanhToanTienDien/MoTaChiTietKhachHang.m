//
//  MoTaChiTietHoaDonDien.m
//  ViViMASS
//
//  Created by DucBT on 4/9/15.
//
//

#import "MoTaChiTietKhachHang.h"
#import "MoTaChiTietHoaDonDien.h"

@implementation MoTaChiTietKhachHang

- (id)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if(self)
    {
        NSString *maKhachHang = [dict valueForKey:@"maKhachHang"];
        if(maKhachHang)
            self.maKhachHang = maKhachHang;
        else
            self.maKhachHang = @"";
        
        NSString *tenKhachHang = [dict valueForKey:@"tenKhachHang"];
        if(tenKhachHang)
            self.tenKhachHang = tenKhachHang;
        else
            self.tenKhachHang = @"";
        
        NSString *diaChi = [dict valueForKey:@"diaChi"];
        if(diaChi)
            self.diaChi = diaChi;
        else
            self.diaChi = @"";
        
        NSString *maDienLuc = [dict valueForKey:@"maDienLuc"];
        if(maDienLuc)
            self.maDienLuc = maDienLuc;
        else
            self.maDienLuc = @"";
        
        NSString *kyThanhToan = [dict valueForKey:@"kyThanhToan"];
        if(kyThanhToan)
            self.kyThanhToan = kyThanhToan;
        else
            self.kyThanhToan = @"";
        
        NSArray *list = [dict valueForKey:@"list"];
        if(list)
        {
            NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:list.count];
            for(NSDictionary *dict in list)
            {
                MoTaChiTietHoaDonDien *moTaChiTietHoaDonDien = [[MoTaChiTietHoaDonDien alloc] initWithDictionary:dict];
                [temp addObject:moTaChiTietHoaDonDien];
                [moTaChiTietHoaDonDien release];
            }
            self.list = temp;
            [temp release];
        }
        else
        {
            self.list = @[];
        }
        
        NSNumber *total = [dict valueForKey:@"total"];
        if(total)
            self.total = total;
        else
            self.total = [NSNumber numberWithInt:-1];
        
        NSNumber *maLoi = [dict valueForKey:@"maLoi"];
        if(maLoi)
            self.maLoi = maLoi;
        else
            self.maLoi = [NSNumber numberWithInt:-1];
        
        NSString *thongBaoLoi = [dict valueForKey:@"thongBaoLoi"];
        if(thongBaoLoi)
            self.thongBaoLoi = thongBaoLoi;
        else
            self.thongBaoLoi = @"";
    }
    return self;
}

- (void)dealloc
{
    [_maKhachHang release];
    [_tenKhachHang release];
    [_diaChi release];
    [_maDienLuc release];
    [_kyThanhToan release];
    [_list release];
    [_total release];
    [_maLoi release];
    [_thongBaoLoi release];
    [super dealloc];
}
@end
