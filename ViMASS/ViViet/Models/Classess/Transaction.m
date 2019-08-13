//
//  ListTransactions.m
//  ViMASS
//
//  Created by QUANGHIEP on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Transaction.h"
#import "Common.h"
#import "AppDelegate.h"

@implementation Transaction
@synthesize transactionDate, amount, accountNo, desc ,isRevert;

- (void) dealloc
{
    self.transactionDate    = nil;
    self.desc               = nil;
    self.accountNo          = nil;
    self.amount             = nil;
    [super dealloc];
}
- (id) initWithDictionary:(NSDictionary*)dictionary
{
    if((self = [super init]))
    {
        [self setAmount:[dictionary objectForKey:@"amount"]];
        NSString *sign = [amount substringToIndex:1];
        _incoming = [sign isEqualToString:@"+"];
        
        NSString *str_date = [dictionary objectForKey:@"date"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd/MM/yy HH:mm"];
        NSDate *date = [formatter dateFromString:str_date];
        [formatter release];
        
        self.transactionDate = date;
        // parse DESCRIPTION
        NSString *description = ((NSString*)[dictionary objectForKey:@"desc"]).trim;
//        NSArray *des_subs = [description componentsSeparatedByString:@":"];
        
//#warning CHUA HIEU du lieu sao ke tra ve ntn
//#warning EM PARSE đối phó tạm thời đó anh, anh bỏ đi parse lại cũng được
#if 0
        if (des_subs.count > 1)
        {
            // des_has_receiver= Revert || Chuyen tu 0915523599 den 0915152823
            NSString * des_has_receiver = [des_subs objectAtIndex:0]; 
            if ([des_has_receiver.trim.lowercaseString isEqualToString:@"revert"])
            {
                isRevert = YES;
                des_has_receiver = [des_subs objectAtIndex:1];
            }
            
            NSRange des_has_receiver_range = [description rangeOfString:des_has_receiver];
            self.desc = [description substringFromIndex:des_has_receiver_range.length - 1];
            
            [self setAccountNumberWithString:des_has_receiver];
        }else //count == 0|1
            if ([self setAccountNumberWithString:description] == NO)
                [self setDesc:description];
#else
        self.desc = description;
#endif
    
    }
    return self;
}
-(void)setDesc:(NSString *)desc_
{
    if (desc_ != desc)
    {
        [desc release];
        desc = [LocalizedString(desc_.trim.lowercaseString) copy];
    }
}

-(BOOL)setAccountNumberWithString:(NSString*) description
{
    BOOL sucess = FALSE;
    
    NSString * desc_ = [description copy];
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"[0-9]{8,14}"
                                                                      options:NSRegularExpressionCaseInsensitive
                                                                        error:nil];
    NSArray * matchers = [regex matchesInString:desc_
                                        options:0
                                          range:NSMakeRange(0, desc_.length)];
    if (matchers && matchers.count == 2)
    {
        NSTextCheckingResult * result = nil;
        result = [matchers objectAtIndex:0];
        NSString *number_1 = [description substringWithRange:result.range];
        
        if ([number_1.trim.lowercaseString isEqualToString:current_account.trim.lowercaseString] == NO)
        {
            self.accountNo = number_1;
        }else
        {
            result = [matchers objectAtIndex:1];
            NSString *number_2 = [description substringWithRange:result.range];
            self.accountNo = number_2;
        }
        sucess = YES;
    }
    
    [regex release];
    [desc_ release];
    return sucess;
}

@end
