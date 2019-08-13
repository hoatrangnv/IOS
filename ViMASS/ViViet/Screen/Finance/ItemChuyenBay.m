//
//  ItemChuyenBay.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 1/7/16.
//
//

#import "ItemChuyenBay.h"

@implementation ItemChuyenBay

- (id)khoiTaoThongTin:(NSDictionary *)dic{
    self = [super init];
    NSString *sMaSanBayDi = [dic objectForKey:@"maSanBayDi"];
    NSString *sMaSanBayDen = [dic objectForKey:@"maSanBayDen"];
    NSString *sThoiGian = [dic objectForKey:@"thoiGian"];
    NSString *sGioBay = [dic objectForKey:@"gioBay"];
    NSString *sGioDen = [dic objectForKey:@"gioDen"];
    NSString *sThoiGianBay = [dic objectForKey:@"thoiGianBay"];
    NSString *sMaChuyenBay = [dic objectForKey:@"maChuyenBay"];
    int nHangBay = [[dic objectForKey:@"hangBay"] intValue];
    int nGia = [[dic objectForKey:@"gia"] intValue];
    int nGiaNL = [[dic objectForKey:@"giaNguoiLon"] intValue];
    int nGiaTE = [[dic objectForKey:@"giaTreEm"] intValue];
    int nGiaEB = [[dic objectForKey:@"giaEmBe"] intValue];
    int nGia15 = [[dic objectForKey:@"gia15KG"] intValue];
    int nGia20 = [[dic objectForKey:@"gia20KG"] intValue];
    int nGia25 = [[dic objectForKey:@"gia25KG"] intValue];
    int nGia30 = [[dic objectForKey:@"gia30KG"] intValue];
    int nGia35 = [[dic objectForKey:@"gia35KG"] intValue];
    int nGia40 = [[dic objectForKey:@"gia40KG"] intValue];
    int nPhiVimass = [[dic objectForKey:@"phiVimass"] intValue];
//    NSLog(@"%s - nHangBay : %d - nGia : %d", __FUNCTION__, nHangBay, nGia);
    self.maSanBayDi = @"";
    self.maSanBayDen = @"";
    self.thoiGian = @"";
    self.gioBay = @"";
    self.gioDen = @"";
    self.thoiGianBay = @"";
    self.maChuyenBay = @"";
    self.hangBay = nHangBay;
    self.gia = nGia;
    self.giaNguoiLon = nGiaNL;
    self.giaTreEm = nGiaTE;
    self.giaEmBe = nGiaEB;
    self.gia15KG = nGia15;
    self.gia20KG = nGia20;
    self.gia25KG = nGia25;
    self.gia30KG = nGia30;
    self.gia35KG = nGia35;
    self.gia40KG = nGia40;
    self.phiVimass = nPhiVimass;
    if (sMaSanBayDi.length > 0) {
        self.maSanBayDi = sMaSanBayDi;
    }
    if (sMaSanBayDen.length > 0) {
        self.maSanBayDen = sMaSanBayDen;
    }
    if (sThoiGian.length > 0) {
        self.thoiGian = sThoiGian;
    }
    if (sGioBay.length > 0) {
        self.gioBay = sGioBay;
    }
    if (sGioDen.length > 0) {
        self.gioDen = sGioDen;
    }
    if (sThoiGianBay.length > 0) {
        self.thoiGianBay = sThoiGianBay;
    }
    if (sMaChuyenBay.length > 0) {
        self.maChuyenBay = sMaChuyenBay;
    }
    return self;
}

@end
