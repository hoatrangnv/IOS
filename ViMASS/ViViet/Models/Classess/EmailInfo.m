//
//  EmailInfo.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 12/13/12.
//
//

#import "EmailInfo.h"

@implementation EmailInfo

+ (EmailInfo *)parseFromQRCode:(NSString *) str
{
    EmailInfo *inf = [[EmailInfo new] autorelease];
    
    
    if (str == nil || str.length < 8 || [str rangeOfString:@"MATMSG:" options:NSCaseInsensitiveSearch].location  != 0)
        return nil;
    
    // Parsing key:value
    NSArray *ext = [[str substringFromIndex:7] componentsSeparatedByString:@";"];
    for (NSString *pair in ext)
    {
        if (pair == nil || pair.length == 0)
            continue;
        
        NSRange r = [pair rangeOfString:@":"];
        
        if (r.location == NSNotFound || r.location + 1 >= pair.length)
            continue;
        
        NSString *key = [pair substringToIndex:r.location];
        NSString *value = [pair substringFromIndex:r.location + 1];
        
        if ([key compare:@"TO" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            if (inf.to == nil)
                inf.to = value;
            else
                inf.to = [NSString stringWithFormat:@"%@, %@", inf.to, value];
        }
        else if ([key compare:@"SUB" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            inf.subject = value;
        }
        else if ([key compare:@"BODY" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            inf.body = value;
        }
    }
    return inf;
}

+ (EmailInfo *)parse:(NSString *)str
{
    EmailInfo *inf = [[EmailInfo new] autorelease];
    
    if (str == nil || str.length < 8 || [str rangeOfString:@"mailto:" options:NSCaseInsensitiveSearch].location  != 0)
        return nil;
    
    NSRange r = [str rangeOfString:@"?" options:NSCaseInsensitiveSearch range:NSMakeRange(7, str.length - 7)];
    if (r.location == NSNotFound)
    {
        inf.to = [str substringFromIndex:7];
        return inf;
    }
    inf.to = [str substringWithRange:NSMakeRange(7, r.location - 7)];
    
    // Parsing key=value
    NSArray *ext = [[str substringFromIndex:(r.location + 1)] componentsSeparatedByString:@"&"];
    for (NSString *pair in ext)
    {
        if (pair == nil || pair.length == 0)
            continue;
        
        r = [pair rangeOfString:@"="];
        
        if (r.location == NSNotFound || r.location + 1 >= pair.length)
            continue;
        
        NSString *key = [pair substringToIndex:r.location];
        NSString *value = [pair substringFromIndex:r.location + 1];
        value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        if ([key compare:@"cc" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            if (inf.cc == nil)
                inf.cc = value;
            else
                inf.cc = [NSString stringWithFormat:@"%@, %@", inf.cc, value];
        }
        else if ([key compare:@"subject" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            inf.subject = value;
        }
        else if ([key compare:@"body" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            inf.body = value;
        }
    }
    return inf;
}

- (NSString *)toURL
{
//    NSString *path = [NSString stringWithFormat:@"mailto:%@?cc=%@&subject=%@&body=%@",
//                      self.to == nil ? @"" : self.to,
//                      self.cc == nil ? @"" : self.cc,
//                      self.subject == nil ? @"" : self.subject,
//                      self.body == nil ? @"" : self.body];
    NSString *path = [NSString stringWithFormat:@"mailto:%@?subject=%@&body=%@",
                      self.to == nil ? @"" : self.to,
                      self.subject == nil ? @"" : self.subject,
                      self.body == nil ? @"" : self.body];
    
    return [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *) toQRCodeURL
{
    NSString *url = [NSString stringWithFormat:@"MATMSG:TO:%@;SUB:%@;BODY:%@;;",
                     self.to == nil ? @"" : self.to,
                     self.subject == nil ? @"" : self.subject,
                     self.body == nil ? @"" : self.body];
    
    return url;
}

- (void)dealloc
{
    self.to = nil;
    self.cc = nil;
    self.body = nil;
    self.subject = nil;
    
    [super dealloc];
}

@synthesize to;
@synthesize cc;
@synthesize body;
@synthesize subject;

@end
