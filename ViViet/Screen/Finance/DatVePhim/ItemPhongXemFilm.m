//
//  ItemPhongXemFilm.m
//  ViViMASS
//
//  Created by nguyen tam on 9/17/15.
//
//

#import "ItemPhongXemFilm.h"
#import "ItemHangXemFilm.h"
@implementation ItemPhongXemFilm

- (void)khoiTaoPhongXemFilm:(NSDictionary *)dic{
    
    NSString *tenPhong = [dic objectForKey:@"phong"];
    if (tenPhong) {
        self.phong = tenPhong;
    }
    else
        self.phong = @"";
    
    NSArray *arrTemp = [dic objectForKey:@"day"];
    if (arrTemp) {
        if (!self.arrDayGhe) {
            self.arrDayGhe = [[NSMutableArray alloc] init];
        }
        [self.arrDayGhe removeAllObjects];
        for (NSDictionary *item in arrTemp) {
            ItemHangXemFilm *hang = [[ItemHangXemFilm alloc] init];
            if (self.typeRap == 1) {
                hang.typeHienThi = 1;
            }
            [hang khoiTaoHangXemFilm:item];
            [self.arrDayGhe addObject:hang];
        }
        
    }
}

- (void)dealloc{
    if (self.arrDayGhe) {
        [self.arrDayGhe release];
    }
    if (self.phong) {
        [self.phong release];
    }
    [super dealloc];
}

@end
