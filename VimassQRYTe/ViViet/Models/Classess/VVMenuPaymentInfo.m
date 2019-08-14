//
//  VVMenuPaymentInfo.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 11/23/12.
//
//

#import "VVMenuPaymentInfo.h"
#import "VVMenuItem.h"
#import "JSONKit.h"

@implementation VVMenuPaymentInfo

-(id)initWithString:(NSString *)str
{
    if (str)
    {
        NSRange range = [str rangeOfString:@"viviet://menu/"];
        if (range.location == 0)
        {
            NSString *jsonStr = [str substringFromIndex:range.length];
            if (jsonStr && jsonStr.length > 0)
            {
                NSDictionary *jsonDict = [jsonStr objectFromJSONString];
                if ([jsonDict isKindOfClass:[NSDictionary class]])
                {
                    return [self initWithDictionary:jsonDict];
                }
            }
        }
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if ([dict isKindOfClass:[NSDictionary class]])
        {
            self.account = [dict objectForKey:@"acc"];
            self.shopName = [dict objectForKey:@"shop"];
            self.comment = [dict objectForKey:@"comment"];
            self.items = [VVMenuItem itemsFromArray:[dict objectForKey:@"items"]];
        }
    }
    
    return self;
}

-(void)dealloc
{
    self.items = nil;
    self.shopName = nil;
    self.account = nil;
    self.comment = nil;
    [super dealloc];
}

@synthesize items;
@synthesize shopName;
@synthesize account;
@synthesize comment;

@end
