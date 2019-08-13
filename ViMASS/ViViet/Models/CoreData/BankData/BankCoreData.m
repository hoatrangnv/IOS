//
//  BankCoreData.m
//  ViMASS
//
//  Created by Chung NV on 5/27/13.
//
//

#import "BankCoreData.h"
#import "JSONKit.h"
#import "Common.h"

#define kBANK_TABLE @"Banks"

#define kBANK_ID @"bank_id"
#define kBANK_CODE @"bank_code"
#define kBANK_ORDER @"bank_order"
#define kBANK_NAME @"bank_name"
#define kBANK_NAME_EN @"bank_name_en"
#define kBANK_SMS @"bank_sms"



@implementation BankCoreData

static BankCoreData * shareBankCoreData;
@synthesize fetchedResultsController = _fetchedResultsController;
+(BankCoreData *)share
{
    if (shareBankCoreData == nil)
    {
        shareBankCoreData = [[BankCoreData alloc] initWithResourceName:kBANK_CORE_DATA_RESOURCE];
    }
    return shareBankCoreData;
}

-(NSFetchedResultsController *) fetchedResultsController
{
    if (_fetchedResultsController)
        return _fetchedResultsController;
    
    
    self.fetchedResultsController = [self fetchedResultsOfTable:kBANK_TABLE
                                                        orderBy:@[kBANK_ID]
                                                      ascending:YES];
    return _fetchedResultsController;
}

+(BOOL)addBanksFromJSON:(NSString *)banks_JSON
{
    if ([BankCoreData allBanks].count > 10)
    {
        return NO;
    }
    NSArray *arr_banks = [banks_JSON objectFromJSONString];
    if (arr_banks == nil || [arr_banks isKindOfClass:[NSArray class]] == NO)
        return NO;
    
    BankCoreData *_this = [BankCoreData share];
    
    NSManagedObjectContext * context = [_this.fetchedResultsController managedObjectContext];
    
    NSEntityDescription *entity = [[_this.fetchedResultsController fetchRequest] entity];
    
    for (id dict_bank in arr_banks)
    {
        NSManagedObject *newObject = [NSEntityDescription insertNewObjectForEntityForName:entity.name
                                                                   inManagedObjectContext:context];
        NSNumber *bank_id = [NSNumber numberWithInt:[[dict_bank objectForKey:@"ID"] intValue]];
        NSNumber *bank_code = [NSNumber numberWithInt:[[dict_bank objectForKey:@"CODE"] intValue]];
        NSString *bank_name = [dict_bank objectForKey:@"NAME_VI"];
        NSString *bank_name_en = [dict_bank objectForKey:@"NAME_EN"];
        NSString *bank_sms = [dict_bank objectForKey:@"SMS"];
        NSNumber *bank_order = [NSNumber numberWithInt:[[dict_bank objectForKey:@"ORDER"] intValue]];
        
        [newObject setValue:bank_id forKey:kBANK_ID];
        [newObject setValue:bank_code forKey:kBANK_CODE];
        [newObject setValue:bank_name.trim forKey:kBANK_NAME];
        [newObject setValue:bank_order forKey:kBANK_ORDER];
        
        [newObject setValue:bank_name_en.trim forKey:kBANK_NAME_EN];
        [newObject setValue:bank_sms.trim forKey:kBANK_SMS];
        
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

+(NSArray *)allBanks
{
    NSArray * orderBy = nil;
    if ([Common getAppLanguage] == 0)
    {
        orderBy = @[kBANK_ORDER,kBANK_NAME];
    }else
    {
        orderBy = @[kBANK_ORDER,kBANK_NAME_EN];
    }
    
    BankCoreData *_this = [BankCoreData share];
    _this.fetchedResultsController = [_this fetchedResultsOfTable:kBANK_TABLE
                                                          orderBy:orderBy
                                                        ascending:YES];
    return _this.fetchedResultsController.fetchedObjects;
}

+(NSArray *)getBankByID:(NSNumber *)ID
{
    BankCoreData *_this = [BankCoreData share];
    
    NSFetchRequest * fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription * entity = [NSEntityDescription entityForName:kBANK_TABLE inManagedObjectContext:_this.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSMutableArray *sortDescriptors = [[NSMutableArray new] autorelease];
    NSSortDescriptor *sort_order = [[[NSSortDescriptor alloc] initWithKey:kBANK_ORDER
                                                                ascending:YES] autorelease];
    
    NSString * order_name = nil;
    if ([Common getAppLanguage] == 0)
    {
        order_name = kBANK_NAME;
    }else
    {
        order_name = kBANK_NAME_EN;
    }
    NSSortDescriptor *sort_name = [[[NSSortDescriptor alloc] initWithKey:order_name
                                                               ascending:YES] autorelease];
    
    [sortDescriptors addObject:sort_order];
    [sortDescriptors addObject:sort_name];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bank_code == %@", ID];
    [fetchRequest setPredicate:predicate];
    
    NSArray *result = [_this.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    return result;
}

+(NSArray *)getBanksByIDs:(NSArray *)ids
{
    BankCoreData *_this = [BankCoreData share];
    
    NSFetchRequest * fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription * entity = [NSEntityDescription entityForName:kBANK_TABLE inManagedObjectContext:_this.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSMutableArray *sortDescriptors = [[NSMutableArray new] autorelease];
    NSSortDescriptor *sort_order = [[[NSSortDescriptor alloc] initWithKey:kBANK_ORDER
                                                                    ascending:YES] autorelease];
    
    NSString * order_name = nil;
    if ([Common getAppLanguage] == 0)
    {
        order_name = kBANK_NAME;
    }else
    {
        order_name = kBANK_NAME_EN;
    }
    NSSortDescriptor *sort_name = [[[NSSortDescriptor alloc] initWithKey:order_name
                                                               ascending:YES] autorelease];
    
    [sortDescriptors addObject:sort_order];
    [sortDescriptors addObject:sort_name];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bank_id IN %@",ids];
    [fetchRequest setPredicate:predicate];
    
    NSArray *result = [_this.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    return result;
}

+ (Banks*) getBankBySMS:(NSString *)bank_sms
{
    BankCoreData *_this = [BankCoreData share];
    
    NSFetchRequest * fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription * entity = [NSEntityDescription entityForName:kBANK_TABLE inManagedObjectContext:_this.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSMutableArray *sortDescriptors = [[NSMutableArray new] autorelease];
    NSSortDescriptor *sort_order = [[[NSSortDescriptor alloc] initWithKey:kBANK_ORDER
                                                                ascending:YES] autorelease];
    
    NSString * order_name = nil;
    if ([Common getAppLanguage] == 0)
    {
        order_name = kBANK_NAME;
    }else
    {
        order_name = kBANK_NAME_EN;
    }
    NSSortDescriptor *sort_name = [[[NSSortDescriptor alloc] initWithKey:order_name
                                                               ascending:YES] autorelease];
    
    [sortDescriptors addObject:sort_order];
    [sortDescriptors addObject:sort_name];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bank_sms == %@",bank_sms];
    [fetchRequest setPredicate:predicate];
    
    NSArray *result = [_this.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    if(result && result.count > 0)
        return [result objectAtIndex:0];
    return nil;
}

@end
