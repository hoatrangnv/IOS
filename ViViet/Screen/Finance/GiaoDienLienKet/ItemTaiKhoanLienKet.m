//
//  ItemTaiKhoanLienKet.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 10/6/16.
//
//

#import "ItemTaiKhoanLienKet.h"
#import "JSONKit.h"
@implementation ItemTaiKhoanLienKet

- (id)khoiTao:(NSDictionary *)dict {
    self = [super init];
    if (self) {
//        NSLog(@"%s - dict : %@", self.self.FUNCTIONself.self., [dict JSONString]);
        self.sId = [dict valueForKey:@"id"];
        self.idVi = [dict valueForKey:@"idVi"];
        self.maNganHang = [dict valueForKey:@"maNganHang"];
        self.tenChuTaiKhoan = [dict valueForKey:@"tenChuTaiKhoan"];
        self.soTaiKhoan = [dict valueForKey:@"soTaiKhoan"];
        
        self.soThe = [dict valueForKey:@"soThe"];
        self.cardMonth = [[dict valueForKey:@"cardMonth"] intValue];
        self.cardYear = [[dict valueForKey:@"cardYear"] intValue];
        
        self.u = [dict valueForKey:@"u"];
        self.p = [dict valueForKey:@"p"];
        self.trangThai = [[dict valueForKey:@"trangThai"] intValue];
        self.danhDauTKMacDinh = [[dict valueForKey:@"danhDauTKMacDinh"] intValue];
        self.danhDauTheMacDinh = [[dict valueForKey:@"danhDauTheMacDinh"] intValue];
        self.kieuXacThuc = [[dict valueForKey:@"kieuXacThuc"] intValue];
        self.lengthP = [[dict valueForKey:@"lengthP"] intValue];
        self.lengthU = [[dict valueForKey:@"lengthU"] intValue];
//        NSLog(@"%s - maNganHang : %@", __FUNCTION__, self.maNganHang);
//        NSLog(@"%s - tenChuTaiKhoan : %@", __FUNCTION__, self.tenChuTaiKhoan);
//        NSLog(@"%s - self.soTaiKhoan : %@", __FUNCTION__, self.soTaiKhoan);
    }
    return self;
}

- (NSString *)toDict {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.sId forKey:@"id"];
    [dict setValue:self.idVi forKey:@"idVi"];
    [dict setValue:self.maNganHang forKey:@"maNganHang"];
    [dict setValue:self.tenChuTaiKhoan forKey:@"tenChuTaiKhoan"];
    [dict setValue:self.soTaiKhoan forKey:@"soTaiKhoan"];
    [dict setValue:self.u forKey:@"u"];
    [dict setValue:self.p forKey:@"p"];
    [dict setValue:[NSNumber numberWithInt:self.trangThai] forKey:@"trangThai"];
    [dict setValue:[NSNumber numberWithInt:self.danhDauTKMacDinh] forKey:@"danhDauTKMacDinh"];
    [dict setValue:[NSNumber numberWithInt:self.danhDauTheMacDinh] forKey:@"danhDauTheMacDinh"];
    [dict setValue:[NSNumber numberWithInt:self.kieuXacThuc] forKey:@"kieuXacThuc"];
    [dict setValue:[NSNumber numberWithInt:self.lengthP] forKey:@"lengthP"];
    [dict setValue:[NSNumber numberWithInt:self.lengthU] forKey:@"lengthU"];
    return [dict JSONString];
}

@end
