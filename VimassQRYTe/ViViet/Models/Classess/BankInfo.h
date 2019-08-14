//
//  BankInfo.h
//  ViMASS
//
//  Created by Ngo Ba Thuong on 12/5/12.
//
//

#import <Foundation/Foundation.h>

@interface BankInfo : NSObject

@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, copy) NSString *bankCode;

+(BankInfo *)bankInfoFromDictionary:(NSDictionary *)dict;

@end
