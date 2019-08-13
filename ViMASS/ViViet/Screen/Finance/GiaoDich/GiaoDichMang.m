//
//  KetNoi.m
//  ViViMASS
//
//  Created by DucBT on 3/24/15.
//
//

#import "JSONKit.h"
#import "GiaoDichMang.h"
#import "DucNT_LuuRMS.h"
#import "Common.h"

@implementation GiaoDichMang

#define URL_TRA_CUU_INTERNET [NSString stringWithFormat:@"%@%@", ROOT_URL, @"ThanhToanInternetService/traCuuHoaDon"]
#define URL_CHI_TIET_HOA_DON_INTERNET [NSString stringWithFormat:@"%@%@", ROOT_URL, @"ThanhToanInternetService/layChiTietGiaoDichThanhToanInternet"]
#define URL_THANH_TOAN_HOA_DON_INTERNET [NSString stringWithFormat:@"%@%@", ROOT_URL, @"ThanhToanInternetService/thanhToanHoaDon"]

#define URL_THAY_DOI_VI_DOANH_NGHIEP [NSString stringWithFormat:@"%@%@", ROOT_URL, @"account/editAcc1"]

//URL Mua the cao, thanh toan tien dien thoai
#define URL_THANH_TOAN_TIEN_DIEN_THOAI [NSString stringWithFormat:@"%@%@", ROOT_URL, @"billing/cellphone"]
#define URL_THANH_TOAN_TIEN_DIEN_THOAI_NGAY_VANG [NSString stringWithFormat:@"%@%@", ROOT_URL, @"DatThanhToanDienThoaiService/datGiaoDich"]
#define URL_MUA_THE_CAO [NSString stringWithFormat:@"%@%@", ROOT_URL, @"billing/buyCard"]
#define URL_TRA_CUU_DIEN_THOAI_TRA_SAU [NSString stringWithFormat:@"%@%@", ROOT_URL, @"billing/searchDt"]

#define URL_LAY_CHI_TIET_TIN_MUA_THE_CAO [NSString stringWithFormat:@"%@%@", ROOT_URL, @"billing/getChiTietKetQuaMuaTheCao"]
#define URL_TRA_CUU_THONG_TIN_THANH_TOAN_DIEN_THOAI_VIETTEL [NSString stringWithFormat:@"%@%@", ROOT_URL, @"billing/searchViettel"]

#define URL_LAY_THONG_TIN_NGAY_VANG [NSString stringWithFormat:@"%@%@", ROOT_URL, @"DatThanhToanDienThoaiService/layTinKhuyenMai"]

//URL tao qua tang
#define URL_LAY_DANH_SACH_QUA_TANG [NSString stringWithFormat:@"%@%@", ROOT_URL, @"icon/admGetIcon"]
#define URL_TAO_QUA_TANG [NSString stringWithFormat:@"%@%@", ROOT_URL, @"gift/createGift"]
#define URL_TAO_QUA_TANG_KHUYEN_MAI [NSString stringWithFormat:@"%@%@", ROOT_URL, @"promotion/createPromotion"]
#define URL_LAY_QUA_TANG_BOI_ID [NSString stringWithFormat:@"%@%@", ROOT_URL, @"icon/getIconById"]

//URL sao ke
#define URL_LAY_DANH_SACH_SAO_KE_QUA_TANG [NSString stringWithFormat:@"%@%@", ROOT_URL, @"gift/getListGift"]
#define URL_LAY_DANH_SACH_SAO_KE_KHUYEN_MAI [NSString stringWithFormat:@"%@%@", ROOT_URL, @"promotion/getListPromotion"]
#define URL_LAY_DANH_SACH_SAO_KE_VI [NSString stringWithFormat:@"%@%@", ROOT_URL, @"account/inquiry1"]
#define URL_LAY_SO_DU_VI [NSString stringWithFormat:@"%@%@", ROOT_URL, @"account/getAmount"]
#define URL_GUI_SAO_KE_VE_EMAIL [NSString stringWithFormat:@"%@%@", ROOT_URL, @"account/sendInquiryToEmail"]

#define URL_GUI_SAO_KE_DON_VE_EMAIL @"http://113.190.248.142:58080/email/services/email/sendEmail"


//URL chuyen tien
#define URL_THAY_DOI_HAN_MUC_MOI [NSString stringWithFormat:@"%@%@", ROOT_URL, @"hanMucViDienTu/edit"]
#define URL_CHUYEN_TIEN_DEN_VI [NSString stringWithFormat:@"%@%@", ROOT_URL, @"account/transactionMoney1"]
#define URL_CHUYEN_TIEN_DEN_VI_CHUA_DANG_KY [NSString stringWithFormat:@"%@%@", ROOT_URL, @"account/confirmTransactionMoneyToAccNotExist"]
#define URL_CHUYEN_TIEN_DEN_THE [NSString stringWithFormat:@"%@%@", ROOT_URL, @"autoBank/transactionViaCardNumber"]
#define URL_CHUYEN_TIEN_DEN_TAI_KHOAN_NGAN_HANG [NSString stringWithFormat:@"%@%@", ROOT_URL, @"autoBank/transactionToBank"]

#define URL_CHUYEN_TIEN_DEN_TAN_NHA_BANK_PLUS [NSString stringWithFormat:@"%@%@", ROOT_URL, @"bankPlus/chuyenTienMat"]

#define URL_THAY_DOI_TRANG_THAI_SU_DUNG_KHUYEN_MAI [NSString stringWithFormat:@"%@%@", ROOT_URL, @"promotion/editStatusPromotion"]

#define URL_CHUYEN_TIEN_DEN_VI_MOMO [NSString stringWithFormat:@"%@%@", ROOT_URL, @"napTienDienTu/napTien"]

#define URL_LAY_DANH_SACH_TAI_KHOAN_THUONG_DUNG [NSString stringWithFormat:@"%@%@", ROOT_URL, @"account/searchAccUsed"]
#define URL_XOA_TAI_KHOAN_THUONG_DUNG [NSString stringWithFormat:@"%@%@", ROOT_URL, @"account/deleteAccUsed"]
#define URL_DANG_KY_THONG_BAO_DINH_KY [NSString stringWithFormat:@"%@%@", ROOT_URL, @"thongBaoThanhToanHoaDon/reg"]
#define URL_HUY_THONG_BAO_DINH_KY [NSString stringWithFormat:@"%@%@", ROOT_URL, @"thongBaoThanhToanHoaDon/reject"]

//URL muon tien
#define URL_LAY_CHI_TIET_TIN_MUON_TIEN [NSString stringWithFormat:@"%@%@", ROOT_URL, @"loan/getLoanById"]
#define URL_MUON_TIEN_TAI_KHOAN [NSString stringWithFormat:@"%@%@", ROOT_URL, @"loan/loanRequest"]

//URL Thanh toan, tra cuu hoa don tien dien
#define URL_LAY_CHI_TIET_THONG_TIN_TRA_CUU_HOA_DON [NSString stringWithFormat:@"%@%@", ROOT_URL, @"billing/getChiTietThongTinTraCuuHoaDon"]
#define URL_TRA_CUU_HOA_DON [NSString stringWithFormat:@"%@%@", ROOT_URL, @"billing/traCuuHoaDon"]
#define URL_THANH_TOAN_HOA_DON_DIEN [NSString stringWithFormat:@"%@%@", ROOT_URL, @"billing/thanhToanHoaDon"]

//URL nap tien tu the
#define URL_NAP_TIEN_TU_THE_KIEU_REDIRECT [NSString stringWithFormat:@"%@%@", ROOT_URL, @"banknet/redirectAddMoney"]
#define URL_NAP_TIEN_TU_THE_KIEU_DIRECT [NSString stringWithFormat:@"%@%@", ROOT_URL, @"banknet/directAddMoney"]
#define URL_XAC_NHAN_OTP_SAU_KHI_NAP_TIEN_KIEU_DIRECT [NSString stringWithFormat:@"%@%@", ROOT_URL, @"banknet/directAddMoneyVerifyOTP"]

//URL dang nhap, dang ky
#define URL_DANG_KY_TAI_KHOAN_THE_VID [NSString stringWithFormat:@"%@%@", ROOT_URL, @"vIdService/dangKy"]
#define URL_XAC_THUC_TAI_KHOAN_THE_VID [NSString stringWithFormat:@"%@%@", ROOT_URL, @"vIdService/xacThucDangKy"]
#define URL_DANG_KY_TAI_KHOAN_VI_VIMASS [NSString stringWithFormat:@"%@%@", ROOT_URL, @"account/createNewAcc1"]
#define URL_DANG_NHAP_TAI_KHOAN_VI_VIMASS [NSString stringWithFormat:@"%@%@", ROOT_URL, @"account/login1"]
#define URL_DANG_NHAP_THE_DA_NANG [NSString stringWithFormat:@"%@%@", ROOT_URL, @"vIdService/dangNhap"]

//URL mua the tro choi dien tu
#define URL_MUA_THE_TRO_CHOI_DIEN_TU [NSString stringWithFormat:@"%@%@", ROOT_URL, @"game/buyCard"]
#define URL_NAP_TIEN_TRO_CHOI_DIEN_TU [NSString stringWithFormat:@"%@%@", ROOT_URL, @"napTienDienTu/napTien"]
//URL guiTietKiem
#define URL_GUI_TIEN_TIET_KIEM [NSString stringWithFormat:@"%@%@", ROOT_URL, @"tietKiem/guiTietKiem"]
#define URL_TRA_CUU_DANH_SACH_SO_TIET_KIEM [NSString stringWithFormat:@"%@%@", ROOT_URL, @"tietKiem/danhSachSoTietKiem"]
#define URL_RUT_SO_TIET_KIEM [NSString stringWithFormat:@"%@%@", ROOT_URL, @"tietKiem/rutSoTietKiem"]
#define URL_LAY_DANH_SACH_NGAN_HANG_GUI_TIET_KIEM [NSString stringWithFormat:@"%@%@", ROOT_URL, @"tietKiem/getLaiSuatForMobile"]
#define URL_LAY_CHI_TIET_SO_TIET_KIEM [NSString stringWithFormat:@"%@%@", ROOT_URL, @"tietKiem/chiTietSoTietKiemTheoSoSo"]

//URL duyetGiaoDich
#define URL_LAY_DANH_SACH_DUYET_GIAO_DICH [NSString stringWithFormat:@"%@%@", ROOT_URL, @"company/danhSachGiaoDich"]
#define URL_LAY_CHI_TIET_DUYET_GIAO_DICH [NSString stringWithFormat:@"%@%@", ROOT_URL, @"company/chiTietGiaoDich"]

#define URL_HUY_DUYET_GIAO_DICH [NSString stringWithFormat:@"%@%@", ROOT_URL, @"company/huyGiaoDich"]
#define URL_DUYET_GIAO_DICH [NSString stringWithFormat:@"%@%@", ROOT_URL, @"company/duyetGiaoDich"]

//URL nap tien quoc te
#define URL_NAP_TIEN_THE_QUOC_TE [NSString stringWithFormat:@"%@%@", ROOT_URL, @"VisaMasterService/napVi"]
#define URL_CONFIRM_NAP_TIEN_THE_QUOC_TE [NSString stringWithFormat:@"%@%@", ROOT_URL, @"VisaMasterService/confirmOTPNapVi"]
#define URL_NAP_TIEN_THE_CAO [NSString stringWithFormat:@"%@%@", ROOT_URL, @"TheCaoDienThoaiService/napViTuTheCao"]
#define URL_KIEM_TRA_NAP_TIEN_QUOC_TE [NSString stringWithFormat:@"%@%@", ROOT_URL, @"VisaMasterService/checkResult"]
//#define URL_LAY_DANH_SACH_RAP_PHIM [NSString stringWithFormat:@"%@%@", ROOT_URL, @"vePhim/getRapPhim"]
#define URL_LAY_DANH_SACH_RAP_PHIM [NSString stringWithFormat:@"%@%@", ROOT_URL, @"vePhim/getFull"]
#define URL_LAY_DANH_SACH_RAP_PHIM_THEO_TEN_KHU_VUC [NSString stringWithFormat:@"%@%@", ROOT_URL, @"vePhim/getRapVaPhimCuaThanhPho?thanhPho=%@&tenPhimSearch=%@"]
#define URL_LAY_DANH_SACH_PHIM [NSString stringWithFormat:@"%@%@", ROOT_URL, @"vePhim/getPhimDangChieuCuaRap"]
#define URL_LAY_DANH_SACH_RAP_PHIM_THEO_TINH [NSString stringWithFormat:@"%@%@", ROOT_URL, @"vePhim/getRapVaPhimCuaThanhPho"]
#define URL_LAY_DANH_SACH_THOI_DIEM_PHIM [NSString stringWithFormat:@"%@%@", ROOT_URL, @"vePhim/getLichChieuPhim"]
#define URL_LAY_DANH_SACH_THOI_DIEM_PHIM_BHD [NSString stringWithFormat:@"%@%@", ROOT_URL, @"vePhim/layDanhSachVePhimBHD"]
#define URL_LAY_DANH_SACH_THONG_TIN_GHE_BHD [NSString stringWithFormat:@"%@%@", ROOT_URL, @"vePhim/layDanhSachGheTrongBHDVer2"]
#define URL_LAY_DANH_SACH_THONG_TIN_GHE [NSString stringWithFormat:@"%@%@", ROOT_URL, @"vePhim/getGheNgoiCuaPhim"]
#define URL_LAY_DANH_SACH_THONG_TIN_GHE_QUOC_GIA [NSString stringWithFormat:@"%@%@", ROOT_URL, @"vePhim/layDanhSachGheTrongCuaPhimNCC"]
#define URL_LAY_DANH_SACH_THONG_TIN_GHE_GALAXY [NSString stringWithFormat:@"%@%@", ROOT_URL, @"vePhim/layDanhSachVePhimGLX"]
#define URL_LAY_DANH_SACH_THONG_TIN_CHO_NGOI_GALAXY [NSString stringWithFormat:@"%@%@", ROOT_URL, @"vePhim/layDanhSachGheTrongGLX"]
#define URL_DAT_VE_XEM_FILM [NSString stringWithFormat:@"%@%@", ROOT_URL, @"vePhim/datVeVer2?"]
#define URL_DAT_VE_XEM_FILM_CGV [NSString stringWithFormat:@"%@%@", ROOT_URL, @"vePhim/datVeCGV"]
#define URL_DAT_VE_XEM_FILM_QUOC_GIA [NSString stringWithFormat:@"%@%@", ROOT_URL, @"vePhim/datVePhimQuocGia"]
#define URL_DAT_VE_XEM_FILM_BHD [NSString stringWithFormat:@"%@%@", ROOT_URL, @"vePhim/datVePhimBHD"]
#define URL_DAT_VE_XEM_FILM_GALAXY [NSString stringWithFormat:@"%@%@", ROOT_URL, @"vePhim/datVePhimGLX"]
#define URL_UPLOAD_ANH_DOANH_NGHIEP [NSString stringWithFormat:@"%@%@", ROOT_URL, @"media/uploadVer2/"]
#define URL_DANG_KY_DOANH_NGHIEP [NSString stringWithFormat:@"%@%@", ROOT_URL, @"account/createNewCompanyAcc"]

//URL ve may bay
#define URL_TRA_CUU_SAN_BAY_DI_DEN [NSString stringWithFormat:@"%@%@", ROOT_URL, @"datVeMayBay/traCuuSanBayDiDen"]
#define URL_TRA_CUU_CHUYEN_BAY [NSString stringWithFormat:@"%@%@", ROOT_URL, @"datVeMayBay/traCuuVeMayBay"]
#define URL_THANH_TOAN_MAY_BAY [NSString stringWithFormat:@"%@%@", ROOT_URL, @"datVeMayBay/yeuCauDatVeMayBay"]
#define URL_CHUYEN_TIEN_ATM [NSString stringWithFormat:@"%@%@", ROOT_URL, @"NhanTienBangDiDong/NhanTienBangDiDong"]

//truyen hinh
#define URL_TRA_CUU_TRUYEN_HINH [NSString stringWithFormat:@"%@%@", ROOT_URL, @"ThanhToanTruyenHinhCapService/traCuuHoaDon"]
#define URL_CHI_TIET_TRUYEN_HINH [NSString stringWithFormat:@"%@%@", ROOT_URL, @"ThanhToanTruyenHinhCapService/layChiTietGiaoDichThanhToanTruyenHinhCap?id="]
#define URL_THANH_TOAN_TRUYEN_HINH [NSString stringWithFormat:@"%@%@", ROOT_URL, @"ThanhToanTruyenHinhCapService/thanhToanHoaDon"]

//hoc phi
#define URL_THANH_TOAN_HOC_PHI [NSString stringWithFormat:@"%@%@", ROOT_URL, @"ThanhToanTruyenHinhCapService/thanhToanHoaDon"]

//chuyen tien cmnd
#define URL_CHUYEN_TIEN_DEN_CMND [NSString stringWithFormat:@"%@%@", ROOT_URL, @"chuyenTienCMND/chuyenTien"]
#define URL_TRA_CUU_TIEN_VAY [NSString stringWithFormat:@"%@%@", ROOT_URL, @"ThanhToanTienVayService/traCuuHoaDon"]
#define URL_LAY_CHI_TIET_TIEN_VAY [NSString stringWithFormat:@"%@%@", ROOT_URL, @"ThanhToanTienVayService/layChiTietGiaoDichThanhToanTienVay?id="]
#define URL_THANH_TOAN_TIEN_VAY [NSString stringWithFormat:@"%@%@", ROOT_URL, @"ThanhToanTienVayService/thanhToanHoaDon"]

//tai khoan lien ket
#define URL_LAY_TAI_KHOAN_LIEN_KET [NSString stringWithFormat:@"%@%@", ROOT_URL, @"lienKetTK/getDanhSach"]
#define URL_TAO_TAI_KHOAN_LIEN_KET [NSString stringWithFormat:@"%@%@", ROOT_URL, @"lienKetTK/dangKy"]
#define URL_EDIT_TAI_KHOAN_LIEN_KET [NSString stringWithFormat:@"%@%@", ROOT_URL, @"lienKetTK/edit"]
#define URL_XOA_TAI_KHOAN_LIEN_KET [NSString stringWithFormat:@"%@%@", ROOT_URL, @"lienKetTK/huy"]

//tra cuu ve may bay
#define URL_TRA_CUU_TRANG_THAI_VE_MAY_BAY [NSString stringWithFormat:@"%@%@", ROOT_URL, @"datVeMayBay/traCuuTrangThaiDatVeMayBay?id="]
#define URL_TRA_CUU_TRANG_THAI_MUA_VE_MAY_BAY_GIA_CAO [NSString stringWithFormat:@"%@%@", ROOT_URL, @"datVeMayBay/yeuCauDatVeMayBayGiaCao"]

//Tra cu qrcode
#define URL_TRA_CUU_SAN_PHAM_QRCODE [NSString stringWithFormat:@"%@%@", ROOT_URL, @"paymentGateway/layChiTietThongTinSanPhamDaiLy?maSo="]
#define URL_TRA_CUU_DON_VI_QRCODE [NSString stringWithFormat:@"%@%@", ROOT_URL, @"paymentGateway/layThongTinDaiLy?maDaiLy="]
#define URL_TRA_CUU_VI_QRCODE [NSString stringWithFormat:@"%@%@", ROOT_URL, @"account/traCuuThongTinMaQR?maQR="]
#define URL_CHUYEN_TIEN_VI_QRCODE [NSString stringWithFormat:@"%@%@", ROOT_URL, @"account/thanhToanQR"]
#define URL_CHUYEN_TIEN_DON_VI_QRCODE [NSString stringWithFormat:@"%@%@", ROOT_URL, @"paymentGateway/thanhToanTienChoDaiLy"]
#define URL_CHUYEN_TIEN_MUA_SAN_PHAM_QRCODE [NSString stringWithFormat:@"%@%@", ROOT_URL, @"paymentGateway/paymentVimassPort"]

#define URL_DANG_KY_QR_DON_VI [NSString stringWithFormat:@"%@%@", ROOT_URL, @"paymentGateway/dangKyDonViNhanThanhToan"]
#define URL_SUA_QR_SON_VI [NSString stringWithFormat:@"%@%@", ROOT_URL, @"paymentGateway/thayDoiThongTinDonViNhanThanhToan"]
#define URL_DANG_KY_QR_SAN_PHAM [NSString stringWithFormat:@"%@%@", ROOT_URL, @"paymentGateway/themSanPham"]
#define URL_XAC_THUC_QR_DON_VI [NSString stringWithFormat:@"%@%@", ROOT_URL, @"paymentGateway/confirmDangKyDonViNhanThanhToan"]
#define URL_LAY_DANH_SACH_QR_DON_VI [NSString stringWithFormat:@"%@%@", ROOT_URL, @"paymentGateway/traCuuDonViBanCuaVi"]
#define URL_LAY_THONG_TIN_QR_DON_VI [NSString stringWithFormat:@"%@%@", ROOT_URL, @"paymentGateway/layThongTinDaiLy?maDaiLy="]
#define URL_LAY_OTP_TAO_SUA_QR_DON_VI [NSString stringWithFormat:@"%@%@", ROOT_URL, @"paymentGateway/getOtpConfirm"]
#define URL_XOA_QR_DON_VI [NSString stringWithFormat:@"%@%@", ROOT_URL, @"paymentGateway/xoaThongTinDonViNhanThanhToan"]
#define URL_SUA_QR_SAN_PHAM [NSString stringWithFormat:@"%@%@", ROOT_URL, @"paymentGateway/editSanPham"]
#define URL_XOA_QR_SAN_PHAM [NSString stringWithFormat:@"%@%@", ROOT_URL, @"paymentGateway/xoaSanPham"]
#define URL_TRA_CUU_K_PLUS [NSString stringWithFormat:@"%@%@", ROOT_URL, @"ThanhToanKPlusService/traCuuHoaDon"]
#define URL_THANH_TOAN_K_PLUS [NSString stringWithFormat:@"%@%@", ROOT_URL, @"ThanhToanKPlusService/thanhToanHoaDon"]
#define URL_DANG_KY_PKI [NSString stringWithFormat:@"%@%@", ROOT_URL, @"auth1/createUserPKI"]
#define URL_XAC_NHAN_DANG_KY_PKI [NSString stringWithFormat:@"%@%@", ROOT_URL, @"auth1/confirmCreateUserPKI"]
#define URL_CAI_DAT_HAN_MUC_PKI [NSString stringWithFormat:@"%@%@", ROOT_URL, @"auth1/caiDatHanMucPKI"]
#define URL_DOI_MAT_KHAU_PKI [NSString stringWithFormat:@"%@%@", ROOT_URL, @"auth1/caiDatHanMucPKI"]

#define URL_DOI_MAT_KHAU_PKI [NSString stringWithFormat:@"%@%@", ROOT_URL, @"auth1/caiDatHanMucPKI"]
#define URL_DOI_MAT_KHAU_PKI [NSString stringWithFormat:@"%@%@", ROOT_URL, @"auth1/caiDatHanMucPKI"]
#define URL_LAY_TIN_TUC [NSString stringWithFormat:@"%@%@", ROOT_URL, @"categoryAdv/getDetail"]
#define URL_LAY_CHI_TIET_TIN_TUC [NSString stringWithFormat:@"%@%@", ROOT_URL, @"quangCaoUuDai/getDetail"]
#define URL_LAY_THONG_TIN_QR [NSString stringWithFormat:@"%@%@", ROOT_URL, @"QRVietNam/traCuuThongTinQR"]
#define URL_THANH_TOAN_VNPAY_QR [NSString stringWithFormat:@"%@%@", ROOT_URL, @"QRVietNam/thanhToanVNPayQR"]
#define URL_TIM_DIA_DIEM_VNPAY_QR [NSString stringWithFormat:@"%@%@", ROOT_URL, @"QRVietNam/traCuuDiemGiaoDichVNPAY"]

+ (void)ketNoiConfirmDangKyTheDaNang:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_XAC_THUC_TAI_KHOAN_THE_VID withContent:dictJSON];
    [connectPost release];
}

+ (void)ketNoiDangKyTheDaNang:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_DANG_KY_TAI_KHOAN_THE_VID withContent:dictJSON];
    [connectPost release];
}

+ (void)ketNoiLayDanhSachDiaDiemVNPAY:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_TIM_DIA_DIEM_VNPAY_QR withContent:dictJSON];
    [connectPost release];
}

+ (void)ketNoiThanhToanVNPayQR:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_THANH_TOAN_VNPAY_QR withContent:dictJSON];
    [connectPost release];
}

+ (void)ketNoiLayThongTinQR:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_LAY_THONG_TIN_QR withContent:dictJSON];
    [connectPost release];
}

+ (void)ketNoiLayTinTuc:(int)langID idInput:(NSString *)idInput noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    NSDictionary *dic = @{@"langId" : [NSNumber numberWithInt:langID],
                          @"id" : idInput
                          };
    NSLog(@"%s - dic : %@", __FUNCTION__, [dic JSONString]);
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_LAY_TIN_TUC withContent:[dic JSONString]];
    [connectPost release];
}

+ (void)ketNoiLayChiTietTinTuc:(int)langID sIDTinTuc:(NSString *)sIDTinTuc noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    NSDictionary *dic = @{@"langId" : [NSNumber numberWithInt:langID],
                          @"id" : sIDTinTuc
                          };
    NSLog(@"%s - dic : %@", __FUNCTION__, [dic JSONString]);
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_LAY_CHI_TIET_TIN_TUC withContent:[dic JSONString]];
    [connectPost release];
}

+ (void)traCuuKPlus:(NSString *)maThueBao noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    NSDictionary *dic = @{@"maThueBao" : maThueBao,
                          @"user" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                          };
    NSLog(@"%s - dic : %@", __FUNCTION__, [dic JSONString]);
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_TRA_CUU_K_PLUS withContent:[dic JSONString]];
    [connectPost release];
}

+ (void)thanhToanKPlus:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    NSLog(@"%s - dictJSON : %@", __FUNCTION__, dictJSON);
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_THANH_TOAN_K_PLUS withContent:[dictJSON JSONString]];
    [connectPost release];
}

+ (void)layMaOTPTaoSuaQRDonVi:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_LAY_OTP_TAO_SUA_QR_DON_VI withContent:dictJSON];
    [connectPost release];
}

+ (void)taoQRDonVi:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_DANG_KY_QR_DON_VI withContent:dictJSON];
    [connectPost release];
}

+ (void)suaQRDonVi:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_SUA_QR_SON_VI withContent:dictJSON];
    [connectPost release];
}

+ (void)taoQRSanPhamCuaDonVi:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    NSLog(@"%s - dictJSON : %@", __FUNCTION__, dictJSON);
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_DANG_KY_QR_SAN_PHAM withContent:dictJSON];
    [connectPost release];
}

+ (void)xacThucOTPTaoQRDonVi:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    NSLog(@"%s - dictJSON : %@", __FUNCTION__, dictJSON);
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_XAC_THUC_QR_DON_VI withContent:dictJSON];
    [connectPost release];
}

+ (void)ketNoiLayDanhSachQRDonVi:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    NSString *session = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_SECSSION];
    NSString *sIDVi = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];

    NSString *sURL = [URL_LAY_DANH_SACH_QR_DON_VI stringByAppendingFormat:@"?idVi=%@&session=%@", sIDVi, session];
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connectGet:sURL withContent:@""];
    [connect release];
}

+ (void)ketNoiLayDanhSachQRSanPham:(NSString *)maDaiLy noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    NSString *sURL = [URL_LAY_THONG_TIN_QR_DON_VI stringByAppendingString:maDaiLy];
    NSLog(@"%s - sURL : %@", __FUNCTION__, sURL);
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connectGet:sURL withContent:@""];
    [connect release];
}

+ (void)upAnhQRSanPham:(NSString *)sURL imageBase64:(NSString *)imageBase64 noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:sURL withContent:imageBase64];
    [connectPost release];
}

+ (void)layThongTinSanPhamQRCode:(NSString *)sIdQRCode noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    NSString *sURL = [URL_TRA_CUU_SAN_PHAM_QRCODE stringByAppendingString:sIdQRCode];
    NSLog(@"%s - sURL : %@", __FUNCTION__, sURL);
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connectGet:sURL withContent:@""];
    [connect release];
}

+ (void)layThongTinDonViQRCode:(NSString *)sIdQRCode noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    NSString *sURL = [URL_TRA_CUU_DON_VI_QRCODE stringByAppendingString:sIdQRCode];
    sURL = [sURL stringByAppendingString:@"&if=1"];
    NSLog(@"%s - sURL : %@", __FUNCTION__, sURL);
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connectGet:sURL withContent:@""];
    [connect release];
}

+ (void)xoaThongTinDaiLy:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_XOA_QR_DON_VI withContent:dictJSON];
    [connectPost release];
}

+ (void)suaThongTinSanPham:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    NSLog(@"%s - dictJSON : %@", __FUNCTION__, dictJSON);
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_SUA_QR_SAN_PHAM withContent:dictJSON];
    [connectPost release];
}

+ (void)xoaThongTinSanPham:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    NSLog(@"%s - dictJSON : %@", __FUNCTION__, dictJSON);
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_XOA_QR_SAN_PHAM withContent:dictJSON];
    [connectPost release];
}

+ (void)layChiTietThongTinDaiLy:(NSString *)maDaiLy noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    NSString *sURL = [URL_TRA_CUU_DON_VI_QRCODE stringByAppendingString:maDaiLy];
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connectGet:sURL withContent:@""];
    [connect release];
}

+ (void)layThongTinViQRCode:(NSString *)sIdQRCode noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    NSString *sURL = [URL_TRA_CUU_VI_QRCODE stringByAppendingString:sIdQRCode];
    NSLog(@"%s - sURL : %@", __FUNCTION__, sURL);
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connectGet:sURL withContent:@""];
    [connect release];
}

+ (void)chuyenTienDenViBangQRCode:(NSString *)jsonDict noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    NSLog(@"%s - jsonDict : %@", __FUNCTION__, jsonDict);
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connect:URL_CHUYEN_TIEN_VI_QRCODE withContent:jsonDict];
    [connect release];
}

+ (void)chuyenTienDenDonViBangQRCode:(NSString *)jsonDict noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    NSLog(@"%s - jsonDict : %@", __FUNCTION__, jsonDict);
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connect:URL_CHUYEN_TIEN_DON_VI_QRCODE withContent:jsonDict];
    [connect release];
}

+ (void)muaSanPhamTuQRCode:(NSString *)jsonDict noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    NSLog(@"%s - jsonDict : %@", __FUNCTION__, jsonDict);
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connect:URL_CHUYEN_TIEN_MUA_SAN_PHAM_QRCODE withContent:jsonDict];
    [connect release];
}

+ (void)traCuuTrangThaiVeMayBay:(NSString *)idShow noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    NSString *sURL = [URL_TRA_CUU_TRANG_THAI_VE_MAY_BAY stringByAppendingString:idShow];
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connectGet:sURL withContent:@""];
    [connect release];
}

+ (void)muaVeMayBayGiaCao:(NSString *)idDatVe token:(NSString *)token otpConfirm:(NSString*)otpComfirm typeAuthenticate:(int)typeAuthenticate noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    NSString *sMaDoanhNghiep = @"";
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sMaDoanhNghiep = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_COMPANY_ID];
    }
    NSDictionary *dic = @{
                          @"token" : token,
                          @"otpConfirm" : otpComfirm,
                          @"typeAuthenticate" : [NSNumber numberWithInt:typeAuthenticate],
                          @"user" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                          @"idDat" : idDatVe
                          };
    NSLog(@"%s - dic : %@", __FUNCTION__, [dic JSONString]);
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_TRA_CUU_TRANG_THAI_MUA_VE_MAY_BAY_GIA_CAO withContent:[dic JSONString]];
    [connectPost release];
}

+ (void)layDanhSachTaiKhoanLienKet:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    NSString *sURL = [NSString stringWithFormat:@"%@?idVi=%@&session=%@", URL_LAY_TAI_KHOAN_LIEN_KET, [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP], [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_SECSSION]];
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connectGet:sURL withContent:@""];
    [connect release];
}

+ (void)taoTaiKhoanLienKet:(NSString *)dict noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_TAO_TAI_KHOAN_LIEN_KET withContent:dict];
    [connectPost release];
}

+ (void)editTaiKhoanLienKet:(NSString *)dict noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    NSLog(@"%s - sua tai khoan lien ket : %@", __FUNCTION__, dict);
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_EDIT_TAI_KHOAN_LIEN_KET withContent:dict];
    [connectPost release];
}

+ (void)xoaTaiKhoanLienKet:(NSString *)dict noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_XOA_TAI_KHOAN_LIEN_KET withContent:dict];
    [connectPost release];
}

+ (void)yeuCauNapTienTuTaiKhoanLienKet:(NSString *)idTaiKhoanLienKet session:(NSString *)session soTien:(NSString *)soTien noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua{
    NSString *url = [NSString stringWithFormat:@"https://vimass.vn/vmbank/services/lienKetTK/napTien?id=%@&idVi=%@&session=%@&VMApp=5&soTien=%@", idTaiKhoanLienKet, [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP], [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_SECSSION], soTien];
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connectGet:url withContent:@""];
    [connect release];
}

+ (void)layTrangThaiNapTienTaiKhoanLienKet:(NSString *)idGiaoDich session:(NSString *)session noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    NSString *url = [NSString stringWithFormat:@"https://vimass.vn/vmbank/services/lienKetTK/checkTrangThai?id=%@&idVi=%@&session=%@&VMApp=5", idGiaoDich, [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP], [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_SECSSION]];
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connectGet:url withContent:@""];
    [connect release];
}

+ (void)xacThucYeuCauNapTienTaiKhoanLienKet:(NSString *)idGiaoDich maXacThuc:(NSString *)maXacThuc noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua{
    NSString *url = [NSString stringWithFormat:@"https://vimass.vn/vmbank/services/lienKetTK/maXacThuc?idGiaoDich=%@&idVi=%@&session=%@&VMApp=5&maXacThuc=%@", idGiaoDich, [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP], [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_SECSSION], maXacThuc];
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connectGet:url withContent:@""];
    [connect release];
}

+ (void)huyYeuCauNapTienTaiKhoanLienKet:(NSString *)idGiaoDich noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    NSString *url = [NSString stringWithFormat:@"https://vimass.vn/vmbank/services/lienKetTK/huyYeuCauNapTien?id=%@&idVi=%@&session=%@&VMApp=5", idGiaoDich, [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP], [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_SECSSION]];
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connectGet:url withContent:@""];
    [connect release];
}

+ (void)layDanhSachQuangCao:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    NSLog(@"%s - *************** quang cao wifi", __FUNCTION__);
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connectGet:@"https://vimass.vn/vmbank/services/managerImage/searchImage?type=-1&offset=0&limit=1000&VMApp=1&appId=5&q=1000" withContent:@"" showAlert:NO];
//    [connect connectGet:@"https://vimass.vn/vmbank/services/managerImage/searchImage?type=-1&offset=0&limit=1000&VMApp=1&appId=5&q=0" withContent:@""];

    [connect release];
}

+ (void)layDanhSachQuangCao3G:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    NSLog(@"%s - *************** quang cao 3G", __FUNCTION__);
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connectGet:@"https://vimass.vn/vmbank/services/managerImage/searchImage?type=-1&offset=0&limit=1000&VMApp=1&appId=5&q=1" withContent:@"" showAlert:NO];
//    [connect connectGet:@"https://vimass.vn/vmbank/services/managerImage/searchImage?type=-1&offset=0&limit=1000&VMApp=1&appId=5&q=1" withContent:@""];
    [connect release];
}

+ (void)thanhToanTienChungKhoan : (NSString *)jsonDic noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    NSLog(@"%s - json dic : %@", __FUNCTION__, jsonDic);
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_NAP_TIEN_TRO_CHOI_DIEN_TU withContent:jsonDic];
    [connectPost release];
}

+ (void)thanhToanTraTienVay:(NSString *)jsonDic noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_THANH_TOAN_TIEN_VAY withContent:jsonDic];
    [connectPost release];
}

+ (void)layThongTinChiTietHoaDonTienVay : (NSString *)sIdShow noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    NSString *link = [NSString stringWithFormat:@"%@%@", URL_LAY_CHI_TIET_TIEN_VAY, sIdShow];
    NSLog(@"%s - link : %@", __FUNCTION__, link);
    DucNT_ServicePost *connectGet = [[DucNT_ServicePost alloc] init];
    connectGet.ducnt_connectDelegate = noiNhanKetQua;
    [connectGet connectGet:60 sUrl:link withContent:@""];
    [connectGet release];
}

+ (void)traCuuTienVay:(NSString *)maHopDong cmnd:(NSString *)cmnd maNhaCungCap:(int)maNhaCungCap soTien:(double)soTien noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    NSString *sMaDoanhNghiep = @"";
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sMaDoanhNghiep = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_COMPANY_ID];
    }
    NSDictionary *dic = @{
                          @"maHopDong" : maHopDong,
                          @"maNhaCungCap" :[NSNumber numberWithInt:maNhaCungCap],
                          @"soTien"        :[NSNumber numberWithInt:(int)soTien],
                          @"cmnd" : cmnd,
                          @"user"          :[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                          @"companyCode"   :sMaDoanhNghiep,
                          @"VMApp" : [NSNumber numberWithInt:VM_APP]
                          };
    NSLog(@"%s - dic : %@", __FUNCTION__, [dic JSONString]);
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_TRA_CUU_TIEN_VAY withContent:[dic JSONString]];
    [connectPost release];
}

+ (void)chuyenTienTuThien:(NSString *)sJson noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_CHUYEN_TIEN_DEN_VI_MOMO withContent:sJson];
    [connectPost release];
}

+ (void)chuyenTienDenCMND:(NSString *)sJson noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_CHUYEN_TIEN_DEN_CMND withContent:sJson];
    [connectPost release];
}

+ (void)thanhToanHocPhi:(NSString *)jsonHocPhi noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_NAP_TIEN_TRO_CHOI_DIEN_TU withContent:jsonHocPhi];
    [connectPost release];

}

+ (void)thanhToanHoaDonTruyenHinh:(NSString *)maHoaDon maNhaCungCap:(int)nMaNhaCungCap soTien:(int)soTien token:(NSString *)token otpConfirm:(NSString*)otpComfirm typeAuthenticate:(int)typeAuthenticate noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    NSString *sMaDoanhNghiep = @"";
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sMaDoanhNghiep = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_COMPANY_ID];
    }
    NSDictionary *dic = @{
                          @"maThueBao" : maHoaDon,
                          @"maNhaCungCap" :[NSNumber numberWithInteger:nMaNhaCungCap],
                          @"soTien"        :[NSNumber numberWithInt:(int)soTien],
                          @"user"          :[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                          @"companyCode"   :sMaDoanhNghiep,
                          @"token"         :token,
                          @"otpConfirm"    :otpComfirm,
                          @"typeAuthenticate" : [NSNumber numberWithInt:typeAuthenticate],
                          @"appId"         : [NSNumber numberWithInt:APP_ID],
                          @"VMApp" : [NSNumber numberWithInt:VM_APP]
                          };
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_THANH_TOAN_TRUYEN_HINH withContent:[dic JSONString]];
    [connectPost release];
}

+ (void)layChiTietHoaDonTruyenHinh: (NSString *)sId noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    NSString *link = [NSString stringWithFormat:@"%@%@", URL_CHI_TIET_TRUYEN_HINH, sId];
    NSLog(@"%s - link : %@", __FUNCTION__, link);
    DucNT_ServicePost *connectGet = [[DucNT_ServicePost alloc] init];
    connectGet.ducnt_connectDelegate = noiNhanKetQua;
    [connectGet connectGet:60 sUrl:link withContent:@""];
    [connectGet release];
}

+ (void)traCuuHoaDonTruyenHinh : (NSString *)maThueBao nhaCungCap:(int)nhaCungCap noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    NSDictionary *dic = @{@"user" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                          @"maThueBao" : maThueBao,
                          @"maNhaCungCap" : [NSNumber numberWithInt:nhaCungCap],
                          @"VMApp" : [NSNumber numberWithInt:VM_APP]};
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_TRA_CUU_TRUYEN_HINH withContent:[dic JSONString]];
    [connectPost release];
}

+ (void)chuyenTienDenATM:(NSString *)sSoDienThoai soTien:(int)soTien maATM:(int)maATM token:(NSString *)sToken otpConfirm:(NSString*)otpComfirm typeAuthenticate:(int)typeAuthenticate noiDung:(NSString *)noiDung noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    NSString *sMaDoanhNghiep = @"";
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sMaDoanhNghiep = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_COMPANY_ID];
    }
//                              @"companyCode"   :sMaDoanhNghiep,
    NSDictionary *dic = @{
                          @"soDienThoai" : sSoDienThoai,
                          @"soTien"        :[NSNumber numberWithInt:(int)soTien],
                          @"maATM" : [NSNumber numberWithInt:maATM],
                          @"user"          :[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                          @"token"         :sToken,
                          @"otpConfirm"    :otpComfirm,
                          @"typeAuthenticate" : [NSNumber numberWithInt:typeAuthenticate],
                          @"appId"         : [NSNumber numberWithInt:APP_ID],
                          @"noiDung" : @"",
                          @"VMApp" : [NSNumber numberWithInt:VM_APP]
                          };
    NSLog(@"%s - dic.json : %@", __FUNCTION__, [dic JSONString]);
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_CHUYEN_TIEN_ATM withContent:[dic JSONString]];
    [connectPost release];
}

+ (void)traCuuSanBayDiDen:(id<DucNT_ServicePostDelegate>)noiNhanKetQua{
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:[NSString stringWithFormat:@"%@", URL_TRA_CUU_SAN_BAY_DI_DEN] withContent:nil];
    [connectPost release];
}
//[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP]
+ (void)traCuuChuyenBay:(NSString*)sMaSanBayDi sMaSanBayDen:(NSString *)sMaSanBayDen sTimeDi:(NSString *)sTimeDi sTimeDen:(NSString *)sTimeDen slNguoiLon:(int)slNguoiLon slTreEm:(int)slTreEm slEmBe:(int)slEmBe noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua{
    NSDictionary *dicPost = @{@"maSanBayDi" : sMaSanBayDi,
                              @"maSanBayDen" : sMaSanBayDen,
                              @"thoiGianDi" : sTimeDi,
                              @"thoiGianVe" : sTimeDen,
                              @"user" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                              @"VMApp" : [NSNumber numberWithInt:VM_APP],
                              @"slNguoiLon":[NSNumber numberWithInt:slNguoiLon],
                              @"slTreEm":[NSNumber numberWithInt:slTreEm],
                              @"slEmBe":[NSNumber numberWithInt:slEmBe]
                              };
    NSLog(@"%s - dicPost : %@", __FUNCTION__, [dicPost JSONString]);
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_TRA_CUU_CHUYEN_BAY withContent:[dicPost JSONString]];
    [connectPost release];
}

+ (void)thanhToanMayBay:(NSString*)sJson noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua{
    NSLog(@"%s - sJson : %@", __FUNCTION__, sJson);
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_THANH_TOAN_MAY_BAY withContent:sJson];
    [connectPost release];
}

+ (void)uploadAnhViDoanhNghiep:(NSString *)maDoanhNghiep value:(NSString *)value noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua{
    NSDictionary *dicPost = @{@"maDoanhNghiep" : maDoanhNghiep,
                              @"value" : value,
                              @"name" : @"",
                              @"VMApp" : [NSNumber numberWithInt:VM_APP]};
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:[NSString stringWithFormat:@"%@%@", URL_UPLOAD_ANH_DOANH_NGHIEP, maDoanhNghiep] withContent:[dicPost JSONString]];
    [connectPost release];
}

+ (void)dangKyDoanhNghiep:(NSDictionary *)dicPost  noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua{
    NSLog(@"%s - [dicPost JSONString] : %@", __FUNCTION__, [dicPost JSONString]);
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_DANG_KY_DOANH_NGHIEP withContent:[dicPost JSONString]];
    [connectPost release];
}

+ (void)dangKyDoanhNghiep2:(NSString *)sMaDn sTenDn:(NSString *)sTenDn sTenDD:(NSString *)sTenDD sSDT:(NSString *)sSDT sEmail:(NSString *)sEmail sImage1:(NSString*)sImage1 sImage2:(NSString *)sImage2 noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua{
    NSDictionary *dicPost = @{@"companyCode" : sMaDn,
                              @"companyName" : sTenDn,
                              @"nameRepresent" : sTenDD,
                              @"walletId" : sSDT,
                              @"email" : sEmail,
                              @"imageCompany1" : sImage1,
                              @"imageCompany2" : sImage2,
                              @"VMApp" : [NSNumber numberWithInt:VM_APP]};
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_DANG_KY_DOANH_NGHIEP withContent:[dicPost JSONString]];
    [connectPost release];
}

+ (void)layDanhSachRapPhim:(id<DucNT_ServicePostDelegate>)noiNhanKetQua{
    DucNT_ServicePost *connectGet = [[DucNT_ServicePost alloc] init];
    connectGet.ducnt_connectDelegate = noiNhanKetQua;
//    [connectGet connectGet:URL_LAY_DANH_SACH_RAP_PHIM withContent:@""];
    [connectGet connectGet:60 sUrl:URL_LAY_DANH_SACH_RAP_PHIM withContent:@""];
    [connectGet release];
}

+ (void)layDanhSachRapPhimTheoTenVaKhuVuc:(NSString *)sTenFilm sKhuVuc:(NSString *)sKhuVuc noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua{
    NSString *sURL = [NSString stringWithFormat:URL_LAY_DANH_SACH_RAP_PHIM_THEO_TEN_KHU_VUC, sTenFilm, sKhuVuc];
    DucNT_ServicePost *connectGet = [[DucNT_ServicePost alloc] init];
    connectGet.ducnt_connectDelegate = noiNhanKetQua;
    //    [connectGet connectGet:URL_LAY_DANH_SACH_RAP_PHIM withContent:@""];
    [connectGet connectGet:60 sUrl:sURL withContent:@""];
    [connectGet release];
}

+ (void)layDanhSAchPhimCuaRap:(NSString*)sIdRap noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua{
    NSString *sContent = [NSString stringWithFormat:@"?idRap=%@",sIdRap];
    DucNT_ServicePost *connectGet = [[DucNT_ServicePost alloc] init];
    connectGet.ducnt_connectDelegate = noiNhanKetQua;
    [connectGet connectGet:URL_LAY_DANH_SACH_PHIM withContent:sContent];
    [connectGet release];
}

+ (void)layDanhSachTinhThanhRapPhim:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    DucNT_ServicePost *connectGet = [[DucNT_ServicePost alloc] init];
    connectGet.ducnt_connectDelegate = noiNhanKetQua;
    [connectGet connectGet:@"https://vimass.vn/vmbank/services/vePhim/getTinhThanhRapPhim" withContent:@""];
    [connectGet release];
}

+ (void)layDanhSachRapPhimTheoTinh:(NSString *)sTenTinh noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    sTenTinh = [sTenTinh stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    sTenTinh  = [sTenTinh stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

    NSString *sContent = [NSString stringWithFormat:@"?thanhPho=%@", sTenTinh];
    DucNT_ServicePost *connectGet = [[DucNT_ServicePost alloc] init];
    connectGet.ducnt_connectDelegate = noiNhanKetQua;
    [connectGet connectGet:URL_LAY_DANH_SACH_RAP_PHIM_THEO_TINH withContent:sContent];
    [connectGet release];
}

+ (void)layDanhSachGioChieuPhimCuaRap:(NSString*)sIdRap idPhim:(NSString *)idPhim noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua{
    NSString *sContent = [NSString stringWithFormat:@"?idRap=%@&idPhim=%@",sIdRap, idPhim];
    DucNT_ServicePost *connectGet = [[DucNT_ServicePost alloc] init];
    connectGet.ducnt_connectDelegate = noiNhanKetQua;
    [connectGet connectGet:URL_LAY_DANH_SACH_THOI_DIEM_PHIM withContent:sContent];
    [connectGet release];
}

+ (void)layThongTinGheNgoi:(NSString*)sIdRap idPhim:(NSString*)idPhim idKhungGio:(NSString*)idKhungGio noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua{
    NSString *sContent = [NSString stringWithFormat:@"?idRap=%@&idPhim=%@&idKhungGio=%@",sIdRap, idPhim, idKhungGio];
    DucNT_ServicePost *connectGet = [[DucNT_ServicePost alloc] init];
    connectGet.ducnt_connectDelegate = noiNhanKetQua;
//    [connectGet connectGet:URL_LAY_DANH_SACH_THONG_TIN_GHE withContent:sContent];
    [connectGet connectGet:120 sUrl:URL_LAY_DANH_SACH_THONG_TIN_GHE withContent:sContent];
    [connectGet release];
}

+ (void)layThongTinGheNgoiQuocGiaBHD:(NSString *)sIdRap idPhim:(NSString *)idPhim idKhungGio:(NSString *)idKhungGio noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    NSString *sContent = [NSString stringWithFormat:@"?idRap=%@&idPhim=%@&idKhungGio=%@",sIdRap, idPhim, idKhungGio];
    DucNT_ServicePost *connectGet = [[DucNT_ServicePost alloc] init];
    connectGet.ducnt_connectDelegate = noiNhanKetQua;
    [connectGet connectGet:120 sUrl:URL_LAY_DANH_SACH_THOI_DIEM_PHIM_BHD withContent:sContent];
    [connectGet release];
}

+ (void)layThongTinGheNgoiSauKhiChonGheBHD:(NSString *)sIdRap idPhim:(NSString *)idPhim idKhungGio:(NSString *)idKhungGio thongTinVe:(NSString *)thongTinVe noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
//    NSString *sContent = [NSString stringWithFormat:@"?idRap=%@&idPhim=%@&idKhungGio=%@&dsVe=%@",sIdRap, idPhim, idKhungGio, thongTinVe];
//    DucNT_ServicePost *connectGet = [[DucNT_ServicePost alloc] init];
//    connectGet.ducnt_connectDelegate = noiNhanKetQua;
//    [connectGet connectGet:120 sUrl:URL_LAY_DANH_SACH_THONG_TIN_GHE_BHD withContent:sContent];
//    [connectGet release];
    NSDictionary *dicPost = @{@"idRap" : sIdRap,
                              @"idPhim" : idPhim,
                              @"idKhungGio" : idKhungGio,
                              @"dsVe" : thongTinVe,
                              @"VMApp" : [NSNumber numberWithInt:VM_APP]};

    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_LAY_DANH_SACH_THONG_TIN_GHE_BHD withContent:[dicPost JSONString]];
    [connectPost release];
}

+ (void)layThongTinGheNgoiSauKhiChonGheGalaxy:(NSString *)sIdRap idPhim:(NSString *)idPhim idKhungGio:(NSString *)idKhungGio thongTinVe:(NSString *)thongTinVe noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    NSString *sContent = [NSString stringWithFormat:@"?idRap=%@&idPhim=%@&idKhungGio=%@&dsVe=%@",sIdRap, idPhim, idKhungGio, thongTinVe];
    DucNT_ServicePost *connectGet = [[DucNT_ServicePost alloc] init];
    connectGet.ducnt_connectDelegate = noiNhanKetQua;
    [connectGet connectGet:120 sUrl:URL_LAY_DANH_SACH_THONG_TIN_CHO_NGOI_GALAXY withContent:sContent];
    [connectGet release];
}

+ (void)layThongTinGheNgoiQuocGia:(NSString *)sIdRap idPhim:(NSString *)idPhim idKhungGio:(NSString *)idKhungGio noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    NSString *sContent = [NSString stringWithFormat:@"?idRap=%@&idPhim=%@&idKhungGio=%@",sIdRap, idPhim, idKhungGio];
    DucNT_ServicePost *connectGet = [[DucNT_ServicePost alloc] init];
    connectGet.ducnt_connectDelegate = noiNhanKetQua;
    [connectGet connectGet:120 sUrl:URL_LAY_DANH_SACH_THONG_TIN_GHE_QUOC_GIA withContent:sContent];
    [connectGet release];
}

+ (void)layThongTinGheNgoiGalaxy:(NSString *)sIdRap idPhim:(NSString *)idPhim idKhungGio:(NSString *)idKhungGio noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    NSString *sContent = [NSString stringWithFormat:@"?idRap=%@&idPhim=%@&idKhungGio=%@",sIdRap, idPhim, idKhungGio];
    DucNT_ServicePost *connectGet = [[DucNT_ServicePost alloc] init];
    connectGet.ducnt_connectDelegate = noiNhanKetQua;
    [connectGet connectGet:120 sUrl:URL_LAY_DANH_SACH_THONG_TIN_GHE_GALAXY withContent:sContent];
    [connectGet release];
}

+ (void)muaVeXemPhim:(NSString *)dic noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua{
    DucNT_ServicePost *connectGet = [[DucNT_ServicePost alloc] init];
    connectGet.ducnt_connectDelegate = noiNhanKetQua;
    [connectGet connectGet:URL_DAT_VE_XEM_FILM withContent:dic];
    [connectGet release];
}

+ (void)muaVeXemPhimQuocGia:(NSString *)dic noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua{
    NSLog(@"%s - URL_DAT_VE_XEM_FILM_QUOC_GIA : %@", __FUNCTION__, URL_DAT_VE_XEM_FILM_QUOC_GIA);
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_DAT_VE_XEM_FILM_QUOC_GIA withContent:dic];
    [connectPost release];
}

+ (void)muaVeXemPhimCGV:(NSString *)dic noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua{
    dic = [dic stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    dic = [dic stringByReplacingOccurrencesOfString:@"\"[" withString:@"["];
    dic = [dic stringByReplacingOccurrencesOfString:@"]\"" withString:@"]"];
    NSLog(@"%s - dic : %@", __FUNCTION__, dic);
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_DAT_VE_XEM_FILM_CGV withContent:dic];
    [connectPost release];
}

+ (void)muaVeXemPhimBHD:(NSString *)dic noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    dic = [dic stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    dic = [dic stringByReplacingOccurrencesOfString:@"\"[" withString:@"["];
    dic = [dic stringByReplacingOccurrencesOfString:@"]\"" withString:@"]"];
    NSLog(@"%s - dic : %@", __FUNCTION__, dic);
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_DAT_VE_XEM_FILM_BHD withContent:dic];
    [connectPost release];
}

+ (void)muaVeXemPhimGalaxy:(NSString *)dic noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    dic = [dic stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    dic = [dic stringByReplacingOccurrencesOfString:@"\"[" withString:@"["];
    dic = [dic stringByReplacingOccurrencesOfString:@"]\"" withString:@"]"];
    NSLog(@"%s - dic : %@", __FUNCTION__, dic);
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_DAT_VE_XEM_FILM_GALAXY withContent:dic];
    [connectPost release];
}

+ (void)kiemTraNapTienTheQuocTe:(int)nSTT noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua{
    NSDictionary *dicPost = @{@"STT" : [NSNumber numberWithInt:nSTT]};
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_KIEM_TRA_NAP_TIEN_QUOC_TE withContent:[dicPost JSONString]];
    [connectPost release];
}

+ (void)napTienVaoViQuaTheCao:(NSString *)idVi maSoThe:(NSString*)maSoThe serial:(NSString *)serialThe nhaMang:(int)nhaMang noiDung:(NSString *)noiDung noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua{
    NSDictionary *dicPost = @{@"idViNap" : idVi,
                              @"noiDung" : noiDung,
                              @"maSoThe" : maSoThe,
                              @"serialThe" : serialThe,
                              @"nhaMang" : [NSNumber numberWithInt:nhaMang],
                              @"VMApp" : [NSNumber numberWithInt:VM_APP]};

    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_NAP_TIEN_THE_CAO withContent:[dicPost JSONString]];
    [connectPost release];
}

+ (void)napTienVaoViQuaTheQuocTe:(NSDictionary *)dicPost noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua{
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_NAP_TIEN_THE_QUOC_TE withContent:[dicPost JSONString]];
    [connectPost release];
}

+ (void)confirmNapTienVaoViQuaTheQuocTe:(NSString *)otp soThuTu:(int)nSTT noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua{
    NSDictionary *dicPost = @{@"STT" : [NSNumber numberWithInt:nSTT],
                              @"otp" : otp,
                              @"VMApp" : [NSNumber numberWithInt:VM_APP]
                              };
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_CONFIRM_NAP_TIEN_THE_QUOC_TE withContent:[dicPost JSONString]];
    [connectPost release];
}

+ (void)traCuuTienInternet:(NSString *)maThueBao maNhaCungCap:(int)nMaNhaCungCap user:(NSString *)user noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua{
    NSDictionary *dic = @{
                               @"maThueBao":maThueBao,
                               @"maNhaCungCap":[NSNumber numberWithInteger:nMaNhaCungCap],
                               @"user":user,
                               @"VMApp" : [NSNumber numberWithInt:VM_APP]
                               };
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_TRA_CUU_INTERNET withContent:[dic JSONString]];
    [connectPost release];
}

+ (void)layChiTietHoaDonInternet:(NSString *)maHoaDon noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua{
    NSString *sContent = [NSString stringWithFormat:@"?id=%@",maHoaDon];
    DucNT_ServicePost *connectGet = [[DucNT_ServicePost alloc] init];
    connectGet.ducnt_connectDelegate = noiNhanKetQua;
    [connectGet connectGet:URL_CHI_TIET_HOA_DON_INTERNET withContent:sContent];
    [connectGet release];
}

+ (void)thanhToanHoaDonInternet:(NSString *)maHoaDon maNhaCungCap:(int)nMaNhaCungCap soTien:(int)soTien token:(NSString *)sToken otpConfirm:(NSString*)otpComfirm typeAuthenticate:(int)typeAuthenticate noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua{
    NSString *sMaDoanhNghiep = @"";
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sMaDoanhNghiep = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_COMPANY_ID];
    }
    NSDictionary *dic = @{
                          @"maThueBao" : maHoaDon,
                          @"maNhaCungCap" :[NSNumber numberWithInteger:nMaNhaCungCap],
                          @"soTien"        :[NSNumber numberWithInt:(int)soTien],
                          @"user"          :[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                          @"companyCode"   :sMaDoanhNghiep,
                          @"token"         :sToken,
                          @"otpConfirm"    :otpComfirm,
                          @"typeAuthenticate" : [NSNumber numberWithInt:typeAuthenticate],
                          @"appId"         : [NSNumber numberWithInt:APP_ID],
                          @"VMApp" : [NSNumber numberWithInt:VM_APP]
                          };
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_THANH_TOAN_HOA_DON_INTERNET withContent:[dic JSONString]];
    [connectPost release];
}

+ (void)thayDoiThongTinViDoanhNghiep:(NSDictionary *)dic noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua{
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_THAY_DOI_VI_DOANH_NGHIEP withContent:[dic JSONString]];
    [connectPost release];
}

+ (void)traCuuDienThoaiTraSau:(NSString *)user soDienThoai:(NSString *)soDienThoai nhaMang:(int)nhaMang noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    NSDictionary *postBody = @{@"soDienThoai"   :soDienThoai,
                               @"nhaMang"       :[NSNumber numberWithInteger:nhaMang],
                               @"user"          :[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP]
                               };
    NSLog(@"%s - [postBody JSONString] : %@", __FUNCTION__, [postBody JSONString]);
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_TRA_CUU_DIEN_THOAI_TRA_SAU withContent:[postBody JSONString]];
    [connectPost release];
}

+ (void)ketNoiLayThongTinNgayVang:(int)nNhaMang noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua{
    NSString *sContent = [NSString stringWithFormat:@"?maNhaMang=%d",nNhaMang];
    DucNT_ServicePost *connectGet = [[DucNT_ServicePost alloc] init];
    connectGet.ducnt_connectDelegate = noiNhanKetQua;
    [connectGet connectGet:URL_LAY_THONG_TIN_NGAY_VANG withContent:sContent];
    [connectGet release];
}

+ (void)ketNoiThanhToanNgayVangDienThoaiChoSo:(NSString*)sSoDienThoai
                                    maNhaMang:(NSInteger)nNhaMang
                                kieuThanhToan:(int)nKieuThanhToan
                                       soTien:(double)fSoTien
                                        token:(NSString*)sToken
                                          otp:(NSString*)sOtp
                             typeAuthenticate:(int)nTypeAuthenticate
                                noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua{

    NSString *sMaDoanhNghiep = @"";
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sMaDoanhNghiep = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_COMPANY_ID];
    }
    NSDictionary *postBody = @{
                               @"companyCode"   :sMaDoanhNghiep,
                               @"soDienThoai"   :sSoDienThoai,
                               @"nhaMang"       :[NSNumber numberWithInteger:nNhaMang],
                               @"loaiThueBao"   :[NSNumber numberWithInt:nKieuThanhToan],
                               @"soTien"        :[NSNumber numberWithInt:(int)fSoTien],
                               @"user"          :[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                               @"token"         :sToken,
                               @"otpConfirm"    :sOtp,
                               @"typeAuthenticate" : [NSNumber numberWithInt:nTypeAuthenticate],
                               @"appId"         : [NSNumber numberWithInt:APP_ID],
                               @"VMApp" : [NSNumber numberWithInt:VM_APP]
                               };
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_THANH_TOAN_TIEN_DIEN_THOAI_NGAY_VANG withContent:[postBody JSONString]];
    [connectPost release];

}

+ (void)ketNoiThanhToanCuocDienThoaiChoSo:(NSString*)sSoDienThoai
                                maNhaMang:(NSInteger)nNhaMang
                            kieuThanhToan:(int)nKieuThanhToan
                                   soTien:(double)fSoTien
                                    token:(NSString*)sToken
                                      otp:(NSString*)sOtp
                         typeAuthenticate:(int)nTypeAuthenticate
                            noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSString *sMaDoanhNghiep = @"";
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sMaDoanhNghiep = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_COMPANY_ID];
    }
    NSDictionary *postBody = @{
                               @"companyCode"   :sMaDoanhNghiep,
                               @"soDienThoai"   :sSoDienThoai,
                               @"nhaMang"       :[NSNumber numberWithInteger:nNhaMang],
                               @"loaiThueBao"   :[NSNumber numberWithInt:nKieuThanhToan],
                               @"soTien"        :[NSNumber numberWithInt:(int)fSoTien],
                               @"user"          :[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                               @"token"         :sToken,
                               @"otpConfirm"    :sOtp,
                               @"typeAuthenticate" : [NSNumber numberWithInt:nTypeAuthenticate],
                               @"appId"         : [NSNumber numberWithInt:APP_ID],
                               @"VMApp" : [NSNumber numberWithInt:VM_APP]
                               };
    NSLog(@"%s - [postBody JSONString] : %@", __FUNCTION__, [postBody JSONString]);
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_THANH_TOAN_TIEN_DIEN_THOAI withContent:[postBody JSONString]];
    [connectPost release];
}

+ (void)ketNoiMuaTheCaoThuocNhaMang:(NSInteger)nNhaMang
                             soTien:(double)fSoTien
                            soLuong:(int)nSoLuong
                              token:(NSString*)sToken
                                otp:(NSString*)sOtp
                   typeAuthenticate:(int)nTypeAuthenticate
                      noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSString *sMaDoanhNghiep = @"";
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sMaDoanhNghiep = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_COMPANY_ID];
    }
    NSDictionary *postBody = @{
                               @"companyCode"   :sMaDoanhNghiep,                               
                               @"nhaMang"       :[NSNumber numberWithInteger:nNhaMang],
                               @"soLuong"       :[NSNumber numberWithInt:nSoLuong],
                               @"soTien"        :[NSNumber numberWithInt:(int)fSoTien],
                               @"user"          :[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                               @"token"         :sToken,
                               @"otpConfirm"    :sOtp,
                               @"typeAuthenticate" : [NSNumber numberWithInt:nTypeAuthenticate],
                               @"appId"         : [NSNumber numberWithInt:APP_ID],
                               @"VMApp" : [NSNumber numberWithInt:VM_APP]
                               };
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_MUA_THE_CAO withContent:[postBody JSONString]];
    [connectPost release];
}

+ (void)ketNoiLayDanhSachQuaTang:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSString *sContent = [NSString stringWithFormat:@"?type=%d&status=%d&offset=%d&limit=%d", 1, 0, 0, 100];
    DucNT_ServicePost *connectGet = [[DucNT_ServicePost alloc] init];
    connectGet.ducnt_connectDelegate = noiNhanKetQua;
    [connectGet connectGet:URL_LAY_DANH_SACH_QUA_TANG withContent:sContent];
    [connectGet release];
}

+ (void)ketNoiTaoQuaTangDen:(NSString*)sToAcc
                   thoiGian:(long)nThoiGianTangQua
                     soTien:(double)fSoTien
             sTieuDeQuaTang:(NSString*)sTieuDe
                   sLoiChuc:(NSString*)sLoiChuc
                     idIcon:(int)nIdIcon
                      token:(NSString*)sToken
                        otp:(NSString*)sOtp
           typeAuthenticate:(int)nTypeAuthenticate
              noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSDictionary *postBody = @{
                               @"timeDeadline"      :[NSNumber numberWithLong:nThoiGianTangQua],
                               @"fromAcc"           :[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                               @"toAcc"             :sToAcc,
                               @"amount"            :[NSNumber numberWithDouble:fSoTien],
                               @"giftName"          :sTieuDe,
                               @"message"           :sLoiChuc,
                               @"idIcon"            :[NSNumber numberWithInt:nIdIcon],
                               @"token"             :sToken,
                               @"otpConfirm"        :sOtp,
                               @"typeAuthenticate"  :[NSNumber numberWithInt:nTypeAuthenticate],
                               @"appId"             :[NSNumber numberWithInt:APP_ID],
                               @"VMApp" : [NSNumber numberWithInt:VM_APP]
                               };
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_TAO_QUA_TANG withContent:[postBody JSONString]];
    [connectPost release];
}

+ (void)ketNoiTaoKhuyenMaiDen:(NSString*)sToAcc
                     thoiGian:(long)nThoiGianTangQua
                       soTien:(double)fSoTien
               sTieuDeQuaTang:(NSString*)sTieuDe
                     sLoiChuc:(NSString*)sLoiChuc
                       idIcon:(int)nIdIcon
                        token:(NSString*)sToken
                          otp:(NSString*)sOtp
             typeAuthenticate:(int)nTypeAuthenticate
                noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSDictionary *postBody = @{
                               @"timeDeadline"      :[NSNumber numberWithLong:nThoiGianTangQua],
                               @"fromAcc"           :[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                               @"toAcc"             :sToAcc,
                               @"amount"            :[NSNumber numberWithDouble:fSoTien],
                               @"giftName"          :sTieuDe,
                               @"message"           :sLoiChuc,
                               @"idIcon"            :[NSNumber numberWithInt:nIdIcon],
                               @"token"             :sToken,
                               @"otpConfirm"        :sOtp,
                               @"typeAuthenticate"  :[NSNumber numberWithInt:nTypeAuthenticate],
                               @"appId"             :[NSNumber numberWithInt:APP_ID],
                               @"VMApp" : [NSNumber numberWithInt:VM_APP]
                               };
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_TAO_QUA_TANG_KHUYEN_MAI withContent:[postBody JSONString]];
    [connectPost release];
}

+ (void)ketNoiLaySaoKeQuaTangBoiID:(NSNumber*)idIcon
                     noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSString *sContent = [NSString stringWithFormat:@"?id=%@",idIcon];
    DucNT_ServicePost *connectGet = [[DucNT_ServicePost alloc] init];
    connectGet.ducnt_connectDelegate = noiNhanKetQua;
    [connectGet connectGet:URL_LAY_QUA_TANG_BOI_ID withContent:sContent];
    [connectGet release];
}

+ (void)ketNoiLayGuiTrangThaiSuDungKhuyenMai:(NSString*)secssion
                                   trangThai:(BOOL)bTrangThai
                               noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSString *sId = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    NSNumber *status = [NSNumber numberWithBool:bTrangThai];
    NSString *sContent = [NSString stringWithFormat:@"?idOwner=%@&status=%@&secssion=%@", sId, status, secssion];
    DucNT_ServicePost *connectGet = [[DucNT_ServicePost alloc] init];
    connectGet.ducnt_connectDelegate = noiNhanKetQua;
    [connectGet connectGet:URL_THAY_DOI_TRANG_THAI_SU_DUNG_KHUYEN_MAI withContent:sContent];
    [connectGet release];
}


+ (void)ketNoiLaySaoKeTangQua:(long long)nThoiGianBatDau
              thoiGianKetThuc:(long long)nThoiGianKetThuc
                  viTribatDau:(int)nViTriBatDau
                      gioiHan:(int)nGioiHan
                      kieuLay:(int)nKieu //tang qua hay nhan qua
              typeTransaction:(int)typeTransaction //mac dinh = 0
                noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSString *sID = @"";
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sID = [DucNT_LuuRMS layThongTinDangNhap:KEY_DINH_DANH_DOANH_NGHIEP];
    }
    else if(nKieuDangNhap == KIEU_CA_NHAN)
    {
        sID = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    }
    NSDictionary *postBody = @{
                               @"phone":sID,
                               @"limit": [NSNumber numberWithInt:nGioiHan],
                               @"fromDate":[NSNumber numberWithLongLong:nThoiGianBatDau],
                               @"toDate":[NSNumber numberWithLongLong:nThoiGianKetThuc],
                               @"start": [NSNumber numberWithInt:nViTriBatDau],
                               @"type": [NSNumber numberWithInt:nKieu],
                               @"typeTransaction" : [NSNumber numberWithInt:typeTransaction],
                               @"VMApp" : [NSNumber numberWithInt:VM_APP]
                               };
    NSLog(@"%s - postBody : %@", __FUNCTION__, [postBody JSONString]);
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connect:URL_LAY_DANH_SACH_SAO_KE_QUA_TANG withContent:[postBody JSONString]];
    [connect release];
}

+ (void)ketNoiLaySaoKeKhuyenMai:(long long)nThoiGianBatDau
                thoiGianKetThuc:(long long)nThoiGianKetThuc
                    viTribatDau:(int)nViTriBatDau
                        gioiHan:(int)nGioiHan
                        kieuLay:(int)nKieu //tang qua hay nhan qua
                typeTransaction:(int)typeTransaction //mac dinh = 0
                  noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{

    NSString *sID = @"";
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sID = [DucNT_LuuRMS layThongTinDangNhap:KEY_DINH_DANH_DOANH_NGHIEP];
    }
    else if(nKieuDangNhap == KIEU_CA_NHAN)
    {
        sID = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    }
    NSDictionary *DICT = @{
                           @"phone":sID,
                           @"limit": [NSNumber numberWithInt:nGioiHan],
                           @"fromDate":[NSNumber numberWithLongLong:nThoiGianBatDau],
                           @"toDate":[NSNumber numberWithLongLong:nThoiGianKetThuc],
                           @"start": [NSNumber numberWithInt:nViTriBatDau],
                           @"type": [NSNumber numberWithInt:nKieu],
                           @"typeTransaction" : [NSNumber numberWithInt:typeTransaction],
                           @"VMApp" : [NSNumber numberWithInt:VM_APP]
                           };
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connect:URL_LAY_DANH_SACH_SAO_KE_KHUYEN_MAI withContent:[DICT JSONString]];
    [connect release];
}

+ (void)ketNoiLaySaoKeVi:(long long)nThoiGianBatDau
         thoiGianKetThuc:(long long)nThoiGianKetThuc
             viTribatDau:(int)nViTriBatDau
                 gioiHan:(int)nGioiHan
                 kieuLay:(int)nKieu //tang qua hay nhan qua
           noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSString *sID = @"";
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sID = [DucNT_LuuRMS layThongTinDangNhap:KEY_DINH_DANH_DOANH_NGHIEP];
    }
    else if(nKieuDangNhap == KIEU_CA_NHAN)
    {
        sID = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    }
    NSDictionary *dic = @{
                          @"phone": sID,
                          @"session": [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_SECSSION],
                          @"limit": [NSNumber numberWithInt:nGioiHan],
                          @"fromDate":[NSNumber numberWithLongLong:nThoiGianBatDau],
                          @"toDate":[NSNumber numberWithLongLong:nThoiGianKetThuc],
                          @"start": [NSNumber numberWithInt:nViTriBatDau],
                          @"type": [NSNumber numberWithInt:nKieu],
                          @"VMApp" : [NSNumber numberWithInt:VM_APP]
                          };
    NSLog(@"%s - [dic JSONString] : %@", __FUNCTION__, [dic JSONString]);
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connect:URL_LAY_DANH_SACH_SAO_KE_VI withContent:[dic JSONString]];
    [connect release];
}


+ (void)ketNoiGuiMailSaoKeDen:(NSString*)sTaiKhoan
                        email:(NSString*)sEmail
                       tuNgay:(long)nTuNgay
                      denNgay:(long)nDenNgay
                noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSString *sID = @"";
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sID = [DucNT_LuuRMS layThongTinDangNhap:KEY_DINH_DANH_DOANH_NGHIEP];
    }
    else if(nKieuDangNhap == KIEU_CA_NHAN)
    {
        sID = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    }
    NSDictionary *dic = @{
                          @"phone": sID,
                          @"email": sEmail,
                          @"fromDate":[NSNumber numberWithLongLong:nTuNgay],
                          @"toDate":[NSNumber numberWithLongLong:nDenNgay],
                          @"VMApp" : [NSNumber numberWithInt:VM_APP]
                          };
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connect:URL_GUI_SAO_KE_VE_EMAIL withContent:[dic JSONString]];
    [connect release];

}

+ (void)ketNoiGuiMailSaoKeDen:(NSString*)sEmail
                   tieuDeMail:(NSString*)sTieuDe
                      noiDung:(NSString*)sNoiDung
                noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    
    NSDictionary *dic = @{
                          @"sendTo": sEmail,
                          @"tieuDe": sTieuDe,
                          @"noiDung":sNoiDung,
                          @"VMApp" : [NSNumber numberWithInt:VM_APP]
                          };
    NSString *jsonDic = [dic JSONString];
    NSLog(@"%s - jsonDic : %@", __FUNCTION__, jsonDic);
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connect:URL_GUI_SAO_KE_DON_VE_EMAIL withContent:jsonDic];
    [connect release];
}

+ (void)ketNoiLaySoDuTaiKhoan:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    
    NSString *sID = @"";
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sID = [DucNT_LuuRMS layThongTinDangNhap:KEY_DINH_DANH_DOANH_NGHIEP];
    }
    else if(nKieuDangNhap == KIEU_CA_NHAN)
    {
        sID = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    }
    NSString *content = [NSString stringWithFormat:@"?id=%@", sID];
    DucNT_ServicePost *ketNoiLaySoDu = [[DucNT_ServicePost alloc] init];
    ketNoiLaySoDu.ducnt_connectDelegate = noiNhanKetQua;
    [ketNoiLaySoDu connectGet:URL_LAY_SO_DU_VI withContent:content showAlert:NO];
    [ketNoiLaySoDu release];
}

+ (void)ketNoiChuyenTienDenViMomo:(NSString*)sTaiKhoan
                           soTien:(double)fSoTien
                          noiDung:(NSString*)sNoiDung
                       nhaCungCap:(int)nNhaCungCap
                            token:(NSString*)sToken
                              otp:(NSString*)sOtp
                 typeAuthenticate:(int)nTypeAuthenticate
                    noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSString *sMaDoanhNghiep = @"";
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sMaDoanhNghiep = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_COMPANY_ID];
    }
    NSString *sUser = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    NSDictionary *dic = @{
                          @"companyCode":sMaDoanhNghiep,
                          @"taiKhoan": sTaiKhoan,
                          @"user": sUser,
                          @"nhaCungCap":[NSNumber numberWithInt:nNhaCungCap],
                          @"noiDung":sNoiDung,
                          @"soTien":[NSNumber numberWithDouble:fSoTien],
                          @"token":sToken,
                          @"appId" : [NSString stringWithFormat:@"%d", APP_ID],
                          @"otpConfirm": sOtp,
                          @"typeAuthenticate": [NSNumber numberWithInt:nTypeAuthenticate],
                          @"VMApp" : [NSNumber numberWithInt:VM_APP]
                          };
    
    NSString *sUrlContent = [dic JSONString];
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connect:URL_CHUYEN_TIEN_DEN_VI_MOMO withContent:sUrlContent];
    [connect release];
}

+ (void)ketNoiChuyenTienDenVi:(NSString*)sDenVi
                       soTien:(double)fSoTien
                      noiDung:(NSString*)sNoiDung
                        token:(NSString*)sToken
                          otp:(NSString*)sOtp
             typeAuthenticate:(int)nTypeAuthenticate
                noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSString *sMaDoanhNghiep = @"";
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sMaDoanhNghiep = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_COMPANY_ID];
    }
    NSDictionary *dicPost = @{
                              @"companyCode":sMaDoanhNghiep,
                              @"fromAcc":[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                              @"toAcc":sDenVi,
                              @"amount":[NSNumber numberWithDouble:fSoTien],
                              @"transDesc":sNoiDung,
                              @"token":sToken,
                              @"type":[NSNumber numberWithInt:1],
                              @"appId" : [NSString stringWithFormat:@"%d", APP_ID],
                              @"otpConfirm": sOtp,
                              @"typeAuthenticate": [NSNumber numberWithInt:nTypeAuthenticate],
                              @"VMApp" : [NSNumber numberWithInt:VM_APP]
                              };
    NSString *sUrlContent = [dicPost JSONString];
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connect:URL_CHUYEN_TIEN_DEN_VI withContent:sUrlContent];
    [connect release];
}

+ (void)ketNoiChuyenTienDenViHienSoVi:(NSString*)sDenVi soTien:(double)fSoTien noiDung:(NSString*)sNoiDung hienSoVi:(int)hienSoVi token:(NSString*)sToken otp:(NSString*)sOtp typeAuthenticate:(int)nTypeAuthenticate noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSString *sMaDoanhNghiep = @"";
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sMaDoanhNghiep = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_COMPANY_ID];
    }
    NSDictionary *dicPost = @{
                              @"companyCode":sMaDoanhNghiep,
                              @"fromAcc":[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                              @"toAcc":sDenVi,
                              @"amount":[NSNumber numberWithDouble:fSoTien],
                              @"transDesc":sNoiDung,
                              @"token":sToken,
                              @"type":[NSNumber numberWithInt:1],
                              @"giauViChuyen":[NSNumber numberWithInt:hienSoVi],
                              @"appId" : [NSString stringWithFormat:@"%d", APP_ID],
                              @"otpConfirm": sOtp,
                              @"typeAuthenticate": [NSNumber numberWithInt:nTypeAuthenticate],
                              @"VMApp" : [NSNumber numberWithInt:VM_APP]
                              };
    NSString *sUrlContent = [dicPost JSONString];
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connect:URL_CHUYEN_TIEN_DEN_VI withContent:sUrlContent];
    [connect release];
}

+ (void)keyNoiThayDoiHanMuc:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connect:ROOT_URL withContent:dictJSON];
    [connect release];
}

+ (void)ketNoiChuyenTienDenViChuaDangKy:(NSString*)sTenViChuaDangKy
                          noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSString *sMaDoanhNghiep = @"";
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sMaDoanhNghiep = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_COMPANY_ID];
    }
    NSDictionary *dicPost = @{
                              @"companyCode":sMaDoanhNghiep,
                              @"fromAcc":[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                              @"toAcc":sTenViChuaDangKy,
                              @"VMApp" : [NSNumber numberWithInt:VM_APP]
                              };
    NSString *sUrlContent = [dicPost JSONString];
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connect:URL_CHUYEN_TIEN_DEN_VI_CHUA_DANG_KY withContent:sUrlContent];
    [connect release];
    
}

+ (void)ketNoiChuyenTienDenThe:(NSString*)sSoThe
                        soTien:(double)fSoTien
                         token:(NSString*)sToken
                           otp:(NSString*)sOtp
              typeAuthenticate:(int)nTypeAuthenticate
                 noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    
    NSString *sMaDoanhNghiep = @"";
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sMaDoanhNghiep = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_COMPANY_ID];
    }
    NSDictionary *dictPost = @{
                           @"token" : sToken,
                           @"otpConfirm" : sOtp,
                           @"typeAuthenticate" : [NSNumber numberWithInt:nTypeAuthenticate],
                           @"amount" : [NSNumber numberWithDouble:fSoTien],
                           @"companyCode":sMaDoanhNghiep,
                           @"cardNumber" : sSoThe,
                           @"content" : @"",
                           @"id" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                           @"appId" : [NSNumber numberWithInt:APP_ID],
                           @"VMApp" : [NSNumber numberWithInt:VM_APP]
                           };
    
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connect:URL_CHUYEN_TIEN_DEN_THE withContent:[dictPost JSONString]];
    [connect release];
}

+ (void)ketNoiChuyenTienDenTaiKhoanNganHang:(NSString*)sSoTaiKhoan
                                   bankCode:(NSString*)sBankCode
                             tenChuTaiKhoan:(NSString*)sTenChuTaiKhoan
                          noiDungChuyenTien:(NSString*)sNoiDung
                                     soTien:(double)fSoTien
                                      token:(NSString*)sToken
                                        otp:(NSString*)sOtp
                           typeAuthenticate:(int)nTypeAuthenticate
                              noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSString *sMaDoanhNghiep = @"";
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sMaDoanhNghiep = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_COMPANY_ID];
    }
//    NSDictionary *dictPost = @{
//                               @"token" : sToken,
//                               @"otpConfirm" : sOtp,
//                               @"typeAuthenticate" : [NSNumber numberWithInt:nTypeAuthenticate],
//                               @"companyCode":sMaDoanhNghiep,
//                               @"amount" : [NSNumber numberWithDouble:fSoTien],
//                               @"bankCode" : sBankCode,
//                               @"content" : sNoiDung,
//                               @"bankNumber" : sSoTaiKhoan,
//                               @"id" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
//                               @"nameBenefit" : sTenChuTaiKhoan,
//                               @"appId" : [NSNumber numberWithInt:APP_ID],
//                               @"VMApp" : [NSNumber numberWithInt:VM_APP]
//                               };
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:sToken forKey:@"token"];
    [dict setValue:sOtp forKey:@"otpConfirm"];
    [dict setValue:[NSNumber numberWithInt:nTypeAuthenticate] forKey:@"typeAuthenticate"];
    [dict setValue:sMaDoanhNghiep forKey:@"companyCode"];
    [dict setValue:[NSNumber numberWithDouble:fSoTien] forKey:@"amount"];
    [dict setValue:sBankCode forKey:@"bankCode"];
    [dict setValue:sNoiDung forKey:@"content"];
    [dict setValue:sSoTaiKhoan forKey:@"bankNumber"];
    [dict setValue:[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP] forKey:@"id"];
    [dict setValue:sTenChuTaiKhoan forKey:@"nameBenefit"];
    [dict setValue:[NSNumber numberWithInt:APP_ID] forKey:@"appId"];
    [dict setValue:[NSNumber numberWithInt:VM_APP] forKey:@"VMApp"];
    NSString *sDict = [dict JSONString];
    [dict release];
    NSLog(@"%s - sDict : %@", __FUNCTION__, sDict);
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connect:URL_CHUYEN_TIEN_DEN_TAI_KHOAN_NGAN_HANG withContent:sDict];
    [connect release];
}

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
                              noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSString *sMaDoanhNghiep = @"";
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sMaDoanhNghiep = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_COMPANY_ID];
    }
    
    NSDictionary *dictPost = @{
                               @"token" : sToken,
                               @"otpConfirm" : sOtp,
                               @"typeAuthenticate" : [NSNumber numberWithInt:nTypeAuthenticate],
                               @"companyCode":sMaDoanhNghiep,
                               @"amount" : [NSNumber numberWithDouble:fSoTien],
                               @"bankCode" : sBankCode,
                               @"content" : sNoiDung,
                               @"bankNumber" : sSoTaiKhoan,
                               @"id" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                               @"nameBenefit" : sTenChuTaiKhoan,
                               @"appId" : [NSNumber numberWithInt:APP_ID],
                               @"tenChiNhanh" : sBrachName,
                               @"maChiNhanh" : sBrachCode,
                               @"VMApp" : [NSNumber numberWithInt:VM_APP]
                               };
    NSLog(@"%s - dictPost : %@", __FUNCTION__, [dictPost JSONString]);
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connect:URL_CHUYEN_TIEN_DEN_TAI_KHOAN_NGAN_HANG withContent:[dictPost JSONString]];
    [connect release];
}

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
                       noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSString *sMaDoanhNghiep = @"";
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sMaDoanhNghiep = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_COMPANY_ID];
    }
    
    NSDictionary *dictPost = @{
                               @"token" : sToken,
                               @"otpConfirm" : sOtp,
                               @"typeAuthenticate" : [NSNumber numberWithInt:nTypeAuthenticate],
                               @"user" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                               @"companyCode":sMaDoanhNghiep,
                               @"appId" : [NSNumber numberWithInt:APP_ID],
                               @"tenNguoiThuHuong" : sTenNguoiThuHuong,
                               @"cellphoneNumber" : sSoDienThoai,
                               @"soTien" : [NSNumber numberWithDouble:fSoTien],
                               @"cmnd" : sSoCMND,
                               @"tinhThanh" : sTinhThanh,
                               @"quanHuyen" : sQuanHuyen,
                               @"phuongXa" : sPhuongXa,
                               @"diaChi" : sDiaChi,
                               @"noiDung" : sNoiDung,
                               @"VMApp" : [NSNumber numberWithInt:VM_APP]
                               };
    
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connect:URL_CHUYEN_TIEN_DEN_TAN_NHA_BANK_PLUS withContent:[dictPost JSONString]];
    [connect release];
}

+ (void)ketNoiLayChiTietTinMuonTien:(NSString*)sIdTin noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSString *content = [NSString stringWithFormat:@"?id=%@", sIdTin];
    DucNT_ServicePost *ketNoiLaySoDu = [[DucNT_ServicePost alloc] init];
    ketNoiLaySoDu.ducnt_connectDelegate = noiNhanKetQua;
    [ketNoiLaySoDu connectGet:URL_LAY_CHI_TIET_TIN_MUON_TIEN withContent:content];
    [ketNoiLaySoDu release];
}

+ (void)ketNoiMuonTienTaiKhoan:(NSString*)sTaiKhoanMuonTien
                       noiDung:(NSString*)sNoiDung
                        soTien:(double)fSoTien
                         token:(NSString*)sToken
                           otp:(NSString*)sOtp
              typeAuthenticate:(int)nTypeAuthenticate
                 noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSDictionary *dict = @{
                           @"token" : sToken,
                           @"otpConfirm" : sOtp,
                           @"typeAuthenticate" : [NSNumber numberWithInt:nTypeAuthenticate],
                           @"amount" : [NSNumber numberWithDouble:fSoTien],
                           @"fromAcc" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                           @"toAcc" : sTaiKhoanMuonTien,
                           @"message" : sNoiDung,
                           @"appId" : [NSNumber numberWithInt:APP_ID],
                           @"VMApp" : [NSNumber numberWithInt:VM_APP]
                           };
    
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connect:URL_MUON_TIEN_TAI_KHOAN withContent:[dict JSONString]];
    [connect release];

}


+ (void)ketNoiLayChiTietTinMuaTheCao:(NSString*)sIdTin noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSString *content = [NSString stringWithFormat:@"?maGiaoDich=%@", sIdTin];
    DucNT_ServicePost *ketNoiLaySoDu = [[DucNT_ServicePost alloc] init];
    ketNoiLaySoDu.ducnt_connectDelegate = noiNhanKetQua;
    [ketNoiLaySoDu connectGet:URL_LAY_CHI_TIET_TIN_MUA_THE_CAO withContent:content];
    [ketNoiLaySoDu release];
}

+ (void)ketNoiLayDanhSachTaiKhoanThuongDung:(int)nKieuLay
                              noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSString *sID = @"";
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sID = [DucNT_LuuRMS layThongTinDangNhap:KEY_DINH_DANH_DOANH_NGHIEP];
    }
    else if(nKieuDangNhap == KIEU_CA_NHAN)
    {
        sID = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    }
    NSDictionary *dicPost = @{
                              @"phoneOwner":sID,
                              @"type":[NSString stringWithFormat:@"%d", nKieuLay],
                              @"VMApp" : [NSNumber numberWithInt:VM_APP]
                              };
    NSLog(@"%s - dicPost : %@", __FUNCTION__, [dicPost JSONString]);
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connect:URL_LAY_DANH_SACH_TAI_KHOAN_THUONG_DUNG withContent:[dicPost JSONString]];
    [connect release];
}

+ (void)ketNoiXoaTaiKhoanThuongDung:(NSString*)sID
                            kieuLay:(int)nKieuLay
                              token:(NSString*)sToken
                                otp:(NSString*)sOtp
                   typeAuthenticate:(int)nTypeAuthenticate
                      noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSString *sMaDoanhNghiep = @"";
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sMaDoanhNghiep = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_COMPANY_ID];
    }
    NSDictionary *dicPost = @{
                              @"id":sID,
                              @"phoneOwner":[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                              @"companyCode": sMaDoanhNghiep,
                              @"type":[NSString stringWithFormat:@"%d", nKieuLay],
                              @"token" : sToken,
                              @"otpConfirm" : sOtp,
                              @"typeAuthenticate" : [NSNumber numberWithInteger:nTypeAuthenticate],
                              @"appId" : [NSNumber numberWithInt:APP_ID],
                              @"VMApp" : [NSNumber numberWithInt:VM_APP]
                              };
    
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connect:URL_XOA_TAI_KHOAN_THUONG_DUNG withContent:[dicPost JSONString]];
    [connect release];
}

+ (void)ketNoiDangKyThongBaoDinhKy:(NSString *)json noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    NSLog(@"%s - json : %@", __FUNCTION__, json);
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connect:URL_DANG_KY_THONG_BAO_DINH_KY withContent:json];
    [connect release];
}

+ (void)ketNoiHuyThongBaoDinhKy:(NSString *)json noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connect:URL_HUY_THONG_BAO_DINH_KY withContent:json];
    [connect release];
}

+ (void)ketNoiTraCuuHoaDonTienDien:(int)nKieuThanhToan
                          maKhachHang:(NSString*)sMaKhachHang
                          secssion:(NSString*)secssion
                     noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSDictionary *dicPost = @{
                              @"kieuThanhToan":[NSNumber numberWithInt:nKieuThanhToan],
                              @"maKhachHang":sMaKhachHang,
                              @"user" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                              @"secsion" : secssion,
                              @"VMApp" : [NSNumber numberWithInt:VM_APP]
                              };
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connect:URL_TRA_CUU_HOA_DON withContent:[dicPost JSONString]];
    [connect release];
}

+ (void)ketNoiLayChiTietThongTinTraCuuHoaDon:(NSString*)sMaGiaoDich
                               noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSString *content = [NSString stringWithFormat:@"?maGiaoDich=%@", sMaGiaoDich];
    DucNT_ServicePost *ketNoiLaySoDu = [[DucNT_ServicePost alloc] init];
    ketNoiLaySoDu.ducnt_connectDelegate = noiNhanKetQua;
    [ketNoiLaySoDu connectGet:URL_LAY_CHI_TIET_THONG_TIN_TRA_CUU_HOA_DON withContent:content];
    [ketNoiLaySoDu release];
}

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
                               noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSDictionary *dictPost = @{
                               @"token" : sToken,
                               @"otpConfirm" : sOtp,
                               @"typeAuthenticate" : [NSNumber numberWithInt:nTypeAuthenticate],
                               @"amount" : [NSNumber numberWithDouble:fSoTien],
                               @"maKhachHang" : sMaKhachHang,
                               @"noiDung" : sNoiDungThanhToan,
                               @"user" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                               @"kyThanhToan":sKyThanhToan,
                               @"maHoaDon" : sMaHoaDon,
                               @"phoneContact" : sSoDienThoaiLienHe,
                               @"kieuThanhToan" : [NSNumber numberWithInt:nKieuThanhToan],
                               @"appId" : [NSNumber numberWithInt:APP_ID],
                               @"VMApp" : [NSNumber numberWithInt:VM_APP]
                               };
    
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connect:URL_THANH_TOAN_HOA_DON_DIEN withContent:[dictPost JSONString]];
    [connect release];
}

+ (void)ketNoiTraCuuThanhToanDienThoaiViettel:(NSString*)sSoDienThoaiCanTraCuu
                                noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSDictionary *dictPost = @{
                               @"soDienThoai" : sSoDienThoaiCanTraCuu,
                               @"user" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                               @"VMApp" : [NSNumber numberWithInt:VM_APP]
                               };
    
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connect:URL_TRA_CUU_THONG_TIN_THANH_TOAN_DIEN_THOAI_VIETTEL withContent:[dictPost JSONString]];
    [connect release];
}


+ (void)ketNoiNapTienTuTheNganHangKieuRedirectSoTienNap:(double)fSoTienNap
                                                noiDung:(NSString*)sNoiDung
                                               viCanNap:(NSString*)sViNap
                                        nganHangLuaChon:(NSString*)selected_bank
                                          noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSDictionary *dictPost = @{
                               @"soTienNap" : [NSNumber numberWithDouble:fSoTienNap],
                               @"viNap" : sViNap,
                               @"noiDung" : sNoiDung,
                               @"selected_bank" : selected_bank,
                               @"VMApp" : [NSNumber numberWithInt:VM_APP]
                               };
    
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connect:URL_NAP_TIEN_TU_THE_KIEU_REDIRECT withContent:[dictPost JSONString]];
    [connect release];
}

+ (void)ketNoiNapTienTuTheNganHangKieuDirectSoTienNap:(double)fSoTienNap
                                              noiDung:(NSString*)sNoiDung
                                             viCanNap:(NSString*)sViNap
                                      nganHangLuaChon:(NSString*)selected_bank
                                           otpGetType:(NSString*)otpGetType
                                           cardNumber:(NSString*)cardNumber
                                             cardName:(NSString*)cardName
                                            cardMonth:(NSString*)cardMonth
                                             cardYear:(NSString*)cardYear
                                          noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSDictionary *dictPost = @{
                               @"soTienNap"     : [NSNumber numberWithDouble:fSoTienNap],
                               @"viNap"         : sViNap,
                               @"noiDung"       : sNoiDung,
                               @"selected_bank" : selected_bank,
                               @"otpGetType"    : otpGetType,
                               @"cardNumber"    : cardNumber,
                               @"cardName"      : cardName,
                               @"cardMonth"     : cardMonth,
                               @"cardYear"      : cardYear,
                               @"VMApp" : [NSNumber numberWithInt:VM_APP]
                               };
    
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connectPost:URL_NAP_TIEN_TU_THE_KIEU_DIRECT withContent:[dictPost JSONString] timeOut:90];
    [connect release];
}

+ (void)ketNoiNapTienTuTheNganHangKieuDirectTheLuu:(double)fSoTienNap idTheLuu:(NSString*)idTheLuu
                                           noiDung:(NSString*)sNoiDung
                                          viCanNap:(NSString*)sViNap
                                   nganHangLuaChon:(NSString*)selected_bank
                                        otpGetType:(NSString*)otpGetType
                                        cardNumber:(NSString*)cardNumber
                                          cardName:(NSString*)cardName
                                         cardMonth:(NSString*)cardMonth
                                          cardYear:(NSString*)cardYear
                                     noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua{
    NSDictionary *dictPost = @{
                               @"soTienNap" : [NSNumber numberWithDouble:fSoTienNap],
                               @"idTheLuu" : idTheLuu,
                               @"viNap" : sViNap,
                               @"noiDung" : sNoiDung,
                               @"selected_bank" : selected_bank,
                               @"otpGetType" : otpGetType,
                               @"cardNumber" : cardNumber,
                               @"cardName" : cardName,
                               @"cardMonth" : cardMonth,
                               @"cardYear" : cardYear,
                               @"VMApp" : [NSNumber numberWithInt:VM_APP]
                               };

    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connectPost:URL_NAP_TIEN_TU_THE_KIEU_DIRECT withContent:[dictPost JSONString] timeOut:90];
    [connect release];
}

+ (void)ketNoiDangKyTaiKhoanViViMASS:(NSString*)sTaiKhoan
                             matKhau:(NSString*)sMatKhau
                           nameAlias:(NSString*)sNameAlias
                               email:(NSString*)sEmail
                       noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSDictionary *dicString = @{
                                @"id"       : sTaiKhoan,
                                @"pass"     : sMatKhau,
                                @"nameAlias": sNameAlias,
                                @"email"    : sEmail,
                                @"appId"    : [NSNumber numberWithInt:APP_ID],
                                @"funcId"   : [NSNumber numberWithInt:FUNC_REGIS_ID],
                                @"deviceId" : [NSNumber numberWithInt:DEVICE_REGIS_ID],
                                @"VMApp" : [NSNumber numberWithInt:VM_APP]
                                };
    
    
    NSString *postString = [dicString JSONString];
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connect:URL_DANG_KY_TAI_KHOAN_VI_VIMASS withContent:postString];
    [connect release];
}

+ (void)ketNoiDangNhapTaiKhoanViViMASS:(NSString*)sTaiKhoan
                               matKhau:(NSString*)sMatKhau
                         maDoanhNghiep:(NSString*)sMaDoanhNghiep
                         noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{

    NSDictionary *dictPost = @{
                               @"user":sTaiKhoan,
                               @"pass":sMatKhau,
                               @"companyCode":sMaDoanhNghiep,
                               @"deviceId": [NSNumber numberWithInt:DEVICE_REGIS_ID],
                               @"type":@"1",
                               @"VMApp" : [NSNumber numberWithInt:VM_APP]
                               };
    NSLog(@"%s - [dictPost JSONString] : %@", __FUNCTION__, [dictPost JSONString]);
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connect:URL_DANG_NHAP_TAI_KHOAN_VI_VIMASS withContent:[dictPost JSONString]];
    [connect release];
}

+ (void)ketNoiDangNhapTheDaNang:(NSString *)idVID matKhau:(NSString*)sMatKhau noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    NSDictionary *dictPost = @{
                               @"idVid":idVID,
                               @"pass":sMatKhau,
                               @"VMApp" : [NSNumber numberWithInt:VM_APP]
                               };
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connect:URL_DANG_NHAP_THE_DA_NANG withContent:[dictPost JSONString]];
    [connect release];
}

+ (void)ketNoiXacNhanOTPSauKhiNapTienKieuDirect:(NSString*)sIdOtp
                                            otp:(NSString*)sOtp
                                     otpGetType:(NSString*)otpGetType
                       noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSDictionary *dicString = @{
                                @"id"           : sIdOtp,
                                @"otp"          : sOtp,
                                @"otpGetType"   : otpGetType,
                                @"VMApp" : [NSNumber numberWithInt:VM_APP]
                                };

    NSString *postString = [dicString JSONString];
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connect:URL_XAC_NHAN_OTP_SAU_KHI_NAP_TIEN_KIEU_DIRECT withContent:postString];
    [connect release];
}

+ (void)ketNoiMuaTheTroChoiDienTu:(NSNumber*)nhaCungCap
                           soTien:(double)fSoTien
                            token:(NSString*)sToken
                              otp:(NSString*)sOtp
                 typeAuthenticate:(int)nTypeAuthenticate
                    noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSDictionary *dictPost = @{
                               @"token" : sToken,
                               @"otpConfirm" : sOtp,
                               @"typeAuthenticate" : [NSNumber numberWithInt:nTypeAuthenticate],
                               @"nhaCungCap" : nhaCungCap,
                               @"user" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                               @"appId" : [NSNumber numberWithInt:APP_ID],
                               @"soTien" : [NSNumber numberWithDouble:fSoTien],
                               @"VMApp" : [NSNumber numberWithInt:VM_APP]
                               };
    
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connect:URL_MUA_THE_TRO_CHOI_DIEN_TU withContent:[dictPost JSONString]];
    [connect release];
}

+ (void)ketNoiNapTienTroChoiDienTu:(NSNumber*)nhaCungCap sLoaiGame:(NSString *)loaiGame
                          taiKhoan:(NSString*)taiKhoan
                            soTien:(double)fSoTien
                             token:(NSString*)sToken
                               otp:(NSString*)sOtp
                  typeAuthenticate:(int)nTypeAuthenticate
                     noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua{
    NSDictionary *dictPost = @{
                               @"token" : sToken,
                               @"otpConfirm" : sOtp,
                               @"typeAuthenticate" : [NSNumber numberWithInt:nTypeAuthenticate],
                               @"taiKhoan" : taiKhoan,
                               @"nhaCungCap" : nhaCungCap,
                               @"loaiGame" : loaiGame,
                               @"user" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                               @"appId" : [NSNumber numberWithInt:APP_ID],
                               @"soTien" : [NSNumber numberWithDouble:fSoTien],
                               @"VMApp" : [NSNumber numberWithInt:VM_APP]
                               };
    NSLog(@"%s - [dictPost JSONString] : %@", __FUNCTION__, [dictPost JSONString]);
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connect:URL_NAP_TIEN_TRO_CHOI_DIEN_TU withContent:[dictPost JSONString]];
    [connect release];
}

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
                           noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSString *sMaDoanhNghiep = @"";
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sMaDoanhNghiep = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_COMPANY_ID];
    }
    NSDictionary *dictPost = @{
                               @"companyCode":sMaDoanhNghiep,
                               @"token" : sToken,
                               @"otpConfirm" : sOtp,
                               @"typeAuthenticate" : [NSNumber numberWithInt:nTypeAuthenticate],
                               @"user" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                               @"appId" : [NSNumber numberWithInt:APP_ID],
                               @"maNganHang" : sMaNganHang,
                               @"soTien" : [NSNumber numberWithDouble:fSoTien],
                               @"cachThucQuayVong" : [NSNumber numberWithInt:nCachThucQuayVong],
                               @"kyHan" : sKyHan,
                               @"kyLinhLai" : [NSNumber numberWithInt:nKyLinhLai],
                               @"tenNguoiGui" : sTenNguoiGui,
                               @"soCmt" : soCMT,
                               @"diaChi":sDiaChi,
                               @"kieuNhanTien":[NSNumber numberWithInteger:nKieuNhanTien],
                               @"maNganHangNhanTien": sMaNganHangNhanTien,
                               @"tenChuTaiKhoan" : sTenChuTaiKhoan,
                               @"soTaiKhoan" : sSoTaiKhoan,
                               @"VMApp" : [NSNumber numberWithInt:VM_APP]
                               };
    
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connect:URL_GUI_TIEN_TIET_KIEM withContent:[dictPost JSONString]];
    [connect release];
}

+ (void)ketNoiLayDanhSachSoTietKiem:(NSString*)secssion noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    DucNT_TaiKhoanViObject *infoVi = [DucNT_LuuRMS layThongTinTaiKhoanVi];
    NSString *content = [NSString stringWithFormat:@"?user=%@&secssion=%@", infoVi.sID, secssion];
    NSLog(@"%s - content : %@", __FUNCTION__, content);
    DucNT_ServicePost *ketNoiLaySoDu = [[DucNT_ServicePost alloc] init];
    ketNoiLaySoDu.ducnt_connectDelegate = noiNhanKetQua;
    [ketNoiLaySoDu connectGet:URL_TRA_CUU_DANH_SACH_SO_TIET_KIEM withContent:content];
    [ketNoiLaySoDu release];
}

+ (void)ketNoiRutSoTietKiem:(NSString*)sSoSoTietKiem
                      token:(NSString*)sToken
                        otp:(NSString*)sOtp
           typeAuthenticate:(int)nTypeAuthenticate
              noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSString *sMaDoanhNghiep = @"";
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sMaDoanhNghiep = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_COMPANY_ID];
    }
    NSDictionary *dictPost = @{
                               @"companyCode":sMaDoanhNghiep,
                               @"token" : sToken,
                               @"otpConfirm" : sOtp,
                               @"typeAuthenticate" : [NSNumber numberWithInt:nTypeAuthenticate],
                               @"user" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                               @"appId" : [NSNumber numberWithInt:APP_ID],
                               @"soSoTietKiem": sSoSoTietKiem,
                               @"VMApp" : [NSNumber numberWithInt:VM_APP]
                               };
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connect:URL_RUT_SO_TIET_KIEM withContent:[dictPost JSONString]];
    [connect release];
}

+ (void)ketNoiLayDanhSachNganHangGuiTietKiem:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSLog(@"%s - URL_LAY_DANH_SACH_NGAN_HANG_GUI_TIET_KIEM : %@", __FUNCTION__, URL_LAY_DANH_SACH_NGAN_HANG_GUI_TIET_KIEM);
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connectGet:URL_LAY_DANH_SACH_NGAN_HANG_GUI_TIET_KIEM withContent:@""];
    [connect release];
}

+ (NSData*)ketNoiLayChiTietSoTietKiem:(NSString*)sMaSoSo
                          secssion:(NSString*)secssion
                  dinhDanhDoanhNghiep:(NSString*)sDinhDanhDoanhNghiep
{
    
//    NSString *sDinhDanhDoanhNghiep = [DucNT_LuuRMS layThongTinDangNhap:KEY_DINH_DANH_DOANH_NGHIEP];
    NSMutableString *sContent = [[[NSMutableString alloc] init] autorelease];
    [sContent appendFormat:@"?user=%@",sDinhDanhDoanhNghiep];
    [sContent appendFormat:@"&secssion=%@",secssion];
    [sContent appendFormat:@"&soSoTietKiem=%@",sMaSoSo];
    return [DucNT_ServicePost connectGet:URL_LAY_CHI_TIET_SO_TIET_KIEM withContent:sContent showAlert:YES];
}


+ (void)ketNoiLayDanhSachDuyetGiaoDichTuNgay:(long long)nTuNgay
                                     denNgay:(long long)nDenNgay
                                       viTri:(int)nViTriBatDauLay
                                     soLuong:(int)nSoLuongGiaoDichCanLay
                               noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSString *sUser = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    NSString *sDinhDanhDoanhNghiep = [DucNT_LuuRMS layThongTinDangNhap:KEY_DINH_DANH_DOANH_NGHIEP];
    NSMutableString *sContent = [[[NSMutableString alloc] init] autorelease];
    [sContent appendFormat:@"?user=%@",sUser];
    [sContent appendFormat:@"&companyCode=%@",sDinhDanhDoanhNghiep];
    [sContent appendFormat:@"&from=%@",[NSNumber numberWithLongLong:nTuNgay]];
    [sContent appendFormat:@"&to=%@",[NSNumber numberWithLongLong:nDenNgay]];
    [sContent appendFormat:@"&offset=%@",[NSNumber numberWithInt:nViTriBatDauLay]];
    [sContent appendFormat:@"&limit=%@",[NSNumber numberWithInt:nSoLuongGiaoDichCanLay]];
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connectGet:URL_LAY_DANH_SACH_DUYET_GIAO_DICH withContent:sContent];
    [connect release];
}

+ (void)ketNoiLayChiTietDuyetGiaoDich:(NSString*)sMaGiaoDich
                        noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSString *sUser = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    NSString *sDinhDanhDoanhNghiep = @"";
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sDinhDanhDoanhNghiep = [DucNT_LuuRMS layThongTinDangNhap:KEY_DINH_DANH_DOANH_NGHIEP];
    }
    NSMutableString *sContent = [[[NSMutableString alloc] init] autorelease];
    [sContent appendFormat:@"?user=%@",sUser];
    [sContent appendFormat:@"&companyCode=%@",sDinhDanhDoanhNghiep];
    [sContent appendFormat:@"&maGiaoDich=%@",sMaGiaoDich];
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connectGet:URL_LAY_CHI_TIET_DUYET_GIAO_DICH withContent:sContent];
    [connect release];
}


+ (void)ketNoiHuyDuyetGiaoDich:(NSArray*)dsMaGiaoDich
                      chucNang:(int)nFuncID
                 maDoanhNghiep:(NSString*)sMaDoanhNghiep
                       noiDung:(NSString*)sNoiDungHuy
                         token:(NSString*)sToken
                           otp:(NSString*)sOtp
              typeAuthenticate:(int)nTypeAuthenticate
                 noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSDictionary *dictPost = @{
                               @"companyCode":sMaDoanhNghiep,
                               @"dsGiaoDich":dsMaGiaoDich,
                               @"lyDoDuyetThatBai" : sNoiDungHuy,
                               @"funcId":[NSNumber numberWithInt:nFuncID],
                               @"user" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                               @"token" : sToken,
                               @"otpConfirm" : sOtp,
                               @"typeAuthenticate" : [NSNumber numberWithInt:nTypeAuthenticate],
                               @"appId" : [NSNumber numberWithInt:APP_ID],
                               @"VMApp" : [NSNumber numberWithInt:VM_APP]
                               };
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connect:URL_HUY_DUYET_GIAO_DICH withContent:[dictPost JSONString]];
    [connect release];
}

+ (void)ketNoiDuyetGiaoDich:(NSArray*)dsMaGiaoDich
                   chucNang:(int)nFuncID
                    noiDung:(NSString*)sNoiDungHuy
              maDoanhNghiep:(NSString*)sMaDoanhNghiep
                      token:(NSString*)sToken
                        otp:(NSString*)sOtp
           typeAuthenticate:(int)nTypeAuthenticate
              noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSDictionary *dictPost = @{
                               @"companyCode":sMaDoanhNghiep,
                               @"dsGiaoDich":dsMaGiaoDich,
                               @"lyDoDuyetThatBai" : sNoiDungHuy,
                               @"funcId":[NSNumber numberWithInt:nFuncID],
                               @"user" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                               @"token" : sToken,
                               @"otpConfirm" : sOtp,
                               @"typeAuthenticate" : [NSNumber numberWithInt:nTypeAuthenticate],
                               @"appId" : [NSNumber numberWithInt:APP_ID],
                               @"VMApp" : [NSNumber numberWithInt:VM_APP]
                               };
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connect:URL_DUYET_GIAO_DICH withContent:[dictPost JSONString]];
    [connect release];

}

+ (void)ketNoiLayDanhSachDiaDiem:(NSString*)keyword langId:(int)langId limit:(int)limit page:(int)page status:(int)status compress:(int)compress lat:(double)lat lng:(double)lng r:(double)r categoryId:(NSString*)categoryId noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua{
    NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
    [dicPost setValue:keyword forKey:@"keyword"];
    [dicPost setValue:categoryId forKey:@"categoryId"];
    [dicPost setValue:[NSNumber numberWithInt:langId] forKey:@"langId"];
    [dicPost setValue:[NSNumber numberWithInt:limit] forKey:@"limit"];
    [dicPost setValue:[NSNumber numberWithInt:page] forKey:@"page"];
    [dicPost setValue:[NSNumber numberWithInt:status] forKey:@"status"];
    [dicPost setValue:[NSNumber numberWithInt:compress] forKey:@"compress"];
    [dicPost setValue:[NSNumber numberWithDouble:lat] forKey:@"lat"];
    [dicPost setValue:[NSNumber numberWithDouble:lng] forKey:@"lng"];
    [dicPost setValue:[NSNumber numberWithInt:r] forKey:@"r"];
//    NSDictionary *dicPost = @{@"keyword": keyword,
//                              @"langId":[NSNumber numberWithInt:langId],
//                              @"limit":[NSNumber numberWithInt:limit],
//                              @"page":[NSNumber numberWithInt:page],
//                              @"status":[NSNumber numberWithInt:status],
//                              @"compress":[NSNumber numberWithInt:compress],
//                              @"lat":[NSNumber numberWithDouble:lat],
//                              @"lng":[NSNumber numberWithDouble:lng],
//                              @"r":[NSNumber numberWithInt:r],
//                              @"categoryId":categoryId,
//                              };
    NSLog(@"%s - dicPost : %@", __FUNCTION__, [dicPost JSONString]);
    NSString *url = @"https://vimass.vn/mcommerce/services/place/search?appToken=abc&userToken=null";
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:noiNhanKetQua];
    [connect connectDiaDiem:url withContent:[dicPost JSONString]];
    [connect release];
    [dicPost release];
}
+ (void)chuyentienDienThoai:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    
    NSString *url = @"https://vimass.vn/vmbank/services/danhBa/chuyenTien";
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:url withContent:dictJSON];
    [connectPost release];

}

//+ (void)confirmChuyenTienDienThoai:(NSString*)session
//                                id:(NSString*)iid
//                            status:(BOOL*)status
//                     noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua{
+ (void)confirmChuyenTienDienThoai:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {

//    NSDictionary *dictPost = @{
//                               @"session":session,
//                               @"id":iid,
//                               @"user" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
//                               @"status" : [NSNumber numberWithBool:status]
//                               };
//    NSLog(@"%s - dicPost : %@", __FUNCTION__, [dictPost JSONString]);
    NSString *url = @"https://vimass.vn/vmbank/services/danhBa/confirmChuyenTien";
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:url withContent:dictJSON];
    [connectPost release];
}

+ (void)dangkyPKI:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    NSLog(@"%s - dictJSON : %@", __FUNCTION__, dictJSON);
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_DANG_KY_PKI withContent:dictJSON];
    [connectPost release];
}
+ (void)xacnhanDangKyPKI:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    NSLog(@"%s - dictJSON : %@", __FUNCTION__, dictJSON);
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_XAC_NHAN_DANG_KY_PKI withContent:dictJSON];
    [connectPost release];
}
+ (void)caidatHanMucPKI:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua {
    NSLog(@"%s - dictJSON : %@", __FUNCTION__, dictJSON);
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:URL_CAI_DAT_HAN_MUC_PKI withContent:dictJSON];
    [connectPost release];
}

+ (void)traCuuSoTay:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua{
    NSLog(@"%s - dictJSON : %@", __FUNCTION__, dictJSON);
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:@"https://vimass.vn/vmbank/services/danhBa/traCuuSoTay" withContent:dictJSON];
    [connectPost release];
}
+(void)xoaSoTay:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua{
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:@"https://vimass.vn/vmbank/services/danhBa/xoaSoTay" withContent:dictJSON];
    [connectPost release];

}
+(void)suaThongTinSoTay:(NSString *)dictJSON noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua{
    DucNT_ServicePost *connectPost = [[DucNT_ServicePost alloc] init];
    [connectPost setDucnt_connectDelegate:noiNhanKetQua];
    [connectPost connect:@"https://vimass.vn/vmbank/services/danhBa/suaThongTinSoTay" withContent:dictJSON];
    [connectPost release];
}
@end
