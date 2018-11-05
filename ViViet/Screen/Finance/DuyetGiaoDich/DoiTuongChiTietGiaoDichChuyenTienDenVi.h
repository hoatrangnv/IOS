//
//  DoiTuongChuyenTienDenVi.h
//  ViViMASS
//
//  Created by DucBui on 6/11/15.
//
//

#import "DoiTuongChiTietGiaoDich.h"

@interface DoiTuongChiTietGiaoDichChuyenTienDenVi : DoiTuongChiTietGiaoDich

@property (nonatomic, copy) NSString *vi;
@property (nonatomic, copy) NSString *fromAcc;
@property (nonatomic, copy) NSString *toAcc;
@property (nonatomic, copy) NSString *transDesc;
@property (nonatomic, copy) NSNumber *amount;
@property (nonatomic, copy) NSNumber *transTime;
@property (nonatomic, copy) NSNumber *feeAmount;
@property (nonatomic, copy) NSString *companyCode;

@end
