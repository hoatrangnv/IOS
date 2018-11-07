//
//  ChuyenTienDenViMomoViewController.m
//  ViViMASS
//
//  Created by DucBui on 6/23/15.
//
//

#import "ChuyenTienDenViMomoViewController.h"
#import "ViewNhapTenDaiDienXacThucThemTaiKhoanThuongDung.h"
#import "DucNT_DanhSachTaiKhoanThuongDungControllerViewController.h"
#import "ContactScreen.h"
#import "GiaoDienThongTinPhim.h"
#import "ViewQuangCao.h"
#import "DucNT_LoginSceen.h"

#define DINH_DANH_KET_NOI_CHUYEN_TIEN_DEN_VI_MOMO @"DINH_DANH_KET_NOI_CHUYEN_TIEN_DEN_VI_MOMO"
@interface ChuyenTienDenViMomoViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
{
    ViewNhapTenDaiDienXacThucThemTaiKhoanThuongDung *mViewNhapTenDaiDien;
    int nRowNhaMay;
    ViewQuangCao *viewQC;
}
@end

@implementation ChuyenTienDenViMomoViewController

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateThongTinViMoMo:) name:KEY_TAI_KHOAN_THUONG_DUNG object:nil];
    nRowNhaMay = 0;
    [self khoiTaoBanDau];
    [self khoiTaoViewNhapTenDaiDienXacThucTaiKhoan];
    if(_mTaiKhoanThuongDung)
        [self khoiTaoTheoTaiKhoanThuongDung];

//    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 12)];
//    [btnRight setBackgroundImage:[UIImage imageNamed:@"muiten35x21.png"] forState:UIControlStateNormal];
//    _edChonVi.rightView = btnRight;
//    _edChonVi.rightViewMode = UITextFieldViewModeAlways;
//
//    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
//    toolBar.barStyle = UIBarStyleBlackOpaque;
//    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneChonVi:)];
//    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelChonVi:)];
//    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//
//    [toolBar setItems:[NSArray arrayWithObjects:cancelButton, flexSpace, doneButton, nil]];
//    UIPickerView *pickerChonRap = [[UIPickerView alloc] init];
//    pickerChonRap.dataSource = self;
//    pickerChonRap.delegate = self;
//    pickerChonRap.tag = 100;
//    _edChonVi.inputAccessoryView = toolBar;
//    _edChonVi.inputView = pickerChonRap;
//    [pickerChonRap release];
    [self addButtonHuongDan];

}

- (void)khoiTaoQuangCao {
    if (!viewQC) {
        viewQC = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ViewQuangCao class]) owner:self options:nil] objectAtIndex:0];
        viewQC.mDelegate = self;
        CGRect rectToken = self.viewThucHien.frame;
        CGRect rectQC = viewQC.frame;
        CGRect rectMain = self.mViewMain.frame;
        CGFloat fW = rectMain.size.width;
        CGFloat fH = rectQC.size.height * ((rectMain.size.width) / rectQC.size.width);
        rectQC.origin.y = rectToken.origin.y + rectToken.size.height + 15;
        viewQC.frame = CGRectMake(0, rectQC.origin.y, fW, fH);
        [viewQC updateSizeQuangCao];
        viewQC.mDelegate = self;
        rectMain.size.height = rectQC.origin.y + rectQC.size.height + 50;
        self.mViewMain.frame = rectMain;
        [self.mViewMain addSubview:viewQC];
        [self.scrMain setContentSize:CGSizeMake(_scrMain.frame.size.width, rectMain.origin.y + rectMain.size.height + self.viewOptionTop.frame.size.height + 20)];
    }
}

- (void)suKienBamNutHuongDanGiaoDichViewController:(UIButton *)sender {
    GiaoDienThongTinPhim *vc = [[GiaoDienThongTinPhim alloc] initWithNibName:@"GiaoDienThongTinPhim" bundle:nil];
    vc.nOption = HUONG_DAN_CHUYEN_TIEN_VI_KHAC;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)doneChonVi:(UIBarButtonItem *)sender {
    [_edChonVi resignFirstResponder];
    [self xuLyChonVi];
}

- (void)xuLyChonVi {
    _edChonVi.text = [self layTenNhaMayNuoc:nRowNhaMay];
    if (nRowNhaMay != 2 && nRowNhaMay != 4 && nRowNhaMay != 6) {
        _tfNoiDung.hidden = NO;
        _mtvNoiDung.hidden = NO;
        CGRect rectThucHien = _viewThucHien.frame;
        CGRect rectXacThuc = _viewXacThuc.frame;
        CGRect rectNoiDung = _tfNoiDung.frame;
        CGRect rectQC = viewQC.frame;
        CGRect rectMain = self.mViewMain.frame;
        rectXacThuc.origin.y = rectNoiDung.origin.y + rectNoiDung.size.height + 8;
        rectThucHien.origin.y = rectXacThuc.origin.y + rectXacThuc.size.height + 8;
        rectQC.origin.y = rectThucHien.origin.y + rectThucHien.size.height + 15;
        rectMain.size.height = rectQC.origin.y + rectQC.size.height + 10;
        
        _viewXacThuc.frame = rectXacThuc;
        _viewThucHien.frame = rectThucHien;
        viewQC.frame = rectQC;
        self.mViewMain.frame = rectMain;
    }
    else {
        _tfNoiDung.hidden = YES;
        _mtvNoiDung.hidden = YES;
        _tfNoiDung.text = @"";
        _mtvNoiDung.text = @"";
        
        CGRect rectThucHien = _viewThucHien.frame;
        CGRect rectXacThuc = _viewXacThuc.frame;
        CGRect rectNoiDung = _viewSoTien.frame;
        CGRect rectQC = viewQC.frame;
        CGRect rectMain = self.mViewMain.frame;
        rectXacThuc.origin.y = rectNoiDung.origin.y + rectNoiDung.size.height + 8;
        rectThucHien.origin.y = rectXacThuc.origin.y + rectXacThuc.size.height + 8;
        rectMain.size.height = rectThucHien.origin.y + rectThucHien.size.height + 10;
        
        _viewXacThuc.frame = rectXacThuc;
        _viewThucHien.frame = rectThucHien;
        viewQC.frame = rectQC;
        self.mViewMain.frame = rectMain;
    }
}

- (void)cancelChonVi:(UIBarButtonItem *)sender {
    [_edChonVi resignFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.view endEditing:YES];
    [self setAnimationChoSoTay:self.btnSoTay];
    nRowNhaMay = self.nType;
    [self xuLyChonVi];
//    [self khoiTaoQuangCao];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    UIImageView *imgSoTay = [self.btnSoTay imageView];
    [imgSoTay stopAnimating];
}

#pragma mark - khoiTao
- (void)khoiTaoBanDau
{
    [self addTitleView:@"Chuyển tiền đến Ví khác"];
    [self addButtonBack];
//    [self addButton:@"ic_save_acc" selector:@selector(suKienBamNutThemTaiKhoanThuongDung:) atSide:1];

    self.mFuncID = FUNC_CHUYEN_TIEN_DEN_VI_MOMO;
    _mtfViMomo.inputAccessoryView = nil;
    [_mtfViMomo setTextError:@"Tài khoản ví khác không được bỏ trống!" forType:ExTextFieldTypeEmpty];
    [_mtfViMomo setTextError:@"Vui lòng nhập đúng tài khoản ví khác!" forType:ExTextFieldTypePhone];
    _mtfSoTien.inputAccessoryView = nil;
    [_mtfSoTien setTextError:@"Số tiền không được bỏ trống!" forType:ExTextFieldTypeEmpty];
    _mtfSoTien.type = ExTextFieldTypeMoney;
    
    _mtvNoiDung.inputAccessoryView = nil;
    [self hienThiSoPhiCuaSoTien:0.0f];
    
}

- (void)khoiTaoTheoTaiKhoanThuongDung
{
    [self hienThiSoPhiCuaSoTien:_mTaiKhoanThuongDung.nAmount];
    if(_mTaiKhoanThuongDung.nAmount != 0)
    {
        self.mtfSoTien.text = [Common hienThiTienTe:_mTaiKhoanThuongDung.nAmount];
    }
    else
    {
        self.mtfSoTien.text = @"";
    }
    
    self.mtfViMomo.text = _mTaiKhoanThuongDung.taiKhoan;
    self.mtvNoiDung.text = _mTaiKhoanThuongDung.sDesc;
    self.edChonVi.text = [self layTenNhaMayNuoc:_mTaiKhoanThuongDung.nhaCungCap];
    nRowNhaMay = [self layIndexChonVi:_mTaiKhoanThuongDung.nhaCungCap];
} 

- (void)khoiTaoViewNhapTenDaiDienXacThucTaiKhoan
{
    if(!mViewNhapTenDaiDien)
    {
        mViewNhapTenDaiDien = [[[[NSBundle mainBundle] loadNibNamed:@"ViewNhapTenDaiDienXacThucThemTaiKhoanThuongDung" owner:self options:nil] objectAtIndex:0] retain];
    }
}

#pragma mark - uipickerview
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 7;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self layTenNhaMayNuoc:(int)row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    nRowNhaMay = (int)row;
}

- (NSString *)layTenNhaMayNuoc:(int)row{
    switch (row) {
        case 0:
            return @"Chọn ví nhận tiền";
        case 1: case MOMO:
            return @"Momo";
        case 2: case NGAN_LUONG:
            return @"Ngân Lượng";
        case 3: case PAYOO:
            return @"Payoo";
        case 4: case VIMO:
            return @"Vimo";
        case 5: case VTC_PAY:
            return @"VTCpay";
        case 6: case NHA_CUNG_CAP_VIVIET:
            return @"Ví Việt";
        case 7: case VNPT_PAY:
            return @"VNPT Pay ";
        case 8: case AIR_PAY:
            return @"Air Pay";
        default:
            break;
    }
    return @"";
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
    NSArray *tfs = @[_mtfViMomo, _mtfSoTien];
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
        return NO;
    }

    double fSoTien = [[_mtfSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
    if(fSoTien < 10000.0f)
    {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Số tiền một lần giao dịch với Ví khác phải lớn hơn 10.000 đ"];
        return NO;
    }
    else if(fSoTien > [self.mThongTinTaiKhoanVi.nAmount doubleValue])
    {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Tài khoản ví không đủ tiền!"];
        return NO;
    }
    else if(fSoTien > 300000000) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Số tiền một lần giao dịch với Ví khác phải nhỏ hơn 300 triệu"];
        return NO;
    }
    else if (fSoTien > [self.mThongTinTaiKhoanVi.nHanMucDenViKhac doubleValue]) {
        [UIAlertView alert:@"Số tiền chuyển đi phải nhỏ hơn hạn mức giao dịch" withTitle:[@"thong_bao" localizableString] block:nil];
        return NO;
    }
    if ([self layMaNhaCungCap] == -1) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng chọn ví nhận tiền"];
        return NO;
    }
    return flg;
}

- (void)xuLyThucHienKhiKiemTraThanhCongTraVeToken:(NSString*)sToken otp:(NSString*)sOtp
{
    double fSoTien = [[_mtfSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self hienThiLoading];
    }
    self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_CHUYEN_TIEN_DEN_VI_MOMO;
    [GiaoDichMang ketNoiChuyenTienDenViMomo:_mtfViMomo.text
                                     soTien:fSoTien
                                    noiDung:_mtvNoiDung.text
                                 nhaCungCap:[self layMaNhaCungCap]
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
    if([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_CHUYEN_TIEN_DEN_VI_MOMO])
    {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
    }
}

#pragma mark - suKien

- (IBAction)suKienBamNutDanhBa:(id)sender
{
    ContactScreen *danhBa = [[[ContactScreen alloc] initWithNibName:@"ContactScreen" bundle:nil] autorelease];
    danhBa.mKieuHienThiLienHe = KIEU_HIEN_THI_LIEN_HE_THUONG;
    [self.navigationController pushViewController:danhBa animated:YES];
    __block ChuyenTienDenViMomoViewController *weakSelf = self;
    [danhBa selectContact:^(NSString *phone,Contact *contact)
     {
         if (phone != nil && phone.length > 0)
         {
             if([Common kiemTraLaMail:phone])
             {
                 weakSelf.mtfViMomo.text = phone;
             }
             else
             {
                 weakSelf.mtfViMomo.text = [phone stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [phone length])];
             }
         }
         [danhBa.navigationController popViewControllerAnimated:YES];
     }];
}


- (IBAction)suKienThayDoiSoTien:(UITextField *)sender
{
    double fSoTien = [[_mtfSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
    if(fSoTien > 0)
        _mtfSoTien.text = [Common hienThiTienTe:fSoTien];
    else
        _mtfSoTien.text = @"";
    [self hienThiSoPhiCuaSoTien:fSoTien];
}


- (void)suKienBamNutThemTaiKhoanThuongDung:(id)sender
{
//    if(!_mTaiKhoanThuongDung)
//        _mTaiKhoanThuongDung = [[DucNT_TaiKhoanThuongDungObject alloc] init];
//    _mTaiKhoanThuongDung.sToAccWallet = _mtfViMomo.text;
    if([_mtfViMomo validate])
    {
        [self.view endEditing:YES];
        [self themDanhSachThuongDung];
    }
}
- (IBAction)suKienBamNuttaiKhoanThuongDung:(id)sender
{
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return;
    }
    DucNT_DanhSachTaiKhoanThuongDungControllerViewController *vc = [[DucNT_DanhSachTaiKhoanThuongDungControllerViewController alloc] initWithType:TAI_KHOAN_VI_KHAC];
    [self.navigationController presentViewController:vc animated:YES completion:^{}];
    [vc release];
}

-(void)updateThongTinViMoMo:(NSNotification *)notification
{
    if([[notification name] isEqualToString:KEY_TAI_KHOAN_THUONG_DUNG])
    {
        self.mTaiKhoanThuongDung = [notification object];
        [self khoiTaoTheoTaiKhoanThuongDung];
    }
}

#pragma mark - xuLy
- (void)hienThiSoPhiCuaSoTien:(double)fSoTien
{
    double fSoPhi = [Common layPhiChuyenTienCuaSoTien:fSoTien kieuChuyenTien:KIEU_CHUYEN_TIEN_DEN_VI_MOMO maNganHang:@""];
    _mtfSoPhi.text = [Common hienThiTienTe_1:fSoPhi];
}

-(void)themDanhSachThuongDung
{
    if(!mViewNhapTenDaiDien.superview)
    {
        if(!_mTaiKhoanThuongDung)
            _mTaiKhoanThuongDung = [[DucNT_TaiKhoanThuongDungObject alloc] init];
        mViewNhapTenDaiDien.frame = self.view.bounds;
        _mTaiKhoanThuongDung.sToAccWallet = self.mtfViMomo.text;
        _mTaiKhoanThuongDung.nAmount = [[self.mtfSoTien.text stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [self.mtfSoTien.text length])] doubleValue];
        _mTaiKhoanThuongDung.sDesc = self.mtvNoiDung.text;
        _mTaiKhoanThuongDung.sPhoneOwner = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
        _mTaiKhoanThuongDung.nType = TAI_KHOAN_MOMO;
        mViewNhapTenDaiDien.mTaiKhoanThuongDung = _mTaiKhoanThuongDung;
        mViewNhapTenDaiDien.mThongTinVi = self.mThongTinTaiKhoanVi;
        [self.view addSubview:mViewNhapTenDaiDien];
    }
}

- (int)layMaNhaCungCap{
    switch (nRowNhaMay) {
        case 0:
            return -1;
        case 1:
            return MOMO;
        case 2:
            return NGAN_LUONG;
        case 3:
            return PAYOO;
        case 4:
            return VIMO;
        case 5:
            return VTC_PAY;
        case 6:
            return NHA_CUNG_CAP_VIVIET;
        case 7:
            return VNPT_PAY;
        case 8:
            return AIR_PAY;
        default:
            break;
    }
    return -1;
}

- (int)layIndexChonVi:(int)nRow {
    switch (nRow) {
        case MOMO:
            return 1;
        case NGAN_LUONG:
            return 2;
        case PAYOO:
            return 3;
        case VIMO:
            return 4;
        case VTC_PAY:
            return 5;
        case NHA_CUNG_CAP_VIVIET:
            return 6;
        case VNPT_PAY:
            return 7;
        case AIR_PAY:
            return 8;
        default:
            break;
    }
    return 0;
}

#pragma mark - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [viewQC release];
    [_mtfViMomo release];
    [_mtfSoTien release];
    [_mtfSoPhi release];
    [_mtvNoiDung release];
    [_edChonVi release];
    [_tfNoiDung release];
    [_viewXacThuc release];
    [_viewThucHien release];
    [_viewSoTien release];
//    [_scrMain release];
    [super dealloc];
}
@end
