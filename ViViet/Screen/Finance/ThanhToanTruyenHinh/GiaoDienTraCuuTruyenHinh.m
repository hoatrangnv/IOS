//
//  GiaoDienTraCuuTruyenHinh.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 2/26/16.
//
//

#import "GiaoDienTraCuuTruyenHinh.h"
#import "MoTaChiTietHoaDonDien.h"
#import "GiaoDienThanhToanTruyenHinh.h"
#import "GiaoDienThongTinPhim.h"
#import "DucNT_DanhSachTaiKhoanThuongDungControllerViewController.h"
#import "GiaoDienThanhToanKPlus.h"

@interface GiaoDienTraCuuTruyenHinh () <UIPickerViewDataSource, UIPickerViewDelegate> {
    int nMaNhaCungCap;
    UIAlertView *alertTimer;
    NSTimer *mTimer;
    int mThoiGianDoi;
    ViewQuangCao *viewQC;
}
@end
//https://developer.apple.com/enroll/migrate/
@implementation GiaoDienTraCuuTruyenHinh
//static NSString *css = @"<div style=\"text-align: center;\">%@</div>";
static NSString *cssKhachHang = @"<div style=\"text-align: center;\"><b>THÔNG TIN HOÁ ĐƠN</b></div><div>Tên khách hàng: %@ <br /> Địa chỉ: %@<br />%@<br /><b>Tổng số tiền: %@</b></div>";
static NSString *cssHoaDon = @"<div><b>Hoá đơn %d:</b><br />Số hoá đơn: %@<br />Kỳ thanh toán: %@<br />Số tiền: %@</div>";

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"Tra cước truyền hình";
    [self addTitleView:@"Tra cước truyền hình"];
    self.mFuncID = FUNC_THANH_TOAN_TRUYEN_HINH_CAP;
    _edMaThueBao.inputAccessoryView = nil;
    nMaNhaCungCap = NHA_CUNG_CAP_TRUYEN_HINH_CAP_VTV;
    _edOptionTruyenHinh.text = @"VTVCab - Truyền hình cáp Việt Nam";
    [self addButtonHuongDan];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateThongTinTruyenHinh:) name:KEY_TAI_KHOAN_THUONG_DUNG object:nil];

}

- (void)khoiTaoQuangCao {
    if (viewQC) {
        return;
    }
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
//    [self.scrMain setContentSize:CGSizeMake(_scrMain.frame.size.width, viewQC.frame.origin.y + viewQC.frame.size.height + 10)];
}

- (void)updateThongTinTruyenHinh:(NSNotification *)notification
{
    if([[notification name] isEqualToString:KEY_TAI_KHOAN_THUONG_DUNG])
    {
        DucNT_TaiKhoanThuongDungObject *temp = [notification object];
        _edMaThueBao.text = temp.maThueBao;
        _edOptionTruyenHinh.text = [self getTenNhaCungCapDichVuTheoMa:temp.maNhaCungCap];
    }
}

- (void)suKienBamNutHuongDanGiaoDichViewController:(UIButton *)sender {
    GiaoDienThongTinPhim *vc = [[GiaoDienThongTinPhim alloc] initWithNibName:@"GiaoDienThongTinPhim" bundle:nil];
    vc.nOption = HUONG_DAN_THANH_TOAN_TRUYEN_HINH;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setAnimationChoSoTay:self.btnSoTay];
    if (_edOptionTruyenHinh.rightView == nil) {
        UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 12)];
        [btnRight setBackgroundImage:[UIImage imageNamed:@"muiten35x21.png"] forState:UIControlStateNormal];
        _edOptionTruyenHinh.rightView = btnRight;
        _edOptionTruyenHinh.rightViewMode = UITextFieldViewModeAlways;

        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
        toolBar.barStyle = UIBarStyleBlackOpaque;
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneChonTruyenHinh:)];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelChonTruyenHinh:)];
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

        [toolBar setItems:[NSArray arrayWithObjects:cancelButton, flexSpace, doneButton, nil]];
        UIPickerView *pickerChonRap = [[UIPickerView alloc] init];
        pickerChonRap.dataSource = self;
        pickerChonRap.delegate = self;
        pickerChonRap.tag = 100;
        _edOptionTruyenHinh.inputAccessoryView = toolBar;
        _edOptionTruyenHinh.inputView = pickerChonRap;
        [pickerChonRap release];
    }

    if(_mDoiTuongNotification)
    {
        NSLog(@"%s - alertContent : %@", __FUNCTION__, _mDoiTuongNotification.alertContent);
        [self xuLyHienThiThongTinTraCuu];
//        https://vimass.vn/vmbank/services/ThanhToanTruyenHinhCapService/layChiTietGiaoDichThanhToanTruyenHinhCap?id=7899821456996922834
        self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_LAY_CHI_TIET_HOA_DON_DIEN_KHACH_HANG;
        [GiaoDichMang layChiTietHoaDonTruyenHinh:_mDoiTuongNotification.idShow noiNhanKetQua:self];
    }
//    [self khoiTaoQuangCao];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.btnSoTay.imageView stopAnimating];
}

- (void)doneChonTruyenHinh:(UIButton *)btn {
//    https://vimass.vn/vmbank/services/ThanhToanTruyenHinhCapService/traCuuHoaDon
//request:{"maThueBao":"411 417 8167","maNhaCungCap":1,"user":"0917951277"}
//    public static final int NHA_CUNG_CAP_TRUYEN_HINH_CAP_VTC = 1;
//    public static final int NHA_CUNG_CAP_TRUYEN_HINH_CAP_VTV = 2;
//    public static final int NHA_CUNG_CAP_TRUYEN_HINH_CAP_MY_TV = 3;
    [_edOptionTruyenHinh resignFirstResponder];
}

- (void)cancelChonTruyenHinh:(UIButton *)btn {
    [_edOptionTruyenHinh resignFirstResponder];
}

- (void)didReceiveRemoteNotification:(NSDictionary *)Info
{
//    NSLog(@"%s - info : %@", __FUNCTION__, Info);
    NSDictionary *userInfo = [Info valueForKey:@"userInfo"];
    if(userInfo)
    {
        NSLog(@"%s - lay duoc thong tin push truyen hinh", __FUNCTION__);
        DoiTuongNotification *doiTuongNotification = [[DoiTuongNotification alloc] initWithDict:userInfo];
        if([doiTuongNotification.typeShow intValue] == KIEU_NOTIFICATION_TIEN_TRUYEN_HINH)
        {
            if ([doiTuongNotification.alertContent rangeOfString:_edMaThueBao.text].location != NSNotFound) {
                self.mDoiTuongNotification = doiTuongNotification;
                [doiTuongNotification release];
            }
            else {
                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:doiTuongNotification.alertContent];
                [self ketThucDemThoiGian];
            }
        }
    }

}

- (void)batDauDemThoiGian
{
    [self ketThucDemThoiGian];
    mThoiGianDoi = 60;
    NSString *sCauThongBao = [NSString stringWithFormat:@"%@ %d s", @"Hệ thống đang tra cứu hoá đơn truyền hình. Vui lòng đợi sau: ", mThoiGianDoi];
    alertTimer.message = sCauThongBao;
    mTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(capNhatDemThoiGian) userInfo:nil repeats:YES];
}

- (void)ketThucDemThoiGian
{
    mThoiGianDoi = 60;
    if(mTimer)
    {
        [mTimer invalidate];
        mTimer = nil;
    }
}

- (void)capNhatDemThoiGian
{
    mThoiGianDoi --;
    NSString *sCauThongBao = [NSString stringWithFormat:@"%@ %d s", @"Hệ thống đang tra cứu hoá đơn truyền hình. Vui lòng đợi sau: ", mThoiGianDoi];
    alertTimer.message = sCauThongBao;

    if (mThoiGianDoi > 0 && _mDoiTuongNotification)
    {
        [self ketThucDemThoiGian];
        [alertTimer dismissWithClickedButtonIndex:0 animated:YES];
        [self xuLyChuyenViewThanhToan];
    }
    else if (mThoiGianDoi == 0 && !_mDoiTuongNotification)
    {
        [alertTimer dismissWithClickedButtonIndex:0 animated:YES];
        [self ketThucDemThoiGian];
    }
}

- (void) xuLyChuyenViewThanhToan {
    //thanh toan hoa don tien nuoc
    if(_mDoiTuongNotification)
    {
        NSString *idShow = _mDoiTuongNotification.idShow;
        if(![idShow isEqualToString:@""] && [_mDoiTuongNotification.typeShow intValue] == KIEU_NOTIFICATION_TIEN_TRUYEN_HINH)
        {
            [self xuLyHienThiThongTinTraCuu];
        }
        else
        {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:_mDoiTuongNotification.alertContent];
        }
    }
}

- (void)xuLyHienThiThongTinTraCuu {
    self.webInfo.hidden = NO;
    NSString *html = _mDoiTuongNotification.alertContent;
    html = [html stringByReplacingOccurrencesOfString:@"-" withString:@"<br/>-"];
    html = [html stringByReplacingOccurrencesOfString:@"Thông tin gói kênh:" withString:@"<br/>Thông tin gói kênh:<br/>"];
    html = [html stringByReplacingOccurrencesOfString:@"Thông tin thanh toán:" withString:@"<br/>Thông tin thanh toán:<br/>"];
    html = [html stringByReplacingOccurrencesOfString:@"CAO CAP#" withString:@"<br/>CAO CAP#"];
    html = [html stringByReplacingOccurrencesOfString:@"CO BAN#" withString:@"<br/>CO BAN#"];
    html = [html stringByReplacingOccurrencesOfString:@"HTV#" withString:@"<br/>HTV#"];
    html = [html stringByReplacingOccurrencesOfString:@"VTVCab#" withString:@"<br/>VTVCab#"];
    html = [html stringByReplacingOccurrencesOfString:@"PHO THONG#" withString:@"<br/>PHO THONG#"];
    html = [html stringByReplacingOccurrencesOfString:@"HD" withString:@"<br/>HD"];
    [self.webInfo loadHTMLString:html baseURL:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect rectWeb = self.webInfo.frame;
        CGRect rectTraCuu = self.btnTraCuu.frame;
        CGRect rectMai = self.mViewMain.frame;
        rectWeb.size.height += 150;
        rectTraCuu.origin.y = rectWeb.origin.y + rectWeb.size.height + 10;
//        CGRect rectQC = viewQC.frame;
//        rectQC.origin.y = rectTraCuu.origin.y + rectTraCuu.size.height + 10;
        rectMai.size.height = rectTraCuu.origin.y + rectTraCuu.size.height + 10;
//        viewQC.frame = rectQC;
        self.webInfo.frame = rectWeb;
        self.btnTraCuu.frame = rectTraCuu;
        self.mViewMain.frame = rectMai;
        [self.btnTraCuu setTitle:@"THANH TOÁN" forState:UIControlStateNormal];
    });
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 4;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (row) {
        case 0:
            return @"VTVCab - Truyền hình cáp Việt Nam";
        case 1:
            return @"VTC - Truyền hình vệ tinh số";
        case 2:
            return @"K+";
        case 3:
            return @"MyTV - Truyền hình VNPT";
//        case 4:
//            return @"MyTV Cần Thơ";
//        case 5:
//            return @"NextTV - Truyền hình số Viettel";
//        case 6:
//            return @"AVG - Truyền hình An Viên";
//        case 7:
//            return @"HCATV - Truyền hình cáp Hà Nội";
//        case 8:
//            return @"HTVC - Truyền hình cáp HCM";
//        case 9:
//            return @"SCTV - Truyền hình cáp Saigontourist";
//        case 10:
//            return @"SCTV Quận 4, 9 HCM";
        default:
            break;
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.btnTraCuu setHidden:NO];
    [self.viewThanhToanKPlus setHidden:YES];
    switch (row) {
        case 0:
            _edOptionTruyenHinh.text = @"VTVCab - Truyền hình cáp Việt Nam";
            nMaNhaCungCap = NHA_CUNG_CAP_TRUYEN_HINH_CAP_VTV;
            break;
        case 1:
            _edOptionTruyenHinh.text = @"VTC - Truyền hình vệ tinh số";
            nMaNhaCungCap = NHA_CUNG_CAP_TRUYEN_HINH_CAP_VTC;
            break;
        case 2:
            _edOptionTruyenHinh.text = @"K+";
            nMaNhaCungCap = NHA_CUNG_CAP_TRUYEN_HINH_K_PLUS;
            [self.btnTraCuu setHidden:YES];
            [self.viewThanhToanKPlus setHidden:NO];
            break;
        case 3:
            _edOptionTruyenHinh.text = @"MyTV - Truyền hình VNPT";
            nMaNhaCungCap = NHA_CUNG_CAP_TRUYEN_HINH_CAP_MY_TV;
            break;
        case 4:
            _edOptionTruyenHinh.text = @"MyTV Cần Thơ";
            nMaNhaCungCap = NHA_CUNG_CAP_TRUYEN_HINH_CAP_MY_TV;
            break;
        case 5:
            _edOptionTruyenHinh.text = @"NextTV - Truyền hình số Viettel";
            nMaNhaCungCap = -1;
            break;
        case 6:
            _edOptionTruyenHinh.text = @"AVG - Truyền hình An Viên";
            nMaNhaCungCap = -1;
            break;
        case 7:
            _edOptionTruyenHinh.text = @"HCATV - Truyền hình cáp Hà Nội";
            nMaNhaCungCap = -1;
            break;
        case 8:
            _edOptionTruyenHinh.text = @"HTVC - Truyền hình cáp HCM";
            nMaNhaCungCap = -1;
            break;
        case 9:
            _edOptionTruyenHinh.text = @"SCTV - Truyền hình cáp Saigontourist";
            nMaNhaCungCap = -1;
            break;
        case 10:
            _edOptionTruyenHinh.text = @"SCTV Quận 4, 9 HCM";
            nMaNhaCungCap = -1;
            break;
        default:
            break;
    }
}

- (BOOL)kiemTraTruocKhiTraCuu {
    if (nMaNhaCungCap == -1) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Chức năng đang được phát triển"];
        return NO;
    }
    if ([_edMaThueBao.text isEmpty]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập mã thuê bao truyền hình"];
        return NO;
    }
    return YES;
}

- (IBAction)suKienBamNutTraCuu:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        GiaoDienThanhToanTruyenHinh *vc = [[GiaoDienThanhToanTruyenHinh alloc] initWithNibName:@"GiaoDienThanhToanTruyenHinh" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
        return;
        
        if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
            DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
            [self presentViewController:loginSceen animated:YES completion:^{}];
            [loginSceen release];
            return;
        }
        if (_mDoiTuongNotification) {
            GiaoDienThanhToanTruyenHinh *vc = [[GiaoDienThanhToanTruyenHinh alloc] initWithNibName:@"GiaoDienThanhToanTruyenHinh" bundle:nil];
            vc.sIdTraCuu = _mDoiTuongNotification.idShow;
            vc.sMaThueBao = _edMaThueBao.text;
            vc.nNhaCungCap = nMaNhaCungCap;
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
            return;
        }
        if (![self kiemTraTruocKhiTraCuu]) {
            return;
        }
        [self.edMaThueBao resignFirstResponder];
        self.mDinhDanhKetNoi = DINH_DANH_TRA_CUU_TRUYEN_HINH;
        [GiaoDichMang traCuuHoaDonTruyenHinh:_edMaThueBao.text nhaCungCap:nMaNhaCungCap noiNhanKetQua:self];
    });
}

- (IBAction)suKienBamNutSoTay:(id)sender {
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return;
    }
    DucNT_DanhSachTaiKhoanThuongDungControllerViewController *vc = [[DucNT_DanhSachTaiKhoanThuongDungControllerViewController alloc] initWithType:TAI_KHOAN_NAP_TIEN_TRUYEN_HINH];
    [self.navigationController presentViewController:vc animated:YES completion:^{}];
    [vc release];
}

- (IBAction)suKienBamNutTraCuuKPlus:(id)sender {
    if ([self.edMaThueBao.text isEmpty]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Mã thuê bao không được để trống"];
        return;
    }
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self hienThiLoadingChuyenTien];
    }
    self.mDinhDanhKetNoi = @"TRA_CUU_KPLUS";
    [GiaoDichMang traCuuKPlus:self.edMaThueBao.text noiNhanKetQua:self];
}

- (IBAction)suKienBamNutThanhToanKPlus:(id)sender {
    GiaoDienThanhToanKPlus *vc = [[GiaoDienThanhToanKPlus alloc] initWithNibName:@"GiaoDienThanhToanKPlus" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)xuLyKetNoiThanhCong:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua{
//    [self hideLoadingScreen];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self anLoading];
    }
    if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_TRA_CUU_TRUYEN_HINH]) {
        if (!alertTimer) {
            alertTimer = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:@"Hệ thống đang tra cứu hoá đơn truyền hình. Vui lòng đợi sau: 60 s" delegate:nil cancelButtonTitle:@"Đóng" otherButtonTitles: nil];
        }
        [alertTimer show];
        [self batDauDemThoiGian];
    }
    else if([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_LAY_CHI_TIET_HOA_DON_DIEN_KHACH_HANG])
    {
        [self.view endEditing:YES];
        self.edMaThueBao.text = [ketQua objectForKey:@"maThueBao"];
        nMaNhaCungCap = [[ketQua objectForKey:@"maNhaCungCap"] intValue];
        switch (nMaNhaCungCap) {
            case NHA_CUNG_CAP_TRUYEN_HINH_CAP_VTV:
                _edOptionTruyenHinh.text = @"VTVCab - Truyền hình cáp Việt Nam";
                break;
            case NHA_CUNG_CAP_TRUYEN_HINH_CAP_VTC:
                _edOptionTruyenHinh.text = @"VTC - Truyền hình vệ tinh số";
                break;
            case NHA_CUNG_CAP_TRUYEN_HINH_CAP_MY_TV:
                _edOptionTruyenHinh.text = @"MyTV - Truyền hình VNPT";
                break;
            default:
                break;
        }
    }
    else if ([sDinhDanhKetNoi isEqualToString:@"TRA_CUU_KPLUS"]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
    }
}

- (NSString *)getTenNhaCungCapDichVuTheoMa:(int)nMa {
    switch (nMa) {
        case NHA_CUNG_CAP_TRUYEN_HINH_CAP_VTV:
            nMaNhaCungCap = NHA_CUNG_CAP_TRUYEN_HINH_CAP_VTV;
            [self.btnTraCuu setHidden:NO];
            [self.viewThanhToanKPlus setHidden:YES];
            return @"VTVCab - Truyền hình cáp Việt Nam";
        case NHA_CUNG_CAP_TRUYEN_HINH_CAP_VTC:
            [self.btnTraCuu setHidden:NO];
            [self.viewThanhToanKPlus setHidden:YES];
            nMaNhaCungCap = NHA_CUNG_CAP_TRUYEN_HINH_CAP_VTC;
            return @"VTC - Truyền hình vệ tinh số";
        case NHA_CUNG_CAP_TRUYEN_HINH_CAP_MY_TV:
            [self.btnTraCuu setHidden:NO];
            [self.viewThanhToanKPlus setHidden:YES];
            nMaNhaCungCap = NHA_CUNG_CAP_TRUYEN_HINH_CAP_MY_TV;
            return @"MyTV - Truyền hình VNPT";
        case NHA_CUNG_CAP_TRUYEN_HINH_K_PLUS:
            [self.btnTraCuu setHidden:YES];
            [self.viewThanhToanKPlus setHidden:NO];
            nMaNhaCungCap = NHA_CUNG_CAP_TRUYEN_HINH_K_PLUS;
            return @"K+";
        default:
            return @"";
    }
}

- (void)khoiTaoGiaTriChiTietKhachHang
{
    if(_mMoTaChiTietKhachHang)
    {
        self.edMaThueBao.text = _mMoTaChiTietKhachHang.maKhachHang;
        self.edMaThueBao.enabled = NO;
        self.edOptionTruyenHinh.text = _mMoTaChiTietKhachHang.maDienLuc;
        //Tao xau html o day
        NSMutableString *sCacHoaDon = [[NSMutableString alloc] init];
        int i = 0;
        for(MoTaChiTietHoaDonDien *moTaChiTietHoaDonDien in _mMoTaChiTietKhachHang.list)
        {
            i++;
            [sCacHoaDon appendFormat:cssHoaDon, i, moTaChiTietHoaDonDien.maHoaDon, moTaChiTietHoaDonDien.kyThanhToan, [NSString stringWithFormat:@"%@ đ", [Common hienThiTienTe:[moTaChiTietHoaDonDien.soTien doubleValue]]]];
        }
        NSString *sXauHtml = [NSString stringWithFormat:cssKhachHang, _mMoTaChiTietKhachHang.tenKhachHang, _mMoTaChiTietKhachHang.diaChi, sCacHoaDon, [NSString stringWithFormat:@"%@ đ", [Common hienThiTienTe:[_mMoTaChiTietKhachHang.total doubleValue]]]];
        [self.webInfo loadHTMLString:sXauHtml baseURL:nil];
    }
}

- (void)dealloc {
    NSLog(@"%s - 1", __FUNCTION__);
//    [viewQC release];
    NSLog(@"%s - 2", __FUNCTION__);
    [_edOptionTruyenHinh release];
    NSLog(@"%s - 3", __FUNCTION__);
    [_edMaThueBao release];
    NSLog(@"%s - 4", __FUNCTION__);
    [_btnTraCuu release];
    NSLog(@"%s - 5", __FUNCTION__);
    [_viewThanhToanKPlus release];
    [super dealloc];
    NSLog(@"%s - 6", __FUNCTION__);
}
@end
