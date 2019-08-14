//
//  TransferInfo.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 12/13/12.
//
//

#import "TransferInfo.h"
#import "JSONKit.h"

@implementation TransferInfo

+ (TransferInfo *) transferInfoWithDictionary:(NSDictionary*)dic
{
    TransferInfo * inf = nil;
    
    if ([dic isKindOfClass:[NSDictionary class]])
    {
        inf.amount = [dic objectForKey:@"amount"];
        inf.receiver = [dic objectForKey:@"receiver"];
        inf.description = [dic objectForKey:@"comment"];
    }
    return inf;
}

+ (TransferInfo *) transferInfoWithString:(NSString *)str
{
    if (str)
    {
        NSRange range = [str rangeOfString:@"viviet://transfer/" options:NSCaseInsensitiveSearch];
        if (range.location == 0)
        {
            NSString *jsonStr = [str substringFromIndex:range.length];
            if (jsonStr && jsonStr.length > 0)
            {
                NSDictionary *jsonDict = [jsonStr objectFromJSONString];
                if ([jsonDict isKindOfClass:[NSDictionary class]])
                {
                    return [self transferInfoWithDictionary:jsonDict];
                }
            }
        }
    }
    return nil;
}

- (void)dealloc
{
    self.amount = nil;
    self.receiver = nil;
    self.description = nil;
    [super dealloc];
}

@synthesize amount;
@synthesize receiver;
@synthesize description;

@end
