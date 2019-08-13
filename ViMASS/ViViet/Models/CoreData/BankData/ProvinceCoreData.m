//
//  ProvinceCoreData.m
//  ViMASS
//
//  Created by Chung NV on 5/27/13.
//
//

#import "ProvinceCoreData.h"
#import "JSONKit.h"
#import "Common.h"
#define kPROVINCE_TABLE @"Cities"

#define kPROVINCE_CODE          @"city_code"
#define kPROVINCE_NAME          @"city_name"
#define kPROVINCE_NAME_EN       @"city_name_en"
#define kPROVINCE_ID            @"city_id"
#define kPROVINCE_TAG           @"city_tag"
#define kPROVINCE_LAT           @"city_lat"
#define kPROVINCE_LNG           @"city_lng"
#define kPROVINCE_HAS_SUB       @"hasSubs"
#define kPROVINCE_PARENT_ID     @"parent_id"
#define kPROVINCE_SMS           @"city_sms"

@implementation NSString(VietNamese)

-(NSComparisonResult)vietNamese_compare:(NSString *)string
{
    NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch | NSNumericSearch | NSWidthInsensitiveSearch | NSForcedOrderingSearch;
    NSRange string1Range = NSMakeRange(0, self.length);
    return [self compare:string options:comparisonOptions range:string1Range locale:[NSLocale currentLocale]];
}

@end

@implementation ProvinceCoreData

static ProvinceCoreData * shareProvinceCoreData;

@synthesize fetchedResultsController = _fetchedResultsController;
+(ProvinceCoreData *)share
{
    if (shareProvinceCoreData == nil)
    {
        shareProvinceCoreData = [[ProvinceCoreData alloc] initWithResourceName:kBANK_CORE_DATA_RESOURCE];
    }
    return shareProvinceCoreData;
}

-(NSFetchedResultsController *) fetchedResultsController
{
    if (_fetchedResultsController)
        return _fetchedResultsController;
    
    
    self.fetchedResultsController = [self fetchedResultsOfTable:kPROVINCE_TABLE
                                                        orderBy:@[kPROVINCE_TAG,kPROVINCE_NAME]
                                                      ascending:YES];
    return _fetchedResultsController;
}

+(BOOL)addProvincesWithJSON:(NSString *)provinces_JSON
{
    if ([ProvinceCoreData allProvinces].count > 10)
    {
        return NO;
    }
    
    NSArray *arr_provinces = [provinces_JSON objectFromJSONString];
    if (arr_provinces == nil || [arr_provinces isKindOfClass:[NSArray class]] == NO)
        return NO;
    
    ProvinceCoreData *_this = [ProvinceCoreData share];
    
    NSManagedObjectContext * context = [_this.fetchedResultsController managedObjectContext];
    
    NSEntityDescription *entity = [[_this.fetchedResultsController fetchRequest] entity];
    
//    BOOL found_HN = NO;
//    BOOL found_HCM = NO;
//    BOOL found_HP = NO;
//    BOOL found_DN = NO;
//    BOOL found_CT = NO;
    for (id dict_province in arr_provinces)
    {
        NSManagedObject *newObject = [NSEntityDescription insertNewObjectForEntityForName:entity.name
                                                                   inManagedObjectContext:context];
        NSNumber *city_code = [NSNumber numberWithInt:[[dict_province objectForKey:@"CODE"] intValue]];
        NSNumber *city_id = [NSNumber numberWithInt:[[dict_province objectForKey:@"ID"] intValue]];
        NSString *city_name = [dict_province objectForKey:@"NAME_VI"];
        NSString *city_name_en = [dict_province objectForKey:@"NAME_EN"];
        NSString *city_sms = [dict_province objectForKey:@"SMS"];
        /*int tag = 10;
        if (found_HN == NO && [city_name.uppercaseString likeString:@"HA NOI"])
        {
            tag = 0;
            found_HN = YES;
        }
        if (found_HCM == NO && [city_name.uppercaseString likeString:@"HO CHI MINH"])
        {
            tag = 1;
            found_HCM = YES;
        }
        if (found_HP == NO && [city_name.uppercaseString likeString:@"HAI PHONG"])
        {
            tag = 2;
            found_HP = YES;
        }
        if (found_DN == NO && [city_name.uppercaseString likeString:@"A NANG"])
        {
            tag = 3;
            found_DN = YES;
        }
        if (found_CT == NO && [city_name.uppercaseString likeString:@"CAN THO"])
        {
            tag = 4;
            found_CT = YES;
        }*/
        int order = [[dict_province objectForKey:@"ORDER"] intValue];
        NSNumber *city_tag = [NSNumber numberWithInt:order];
        NSString *lat = [dict_province objectForKey:@"LAT"];
        NSString *lng = [dict_province objectForKey:@"LNG"];
        NSNumber *parentID = [NSNumber numberWithInt:0];
        
        [newObject setValue:city_id         forKey:kPROVINCE_ID];
        [newObject setValue:city_name       forKey:kPROVINCE_NAME];
        [newObject setValue:city_name_en    forKey:kPROVINCE_NAME_EN];
        [newObject setValue:city_sms        forKey:kPROVINCE_SMS];
        [newObject setValue:lat             forKey:kPROVINCE_LAT];
        [newObject setValue:lng             forKey:kPROVINCE_LNG];
        [newObject setValue:city_code       forKey:kPROVINCE_CODE];
        [newObject setValue:city_tag        forKey:kPROVINCE_TAG];
        [newObject setValue:parentID        forKey:kPROVINCE_PARENT_ID];
        
        
        NSArray *childs = [dict_province objectForKey:@"CHILDS"];
        if (childs != nil && [childs isKindOfClass:[NSArray class]] && childs.count > 0)
        {
            [newObject setValue:[NSNumber numberWithBool:YES] forKey:kPROVINCE_HAS_SUB];
            
            int i = 0;
            for (NSDictionary *child_dict in childs)
            {
                NSManagedObject *child_obj = [NSEntityDescription insertNewObjectForEntityForName:entity.name
                                                                           inManagedObjectContext:context];
                int c_id = [[NSString stringWithFormat:@"%@00%d",city_id,i] intValue];
                NSNumber *child_id = [NSNumber numberWithInt:c_id];
                NSString *child_name = [child_dict objectForKey:@"NAME"];
                NSString *child_lat = [child_dict objectForKey:@"LAT"];
                NSString *child_lng = [child_dict objectForKey:@"LNG"];
                NSNumber *child_tag = [NSNumber numberWithInt:(i+1)];
                [child_obj setValue:child_id    forKey:kPROVINCE_ID];
                [child_obj setValue:child_name  forKey:kPROVINCE_NAME];
                [child_obj setValue:child_lat   forKey:kPROVINCE_LAT];
                [child_obj setValue:child_lng   forKey:kPROVINCE_LNG];
                [child_obj setValue:city_id     forKey:kPROVINCE_PARENT_ID];
                [child_obj setValue:child_tag   forKey:kPROVINCE_TAG];
                
                i++;
            }
        }
    }
    NSError *error;
    if ([context save:&error] == FALSE)
    {
        NSLog(@"Insert FALSE:%@ , %@",error , error.userInfo);
        abort();
        return FALSE;
    }
    
    return YES;
}
+(NSArray *)allProvinces
{
    return [ProvinceCoreData getProvincesByParentID:0];
}

+(NSArray *)getProvincesByParentID:(int) parent_id
{
    ProvinceCoreData *_this = [ProvinceCoreData share];
    
    NSFetchRequest * fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription * entity = [NSEntityDescription entityForName:kPROVINCE_TABLE
                                               inManagedObjectContext:_this.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSMutableArray *sortDescriptors = [[NSMutableArray new] autorelease];
    NSSortDescriptor *sort_TAG = [[[NSSortDescriptor alloc] initWithKey:kPROVINCE_TAG ascending:YES] autorelease];
    [sortDescriptors addObject:sort_TAG];
    
    NSString * order_name = nil;
    if ([Common getAppLanguage] == 0)
    {
        order_name = kPROVINCE_NAME;
    }else
    {
        order_name = kPROVINCE_NAME_EN;
    }
    
    NSSortDescriptor *sort_NAME = [[[NSSortDescriptor alloc] initWithKey:order_name
                                                               ascending:YES] autorelease];
    [sortDescriptors addObject:sort_NAME];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parent_id = %d",parent_id];
    [fetchRequest setPredicate:predicate];
    
    NSArray *result = [_this.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    NSArray *cities = [result sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
      {
          Cities *c1 = obj1;
          Cities *c2 = obj2;
          if (c1.city_tag.intValue != c2.city_tag.intValue)
          {
              if(c1.city_tag.intValue < c2.city_tag.intValue)
                  return NSOrderedAscending;
              else
                  return NSOrderedDescending;
          }else
          {
              NSStringCompareOptions comparisonOptions = NSDiacriticInsensitiveSearch | NSCaseInsensitiveSearch;
              NSString * name1 = [c1.city_name.lowercaseString stringByReplacingOccurrencesOfString:@"đ" withString:@"d"];
              NSString * name2 = [c2.city_name.lowercaseString stringByReplacingOccurrencesOfString:@"đ" withString:@"d"];
              return [name1 compare:name2
                            options:comparisonOptions];
          }
      }];
    return cities;
    
    
    
    
    /*
     ProvinceCoreData *_this = [ProvinceCoreData share];
     
     _this.fetchedResultsController = [_this fetchedResultsOfTable:kPROVINCE_TABLE
     orderBy:@[kPROCINCE_TAG]
     ascending:YES];
     
     NSArray *cities = _this.fetchedResultsController.fetchedObjects;
     cities = [cities sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
     {
     Cities *c1 = obj1;
     Cities *c2 = obj2;
     if (c1.city_tag.intValue != c2.city_tag.intValue)
     {
     if(c1.city_tag.intValue < c2.city_tag.intValue)
     return NSOrderedAscending;
     else
     return NSOrderedDescending;
     }else
     {
     NSStringCompareOptions comparisonOptions = NSDiacriticInsensitiveSearch | NSCaseInsensitiveSearch;
     NSString * name1 = [c1.city_name.lowercaseString stringByReplacingOccurrencesOfString:@"đ" withString:@"d"];
     NSString * name2 = [c2.city_name.lowercaseString stringByReplacingOccurrencesOfString:@"đ" withString:@"d"];
     return [name1 compare:name2
     options:comparisonOptions];
     }
     }];
     return cities;
     */
    
    
}


-(NSComparisonResult) compare1:(NSString *) obj1 p2:(NSString *) obj2
{
    NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch | NSNumericSearch | NSWidthInsensitiveSearch | NSForcedOrderingSearch;
    NSRange string1Range = NSMakeRange(0, obj1.length);
    return [obj1 compare:obj2 options:comparisonOptions range:string1Range locale:[NSLocale currentLocale]];
}
@end
