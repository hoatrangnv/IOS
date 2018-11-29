//
//  ChuyenTienViewController.m
//  ViViMASS
//
//  Created by DucBT on 2/3/15.
//
//

#import "DucNT_TaiKhoanThuongDungObject.h"
#import "ChuyenTienViewController.h"
#import "DucNT_ServicePost.h"
#import "DanhSachTaiKhoanThuongDungViewController.h"
#import "BankCoreData.h"
#import "GiaoDienThongTinPhim.h"
#import "ItemTaiKhoanLienKet.h"
#import "GiaoDienDanhSachTaiKhoanLienKet.h"
#import "DucNT_LoginSceen.h"

@interface ChuyenTienViewController () <DucNT_ServicePostDelegate, GiaoDienDanhSachTaiKhoanLienKetDelegate>
{
    NSInteger mViTriNganHangDuocChon;
    ViewQuangCao *viewQC;
    ItemTaiKhoanLienKet *tkLienKet;
    int nBankCode;
    BOOL isTaiKhoan;
}
@property (retain, nonatomic) NSArray *mDanhSachTaiKhoanRutTienThuongDung;
@property (retain, nonatomic) NSArray *mDanhSachNganHang;
@property (retain, nonatomic) NSString *mBankSMS;

@end

@implementation ChuyenTienViewController

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self khoiTaoBanDau];
    [self khoiTaoDanhSachNganHang];
    [self khoiTaoGiaoDien];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chonTaiKhoanThuongDung:) name:NOTIFICATION_LAY_TAI_KHOAN_THUONG_DUNG object:nil];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 40);
    [button setImage:[UIImage imageNamed:@"hdsd-icon"]forState:UIControlStateNormal];

    button.backgroundColor = [UIColor clearColor];
    button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [button addTarget:self action:@selector(suKienBamNutHuongDanRutTien:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *leftItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    UIBarButtonItem *negativeSeperator = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
    if (SYSTEM_VERSION_LESS_THAN(@"11"))
        negativeSeperator.width = -10;
    else {
        negativeSeperator.width = -15;
        [button.widthAnchor constraintEqualToConstant:34].active = YES;
        [button.heightAnchor constraintEqualToConstant:34].active = YES;
    }
    self.navigationItem.rightBarButtonItems = @[negativeSeperator, leftItem];

    isTaiKhoan = NO;
    
    if ([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
            [self hienThiLoadingChuyenTien];
        }
        self.mDinhDanhKetNoi = @"LAY_DANH_SACH_LIEN_KET";
        [GiaoDichMang layDanhSachTaiKhoanLienKet:self];
    }
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
        rectQC.origin.y = rectToken.origin.y + rectToken.size.height + 15.0;
        viewQC.frame = CGRectMake(0, rectQC.origin.y, fW, fH);
        viewQC.mDelegate = self;
        [viewQC updateSizeQuangCao];
        self.heightViewMain.constant += (fH + 15.0);
//        rectMain.size.height = rectQC.origin.y + rectQC.size.height;
//        self.mViewMain.frame = rectMain;
        [self.mViewMain addSubview:viewQC];
        self.scrMain.contentSize = CGSizeMake(rectMain.size.width, rectMain.size.height + 20.0);
    }
}

- (void)suKienBamNutHuongDanRutTien:(UIButton *)sender
{
    GiaoDienThongTinPhim *vc = [[GiaoDienThongTinPhim alloc] initWithNibName:@"GiaoDienThongTinPhim" bundle:nil];
    vc.nOption = 6;
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
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    UIImageView *imgSoTay = [self.btnSoTay imageView];
    [imgSoTay stopAnimating];
}

#pragma mark - khoi Tao

- (void)khoiTaoBanDau
{
    [self addButtonBack];
    
    [self addTitleView:[@"rut_tien" localizableString]];
    self.mFuncID = FUNC_TRANSACTION_TO_BANK;
    [self xuLyHienThiSoTienPhiCuaSoTien:@"1"];

}

- (void)khoiTaoGiaoDien
{
    [self.mtfTenTKRutTien setTextError:[@"ten_tk_rut_tien_khong_duoc_de_tong" localizableString] forType:ExTextFieldTypeEmpty];
    [self.mtfSoTien setTextError:[@"so_tien_khong_duoc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    [self.mtfSoTien setTextError:[@"@so_tien_khong_hop_le" localizableString]forType:ExTextFieldTypeMoney];
    [self.mtfSoTien setText:@""];
    self.mtfSoTien.inputAccessoryView = nil;
    [self.mtvNoiDungGiaoDich setText:@""];
    self.mtvNoiDungGiaoDich.inputAccessoryView = nil;
}
- (void)khoiTaoDuLieuTaiKhoanThuongDung
{
    if(tkLienKet)
    {
        for(Banks *bank in self.mDanhSachNganHang)
        {
            if ([bank.bank_sms.lowercaseString hasPrefix:tkLienKet.maNganHang.lowercaseString]) {
                NSLog(@"%s - bank : %@", __FUNCTION__, bank.bank_code);
                nBankCode = [bank.bank_code intValue];
                self.mBankSMS = bank.bank_sms;
                NSString *sDsBank = @"BID - Đầu tư và phát triển Việt Nam/CTG - Công thương Việt Nam/VCB - Ngoại thương Việt Nam/ABB - An bình/ACB - Á châu/BAB - Bắc á/BVB - Bảo Việt/EAB - Đông á/EIB - Xuất nhập khẩu Việt Nam/GPB - Dầu khí toàn cầu/HDB - Phát triển TPHCM/KLB - Kiên Long/LPB - Bưu điện Liên Việt/MB - Quân đội/MSB - Hàng hải/NAB - Nam á/NCB - Quốc dân/OCB -  Phương đông/OJB - Đại dương/PGB - Xăng dầu Petrolimex/PVB - Đại chúng Việt Nam/SCB - Sài Gòn/SEAB - Đông nam á/SGB - Sài Gòn công thương/SHB - Sài Gòn - Hà Nội/STB - Sài Gòn thương tín/TCB - Kỹ thương Việt Nam/TPB - Tiên Phong/VAB - Việt Á/VB - Việt Nam thương tín/VCCB - Bản Việt/VIB - Quốc tế/VPB - Việt Nam thịnh vượng";
                NSArray *arrTemp = [sDsBank componentsSeparatedByString:@"/"];
                for (NSString *sBank in arrTemp) {
                    if ([sBank hasPrefix:tkLienKet.maNganHang]) {
                        self.mtfTenTKRutTien.text = sBank;
                        break;
                    }
                }
                break;
            }
        }
        self.mtfTenNguoiThuHuong.text = tkLienKet.tenChuTaiKhoan;
        if (tkLienKet.soTaiKhoan.length > 0) {
            self.mtfTenVietTatNganHang.text = tkLienKet.soTaiKhoan;
            self.mtfTenVietTatNganHang.placeholder = @"Số tài khoản";
            isTaiKhoan = YES;
        }
        else if (tkLienKet.soThe.length > 0) {
            isTaiKhoan = NO;
            self.mtfTenVietTatNganHang.text = tkLienKet.soThe;
            self.mtfTenVietTatNganHang.placeholder = @"Số thẻ";
        }
    }
    else
    {
        [self.mtfTenTKRutTien setText:@""];
        [self.mtvNoiDungGiaoDich setText:@""];
        [self.mtfSoTien setText:@""];
        [self.mtfTenNguoiThuHuong setText:@""];
        [self.mtfTenVietTatNganHang setText:@""];
        [self xuLyHienThiSoTienPhiCuaSoTien:@"1"];
    }
}

-(void) khoiTaoDanhSachNganHang
{
    self.mDanhSachNganHang = [BankCoreData allBanks];
}

#pragma mark - handler error

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)hideViewNhapToken {
    
}

#pragma mark - overriden GiaoDichViewController

-(BOOL)validateVanTay
{
    NSArray *tfs = @[_mtfSoTien, _mtfTenTKRutTien];
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
    
    double fSoTien = [[self.mtfSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
    if(fSoTien < 50000 && fSoTien > 1000000000)
    {
        [UIAlertView alert:@"Số tiền phải từ 50.000 đến 1 tỷ đồng" withTitle:[@"thong_bao" localizableString] block:nil];
        return NO;
    }
    else if (fSoTien >= [self.mThongTinTaiKhoanVi.nAmount doubleValue]) {
        [UIAlertView alert:@"Số dư trong tài khoản không đủ" withTitle:[@"thong_bao" localizableString] block:nil];
        return NO;
    }
    NSString *sSoTienChuyen = [self.mtfSoTien.text stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [self.mtfSoTien.text length])];
    double fSoTienRut = [sSoTienChuyen doubleValue];
    double fSoTienPhi = [Common layPhiRutTienCuaSoTien:fSoTienRut];
    if([self.mThongTinTaiKhoanVi.nAmount doubleValue] < fSoTienRut + fSoTienPhi)
    {
        flg = NO;
        [self.mtfSoTien showNotify];
        [UIAlertView alert:[@"thong_bao_so_du_tai_khoan_khong_du_de_thuc_hien_chuyen_tien" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
    }
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return NO;
    }
    return flg;
}

- (void)xuLyThucHienKhiKiemTraThanhCongTraVeToken:(NSString*)sToken otp:(NSString*)sOtp
{
    self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_CHUYEN_TIEN_VE_TAI_KHOAN_NGAN_HANG;
    NSString *sBankCode = @"";
    if(mViTriNganHangDuocChon > -1)
    {
        Banks *bank = [_mDanhSachNganHang objectAtIndex:mViTriNganHangDuocChon];
        sBankCode = bank.bank_sms;
    }
    double fSoTien = [[[self.mtfSoTien.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
    [GiaoDichMang ketNoiChuyenTienDenTaiKhoanNganHang:tkLienKet.soTaiKhoan
                                             bankCode:tkLienKet.maNganHang
                                       tenChuTaiKhoan:tkLienKet.tenChuTaiKhoan
                                    noiDungChuyenTien:_mtvNoiDungGiaoDich.text
                                               soTien:fSoTien
                                                token:sToken
                                                  otp:sOtp
                                     typeAuthenticate:self.mTypeAuthenticate
                                        noiNhanKetQua:self];
    
}

- (void)xuLyKetNoiThanhCong:(NSString*)sDinhDanhKetNoi thongBao:(NSString*)sThongBao ketQua:(id)ketQua
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
        [self anLoading];
    }
    if([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_CHUYEN_TIEN_VE_TAI_KHOAN_NGAN_HANG])
    {
        [self hienThiHopThoaiMotNutBamKieu:HOP_THOAI_XAC_NHAN_CHUYEN_TIEN_THANH_CONG cauThongBao:sThongBao];
    }
    else if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_LAY_TAI_KHOAN_THUONG_DUNG])
    {
        NSDictionary *dic2 = (NSDictionary*)ketQua;
        NSArray *dsTaiKhoan = [dic2 valueForKey:@"list"];
        [self xuLyLayDanhSachTaiKhoanThuongDungThanhCong:dsTaiKhoan];
        [self xuLyKetNoiLaySoDuTaiKhoan];
    }
    else if ([sDinhDanhKetNoi isEqualToString:@"LAY_DANH_SACH_LIEN_KET"]) {
        NSArray *arrTemp = (NSArray *)ketQua;
        if (arrTemp.count == 0) {
            return;
        }
        for (NSDictionary *dict in arrTemp) {
            ItemTaiKhoanLienKet *item = [[ItemTaiKhoanLienKet alloc] khoiTao:dict];
            if (item.danhDauTKMacDinh == 1) {
                tkLienKet = item;
                break;
            }
        }
        if (tkLienKet == nil && arrTemp.count > 0) {
            NSDictionary *dict = [arrTemp firstObject];
            ItemTaiKhoanLienKet *item = [[ItemTaiKhoanLienKet alloc] khoiTao:dict];
            tkLienKet = item;
        }
        [self khoiTaoDuLieuTaiKhoanThuongDung];
    }
}


#pragma mark - suKien
- (IBAction)suKienBamNutLayTaiKhoanThuongDung:(id)sender
{
    DanhSachTaiKhoanThuongDungViewController *vc = [[DanhSachTaiKhoanThuongDungViewController alloc] initWithNibName:@"DanhSachTaiKhoanThuongDungViewController" bundle:nil];
    vc.mKieuChucNang = CHUC_NANG_CHON;
    vc.mKieuHienThiDanhSachTaiKhoan = TAI_KHOAN_NGAN_HANG_RUT_TIEN;
    [self presentViewController:vc animated:YES completion:^{}];
    [vc release];
}

- (IBAction)suKienThayDoiGiaTriTextField:(id)sender
{
    NSString *sSoTien = [self.mtfSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    if([sSoTien doubleValue] > 0)
    {
        [self.mtfSoTien setText:[Common hienThiTienTe:[sSoTien doubleValue]]];
    }
    else
        self.mtfSoTien.text = @"";
    double fPhi = [Common layPhiChuyenTienCuaSoTien:[sSoTien doubleValue] kieuChuyenTien:KIEU_CHUYEN_TIEN_DEN_TAI_KHOAN_NGAN_HANG maNganHang:self.mBankSMS];
    self.mtfSoPhi.text = [NSString stringWithFormat:@"%@ đ", [Common hienThiTienTe:fPhi]];
}

- (void)xuLyLayDanhSachTaiKhoanThuongDungThanhCong:(NSArray*)dsTaiKhoan
{
    if(dsTaiKhoan.count > 0)
    {
        NSMutableArray *arrTKRutTienTemp = [[NSMutableArray alloc] init];
        for(int i = 0; i < dsTaiKhoan.count; i++)
        {
            NSString *jsonDict = [dsTaiKhoan objectAtIndex:i];
            NSDictionary *itemDs = [jsonDict objectFromJSONString];
            DucNT_TaiKhoanThuongDungObject *obj = [[DucNT_TaiKhoanThuongDungObject alloc] init];
            obj.sId = [itemDs objectForKey:@"id"];
            obj.sPhoneOwner = [itemDs objectForKey:@"phoneOwner"];
            obj.nType = [[itemDs objectForKey:@"type"] intValue];
            obj.sAliasName = [Common URLDecode:[itemDs objectForKey:@"aliasName"]];
            obj.nAmount = [[itemDs objectForKey:@"amount"] doubleValue];
            obj.sDesc = [Common URLDecode:[itemDs objectForKey:@"desc"]];
            obj.sToAccWallet = [itemDs objectForKey:@"toAccWallet"];
            obj.sAccOwnerName = [itemDs objectForKey:@"AccOwnerName"];
            obj.sBankName = [Common URLDecode:[itemDs objectForKey:@"bankName"]];
            obj.sBankNumber = [itemDs objectForKey:@"BankNumber"];
            obj.sProvinceName = [Common URLDecode:[itemDs objectForKey:@"provinceName"]];
            obj.nProvinceCode = [[itemDs objectForKey:@"provinceCode"] intValue];
            obj.nProvinceID = [[itemDs objectForKey:@"provinceId"]intValue];
            obj.nBankCode = [[itemDs objectForKey:@"bankCode"] intValue];
            obj.nBankId = [[itemDs objectForKey:@"bankId"] intValue];
            obj.nBranchId = [[itemDs objectForKey:@"branchId"] intValue];
            obj.sBranchName = [Common URLDecode:[itemDs objectForKey:@"branchName"]];
            obj.sBranchCode = [itemDs objectForKey:@"branchCode"];
            obj.nDateExp = [[itemDs objectForKey:@"dateExp"] longLongValue];
            obj.nDateReg = [[itemDs objectForKey:@"dateReg"] longLongValue];
            obj.sCardNumber = [itemDs objectForKey:@"cardNumber"];
            obj.sCardOwnerName = [itemDs objectForKey:@"cardOwnerName"];
            obj.sCardTypeName = [itemDs objectForKey:@"cardTypeName"];
            if(obj.nType == TAI_KHOAN_NGAN_HANG_RUT_TIEN)
            {
                [arrTKRutTienTemp addObject:obj];
                if(!_mTaiKhoanThuongDung)
                {
                    self.mTaiKhoanThuongDung = obj;
                    [self khoiTaoDuLieuTaiKhoanThuongDung];
                }
            }
            [obj release];
        }
        self.mDanhSachTaiKhoanRutTienThuongDung = arrTKRutTienTemp;

        [arrTKRutTienTemp release];
    }
}

-(void)chonTaiKhoanThuongDung:(NSNotification *)notification
{
    if([[notification name] isEqualToString:NOTIFICATION_LAY_TAI_KHOAN_THUONG_DUNG])
    {
        DucNT_TaiKhoanThuongDungObject *taiKhoanThuongDung = [notification object];
        self.mTaiKhoanThuongDung = taiKhoanThuongDung;
        [self khoiTaoDuLieuTaiKhoanThuongDung];
    }
}

- (void)xuLyHienThiSoTienPhiCuaSoTien:(NSString*)sSoTien
{
    double fSoPhi = [Common layPhiChuyenTienCuaSoTien:[sSoTien doubleValue] kieuChuyenTien:KIEU_CHUYEN_TIEN_DEN_TAI_KHOAN_NGAN_HANG maNganHang:self.mBankSMS];
    self.mtfSoPhi.text = [Common hienThiTienTe_1:fSoPhi];
}

#pragma mark - xuLyKetNoi
- (void)xuLyKetNoiLayDanhSachTaiKhoanThuongDung
{
    self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_LAY_TAI_KHOAN_THUONG_DUNG;
    [GiaoDichMang ketNoiLayDanhSachTaiKhoanThuongDung:TAI_KHOAN_TONG_HOP noiNhanKetQua:self];
}

- (IBAction)suKienChonSoTay:(id)sender {
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return;
    }
    GiaoDienDanhSachTaiKhoanLienKet *vc = [[GiaoDienDanhSachTaiKhoanLienKet alloc] initWithNibName:@"GiaoDienDanhSachTaiKhoanLienKet" bundle:nil];
    vc.bChinhSua = YES;
    [self.navigationController presentViewController:vc animated:YES completion:nil];
    vc.delegate = self;
    [vc release];
}

- (void)suKienChinhSuaTaiKhoanLienKet:(ItemTaiKhoanLienKet *)taiKhoan {
    tkLienKet = taiKhoan;
    [self khoiTaoDuLieuTaiKhoanThuongDung];
}

#pragma mark - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_LAY_TAI_KHOAN_THUONG_DUNG object:nil];
    if(_mTaiKhoanThuongDung)
        [_mTaiKhoanThuongDung release];
    if(_mDanhSachNganHang)
        [_mDanhSachNganHang release];
    if(_mBankSMS)
        [_mBankSMS release];
    [_mtfTenTKRutTien release];
    [_mtfSoTien release];
    [_mtfSoPhi release];
    [_mtvNoiDungGiaoDich release];
    [_mtfTenNguoiThuHuong release];
    [_mtfTenVietTatNganHang release];
    [_scrMain release];
    [_heightViewMain release];
    [super dealloc];
}
@end
