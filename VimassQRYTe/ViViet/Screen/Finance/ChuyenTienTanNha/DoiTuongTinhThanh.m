//
//  DoiTuongTinhThanh.m
//  ViViMASS
//
//  Created by DucBui on 7/13/15.
//
//

#import "DoiTuongTinhThanh.h"
#import "JSONKit.h"

@implementation DoiTuongTinhThanh

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if(self)
    {
        NSNumber *maTinh = [dict valueForKey:@"maTinh"];
        if(maTinh)
            self.maTinh = maTinh;
        else
            self.maTinh = [NSNumber numberWithInteger:0];
        
        NSString *tenTinh = [dict valueForKey:@"tenTinh"];
        if(tenTinh)
            self.mTen = tenTinh;
        else
            self.mTen = @"";
        
        NSArray *dsQuanHuyen = [dict valueForKey:@"dsQuanHuyen"];
        if(dsQuanHuyen)
        {
            NSMutableArray *tempQuanHuyen = [[NSMutableArray alloc] initWithCapacity:dsQuanHuyen.count];
            for(NSDictionary *dictQuanHuyen in dsQuanHuyen)
            {
                DoiTuongQuanHuyen *doiTuongQuanHuyen = [[DoiTuongQuanHuyen alloc] initWithDict:dictQuanHuyen];
                [tempQuanHuyen addObject:doiTuongQuanHuyen];
                [doiTuongQuanHuyen release];
            }
            self.dsQuanHuyen = tempQuanHuyen;
            [tempQuanHuyen release];
        }
        else
            self.dsQuanHuyen = [NSArray new];
    }
    return self;
}

+ (NSArray*)layDanhSachTinhThanh
{
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"jsonTinhThanh" ofType:@"txt"]];
    NSDictionary *dict = [data objectFromJSONData];
    NSArray *dsTinhThanh = [dict valueForKey:@"dsTinhThanh"];
    if(dsTinhThanh)
    {
        NSMutableArray *tempDSTinhThanh = [[[NSMutableArray alloc] initWithCapacity:dsTinhThanh.count] autorelease];
        for(NSDictionary *dictTinhThanh in dsTinhThanh)
        {
            DoiTuongTinhThanh *doiTuongTinhThanh = [[DoiTuongTinhThanh alloc] initWithDict:dictTinhThanh];
            [tempDSTinhThanh addObject:doiTuongTinhThanh];
            [doiTuongTinhThanh release];
        }
        return tempDSTinhThanh;
    }
    return [NSArray new];
}

- (void)dealloc
{
    [_maTinh release];
    [_dsQuanHuyen  release];
    [super dealloc];
}
@end
