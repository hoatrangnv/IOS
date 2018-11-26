//
//  ItemTaiKhoanLienKet.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 10/6/16.
//
//

#import <Foundation/Foundation.h>

@interface ItemTaiKhoanLienKet : NSObject

@property (retain, nonatomic) NSString* sId;
@property (retain, nonatomic) NSString* idVi;

@property (retain, nonatomic) NSString* maNganHang;
@property (retain, nonatomic) NSString* tenChuTaiKhoan;
@property (retain, nonatomic) NSString* soTaiKhoan;
@property (retain, nonatomic) NSString* token;
@property (retain, nonatomic) NSString* otpConfirm;
@property (retain, nonatomic) NSString* u;
@property (retain, nonatomic) NSString* p;
@property (retain, nonatomic) NSString* cvv;

@property (retain, nonatomic) NSString* soThe;
@property (assign, nonatomic) int cardMonth;
@property (assign, nonatomic) int cardYear;

@property (assign, nonatomic) int trangThai;
@property (assign, nonatomic) int kieuXacThuc;
@property (assign, nonatomic) int lengthP;
@property (assign, nonatomic) int lengthU;
@property (assign, nonatomic) int danhDauTKMacDinh;
@property (assign, nonatomic) int danhDauTheMacDinh;

- (id)khoiTao:(NSDictionary *)dict;
- (NSString *)toDict;
@end
