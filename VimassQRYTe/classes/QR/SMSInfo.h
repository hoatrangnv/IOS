//
//  SMSInfo.h
//  ViMASS
//
//  Created by Ngo Ba Thuong on 12/13/12.
//
//

#import <Foundation/Foundation.h>

@interface SMSInfo : NSObject

+ (SMSInfo *) parse:(NSString *)str;

@property (nonatomic, copy) NSString *toPhone;
@property (nonatomic, copy) NSString *content;

@end
