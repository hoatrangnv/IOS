//
//  BranchCoreData.m
//  ViMASS
//
//  Created by Chung NV on 5/27/13.
//
//

#import "BranchCoreData.h"
#import "JSONKit.h"
#import "Common.h"
#define kBRANCH_TABLE @"Branches"

#define kBRANCH_ID @"branch_id"
#define kBRANCH_NAME @"branch_name"
#define kBRANCH_NAME_EN @"branch_name_en"
#define kBRANCH_CODE @"branch_code"
#define kBRANCH_BANK_ID @"bank_id"
#define kBRANCH_PROVINCE_ID @"city_id"
#define kBRANCH_SMS @"branch_sms"
@implementation BranchCoreData

static BranchCoreData * shareBranchCoreData;
@synthesize fetchedResultsController = _fetchedResultsController;
+(BranchCoreData *)share
{
    if (shareBranchCoreData == nil)
    {
        shareBranchCoreData = [[BranchCoreData alloc] initWithResourceName:kBANK_CORE_DATA_RESOURCE];
    }
    return shareBranchCoreData;
}

-(NSFetchedResultsController *) fetchedResultsController
{
    if (_fetchedResultsController)
        return _fetchedResultsController;
    
    
    self.fetchedResultsController = [self fetchedResultsOfTable:kBRANCH_TABLE
                                                        orderBy:@[kBRANCH_NAME]
                                                      ascending:YES];
    return _fetchedResultsController;
}

+(BOOL)addBranchesFromJSON:(NSString *)branches_JSON
{
    if ([BranchCoreData allBranches].count > 10)
    {
        return NO;
    }
    
    NSArray *arr_branches = [branches_JSON objectFromJSONString];
    if (arr_branches == nil || [arr_branches isKindOfClass:[NSArray class]] == NO)
        return NO;
    
    BranchCoreData *_this = [BranchCoreData share];
    
    NSManagedObjectContext * context = [_this.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[_this.fetchedResultsController fetchRequest] entity];
    
    for (id dict_branch in arr_branches)
    {
        NSManagedObject *newObject = [NSEntityDescription insertNewObjectForEntityForName:entity.name
                                                                   inManagedObjectContext:context];
        NSNumber *branch_id = [NSNumber numberWithInt:[[dict_branch objectForKey:@"ID"] intValue]];
        NSString *branch_name = [dict_branch objectForKey:@"NAME_VI"];
        NSString *branch_name_en = [dict_branch objectForKey:@"NAME_EN"];
        NSString *branch_sms = [dict_branch objectForKey:@"SMS"];
        NSString *branch_code = [dict_branch objectForKey:@"CODE"];
        
        NSNumber *bank_id = [NSNumber numberWithInt:[[dict_branch objectForKey:@"PARENT_ID"] intValue]];
        NSNumber *city_id = [NSNumber numberWithInt:[[dict_branch objectForKey:@"PROVINCE_ID"] intValue]];
        
        [newObject setValue:branch_id       forKey:kBRANCH_ID];
        [newObject setValue:branch_code     forKey:kBRANCH_CODE];
        [newObject setValue:branch_name     forKey:kBRANCH_NAME];
        [newObject setValue:branch_name_en  forKey:kBRANCH_NAME_EN];
        [newObject setValue:branch_sms      forKey:kBRANCH_SMS];
        [newObject setValue:bank_id         forKey:kBRANCH_BANK_ID];
        [newObject setValue:city_id         forKey:kBRANCH_PROVINCE_ID];
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
+(NSArray *)allBranches
{
    NSArray * orderBy = nil;
    if ([Common getAppLanguage] == 0)
    {
        orderBy = @[kBRANCH_NAME];
    }else
    {
        orderBy = @[kBRANCH_NAME_EN];
    }
    
    BranchCoreData *_this = [BranchCoreData share];
    _this.fetchedResultsController = [_this fetchedResultsOfTable:kBRANCH_TABLE
                                                          orderBy:orderBy
                                                        ascending:YES];
    
    return _this.fetchedResultsController.fetchedObjects;
}

+(NSArray *)getBranchByCode:(NSString *)branchCode
{
    BranchCoreData *_this = [BranchCoreData share];
    
    NSFetchRequest * fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription * entity = [NSEntityDescription entityForName:kBRANCH_TABLE
                                               inManagedObjectContext:_this.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setResultType:NSManagedObjectResultType];
    
    NSMutableArray *sortDescriptors = [[NSMutableArray new] autorelease];
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:kBRANCH_BANK_ID ascending:YES] autorelease];
    [sortDescriptors addObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"branch_code == %@", branchCode];
    
    [fetchRequest setPredicate:predicate];
    
//    [fetchRequest setPropertiesToFetch:@[kBRANCH_BANK_ID]];
//    [fetchRequest setReturnsDistinctResults:YES];
    
    return [_this.managedObjectContext executeFetchRequest:fetchRequest error:nil];
}

+(NSArray *)getBankIDsByProvince:(int)city_id
{
    BranchCoreData *_this = [BranchCoreData share];
    
    NSFetchRequest * fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription * entity = [NSEntityDescription entityForName:kBRANCH_TABLE
                                               inManagedObjectContext:_this.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setResultType:NSDictionaryResultType];
    
    NSMutableArray *sortDescriptors = [[NSMutableArray new] autorelease];
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:kBRANCH_BANK_ID ascending:YES] autorelease];
    [sortDescriptors addObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"city_id IN %@", @[[NSString stringWithFormat:@"%d",city_id]]];
    
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setPropertiesToFetch:@[kBRANCH_BANK_ID]];
    [fetchRequest setReturnsDistinctResults:YES];
    
    return [_this.managedObjectContext executeFetchRequest:fetchRequest error:nil];
}

+(NSArray *)getBranchesByProvince:(int)city_id
                          andBank:(int)bank_id
{
    BranchCoreData *_this = [BranchCoreData share];
    NSFetchRequest * fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription * entity = [NSEntityDescription entityForName:kBRANCH_TABLE inManagedObjectContext:_this.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setResultType:NSManagedObjectResultType];
    
    NSMutableArray *sortDescriptors = [[NSMutableArray new] autorelease];
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:kBRANCH_BANK_ID ascending:YES] autorelease];
    [sortDescriptors addObject:sortDescriptor];
    
    NSString * order_name = nil;
    if ([Common getAppLanguage] == 0)
    {
        order_name = kBRANCH_NAME;
    }else
    {
        order_name = kBRANCH_NAME_EN;
    }
    NSSortDescriptor *sort_NAME = [[[NSSortDescriptor alloc] initWithKey:order_name
                                                               ascending:YES] autorelease];
    [sortDescriptors addObject:sort_NAME];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"city_id = %d and bank_id = %d", city_id,bank_id];
    [fetchRequest setPredicate:predicate];
    
    NSArray *result = [_this.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    return result;
}

+ (NSArray *)getAllBanks
{
    return nil;
}
@end
