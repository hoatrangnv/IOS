//
//  GiaoDienChiTietSaoKe.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 4/6/16.
//
//

#import "GiaoDienChiTietSaoKe.h"

@interface GiaoDienChiTietSaoKe ()<UIWebViewDelegate> {
}

@end

@implementation GiaoDienChiTietSaoKe

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitleView:@"Chi tiết sao kê"];
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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_saoKe) {
        NSString *sHTML = [self updateView:_saoKe];
        _sXauGuiMail = sHTML;
        [_webChiTiet loadHTMLString:sHTML baseURL:nil];
        [_webChiTiet setDelegate:self];
        [_btnMail setTitle:[NSString stringWithFormat:@"Gửi về %@", [self.mThongTinTaiKhoanVi layThuDienTu]] forState:UIControlStateNormal];
    }
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *fontSize=@"143";
    NSString *jsString = [[NSString alloc]      initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'",[fontSize intValue]];
    [_webChiTiet stringByEvaluatingJavaScriptFromString:jsString];
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
        sFromAcc = [NSString stringWithFormat:@"%@: %@", [@"@qua_tang_tang" localizableString], item.fromAcc];
    }
    else
    {
        sFromAcc = [NSString stringWithFormat:@"%@: %@", [@"@tu" localizableString], item.fromAcc];
    }

    NSString *sAmount = @"";
    NSString *sSoDu = @"";
    NSString *idVi = [DucNT_LuuRMS layThongTinTaiKhoanVi].sID;
//    [item.fromAcc hasPrefix:idVi]
    if([item.feeAmount intValue] > 0)
    {
        sAmount = [NSString stringWithFormat:@"%@: - %@ đ", [@"@so_tien_giao_dich" localizableString], [Common hienThiTienTe:[item.amount doubleValue]]];
        if([item.type intValue] != 4)
        {
            // so du vi
            sSoDu = [NSString stringWithFormat:@"%@%@: %@ đ", [@"Inq - blance" localizableString], [@"tao_tai_khoan_thuong_dung_vi" localizableString], [Common hienThiTienTe:[item.totalAmount doubleValue]]];
        }
        else
        {
            // so du km
            sSoDu = [NSString stringWithFormat:@"%@%@: %@ đ", [@"Inq - blance" localizableString], [@"TKKM" localizableString], [Common hienThiTienTe:[item.totalPromotion doubleValue]]];
        }
    }
    else
    {
        sAmount = [NSString stringWithFormat:@"%@: +%@ đ", [@"@so_tien_giao_dich" localizableString], [Common hienThiTienTe:[item.amount doubleValue]]];
        if([item.type intValue] != 4)
        {
            // so du vi
            sSoDu = [NSString stringWithFormat:@"%@%@: %@ đ", [@"Inq - blance" localizableString], [@"tao_tai_khoan_thuong_dung_vi" localizableString], [Common hienThiTienTe:[item.totalAmountToAcc doubleValue]]];
        }
        else
        {
            // so du km
            sSoDu = [NSString stringWithFormat:@"%@%@: %@", [@"Inq - blance" localizableString], [@"TKKM" localizableString], [Common hienThiTienTe_1:[item.totalPromotionToAcc doubleValue]]];
        }
    }

    NSString *sNoiDung = @"";
    NSString *sDes = @"";
    if([item.type intValue] != 3 && [item.type intValue] != 4)
        sDes = [NSString stringWithFormat:@"%@ %@", [@"sk noi dung" localizableString], [item layNoiDung]];
    else
        sDes = [NSString stringWithFormat:@"%@ %@ : %@", [@"sk noi dung" localizableString], [item layNoiDung], [item layGiftName]];
    //Tu
    sNoiDung = [NSString stringWithFormat:@"%@ <br/>", sFromAcc];
    //Den
    sNoiDung = [sNoiDung stringByAppendingFormat:@"%@ <br/>", [NSString stringWithFormat:@"%@: %@", [@"@den" localizableString], sDenTK]];
    if(sTenNguoiThuHuong.length > 0) {
        sNoiDung = [sNoiDung stringByAppendingFormat:@"%@ <br/>", sTenNguoiThuHuong];
    }
    if(sTenVietTat.length > 0) {
        sNoiDung = [sNoiDung stringByAppendingFormat:@"%@ <br/>", sTenVietTat];
    }
    //soTien
    sNoiDung = [sNoiDung stringByAppendingFormat:@"%@ <br/>", sAmount];
    //sophi
    sNoiDung = [sNoiDung stringByAppendingFormat:@"%@ <br/>", [NSString stringWithFormat:@"%@: %@ đ", [@"so_phi" localizableString], [Common hienThiTienTe:[item.feeAmount doubleValue]]]];
    //noidung
    sNoiDung = [sNoiDung stringByAppendingFormat:@"%@ <br/>", sDes];

    //thoiDiem
    sNoiDung = [sNoiDung stringByAppendingFormat:@"%@ <br/>", [NSString stringWithFormat:@"%@: %@", [@"@thoi_diem_giao_dich" localizableString],  [item layThoiGianChuyenTien]]];
    if (item.VMApp != nil) {
        int nVM_APP = [item.VMApp intValue];
        switch (nVM_APP) {
            case 1:
                sNoiDung = [sNoiDung stringByAppendingFormat:@"Ứng dụng: Ví Vimass Android<br/>"];
                break;
            case 2:
                sNoiDung = [sNoiDung stringByAppendingFormat:@"Ứng dụng: Ví Vimass iOS<br/>"];
                break;
            case 3:
                sNoiDung = [sNoiDung stringByAppendingFormat:@"Ứng dụng: Ví Vimass WP<br/>"];
                break;
            case 4:
                sNoiDung = [sNoiDung stringByAppendingFormat:@"Ứng dụng: VĐT Vimass <br/>"];
                break;
            case 5:
                sNoiDung = [sNoiDung stringByAppendingFormat:@"Ứng dụng: Ví Vimass iOS<br/>"];
                break;
            default:
                break;
        }

    }
    //soDu
    sNoiDung = [sNoiDung stringByAppendingFormat:@"%@ <br/>", sSoDu];
    sNoiDung = [sNoiDung stringByAppendingFormat:@"Số dư KM: %@ đ<br/>", [Common hienThiTienTe:[self.mThongTinTaiKhoanVi.nPromotionTotal doubleValue]]];
    return sNoiDung;
}

- (IBAction)suKienBamKhieuNai:(id)sender {
    [self taoViewKhieuNai];
}

- (IBAction)suKienBamNutGuiMail:(id)sender {
    self.btnMail.enabled = NO;
    [GiaoDichMang ketNoiGuiMailSaoKeDen:[self.mThongTinTaiKhoanVi layThuDienTu]
                             tieuDeMail:@"Sao kê giao dịch ví điện tử"
                                noiDung:_sXauGuiMail
                          noiNhanKetQua:self];
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
    }
}

- (void)xuLyKetNoiThatBai:(NSString*)sDinhDanhKetNoi thongBao:(NSString*)sThongBao ketQua:(id)ketQua
{
    [self anLoading];
    [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
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
    [super dealloc];
}
@end
