//
//  ChuyenTienTanNhaViewController.m
//  ViViMASS
//
//  Created by DucBui on 7/8/15.
//
//

#import "ChuyenTienTanNhaViewController.h"
#import "ChonTinhThanhViewController.h"
#import "DoiTuongTinhThanh.h"
#import "DucNT_DanhSachTaiKhoanThuongDungControllerViewController.h"
#import "ViewNhapTenDaiDienXacThucThemTaiKhoanThuongDung.h"
#import "GiaoDienThongTinPhim.h"
#import "DucNT_LoginSceen.h"

#define DINH_DANH_CHUYEN_TIEN_MAT_VE_TAN_NHA_BANK_PLUS @"DINH_DANH_CHUYEN_TIEN_MAT_VE_TAN_NHA_BANK_PLUS"

@interface ChuyenTienTanNhaViewController () <UITextFieldDelegate, ChonTinhThanhViewControllerDelegate>{
    ViewNhapTenDaiDienXacThucThemTaiKhoanThuongDung *mViewNhapTenDaiDien;
    ViewQuangCao *viewQC;
}


@property (nonatomic, retain) NSArray *mDanhSachTinhThanh;
@property (nonatomic, retain) DoiTuongTinhThanh *mTinhThanhDuocChon;
@property (nonatomic, retain) DoiTuongQuanHuyen *mQuanHuyenDuocChon;
@property (nonatomic, assign) BOOL mChonNhapQuanHuyen;
@property (nonatomic, retain) DoiTuongPhuongXa *mPhuongXaDuocChon;
@property (nonatomic, assign) BOOL mChonNhapPhuongXa;

@end

@implementation ChuyenTienTanNhaViewController

#pragma mark - overriden GiaoDichViewController

- (BOOL)validateVanTay
{
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return NO;
    }
    NSArray *tfs = @[_mtfHoTenNguoiNhan, _mtfCMNDNguoiNhan, _mtfSoTien, _mtfSoDienThoaiNguoiNhan, _mtfTinhThanhPho, _mtfQuanHuyen, _mtfPhuongXa];
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

    if([[_mtvTenDuong.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
    {
        [_mtfTenDuong show_error];
        return NO;
    }

    double fSoTien = [[_mtfSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
    if (fSoTien <= 2000000000) {
        [UIAlertView alert:[@"thong_bao_limit_so_tien_mot_lan_giao_dich_chuyen_ve_tan_nha" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
        return NO;
    }
    int nTemp = (int)fSoTien / 5000000;
    double fPhanDu = fSoTien - nTemp * 5000000.0f;
    if(fPhanDu < 100000)
    {
        [UIAlertView alert:[@"thong_bao_phan_du_so_tien_mot_lan_giao_dich_chuyen_ve_tan_nha" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
        return NO;
    }
    
    if(fSoTien < 100000)
    {
        [UIAlertView alert:[@"thong_bao_so_tien_mot_lan_giao_dich_chuyen_ve_tan_nha" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
        return NO;
    }
    return flg;
}

- (void)xuLyThucHienKhiKiemTraThanhCongTraVeToken:(NSString*)sToken otp:(NSString*)sOtp
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
            [self hienThiLoading];
        }
        self.mDinhDanhKetNoi = DINH_DANH_CHUYEN_TIEN_MAT_VE_TAN_NHA_BANK_PLUS;
        double fSoTien = [[_mtfSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
        [GiaoDichMang ketNoiChuyenTienDenTanNhaCho:_mtfHoTenNguoiNhan.text
                          soDienThoaiNguoiThuHuong:_mtfSoDienThoaiNguoiNhan.text
                                            soTien:fSoTien
                               soCMNDNguoiThuHuong:_mtfCMNDNguoiNhan.text
                                         tinhThanh:_mtfTinhThanhPho.text
                                         quanHuyen:_mtfQuanHuyen.text
                                          phuongXa:_mtfPhuongXa.text
                                            diaChi:_mtvTenDuong.text
                                           noiDung:_mtvNoiDung.text
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
    if([sDinhDanhKetNoi isEqualToString:DINH_DANH_CHUYEN_TIEN_MAT_VE_TAN_NHA_BANK_PLUS])
    {
        [self hienThiHopThoaiMotNutBamKieu:HOP_THOAI_XAC_NHAN_CHUYEN_TIEN_THANH_CONG cauThongBao:sThongBao];
    }
}

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateThongTin:) name:KEY_TAI_KHOAN_THUONG_DUNG object:nil];
    
    [self khoiTaoBanDau];
    self.mDanhSachTinhThanh = [DoiTuongTinhThanh layDanhSachTinhThanh];
    [self setAnimationChoSoTay:self.btnSoTay];
    [self addButtonHuongDan];
    NSLog(@"%s - self.mViewMain.frame.size.width : %f", __FUNCTION__, self.mViewMain.frame.size.width);
    CGRect frame = self.mViewMain.frame;
    frame.size.width = self.viewOptionTop.frame.size.width;
    self.mViewMain.frame = frame;
}

- (void)khoiTaoQuangCao {
    if (!viewQC) {
        viewQC = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ViewQuangCao class]) owner:self options:nil] objectAtIndex:0];
        viewQC.mDelegate = self;
        CGRect rectToken = self.mViewTenDuongSonha.frame;
        CGRect rectQC = viewQC.frame;
        CGRect rectMain = self.mViewMain.frame;
//        CGRect rectTenDuong = self.mViewTenDuongSonha.frame;
        CGFloat fW = rectMain.size.width;
        CGFloat fH = fW * 0.46;
        rectQC.origin.y = rectToken.origin.y + rectToken.size.height;
        viewQC.frame = CGRectMake(0, rectQC.origin.y, fW, fH);
        viewQC.mDelegate = self;
        [viewQC updateSizeQuangCao];
        [self.mViewMain addSubview:viewQC];
//        rectTenDuong.size.height = rectQC.origin.y + rectQC.size.height + 10;
//        rectMain.size.height = rectTenDuong.origin.y + rectTenDuong.size.height;
//        self.mViewTenDuongSonha.frame = rectTenDuong;
        self.heightViewMain.constant = rectQC.origin.y + rectQC.size.height;
        
        [self.mScrView setContentSize:CGSizeMake(_mScrView.frame.size.width, self.heightViewMain.constant + 10)];
    }
}

- (void)suKienBamNutHuongDanGiaoDichViewController:(UIButton *)sender {
    GiaoDienThongTinPhim *vc = [[GiaoDienThongTinPhim alloc] initWithNibName:@"GiaoDienThongTinPhim" bundle:nil];
    vc.nOption = HUONG_DAN_CHUYEN_TIEN_TAN_NHA;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self khoiTaoQuangCao];
    [_mtvTenDuong resignFirstResponder];
//    self.btnVanTayMini.enabled = true;
    [self.mScrView setContentSize:CGSizeMake(self.mScrView.frame.size.width, 650.0)];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.btnSoTay.imageView stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showViewNhapToken:(int)type {
    [super showViewNhapToken:type];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.heightViewMain.constant += 35.0;
        [self.mScrView setContentSize:CGSizeMake(_mScrView.frame.size.width, self.heightViewMain.constant + 10)];
        if (viewQC != nil) {
            CGRect rectQC = viewQC.frame;
            rectQC.origin.y += 35.0;
            viewQC.frame = rectQC;
        }
    });
}

- (void)hideViewNhapToken {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.heightViewMain.constant -= 35.0;
        [self.mScrView setContentSize:CGSizeMake(_mScrView.frame.size.width, self.heightViewMain.constant + 10)];
        if (viewQC != nil) {
            CGRect rectQC = viewQC.frame;
            rectQC.origin.y -= 35.0;
            viewQC.frame = rectQC;
        }
    });
}

#pragma mark - KhoiTao

- (void)khoiTaoBanDau
{
    [self addButtonBack];
    self.mFuncID = FUNC_BANKPLUS_CHUYEN_TIEN_MAT;
//    self.navigationItem.title = @"Chuyển tiền tận nhà";
    [self addTitleView:[@"financer_viewer_wallet_to_home" localizableString]];
    [self khoiTaoGiaoDien];
    self.mChonNhapQuanHuyen = NO;
    self.mChonNhapPhuongXa = NO;
    [self khoiTaoTextField];
    [self xuLyHienThiSoPhi:0];
}

- (void)khoiTaoGiaoDien
{
    float fHeight = 0.0f;
    [self.viewOptionTop setHidden:YES];
    CGRect rectTop = self.viewOptionTop.frame;
    CGRect rViewMain = self.mViewMain.frame;
    CGRect rBtnVanTay = self.mbtnVanTay.frame;
    rViewMain.origin.y = 5.0;
    rViewMain.origin.x = 5.0;
    rViewMain.size.width = [UIScreen mainScreen].bounds.size.width - 10.0;
    if([self kiemTraCoChucNangQuetVanTay])
    {
        rBtnVanTay.origin.y = rViewMain.origin.y + rViewMain.size.height + 20.0f;
        fHeight = rBtnVanTay.origin.y + rBtnVanTay.size.height + 10.0f;
    }
    else
    {
        fHeight = 2*rViewMain.origin.y + rViewMain.size.height;
    }
    
    self.mViewMain.frame = rViewMain;
    self.mbtnVanTay.frame = rBtnVanTay;
    
    [_mScrView addSubview:self.mViewMain];
//    [_mScrView bringSubviewToFront:self.viewOptionTop];
    [_mScrView setContentSize:CGSizeMake(_mScrView.frame.size.width, fHeight)];
    
    _mtfHoTenNguoiNhan.placeholder = [@"ho_ten_nguoi_nhan" localizableString];
    _mtfCMNDNguoiNhan.placeholder = [@"cmnd_nguoi_nhan" localizableString];
    _mtfSoTien.placeholder = [@"amount" localizableString];
    _mtfSoDienThoaiNguoiNhan.placeholder = [@"sdt_nguoi_nhan" localizableString];
    _mtfTinhThanhPho.placeholder = [@"register_account_link_province" localizableString];
    _mtfQuanHuyen.placeholder = [@"quan_huyen" localizableString];
    _mtfPhuongXa.placeholder = [@"phuong_xa" localizableString];
    _mtfTenDuong.placeholder = [@"ten_duong_so_nha" localizableString];
    _tvNoiDung.placeholder = [@"description" localizableString];
}

- (void)khoiTaoTextField
{
    [_mtfHoTenNguoiNhan setTextError:[@"transfer_toId_invalid_receiver_name" localizableString] forType:ExTextFieldTypeEmpty];
    [_mtfHoTenNguoiNhan setInputAccessoryView:nil];
    
    [_mtfCMNDNguoiNhan setTextError:[@"transfer_empty_ID_number" localizableString] forType:ExTextFieldTypeEmpty];
    _mtfCMNDNguoiNhan.inputAccessoryView = nil;
    
    
    [_mtfSoTien setTextError:[@"so_tien_khong_duoc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    _mtfSoTien.type = ExTextFieldTypeMoney;
    _mtfSoTien.inputAccessoryView = nil;
    
    [_mtfSoDienThoaiNguoiNhan setTextError:[@"so_dien_thoai_khong_duoc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    _mtfSoDienThoaiNguoiNhan.type = ExTextFieldTypePhone;
    _mtfSoDienThoaiNguoiNhan.inputAccessoryView = nil;
    
    [_mtfTinhThanhPho setTextError:[@"tinh_thanh_khong_duoc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    _mtfTinhThanhPho.inputAccessoryView = nil;
    
    [_mtfQuanHuyen setTextError:[@"quan_huyen_khong_duoc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    _mtfQuanHuyen.inputAccessoryView = nil;
    
    [_mtfPhuongXa setTextError:[@"phuong_xa_khong_duoc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    _mtfPhuongXa.inputAccessoryView = nil;
    
    [_mtfTenDuong setTextError:[@"ten_duong_khong_duoc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    _mtfTenDuong.inputAccessoryView = nil;
    
    _mtvNoiDung.inputAccessoryView = nil;

}

- (void)suKienBamNutAddAccUser{
    NSLog(@"ChuyenTienTanNhaViewControler : suKienBamNutAddAccUser : add user");
    if(![self validateVanTay])
        return;
    if(!mViewNhapTenDaiDien)
    {
        mViewNhapTenDaiDien = [[[[NSBundle mainBundle] loadNibNamed:@"ViewNhapTenDaiDienXacThucThemTaiKhoanThuongDung" owner:self options:nil] objectAtIndex:0] retain];
    }
    if(!mViewNhapTenDaiDien.superview)
    {
        if(!_mTaiKhoanThuongDung)
            _mTaiKhoanThuongDung = [[DucNT_TaiKhoanThuongDungObject alloc] init];
        mViewNhapTenDaiDien.frame = self.view.bounds;
        _mTaiKhoanThuongDung.tenNguoiThuHuong = self.mtfHoTenNguoiNhan.text;
        _mTaiKhoanThuongDung.cellphoneNumber = self.mtfSoDienThoaiNguoiNhan.text;
        _mTaiKhoanThuongDung.soTien = [[self.mtfSoTien.text stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [self.mtfSoTien.text length])] intValue];
        _mTaiKhoanThuongDung.cmnd = self.mtfCMNDNguoiNhan.text;
        _mTaiKhoanThuongDung.tinhThanh = _mTinhThanhDuocChon.mTen;
        _mTaiKhoanThuongDung.quanHuyen = _mQuanHuyenDuocChon.mTen;
        _mTaiKhoanThuongDung.phuongXa = _mPhuongXaDuocChon.mTen;
        _mTaiKhoanThuongDung.diaChi = self.mtvTenDuong.text;
        _mTaiKhoanThuongDung.noiDung = self.mtvNoiDung.text;
        _mTaiKhoanThuongDung.sPhoneOwner = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
        _mTaiKhoanThuongDung.nType = TAI_KHOAN_TAN_NHA;
        mViewNhapTenDaiDien.mTaiKhoanThuongDung = _mTaiKhoanThuongDung;
        mViewNhapTenDaiDien.mThongTinVi = self.mThongTinTaiKhoanVi;
//        _mTaiKhoanThuongDung.sToAccWallet = self.mtfViMomo.text;
//        _mTaiKhoanThuongDung.nAmount = [[self.mtfSoTien.text stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [self.mtfSoTien.text length])] doubleValue];
//        _mTaiKhoanThuongDung.sDesc = self.mtvNoiDung.text;
//        _mTaiKhoanThuongDung.sPhoneOwner = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
//        _mTaiKhoanThuongDung.nType = TAI_KHOAN_MOMO;
//        mViewNhapTenDaiDien.mTaiKhoanThuongDung = _mTaiKhoanThuongDung;
//        mViewNhapTenDaiDien.mThongTinVi = self.mThongTinTaiKhoanVi;
        [self.view addSubview:mViewNhapTenDaiDien];
    }
}

#pragma mark - suKien

- (IBAction)suKienThayDoiSoTien:(id)sender
{
    [self thayDoiSoTienChuyen];
}

- (void)thayDoiSoTienChuyen{
    NSString *sSoTien = [_mtfSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    if([sSoTien doubleValue] > 0)
        _mtfSoTien.text = [Common hienThiTienTeFromString:sSoTien];
    else
        _mtfSoTien.text = @"";

    [self xuLyHienThiSoPhi:[sSoTien doubleValue]];
}

#pragma mark - xuLy

- (void)xuLyHienThiSoPhi:(double)fSoTien
{
    float fSoTienPhi = 0;
//    [Common layPhiChuyenTienCuaSoTien:fSoTien kieuChuyenTien:KIEU_CHUYEN_TIEN_DEN_TAN_NHA maNganHang:@""];
    if (![self.mtfQuanHuyen.text containsString:@"*"]) {
        fSoTienPhi = [Common layPhiChuyenTienTanNha:fSoTien nKhuVuc:1];
    }
    else{
        fSoTienPhi = [Common layPhiChuyenTienTanNha:fSoTien nKhuVuc:0];
    }
    NSString *sSoPhi = [NSString stringWithFormat:@"%@ đ", [Common hienThiTienTe:fSoTienPhi]];
    self.mtfSoPhi.text = sSoPhi;
}

- (void)xuLyHienThiViewChonDiaDiem:(NSArray*)danhSachDiaDiem tieuDe:(NSString*)sTieuDeView kieuView:(NSInteger)nKieuView
{
    ChonTinhThanhViewController *chonTinhThanhViewController = [[ChonTinhThanhViewController alloc] initWithNibName:@"ChonTinhThanhViewController" bundle:nil];
    chonTinhThanhViewController.mDanhSachDiaDiem = danhSachDiaDiem;
    chonTinhThanhViewController.mTitle = sTieuDeView;
    chonTinhThanhViewController.mKieuChon = nKieuView;
    chonTinhThanhViewController.mDelegate = self;
    [self presentViewController:chonTinhThanhViewController animated:YES completion:nil];
    [chonTinhThanhViewController release];
    
}

- (void)xuLyHienThiSauKhiChonTinhThanhPho
{
    _mtfTinhThanhPho.text = _mTinhThanhDuocChon.mTen;
    _mtfQuanHuyen.text = @"";
    _mtfPhuongXa.text = @"";
    self.mQuanHuyenDuocChon = nil;
    self.mChonNhapQuanHuyen = NO;
    self.mPhuongXaDuocChon = nil;
    self.mChonNhapPhuongXa = NO;
    
    CGRect rViewTenDuongSoNha = _mViewTenDuongSonha.frame;
    CGRect rViewMain = self.mViewMain.frame;
    CGRect rbtnVanTay = self.mbtnVanTay.frame;
    rViewTenDuongSoNha.origin.y = _mtfPhuongXa.frame.origin.y;
    rViewMain.size.height = rViewTenDuongSoNha.origin.y + rViewTenDuongSoNha.size.height + 20.0f;
    
    float fHeight = 0.0f;
    if([self kiemTraCoChucNangQuetVanTay])
    {
        rbtnVanTay.origin.y = rViewMain.size.height + rViewMain.origin.y + 20.0f;
        fHeight = rbtnVanTay.origin.y + rbtnVanTay.size.height + 10.0f;
    }
    else
    {
        fHeight = 2 * rViewMain.origin.y + rViewMain.size.height;
    }

    _mViewTenDuongSonha.frame = rViewTenDuongSoNha;
    self.mViewMain.frame = rViewMain;
    self.mbtnVanTay.frame = rbtnVanTay;
    [_mScrView setContentSize:CGSizeMake(_mScrView.frame.size.width, fHeight)];
}

- (void)xuLyHienThiSauKhiChonQuanHuyen
{
    if(_mQuanHuyenDuocChon)
        _mtfQuanHuyen.text = _mQuanHuyenDuocChon.mTen;
    else
    {
        _mtfQuanHuyen.text = @"";
        [_mtfQuanHuyen becomeFirstResponder];
    }
    [self thayDoiSoTienChuyen];
    _mtfPhuongXa.text = @"";
    self.mPhuongXaDuocChon = nil;
    self.mChonNhapPhuongXa = NO;
    
    CGRect rViewTenDuongSoNha = _mViewTenDuongSonha.frame;
    CGRect rViewMain = self.mViewMain.frame;
    CGRect rbtnVanTay = self.mbtnVanTay.frame;
    rViewTenDuongSoNha.origin.y = _mtfPhuongXa.frame.origin.y + _mtfPhuongXa.frame.size.height + 8;
    rViewMain.size.height = rViewTenDuongSoNha.origin.y + rViewTenDuongSoNha.size.height + 20.0f;
    
    float fHeight = 0.0f;
    if([self kiemTraCoChucNangQuetVanTay])
    {
        rbtnVanTay.origin.y = rViewMain.size.height + rViewMain.origin.y + 20.0f;
        fHeight = rbtnVanTay.origin.y + rbtnVanTay.size.height + 10.0f;
    }
    else
    {
        fHeight = 2*rViewMain.origin.y + rViewMain.size.height;
    }
    _mViewTenDuongSonha.frame = rViewTenDuongSoNha;
    self.mViewMain.frame = rViewMain;
    self.mbtnVanTay.frame = rbtnVanTay;
    [_mScrView setContentSize:CGSizeMake(_mScrView.frame.size.width, fHeight)];
}

- (void)xuLyHienThiSauKhiChonPhuongXa
{
    if(_mPhuongXaDuocChon)
        _mtfPhuongXa.text = _mPhuongXaDuocChon.mTen;
    else
    {
        _mtfPhuongXa.text = @"";
        [_mtfPhuongXa becomeFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == _mtfTinhThanhPho)
    {
        //Dung cai nay de dau keyboard :(.
        //Khong hieu sao self.view endEditing khong lam viec
//        [_mScrView scrollRectToVisible:CGRectMake(0, 0, 0, 0) animated:YES];
        [textField resignFirstResponder];
        [self xuLyHienThiViewChonDiaDiem:self.mDanhSachTinhThanh tieuDe:@"Chọn tỉnh thành" kieuView:KIEU_CHON_TINH_THANH];
    }
    else if (textField == _mtfQuanHuyen)
    {
        if(!self.mChonNhapQuanHuyen)
        {
            [textField resignFirstResponder];
            [self xuLyHienThiViewChonDiaDiem:self.mTinhThanhDuocChon.dsQuanHuyen tieuDe:@"Chọn Quận Huyện" kieuView:KIEU_CHON_QUAN_HUYEN];
        }
    }
    else if(textField == _mtfPhuongXa)
    {
        if(_mQuanHuyenDuocChon && !self.mChonNhapPhuongXa)
        {
            [textField resignFirstResponder];
            [self xuLyHienThiViewChonDiaDiem:self.mQuanHuyenDuocChon.dsPhuongXa tieuDe:@"Chọn Phường Xã" kieuView:KIEU_CHON_PHUONG_XA];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == _mtfQuanHuyen)
    {
        if(!_mQuanHuyenDuocChon)
        {
            if([textField.text isEqualToString:@""])
                self.mChonNhapQuanHuyen = NO;
            else
                self.mChonNhapQuanHuyen = YES;
        }
    }
    else if(textField == _mtfPhuongXa)
    {
        if(!_mPhuongXaDuocChon)
        {
            if([textField.text isEqualToString:@""] && _mQuanHuyenDuocChon)
                self.mChonNhapPhuongXa = NO;
            else
                self.mChonNhapPhuongXa = YES;
        }
    }
}

#pragma mark - ChonTinhThanhViewControllerDelegate

- (void)suKienChonDoiTuongDiaDiem:(DoiTuongDiaDiem*)doiTuongDiaDiem kieuChon:(NSInteger)nKieuChon
{
    if(nKieuChon == KIEU_CHON_TINH_THANH)
    {
        self.mTinhThanhDuocChon = (DoiTuongTinhThanh*)doiTuongDiaDiem;
        [self xuLyHienThiSauKhiChonTinhThanhPho];
    }
    else if(nKieuChon == KIEU_CHON_QUAN_HUYEN)
    {
        self.mQuanHuyenDuocChon = (DoiTuongQuanHuyen*)doiTuongDiaDiem;
        if(doiTuongDiaDiem)
        {
            self.mChonNhapQuanHuyen = NO;
            self.mChonNhapPhuongXa = NO;
        }
        else
        {
            self.mChonNhapQuanHuyen = YES;
            self.mChonNhapPhuongXa = YES;
        }
        [self xuLyHienThiSauKhiChonQuanHuyen];
    }
    else if(nKieuChon == KIEU_CHON_PHUONG_XA)
    {
        self.mPhuongXaDuocChon = (DoiTuongPhuongXa*)doiTuongDiaDiem;
        if(doiTuongDiaDiem)
            self.mChonNhapPhuongXa = NO;
        else
            self.mChonNhapPhuongXa = YES;
        [self xuLyHienThiSauKhiChonPhuongXa];
    }
}

- (void)dealloc {
    if(_mTaiKhoanThuongDung)
        [_mTaiKhoanThuongDung release];
    if (_mDanhSachTinhThanh) {
        [_mDanhSachTinhThanh release];
    }
    [viewQC release];
    [_mtfSoTien release];
    [_mtfSoPhi release];
    [_mtfTinhThanhPho release];
    [_mtfQuanHuyen release];
    [_mtfPhuongXa release];
    [_mtfTenDuong release];
    [_mtfSoDienThoaiNguoiNhan release];
    [_mtfHoTenNguoiNhan release];
    [_mtfCMNDNguoiNhan release];
    [_mtvNoiDung release];
    [_mViewTenDuongSonha release];
    [_mtvTenDuong release];
//    [_mScrView release];
    [_heightViewMain release];
    [_tvNoiDung release];
    [super dealloc];
}

- (IBAction)suKienBamNutThuongDung:(id)sender {
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return;
    }
    DucNT_DanhSachTaiKhoanThuongDungControllerViewController *vc = [[DucNT_DanhSachTaiKhoanThuongDungControllerViewController alloc] initWithType:TAI_KHOAN_TAN_NHA];
    [self.navigationController presentViewController:vc animated:YES completion:^{}];
    [vc release];
}

-(void)updateThongTin:(NSNotification *)notification
{
    NSLog(@"ChuyenTienTanNhaViewController : updateThongTin : name : %@", [notification name]);
    if([[notification name] isEqualToString:KEY_TAI_KHOAN_THUONG_DUNG])
    {
        self.mTaiKhoanThuongDung = [notification object];
        NSLog(@"ChuyenTienTanNhaViewController : updateThongTin : thuHuong : %@", self.mTaiKhoanThuongDung.tenNguoiThuHuong);
        [self.mtfHoTenNguoiNhan setText:self.mTaiKhoanThuongDung.tenNguoiThuHuong];
        [self.mtfCMNDNguoiNhan setText:self.mTaiKhoanThuongDung.cmnd];
        [self.mtfSoDienThoaiNguoiNhan setText:self.mTaiKhoanThuongDung.cellphoneNumber];
        for (DoiTuongTinhThanh *item in _mDanhSachTinhThanh) {
            if([item.mTen isEqualToString:self.mTaiKhoanThuongDung.tinhThanh]){
                _mTinhThanhDuocChon = item;
                [self.mtfTinhThanhPho setText:self.mTaiKhoanThuongDung.tinhThanh];
//                [self xuLyHienThiSauKhiChonTinhThanhPho];
                break;
            }
        }
        if (_mTinhThanhDuocChon) {
            for (DoiTuongQuanHuyen *item in _mTinhThanhDuocChon.dsQuanHuyen) {
                if ([item.mTen isEqualToString:self.mTaiKhoanThuongDung.quanHuyen]) {
                    _mQuanHuyenDuocChon = item;
                    [self.mtfQuanHuyen setText:self.mTaiKhoanThuongDung.quanHuyen];
                    break;
                }
            }
        }
        if (_mQuanHuyenDuocChon) {
            self.mChonNhapQuanHuyen = NO;
            self.mChonNhapPhuongXa = NO;
        }
        else{
            self.mChonNhapQuanHuyen = YES;
            self.mChonNhapPhuongXa = YES;
        }
//        [self xuLyHienThiSauKhiChonQuanHuyen];
        
        if (_mQuanHuyenDuocChon) {
            for (DoiTuongPhuongXa *item in _mQuanHuyenDuocChon.dsPhuongXa) {
                if ([item.mTen isEqualToString:self.mTaiKhoanThuongDung.phuongXa]) {
                    _mPhuongXaDuocChon = item;
                    [self.mtvTenDuong setText:self.mTaiKhoanThuongDung.diaChi];
                    self.mChonNhapPhuongXa = YES;
                    break;
                }
                self.mChonNhapPhuongXa = NO;
            }
        }
//        [self xuLyHienThiSauKhiChonPhuongXa];
        
        NSLog(@"ChuyenTienTanNhaViewController : updateThongTin : soTien : %d", self.mTaiKhoanThuongDung.soTien);
        NSString *sSoTien = [Common hienThiTienTe:self.mTaiKhoanThuongDung.soTien];
        [self.mtfSoTien setText:sSoTien];
        [self xuLyHienThiSoPhi:self.mTaiKhoanThuongDung.soTien];
    }
}

@end
