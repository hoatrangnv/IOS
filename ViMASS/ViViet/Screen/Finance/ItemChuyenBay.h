//
//  ItemChuyenBay.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 1/7/16.
//
//

#import <Foundation/Foundation.h>

@interface ItemChuyenBay : NSObject
@property (nonatomic, copy) NSString *maSanBayDi;
@property (nonatomic, copy) NSString *maSanBayDen;
@property (nonatomic, copy) NSString *thoiGian;
@property (nonatomic, copy) NSString *gioBay;
@property (nonatomic, copy) NSString *gioDen;
@property (nonatomic, copy) NSString *thoiGianBay;
@property (nonatomic, copy) NSString *maChuyenBay;
@property (nonatomic, assign) int hangBay;
@property (nonatomic, assign) int gia;
@property (nonatomic, assign) int giaNguoiLon;
@property (nonatomic, assign) int giaTreEm;
@property (nonatomic, assign) int giaEmBe;
@property (nonatomic, assign) int gia15KG;
@property (nonatomic, assign) int gia20KG;
@property (nonatomic, assign) int gia25KG;
@property (nonatomic, assign) int gia30KG;
@property (nonatomic, assign) int gia35KG;
@property (nonatomic, assign) int gia40KG;
@property (nonatomic, assign) int phiVimass;

- (id)khoiTaoThongTin:(NSDictionary *)dic;

@end
