//
//  MoTaChiTietHoaDonDien.h
//  ViViMASS
//
//  Created by DucBT on 4/9/15.
//
//

#import <Foundation/Foundation.h>

@interface MoTaChiTietKhachHang : NSObject
@property (nonatomic, copy) NSString *maKhachHang;
@property (nonatomic, copy) NSString *tenKhachHang;
@property (nonatomic, copy) NSString *diaChi;
@property (nonatomic, copy) NSString *maDienLuc;
@property (nonatomic, copy) NSString *kyThanhToan;
@property (nonatomic, retain) NSArray *list;
@property (nonatomic, copy) NSNumber *total;
@property (nonatomic, copy) NSNumber *maLoi;
@property (nonatomic, copy) NSString *thongBaoLoi;

- (id)initWithDictionary:(NSDictionary*)dict;

@end
