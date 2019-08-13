//
//  ProfileInfo.m
//  ViMASS
//
//  Created by Chung NV on 4/15/13.
//
//

#import "ProfileInfo.h"

@implementation ProfileInfo

-(id)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init])
    {
        self.name           = [dic objectForKey:@"name"];
        self.address        = [dic objectForKey:@"address"];
        self.country        = [dic objectForKey:@"country"];
        self.accountClass   = [dic objectForKey:@"accountClass"];
        self.DOB            = [dic objectForKey:@"DOB"];
        self.email          = [dic objectForKey:@"email"];
        self.typeDate       = [dic objectForKey:@"tpeDate"];
        self.typePlace      = [dic objectForKey:@"tpePlace"];
        self.typeValue      = [dic objectForKey:@"tpeValue"];
        
        self.type           = [[dic objectForKey:@"accountType"] intValue];
        self.state          = [dic objectForKey:@"status"];
        
    }
    return self;
}

-(void)dealloc
{
    self.name = nil;
    self.address = nil;
    self.country = nil;
    self.accountClass = nil;
    self.DOB = nil;
    self.email = nil;
    self.typeDate = nil;
    self.typePlace = nil;
    self.address = nil;
    self.address = nil;
    self.address = nil;
    [super dealloc];
}

@synthesize name,address,country,accountClass,DOB,email,gender,state,type,typeDate,typePlace,typeValue;
@end
