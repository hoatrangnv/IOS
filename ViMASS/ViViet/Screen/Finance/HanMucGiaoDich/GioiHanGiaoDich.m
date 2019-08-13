//
//  GioiHanGiaoDich.m
//  ViViMASS
//
//  Created by DucBT on 2/11/15.
//
//

#import "GioiHanGiaoDich.h"

@implementation GioiHanGiaoDich

- (id) initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if(self)
    {
        NSNumber *typeTransfer = [dict valueForKey:@"typeTransfer"];
        NSNumber *oneTime = [dict valueForKey:@"oneTime"];
        NSNumber *oneDay = [dict valueForKey:@"oneDay"];
        NSNumber *oneMonth = [dict valueForKey:@"oneMonth"];
        self.typeTransfer = typeTransfer;
        self.oneDay = oneDay;
        self.oneMonth = oneMonth;
        self.oneTime = oneTime;
    }
    return self;
}

- (NSDictionary*)toDict
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.typeTransfer forKey:@"typeTransfer"];
    [dict setValue:self.oneTime forKey:@"oneTime"];
    [dict setValue:self.oneDay forKey:@"oneDay"];
    [dict setValue:self.oneMonth forKey:@"oneMonth"];
    NSDictionary *dictTraVe = [NSDictionary dictionaryWithDictionary:dict];
    [dict release];
    return dictTraVe;
}

- (void)dealloc
{
    [_typeTransfer release];
    [_oneTime release];
    [_oneDay release];
    [_oneMonth release];
    [super dealloc];
}

@end
