//
//  DoiTuongTinhThanh.h
//  ViViMASS
//
//  Created by DucBui on 7/13/15.
//
//

#import "DoiTuongQuanHuyen.h"

@interface DoiTuongTinhThanh : DoiTuongDiaDiem

@property (nonatomic, copy) NSNumber *maTinh;

@property (nonatomic, retain) NSArray *dsQuanHuyen;


+ (NSArray*)layDanhSachTinhThanh;

@end
