//
//  BranchCoreData.h
//  ViMASS
//
//  Created by Chung NV on 5/27/13.
//
//


#import "BaseCoreData.h"
#import "Branches.h"

@interface BranchCoreData : BaseCoreData

+(BranchCoreData *) share;
+(BOOL) addBranchesFromJSON:(NSString *) branches_JSON;
+(NSArray *) allBranches;
+(NSArray *)getBranchByCode:(NSString *)branchCode;
+(NSArray *) getBankIDsByProvince:(int) city_id;
+(NSArray *) getBranchesByProvince:(int) city_id
                           andBank:(int)bank_id;
+ (NSArray *)getAllBanks;
@end
