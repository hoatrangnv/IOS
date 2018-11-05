//
//  BranchInfo.h
//  ViMASS
//
//  Created by Ngo Ba Thuong on 12/5/12.
//
//

#import <Foundation/Foundation.h>

@interface BranchInfo : NSObject

@property (nonatomic, copy) NSString *branchName;
@property (nonatomic, copy) NSString *branchCode;

+(BranchInfo *)branchInfoFromDictionary:(NSDictionary *)dict;

@end
