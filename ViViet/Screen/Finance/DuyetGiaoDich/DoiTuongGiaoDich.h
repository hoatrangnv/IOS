//
//  DoiTuongGiaoDich.h
//  ViViMASS
//
//  Created by DucBui on 6/9/15.
//
//

#import <Foundation/Foundation.h>
#import "DoiTuongChiTietGiaoDich.h"



typedef enum : NSUInteger {
    DOANH_NGHIEP_LAP_LENH_THANH_CONG = 1,
    DOANH_NGHIEP_HET_HAN_DUYET = 2,
    DOANH_NGHIEP_DA_HUY = 3,
    DOANH_NGHIEP_DUYET_LENH_THANH_CONG = 4,
    DOANH_NGHIEP_DUYET_LENH_XOA = 7,
}TRANG_THAI_DOI_TUONG_GIAO_DICH;

@interface DoiTuongGiaoDich : NSObject

@property (nonatomic, copy) NSString *vi;
@property (nonatomic, copy) NSString *nameLap;
@property (nonatomic, copy) NSString *nameDuyet;
@property (nonatomic, copy) NSString *userLap;
@property (nonatomic, copy) NSString *userDuyet;
@property (nonatomic, copy) NSNumber *funcId;
@property (nonatomic, copy) NSString *maGiaoDich;
@property (nonatomic, copy) NSString *companyCode;
@property (nonatomic, copy) NSNumber *soTien;
@property (nonatomic, copy) NSString *noiDungHienThi;
@property (nonatomic, copy) NSNumber *thoiGianLap;
@property (nonatomic, copy) NSNumber *thoiGianDuyet;
@property (nonatomic, copy) NSNumber *thoiGianHetHan;
@property (nonatomic, copy) NSNumber *thoiGianHuy;
@property (nonatomic, copy) NSNumber *fee;
@property (nonatomic, copy) NSNumber *trangThai;
@property (nonatomic, copy) NSString *lyDoDuyetThatBai;

@property (nonatomic, retain) DoiTuongChiTietGiaoDich *mDoiTuongChiTietGiaoDich;

- (id)initWithDict:(NSDictionary*)dict;

- (NSString*)layThoiGianHuy;

- (NSString*)layThoiGianLap;

- (NSString*)layThoiGianHetHan;

- (NSString*)layThoiGianDuyet;

- (NSString*)layTrangThai;

- (NSDate*)layThoiGianLapTraVeNSDate;

- (void)khoiTaoDoiTuongChiTietGiaoDich:(NSDictionary*)dict;

- (NSString*)layXauHTMLHienThiDoiTuongGiaoDich;

+ (NSArray*)layDanhSachDuyetGiaoDich:(NSArray*)arr;



@end
