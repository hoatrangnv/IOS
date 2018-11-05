//
//  LogObject.h
//  ViMASS
//
//  Created by QUANGHIEP on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Transactionlog.h"
@interface LogObject : NSObject
{
    
}
@property(nonatomic, copy) NSString * sMess;
@property(nonatomic, copy) NSString * sBussinessName;
@property(nonatomic, copy) NSString * sAction;

- (id) initWithTransationLog:(Transactionlog *)log;
@end
