//
//  ViMASSPlace.h
//  ViMASS
//
//  Created by GOD on 11/12/12.
//
//

#import <Foundation/Foundation.h>

typedef enum
{
    VIVIET_PLACE_BANK,
    VIVIET_PLACE_RESTAURANT,
    VIVIET_PLACE_MARKET
} ViVietPlaceType;

@interface ViVietPlace : NSObject
{
    ViVietPlaceType _type;
    NSString *_name;
    NSString *_address;
    NSString *_district;
    NSString *_province;
    double  _lat, _log;
    double _distance;
}

@property (nonatomic, assign) ViVietPlaceType type;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *district;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, assign) double  lat, log;
@property (nonatomic, assign) double  distance;

-(id)initWithDictionary:(NSDictionary *)dic;

@end
