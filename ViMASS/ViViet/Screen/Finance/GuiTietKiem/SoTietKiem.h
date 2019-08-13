//
//  SoTietKiem.h
//  ViViMASS
//
//  Created by DucBui on 5/18/15.
//
//

#import <Foundation/Foundation.h>

@interface SoTietKiem : NSObject

@property (nonatomic, copy) NSString *user;
@property (nonatomic, copy) NSNumber *typeAuthenticate;
@property (nonatomic, copy) NSString *maNganHang;
@property (nonatomic, copy) NSNumber *soTien;
@property (nonatomic, copy) NSNumber *cachThucQuayVong;
@property (nonatomic, copy) NSString *kyHan;
@property (nonatomic, copy) NSNumber *kyLinhLai;
@property (nonatomic, copy) NSString *tenNguoiGui;
@property (nonatomic, copy) NSString *soCmt;
@property (nonatomic, copy) NSString *diaChi;
@property (nonatomic, copy) NSNumber *kieuNhanTien;
@property (nonatomic, copy) NSString *maNganHangNhanTien;
@property (nonatomic, copy) NSString *tenChuTaiKhoan;
@property (nonatomic, copy) NSString *soTaiKhoan;
@property (nonatomic, copy) NSNumber *maGiaoDich;
@property (nonatomic, copy) NSString *soSoTietKiem;
@property (nonatomic, copy) NSNumber *trangThai;
@property (nonatomic, copy) NSNumber *thoiGianGui;
@property (nonatomic, copy) NSNumber *thoiGianDaoHan;
@property (nonatomic, copy) NSNumber *thoiGianHoanTien;

@property (nonatomic, copy) NSNumber *thoiGianHieuLuc;
@property (nonatomic, copy) NSNumber *thoiGianRutSo;

@property (nonatomic, copy) NSNumber *laiSuat;
@property (nonatomic, copy) NSString *soSoVimass;
@property (nonatomic, copy) NSNumber *tienThucLinh;

- (id)initWithDictionary:(NSDictionary*)dict;

- (NSString*)layTrangThai;
- (NSString*)layKyHan;
- (NSString*)layKyLinhLai;
- (NSString*)layLaiSuat;
- (NSString*)layNgayGui;
- (NSString*)layNgayDaoHan;
- (NSString*)layCachThucQuayVong;
- (NSString*)layKieuNhanTien;

- (double)laySoTienLaiTheoKyHan;
- (double)laySoTienLaiRutTruocHan;

- (NSString*)layChiTietSoTietKiemKieuHTML;

- (NSDate*)layNgayGuiTraVeNSDate;

@end
