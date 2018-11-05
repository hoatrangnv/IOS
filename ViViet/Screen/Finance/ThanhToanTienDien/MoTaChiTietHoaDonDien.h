//
//  MoTaChiTietHoaDonDien.h
//  ViViMASS
//
//  Created by DucBT on 4/9/15.
//
//

#import <Foundation/Foundation.h>

@interface MoTaChiTietHoaDonDien : NSObject
@property (nonatomic, copy) NSString *maHoaDon;
@property (nonatomic, copy) NSString *moTa;
@property (nonatomic, copy) NSNumber *soTien;
@property (nonatomic, copy) NSString *tienTe;
@property (nonatomic, copy) NSString *kyThanhToan;

- (id)initWithDictionary:(NSDictionary*)dict;

@end
