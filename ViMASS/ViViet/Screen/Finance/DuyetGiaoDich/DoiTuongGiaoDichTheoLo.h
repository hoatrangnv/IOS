//
//  DoiTuongGiaoDichTheoLo.h
//  ViViMASS
//
//  Created by DucBui on 6/25/15.
//
//

#import "DoiTuongChiTietGiaoDich.h"

@interface DoiTuongGiaoDichTheoLo : DoiTuongChiTietGiaoDich

@property (nonatomic, copy) NSString *linkFile;
@property (nonatomic, retain) NSArray *mDsGiaoDich;
@property (nonatomic, copy) NSNumber *total;


@end
