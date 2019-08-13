//
//  CachQuayVongKyLai.h
//  ViViMASS
//
//  Created by DucBui on 5/13/15.
//
//

#import <Foundation/Foundation.h>

@interface CachQuayVongKyLai : NSObject

@property (nonatomic, copy) NSString *noiDungQuayVong;
@property (nonatomic, copy) NSNumber *maQuayVong;

- (id)initWithDictionary:(NSDictionary*)dict;

@end
