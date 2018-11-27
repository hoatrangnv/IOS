//
//  GiaoDienThanhToanInternet.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 10/16/15.
//
//

#import "GiaoDienThanhToanInternet.h"
#import "DoiTuongNotification.h"
#import "GiaoDienThanhToanSauTraCuuInternet.h"
#import "GiaoDienThongTinPhim.h"
#import "DucNT_DanhSachTaiKhoanThuongDungControllerViewController.h"

@interface GiaoDienThanhToanInternet ()
{
    int nIdVNPT;
    int mThoiGianDoi;
    NSTimer *mTimer1;
    UIAlertView *thongBaoInternet;
    ViewQuangCao *viewQC;
}
@end

const int NHA_CUNG_CAP_INTERNET_VNPT_HA_NOI = 1;
const int NHA_CUNG_CAP_INTERNET_VNPT_HAI_PHONG = 2;
const int NHA_CUNG_CAP_INTERNET_VNPT_HO_CHI_MINH = 3;
const int NHA_CUNG_CAP_INTERNET_ADSL_FPT = 4;
const int NHA_CUNG_CAP_INTERNET_VIETTEL = 5;
const int NHA_CUNG_CAP_INTERNET_CMC = 6;

@implementation GiaoDienThanhToanInternet

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addButtonBack];
    [self addButtonHuongDan];
//    self.navigationItem.title = @"Thanh toán Internet";
    [self addTitleView:@"Thanh toán Internet"];
    self.viewMain.layer.masksToBounds = YES;
    self.viewMain.layer.cornerRadius = 4.0f;
    self.viewMain.layer.borderColor = [UIColor whiteColor].CGColor;
    self.viewMain.layer.borderWidth = 1.0f;
    self.mtfMaKH.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    self.mtfMaKH.inputAccessoryView = nil;
    nIdVNPT = NHA_CUNG_CAP_INTERNET_VNPT_HA_NOI;


    [self khoiTaoBanDau];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateThongTinInternet:) name:KEY_TAI_KHOAN_THUONG_DUNG object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setAnimationChoSoTay:self.btnSoTay];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_nChucNang == 1) {
        [self suKienChonViettel:self.btnViettel];
    }
    else if (_nChucNang == 2) {
        [self suKienChonFPT:self.btnFPT];
    }
    else if (_nChucNang == 3) {
        [self suKienBamNutCMC:self.btnCMC];
    }
//    [self khoiTaoQuangCao];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.btnSoTay.imageView stopAnimating];
}

- (void)khoiTaoQuangCao {
    if (!viewQC) {
        viewQC = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ViewQuangCao class]) owner:self options:nil] objectAtIndex:0];
        viewQC.mDelegate = self;
        CGRect rectToken = self.btnTraCuu.frame;
        CGRect rectQC = viewQC.frame;
        CGRect rectMain = self.viewMain.frame;

        CGFloat fW = rectMain.size.width;
        CGFloat fH = fW * 0.45333;
        rectQC.origin.y = rectToken.origin.y + rectToken.size.height + 15.0;
        viewQC.frame = CGRectMake(0, rectQC.origin.y, fW, fH);
        viewQC.mDelegate = self;
        [viewQC updateSizeQuangCao];
        rectMain.size.height = rectQC.origin.y + rectQC.size.height;
        self.viewMain.frame = rectMain;
        [self.viewMain addSubview:viewQC];
    }
//    [self.scrMain setContentSize:CGSizeMake(_scrMain.frame.size.width, viewQC.frame.origin.y + viewQC.frame.size.height + 10)];
}

- (void)updateThongTinInternet:(NSNotification *)notification
{
    if([[notification name] isEqualToString:KEY_TAI_KHOAN_THUONG_DUNG])
    {
        DucNT_TaiKhoanThuongDungObject *temp = [notification object];

        int nMaNhaCungCap = temp.maNhaCungCap;
        if (nMaNhaCungCap == NHA_CUNG_CAP_INTERNET_VNPT_HA_NOI || nMaNhaCungCap == NHA_CUNG_CAP_INTERNET_VNPT_HAI_PHONG || nMaNhaCungCap == NHA_CUNG_CAP_INTERNET_VNPT_HO_CHI_MINH) {
            if (nMaNhaCungCap == NHA_CUNG_CAP_INTERNET_VNPT_HA_NOI) {
                _mtfChonVNPT.text = @"VNPT Hà Nội";
            }
            else if (nMaNhaCungCap == NHA_CUNG_CAP_INTERNET_VNPT_HAI_PHONG) {
                _mtfChonVNPT.text = @"VNPT Hải Phòng";
            }
            else if (nMaNhaCungCap == NHA_CUNG_CAP_INTERNET_VNPT_HO_CHI_MINH) {
                _mtfChonVNPT.text = @"VNPT Hồ Chí Minh";
            }
            [self suKienChonVNPT:nil];
        }
        else if (nMaNhaCungCap == NHA_CUNG_CAP_INTERNET_VIETTEL) {
            [self suKienChonViettel:nil];
        }
        else if (nMaNhaCungCap == NHA_CUNG_CAP_INTERNET_ADSL_FPT) {
            [self suKienChonFPT:nil];
        }
        else if (nMaNhaCungCap == NHA_CUNG_CAP_INTERNET_CMC) {
            [self suKienBamNutCMC:nil];
        }
        NSLog(@"%s - temp.maKhachHang : %@", __FUNCTION__, temp.maKhachHang);
        _mtfMaKH.text = temp.maThueBao;
    }
}

- (void)suKienBamNutHuongDanGiaoDichViewController:(UIButton *)sender {
    GiaoDienThongTinPhim *vc = [[GiaoDienThongTinPhim alloc] initWithNibName:@"GiaoDienThongTinPhim" bundle:nil];
    vc.nOption = HUONG_DAN_THANH_TOAN_INTERNET;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)khoiTaoBanDau{

    self.mtfChonVNPT.hidden = NO;
    UIPickerView *pickerChonThe = [[UIPickerView alloc] init];
    pickerChonThe.tag = 100;
    pickerChonThe.backgroundColor = [UIColor whiteColor];
    pickerChonThe.dataSource = self;
    pickerChonThe.delegate = self;
    self.mtfChonVNPT.inputView = pickerChonThe;

    self.mtfChonVNPT.inputAccessoryView = nil;

    CGRect rectChon = self.mtfChonVNPT.frame;
    CGRect rectMaKH = self.mtfMaKH.frame;
    CGRect rectBtnTraCuu = self.btnTraCuu.frame;

    rectMaKH.origin.y = rectChon.origin.y + rectChon.size.height + 8;
    rectBtnTraCuu.origin.y = rectMaKH.origin.y + rectMaKH.size.height + 8;
    self.mtfMaKH.frame = rectMaKH;
    self.btnTraCuu.frame = rectBtnTraCuu;

    CGRect rectQC = viewQC.frame;
    CGRect rectMain = self.viewMain.frame;
    rectQC.origin.y = rectBtnTraCuu.origin.y + rectBtnTraCuu.size.height + 10;
    rectMain.size.height = rectQC.origin.y + rectQC.size.height + 10;
    viewQC.frame = rectQC;
    self.viewMain.frame = rectMain;
}

- (void)updateGiaoDienKhiChonKhac{
    self.mtfChonVNPT.hidden = YES;

    CGRect rectChon = self.mtfChonVNPT.frame;
    CGRect rectBtnTraCuu = self.btnTraCuu.frame;

    rectBtnTraCuu.origin.y = rectChon.origin.y + rectChon.size.height + 8;
    self.mtfMaKH.frame = rectChon;
    self.btnTraCuu.frame = rectBtnTraCuu;

    CGRect rectQC = viewQC.frame;
    CGRect rectMain = self.viewMain.frame;
    rectQC.origin.y = rectBtnTraCuu.origin.y + rectBtnTraCuu.size.height + 10;
    rectMain.size.height = rectQC.origin.y + rectQC.size.height + 5;
    viewQC.frame = rectQC;
    self.viewMain.frame = rectMain;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 100) {
        return 3;
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 100) {
        switch (row) {
            case 0:
                return @"VNPT Hà Nội";
            case 1:
                return @"VNPT Hồ Chí Minh";
            case 2:
                return @"VNPT Hải Phòng";
            default:
                break;
        }
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (row) {
        case 0:
            nIdVNPT = NHA_CUNG_CAP_INTERNET_VNPT_HA_NOI;
            self.mtfChonVNPT.text = @"VNPT Hà Nội";
            break;
        case 1:
            nIdVNPT = NHA_CUNG_CAP_INTERNET_VNPT_HO_CHI_MINH;
            self.mtfChonVNPT.text = @"VNPT Hồ Chí Minh";
            break;
        case 2:
            nIdVNPT = NHA_CUNG_CAP_INTERNET_VNPT_HAI_PHONG;
            self.mtfChonVNPT.text = @"VNPT Hải Phòng";
            break;
        default:
            break;
    }
    [self.mtfChonVNPT resignFirstResponder];
}

- (IBAction)suKienChonVNPT:(id)sender {
    if (self.mtfChonVNPT.hidden) {
        nIdVNPT = NHA_CUNG_CAP_INTERNET_VNPT_HA_NOI;
        [self khoiTaoBanDau];
        [self thayDoiTrangThaiButton:0];
    }
}

- (IBAction)suKienChonFPT:(id)sender {
    if (nIdVNPT != NHA_CUNG_CAP_INTERNET_ADSL_FPT)
    {
        nIdVNPT = NHA_CUNG_CAP_INTERNET_ADSL_FPT;
        [self updateGiaoDienKhiChonKhac];
        [self thayDoiTrangThaiButton:1];
    }
}

- (IBAction)suKienChonViettel:(id)sender {
    if (nIdVNPT != NHA_CUNG_CAP_INTERNET_VIETTEL) {
        nIdVNPT = NHA_CUNG_CAP_INTERNET_VIETTEL;
        [self updateGiaoDienKhiChonKhac];
        [self thayDoiTrangThaiButton:2];
    }
}

- (IBAction)suKienBamNutTraCuu:(id)sender {
    if (self.mtfMaKH.text.length == 0) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập mã khách hàng"];
        return;
    }
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return;
    }
    [self showLoadingScreen];
    self.mDinhDanhKetNoi = DINH_DANH_TRA_CUU_INTERNET;
    [GiaoDichMang traCuuTienInternet:self.mtfMaKH.text maNhaCungCap:nIdVNPT user:self.mThongTinTaiKhoanVi.sID noiNhanKetQua:self];
}

- (IBAction)suKienBamNutCMC:(id)sender {
    if (nIdVNPT != NHA_CUNG_CAP_INTERNET_CMC)
    {
        NSLog(@"%s - chon CMC roi", __FUNCTION__);
        nIdVNPT = NHA_CUNG_CAP_INTERNET_CMC;
        [self updateGiaoDienKhiChonKhac];
        [self thayDoiTrangThaiButton:3];
    }
}

- (IBAction)suKienBamNutSoTay:(id)sender {
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return;
    }
    DucNT_DanhSachTaiKhoanThuongDungControllerViewController *vc = [[DucNT_DanhSachTaiKhoanThuongDungControllerViewController alloc] initWithType:TAI_KHOAN_NAP_TIEN_INTERNET];
    [self.navigationController presentViewController:vc animated:YES completion:^{}];
    [vc release];
}

- (void)batDauDemThoiGian1
{
    [self ketThucDemThoiGian1];
    mThoiGianDoi = 45;
    NSString *sCauThongBao = [NSString stringWithFormat:@"%@ %d s",[@"thong_bao_dang_tra_cuu_thong_tin_thanh_toan_viettel" localizableString], mThoiGianDoi];
    [self hienThiViewThongBao:sCauThongBao];
//    self.mDoiTuongNotification = nil;
    mTimer1 = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(capNhatDemThoiGian1) userInfo:nil repeats:YES];
}

- (void)ketThucDemThoiGian1
{
    if(mTimer1)
    {
        [mTimer1 invalidate];
        mTimer1 = nil;
    }
}

- (void)capNhatDemThoiGian1
{
    mThoiGianDoi --;
    NSString *sCauThongBao = [NSString stringWithFormat:@"%@ %d s",[@"thong_bao_dang_tra_cuu_thong_tin_thanh_toan_viettel" localizableString], mThoiGianDoi];
    [self hienThiViewThongBao:sCauThongBao];
    if(mThoiGianDoi == 0)
    {
        [self anViewThongBao];
        [self ketThucDemThoiGian1];
    }
}

- (void)hienThiViewThongBao:(NSString *)sThongBao
{
    if (!thongBaoInternet) {
        thongBaoInternet = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:sThongBao delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
    }
    if (!thongBaoInternet.visible) {
        [thongBaoInternet show];
    }
    thongBaoInternet.message = sThongBao;
}

- (void)anViewThongBao
{
    [self ketThucDemThoiGian1];
    if (thongBaoInternet) {
        [thongBaoInternet dismissWithClickedButtonIndex:0 animated:YES];
    }
}

- (void)thayDoiTrangThaiButton:(int)nIndex{
    [self.btnViettel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnFPT setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnVNPT setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnCMC setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

    [self.btnViettel setBackgroundColor:[UIColor whiteColor]];
    [self.btnFPT setBackgroundColor:[UIColor whiteColor]];
    [self.btnVNPT setBackgroundColor:[UIColor whiteColor]];
    [self.btnCMC setBackgroundColor:[UIColor whiteColor]];
    switch (nIndex) {
        case 0:
            [self.btnVNPT setBackgroundColor:[UIColor colorWithHexString:@"#015079"]];
            [self.btnVNPT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        case 1:
            [self.btnFPT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.btnFPT setBackgroundColor:[UIColor colorWithHexString:@"#015079"]];
            break;
        case 2:
            [self.btnViettel setBackgroundColor:[UIColor colorWithHexString:@"#015079"]];
            [self.btnViettel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        case 3:
            NSLog(@"%s - doi mau button CMC", __FUNCTION__);
            [self.btnCMC setBackgroundColor:[UIColor colorWithHexString:@"#015079"]];
            [self.btnCMC setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (void)xuLyKetNoiThanhCong:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua{
    NSLog(@"%s - sDinhDanhKetNoi : %@", __FUNCTION__, sDinhDanhKetNoi);
    [self hideLoadingScreen];
    if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_TRA_CUU_INTERNET]) {
        [self batDauDemThoiGian1];
    }
    else if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_CHI_TIET_INTERNET]){
        
    }
}

- (void)xuLyKetNoiThatBai:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua {
    [self hideLoadingScreen];
}

- (void)didReceiveRemoteNotification:(NSDictionary *)Info
{
    [self anViewThongBao];
//    NSLog(@"%s - info : %@", __FUNCTION__, Info);
    NSDictionary *userInfo = [Info valueForKey:@"userInfo"];
    if(userInfo)
    {
        NSLog(@"Debug:%@: %@, jSonString : %@", NSStringFromClass([self class]),NSStringFromSelector(_cmd), [userInfo JSONString]);
        DoiTuongNotification *doiTuongNotification = [[DoiTuongNotification alloc] initWithDict:userInfo];
        if([doiTuongNotification.typeShow intValue] == TYPE_SHOW_TRA_CUU_HOA_DON_INTERNET)
        {
            if ([doiTuongNotification.idShow isEqualToString:@"-1"]) {
                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Thuê bao không nợ cước"];
                return;
            }
            GiaoDienThanhToanSauTraCuuInternet *vc = [[GiaoDienThanhToanSauTraCuuInternet alloc] initWithNibName:@"GiaoDienThanhToanSauTraCuuInternet" bundle:nil];
            vc.idTypeShow = doiTuongNotification.idShow;
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
            [doiTuongNotification release];
        }
    }
}

- (void)dealloc {
    [viewQC release];
    [_viewMain release];
    [_btnVNPT release];
    [_btnFPT release];
    [_btnViettel release];
    [_mtfChonVNPT release];
    [_mtfMaKH release];
    [_btnTraCuu release];
    if (thongBaoInternet) {
        [thongBaoInternet release];
    }
    [_btnCMC release];
    [super dealloc];
}
@end
