//
//  Branches.h
//  ViMASS
//
//  Created by Chung NV on 12/5/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Branches : NSManagedObject

@property (nonatomic, retain) NSNumber * bank_id;
@property (nonatomic, retain) NSString * branch_code;
@property (nonatomic, retain) NSNumber * branch_id;
@property (nonatomic, retain) NSString * branch_name;
@property (nonatomic, retain) NSNumber * city_id;
@property (nonatomic, retain) NSString * branch_name_en;
@property (nonatomic, retain) NSString * branch_sms;

-(NSString *)getName;

@end
