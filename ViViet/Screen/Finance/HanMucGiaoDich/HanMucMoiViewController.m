//
//  HanMucMoiViewController.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 11/15/18.
//

#import "HanMucMoiViewController.h"

@interface HanMucMoiViewController ()<UITextFieldDelegate>

@end

@implementation HanMucMoiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"Hạn mức";
    [self addTitleView:@"Hạn mức"];
    self.mFuncID = 468;
    self.tfTimeMPKI.delegate = self;
    self.tfDayMPKI.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (![self.scrMain.subviews containsObject:self.viewUI]) {
        self.viewUI.frame = CGRectMake(8, 8, self.scrMain.frame.size.width - 16, self.viewUI.frame.size.height - self.heightViewMaXacThuc.constant);
        self.viewUI.layer.cornerRadius = 8.0;
        [self.scrMain addSubview:self.viewUI];
        self.heightViewXacThuc.constant -= self.heightViewMaXacThuc.constant;
        self.heightViewMaXacThuc.constant = 0.0;
        [self.viewMaXacThuc setHidden:YES];
        [self.scrMain setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, self.viewUI.frame.size.height)];
    }
    
    if (self.mThongTinTaiKhoanVi) {
        self.tfTimeSoftToken.text = [Common hienThiTienTe:[self.mThongTinTaiKhoanVi.hanMucTimeSoftToken doubleValue]];
        self.tfDaySoftToken.text = [Common hienThiTienTe:[self.mThongTinTaiKhoanVi.hanMucDaySoftToken doubleValue]];
        
        self.tfTimeVanTay.text = [Common hienThiTienTe:[self.mThongTinTaiKhoanVi.hanMucTimeVanTay doubleValue]];
        self.tfDayVanTay.text = [Common hienThiTienTe:[self.mThongTinTaiKhoanVi.hanMucDayVanTay doubleValue]];
        
        self.tfTimeMPKI.text = @"";
        self.tfDayMPKI.text = @"";
    }
}

- (void)hideViewNhapToken {
    
}

- (BOOL)validateVanTay {
    double fSoTien1Token = [[self.tfTimeSoftToken.text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
    double fSoTien2Token = [[self.tfDaySoftToken.text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
    if (fSoTien1Token > fSoTien2Token) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Hạn mức Soft Token mỗi giao dịch phải nhỏ hơn hạn mức 1 ngày"];
        return NO;
    } else if (fSoTien1Token > [self.mThongTinTaiKhoanVi.hanMucTimeSoftTokenMax doubleValue]) {
        NSString *sTien = [NSString stringWithFormat:@"%f", [self.mThongTinTaiKhoanVi.hanMucTimeSoftTokenMax doubleValue]];
        NSString *sTien2 = [Common hienThiTienTeFromString:sTien];
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:[NSString stringWithFormat:@"Hạn mức tối đa chuyển tiền xác thực bằng Soft Token là %@ đồng mỗi giao dịch.", sTien2]];
        return NO;
    }
    
    double fSoTien1VanTay = [[self.tfTimeVanTay.text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
    double fSoTien2VanTay = [[self.tfDayVanTay.text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
    if (fSoTien1VanTay > fSoTien2VanTay) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Hạn mức Vân tay mỗi giao dịch phải nhỏ hơn hạn mức 1 ngày"];
        return NO;
    } else if (fSoTien1VanTay > [self.mThongTinTaiKhoanVi.hanMucTimeVanTayMax doubleValue]) {
        NSString *sTien = [NSString stringWithFormat:@"%f", [self.mThongTinTaiKhoanVi.hanMucTimeVanTayMax doubleValue]];
        NSString *sTien2 = [Common hienThiTienTeFromString:sTien];
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:[NSString stringWithFormat:@"Hạn mức tối đa chuyển tiền xác thực bằng Vân tay là %@ đồng mỗi giao dịch.", sTien2]];
        return NO;
    }
    
    if (!self.tfDayMPKI.text.isEmpty && !self.tfTimeMPKI.text.isEmpty) {
        double fSoTien1MPKI = [[self.tfTimeMPKI.text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
        double fSoTien2MPKI = [[self.tfDayMPKI.text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
        if (fSoTien1MPKI > fSoTien2MPKI) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Hạn mức mPKI mỗi giao dịch phải nhỏ hơn hạn mức 1 ngày"];
            return NO;
        }
        else if (fSoTien1VanTay > [self.mThongTinTaiKhoanVi.hanMucTimeMPKIMax doubleValue]) {
            NSString *sTien = [NSString stringWithFormat:@"%f", [self.mThongTinTaiKhoanVi.hanMucTimeMPKIMax doubleValue]];
            NSString *sTien2 = [Common hienThiTienTeFromString:sTien];
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:[NSString stringWithFormat:@"Hạn mức tối đa chuyển tiền xác thực bằng mPKI là %@ đồng mỗi giao dịch.", sTien2]];
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    [self.viewSMS setHidden:![textField.text isEmpty]];
    [self.viewToken setHidden:![textField.text isEmpty]];
    return YES;
}

- (IBAction)suKienChonSMS:(id)sender {
    if (self.heightViewMaXacThuc.constant > 0) {
        CGRect frame = self.viewUI.frame;
        self.heightViewXacThuc.constant -= self.heightViewMaXacThuc.constant;
        frame.size.height -= self.heightViewMaXacThuc.constant;
        self.viewUI.frame = frame;
        self.heightViewMaXacThuc.constant = 0;
    }
    [self.viewMaXacThuc setHidden:YES];
}

- (IBAction)suKienChonToken:(id)sender {
    if (self.heightViewMaXacThuc.constant == 0.0) {
        self.heightViewMaXacThuc.constant = 40.0;
        self.heightViewXacThuc.constant += self.heightViewMaXacThuc.constant;
        CGRect frame = self.viewUI.frame;
        frame.size.height += self.heightViewMaXacThuc.constant;
        self.viewUI.frame = frame;
    }
    [self.tfMaXacThuc setPlaceholder:@"Mật khẩu token"];
    [self.viewMaXacThuc setHidden:NO];
}

- (IBAction)suKienChonMKPI:(id)sender {
    if (self.heightViewMaXacThuc.constant == 0.0) {
        self.heightViewMaXacThuc.constant = 40.0;
        self.heightViewXacThuc.constant += self.heightViewMaXacThuc.constant;
        CGRect frame = self.viewUI.frame;
        frame.size.height += self.heightViewMaXacThuc.constant;
        self.viewUI.frame = frame;
    }
    [self.tfMaXacThuc setPlaceholder:@"Chữ ký mPKI"];
    [self.viewMaXacThuc setHidden:NO];
}

- (IBAction)suKienChonThucHien:(id)sender {
}

- (void)xuLyThucHienKhiKiemTraThanhCongTraVeToken:(NSString *)sToken otp:(NSString *)sOtp {
    self.mDinhDanhKetNoi = @"DINH_DANH_THAY_HAN_MUC";
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self hienThiLoadingChuyenTien];
    }
    NSString *sMaDoanhNghiep = @"";
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sMaDoanhNghiep = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_COMPANY_ID];
    }
    
    double fSoTien1Token = [[self.tfTimeSoftToken.text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
    double fSoTien2Token = [[self.tfDaySoftToken.text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];

    double fSoTien1VanTay = [[self.tfTimeVanTay.text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
    double fSoTien2VanTay = [[self.tfDayVanTay.text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
    
    double fSoTien1MPKI = [[self.tfTimeMPKI.text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
    double fSoTien2MPKI = [[self.tfDayMPKI.text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
    if (fSoTien1MPKI == 0) {
        fSoTien1MPKI = DBL_MAX;
    }
    if (fSoTien2MPKI == 0) {
        fSoTien2MPKI = DBL_MAX;
    }
    
    NSMutableArray *arrDict = [[NSMutableArray alloc] init];
    NSDictionary *dictToken = @{
                                @"id":self.mThongTinTaiKhoanVi.idSoftToken,
                                @"user":[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                                @"level":[NSNumber numberWithInt:1],
                                @"amountTime":[NSNumber numberWithInt:fSoTien1Token],
                                @"amountDay":[NSNumber numberWithInt:fSoTien2Token],
                                @"maxAmountTime":self.mThongTinTaiKhoanVi.hanMucTimeSoftTokenMax,
                                @"maxAmountDay":self.mThongTinTaiKhoanVi.hanMucDaySoftTokenMax
                                };
    NSDictionary *dictVantay = @{
                                @"id":self.mThongTinTaiKhoanVi.idVantay,
                                @"user":[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                                @"level":[NSNumber numberWithInt:3],
                                @"amountTime":[NSNumber numberWithInt:fSoTien1VanTay],
                                @"amountDay":[NSNumber numberWithInt:fSoTien2VanTay],
                                @"maxAmountTime":self.mThongTinTaiKhoanVi.hanMucTimeVanTayMax,
                                @"maxAmountDay":self.mThongTinTaiKhoanVi.hanMucDayVanTayMax
                                };
    NSDictionary *dictMPKI = @{
                                @"id":self.mThongTinTaiKhoanVi.idSoftToken,
                                @"user":[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                                @"level":[NSNumber numberWithInt:5],
                                @"amountTime":[NSNumber numberWithInt:fSoTien1MPKI],
                                @"amountDay":[NSNumber numberWithInt:fSoTien2MPKI],
                                @"maxAmountTime":self.mThongTinTaiKhoanVi.hanMucTimeMPKIMax,
                                @"maxAmountDay":self.mThongTinTaiKhoanVi.hanMucDayMPKIMax
                                };
    [arrDict addObject:dictToken];
    [arrDict addObject:dictVantay];
    [arrDict addObject:dictMPKI];
    
    NSDictionary *dicPost = @{
                              @"companyCode":sMaDoanhNghiep,
                              @"token":sToken,
                              @"type":[NSNumber numberWithInt:1],
                              @"appId" : [NSString stringWithFormat:@"%d", APP_ID],
                              @"otpConfirm": sOtp,
                              @"typeAuthenticate": [NSNumber numberWithInt:self.mTypeAuthenticate],
                              @"VMApp" : [NSNumber numberWithInt:VM_APP],
                              @"dsHanMuc":arrDict,
                              @"idOwner":self.mThongTinTaiKhoanVi.sID
                              };
    [GiaoDichMang keyNoiThayDoiHanMuc:[dicPost JSONString] noiNhanKetQua:self];
}

- (void)xuLyKetNoiThanhCong:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self anLoading];
    }
    if ([sDinhDanhKetNoi isEqualToString:@"DINH_DANH_THAY_HAN_MUC"]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
    }
}

- (void)xuLyKetNoiThatBai:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self anLoading];
    }
    [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
}

- (void)dealloc {
    [_scrMain release];
    [_viewUI release];
    [_heightViewXacThuc release];
    [_heightViewMaXacThuc release];
    [_btnSMS release];
    [_btnToken release];
    [_btnMKPI release];
    [_viewMaXacThuc release];
    [_tfMaXacThuc release];
    [_tfTimeSoftToken release];
    [_tfDaySoftToken release];
    [_tfTimeVanTay release];
    [_tfDayVanTay release];
    [_tfTimeMPKI release];
    [_tfDayMPKI release];
    [_viewSMS release];
    [_viewToken release];
    [_viewMPKI release];
    [super dealloc];
}
@end
