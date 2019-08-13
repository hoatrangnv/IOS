//
//  KyLaiNganHang.h
//  ViViMASS
//
//  Created by DucBui on 5/13/15.
//
//

#import "CachQuayVongKyLai.h"

@interface KyLaiNganHang : NSObject

@property (nonatomic, copy) NSString *noiDungLai;
@property (nonatomic, copy) NSNumber *maLai;
@property (nonatomic, retain) NSArray *mDanhSachCachQuayVong;

- (id)initWithDictionary:(NSDictionary*)dict;
@end
