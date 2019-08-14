//
//  BalanceInfo.h
//  ViMASS
//
//  Created by GOD on 11/8/12.
//
//

#import <Foundation/Foundation.h>

@interface BalanceInfo : NSObject
{
    NSString *_accountName;
    NSString *_accountBalance;
}

@property (nonatomic, copy) NSString *accountName;
@property (nonatomic, copy) NSString *accountBalance;

-(id)initWithDictionary:(NSDictionary *)dic;
-(id)initwithBalance:(NSString *) balance;
@end
