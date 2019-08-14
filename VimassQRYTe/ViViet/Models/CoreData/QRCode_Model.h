//
//  QRCode_Model.h
//  ViMASS
//
//  Created by Chung NV on 4/17/13.
//
//

#import "BaseCoreData.h"

@interface QRCode_Model : BaseCoreData

+(QRCode_Model*) shareQRCodeModel;

// insert
-(BOOL) insertObjectWithObjClass:(NSString *) objClass
                  JSONDictionary:(NSString *) JSONDict
                       completed:(CDInsertFinish) finished;

// get object at indexpath
-(NSManagedObject *) objectAtIndexPath:(NSIndexPath *) indexPath;
@end
