//
//  LocalData.m
//  ViMASS
//
//  Created by Chung NV on 5/4/13.
//
//

#import "LocalData.h"
#import "JSONKit.h"
#import "ProvinceInfo.h"
#import "BankInfo.h"

@implementation LocalData
+(NSMutableArray *)getProvinces
{
    NSString *f = [[NSBundle mainBundle] pathForResource:@"getProvinces" ofType:@"txt"];
    NSString *getProvinces = [NSString stringWithContentsOfFile:f encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *model = [getProvinces objectFromJSONString];
    
    if ([model isKindOfClass:[NSArray class]])
    {
        NSMutableArray *provinces = [[[NSMutableArray alloc] initWithCapacity:model.count] autorelease];
        for (NSDictionary *provinceJson in model)
            [provinces addObject:[ProvinceInfo provinceInfoFromDictionary:provinceJson]];

        return provinces;
    }
    return nil;
}

+(NSMutableArray *)getBanks
{
    NSString *f = [[NSBundle mainBundle] pathForResource:@"getBanks" ofType:@"txt"];
    NSString *getBanks = [NSString stringWithContentsOfFile:f encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *banksJson = [getBanks objectFromJSONString];
    if ([banksJson isKindOfClass:[NSArray class]])
    {
        NSMutableArray *banks = [[[NSMutableArray alloc] initWithCapacity:banksJson.count] autorelease];
        for (NSDictionary *bankInfoJson in banksJson)
            [banks addObject:[BankInfo bankInfoFromDictionary:bankInfoJson]];
        
        return banks;
    }
    return nil;
}
@end
