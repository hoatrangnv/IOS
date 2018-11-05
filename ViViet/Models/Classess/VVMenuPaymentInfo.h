//
//  VVMenuPaymentInfo.h
//  ViMASS
//
//  Created by Ngo Ba Thuong on 11/23/12.
//
//

#import <Foundation/Foundation.h>

@interface VVMenuPaymentInfo : NSObject

@property (nonatomic, retain) NSMutableArray* items;
@property (nonatomic, copy) NSString *shopName;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *comment;

-(id) initWithDictionary:(NSDictionary *)dict;
-(id) initWithString:(NSString *)str;

@end
