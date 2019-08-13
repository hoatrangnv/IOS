//
//  QRCode_Model.m
//  ViMASS
//
//  Created by Chung NV on 4/17/13.
//
//

#import "QRCode_Model.h"

@implementation QRCode_Model

@synthesize fetchedResultsController = _fetchedResultsController;

static QRCode_Model * shareQRCodeModel_;
+(QRCode_Model*) shareQRCodeModel
{
    if (shareQRCodeModel_ == nil)
        shareQRCodeModel_ = [[QRCode_Model alloc] initWithResourceName:@"QRCodeData"];
    
    return shareQRCodeModel_;
}

-(NSFetchedResultsController *) fetchedResultsController
{
    if (_fetchedResultsController)
        return _fetchedResultsController;
    
    
    self.fetchedResultsController = [self fetchedResultsOfTable:@"QRCodeObj"
                                                        orderBy:@[@"obj_class"]
                                                      ascending:NO];
    return _fetchedResultsController;
}

-(NSManagedObject *) objectAtIndexPath:(NSIndexPath *) indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return object;
}

-(BOOL) insertObjectWithObjClass:(NSString *) objClass
                  JSONDictionary:(NSString *) JSONDict
                       completed:(CDInsertFinish)completed
{
    if (completed)
    {
        self.fetchedResultsController.delegate = self;
        [_insertFinished release];
        _insertFinished = [completed copy];
    }
    
    NSManagedObjectContext * context = [self.fetchedResultsController managedObjectContext];
    
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    
    NSManagedObject *newObject = [NSEntityDescription insertNewObjectForEntityForName:entity.name
                                                               inManagedObjectContext:context];
    
    [newObject setValue:objClass forKey:@"obj_class"];
    [newObject setValue:JSONDict forKey:@"dictionary"];
    
    NSError *error = nil;
    if ([context save:&error] == FALSE)
    {
        NSLog(@"Insert FALSE:%@ , %@",error , error.userInfo);
        abort();
        return FALSE;
    }
    return TRUE;
}

-(BOOL)deleteObjectAtIndexPath:(NSIndexPath *)indexPath
                     completed:(CDDeleteFinish)completed
{
    if (completed)
    {
        self.fetchedResultsController.delegate = self;
        [_deleteFinish release];
        _deleteFinish = [completed copy];
    }
    
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    
    NSError *error = nil;
    if (![context save:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
        return FALSE;
    }
    return TRUE;
}

#pragma mark -
- (void) controller:(NSFetchedResultsController *)controller
    didChangeObject:(id)anObject
        atIndexPath:(NSIndexPath *)indexPath
      forChangeType:(NSFetchedResultsChangeType)type
       newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            if (_insertFinished)
                _insertFinished(controller,anObject);
            
            break;
            
        case NSFetchedResultsChangeDelete:
            if (_deleteFinish)
                _deleteFinish(controller,anObject);
            break;
            
        default:
            break;
    }
}

-(void)dealloc
{
    [super dealloc];
}

@end
