//
//  ViMASSLogger.m
//  ViMASS
//
//  Created by Chung NV on 5/10/13.
//
//

#import "ViMASSLogger.h"
#import "Common.h"

@implementation ViMASSLogger
+(void)writeLog:(NSString *)log
{
    NSString *fileName =[self fileNameWithDate:[NSDate date]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fileName] == NO)
    {
        [log writeToFile:fileName
              atomically:YES
                encoding:NSASCIIStringEncoding
                   error:nil];
    }else
    {
        NSFileHandle *fileHandler = [NSFileHandle fileHandleForWritingAtPath:fileName];
        [fileHandler seekToEndOfFile];
        [fileHandler writeData:[log dataUsingEncoding:NSASCIIStringEncoding]];
    }
}

+(NSString *)readLog:(NSDate *)date
{
    NSString *filePath =[self fileNameWithDate:[NSDate date]];
    NSString *log = [NSString stringWithContentsOfFile:filePath encoding:NSASCIIStringEncoding error:nil];
    return log;
}

+(NSString *) fileNameWithDate:(NSDate *) date
{
    NSDateComponents *dateCompnonents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    NSString *fileName = [NSString stringWithFormat:@"ViMassLogger_%ld-%ld-%ld.txt",(long)dateCompnonents.day,(long)dateCompnonents.month,(long)dateCompnonents.year];
    return [Common pathForResource:fileName];
}
@end
