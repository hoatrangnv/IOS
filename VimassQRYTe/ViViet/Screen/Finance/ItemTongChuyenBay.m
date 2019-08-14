//
//  ItemTongChuyenBay.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 1/9/16.
//
//

#import "ItemTongChuyenBay.h"

@implementation ItemTongChuyenBay
- (id)khoiTao{
    self = [super init];
    if (self) {
        self.arrItemChuyenBay = [[NSMutableArray alloc] init];
    }
    return self;
}
@end
