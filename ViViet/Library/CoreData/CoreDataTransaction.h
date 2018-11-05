//
//  CoreDataTransaction.h
//  TestCoreData
//
//  Created by QUANGHIEP on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Transactionlog.h"
@interface CoreDataTransaction : NSObject
{
    NSManagedObjectModel *managedObjectModel;
	NSManagedObjectContext *managedObjectContext;	    
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
}
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
-(void) addDataWithBussinessName:(NSString *) _bussinessName andAction:(NSString *) _action andMess:(NSString *) _mess;
-(NSMutableArray *) getAllData;
@end
