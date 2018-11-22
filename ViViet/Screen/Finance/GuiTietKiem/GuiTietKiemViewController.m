//
//  GuiTietKiemViewController.m
//  ViViMASS
//
//  Created by DucBui on 5/13/15.
//
//

#import "GuiTietKiemViewController.h"
#import "NganHangGuiTietKiem.h"
#import "TraCuuSoTietKiemView.h"
#import "ChiTietSoTietKiemViewController.h"
#import "BankCoreData.h"
#import "DucNT_TaiKhoanThuongDungObject.h"
#import "DanhSachTaiKhoanThuongDungViewController.h"
#import "DucNT_DanhSachTaiKhoanThuongDungControllerViewController.h"
#import "GiaoDienThongTinPhim.h"
#import "DucNT_LoginSceen.h"
#import "CommonUtils.h"

typedef enum : NSUInteger {
    TF_NHAN_GOC_VA_LAI = 1,
    TF_NGAN_HANG_GUI_TK = 2,
    TF_KY_HAN_GUI_TK = 3,
    TF_KY_LINH_LAI = 4,
    TF_CACH_THUC_QUAY_VONG = 5,
    TF_DANH_SACH_NGAN_HANG= 6,
} TAG_TF;

typedef enum : NSUInteger {
    MA_LAI_DAU_KY = 2,
    MA_LAI_HANG_THANG = 1,
    MA_LAI_HANG_QUY = 3,
    MA_LAI_6_THANG = 4,
    MA_LAI_HANG_NAM = 5,
    MA_LAI_CUOI_KY = 0,
} MA_LAI;

typedef enum : NSUInteger {
    KIEU_NHAN_TIEN_QUA_VI = 0,
    KIEU_NHAN_TIEN_QUA_TK = 1,
    KIEU_NHAN_TIEN_QUA_THE = 2,
    KIEU_NHAN_TIEN_TAI_QUAY = 3,
} KIEU_NHAN_TIEN;

@interface GuiTietKiemViewController () <UIPickerViewDataSource, UIPickerViewDelegate, TraCuuSoTietKiemViewDelegate>
{
    BOOL mFirst;
    int nKyHanRow;
    ViewQuangCao *viewQC;
}

@property (nonatomic, retain) TraCuuSoTietKiemView *mViewTraCuuSoTietKiem;
@property (nonatomic, retain) UIView *mViewLaiSuatTietKiem;
@property (nonatomic, assign) double mLaiSuatTheoKyLai;
//@property (nonatomic, retain) NSArray *mDanhSachLaiSuatCacNganHangTheoKiHan;
@property (nonatomic, retain) NSArray *mDanhSachNganHangGuiTietKiem;
@property (nonatomic, retain) NSArray *mDanhSachCachNhanGocVaLai;
@property (nonatomic, retain) NSArray *mDanhSachKyHanGui;
@property (nonatomic, retain) NSArray *mDanhSachKyLinhLai;
@property (nonatomic, retain) NSArray *mDanhSachCachThucQuayVong;
@property (nonatomic, retain) NSArray *mDanhSachNganHangRutTienVe;
@property (nonatomic, retain) Banks *mNganHangRutTienDuocChon;

@property (nonatomic, retain) DucNT_TaiKhoanThuongDungObject *mTaiKhoanThuongDung;

@property (nonatomic, retain) NganHangGuiTietKiem *mNganHangDuocChon;
@property (nonatomic, retain) KyHanNganHang *mKyHanDuocChon;
@property (nonatomic, retain) KyLaiNganHang *mKyLaiDuocChon;
@property (nonatomic, retain) CachQuayVongKyLai *mCachThucQuayVongDuocChon;
@end

@implementation GuiTietKiemViewController

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    nKyHanRow = 0;
    [self khoiTaoBanDau];
    [self xuLyHienThiSoPhi];
    
    UIView *viewLaiSuatTietKiem = [[UIView alloc] initWithFrame:_mScrvHienThi.frame];
    [viewLaiSuatTietKiem setBackgroundColor:[UIColor whiteColor]];
    TraCuuSoTietKiemView *viewTraCuuSoTietKiem = [[[NSBundle mainBundle] loadNibNamed:@"TraCuuSoTietKiemView" owner:self options:nil] objectAtIndex:0];
    viewTraCuuSoTietKiem.mDelegate = self;
    [viewTraCuuSoTietKiem setBackgroundColor:[UIColor whiteColor]];
    self.mViewLaiSuatTietKiem = viewLaiSuatTietKiem;
    self.mViewTraCuuSoTietKiem = viewTraCuuSoTietKiem;
    [self.view addSubview:viewTraCuuSoTietKiem];
    [self.view addSubview:viewLaiSuatTietKiem];
    [viewLaiSuatTietKiem release];
    [self suKienBamNutGuiTietKiem:_mbtnGuiTK];
    if (!_mtfKyHanGui.rightView) {
        UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 12)];
        [btnRight setBackgroundImage:[UIImage imageNamed:@"muiten35x21.png"] forState:UIControlStateNormal];
        _mtfKyHanGui.rightView = btnRight;
        _mtfKyHanGui.rightViewMode = UITextFieldViewModeAlways;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateThongTinGuiTietKiem:) name:KEY_TAI_KHOAN_THUONG_DUNG object:nil];
    [self khoiTaoGiaoDien];
}

- (void)khoiTaoQuangCao {
    if (!viewQC) {
        viewQC = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ViewQuangCao class]) owner:self options:nil] objectAtIndex:0];
        viewQC.mDelegate = self;
        CGRect rectToken = self.mViewNhapToken.frame;
        CGRect rectQC = viewQC.frame;
        CGRect rectMain = self.mViewMain.frame;
        CGFloat fW = rectMain.size.width;
        CGFloat fH = fW * 0.46;
        rectQC.origin.y = rectToken.origin.y + rectToken.size.height + 15;
        viewQC.frame = CGRectMake(0, rectQC.origin.y, fW, fH);
        viewQC.mDelegate = self;
        [viewQC updateSizeQuangCao];
        rectMain.size.height = rectQC.origin.y + rectQC.size.height;
        self.mViewMain.frame = rectMain;
        [self.mViewMain addSubview:viewQC];
        [self.mScrvHienThi setContentSize:CGSizeMake(_mScrvHienThi.frame.size.width, viewQC.frame.origin.y + viewQC.frame.size.height + self.viewOptionTop.frame.size.height + 30)];
    }
}

-(void)updateThongTinGuiTietKiem:(NSNotification *)notification
{
    if([[notification name] isEqualToString:KEY_TAI_KHOAN_THUONG_DUNG])
    {
        DucNT_TaiKhoanThuongDungObject *mTaiKhoanThuongDung = [notification object];
        if (_mDanhSachNganHangGuiTietKiem.count > 0) {
            int nDem = 0;
            for ( NganHangGuiTietKiem *nganHangGuiTietKiem in _mDanhSachNganHangGuiTietKiem) {
                if ([nganHangGuiTietKiem.bank hasPrefix:mTaiKhoanThuongDung.maNganHang]) {
                    [self xuLyChonNganHangGuiTietKiem:nDem];
                    break;
                }
                nDem ++;
            }
        }
        self.mtfSoTien.text = [Common hienThiTienTe:mTaiKhoanThuongDung.soTien];
        [self xuLyHienThiSoPhi];
        if (_mDanhSachKyHanGui.count > 0) {
            int nDem = 0;
            for (KyHanNganHang *kyHanNganHang in _mDanhSachKyHanGui) {
                NSLog(@"%s - kyHanNganHang.maKyHan : %@ - mTaiKhoanThuongDung.kyHan : %@", __FUNCTION__, kyHanNganHang.maKyHan, mTaiKhoanThuongDung.kyHan);
                if ([kyHanNganHang.maKyHan isEqualToString:mTaiKhoanThuongDung.kyHan]) {
                    _mtfKyHanGui.text = [NSString stringWithFormat:@"Kỳ hạn %@", kyHanNganHang.noiDung];
                    [self xuLyChonKyHanGui:nDem];
                    break;
                }
                nDem ++;
            }
        }
        [self xuLyHienThiKhiChonCachNhanTienGocVaLai:mTaiKhoanThuongDung.kieuNhanTien];
        NSLog(@"%s - mTaiKhoanThuongDung.kieuNhanTien : %d", __FUNCTION__, mTaiKhoanThuongDung.kieuNhanTien);
        if (mTaiKhoanThuongDung.kieuNhanTien == 2) {
            self.mtfSoThe.text = mTaiKhoanThuongDung.maATM;
        }
        else if (mTaiKhoanThuongDung.kieuNhanTien == 1) {
            for (int i = 0; i < _mDanhSachNganHangRutTienVe.count; i++) {
                Banks *bank = [_mDanhSachNganHangRutTienVe objectAtIndex:i];
                if ([bank.bank_sms isEqualToString:mTaiKhoanThuongDung.maNganHangNhanTien]) {
                    self.mtfNganHangRutTienVe.text = bank.bank_name;
                    break;
                }
            }
            self.mtfTenChuTaiKhoan.text = mTaiKhoanThuongDung.tenChuTaiKhoan;
            self.mtfSoTaiKhoanRutTienVe.text = mTaiKhoanThuongDung.soTaiKhoan;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    self.mViewTraCuuSoTietKiem.secssion = self.mThongTinTaiKhoanVi.secssion;
    [self khoiTaoGiaoDienKhuyenMaiVaSoDu];
    if(mFirst)
    {
        mFirst = NO;
        [self xuLyHienThiThongTinNguoiDungLanDauTien];
    }
    [self setAnimationChoSoTay:self.btnSoTayTkBank];
    [self setAnimationChoSoTay:self.btnSoTayThe];
    [self setAnimationChoSoTay:self.btnSoTay];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(![CommonUtils isEmptyOrNull:self.mThongTinTaiKhoanVi.pki3] && [self.mThongTinTaiKhoanVi.hanMucPki3 doubleValue] >0 ){
        self.mbtnPKI.hidden = NO;
    }
    else{
        self.mbtnPKI.hidden = YES;
    }
    [self khoiTaoQuangCao];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.btnSoTayTkBank.imageView stopAnimating];
    [self.btnSoTayThe.imageView stopAnimating];
    [self.btnSoTay.imageView stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - khoiTao

- (void)khoiTaoBanDau
{
    [self addButtonBack];
//    self.title = @"Gửi tiết kiệm";
    [self addTitleView:@"Gửi tiết kiệm"];
    mFirst = YES;
    self.mFuncID = FUNC_GUI_TIEN_TIET_KIEM;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateThongTin:) name:NOTIFICATION_LAY_TAI_KHOAN_THUONG_DUNG object:nil];
    [self khoiTaoDanhSachNganHangGuiTietKiem];
}

- (void)khoiTaoGiaoDien
{
    [self.viewOptionTop setHidden:YES];
    
    [_mtfSoTien setPlaceholder:[@"so_tien_dong" localizableString]];
    [_mtfSoTien setTextError:[@"so_tien_khong_duoc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    [_mtfSoTien setType:ExTextFieldTypeMoney];
    _mtfSoTien.inputAccessoryView = nil;
    
    [_mtfTenNguoiGui setPlaceholder:@"Tên người gửi"];
    [_mtfTenNguoiGui setTextError:@"Tên người gửi không được để trống" forType:ExTextFieldTypeEmpty];
    _mtfTenNguoiGui.inputAccessoryView = nil;
    
    [_mtfSoCMND setPlaceholder:@"Số CMND/HC/Mã DN"];
    [_mtfSoCMND setTextError:@"Số CMND/HC/Mã DN không được bỏ trống" forType:ExTextFieldTypeEmpty];
    _mtfSoCMND.inputAccessoryView = nil;
    
    [_mtfDiaChi setPlaceholder:[@"location form - address" localizableString]];
    _mtfSoCMND.inputAccessoryView = nil;
    
    [_mtfSoThe setTextError:[@"so_the_ngan_hang_khong_duoc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    _mtfSoThe.type = ExTextFieldTypeCardNumber;
    _mtfSoThe.inputAccessoryView = nil;
    
    _mtfSoThe.type = ExTextFieldTypeCardNumber;
    _mtfSoThe.inputAccessoryView = nil;
    
    [_mtfSoTaiKhoanRutTienVe setTextError:[@"so_tai_khoan_khong_dc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    _mtfSoTaiKhoanRutTienVe.type = ExTextFieldTypeBankNumber;
    _mtfSoTaiKhoanRutTienVe.inputAccessoryView = nil;

    [_mtfTenChuTaiKhoan setTextError:[@"ten_chu_tai_khoan_khong_duoc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    _mtfTenChuTaiKhoan.inputAccessoryView = nil;
    
    CGRect rViewMain = self.mViewMain.bounds;
    CGRect rButtonVanTay = self.mbtnVanTay.frame;
    float fHeight = 0;
    float fWidth = _mScrvHienThi.frame.size.width;
    rViewMain = CGRectMake(5, 5, _mScrvHienThi.frame.size.width - 10, rViewMain.size.height);
    fHeight = rViewMain.origin.y + rViewMain.size.height;
    
    if([self kiemTraCoChucNangQuetVanTay])
    {
        rButtonVanTay.origin.y = fHeight + 20;
        rButtonVanTay.origin.x = (fWidth - rButtonVanTay.size.width) / 2;
        fHeight = rButtonVanTay.origin.y + rButtonVanTay.size.height + 10;
    }
    else
    {
        fHeight += 10;
    }
    self.mViewMain.frame = rViewMain;
    self.mbtnVanTay.frame = rButtonVanTay;
    
    [_mScrvHienThi addSubview:self.mViewMain];
    [_mScrvHienThi addSubview:self.mbtnVanTay];
    [_mScrvHienThi bringSubviewToFront:self.mbtnVanTay];
    [_mScrvHienThi setContentSize:CGSizeMake(fWidth, fHeight)];
    
    [self khoiTaoCachNhanGocVaLai];
    [self khoiTaoNganHangGuiTietKiem];
    [self khoiTaoKyTinhLai];
    [self khoiTaoKyHanGuiTietKiem];
    [self khoiTaoCachThucQuayVong];
}

- (void)khoiTaoCachNhanGocVaLai
{
    NSString *sID = @"";
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sID = [DucNT_LuuRMS layThongTinDangNhap:KEY_DINH_DANH_DOANH_NGHIEP];
    }
    else if(nKieuDangNhap == KIEU_CA_NHAN)
    {
        sID = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    }
    self.mDanhSachCachNhanGocVaLai = @[
                                       [[NSString stringWithFormat:@"%@ %@",[@"vi_vimass" localizableString], sID] lowercaseString]
                                       ,
                                       [[@"Account" localizableString] lowercaseString],
                                       [[@"tao_tai_khoan_thuong_dung_the" localizableString] lowercaseString]
                                       ];
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.tag = TF_NHAN_GOC_VA_LAI;
    picker.dataSource = self;
    picker.delegate = self;

    _mtfNhanGocVaLaiVe.inputView = picker;
    _mtfNhanGocVaLaiVe.inputAccessoryView = nil;
    [picker selectRow:0 inComponent:0 animated:YES];
    [self xuLyHienThiKhiChonCachNhanTienGocVaLai:0];
    [picker release];
}

- (void)khoiTaoNganHangGuiTietKiem
{
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.tag = TF_NGAN_HANG_GUI_TK;
    picker.dataSource = self;
    picker.delegate = self;
    _mtfNganHangGui.inputAccessoryView = nil;
    _mtfNganHangGui.inputView = picker;
    [picker release];
}


- (void)khoiTaoKyHanGuiTietKiem
{
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneChonKyHan:)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelChonKyHan:)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

    [toolBar setItems:[NSArray arrayWithObjects:cancelButton, flexSpace, doneButton, nil]];

    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.tag = TF_KY_HAN_GUI_TK;
    picker.dataSource = self;
    picker.delegate = self;
    _mtfKyHanGui.inputAccessoryView = toolBar;
    _mtfKyHanGui.inputView = picker;
    [picker release];
}

- (void)doneChonKyHan:(UIBarButtonItem *)sender{
    [_mtfKyHanGui resignFirstResponder];
    [self xuLyChonKyHanGui:nKyHanRow];
}

- (void)cancelChonKyHan:(UIBarButtonItem *)sender{
    [_mtfKyHanGui resignFirstResponder];
}

- (void)khoiTaoKyTinhLai
{
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.tag = TF_KY_LINH_LAI;
    picker.dataSource = self;
    picker.delegate = self;
    _mtfKyLinhLai.inputAccessoryView = nil;
    _mtfKyLinhLai.inputView = picker;
    [picker release];
}

- (void)khoiTaoCachThucQuayVong
{
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.tag = TF_CACH_THUC_QUAY_VONG;
    picker.dataSource = self;
    picker.delegate = self;
    _mtfCachThucQuayVong.inputAccessoryView = nil;
    _mtfCachThucQuayVong.inputView = picker;
    [picker release];
}

- (void)khoiTaoDanhSachNganHangRutTienVe
{
    self.mDanhSachNganHangRutTienVe = [BankCoreData allBanks];
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.tag = TF_DANH_SACH_NGAN_HANG;
    picker.dataSource = self;
    picker.delegate = self;
    _mtfNganHangRutTienVe.inputAccessoryView = nil;
    _mtfNganHangRutTienVe.inputView = picker;
    [picker release];
}

- (void)khoiTaoLaiSuatNganHangNCB
{
//    self.mDanhSachLaiSuatCacNganHangTheoKiHan = [NganHangGuiTietKiemLayLaiSuat layLaiSuatCacNganHang];

}

- (void)khoiTaoViewLaiSuat
{
    UIWebView *wv = [[UIWebView alloc] initWithFrame:_mViewLaiSuatTietKiem.bounds];
    wv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    NSMutableString *strHTML = [[NSMutableString alloc] init];
    for(NganHangGuiTietKiem *nganHang in _mDanhSachNganHangGuiTietKiem)
    {
        [strHTML appendString:[nganHang layBangLaiSuatHtml]];
    }
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];

    [wv loadHTMLString:strHTML baseURL:baseURL];
    [strHTML release];
    [self.mViewLaiSuatTietKiem addSubview:wv];
    [wv release];
}

- (void)khoiTaoDanhSachNganHangGuiTietKiem
{
    self.mDinhDanhKetNoi = DINH_DANH_LAY_DANH_SACH_NGAN_HANG_GUI_TIET_KIEM;
    [self hienThiLoading];
    [GiaoDichMang ketNoiLayDanhSachNganHangGuiTietKiem:self];
}

#pragma mark - overriden GiaoDichViewController

- (BOOL)validateVanTay
{
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return NO;
    }
    NSInteger nKieuNhanTien = [_mDanhSachCachNhanGocVaLai indexOfObject:_mtfNhanGocVaLaiVe.text];
    NSArray *tfs = nil;
    if(nKieuNhanTien == KIEU_NHAN_TIEN_QUA_THE)
    {
        tfs = @[_mtfSoTien, _mtfTenNguoiGui, /*_mtfSoCMND,*/ _mtfSoThe];
    }
    else if (nKieuNhanTien == KIEU_NHAN_TIEN_QUA_TK)
    {
//        tfs = @[_mtfSoTien, _mtfTenNguoiGui, _mtfSoCMND, _mtfSoTaiKhoanRutTienVe, _mtfTenChuTaiKhoan];
        tfs = @[_mtfSoTien, _mtfSoTaiKhoanRutTienVe, _mtfTenChuTaiKhoan];
    }
    else
    {
        tfs = @[_mtfSoTien, _mtfTenNguoiGui/*, _mtfSoCMND*/];
    }

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
    }
    return flg;
}

- (void)xuLyThucHienKhiKiemTraThanhCongTraVeToken:(NSString*)sToken otp:(NSString*)sOtp
{
    self.mDinhDanhKetNoi = DINH_DANH_GUI_TIET_KIEM;
    double fSoTien = [[[self.mtfSoTien.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
    NSInteger nKieuNhanTien = [_mDanhSachCachNhanGocVaLai indexOfObject:_mtfNhanGocVaLaiVe.text];
    NSString *sSoTaiKhoan = @"";
    NSString *sMaNganHangNhanTien = @"";
    NSString *sTenChuTaiKhoan = @"";
    
    if(nKieuNhanTien == KIEU_NHAN_TIEN_QUA_THE)
    {
        sSoTaiKhoan = _mTaiKhoanThuongDung.sCardNumber;
    }
    else
    {
        sSoTaiKhoan = _mtfSoTaiKhoanRutTienVe.text;
        sTenChuTaiKhoan = [[Common chuyenKhongDau:_mtfTenChuTaiKhoan.text] uppercaseString];
        sMaNganHangNhanTien = self.mNganHangRutTienDuocChon.bank_sms;
    }
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self hienThiLoading];
    }
    [GiaoDichMang ketNoiGuiTienTietKiemTaiNganHang:_mNganHangDuocChon.maNganHang
                                            soTien:fSoTien
                                  cachThucQuayVong:[_mCachThucQuayVongDuocChon.maQuayVong intValue]
                                             kyHan:_mKyHanDuocChon.maKyHan
                                         kyLinhLai:[_mKyLaiDuocChon.maLai intValue]
                                       tenNguoiGui:_mtfTenNguoiGui.text
                                             soCmt:_mtfSoCMND.text
                                            diaChi:_mtvDiaChi.text
                                      kieuNhanTien:nKieuNhanTien
                                maNganHangNhanTien:sMaNganHangNhanTien
                                    tenChuTaiKhoan:sTenChuTaiKhoan
                                        soTaiKhoan:sSoTaiKhoan
                                             token:sToken
                                               otp:sOtp
                                  typeAuthenticate:self.mTypeAuthenticate
                                     noiNhanKetQua:self];
}

- (void)xuLyKetNoiThanhCong:(NSString*)sDinhDanhKetNoi thongBao:(NSString*)sThongBao ketQua:(id)ketQua
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self anLoading];
    }
    if([sDinhDanhKetNoi isEqualToString:DINH_DANH_GUI_TIET_KIEM])
    {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
    }
    else if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_LAY_DANH_SACH_NGAN_HANG_GUI_TIET_KIEM])
    {
        self.mDanhSachNganHangGuiTietKiem = [NganHangGuiTietKiem layDanhSachNganHangGuiTietKiem:(NSDictionary*)ketQua];

        [self khoiTaoViewLaiSuat];
        [self khoiTaoDanhSachNganHangRutTienVe];
        [self xuLyChonNganHangRutTienVe:0];
        [self khoiTaoLaiSuatNganHangNCB];
        [self xuLyChonNganHangGuiTietKiem:0];
    }
}

- (void)xuLyKetNoiThatBai:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua {
    NSLog(@"%s - that bai roi", __FUNCTION__);
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self anLoading];
    }
    [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
}

#pragma mark - suKien
- (IBAction)suKienBamNutBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)suKienThayDoiTenNguoiGui:(id)sender
{
    NSString *sTenNguoiGui = _mtfTenNguoiGui.text;
    sTenNguoiGui = [Common chuyenKhongDau:sTenNguoiGui];
    [_mtfTenChuTaiKhoan setText:[sTenNguoiGui uppercaseString]];
}

- (IBAction)suKienBamNutGuiTietKiem:(id)sender
{
    if(_mbtnGuiTK.enabled)
    {
        _mbtnTraCuu.enabled = YES;
        _mbtnLaiSuat.enabled = YES;
        _mbtnGuiTK.enabled = NO;
        [_mbtnGuiTK setBackgroundColor:[UIColor colorWithHexString:@"#03528a"]];
        [_mbtnTraCuu setBackgroundColor:[UIColor clearColor]];
        [_mbtnLaiSuat setBackgroundColor:[UIColor clearColor]];
        
        _mViewLaiSuatTietKiem.hidden = YES;
        _mViewTraCuuSoTietKiem.hidden = YES;
    }
}

- (IBAction)suKienBamNutTaiKhoanNganHangThuongDung:(id)sender
{
    DanhSachTaiKhoanThuongDungViewController *vc = [[DanhSachTaiKhoanThuongDungViewController alloc] initWithNibName:@"DanhSachTaiKhoanThuongDungViewController" bundle:nil];
    vc.mKieuChucNang = CHUC_NANG_CHON;
    vc.mKieuHienThiDanhSachTaiKhoan = TAI_KHOAN_NGAN_HANG;
    [self presentViewController:vc animated:YES completion:^{}];
    [vc release];
}

- (IBAction)suKienBamNutTaiKhoanTheThuongDung:(id)sender
{
    DanhSachTaiKhoanThuongDungViewController *vc = [[DanhSachTaiKhoanThuongDungViewController alloc] initWithNibName:@"DanhSachTaiKhoanThuongDungViewController" bundle:nil];
    vc.mKieuChucNang = CHUC_NANG_CHON;
    vc.mKieuHienThiDanhSachTaiKhoan = TAI_KHOAN_THE;
    [self presentViewController:vc animated:YES completion:^{}];
    [vc release];
}

- (IBAction)suKienBamNutTraCuu:(id)sender
{
    if(_mbtnTraCuu.enabled)
    {
        _mbtnTraCuu.enabled = NO;
        _mbtnLaiSuat.enabled = YES;
        _mbtnGuiTK.enabled = YES;
        [_mbtnTraCuu setBackgroundColor:[UIColor colorWithHexString:@"#03528a"]];
        [_mbtnLaiSuat setBackgroundColor:[UIColor clearColor]];
        [_mbtnGuiTK setBackgroundColor:[UIColor clearColor]];
        _mViewTraCuuSoTietKiem.frame = _mScrvHienThi.frame;
        _mViewTraCuuSoTietKiem.hidden = NO;
        _mViewLaiSuatTietKiem.hidden = YES;
    }
}

- (IBAction)suKienBamNutLaiSuat:(id)sender
{
    if(_mbtnLaiSuat.enabled)
    {
        _mbtnTraCuu.enabled = YES;
        _mbtnLaiSuat.enabled = NO;
        _mbtnGuiTK.enabled = YES;
        [_mbtnLaiSuat setBackgroundColor:[UIColor colorWithHexString:@"#03528a"]];
        [_mbtnTraCuu setBackgroundColor:[UIColor clearColor]];
        [_mbtnGuiTK setBackgroundColor:[UIColor clearColor]];
        _mViewLaiSuatTietKiem.frame = _mScrvHienThi.frame;
        _mViewLaiSuatTietKiem.hidden = NO;
        _mViewTraCuuSoTietKiem.hidden = YES;

    }
}

- (IBAction)suKienThayDoiGiaTriSoTien:(id)sender
{
    [self xuLyHienThiSoPhi];
    [self xuLyHienThiSoTienLai];
    double fSoTien = [[[self.mtfSoTien.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
    if(![CommonUtils isEmptyOrNull:self.mThongTinTaiKhoanVi.pki3] && [self.mThongTinTaiKhoanVi.hanMucPki3 doubleValue] >0 ){
        if(fSoTien > [self.mThongTinTaiKhoanVi.hanMucPki3 doubleValue]){
            self.mbtnSMS.hidden = YES;
            self.mbtnToken.hidden = YES;
            self.mbtnEmail.hidden = YES;
            self.mbtnPKI.hidden = NO;
        }
        else{
            self.mbtnSMS.hidden = NO;
            
            self.mbtnToken.hidden = NO;
            
            self.mbtnEmail.hidden = NO;
            
            self.mbtnPKI.hidden = NO;
        }
    }
    else{
        self.mbtnPKI.hidden = YES;
        self.mbtnToken.hidden = NO;
        self.mbtnSMS.hidden = NO;
        self.mbtnEmail.hidden = NO;
    }
    if(fSoTien > 0)
        _mtfSoTien.text = [Common hienThiTienTe:fSoTien];
    else
        _mtfSoTien.text = @"";
}

#pragma mark - xuLy

- (void)xuLyCapNhatTaiKhoanThuongDung
{
    NSInteger nKieuNhanTien = [_mDanhSachCachNhanGocVaLai indexOfObject:_mtfNhanGocVaLaiVe.text];
    if(nKieuNhanTien == KIEU_NHAN_TIEN_QUA_THE)
    {
        _mtfSoThe.text =  _mTaiKhoanThuongDung.sCardNumber;
    }
    else
    {
        _mtfSoTaiKhoanRutTienVe.text = _mTaiKhoanThuongDung.sBankNumber;
        _mtfTenChuTaiKhoan.text = [[Common chuyenKhongDau:_mTaiKhoanThuongDung.sAccOwnerName] uppercaseString];

        int nViTri = -1;
        for (int i = 0; i< _mDanhSachNganHangRutTienVe.count; i++) {
            Banks *bank = [_mDanhSachNganHangRutTienVe objectAtIndex:i];
            if([bank.bank_code intValue] == _mTaiKhoanThuongDung.nBankCode)
            {
                _mtfNganHangRutTienVe.text = bank.bank_name;
                self.mNganHangRutTienDuocChon = bank;
                nViTri = i;
                break;
            }
        }
        if(nViTri != -1)
        {

            [(UIPickerView*)_mtfNganHangRutTienVe.inputView selectRow:nViTri inComponent:0 animated:YES];
        }
    }
}

- (void)xuLyChonNganHangRutTienVe:(int)nViTri
{
    self.mNganHangRutTienDuocChon = [self.mDanhSachNganHangRutTienVe objectAtIndex:nViTri];
    [_mtfNganHangRutTienVe setText:_mNganHangRutTienDuocChon.bank_name];
    [(UIPickerView*)_mtfNganHangRutTienVe.inputView selectRow:nViTri inComponent:0 animated:YES];
}

- (void)xuLyHienThiKhiChonCachNhanTienGocVaLai:(int)nCachChon
{
    NSString *sCachNhanTienGocVaLai = [_mDanhSachCachNhanGocVaLai objectAtIndex:nCachChon];
    _mtfNhanGocVaLaiVe.text = sCachNhanTienGocVaLai;
    CGRect rViewNhanGocVaLaiVe = _mVIewNhanGocVaLaiVe.frame;
    CGRect rViewThoiGian = _mViewThoiGianConLai.frame;
    CGRect rViewNhapToken = self.mViewNhapToken.frame;
    CGRect rectQC = viewQC.frame;
    CGRect rViewMain = self.mViewMain.frame;
    CGRect rButtonVanTay = self.mbtnVanTay.frame;

    float fHeight = 0;
    float fWidth = _mScrvHienThi.frame.size.width;
    
    if(nCachChon == KIEU_NHAN_TIEN_QUA_VI)
    {
        if(_mViewChonNganHangNhanTienGocVaLaiTietKiem.superview)
            [_mViewChonNganHangNhanTienGocVaLaiTietKiem removeFromSuperview];
        if(_mViewRutGocVaLaiVeThe.superview)
            [_mViewRutGocVaLaiVeThe removeFromSuperview];
        
        rViewThoiGian.origin.y = rViewNhanGocVaLaiVe.origin.y + rViewNhanGocVaLaiVe.size.height + 8;
        rViewNhapToken.origin.y = rViewThoiGian.origin.y + rViewThoiGian.size.height + 8;
        rectQC.origin.y = rViewNhapToken.origin.y + rViewNhapToken.size.height + 15;
        rViewMain.size.height = rectQC.origin.y +rectQC.size.height + 10;

    }
    else if(nCachChon == KIEU_NHAN_TIEN_QUA_TK)
    {
        if(_mViewChonNganHangNhanTienGocVaLaiTietKiem.superview)
            [_mViewChonNganHangNhanTienGocVaLaiTietKiem removeFromSuperview];
        if(_mViewRutGocVaLaiVeThe.superview)
            [_mViewRutGocVaLaiVeThe removeFromSuperview];
        
        CGRect rViewChonNganHangNhanTienGocVaLai = _mViewChonNganHangNhanTienGocVaLaiTietKiem.frame;
        rViewChonNganHangNhanTienGocVaLai.origin.y = rViewNhanGocVaLaiVe.size.height + rViewNhanGocVaLaiVe.origin.y + 8;
        rViewChonNganHangNhanTienGocVaLai.size.width = rViewThoiGian.size.width;
        
        rViewThoiGian.origin.y = rViewChonNganHangNhanTienGocVaLai.origin.y + rViewChonNganHangNhanTienGocVaLai.size.height + 8;
        rViewNhapToken.origin.y = rViewThoiGian.origin.y + rViewThoiGian.size.height + 8;
        rectQC.origin.y = rViewNhapToken.origin.y + rViewNhapToken.size.height + 15;
        rViewMain.size.height = rectQC.origin.y +rectQC.size.height + 10;
        
        _mViewChonNganHangNhanTienGocVaLaiTietKiem.frame = rViewChonNganHangNhanTienGocVaLai;
        [self.mViewMain addSubview:_mViewChonNganHangNhanTienGocVaLaiTietKiem];
    }
    else if(nCachChon == KIEU_NHAN_TIEN_QUA_THE)
    {
        if(_mViewChonNganHangNhanTienGocVaLaiTietKiem.superview)
            [_mViewChonNganHangNhanTienGocVaLaiTietKiem removeFromSuperview];
        if(_mViewRutGocVaLaiVeThe.superview)
            [_mViewRutGocVaLaiVeThe removeFromSuperview];
        
        CGRect rViewChonTheNhanTienGocVaLai = _mViewRutGocVaLaiVeThe.frame;
        rViewChonTheNhanTienGocVaLai.origin.y = rViewNhanGocVaLaiVe.size.height + rViewNhanGocVaLaiVe.origin.y + 8;
        rViewChonTheNhanTienGocVaLai.size.width = rViewThoiGian.size.width;
        rViewThoiGian.origin.y = rViewChonTheNhanTienGocVaLai.origin.y + rViewChonTheNhanTienGocVaLai.size.height + 8;
        rViewNhapToken.origin.y = rViewThoiGian.origin.y + rViewThoiGian.size.height + 8;
        rectQC.origin.y = rViewNhapToken.origin.y + rViewNhapToken.size.height + 15;
        rViewMain.size.height = rectQC.origin.y +rectQC.size.height + 10;
        
        _mViewRutGocVaLaiVeThe.frame = rViewChonTheNhanTienGocVaLai;
        [self.mViewMain addSubview:_mViewRutGocVaLaiVeThe];
    }
    
    if([self kiemTraCoChucNangQuetVanTay])
    {
        rButtonVanTay.origin.y = rViewMain.origin.y + rViewMain.size.height + 20;
        fHeight = rButtonVanTay.origin.y + rButtonVanTay.size.height + 10;
    }
    else
    {
        fHeight = rViewMain.size.height + rViewMain.origin.y + 10;
    }
    
    _mViewThoiGianConLai.frame = rViewThoiGian;
    self.mViewNhapToken.frame = rViewNhapToken;
    viewQC.frame = rectQC;
    self.mViewMain.frame = rViewMain;
    self.mbtnVanTay.frame = rButtonVanTay;
    
    _mScrvHienThi.contentSize = CGSizeMake(fWidth, fHeight);
}

- (void)xuLyHienThiThongTinNguoiDungLanDauTien
{
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        _mtfTenNguoiGui.text = self.mThongTinTaiKhoanVi.companyName;
        _mtfTenChuTaiKhoan.text = [[Common chuyenKhongDau:self.mThongTinTaiKhoanVi.companyName] uppercaseString];
        _mtfSoCMND.text = self.mThongTinTaiKhoanVi.companyCode;
        _mtvDiaChi.text = self.mThongTinTaiKhoanVi.sDiaChiNha;
    }
    else if(nKieuDangNhap == KIEU_CA_NHAN)
    {
        _mtfTenNguoiGui.text = self.mThongTinTaiKhoanVi.sTenCMND;
        _mtfTenChuTaiKhoan.text = [[Common chuyenKhongDau:self.mThongTinTaiKhoanVi.sTenCMND] uppercaseString];
        _mtfSoCMND.text = self.mThongTinTaiKhoanVi.sCMND;
        _mtvDiaChi.text = self.mThongTinTaiKhoanVi.sDiaChiNha;
    }

}

- (void)xuLyChonNganHangGuiTietKiem:(int)nViTriNganHangDuocChon
{
    if(_mDanhSachNganHangGuiTietKiem.count > 0)
    {
        self.mNganHangDuocChon = [_mDanhSachNganHangGuiTietKiem objectAtIndex:nViTriNganHangDuocChon];
        _mtfNganHangGui.text = self.mNganHangDuocChon.bank;
        self.mDanhSachKyHanGui = self.mNganHangDuocChon.mDanhSachKyHan;
        [self xuLyChonKyHanGui:0];
    }
}

- (void)xuLyChonCachThucQuayVong:(int)nViTriChonCachThucQuayVong
{
    if(_mDanhSachCachThucQuayVong.count > 0)
    {
        self.mCachThucQuayVongDuocChon = [_mDanhSachCachThucQuayVong objectAtIndex:nViTriChonCachThucQuayVong];
        _mtfCachThucQuayVong.text = self.mCachThucQuayVongDuocChon.noiDungQuayVong;
        _mtfCachThucQuayVong.text = [NSString stringWithFormat:@"Quay vòng %@", _mCachThucQuayVongDuocChon.noiDungQuayVong];
        if([_mCachThucQuayVongDuocChon.noiDungQuayVong rangeOfString:@"không"].location != NSNotFound)
        {
            _mtfCachThucQuayVong.text = _mCachThucQuayVongDuocChon.noiDungQuayVong;
        }
        [(UIPickerView*)_mtfCachThucQuayVong.inputView reloadAllComponents];
        [(UIPickerView*)_mtfCachThucQuayVong.inputView selectRow:nViTriChonCachThucQuayVong inComponent:0 animated:YES];
    }
}

- (void)xuLyChonKyLinhLai:(int)nViTriKyLinhLai
{
    if(_mDanhSachKyLinhLai.count > 0)
    {
        self.mKyLaiDuocChon = [_mDanhSachKyLinhLai objectAtIndex:nViTriKyLinhLai];
        _mtfKyLinhLai.text = [NSString stringWithFormat:@"Lĩnh lãi %@", _mKyLaiDuocChon.noiDungLai];
        self.mDanhSachCachThucQuayVong = self.mKyLaiDuocChon.mDanhSachCachQuayVong;
        [(UIPickerView*)_mtfKyLinhLai.inputView reloadAllComponents];
        [(UIPickerView*)_mtfKyLinhLai.inputView selectRow:nViTriKyLinhLai inComponent:0 animated:YES];
//        [self xuLyLayLaiSuatTheoKyLinhLai];
        [self xuLyHienThiSoTienLai];
        [self xuLyChonCachThucQuayVong:0];
    }
}

- (void)xuLyChonKyHanGui:(int)nViTriKyHan
{
    if(_mDanhSachKyHanGui.count > 0)
    {
        self.mKyHanDuocChon = [_mDanhSachKyHanGui objectAtIndex:nViTriKyHan];
        if ([_mKyHanDuocChon.noiDung hasPrefix:@"Không"]) {
            _mtfKyHanGui.text = _mKyHanDuocChon.noiDung;
        }
        else
            _mtfKyHanGui.text = [NSString stringWithFormat:@"Kỳ hạn %@", _mKyHanDuocChon.noiDung];
        [(UIPickerView*)_mtfKyHanGui.inputView reloadAllComponents];
        [(UIPickerView*)_mtfKyHanGui.inputView selectRow:nViTriKyHan inComponent:0 animated:YES];
        self.mDanhSachKyLinhLai = self.mKyHanDuocChon.mDanhSachKyLai;
        _mLaiSuatTheoKyLai = [_mKyHanDuocChon.laiSuat doubleValue];
        [self xuLyChonKyLinhLai:0];
    }
}

//- (void)xuLyLayLaiSuatTheoKyLinhLai
//{
//    _mLaiSuatTheoKyLai = 5.5f;
//    
//    for(NganHangGuiTietKiemLayLaiSuat *nganHang in _mDanhSachLaiSuatCacNganHangTheoKiHan)
//    {
//        if([nganHang.maNganHang isEqualToString:_mNganHangDuocChon.maNganHang])
//        {
//            for(LaiSuatNganHang *laiSuat in nganHang.danhSachLai)
//            {
//                if([laiSuat.maKyHan isEqualToString:_mKyHanDuocChon.maKyHan])
//                {
//                    switch ([_mKyLaiDuocChon.maLai intValue]) {
//                        case MA_LAI_DAU_KY:
//                            _mLaiSuatTheoKyLai = [laiSuat.dauKy doubleValue];
//                            break;
//                        case MA_LAI_CUOI_KY:
//                            _mLaiSuatTheoKyLai = [laiSuat.cuoiKy doubleValue];
//                            break;
//                        case MA_LAI_HANG_THANG:
//                            _mLaiSuatTheoKyLai = [laiSuat.time1Thang doubleValue];
//                            break;
//                        case MA_LAI_HANG_QUY:
//                            _mLaiSuatTheoKyLai = [laiSuat.time3Thang doubleValue];
//                            break;
//                        case MA_LAI_HANG_NAM:
//                            _mLaiSuatTheoKyLai = [laiSuat.time12Thang doubleValue];
//                            break;
//                        case MA_LAI_6_THANG:
//                            _mLaiSuatTheoKyLai = [laiSuat.time6Thang doubleValue];
//                            break;
//                        default:
//                            break;
//                    }
//                }
//            }
//            break;
//        }
//    }
//    
//    [self xuLyHienThiSoTienLai];
//}

- (void)xuLyHienThiSoPhi
{
    double fSoTien = [[[self.mtfSoTien.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
    if (fSoTien >= 10000000){
        _mtfSoPhi.text = [NSString stringWithFormat:@"%@ đ", [Common hienThiTienTe:6600]];
    }
    else{
//        double fSoPhi = [Common layPhiChuyenTienCuaSoTien:fSoTien kieuChuyenTien:KIEU_CHUYEN_TIEN_DEN_VI maNganHang:@""];
        _mtfSoPhi.text = [NSString stringWithFormat:@"%@ đ", [Common hienThiTienTe:3300]];
    }
}

- (void)xuLyHienThiSoTienLai
{
    double fSoTien = [[[self.mtfSoTien.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
    _mlblLaiSuat.text = [NSString stringWithFormat:@"Lãi suất: %@\uFF05", [NSString stringWithFormat:@"%.02f", _mLaiSuatTheoKyLai]];
    double fSoTienLai = 0;
    if([_mKyHanDuocChon.maKyHan rangeOfString:@"M"].location != NSNotFound)
    {
        //La thang
        NSInteger nSoThang = [[_mKyHanDuocChon.maKyHan stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, _mKyHanDuocChon.maKyHan.length)] intValue];
        fSoTienLai = [self laySoTienLaiTheoThang:nSoThang];
    }
    else if([_mKyHanDuocChon.maKyHan rangeOfString:@"D"].location != NSNotFound)
    {
        //La ngay
        NSInteger nSoNgay = [[_mKyHanDuocChon.maKyHan stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, _mKyHanDuocChon.maKyHan.length)] intValue];
        fSoTienLai = [self laySoTienLaiTheoNgay:nSoNgay];
    }
    else if ([_mKyHanDuocChon.maKyHan rangeOfString:@"KKH"].location != NSNotFound)
    {
        fSoTienLai = [self laySoTienLaiTheoNgay:1];
        if(fSoTien > 0)
            _mlblTienLai.text = [NSString stringWithFormat:@"Tiền lãi: %@ đ/ngày", [Common hienThiTienTe:fSoTienLai]];
        else
            _mlblTienLai.text = @"Tiền lãi: 0 đ/ngày";
        return;
    }
    
    if(fSoTien > 0)
        _mlblTienLai.text = [NSString stringWithFormat:@"Tiền lãi: %@ đ", [Common hienThiTienTe:fSoTienLai]];
    else
        _mlblTienLai.text = @"Tiền lãi: 0 đ";
}

- (double)laySoTienLaiTheoNgay:(NSInteger)nSoNgayTinhLai
{
    double fSoTien = [[[self.mtfSoTien.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
    return [Common laySoTienLaiTheoNgay:_mLaiSuatTheoKyLai soNgayGui:nSoNgayTinhLai soTien:fSoTien];
}

- (double)laySoTienLaiTheoThang:(NSInteger)nSoThangTinhLai
{
    double fSoTien = [[[self.mtfSoTien.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
    return [Common laySoTienLaiTheoThang:_mLaiSuatTheoKyLai soThangGui:nSoThangTinhLai soTien:fSoTien];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView.tag == TF_NHAN_GOC_VA_LAI)
    {
        if(_mDanhSachCachNhanGocVaLai)
            return _mDanhSachCachNhanGocVaLai.count;
    }
    else if(pickerView.tag == TF_KY_HAN_GUI_TK)
    {
        if(_mDanhSachKyHanGui)
            return _mDanhSachKyHanGui.count;
    }
    else if (pickerView.tag == TF_NGAN_HANG_GUI_TK)
    {
        if(_mDanhSachNganHangGuiTietKiem)
            return _mDanhSachNganHangGuiTietKiem.count;
    }
    else if (pickerView.tag == TF_KY_LINH_LAI)
    {
        if(_mDanhSachKyLinhLai)
            return _mDanhSachKyLinhLai.count;
    }
    else if (pickerView.tag == TF_CACH_THUC_QUAY_VONG)
    {
        if(_mDanhSachCachThucQuayVong)
            return _mDanhSachCachThucQuayVong.count;
    }
    else if (pickerView.tag == TF_DANH_SACH_NGAN_HANG)
    {
        return _mDanhSachNganHangRutTienVe.count;
    }
    return 0;
}


#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView.tag == TF_NHAN_GOC_VA_LAI)
    {
        return [_mDanhSachCachNhanGocVaLai objectAtIndexedSubscript:row];
    }
    else if (pickerView.tag == TF_NGAN_HANG_GUI_TK)
    {
        NganHangGuiTietKiem *nganHangGuiTietKiem = [_mDanhSachNganHangGuiTietKiem objectAtIndex:row];
        return nganHangGuiTietKiem.bank;
    }
    else if ( pickerView.tag == TF_KY_HAN_GUI_TK)
    {
        KyHanNganHang *kyHanNganHang = [_mDanhSachKyHanGui objectAtIndex:row];
        if ([kyHanNganHang.noiDung hasPrefix:@"Không"]) {
            return kyHanNganHang.noiDung;
        }
        return [NSString stringWithFormat:@"Kỳ hạn %@", kyHanNganHang.noiDung];
    }
    else if ( pickerView.tag == TF_KY_LINH_LAI)
    {
        KyLaiNganHang *kyLaiNganHang = [_mDanhSachKyLinhLai objectAtIndex:row];
        return [NSString stringWithFormat:@"Lĩnh lãi %@", kyLaiNganHang.noiDungLai];
    }
    else if (pickerView.tag == TF_CACH_THUC_QUAY_VONG)
    {
        CachQuayVongKyLai *cachThucQuayVong = [_mDanhSachCachThucQuayVong objectAtIndex:row];
        if([cachThucQuayVong.noiDungQuayVong rangeOfString:@"không"].location != NSNotFound)
        {
            return cachThucQuayVong.noiDungQuayVong;
        }
        return [NSString stringWithFormat:@"Quay vòng %@", cachThucQuayVong.noiDungQuayVong];
    }
    else if (pickerView.tag == TF_DANH_SACH_NGAN_HANG)
    {
        Banks *bank = [_mDanhSachNganHangRutTienVe objectAtIndex:row];
        return bank.bank_name;
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    int nRow = (int)row;
    if(pickerView.tag == TF_NHAN_GOC_VA_LAI)
    {
        [self xuLyHienThiKhiChonCachNhanTienGocVaLai:nRow];
    }
    else if (pickerView.tag == TF_NGAN_HANG_GUI_TK)
    {
        [self xuLyChonNganHangGuiTietKiem:nRow];
    }
    else if ( pickerView.tag == TF_KY_HAN_GUI_TK)
    {
        nKyHanRow = (int)row;
    }
    else if ( pickerView.tag == TF_KY_LINH_LAI)
    {
        [self xuLyChonKyLinhLai:nRow];
    }
    else if (pickerView.tag == TF_CACH_THUC_QUAY_VONG)
    {
        [self xuLyChonCachThucQuayVong:nRow];
    }
    else if (pickerView.tag == TF_DANH_SACH_NGAN_HANG)
    {
        [self xuLyChonNganHangRutTienVe:nRow];
    }
}

#pragma mark -

-(void)updateThongTin:(NSNotification *)notification
{
    if([[notification name] isEqualToString:NOTIFICATION_LAY_TAI_KHOAN_THUONG_DUNG])
    {
        self.mTaiKhoanThuongDung = [notification object];
        [self xuLyCapNhatTaiKhoanThuongDung];
    }
}

#pragma mark - TraCuuSoTietKiemViewDelegate

- (void)suKienChonSoTietKiem:(SoTietKiem*)soTietKiem
{
    ChiTietSoTietKiemViewController *chiTiet = [[ChiTietSoTietKiemViewController alloc] initWithNibName:@"ChiTietSoTietKiemViewController" bundle:nil];
    chiTiet.mSoTietKiem = soTietKiem;
    [self.navigationController pushViewController:chiTiet animated:YES];
    [chiTiet release];
}

- (IBAction)suKienBamNutSoTayThuongDung:(id)sender {
    DucNT_DanhSachTaiKhoanThuongDungControllerViewController *vc = [[DucNT_DanhSachTaiKhoanThuongDungControllerViewController alloc] initWithType:TAI_KHOAN_GUI_TIET_KIEM];
    [self.navigationController presentViewController:vc animated:YES completion:^{}];
    [vc release];
}

- (IBAction)suKienBamNutHuongDan:(id)sender {
    GiaoDienThongTinPhim *vc = [[GiaoDienThongTinPhim alloc] initWithNibName:@"GiaoDienThongTinPhim" bundle:nil];
    vc.nOption = HUONG_DAN_GUI_TIET_KIEM;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

#pragma mark - dealloc
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_LAY_TAI_KHOAN_THUONG_DUNG object:nil];
    //    if(_mDanhSachLaiSuatCacNganHangTheoKiHan)
    //        [_mDanhSachLaiSuatCacNganHangTheoKiHan release];
    [viewQC release];
    if(_mTaiKhoanThuongDung)
        [_mTaiKhoanThuongDung release];
    if(_mNganHangRutTienDuocChon)
        [_mNganHangRutTienDuocChon release];
    if(_mDanhSachNganHangRutTienVe)
        [_mDanhSachNganHangRutTienVe release];
    if(_mViewLaiSuatTietKiem)
        [_mViewLaiSuatTietKiem release];
    if(_mViewTraCuuSoTietKiem)
        [_mViewTraCuuSoTietKiem release];
    if(_mNganHangDuocChon)
        [_mNganHangDuocChon release];
    if(_mKyHanDuocChon)
        [_mKyHanDuocChon release];
    if(_mKyLaiDuocChon)
        [_mKyLaiDuocChon release];
    if(_mCachThucQuayVongDuocChon)
        [_mCachThucQuayVongDuocChon release];
    if(_mDanhSachKyHanGui)
        [_mDanhSachKyHanGui release];
    if(_mDanhSachKyLinhLai)
        [_mDanhSachKyLinhLai release];
    if(_mDanhSachCachThucQuayVong)
        [_mDanhSachCachThucQuayVong release];
    [_mDanhSachCachNhanGocVaLai release];
    [_mDanhSachNganHangGuiTietKiem release];
    [_mtfNganHangGui release];
    [_mtfSoTien release];
    [_mtfKyHanGui release];
    [_mtfKyLinhLai release];
    [_mtfCachThucQuayVong release];
    [_mlblLaiSuat release];
    [_mlblTienLai release];
    [_mtfTenNguoiGui release];
    [_mtfDiaChi release];
    [_mtvDiaChi release];
    [_mtfNhanGocVaLaiVe release];
    [_mVIewNhanGocVaLaiVe release];
    [_mViewThoiGianConLai release];
    [_mViewChonNganHangNhanTienGocVaLaiTietKiem release];
    [_mtfSoCMND release];
    [_mtfSoPhi release];
    [_mbtnGuiTK release];
    [_mbtnTraCuu release];
    [_mbtnLaiSuat release];
    [_mbtnThuongDung release];
    [_mViewRutGocVaLaiVeThe release];
    [_mtfSoThe release];
    [_mtfSoTaiKhoanRutTienVe release];
    [_mtfNganHangRutTienVe release];
    [_mtfTenChuTaiKhoan release];
    [_btnSoTayTkBank release];
    [_btnSoTayThe release];
    [_mScrvHienThi release];
    [super dealloc];
}
@end
