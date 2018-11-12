//
//  ThanhToanDienThoaiKhacViewController.m
//  ViViMASS
//
//  Created by DucBT on 3/24/15.
//
//

#import "ThanhToanDienThoaiKhacViewController.h"
#import "ContactScreen.h"
#import "DoiTuongNotification.h"
#import "DucNT_DanhSachTaiKhoanThuongDungControllerViewController.h"
#import "DucNT_TaiKhoanThuongDungObject.h"
#import "GiaoDienThongTinPhim.h"
#import "DucNT_LoginSceen.h"

#define NAP_DI_DONG_TRA_TRUOC [@"thanh_toan_nap_di_dong_tra_truoc" localizableString]
#define THANH_TOAN_DI_DONG_TRA_SAU [@"thanh_toan_di_dong_tra_sau" localizableString]
#define NAP_THE_CAO [@"thanh_toan_mua_the_cao" localizableString]
#define KHOANG_CACH_GIUA_2_CONTROL 8.0f
const int TIME_COUNT_DOWN_DIEN_THOAI = 180;

@interface ThanhToanDienThoaiKhacViewController () <UITableViewDataSource, UITableViewDelegate>
{
    int mThoiGianDoi;
    NSTimer *mTimer1;
    double mSoTienThanhToan;
    NSInteger mViTriChonSoLuongTheCao; //Chi danh cho the loai mua the cao.
    UIAlertView *thongBaoViettel;
    NSString *infoViettel;
    NSString *infoVina;
    NSString *infoMobi;
    BOOL bLanDau, isCoDinh;
    ViewQuangCao *viewQC;
    NSTimer *mTimer;
}

@property (nonatomic, assign) NSInteger mLuaChonThanhToan;
@property (nonatomic, retain) NSArray *mDanhSachLuaChonThanhToan;
@property (nonatomic, retain) NSArray *mDanhSachSoLuong;
@property (retain, nonatomic) NSString *mSoDienThoaiDangTraCuuTraSau;
@property (retain, nonatomic) DoiTuongNotification *mDoiTuongNotification;
@end

@implementation ThanhToanDienThoaiKhacViewController

NSString *sCauLuuY = @"<b>Lưu ý:</b> Số điện thoại nhận thanh toán cần đăng ký tài khoản EZPay.<br/>Đăng ký EZPay qua SMS: Soạn <b>EZPAY</b> gửi <b>9888</b>";

#pragma mark - init

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
//        _mNhaMang = -1;
    }
    return self;
}

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addButtonBack];
    self.mViewMain.layer.borderColor = [UIColor whiteColor].CGColor;
    self.mViewMain.layer.borderWidth = 1.0f;
    bLanDau = YES;
    mThoiGianDoi = 0;

    NSLog(@"%s - START ****", __FUNCTION__);
    
    CGRect rectMain = self.mViewMain.frame;
    rectMain.origin.y = 5;
    rectMain.origin.x = 10;
    self.mViewMain.frame = rectMain;
    [self.mscrv addSubview:self.mViewMain];
    [self.mscrv bringSubviewToFront:self.viewOptionTop];

    [self.mwvHienThiLuuY loadHTMLString:sCauLuuY baseURL:nil];
    [self khoiTaoTheoNhaMang];
    [self.soTienViettel setTextError:@"Số tiền không được để trống" forType:ExTextFieldTypeEmpty];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateThongTinDienThoai:) name:KEY_TAI_KHOAN_THUONG_DUNG object:nil];
    [self addButtonHuongDan];

    if (self.mNhaMang == NHA_MANG_VINA) {
        [self suKienChonNhaMangVina:nil];
    }
    else if (self.mNhaMang == NHA_MANG_MOBI) {
        [self suKienChonNhaMangMobi:nil];
    }
    else if (self.mNhaMang == NHA_MANG_VIETNAMMOBILE || self.mNhaMang == NHA_MANG_GMOBILE) {
        [self suKienChonNhaMangKhac:nil];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateThongTinTraCuuDienThoai:) name:@"UPDATE_TRA_CUU_DIEN_THOAI" object:nil];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(suKienClickViewTime:)];
    [_viewTimeTraCuuTraSau addGestureRecognizer:tap];
}

- (void)suKienClickViewTime:(UITapGestureRecognizer *)tap {
    [self anViewThongBaoHoaDonDienThoai];
    [self ketThucDemThoiGian];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setAnimationChoSoTay:self.btnSoTay];
    [self khoiTaoQuangCao];
}

- (void)updateThongTinTraCuuDienThoai:(NSNotification *)notification
{
    NSLog(@"%s - notification : %@", __FUNCTION__, notification);
    if([[notification name] isEqualToString:@"UPDATE_TRA_CUU_DIEN_THOAI"])
    {
        
    }
}


- (void)khoiTaoQuangCao {
    if (viewQC) {
        return;
    }
    viewQC = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ViewQuangCao class]) owner:self options:nil] objectAtIndex:0];
//    viewQC.backgroundColor = UIColor.redColor;
    viewQC.mDelegate = self;
    CGRect rectToken = self.mViewNhapToken.frame;
    CGRect rectQC = viewQC.frame;
    CGRect rectMain = self.mViewMain.frame;

    CGFloat fW = rectMain.size.width;
    CGFloat fH = fW * 0.45333;
    rectQC.origin.y = rectToken.origin.y + rectToken.size.height + 5;
    viewQC.frame = CGRectMake(0, rectQC.origin.y, fW, fH);
    viewQC.mDelegate = self;
    [viewQC updateSizeQuangCao];
    rectMain.size.height = rectQC.origin.y + rectQC.size.height;
    self.mViewMain.frame = rectMain;
    [self.mViewMain addSubview:viewQC];
    [self.mscrv setContentSize:CGSizeMake(_mscrv.frame.size.width, rectMain.origin.y + rectMain.size.height)];
    
}

- (void)suKienBamNutHuongDanGiaoDichViewController:(UIButton *)sender {
    NSLog(@"%s - nhaMang : %ld", __FUNCTION__, (long)self.mNhaMang);
    GiaoDienThongTinPhim *vc = [[GiaoDienThongTinPhim alloc] initWithNibName:@"GiaoDienThongTinPhim" bundle:nil];
    if (isCoDinh) {
        vc.nOption = HUONG_DAN_THANH_TOAN_DIEN_THOAI_CO_DINH;
    }
    else {
        if (self.mNhaMang == NHA_MANG_VIETTEL) {
            vc.nOption = HUONG_DAN_THANH_TOAN_DIEN_THOAI_VIETEL;
        }
        else if (self.mNhaMang == NHA_MANG_VINA) {
            vc.nOption = HUONG_DAN_THANH_TOAN_DIEN_THOAI_VINA;
        }
        else if (self.mNhaMang == NHA_MANG_MOBI) {
            vc.nOption = HUONG_DAN_THANH_TOAN_DIEN_THOAI_MOBI;
        }
        else if (self.mNhaMang == NHA_MANG_VIETNAMMOBILE) {
            NSLog(@"%s - self.mLuaChonThanhToan = %d", __FUNCTION__, (int)self.mLuaChonThanhToan);
            vc.nOption = HUONG_DAN_THANH_TOAN_DIEN_THOAI_VIETNAMOBILE;
            if (self.mLuaChonThanhToan == 2 || self.mLuaChonThanhToan == 3) {
                vc.nOption = HUONG_DAN_THANH_TOAN_DIEN_THOAI_GMOBILE;
            }
        }
        else  if (self.mNhaMang == NHA_MANG_GMOBILE){
            vc.nOption = HUONG_DAN_THANH_TOAN_DIEN_THOAI_GMOBILE;
        }
    }
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

-(void)updateThongTinDienThoai:(NSNotification *)notification
{
    if([[notification name] isEqualToString:KEY_TAI_KHOAN_THUONG_DUNG])
    {
        DucNT_TaiKhoanThuongDungObject *mTaiKhoanThuongDung = [notification object];
        NSLog(@"%s - mTaiKhoanThuongDung.nhaMang : %d", __FUNCTION__, mTaiKhoanThuongDung.nhaMang);
        if (mTaiKhoanThuongDung.nhaMang == NHA_MANG_VIETTEL) {
            [self suKienChonNhaMangViettel:self.btnViettel];
            if (mTaiKhoanThuongDung.loaiThueBao == 1) {
                self.mLuaChonThanhToan = 2;
            }
            else{
                self.mLuaChonThanhToan = 0;
            }
        }
        else if (mTaiKhoanThuongDung.nhaMang == NHA_MANG_VINA) {
            [self suKienChonNhaMangVina:self.btnVina];
            if (mTaiKhoanThuongDung.loaiThueBao == 1) {
                self.mLuaChonThanhToan = 2;
            }
            else{
                self.mLuaChonThanhToan = 0;
            }
        }
        else if (mTaiKhoanThuongDung.nhaMang == NHA_MANG_MOBI) {
            [self suKienChonNhaMangVina:self.btnMobi];
            if (mTaiKhoanThuongDung.loaiThueBao == 1) {
                self.mLuaChonThanhToan = 2;
            }
            else{
                self.mLuaChonThanhToan = 0;
            }
        }
        else if (mTaiKhoanThuongDung.nhaMang == NHA_MANG_VIETNAMMOBILE || mTaiKhoanThuongDung.nhaMang == NHA_MANG_GMOBILE) {
            [self suKienChonNhaMangKhac:self.btnKhac];
            if (mTaiKhoanThuongDung.nhaMang == NHA_MANG_VIETNAMMOBILE) {
                self.mLuaChonThanhToan = 0;
            }
            else{
                self.mLuaChonThanhToan = 2;
            }
        }
        NSString *sKieuLuaChon = [self.mDanhSachLuaChonThanhToan objectAtIndexedSubscript:self.mLuaChonThanhToan];
        self.mtfLuaChon.text = sKieuLuaChon;
        self.mtfSoDienThoai.text = mTaiKhoanThuongDung.soDienThoai;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    UIImageView *imgSoTay = [self.btnSoTay imageView];
    [imgSoTay stopAnimating];
    [self ketThucDemThoiGian];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *sSoDu = [NSString stringWithFormat:@"%@ đ", [Common hienThiTienTe:[self.mThongTinTaiKhoanVi.nAmount doubleValue]]];
    sSoDu = [NSString stringWithFormat:@"%@ %@", [@"so_du" localizableString], sSoDu];
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        [self addTitleView:@"Thanh toán điện thoại"];
    }
    else{
        [self addTitleView:[NSString stringWithFormat:@"%@", sSoDu]];
    }
    if (self.mDoiTuongThanhToanCuocDienThoaiViettel) {
        self.soTienViettel.text = self.mDoiTuongThanhToanCuocDienThoaiViettel.tienCuocPhaiThanhToan;
        self.edSoTienTraSauViettel.text = self.mDoiTuongThanhToanCuocDienThoaiViettel.tienCuocPhaiThanhToan;
        
        self.mLuaChonThanhToan = 2;
        [self khoiTaoTheoLuaChonThanhToan];
        self.soTienViettel.enabled = NO;
        [self khoiTaoGiaoDienDiDongVaDcomTraSau];
    }
}

- (IBAction)suKienThayDoiGiaTriTextFieldSoTien:(id)sender
{
    NSLog(@"%s - START", __FUNCTION__);
    double fSoTien = [[[self.soTienViettel.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
    mSoTienThanhToan = fSoTien;
    if(fSoTien > 0)
        self.soTienViettel.text = [Common hienThiTienTe:fSoTien];
    else
        self.soTienViettel.text = @"";
    [self hienThiSoPhi];
    [self hienThiKhuyenMai];
}

#pragma mark - khoiTao
- (void)khoiTaoTheoNhaMang
{
    mSoTienThanhToan = 0.0f;
    if(_mNhaMang == - 1)
    {
        _mNhaMang = [[DucNT_LuuRMS layThongTinDangNhap:KEY_LUU_KIEU_THANH_TOAN_DIEN_THOAI] intValue];
    }
    
    switch (self.mNhaMang) {
        case NHA_MANG_VIETTEL:
            self.mDanhSachLuaChonThanhToan = @[[@"thanh_toan_viettel_thanh_toan_di_dong_hoac_dcom_tra_truoc" localizableString],
                                               [@"thanh_toan_viettel_thanh_toan_ngay_vang" localizableString],
                                               [@"thanh_toan_viettel_thanh_toan_di_dong_hoac_dcom_tra_sau" localizableString],
                                               @"Thẻ cào Viettel",
                                               [@"thanh_toan_viettel_thanh_toan_dien_thoai_co_dinh" localizableString],
                                               [@"thanh_toan_viettel_thanh_toan_homephone" localizableString],
                                               [@"thanh_toan_viettel_thanh_toan_truyen_hinh_va_internet" localizableString]];

            self.mDanhSachSoLuong = @[[NSString stringWithFormat:@"%@: %d", [@"job reg - quantity" localizableString], 1],
                                      [NSString stringWithFormat:@"%@: %d", [@"job reg - quantity" localizableString], 2],
                                      [NSString stringWithFormat:@"%@: %d", [@"job reg - quantity" localizableString], 3]];
            if (!infoViettel) {
                [self ketNoiLayThongTinNgayVang:(int)self.mNhaMang];
            }
            break;
        case NHA_MANG_MOBI:
            self.mDanhSachLuaChonThanhToan = @[[@"thanh_toan_nap_di_dong_tra_truoc_mobi" localizableString],
                                               [@"thanh_toan_nap_di_dong_ngay_vang_mobi" localizableString],
                                               [@"thanh_toan_di_dong_tra_sau_mobi" localizableString],
                                               [@"thanh_toan_mua_the_cao_mobi" localizableString]];
            self.mDanhSachSoLuong = @[[NSString stringWithFormat:@"%@: %d", [@"job reg - quantity" localizableString], 1],
                                      [NSString stringWithFormat:@"%@: %d", [@"job reg - quantity" localizableString], 2],
                                      [NSString stringWithFormat:@"%@: %d", [@"job reg - quantity" localizableString], 3]];
            if (!infoMobi) {
                [self ketNoiLayThongTinNgayVang:(int)self.mNhaMang];
            }
            break;
        case NHA_MANG_VINA:
            self.mDanhSachLuaChonThanhToan = @[[@"thanh_toan_nap_di_dong_tra_truoc_vina" localizableString],
                                               [@"thanh_toan_nap_di_dong_ngay_vang_vina" localizableString],
                                               [@"thanh_toan_di_dong_tra_sau_vina" localizableString],
                                               [@"thanh_toan_mua_the_cao_vina" localizableString]];
            self.mDanhSachSoLuong = @[[NSString stringWithFormat:@"%@: %d", [@"job reg - quantity" localizableString], 1],
                                      [NSString stringWithFormat:@"%@: %d", [@"job reg - quantity" localizableString], 2],
                                      [NSString stringWithFormat:@"%@: %d", [@"job reg - quantity" localizableString], 3]];
            if (!infoVina) {
                [self ketNoiLayThongTinNgayVang:(int)self.mNhaMang];
            }
            break;
        case NHA_MANG_VIETNAMMOBILE:
            self.mDanhSachLuaChonThanhToan = @[[@"thanh_toan_nap_di_dong_tra_truoc_khac_vietna" localizableString],
                                               [@"thanh_toan_mua_the_cao_khac_vietna" localizableString],
                                               [@"thanh_toan_nap_di_dong_tra_truoc_khac_gmobile" localizableString],
                                               [@"thanh_toan_mua_the_cao_khac_gmobile" localizableString],
                                               [@"thanh_toan_di_dong_khac_dt_co_dinh_hn" localizableString],
                                               [@"thanh_toan_di_dong_khac_dt_co_dinh_hcm" localizableString],
                                               [@"thanh_toan_di_dong_khac_dt_co_dinh_hp" localizableString]];
            self.mDanhSachSoLuong = @[[NSString stringWithFormat:@"%@: %d", [@"job reg - quantity" localizableString], 1]/*,
                                      [NSString stringWithFormat:@"%@: %d", [@"job reg - quantity" localizableString], 2],
                                      [NSString stringWithFormat:@"%@: %d", [@"job reg - quantity" localizableString], 3]*/];
            break;
        case NHA_MANG_GMOBILE:
            self.mDanhSachLuaChonThanhToan = @[NAP_DI_DONG_TRA_TRUOC, NAP_THE_CAO];
            self.mDanhSachSoLuong = @[[NSString stringWithFormat:@"%@: %d", [@"job reg - quantity" localizableString], 1],
                                      [NSString stringWithFormat:@"%@: %d", [@"job reg - quantity" localizableString], 2],
                                      [NSString stringWithFormat:@"%@: %d", [@"job reg - quantity" localizableString], 3]];
            break;
        default:
            break;
    }
    self.mLuaChonThanhToan = 0;
    [self khoiTaoTheoLuaChonThanhToan];
}

- (void)khoiTaoTheoLuaChonThanhToan
{
    isCoDinh = NO;
    NSString *sKieuLuaChon = [self.mDanhSachLuaChonThanhToan objectAtIndexedSubscript:self.mLuaChonThanhToan];
    self.mtfLuaChon.text = sKieuLuaChon;
    self.soTienViettel.enabled = YES;
    [self.soTienViettel setPlaceholder:@"Số tiền (đ)"];
    self.soTienViettel.text = @"";
    [self khoiTaoTableViewTheoNhaMang];
    NSLog(@"%s : sKieuLuaChon : %@", __FUNCTION__, sKieuLuaChon);
    if([sKieuLuaChon isEqualToString:[@"thanh_toan_nap_di_dong_tra_truoc_mobi" localizableString]]
       || [sKieuLuaChon isEqualToString:[@"thanh_toan_nap_di_dong_tra_truoc_vina" localizableString]]
       || [sKieuLuaChon isEqualToString:[@"thanh_toan_nap_di_dong_tra_truoc_khac_vietna" localizableString]]
       || [sKieuLuaChon isEqualToString:[@"thanh_toan_nap_di_dong_tra_truoc_khac_gmobile" localizableString]])
    {
        self.mFuncID = FUNC_BILLING_CELLPHONE;
        [self khoiTaoGiaoDienTheoKieuNapDiDongTraTruoc];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([sKieuLuaChon isEqualToString:[@"thanh_toan_nap_di_dong_tra_truoc_mobi" localizableString]]) {
                self.mlblKhuyenMai.text = @"Khuyến mại: 4.9%";
            }
            else if ([sKieuLuaChon isEqualToString:[@"thanh_toan_nap_di_dong_tra_truoc_vina" localizableString]]) {
                self.mlblKhuyenMai.text = @"Khuyến mại: 4.8%";
            }
        });
    }
    else if([sKieuLuaChon isEqualToString:[@"thanh_toan_nap_di_dong_ngay_vang_vina" localizableString]]
            || [sKieuLuaChon isEqualToString:[@"thanh_toan_nap_di_dong_ngay_vang_mobi" localizableString]]
            || [sKieuLuaChon isEqualToString:[@"thanh_toan_viettel_thanh_toan_ngay_vang" localizableString]]){
        [self.soTienViettel setPlaceholder:@"Số tiền nạp tối đa"];
        self.mFuncID = FUNC_DAT_LICH_NAP_TIEN_DIEN_THOAI;
        [self khoiTaoGiaoDienDatNgayVang];
        self.mlblKhuyenMai.text = @"Khuyến mại 50%";
    }
    else if ([sKieuLuaChon isEqualToString:[@"thanh_toan_mua_the_cao_mobi" localizableString]]
             || [sKieuLuaChon isEqualToString:[@"thanh_toan_mua_the_cao_vina" localizableString]]
             || [sKieuLuaChon isEqualToString:[@"thanh_toan_mua_the_cao_khac_vietna" localizableString]]
             || [sKieuLuaChon isEqualToString:[@"thanh_toan_mua_the_cao_khac_gmobile" localizableString]]
             || [sKieuLuaChon isEqualToString:@"Thẻ cào Viettel"])
    {
        self.mFuncID = FUNC_BUY_CARD;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self khoiTaoGiaoDienTheoKieuNapTheCao];
        });
    }
    else if ([sKieuLuaChon isEqualToString:[@"thanh_toan_di_dong_tra_sau_mobi" localizableString]]
             || [sKieuLuaChon isEqualToString:[@"thanh_toan_di_dong_tra_sau_vina" localizableString]])
    {
        self.mFuncID = FUNC_BILLING_CELLPHONE;
        [self khoiTaoGiaoDienTheoKieuThanhToanDiDongTraSau];
    }
    else if ([sKieuLuaChon isEqualToString:[@"thanh_toan_viettel_thanh_toan_di_dong_hoac_dcom_tra_truoc" localizableString]]){
        self.mFuncID = FUNC_BILLING_CELLPHONE;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self khoiTaoGiaoDienViettelTraTruoc];
        });
    }
    else if([sKieuLuaChon isEqualToString:[@"thanh_toan_viettel_thanh_toan_di_dong_hoac_dcom_tra_sau" localizableString]]){
        self.mFuncID = FUNC_BILLING_CELLPHONE;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self khoiTaoGiaoDienViettelTraSau];
        });
    }
    else if ([sKieuLuaChon isEqualToString:[@"thanh_toan_di_dong_khac_dt_co_dinh_hn" localizableString]] || [sKieuLuaChon isEqualToString:[@"thanh_toan_di_dong_khac_dt_co_dinh_hcm" localizableString]] || [sKieuLuaChon isEqualToString:[@"thanh_toan_di_dong_khac_dt_co_dinh_hp" localizableString]]) {
        isCoDinh = YES;
        self.mFuncID = FUNC_BILLING_CELLPHONE;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self khoiTaoGiaoDienCoDinh];
        });
    }
//    [self dieuChinhViewMainVaNutVanTayTheoKichCoManHinh];
    self.mtfSoDienThoai.placeholder = [@"so_dien_thoai_dd" localizableString];
    self.mbtnTraCuu.titleLabel.text = [@"tra_cuu" localizableString];
    self.mbtnThucHien.titleLabel.text = [@"button_thuc_hien" localizableString];
    self.mtfSoDienThoai.inputAccessoryView = nil;
    mSoTienThanhToan = 0.0f;
    for(UIButton *button in _mbtnSoTien)
    {
        [self huyHienThiLuaChonButton:button];
        double fSoTienThanhToan = [[[button.titleLabel.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
        if(fSoTienThanhToan == 30000 && _mNhaMang == NHA_MANG_VIETNAMMOBILE && _mLuaChonThanhToan == 1)
        {
            button.enabled = NO;
        }
        else
        {
            button.enabled = YES;
        }
    }
    [self hienThiSoPhi];
    if ([sKieuLuaChon isEqualToString:@"ĐT cố định VNPT HN"] || [sKieuLuaChon isEqualToString:@"ĐT cố định VNPT HCM"] || [sKieuLuaChon isEqualToString:@"ĐT cố định VNPT HP"]) {
        [self.mlblKhuyenMai setText:[NSString stringWithFormat:@"%@: 0%%",[@"khuyen_mai" localizableString]]];
    }
    else
        [self hienThiKhuyenMai];
}

- (void)khoiTaoGiaoDienDatNgayVang{
    NSLog(@"%s ==========> START", __FUNCTION__);
    self.btnTraCuuTraSau.hidden = YES;
    self.mViewSoLuong.hidden = YES;
    self.soTienViettel.hidden = NO;
    self.edSoTienTraSauViettel.hidden = YES;
    self.mViewSoDienThoai_TraCuu.hidden = NO;
    self.mViewThoiGianConLai.hidden = NO;
    self.mViewNhapToken.hidden = NO;
    self.viewSoPhiVaKhuyenMai.hidden = NO;
    [self.mwvHienThiLuuY setHidden:NO];

    switch (self.mNhaMang) {
        case NHA_MANG_VIETTEL:
            [self.mwvHienThiLuuY loadHTMLString:infoViettel baseURL:nil];
            break;
        case NHA_MANG_VINA:
            [self.mwvHienThiLuuY loadHTMLString:infoVina baseURL:nil];
            break;
        case NHA_MANG_MOBI:
            [self.mwvHienThiLuuY loadHTMLString:infoMobi baseURL:nil];
            break;
        default:
            break;
    }
    for(UIButton *button in _mbtnSoTien)
    {
        button.hidden = YES;
    }
    CGRect rlblKhuyenMai = self.viewSoPhiVaKhuyenMai.frame;
    CGRect rectSoTien = self.soTienViettel.frame;
    CGRect rViewThoiGianConLai = self.mViewThoiGianConLai.frame;
    CGRect rViewNhapToken = self.mViewNhapToken.frame;
    CGRect rectQC = viewQC.frame;
//    CGFloat fKhoangCachDich = rlblKhuyenMai.origin.y -  rectSoTien.size.height;

    rectSoTien.origin.y = self.mViewSoDienThoai_TraCuu.frame.origin.y + self.mViewSoDienThoai_TraCuu.frame.size.height + 8;
    rlblKhuyenMai.origin.y = rectSoTien.origin.y + rectSoTien.size.height + 8;
    rViewThoiGianConLai.origin.y = rlblKhuyenMai.origin.y + rlblKhuyenMai.size.height + 8;
    rViewNhapToken.origin.y = rViewThoiGianConLai.origin.y + rViewThoiGianConLai.size.height + 8;
    self.viewSoPhiVaKhuyenMai.frame = rlblKhuyenMai;
    self.soTienViettel.frame = rectSoTien;
    self.mViewThoiGianConLai.frame = rViewThoiGianConLai;
    self.mViewNhapToken.frame = rViewNhapToken;

    rectQC.origin.y = rViewNhapToken.origin.y + rViewNhapToken.size.height + 10;
    viewQC.frame = rectQC;
    CGRect rectMain = self.mViewMain.frame;
    NSLog(@"%s - rectMain1 : %f", __FUNCTION__, rectMain.size.height);
//    rectMain.size.height = rectQC.origin.y + rectQC.size.height + 10;
//    if (rectMain.size.height < 530.0) {
//        rectMain.size.height = 530.0;
//    }
//    NSLog(@"%s - rectMain2 : %f", __FUNCTION__, rectMain.size.height);
    self.mViewMain.frame = rectMain;
    [self.mscrv setContentSize:CGSizeMake(_mscrv.frame.size.width, rectMain.origin.y + rectMain.size.height + 10)];
}

- (void)khoiTaoGiaoDienViettelTraTruoc{
    NSLog(@"%s - START!!!!!", __FUNCTION__);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.btnTraCuuTraSau.hidden = YES;
        self.mViewSoLuong.hidden = YES;
        self.soTienViettel.hidden = NO;
        self.edSoTienTraSauViettel.hidden = YES;

        self.mViewThoiGianConLai.hidden = NO;
        self.mViewNhapToken.hidden = NO;
        self.viewSoPhiVaKhuyenMai.hidden = NO;
        self.mViewSoDienThoai_TraCuu.hidden = NO;

        if (!self.mwvHienThiLuuY.hidden) {
            [self.mwvHienThiLuuY setHidden:YES];
        }
        for(UIButton *button in _mbtnSoTien)
        {
            button.hidden = YES;
        }

        CGRect rlblKhuyenMai = self.viewSoPhiVaKhuyenMai.frame;
        CGRect rectSoTien = self.soTienViettel.frame;

        rectSoTien.origin.y = self.mViewSoDienThoai_TraCuu.frame.origin.y + self.mViewSoDienThoai_TraCuu.frame.size.height + 8;
        self.soTienViettel.frame = rectSoTien;
        CGRect rViewThoiGianConLai = self.mViewThoiGianConLai.frame;
        CGRect rViewNhapToken = self.mViewNhapToken.frame;
        rlblKhuyenMai.origin.y = rectSoTien.origin.y + rectSoTien.size.height + 5;
        rViewThoiGianConLai.origin.y = rlblKhuyenMai.origin.y + rlblKhuyenMai.size.height + 5;
        rViewNhapToken.origin.y = rViewThoiGianConLai.origin.y + rViewThoiGianConLai.size.height + 5;
        self.viewSoPhiVaKhuyenMai.frame = rlblKhuyenMai;
        self.mViewThoiGianConLai.frame = rViewThoiGianConLai;
        self.mViewNhapToken.frame = rViewNhapToken;
        CGRect rectQC = viewQC.frame;
//        NSLog(@"%s - %d - rectQC1 : %f - %f", __FUNCTION__, __LINE__, rectQC.origin.y, rectQC.size.height);
        rectQC.origin.y = rViewNhapToken.origin.y + rViewNhapToken.size.height + 10;
//        NSLog(@"%s - %d - rectQC2 : %f - %f", __FUNCTION__, __LINE__,rectQC.origin.y, rectQC.size.height);
        viewQC.frame = rectQC;
        CGRect rectMain = self.mViewMain.frame;
        NSLog(@"%s - %d - rectMain1 : %f", __FUNCTION__, __LINE__, rectMain.size.height);
        rectMain.size.height = rectQC.origin.y + rectQC.size.height + 10;
        NSLog(@"%s - %d - rectMain1 : %f", __FUNCTION__, __LINE__, rectMain.size.height);
        if (rectMain.size.height > 500.0 && rectMain.size.height < 600.0) {
            rectMain.size.height = 500.0;
        }
        NSLog(@"%s - rectMain2 : %f", __FUNCTION__, rectMain.size.height);
        self.mViewMain.frame = rectMain;
        [self.mscrv setContentSize:CGSizeMake(_mscrv.frame.size.width, rectMain.origin.y + rectMain.size.height + 10)];
    });
}

- (void)khoiTaoGiaoDienViettelTraSau{
    if (!self.mwvHienThiLuuY.hidden) {
        [self.mwvHienThiLuuY setHidden:YES];
    }
    self.soTienViettel.text = @"";
    self.edSoTienTraSauViettel.hidden = NO;
    self.mViewSoTien.hidden = YES;
    self.edSoTienTraSauViettel.hidden = YES;
    self.soTienViettel.hidden = NO;
    self.viewSoPhiVaKhuyenMai.hidden = YES;
    self.mViewNhapToken.hidden = NO;
    self.mViewThoiGianConLai.hidden = NO;
    self.btnTraCuuTraSau.hidden = NO;
    CGRect rectBtnTraCuu = self.btnTraCuuTraSau.frame;
    CGRect rectSoTien = self.soTienViettel.frame;
    CGRect rViewThoiGianConLai = self.mViewThoiGianConLai.frame;
    CGRect rectToken = self.mViewNhapToken.frame;
    CGRect rViewMain = self.mViewMain.frame;
    CGRect rectQC = viewQC.frame;
    rectSoTien.origin.y = rectBtnTraCuu.origin.y + rectBtnTraCuu.size.height + 10;
    rViewThoiGianConLai.origin.y = rectSoTien.origin.y + rectSoTien.size.height + 5;
    rectToken.origin.y = rViewThoiGianConLai.origin.y + rViewThoiGianConLai.size.height + 5;
    self.soTienViettel.frame = rectSoTien;
    self.mViewThoiGianConLai.frame = rViewThoiGianConLai;
    self.mViewNhapToken.frame = rectToken;
    rectQC.origin.y = rectToken.origin.y + rectToken.size.height + 10;
    rViewMain.size.height = rectQC.origin.y + rectQC.size.height + 10;
    viewQC.frame = rectQC;
    self.mViewMain.frame = rViewMain;
    [self.mscrv setContentSize:CGSizeMake(_mscrv.frame.size.width, rViewMain.origin.y + rViewMain.size.height + 10)];
}

- (void)khoiTaoGiaoDienCoDinh {
    self.mViewSoLuong_Phi.hidden = YES;
    self.mViewSoDienThoai_TraCuu.hidden = NO;
    self.edSoTienTraSauViettel.hidden = NO;
    self.mViewSoTien.hidden = YES;
    self.soTienViettel.hidden = YES;
    self.viewSoPhiVaKhuyenMai.hidden = YES;
    self.mViewNhapToken.hidden = YES;
    self.mViewThoiGianConLai.hidden = YES;
    CGRect rViewMain = self.mViewMain.frame;
    CGRect rectQC = viewQC.frame;
    rectQC.origin.y = self.edSoTienTraSauViettel.frame.origin.y + self.edSoTienTraSauViettel.frame.size.height + 10;
    rViewMain.size.height = rectQC.origin.y + rectQC.size.height + 20;
    viewQC.frame = rectQC;
    self.mViewMain.frame = rViewMain;
    [self.mscrv setContentSize:CGSizeMake(_mscrv.frame.size.width, viewQC.frame.origin.y + viewQC.frame.size.height + 10)];
//    rViewMain.size.height = self.btnTraCuuViettel.frame.origin.y + self.btnTraCuuViettel.frame.size.height + 75;
//    self.mViewMain.frame = rViewMain;
}

- (void)khoiTaoGiaoDienTheoKieuNapDiDongTraTruoc
{
    dispatch_async(dispatch_get_main_queue(), ^{
        for(UIButton *button in _mbtnSoTien)
        {
            button.hidden = NO;
        }
        self.btnTraCuuTraSau.hidden = YES;
        self.soTienViettel.hidden = YES;
        self.edSoTienTraSauViettel.hidden = YES;
        [self.mwvHienThiLuuY setHidden:YES];
        self.mViewSoDienThoai_TraCuu.hidden = NO;
        self.mViewSoTien.hidden = NO;
        self.mViewThoiGianConLai.hidden = NO;
        self.mViewNhapToken.hidden = NO;
        self.viewSoPhiVaKhuyenMai.hidden = NO;
        //Chinh lai view tong
        CGRect rViewMain = self.mViewMain.frame;
        CGRect rViewSoDienThoai_TraCuu = self.mViewSoDienThoai_TraCuu.frame;
        CGRect rViewSoTien = self.mViewSoTien.frame;
        CGRect rlblKhuyenMai = self.viewSoPhiVaKhuyenMai.frame;
        CGRect rViewThoiGianConLai = self.mViewThoiGianConLai.frame;
        CGRect rViewNhapToken = self.mViewNhapToken.frame;
        CGRect rectQC = viewQC.frame;

        rViewSoTien.origin.y = rViewSoDienThoai_TraCuu.origin.y + rViewSoDienThoai_TraCuu.size.height + KHOANG_CACH_GIUA_2_CONTROL;
        rlblKhuyenMai.origin.y = rViewSoTien.origin.y + rViewSoTien.size.height + KHOANG_CACH_GIUA_2_CONTROL;
        rViewThoiGianConLai.origin.y = rlblKhuyenMai.origin.y + rlblKhuyenMai.size.height + KHOANG_CACH_GIUA_2_CONTROL;
        rViewNhapToken.origin.y = rViewThoiGianConLai.origin.y + rViewThoiGianConLai.size.height + KHOANG_CACH_GIUA_2_CONTROL;
        rectQC.origin.y = rViewNhapToken.origin.y + rViewNhapToken.size.height + 10;
        NSLog(@"%s - %d : rViewMain.size.height : %f - %f - %f - %f", __FUNCTION__, __LINE__, rectQC.origin.x, rectQC.origin.y, rectQC.size.width, rectQC.size.height);
        rViewMain.size.height = rectQC.origin.y + rectQC.size.height + 10;
        NSLog(@"%s - %d : rViewMain.size.height : %f", __FUNCTION__, __LINE__, rViewMain.size.height);
        if (rViewMain.size.height < 550.0) {
            rViewMain.size.height = 550.0;
        } else {
            rViewMain.size.height = 550.0;
        }
        self.mViewSoTien.frame = rViewSoTien;
        self.viewSoPhiVaKhuyenMai.frame = rlblKhuyenMai;
        self.mViewThoiGianConLai.frame = rViewThoiGianConLai;
        self.mViewNhapToken.frame = rViewNhapToken;
        viewQC.frame = rectQC;
        self.mViewMain.frame = rViewMain;

        [self.mtfSoDienThoai setTextError:[@"so_dien_thoai_khong_dc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
        [self.mscrv setContentSize:CGSizeMake(_mscrv.frame.size.width, rectQC.origin.y + rectQC.size.height + 10)];
    });
}

- (void)khoiTaoGiaoDienTheoKieuThanhToanDiDongTraSau
{
    NSLog(@"%s - START", __FUNCTION__);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.soTienViettel.text = @"";
        if(self.mNhaMang != NHA_MANG_VINA)
        {
            [self.mwvHienThiLuuY setHidden:YES];
        }
        else
        {
            [self.mwvHienThiLuuY setHidden:NO];
        }
        self.viewSoPhiVaKhuyenMai.hidden = YES;
        self.mViewSoLuong.hidden = YES;
        self.mwvHienThiLuuY.hidden = YES;
        self.btnTraCuuTraSau.hidden = NO;
        self.soTienViettel.hidden = NO;
        self.mViewSoDienThoai_TraCuu.hidden = NO;

        for(UIButton *button in _mbtnSoTien)
        {
            button.hidden = NO;
        }
        //Chinh lai view tong
        CGRect rViewMain = self.mViewMain.frame;
        CGRect rViewSoDienThoai_TraCuu = self.mViewSoDienThoai_TraCuu.frame;
        CGRect rViewSoTien = self.mViewSoTien.frame;
        CGRect rViewSoLuong_Phi = self.mViewSoLuong_Phi.frame;
//        CGRect rlblKhuyenMai = self.viewSoPhiVaKhuyenMai.frame;
        CGRect rViewThoiGianConLai = self.mViewThoiGianConLai.frame;
        CGRect rViewNhapToken = self.mViewNhapToken.frame;
        CGRect rWebviewHienThiLuuY = self.mwvHienThiLuuY.frame;
        CGRect rectSoTien = self.soTienViettel.frame;
        CGRect rectBtnTraCuu = self.btnTraCuuTraSau.frame;
        CGRect rectQC = viewQC.frame;

        rectSoTien.origin.y = rectBtnTraCuu.origin.y + rectBtnTraCuu.size.height + 8;
        rViewSoTien.origin.y = rectSoTien.origin.y + rectSoTien.size.height + 8;
//        rlblKhuyenMai.origin.y = rViewSoTien.origin.y + rViewSoTien.size.height + 8;
        rViewThoiGianConLai.origin.y = rViewSoTien.origin.y + rViewSoTien.size.height + 8;
        rViewNhapToken.origin.y = rViewThoiGianConLai.origin.y + rViewThoiGianConLai.size.height + 8;
        rectQC.origin.y = rViewNhapToken.origin.y + rViewNhapToken.size.height + 10;
        rViewMain.size.height = rectQC.origin.y + rectQC.size.height + 20;
        NSLog(@"%s - rViewMain.size.height : %f", __FUNCTION__, rViewMain.size.height);
        if (rViewMain.size.height <= 570.0) {
            rViewMain.size.height = rectQC.origin.y + rectQC.size.height + 80;
        }
        viewQC.frame = rectQC;
        self.mViewMain.frame = rViewMain;
        self.mViewSoTien.frame = rViewSoTien;
//        self.viewSoPhiVaKhuyenMai.frame = rlblKhuyenMai;
        self.mViewThoiGianConLai.frame = rViewThoiGianConLai;
        self.mViewNhapToken.frame = rViewNhapToken;
        self.soTienViettel.frame = rectSoTien;
        [self.mscrv setContentSize:CGSizeMake(_mscrv.frame.size.width, viewQC.frame.origin.y + viewQC.frame.size.height + 70)];
    });
}

- (void)khoiTaoGiaoDienTheoKieuNapTheCao
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.btnTraCuuTraSau.hidden = YES;
        self.edSoTienTraSauViettel.hidden = YES;
        [self.mwvHienThiLuuY setHidden:YES];
        self.mViewSoDienThoai_TraCuu.hidden = YES;
        self.soTienViettel.hidden = YES;

        self.mViewSoLuong.hidden = NO;
        self.viewSoPhiVaKhuyenMai.hidden = NO;
        self.mViewNhapToken.hidden = NO;
        self.mViewThoiGianConLai.hidden = NO;
        self.mViewSoLuong_Phi.hidden = NO;
        self.mViewSoTien.hidden = NO;

        for(UIButton *button in _mbtnSoTien)
        {
            button.hidden = NO;
        }
        //Chinh lai view tong
        CGRect rViewMain = self.mViewMain.frame;
        CGRect rViewSoDienThoai_TraCuu = self.mViewSoDienThoai_TraCuu.frame;
        CGRect rViewSoTien = self.mViewSoTien.frame;
        CGRect rViewSoLuong_Phi = self.mViewSoLuong_Phi.frame;
        CGRect rlblKhuyenMai = self.viewSoPhiVaKhuyenMai.frame;
        CGRect rViewThoiGianConLai = self.mViewThoiGianConLai.frame;
        CGRect rViewNhapToken = self.mViewNhapToken.frame;
        CGRect rtbSoLuong = self.mtbSoLuong.frame;
        CGRect rectQC = viewQC.frame;
        rViewSoTien.origin.y = self.mViewLuaChon.frame.origin.y + self.mViewLuaChon.frame.size.height + KHOANG_CACH_GIUA_2_CONTROL;
        NSLog(@"%s - rViewSoTien.origin.y : %f", __FUNCTION__, rViewSoTien.origin.y);
        rViewSoLuong_Phi.origin.y = rViewSoTien.origin.y + rViewSoTien.size.height + KHOANG_CACH_GIUA_2_CONTROL;
        rtbSoLuong.origin.y = rViewSoLuong_Phi.origin.y + rViewSoLuong_Phi.size.height;
        rlblKhuyenMai.origin.y = rViewSoLuong_Phi.origin.y + rViewSoLuong_Phi.size.height + KHOANG_CACH_GIUA_2_CONTROL;
        rViewThoiGianConLai.origin.y = rlblKhuyenMai.origin.y + rlblKhuyenMai.size.height + KHOANG_CACH_GIUA_2_CONTROL;
        rViewNhapToken.origin.y = rViewThoiGianConLai.origin.y + rViewThoiGianConLai.size.height + KHOANG_CACH_GIUA_2_CONTROL;
        rectQC.origin.y = rViewNhapToken.origin.y + rViewNhapToken.size.height + 10;
        rViewMain.size.height = rectQC.origin.y + rectQC.size.height + 20;
        rViewMain.size.width = self.mscrv.frame.size.width - 20.0f;

        viewQC.frame = rectQC;
        self.mViewMain.frame = rViewMain;
        self.mViewSoDienThoai_TraCuu.frame = rViewSoDienThoai_TraCuu;
        self.mViewSoTien.frame = rViewSoTien;
        self.mViewSoLuong_Phi.frame = rViewSoLuong_Phi;
        self.viewSoPhiVaKhuyenMai.frame = rlblKhuyenMai;
        self.mViewThoiGianConLai.frame = rViewThoiGianConLai;
        self.mViewNhapToken.frame = rViewNhapToken;
        self.mtbSoLuong.frame = rtbSoLuong;
        [self.mscrv setContentSize:CGSizeMake(_mscrv.frame.size.width, viewQC.frame.origin.y + viewQC.frame.size.height + 80)];

        self.mViewSoLuong.hidden = NO;
        self.mtfSoDienThoai.checkEmpty = NO;
        mViTriChonSoLuongTheCao = 0;
        self.mtfSoLuong.text = [self.mDanhSachSoLuong objectAtIndex:mViTriChonSoLuongTheCao];
    });
}

- (void)khoiTaoTableViewTheoNhaMang
{
    NSLog(@"%s - START", __FUNCTION__);
//    self.mtbHienThiLuaChon.layer.borderColor = [UIColor blackColor].CGColor;
//    self.mtbHienThiLuaChon.layer.borderWidth = 1.0f;
//
    self.mtbSoLuong.layer.borderColor = [UIColor blackColor].CGColor;
    self.mtbSoLuong.layer.borderWidth = 1.0f;
    
    CGRect rtbHienThiLuaChon = self.mtbHienThiLuaChon.frame;
    rtbHienThiLuaChon.size.height = self.mDanhSachLuaChonThanhToan.count * 44;

    if (self.mDanhSachLuaChonThanhToan.count >= 6) {
        rtbHienThiLuaChon.size.height = (self.mDanhSachLuaChonThanhToan.count - 3) * 44;
//        if (self.mNhaMang == NHA_MANG_VIETTEL) {
//            rtbHienThiLuaChon.size.height = (self.mDanhSachLuaChonThanhToan.count - 3) * 44;
//        }
//        else
//            rtbHienThiLuaChon.size.height = self.mDanhSachLuaChonThanhToan.count * 44;
    }
    self.mtbHienThiLuaChon.frame = rtbHienThiLuaChon;
    [self.mtbHienThiLuaChon reloadData];
    
    CGRect rtbSoLuong = self.mtbSoLuong.frame;
    rtbSoLuong.size.height = self.mDanhSachSoLuong.count * 44;
    self.mtbSoLuong.frame = rtbSoLuong;
    [self.mtbSoLuong reloadData];
}

- (void)dieuChinhViewMainVaNutVanTayTheoKichCoManHinh
{
    CGRect rViewMain = self.mViewMain.frame;
    rViewMain = CGRectMake(10.0f, 10.0f, rViewMain.size.width, rViewMain.size.height);
    CGRect rButtonVanTay = self.mbtnVanTay.frame;
    
    if(self.mbtnVanTay.isHidden)
    {
        rViewMain = CGRectMake(10.0f, 10.0f, rViewMain.size.width, rViewMain.size.height);
        self.mscrv.contentSize = CGSizeMake(self.mscrv.frame.size.width, rViewMain.size.height + 2 * rViewMain.origin.y);
    }
    else
    {
        float height = rViewMain.origin.y + rViewMain.size.height + 20.0f + rButtonVanTay.size.height + 10.0f;
        if(self.mscrv.frame.size.height - height > 10.0f)
        {
            float fToaDoYVanTay = self.mscrv.frame.size.height - 10.0f - rButtonVanTay.size.height;
            rButtonVanTay = CGRectMake(rButtonVanTay.origin.x, fToaDoYVanTay, rButtonVanTay.size.width, rButtonVanTay.size.height);
        }
        else
        {
            float fToaDoYVanTay = rViewMain.origin.y + rViewMain.size.height + 20.0f ;
            rButtonVanTay = CGRectMake(rButtonVanTay.origin.x, fToaDoYVanTay, rButtonVanTay.size.width, rButtonVanTay.size.height);
        }
        self.mscrv.contentSize = CGSizeMake(self.mscrv.frame.size.width, rButtonVanTay.origin.y + rButtonVanTay.size.height + 25.0f);
    }
    
    self.mViewMain.frame = rViewMain;
    self.mbtnVanTay.frame = rButtonVanTay;
}

- (void)ketNoiLayThongTinNgayVang:(int)nNhaMang{
    if (nNhaMang == NHA_MANG_VIETTEL) {
        self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_LAY_THONG_TIN_NGAY_VANG_VIETTEL;
    }
    else if (nNhaMang == NHA_MANG_VINA){
        self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_LAY_THONG_TIN_NGAY_VANG_VINA;
    }
    else if (nNhaMang == NHA_MANG_MOBI){
        self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_LAY_THONG_TIN_NGAY_VANG_MOBI;
    }
    [GiaoDichMang ketNoiLayThongTinNgayVang:nNhaMang noiNhanKetQua:self];
}

#pragma mark - overriden

- (BOOL)validateVanTay
{
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return NO;
    }
    if ([_mtfLuaChon.text isEqualToString:[@"thanh_toan_viettel_thanh_toan_di_dong_hoac_dcom_tra_truoc" localizableString]]) {
        if (self.soTienViettel.text.length == 0) {
            [self.soTienViettel show_error];
            return NO;
        }
        if (self.mtfSoDienThoai.text.length == 0) {
            [self.mtfSoDienThoai show_error];
            return NO;
        }
        else{
            NSString *sSoDienThoai = [_mtfSoDienThoai.text stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [_mtfSoDienThoai.text length])];
            if (![Common kiemTralaSoDienThoaiViettel:sSoDienThoai]) {
                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:[NSString stringWithFormat:@"%@ %@",[@"qrcode_phone_empty" localizableString], [@"title_viettel" localizableString]]];
                return NO;
            }
        }
        return YES;
    }
    else if([_mtfLuaChon.text isEqualToString:[@"thanh_toan_mua_the_cao_mobi" localizableString]]
            || [_mtfLuaChon.text isEqualToString:[@"thanh_toan_mua_the_cao_vina" localizableString]]
            || [_mtfLuaChon.text isEqualToString:[@"thanh_toan_mua_the_cao_khac_vietna" localizableString]]
            || [_mtfLuaChon.text isEqualToString:[@"thanh_toan_mua_the_cao_khac_gmobile" localizableString]]
            || [_mtfLuaChon.text isEqualToString:@"Thẻ cào Viettel"]){
        NSLog(@"%s - mSoTienThanhToan : %f", __FUNCTION__, mSoTienThanhToan);
        if (mSoTienThanhToan == 0) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng chọn mệnh giá thẻ"];
            return NO;
        }
        else{
            return YES;
        }
    }
    else if ([_mtfLuaChon.text isEqualToString:[@"thanh_toan_nap_di_dong_ngay_vang_vina" localizableString]]
             || [_mtfLuaChon.text isEqualToString:[@"thanh_toan_nap_di_dong_ngay_vang_mobi" localizableString]]
             || [_mtfLuaChon.text isEqualToString:[@"thanh_toan_viettel_thanh_toan_ngay_vang" localizableString]]){
        BOOL flg = YES;
        if (self.soTienViettel.text.length == 0) {
            [self.soTienViettel show_error];
            return NO;
        }
        else{
            if ([self.mThongTinTaiKhoanVi.nAmount doubleValue] < 20000 && ([self.mThongTinTaiKhoanVi.nPromotionTotal doubleValue] < 50000 || [self.mThongTinTaiKhoanVi.nPromotionStatus intValue] == 0)){
                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Số dư trong Ví phải lớn hơn 20.000đ"];
                return NO;
            }
            BOOL bLoi = NO;
            NSString *sLoi = @"Số điện thoại nhập vào không thuộc danh sách đầu số của %@";
            NSString *sSoDienThoai = [_mtfSoDienThoai.text stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [_mtfSoDienThoai.text length])];
            if ([_mtfLuaChon.text isEqualToString:[@"thanh_toan_nap_di_dong_ngay_vang_vina" localizableString]]) {
                if (![Common kiemTralaSoDienThoaiVina:sSoDienThoai]) {
                    bLoi = YES;
                    sLoi = [NSString stringWithFormat:sLoi, @"Vinaphone."];
                }
            }
            else if ([_mtfLuaChon.text isEqualToString:[@"thanh_toan_nap_di_dong_ngay_vang_mobi" localizableString]]){
                if (![Common kiemTralaSoDienThoaiMobiphone:sSoDienThoai]) {
                    bLoi = YES;
                    sLoi = [NSString stringWithFormat:sLoi, @"Mobifone."];
                }
            }
            else if ([_mtfLuaChon.text isEqualToString:[@"thanh_toan_viettel_thanh_toan_ngay_vang" localizableString]]){
                if (![Common kiemTralaSoDienThoaiViettel:sSoDienThoai]) {
                    bLoi = YES;
                    sLoi = [NSString stringWithFormat:sLoi, @"Viettel."];
                }
            }
            if (bLoi) {
                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sLoi];
                return NO;
            }
            double fSoTien = [[[self.soTienViettel.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
            if (fSoTien < 20000) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:@"Số tiền phải lớn hơn hoặc bằng 20.000đ" delegate:nil cancelButtonTitle:@"Đóng" otherButtonTitles: nil];
                [alert show];
                [alert release];
                flg = NO;
            }
        }
        if (self.mtfSoDienThoai.text.length == 0) {
            [self.mtfSoDienThoai show_error];
            return NO;
        }
        return flg;
    }
    else{
        NSLog(@"%s ===================> line : %d - START", __FUNCTION__, __LINE__);
        NSArray *tfs = @[_mtfSoDienThoai];
        ExTextField *first = nil;
        BOOL flg = YES;
        for (ExTextField *tf in tfs)
        {
            flg = [tf validate] && flg;
            if (flg == NO && first == nil)
                first = tf;
        }
        if (first)
        {
            [first show_error];
            return flg;
        }
        
        if(mSoTienThanhToan == 0)
        {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:[@"thong_bao_chua_chon_menh_gia_the" localizableString]];
            return false;
        }
        //0186
//        NSString *sLuaChon = _mtfLuaChon.text;
        NSString *sSoDienThoai = [_mtfSoDienThoai.text stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [_mtfSoDienThoai.text length])];
        NSLog(@"%s - sSoDienThoai : %@ - nha mang : %ld", __FUNCTION__, sSoDienThoai, (long)self.mNhaMang);
//        if([sLuaChon isEqualToString:NAP_DI_DONG_TRA_TRUOC] || [sLuaChon isEqualToString:THANH_TOAN_DI_DONG_TRA_SAU])
//        {
            NSString *sCauThongBao = @"";
            switch (self.mNhaMang) {
                case NHA_MANG_MOBI:
                    if (sSoDienThoai.length > 0) {
                        sCauThongBao = [NSString stringWithFormat:@"%@ %@",@"Số điện thoại nhập vào không thuộc danh sách đầu số của ", [@"title_mobifone" localizableString]];
                    }
                    else
                        sCauThongBao = [NSString stringWithFormat:@"%@ %@", @"Số điện thoại nhập vào không thuộc danh sách đầu số của ", [@"title_mobifone" localizableString]];
                    flg = [Common kiemTralaSoDienThoaiMobiphone:sSoDienThoai];
                    break;
                case NHA_MANG_VINA:
                    if (sSoDienThoai.length > 0) {
                        sCauThongBao = [NSString stringWithFormat:@"%@ %@",@"Số điện thoại nhập vào không thuộc danh sách đầu số của ", [@"title_vinaphone" localizableString]];
                    }
                    else
                        sCauThongBao = [NSString stringWithFormat:@"%@ %@",[@"qrcode_phone_empty" localizableString], [@"title_vinaphone" localizableString]];
                    flg = [Common kiemTralaSoDienThoaiVina:sSoDienThoai];
                    break;
                case NHA_MANG_VIETNAMMOBILE:
                    if (sSoDienThoai.length > 0) {
                        sCauThongBao = [NSString stringWithFormat:@"%@ %@",@"Số điện thoại nhập vào không thuộc danh sách đầu số của ", [@"title_vietnamobile" localizableString]];
                    }
                    else
                        sCauThongBao = [NSString stringWithFormat:@"%@ %@",[@"qrcode_phone_empty" localizableString], [@"title_vietnamobile" localizableString]];
                    flg = [Common kiemTralaSoDienThoaiVietNamobile:sSoDienThoai];
                    break;
                case NHA_MANG_GMOBILE:
                    if (sSoDienThoai.length > 0) {
                        sCauThongBao = [NSString stringWithFormat:@"%@ %@",@"Số điện thoại nhập vào không thuộc danh sách đầu số của ", [@"title_gmobile" localizableString]];
                    }
                    else
                        sCauThongBao = [NSString stringWithFormat:@"%@ %@",[@"qrcode_phone_empty" localizableString], [@"title_gmobile" localizableString]];
                    flg = [Common kiemTralaSoDienThoaiGMobile:sSoDienThoai];
                    break;
                case NHA_MANG_VIETTEL:
                    if (sSoDienThoai.length > 0) {
                        sCauThongBao = [NSString stringWithFormat:@"%@ %@",@"Số điện thoại nhập vào không thuộc danh sách đầu số của ", [@"title_viettel" localizableString]];
                    }
                    else
                        sCauThongBao = [NSString stringWithFormat:@"%@ %@",[@"qrcode_phone_empty" localizableString], [@"title_viettel" localizableString]];
                    flg = [Common kiemTralaSoDienThoaiViettel:sSoDienThoai];
                    break;
                    break;
                default:
                    break;
            }
            if(!flg)
            {
                NSLog(@"%s - sCauThongBao : %@", __FUNCTION__, sCauThongBao);
                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sCauThongBao];
            }
        return flg;
    }
}

- (void)xuLyThucHienKhiKiemTraThanhCongTraVeToken:(NSString *)sToken otp:(NSString *)sOtp
{

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self hienThiLoading];
    }
    NSString *sLuaChonThanhToan = [self.mDanhSachLuaChonThanhToan objectAtIndex:self.mLuaChonThanhToan];
    NSLog(@"%s ===========> NAP_DI_DONG_TRA_TRUOC %@", __FUNCTION__, sLuaChonThanhToan);
    if(self.mFuncID == FUNC_BUY_CARD/*[sLuaChonThanhToan isEqualToString:NAP_THE_CAO]*/)
    {
        self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_MUA_THE_CAO;
        [GiaoDichMang ketNoiMuaTheCaoThuocNhaMang:self.mNhaMang
                                           soTien:mSoTienThanhToan
                                          soLuong:(int)(mViTriChonSoLuongTheCao + 1)
                                            token:sToken
                                              otp:sOtp
                                 typeAuthenticate:self.mTypeAuthenticate
                                    noiNhanKetQua:self];
    }
    else if(self.mFuncID == FUNC_BILLING_CELLPHONE/*[sLuaChonThanhToan isEqualToString:NAP_DI_DONG_TRA_TRUOC]*/)
    {
        if ([_mtfLuaChon.text isEqualToString:[@"thanh_toan_viettel_thanh_toan_di_dong_hoac_dcom_tra_truoc" localizableString]]
            || [_mtfLuaChon.text isEqualToString:[@"thanh_toan_viettel_thanh_toan_di_dong_hoac_dcom_tra_sau" localizableString]]
            || [_mtfLuaChon.text isEqualToString:[@"thanh_toan_viettel_thanh_toan_dien_thoai_co_dinh" localizableString]]
            || [_mtfLuaChon.text isEqualToString:[@"thanh_toan_viettel_thanh_toan_homephone" localizableString]]
            || [_mtfLuaChon.text isEqualToString:[@"thanh_toan_viettel_thanh_toan_truyen_hinh_va_internet" localizableString]])
        {
            double fSoTien = [[[self.soTienViettel.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
            self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_THANH_TOAN_CUOC;
            NSString *sText = self.mtfLuaChon.text;
            int nIndex = (int)[_mDanhSachLuaChonThanhToan indexOfObject:sText];
            NSString *sSoDienThoai = _mtfSoDienThoai.text;
            switch (nIndex) {
                case 0:
                case 1:
                    sSoDienThoai = [sSoDienThoai stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [_mtfSoDienThoai.text length])];
                default:
                    break;
            }
            int nKieuThanhToan = TRA_TRUOC;
            if ([_mtfLuaChon.text isEqualToString:[@"thanh_toan_viettel_thanh_toan_dien_thoai_co_dinh" localizableString]]
                || [_mtfLuaChon.text isEqualToString:[@"thanh_toan_viettel_thanh_toan_homephone" localizableString]]
                || [_mtfLuaChon.text isEqualToString:[@"thanh_toan_viettel_thanh_toan_truyen_hinh_va_internet" localizableString]]) {
                nKieuThanhToan = TRA_SAU_HOAC_TRA_TRUOC_VIETNAMMOBILE_GMOBILE;
            }
            [GiaoDichMang ketNoiThanhToanCuocDienThoaiChoSo:sSoDienThoai maNhaMang:NHA_MANG_VIETTEL kieuThanhToan:(int)nKieuThanhToan soTien:fSoTien token:sToken otp:sOtp typeAuthenticate:self.mTypeAuthenticate noiNhanKetQua:self];
        }else{
            self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_THANH_TOAN_CUOC;
            int nKieuThanhToan = TRA_TRUOC;
            NSString *sSoDienThoai = [_mtfSoDienThoai.text stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [_mtfSoDienThoai.text length])];
            if(self.mNhaMang == NHA_MANG_GMOBILE || self.mNhaMang == NHA_MANG_VIETNAMMOBILE
               || [_mtfLuaChon.text isEqualToString:[@"thanh_toan_di_dong_tra_sau_mobi" localizableString]]
               || [_mtfLuaChon.text isEqualToString:[@"thanh_toan_di_dong_tra_sau_vina" localizableString]])
            {
                nKieuThanhToan = TRA_SAU_HOAC_TRA_TRUOC_VIETNAMMOBILE_GMOBILE;
            }

            NSLog(@"%s - sSoDienThoai : %@", __FUNCTION__, sSoDienThoai);
            NSLog(@"%s - mNhaMang : %ld", __FUNCTION__, (long)self.mNhaMang);
            NSLog(@"%s - nKieuThanhToan : %ld", __FUNCTION__, (long)nKieuThanhToan);
            if (self.soTienViettel.text.length > 0) {
                mSoTienThanhToan = [[[self.soTienViettel.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
            }
            [GiaoDichMang ketNoiThanhToanCuocDienThoaiChoSo:sSoDienThoai maNhaMang:self.mNhaMang kieuThanhToan:nKieuThanhToan soTien:mSoTienThanhToan token:sToken otp:sOtp typeAuthenticate:self.mTypeAuthenticate noiNhanKetQua:self];
        }
    }
    else if([_mtfLuaChon.text isEqualToString:[@"thanh_toan_nap_di_dong_ngay_vang_vina" localizableString]]
            || [_mtfLuaChon.text isEqualToString:[@"thanh_toan_nap_di_dong_ngay_vang_mobi" localizableString]]
            || [_mtfLuaChon.text isEqualToString:[@"thanh_toan_viettel_thanh_toan_ngay_vang" localizableString]])
    {
        self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_THANH_TOAN_CUOC;

        double fSoTien = [[[self.soTienViettel.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];

        [GiaoDichMang ketNoiThanhToanNgayVangDienThoaiChoSo:self.mtfSoDienThoai.text maNhaMang:self.mNhaMang kieuThanhToan:TRA_TRUOC soTien:fSoTien token:sToken otp:sOtp typeAuthenticate:self.mTypeAuthenticate noiNhanKetQua:self];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:@"Hình thức thanh toán đang được phát triển" delegate:nil cancelButtonTitle:@"Đóng" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
}

- (void)xuLyKetNoiThanhCong:(NSString*)sDinhDanhKetNoi thongBao:(NSString*)sThongBao ketQua:(id)ketQua
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self anLoading];
    }
    if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_TRA_CUU_THANH_TOAN_DIEN_THOAI_VIETTEL])
    {
        //Hien thi thong bao
        NSLog(@"%s - DINH_DANH_KET_NOI_TRA_CUU_THANH_TOAN_DIEN_THOAI_VIETTEL", __FUNCTION__);
        [self batDauDemThoiGian1];
    }
    else if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_LAY_THONG_TIN_NGAY_VANG_VIETTEL]){
        NSArray *dic = (NSArray *)ketQua;
        infoViettel = [[NSString alloc] initWithString:[self xuLyKetQuaThongTinNgayVang:dic nhaMang:@"Viettel"]];
        NSLog(@"%s - infoViettel : %@", __FUNCTION__, infoViettel);
    }
    else if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_LAY_THONG_TIN_NGAY_VANG_VINA]){
        NSArray *dic = (NSArray *)ketQua;
        infoVina = [[NSString alloc] initWithString:[self xuLyKetQuaThongTinNgayVang:dic nhaMang:@"Vinaphone"]];
//        NSLog(@"%s - infoVina : %@", __FUNCTION__, infoVina);
    }
    else if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_LAY_THONG_TIN_NGAY_VANG_MOBI]){
        NSArray *dic = (NSArray *)ketQua;
        infoMobi = [[NSString alloc] initWithString:[self xuLyKetQuaThongTinNgayVang:dic nhaMang:@"Mobifone"]];
//        NSLog(@"%s - infoMobi : %@", __FUNCTION__, infoMobi);
    }
    else if ([self.mDinhDanhKetNoi isEqualToString:@"TRA_CUU_DIEN_THOAI_TRA_SAU"]) {

    }
    else{
        [self hienThiHopThoaiMotNutBamKieu:HOP_THOAI_XAC_NHAN_CHUYEN_TIEN_THANH_CONG cauThongBao:sThongBao];
    }
}

- (NSString *)xuLyKetQuaThongTinNgayVang:(NSArray *)arrDic nhaMang:(NSString *)nhaMang{
    NSString *value = @"";
    value = [NSString stringWithFormat:@"Vimass tạm giữ 20.000 đ và tự động nạp đến số tiền tối đa vào ngày được khuyến mại 50%% gần nhất. Những ngày được KM 50%% gần đây của %@: ", nhaMang];
    for (int i = 0; i < arrDic.count; i++) {
        NSDictionary *dicTemp = [arrDic objectAtIndex:i];
        NSNumber* lTime = [dicTemp objectForKey:@"ngayBatDau"];
//        NSLog(@"%s - lTime : %lld", __FUNCTION__, [lTime longLongValue]);
        NSString *sTime1 = [Common convertLongToStringWithFormatter:[lTime longLongValue] formatter:@"dd/MM/yyyy"];

        NSNumber* lTime2 = [dicTemp objectForKey:@"ngayKetThuc"];
//        NSLog(@"%s - lTime2 : %lld", __FUNCTION__, lTime2);

        NSString *sTime2 = [Common convertLongToStringWithFormatter:[lTime2 longLongValue] formatter:@"dd/MM/yyyy"];

        NSString *sTime = @"";
        if (i == arrDic.count - 1) {
            sTime = [NSString stringWithFormat:@"<b>%@ - %@</b>", sTime1, sTime2];
        }
        else
            sTime = [NSString stringWithFormat:@"<b>%@ - %@</b>, ", sTime1, sTime2];
        value = [value stringByAppendingString:sTime];

    }
    return value;
}

- (void)xuLyKetNoiThatBai:(NSString*)sDinhDanhKetNoi thongBao:(NSString*)sThongBao ketQua:(id)ketQua
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self anLoading];
    }
    [super xuLyKetNoiThatBai:sDinhDanhKetNoi thongBao:sThongBao ketQua:ketQua];
}

- (void)batDauDemThoiGian1
{
    [self ketThucDemThoiGian1];
    mThoiGianDoi = 45;
    NSString *sCauThongBao = [NSString stringWithFormat:@"%@ %d s",[@"thong_bao_dang_tra_cuu_thong_tin_thanh_toan_viettel" localizableString], mThoiGianDoi];
    [self hienThiViewThongBao:sCauThongBao];
    self.mDoiTuongNotification = nil;
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
    if (!thongBaoViettel) {
        thongBaoViettel = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:sThongBao delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
    }
    if (!thongBaoViettel.visible) {
        [thongBaoViettel show];
    }
    thongBaoViettel.message = sThongBao;
}

- (void)anViewThongBao
{
    [self ketThucDemThoiGian1];
    if (thongBaoViettel) {
        [thongBaoViettel dismissWithClickedButtonIndex:0 animated:YES];
    }
}

#pragma mark - suKien

- (IBAction)suKienBamNutChonSoTien:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    if(btn.isSelected == NO)
    {
        if (!self.btnTraCuuTraSau.hidden) {
            self.soTienViettel.text = btn.titleLabel.text;
        }
        mSoTienThanhToan = [[[btn.titleLabel.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
        for(UIButton *button in _mbtnSoTien)
        {
            [self huyHienThiLuaChonButton:button];
        }
        [self hienThiLuaChonButton:btn];
        [self hienThiSoPhi];
        [self hienThiKhuyenMai];
    }
}

- (IBAction)suKienChonNhaMangViettel:(id)sender
{
    if (self.mNhaMang == NHA_MANG_VIETTEL) {
        return;
    }
    self.mDoiTuongNotification = nil;
    self.mDoiTuongThanhToanCuocDienThoaiViettel = nil;
    self.mtbHienThiLuaChon.hidden = YES;
    self.mNhaMang = NHA_MANG_VIETTEL;
    [self khoiTaoTheoNhaMang];
    [self doiTrangThaiButtonNhaMang];
}

- (IBAction)suKienChonNhaMangVina:(id)sender
{
    if (self.mNhaMang == NHA_MANG_VINA) {
        return;
    }
    self.mDoiTuongNotification = nil;
    self.mDoiTuongThanhToanCuocDienThoaiViettel = nil;
    self.mtbHienThiLuaChon.hidden = YES;
    self.mNhaMang = NHA_MANG_VINA;
    [self khoiTaoTheoNhaMang];
    [self doiTrangThaiButtonNhaMang];
}

- (IBAction)suKienChonNhaMangMobi:(id)sender
{
    if (self.mNhaMang == NHA_MANG_MOBI) {
        return;
    }
    self.mDoiTuongNotification = nil;
    self.mDoiTuongThanhToanCuocDienThoaiViettel = nil;
    self.mtbHienThiLuaChon.hidden = YES;
    self.mNhaMang = NHA_MANG_MOBI;
    [self khoiTaoTheoNhaMang];
    [self doiTrangThaiButtonNhaMang];
}

- (IBAction)suKienChonNhaMangKhac:(id)sender
{
    if (self.mNhaMang == NHA_MANG_VIETNAMMOBILE) {
        return;
    }
    self.mDoiTuongNotification = nil;
    self.mDoiTuongThanhToanCuocDienThoaiViettel = nil;
    CGRect rViewMain = self.mViewMain.frame;
    NSLog(@"%s - rViewMain : %f", __FUNCTION__, rViewMain.size.height);
    self.mtbHienThiLuaChon.hidden = YES;
    self.mNhaMang = NHA_MANG_VIETNAMMOBILE;
    [self khoiTaoTheoNhaMang];
    [self doiTrangThaiButtonNhaMang];
}

- (void)doiTrangThaiButtonNhaMang
{
    [self.btnViettel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnVina setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnMobi setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnKhac setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

    [self.btnViettel setBackgroundColor:[UIColor whiteColor]];
    [self.btnVina setBackgroundColor:[UIColor whiteColor]];
    [self.btnMobi setBackgroundColor:[UIColor whiteColor]];
    [self.btnKhac setBackgroundColor:[UIColor whiteColor]];

    switch (self.mNhaMang) {
        case NHA_MANG_VIETTEL:
            [self.btnViettel setBackgroundColor:[UIColor colorWithHexString:@"#015079"]];
            [self.btnViettel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        case NHA_MANG_VINA:
            [self.btnVina setBackgroundColor:[UIColor colorWithHexString:@"#015079"]];
            [self.btnVina setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        case NHA_MANG_MOBI:
            [self.btnMobi setBackgroundColor:[UIColor colorWithHexString:@"#015079"]];
            [self.btnMobi setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        case NHA_MANG_VIETNAMMOBILE: case NHA_MANG_GMOBILE:
            [self.btnKhac setBackgroundColor:[UIColor colorWithHexString:@"#015079"]];
            [self.btnKhac setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (IBAction)suKienBamNutChonKieuThanhToan:(id)sender
{
    if(self.mtbHienThiLuaChon.isHidden == YES)
    {
        [self hienThiLuaChonThanhToan];
    }
    else
    {
        [self anLuaChonThanhToan];
    }
}

- (IBAction)suKienBamNutChonSoLuong:(id)sender
{
    if(self.mtbSoLuong.isHidden == YES)
    {
        [self hienThiSoLuong];
    }
    else
    {
        [self anSoLuong];
    }
}

- (IBAction)suKienBamNutTraCuu:(id)sender
{
    ContactScreen *danhBa = [[[ContactScreen alloc] initWithNibName:@"ContactScreen" bundle:nil] autorelease];
    danhBa.mKieuHienThiLienHe = KIEU_HIEN_THI_LIEN_HE_THUONG;
    [self.navigationController pushViewController:danhBa animated:YES];
    __block ThanhToanDienThoaiKhacViewController *weakSelf = self;
    [danhBa selectContact:^(NSString *phone, Contact *contact)
     {
         if (phone != nil && phone.length > 0)
         {
             if([Common kiemTraLaMail:phone])
             {
                 weakSelf.mtfSoDienThoai.text = phone;
             }
             else
             {
                 weakSelf.mtfSoDienThoai.text = [phone stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [phone length])];
             }
         }
         [danhBa.navigationController popViewControllerAnimated:YES];
     }];
}

- (IBAction)suKienBamNutTraCuuViettel:(id)sender
{
    if (self.mtfSoDienThoai) {
        NSString *sSoDienThoai = [_mtfSoDienThoai.text stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [_mtfSoDienThoai.text length])];
        if (![Common kiemTralaSoDienThoaiViettel:sSoDienThoai]) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:[NSString stringWithFormat:@"%@ %@",[@"qrcode_phone_empty" localizableString], [@"title_viettel" localizableString]]];
            return;
        }
        if(![sSoDienThoai isEqualToString:self.mSoDienThoaiDangTraCuuTraSau] || mThoiGianDoi == 0)
        {
            if([Common kiemTralaSoDienThoaiViettel:sSoDienThoai])
            {
                NSLog(@"%s - tra cuu sdt : %@", __FUNCTION__, sSoDienThoai);
                self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_TRA_CUU_THANH_TOAN_DIEN_THOAI_VIETTEL;
                self.mSoDienThoaiDangTraCuuTraSau = sSoDienThoai;
                [GiaoDichMang ketNoiTraCuuThanhToanDienThoaiViettel:sSoDienThoai noiNhanKetQua:self];
            }
            else
            {
                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:[NSString stringWithFormat:@"%@ %@",[@"qrcode_phone_empty" localizableString], [@"title_viettel" localizableString]]];
            }
        }
        else
        {
            NSString *sCauThongBao = [NSString stringWithFormat:@"%@ %d s",[@"thong_bao_dang_tra_cuu_thong_tin_thanh_toan_viettel" localizableString], mThoiGianDoi];
            [self hienThiViewThongBao:sCauThongBao];
        }
    }
    else{
        [self.mtfSoDienThoai show_error];
    }
}

- (IBAction)suKienChonSoTay:(id)sender {
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return;
    }
    DucNT_DanhSachTaiKhoanThuongDungControllerViewController *vc = [[DucNT_DanhSachTaiKhoanThuongDungControllerViewController alloc] initWithType:12];
    [self.navigationController presentViewController:vc animated:YES completion:^{}];
    [vc release];
}

- (IBAction)suKienBamNutTraCuuTraSau:(id)sender {
    [self.view resignFirstResponder];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self hienThiLoading];
    }
    self.mDinhDanhKetNoi = @"TRA_CUU_DIEN_THOAI_TRA_SAU";
//    [GiaoDichMang traCuuDienThoaiTraSau:@"" soDienThoai:@"01233336061" nhaMang:2 noiNhanKetQua:self];
    [GiaoDichMang traCuuDienThoaiTraSau:@"" soDienThoai:self.mtfSoDienThoai.text nhaMang:(int)_mNhaMang noiNhanKetQua:self];
    [self hienThiViewThongBaoTraSau];
    [self batDauDemThoiGian];
}
//01
#pragma mark - BaseScreen

-(void)didReceiveRemoteNotification:(NSDictionary *)Info
{
    NSLog(@"%s - START!!!!!", __FUNCTION__);
    [self anViewThongBaoHoaDonDienThoai];
    [self ketThucDemThoiGian];
    NSDictionary *userInfo = [Info valueForKey:@"userInfo"];
    if(userInfo)
    {
        DoiTuongNotification *doiTuongNotification = [[DoiTuongNotification alloc] initWithDict:userInfo];
        if ([doiTuongNotification.typeShow intValue] == 4) {
            NSString *sIdShow = doiTuongNotification.idShow;
            NSArray *arrTemp = [sIdShow componentsSeparatedByString:@"_"];
            if (arrTemp.count == 3) {
                NSString *soTien = [arrTemp lastObject];
                self.soTienViettel.text = [Common hienThiTienTeFromString:soTien];
            }
        }
//        if([doiTuongNotification.funcID intValue] == TYPE_SHOW_TRA_CUU_HOA_DON_DIEN && [doiTuongNotification. typeShow intValue] == KIEU_NOTIFICATION_TRA_CUU_HOA_DON_VIETTEL)
//        {
//            self.soTienViettel.enabled = NO;
//            self.mDoiTuongNotification = doiTuongNotification;
//            [doiTuongNotification release];
//            [self anViewThongBao];
//            [self hienThiThongTinThanhToan];
//        }
    }
}

- (void)hienThiThongTinThanhToan
{
    NSString *idShow = _mDoiTuongNotification.idShow;
    if(idShow && ![idShow isEqualToString:@""])
    {
        if([idShow rangeOfString:self.mSoDienThoaiDangTraCuuTraSau].location != NSNotFound)
        {
            [self anViewThongBao];
            [self ketThucDemThoiGian1];
            //            [self hienThiThongTinThanhToan];
            NSArray *arrTemp = [idShow componentsSeparatedByString:@"_"];
            @try {
                DoiTuongThanhToanCuocDienThoaiViettel *doiTuongThanhToanCuocDienThoaiViettel = [[DoiTuongThanhToanCuocDienThoaiViettel alloc] initWithMaGiaoDich:arrTemp[0] soDienThoai:arrTemp[1] tienCuocPhaiThanhToan:arrTemp[2]];
                self.mDoiTuongThanhToanCuocDienThoaiViettel = doiTuongThanhToanCuocDienThoaiViettel;
                [doiTuongThanhToanCuocDienThoaiViettel release];
                if([doiTuongThanhToanCuocDienThoaiViettel.tienCuocPhaiThanhToan doubleValue] > 0)
                {
                    [self khoiTaoGiaoDienDiDongVaDcomTraSau];
//                    [self capNhatThongTinTraSau];
                }
                else
                {
                    [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:_mDoiTuongNotification.alertContent];
                }
            }
            @catch (NSException *exception) {
                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:_mDoiTuongNotification.alertContent];
            }
            @finally {

            }
        }
        else if([_mDoiTuongNotification.alertContent rangeOfString:self.mSoDienThoaiDangTraCuuTraSau].location != NSNotFound)
        {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:_mDoiTuongNotification.alertContent];
        }
    }
}

- (void)khoiTaoGiaoDienDiDongVaDcomTraSau{
    if(_mDoiTuongThanhToanCuocDienThoaiViettel)
    {
        self.edSoTienTraSauViettel.hidden = YES;
        self.soTienViettel.hidden = NO;
        self.mViewThoiGianConLai.hidden = NO;
        self.mViewNhapToken.hidden = NO;
        CGRect rectMain = self.mViewMain.frame;
        rectMain.size.height = self.mViewNhapToken.frame.size.height + self.mViewNhapToken.frame.origin.y + 20;
        self.mViewMain.frame = rectMain;

        [_mtfSoDienThoai setText:_mDoiTuongThanhToanCuocDienThoaiViettel.soDienThoai];
        [_soTienViettel setText:[Common hienThiTienTeFromString:_mDoiTuongThanhToanCuocDienThoaiViettel.tienCuocPhaiThanhToan]];
        _soTienViettel.enabled = NO;
        [self hienThiSoPhi];
        NSString *sSoTienDuocKhuyenMai = @"";
        mSoTienThanhToan = [[[self.soTienViettel.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
        double fSoTienDuocKhuyenMai = (mSoTienThanhToan * 5)/100;
        NSString *sPhanTramKhuyenMai = @"3.5 %";
        if(fSoTienDuocKhuyenMai > 0)
        {
            sSoTienDuocKhuyenMai = [Common hienThiTienTe_1:fSoTienDuocKhuyenMai];
        }
        else
        {
            sSoTienDuocKhuyenMai = sPhanTramKhuyenMai;
        }
        [self.mlblKhuyenMai setText:[NSString stringWithFormat:@"%@: %@",[@"khuyen_mai" localizableString], sSoTienDuocKhuyenMai]];
        self.viewSoPhiVaKhuyenMai.hidden = NO;
    }
}

#pragma mark - xuLy


- (void)hienThiLuaChonButton:(UIButton*)btn
{
    [btn setSelected:YES];
    [btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
}

- (void)huyHienThiLuaChonButton:(UIButton*)btn
{
        [btn setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setSelected:NO];
}

- (void)hienThiSoPhi
{
    double fSoPhi = [Common layPhiChuyenTienCuaSoTien:mSoTienThanhToan kieuChuyenTien:KIEU_CHUYEN_TIEN_NAP_THE_DIEN_THOAI maNganHang:@""];
    self.mlblPhi.text = [NSString stringWithFormat:@"%@: %@",[@"so_phi" localizableString], [Common hienThiTienTe_1:fSoPhi]];
    
}

- (void)hienThiKhuyenMai
{
    NSString *sSoTienDuocKhuyenMai = @"";
    NSString *sPhanTramKhuyenMai = @"3.5 %";
    double fSoTienDuocKhuyenMai = (mSoTienThanhToan * 3.5f)/100;
    if(_mNhaMang == NHA_MANG_VIETNAMMOBILE)
    {
        fSoTienDuocKhuyenMai = (mSoTienThanhToan * 65/10)/100;
        sPhanTramKhuyenMai = @"6.5 %";
    }
    if (self.mFuncID == FUNC_DAT_LICH_NAP_TIEN_DIEN_THOAI) {
        fSoTienDuocKhuyenMai = (mSoTienThanhToan * 50)/100;
        sPhanTramKhuyenMai = @"50 %";
    }
    NSString *sLuaChonThanhToan = [self.mDanhSachLuaChonThanhToan objectAtIndex:self.mLuaChonThanhToan];
    if([sLuaChonThanhToan isEqualToString:NAP_THE_CAO])
    {
        fSoTienDuocKhuyenMai *= (mViTriChonSoLuongTheCao + 1);
    }
    else if([sLuaChonThanhToan isEqualToString:@"Thẻ cào Viettel"]) {
        fSoTienDuocKhuyenMai = (mSoTienThanhToan * 3.5f)/100;
    }
    if(fSoTienDuocKhuyenMai > 0)
    {
        sSoTienDuocKhuyenMai = [Common hienThiTienTe_1:fSoTienDuocKhuyenMai];
    }
    else
    {
        sSoTienDuocKhuyenMai = sPhanTramKhuyenMai;
    }
    [self.mlblKhuyenMai setText:[NSString stringWithFormat:@"%@: %@",[@"khuyen_mai" localizableString], sSoTienDuocKhuyenMai]];
    
}

- (void)hienThiLuaChonThanhToan
{
    if(self.mtbHienThiLuaChon.isHidden == YES)
    {
        self.mtbHienThiLuaChon.hidden = NO;
    }
}

- (void)anLuaChonThanhToan
{
    if(self.mtbHienThiLuaChon.isHidden == NO)
    {
        self.mtbHienThiLuaChon.hidden = YES;
    }
}

- (void)hienThiSoLuong
{
    if(self.mtbSoLuong.isHidden == YES)
    {
        self.mtbSoLuong.hidden = NO;
    }
}

- (void)anSoLuong
{
    if(self.mtbSoLuong.isHidden == NO)
    {
        self.mtbSoLuong.hidden = YES;
    }
}

#pragma mark - Xu ly tra cuu tra sau
- (void)hienThiViewThongBaoTraSau
{
    if(!_viewTimeTraCuuTraSau.superview)
    {
        _viewTimeTraCuuTraSau.frame = self.view.bounds;
        [self.view addSubview:_viewTimeTraCuuTraSau];
    }
    else
    {
        _viewTimeTraCuuTraSau.frame = self.view.bounds;
        [self.view bringSubviewToFront:_viewTimeTraCuuTraSau];
    }
    [self xuLyCoGianViewThongBaoTheoNoiDung];
    [_viewTimeTraCuuTraSau setHidden:NO];
}

- (void)xuLyCoGianViewThongBaoTheoNoiDung
{
//    NSString *sText = _tvTimeTraCuuTraSau.text;
//    CGSize textViewSize = [sText sizeWithFont:[UIFont systemFontOfSize:16.0f]
//                            constrainedToSize:CGSizeMake(_tvTimeTraCuuTraSau.frame.size.width, FLT_MAX)
//                                lineBreakMode:NSLineBreakByTruncatingTail];
//    float fMaxHeightViewThongBao = _mViewNenThongBao.frame.size.height - 40;
//    float fMinHeightViewThongBao = 150;
//
//
//    float fHeightViewThongBao = textViewSize.height + 20 + _mViewTieuDeThongBao.frame.size.height;
//    float fWithViewThongBao = _mViewChuaThongBao.frame.size.width;
//
//    if(fHeightViewThongBao > fMaxHeightViewThongBao)
//        fHeightViewThongBao = fMaxHeightViewThongBao;
//    else if (fHeightViewThongBao < fMinHeightViewThongBao)
//        fHeightViewThongBao = fMinHeightViewThongBao;
//
//    _tvTimeTraCuuTraSau.frame = CGRectMake(_tvTimeTraCuuTraSau.frame.origin.x, _tvTimeTraCuuTraSau.frame.origin.y, _tvTimeTraCuuTraSau.frame.size.width, textViewSize.height + 20);
//    _tvTimeTraCuuTraSau.frame = CGRectMake(0, 0, fWithViewThongBao, fHeightViewThongBao);
//    _tvTimeTraCuuTraSau.center = _mViewNenThongBao.center;
}

- (void)batDauDemThoiGian
{
    [self ketThucDemThoiGian];
    mThoiGianDoi = TIME_COUNT_DOWN_DIEN_THOAI;
    NSString *sCauThongBao = [NSString stringWithFormat:@"%@ %d s",@"Hệ thống đang tra cứu hoá đơn điện thoại. Vui lòng đợi sau:", mThoiGianDoi];
    [_tvTimeTraCuuTraSau setText:sCauThongBao];
    [self hienThiViewThongBaoTraSau];
    mTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(capNhatDemThoiGian) userInfo:nil repeats:YES];
}

- (void)ketThucDemThoiGian
{
    mThoiGianDoi = TIME_COUNT_DOWN_DIEN_THOAI;
    if(mTimer)
    {
        [mTimer invalidate];
        mTimer = nil;
    }
}

- (void)capNhatDemThoiGian
{
    mThoiGianDoi --;
    NSString *sCauThongBao = [NSString stringWithFormat:@"%@ %d s",@"Hệ thống đang tra cứu hoá đơn điện thoại. Vui lòng đợi sau:", mThoiGianDoi];
    [_tvTimeTraCuuTraSau setText:sCauThongBao];

    if(mThoiGianDoi > 0 && _mDoiTuongNotification)
    {
        [self ketThucDemThoiGian];
        [self anViewThongBaoHoaDonDienThoai];
//        [self xuLyChuyenViewThanhToan];

    }
    else if(mThoiGianDoi == 0 && !_mDoiTuongNotification)
    {
        [self anViewThongBaoHoaDonDienThoai];
        [self ketThucDemThoiGian];
    }
}

- (void)anViewThongBaoHoaDonDienThoai
{
    if(_viewTimeTraCuuTraSau.superview)
        _viewTimeTraCuuTraSau.hidden = YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.mtbHienThiLuaChon)
    {
        NSLog(@"%s - mDanhSachLuaChonThanhToan.count : %d", __FUNCTION__, (int)self.mDanhSachLuaChonThanhToan.count);
        return self.mDanhSachLuaChonThanhToan.count;
    }
    else if (tableView == self.mtbSoLuong)
    {
        return self.mDanhSachSoLuong.count;
    }
    return  0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.mtbSoLuong)
    {
        NSString *cellSoLuongIdentifier = @"cellSoLuongIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellSoLuongIdentifier];
        if(!cell)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellSoLuongIdentifier];
        cell.textLabel.text = [self.mDanhSachSoLuong objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
        return cell;
    }
    NSString *cellLuaChonIdentifier = @"cellLuaChonIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellLuaChonIdentifier];
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellLuaChonIdentifier];
    NSString *sLuaChon = [self.mDanhSachLuaChonThanhToan objectAtIndexedSubscript:indexPath.row];
    cell.textLabel.text = sLuaChon;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(tableView == self.mtbHienThiLuaChon)
    {
        NSLog(@"%s - tableView == self.mtbHienThiLuaChon", __FUNCTION__);
        self.mLuaChonThanhToan = indexPath.row;
        [self khoiTaoTheoLuaChonThanhToan];
        [self anLuaChonThanhToan];
    }
    else if(tableView == self.mtbSoLuong)
    {
        mViTriChonSoLuongTheCao = indexPath.row;
        self.mtfSoLuong.text = [self.mDanhSachSoLuong objectAtIndex:mViTriChonSoLuongTheCao];
        [self hienThiKhuyenMai];
        [self anSoLuong];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

#pragma mark - dealloc
- (void)dealloc {
    [viewQC release];
    [_mDanhSachSoLuong release];
    [_mDanhSachLuaChonThanhToan release];
    [_mbtnSoTien release];
    [_mtbHienThiLuaChon release];
    [_mtbSoLuong release];
    [_mViewSoTien release];
    [_mViewThoiGianConLai release];
    [_mlblKhuyenMai release];
    [_mViewSoLuong_Phi release];
    [_mtfSoLuong release];
    [_mbtnChonSoLuong release];
    [_mlblPhi release];
    [_mViewSoDienThoai_TraCuu release];
    [_mtfSoDienThoai release];
    [_mbtnTraCuu release];
    [_mtfLuaChon release];
    [_mViewSoLuong release];
//    [_mscrv release];
    [_mwvHienThiLuuY release];
    [_btnViettel release];
    [_btnVina release];
    [_btnMobi release];
    [_btnKhac release];
    [_viewSoPhiVaKhuyenMai release];
    [_soTienViettel release];
//    [_btnTraCuuViettel release];
    if (thongBaoViettel) {
        [thongBaoViettel release];
    }
    if (infoViettel) {
        [infoViettel release];
    }
    if (infoVina) {
        [infoVina release];
    }
    if (infoMobi) {
        [infoMobi release];
    }
    [_mViewLuaChon release];
    [_edSoTienTraSauViettel release];
    [_btnTraCuuTraSau release];
    [_viewTimeTraCuuTraSau release];
    [_tvTimeTraCuuTraSau release];
    [_mViewNenThongBao release];
    [_mViewTieuDeThongBao release];
    [_mViewChuaThongBao release];
    [super dealloc];
}

@end
