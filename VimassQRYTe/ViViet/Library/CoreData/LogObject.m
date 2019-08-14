//
//  LogObject.m
//  ViMASS
//
//  Created by QUANGHIEP on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LogObject.h"

#import "Common.h"
@implementation LogObject
@synthesize sMess, sAction, sBussinessName;
-(void) dealloc
{
    if (sMess) {
        [sMess release];
    }
    if (sAction) {
        [sAction release];
    }
    if (sBussinessName) {
        [sBussinessName release];
    }
    [super dealloc];
}
- (id) initWithTransationLog:(Transactionlog *)log
{
    if(self = [super init])
    {
        [self setSMess:[Common giaiMaDataToString:[log vv_mess]]];
        [self setSBussinessName:[Common giaiMaDataToString:[log vv_bussiness_name]]];
        [self setSAction:[Common giaiMaDataToString:[log vv_action]]];
        
    }
    return self;
}
@end
