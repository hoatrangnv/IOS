//
//  SMSInfo.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 12/13/12.
//
//

#import "SMSInfo.h"

@implementation SMSInfo

+ (SMSInfo *) parse:(NSString *)str
{
    SMSInfo *sms = [[SMSInfo new] autorelease];
    
    NSRange r = {6, str.length - 6};
    NSRange secondColon = [str rangeOfString:@":" options:NSCaseInsensitiveSearch range:r];
    
    if (secondColon.location == NSNotFound)
    {
        sms.toPhone = @"";
        sms.content = @"";
    }
    else
    {
        sms.toPhone = [str substringWithRange:NSMakeRange(6, secondColon.location  - 6)];
        sms.content = [str substringFromIndex:secondColon.location + secondColon.length];
    };
    
    return sms;
}

- (void)dealloc
{
    self.toPhone =nil;
    self.content = nil;
    [super dealloc];
}

@synthesize toPhone;
@synthesize content;

@end
