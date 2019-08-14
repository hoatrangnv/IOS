//
//  ProvinceCoreData.h
//  ViMASS
//
//  Created by Chung NV on 5/27/13.
//
//

#import "BaseCoreData.h"
#import "Cities.h"

@interface ProvinceCoreData : BaseCoreData
+(ProvinceCoreData *) share;
+(BOOL) addProvincesWithJSON:(NSString *) provinces_JSON;
+(NSArray *) allProvinces;
+(NSArray *)getProvincesByParentID:(int) parent_id;
@end

@interface NSString(VietNamese)

- (NSComparisonResult)vietNamese_compare:(NSString *)string;

@end