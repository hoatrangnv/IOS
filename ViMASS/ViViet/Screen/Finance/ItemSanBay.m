//
//  ItemSanBay.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 1/5/16.
//
//

#import "ItemSanBay.h"

@implementation ItemSanBay

- (id)khoiTaoBanDau{
    self = [super init];
    if (self) {
        self.sTenSanBay = @"";
        self.sMaSanBay = @"";
        self.arrSanBayDen = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc{
    [_sTenSanBay release];
    [_sMaSanBay release];
    [_arrSanBayDen release];
    [super dealloc];
}

@end
