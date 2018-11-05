//
//  DoiTuongChiTietGiaoDich.h
//  ViViMASS
//
//  Created by DucBui on 6/11/15.
//
//

#import <Foundation/Foundation.h>
#import "Common.h"

@interface DoiTuongChiTietGiaoDich : NSObject


- (id)initWithDict:(NSDictionary*)dict;

- (NSString*)layChiTietHienThi;

- (NSString*)layKieuGiaoDich;

- (double)laySoTienGiaoDich;

- (double)laySoTienPhiGiaoDich;

- (NSString*)layNoiDung;

@end
