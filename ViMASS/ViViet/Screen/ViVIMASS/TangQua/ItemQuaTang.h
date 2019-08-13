//
//  ItemQuaTang.h
//  ViViMASS
//
//  Created by DucBT on 2/27/15.
//
//

#import <Foundation/Foundation.h>
#import "ThuocTinhQuaTang.h"

@interface ItemQuaTang : NSObject <NSCopying> 

@property (nonatomic, copy) NSNumber *mId;
@property (nonatomic, copy) NSNumber *mType;
@property (nonatomic, copy) NSString *mImage;
@property (nonatomic, retain) ThuocTinhQuaTang *mName;
@property (nonatomic, retain) ThuocTinhQuaTang *mMessage;
@property (nonatomic, retain) ThuocTinhQuaTang *mAmount;
@property (nonatomic, copy) NSNumber *mStatus;
@property (nonatomic, copy) NSNumber *mPos;


- (id)initWithDictionary:(NSDictionary*)dict;

@end
