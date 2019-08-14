//
//  iCalendarEventCore.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 11/5/13.
//
//

#import "iCalendarEventCore.h"
#import "Common.h"

@implementation iCalendarEventCore

+ (iCalendarEventCore *)parse:(NSString *)str;
{
    if (str == nil || str.length == 0)
        return nil;
    str = [[str stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"] stringByReplacingOccurrencesOfString:@"\r" withString:@"\n"];
    
    NSArray *lines = [str componentsSeparatedByString:@"\n"];
    
    if ([[lines objectAtIndex:0] compare:@"BEGIN:VEVENT" options:NSCaseInsensitiveSearch] != NSOrderedSame)
        return nil;
    if ([(NSString *)lines.lastObject compare:@"END:VEVENT" options:NSCaseInsensitiveSearch] != NSOrderedSame)
        return nil;
    
    iCalendarEventCore * obj = [[iCalendarEventCore new] autorelease];
    for (int i = 1; i < lines.count - 1; i++)
    {
        NSString *l = [lines objectAtIndex:i];
        
        if ([l rangeOfString:@"SUMMARY:"].location == 0)
        {
            obj.summary = [l substringFromIndex:@"SUMMARY:".length];
        }
        else if ([l rangeOfString:@"LOCATION:"].location == 0)
        {
            obj.location = [l substringFromIndex:@"LOCATION:".length];
        }
        if ([l rangeOfString:@"URL:"].location == 0)
        {
            obj.url = [l substringFromIndex:@"URL:".length];
        }
        if ([l rangeOfString:@"DTSTART:"].location == 0)
        {
            NSString *s = [l substringFromIndex:@"DTSTART:".length];
            obj.begin = [s parseDateWithFormat:@"yyyyMMdd'T'HHmmss"];
        }
        if ([l rangeOfString:@"DTEND:"].location == 0)
        {
            NSString *s = [l substringFromIndex:@"DTEND:".length];
            obj.begin = [s parseDateWithFormat:@"yyyyMMdd'T'HHmmss"];
        }
    }
    
    return obj;
}

- (NSString *)description;
{
    NSString *headers[] = {
        @"SUMMARY:%@",
        @"LOCATION:%@",
        @"URL:%@",
        @"DTSTART:%@",
        @"DTEND:%@"
    };
    
    NSMutableString *s = [[[NSMutableString alloc] initWithCapacity:100] autorelease];
    [s appendString:@"BEGIN:VEVENT\r\n"];
    [s appendFormat:headers[0], self.summary];
    [s appendString:@"\r\n"];
    [s appendFormat:headers[1], self.location];
    [s appendString:@"\r\n"];
//    [s appendFormat:headers[2], self.url];
//    [s appendString:@"\n"];
    [s appendFormat:headers[3], [self.begin format:@"yyyyMMdd"]];// [self.begin format:@"yyyyMMdd'T'HHmmss'Z'"]];
    [s appendString:@"\r\n"];
    [s appendFormat:headers[4], [self.end format:@"yyyyMMdd"]];//[self.end format:@"yyyyMMdd'T'HHmmss'Z'"]];
    [s appendString:@"\r\nEND:VEVENT"];
    NSLog(@"s = %@", s);
    return s;
}

@end
