//
//  DoiTuongChiTietGiaoDichChuyenTienDenTaiKhoan.h
//  ViViMASS
//
//  Created by DucBui on 6/11/15.
//
//

#import "DoiTuongChiTietGiaoDich.h"

@interface DoiTuongChiTietGiaoDichChuyenTienDenTaiKhoan : DoiTuongChiTietGiaoDich

@property (nonatomic, copy) NSString *vi;
@property (nonatomic, copy) NSNumber *amount;
@property (nonatomic, copy) NSString *bankCode;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *bankNumber;
@property (nonatomic, copy) NSString *chiNhanh;
@property (nonatomic, copy) NSString *sID;
@property (nonatomic, copy) NSString *companyCode;
@property (nonatomic, copy) NSString *nameBenefit;
@property (nonatomic, copy) NSString *maGiaoDich;
@property (nonatomic, copy) NSNumber *tranTime;
@property (nonatomic, copy) NSString *nameBenefitSaoKe;
@property (nonatomic, copy) NSString *bankAcc;
@property (nonatomic, copy) NSString *nameUsed;

@end
