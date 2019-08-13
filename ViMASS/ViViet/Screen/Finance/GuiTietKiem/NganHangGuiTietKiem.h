//
//  NganHangGuiTietKiem.h
//  ViViMASS
//
//  Created by DucBui on 5/13/15.
//
//

#import "KyHanNganHang.h"

@interface NganHangGuiTietKiem : NSObject

@property (nonatomic, retain) NSArray *mDanhSachKyHan;
@property (nonatomic, copy) NSString *bank;
@property (nonatomic, copy) NSString *maNganHang;
@property (nonatomic, copy) NSNumber *laiKhongKyHan;

- (id)initWithDictionary:(NSDictionary*)dict;

- (NSString *)layBangLaiSuatHtml;

+ (NSArray*)layDanhSachNganHangGuiTietKiem:(NSDictionary*)dict;

@end
