//
//  ItemMenuTaiChinh.m
//  ViViMASS
//
//  Created by DucBT on 1/7/15.
//
//

#import "ItemMenuTaiChinh.h"

@implementation ItemMenuTaiChinh

- (id)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    if(self)
    {
        if(dict)
        {
            NSNumber *nCanDangNhap = [dict valueForKey:@"CanDangNhap"];
            if(!nCanDangNhap)
                self.mCanDangNhap = NO;
            else
                self.mCanDangNhap = [nCanDangNhap boolValue];
            
            NSString *sKieuChuyenView = [dict valueForKey:@"KieuChuyenView"];
            if(!sKieuChuyenView)
                self.mKieuChuyenView = @"";
            else
                self.mKieuChuyenView = sKieuChuyenView;
            
            NSString *sTieuDe = [dict valueForKey:@"TieuDe"];
            if(!sTieuDe)
                self.mTieuDe = @"";
            else
                self.mTieuDe = sTieuDe;
            
            NSString *sTenViewController = [dict valueForKey:@"TenViewController"];
            if(!sTenViewController)
                self.mTenViewController = @"";
            else
                self.mTenViewController = sTenViewController;
            
            NSString *sAnhDaiDien = [dict valueForKey:@"AnhDaiDien"];
            if(!sAnhDaiDien)
                self.mAnhDaiDien = @"";
            else
                self.mAnhDaiDien = sAnhDaiDien;
            
            NSString *sTenHamXuLy = [dict valueForKey:@"TenHamXuLy"];
            if(!sTenHamXuLy)
                self.mTenHamXuLy = @"";
            else
                self.mTenHamXuLy = sTenHamXuLy;
            
            NSArray *dsCon = [dict valueForKey:@"dsCon"];
            NSMutableArray *__dsCon = [[NSMutableArray alloc] init];
            if(dsCon)
                for(NSDictionary *dictCon in dsCon)
                {
                    ItemMenuTaiChinh *item = [[ItemMenuTaiChinh alloc] initWithDict:dictCon];
                    [__dsCon addObject:item];
                    [item release];
                }
            self.mDsCon = __dsCon;
            [__dsCon release];
        }
        else
        {
            self.mKieuChuyenView = @"";
            self.mTieuDe = @"";
            self.mTenViewController = @"";
            self.mAnhDaiDien = @"";
            self.mTenHamXuLy = @"";
            self.mDsCon = [NSArray new];
        }
    }
    return self;
}


- (void)dealloc
{
    [_mKieuChuyenView release];
    [_mTieuDe release];
    [_mTenViewController release];
    [_mAnhDaiDien release];
    [_mTenHamXuLy release];
    [_mDsCon release];
    [super dealloc];
}


@end
