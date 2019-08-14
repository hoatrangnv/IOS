//
//  ItemGiaVeCGV.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 6/24/16.
//
//

#import "ItemGiaVeCGV.h"
#import "JSONKit.h"
@implementation ItemGiaVeCGV

- (id)initWithDictionary:(NSDictionary*)dict{
    self = [super init];
    if(self)
    {
        self.idVe = [dict objectForKey:@"idVe"];
        self.ghiChu = [dict objectForKey:@"ghiChu"];
        self.hienThi = [dict objectForKey:@"hienThi"];
        if (self.hienThi == [NSNull null]) {
            self.hienThi = @"";
        }
        self.tenVe = [dict objectForKey:@"tenVe"];
        self.gia = [[dict objectForKey:@"gia"] doubleValue];
        self.sl = [[dict objectForKey:@"sl"] intValue];
        self.nDinhDanhGhe = 0;
    }
    return self;
}

- (NSString *)convertJSON {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:self.idVe forKey:@"idVe"];
    [dict setObject:[NSNumber numberWithInt:self.sl] forKey:@"sl"];
    [dict setObject:[NSNumber numberWithInt:self.gia ] forKey:@"gia"];
    return [dict JSONString];
}

- (void)dealloc {
    [_idVe release];
    [_ghiChu release];
    [_hienThi release];
    [_tenVe release];
    [super dealloc];
}

@end
