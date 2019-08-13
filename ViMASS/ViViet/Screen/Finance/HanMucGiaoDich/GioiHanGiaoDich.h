//
//  GioiHanGiaoDich.h
//  ViViMASS
//
//  Created by DucBT on 2/11/15.
//
//

#import <Foundation/Foundation.h>

@interface GioiHanGiaoDich : NSObject

@property (nonatomic, retain) NSNumber *typeTransfer;
@property (nonatomic, retain) NSNumber *oneTime;
@property (nonatomic, retain) NSNumber *oneDay;
@property (nonatomic, retain) NSNumber *oneMonth;

- (id) initWithDictionary:(NSDictionary*)dict;

- (NSDictionary*)toDict;

@end
