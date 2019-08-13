//
//  ItemInfoDiaDiem.h
//  ViViMASS
//
//  Created by nguyen tam on 9/7/15.
//
//

#import <Foundation/Foundation.h>

@interface ItemInfoDiaDiem : NSObject

@property(nonatomic, copy) NSString *ten;
@property(nonatomic) double latude;
@property(nonatomic) double longtude;
@property(nonatomic) int kc;
@property(nonatomic, retain) NSMutableArray *dsCon;

- (void)khoiTaoDoiTuong:(NSDictionary *)dic;

@end
