//
//  BranchInfo.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 12/5/12.
//
//

#import "BranchInfo.h"

@implementation BranchInfo

+(BranchInfo *)branchInfoFromDictionary:(NSDictionary *)dict
{
    BranchInfo *branch = nil;
    
    if ([dict isKindOfClass:[NSDictionary class]])
    {
        branch = [[BranchInfo new] autorelease];
        branch.branchCode = [dict objectForKey:@"branchCode"];
        branch.branchName = [dict objectForKey:@"name"];
    }
    
    return branch;
}


-(void) dealloc
{
    self.branchCode = nil;
    self.branchName = nil;
    
    [super dealloc];
}


@synthesize branchName;
@synthesize branchCode;
@end
