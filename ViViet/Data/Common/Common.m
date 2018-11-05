//
//  Common.m
//  ViVietApp
//
//  Created by QUANGHIEP on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Common.h"
#import "RNCryptor.h"
@interface Common ()

@end

@implementation Common

+ (NSDictionary * ) getLaguages:(NSString *) _lagName
{
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"Vietnamese" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    return dictionary;
}
+ (NSString *) getKeyMaHoa
{
    NSString *sKey = @"ViVietAPP";
    NSString * md5 = [Common toMD5:sKey];
    NSString *stringToReturn = [md5 substringWithRange:NSMakeRange(3, 9)];
    return stringToReturn;
}
+ (NSString *) giaiMaDataToString:(NSData *) data
{
    NSString * password = [Common getKeyMaHoa];
//    NSData *encrypted = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSData *decrypted = [[RNCryptor AES256Cryptor] decryptData:data password:password error:&error];
    NSString * stringToReturn = [NSString stringWithUTF8String:[decrypted bytes]];
    return stringToReturn;
}
+ (NSData *) maHoaStringToData:(NSString *) string
{
    NSString * password = [Common getKeyMaHoa];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSData *encrypted = [[RNCryptor AES256Cryptor] encryptData:data password:password error:&error];
//    NSString *stringToreturn  = [NSString stringWithUTF8String:[encrypted bytes]];
    return encrypted;
}
+(NSString *)toMD5:(NSString *)source
{
    const char *src = [[source lowercaseString] UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(src, strlen(src), result);
    
    NSString *ret = [[[NSString alloc] initWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                      result[0], result[1], result[2], result[3],
                      result[4], result[5], result[6], result[7],
                      result[8], result[9], result[10], result[11],
                      result[12], result[13], result[14], result[15]
                      ] autorelease];
    
    return ret;
}
@end
