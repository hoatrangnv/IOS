//
//  DucNT_ChuyenTienDenTheViewController.m
//  ViMASS
//
//  Created by MacBookPro on 8/2/14.
//
//

#import "DucNT_ChuyenTienDenTheViewController.h"
#import "Common.h"
#import "BankCoreData.h"
#import "BranchCoreData.h"
#import "DucNT_ViewNhapTenDaiDienTaiKhoanThuongDung.h"
#import "ViewNhapTenDaiDienXacThucThemTaiKhoanThuongDung.h"
#import "TPKeyboardAvoidAcessory.h"
#import "GiaoDienThongTinPhim.h"
#import "DucNT_LoginSceen.h"
#import "CommonUtils.h"

@interface DucNT_ChuyenTienDenTheViewController ()
{
    ViewNhapTenDaiDienXacThucThemTaiKhoanThuongDung *mViewNhapTenDaiDien;
    ViewQuangCao *viewQC;
}
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoPhi;
@property (retain, nonatomic) IBOutlet TPKeyboardAvoidAcessory *mscrvHienThi;

@end

@implementation DucNT_ChuyenTienDenTheViewController


#pragma mark - life circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self khoiTaoBanDau];
    [self khoiTaoTextField];
    [self khoiTaoViewNhapTenDaiDienXacThucTaiKhoan];
    
    [self xuLyKetNoiLaySoDuTaiKhoan];
    if(_mTaiKhoanThuongDung)
        [self xuLyCapNhatTaiKhoanThuongDung];
    else
        [self xuLyHienThiSoTienPhiCuaSoTien:@"0"];
    [self addButtonHuongDan];

    self.mbtnToken.hidden = NO;
}


- (void)updateXacThucKhac {
    [super updateXacThucKhac];
}

- (void)showViewNhapToken:(int)type {
    [super showViewNhapToken:type];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.heightMain.constant += 35.0;
        if (viewQC != nil) {
            CGRect rectQC = viewQC.frame;
            rectQC.origin.y += 35.0;
            viewQC.frame = rectQC;
        }
    });
}

- (void)hideViewNhapToken {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.heightMain.constant -= 35.0;
        if (viewQC != nil) {
            CGRect rectQC = viewQC.frame;
            rectQC.origin.y -= 35.0;
            viewQC.frame = rectQC;
        }
    });
}

- (void)suKienBamNutHuongDanGiaoDichViewController:(UIButton *)sender {
    GiaoDienThongTinPhim *vc = [[GiaoDienThongTinPhim alloc] initWithNibName:@"GiaoDienThongTinPhim" bundle:nil];
    vc.nOption = HUONG_DAN_CHUYEN_TIEN_THE;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setAnimationChoSoTay:self.btnSoTay];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view endEditing:YES];
//    [self khoiTaoQuangCao];
//    if(![CommonUtils isEmptyOrNull:self.mThongTinTaiKhoanVi.pki3] && [self.mThongTinTaiKhoanVi.hanMucPki3 doubleValue] >0 ){
//        self.mbtnPKI.hidden = NO;
//    }
//    else{
//        self.mbtnPKI.hidden = YES;
//    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.btnSoTay.imageView stopAnimating];
}

- (void)suKienChonQuangCao:(NSString *)sNameImage {
    [self suKienQuangCaoGoc:sNameImage];
}

#pragma mark - get & set

- (void)setMTaiKhoanThuongDung:(DucNT_TaiKhoanThuongDungObject *)mTaiKhoanThuongDung
{
    if(_mTaiKhoanThuongDung)
        [_mTaiKhoanThuongDung release];
    _mTaiKhoanThuongDung = [mTaiKhoanThuongDung retain];
    _mTaiKhoanThuongDung.sId = @"";
}


#pragma mark - handler error
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - khoiTao

- (void)khoiTaoBanDau
{
    [self addButtonBack];
    if (_nOption == 1) {
        [self addTitleView:[@"financer_viewer_wallet_to_viettel_pay" localizableString]];
    } else {
        [self addTitleView:[@"financer_viewer_wallet_to_BankCard" localizableString]];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateThongTin:) name:KEY_TAI_KHOAN_THUONG_DUNG object:nil];
    
    self.mFuncID = FUNC_TRANSACTION_VIA_CARD_NUMBER;
    
    if (_nOption == 1) {
        _mtfSoTheNganHang.placeholder = [@"tai_khoan_viettel_pay" localizableString];
    } else {
        _mtfSoTheNganHang.placeholder = [@"card_number" localizableString];
    }
    _mtfSoTien.placeholder = [@"amount" localizableString];
}

- (void)khoiTaoViewNhapTenDaiDienXacThucTaiKhoan
{
    if(!mViewNhapTenDaiDien)
    {
        mViewNhapTenDaiDien = [[[[NSBundle mainBundle] loadNibNamed:@"ViewNhapTenDaiDienXacThucThemTaiKhoanThuongDung" owner:self options:nil] objectAtIndex:0] retain];
    }
}

-(void)khoiTaoTextField
{
    [_mtfSoTheNganHang setTextError:[@"so_the_ngan_hang_khong_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    [_mtfSoTheNganHang setType:ExTextFieldTypeCardNumber];
    _mtfSoTheNganHang.max_length = 20;
    _mtfSoTheNganHang.inputAccessoryView = nil;
    
    [_mtfSoTien setTextError:[@"so_tien_khong_duoc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    [_mtfSoTien setTextError:[@"so_tien_khong_hop_le" localizableString]forType:ExTextFieldTypeMoney];
    _mtfSoTien.inputAccessoryView = nil;
}

#pragma mark - overriden GiaoDichViewController

-(BOOL)validateVanTay
{
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return NO;
    }
    NSArray *tfs = @[_mtfSoTheNganHang, _mtfSoTien];
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
    NSLog(@"%s - nHanMucDenThe : %f", __FUNCTION__, [self.mThongTinTaiKhoanVi.nHanMucDenThe doubleValue]);
    if(fSoTien < 10000)
    {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:[@"so_tien_min_den_the_ngan_hang" localizableString]];
        return NO;
    }
    else if (fSoTien >= [self.mThongTinTaiKhoanVi.nAmount doubleValue]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:[@"so_tien_chuyen_di_phai_nho_hon_sodu_tk" localizableString]];
        return NO;
    }
    else if (fSoTien > [self.mThongTinTaiKhoanVi.hanMucTimeSoftToken doubleValue]) {
//        [self.mThongTinTaiKhoanVi.nHanMucDenThe doubleValue]
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:[@"vuot_han_muc" lowercaseString]];
        return NO;
    }
    else if (fSoTien > 50000000) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Số tiền chuyển đi tối đa là 50 triệu đồng"];
        return NO;
    }
    if (_nOption != 1) {
        if ([_mtfSoTheNganHang.text hasPrefix:@"272727"] || [_mtfSoTheNganHang.text hasPrefix:@"272728"] || [_mtfSoTheNganHang.text hasPrefix:@"272729"] || [_mtfSoTheNganHang.text hasPrefix:@"970405"]) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:[@"the_agribank" lowercaseString]];
            return NO;
        }
    }
    
    return flg;
}

- (void)xuLyThucHienKhiKiemTraThanhCongTraVeToken:(NSString*)sToken otp:(NSString*)sOtp
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_CHUYEN_TIEN_VE_THE;
        NSString *sSoTien = [_mtfSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""];
        double fSoTien = [sSoTien doubleValue];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
            [self hienThiLoading];
        }
        [GiaoDichMang ketNoiChuyenTienDenThe:_mtfSoTheNganHang.text
                                      soTien:fSoTien
                                       token:sToken
                                         otp:sOtp
                            typeAuthenticate:self.mTypeAuthenticate
                               noiNhanKetQua:self];
    });
}

- (void)xuLyKetNoiThanhCong:(NSString*)sDinhDanhKetNoi thongBao:(NSString*)sThongBao ketQua:(id)ketQua
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self anLoading];
    }
    if([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_CHUYEN_TIEN_VE_THE])
        [self hienThiHopThoaiMotNutBamKieu:HOP_THOAI_XAC_NHAN_CHUYEN_TIEN_THANH_CONG cauThongBao:sThongBao];
}

#pragma mark - suKien

- (IBAction)suKienLuuTaiKhoanThuongDung:(id)sender
{
    [self themTaiKhoanThuongDung];
}

- (IBAction)suKienLayDanhSachThuongDung:(id)sender {
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return;
    }
    DucNT_DanhSachTaiKhoanThuongDungControllerViewController *vc = [[DucNT_DanhSachTaiKhoanThuongDungControllerViewController alloc] initWithType:TAI_KHOAN_THE];
    [self.navigationController presentViewController:vc animated:YES completion:^{}];
    [vc release];
}

- (IBAction)editSoTien:(id)sender
{
    NSString *sSoTien = [self.mtfSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    self.mtfSoTien.text = [Common hienThiTienTeFromString:sSoTien];
    
    double fSoTien = [sSoTien doubleValue];
    double fHanMucToken = [self.mThongTinTaiKhoanVi.hanMucTimeSoftToken doubleValue];
    if (fSoTien > fHanMucToken) {
        double fHanMucPKI = [self.mThongTinTaiKhoanVi.hanMucTimeMPKI doubleValue];
        NSLog(@"%s - sSoTien : %@ - fHanMucPKI : %f", __FUNCTION__, sSoTien, fHanMucPKI);
        if (fSoTien <= fHanMucPKI) {
            self.mbtnPKI.hidden = NO;
            self.btnVanTayMini.hidden = YES;
            self.mbtnToken.hidden = YES;
        } else {
            self.mbtnPKI.hidden = YES;
            self.btnVanTayMini.hidden = YES;
            self.mbtnToken.hidden = YES;
        }
    } else {
        self.mbtnPKI.hidden = NO;
        self.btnVanTayMini.hidden = NO;
        self.mbtnToken.hidden = NO;
    }
    
    [self xuLyHienThiSoTienPhiCuaSoTien:sSoTien];
    
}

#pragma mark - xuLy

- (void)xuLyCapNhatTaiKhoanThuongDung
{
    self.mtfSoTheNganHang.text = _mTaiKhoanThuongDung.sCardNumber;
    [self xuLyHienThiSoTienPhiCuaSoTien:[NSString stringWithFormat:@"%f", _mTaiKhoanThuongDung.nAmount]];
    if(_mTaiKhoanThuongDung.nAmount != 0)
    {
        self.mtfSoTien.text = [Common hienThiTienTe:_mTaiKhoanThuongDung.nAmount];
    }
    else
    {
        self.mtfSoTien.text = @"";
    }
}

- (void)xuLyHienThiSoTienPhiCuaSoTien:(NSString*)sSoTien
{
    double fSoPhi = [Common layPhiChuyenTienCuaSoTien:[sSoTien doubleValue] kieuChuyenTien:KIEU_CHUYEN_TIEN_DEN_THE maNganHang:@""];
    self.mtfSoPhi.text = [Common hienThiTienTe_1:fSoPhi];
}

-(void)updateThongTin:(NSNotification *)notification
{
    if([[notification name] isEqualToString:KEY_TAI_KHOAN_THUONG_DUNG])
    {
        self.mTaiKhoanThuongDung = [notification object];
        [self xuLyCapNhatTaiKhoanThuongDung];
    }
    else
    {
        NSLog(@"%s >> %s line: %d >> ko nhan notification ",__FILE__,__FUNCTION__ ,__LINE__);
    }
}

-(void)themTaiKhoanThuongDung
{
    if([self validateVanTay] && !mViewNhapTenDaiDien.superview)
    {
        mViewNhapTenDaiDien.frame = self.mscrvHienThi.frame;
        if(!_mTaiKhoanThuongDung)
            _mTaiKhoanThuongDung = [[DucNT_TaiKhoanThuongDungObject alloc] init];
        _mTaiKhoanThuongDung.sPhoneOwner = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
        _mTaiKhoanThuongDung.nType = TAI_KHOAN_THE;
        _mTaiKhoanThuongDung.sCardNumber = self.mtfSoTheNganHang.text;
        _mTaiKhoanThuongDung.nAmount = [[self.mtfSoTien.text stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [_mtfSoTien.text length])] doubleValue];
        mViewNhapTenDaiDien.mTaiKhoanThuongDung = _mTaiKhoanThuongDung;
        mViewNhapTenDaiDien.mThongTinVi = self.mThongTinTaiKhoanVi;
        [self.view addSubview:mViewNhapTenDaiDien];
        [self.view endEditing:YES];
    }
}

- (void)suKienBamNutVi:(UIButton *)sender {
    [super suKienBamNutVi:sender];
    [self.webGioiThieuTaiKhoan setHidden:YES];
    [self.mViewMain setHidden:NO];
}

- (void)suKienBamNutTaiKhoan:(UIButton *)sender {
    [super suKienBamNutTaiKhoan:sender];
    [self.webGioiThieuTaiKhoan setHidden:NO];
    [self.mViewMain setHidden:YES];
}

#pragma mark - dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s - release viewQC", __FUNCTION__);
    [viewQC release];
    NSLog(@"%s - end release viewQC", __FUNCTION__);
    if(mViewNhapTenDaiDien)
        [mViewNhapTenDaiDien release];
    [_mtfSoPhi release];
//    [_mscrvHienThi release];
    [_mbtnLuuTaiKhoanThuongDung release];
    [_viewCenter release];
    [_heightMain release];
    [super dealloc];
}


@end
