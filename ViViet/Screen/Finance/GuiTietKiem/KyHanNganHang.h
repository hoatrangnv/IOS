//
//  KyHanNganHang.h
//  ViViMASS
//
//  Created by DucBui on 5/13/15.
//
//

#import "KyLaiNganHang.h"

@interface KyHanNganHang : NSObject
@property (nonatomic, copy) NSString *maKyHan;
@property (nonatomic, copy) NSString *noiDung;
@property (nonatomic, copy) NSNumber *laiSuat;
@property (nonatomic, retain) NSArray *mDanhSachKyLai;

- (id)initWithDictionary:(NSDictionary*)dict;

- (NSString*)layCotLaiSuatTheoKiHan;

@end
