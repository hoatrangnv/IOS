//
//  DucNT_TaiKhoanViObject.h
//  ViMASS
//
//  Created by MacBookPro on 7/17/14.
//
//

#import "QuyenCuaTaiKhoan.h"
#import "DucNT_TaiKhoanThuongDungObject.h"

extern NSString *const KEY_ACCOUNT_TEN_TAI_KHOAN;
extern NSString *const KEY_ACCOUNT_TEN_NGAN_HANG;
extern NSString *const KEY_ACCOUNT_TEN_CMND;
extern NSString *const KEY_ACCOUNT_THU_DIEN_TU;
extern NSString *const KEY_ACCOUNT_NGAY_SINH;
extern NSString *const KEY_ACCOUNT_CMND;
extern NSString *const KEY_ACCOUNT_NGAY_CAP_CMND;
extern NSString *const KEY_ACCOUNT_NOI_CAP_CMND;
extern NSString *const KEY_ACCOUNT_DIA_CHI_NHA;
extern NSString *const KEY_ACCOUNT_LINK_ANH_TRUOC;
extern NSString *const KEY_ACCOUNT_LINK_ANH_SAU;
extern NSString *const KEY_ACCOUNT_LINK_CHU_KY;
extern NSString *const KEY_ACCOUNT_LINK_NAME_ALIAS;
extern NSString *const KEY_ACCOUNT_PHONE;
extern NSString *const KEY_ACCOUNT_LINK_ANH_DAI_DIEN;
extern NSString *const KEY_ACCOUNT_PHONE_AUTHENTICATE;
extern NSString *const KEY_ACCOUNT_PHONE_TOKEN;
extern NSString *const KEY_ACCOUNT_PASS;
extern NSString *const KEY_ACCOUNT_ID;
extern NSString *const KEY_ACCOUNT_IS_TOKEN;
extern NSString *const KEY_ACCOUNT_AMOUNT;
extern NSString *const KEY_ACCOUNT_PROMOTION_STATUS;
extern NSString *const KEY_ACCOUNT_PROMOTION_TOTAL;

extern NSString *const KEY_ACCOUNT_SECSSION;
extern NSString *const KEY_ACCOUNT_START;
extern NSString *const KEY_ACCOUNT_STATUS;
extern NSString *const KEY_ACCOUNT_TOTALGIFT;
extern NSString *const KEY_ACCOUNT_TOTALCREATEGIFT;
extern NSString *const KEY_ACCOUNT_UID;


extern NSString *const KEY_ACCOUNT_ACC_TYPE;
extern NSString *const KEY_ACCOUNT_COMPANY_CODE;
extern NSString *const KEY_ACCOUNT_COMPANY_NAME;
extern NSString *const KEY_ACCOUNT_IMAGE_COMPANY_1;
extern NSString *const KEY_ACCOUNT_IMAGE_COMPANY_2;
extern NSString *const KEY_ACCOUNT_NAME_REPRESENT;
extern NSString *const KEY_ACCOUNT_ROLES;

extern NSString *const KEY_ACCOUNT_WALLET_ID;
extern NSString *const KEY_ACCOUNT_WALLET_LOGIN;

extern NSString *const KEY_ACCOUNT_WALLET_LOGIN_EMAIL;
extern NSString *const KEY_ACCOUNT_WALLET_LOGIN_NAME;
extern NSString *const KEY_DS_LAP;
extern NSString *const KEY_DS_DUYET;
extern NSString *const KEY_SDT_NGUOI_DUYET;
extern NSString *const KEY_EMAIL_NGUOI_DUYET;
@interface DucNT_TaiKhoanViObject : NSObject

@property (retain, nonatomic) NSString *sID;
@property (retain, nonatomic) NSString *sTenTaiKhoan;
@property (retain, nonatomic) NSString *sTenNganHang;
@property (retain, nonatomic) NSString *sTenCMND;
@property (retain, nonatomic) NSString *sNgaySinh;
@property (retain, nonatomic) NSString *sThuDienTu;
@property (retain, nonatomic) NSString *sCMND;
@property (retain, nonatomic) NSString *sNoiCapCMND;
@property (retain, nonatomic) NSString *sNgayCapCMND;
@property (retain, nonatomic) NSString *sDiaChiNha;
@property (retain, nonatomic) NSString *sLinkAnhTruocCMND;
@property (retain, nonatomic) NSString *sLinkAnhSauCMND;
@property (retain, nonatomic) NSString *sLinkAnhChuKy;
@property (retain, nonatomic) NSString *sLinkAnhDaiDien;
@property (retain, nonatomic) NSString *sNameAlias;
@property (retain, nonatomic) NSString *sPhone;
@property (retain, nonatomic) NSString *sPhoneAuthenticate;
@property (retain, nonatomic) NSString *sPass;
@property (retain, nonatomic) NSString *sPhoneToken;
@property (retain, nonatomic) NSString *sEmail;
@property (retain, nonatomic) NSNumber *nIsToken;
@property (retain, nonatomic) NSNumber *nAmount;
@property (retain, nonatomic) NSNumber *nPromotionTotal;
@property (retain, nonatomic) NSNumber *nPromotionStatus;

@property (retain, nonatomic) NSString *secssion;
@property (retain, nonatomic) NSNumber *start;
@property (retain, nonatomic) NSNumber *status;
@property (retain, nonatomic) NSNumber *toTalGift;
@property (retain, nonatomic) NSNumber *totalCreateGift;
@property (retain, nonatomic) NSNumber *uId;
@property (retain, nonatomic) NSString *sdsTKNhanThongBaoBienDongSoDu;

//Company
@property (retain, nonatomic) NSNumber *accType;
@property (retain, nonatomic) NSString *sdtNguoiDuyet;
@property (retain, nonatomic) NSString *dsLap;
@property (retain, nonatomic) NSString *dsDuyet;
@property (retain, nonatomic) NSString *companyCode;
@property (retain, nonatomic) NSString *companyName;
@property (retain, nonatomic) NSString *imageCompany1;
@property (retain, nonatomic) NSString *imageCompany2;
@property (retain, nonatomic) NSString *nameRepresent;
@property (retain, nonatomic) QuyenCuaTaiKhoan *roles;
@property (retain, nonatomic) NSString *tKRutTien;
@property (retain, nonatomic) NSNumber *nHanMucDenVi;
@property (retain, nonatomic) NSNumber *nHanMucDenThe;
@property (retain, nonatomic) NSNumber *nHanMucDenTaiKhoan;
@property (retain, nonatomic) NSNumber *nHanMucDenViKhac;
//roles = "{\"list\":[{\"nguoiLapGiaoDich\":1,\"nguoiDuyetGiaoDich\":0,\"funcId\":1},{\"nguoiLapGiaoDich\":1,\"nguoiDuyetGiaoDich\":0,\"funcId\":420},{\"nguoiLapGiaoDich\":1,\"nguoiDuyetGiaoDich\":0,\"funcId\":421},{\"nguoiLapGiaoDich\":1,\"nguoiDuyetGiaoDich\":0,\"funcId\":403},{\"nguoiLapGiaoDich\":1,\"nguoiDuyetGiaoDich\":0,\"funcId\":406},{\"nguoiLapGiaoDich\":1,\"nguoiDuyetGiaoDich\":0,\"funcId\":414},{\"nguoiLapGiaoDich\":1,\"nguoiDuyetGiaoDich\":0,\"funcId\":415}],\"administrator\":0}";

@property (retain, nonatomic) NSString *walletId;
@property (retain, nonatomic) NSString *walletLogin;
@property (retain, nonatomic) NSString *walletLoginEmail;
@property (retain, nonatomic) NSString *walletLoginName;
@property (retain, nonatomic) NSString *linkQR;
@property (nonatomic, retain) NSNumber *hienThiNoiDungThanhToanQR;
@property (retain, nonatomic) NSString *pki3;
@property (nonatomic, retain) NSNumber *hanMucPki3;

@property (nonatomic, retain) NSNumber *hanMucTimeSoftToken;
@property (nonatomic, retain) NSNumber *hanMucDaySoftToken;
@property (nonatomic, retain) NSNumber *hanMucTimeSoftTokenMax;
@property (nonatomic, retain) NSNumber *hanMucDaySoftTokenMax;

@property (nonatomic, retain) NSNumber *hanMucTimeVanTay;
@property (nonatomic, retain) NSNumber *hanMucDayVanTay;
@property (nonatomic, retain) NSNumber *hanMucTimeVanTayMax;
@property (nonatomic, retain) NSNumber *hanMucDayVanTayMax;

@property (nonatomic, retain) NSNumber *hanMucTimeMPKI;
@property (nonatomic, retain) NSNumber *hanMucDayMPKI;
@property (nonatomic, retain) NSNumber *hanMucTimeMPKIMax;
@property (nonatomic, retain) NSNumber *hanMucDayMPKIMax;

- (id)initWithDict:(NSDictionary*)dict;

- (BOOL)layQuyenDuocDuyetGiaoDichTrongChucNang:(int)nFuncID;

- (BOOL)layQuyenDuocLapGiaoDichTrongChucNang:(int)nFuncID;

- (BOOL)kiemTraCoThuDienTu;

- (NSString*)layThuDienTu;

@end
