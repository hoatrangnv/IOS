//
//  DucNT_ChuyenTienDenTaiKhoanViewController.m
//  ViMASS
//
//  Created by MacBookPro on 7/30/14.
//
//

#import "DucNT_ChuyenTienDenTaiKhoanViewController.h"
#import "DucNT_DanhSachTaiKhoanThuongDungControllerViewController.h"
#import "DucNT_TaiKhoanThuongDungObject.h"
#import "DucNT_ViewNhapTenDaiDienTaiKhoanThuongDung.h"
#import "DucNT_ViewPicker.h"
#import "ProvinceCoreData.h"
#import "BranchCoreData.h"
#import "BankCoreData.h"
#import "ContactScreen.h"
#import "DucNT_Token.h"
#import "ViewNhapTenDaiDienXacThucThemTaiKhoanThuongDung.h"
#import "TPKeyboardAvoidAcessory.h"
#import "GiaoDienThongTinPhim.h"
#import "ViewQuangCao.h"
#import "DucNT_LoginSceen.h"
#import "CommonUtils.h"
@interface DucNT_ChuyenTienDenTaiKhoanViewController ()<UITextFieldDelegate>
{
    ViewNhapTenDaiDienXacThucThemTaiKhoanThuongDung *mViewNhapTenDaiDien;
    DucNT_ViewPicker *mViewPickerNganHang;
    int mViTriNganHangDuocChon;
    IBOutlet TPKeyboardAvoidAcessory *mScrv;
//    ExTextField *mtfChiNhanhKhac;
    NSMutableArray *arrChiNhanhBank;
    ViewQuangCao *viewQC;
}

@end

@implementation DucNT_ChuyenTienDenTaiKhoanViewController


#pragma mark - init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        mViTriNganHangDuocChon = -1;
    }
    return self;
}

#pragma mark - life circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self khoiTaoBanDau];
    [self khoiTaoTextField];
    [self khoiTaoViewPickerNganHang];
    [self khoiTaoViewNhapTenDaiDienXacThucTaiKhoan];
    [self xuLyKetNoiLaySoDuTaiKhoan];
    if(_mTaiKhoanThuongDung)
        [self xuLyCapNhatTaiKhoanThuongDung];
    else
        [self xuLyHienThiSoTienPhiCuaSoTien:@"0"];
    [self themButtonHuongDanSuDung:@selector(huongDanChuyenTienDenTaiKhoan:)];
    [self addRightButtonForPicker:_edtNganHang];
    
    self.mbtnToken.hidden = NO;
}

- (void)updateXacThucKhac {
    [super updateXacThucKhac];
}

- (void)showViewNhapToken:(int)type {
    [super showViewNhapToken:type];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.heightViewMain.constant += 35.0;
        if (viewQC != nil) {
            CGRect rectToken = self.mViewNhapToken.frame;
            CGRect rectQC = viewQC.frame;
            rectQC.origin.y = rectToken.origin.y + self.heightViewNhapXacThuc.constant + 15.0;
            viewQC.frame = rectQC;
        }
    });
}

- (void)hideViewNhapToken {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.heightViewMain.constant -= 35.0;
        if (viewQC != nil) {
            CGRect rectQC = viewQC.frame;
            rectQC.origin.y -= 35.0;
            viewQC.frame = rectQC;
        }
    });
}

- (void)suKienChonQuangCao:(NSString *)sNameImage {
    [self suKienQuangCaoGoc:sNameImage];
}

- (void)huongDanChuyenTienDenTaiKhoan:(UIButton *)sender {
    GiaoDienThongTinPhim *vc = [[GiaoDienThongTinPhim alloc] initWithNibName:@"GiaoDienThongTinPhim" bundle:nil];
    vc.nOption = HUONG_DAN_CHUYEN_TIEN_TAI_KHOAN;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)suKienBamNutHuongDanGiaoDichViewController:(UIButton *)sender {
    GiaoDienThongTinPhim *vc = [[GiaoDienThongTinPhim alloc] initWithNibName:@"GiaoDienThongTinPhim" bundle:nil];
    vc.nOption = HUONG_DAN_CHUYEN_TIEN_TAI_KHOAN;
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
    [mScrv setContentOffset:CGPointMake(0, 0) animated:NO];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self xuLyKetNoiThanhCong:DINH_DANH_KET_NOI_CHUYEN_TIEN_VE_TAI_KHOAN_NGAN_HANG thongBao:@"thanh cog" ketQua:@""];
//    });
    
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

#pragma mark - handler error

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - khoi Tao

- (void)khoiTaoBanDau
{
    [self addButtonBack];
    [self addTitleView:[@"financer_viewer_wallet_to_bank" localizableString]];
    self.mFuncID = FUNC_TRANSACTION_TO_BANK;
    NSLog(@"%s - mFuncID : %d", __FUNCTION__, self.mFuncID);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateThongTin:) name:KEY_TAI_KHOAN_THUONG_DUNG object:nil];
    
    _edtNganHang.placeholder = [@"ngan_hang" localizableString];
    _edtTenChuTaiKhoan.placeholder = [@"ten_chu_tai_khoan" localizableString];
    _edtSoTaiKhoan.placeholder = [@"register_account_link_acc_no" localizableString];
    _edtSoTien.placeholder = [@"amount" localizableString];
    _mtfNoiDug.placeholder = [@"place_holder_noi_dung" localizableString];
}

-(void)khoiTaoTextField
{    
    [_edtTenChuTaiKhoan setTextError:[@"ten_tai_khoan_khong_duoc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    _edtTenChuTaiKhoan.inputAccessoryView = nil;
    
    [_edtSoTaiKhoan setTextError:[@"so_tai_khoan_khong_dc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    [_edtSoTaiKhoan setType:ExTextFieldTypeBankNumber];
    _edtSoTaiKhoan.inputAccessoryView = nil;
    
    [_edtSoTien setTextError:[@"so_tien_khong_duoc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    [_edtSoTien setTextError:[@"amount_invalid" localizableString]forType:ExTextFieldTypeMoney];
    _edtSoTien.inputAccessoryView = nil;

    [_edtNganHang setTextError:[@"ten_ngan_hang_khong_duoc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    _edtNganHang.inputAccessoryView = nil;

    _tvNoiDung.inputAccessoryView = nil;
}

- (void)khoiTaoViewPickerNganHang
{
    if(!mViewPickerNganHang)
        mViewPickerNganHang = [[DucNT_ViewPicker alloc] initWithNib];

    self.mDanhSachNganHang = [BankCoreData allBanks];
    if(_mDanhSachNganHang && _mDanhSachNganHang.count > 0)
    {
        NSMutableArray *dsTenNganHang = [[NSMutableArray alloc] init];
        for(int i = 0; i < _mDanhSachNganHang.count; i++)
        {
            Banks *bank = [_mDanhSachNganHang objectAtIndex:i];
            NSString *sTenNganHang = bank.bank_name;
            [dsTenNganHang addObject:sTenNganHang];
//            NSLog(@"%s - bank : %@", __FUNCTION__, bank.bank_name);
        }
        
        [_edtNganHang becomeFirstResponder];
        __block DucNT_ChuyenTienDenTaiKhoanViewController *blockSELF = self;
        [mViewPickerNganHang khoiTaoDuLieu:dsTenNganHang];
        [mViewPickerNganHang capNhatKetQuaLuaChon:^(int nGiaTri) {
            [blockSELF.edtNganHang resignFirstResponder];
            if(nGiaTri != -1)
            {
                blockSELF.edtNganHang.text = [dsTenNganHang objectAtIndex:nGiaTri];
                if(nGiaTri != blockSELF->mViTriNganHangDuocChon)
                {
                    blockSELF->mViTriNganHangDuocChon = nGiaTri;
                    NSString *sSoTien = [blockSELF.edtSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""];
                    [blockSELF xuLyHienThiSoTienPhiCuaSoTien:sSoTien];
                    if([blockSELF.edtNganHang.text hasPrefix:@"AGR"]){
                        [self hienThiGiaoDienThemChiNhanh];
                    }
                    else{
                        [self hienThiGiaoDienTruChiNhanh];
                        [self hienThiGiaoDienTruChiNhanhKhac];
                    }
                }
            }
        }];
        [dsTenNganHang release];
    }
    _edtNganHang.inputView = mViewPickerNganHang;
}

- (void)khoiTaoPickerChiNhanhNganHang{
    if (!arrChiNhanhBank) {
        arrChiNhanhBank = [[NSMutableArray alloc] init];
        [arrChiNhanhBank addObject:@"CN Bà Rịa Vũng Tàu"];
        [arrChiNhanhBank addObject:@"77204001"];
        [arrChiNhanhBank addObject:@"CN Bắc Hà Nội"];
        [arrChiNhanhBank addObject:@"1204006"];
        [arrChiNhanhBank addObject:@"CN Bình Phước"];
        [arrChiNhanhBank addObject:@"70204001"];
        [arrChiNhanhBank addObject:@"CN Đồng Nai"];
        [arrChiNhanhBank addObject:@"75204001"];
        [arrChiNhanhBank addObject:@"CN Gia Lai"];
        [arrChiNhanhBank addObject:@"64204001"];
        [arrChiNhanhBank addObject:@"CN Hà Nội"];
        [arrChiNhanhBank addObject:@"1204003"];
        [arrChiNhanhBank addObject:@"CN Hà Nội"];
        [arrChiNhanhBank addObject:@"1204003"];
        [arrChiNhanhBank addObject:@"CN Hà Tây"];
        [arrChiNhanhBank addObject:@"1204036"];
        [arrChiNhanhBank addObject:@"CN Láng Hà Nội"];
        [arrChiNhanhBank addObject:@"1204010"];
        [arrChiNhanhBank addObject:@"CN Nam Hà Nội"];
        [arrChiNhanhBank addObject:@"1204017"];
        [arrChiNhanhBank addObject:@"CN Nghệ An"];
        [arrChiNhanhBank addObject:@"40204001"];
        [arrChiNhanhBank addObject:@"CN Sài Gòn"];
        [arrChiNhanhBank addObject:@"79204023"];
        [arrChiNhanhBank addObject:@"CN Sở giao dịch"];
        [arrChiNhanhBank addObject:@"1204002"];
        [arrChiNhanhBank addObject:@"CN TP Hồ Chí Minh"];
        [arrChiNhanhBank addObject:@"79204001"];
        [arrChiNhanhBank addObject:@"CN TT Thanh Toán"];
        [arrChiNhanhBank addObject:@"1204009"];
        [arrChiNhanhBank addObject:@"CN Thăng Long"];
        [arrChiNhanhBank addObject:@"1204011"];
        [arrChiNhanhBank addObject:@"CN Thừa Thiên Huế"];
        [arrChiNhanhBank addObject:@"46204001"];
        [arrChiNhanhBank addObject:@"CN tỉnh Bắc Giang"];
        [arrChiNhanhBank addObject:@"24204001"];
        [arrChiNhanhBank addObject:@"CN tỉnh Bình Dương"];
        [arrChiNhanhBank addObject:@"74204001"];
        [arrChiNhanhBank addObject:@"CN tỉnh Bình Thuận"];
        [arrChiNhanhBank addObject:@"60204001"];
        [arrChiNhanhBank addObject:@"CN tỉnh Cao Bằng"];
        [arrChiNhanhBank addObject:@"4204001"];
        [arrChiNhanhBank addObject:@"CN tỉnh Điện Biên"];
        [arrChiNhanhBank addObject:@"11204001"];
        [arrChiNhanhBank addObject:@"CN tỉnh Hà Nam"];
        [arrChiNhanhBank addObject:@"35204001"];
        [arrChiNhanhBank addObject:@"CN tỉnh Hà Tĩnh"];
        [arrChiNhanhBank addObject:@"42204001"];
        [arrChiNhanhBank addObject:@"CN tỉnh Hoà Bình"];
        [arrChiNhanhBank addObject:@"17204001"];
        [arrChiNhanhBank addObject:@"CN tỉnh Khánh Hoà"];
        [arrChiNhanhBank addObject:@"56204001"];
        [arrChiNhanhBank addObject:@"CN tỉnh Kon Tum"];
        [arrChiNhanhBank addObject:@"62204001"];
        [arrChiNhanhBank addObject:@"CN tỉnh Lào Cai"];
        [arrChiNhanhBank addObject:@"10204001"];
        [arrChiNhanhBank addObject:@"CN tỉnh Nam Định"];
        [arrChiNhanhBank addObject:@"36204001"];
        [arrChiNhanhBank addObject:@"CN tỉnh Ninh Bình"];
        [arrChiNhanhBank addObject:@"37204001"];
        [arrChiNhanhBank addObject:@"CN tỉnh Ninh Thuận"];
        [arrChiNhanhBank addObject:@"58204001"];
        [arrChiNhanhBank addObject:@"CN tỉnh Quảng Bình"];
        [arrChiNhanhBank addObject:@"44204001"];
        [arrChiNhanhBank addObject:@"CN tỉnh Sơn La"];
        [arrChiNhanhBank addObject:@"14204001"];
        [arrChiNhanhBank addObject:@"CN tỉnh Thái Bình"];
        [arrChiNhanhBank addObject:@"34204001"];
        [arrChiNhanhBank addObject:@"CN tỉnh Thái Nguyên"];
        [arrChiNhanhBank addObject:@"19204001"];
        [arrChiNhanhBank addObject:@"CN tỉnh Tuyên Quang"];
        [arrChiNhanhBank addObject:@"8204001"];
        [arrChiNhanhBank addObject:@"CN tỉnh Vĩnh Phúc"];
        [arrChiNhanhBank addObject:@"26204001"];
        [arrChiNhanhBank addObject:@"Chi nhánh khác"];
        [arrChiNhanhBank addObject:@"11111111"];
    }
    NSMutableArray *arrTemp = [[NSMutableArray alloc] init];
    for (int i = 0; i < arrChiNhanhBank.count; i += 2) {
        [arrTemp addObject:[arrChiNhanhBank objectAtIndex:i]];
    }
    DucNT_ViewPicker *brankPicker = [[DucNT_ViewPicker alloc] initWithNib];
    [brankPicker khoiTaoDuLieu:arrTemp];
    _mtfChiNhanh.inputView = brankPicker;
    [brankPicker capNhatKetQuaLuaChon:^(int nIndex) {
        [_mtfChiNhanh resignFirstResponder];
        if (nIndex > -1) {
            NSString *sBranch = [arrTemp objectAtIndex:nIndex];
            [_mtfChiNhanh setText:sBranch];
            if (nIndex != [arrTemp count] - 1) {
                [self hienThiGiaoDienTruChiNhanhKhac];
            }
            else{
                [self hienThiGiaoDienThemChiNhanhKhac];
            }
        }
    }];
    [arrTemp release];
    [brankPicker release];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField isEqual:_mtfChiNhanh]) {
        if (_mtfChiNhanh.text.length == 0) {
            [self khoiTaoPickerChiNhanhNganHang];
        }
    }
}

- (void)hienThiGiaoDienThemChiNhanh{
//    if (!mtfChiNhanh) {
//        mtfChiNhanh = [[ExTextField alloc] initWithFrame:CGRectMake(10, 44, 282, 35)];
//
////        [mtfChiNhanh setDelegate:self];
//    }
    self.mtfChiNhanh.hidden = NO;
    [self addRightButtonForPicker:_mtfChiNhanh];
    [self khoiTaoPickerChiNhanhNganHang];
    [_mtfChiNhanh setPlaceholder:[@"chon_chi_nhanh" localizableString]];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.heightChiNhanh.constant = 35.0;
        self.heightViewThongTin.constant += self.heightChiNhanh.constant;
        self.topSpaceTenChuTaiKhoan.constant = 8.0;
    });
}

- (void)hienThiGiaoDienTruChiNhanh{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.heightViewThongTin.constant -= self.heightChiNhanh.constant;
        self.heightChiNhanh.constant = 0;
        self.mtfChiNhanh.hidden = YES;
        self.topSpaceTenChuTaiKhoan.constant = 0;
    });
}

- (void)hienThiGiaoDienThemChiNhanhKhac {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.mtfChiNhanhKhac.hidden = NO;
        self.topChiNhanhKhac.constant = 8;
        self.heightChiNhanhKhac.constant = 35;
        self.heightViewThongTin.constant += self.heightChiNhanh.constant;
        self.topSpaceTenChuTaiKhoan.constant = 8;
    });
}

- (void)hienThiGiaoDienTruChiNhanhKhac{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.mtfChiNhanhKhac.hidden = YES;
        self.topChiNhanhKhac.constant = 0;
        self.heightViewThongTin.constant -= self.heightChiNhanh.constant;
        self.heightChiNhanhKhac.constant = 0;
        self.topSpaceTenChuTaiKhoan.constant = 0;
    });
}

- (void)khoiTaoViewNhapTenDaiDienXacThucTaiKhoan
{
    if(!mViewNhapTenDaiDien)
    {
        mViewNhapTenDaiDien = [[[[NSBundle mainBundle] loadNibNamed:@"ViewNhapTenDaiDienXacThucThemTaiKhoanThuongDung" owner:self options:nil] objectAtIndex:0] retain];

    }
}

#pragma mark - get & set

- (void)setMTaiKhoanThuongDung:(DucNT_TaiKhoanThuongDungObject *)mTaiKhoanThuongDung
{
    if(_mTaiKhoanThuongDung)
        [_mTaiKhoanThuongDung release];
    _mTaiKhoanThuongDung = [mTaiKhoanThuongDung retain];
    _mTaiKhoanThuongDung.sId = @"";
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
    NSArray *tfs = @[_edtNganHang, _edtTenChuTaiKhoan, _edtSoTaiKhoan, _edtSoTien];
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

    double fSoTien = [[_edtSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
//    && fSoTien > 1000000000
    if(fSoTien < 10000)
    {
        [UIAlertView alert:[@"so_tien_min_den_the_ngan_hang" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
        return NO;
    }
    else if (fSoTien >= [self.mThongTinTaiKhoanVi.nAmount doubleValue]) {
        [UIAlertView alert:[@"so_du_khong_du" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
        return NO;
    }
    else if (fSoTien > [self.mThongTinTaiKhoanVi.nHanMucDenTaiKhoan doubleValue]) {
        [UIAlertView alert:[@"vuot_han_muc" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
        return NO;
    }
    return flg;
}

- (void)xuLyThucHienKhiKiemTraThanhCongTraVeToken:(NSString*)sToken otp:(NSString*)sOtp
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_CHUYEN_TIEN_VE_TAI_KHOAN_NGAN_HANG;
        NSString *sBankCode = @"";
        NSString *sBrachName = @"";
        NSString *sBrachCode = @"";
        if(mViTriNganHangDuocChon > -1)
        {
            Banks *bank = [_mDanhSachNganHang objectAtIndex:mViTriNganHangDuocChon];
            sBankCode = bank.bank_sms;
            if ([bank.bank_name hasPrefix:@"AGR"] && arrChiNhanhBank) {
                if ([_mtfChiNhanh.text isEqualToString:[@"chi_nhanh_khac" localizableString]] && _mtfChiNhanhKhac.text.isEmpty) {
                    [_mtfChiNhanhKhac setTextError:[@"vui_long_nhap_ten_chi_nhanh" localizableString]];
                    [_mtfChiNhanhKhac show_error];
                    return;
                }
                for (int i = 0; i < arrChiNhanhBank.count; i+=2) {
                    NSString *sTemp = [arrChiNhanhBank objectAtIndex:i];
                    if ([sTemp isEqualToString:[_mtfChiNhanh.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]) {
                        sBrachName = [arrChiNhanhBank objectAtIndex:i];
                        sBrachCode = [arrChiNhanhBank objectAtIndex:(i + 1)];
                        break;
                    }
                }
                if (sBrachName.isEmpty || [sBrachCode isEqualToString:@"11111111"]) {
                    sBrachName = [_mtfChiNhanhKhac.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    sBrachCode = [arrChiNhanhBank objectAtIndex:arrChiNhanhBank.count - 1];
                }
            }
        }
        double fSoTien = [[[_edtSoTien.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
            [self hienThiLoading];
        }
        [GiaoDichMang ketNoiChuyenTienDenTaiKhoanNganHangThemChiNhanh:_edtSoTaiKhoan.text bankCode:sBankCode brachName:sBrachName brachCode:sBrachCode tenChuTaiKhoan:_edtTenChuTaiKhoan.text noiDungChuyenTien:_tvNoiDung.text soTien:fSoTien token:sToken otp:sOtp typeAuthenticate:self.mTypeAuthenticate noiNhanKetQua:self];
    });
}

- (void)xuLyKetNoiThanhCong:(NSString*)sDinhDanhKetNoi thongBao:(NSString*)sThongBao ketQua:(id)ketQua
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self anLoading];
    }
    if([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_CHUYEN_TIEN_VE_TAI_KHOAN_NGAN_HANG])
    {
        [self hienThiHopThoaiMotNutBamKieu:HOP_THOAI_XAC_NHAN_CHUYEN_TIEN_THANH_CONG cauThongBao:sThongBao];
    }
}


#pragma mark - sự kiện

- (IBAction)editSoTien:(id)sender
{
    NSString *sText = [Common hienThiTienTeFromString:[_edtSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""]];
    _edtSoTien.text = sText;
    NSString *sSoTien = [[sText componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
    
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
        self.mbtnPKI.hidden = YES;
        self.btnVanTayMini.hidden = NO;
        self.mbtnToken.hidden = NO;
    }
    
    [self xuLyHienThiSoTienPhiCuaSoTien:sSoTien];
}

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
    DucNT_DanhSachTaiKhoanThuongDungControllerViewController *vc = [[DucNT_DanhSachTaiKhoanThuongDungControllerViewController alloc] initWithType:TAI_KHOAN_NGAN_HANG];
    [self.navigationController presentViewController:vc animated:YES completion:^{}];
    [vc release];
}


#pragma mark - xuLy

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

- (void)xuLyHienThiSoTienPhiCuaSoTien:(NSString*)sSoTien
{
    NSString *sBankCode = @"";
    if(mViTriNganHangDuocChon > -1)
    {
        Banks *bank = [_mDanhSachNganHang objectAtIndex:mViTriNganHangDuocChon];
        sBankCode = bank.bank_sms;
    }
    NSLog(@"%s - sSoTien : %@", __FUNCTION__, sSoTien);
    double fSoPhi = [Common layPhiChuyenTienCuaSoTien:[sSoTien doubleValue] kieuChuyenTien:KIEU_CHUYEN_TIEN_DEN_TAI_KHOAN_NGAN_HANG maNganHang:sBankCode];
    self.mtfPhiGiaoDich.text = [Common hienThiTienTe_1:fSoPhi];
}

#pragma mark - sửa giao diện nếu là edit
- (void)xuLyCapNhatTaiKhoanThuongDung
{
    if(_mTaiKhoanThuongDung.nAmount > 0)
        _edtSoTien.text = [Common hienThiTienTe:_mTaiKhoanThuongDung.nAmount];
    else
        _edtSoTien.text = @"";
    _edtTenChuTaiKhoan.text = _mTaiKhoanThuongDung.sAccOwnerName;
    _edtSoTaiKhoan.text = _mTaiKhoanThuongDung.sBankNumber;

    for(int i = 0; i < _mDanhSachNganHang.count; i++)
    {
        Banks *bank = [_mDanhSachNganHang objectAtIndex:i];
        NSLog(@"%s - [bank.bank_id intValue] : %d", __FUNCTION__, [bank.bank_id intValue]);
        if([bank.bank_id intValue] == _mTaiKhoanThuongDung.nBankId)
        {
            NSString *sTenNganHang = bank.bank_name;
            _edtNganHang.text = sTenNganHang;
            mViTriNganHangDuocChon = i;
            if ([bank.bank_id intValue] == 1) {
                [self hienThiGiaoDienThemChiNhanh];
                NSLog(@"%s - _mTaiKhoanThuongDung.maChiNhanh : %@", __FUNCTION__, _mTaiKhoanThuongDung.maChiNhanh);
                if(_mTaiKhoanThuongDung.maChiNhanh.length > 0){
//                    if ([_mTaiKhoanThuongDung.maChiNhanh isEqualToString:@"11111111"]) {
//                        mtfChiNhanh.text = @"Chi nhánh khác";
//                    }
//                    else {
                        for (int i = 0; i < arrChiNhanhBank.count; i++) {
                            NSString *sChiNhanhTemp = [arrChiNhanhBank objectAtIndex:i];
                            NSLog(@"%s - _mTaiKhoanThuongDung.maChiNhanh : %@ - sChiNhanhTemp : %@", __FUNCTION__, _mTaiKhoanThuongDung.maChiNhanh, sChiNhanhTemp);
                            if (i > 0 && [sChiNhanhTemp isEqualToString:_mTaiKhoanThuongDung.maChiNhanh]) {
                                _mtfChiNhanh.text = [arrChiNhanhBank objectAtIndex:i - 1];
                                break;
                            }
                        }
//                    }
                }
            }
            break;
        }
    }
    
    _tvNoiDung.text = _mTaiKhoanThuongDung.sDesc;
    [self xuLyHienThiSoTienPhiCuaSoTien:[NSString stringWithFormat:@"%f", _mTaiKhoanThuongDung.nAmount]];
}


-(void)themTaiKhoanThuongDung
{
    if([self validateVanTay] && !mViewNhapTenDaiDien.superview)
    {
        if(!_mTaiKhoanThuongDung)
            _mTaiKhoanThuongDung = [[DucNT_TaiKhoanThuongDungObject alloc] init];
        
        mViewNhapTenDaiDien.frame = self.view.bounds;
        _mTaiKhoanThuongDung.sBankNumber = _edtSoTaiKhoan.text;
        _mTaiKhoanThuongDung.nAmount = [[_edtSoTien.text stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [_edtSoTien.text length])] doubleValue];
        _mTaiKhoanThuongDung.sDesc = _tvNoiDung.text;
        _mTaiKhoanThuongDung.sPhoneOwner = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
        _mTaiKhoanThuongDung.nType = TAI_KHOAN_NGAN_HANG;
        _mTaiKhoanThuongDung.sAccOwnerName = _edtTenChuTaiKhoan.text;
        if(mViTriNganHangDuocChon > -1)
        {
            Banks *bank = [_mDanhSachNganHang objectAtIndex:mViTriNganHangDuocChon];
            NSLog(@"ChuyenTienDenTaiKhoanViewController : themTaiKhoanThuongDung : bank name : %@", bank.bank_name);
            _mTaiKhoanThuongDung.sBankName = bank.bank_name;
            _mTaiKhoanThuongDung.nBankCode = bank.bank_code.intValue;
            _mTaiKhoanThuongDung.nBankId = bank.bank_id.intValue;
            if ([bank.bank_name hasPrefix:@"AGR"]) {
                if (_mtfChiNhanh.text.length == 0) {
                    [_mtfChiNhanh setTextError:@"Vui lòng chọn chi nhánh"];
                    [_mtfChiNhanh show_error];
                    return;
                }
                _mTaiKhoanThuongDung.sBranchName = [_mtfChiNhanh.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                if (arrChiNhanhBank) {
                    for (int i = 0; i < arrChiNhanhBank.count; i+= 2) {
                        NSString *sTemp = [arrChiNhanhBank objectAtIndex:i];
                        if([sTemp isEqualToString:[_mtfChiNhanh.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]){
                            _mTaiKhoanThuongDung.sBranchCode = [arrChiNhanhBank objectAtIndex:(i + 1)];
                            break;
                        }
                    }
                    if (_mTaiKhoanThuongDung.sBranchCode.isEmpty) {
                        _mTaiKhoanThuongDung.sBranchCode = [arrChiNhanhBank objectAtIndex:arrChiNhanhBank.count - 1];
                    }
                }
            }
        }

        mViewNhapTenDaiDien.mTaiKhoanThuongDung = _mTaiKhoanThuongDung;
        mViewNhapTenDaiDien.mThongTinVi = self.mThongTinTaiKhoanVi;
        
        [self.view addSubview:mViewNhapTenDaiDien];
        [self.view endEditing:YES];
    }
    else {
        [self khoiTaoButtonXacThucBanDau];
    }
}

#pragma mark - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [viewQC release];
    [_edtNganHang release];
    [_edtTenChuTaiKhoan release];
    [_edtSoTaiKhoan release];
    [_edtSoTien release];
    [_tvNoiDung release];
    [_btnLuuTaiKhoanThuongDung release];
    if(_mDanhSachNganHang)
        [_mDanhSachNganHang release];
    if(mViewPickerNganHang)
        [mViewPickerNganHang release];
    [_mtfPhiGiaoDich release];
//    [_mlblPhi release];
    [mScrv release];
    [_viewThongTin release];
    [_viewToken release];
    [_viewButtonOption release];
    [_mtfNoiDug release];
    if (arrChiNhanhBank) {
        [arrChiNhanhBank release];
    }
    [_mtfChiNhanh release];
    [_mtfChiNhanhKhac release];
    [_scrMain release];
    [_viewTaiKhoan release];
    [_heightViewMain release];
    [_heightChiNhanh release];
    [_topSpaceTenChuTaiKhoan release];
    [_heightViewThongTin release];
    [_topChiNhanhKhac release];
    [super dealloc];
}

@end
