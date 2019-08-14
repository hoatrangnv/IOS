//
//  Quyen.h
//  ViViMASS
//
//  Created by DucBui on 6/2/15.
//
//

#import <Foundation/Foundation.h>

@interface Quyen : NSObject
@property (nonatomic, retain) NSNumber *nguoiLapGiaoDich;
@property (nonatomic, retain) NSNumber *nguoiDuyetGiaoDich;
@property (nonatomic, retain) NSNumber *funcId;

- (id)initWithDict:(NSDictionary*)dict;

@end
