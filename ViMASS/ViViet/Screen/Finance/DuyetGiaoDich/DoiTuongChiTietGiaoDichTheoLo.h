//
//  DoiTuongChiTietGiaoDichTheoLo.h
//  ViViMASS
//
//  Created by DucBui on 6/25/15.
//
//

#import "DoiTuongChiTietGiaoDich.h"

@interface DoiTuongChiTietGiaoDichTheoLo : DoiTuongChiTietGiaoDich

@property (nonatomic, copy) NSNumber *funcId;
@property (nonatomic, retain) DoiTuongChiTietGiaoDich *mDoiTuongChiTietGiaoDich;
@property (nonatomic, copy) NSString *moTa;
@property (nonatomic, copy) NSNumber *trangThai;

@end
