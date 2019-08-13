//
//  DoiTuongChiTietGiaoDichGuiTietKiem.h
//  ViViMASS
//
//  Created by DucBui on 6/11/15.
//
//

#import "DoiTuongChiTietGiaoDich.h"
#import "SoTietKiem.h"
#import "DucNT_ServicePost.h"

@interface DoiTuongChiTietGiaoDichRutTietKiem : DoiTuongChiTietGiaoDich

@property (nonatomic, copy) NSString *vi;
@property (nonatomic, copy) NSString *soSoTietKiem;
@property (nonatomic, retain) NSString *secssion;
@property (nonatomic, retain) SoTietKiem *mSoTietKiem;
@property (nonatomic, retain) NSString *mDinhDanhDoanhNghiep;

@end
