//
//  ViMASSPlace.m
//  ViMASS
//
//  Created by GOD on 11/12/12.
//
//

#import "ViVietPlace.h"

@implementation ViVietPlace

-(id)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init])
    {
        if ([dic isKindOfClass:[NSDictionary class]])
        {
            self.name = [dic objectForKey:@"name"];
            self.district = [dic objectForKey:@"district"];
            self.province = [dic objectForKey:@"province"];
            self.address = [dic objectForKey:@"address"];
            
            NSNumber *tmp = [dic objectForKey:@"latitude"];
            self.lat = [tmp floatValue];
            
            tmp = [dic objectForKey:@"longitude"];
            self.log = [tmp floatValue];
            
            tmp = [dic objectForKey:@"type"];
            self.type = (ViVietPlaceType)[tmp intValue];
        }
    }
    
    return self;
}

@synthesize type = _type;
@synthesize name = _name;
@synthesize address = _address;
@synthesize district = _district;
@synthesize province = _province;
@synthesize lat = _lat, log = _log;
@synthesize distance = _distance;

@end
