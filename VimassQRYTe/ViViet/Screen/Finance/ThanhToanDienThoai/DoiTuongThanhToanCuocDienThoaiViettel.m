//
//  DoiTuongThanhToanCuocDienThoaiViettel.m
//  ViViMASS
//
//  Created by DucBui on 4/21/15.
//
//

#import "DoiTuongThanhToanCuocDienThoaiViettel.h"

@implementation DoiTuongThanhToanCuocDienThoaiViettel

- (id)initWithMaGiaoDich:(NSString*)maGiaoDich
             soDienThoai:(NSString*)soDienThoai
   tienCuocPhaiThanhToan:(NSString*)tienCuocPhaiThanhToan
{
    self = [super init];
    if(self)
    {
        if(maGiaoDich)
            self.maGiaoDich = maGiaoDich;
        else
            self.maGiaoDich = @"";
        
        if(soDienThoai)
            self.soDienThoai = soDienThoai;
        else
            self.soDienThoai = @"";
        
        if(tienCuocPhaiThanhToan)
            self.tienCuocPhaiThanhToan = tienCuocPhaiThanhToan;
        else
            self.tienCuocPhaiThanhToan = @"";
    }
    return self;
}

- (void)dealloc
{
    [_maGiaoDich release];
    [_soDienThoai release];
    [_tienCuocPhaiThanhToan release];
    [super dealloc];
}

@end
