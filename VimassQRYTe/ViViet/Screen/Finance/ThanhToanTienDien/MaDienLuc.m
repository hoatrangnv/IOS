//
//  MaDienLuc.m
//  ViViMASS
//
//  Created by DucBT on 4/8/15.
//
//

#import "MaDienLuc.h"
#import "JSONKit.h"

@implementation MaDienLuc

- (id)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if(self)
    {
        NSString *maDienLuc = [dict valueForKey:@"maDienLuc"];
        if(maDienLuc)
            self.maDienLuc = maDienLuc;
        else
            self.maDienLuc = @"";
        NSString *tinhThanh = [dict valueForKey:@"tinhThanh"];
        if(tinhThanh)
            self.tinhThanh = tinhThanh;
        else
            self.tinhThanh = @"";
        NSNumber *khuVuc = [dict valueForKey:@"khuVuc"];
        if(khuVuc)
            self.khuVuc = khuVuc;
        else
            self.khuVuc = [NSNumber numberWithInt:-1];

    }
    return self;
}


+ (NSArray *)layDanhSachMaDienLucTuFile
{
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MaDienLuc" ofType:@"txt"]];
    NSDictionary *dict = [data objectFromJSONData];
    NSArray *arrMaDienLuc = [dict valueForKey:@"arrDienLuc"];
    if(arrMaDienLuc)
    {
        NSMutableArray *temp = [[[NSMutableArray alloc] initWithCapacity:arrMaDienLuc.count] autorelease];
        for(NSDictionary *dictDienLuc in arrMaDienLuc)
        {
            MaDienLuc *objMaDienLuc = [[MaDienLuc alloc] initWithDictionary:dictDienLuc];
            [temp addObject:objMaDienLuc];
            [objMaDienLuc release];
        }
        
        return temp;
    }
    return nil;
}

- (void)dealloc
{
    [_maDienLuc release];
    [_tinhThanh release];
    [_khuVuc release];
    [super dealloc];
}

@end
