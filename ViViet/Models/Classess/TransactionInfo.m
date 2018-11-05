//
//  TransactionInfo.m
//  ViMASS
//
//  Created by QUANGHIEP on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TransactionInfo.h"

@implementation TransactionInfo
@synthesize msg, model;
- (void) dealloc
{
    if (msg) {
        [msg release];
        msg = nil;
    }
    if (model) {
        [model release];
        model = nil;
    }
    [super dealloc];
}
@end
