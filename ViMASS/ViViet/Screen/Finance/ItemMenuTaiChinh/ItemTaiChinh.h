//
//  ItemTaiChinh.h
//  ViMASS
//
//  Created by DucBT on 10/8/14.
//
//

#import <Foundation/Foundation.h>

@interface ItemTaiChinh : NSObject
@property (nonatomic, copy) NSString *mKieuHienThi;
@property (nonatomic, copy) NSString *mTenViewController;
@property (nonatomic, copy) NSString *mTieuDe;
@property (nonatomic, copy) NSString *mAnhDaiDien;
@property (nonatomic, retain) NSArray *mDanhSachSubItem;

- (id)initWithDictionary:(NSDictionary*)dict;

@end
