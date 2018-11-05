//
//  MoTaChiTietHoaDonDien.m
//  ViViMASS
//
//  Created by DucBT on 4/9/15.
//
//

#import "MoTaChiTietHoaDonDien.h"

@implementation MoTaChiTietHoaDonDien

- (id)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if(self)
    {
        NSString *maHoaDon = [dict valueForKey:@"maHoaDon"];
        if(maHoaDon)
            self.maHoaDon = maHoaDon;
        else
            self.maHoaDon = @"";
        
        NSString *moTa = [dict valueForKey:@"moTa"];
        if(moTa)
            self.moTa = moTa;
        else
            self.moTa = @"";
        
        NSNumber *soTien = [dict valueForKey:@"soTien"];
        if(soTien)
            self.soTien = soTien;
        else
            self.soTien = [NSNumber numberWithInt:-1];
        NSString *tienTe = [dict valueForKey:@"tienTe"];
        if(tienTe)
            self.tienTe = tienTe;
        else
            self.tienTe = @"";
        
        NSString *kyThanhToan = [dict valueForKey:@"kyThanhToan"];
        if(kyThanhToan)
            self.kyThanhToan = kyThanhToan;
        else
            self.kyThanhToan = @"";
    }
    return self;
}

- (void)dealloc
{
    [_maHoaDon release];
    [_moTa release];
    [_soTien release];
    [_tienTe release];
    [_kyThanhToan release];
    [super dealloc];
}

@end
