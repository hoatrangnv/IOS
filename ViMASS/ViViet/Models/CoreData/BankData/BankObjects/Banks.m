//
//  Banks.m
//  ViMASS
//
//  Created by Chung NV on 12/5/13.
//
//

#import "Banks.h"
#import "Common.h"

@implementation Banks

@dynamic bank_code;
@dynamic bank_id;
@dynamic bank_name;
@dynamic bank_order;
@dynamic bank_name_en;
@dynamic bank_sms;


-(NSString *)getName
{
    NSString * name = nil;
    if ([Common getAppLanguage] == 0)
    {
        name = self.bank_name;
    }else
    {
        name = self.bank_name_en;
    }
    return name;
}


@end
