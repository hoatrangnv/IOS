//
//  NganHangNapTien.h
//  ViViMASS
//
//  Created by DucBui on 4/20/15.
//
//

#import <Foundation/Foundation.h>

@interface NganHangNapTien : NSObject
@property (nonatomic, copy) NSString *tenBank;
@property (nonatomic, retain) NSArray *danhSachTheNapTien;
@property (nonatomic, copy) NSNumber *trangThaiDirect;

+ (NSArray*)layDanhSachNganHangNapTien;

@end
