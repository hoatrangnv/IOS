//
//  TransactionList.m
//  ViMASS
//
//  Created by QUANGHIEP on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TransactionList.h"
@implementation TransactionList
@synthesize listTransactions;

- (void) dealloc
{
    if (listTransactions) {
        [listTransactions release];
        listTransactions = nil;
    }
    [super dealloc];
}
@end
