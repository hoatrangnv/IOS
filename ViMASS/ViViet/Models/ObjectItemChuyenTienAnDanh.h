//
//  ObjectItemChuyenTienAnDanh.h
//  ViViMASS
//
//  Created by Mac Mini on 11/2/18.
//

#import <Foundation/Foundation.h>

@interface ObjectItemChuyenTienAnDanh : NSObject{
    
}
@property (nonatomic, strong) NSString * sdt;
@property (nonatomic, strong) NSString *tenHienThi;
@property (nonatomic, assign) double  soTien;
@property (nonatomic, assign) double  fee;
@property (nonatomic, assign) int loaiMapping;
@property (nonatomic, assign) BOOL soTienThanhToanHopLe;
-(NSDictionary*)toDict;
@end
