//
//  GiaoDienThanhToanChungKhoan.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 4/12/16.
//
//

#import "GiaoDienThanhToanChungKhoan.h"
#import "GiaoDienThongTinPhim.h"
#import "GiaoDichMang.h"
#import "DucNT_DanhSachTaiKhoanThuongDungControllerViewController.h"

@interface GiaoDienThanhToanChungKhoan () <UIPickerViewDelegate, UIPickerViewDataSource> {
    int nIndexQuy;
    ViewQuangCao *viewQC;
}
@end

@implementation GiaoDienThanhToanChungKhoan

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitleView:@"Chứng khoán"];
    self.mFuncID = FUNC_CHUYEN_TIEN_DEN_VI_MOMO;
    nIndexQuy = 0;
    [self themButtonHuongDanSuDung:@selector(suKienBamNutHuongDanChungKhoan:)];
    [self khoiTaoTextFeildTheoYChuTit:_edTaiKhoan nTag:100 dataPicker:self delegatePicker:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateThongTinChungKhoan:) name:KEY_TAI_KHOAN_THUONG_DUNG object:nil];
     _edTaiKhoan.text = [self getTaiKhoanChungKhoan:nIndexQuy];

    _edHoTen.inputAccessoryView = nil;
    _edMaKhachHang.inputAccessoryView = nil;
    _edSoTien.inputAccessoryView = nil;
    _tvNoiDung.inputAccessoryView = nil;

}

-(void)updateThongTinATM:(NSNotification *)notification {
    if([[notification name] isEqualToString:KEY_TAI_KHOAN_THUONG_DUNG])
    {
//        DucNT_TaiKhoanThuongDungObject *temp = [notification object];
    }
}

- (void)khoiTaoQuangCao {
    if (viewQC) {
        return;
    }
    viewQC = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ViewQuangCao class]) owner:self options:nil] objectAtIndex:0];
    viewQC.mDelegate = self;
    CGRect rectToken = self.viewThanhToan.frame;
    CGRect rectQC = viewQC.frame;
    CGRect rectMain = self.mViewMain.frame;
    rectQC.origin.x += 2;
    CGFloat fW = rectMain.size.width;
    CGFloat fH = fW * 0.45333;
    rectQC.origin.y = rectToken.origin.y + rectToken.size.height + 15.0;
    viewQC.frame = CGRectMake(0, rectQC.origin.y, fW, fH);
    viewQC.mDelegate = self;
    [viewQC updateSizeQuangCao];
    rectMain.size.height = rectQC.origin.y + rectQC.size.height;
    self.mViewMain.frame = rectMain;
    [self.mViewMain addSubview:viewQC];
    [self.scrMain setContentSize:CGSizeMake(_scrMain.frame.size.width, rectMain.origin.y + rectMain.size.height + self.viewOptionTop.frame.origin.y + self.viewOptionTop.frame.size.height + 50)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_tvNoiDung resignFirstResponder];
    [self setAnimationChoSoTay:self.btnSoTay];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self khoiTaoQuangCao];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.btnSoTay.imageView stopAnimating];

}

- (void)suKienDonePicker:(UIButton *)btn {
    [_edTaiKhoan resignFirstResponder];
    _edTaiKhoan.text = [self getTaiKhoanChungKhoan:nIndexQuy];

}

- (void)suKienCancelPicker:(UIButton *)btn {
    [_edTaiKhoan resignFirstResponder];
}

- (void)suKienBamNutHuongDanChungKhoan:(UIButton *)sender {
    GiaoDienThongTinPhim *vc = [[GiaoDienThongTinPhim alloc] initWithNibName:@"GiaoDienThongTinPhim" bundle:nil];
    vc.nOption = HUONG_DAN_CHUNG_KHOAN;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)hideViewNhapToken {
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 14;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self getTaiKhoanChungKhoan:(int)row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    nIndexQuy = (int)row;
}

- (NSString *)getTaiKhoanChungKhoan:(int)row {
    switch (row) {
        case 0:
            return @"CK Vietcombank (VCBS)";
        case 1:
            return @"CK Sài Gòn (SSI) Hội sở chính";
        case 2:
            return @"CK Sài Gòn (SSI) Hà Nội";
        case 3:
            return @"Cty CK VNDirect Hội sở chính";
        case 4:
            return @"Cty CK VNDirect CN HCM";
        case 5:
            return @"Cty CK Bản Việt";
        case 6:
            return @"Cty CK FPT";
        case 7:
            return @"CK Maritime Bank-VCB HN";
        case 8:
            return @"CK Maritime Bank-VCB HCM";
        case 9:
            return @"CK Nông nghiệp (Agriseco)";
        case 10:
            return @"CK Tân Việt (TVSI)";
        case 11:
            return @"CK TP.Hồ Chí Minh (HSC)";
        case 12:
            return @"Cty tài chính Prudential";
        case 13:
            return @"Tất toán trước hạn Prudential";
        default:
            break;
    }
    return @"";
}

- (int)getCongTyChungKhoan:(int)row {
    switch (row) {
        case 0:
            return CHUNG_KHOAN_VCBS;
        case 1: case 2:
            return CHUNG_KHOAN_SSI;
        case 3: case 4:
            return CHUNG_KHOAN_VN_DIRECT;
        case 5:
            return CHUNG_KHOAN_BAN_VIET;
        case 6:
            return CHUNG_KHOAN_FPT;
        case 7: case 8:
            return CHUNG_KHOAN_MARITIME;
        case 9:
            return CHUNG_KHOAN_AGRISECO;
        case 10:
            return CHUNG_KHOAN_TVSI;
        case 11:
            return CHUNG_KHOAN_HSC;
        case 12: case 13:
            return CHUNG_KHOAN_PRUDENTIAL;
        default:
            break;
    }
    return 0;
}

- (int)getDichVuCongTyChungKhoan:(int)row {
    switch (row) {
        case 0:
            return DICH_VU_CHUNG_KHOAN_VCBS_NOP_TIEN_VAO_TK_CHUNG_KHOAN;
        case 1:
            return DICH_VU_CHUNG_KHOAN_SSI_NOP_TIEN_VAO_TK_CHUNG_KHOAN_HOI_SO_CHINH;
        case 2:
            return DICH_VU_CHUNG_KHOAN_SSI_NOP_TIEN_VAO_TK_CHUNG_KHOAN_CHI_NHANH_HA_NOI;
        case 3:
            return DICH_VU_CHUNG_KHOAN_VN_DIRECT_NOP_TIEN_VAO_TK_CHUNG_KHOAN_HOI_SO_CHINH;
        case 4:
            return DICH_VU_CHUNG_KHOAN_VN_DIRECT_NOP_TIEN_VAO_TK_CHUNG_KHOAN_CHI_NHANH_HO_CHI_MINH;
        case 5:
            return DICH_VU_CHUNG_KHOAN_BAN_VIET_NOP_TIEN_VAO_TK_CHUNG_KHOAN;
        case 6:
            return DICH_VU_CHUNG_KHOAN_FPT_NOP_TIEN_VAO_TK_CHUNG_KHOAN;
        case 7:
            return DICH_VU_CHUNG_KHOAN_MARITIME_NOP_TIEN_VAO_TK_CHUNG_KHOAN_TAI_VCB_HOAN_KIEM;
        case 8:
            return DICH_VU_CHUNG_KHOAN_MARITIME_NOP_TIEN_VAO_TK_CHUNG_KHOAN_TAI_VCB_HO_CHI_MINH;
        case 9:
            return DICH_VU_CHUNG_KHOAN_AGRISECO_NOP_TIEN_VAO_TK_CHUNG_KHOAN;
        case 10:
            return DICH_VU_CHUNG_KHOAN_TVSI_NOP_TIEN_VAO_TK_CHUNG_KHOAN;
        case 11:
            return DICH_VU_CHUNG_KHOAN_HSC_NOP_TIEN_VAO_TK_CHUNG_KHOAN;
        case 12:
            return DICH_VU_CHUNG_KHOAN_PRUDENTIAL_THANH_TOAN_KHOAN_VAY;
        case 13:
            return DICH_VU_CHUNG_KHOAN_PRUDENTIAL_TAT_TOAN_KHOAN_VAY_TRUOC_HAN;
        default:
            break;
    }
    return 0;
}

- (IBAction)suKienNhapSoTienChungKhoan:(id)sender {
    NSString *sText = [Common hienThiTienTeFromString:[_edSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""]];
    _edSoTien.text = sText;
}

- (IBAction)suKienBamNutSoTayChungKhoan:(id)sender {
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return;
    }
    DucNT_DanhSachTaiKhoanThuongDungControllerViewController *vc = [[DucNT_DanhSachTaiKhoanThuongDungControllerViewController alloc] initWithType:TAI_KHOAN_CHUNG_KHOAN];
    [self.navigationController presentViewController:vc animated:YES completion:^{}];
    [vc release];
}

- (BOOL)validateVanTay {
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return NO;
    }
    if (_edHoTen.text.isEmpty) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập họ tên khách hàng"];
        return NO;
    }
    if (_edMaKhachHang.text.isEmpty) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập mã khách hàng"];
        return NO;
    }
    if (_edSoTien.text.isEmpty) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập số tiền"];
        return NO;
    }
    else {
        double fSoTien = [[[self.edSoTien.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
        if (fSoTien < 10000) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Số tiền chuyển đi phải lớn hơn hoặc bằng 10.000 đ"];
            return NO;
        }
        else if (fSoTien >= [self.mThongTinTaiKhoanVi.nAmount doubleValue]) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Số dư trong tài khoản không đủ"];
            return NO;
        }
    }
    if (_tvNoiDung.text.isEmpty) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập nội dung chuyển tiền"];
        return NO;
    }

    return YES;
}

- (void)xuLyThucHienKhiKiemTraThanhCongTraVeToken:(NSString *)sToken otp:(NSString *)sOtp {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self hienThiLoading];
    }
    self.mDinhDanhKetNoi = @"DINH_DANH_KET_NOI_CHUNG_KHOAN";
    double fSoTien = [[[self.edSoTien.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
    NSDictionary *dic = @{@"noiDung" : _tvNoiDung.text,
                          @"nhaCungCap" : [NSNumber numberWithInt:37],
                          @"soTien" : [NSNumber numberWithDouble:fSoTien],
                          @"maCongTyChungKhoan" : [NSNumber numberWithInt:[self getCongTyChungKhoan:nIndexQuy]],
                          @"loaiDichVuChungKhoan" : [NSNumber numberWithInt:[self getDichVuCongTyChungKhoan:nIndexQuy]],
                          @"maKhachHangChungKhoan" : _edMaKhachHang.text,
                          @"tenKhachHangChungKhoan" : _edHoTen.text,
                          @"token" : sToken,
                          @"otpConfirm" : sOtp,
                          @"typeAuthenticate" : [NSNumber numberWithInt:self.mTypeAuthenticate],
                          @"appId" : [NSNumber numberWithInt:APP_ID],
                          @"VMApp" : [NSNumber numberWithInt:VM_APP]
                          };
    [GiaoDichMang thanhToanTienChungKhoan:[dic JSONString] noiNhanKetQua:self];
}

- (void)xuLyKetNoiThanhCong:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self anLoading];
    }
    if ([sDinhDanhKetNoi isEqualToString:@"DINH_DANH_KET_NOI_CHUNG_KHOAN"]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
    }
}

- (void)dealloc {
    [viewQC release];
    [_edTaiKhoan release];
    [_edHoTen release];
    [_edMaKhachHang release];
    [_edSoTien release];
    [_tvNoiDung release];
//    [_scrMain release];
    [_viewThanhToan release];
    [super dealloc];
}

@end
