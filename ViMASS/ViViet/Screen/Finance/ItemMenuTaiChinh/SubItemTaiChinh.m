//
//  SubItemTaiChinh.m
//  ViMASS
//
//  Created by DucBT on 10/8/14.
//
//

#import "SubItemTaiChinh.h"

@implementation SubItemTaiChinh

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
        
        
        NSString *mTieuDe = [dict valueForKey:@"title"];
        if(mTieuDe)
            self.mTieuDe = mTieuDe;
    }
    return self;
}

- (void)dealloc
{
    [_mKieuHienThi release];
    [_mTenViewController release];
    [_mTieuDe release];
    [super dealloc];
}
@end
