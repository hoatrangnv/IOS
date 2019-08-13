//
//  SubItemTaiChinh.h
//  ViMASS
//
//  Created by DucBT on 10/8/14.
//
//

#import <Foundation/Foundation.h>

@interface SubItemTaiChinh : NSObject

@property (nonatomic, copy) NSString *mKieuHienThi;
@property (nonatomic, copy) NSString *mTenViewController;
@property (nonatomic, copy) NSString *mTieuDe;

- (id)initWithDictionary:(NSDictionary*)dict;

@end
