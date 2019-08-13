//
//  KieuLoaiNotification.h
//  BIDV
//
//  Created by Mac Mini on 9/17/14.
//
//

#import <Foundation/Foundation.h>

@interface KieuLoaiNotification : NSObject

@property (nonatomic, copy) NSString *sTenLoai;
@property (nonatomic, copy) NSNumber *nKieu;

- (id)initWithDictionary:(NSDictionary*)dict;
@end
