//
//  Msg.h
//  ViMASS
//
//  Created by QUANGHIEP on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Msg : NSObject
@property(nonatomic, copy) NSString * msgCode;
@property(nonatomic, copy) NSString * msgContent;
@property(nonatomic, copy) NSNumber * msgType;

- (id) initWithDictionary:(NSDictionary*)dictionary;
@end
