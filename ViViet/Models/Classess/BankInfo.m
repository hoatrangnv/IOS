//
//  BankInfo.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 12/5/12.
//
//

#import "BankInfo.h"

@implementation BankInfo

+(BankInfo *)bankInfoFromDictionary:(NSDictionary *)dict
{
    BankInfo *bank = nil;
    
    if ([dict isKindOfClass:[NSDictionary class]])
    {
        bank = [[BankInfo new] autorelease];
        bank.bankName = [dict objectForKey:@"name"];
        bank.bankCode = [dict objectForKey:@"code"];
    }
    
    return bank;
}


-(void) dealloc
{
    self.bankCode = nil;
    self.bankName = nil;
    
    [super dealloc];
}


@synthesize bankName;
@synthesize bankCode;



@end
