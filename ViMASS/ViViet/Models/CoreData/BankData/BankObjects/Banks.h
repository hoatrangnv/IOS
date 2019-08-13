//
//  Banks.h
//  ViMASS
//
//  Created by Chung NV on 12/5/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Banks : NSManagedObject

@property (nonatomic, retain) NSString * bank_code;
@property (nonatomic, retain) NSNumber * bank_id;
@property (nonatomic, retain) NSString * bank_name;
@property (nonatomic, retain) NSNumber * bank_order;
@property (nonatomic, retain) NSString * bank_name_en;
@property (nonatomic, retain) NSString * bank_sms;

-(NSString *)getName;

@end
