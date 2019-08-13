//
//  CacheManager.h
//  ViMASS
//
//  Created by Ngo Ba Thuong on 3/19/13.
//
//

#import <Foundation/Foundation.h>


@interface CacheManager : NSObject

+(BOOL) clearCaches;

+(NSString *)pathForURI:(NSString *)uri;
+(NSString *)lookForURI:(NSString *)uri;

+(BOOL) storeString:(NSString *)str withURI:(NSString *)uri;
+(NSString *) readStringWithURI:(NSString *)uri;


+(void) writeCachedWithURI:(NSString *)uri
                  postJSON:(NSString *)postJSON
                      data:(NSString *)data;
+(NSString *) getCachedWithURI:(NSString *) uri
                      postJSON:(NSString *) postJSON
                     timeAlive:(float) timeAlive;
@end
