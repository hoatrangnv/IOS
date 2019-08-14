//
//  Branches.m
//  ViMASS
//
//  Created by Chung NV on 12/5/13.
//
//

#import "Branches.h"
#import "Common.h"

@implementation Branches

@dynamic bank_id;
@dynamic branch_code;
@dynamic branch_id;
@dynamic branch_name;
@dynamic city_id;
@dynamic branch_name_en;
@dynamic branch_sms;

-(NSString *)getName
{
    NSString * name = nil;
    if ([Common getAppLanguage] == 0)
    {
        name = self.branch_name;
    }else
    {
        name = self.branch_name_en;
    }
    return name;
}

@end
