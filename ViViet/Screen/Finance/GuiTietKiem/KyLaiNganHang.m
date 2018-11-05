//
//  KyLaiNganHang.m
//  ViViMASS
//
//  Created by DucBui on 5/13/15.
//
//


#import "KyLaiNganHang.h"

@implementation KyLaiNganHang

- (id)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if(self)
    {
        NSNumber *maLai = [dict valueForKey:@"maLai"];
        if(maLai)
            self.maLai = maLai;
        else
            self.maLai = [NSNumber numberWithInt:-1];
        NSString *noiDungLai = [dict valueForKey:@"noiDungLai"];
        if(noiDungLai)
            self.noiDungLai = noiDungLai;
        else
            self.noiDungLai = @"";
        
        NSArray *dsCachQuayVong = [dict valueForKey:@"cachQuayVong"];
        if(dsCachQuayVong)
        {
            NSMutableArray *arrTemp = [[NSMutableArray alloc] initWithCapacity:dsCachQuayVong.count];
            for(NSDictionary *dictTemp in dsCachQuayVong)
            {
                CachQuayVongKyLai *cachQuayVong = [[CachQuayVongKyLai alloc] initWithDictionary:dictTemp];
                [arrTemp addObject:cachQuayVong];
                [cachQuayVong release];
            }
            
            self.mDanhSachCachQuayVong = arrTemp;
            [arrTemp release];
        }
        else
        {
            self.mDanhSachCachQuayVong = [NSArray new];
        }
        
    }
    return self;
}

- (void)dealloc
{
    [_maLai release];
    [_noiDungLai release];
    [_mDanhSachCachQuayVong release];
    [super dealloc];
}
@end
