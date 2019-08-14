//
//  Cities.h
//  ViMASS
//
//  Created by Chung NV on 12/5/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Cities : NSManagedObject

@property (nonatomic, retain) NSNumber * city_code;
@property (nonatomic, retain) NSNumber * city_id;
@property (nonatomic, retain) NSString * city_lat;
@property (nonatomic, retain) NSString * city_lng;
@property (nonatomic, retain) NSString * city_name;
@property (nonatomic, retain) NSNumber * city_tag;
@property (nonatomic, retain) NSNumber * hasSubs;
@property (nonatomic, retain) NSNumber * parent_id;
@property (nonatomic, retain) NSString * city_name_en;
@property (nonatomic, retain) NSString * city_sms;

-(NSString *) getName;

@end


@interface City : NSObject
@property (nonatomic, retain) NSNumber * city_id;
@property (nonatomic, retain) NSNumber * parent_id;
@property (nonatomic, copy) NSString * city_lat;
@property (nonatomic, copy) NSString * city_lng;
@property (nonatomic, copy) NSString * city_name;

-(id)initWithDictionary:(NSDictionary *) dict;
-(NSDictionary *) dictionary;
@end