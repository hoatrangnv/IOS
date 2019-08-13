//
//  TransferInfo.h
//  ViMASS
//
//  Created by Ngo Ba Thuong on 12/13/12.
//
//

#import <Foundation/Foundation.h>

@interface TransferInfo : NSObject

@property (nonatomic, copy) NSString *receiver;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *description;

+ (TransferInfo *) transferInfoWithString:(NSString *)str;
+ (TransferInfo *) transferInfoWithDictionary:(NSDictionary*)dic;

@end
