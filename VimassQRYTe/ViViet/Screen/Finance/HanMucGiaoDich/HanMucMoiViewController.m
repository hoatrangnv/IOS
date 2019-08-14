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
    [self addTitleView:[@"financer_viewer_bussiness_transaction_limit" localizableString]];
    self.mFuncID = 468;
    self.tfTimeMPKI.delegate = self;
    self.tfDayMPKI.delegate = self;
    
    _lblSoftToken.text = [@"han_muc_soft_token" localizableString];
    _lblMaxSoftToken.text = [@"han_muc_van_tay" localizableString];
    _lblMPKI.text = [@"han_muc_mki" localizableString];
    _lblMaxSoftToken.text = [@"han_muc_soft_token2" localizableString];
    _lblMaxVanTay.text = [@"han_muc_van_tay2" localizableString];
    _lblMaxMPKI.text = [@"han_muc_mki2" localizableString];
    
    _tfTimeSoftToken.placeholder = [@"place_holder_so_tien" localizableString];
    _tfDaySoftToken.placeholder = [@"place_holder_so_tien" localizableString];
//    _tfTimeVanTay.placeholder = [@"place_holder_so_tien" localizableString];
//    _tfDayVanTay.placeholder = [@"place_holder_so_tien" localizableString];
    _tfTimeMPKI.placeholder = [@"place_holder_so_tien" localizableString];
    _tfDayMPKI.placeholder = [@"place_holder_so_tien" localizableString];
    _tfMaXacThuc.placeholder = [@"mat_khau_token" localizableString];
    
    self.mbtnToken.hidden = NO;
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
        self.tfTimeSoftToken.text = [Common hienThiTienTe:[DucNT_LuuRMS layHanMuc:KEY_TIME_SOFT_TOKEN]];
        self.tfDaySoftToken.text = [Common hienThiTienTe:[DucNT_LuuRMS layHanMuc:KEY_DAY_SOFT_TOKEN]];

//        self.tfTimeVanTay.text = [Common hienThiTienTe:[DucNT_LuuRMS layHanMuc:KEY_TIME_VAN_TAY]];
//        self.tfDayVanTay.text = [Common hienThiTienTe:[DucNT_LuuRMS layHanMuc:KEY_DAY_VAN_TAY]];

        double timeMpki = [DucNT_LuuRMS layHanMuc:KEY_TIME_MPKI];
        double dayMpki = [DucNT_LuuRMS layHanMuc:KEY_DAY_MPKI];
//        NSLog(@"%s - timeMpki : %f - DBL_MAX : %f", __FUNCTION__, timeMpki, DBL_MAX);
        if (timeMpki == 0 || timeMpki == DBL_MAX || timeMpki == 2147483647) {
            self.tfTimeMPKI.text = @"";
        } else {
            self.tfTimeMPKI.text = [Common hienThiTienTe:timeMpki];
        }
        if (dayMpki == 0 || dayMpki == DBL_MAX || dayMpki == 2147483647) {
            self.tfDayMPKI.text = @"";
        } else {
            self.tfDayMPKI.text = [Common hienThiTienTe:dayMpki];
        }
//        double fSoTien1MPKI = [[self.tfTimeMPKI.text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
//        double fSoTien2MPKI = [[self.tfDayMPKI.text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
//        NSLog(@"%s - fSoTien1MPKI : %f - fSoTien2MPKI : %f", __FUNCTION__, fSoTien2MPKI, fSoTien2MPKI);
//        self.tfTimeSoftToken.text = [Common hienThiTienTe:[self.mThongTinTaiKhoanVi.hanMucTimeSoftToken doubleValue]];
//        self.tfDaySoftToken.text = [Common hienThiTienTe:[self.mThongTinTaiKhoanVi.hanMucDaySoftToken doubleValue]];
//
//        self.tfTimeVanTay.text = [Common hienThiTienTe:[self.mThongTinTaiKhoanVi.hanMucTimeVanTay doubleValue]];
//        self.tfDayVanTay.text = [Common hienThiTienTe:[self.mThongTinTaiKhoanVi.hanMucDayVanTay doubleValue]];
//
//        self.tfTimeMPKI.text = @"";
//        self.tfDayMPKI.text = @"";
    }
}

- (IBAction)suKienThayDoiGiaTriTextField:(UITextField*)sender
{
    NSString *sSoTien = [sender.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    [sender setText:[Common hienThiTienTeFromString:sSoTien]];
    if ([sender isEqual:_tfTimeMPKI] || [sender isEqual:_tfDayMPKI]) {
        if ([sSoTien isEmpty]) {
            self.btnVanTayMini.hidden = NO;
            self.mbtnToken.hidden = NO;
            self.mbtnPKI.hidden = NO;
        } else {
            self.btnVanTayMini.hidden = YES;
            self.mbtnToken.hidden = YES;
            self.mbtnPKI.hidden = NO;
        }
    }
}

- (void)hideViewNhapToken {
    
}

- (BOOL)validateVanTay {
    double fSoTien1Token = [[self.tfTimeSoftToken.text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
    double fSoTien2Token = [[self.tfDaySoftToken.text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
    if (fSoTien1Token > fSoTien2Token) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Hạn mức Token mỗi giao dịch phải nhỏ hơn hạn mức 1 ngày"];
        return NO;
    } else if (fSoTien1Token > [self.mThongTinTaiKhoanVi.hanMucTimeSoftTokenMax doubleValue]) {
        NSString *sTien = [NSString stringWithFormat:@"%f", [self.mThongTinTaiKhoanVi.hanMucTimeSoftTokenMax doubleValue]];
        NSString *sTien2 = [Common hienThiTienTeFromString:sTien];
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:[NSString stringWithFormat:@"Hạn mức tối đa chuyển tiền xác thực bằng Token là %@ đồng mỗi giao dịch.", sTien2]];
        return NO;
    }
    
//    double fSoTien1VanTay = [[self.tfTimeVanTay.text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
//    double fSoTien2VanTay = [[self.tfDayVanTay.text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
//    if (fSoTien1VanTay > fSoTien2VanTay) {
//        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Hạn mức Vân tay mỗi giao dịch phải nhỏ hơn hạn mức 1 ngày"];
//        return NO;
//    } else if (fSoTien1VanTay > [self.mThongTinTaiKhoanVi.hanMucTimeVanTayMax doubleValue]) {
//        NSString *sTien = [NSString stringWithFormat:@"%f", [self.mThongTinTaiKhoanVi.hanMucTimeVanTayMax doubleValue]];
//        NSString *sTien2 = [Common hienThiTienTeFromString:sTien];
//        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:[NSString stringWithFormat:@"Hạn mức tối đa chuyển tiền xác thực bằng Vân tay là %@ đồng mỗi giao dịch.", sTien2]];
//        return NO;
//    }
    
    if (!self.tfDayMPKI.text.isEmpty && !self.tfTimeMPKI.text.isEmpty) {
        double fSoTien1MPKI = [[self.tfTimeMPKI.text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
        double fSoTien2MPKI = [[self.tfDayMPKI.text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
        if (fSoTien1MPKI > fSoTien2MPKI) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Hạn mức mPKI mỗi giao dịch phải nhỏ hơn hạn mức 1 ngày"];
            return NO;
        }
        else if (fSoTien1MPKI > [self.mThongTinTaiKhoanVi.hanMucTimeMPKIMax doubleValue]) {
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
    [self.tfMaXacThuc setPlaceholder:[@"mat_khau_token" localizableString]];
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
    [self.tfMaXacThuc setPlaceholder:[@"chu_ky_mpki" localizableString]];
    [self.viewMaXacThuc setHidden:NO];
}

- (IBAction)suKienChonThucHien:(id)sender {
}

- (void)xuLyThucHienKhiKiemTraThanhCongTraVeToken:(NSString *)sToken otp:(NSString *)sOtp {
    self.mDinhDanhKetNoi = @"DINH_DANH_THAY_HAN_MUC";
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hienThiLoadingChuyenTien];
        });
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *sMaDoanhNghiep = @"";
        int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
        if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
        {
            sMaDoanhNghiep = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_COMPANY_ID];
        }
        
        double fSoTien1Token = [[self.tfTimeSoftToken.text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
        double fSoTien2Token = [[self.tfDaySoftToken.text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
        
//        double fSoTien1VanTay = [[self.tfTimeVanTay.text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
//        double fSoTien2VanTay = [[self.tfDayVanTay.text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
        
        double fSoTien1MPKI = [[self.tfTimeMPKI.text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
        double fSoTien2MPKI = [[self.tfDayMPKI.text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
        if (fSoTien1MPKI == 0) {
            fSoTien1MPKI = DBL_MAX;
        }
        if (fSoTien2MPKI == 0) {
            fSoTien2MPKI = DBL_MAX;
        }
        
        self.mThongTinTaiKhoanVi.hanMucTimeSoftToken = [NSNumber numberWithDouble:fSoTien1Token];
        self.mThongTinTaiKhoanVi.hanMucDaySoftToken = [NSNumber numberWithDouble:fSoTien2Token];
//        self.mThongTinTaiKhoanVi.hanMucTimeVanTay = [NSNumber numberWithDouble:fSoTien1VanTay];
//        self.mThongTinTaiKhoanVi.hanMucDayVanTay = [NSNumber numberWithDouble:fSoTien2VanTay];
        self.mThongTinTaiKhoanVi.hanMucTimeMPKI = [NSNumber numberWithDouble:fSoTien1MPKI];
        self.mThongTinTaiKhoanVi.hanMucDayMPKI = [NSNumber numberWithDouble:fSoTien2MPKI];
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
//        NSDictionary *dictVantay = @{
//                                     @"id":self.mThongTinTaiKhoanVi.idVantay,
//                                     @"user":[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
//                                     @"level":[NSNumber numberWithInt:3],
//                                     @"amountTime":[NSNumber numberWithInt:fSoTien1VanTay],
//                                     @"amountDay":[NSNumber numberWithInt:fSoTien2VanTay],
//                                     @"maxAmountTime":self.mThongTinTaiKhoanVi.hanMucTimeVanTayMax,
//                                     @"maxAmountDay":self.mThongTinTaiKhoanVi.hanMucDayVanTayMax
//                                     };
        NSDictionary *dictMPKI = @{
                                   @"id":self.mThongTinTaiKhoanVi.idMPKI,
                                   @"user":[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                                   @"level":[NSNumber numberWithInt:5],
                                   @"amountTime":[NSNumber numberWithInt:fSoTien1MPKI],
                                   @"amountDay":[NSNumber numberWithInt:fSoTien2MPKI],
                                   @"maxAmountTime":self.mThongTinTaiKhoanVi.hanMucTimeMPKIMax,
                                   @"maxAmountDay":self.mThongTinTaiKhoanVi.hanMucDayMPKIMax
                                   };
        [arrDict addObject:dictToken];
//        [arrDict addObject:dictVantay];
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
        NSString *sDictJson = [dicPost JSONString];
        NSLog(@"%s - sDictJson : %@", __FUNCTION__, sDictJson);
//        [GiaoDichMang keyNoiThayDoiHanMuc:sDictJson noiNhanKetQua:self];
        NSString *sUrl = @"https://vimass.vn/vmbank/services/hanMucViDienTu/edit";
        NSURL * url = [NSURL URLWithString:sUrl];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[sDictJson length]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
        request.timeoutInterval = 120;
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:[sDictJson dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
        NSLog(@"%s - sURL : %@", __FUNCTION__, sUrl);
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self anLoading];
            });
            
            if(httpResponse.statusCode == 200)
            {
                NSDictionary * dictResult = [data objectFromJSONData];
                NSLog(@"%s - dictResult : %@", __FUNCTION__, [dictResult JSONString]);
                int msgCode = [[dictResult valueForKey:@"msgCode"] intValue];
                NSString *sThongBao = (NSString *)[dictResult valueForKey:@"msgContent"];
                if (msgCode == 1) {
                    if (self.mThongTinTaiKhoanVi) {
                        NSLog(@"%s - self.mThongTinTaiKhoanVi : %@", __FUNCTION__, self.mThongTinTaiKhoanVi.hanMucTimeSoftToken);
                        DucNT_TaiKhoanViObject *newThongTin = [[DucNT_TaiKhoanViObject alloc] init];
                        newThongTin.sID = self.mThongTinTaiKhoanVi.sID;
                        newThongTin.sTenTaiKhoan = @"";
                        newThongTin.sTenNganHang = @"";
                        newThongTin.sThuDienTu = self.mThongTinTaiKhoanVi.sThuDienTu;
                        newThongTin.sNgaySinh = self.mThongTinTaiKhoanVi.sNgaySinh;
                        newThongTin.sCMND = self.mThongTinTaiKhoanVi.sCMND;
                        newThongTin.sNgayCapCMND = self.mThongTinTaiKhoanVi.sNgayCapCMND;
                        newThongTin.sNoiCapCMND = self.mThongTinTaiKhoanVi.sNoiCapCMND;
                        newThongTin.sDiaChiNha = self.mThongTinTaiKhoanVi.sDiaChiNha;
                        newThongTin.sLinkAnhTruocCMND = self.mThongTinTaiKhoanVi.sLinkAnhTruocCMND;
                        newThongTin.sLinkAnhSauCMND = self.mThongTinTaiKhoanVi.sLinkAnhSauCMND;
                        newThongTin.sLinkAnhChuKy = self.mThongTinTaiKhoanVi.sLinkAnhChuKy;
                        newThongTin.sLinkAnhDaiDien = self.mThongTinTaiKhoanVi.sLinkAnhDaiDien;
                        newThongTin.nIsToken = self.mThongTinTaiKhoanVi.nIsToken;
                        newThongTin.sNameAlias = self.mThongTinTaiKhoanVi.sNameAlias;
                        newThongTin.sPhone = self.mThongTinTaiKhoanVi.sPhone;
                        newThongTin.sTenCMND = self.mThongTinTaiKhoanVi.sTenCMND;
                        newThongTin.sPhoneAuthenticate = self.mThongTinTaiKhoanVi.sPhoneAuthenticate;
                        newThongTin.sPass = self.mThongTinTaiKhoanVi.sPass;
                        newThongTin.sPhoneToken = self.mThongTinTaiKhoanVi.sPhoneToken;
                        newThongTin.nAmount = self.mThongTinTaiKhoanVi.nAmount;
                        newThongTin.nPromotionStatus = self.mThongTinTaiKhoanVi.nPromotionStatus;
                        newThongTin.nPromotionTotal = self.mThongTinTaiKhoanVi.nPromotionTotal;
                        newThongTin.linkQR = self.mThongTinTaiKhoanVi.linkQR;
                        newThongTin.pki3 = self.mThongTinTaiKhoanVi.pki3;
                        newThongTin.hanMucPki3 = self.mThongTinTaiKhoanVi.hanMucPki3;
                        newThongTin.hienThiNoiDungThanhToanQR = self.mThongTinTaiKhoanVi.hienThiNoiDungThanhToanQR;
                        newThongTin.tKRutTien = self.mThongTinTaiKhoanVi.tKRutTien;
                        newThongTin.idSoftToken = self.mThongTinTaiKhoanVi.idSoftToken;
                        newThongTin.hanMucTimeSoftToken = self.mThongTinTaiKhoanVi.hanMucTimeSoftToken;
                        NSLog(@"%s - newThongTin.hanMucTimeSoftToken : %@", __FUNCTION__, newThongTin.hanMucTimeSoftToken);
                        newThongTin.hanMucDaySoftToken = self.mThongTinTaiKhoanVi.hanMucDaySoftToken;
                        newThongTin.hanMucTimeSoftTokenMax = self.mThongTinTaiKhoanVi.hanMucTimeSoftTokenMax;
                        newThongTin.hanMucDaySoftTokenMax = self.mThongTinTaiKhoanVi.hanMucDaySoftTokenMax;
                        newThongTin.idVantay = self.mThongTinTaiKhoanVi.idVantay;
                        newThongTin.hanMucTimeVanTay = self.mThongTinTaiKhoanVi.hanMucTimeVanTay;
                        newThongTin.hanMucDayVanTay = self.mThongTinTaiKhoanVi.hanMucDayVanTay;
                        newThongTin.hanMucTimeVanTayMax = self.mThongTinTaiKhoanVi.hanMucTimeVanTayMax;
                        newThongTin.hanMucDayVanTayMax = self.mThongTinTaiKhoanVi.hanMucDayVanTayMax;
                        newThongTin.idMPKI = self.mThongTinTaiKhoanVi.idMPKI;
                        newThongTin.hanMucTimeMPKI = self.mThongTinTaiKhoanVi.hanMucTimeMPKI;
                        newThongTin.hanMucDayMPKI = self.mThongTinTaiKhoanVi.hanMucDayMPKI;
                        newThongTin.hanMucTimeMPKIMax = self.mThongTinTaiKhoanVi.hanMucTimeMPKIMax;
                        newThongTin.hanMucDayMPKIMax = self.mThongTinTaiKhoanVi.hanMucDayMPKIMax;
                        
                        [DucNT_LuuRMS luuHanMuc:KEY_TIME_SOFT_TOKEN dHanMuc:[self.mThongTinTaiKhoanVi.hanMucTimeSoftToken doubleValue]];
                        [DucNT_LuuRMS luuHanMuc:KEY_DAY_SOFT_TOKEN dHanMuc:[self.mThongTinTaiKhoanVi.hanMucDaySoftToken doubleValue]];
                        [DucNT_LuuRMS luuHanMuc:KEY_TIME_VAN_TAY dHanMuc:[self.mThongTinTaiKhoanVi.hanMucTimeVanTay doubleValue]];
                        [DucNT_LuuRMS luuHanMuc:KEY_DAY_VAN_TAY dHanMuc:[self.mThongTinTaiKhoanVi.hanMucDayVanTay doubleValue]];
                        [DucNT_LuuRMS luuHanMuc:KEY_TIME_MPKI dHanMuc:[self.mThongTinTaiKhoanVi.hanMucTimeMPKI doubleValue]];
                        [DucNT_LuuRMS luuHanMuc:KEY_DAY_MPKI dHanMuc:[self.mThongTinTaiKhoanVi.hanMucDayMPKI doubleValue]];

                        [DucNT_LuuRMS luuThongTinTaiKhoanViSauDangNhap:newThongTin];
//                        AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
//                        app.objUpdateProfile = newThongTin;
//                        app.mThongTinTaiKhoanVi = newThongTin;
//                        //END
                        self.mThongTinTaiKhoanVi = newThongTin;
                        NSLog(@"%s - [DucNT_LuuRMS layHanMuc:KEY_TIME_SOFT_TOKEN] : %f", __FUNCTION__, [DucNT_LuuRMS layHanMuc:KEY_TIME_SOFT_TOKEN]);
                        [newThongTin release];
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
                    });
                }
            } else {
                
            }
        }];
        [task resume];
//        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//        [connection start];
    });
}

- (void)xuLyKetNoiThanhCong:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self anLoading];
    });
    if ([sDinhDanhKetNoi isEqualToString:@"DINH_DANH_THAY_HAN_MUC"]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
        if (self.mThongTinTaiKhoanVi) {
            [DucNT_LuuRMS luuThongTinTaiKhoanViSauDangNhap:self.mThongTinTaiKhoanVi];
        }
    }
}

- (void)xuLyKetNoiThatBai:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%s - an loading", __FUNCTION__);
        [self anLoading];
    });
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
//    [_tfTimeVanTay release];
//    [_tfDayVanTay release];
    [_tfTimeMPKI release];
    [_tfDayMPKI release];
    [_viewSMS release];
    [_viewToken release];
    [_viewMPKI release];
    NSLog(@"%s - =========+> dealloc", __FUNCTION__);
    [_lblSoftToken release];
    [_lblMaxSoftToken release];
    [_lblVanTay release];
    [_lblMaxVanTay release];
    [_lblMPKI release];
    [_lblMaxMPKI release];
    [super dealloc];
}
@end
