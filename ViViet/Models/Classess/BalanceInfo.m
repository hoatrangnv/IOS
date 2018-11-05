//
//  BalanceInfo.m
//  ViMASS
//
//  Created by GOD on 11/8/12.
//
//

#import "BalanceInfo.h"
#import "Static.h"
@implementation BalanceInfo

-(id)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init])
    {
        self.accountName = [dic objectForKey:@"accountName"];
        self.accountBalance = [dic objectForKey:@"balance"];
    }
    return self;
}
-(id)initwithBalance:(NSString *)balance
{
    if (self = [super init])
    {
        self.accountBalance = balance;
    }
    return self;
}

-(void)dealloc
{
    self.accountBalance = nil;
    self.accountName = nil;
    [super dealloc];
}

@synthesize accountBalance = _accountBalance;
@synthesize accountName = _accountName;

@end
