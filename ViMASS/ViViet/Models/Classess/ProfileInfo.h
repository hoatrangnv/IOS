//
//  ProfileInfo.h
//  ViMASS
//
//  Created by Chung NV on 4/15/13.
//
//

#import <Foundation/Foundation.h>

@interface ProfileInfo : NSObject

@property (nonatomic ,copy)     NSString *      name;
@property (nonatomic ,copy)     NSString *      address;

@property (nonatomic ,copy)     NSString *      typeValue;
@property (nonatomic ,copy)     NSString *      typeDate;
@property (nonatomic ,copy)     NSString *      typePlace;
@property (nonatomic ,copy)     NSString *      country;
@property (nonatomic ,copy)     NSString *      DOB;
@property (nonatomic ,copy)     NSString *      email;
@property (nonatomic ,copy)     NSString *      accountClass;
@property (nonatomic ,copy)     NSString *      state;

@property (nonatomic ,assign)   int             gender;

@property (nonatomic ,assign)   int             type;



-(id) initWithDictionary:(NSDictionary *) dic;


@end
