//
//  UniCoreData.h
//  test_logcoredata
//
//  Created by Ngo Ba Thuong on 9/4/13.
//  Copyright (c) 2013 ViMASS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface UniCoreData : NSObject
{
    NSManagedObjectContext *        context;
    NSManagedObjectModel *          model;
    NSPersistentStoreCoordinator *  coordinator;
    BOOL                            autocommit;
}

@property (nonatomic, retain) NSManagedObjectContext*       context;
@property (nonatomic, retain) NSManagedObjectModel*         model;
@property (nonatomic, retain) NSPersistentStoreCoordinator* coordinator;
@property (nonatomic, assign) BOOL                          autocommit;

#pragma mark - Initialization

- (id)initWithDBName:(NSString *)name;
+ (UniCoreData *)open_coredata:(NSString *)name;
+ (void)close_coredata:(NSString *)name;

#pragma mark - SELECT

- (NSError *)select_entity:(NSString *)entity_name result:(NSArray **)result constraints:(void (^)(NSFetchRequest *request))constraint;
- (NSError *)fetch_entity:(NSString *)entity_name sectionKeyPath:(NSString *)sectionKeyPath result:(NSFetchedResultsController **)result constraints:(void (^)(NSFetchRequest *request))constraint;

#pragma mark - INSERT

//
// Them 1 object vao entity. Co 2 cach dung nhu sau:
// e.g: [insert_to:@"entity", new_obj, nil]
// e.g: [insert_to:@"entity", @"property_1", value_1, @"property_2", value_2, nil];
//
- (NSError *)insert_entity:(NSString *)entity_name,...;
- (NSError *)commit;


#pragma mark - DELETE

- (NSError *)del:(NSManagedObject *)obj;


@end
