//
//  CoreData.m
//  ViMASS
//
//  Created by Chung NV on 4/17/13.
//
//

#import "BaseCoreData.h"

@implementation BaseCoreData

@synthesize managedObjectContext        = _managedObjectContext;
@synthesize managedObjectModel          = _managedObjectModel;
@synthesize persistentStoreCoordinator  = _persistentStoreCoordinator;
@synthesize fetchedResultsController    = _fetchedResultsController;
@synthesize coreDataFileName            = _coreDataFileName;

-(id) initWithResourceName:(NSString *) databaseName
{
    if (self = [super init])
    {
        self.coreDataFileName = databaseName;
    }
    return self;
}

- (NSArray*)getObject:(NSString*)sObjectName withPredicate:(NSPredicate*)predicate andSortDescriptor:(NSSortDescriptor*)sortDescriptor
{
    if(![self checkObjectExist:sObjectName withPredicate:predicate andSortDescriptor:sortDescriptor])
    {
        return nil;
    }
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:sObjectName
                                                         inManagedObjectContext:moc];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    
    if(predicate)
        [request setPredicate:predicate];
    if(sortDescriptor)
        [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;

    NSArray *array = [moc executeFetchRequest:request error:&error];
    if (array == nil)
    {
        return nil;
    }
    return  array;
}

- (NSError*)getObject:(NSString*)sObjectName withPredicate:(NSPredicate*)predicate andSortDescriptor:(NSSortDescriptor*)sortDescriptor result:(NSArray**)results
{

    if(![self checkObjectExist:sObjectName withPredicate:predicate andSortDescriptor:sortDescriptor])
    {
        return nil;
    }
    NSError *err = nil;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:sObjectName
                                                         inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    if(predicate)
        [request setPredicate:predicate];
    if(sortDescriptor)
        [request setSortDescriptors:@[sortDescriptor]];
    
    //Tra ve ket qua
    *results = [self.managedObjectContext executeFetchRequest:request error:&err];
    return err;
}

- (BOOL)checkObjectExist:(NSString*)sObjectName withPredicate:(NSPredicate*)predicate andSortDescriptor:(NSSortDescriptor*)sortDescriptor
{
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc]init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:sObjectName
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    if(predicate)
        [fetchRequest setPredicate:predicate];
    if(sortDescriptor)
        [fetchRequest setSortDescriptors:@[sortDescriptor]];
    NSError *error = nil;
    NSUInteger count = [self.managedObjectContext countForFetchRequest:fetchRequest error:&error];
    if(count != NSNotFound)
        return YES;
    return NO;
}

- (NSFetchedResultsController *)fetchedResultsOfTable:(NSString *)tableName
                                              orderBy:(NSArray *)orderByFields
                                            ascending:(BOOL)ascending
{
    NSFetchRequest * fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription * entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // ORDER BY
    NSMutableArray *sortDescriptors = nil;
    for (int i=0; i < orderByFields.count; i++)
    {
        if (sortDescriptors == nil)
            sortDescriptors = [[NSMutableArray new] autorelease];
    
        NSString *property = [orderByFields objectAtIndex:i];
        NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:property ascending:ascending] autorelease];
        [sortDescriptors addObject:sortDescriptor];
    }
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:tableName];
    aFetchedResultController.delegate = self;
    
    NSError *error = nil;
    if ([aFetchedResultController performFetch:&error] == FALSE)
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
    }
    
    return aFetchedResultController;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil)
        return _managedObjectContext;
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:_coreDataFileName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    NSString *sqlite = [NSString stringWithFormat:@"%@.sqlite",_coreDataFileName];
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:sqlite];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],
                             NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES],
                             NSInferMappingModelAutomaticallyOption, nil];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
    }
    return _persistentStoreCoordinator;
}
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSError*)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
            return  error;
        }
    }
    return nil;
}

-(void)dealloc
{
//    self.coreDataFileName = nil;
//    self.fetchedResultsController = nil;
//    self.managedObjectContext = nil;
    if(_coreDataFileName)
        [_coreDataFileName release];
    if(_fetchedResultsController)
        [_fetchedResultsController release];
    [_managedObjectContext release];
    [_managedObjectModel release];
    [_persistentStoreCoordinator release];
    [super dealloc];
}

/**
 @property (nonatomic , copy) NSString * coreDataFileName;
 @property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
 @property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
 @property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
 @property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
 */

@end
