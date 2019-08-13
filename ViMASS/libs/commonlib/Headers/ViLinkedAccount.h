//
//  ViLinkedAccount.h
//  commonlib
//
//  Created by Ngo Ba Thuong on 3/6/14.
//  Copyright (c) 2014 ViMASS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViLinkedAccount : NSObject

@property (nonatomic, assign) NSNumber *order;
@property (nonatomic, copy) NSString *ownerName;
@property (nonatomic, copy) NSString *bankCode;
@property (nonatomic, copy) NSString *branchCode;
@property (nonatomic, copy) NSString *accountNumber;
@property (nonatomic, copy) NSString *accountName;

@end
