//
//  ObjectFilm.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 12/7/15.
//
//

#import <Foundation/Foundation.h>

@interface ObjectFilm : NSObject
@property (nonatomic, copy) NSString *idRap;
@property (nonatomic, copy) NSString *tenPhim;
@property (nonatomic, copy) NSString *idPhim;
@property (nonatomic, copy) NSString *ngayKhoiChieu;
@property (nonatomic, copy) NSString *anhDaiDien;
@property (nonatomic, copy) NSString *thoiLuong;
@property (nonatomic, copy) NSString *daoDien;
@property (nonatomic, copy) NSString *dienVien;
@property (nonatomic, copy) NSString *quocGia;
@property (nonatomic, copy) NSString *ngonNgu;
@property (nonatomic, copy) NSString *theLoai;
@property (nonatomic, copy) NSString *trailer;
@property (nonatomic, copy) NSString *noiDung;
@property (nonatomic, retain) NSMutableArray *arrNgayChieu;
@property (nonatomic, copy) NSString *dsRap;

- (id)initWithDictionary:(NSDictionary*)dict;
- (void)khoiTaoLaiDuLieu:(NSDictionary*)dict;
@end
