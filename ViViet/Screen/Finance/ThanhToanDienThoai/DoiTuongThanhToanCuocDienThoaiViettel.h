//
//  DoiTuongThanhToanCuocDienThoaiViettel.h
//  ViViMASS
//
//  Created by DucBui on 4/21/15.
//
//

#import <Foundation/Foundation.h>

@interface DoiTuongThanhToanCuocDienThoaiViettel : NSObject

@property (nonatomic, copy) NSString *maGiaoDich;
@property (nonatomic, copy) NSString *soDienThoai;
@property (nonatomic, copy) NSString *tienCuocPhaiThanhToan;

- (id)initWithMaGiaoDich:(NSString*)maGiaoDich
             soDienThoai:(NSString*)soDienThoai
   tienCuocPhaiThanhToan:(NSString*)tienCuocPhaiThanhToan;

@end
