//
//  UniCoreData.m
//  test_logcoredata
//
//  Created by Ngo Ba Thuong on 9/4/13.
//  Copyright (c) 2013 ViMASS. All rights reserved.
//

#import "UniCoreData.h"
//#import "UniLog.h"
#import <objc/runtime.h>

NSMutableDictionary *coredatas = nil;

@implementation UniCoreData
{
    
}

+ (UniCoreData *)open_coredata:(NSString *)name;
{
    if (coredatas == nil)
    {
        coredatas = [[NSMutableDictionary alloc] initWithCapacity:10];
    }
    UniCoreData *coredata = [coredatas objectForKey:name];
    if (coredata == nil)
    {
        coredata = [[UniCoreData alloc] initWithDBName:name];
        [coredatas setObject:coredata forKey:name];
    }
    
    return coredata;
}
+ (void)close_coredata:(NSString *)name;
{
    if (coredatas)
    {
        [coredatas removeObjectForKey:name];
    }
}
- (id)initWithDBName:(NSString *)name;
{
    if (self = [super init])
    {
        autocommit = YES;
        [self load_db:name];
    }
    return self;
}

- (void)load_db:(NSString *)name
{
    //
    // Load model
    //
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:name withExtension:@"momd"];
    model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    //
    // Create a coordinator
    //
    NSURL *doc_dir = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [doc_dir URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", name]];
    coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    NSError *error = nil;
    if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
}

- (NSManagedObjectContext *)context
{
    if (context != nil)
    {
        return context;
    }
    
    context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:coordinator];
    
    return context;
}

#pragma mark - SELECT

- (NSError *)select_entity:(NSString *)entity_name result:(NSArray **)result constraints:(void (^)(NSFetchRequest *request))constraint;
{
    NSFetchRequest *request = [self create_request_for_entity:entity_name constraints:constraint];
    
    NSError *error = nil;
    *result = [context executeFetchRequest:request error:&error];
    return error;
}

- (NSError *)fetch_entity:(NSString *)entity_name sectionKeyPath:(NSString *)sectionKeyPath result:(NSFetchedResultsController **)result constraints:(void (^)(NSFetchRequest *request))constraint;
{
    NSFetchRequest *request = [self create_request_for_entity:entity_name constraints:constraint];
    
    NSFetchedResultsController *fetch_ctrl = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:sectionKeyPath cacheName:entity_name];
    
    NSError *error = nil;
    if ([fetch_ctrl performFetch:&error] == FALSE)
    {
        return error;
    }
    *result = fetch_ctrl;
    return error;
}

- (NSFetchRequest *)create_request_for_entity:(NSString *)entity_name constraints:(void (^)(NSFetchRequest *request))constraint
{
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entity_name inManagedObjectContext:self.context];
    [request setEntity:entity];
    
    if (constraint != nil)
    {
        constraint (request);
    }
    
    if (request.sortDescriptors)
        return request;
    
    return nil;
}

#pragma mark - INSERT

- (NSError *)commit;
{
    NSError *error = nil;
    [self.context save:&error];
    return error;
}

#pragma mark - INSERT

- (NSError *)insert_entity:(NSString *)entity_name,...;
{
    va_list va;
    va_start(va, entity_name);
    
    NSObject *first_param = va_arg(va, NSObject *);
    NSObject *second_param = va_arg(va, NSObject *);
    
    if (first_param == nil && second_param == nil)
    {
        return nil;
    }
    if (first_param != nil && second_param == nil)
    {
        return [self insert_to:entity_name obj:first_param];
    }
    va_start(va, entity_name);
    
    return [self insert_to:entity_name va:va];
}

- (NSError *)insert_to:(NSString *)entity_name va:(va_list)va
{
    id entity;
    @try
    {
        entity = [NSEntityDescription insertNewObjectForEntityForName:entity_name inManagedObjectContext:self.context];
    }
    @catch (NSException *exception)
    {
        return [[NSError alloc] initWithDomain:@"app" code:1 userInfo:[NSDictionary dictionaryWithObject:exception forKey:@"exception"]];
    }
    
    while (true)
    {
        NSString *key = va_arg(va, NSString *);
        if (key == nil)
            break;
        
        NSObject *obj = va_arg(va, NSObject *);
        if (obj == nil)
            break;
        
        [entity setValue:obj forKey:key];
    }
    
    if (autocommit == YES)
    {
        [self commit];
    }
    
    return nil;
}

- (NSError *)insert_to:(NSString *)entity_name obj:(NSObject *)obj;
{
    id entity;
    @try
    {
        entity = [NSEntityDescription insertNewObjectForEntityForName:entity_name inManagedObjectContext:self.context];
    }
    @catch (NSException *exception)
    {
        return [[NSError alloc] initWithDomain:@"app" code:1 userInfo:[NSDictionary dictionaryWithObject:exception forKey:@"exception"]];
    }
    
    unsigned int cnt, i;
    objc_property_t *properties = class_copyPropertyList([entity class], &cnt);
    
    for (i = 0; i < cnt; i++)
    {
        objc_property_t property = properties[i];
        const char *prop_name = property_getName(property);
        
        if(prop_name)
        {
            NSString *k = [NSString stringWithUTF8String:prop_name];
            [entity setValue:[obj valueForKey:k] forKey:k];
        }
    }
    free(properties);
    
    if (autocommit == YES)
    {
        return [self commit];
    }
    
    return nil;
}

#pragma mark - DELETE

- (NSError *)del:(NSManagedObject *)obj;
{
    [self.context deleteObject:obj];
    if (autocommit == YES)
    {
        return [self commit];
    }
    
    return nil;
}


@synthesize coordinator = coordinator;
@synthesize context = context;
@synthesize model = model;
@synthesize autocommit = autocommit;

@end
