//
//  QuyenCuaTaiKhoan.h
//  ViViMASS
//
//  Created by DucBui on 6/2/15.
//
//

#import "Quyen.h"

@interface QuyenCuaTaiKhoan : NSObject
@property (nonatomic, retain) NSNumber *administrator;
@property (nonatomic, retain) NSArray *list;

- (id)initWithDict:(NSDictionary*)dict;

@end
