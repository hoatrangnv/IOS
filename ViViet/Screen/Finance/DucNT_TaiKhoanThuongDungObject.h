//
//  DucNT_TaiKhoanThuongDungObject.h
//  ViMASS
//
//  Created by MacBookPro on 7/24/14.
//
//

#import <Foundation/Foundation.h>

@interface DucNT_TaiKhoanThuongDungObject : NSObject<NSCopying>

@property (nonatomic, retain) NSString *sId;
@property (nonatomic, retain) NSString *sPhoneOwner;
@property (nonatomic, assign) int nType;
@property (nonatomic, retain) NSString *sAliasName;
@property (nonatomic, retain) NSString *sDesc;
@property (nonatomic, assign) double nAmount;
@property (nonatomic, retain) NSString *sToAccWallet;
@property (nonatomic, retain) NSString *sAccOwnerName;
@property (nonatomic, retain) NSString *sBankNumber;
@property (nonatomic, retain) NSString *sProvinceName;
@property (nonatomic, assign) int nProvinceCode;
@property (nonatomic, assign) int nProvinceID;
@property (nonatomic, retain) NSString *sBankName;
@property (nonatomic, assign) int nBankCode;
@property (nonatomic, assign) int nBankId;
@property (nonatomic, assign) int nBranchId;
@property (nonatomic, retain) NSString *sBranchName;
@property (nonatomic, retain) NSString *sBranchCode;
//@property (nonatomic, assign) int nCardId;
@property (nonatomic, retain) NSString *sCardTypeName;
@property (nonatomic, retain) NSString *sCardNumber;
@property (nonatomic, retain) NSString *sCardOwnerName;
@property (nonatomic, assign) long long nDateReg;
@property (nonatomic, assign) long long nDateExp;

// visa
@property (nonatomic, assign) int cardMonth;
@property (nonatomic, assign) int cardYear;
@property (nonatomic, retain) NSString *otpGetType;
@property (nonatomic, retain) NSString *zipCode;
@property (nonatomic, retain) NSString *thanhPho;
@property (nonatomic, retain) NSString *quocGia;
@property (nonatomic, retain) NSString *ten;
@property (nonatomic, retain) NSString *ho;
@property (nonatomic, retain) NSString *cvv;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *phone;
//Chuyen tien tan nha

@property (nonatomic, retain) NSString *tenNguoiThuHuong;
@property (nonatomic, retain) NSString *cellphoneNumber;
@property (nonatomic, retain) NSString *cmnd;
@property (nonatomic, retain) NSString *tinhThanh;
@property (nonatomic, retain) NSString *quanHuyen;
@property (nonatomic, retain) NSString *phuongXa;
@property (nonatomic, retain) NSString *diaChi;
@property (nonatomic, retain) NSString *noiDung;
@property (nonatomic, assign) int soTien;

//dien thoai
@property (nonatomic, retain) NSString *soDienThoai;
@property (nonatomic, retain) NSString *avatar;
@property (nonatomic, assign) int nhaMang;
@property (nonatomic, assign) int loaiThueBao;
@property (nonatomic, assign) BOOL ngayVang;

//nap tien dien tu
@property (nonatomic, assign) int nhaCungCap;
@property (nonatomic, retain) NSString *taiKhoan;
@property (nonatomic, retain) NSString *loaiGame;

//nap tien dien
@property (nonatomic, retain) NSString *maKhachHang;
@property (nonatomic, retain) NSString *tenChiNhanh;
@property (nonatomic, retain) NSString *maChiNhanh;

//internet
@property (nonatomic, retain) NSString *maThueBao;

//gui tiet kiem
@property (nonatomic, assign) int cachThucQuayVong;
@property (nonatomic, assign) int kyLinhLai;
@property (nonatomic, assign) int kieuNhanTien;
@property (nonatomic, retain) NSString *maNganHang;
@property (nonatomic, retain) NSString *kyHan;
@property (nonatomic, retain) NSString *tenNguoiGui;
@property (nonatomic, retain) NSString *soCmt;
@property (nonatomic, retain) NSString *maNganHangNhanTien;
@property (nonatomic, retain) NSString *tenChuTaiKhoan;
@property (nonatomic, retain) NSString *soTaiKhoan;
//ATM
@property (nonatomic, assign) int kieuThanhToan;
@property (nonatomic, assign) int maNhaCungCap;
@property (nonatomic, assign) int maATM;
//CMND
@property (nonatomic, retain) NSString *diaChiChiNhanh;
@property (nonatomic, retain) NSString *noiCap;
@property (nonatomic, assign) long long ngayCap;
//qua tang
@property (nonatomic, assign) int idIcon;
@property (nonatomic, retain) NSString *giftName;
//tu thien
@property (nonatomic, retain) NSString *tenNguoiUngHo;
@property (nonatomic, assign) int maDuAnTuThien;
@property (nonatomic, retain) NSString *hoanCanhNguoiUngHo;
@property (nonatomic, retain) NSString *diaChiNguoiUngHo;
//hoc phi
@property (nonatomic, assign) int loaiDichVuHocPhi;
@property (nonatomic, retain) NSString *maHocPhi;
@property (nonatomic, retain) NSString *maKhachHangHocPhi;
@property (nonatomic, retain) NSString *tenKhachHangHocPhi;
//tien vay
@property (nonatomic, retain) NSString *maHopDong;
@property (nonatomic, retain) NSString *idThongBaoDinhKy;
@property (nonatomic) int trangThaiThongBaoDinhKy;
//hoa don may bay
@property (nonatomic, retain) NSString *tenCongTyXuatHoaDon;
@property (nonatomic, retain) NSString *diaChiCongTyXuatHoaDon;
@property (nonatomic, retain) NSString *maSoThueCongTyXuatHoaDon;
@property (nonatomic, retain) NSString *diaChiNhanHoaDon;
-(void)datLoaiTaiKhoan:(NSString *)sType;

- (NSMutableDictionary*)toDict;

- (void)fillDataWithDictionary:(NSDictionary*)dict loaiTaiKhoan:(int)nLoaiTaiKhoan;

@end
