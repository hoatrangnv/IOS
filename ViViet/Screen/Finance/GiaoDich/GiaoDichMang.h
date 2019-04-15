//
//  KetNoi.h
//  ViViMASS
//
//  Created by DucBT on 3/24/15.
//
//

#import <Foundation/Foundation.h>
#import "DucNT_ServicePost.h"

#define ROOT_URL @"https://vimass.vn/vmbank/services/"

#define URL_KIEM_TRA_TAI_KHOAN_CO_VI [NSString stringWithFormat:@"%@%@", ROOT_URL, @"account/checkAccount"]

@interface GiaoDichMang : NSObject
+ (void)ketNoiThanhToanVNPayQR:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;
+ (void)ketNoiLayThongTinQR:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;
+ (void)ketNoiLayTinTuc:(int)langID idInput:(NSString *)idInput noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;
+ (void)ketNoiLayChiTietTinTuc:(int)langID sIDTinTuc:(NSString *)sIDTinTuc noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;
+ (void)keyNoiThayDoiHanMuc:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;
+ (void)dangkyPKI:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua ;
+ (void)xacnhanDangKyPKI:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;
+ (void)caidatHanMucPKI:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)traCuuKPlus:(NSString *)maThueBao noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)thanhToanKPlus:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)layMaOTPTaoSuaQRDonVi:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)taoQRDonVi:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)suaQRDonVi:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)taoQRSanPhamCuaDonVi:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)xacThucOTPTaoQRDonVi:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)ketNoiLayDanhSachQRDonVi:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)ketNoiLayDanhSachQRSanPham:(NSString *)maDaiLy noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)xoaThongTinDaiLy:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)suaThongTinSanPham:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)xoaThongTinSanPham:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)layChiTietThongTinDaiLy:(NSString *)maDaiLy noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)ketNoiChuyenTienDenViHienSoVi:(NSString*)sDenVi soTien:(double)fSoTien noiDung:(NSString*)sNoiDung hienSoVi:(int)hienSoVi token:(NSString*)sToken otp:(NSString*)sOtp typeAuthenticate:(int)nTypeAuthenticate noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)layThongTinDonViQRCode:(NSString *)sIdQRCode noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)layThongTinSanPhamQRCode:(NSString *)sIdQRCode noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)layThongTinViQRCode:(NSString *)sIdQRCode noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)chuyenTienDenViBangQRCode:(NSString *)jsonDict noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)chuyenTienDenDonViBangQRCode:(NSString *)jsonDict noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)muaSanPhamTuQRCode:(NSString *)jsonDict noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)traCuuTrangThaiVeMayBay:(NSString *)idShow noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)muaVeMayBayGiaCao:(NSString *)idDatVe token:(NSString *)token otpConfirm:(NSString*)otpComfirm typeAuthenticate:(int)typeAuthenticate noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)layDanhSachTaiKhoanLienKet:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)taoTaiKhoanLienKet:(NSString *)dict noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)editTaiKhoanLienKet:(NSString *)dict noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)xoaTaiKhoanLienKet:(NSString *)dict noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)yeuCauNapTienTuTaiKhoanLienKet:(NSString *)idTaiKhoanLienKet session:(NSString *)session soTien:(NSString *)soTien noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)layTrangThaiNapTienTaiKhoanLienKet:(NSString *)idGiaoDich session:(NSString *)session noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)xacThucYeuCauNapTienTaiKhoanLienKet:(NSString *)idGiaoDich maXacThuc:(NSString *)maXacThuc noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)huyYeuCauNapTienTaiKhoanLienKet:(NSString *)idGiaoDich noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)layDanhSachQuangCao:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)layDanhSachQuangCao3G:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)thanhToanTienChungKhoan : (NSString *)jsonDic noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)thanhToanTraTienVay:(NSString *)jsonDic noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)layThongTinChiTietHoaDonTienVay : (NSString *)sIdShow noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)traCuuTienVay:(NSString *)maHopDong cmnd:(NSString *)cmnd maNhaCungCap:(int)maNhaCungCap soTien:(double)soTien noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)chuyenTienTuThien:(NSString *)sJson noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)chuyenTienDenCMND:(NSString *)sJson noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)thanhToanHocPhi:(NSString *)jsonHocPhi noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)thanhToanHoaDonTruyenHinh:(NSString *)maHoaDon maNhaCungCap:(int)nMaNhaCungCap soTien:(int)soTien token:(NSString *)token otpConfirm:(NSString*)otpComfirm typeAuthenticate:(int)typeAuthenticate noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)layChiTietHoaDonTruyenHinh: (NSString *)sId noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)traCuuHoaDonTruyenHinh : (NSString *)maThueBao nhaCungCap:(int)nhaCungCap noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)chuyenTienDenATM:(NSString *)sSoDienThoai soTien:(int)soTien maATM:(int)maATM token:(NSString *)sToken otpConfirm:(NSString*)otpComfirm typeAuthenticate:(int)typeAuthenticate noiDung:(NSString *)noiDung noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)traCuuSanBayDiDen:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)traCuuChuyenBay:(NSString*)sMaSanBayDi sMaSanBayDen:(NSString *)sMaSanBayDen sTimeDi:(NSString *)sTimeDi sTimeDen:(NSString *)sTimeDen slNguoiLon:(int)slNguoiLon slTreEm:(int)slTreEm slEmBe:(int)slEmBe noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)thanhToanMayBay:(NSString*)sJson noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;
+ (void)uploadAnhViDoanhNghiep:(NSString *)maDoanhNghiep value:(NSString *)value noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)dangKyDoanhNghiep2:(NSString *)sMaDn sTenDn:(NSString *)sTenDn sTenDD:(NSString *)sTenDD sSDT:(NSString *)sSDT sEmail:(NSString *)sEmail sImage1:(NSString*)sImage1 sImage2:(NSString *)sImage2 noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)dangKyDoanhNghiep:(NSDictionary *)dicPost  noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)layDanhSachRapPhim:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)layDanhSachRapPhimTheoTenVaKhuVuc:(NSString *)sTenFilm sKhuVuc:(NSString *)sKhuVuc noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)layDanhSAchPhimCuaRap:(NSString*)sIdRap noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)layDanhSachTinhThanhRapPhim:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)layDanhSachRapPhimTheoTinh:(NSString *)sTenTinh noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)layDanhSachGioChieuPhimCuaRap:(NSString*)sIdRap idPhim:(NSString *)idPhim noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)layThongTinGheNgoi:(NSString*)sIdRap idPhim:(NSString*)idPhim idKhungGio:(NSString*)idKhungGio noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)layThongTinGheNgoiQuocGiaBHD:(NSString *)sIdRap idPhim:(NSString *)idPhim idKhungGio:(NSString *)idKhungGio noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)layThongTinGheNgoiSauKhiChonGheBHD:(NSString *)sIdRap idPhim:(NSString *)idPhim idKhungGio:(NSString *)idKhungGio thongTinVe:(NSString *)thongTinVe noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)layThongTinGheNgoiSauKhiChonGheGalaxy:(NSString *)sIdRap idPhim:(NSString *)idPhim idKhungGio:(NSString *)idKhungGio thongTinVe:(NSString *)thongTinVe noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)layThongTinGheNgoiQuocGia:(NSString*)sIdRap idPhim:(NSString*)idPhim idKhungGio:(NSString*)idKhungGio noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)layThongTinGheNgoiGalaxy:(NSString *)sIdRap idPhim:(NSString *)idPhim idKhungGio:(NSString *)idKhungGio noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)muaVeXemPhim:(NSString *)dic noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)muaVeXemPhimQuocGia:(NSString *)dic noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)muaVeXemPhimCGV:(NSString *)dic noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)muaVeXemPhimBHD:(NSString *)dic noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)muaVeXemPhimGalaxy:(NSString *)dic noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)kiemTraNapTienTheQuocTe:(int)nSTT noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)napTienVaoViQuaTheCao:(NSString *)idVi maSoThe:(NSString*)maSoThe serial:(NSString *)serialThe nhaMang:(int)nhaMang noiDung:(NSString *)noiDung noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)napTienVaoViQuaTheQuocTe:(NSDictionary *)dicPost noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)confirmNapTienVaoViQuaTheQuocTe:(NSString *)otp soThuTu:(int)nSTT noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)traCuuTienInternet:(NSString *)maThueBao maNhaCungCap:(int)nMaNhaCungCap user:(NSString *)user noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)layChiTietHoaDonInternet:(NSString *)maHoaDon noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)thanhToanHoaDonInternet:(NSString *)maHoaDon maNhaCungCap:(int)nMaNhaCungCap soTien:(int)soTien token:(NSString *)token otpConfirm:(NSString*)otpComfirm typeAuthenticate:(int)typeAuthenticate noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)thayDoiThongTinViDoanhNghiep:(NSDictionary *)dic noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)ketNoiLayThongTinNgayVang:(int)nNhaMang noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)traCuuDienThoaiTraSau:(NSString *)user soDienThoai:(NSString *)soDienThoai nhaMang:(int)nhaMang noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;
#pragma mark - Thanh toan cuoc dien thoai
+ (void)ketNoiThanhToanNgayVangDienThoaiChoSo:(NSString*)sSoDienThoai
                                maNhaMang:(NSInteger)nNhaMang
                            kieuThanhToan:(int)nKieuThanhToan
                                   soTien:(double)fSoTien
                                    token:(NSString*)sToken
                                      otp:(NSString*)sOtp
                         typeAuthenticate:(int)nTypeAuthenticate
                            noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)ketNoiThanhToanCuocDienThoaiChoSo:(NSString*)sSoDienThoai
                                maNhaMang:(NSInteger)nNhaMang
                            kieuThanhToan:(int)nKieuThanhToan
                                   soTien:(double)fSoTien
                                    token:(NSString*)sToken
                                      otp:(NSString*)sOtp
                         typeAuthenticate:(int)nTypeAuthenticate
                            noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;


+ (void)ketNoiMuaTheCaoThuocNhaMang:(NSInteger)nNhaMang
                             soTien:(double)fSoTien
                            soLuong:(int)nSoLuong
                              token:(NSString*)sToken
                                otp:(NSString*)sOtp
                   typeAuthenticate:(int)nTypeAuthenticate
                      noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)ketNoiLayChiTietTinMuaTheCao:(NSString*)sIdTin
                       noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)ketNoiTraCuuThanhToanDienThoaiViettel:(NSString*)sSoDienThoaiCanTraCuu
                                noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

#pragma mark - Lay danh sach qua tang
+ (void)ketNoiLayDanhSachQuaTang:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)ketNoiTaoQuaTangDen:(NSString*)sToAcc
                   thoiGian:(long)nThoiGianTangQua
                     soTien:(double)fSoTien
             sTieuDeQuaTang:(NSString*)sTieuDe
                   sLoiChuc:(NSString*)sLoiChuc
                     idIcon:(int)nIdIcon
                      token:(NSString*)sToken
                        otp:(NSString*)sOtp
           typeAuthenticate:(int)nTypeAuthenticate
              noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)ketNoiTaoKhuyenMaiDen:(NSString*)sToAcc
                   thoiGian:(long)nThoiGianTangQua
                     soTien:(double)fSoTien
               sTieuDeQuaTang:(NSString*)sTieuDe
                     sLoiChuc:(NSString*)sLoiChuc
                     idIcon:(int)nIdIcon
                        token:(NSString*)sToken
                          otp:(NSString*)sOtp
             typeAuthenticate:(int)nTypeAuthenticate
                noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;


+ (void)ketNoiLaySaoKeQuaTangBoiID:(NSNumber*)idIcon
                     noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

#pragma mark - Lay trang thai su dung khuyen mai
+ (void)ketNoiLayGuiTrangThaiSuDungKhuyenMai:(NSString*)secssion
                                   trangThai:(BOOL)bTrangThai
                               noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

#pragma mark - Sao ke
+ (void)ketNoiLaySaoKeTangQua:(long long)nThoiGianBatDau
              thoiGianKetThuc:(long long)nThoiGianKetThuc
                  viTribatDau:(int)nViTriBatDau
                      gioiHan:(int)nGioiHan
                      kieuLay:(int)nKieu //tang qua hay nhan qua
              typeTransaction:(int)typeTransaction //mac dinh = 0
                noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)ketNoiLaySaoKeKhuyenMai:(long long)nThoiGianBatDau
                thoiGianKetThuc:(long long)nThoiGianKetThuc
                    viTribatDau:(int)nViTriBatDau
                        gioiHan:(int)nGioiHan
                        kieuLay:(int)nKieu //tang qua hay nhan qua
                typeTransaction:(int)typeTransaction //mac dinh = 0
                  noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)ketNoiLaySaoKeVi:(long long)nThoiGianBatDau
         thoiGianKetThuc:(long long)nThoiGianKetThuc
             viTribatDau:(int)nViTriBatDau
                 gioiHan:(int)nGioiHan
                 kieuLay:(int)nKieu //tang qua hay nhan qua
           noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)ketNoiGuiMailSaoKeDen:(NSString*)sTaiKhoan
                        email:(NSString*)sEmail
                       tuNgay:(long)nTuNgay
                      denNgay:(long)nDenNgay
                noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;


+ (void)ketNoiGuiMailSaoKeDen:(NSString*)sEmail
                   tieuDeMail:(NSString*)sTieuDe
                      noiDung:(NSString*)sNoiDung
                noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

#pragma mark - Lay so du tai khoan
+ (void)ketNoiLaySoDuTaiKhoan:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;


#pragma mark - Chuyen tien

+ (void)ketNoiChuyenTienDenViMomo:(NSString*)sTaiKhoan
                           soTien:(double)fSoTien
                          noiDung:(NSString*)sNoiDung
                       nhaCungCap:(int)nNhaCungCap
                            token:(NSString*)sToken
                              otp:(NSString*)sOtp
                 typeAuthenticate:(int)nTypeAuthenticate
                    noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;



+ (void)ketNoiChuyenTienDenVi:(NSString*)sDenVi
                       soTien:(double)fSoTien
                      noiDung:(NSString*)sNoiDung
                        token:(NSString*)sToken
                          otp:(NSString*)sOtp
             typeAuthenticate:(int)nTypeAuthenticate
                noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;



+ (void)ketNoiChuyenTienDenViChuaDangKy:(NSString*)sTenViChuaDangKy
                          noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)ketNoiChuyenTienDenThe:(NSString*)sSoThe
                        soTien:(double)fSoTien
                         token:(NSString*)sToken
                           otp:(NSString*)sOtp
              typeAuthenticate:(int)nTypeAuthenticate
                 noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)ketNoiChuyenTienDenTaiKhoanNganHang:(NSString*)sSoTaiKhoan
                                   bankCode:(NSString*)sBankCode
                             tenChuTaiKhoan:(NSString*)sTenChuTaiKhoan
                          noiDungChuyenTien:(NSString*)sNoiDung
                                     soTien:(double)fSoTien
                                      token:(NSString*)sToken
                                        otp:(NSString*)sOtp
                           typeAuthenticate:(int)nTypeAuthenticate
                              noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)ketNoiChuyenTienDenTaiKhoanNganHangThemChiNhanh:(NSString*)sSoTaiKhoan
                                               bankCode:(NSString*)sBankCode
                                              brachName:(NSString*)sBrachName
                                              brachCode:(NSString*)sBrachCode
                                         tenChuTaiKhoan:(NSString*)sTenChuTaiKhoan
                                      noiDungChuyenTien:(NSString*)sNoiDung
                                                 soTien:(double)fSoTien
                                                  token:(NSString*)sToken
                                                    otp:(NSString*)sOtp
                                       typeAuthenticate:(int)nTypeAuthenticate
                                          noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)ketNoiChuyenTienDenTanNhaCho:(NSString*)sTenNguoiThuHuong
            soDienThoaiNguoiThuHuong:(NSString*)sSoDienThoai
                              soTien:(double)fSoTien
                 soCMNDNguoiThuHuong:(NSString*)sSoCMND
                           tinhThanh:(NSString*)sTinhThanh
                           quanHuyen:(NSString*)sQuanHuyen
                            phuongXa:(NSString*)sPhuongXa
                              diaChi:(NSString*)sDiaChi
                             noiDung:(NSString*)sNoiDung
                               token:(NSString*)sToken
                                 otp:(NSString*)sOtp
                    typeAuthenticate:(int)nTypeAuthenticate
                       noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

#pragma mark - Thuong dung

+ (void)ketNoiLayDanhSachTaiKhoanThuongDung:(int)nKieuLay noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;
+ (void)ketNoiXoaTaiKhoanThuongDung:(NSString*)sID
                            kieuLay:(int)nKieuLay
                              token:(NSString*)sToken
                                otp:(NSString*)sOtp
                   typeAuthenticate:(int)nTypeAuthenticate
                      noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;
+ (void)ketNoiDangKyThongBaoDinhKy:(NSString *)json noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;
+ (void)ketNoiHuyThongBaoDinhKy:(NSString *)json noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;
#pragma mark - Muon tien

+(void)ketNoiLayChiTietTinMuonTien:(NSString*)sIdTin
                     noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)ketNoiMuonTienTaiKhoan:(NSString*)sTaiKhoanMuonTien
                       noiDung:(NSString*)sNoiDung
                        soTien:(double)fSoTien
                         token:(NSString*)sToken
                           otp:(NSString*)sOtp
              typeAuthenticate:(int)nTypeAuthenticate
                 noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;


#pragma mark - Thanh toan & tra cuu tien dien
+ (void)ketNoiTraCuuHoaDonTienDien:(int)nKieuThanhToan
                       maKhachHang:(NSString*)sMaKhachHang
                          secssion:(NSString*)secssion
                     noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)ketNoiLayChiTietThongTinTraCuuHoaDon:(NSString*)sMaGiaoDich
                               noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)ketNoithanhToanHoaDonDienKieuThanhToan:(int)nKieuThanhToan
                                   maKhachHang:(NSString*)sMaKhachHang
                                        soTien:(double)fSoTien
                                       noiDung:(NSString*)sNoiDungThanhToan
                             soDienThoaiLienHe:(NSString*)sSoDienThoaiLienHe
                                      maHoaDon:(NSString*)sMaHoaDon
                                   kyThanhToan:(NSString*)sKyThanhToan
                                         token:(NSString*)sToken
                                           otp:(NSString*)sOtp
                              typeAuthenticate:(int)nTypeAuthenticate
                                 noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

#pragma mark - Nap tien tu the ngan hang
+ (void)ketNoiNapTienTuTheNganHangKieuRedirectSoTienNap:(double)fSoTienNap
                                                noiDung:(NSString*)sNoiDung
                                               viCanNap:(NSString*)sViNap
                                        nganHangLuaChon:(NSString*)selected_bank
                                          noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)ketNoiNapTienTuTheNganHangKieuDirectSoTienNap:(double)fSoTienNap
                                              noiDung:(NSString*)sNoiDung
                                             viCanNap:(NSString*)sViNap
                                      nganHangLuaChon:(NSString*)selected_bank
                                           otpGetType:(NSString*)otpGetType
                                           cardNumber:(NSString*)cardNumber
                                             cardName:(NSString*)cardName
                                            cardMonth:(NSString*)cardMonth
                                             cardYear:(NSString*)cardYear
                                        noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)ketNoiNapTienTuTheNganHangKieuDirectTheLuu:(double)fSoTienNap idTheLuu:(NSString*)idTheLuu
                                              noiDung:(NSString*)sNoiDung
                                             viCanNap:(NSString*)sViNap
                                      nganHangLuaChon:(NSString*)selected_bank
                                           otpGetType:(NSString*)otpGetType
                                           cardNumber:(NSString*)cardNumber
                                             cardName:(NSString*)cardName
                                            cardMonth:(NSString*)cardMonth
                                             cardYear:(NSString*)cardYear
                                        noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)ketNoiXacNhanOTPSauKhiNapTienKieuDirect:(NSString*)sIdOtp
                                            otp:(NSString*)sOtp
                                     otpGetType:(NSString*)otpGetType
                                  noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

#pragma mark - Dang nhap, dang ky,

+ (void)ketNoiDangKyTaiKhoanViViMASS:(NSString*)sTaiKhoan
                             matKhau:(NSString*)sMatKhau
                           nameAlias:(NSString*)sNameAlias
                               email:(NSString*)sEmail
                       noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)ketNoiDangNhapTaiKhoanViViMASS:(NSString*)sTaiKhoan
                               matKhau:(NSString*)sMatKhau
                         maDoanhNghiep:(NSString*)sMaDoanhNghiep
                         noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

#pragma mark - Mua the tro choi dien tu
+ (void)ketNoiMuaTheTroChoiDienTu:(NSNumber*)nhaCungCap
                           soTien:(double)fSoTien
                            token:(NSString*)sToken
                              otp:(NSString*)sOtp
                 typeAuthenticate:(int)nTypeAuthenticate
                    noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)ketNoiNapTienTroChoiDienTu:(NSNumber*)nhaCungCap sLoaiGame:(NSString *)loaiGame 
                         taiKhoan:(NSString*)taiKhoan
                           soTien:(double)fSoTien
                            token:(NSString*)sToken
                              otp:(NSString*)sOtp
                 typeAuthenticate:(int)nTypeAuthenticate
                    noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

#pragma mark - Gui tiet kiem
+ (void)ketNoiGuiTienTietKiemTaiNganHang:(NSString*)sMaNganHang
                                  soTien:(double)fSoTien
                        cachThucQuayVong:(int)nCachThucQuayVong
                                   kyHan:(NSString*)sKyHan
                               kyLinhLai:(int)nKyLinhLai
                             tenNguoiGui:(NSString*)sTenNguoiGui
                                   soCmt:(NSString*)soCMT
                                  diaChi:(NSString*)sDiaChi
                            kieuNhanTien:(NSInteger)nKieuNhanTien
                      maNganHangNhanTien:(NSString*)sMaNganHangNhanTien
                          tenChuTaiKhoan:(NSString*)sTenChuTaiKhoan
                              soTaiKhoan:(NSString*)sSoTaiKhoan
                                   token:(NSString*)sToken
                                     otp:(NSString*)sOtp
                        typeAuthenticate:(int)nTypeAuthenticate
                           noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)ketNoiLayDanhSachSoTietKiem:(NSString*)secssion
                      noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)ketNoiRutSoTietKiem:(NSString*)sSoSoTietKiem
                      token:(NSString*)sToken
                        otp:(NSString*)sOtp
           typeAuthenticate:(int)nTypeAuthenticate
              noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)ketNoiLayDanhSachNganHangGuiTietKiem:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;


+ (NSData*)ketNoiLayChiTietSoTietKiem:(NSString*)sMaSoSo
                             secssion:(NSString*)secssion
                  dinhDanhDoanhNghiep:(NSString*)sDinhDanhDoanhNghiep;

#pragma mark - Duyệt giao dịch
+ (void)ketNoiLayDanhSachDuyetGiaoDichTuNgay:(long long)nTuNgay
                                     denNgay:(long long)nDenNgay
                                       viTri:(int)nViTriBatDauLay
                                     soLuong:(int)nSoLuongGiaoDichCanLay
                               noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)ketNoiLayChiTietDuyetGiaoDich:(NSString*)sMaGiaoDich
                        noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)ketNoiHuyDuyetGiaoDich:(NSArray*)dsMaGiaoDich
                      chucNang:(int)nFuncID
                 maDoanhNghiep:(NSString*)sMaDoanhNghiep
                       noiDung:(NSString*)sNoiDungHuy
                         token:(NSString*)sToken
                           otp:(NSString*)sOtp
              typeAuthenticate:(int)nTypeAuthenticate
                 noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)ketNoiDuyetGiaoDich:(NSArray*)dsMaGiaoDich
                   chucNang:(int)nFuncID
                    noiDung:(NSString*)sNoiDungHuy
              maDoanhNghiep:(NSString*)sMaDoanhNghiep
                      token:(NSString*)sToken
                        otp:(NSString*)sOtp
           typeAuthenticate:(int)nTypeAuthenticate
              noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)ketNoiLayDanhSachDiaDiem:(NSString*)keyword langId:(int)langId limit:(int)limit page:(int)page status:(int)status compress:(int)compress lat:(double)lat lng:(double)lng r:(double)r categoryId:(NSString*)categoryId noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;


+ (void)chuyentienDienThoai:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)confirmChuyenTienDienThoai:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)chuyentienDienThoai:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

+ (void)traCuuSoTay:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;
+ (void)xoaSoTay:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;
+ (void)suaThongTinSoTay:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua;

@end
