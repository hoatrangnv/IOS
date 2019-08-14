//
//  KyHanNganHang.m
//  ViViMASS
//
//  Created by DucBui on 5/13/15.
//
//

#import "KyHanNganHang.h"

@implementation KyHanNganHang

- (id)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if(self)
    {
        NSString *maKyHan = [dict valueForKey:@"maKyHan"];
        if(maKyHan)
            self.maKyHan = maKyHan;
        else
            self.maKyHan = @"";
            
        NSString *noiDung = [dict valueForKey:@"noiDung"];
        if(noiDung)
            self.noiDung = noiDung;
        else
            self.noiDung = @"";
        
        NSNumber *laiSuat = [dict valueForKey:@"laiSuat"];
        if(laiSuat)
            self.laiSuat = laiSuat;
        else
            self.laiSuat = [NSNumber numberWithInt:0];
        NSArray *dsKyLai = [dict valueForKey:@"kyLai"];
        if(dsKyLai)
        {
            NSMutableArray *arrTemp = [[NSMutableArray alloc] initWithCapacity:dsKyLai.count];
            for (NSDictionary *dictTemp in dsKyLai)
            {
                KyLaiNganHang *kyLaiNganHang = [[KyLaiNganHang alloc] initWithDictionary:dictTemp];
                [arrTemp addObject:kyLaiNganHang];
                [kyLaiNganHang release];
            }
            self.mDanhSachKyLai = arrTemp;
            [arrTemp release];
        }
        else
            self.mDanhSachKyLai = [NSArray new];
    }
    return self;
}

- (NSString*)layCotLaiSuatTheoKiHan
{
    return [NSString stringWithFormat:@"<tr><td>%@</td><td>%@</td></tr>", _noiDung, _laiSuat];
}

- (void)dealloc
{
    [_laiSuat release];
    [_maKyHan release];
    [_noiDung release];
    [_mDanhSachKyLai release];
    [super dealloc];
}

@end
