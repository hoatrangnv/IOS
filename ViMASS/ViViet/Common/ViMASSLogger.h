//
//  ViMASSLogger.h
//  ViMASS
//
//  Created by Chung NV on 5/10/13.
//
//

#import <Foundation/Foundation.h>

@interface ViMASSLogger : NSObject
+(void)writeLog:(NSString *)log;
+(NSString *)readLog:(NSDate *)date;
@end


@interface File : NSObject
+ (id)fileWithPath:(NSString *) pathFile;

- (void)deleteFile;
- (NSDate *) getDateModify;
- (BOOL) appendString:(NSString *) strAppend;


@end