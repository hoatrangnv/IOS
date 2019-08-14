//
//  NSString+Extended.m
//  ViMASS
//
//  Created by QUANGHIEP on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocalizationSystem.h"
#import "Localization.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (Extended)

-(BOOL)likeString:(NSString *)likeString
{
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@",likeString];
    BOOL match =  [regex evaluateWithObject:self];
    return match;
}
-(BOOL) isHTTP
{
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"^http[s]{0,1}:"
                                                                      options:NSRegularExpressionCaseInsensitive
                                                                        error:nil];
    NSTextCheckingResult *found = [regex firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    BOOL c = found != nil;
    [regex release];
    return c;
}
-(BOOL)isEmpty
{
    if (self == nil)
        return YES;
    
    return self.trim.length == 0;
}

-(NSString *)trim
{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)urlencode
{
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    int sourceLen = (int)strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"%20"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' || 
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

-(NSString *)localizableString
{
    return [Localization languageSelectedStringForKey:self];
}

-(NSString *)upperCaseFirstChar
{
    if (self == nil || self.trim.length == 0)
        return nil;
    
    NSString *temp = self.trim.lowercaseString;
    NSString *firstCapChar = [[temp substringToIndex:1] capitalizedString];
    NSString *cappedString = [temp stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapChar];
    return cappedString;
}


-(NSString*) sha1
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}
- (NSString *) md5_3
{
    const char *cStr = [self UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 3];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%03x", digest[i]];
    
    return  output;
}
- (NSString *) md5
{
    const char *cStr = [self UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
    
}

-(NSData *)sha256
{
    NSData *keyData = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH]={0};
    CC_SHA256(keyData.bytes, (CC_LONG)keyData.length, digest);
    NSData *out_=[NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    return out_;
}

-(NSString *)isHexString
{
    // Squeeze out whitespace and detect illegal chars
    NSMutableString *string = [NSMutableString stringWithCapacity:[self length]];
    for (int i = 0; i < [self length]; i++) {
        unichar ch = [self characterAtIndex:i];
        if (isspace(ch))
            continue;
        if (!isxdigit(ch))
            return nil;
        [string appendFormat:@"%c", ch];
    }
    
    // Check length
    if ([string length] % 2 != 0)
        return nil;
    
    // Done
    return string;
}
-(NSData *)hexData
{
    NSMutableData* data = [NSMutableData data];
    for (int i = 0; i+2 <= self.length; i+=2)
    {
        NSRange range = NSMakeRange(i, 2);
        NSString* hexStr = [self substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}


- (NSString *)bo_dau_tieng_viet;
{
    NSString *tmp = [self stringByReplacingOccurrencesOfString:@"đ" withString:@"d"];
    tmp = [tmp stringByReplacingOccurrencesOfString:@"Đ" withString:@"D"];
    
    NSData *data = [tmp dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    char *buff = malloc(data.length + 1);
    memcpy(buff, data.bytes, data.length);
    buff[data.length] = 0;
    
    NSString *result = [NSString stringWithCString:buff encoding:NSASCIIStringEncoding];
    free(buff);
    return result;
    
    return [NSString stringWithCString:data.bytes encoding:NSASCIIStringEncoding];
        
}

- (BOOL)match_with_exp:(NSString *)reg;
{
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:reg options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [regex firstMatchInString:self
                                                    options:0
                                                      range:NSMakeRange(0, self.length)];
    [regex release];
    return match != nil;
}

-(BOOL)isYoutubeVideo
{
    //http[s]{0,1}:\\/\\/www.
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"youtube.com\\/watch\\?v=" options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *found = [regex firstMatchInString:self
                                                    options:0
                                                      range:NSMakeRange(0, self.length)];
    BOOL check = found != nil;
    [regex release];
    NSURL *url = nil; [url scheme];
    return check;
}

@end
