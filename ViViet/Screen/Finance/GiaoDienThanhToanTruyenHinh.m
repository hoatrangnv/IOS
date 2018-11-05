//
//  GiaoDienThanhToanTruyenHinh.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 3/3/16.
//
//

#import "GiaoDienThanhToanTruyenHinh.h"

@interface GiaoDienThanhToanTruyenHinh () {
    ViewQuangCao *viewQC;
}

@end

@implementation GiaoDienThanhToanTruyenHinh

- (void)viewDidLoad {
    [super viewDidLoad];
//    https://vimass.vn/vmbank/services/ThanhToanTruyenHinhCapService/layChiTietGiaoDichThanhToanTruyenHinhCap?id=xxx
//    https://vimass.vn/vmbank/services/ThanhToanTruyenHinhCapService/thanhToanHoaDon
//    self.navigationItem.title = @"Thanh toán truyền hình";
    [self addTitleView:@"Thanh toán truyền hình"];
    self.mFuncID = FUNC_THANH_TOAN_TRUYEN_HINH_CAP;
    self.edMaThueBao.text = self.sMaThueBao;
    switch (_nNhaCungCap) {
        case NHA_CUNG_CAP_TRUYEN_HINH_CAP_VTV:
            self.edNhaCungCap.text = @"VTVCab - Truyền hình cáp Việt Nam";
            break;
        case NHA_CUNG_CAP_TRUYEN_HINH_CAP_VTC:
            self.edNhaCungCap.text = @"VTC - Truyền hình vệ tinh số";
            break;
        case NHA_CUNG_CAP_TRUYEN_HINH_CAP_MY_TV:
            self.edNhaCungCap.text = @"MyTV - Truyền hình VNPT";
            break;
        default:
            break;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_edSoTien setTextError:[@"so_tien_khong_duoc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    [_edSoTien setType:ExTextFieldTypeMoney];
    _edSoTien.inputAccessoryView = nil;
    [self khoiTaoQuangCao];
}

- (void)khoiTaoQuangCao {
    viewQC = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ViewQuangCao class]) owner:self options:nil] objectAtIndex:0];
    viewQC.mDelegate = self;
    CGRect rectToken = self.mViewNhapToken.frame;
    CGRect rectQC = viewQC.frame;
    CGRect rectMain = self.mViewMain.frame;
    CGFloat fW = rectMain.size.width;
    CGFloat fH = rectQC.size.height * ((rectMain.size.width) / rectQC.size.width);
    rectQC.origin.y = rectToken.origin.y + rectToken.size.height + 15;
    viewQC.frame = CGRectMake(0, rectQC.origin.y, fW, fH);
    viewQC.mDelegate = self;
    [viewQC updateSizeQuangCao];
    rectMain.size.height = rectQC.origin.y + rectQC.size.height + 50;
    self.mViewMain.frame = rectMain;
    [self.mViewMain addSubview:viewQC];
}

- (BOOL)validateVanTay
{
    if (_edSoTien.text.isEmpty) {
        [UIAlertView alert:[@"so_tien_khong_duoc_de_trong" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
        return NO;
    }

    int fSoTien = [[_edSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""] intValue];
    if (fSoTien >= [self.mThongTinTaiKhoanVi.nAmount doubleValue]) {
        [UIAlertView alert:@"Số dư trong tài khoản không đủ" withTitle:[@"thong_bao" localizableString] block:nil];
        return NO;
    }
    return YES;
}

- (void)xuLyThucHienKhiKiemTraThanhCongTraVeToken:(NSString*)sToken otp:(NSString*)sOtp
{
    double fSoTien = [[[self.edSoTien.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
    self.mDinhDanhKetNoi = DINH_DANH_THANH_TOAN_TRUYEN_HINH;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self hienThiLoading];
    }
    [GiaoDichMang thanhToanHoaDonTruyenHinh:_sIdTraCuu maNhaCungCap:_nNhaCungCap soTien:fSoTien token:sToken otpConfirm:sOtp typeAuthenticate:self.mTypeAuthenticate noiNhanKetQua:self];
}

- (void)xuLyKetNoiThanhCong:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self anLoading];
    }
    [self hienThiHopThoaiMotNutBamKieu:HOP_THOAI_XAC_NHAN_CHUYEN_TIEN_THANH_CONG cauThongBao:sThongBao];
}

- (void)dealloc {
    [_sIdTraCuu release];
    [_edMaThueBao release];
    [_edNhaCungCap release];
    [_edSoTien release];
    [super dealloc];
}

@end
