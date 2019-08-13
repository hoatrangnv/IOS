//
//  GiaoDienChiTietSaoKe.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 4/6/16.
//
//

#import "GiaoDienChiTietSaoKe.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface GiaoDienChiTietSaoKe ()<UIWebViewDelegate> {
}
@property (retain, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *mainScroll;

@end

@implementation GiaoDienChiTietSaoKe

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitleView:[@"inquiry_detail_title" localizableString]];
    _sXauGuiMail = @"";
    self.viewKhieuNai.hidden = YES;
    [_tvKhieuNai resignFirstResponder];
    _tvKhieuNai.inputAccessoryView = nil;

    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, 0, 30, 30);
//    [button1 setImage:[UIImage imageNamed:@"hdsd-icon"]forState:UIControlStateNormal];

    button1.backgroundColor = [UIColor clearColor];
    button1.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [button1 addTarget:self action:@selector(suKienBamNutHuongDanSaoKe:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *leftItem = [[[UIBarButtonItem alloc] initWithCustomView:button1] autorelease];

    UIBarButtonItem *negativeSeperator = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];

    if (SYSTEM_VERSION_LESS_THAN(@"7"))
        negativeSeperator.width = -5;
    else
        negativeSeperator.width = -10;
    self.navigationItem.rightBarButtonItems = @[negativeSeperator, leftItem];
    
    [self khoiTaoSaoKe];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)khoiTaoSaoKe {
    if ([[DucNT_LuuRMS layThongTinTrongRMSTheoKey:KEY_LOGIN_STATE] boolValue] && !self.mThongTinTaiKhoanVi) {
        self.mThongTinTaiKhoanVi = [DucNT_LuuRMS layThongTinTaiKhoanVi];
    }
    if (_saoKe) {
        NSString *sHTML = [self updateView:_saoKe];
        NSLog(@"%s - line : %d - sHTML : %@", __FUNCTION__, __LINE__, sHTML);
        _sXauGuiMail = [[NSString alloc] initWithString:sHTML];
        [_webChiTiet loadHTMLString:[NSString stringWithFormat:@"<p style=\"font-size:20px;\">%@</p>", sHTML] baseURL:nil];
        [_webChiTiet setDelegate:self];
        [_btnMail setTitle:[NSString stringWithFormat:@"Gửi về %@", [self.mThongTinTaiKhoanVi layThuDienTu]] forState:UIControlStateNormal];
    }
    _webChiTiet.scrollView.scrollEnabled = NO;
    _webChiTiet.scrollView.bounces = NO;
    _webChiTiet.backgroundColor = [UIColor redColor];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    CGFloat height = webView.scrollView.contentSize.height;
//    height = 300;
    NSLog(@"%s - height : %f", __FUNCTION__, height);
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect rectWeb = webView.frame;
        rectWeb.size.height = height;
        webView.frame = rectWeb;
        
        CGRect rectKhieuNai = self.viewKhieuNai.frame;
        rectKhieuNai.origin.y = height + webView.frame.origin.y + 8;
        self.viewKhieuNai.frame = rectKhieuNai;
        CGRect v1 = self.viewBtnMail.frame;
        v1.origin.y = CGRectGetMaxY(webView.frame);
        self.viewBtnMail.frame = v1;
        CGRect vMain = self.mViewMain.frame;
        vMain.size.height = CGRectGetMaxY(self.viewBtnMail.frame) + 10;
        self.mViewMain.frame = vMain;
        self.mainScroll.contentSize = CGSizeMake(1,CGRectGetMaxY(self.mViewMain.frame) +20);
    });
}
-(NSString *)updateView:(DucNT_SaoKeObject*)item
{
    NSString *sDenTK = @"";
    NSString *sTenNguoiThuHuong = @"";
    NSString *sTenVietTat = @"";

//    NSMutableString *sXauTraVe = [[NSMutableString alloc] init];

    if(item.bankShortName && item.bankAcc && item.bankShortName.length > 0 && item.bankAcc.length > 0)
    {
        //tk ngan hang
        if(item.nameUsed && item.nameUsed.length > 0)
        {
            NSString *idVi = [DucNT_LuuRMS layThongTinTaiKhoanVi].sID;
            //thay doi ngay 25/11/2017
//            [item.fromAcc hasPrefix:idVi]
            if([item.feeAmount intValue] > 0)
            {
                sDenTK = item.nameUsed;
                sTenNguoiThuHuong = item.nameBenefit;
            }
            else
            {
                sDenTK = item.nameBenefit;
            }
        }
        else
        {
            sDenTK = item.nameBenefit;
        }
        sTenVietTat = [NSString stringWithFormat:@"%@ %@", item.bankShortName, item.bankAcc];
    }
    else if(item.bankAcc && item.bankAcc.length > 0)
    {
        //The ngan hang
        if(item.nameUsed && item.nameUsed.length > 0)
        {
            NSString *idVi = [DucNT_LuuRMS layThongTinTaiKhoanVi].sID;
            if([item.feeAmount intValue] > 0)
            {
                sDenTK = item.nameUsed;
                sTenNguoiThuHuong = item.bankAcc;
            }
            else
            {
                sDenTK = item.bankAcc;
            }
        }
        else
        {
            sDenTK = item.bankAcc;
        }
    }
    else
    {
        //Den vi
        if(item.nameUsed && item.nameUsed.length > 0)
        {
            NSString *idVi = [DucNT_LuuRMS layThongTinTaiKhoanVi].sID;
            if([item.feeAmount intValue] > 0)
            {
                sDenTK = item.nameUsed;
                sTenNguoiThuHuong = item.toAcc;
            }
            else
            {
                sDenTK = item.toAcc;
            }
        }
        else
        {
            sDenTK = item.toAcc;
        }
    }

    NSString *sFromAcc = @"";

    if([item.type integerValue] == 3)
    {
        sFromAcc = [NSString stringWithFormat:@"%@: %@", [@"qua_tang_tang" localizableString], item.fromAcc];
    }
    else
    {
        sFromAcc = [NSString stringWithFormat:@"%@: %@", [@"tu" localizableString], item.fromAcc];
    }
    
    if (item.VMApp != nil) {
        int nVM_APP = [item.VMApp intValue];
        switch (nVM_APP) {
            case 1:
                sFromAcc = [NSString stringWithFormat:@"%@ - %@", sFromAcc, @"ĐT Android"];
                break;
            case 2:
                sFromAcc = [NSString stringWithFormat:@"%@ - %@", sFromAcc, @"iPhone"];
                break;
            case 3:
                sFromAcc = [NSString stringWithFormat:@"%@ - %@", sFromAcc, @"ĐT Window Phone"];
                break;
            case 4:
                sFromAcc = [NSString stringWithFormat:@"%@ - %@", sFromAcc, @"Website"];
                break;
            case 5:
                sFromAcc = [NSString stringWithFormat:@"%@ - %@", sFromAcc, @"ĐT iPhone"];
                break;
            default:
                break;
        }
        
    }

    NSString *sAmount = @"";
    NSString *sSoDu = @"";
    NSString *idVi = [DucNT_LuuRMS layThongTinTaiKhoanVi].sID;
//    [item.fromAcc hasPrefix:idVi]
    if([item.feeAmount intValue] > 0)
    {
        sAmount = [NSString stringWithFormat:@"ST: - %@ đ", [Common hienThiTienTe:[item.amount doubleValue]]];
        if([item.type intValue] != 4)
        {
            // so du vi
            sSoDu = [NSString stringWithFormat:@"%@: %@ đ", [@"vi_con" localizableString], [Common hienThiTienTe:[item.totalAmount doubleValue]]];
        }
        else
        {
            // so du km
            sSoDu = [NSString stringWithFormat:@"%@: %@ đ", [@"du_km" localizableString], [Common hienThiTienTe:[item.totalPromotion doubleValue]]];
        }
    }
    else
    {
        sAmount = [NSString stringWithFormat:@"ST: +%@ đ", [Common hienThiTienTe:[item.amount doubleValue]]];
        if([item.type intValue] != 4)
        {
            // so du vi
            sSoDu = [NSString stringWithFormat:@"%@: %@ đ", [@"vi_con" localizableString], [Common hienThiTienTe:[item.totalAmountToAcc doubleValue]]];
        }
        else
        {
            // so du km
            sSoDu = [NSString stringWithFormat:@"%@: %@", [@"du_km" localizableString], [Common hienThiTienTe_1:[item.totalPromotionToAcc doubleValue]]];
        }
    }

    NSString *sNoiDung = @"";
    NSString *sDes = @"";
    if([item.type intValue] != 3 && [item.type intValue] != 4) {
        if (![[item layNoiDung] isEmpty]) {
            sDes = [NSString stringWithFormat:@"%@: %@", [@"title_noi_dung_viet_tat" localizableString], [item layNoiDung]];
        }
    }
    else {
        if (![[item layGiftName] isEmpty]) {
            sDes = [NSString stringWithFormat:@"%@ %@ : %@", [@"title_noi_dung_viet_tat" localizableString], [item layNoiDung], [item layGiftName]];
        }
    }
    //Tu
    sNoiDung = [NSString stringWithFormat:@"%@ <br/>", sFromAcc];
    //Den
    sNoiDung = [sNoiDung stringByAppendingFormat:@"%@ <br/>", [NSString stringWithFormat:@"%@: %@", [@"den" localizableString], sDenTK]];
    if(sTenNguoiThuHuong.length > 0) {
        sNoiDung = [sNoiDung stringByAppendingFormat:@"%@ <br/>", sTenNguoiThuHuong];
    }
    if(sTenVietTat.length > 0) {
        sNoiDung = [sNoiDung stringByAppendingFormat:@"%@ <br/>", sTenVietTat];
    }
    //soTien
    sNoiDung = [sNoiDung stringByAppendingFormat:@"%@ <br/>", sAmount];
    //sophi
    NSLog(@"%s - item.feeAmount : %@", __FUNCTION__, item.feeAmount);
    NSLog(@"%s - [item.feeAmount doubleValue] : % ", __FUNCTION__, [item.feeAmount doubleValue]);
    if ([item.feeAmount doubleValue] > 0) {
        sNoiDung = [sNoiDung stringByAppendingFormat:@"%@ <br/>", [NSString stringWithFormat:@"%@: %@ đ", [@"phi_chuyen_tien" localizableString], [Common hienThiTienTe:[item.feeAmount doubleValue]]]];
    }
    //noidung
    if (![sDes isEmpty] ) {
        sNoiDung = [sNoiDung stringByAppendingFormat:@"%@ <br/>", sDes];
    }

    //thoiDiem
    sNoiDung = [sNoiDung stringByAppendingFormat:@"%@ <br/>", [NSString stringWithFormat:@"%@: %@", [@"thoi_diem_giao_dich" localizableString],  [item layThoiGianChuyenTien]]];
    //======Đây là nơi xử lý mã CA======
    if ([item.donViXacThuc intValue] == 1) {
        sNoiDung = [sNoiDung stringByAppendingString:@"CA: Vina-CA<br/>"];
    }
    
    //soDu
    sNoiDung = [sNoiDung stringByAppendingFormat:@"%@ <br/>", sSoDu];
    if ([self.mThongTinTaiKhoanVi.nPromotionTotal doubleValue] > 0) {
        sNoiDung = [sNoiDung stringByAppendingFormat:@"%@: %@ đ<br/>", [@"du_km" localizableString], [Common hienThiTienTe:[self.mThongTinTaiKhoanVi.nPromotionTotal doubleValue]]];
    }
    
    
    
    return sNoiDung;
}

- (IBAction)suKienBamKhieuNai:(id)sender {
    self.viewBtnMail.hidden = true;
    self.viewKhieuNai.hidden = false;
    CGRect v1 = self.viewKhieuNai.frame;
    v1.origin.y = CGRectGetMaxY(_webChiTiet.frame);
    self.viewKhieuNai.frame = v1;
    CGRect vMain = self.mViewMain.frame;
    vMain.size.height = CGRectGetMaxY(self.viewKhieuNai.frame) + 10;
    self.mViewMain.frame = vMain;
    self.mainScroll.contentSize = CGSizeMake(1, CGRectGetMaxY(self.mViewMain.frame) + 20);
}

- (IBAction)suKienBamNutGuiMail:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.btnMail.enabled = NO;
        self.mDinhDanhKetNoi = @"GUI_VE_EMAIL";
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
            [self hienThiLoadingChuyenTien];
        }
        NSString *sEmail = [self.mThongTinTaiKhoanVi layThuDienTu];
        NSLog(@"%s - line : %d - sEmail : %@", __FUNCTION__, __LINE__, sEmail);
        NSLog(@"%s - line : %d - _sXauGuiMail : %@", __FUNCTION__, __LINE__, _sXauGuiMail);
        [GiaoDichMang ketNoiGuiMailSaoKeDen:sEmail
                                 tieuDeMail:@"Sao kê giao dịch ví điện tử"
                                    noiDung:_sXauGuiMail
                              noiNhanKetQua:self];
    });
    
}

- (IBAction)suKienBamNutGuiKhieuNai:(id)sender {
    NSString *sMailGui = [self.mThongTinTaiKhoanVi layThuDienTu];
    if (sMailGui.length == 0) {
        sMailGui = self.edEmail.text;
        if (sMailGui.length == 0) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập email của bạn"];
            return;
        }
    }
    [self hienThiLoading];
    _sXauGuiMail = [self updateView:_saoKe];
    NSString *sNoiDung = @"Người gửi: %@<br/>Email: %@<br/>SDT: %@<br/>Khiếu nại: %@<br/>%@";
    sNoiDung = [NSString stringWithFormat:sNoiDung, self.mThongTinTaiKhoanVi.sNameAlias, sMailGui, self.mThongTinTaiKhoanVi.sPhone, _tvKhieuNai.text, _sXauGuiMail];
    NSLog(@"%s - %s : sNoiDung : %@", __FILE__, __FUNCTION__, sNoiDung);
    self.mDinhDanhKetNoi = @"GUI_KHIEU_NAI";
    [GiaoDichMang ketNoiGuiMailSaoKeDen:@"VMhotro@gmail.com" tieuDeMail:@"Khiếu nại giao dịch Ví điện tử" noiDung:sNoiDung noiNhanKetQua:self];
}

- (void)xuLyKetNoiThanhCong:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua {
    if ([sDinhDanhKetNoi isEqualToString:@"GUI_KHIEU_NAI"]) {
        [self anLoading];
        self.viewBtnMail.hidden = NO;
        self.viewKhieuNai.hidden = YES;
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
    } else if ([sDinhDanhKetNoi isEqualToString:@"GUI_VE_EMAIL"]){
        [self anLoading];
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
    }
}

- (void)xuLyKetNoiThatBai:(NSString*)sDinhDanhKetNoi thongBao:(NSString*)sThongBao ketQua:(id)ketQua
{
    NSLog(@"%s - line : %d : START", __FUNCTION__, __LINE__);
    [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
    [self anLoading];
}

- (void)taoViewKhieuNai {
    CGRect rectViewKhieuNai = self.viewKhieuNai.frame;
    CGRect rectMain = self.mViewMain.frame;
    CGRect rectBtnMail = self.viewBtnMail.frame;
    rectViewKhieuNai.origin.y = rectBtnMail.origin.y;
    if ([self.mThongTinTaiKhoanVi layThuDienTu].length == 0) {
        self.edEmail.hidden = NO;
        CGRect rectEmail = self.edEmail.frame;
        CGRect rectBtnGuiKhieuNai = self.btnGuiKhieuNai.frame;
        rectBtnGuiKhieuNai.origin.y = rectEmail.origin.y + rectEmail.size.height + 8;
        rectViewKhieuNai.size.height = rectBtnGuiKhieuNai.origin.y + rectBtnGuiKhieuNai.size.height;
        self.btnGuiKhieuNai.frame = rectBtnGuiKhieuNai;
    }
    rectMain.size.height = rectViewKhieuNai.origin.y + rectViewKhieuNai.size.height + 10;
    self.viewKhieuNai.frame = rectViewKhieuNai;
    self.mViewMain.frame = rectMain;
    self.viewBtnMail.hidden = YES;
    self.viewKhieuNai.hidden = NO;

}

- (void)dealloc {
//    [_saoKe release];
//    [_sXauGuiMail release];
    [_webChiTiet release];
    [_btnMail release];
    [_viewKhieuNai release];
    [_viewBtnMail release];
    [_tvKhieuNai release];
    [_edEmail release];
    [_btnGuiKhieuNai release];
    [_mainScroll release];
    [super dealloc];
}
@end
