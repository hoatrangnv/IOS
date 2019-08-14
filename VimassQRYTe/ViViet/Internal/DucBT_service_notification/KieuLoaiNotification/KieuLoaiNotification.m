//
//  KieuLoaiNotification.m
//  BIDV
//
//  Created by Mac Mini on 9/17/14.
//
//

#import "KieuLoaiNotification.h"

@implementation KieuLoaiNotification

- (id)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if(self)
    {
        self.nKieu = dict[@"nKieu"];
        self.sTenLoai = dict[@"sTenLoai"];
    }
    return self;
}

- (void)dealloc
{
    if(_nKieu)
       [_nKieu release];
    if (_sTenLoai) {
        [_sTenLoai release];
    }
    [super dealloc];
}
@end
