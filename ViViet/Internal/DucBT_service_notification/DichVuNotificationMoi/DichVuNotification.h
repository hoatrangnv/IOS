//
//  DichVuNotification.h
//  ViMASS
//
//  Created by DucBT on 10/14/14.
//
//

#import "DucNT_ServicePost.h"

#define BASE_URL_SERVICE_NOTIFICATION @"https://vimass.vn/pushNotification/services/adminPush"
#define KEY_TRANG_THAI_DANG_KI_THIET_BI @"KEY_TRANG_THAI_DANG_KI_THIET_BI"
#define KEY_LUU_SO_LUONG_TIN_CHUA_DOC @"KEY_LUU_SO_LUONG_TIN_CHUA_DOC"

#define DINH_DANG_KIEM_TRA_VERSION @"DINH_DANG_KIEM_TRA_VERSION"
#define DINH_DANH_DANG_KI_THIET_BI @"DINH_DANH_DANG_KI_THIET_BI"
#define DINH_DANH_LAY_SO_LUONG_TIN_CHUA_DOC @"DINH_DANH_LAY_SO_LUONG_TIN_CHUA_DOC"
#define DINH_DANH_LAY_DANH_SACH_TIN @"DINH_DANH_LAY_DANH_SACH_TIN"
#define DINH_DANH_LAY_CHI_TIET_MOT_TIN @"DINH_DANH_LAY_CHI_TIET_MOT_TIN"
#define DINH_DANH_XAC_NHAN_TIN_DA_DOC @"DINH_DANH_XAC_NHAN_TIN_DA_DOC"
#define DINH_DANH_XOA_TIN @"DINH_DANH_XOA_TIN"
#define DINH_DANH_LAY_DANH_SACH_GIAO_DICH @"DINH_DANH_LAY_DANH_SACH_GIAO_DICH"
#define DINH_DANH_GUI_TIN_CHAT @"DINH_DANH_GUI_TIN_CHAT"

#define TIN_TAI_CHINH 1
#define TIN_QUANG_BA 2
#define TIN_CHAT_RAO_VAT 3

#define TIN_CHAT_DON_HANG 5
#define TIN_CHAT_HOA_DON 6
#define TIN_CHAT_BDS 7
#define TIN_CHAT_TIM_VIEC 8
#define TIN_CHAT_VIEC_LAM 9
#define TIN_CHAT_BIDV 10

#define TIN_CHAT_THUONG_MAI 11
#define TIN_CHAT_DIA_DIEM 12
#define TIN_CHAT_TAI_CHINH 19




@interface DichVuNotification : NSObject

+ (id)shareService;

- (void)dichVuDanhDauAllTin: (long long)nThoiGianDocTin
              trongChucNang: (int)nFuncID
              noiNhanKetQua: (id<DucNT_ServicePostDelegate>)noiNhanKetQua;

- (void)dichVuDangKyThietBi:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;


- (void)dichVuLayDanhSachTinNhanTrongChucNang: (int)nFuncID
                                     thoiGian: (long long)time
                                  viTriBatDau: (int)nViTri
                                   soLuongTin: (int)nSoLuong
                                    nguoiNhan: (NSString*)sNguoiNhan
                                  kieuTimKiem: (int)nKieuTimKiem
                              phanLoaiTinNhan: (NSString*)phanLoaiTinNhan
                                noiNhanKetQua: (id<DucNT_ServicePostDelegate>)noiNhanKetQua;

- (void)dichVuLayChiTietMotTin:(NSString*)sIDTin noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

- (void)dichVuChatVoi: (NSString*)sNguoiNhan
              tinNhan: (NSString*)sTinNhan
               tieuDe: (NSString*)sTieuDe
             chucNang: (int)nFuncID
        noiNhanKetQua: (id<DucNT_ServicePostDelegate>)noiNhanKetQua;

- (void)dichVuLayDanhSachNguoiChatTrongChucNang:(int)nFuncID noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

- (void)dichVuXoaTinNhan:(NSArray*)mDanhSachIDTinCanXoa noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

- (void)dichVuDanhDauThoiGianDocTin: (long long)nThoiGianDocTin
                      trongChucNang: (int)nFuncID
                             doiTac: (NSString*)sDoiTac
                      noiNhanKetQua: (id<DucNT_ServicePostDelegate>)noiNhanKetQua;

- (void)dichVuDanhDauThoiGianDocTin: (long long)nThoiGianDocTin
                      trongChucNang: (int)nFuncID
                             doiTac: (NSString*)sDoiTac
                          showAlert:(BOOL)show
                      noiNhanKetQua: (id<DucNT_ServicePostDelegate>)noiNhanKetQua;

- (void)dichVuLaySoLuongTinChuaDocTrongKieu:(int)nFuncID noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

- (void)dichVuCheckVersion:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

- (void)dichVuDoiTenGiaoDich:(NSString*)sTenGiaoDichMoi
                     account:(NSString*)sTenAccount
                        pass:(NSString*)sPass
               noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

- (void)dichVuXacNhanTrangThaiTinNotificationMuonTien:(NSString*)sIdMess
                                            trangThai:(int)nStatusShow
                                        noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhan;

#pragma mark - client
- (BOOL)kiemTraDaDangKiThietBi;

- (void)xacNhanDangKiThietBi;

- (void)luuSoLuongTinChuaDoc:(NSString*)sJsonSoLuongTinChuaDoc;

- (int)laySoLuongTinChuaDocTrongChucNang:(int)nFuncID;

- (void)tangGiaTriBagdeNumberChoChucNang:(int)nFuncID;

- (void)xacNhanDaDocTinTrongChucNang:(int)nFuncID;

- (void)dichVuXacNhanDaDocTatCaCacTin;


@end
