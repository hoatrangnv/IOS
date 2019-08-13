//
//  iCalendarEventCore.h
//  ViMASS
//
//  Created by Ngo Ba Thuong on 11/5/13.
//
//

#import <Foundation/Foundation.h>

@interface iCalendarEventCore : NSObject

@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSDate *begin;
@property (nonatomic, copy) NSDate *end;

- (NSString *)description;
+ (iCalendarEventCore *)parse:(NSString *)str;

@end
