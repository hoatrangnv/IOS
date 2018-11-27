//
//  GiaoDienThanhToanNuoc.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 2/3/16.
//
//

#import "GiaoDienThanhToanNuoc.h"
#import "DoiTuongNotification.h"
#import "TraCuuTienDienViewController.h"
#import "MoTaChiTietKhachHang.h"
#import "MoTaChiTietHoaDonDien.h"
#import "ThanhToanTienDienViewController.h"
#import "GiaoDienThongTinPhim.h"
#import "DucNT_DanhSachTaiKhoanThuongDungControllerViewController.h"
#import "DucNT_LoginSceen.h"
@interface GiaoDienThanhToanNuoc () <UIPickerViewDataSource, UIPickerViewDelegate>{
    int nRowNhaMay;
    UIAlertView *alertTimer;
    NSTimer *mTimer;
    int mThoiGianDoi;
    ViewQuangCao *viewQC;
}
@property (nonatomic, retain) MoTaChiTietKhachHang *mMoTaChiTietKhachHang;
@property (nonatomic, retain) DoiTuongNotification *mDoiTuongNotification;
@end

@implementation GiaoDienThanhToanNuoc
//static NSString *css = @"<div style=\"text-align: center;\">%@</div>";
static NSString *cssKhachHang = @"<div style=\"text-align: center;\"><b>THÔNG TIN HOÁ ĐƠN</b></div><div>Tên khách hàng: %@ <br /> Địa chỉ: %@<br />%@<br /><b>Tổng số tiền: %@</b></div>";
static NSString *cssHoaDon = @"<div><b>Hoá đơn %d:</b><br />Số hoá đơn: %@<br />Kỳ thanh toán: %@<br />Số tiền: %@</div>";

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"Thanh toán tiền nước";
    [self addTitleView:@"Thanh toán tiền nước"];
    nRowNhaMay = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateThongTinTienNuoc:) name:KEY_TAI_KHOAN_THUONG_DUNG object:nil];
}

- (void)updateThongTinTienNuoc:(NSNotification *)notification
{
    if([[notification name] isEqualToString:KEY_TAI_KHOAN_THUONG_DUNG])
    {
        DucNT_TaiKhoanThuongDungObject *temp = [notification object];
        _edChonNhaMay.text = [self layTenNhaMayNuocTheoMaThanhToan:temp.kieuThanhToan];
        _edMaKH.text = temp.maKhachHang;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self setAnimationChoSoTay:self.btnSoTay];

    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 12)];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"muiten35x21.png"] forState:UIControlStateNormal];
    _edChonNhaMay.rightView = btnRight;
    _edChonNhaMay.rightViewMode = UITextFieldViewModeAlways;

    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneChonNhaMay:)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelChonNhaMay:)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

    [toolBar setItems:[NSArray arrayWithObjects:cancelButton, flexSpace, doneButton, nil]];
    UIPickerView *pickerChonRap = [[UIPickerView alloc] init];
    pickerChonRap.dataSource = self;
    pickerChonRap.delegate = self;
    pickerChonRap.tag = 100;
    _edChonNhaMay.inputAccessoryView = toolBar;
    _edChonNhaMay.inputView = pickerChonRap;
    [pickerChonRap release];

    if(_mIdShow)
    {
        [self.webInfo setHidden:NO];
        CGRect rectInfo = self.webInfo.frame;
        CGRect rectTraCuu = self.btnTraCuu.frame;
        CGRect rectMain = self.mViewMain.frame;
        rectInfo.size.height = rectInfo.size.height + 120;
        rectTraCuu.origin.y = rectInfo.origin.y + rectInfo.size.height + 10;
        rectMain.size.height = rectTraCuu.origin.y + rectTraCuu.size.height + 10;
        self.webInfo.frame = rectInfo;
        self.btnTraCuu.frame = rectTraCuu;
        self.mViewMain.frame = rectMain;
        [self.btnTraCuu setTitle:@"THANH TOÁN" forState:UIControlStateNormal];

        self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_LAY_CHI_TIET_HOA_DON_DIEN_KHACH_HANG;
        [GiaoDichMang ketNoiLayChiTietThongTinTraCuuHoaDon:_mIdShow noiNhanKetQua:self];
    }
    [self addButtonHuongDan];
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
        rectQC.origin.y = rectToken.origin.y + rectToken.size.height + 15;
        viewQC.frame = CGRectMake(0, rectQC.origin.y, fW, fH);
        viewQC.mDelegate = self;
        [viewQC updateSizeQuangCao];
        rectMain.size.height = rectQC.origin.y + rectQC.size.height;
        self.mViewMain.frame = rectMain;
        [self.mViewMain addSubview:viewQC];
    }
}

- (void)suKienBamNutHuongDanGiaoDichViewController:(UIButton *)sender {
    GiaoDienThongTinPhim *vc = [[GiaoDienThongTinPhim alloc] initWithNibName:@"GiaoDienThongTinPhim" bundle:nil];
    vc.nOption = HUONG_DAN_THANH_TOAN_NUOC;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)doneChonNhaMay:(UIBarButtonItem *)sender {
    [_edChonNhaMay resignFirstResponder];
    _edChonNhaMay.text = [self layTenNhaMayNuoc:nRowNhaMay];
}

- (void)cancelChonNhaMay:(UIBarButtonItem *)sender {
    [_edChonNhaMay resignFirstResponder];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 8;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self layTenNhaMayNuoc:(int)row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    nRowNhaMay = (int)row;
    _edChonNhaMay.text = [self layTenNhaMayNuoc:nRowNhaMay];
}

- (NSString *)layTenNhaMayNuoc:(int)row{
    switch (row) {
        case 0:
            return @"Chọn đơn vị cung cấp";
            break;
        case 1:
            return @"Nhà Bè";
            break;
        case 2:
            return @"Bến Thành";
            break;
        case 3:
            return @"Chợ Lớn";
            break;
        case 4:
            return @"Phú Hòa Tân";
            break;
        case 5:
            return @"Thủ Đức";
            break;
        case 6:
            return @"Trung An";
            break;
        case 7:
            return @"Tân Hòa";
            break;
        default:
            break;
    }
    return @"";
}

- (NSString *)layTenNhaMayNuocTheoMa:(int)row{
    switch (row) {
        case -1:
            return @"Chọn đơn vị cung cấp";
            break;
        case 102:
            return @"Nhà Bè";
            break;
        case 104:
            return @"Bến Thành";
            break;
        case 106:
            return @"Chợ Lớn";
            break;
        case 108:
            return @"Phú Hòa Tân";
            break;
        case 110:
            return @"Thủ Đức";
            break;
        case 112:
            return @"Trung An";
            break;
        case 114:
            return @"Tân Hòa";
            break;
        default:
            break;
    }
    return @"Chọn đơn vị cung cấp";
}

- (NSString *)layTenNhaMayNuocTheoMaThanhToan:(int)row{
    switch (row) {
        case -1:
            return @"Chọn đơn vị cung cấp";
            break;
        case 103:
            return @"Nhà Bè";
            break;
        case 105:
            return @"Bến Thành";
            break;
        case 107:
            return @"Chợ Lớn";
            break;
        case 109:
            return @"Phú Hòa Tân";
            break;
        case 111:
            return @"Thủ Đức";
            break;
        case 113:
            return @"Trung An";
            break;
        case 115:
            return @"Tân Hòa";
            break;
        default:
            break;
    }
    return @"Chọn đơn vị cung cấp";
}

- (int)layMaTraCuu:(int)row{
    switch (row) {
        case 0:
            return -1;
            break;
        case 1:
            return 102;
            break;
        case 2:
            return 104;
            break;
        case 3:
            return 106;
            break;
        case 4:
            return 108;
            break;
        case 5:
            return 110;
            break;
        case 6:
            return 112;
            break;
        case 7:
            return 114;
            break;
        default:
            break;
    }
    return -1;
}

- (IBAction)suKienBamNutTraCuu:(id)sender {
    [self resignFirstResponder];
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return;
    }
    if(_mMoTaChiTietKhachHang)
    {
        //Thanh Toan
        ThanhToanTienDienViewController *thanhToanTienDienViewController = [[ThanhToanTienDienViewController alloc] initWithNibName:@"ThanhToanTienDienViewController" bundle:nil];
        thanhToanTienDienViewController.nChucNang = 2;
        thanhToanTienDienViewController.mMoTaChiTietKhachHang = _mMoTaChiTietKhachHang;
        [self.navigationController pushViewController:thanhToanTienDienViewController animated:YES];
        [thanhToanTienDienViewController release];
    }
    else
    {
        NSString *seccsion = self.mThongTinTaiKhoanVi.secssion;
        int nKieuThanhToan = [self layMaTraCuu:nRowNhaMay];
        if (nKieuThanhToan == -1) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng chọn đơn vị cung cấp dịch vụ"];
            return;
        }
        if ([self.edMaKH.text isEmpty]) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập mã khách hàng"];
            return;
        }
        if(seccsion)
        {
            self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_TRA_CUU_HOA_DON_DIEN_KHACH_HANG;
            [GiaoDichMang ketNoiTraCuuHoaDonTienDien:nKieuThanhToan
                                         maKhachHang:self.edMaKH.text
                                            secssion:self.mThongTinTaiKhoanVi.secssion
                                       noiNhanKetQua:self];
        }
        else
        {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Xin vui lòng đăng nhập lại để thực hiện chức năng này"];
        }
    }
}

- (IBAction)suKienBamSoTayNuoc:(id)sender {
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return;
    }
    DucNT_DanhSachTaiKhoanThuongDungControllerViewController *vc = [[DucNT_DanhSachTaiKhoanThuongDungControllerViewController alloc] initWithType:TAI_KHOAN_HOA_DON_NUOC];
    [self.navigationController presentViewController:vc animated:YES completion:^{}];
    [vc release];
}

- (void)xuLyKetNoiThanhCong:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua{
    if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_TRA_CUU_HOA_DON_DIEN_KHACH_HANG]) {
        NSLog(@"%s - sThongBao : %@", __FUNCTION__, sThongBao);
        if (!alertTimer) {
            alertTimer = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:@"Hệ thống đang tra cứu hoá đơn nước. Vui lòng đợi sau: 60 s" delegate:nil cancelButtonTitle:@"Đóng" otherButtonTitles: nil];
        }
        [alertTimer show];
        [self batDauDemThoiGian];
    }
    else if([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_LAY_CHI_TIET_HOA_DON_DIEN_KHACH_HANG])
    {
        [self.view endEditing:YES];
        if(ketQua)
        {
            NSString *jsonMoTa = [ketQua valueForKey:@"moTa"];
            if(jsonMoTa)
            {
                NSLog(@"%s - jsonMoTa : %@", __FUNCTION__, jsonMoTa);
                NSDictionary *moTa = [jsonMoTa objectFromJSONString];
                MoTaChiTietKhachHang *moTaChiTietKhachHang = [[MoTaChiTietKhachHang alloc] initWithDictionary:moTa];
                self.mMoTaChiTietKhachHang = moTaChiTietKhachHang;
                [self khoiTaoGiaTriChiTietKhachHang];
                [moTaChiTietKhachHang release];
            }
        }
    }
}

- (void)khoiTaoGiaTriChiTietKhachHang
{
    if(_mMoTaChiTietKhachHang)
    {
        self.edMaKH.text = _mMoTaChiTietKhachHang.maKhachHang;
        self.edMaKH.enabled = NO;
        self.edChonNhaMay.text = _mMoTaChiTietKhachHang.maDienLuc;
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

- (void)batDauDemThoiGian
{
    [self ketThucDemThoiGian];
    mThoiGianDoi = 60;
    NSString *sCauThongBao = [NSString stringWithFormat:@"%@ %d s", @"Hệ thống đang tra cứu hoá đơn nước. Vui lòng đợi sau: ", mThoiGianDoi];
    alertTimer.message = sCauThongBao;
    mTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(capNhatDemThoiGianTienNuoc) userInfo:nil repeats:YES];
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

- (void)capNhatDemThoiGianTienNuoc
{
    mThoiGianDoi --;
    NSString *sCauThongBao = [NSString stringWithFormat:@"%@ %d s", @"Hệ thống đang tra cứu hoá đơn nước. Vui lòng đợi sau: ", mThoiGianDoi];
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

- (void)didReceiveRemoteNotification:(NSDictionary *)Info{
    NSDictionary *userInfo = [Info valueForKey:@"userInfo"];
    if(userInfo)
    {
        NSLog(@"Debug:%@: %@, jSonString : %@", NSStringFromClass([self class]),NSStringFromSelector(_cmd), [userInfo JSONString]);
        DoiTuongNotification *doiTuongNotification = [[DoiTuongNotification alloc] initWithDict:userInfo];
        if([doiTuongNotification.typeShow intValue] == KIEU_NOTIFICATION_TIEN_NUOC)
        {
            NSString *sMaKhachHangDangTraCuu = _edMaKH.text;
            if([doiTuongNotification.alertContent rangeOfString:sMaKhachHangDangTraCuu].location != NSNotFound)
            {
                self.mDoiTuongNotification = doiTuongNotification;
            }
            [doiTuongNotification release];
            [self ketThucDemThoiGian];
        }
    }
}

- (void) xuLyChuyenViewThanhToan {
    //thanh toan hoa don tien nuoc
    if(_mDoiTuongNotification)
    {
        NSString *idShow = _mDoiTuongNotification.idShow;
        if(![idShow isEqualToString:@""] && [_mDoiTuongNotification.typeShow intValue] == KIEU_NOTIFICATION_TIEN_NUOC)
        {
            TraCuuTienDienViewController *traCuuTienDienViewController = [[TraCuuTienDienViewController alloc] initWithNibName:@"TraCuuTienDienViewController" bundle: nil];
            traCuuTienDienViewController.mIdShow = idShow;
            [self.navigationController pushViewController:traCuuTienDienViewController animated:YES];
            [traCuuTienDienViewController release];
        }
        else
        {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:_mDoiTuongNotification.alertContent];
        }
    }
}

- (void)dealloc {
    [viewQC release];
    [_edChonNhaMay release];
    [_edMaKH release];
    if (_mDoiTuongNotification) {
        [_mDoiTuongNotification release];
    }
    [_webInfo release];
    [_btnTraCuu release];
    [super dealloc];
}
@end
