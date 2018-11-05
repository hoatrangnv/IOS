//
//  CacheManager.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 3/19/13.
//
//

#import "CacheManager.h"
#import <CommonCrypto/CommonDigest.h>

#define kCACHE_MANAGER_FOLDER @"VIMASS.Cache"
@implementation CacheManager

+(NSString *)getTempDirectory
{
    NSString *temp = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
//    temp = [temp stringByAppendingPathComponent:kCACHE_MANAGER_FOLDER];
//    BOOL isDir;
//    if ([[NSFileManager defaultManager] fileExistsAtPath:temp isDirectory:&isDir] == NO)
//    {
//        [[NSFileManager defaultManager] createDirectoryAtPath:temp withIntermediateDirectories:YES attributes:nil error:nil];
//    }
    return temp;
}
+(BOOL)clearCaches
{
    return YES;
    return [[NSFileManager defaultManager] removeItemAtPath:[self getTempDirectory] error:nil];
}

+(NSString *)pathForResource:(NSString *)file
{
    NSString *dir = [[NSBundle mainBundle] bundlePath];
    NSString *path = [dir stringByAppendingPathComponent:file];
    return path;
}
+(NSString *)pathForCachedFile:(NSString *)file
{
    NSString *path = [[self getTempDirectory] stringByAppendingPathComponent:file];
    if (NO == [[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        path = [self pathForResource:file];
        if (NO == [[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            return nil;
        }
    };
    
    return path;
}

+(NSString *)pathForURI:(NSString *)uri
{
    NSString *file_name = [self hash:uri];
    
    NSString *path = [[self getTempDirectory] stringByAppendingPathComponent:file_name];
    
    return path;
}

+(NSString *)lookForURI:(NSString *)uri
{
    NSString *file_name = [self hash:uri];
    
    return [self pathForCachedFile:file_name];
}

+(NSString *)hash:(NSString *)str
{
    const char *string = [str UTF8String];
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(string, (CC_LONG)strlen(string), md5Buffer);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}
+(BOOL)storeString:(NSString *)str withURI:(NSString *)uri
{
    NSString *path = [self pathForURI:uri];
    if (path == nil || str == nil)
        return NO;
    
    return [str writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}
+(NSString *) readStringWithURI:(NSString *)uri
{
    NSString *path = [self lookForURI:uri];
    if (path == nil)
        return nil;
    
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

+(NSString *) fileCachedWithURI:(NSString *)uri
                       postJSON:(NSString *)postJSON
{
    return [[NSString stringWithFormat:@"%@ - %@",uri,postJSON] md5];
}
+(void) writeCachedWithURI:(NSString *)uri
                  postJSON:(NSString *)postJSON
                      data:(NSString *)data;
{
    NSString * fileName = [self fileCachedWithURI:uri postJSON:postJSON];
//    NSLog(@"fileName = %@",fileName);
    NSString *path = [[self getTempDirectory] stringByAppendingPathComponent:fileName];
    [data writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
}

+(NSString *)getCachedWithURI:(NSString *)uri
                     postJSON:(NSString *)postJSON
                    timeAlive:(float)timeAlive
{
    NSString * fileName = [self fileCachedWithURI:uri postJSON:postJSON];
//    NSLog(@"fileName = %@",fileName);
    NSString *path = [[self getTempDirectory] stringByAppendingPathComponent:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path] == NO)
    {
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDate * dateMofify =[[fileManager attributesOfItemAtPath:path error:nil] objectForKey:NSFileModificationDate];
    NSTimeInterval interval_modify = [[NSDate date] timeIntervalSinceDate:dateMofify];
    
    if (interval_modify > timeAlive)
    {
        return nil;
    }
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}
@end
