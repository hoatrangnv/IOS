//
//  ThanhToanTienDienViewController.m
//  ViViMASS
//
//  Created by DucBui on 4/14/15.
//
//

#import "ThanhToanTienDienViewController.h"
#import "MoTaChiTietHoaDonDien.h"
#import "MaDienLuc.h"

@interface ThanhToanTienDienViewController () {
    ViewQuangCao *viewQC;
}

@end

@implementation ThanhToanTienDienViewController

#pragma mark - lifecircle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self khoiTaoBanDau];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self xuLyKetNoiLaySoDuTaiKhoan];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.mtfNoiDung resignFirstResponder];
    [self.mtvNoiDung resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - khoiTao

- (void)khoiTaoBanDau
{
    [self addButtonBack];
    self.mFuncID = FUNC_THANH_TOAN_DIEN_LUC;
    NSString *sTitle = [@"thanh_toan_tien_dien" localizableString];
    if (self.nChucNang == 2) {
        sTitle = @"Thanh toán tiền nước";
    }
    [self addTitleView:sTitle];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self khoiTaoGiaoDien];
    });
    self.mtfMaKhachHang.enabled = NO;
    self.mtfTenKhuVucThanhToan.enabled = NO;
    self.mtfTenKhachHang.enabled = NO;
    self.mtvDiaChi.editable = NO;
    self.mtfKyThanhToan.enabled = NO;
    self.mtfSoTien.enabled =NO;
    self.mtfSoPhi.enabled = NO;
    [self.mtfSoDienThoaiLienHe setPlaceholder:[NSString stringWithFormat:@"%@(%@)",[@"dien_thoai_lien_he" localizableString], [@"co_the_bo_qua" localizableString]]];
    [self.mtfNoiDung setPlaceholder:[NSString stringWithFormat:@"%@(%@)",[@"noi_dung" localizableString], [@"co_the_bo_qua" localizableString]]];
    [self.mtfSoDienThoaiLienHe setType:ExTextFieldTypePhone];
    if(_mMoTaChiTietKhachHang)
    {
        [self.mtfMaKhachHang setText:_mMoTaChiTietKhachHang.maKhachHang];
        [self.mtfTenKhuVucThanhToan setText:_mMoTaChiTietKhachHang.maDienLuc];
        [self.mtfTenKhachHang setText:_mMoTaChiTietKhachHang.tenKhachHang];
        [self.mtvDiaChi setText:_mMoTaChiTietKhachHang.diaChi];
        [self.mtfKyThanhToan setText:[NSString stringWithFormat:@"Kỳ thanh toán: %@",_mMoTaChiTietKhachHang.kyThanhToan]];
        [self.mtfSoTien setText:[Common hienThiTienTe:[_mMoTaChiTietKhachHang.total doubleValue]]];
        double fSoPhi = [Common layPhiChuyenTienCuaSoTien:[_mMoTaChiTietKhachHang.total doubleValue] kieuChuyenTien:KIEU_CHUYEN_TIEN_DEN_VI maNganHang:@""];
        [self.mtfSoPhi setText:[Common hienThiTienTe_1:fSoPhi]];
        self.mtfSoDienThoaiLienHe.text = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    }

    _mtfTenKhuVucThanhToan.borderStyle = UITextBorderStyleNone;
    _mtfTenKhuVucThanhToan.background = nil;
    _mtfMaKhachHang.borderStyle = UITextBorderStyleNone;
    _mtfMaKhachHang.background = nil;
    _mtfTenKhachHang.borderStyle = UITextBorderStyleNone;
    _mtfTenKhachHang.background = nil;
    _mtfDiaChi.borderStyle = UITextBorderStyleNone;
    _mtfDiaChi.background = nil;
    _mtfKyThanhToan.borderStyle = UITextBorderStyleNone;
    _mtfKyThanhToan.background = nil;
    _mtfSoTien.borderStyle = UITextBorderStyleNone;
    _mtfSoTien.background = nil;
    _mtfSoPhi.borderStyle = UITextBorderStyleNone;
    _mtfSoPhi.background = nil;

}

- (void)khoiTaoGiaoDien
{
    CGRect rbtnVanTay = self.mbtnVanTay.frame;
    CGRect rViewMain = self.mViewMain.frame;
    rViewMain.origin.y = self.viewOptionTop.frame.origin.y + self.viewOptionTop.frame.size.height - 5;
    rViewMain.origin.x = 10;
    rViewMain.size.height += 60;
    rbtnVanTay.origin.y = rViewMain.origin.y + rViewMain.size.height + 20;
    rbtnVanTay.origin.x = (self.mscrv.frame.size.width - rbtnVanTay.size.width) / 2;
    float fHeight = rbtnVanTay.origin.y + rbtnVanTay.size.height + 10;

    self.mbtnVanTay.frame = rbtnVanTay;
    self.mViewMain.frame = rViewMain;
    [self.mscrv addSubview:self.mViewMain];
    [self.mscrv addSubview:self.mbtnVanTay];
    [self.mscrv bringSubviewToFront:self.viewOptionTop];
    self.mscrv.contentSize = CGSizeMake(self.mscrv.frame.size.width, fHeight);

}

- (void)khoiTaoQuangCao {
//    viewQC = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ViewQuangCao class]) owner:self options:nil] objectAtIndex:0];
//    viewQC.mDelegate = self;
//    CGRect rectToken = self.mViewNhapToken.frame;
//    CGRect rectQC = viewQC.frame;
//    CGRect rectMain = self.mViewMain.frame;
//
//    rectQC.origin.y = rectToken.origin.y + rectToken.size.height + 15;
//    viewQC.frame = rectQC;
//    rectMain.size.height = rectQC.origin.y + rectQC.size.height + 10;
//    self.mViewMain.frame = rectMain;
//    [self.mViewMain addSubview:viewQC];
//    [self.mscrv setContentSize:CGSizeMake(_mscrv.frame.size.width, viewQC.frame.origin.y + viewQC.frame.size.height + 10)];

}


#pragma mark - overriden GiaoDich

- (BOOL)validateVanTay
{
    BOOL flg = YES;
    if(_mtfSoDienThoaiLienHe.text.length > 0)
    {
        flg = [_mtfSoDienThoaiLienHe validate];
        if(!flg)
            [_mtfSoDienThoaiLienHe show_error];
    }

    return flg;
}

- (void)xuLyThucHienKhiKiemTraThanhCongTraVeToken:(NSString *)sToken otp:(NSString *)sOtp
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_THANH_TOAN_HOA_DON_DIEN_KHACH_HANG;
        int nKieuThanhToan = [Common layKieuThanhToanHoaDonDienTheoMaKhachHang:_mMoTaChiTietKhachHang.maKhachHang];
        if (self.nChucNang == 2) {
            nKieuThanhToan = [self layMaThanhToanNhaMayNuoc:_mMoTaChiTietKhachHang.maDienLuc];
        }
        if(nKieuThanhToan == -1)
        {
            if (self.nChucNang == 2) {
                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Không lấy được kiểu thanh toán tiền nước"];
            }
            else {
                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:[NSString stringWithFormat:[@"thong_bao_chuc_nang_thanh_toan_dang_duoc_hoan_tat" localizableString], _mMoTaChiTietKhachHang.maKhachHang, _mMoTaChiTietKhachHang.maDienLuc]];
            }
        }
        else
        {
            self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_THANH_TOAN_HOA_DON_DIEN_KHACH_HANG;
            NSMutableString * sMaHoaDon = [[[NSMutableString alloc] init] autorelease];
            NSMutableString * sKyThanhToan = [[[NSMutableString alloc] init] autorelease];
            int nCount = (int)_mMoTaChiTietKhachHang.list.count;
            
            for(int i = 0; i < nCount; i ++)
            {
                MoTaChiTietHoaDonDien *moTaChiTietHoaDonDien = [_mMoTaChiTietKhachHang.list objectAtIndex:i];
                if(i < nCount - 1)
                {
                    [sMaHoaDon appendFormat:@"%@,",moTaChiTietHoaDonDien.maHoaDon];
                    [sKyThanhToan appendFormat:@"%@,",moTaChiTietHoaDonDien.kyThanhToan];
                }
                else if (i == nCount - 1)
                {
                    [sMaHoaDon appendString:moTaChiTietHoaDonDien.maHoaDon];
                    [sKyThanhToan appendString:moTaChiTietHoaDonDien.kyThanhToan];
                }
            }
            NSLog(@"_mMoTaChiTietKhachHang.maKhachHang : %@", _mMoTaChiTietKhachHang.maKhachHang);
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
                [self hienThiLoading];
            }
            
            [GiaoDichMang ketNoithanhToanHoaDonDienKieuThanhToan:nKieuThanhToan
                                                     maKhachHang:_mMoTaChiTietKhachHang.maKhachHang
                                                          soTien:[_mMoTaChiTietKhachHang.total doubleValue]
                                                         noiDung:_mtvNoiDung.text
                                               soDienThoaiLienHe:_mtfSoDienThoaiLienHe.text
                                                        maHoaDon:sMaHoaDon
                                                     kyThanhToan:sKyThanhToan
                                                           token:sToken
                                                             otp:sOtp
                                                typeAuthenticate:self.mTypeAuthenticate
                                                   noiNhanKetQua:self];
        }
    });
}

- (void)xuLyKetNoiThanhCong:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua
{
    [super xuLyKetNoiThanhCong:sDinhDanhKetNoi thongBao:sThongBao ketQua:ketQua];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
//        [self anLoading];
    }
    if([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_THANH_TOAN_HOA_DON_DIEN_KHACH_HANG])
        [self hienThiHopThoaiMotNutBamKieu:HOP_THOAI_XAC_NHAN_CHUYEN_TIEN_THANH_CONG cauThongBao:sThongBao];
}

//- (void)xuLyKetNoiThatBai:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua {
//    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
////        [self anLoading];
//    }
//}

- (int)layMaThanhToanNhaMayNuoc:(NSString *)row{
    if ([row isEqualToString:@"Nhà Bè"]) {
        return 103;
    }
    else if ([row isEqualToString:@"Bến Thành"]) {
        return 105;
    }
    else if ([row isEqualToString:@"Chợ Lớn"]) {
        return 107;
    }
    else if ([row isEqualToString:@"Phú Hòa Tân"]) {
        return 109;
    }
    else if ([row isEqualToString:@"Thủ Đức"]) {
        return 111;
    }
    else if ([row isEqualToString:@"Trung An"]) {
        return 113;
    }
    else if ([row isEqualToString:@"Tân Hòa"]) {
        return 115;
    }
    return -1;
}

#pragma mark - dealloc

- (void)dealloc
{
    [viewQC release];
    if(_mDanhSachMaDienLuc)
        [_mDanhSachMaDienLuc release];
    if(_mMoTaChiTietKhachHang)
        [_mMoTaChiTietKhachHang release];
    [_mtfTenKhuVucThanhToan release];
    [_mtfMaKhachHang release];
    [_mtfTenKhachHang release];
    [_mtfSoDienThoaiLienHe release];
    [_mtvDiaChi release];
    [_mtfKyThanhToan release];
    [_mtfSoTien release];
    [_mtfSoPhi release];
    [_mtvNoiDung release];
    [_mtfDiaChi release];
    [_mtfNoiDung release];
    [_mscrv release];
    [super dealloc];
}
@end
