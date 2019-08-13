//
//  ItemGiaVeCGV.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 6/24/16.
//
//

#import <Foundation/Foundation.h>

@interface ItemGiaVeCGV : NSObject
@property (nonatomic, copy) NSString *idVe;
@property (nonatomic, copy) NSString *ghiChu;
@property (nonatomic, copy) NSString *hienThi;
@property (nonatomic, copy) NSString *tenVe;
@property (nonatomic, assign) double gia;
@property (nonatomic, assign) int sl;
@property (nonatomic, assign) int nDinhDanhGhe;
- (id)initWithDictionary:(NSDictionary*)dict;
- (NSString *)convertJSON;
@end
