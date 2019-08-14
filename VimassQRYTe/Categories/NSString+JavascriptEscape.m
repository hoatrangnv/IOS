//
//  NSString+JavascriptEscape.m
//  ViMASS
//
//  Created by Hoang Pham Huu on 9/10/13.
//
//

#import "NSString+JavascriptEscape.h"

@implementation NSString (JavascriptEscape)

- (NSString *)stringEscapedForJavasacript {
    // valid JSON object need to be an array or dictionary
    NSArray* arrayForEncoding = @[self];
    NSString* jsonString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:arrayForEncoding options:0 error:nil] encoding:NSUTF8StringEncoding];
    
    NSString* escapedString = [jsonString substringWithRange:NSMakeRange(2, jsonString.length - 4)];
    return escapedString;
}

-(NSString *)escapedString {
    /*
     
     Escape characters so we can pass a string via stringByEvaluatingJavaScriptFromString
     
     */
    // Escape the characters
    NSString *string = [self copy];
    string = [string stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    string = [string stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    string = [string stringByReplacingOccurrencesOfString:@"\'" withString:@"\\\'"];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
    string = [string stringByReplacingOccurrencesOfString:@"\f" withString:@"\\f"];
    return [string autorelease];
}


@end
