//
//  CachQuayVongKyLai.m
//  ViViMASS
//
//  Created by DucBui on 5/13/15.
//
//

#import "CachQuayVongKyLai.h"

@implementation CachQuayVongKyLai

- (id)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if(self)
    {
        NSString *noiDungQuayVong = [dict valueForKey:@"noiDungQuayVong"];
        if(noiDungQuayVong)
            self.noiDungQuayVong = noiDungQuayVong;
        else
            self.noiDungQuayVong = @"";
        
        NSNumber *maQuayVong = [dict valueForKey:@"maQuayVong"];
        if(maQuayVong)
            self.maQuayVong = maQuayVong;
        else
            self.maQuayVong = [NSNumber numberWithInt:-1];
    }
    return self;
}


- (void)dealloc
{
    [_noiDungQuayVong release];
    [_maQuayVong release];
    [super dealloc];
}
@end
