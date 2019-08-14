//
//  QRCodeInfo.m
//  ViMASS
//
//  Created by QUANGHIEP on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QRCodeInfo.h"
#import "JSONKit.h"

@implementation QRCodeInfo

@synthesize amount,receiver, comment;

- (id) initWithDictionary:(NSDictionary*)dictionary
{
    if((self = [super init]))
    {
        [self setAmount:[dictionary objectForKey:@"amount"]];
        [self setReceiver:[dictionary objectForKey:@"receiver"]];
        [self setComment:[dictionary objectForKey:@"comment"]];
    }
    return self;
}

- (id) initWithQRCodeString:(NSString *)str
{
    if (str)
    {
        NSRange range = [str rangeOfString:@"viviet://transfer/"];
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

- (void) dealloc
{
    [comment release];
    [amount release];
    [receiver release];
    [super dealloc];
}

@end
