//
//  MaDienLuc.h
//  ViViMASS
//
//  Created by DucBT on 4/8/15.
//
//

#import <Foundation/Foundation.h>

@interface MaDienLuc : NSObject

@property (nonatomic, copy) NSString *maDienLuc;
@property (nonatomic, copy) NSString *tinhThanh;
@property (nonatomic, copy) NSNumber *khuVuc;

- (id)initWithDictionary:(NSDictionary*)dict;

+ (NSArray*)layDanhSachMaDienLucTuFile;
@end
