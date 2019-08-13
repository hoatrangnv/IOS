//
//  Cities.m
//  ViMASS
//
//  Created by Chung NV on 12/5/13.
//
//

#import "Cities.h"
#import "Common.h"

@implementation Cities

@dynamic city_code;
@dynamic city_id;
@dynamic city_lat;
@dynamic city_lng;
@dynamic city_name;
@dynamic city_tag;
@dynamic hasSubs;
@dynamic parent_id;
@dynamic city_name_en;
@dynamic city_sms;
-(NSString *)getName
{
    NSString * name = nil;
    if ([Common getAppLanguage] == 0)
    {
        name = self.city_name;
    }else
    {
        name = self.city_name_en;
        if (name == nil || name.trim.length == 0)
        {
            name = self.city_name;
        }
    }
    return name;
}
@end

@implementation City
-(id)initWithDictionary:(NSDictionary *) dict;
{
    if (self = [super init])
    {
        self.city_name = [dict objectForKey:@"city_name"];
        self.city_lat = [dict objectForKey:@"city_lat"];
        self.city_lng = [dict objectForKey:@"city_lng"];
        self.city_id = [dict objectForKey:@"city_id"];
        self.parent_id = [dict objectForKey:@"parent_id"];
    }
    return self;
}
-(NSDictionary *) dictionary
{
    if (!_city_name||!_city_lat||!_city_lng||!_city_id||!_parent_id)
    {
        return nil;
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[_city_name,_city_lat,_city_lng,_city_id,_parent_id] forKeys:@[@"city_name",@"city_lat",@"city_lng",@"city_id",@"parent_id"]];
    return dict;
}
-(void)dealloc
{
    [_city_name release];
    [_city_lat release];
    [_city_lng release];
    [super dealloc];
}

@end
