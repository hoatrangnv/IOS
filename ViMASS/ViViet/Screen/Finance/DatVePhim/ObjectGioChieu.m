//
//  ObjectGioChieu.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 12/9/15.
//
//

#import "ObjectGioChieu.h"

@implementation ObjectGioChieu

- (id)khoiTaoObjectGioChieu:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        NSString *sId = [dict objectForKey:@"idRap"];
        NSString *sIdPhim = [dict objectForKey:@"idPhim"];
        NSString *sNgayChieu = [dict objectForKey:@"ngayChieu"];
        NSString *sIdKhungGio = [dict objectForKey:@"idKhungGio"];
        if (sId) {
            self.idRap = sId;
        }
        else
            self.idRap = @"";
        if (sIdPhim) {
            self.idPhim = sIdPhim;
        }
        else
            self.idPhim = @"";
        if (sNgayChieu) {
            self.ngayChieu = sNgayChieu;
        }
        else
            self.ngayChieu = @"";
        if (sIdKhungGio) {
            self.idKhungGio = sIdKhungGio;
        }
        else
            self.idKhungGio = @"";
        NSArray *arrNgayChieu = [dict objectForKey:@"groupNgayChieu"];
        if (!self.groupNgayChieu) {
            self.groupNgayChieu = [[NSMutableArray alloc] initWithArray:arrNgayChieu];
        }
    }
    return self;
}

- (void)dealloc{
    [_idRap release];
    [_idPhim release];
    [_ngayChieu release];
    [_idKhungGio release];
    [_groupNgayChieu release];
    [super dealloc];
}

@end
