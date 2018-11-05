//
//  DucNT_ChuyenTienViDenViViewController.m
//  ViMASS
//
//  Created by MacBookPro on 7/8/14.
//
//

#import "DucNT_ChuyenTienViDenViViewController.h"
#import "NapViTuTheNganHangViewController.h"
#import "DucNT_DanhSachTaiKhoanThuongDungControllerViewController.h"
#import "DucNT_ViewNhapTenDaiDienTaiKhoanThuongDung.h"
#import "ViewNhapTenDaiDienXacThucThemTaiKhoanThuongDung.h"
#import "ContactScreen.h"
#import "DDAlertPrompt.h"
#import "Common.h"
#import "GiaoDienThongTinPhim.h"
#import "GiaoDienChuyenTienATM.h"
#import "DucNT_LoginSceen.h"
#import "CommonUtils.h"
@interface DucNT_ChuyenTienViDenViViewController () <UITextFieldDelegate, UIGestureRecognizerDelegate>
{
    NSString *mDinhDanhKetNoi;
    ViewNhapTenDaiDienXacThucThemTaiKhoanThuongDung *mViewNhapTenDaiDien;
    ViewQuangCao *viewQC;
    BOOL isLongPress;
}

@end

@implementation DucNT_ChuyenTienViDenViViewController

#pragma mark - life circle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mFuncID = FUNC_ID_CHUYEN_TIEN;
    self.bChuyenGiaoDien = NO;
    // Nhận thông tin từ danh sách tài khoản thường dùng (sau khi gọi từ chính form này)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateThongTin:) name:KEY_TAI_KHOAN_THUONG_DUNG object:nil];
    [self khoiTaoGiaoDien];
    [self khoiTaoTextField];
    [self khoiTaoViewNhapTenDaiDienXacThucTaiKhoan];
    if(!_mTaiKhoanThuongDung)
        [self xuLyHienThiSoTienPhiCuaSoTien:@"0"];
    else
        [self xuLyCapNhatTaiKhoanThuongDung];

    [self addButtonHuongDan];
    [self xuLyKetNoiLaySoDuTaiKhoan];

    [_btnTab1 setSelected:YES];

    isLongPress = NO;
    self.imgvQRCode.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longHander = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleHoldGesture:)];
    longHander.delegate = self;
    longHander.minimumPressDuration = 1;
    [self.imgvQRCode addGestureRecognizer:longHander];
    

}

- (void) handleHoldGesture:(UILongPressGestureRecognizer *)gestureRecognizer
{
    NSLog(@"%s - START", __FUNCTION__);
    if (!isLongPress) {
        isLongPress = YES;
        [self showThongBaoLuuQRCode];
    }
}

- (void)showThongBaoLuuQRCode {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Thông báo" message:@"Lưu ảnh QRCode vào thư viện ảnh của điện thoại?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Đóng" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        isLongPress = NO;
    }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Lưu" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImage *img = self.imgvQRCode.image;
        if (img != nil) {
            UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
        }
        [alert dismissViewControllerAnimated:YES completion:^{
        }];
    }];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)khoiTaoQuangCao {
    NSLog(@"%s - [UIScreen mainScreen].bounds.size.width : %f", __FUNCTION__, [UIScreen mainScreen].bounds.size.width);
    if (viewQC) {
        return;
    }
    viewQC = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ViewQuangCao class]) owner:self options:nil] objectAtIndex:0];
    CGRect rectToken = self.viewQR.frame;
    CGRect rectQC = viewQC.frame;
    CGRect rectMain = self.mViewMain.frame;
    NSLog(@"%s - rectMain.size.height 1 : %f", __FUNCTION__, rectToken.size.height);
    CGFloat fW = rectMain.size.width;
    CGFloat fH = rectQC.size.height * ((rectMain.size.width) / rectQC.size.width);
    rectQC.origin.y = rectToken.origin.y + 230.0;
    viewQC.frame = CGRectMake(0, rectQC.origin.y, fW, fH);
    viewQC.mDelegate = self;
    [viewQC updateSizeQuangCao];
    [self.viewVi addSubview:viewQC];
    NSLog(@"%s - rectMain.size.height 2 : %f - %f", __FUNCTION__, rectMain.size.height, self.heightViewMain.constant);
    NSLog(@"%s - rectMain.size.height 2 : %f", __FUNCTION__, rectMain.origin.y + rectMain.size.height + self.heightViewMain.constant);
    self.heightContentView.constant += rectQC.size.height;
//    [self.scrMain setContentSize:CGSizeMake(_scrMain.frame.size.width, rectMain.origin.y + rectMain.size.height + self.heightViewMain.constant + 1000)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.bChuyenGiaoDien = NO;
    [self setAnimationChoSoTay:self.btnSoTay];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.mtvNoiDungGiaoDich resignFirstResponder];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self khoiTaoQuangCao];
    });
    
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache removeImageForKey:self.mThongTinTaiKhoanVi.linkQR fromDisk:YES withCompletion:^{
        NSLog(@"%s - linkQR : %@", __FUNCTION__, self.mThongTinTaiKhoanVi.linkQR);
        [CommonUtils displayImage:[NSURL URLWithString:self.mThongTinTaiKhoanVi.linkQR] toImageView:self.imgvQRCode placeHolder:nil];
    }];
    self.lblTenChuVi.text = self.mThongTinTaiKhoanVi.sNameAlias;
    NSString *sDuongDanAnhDaiDien = self.mThongTinTaiKhoanVi.sLinkAnhDaiDien;
    NSLog(@"%s - sDuongDanAnhDaiDien : %@", __FUNCTION__, sDuongDanAnhDaiDien);
    [self.imgvAvatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://vimass.vn/vmbank/services/media/getImage?id=%@", sDuongDanAnhDaiDien]] placeholderImage:[UIImage imageNamed:@"icon_danhba"]];
    [self.scrMain setContentSize:CGSizeMake(_scrMain.frame.size.width, _scrMain.frame.origin.y + _scrMain.frame.size.height + 80)];
    if(![CommonUtils isEmptyOrNull:self.mThongTinTaiKhoanVi.pki3] && [self.mThongTinTaiKhoanVi.hanMucPki3 doubleValue] >0 ){
        self.mbtnPKI.hidden = NO;
    }
    else{
        self.mbtnPKI.hidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.btnSoTay.imageView stopAnimating];

}

- (void)didMoveToParentViewController:(UIViewController *)parent {

}

- (void)suKienBamNutHuongDanGiaoDichViewController:(UIButton *)sender {
    GiaoDienThongTinPhim *vc = [[GiaoDienThongTinPhim alloc] initWithNibName:@"GiaoDienThongTinPhim" bundle:nil];
    vc.nOption = HUONG_DAN_CHUYEN_TIEN_VI_VIMASS;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

#pragma mark - set & get

- (void)setMTaiKhoanThuongDung:(DucNT_TaiKhoanThuongDungObject *)mTaiKhoanThuongDung
{
    if(_mTaiKhoanThuongDung)
        [_mTaiKhoanThuongDung release];
    _mTaiKhoanThuongDung = [mTaiKhoanThuongDung retain];
    _mTaiKhoanThuongDung.sId = @"";
}

#pragma mark - khoiTao

- (void)khoiTaoGiaoDien
{
//    [self addButtonBack];
    [self addTitleView:[@"@title_chuyen_tien_den_vi" localizableString]];
}

- (void)khoiTaoTextField
{
    [self.mtfSoVi setTextError:[@"so_tai_khoan_khong_hop_le" localizableString]
                       forType:ExTextFieldTypeEmpty];
    
    [self.mtfSoTien setTextError:[@"@so_tien_khong_duoc_de_trong" localizableString]
                         forType:ExTextFieldTypeEmpty];
    [self.mtfSoTien setTextError:@"@so_tien_khong_hop_le" forType:ExTextFieldTypeMoney];

    self.mtvNoiDungGiaoDich.inputAccessoryView = nil;
    self.mtfNoiDung.inputAccessoryView = nil;
    self.mtfSoTien.inputAccessoryView = nil;
    self.mtfSoVi.inputAccessoryView = nil;
}

- (void)khoiTaoViewNhapTenDaiDienXacThucTaiKhoan
{
    if(!mViewNhapTenDaiDien)
    {
        mViewNhapTenDaiDien = [[[[NSBundle mainBundle] loadNibNamed:@"ViewNhapTenDaiDienXacThucThemTaiKhoanThuongDung" owner:self options:nil] objectAtIndex:0] retain];
    }
}

#pragma mark - overriden GiaoDichViewController

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    if(buttonIndex == 1)
    {
        if(alertView.tag == HOP_THOAI_XAC_NHAN_CHUYEN_TIEN_DEN_TAI_KHOAN_CHUA_DANG_KI_VI)
        {
            self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_CHUYEN_TIEN_DEN_SO_DIEN_THOAI_CHUA_CO_VI;
            [GiaoDichMang ketNoiChuyenTienDenViChuaDangKy:self.mtfSoVi.text noiNhanKetQua:self];
        }
    }
}

- (BOOL)validateVanTay
{
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return NO;
    }
    NSArray *tfs = @[_mtfSoVi, _mtfSoTien];
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
    if(![Common kiemTraSoTienMotLanChuyenHopLe:fSoTien])
    {
        [UIAlertView alert:@"chuyển đi tối thiểu là 10.000 đồng" withTitle:[@"thong_bao" localizableString] block:nil];
        return NO;
    }
    else if (fSoTien >= [self.mThongTinTaiKhoanVi.nAmount doubleValue]) {
        [UIAlertView alert:@"Số dư trong tài khoản không đủ" withTitle:[@"thong_bao" localizableString] block:nil];
        return NO;
    }
    else if (fSoTien > [self.mThongTinTaiKhoanVi.nHanMucDenVi doubleValue]) {
        [UIAlertView alert:@"Số tiền chuyển đi vượt quá hạn mức. Bạn có thể thay đổi hạn mức tại mục Thay đổi" withTitle:[@"thong_bao" localizableString] block:nil];
        return NO;
    }
    return flg;
}

- (void)xuLyThucHienKhiKiemTraThanhCongTraVeToken:(NSString*)sToken otp:(NSString*)sOtp
{
    self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_CHUYEN_TIEN_DEN_VI;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self hienThiLoading];
    }
    NSString *sSoTien = [_mtfSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    double fSoTien = [sSoTien doubleValue];
    int nHienSoVi = 0;
    if (self.switchHienSoVi.isOn) {
        nHienSoVi = 1;
    }
    [GiaoDichMang ketNoiChuyenTienDenViHienSoVi:self.mtfSoVi.text soTien:fSoTien noiDung:self.mtvNoiDungGiaoDich.text hienSoVi:nHienSoVi token:sToken otp:sOtp typeAuthenticate:self.mTypeAuthenticate noiNhanKetQua:self];
//    [GiaoDichMang ketNoiChuyenTienDenVi:self.mtfSoVi.text
//                                 soTien:fSoTien
//                                noiDung:self.mtvNoiDungGiaoDich.text
//                                  token:sToken
//                                    otp:sOtp
//                       typeAuthenticate:self.mTypeAuthenticate
//                          noiNhanKetQua:self];
}

- (void)xuLyKetNoiThanhCong:(NSString*)sDinhDanhKetNoi thongBao:(NSString*)sThongBao ketQua:(id)ketQua
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self anLoading];
    }
    if([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_CHUYEN_TIEN_DEN_VI])
    {
        [self hienThiHopThoaiMotNutBamKieu:HOP_THOAI_XAC_NHAN_CHUYEN_TIEN_THANH_CONG cauThongBao:sThongBao];
    }
    else if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_CHUYEN_TIEN_DEN_SO_DIEN_THOAI_CHUA_CO_VI])
    {
        [self hienThiHopThoaiMotNutBamKieu:HOP_THOAI_XAC_NHAN_CHUYEN_TIEN_THANH_CONG cauThongBao:sThongBao];
    }
}

- (void)xuLyKetNoiThatBai:(NSString*)sDinhDanhKetNoi thongBao:(NSString*)sThongBao ketQua:(id)ketQua
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self anLoading];
    }
    if([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_CHUYEN_TIEN_DEN_VI])
    {
        NSDictionary *dictKetQua = (NSDictionary*)ketQua;
        int nCode = [[dictKetQua objectForKey:@"msgCode"] intValue];
        NSString *message = [dictKetQua objectForKey:@"msgContent"];
        if(nCode == 14)
        {
            NSString *sCauThongBao = @"";
            if([Common kiemTraLaSoDienThoai:self.mtfSoVi.text])
            {
                sCauThongBao = [NSString stringWithFormat:[@"thong_bao_so_dien_thoai_chua_co_tk_vimass" localizableString], self.mtfSoVi.text, self.mtfSoTien.text];
            }
            else
            {
                sCauThongBao = [NSString stringWithFormat:[@"thong_bao_email_chua_co_tk_vimass" localizableString], self.mtfSoVi.text, self.mtfSoTien.text];
            }
            [self hienThiHopThoaiHaiNutBamKieu:HOP_THOAI_XAC_NHAN_CHUYEN_TIEN_DEN_TAI_KHOAN_CHUA_DANG_KI_VI cauThongBao:sCauThongBao];
        }
        else
        {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:message];
        }
    }
    else
    {
        [super xuLyKetNoiThatBai:sDinhDanhKetNoi thongBao:sThongBao ketQua:ketQua];
    }
}


#pragma mark - handler error

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - suKien
- (IBAction)changeSoTien:(id)sender
{
    NSString *sSoTien = [_mtfSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    _mtfSoTien.text = [Common hienThiTienTeFromString:sSoTien];
    if(![CommonUtils isEmptyOrNull:self.mThongTinTaiKhoanVi.pki3] && [self.mThongTinTaiKhoanVi.hanMucPki3 doubleValue] >0 ){
        if([sSoTien doubleValue] > [self.mThongTinTaiKhoanVi.hanMucPki3 doubleValue]){
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
    [self xuLyHienThiSoTienPhiCuaSoTien:sSoTien];
}

- (IBAction)suKienLayDanhBa:(id)sender
{
    ContactScreen *danhBa = [[[ContactScreen alloc] initWithNibName:@"ContactScreen" bundle:nil] autorelease];
    danhBa.mKieuHienThiLienHe = KIEU_HIEN_THI_LIEN_HE_THUONG;
    [self.navigationController pushViewController:danhBa animated:YES];
    __block DucNT_ChuyenTienViDenViViewController *weakSelf = self;
    [danhBa selectContact:^(NSString *phone)
     {
         NSLog(@"%s - phone : %@", __FUNCTION__, phone);
         if (phone != nil && phone.length > 0)
         {
             NSLog(@"%s - 2 phone : %@", __FUNCTION__, phone);
             if([Common kiemTraLaMail:phone])
             {
                 weakSelf.mtfSoVi.text = phone;
             }
             else
             {
                 weakSelf.mtfSoVi.text = [phone stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [phone length])];
             }
         }
         [danhBa.navigationController popViewControllerAnimated:YES];
     }];
}

- (IBAction)suKienLuuTaiKhoanThuongDung:(id)sender
{
    if([self validateVanTay])
    {
        [self.view endEditing:YES];
        [self themDanhSachThuongDung];
    }
}

- (IBAction)suKienLayDanhSachThuongDung:(id)sender {
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return;
    }
    DucNT_DanhSachTaiKhoanThuongDungControllerViewController *vc = [[DucNT_DanhSachTaiKhoanThuongDungControllerViewController alloc] initWithType:TAI_KHOAN_VI];
    [self.navigationController presentViewController:vc animated:YES completion:^{}];
    [vc release];
}

#pragma mark - xu Ly
- (void)xuLyCapNhatTaiKhoanThuongDung
{
    [self xuLyHienThiSoTienPhiCuaSoTien:[NSString stringWithFormat:@"%f", _mTaiKhoanThuongDung.nAmount]];
    if(_mTaiKhoanThuongDung.nAmount != 0)
    {
        self.mtfSoTien.text = [Common hienThiTienTe:_mTaiKhoanThuongDung.nAmount];
    }
    else
    {
        self.mtfSoTien.text = @"";
    }

    self.mtfSoVi.text = _mTaiKhoanThuongDung.sToAccWallet;
    self.mtvNoiDungGiaoDich.text = _mTaiKhoanThuongDung.sDesc;
}


- (void)xuLyHienThiSoTienPhiCuaSoTien:(NSString*)sSoTien
{
    float fSoTienPhi = [Common layPhiChuyenTienCuaSoTien:[sSoTien floatValue] kieuChuyenTien:KIEU_CHUYEN_TIEN_DEN_VI maNganHang:@""];
    NSString *sSoPhi = [Common hienThiTienTe:fSoTienPhi];
    self.mtfSoPhi.text = [sSoPhi stringByAppendingString:@" đ"];
}

-(void)updateThongTin:(NSNotification *)notification
{
    if([[notification name] isEqualToString:KEY_TAI_KHOAN_THUONG_DUNG])
    {
        self.mTaiKhoanThuongDung = [notification object];
        [self xuLyCapNhatTaiKhoanThuongDung];
    }
}

#pragma mark - xử lý dữ liệu cập thêm danh sách người dùng
/* sId = @"" -> thêm mới
 * sId.length > 0 -> cập nhật
 */
-(void)themDanhSachThuongDung
{
    if(!mViewNhapTenDaiDien.superview && [self validateVanTay])
    {
        if(!_mTaiKhoanThuongDung)
            _mTaiKhoanThuongDung = [[DucNT_TaiKhoanThuongDungObject alloc] init];
        mViewNhapTenDaiDien.frame = self.view.bounds;
        _mTaiKhoanThuongDung.sToAccWallet = self.mtfSoVi.text;
        _mTaiKhoanThuongDung.nAmount = [[self.mtfSoTien.text stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [self.mtfSoTien.text length])] doubleValue];
        _mTaiKhoanThuongDung.sDesc = self.mtvNoiDungGiaoDich.text;
        _mTaiKhoanThuongDung.sPhoneOwner = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
        _mTaiKhoanThuongDung.nType = TAI_KHOAN_VI;
        mViewNhapTenDaiDien.mTaiKhoanThuongDung = _mTaiKhoanThuongDung;
        mViewNhapTenDaiDien.mThongTinVi = self.mThongTinTaiKhoanVi;
        [self.view addSubview:mViewNhapTenDaiDien];
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *sSoTien = [textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
}
#pragma mark - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [viewQC dungChayQuangCao];
    if(_mTaiKhoanThuongDung)
        [_mTaiKhoanThuongDung release];
    if(mViewNhapTenDaiDien)
        [mViewNhapTenDaiDien release];
    [_mbtnLuuTaiKhoanThuongDung release];
    [_mtfSoVi release];
    [_mtfSoTien release];
    [_mtfSoPhi release];
    [_mtvNoiDungGiaoDich release];
    [_mtfNoiDung release];
    
    [_imgTab release];
    [_btnTab1 release];
    [_btnTab2 release];
    [_btnTab3 release];
    [_scrMain release];

    [_imgvQRCode release];
    [_imgvAvatar release];
    [_lblTenChuVi release];
    [_switchHienSoVi release];
    [_viewVi release];
    [_webTaiKhoan release];
    [_heightViewMain release];
    [_viewQR release];
    [_heightContentView release];
    [super dealloc];
}

- (IBAction)suKienThayDoiViChuyenDen:(id)sender {
//    NSString *temp = [_mtfSoVi.text uppercaseString];
//    NSLog(@"%s - temp : %@", __FUNCTION__, temp);
//    if (self.bChuyenGiaoDien) {
//        return;
//    }
//    if ([temp rangeOfString:@"HƯỚNG DẪN"].location != NSNotFound) {
//        self.bChuyenGiaoDien = YES;
//        [self suKienBamNutHuongDanGiaoDichViewController:nil];
//    }
//    else if ([temp rangeOfString:@"DANH BẠ"].location != NSNotFound) {
//        [self suKienLayDanhBa:nil];
//        self.bChuyenGiaoDien = YES;
//    }
//    else if ([temp rangeOfString:@"SỔ TAY"].location != NSNotFound) {
//        [self suKienLayDanhSachThuongDung:nil];
//        self.bChuyenGiaoDien = YES;
//    }
}

- (IBAction)suKienChonTab1:(id)sender {
    [_imgTab setImage:[UIImage imageNamed:@"tab-cat1"]];
    [_btnTab1 setSelected:YES];
    [_btnTab2 setSelected:NO];
    [_btnTab3 setSelected:NO];
    [self.viewVi setHidden:NO];
    [self.webTaiKhoan setHidden:YES];
}

- (IBAction)suKienChonTab2:(id)sender {
//    [_imgTab setImage:[UIImage imageNamed:@"tab-cat2"]];
//    [_btnTab2 setSelected:YES];
//    [_btnTab1 setSelected:NO];
//    [_btnTab3 setSelected:NO];
    
    NapViTuTheNganHangViewController *napViTuTheNganHangViewController = [[NapViTuTheNganHangViewController alloc] initWithNibName:@"NapViTuTheNganHangViewController" bundle:nil];
    [self.navigationController pushViewController:napViTuTheNganHangViewController animated:YES];
    [napViTuTheNganHangViewController release];
}

- (IBAction)suKienChonTab3:(id)sender {
    [_imgTab setImage:[UIImage imageNamed:@"tab-cat3"]];
    [_btnTab3 setSelected:YES];
    [_btnTab2 setSelected:NO];
    [_btnTab1 setSelected:NO];
    [self.viewVi setHidden:YES];
    [self.webTaiKhoan setHidden:NO];
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"huongdannaptien" ofType:@"txt"]];
    
    NSString *sXauHtml = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self.webTaiKhoan loadHTMLString:sXauHtml baseURL:nil];
}
@end
