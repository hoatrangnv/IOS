//
//  CoreData.h
//  ViMASS
//
//  Created by Chung NV on 4/17/13.
//
//
#define kBANK_CORE_DATA_RESOURCE @"BankCoreData"

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef void(^CDInsertFinish) (NSFetchedResultsController *fetchedResult,NSManagedObject *insertedObj);
typedef void(^CDDeleteFinish) (NSFetchedResultsController *fetchedResult,NSManagedObject *deletedObj);

@interface BaseCoreData : NSObject<NSFetchedResultsControllerDelegate>
{
    CDInsertFinish _insertFinished;
    CDDeleteFinish _deleteFinish;
}
-(id) initWithResourceName:(NSString *) databaseName;

//-(BOOL) deleteObjectAtIndexPath:(NSIndexPath *) indexPath
//                      completed:(CDDeleteFinish ) completed;

-(NSFetchedResultsController *) fetchedResultsOfTable:(NSString *) tableName
                                              orderBy:(NSArray *) orderByFields
                                            ascending:(BOOL) ascending;

- (NSError*)saveContext;


- (NSArray*)getObject:(NSString*)sObjectName
        withPredicate:(NSPredicate*)predicate
    andSortDescriptor:(NSSortDescriptor*)sortDescriptor;

- (NSError*)getObject:(NSString*)sObjectName
        withPredicate:(NSPredicate*)predicate
    andSortDescriptor:(NSSortDescriptor*)sortDescriptor
               result:(NSArray**)results;

@property (nonatomic , copy) NSString * coreDataFileName;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end
