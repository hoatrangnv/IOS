//
//  ObjectFilm.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 12/7/15.
//
//

#import "ObjectFilm.h"

@implementation ObjectFilm

- (id)initWithDictionary:(NSDictionary*)dict{
    self = [super init];
    if(self)
    {
        [self khoiTaoLaiDuLieu:dict];
    }
    return self;
}

- (void)khoiTaoLaiDuLieu:(NSDictionary*)dict{
    NSString *sId = [dict objectForKey:@"idRap"];
    NSString *stenPhim = [dict objectForKey:@"tenPhim"];
    NSString *sidPhim = [dict objectForKey:@"idPhim"];
//    NSLog(@"%s - sidPhim : %@", __FUNCTION__, sidPhim);
    NSString *sngayKhoiChieu = [dict objectForKey:@"ngayKhoiChieu"];
    NSString *sanhDaiDien = [dict objectForKey:@"anhDaiDien"];
    NSString *sthoiLuong = [dict objectForKey:@"thoiLuong"];
    NSString *sdaoDien = [dict objectForKey:@"daoDien"];
    NSString *sdienVien = [dict objectForKey:@"dienVien"];
    NSString *squocGia = [dict objectForKey:@"quocGia"];
    NSString *sngonNgu = [dict objectForKey:@"ngonNgu"];
    NSString *stheLoai = [dict objectForKey:@"theLoai"];
    NSString *strailer = [dict objectForKey:@"trailer"];
    NSString *snoiDung = [dict objectForKey:@"noiDung"];
    NSString *sDSRap = [dict objectForKey:@"dsRap"];
//    NSLog(@"%s - sDSRap : %@", __FUNCTION__, sDSRap);
    if (sId ) {
        self.idRap = sId;
    }
    else{
        self.idRap = @"";
    }
    if (stenPhim ) {
        self.tenPhim = stenPhim;
    }
    else{
        self.tenPhim = @"";
    }
    if (sidPhim ) {
        self.idPhim = sidPhim;
    }
    else{
        self.idPhim = @"";
    }
    if (sngayKhoiChieu ) {
        self.ngayKhoiChieu = sngayKhoiChieu;
    }
    else{
        self.ngayKhoiChieu = @"";
    }
    if (sanhDaiDien ) {
        self.anhDaiDien = sanhDaiDien;
    }
    else{
        self.anhDaiDien = @"";
    }
    if (sthoiLuong ) {
        self.thoiLuong = sthoiLuong;
    }
    else{
        self.thoiLuong = @"";
    }
    if (sdaoDien ) {
        self.daoDien = sdaoDien;
    }
    else{
        self.daoDien = @"";
    }
    if (sdienVien ) {
        self.dienVien = sdienVien;
    }
    else{
        self.dienVien = @"";
    }
    if (squocGia ) {
        self.quocGia = squocGia;
    }
    else{
        self.quocGia = @"";
    }
    if (sngonNgu ) {
        self.ngonNgu = sngonNgu;
    }
    else{
        self.ngonNgu = @"";
    }
    if (stheLoai ) {
        self.theLoai = stheLoai;
    }
    else{
        self.theLoai = @"";
    }
    if (strailer ) {
        self.trailer = strailer;
    }
    else{
        self.trailer = @"";
    }
    if (snoiDung ) {
        self.noiDung = snoiDung;
    }
    else{
        self.noiDung = @"";
    }
    if (sDSRap) {
        self.dsRap = sDSRap;
    }
    else{
        self.dsRap = @"";
    }
}

- (void)dealloc{
    [_idRap release];
    [_tenPhim release];
    [_idPhim release];
    [_ngayKhoiChieu release];
    [_anhDaiDien release];
    [_thoiLuong release];
    [_daoDien release];
    [_dienVien release];
    [_quocGia release];
    [_ngonNgu release];
    [_theLoai release];
    [_trailer release];
    [_noiDung release];
    [_dsRap release];
    [super dealloc];
}
@end
