//
//  TransactionInfo.h
//  ViMASS
//
//  Created by QUANGHIEP on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransactionList.h"

@interface TransactionInfo : NSObject
@property(nonatomic, retain) Msg *msg;
@property(nonatomic, retain) TransactionList *model;
@end
