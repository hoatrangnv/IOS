//
//  HanMucGiaoDich.m
//  ViViMASS
//
//  Created by DucBT on 2/11/15.
//
//

#import "HanMucGiaoDich.h"
#import "GioiHanGiaoDich.h"

@implementation HanMucGiaoDich

- (id) initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if(self)
    {
        NSArray *arr = [dict valueForKey:@"transactionLimits"];
        NSMutableArray *danhSachGioiHan = [[NSMutableArray alloc] initWithCapacity:arr.count];
        for(NSDictionary *dictGioiHan in arr)
        {
            GioiHanGiaoDich *gioiHanGiaoDich = [[GioiHanGiaoDich alloc] initWithDictionary:dictGioiHan];
            [danhSachGioiHan addObject:gioiHanGiaoDich];
            [gioiHanGiaoDich release];
        }
        
        NSString *idOwner = [dict valueForKey:@"idOwner"];
        NSNumber *typeAuthenticate = [dict valueForKey:@"typeAuthenticate"];
        self.mDanhSachGioiHan = danhSachGioiHan;
        [danhSachGioiHan release];
        self.idOwner = idOwner;
        self.typeAuthenticate = typeAuthenticate;
    }
    return self;
}

- (NSDictionary*)toDict
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for(GioiHanGiaoDich *gioiHan in _mDanhSachGioiHan)
    {
        [arr addObject:[gioiHan toDict]];
    }
    [dict setValue:arr forKey:@"transactionLimits"];
    [arr release];
    NSDictionary *dictTraVe = [NSDictionary dictionaryWithDictionary:dict];
    return dictTraVe;
}


- (void)dealloc
{
    [_mDanhSachGioiHan release];
    [_idOwner release];
    [_typeAuthenticate release];
    [super dealloc];
}
@end
