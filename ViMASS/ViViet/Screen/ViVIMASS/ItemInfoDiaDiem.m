//
//  ItemInfoDiaDiem.m
//  ViViMASS
//
//  Created by nguyen tam on 9/7/15.
//
//

#import "ItemInfoDiaDiem.h"

@implementation ItemInfoDiaDiem


- (void)khoiTaoDoiTuong:(NSDictionary *)dic{
    NSString* tenTemp = [dic valueForKey:@"ten"];
    if (tenTemp) {
        self.ten = tenTemp;
    }
    else
        self.ten = @"";
    double lat = [[dic valueForKey:@"lat"] doubleValue];
    self.latude = lat;
    double lng = [[dic valueForKey:@"lng"] doubleValue];
    self.longtude = lng;
    int nKc = [[dic valueForKey:@"kc"] intValue];
    self.kc = nKc;
    
    NSMutableArray *arrDsCon = [[NSMutableArray alloc] init];
    NSArray *arrTemp = [dic objectForKey:@"dsCon"];
    if (arrTemp) {
        for (int i = 0; i < arrTemp.count; i++) {
            NSDictionary *dicTemp = [arrTemp objectAtIndex:i];
            ItemInfoDiaDiem *item = [[ItemInfoDiaDiem alloc] init];
            [item khoiTaoDoiTuong:dicTemp];
            [arrDsCon addObject:item];
        }
    }
    self.dsCon = arrDsCon;
}

- (void)dealloc{
    if (self.dsCon) {
        [self.dsCon release];
    }
    [super dealloc];
}

@end
