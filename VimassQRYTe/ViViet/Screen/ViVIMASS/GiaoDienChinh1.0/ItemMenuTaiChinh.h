//
//  ItemMenuTaiChinh.h
//  ViViMASS
//
//  Created by DucBT on 1/7/15.
//
//

#import <Foundation/Foundation.h>

@interface ItemMenuTaiChinh : NSObject

@property (nonatomic, assign) BOOL mCanDangNhap;
@property (nonatomic, copy) NSString *mKieuChuyenView;
@property (nonatomic, copy) NSString *mTieuDe;
@property (nonatomic, copy) NSString *mTenViewController;
@property (nonatomic, copy) NSString *mAnhDaiDien;
@property (nonatomic, copy) NSString *mTenHamXuLy;
@property (nonatomic, retain) NSArray *mDsCon;

- (id)initWithDict:(NSDictionary*)dict;

@end
