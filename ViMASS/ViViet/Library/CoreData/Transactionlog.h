//
//  Transactionlog.h
//  TestCoreData
//
//  Created by QUANGHIEP on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Transactionlog : NSManagedObject

@property (nonatomic, retain) NSData * vv_bussiness_name;
@property (nonatomic, retain) NSData * vv_action;
@property (nonatomic, copy) NSData * vv_mess;

@end
