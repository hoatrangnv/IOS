//
//  ProvinceInfo.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 12/5/12.
//
//

#import "ProvinceInfo.h"

@implementation ProvinceInfo

+(ProvinceInfo *)provinceInfoFromDictionary:(NSDictionary *)dict
{
    ProvinceInfo *pro = [[ProvinceInfo new]autorelease];
    if ([dict isKindOfClass:[NSDictionary class]])
    {
        pro.provinceName = [dict objectForKey:@"name"];
        pro.provinceID = [dict objectForKey:@"id"];
    }
    return pro;
}

-(void)dealloc
{
    self.provinceName = nil;
    self.provinceID = nil;
    [super dealloc];
}

@synthesize provinceID;
@synthesize provinceName;

@end
