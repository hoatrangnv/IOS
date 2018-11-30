//
//  GiaoDienThanhToanSauTraCuuInternet.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 10/19/15.
//
//

#import "GiaoDienThanhToanSauTraCuuInternet.h"

@interface GiaoDienThanhToanSauTraCuuInternet (){
    float fPhi;
    int nMaNhaCungCap;
}

@end

@implementation GiaoDienThanhToanSauTraCuuInternet

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addButtonBack];
    fPhi = 1100;
    nMaNhaCungCap = 1;
//    self.navigationItem.title = @"Thanh toán Internet";
    [self addTitleView:@"Thanh toán Internet"];
    self.mFuncID = FUNC_THANH_TOAN_INTERNET;

    self.mViewMain.layer.cornerRadius = 3.0f;

    if (self.idTypeShow && self.idTypeShow.length > 0) {
        [self ketNoiLayChiTietHoaDonInternet:self.idTypeShow];
    }
}

- (void)ketNoiLayChiTietHoaDonInternet:(NSString *)sIdHoaDon{
    self.mDinhDanhKetNoi = DINH_DANH_CHI_TIET_INTERNET;
    [GiaoDichMang layChiTietHoaDonInternet:sIdHoaDon noiNhanKetQua:self];
}

- (void)xuLyKetNoiThanhCong:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua{

    if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_CHI_TIET_INTERNET]){
//        NSDictionary *dicInternet = [ketQua objectForKey:@"result"];
        double dSoTien = [[ketQua objectForKey:@"soTien"] doubleValue];
        NSString *maThueBao = [ketQua objectForKey:@"maThueBao"];
        NSLog(@"%s - ketQua : %@", __FUNCTION__, ketQua);
        int maNhaCungCap = [[ketQua objectForKey:@"maNhaCungCap"] intValue];
        nMaNhaCungCap = maNhaCungCap;
        self.mtfMaKhachHang.text = maThueBao;
        self.mtfSoTien.text = [Common hienThiTienTe:dSoTien];
        double fSoPhi = [Common layPhiChuyenTienCuaSoTien:dSoTien kieuChuyenTien:KIEU_CHUYEN_TIEN_DEN_VI maNganHang:@""];
//        if (nMaNhaCungCap == 1) {
//            fSoPhi = 3300;
//        }
        fPhi = fSoPhi;
        self.lblPhi.text = [NSString stringWithFormat:@"Phí: %@đ", [Common hienThiTienTe:fSoPhi]];

        switch (maNhaCungCap) {
            case 1:
                self.mtfNhaCungCap.text = @"VNPT Hà Nội";
                break;
            case 2:
                self.mtfNhaCungCap.text = @"VNPT Hồ Chí Minh";
                break;
            case 3:
                self.mtfNhaCungCap.text = @"VNPT Hải Phòng";
                break;
            case 4:
                self.mtfNhaCungCap.text = @"FPT";
                break;
            case 5:
                self.mtfNhaCungCap.text = @"VIETTEL";
                break;
            default:
                break;
        }
    }
}

- (void)hideViewNhapToken {
    
}

- (BOOL)validateVanTay{
    BOOL flag = YES;
    NSString *sSoTien = [_mtfSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    double fSoTien = [sSoTien doubleValue];
    if (fSoTien + fPhi >= [self.mThongTinTaiKhoanVi.nAmount doubleValue]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Số dư tài khoản không đủ"];
        flag = NO;
    }
    if (self.mtfMaKhachHang.text.length == 0) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Lỗi khi lấy chi tiết hoá đơn Internet"];
        flag = NO;
    }
    return flag;
}

- (void)xuLyThucHienKhiKiemTraThanhCongTraVeToken:(NSString *)sToken otp:(NSString *)sOtp{
    NSLog(@"%s - START", __FUNCTION__);
    self.mDinhDanhKetNoi = DINH_DANH_THANH_TOAN_TIEN_INTERNET;
    NSString *sSoTien = [_mtfSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    int fSoTien = [sSoTien intValue];
    [GiaoDichMang thanhToanHoaDonInternet:self.mtfMaKhachHang.text maNhaCungCap:nMaNhaCungCap soTien:fSoTien token:sToken otpConfirm:sOtp typeAuthenticate:self.mTypeAuthenticate noiNhanKetQua:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)dealloc {
    [_mtfMaKhachHang release];
    [_mtfSoTien release];
    if (self.idTypeShow) {
        [self.idTypeShow release];
    }
    [_lblPhi release];
    [_mtfNhaCungCap release];
    [super dealloc];
}
@end
