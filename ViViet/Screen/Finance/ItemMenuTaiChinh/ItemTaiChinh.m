//
//  ItemTaiChinh.m
//  ViMASS
//
//  Created by DucBT on 10/8/14.
//
//

#import "ItemTaiChinh.h"
#import "SubItemTaiChinh.h"

@implementation ItemTaiChinh

- (id)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if(self)
    {
        NSString *mKieuHienThi = [dict valueForKey:@"kieuhienthi"];
        if(mKieuHienThi)
            self.mKieuHienThi = mKieuHienThi;
        
        NSString *mTenViewController = [dict valueForKey:@"viewcontroller"];
        if(mTenViewController)
            self.mTenViewController = mTenViewController;
        
        
        NSString *mTieuDe = [dict valueForKey:@"MainMenu"];
        if(mTieuDe)
            self.mTieuDe = mTieuDe;
        
        NSString *mAnhDaiDien = [dict valueForKey:@"AnhDaiDien"];
        if(mAnhDaiDien)
            self.mAnhDaiDien = mAnhDaiDien;
        
        NSArray *arr = [dict valueForKey:@"SubMenu"];
        if(arr && arr.count > 0)
        {
            NSMutableArray *arrTemp = [[NSMutableArray alloc] init];
            for(NSDictionary *dict in arr)
            {
                SubItemTaiChinh *subItem = [[SubItemTaiChinh alloc] initWithDictionary:dict];
                [arrTemp addObject:subItem];
                [subItem release];
            }
            self.mDanhSachSubItem = arrTemp;
            [arrTemp release];
        }
        
    }
    return self;
}


- (void)dealloc
{
    [_mKieuHienThi release];
    [_mTenViewController release];
    [_mTieuDe release];
    [_mAnhDaiDien release];
    [_mDanhSachSubItem release];
    [super dealloc];
}
@end
