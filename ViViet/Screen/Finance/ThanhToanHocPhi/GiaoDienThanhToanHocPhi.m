//
//  GiaoDienThanhToanHocPhi.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 3/8/16.
//
//

#import "GiaoDienThanhToanHocPhi.h"
#import "DucNT_DanhSachTaiKhoanThuongDungControllerViewController.h"
#import "GiaoDienThongTinPhim.h"

@interface GiaoDienThanhToanHocPhi () {
    int nIndexTruongHoc;
    int nIndexGiaoDich;
    int nTagPicker;
    ViewQuangCao *viewQC;
}

@end

@implementation GiaoDienThanhToanHocPhi

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"Thanh toán học phí";
    [self addTitleView:@"Thanh toán học phí"];
    nIndexTruongHoc = 0;
    nIndexGiaoDich = 0;
    nTagPicker = 0;
    self.mFuncID = FUNC_CHUYEN_TIEN_DEN_VI_MOMO;
    [self khoiTaoTextFeildTheoYChuTit:self.edTruongHoc nTag:100 dataPicker:self delegatePicker:self];
    [self khoiTaoTextFeildTheoYChuTit:self.edLoaiGiaoDich nTag:101 dataPicker:self delegatePicker:self];
    [self themButtonHuongDanSuDung:@selector(suKienBamNutHuongDanHocPhi:)];
    [_edSoTien setTextError:[@"so_tien_khong_duoc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    [_edSoTien setType:ExTextFieldTypeMoney];
    _edSoTien.inputAccessoryView = nil;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateThongTinHocPhi:) name:KEY_TAI_KHOAN_THUONG_DUNG object:nil];

}

- (void)updateThongTinHocPhi:(NSNotification *)notification
{
    if([[notification name] isEqualToString:KEY_TAI_KHOAN_THUONG_DUNG])
    {
        DucNT_TaiKhoanThuongDungObject *temp = [notification object];

        NSString *sTenDichVu = [self getTenTruongHoc:temp.loaiDichVuHocPhi];
        _edTruongHoc.text = sTenDichVu;
        nIndexTruongHoc = [self getIndexTruongHoc:sTenDichVu];
        _edTenKH.text = temp.tenKhachHangHocPhi;
        _edMaKH.text = temp.maKhachHangHocPhi;
        _edSoTien.text = [Common hienThiTienTe:temp.soTien];
        _tvNoiDung.text = temp.noiDung;
    }
}

- (void)khoiTaoQuangCao {
    if (viewQC) {
        return;
    }
    viewQC = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ViewQuangCao class]) owner:self options:nil] objectAtIndex:0];
    viewQC.mDelegate = self;
    CGRect rectToken = self.mViewNhapToken.frame;
    CGRect rectQC = viewQC.frame;
    CGRect rectMain = self.mViewMain.frame;
    CGFloat fW = rectMain.size.width;
    CGFloat fH = fW * 0.45333;
    rectQC.origin.y = rectToken.origin.y + rectToken.size.height + 15.0;
    viewQC.frame = CGRectMake(0, rectQC.origin.y, fW, fH);
    viewQC.mDelegate = self;
    [viewQC updateSizeQuangCao];
    rectMain.size.height = rectQC.origin.y + rectQC.size.height;
    self.mViewMain.frame = rectMain;
    [self.mViewMain addSubview:viewQC];
    [self.scrMain setContentSize:CGSizeMake(_scrMain.frame.size.width, viewQC.frame.origin.y + viewQC.frame.size.height + self.viewOptionTop.frame.origin.y + self.viewOptionTop.frame.size.height + 20)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setAnimationChoSoTay:self.btnSoTay];
    [self.tvNoiDung resignFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self khoiTaoQuangCao];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.btnSoTay.imageView stopAnimating];
}

- (void)suKienBamNutHuongDanHocPhi:(UIButton *)sender {
    GiaoDienThongTinPhim *vc = [[GiaoDienThongTinPhim alloc] initWithNibName:@"GiaoDienThongTinPhim" bundle:nil];
    vc.nOption = HUONG_DAN_NAP_TIEN_HOC_PHI;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)suKienDonePicker:(UIButton *)btn {
    if (nTagPicker == 100) {
        [self.edTruongHoc resignFirstResponder];
        if (nIndexTruongHoc > 2 && nIndexTruongHoc < 5) {
            self.edLoaiGiaoDich.enabled = YES;
            self.edLoaiGiaoDich.text = @"Thanh toán học phí";
        }
        else {
            self.edLoaiGiaoDich.enabled = NO;
            self.edLoaiGiaoDich.text = @"Thanh toán học phí";
        }
    }
}

- (void)suKienCancelPicker:(UIButton *)btn {
    [self.edTruongHoc resignFirstResponder];
    [self.edLoaiGiaoDich resignFirstResponder];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 101) {
        return 4;
    }
    return 11;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 101) {
        if (row == 0) {
            return @"Thanh toán học phí";
        }
        else if (row == 1) {
            return @"Phí thi lại học lại";
        }
        else if (row == 2) {
            return @"Học phí miễn môn";
        }
        else if (row == 3) {
            return @"Học lại môn thực tập tốt nghiệp";
        }
    }
    return [self getTenTruongHoc:(int)row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    nTagPicker = (int)pickerView.tag;
    if (pickerView.tag == 101) {
        nIndexGiaoDich = (int)row;
        if (row == 0) {
            _edLoaiGiaoDich.text = @"Thanh toán học phí";
        }
        else if (row == 1) {
            _edLoaiGiaoDich.text = @"Phí thi lại học lại";
        }
        else if (row == 2) {
            _edLoaiGiaoDich.text = @"Học phí miễn môn";
        }
        else if (row == 3) {
            _edLoaiGiaoDich.text = @"Học lại môn thực tập tốt nghiệp";
        }
    }
    else{
        self.edTruongHoc.text = [self getTenTruongHoc:(int)row];
        nIndexTruongHoc = (int)row;
        nIndexGiaoDich = 0;
    }
}

- (NSString *)getTenTruongHoc:(int)nRow {
    if (nRow == 0 || nRow == HOC_PHI_DH_HAI_DUONG_THANH_TOAN_HOC_PHI)
        return @"ĐH Hải Dương";
    else if (nRow == 1 || nRow == HOC_PHI_TIEU_HOC_BAN_MAI_THANH_TOAN_HOC_PHI)
        return @"Tiểu học Ban Mai";
    else if (nRow == 2 || nRow == HOC_PHI_PHO_THONG_LIEN_CAP_WELLSPRING_THANH_TOAN_HOC_PHI)
        return @"Trường phổ thông liên cấp Wellspring";
    else if (nRow == 3 || nRow == HOC_PHI_VIEN_DAI_HOC_MO_CT_EHOU_THANH_TOAN_HOC_PHI || nRow == HOC_PHI_VIEN_DAI_HOC_MO_CT_EHOU_THANH_TOAN_HOC_PHI_HOC_LAI_THI_LAI || nRow == HOC_PHI_VIEN_DAI_HOC_MO_CT_EHOU_THANH_TOAN_HOC_PHI_MIEN_MON | nRow == HOC_PHI_VIEN_DAI_HOC_MO_CT_EHOU_THANH_TOAN_HOC_PHI_HOC_LAI_MON_THUC_TAP_TOT_NGHIEP)
        return @"Đại học mở HN - CT EHOU";
    else if (nRow == 4 || nRow == HOC_PHI_VIEN_DAI_HOC_MO_CT_HOU_TOPICA_THANH_TOAN_HOC_PHI || nRow == HOC_PHI_VIEN_DAI_HOC_MO_CT_HOU_TOPICA_THANH_TOAN_HOC_PHI_HOC_LAI_THI_LAI || nRow == HOC_PHI_VIEN_DAI_HOC_MO_CT_HOU_TOPICA_THANH_TOAN_HOC_PHI_MIEN_MON || nRow == HOC_PHI_VIEN_DAI_HOC_MO_CT_HOU_TOPICA_THANH_TOAN_HOC_PHI_HOC_LAI_MON_THUC_TAP_TOT_NGHIEP)
        return @"Đại học mở HN - CT HOU TOPICA";
    else if (nRow == 5 || nRow == HOC_PHI_VIEN_DAI_HOC_MO_KHOA_CNTT_THANH_TOAN_HOC_PHI)
        return @"Đại học mở HN - khoa CNTT";
    else if (nRow == 6 || nRow == HOC_PHI_VIEN_DAI_HOC_MO_KHOA_DU_LICH_THANH_TOAN_HOC_PHI)
        return @"Đại học mở HN - khoa du lịch";
    else if (nRow == 7 || nRow == HOC_PHI_VIEN_DAI_HOC_MO_KHOA_KINH_TE_THANH_TOAN_HOC_PHI)
        return @"Đại học mở HN - khoa kinh tế";
    else if (nRow == 8 || nRow == HOC_PHI_VIEN_DAI_HOC_MO_KHOA_SAU_DAI_HOC_THANH_TOAN_HOC_PHI)
        return @"Đại học mở HN - khoa sau ĐH";
    else if (nRow == 9 || nRow == HOC_PHI_VIEN_DAI_HOC_MO_KHOA_TIENG_ANH_THANH_TOAN_HOC_PHI)
        return @"Đại học mở HN - khoa TA";
    else if (nRow == 10 || nRow == HOC_PHI_VIEN_DAI_HOC_MO_KHOA_TAO_DANG_CONG_NGHIEP_THANH_TOAN_HOC_PHI)
        return @"Đại học mở HN - khoa tạo dáng CN";
    return @"";
}

- (int)getIndexTruongHoc:(NSString *)sTen {
    if ([sTen isEqualToString:@"ĐH Hải Dương"])
        return 0;
    else if ([sTen isEqualToString:@"Tiểu học Ban Mai"])
        return 1;
    else if ([sTen isEqualToString:@"Trường phổ thông liên cấp Wellspring"])
        return 2;
    else if ([sTen isEqualToString:@"Đại học mở HN - CT EHOU"])
        return 3;
    else if ([sTen isEqualToString:@"Đại học mở HN - CT HOU TOPICA"])
        return 4;
    else if ([sTen isEqualToString:@"Đại học mở HN - khoa CNTT"])
        return 5;
    else if ([sTen isEqualToString:@"Đại học mở HN - khoa du lịch"])
        return 6;
    else if ([sTen isEqualToString:@"Đại học mở HN - khoa kinh tế"])
        return 7;
    else if ([sTen isEqualToString:@"Đại học mở HN - khoa sau ĐH"])
        return 8;
    else if ([sTen isEqualToString:@"Đại học mở HN - khoa TA"])
        return 9;
    else if ([sTen isEqualToString:@"Đại học mở HN - khoa tạo dáng CN"])
        return 10;
    return 0;
}

- (NSString *)getMaHocPhiTheoTruongHoc:(int)nRow {
    switch (nRow) {
        case 0:
            return @"FSP.025";
        case 1:
            return @"FSP.023";
        case 2:
            return @"FSP.017";
        case 3:
            return @"FSP.020";
        case 4:
            return @"FSP.019";
        case 5:
            return @"FSP.024";
        case 6:
            return @"FSP.028";
        case 7:
            return @"FSP.027";
        case 8:
            return @"FSP.022";
        case 9:
            return @"FSP.026";
        case 10:
            return @"FSP.032";
        default:
            break;
    }
//    public final static String HOC_PHI_DH_MO_HCM = "35";
//    public final static String HOC_PHI_DH_TON_DUC_THANG = "125";
    return @"";
}

- (int)getLoaiDichVuHocPhi {
    if (nIndexTruongHoc == 0) {
        return HOC_PHI_DH_HAI_DUONG_THANH_TOAN_HOC_PHI;
    }
    else if (nIndexTruongHoc == 1) {
        return HOC_PHI_TIEU_HOC_BAN_MAI_THANH_TOAN_HOC_PHI;
    }
    else if (nIndexTruongHoc == 2) {
        return HOC_PHI_PHO_THONG_LIEN_CAP_WELLSPRING_THANH_TOAN_HOC_PHI;
    }
    else  if (nIndexTruongHoc == 3) {
        if (nIndexGiaoDich == 0) {
            return HOC_PHI_VIEN_DAI_HOC_MO_CT_EHOU_THANH_TOAN_HOC_PHI;
        }
        else if (nIndexGiaoDich == 1) {
            return HOC_PHI_VIEN_DAI_HOC_MO_CT_EHOU_THANH_TOAN_HOC_PHI_HOC_LAI_THI_LAI;
        }
        else if (nIndexGiaoDich == 2) {
            return HOC_PHI_VIEN_DAI_HOC_MO_CT_EHOU_THANH_TOAN_HOC_PHI_MIEN_MON;
        }
        else if (nIndexGiaoDich == 3) {
            return HOC_PHI_VIEN_DAI_HOC_MO_CT_EHOU_THANH_TOAN_HOC_PHI_HOC_LAI_MON_THUC_TAP_TOT_NGHIEP;
        }
    }
    else if (nIndexTruongHoc == 4) {
        if (nIndexGiaoDich == 0) {
            return HOC_PHI_VIEN_DAI_HOC_MO_CT_HOU_TOPICA_THANH_TOAN_HOC_PHI;
        }
        else if (nIndexGiaoDich == 1) {
            return HOC_PHI_VIEN_DAI_HOC_MO_CT_HOU_TOPICA_THANH_TOAN_HOC_PHI_HOC_LAI_THI_LAI;
        }
        else if (nIndexGiaoDich == 2) {
            return HOC_PHI_VIEN_DAI_HOC_MO_CT_HOU_TOPICA_THANH_TOAN_HOC_PHI_MIEN_MON;
        }
        else if (nIndexGiaoDich == 3) {
            return HOC_PHI_VIEN_DAI_HOC_MO_CT_HOU_TOPICA_THANH_TOAN_HOC_PHI_HOC_LAI_MON_THUC_TAP_TOT_NGHIEP;
        }
    }
    else if (nIndexTruongHoc == 5) {
        return HOC_PHI_VIEN_DAI_HOC_MO_KHOA_CNTT_THANH_TOAN_HOC_PHI;
    }
    else if (nIndexTruongHoc == 6) {
        return HOC_PHI_VIEN_DAI_HOC_MO_KHOA_DU_LICH_THANH_TOAN_HOC_PHI;
    }
    else if (nIndexTruongHoc == 7) {
        return HOC_PHI_VIEN_DAI_HOC_MO_KHOA_KINH_TE_THANH_TOAN_HOC_PHI;
    }
    else if (nIndexTruongHoc == 8) {
        return HOC_PHI_VIEN_DAI_HOC_MO_KHOA_SAU_DAI_HOC_THANH_TOAN_HOC_PHI;
    }
    else if (nIndexTruongHoc == 9) {
        return HOC_PHI_VIEN_DAI_HOC_MO_KHOA_TIENG_ANH_THANH_TOAN_HOC_PHI;
    }
    else if (nIndexTruongHoc == 10) {
        return HOC_PHI_VIEN_DAI_HOC_MO_KHOA_TAO_DANG_CONG_NGHIEP_THANH_TOAN_HOC_PHI;
    }
    return -1;
}

- (BOOL)validateVanTay {
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return NO;
    }
//    if ([self.edMaKH.text isEmpty]) {
//        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập mã khách hàng"];
//        return NO;
//    }
//    if (![_edSoTien validate]) {
//        [_edSoTien show_error];
//        return NO;
//    }
//    else{
//        int fSoTien = [[_edSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""] intValue];
//        if (fSoTien >= [self.mThongTinTaiKhoanVi.nAmount doubleValue]) {
//            [UIAlertView alert:@"Số dư trong tài khoản không đủ" withTitle:[@"thong_bao" localizableString] block:nil];
//            return NO;
//        }
//        else if (fSoTien < 10000) {
//            [UIAlertView alert:@"Số tiền chuyển đi phải lớn hơn 10.000 đ" withTitle:[@"thong_bao" localizableString] block:nil];
//            return NO;
//        }
//    }
//    if ([_edTenKH.text isEmpty]) {
//        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập tên khách hàng"];
//        return NO;
//    }
//    if ([_tvNoiDung.text isEmpty]) {
//        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập nhập nội dung"];
//        return NO;
//    }

    return YES;
}

- (void)xuLyThucHienKhiKiemTraThanhCongTraVeToken:(NSString *)sToken otp:(NSString *)sOtp {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self hienThiLoading];
    }
    self.mDinhDanhKetNoi = DINH_DANH_THANH_TOAN_HOC_PHI;
    double fSoTien = [[[self.edSoTien.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
    NSDictionary *dic = @{@"noiDung":_tvNoiDung.text,
                          @"nhaCungCap":[NSNumber numberWithInt:38],
                          @"soTien":[NSNumber numberWithDouble:fSoTien],
                          @"maHocPhi":[self getMaHocPhiTheoTruongHoc:nIndexTruongHoc],
                          @"loaiDichVuHocPhi":[NSNumber numberWithInt:[self getLoaiDichVuHocPhi]],
                          @"maKhachHangHocPhi":_edMaKH.text,
                          @"tenKhachHangHocPhi":_edTenKH.text,
                          @"user":[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                          @"token":sToken,
                          @"otpConfirm":sOtp,
                          @"typeAuthenticate":[NSNumber numberWithInt:self.mTypeAuthenticate],
                          @"appId":[NSNumber numberWithInt:5],
                          @"VMApp" : [NSNumber numberWithInt:VM_APP]};
    [GiaoDichMang thanhToanHocPhi:[dic JSONString] noiNhanKetQua:self];
}

- (void)xuLyKetNoiThanhCong:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self anLoading];
    }
    [self hienThiHopThoaiMotNutBamKieu:HOP_THOAI_XAC_NHAN_CHUYEN_TIEN_THANH_CONG cauThongBao:sThongBao];
}

- (IBAction)suKienClickSoTayHocPhi:(id)sender {
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return;
    }
    DucNT_DanhSachTaiKhoanThuongDungControllerViewController *vc = [[DucNT_DanhSachTaiKhoanThuongDungControllerViewController alloc] initWithType:TAI_KHOAN_HOC_PHI];
    [self.navigationController presentViewController:vc animated:YES completion:^{}];
    [vc release];
}

- (IBAction)suKienThayDoiSoTien:(id)sender {
    NSString *sSoTien = [_edSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    _edSoTien.text = [Common hienThiTienTeFromString:sSoTien];
}

- (void)dealloc {
    [viewQC release];
    [_edTruongHoc release];
    [_edLoaiGiaoDich release];
    [_edMaKH release];
    [_edTenKH release];
    [_edSoTien release];
    [_tvNoiDung release];
//    [_scrMain release];
    [super dealloc];
}
@end
