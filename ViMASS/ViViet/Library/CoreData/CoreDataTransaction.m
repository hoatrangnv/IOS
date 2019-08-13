//
//  CoreDataTransaction.m
//  TestCoreData
//
//  Created by QUANGHIEP on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CoreDataTransaction.h"
#import <CoreData/CoreData.h>
#import "Common.h"
#import "LogObject.h"
@implementation CoreDataTransaction
@synthesize persistentStoreCoordinator;
@synthesize managedObjectContext;
@synthesize managedObjectModel;
- (id)init
{
    if (self = [super init]) {
        [self managedObjectContext];
    }
    return self;
}
-(void) dealloc
{
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        } 
    }
    [super dealloc];
}

- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"transactionlog.sqlite"]];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
	
    return persistentStoreCoordinator;
}
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

-(void) addDataWithBussinessName:(NSString *) _bussinessName andAction:(NSString *) _action andMess:(NSString *) _mess
{
     Transactionlog * event = (Transactionlog *) [NSEntityDescription insertNewObjectForEntityForName:@"Transactionlog" inManagedObjectContext:managedObjectContext];
    [Common maHoaStringToData:_bussinessName];
    [event setVv_mess:[Common maHoaStringToData:_mess]];
    [event setVv_action:[Common maHoaStringToData:_action]];
    [event setVv_bussiness_name:[Common maHoaStringToData:_bussinessName]];
    NSError * error;
    if (![managedObjectContext save:&error]) {
        NSLog(@":(");
    }
}
- (NSMutableArray *) getAllData
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transactionlog" inManagedObjectContext:managedObjectContext];
    
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    // Define how we will sort the records
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"vv_mess" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    [request setSortDescriptors:sortDescriptors];
    [sortDescriptor release];
    
    // Fetch the records and handle an error
    NSError *error;
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (!mutableFetchResults) {
        // Handle the error.
        // This is a serious error and should advise the user to restart the application
    }
    
    // Save our fetched data to an array
    NSMutableArray * dataToReturn = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < [mutableFetchResults count]; i++) {
        Transactionlog * tranLog = (Transactionlog *) [mutableFetchResults objectAtIndex:i];
        LogObject * logObject = [[LogObject alloc] initWithTransationLog:tranLog];
        [dataToReturn addObject:logObject];
        [logObject release];
    }
    [request release];
    [mutableFetchResults release];
    return dataToReturn;
}

@end
