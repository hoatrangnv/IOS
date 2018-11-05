//
//  Transaction.h
//  ViMASS
//
//  Created by QUANGHIEP on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Transaction : NSObject
{

}
@property(nonatomic, copy) NSString  * amount;
@property(nonatomic, copy) NSString  * accountNo;
@property(nonatomic, retain) NSDate  * transactionDate;
@property(nonatomic, copy) NSString  * desc;

@property (nonatomic, readonly) BOOL incoming;
@property (nonatomic, readonly) BOOL isRevert;
- (id) initWithDictionary:(NSDictionary*)dictionary;

@end
