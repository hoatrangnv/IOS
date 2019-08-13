//
//  BankCoreData.h
//  ViMASS
//
//  Created by Chung NV on 5/27/13.
//
//

#import "BaseCoreData.h"
#import "Banks.h"

@interface BankCoreData : BaseCoreData
+ (BankCoreData *) share;
+ (BOOL) addBanksFromJSON:(NSString *) banks_JSON;
+ (NSArray *) allBanks;
+ (NSArray *)getBankByID:(NSNumber *)ID;
+ (NSArray *) getBanksByIDs:(NSArray *) ids;
+ (Banks*) getBankBySMS:(NSString *)bank_sms;
@end
