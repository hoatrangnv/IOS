//
//  QRCodeInfo.h
//  ViMASS
//
//  Created by QUANGHIEP on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QRCodeInfo : NSObject

@property(nonatomic, copy) NSNumber *amount;
@property(nonatomic, copy) NSString *receiver;
@property(nonatomic, copy) NSString *comment;

- (id) initWithDictionary:(NSDictionary*)dictionary;
- (id) initWithQRCodeString:(NSString *)str;

@end
