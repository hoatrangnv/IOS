//
//  CellProductOther.m
//  Test
//
//  Created by Chung NV on 2/15/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "CellProductOther.h"

@interface CellProductOther ()

@end

@implementation CellProductOther
- (id)initWithCoder:(NSCoder *)aDecoder 
{
	if (self = [super initWithCoder:aDecoder]) 
    {
		self.transform = CGAffineTransformRotate(CGAffineTransformIdentity,M_PI_2);
	}
	return self;
}
@end
