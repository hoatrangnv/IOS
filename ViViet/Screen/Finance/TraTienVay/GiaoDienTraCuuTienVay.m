//
//  GiaoDienTraCuuTienVay.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 3/31/16.
//
//

#import "GiaoDienTraCuuTienVay.h"
#import "GiaoDienThongTinPhim.h"
#import "GiaoDichMang.h"
#import "DoiTuongNotification.h"
#import "MoTaChiTietKhachHang.h"
#import "DucNT_DanhSachTaiKhoanThuongDungControllerViewController.h"
@interface GiaoDienTraCuuTienVay ()<UIPickerViewDelegate, UIPickerViewDataSource> {
    int nIndexQuy;
    UIAlertView *alertTimer;
    NSTimer *mTimer;
    int mThoiGianDoi;
    ViewQuangCao *viewQC;
}
@property (nonatomic, retain) MoTaChiTietKhachHang *mMoTaChiTietKhachHang;
@property (nonatomic, retain) DoiTuongNotification *mDoiTuongNotification;
@end

@implementation GiaoDienTraCuuTienVay

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitleView:@"Trả tiền vay"];
    self.mFuncID = FUNC_THANH_TOAN_TIEN_VAY;
    nIndexQuy = 0;
    [self themButtonHuongDanSuDung:@selector(suKienBamNutHuongDanTraTienVay:)];
    [self khoiTaoTextFeildTheoYChuTit:_edQuyTraTien nTag:100 dataPicker:self delegatePicker:self];
    _edQuyTraTien.text = @"ACS";
    _edMaHopDong.inputAccessoryView = nil;

    if (_sIdShow && !_sIdShow.isEmpty) {
        [self khoiTaoThongTinKhiCoPush];
        [self layChiTietThongTinHoaDon:_sIdShow];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateThongTinTraTienVay:) name:KEY_TAI_KHOAN_THUONG_DUNG object:nil];

//    [self khoiTaoThongTinKhiCoPush];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setAnimationChoSoTay:self.btnSoTay];
//    [self khoiTaoQuangCao];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.btnSoTay.imageView stopAnimating];
}

- (void)khoiTaoQuangCao {
    if (viewQC == nil) {
        viewQC = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ViewQuangCao class]) owner:self options:nil] objectAtIndex:0];
        viewQC.mDelegate = self;
        CGRect rectToken = self.btnTraCuu.frame;
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
    }
}

- (void)updateThongTinTraTienVay:(NSNotification *)notification
{
    if([[notification name] isEqualToString:KEY_TAI_KHOAN_THUONG_DUNG])
    {
        DucNT_TaiKhoanThuongDungObject *temp = [notification object];
        if (temp.maNhaCungCap == NHA_CUNG_CAP_TIEN_VAY_FE_CREDIT) {
            _edMaHopDong.text = temp.maHopDong;
            _edCMNDFE.text = temp.cmnd;
        }
        else {
            _edMaHopDong.text = temp.maHopDong;
        }
        nIndexQuy = [self getIndexNhaCungCap:temp.maNhaCungCap];
        _edQuyTraTien.text = [self getQuyTraTienVay:nIndexQuy];
        [self refreshGiaoDienKhiChonQuy];
    }
}

- (void)suKienDonePicker:(UIButton *)btn {
    [_edQuyTraTien resignFirstResponder];
    _edQuyTraTien.text = [self getQuyTraTienVay:nIndexQuy];
    [self refreshGiaoDienKhiChonQuy];
}

- (void)refreshGiaoDienKhiChonQuy {
    if (nIndexQuy == 1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_edMaHopDong setPlaceholder:@"Mã hợp đồng"];
            self.edCMNDFE.hidden = NO;
            self.heightCmndFE.constant = 35.0;
            self.topBtnTraCuu.constant = 8;
            self.heightViewMain.constant += (self.heightCmndFE.constant + self.topBtnTraCuu.constant);
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            _edMaHopDong.placeholder = @"Số CMND/ mã HĐ";
            self.edCMNDFE.hidden = YES;
            self.heightViewMain.constant -= (self.heightCmndFE.constant + self.topBtnTraCuu.constant);
            self.heightCmndFE.constant = 0.0;
            self.topBtnTraCuu.constant = 0.0;
        });
    }
    
//    if ([self.mViewMain.subviews containsObject:self.viewThanhToan] && !self.viewThanhToan.hidden) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.topViewThanhToan.constant = 8;
//            self.heightViewThanhToan.constant = 220;
//            self.heightViewMain.constant += (self.heightViewThanhToan.constant + self.topViewThanhToan.constant);
//        });
}

- (void)suKienCancelPicker:(UIButton *)btn {
    [_edQuyTraTien resignFirstResponder];
}

- (void)suKienBamNutHuongDanTraTienVay:(UIButton *)sender {
    GiaoDienThongTinPhim *vc = [[GiaoDienThongTinPhim alloc] initWithNibName:@"GiaoDienThongTinPhim" bundle:nil];
    vc.nOption = HUONG_DAN_TRA_TIEN_VAY;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
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
    return [self getQuyTraTienVay:(int)row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    nIndexQuy = (int)row;
}

- (NSString *)getQuyTraTienVay:(int)row {
    switch (row) {
        case 0:
            return @"ACS";
        case 1:
            return @"FE Credit";
        case 2:
            return @"HD Saison (HD Finance)";
        case 3:
            return @"Prudential";
        case 4:
            return @"ATM Online";
        case 5:
            return @"Cashwagon";
        case 6:
            return @"Công ty Tài chính TNHH Shinsei(Mcredit)";
        case 7:
            return @"Doctor Dong";
        case 8:
            return @"Easy Credit";
        case 9:
            return @"JACCS";
        case 10:
            return @"Miare Asset";
        case 11:
            return @"NCB Ngân hàng quốc dân";
        case 12:
            return @"OCB";
        case 13:
            return @"Toyota Finance/TFSVN";
        default:
            break;
    }
    return @"";
}

- (int)getMaCungCapQuyTraTienVay:(int)row {
    switch (row) {
        case 0:return NHA_CUNG_CAP_TIEN_VAY_ACS;
        case 1:return NHA_CUNG_CAP_TIEN_VAY_FE_CREDIT;
        case 2:return NHA_CUNG_CAP_TIEN_VAY_HD_FINANCE;
        case 3:return NHA_CUNG_CAP_TIEN_VAY_HOME_CREDIT;
        case 4:return NHA_CUNG_CAP_TIEN_VAY_PRUDENTIAL_FINANCE;
        case 5:return NHA_CUNG_CAP_TIEN_VAY_ATM_ONLINE;
        case 6:return NHA_CUNG_CAP_TIEN_VAY_Cashwagon;
        case 7:return NHA_CUNG_CAP_TIEN_VAY_MCredit;
        case 8:return NHA_CUNG_CAP_TIEN_VAY_Doctor_Dong;
        case 9:return NHA_CUNG_CAP_TIEN_VAY_EAsy_credit;
        case 10:return NHA_CUNG_CAP_TIEN_VAY_JACCS;
        case 11:return NHA_CUNG_CAP_TIEN_VAY_Mirae_asset;
        case 12:return NHA_CUNG_CAP_TIEN_VAY_NCB;
        case 13:return NHA_CUNG_CAP_TIEN_VAY_OCB;
        case 14:return NHA_CUNG_CAP_TIEN_VAY_TOyota_finance;
        default:
            break;
    }
    return @"";
}

- (int)getIndexNhaCungCap:(int)maNhaChungCap {
    switch (maNhaChungCap) {
        case NHA_CUNG_CAP_TIEN_VAY_ACS:
            return 0;
        case NHA_CUNG_CAP_TIEN_VAY_FE_CREDIT:
            return 1;
        case NHA_CUNG_CAP_TIEN_VAY_HD_FINANCE:
            return 2;
        case NHA_CUNG_CAP_TIEN_VAY_PRUDENTIAL_FINANCE:
            return 3;
        case NHA_CUNG_CAP_TIEN_VAY_HOME_CREDIT:
            return 4;
        default:
            break;
    }
    return 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)validateVanTay {
    if (nIndexQuy != 1) {
        if ([_edMaHopDong.text isEmpty]) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập số CMND hoặc mã hợp đồng"];
            return NO;
        }
    }
    else {
        if ([_edMaHopDong.text isEmpty]) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập mã hợp đồng"];
            return NO;
        }
        if ([_edCMNDFE.text isEmpty]) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập số CMND"];
            return NO;
        }
    }
    return YES;
}

- (void)xuLyThucHienKhiKiemTraThanhCongTraVeToken:(NSString *)sToken otp:(NSString *)sOtp {
    double fSoTien = [[[self.edSoTien.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
    self.mDinhDanhKetNoi = DINH_DANH_THANH_TOAN_TIEN_VAY;
    NSDictionary *dic = @{@"maNhaCungCap":[NSNumber numberWithInt:[self getMaCungCapQuyTraTienVay:nIndexQuy]],
                          @"maHopDong":_edMaHopDong.text,
                          @"cmnd":_edCMNDFE.text,
                          @"soTien":[NSNumber numberWithDouble:fSoTien],
                          @"user":[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                          @"token":sToken,
                          @"typeAuthenticate":[NSNumber numberWithInt:self.mTypeAuthenticate],
                          @"appId":[NSNumber numberWithInt:APP_ID],
                          @"VMApp" : [NSNumber numberWithInt:VM_APP]
                          };
    NSString *sJson = [dic JSONString];
    NSLog(@"%s - sJson : %@", __FUNCTION__, sJson);
    [GiaoDichMang thanhToanTraTienVay:sJson noiNhanKetQua:self];
}

- (IBAction)suKienBamNutTraCuu:(id)sender {
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return;
    }
    [self hienThiLoading];
    self.mDinhDanhKetNoi = DINH_DANH_TRA_CUU_TIEN_VAY;
    [GiaoDichMang traCuuTienVay:_edMaHopDong.text cmnd:_edCMNDFE.text maNhaCungCap:[self getMaCungCapQuyTraTienVay:nIndexQuy] soTien:0 noiNhanKetQua:self];
}

- (IBAction)suKienBamNutSoTay:(id)sender {
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return;
    }
    DucNT_DanhSachTaiKhoanThuongDungControllerViewController *vc = [[DucNT_DanhSachTaiKhoanThuongDungControllerViewController alloc] initWithType:TAI_KHOAN_TIEN_VAY];
    [self.navigationController presentViewController:vc animated:YES completion:^{}];
    [vc release];
}

- (void)xuLyKetNoiThanhCong:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua{
    if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_TRA_CUU_TIEN_VAY]) {
        NSLog(@"%s - sThongBao : %@", __FUNCTION__, sThongBao);
        if (!alertTimer) {
            alertTimer = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:@"Hệ thống đang tra cứu mã. Vui lòng đợi sau: 45s" delegate:nil cancelButtonTitle:@"Đóng" otherButtonTitles: nil];
        }
        [alertTimer show];
        [self batDauDemThoiGian];
    }
    else if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_LAY_CHI_TIET_TIEN_VAY]) {
        NSDictionary *dic = (NSDictionary *)ketQua;
        if (dic) {
            int nSoTien = [[dic objectForKey:@"soTien"] intValue];
            _edSoTien.text = [Common hienThiTienTe:nSoTien];
            NSString *sMoTa = [dic objectForKey:@"moTa"];
            NSString *decodedString = [sMoTa stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"%s - decodedString : %@", __FUNCTION__, decodedString);
            NSDictionary *dicMoTa = [decodedString objectFromJSONString];
            NSString *sHoTen = [dicMoTa objectForKey:@"tenKhachHang"];
            sHoTen = [sHoTen stringByReplacingOccurrencesOfString:@"+" withString:@" "];
            _edHoTen.text = sHoTen;

            int nMaNhaCungCap = [[dic objectForKey:@"maNhaCungCap"] intValue];
            nIndexQuy = [self getIndexNhaCungCap:nMaNhaCungCap];
            _edQuyTraTien.text = [self getQuyTraTienVay:nIndexQuy];
            _edCMNDFE.text = [dic objectForKey:@"cmnd"];

            [self refreshGiaoDienKhiChonQuy];
        }
    }
    [self anLoading];
}

- (void)batDauDemThoiGian
{
    [self ketThucDemThoiGian];
    mThoiGianDoi = 45;
    NSString *sCauThongBao = [NSString stringWithFormat:@"%@ %ds", @"Hệ thống đang tra cứu mã. Vui lòng đợi sau: ", mThoiGianDoi];
    alertTimer.message = sCauThongBao;
    mTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(capNhatDemThoiGianTienVay) userInfo:nil repeats:YES];
}

- (void)ketThucDemThoiGian
{

    mThoiGianDoi = 45;
    if(mTimer)
    {
        [mTimer invalidate];
        mTimer = nil;
    }
}

- (void)capNhatDemThoiGianTienVay
{
    mThoiGianDoi --;
    NSString *sCauThongBao = [NSString stringWithFormat:@"%@ %d s", @"Hệ thống đang tra cứu mã. Vui lòng đợi sau: ", mThoiGianDoi];
    alertTimer.message = sCauThongBao;

    if (mThoiGianDoi > 0 && _mDoiTuongNotification)
    {
        [self ketThucDemThoiGian];
        [alertTimer dismissWithClickedButtonIndex:0 animated:YES];
//        [self xuLyChuyenViewThanhToan];
        [self khoiTaoThongTinKhiCoPush];
        [self layChiTietThongTinHoaDon:self.mDoiTuongNotification.idShow];
    }
    else if (mThoiGianDoi == 0 && !_mDoiTuongNotification)
    {
        [alertTimer dismissWithClickedButtonIndex:0 animated:YES];
        [self ketThucDemThoiGian];
    }
}

- (void)didReceiveRemoteNotification:(NSDictionary *)Info{
    NSDictionary *userInfo = [Info valueForKey:@"userInfo"];
    if(userInfo)
    {
        NSLog(@"Debug:%@: %@, jSonString : %@", NSStringFromClass([self class]),NSStringFromSelector(_cmd), [userInfo JSONString]);
        DoiTuongNotification *doiTuongNotification = [[DoiTuongNotification alloc] initWithDict:userInfo];
        if([doiTuongNotification.typeShow intValue] == KIEU_NOTIFICATION_TIEN_VAY)
        {
            [self ketThucDemThoiGian];
            if (alertTimer) {
                [alertTimer dismissWithClickedButtonIndex:0 animated:YES];
            }

//            NSString *sMaKhachHangDangTraCuu = _edMaKH.text;
            if([doiTuongNotification.alertContent rangeOfString:@"0 đ"].location != NSNotFound)
            {
                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:doiTuongNotification.alertContent];
            }
            else {
                self.mDoiTuongNotification = doiTuongNotification;
            }
            [doiTuongNotification release];
            //            [self khoiTaoThongTinKhiCoPush];
//            [self layChiTietThongTinHoaDon:self.mDoiTuongNotification.idShow];
        }
    }
}

- (void)khoiTaoThongTinKhiCoPush {
//    if (![self.mViewMain.subviews containsObject:self.viewThanhToan]) {
//        [self.mViewMain addSubview:self.viewThanhToan];
//    }
//    [self.mViewMain bringSubviewToFront:self.viewThanhToan];
//    [self.viewThanhToan setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [self.viewThanhToan.trailingAnchor constraintEqualToAnchor:self.mViewMain.trailingAnchor].active = YES;
//    [self.viewThanhToan.leadingAnchor constraintEqualToAnchor:self.mViewMain.leadingAnchor].active = YES;
//    [self.viewThanhToan.topAnchor constraintEqualToAnchor:self.edMaHopDong.bottomAnchor constant:12].active = YES;
    self.viewThanhToan.hidden = NO;
    self.btnTraCuu.hidden = YES;
    self.heightViewThanhToan.constant = 200;
    self.topViewThanhToan.constant = 0;
    self.heightViewMain.constant += self.heightViewThanhToan.constant;
}

- (void)layChiTietThongTinHoaDon:(NSString *)idHoaDon {
    [self hienThiLoading];
    self.mDinhDanhKetNoi = DINH_DANH_LAY_CHI_TIET_TIEN_VAY;
    [GiaoDichMang layThongTinChiTietHoaDonTienVay:idHoaDon noiNhanKetQua:self];
}

- (void)dealloc {
    [viewQC release];
    [_edQuyTraTien release];
    [_edCMNDFE release];
    [_btnTraCuu release];
    [_edMaHopDong release];
    [_viewThanhToan release];
    [_edHoTen release];
    [_edSoTien release];
//    [_scrMain release];
    [_heightViewMain release];
    [_heightCmndFE release];
    [_topBtnTraCuu release];
    [_topViewThanhToan release];
    [_heightViewThanhToan release];
    [super dealloc];
}

@end
