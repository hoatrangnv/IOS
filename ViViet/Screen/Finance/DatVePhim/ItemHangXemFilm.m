//
//  ItemHangXemFilm.m
//  ViViMASS
//
//  Created by nguyen tam on 9/17/15.
//
//

#import "ItemHangXemFilm.h"
#import "ItemGheXemFilm.h"

@implementation ItemHangXemFilm

- (void)khoiTaoHangXemFilm:(NSDictionary *)dic{
    NSString *tenHang = [dic objectForKey:@"stt"];
    if (tenHang) {
        self.stt = tenHang;
    }
    else
        self.stt = @"";
    NSArray *arrTemp = [dic objectForKey:@"ghe"];
    if (arrTemp) {
//         NSArray *arrSort = [arrTemp sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
//            int nIndex1 = [[obj1 objectForKey:@"stt"] intValue];
//            int nIndex2 = [[obj2 objectForKey:@"stt"] intValue];
//            return nIndex1 > nIndex2;
//        }];

        for (NSDictionary *item in arrTemp) {
            if (!self.arrGhe) {
                self.arrGhe = [[NSMutableArray alloc] init];
            }
            ItemGheXemFilm *temp = [[ItemGheXemFilm alloc] init];
            temp.sHangGhe = self.stt;
            [temp khoiTaoGhe:item];
            if (self.typeHienThi == 1) {
                temp.hienThi = @"1";
            }
            [self.arrGhe addObject:temp];
        }
    }
}

- (void)dealloc{
    if (_arrGhe) {
        [_arrGhe release];
    }
    [super dealloc];
}

@end
