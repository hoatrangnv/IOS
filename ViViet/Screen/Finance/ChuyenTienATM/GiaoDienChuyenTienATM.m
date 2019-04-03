//
//  GiaoDienChuyenTienATM.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 2/5/16.
//
//

#import "GiaoDienChuyenTienATM.h"
#import "DucNT_DanhSachTaiKhoanThuongDungControllerViewController.h"
#import "ContactScreen.h"
#import "GiaoDienThongTinPhim.h"
#import "GiaoDienDiemGiaoDichV2.h"
#import "DucNT_LoginSceen.h"
#import "CommonUtils.h"

@interface GiaoDienChuyenTienATM () <UITextFieldDelegate>{
    int nMaATM;
    ViewQuangCao *viewQC;
}

@end

@implementation GiaoDienChuyenTienATM

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mFuncID = 441;
    nMaATM = 0;
    [self addTitleView:[@"financer_viewer_atm" localizableString]];

    self.edNoiDung.inputAccessoryView = nil;
    self.edSoTien.inputAccessoryView = nil;
    self.edViNhan.inputAccessoryView = nil;
    self.tvNoiDung.inputAccessoryView = nil;
    [self addRightButton];
    self.edViNhan.text = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateThongTinATM:) name:KEY_TAI_KHOAN_THUONG_DUNG object:nil];
    
    [self.edSoTien setDelegate:self];
    _edSoTien.placeholder = [@"amount" localizableString];
    _edViNhan.placeholder = [@"sdt_nhan_tien_tai_atm" localizableString];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tvNoiDung resignFirstResponder];
    [self setAnimationChoSoTay:self.btnSoTay];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_nIndexBank == 0) {
        nMaATM = 0;
        [self thayDoiAnhTimATM];
        [self thayDoiTrangThaiButton:_nIndexBank];
    }
    else if (_nIndexBank == 1) {
        nMaATM = 1;
        [self thayDoiAnhTimATM];
        [self thayDoiTrangThaiButton:_nIndexBank];
    }
    else {
        nMaATM = 2;
        [self thayDoiAnhTimATM];
        [self thayDoiTrangThaiButton:_nIndexBank];
    }
    
//    [self khoiTaoQuangCao];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.btnSoTay.imageView stopAnimating];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"%s -------> textField : %@", __FUNCTION__, textField.text);
    return YES;
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    NSLog(@"%s -------> START", __FUNCTION__);

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
        rectQC.origin.y = rectToken.origin.y + 8;
        viewQC.frame = CGRectMake(0, rectQC.origin.y, fW, fH);
        viewQC.mDelegate = self;
        [viewQC updateSizeQuangCao];
        self.heightViewMain.constant = rectQC.origin.y + rectQC.size.height;
//        rectMain.size.height = rectQC.origin.y + rectQC.size.height;
//        self.mViewMain.frame = rectMain;
        [self.mViewMain addSubview:viewQC];
        [self.scrMain setContentSize:CGSizeMake(_scrMain.frame.size.width, self.heightViewMain.constant + 10)];
    }
}

- (void)showViewNhapToken:(int)type {
    [super showViewNhapToken:type];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.heightViewMain.constant += 35.0;
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
        if (viewQC != nil) {
            CGRect rectQC = viewQC.frame;
            rectQC.origin.y -= 35.0;
            viewQC.frame = rectQC;
        }
    });
}

- (void)addRightButton{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 34, 34);
    [button setImage:[UIImage imageNamed:@"hdsd-icon"]forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [button addTarget:self action:@selector(suKienBamNutHuongDanChuyenTienATM:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *leftItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];

    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(0, 0, 25, 25);
    [button2 setImage:[UIImage imageNamed:@"icon_atm_sacombank"]forState:UIControlStateNormal];
    button2.backgroundColor = [UIColor clearColor];
    button2.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [button2 addTarget:self action:@selector(suKienBamNutTimATM:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *leftItem2 = [[[UIBarButtonItem alloc] initWithCustomView:button2] autorelease];

    UIBarButtonItem *negativeSeperator = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];

    if (SYSTEM_VERSION_LESS_THAN(@"11"))
        negativeSeperator.width = -10;
    else {
        negativeSeperator.width = -15;
        [button.widthAnchor constraintEqualToConstant:34].active = YES;
        [button.heightAnchor constraintEqualToConstant:34].active = YES;

        [button2.widthAnchor constraintEqualToConstant:25].active = YES;
        [button2.heightAnchor constraintEqualToConstant:25].active = YES;
    }

    self.navigationItem.rightBarButtonItems = @[negativeSeperator, leftItem, leftItem2];
}

-(void)updateThongTinATM:(NSNotification *)notification {
    if([[notification name] isEqualToString:KEY_TAI_KHOAN_THUONG_DUNG])
    {
        DucNT_TaiKhoanThuongDungObject *temp = [notification object];
        NSLog(@"%s - [[temp toDict] JSONString] : %@", __FUNCTION__, [[temp toDict] JSONString]);
        nMaATM = temp.maATM;
        if (temp.maATM == 0) {
            _nIndexBank = 0;
        }
        else if (temp.maATM == 1) {
            _nIndexBank = 1;
        }
        else {
            _nIndexBank = 2;
        }
        [self thayDoiAnhTimATM];
        [self thayDoiTrangThaiButton:_nIndexBank];
        self.tvNoiDung.text = temp.noiDung;
        self.edSoTien.text = [Common hienThiTienTe:temp.soTien];
        self.edViNhan.text = temp.soDienThoai;
    }
}

- (void)suKienBamNutHuongDanChuyenTienATM:(UIButton *)sender
{
    GiaoDienThongTinPhim *vc = [[GiaoDienThongTinPhim alloc] initWithNibName:@"GiaoDienThongTinPhim" bundle:nil];
    if (_nIndexBank == 0) {
        vc.nOption = HUONG_DAN_SACOMBANK;
    }
    else if (_nIndexBank == 1) {
        vc.nOption = HUONG_DAN_TECHCOMBANK;
    }
    else if (_nIndexBank == 2) {
        vc.nOption = HUONG_DAN_VIETINBANK;
    }
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)suKienBamNutTimATM:(UIButton *)sender {
    NSString *sKeyWord = @"";
    if (_nIndexBank == 0) {
        sKeyWord = @"sacombank";
    }
    else if (_nIndexBank == 1){
        sKeyWord = @"techcombank";
    }
    else if (_nIndexBank == 2){
        sKeyWord = @"vietinbank";
    }
    GiaoDienDiemGiaoDichV2 *vc = [[GiaoDienDiemGiaoDichV2 alloc] initWithNibName:@"GiaoDienDiemGiaoDichV2" bundle:nil];
    vc.nIndexLuaChon = 1;
    vc.sKeyWord = sKeyWord;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)thayDoiAnhTimATM{
    NSArray *arrButton = self.navigationItem.rightBarButtonItems;
    UIBarButtonItem *barAtm = [arrButton objectAtIndex:2];
    UIButton *btn = barAtm.customView;
    if (_nIndexBank == 0) {
        [btn setImage:[UIImage imageNamed:@"icon_atm_sacombank"] forState:UIControlStateNormal];
    }
    else if (_nIndexBank == 1) {
        [btn setImage:[UIImage imageNamed:@"icon_atm_techcombank"] forState:UIControlStateNormal];
    }
    else if (_nIndexBank == 2) {
        [btn setImage:[UIImage imageNamed:@"icon_atm_vietin"] forState:UIControlStateNormal];
    }
}

- (void)xuLyKetNoiThanhCong:(NSString*)sDinhDanhKetNoi thongBao:(NSString*)sThongBao ketQua:(id)ketQua
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self anLoading];
    }
    if ([sDinhDanhKetNoi isEqualToString:@"CHUYEN_TIEN_ATM"]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
    }
}

- (void)xuLyThucHienKhiKiemTraThanhCongTraVeToken:(NSString*)sToken otp:(NSString*)sOtp
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
            [self hienThiLoading];
        }
        self.mDinhDanhKetNoi = @"CHUYEN_TIEN_ATM";
        double fSoTien = [[_edSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
        [GiaoDichMang chuyenTienDenATM:_edViNhan.text soTien:fSoTien maATM:nMaATM token:sToken otpConfirm:sOtp typeAuthenticate:self.mTypeAuthenticate noiDung:_tvNoiDung.text noiNhanKetQua:self];
    });
}

- (BOOL)validateVanTay{
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return NO;
    }
    if ([_edViNhan.text isEmpty]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:[@"vui_long_nhap_sdt_nhan_tien" localizableString]];
        return NO;
    }
    if ([_edSoTien.text isEmpty]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:[@"amount_empty" localizableString]];
        return NO;
    }
    else{
        int fSoTien = [[_edSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""] intValue];
        int nSoTienChia = 10000;
        if (nMaATM == 1 || nMaATM == 2) {
            nSoTienChia = 50000;
        }
        if (fSoTien < nSoTienChia) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:[NSString stringWithFormat:@"%@ %@ đ", [@"so_tien_chuyen_di_phai_lon_hon" localizableString], [Common hienThiTienTe:nSoTienChia]]];
            return NO;
        }
        else if (fSoTien % nSoTienChia != 0){
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:[NSString stringWithFormat:@"%@ %@ đ", [@"so_tien_chuyen_di_la_boi" localizableString], [Common hienThiTienTe:nSoTienChia]]];
            return NO;
        }
        else if (fSoTien >= [self.mThongTinTaiKhoanVi.nAmount doubleValue]) {
            [UIAlertView alert:[@"so_du_khong_du" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
            return NO;
        }
    }
    return YES;
}

- (IBAction)hienThiSoTien:(id)sender {
    NSString *sSoTien = [_edSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    _edSoTien.text = [Common hienThiTienTeFromString:sSoTien];
//    if(![CommonUtils isEmptyOrNull:self.mThongTinTaiKhoanVi.pki3] && [self.mThongTinTaiKhoanVi.hanMucPki3 doubleValue] >0 ){
//        if([sSoTien doubleValue] > [self.mThongTinTaiKhoanVi.hanMucPki3 doubleValue]){
//            self.mbtnSMS.hidden = YES;
//            self.mbtnToken.hidden = YES;
//            self.mbtnEmail.hidden = YES;
//            self.mbtnPKI.hidden = NO;
//        }
//        else{
//            self.mbtnSMS.hidden = NO;
//            
//            self.mbtnToken.hidden = NO;
//            
//            self.mbtnEmail.hidden = NO;
//            
//            self.mbtnPKI.hidden = NO;
//        }
//    }
//    else{
//        self.mbtnPKI.hidden = YES;
//        self.mbtnToken.hidden = NO;
//        self.mbtnSMS.hidden = NO;
//        self.mbtnEmail.hidden = NO;
//    }
}

- (IBAction)suKienChonDanhBa:(id)sender {
    ContactScreen *danhBa = [[[ContactScreen alloc] initWithNibName:@"ContactScreen" bundle:nil] autorelease];
    danhBa.mKieuHienThiLienHe = KIEU_HIEN_THI_LIEN_HE_THUONG;
    [self.navigationController pushViewController:danhBa animated:YES];
    __block GiaoDienChuyenTienATM *weakSelf = self;
    [danhBa selectContact:^(NSString *phone, Contact *contact)
     {
         if (phone != nil && phone.length > 0)
         {
             if([Common kiemTraLaMail:phone])
             {
                 weakSelf.edViNhan.text = phone;
             }
             else
             {
                 weakSelf.edViNhan.text = [phone stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [phone length])];
             }
         }
         [danhBa.navigationController popViewControllerAnimated:YES];
     }];
}

- (IBAction)suKienChonSoTay:(id)sender {
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return;
    }
    DucNT_DanhSachTaiKhoanThuongDungControllerViewController *vc = [[DucNT_DanhSachTaiKhoanThuongDungControllerViewController alloc] initWithType:TAI_KHOAN_CHUYEN_TIEN_ATM];
    [self.navigationController presentViewController:vc animated:YES completion:^{}];
    [vc release];
}

- (IBAction)suKienChonSacombank:(id)sender {
    if (_nIndexBank == 0) {
        return;
    }
    nMaATM = 0;
    _nIndexBank = 0;
    [self thayDoiAnhTimATM];
    [self thayDoiTrangThaiButton:0];
}

- (IBAction)suKienChonTechcombank:(id)sender {
    if (_nIndexBank == 1) {
        return;
    }
    nMaATM = 1;
    _nIndexBank = 1;
    [self thayDoiAnhTimATM];
    [self thayDoiTrangThaiButton:1];
}

- (IBAction)suKienChonVietinbank:(id)sender {
    if (_nIndexBank == 2) {
        return;
    }
    _nIndexBank = 2;
    nMaATM = 2;
    [self thayDoiAnhTimATM];
    [self thayDoiTrangThaiButton:2];
}

- (void)thayDoiTrangThaiButton:(int)row {
    switch (row) {
        case 0:
            [self doiTrangThaiButton1:self.btnSacomBank];
            [self doiTrangThaiButton2:self.btnTechcombank];
            [self doiTrangThaiButton2:self.btnVietinbank];
            
            self.lblPhi.text = [NSString stringWithFormat:@"%@: %@", [@"phi_chuyen_tien" localizableString], @"10.000 đ"];
            if (![self.edSoTien.text isEmpty]) {
                int fSoTien = [[_edSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""] intValue];
                if (fSoTien > 5000000) {
                    self.lblPhi.text = [NSString stringWithFormat:@"%@: %@", [@"phi_chuyen_tien" localizableString], @"13.200 đ"];
                }
            }
            break;
        case 1:
            [self doiTrangThaiButton2:self.btnSacomBank];
            [self doiTrangThaiButton1:self.btnTechcombank];
            [self doiTrangThaiButton2:self.btnVietinbank];
            self.lblPhi.text = [NSString stringWithFormat:@"%@: %@", [@"phi_chuyen_tien" localizableString], @"6.600 đ"];
            
            break;
        case 2:
            [self doiTrangThaiButton2:self.btnSacomBank];
            [self doiTrangThaiButton2:self.btnTechcombank];
            [self doiTrangThaiButton1:self.btnVietinbank];
            self.lblPhi.text = [NSString stringWithFormat:@"%@: %@", [@"phi_chuyen_tien" localizableString], @"6.600 đ"];
            break;
        default:
            break;
    }
}

- (void)doiTrangThaiButton1:(UIButton *)btn {
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor clearColor];
}

- (void)doiTrangThaiButton2:(UIButton *)btn {
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
}

- (void)dealloc {
    [viewQC release];
    [_edViNhan release];
    [_edSoTien release];
    [_edNoiDung release];
    [_tvNoiDung release];
    [_btnSacomBank release];
    [_btnTechcombank release];
    [_btnVietinbank release];
    [_lblPhi release];
    [_heightViewMain release];
    [super dealloc];
}
@end
