//
//  GiaoDienThanhToanQRVNPay.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 3/26/19.
//

#import "GiaoDienThanhToanQRVNPay.h"
#import "VNPayQRTableViewCell.h"
#import "VNPayQRInputMoneyViewCell.h"
#import "VNPayQRInputContentTableViewCell.h"
#import "ViewAuthentication.h"
#import "VNPayQRSoLuongTableViewCell.h"
#import "MaGiamGiaTableViewCell.h"
#import "GiaoDienMaGiamGiaVNPay.h"
@interface GiaoDienThanhToanQRVNPay () <UITableViewDelegate, UITableViewDataSource, ViewAuthenticationDelegate, VNPayQRSoLuongTableViewCellDelegate> {
    int rowTable;
    NSArray *arrTitleType1;
    NSArray *arrNgonNgu;
    NSString *sMaGiaoDich;
    double soTienType3;
    int nIndexLang;
    BOOL isQRNganHang;
    NSDictionary *dictQRNganHang;
}

@end

@implementation GiaoDienThanhToanQRVNPay

- (void)viewDidLoad {
    [super viewDidLoad];
    
    rowTable = 0;
    isQRNganHang = NO;
    
    UIBarButtonItem *btnRight = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon-global"] style:UIBarButtonItemStyleDone target:self action:@selector(suKienChonGlobal)];
    self.navigationItem.rightBarButtonItem = btnRight;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"VNPayQRTableViewCell" bundle:nil] forCellReuseIdentifier:@"VNPayQRTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"VNPayQRInputMoneyViewCell" bundle:nil] forCellReuseIdentifier:@"VNPayQRInputMoneyViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"VNPayQRInputContentTableViewCell" bundle:nil] forCellReuseIdentifier:@"VNPayQRInputContentTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"VNPayQRSoLuongTableViewCell" bundle:nil] forCellReuseIdentifier:@"VNPayQRSoLuongTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MaGiamGiaTableViewCell" bundle:nil] forCellReuseIdentifier:@"MaGiamGiaTableViewCell"];
    
    ViewAuthentication *footerView = [[[NSBundle mainBundle] loadNibNamed:@"ViewAuthentication" owner:self options:nil] objectAtIndex:0];
    footerView.delegate = self;
    footerView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 110);
    [footerView.btnToken addTarget:self action:@selector(suKienBamNutToken:) forControlEvents:UIControlEventTouchUpInside];
    footerView.enableFaceID = self.enableFaceID;
    [self.tableView setTableFooterView:footerView];
    
    [self khoiTaoButtonXacThucBanDau];
    
    [self.tableView setHidden:YES];
    [self ketNoiLayThongTinQR];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    // Register notification when the keyboard will be hide
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    nIndexLang = 0;
}

- (void)suKienChonGlobal {
    if (self.heightGlobal.constant == 0) {
        [self.stackGlobal setHidden:NO];
        self.heightGlobal.constant = 40;
    } else {
        [self.stackGlobal setHidden:YES];
        self.heightGlobal.constant = 0;
    }
}

- (NSArray *)chuyenNgonNguQRNganHang {
    if (nIndexLang == 0) {
        return [[NSArray alloc] initWithObjects:@"Trả cho:", @"TK:", @"Số tiền thanh toán:", nil];
    }
    else if (nIndexLang == 1) {
        return [[NSArray alloc] initWithObjects: @"Pay for:", @"Acc:", @"Amount:", nil];
    } else if (nIndexLang == 2) {
        return [[NSArray alloc] initWithObjects: @"支付:", @"帐户:", @"量:", nil];
    } else if (nIndexLang == 3) {
        return [[NSArray alloc] initWithObjects: @"Оплатить:", @"счет:", @"Количество:", nil];
    } else if (nIndexLang == 4) {
        return [[NSArray alloc] initWithObjects : @"지불 대상:", @"계정:", @"양:", nil];
    } else if (nIndexLang == 5) {
        return [[NSArray alloc] initWithObjects: @"支払い:", @"アカウント:", @"量:", nil];
    }
    return [[NSArray alloc] initWithObjects: @"Bezahlen für:", @"Konto:", @"Menge:", nil];
}

- (NSArray *)chuyenNgonNguType1 {
    if (nIndexLang == 0) {
        if (rowTable == 7) {
            return [[NSArray alloc] initWithObjects:@"Trả cho:", @"Điểm bán:", @"Mã điểm bán:", @"Số hoá đơn:", nil];
        }
        return [[NSArray alloc] initWithObjects:@"Trả cho:", @"Điểm bán:", @"Mã điểm bán:", nil];
    } else if (nIndexLang == 1) {
        if (rowTable == 7) {
            return [[NSArray alloc] initWithObjects: @"Pay for:", @"Point of sale:", @"Code point of sale:", @"Invoice number:", nil];
        }
        return [[NSArray alloc] initWithObjects: @"Pay for:", @"Point of sale:", @"Code point of sale:", nil];
    } else if (nIndexLang == 2) {
        if (rowTable == 7) {
            return [[NSArray alloc] initWithObjects: @"支付:", @"销售点:", @"代码销售点:", @"发票编号:", nil];
        }
        return [[NSArray alloc] initWithObjects: @"支付:", @"销售点:", @"代码销售点:", nil];
    } else if (nIndexLang == 3) {
        if (rowTable == 7) {
            return [[NSArray alloc] initWithObjects: @"Оплатить:", @"Пункт продажи:", @"Код пункта продажи:", @"Номер счета:", nil];
        }
        return [[NSArray alloc] initWithObjects: @"Оплатить:", @"Пункт продажи:", @"Код пункта продажи:", nil];
    } else if (nIndexLang == 4) {
        if (rowTable == 7) {
            return [[NSArray alloc] initWithObjects : @"지불 대상 :", @"판매 시점 :", @"판매 시점 코드 :", @"송장 번호 :", nil];
        }
        return [[NSArray alloc] initWithObjects : @"지불 대상:", @"판매 시점:", @"판매 시점 코드:", nil];
    } else if (nIndexLang == 5) {
        if (rowTable == 7) {
            return [[NSArray alloc] initWithObjects: @"支払い:", @"販売時点:", @"コード販売時点:", @"請求書番号", nil];
        }
        return [[NSArray alloc] initWithObjects: @"支払い:", @"販売時点:", @"コード販売時点:", nil];
    }
    if (rowTable == 7) {
        return [[NSArray alloc] initWithObjects: @"Bezahlen für:", @"Verkaufsstelle:", @"Code Verkaufsstelle:", @"Rechnungsnummer:", nil];
    }
    return [[NSArray alloc] initWithObjects: @"Bezahlen für:", @"Verkaufsstelle:", @"Code Verkaufsstelle:", nil];
}

- (NSArray *)chuyenNgonNguType2 {
    if (nIndexLang == 0) {
        return [[NSArray alloc] initWithObjects:@"Nhà cung cấp", @"Dịch vụ:", @"Mã khách hàng:", nil];
    } else if (nIndexLang == 1) {
        return [[NSArray alloc] initWithObjects:@"Supplier:", @"Service:", @"Customer code:", nil];
    } else if (nIndexLang == 2) {
        return [[NSArray alloc] initWithObjects:@"供应商:", @"服务", @"客户代码", nil];
    } else if (nIndexLang == 3) {
        return [[NSArray alloc] initWithObjects:@"Поставщик:", @"Сервис:", @"Код клиента:", nil];
    } else if (nIndexLang == 4) {
        return [[NSArray alloc] initWithObjects:@"공급 업체:", @"서비스:", @"고객 코드:", nil];
    } else if (nIndexLang == 5) {
        return [[NSArray alloc] initWithObjects:@"サプライヤ:", @"サービス:", @"顧客コード:", nil];
    }
    return [[NSArray alloc] initWithObjects:@"Lieferant:", @"Service:", @"Kundencode:", nil];
}

- (NSArray *)chuyenNgonNguType3 {
    if (nIndexLang == 0) {
        return [[NSArray alloc] initWithObjects:@"Trả cho:", @"Điểm bán:", @"Tên sản phẩm:", @"Mã sản phẩm:", nil];
    } else if (nIndexLang == 1) {
        return [[NSArray alloc] initWithObjects:@"Pay for:", @"Point of sale:", @"Product name:", @"Product code:", nil];
    } else if (nIndexLang == 2) {
        return [[NSArray alloc] initWithObjects:@"支付:", @"销售点:",@"产品名称:", @"产品代码", nil];
    } else if (nIndexLang == 3) {
        return [[NSArray alloc] initWithObjects:@"Оплатить:", @"Точка продажи:", @"Название товара:", @"Код товара:", nil];
    } else if (nIndexLang == 4) {
        return [[NSArray alloc] initWithObjects:@"지불 대상:", @"판매 시점:", @"제품 이름:", @"제품 코드:", nil];
    } else if (nIndexLang == 5) {
        return [[NSArray alloc] initWithObjects:@"支払い:", @"販売時点情報:", @"製品名:", @"製品コード:", nil];
    }
    return [[NSArray alloc] initWithObjects:@"Bezahlen für:", @"Verkaufsstelle:", @"Produktname:", @"Produktcode:", nil];
}

- (NSArray *)chuyenNgonNguType4 {
    if (nIndexLang == 0) {
        return [[NSArray alloc] initWithObjects:@"Trả cho:", @"Điểm bán:", @"Mã hàng hoá:", @"Hạn thanh toán:", @"Mô tả:", nil];
    } else if (nIndexLang == 1) {
        return [[NSArray alloc] initWithObjects:@"Pay for:", @"Point of sale:", @"Commodity code:", @"Payment term:", @"Description:", nil];
    } else if (nIndexLang == 2) {
        return [[NSArray alloc] initWithObjects:@"支付:", @"销售点:", @"商品代码:", @"付款期限:", @"说明:", nil];
    } else if (nIndexLang == 3) {
        return [[NSArray alloc] initWithObjects:@"Оплатить:", @"Пункт продажи:", @"Код товара:", @"Срок оплаты:", @"Описание:", nil];
    } else if (nIndexLang == 4) {
        return [[NSArray alloc] initWithObjects:@"지불 조건:", @"판매 시점:", @"상품 코드:", @"지불 기간:", @"설명:", nil];
    } else if (nIndexLang == 5) {
        return [[NSArray alloc] initWithObjects:@"支払う:", @"販売時点:", @"商品コード:", @"支払期間:", @"説明:", nil];
    }
    return [[NSArray alloc] initWithObjects:@"Bezahlen für:", @"Verkaufsstelle:", @"Warencode:", @"Zahlungsbedingung:", @"Beschreibung:", nil];
}

- (void)khoiTaoButtonXacThucBanDau {
    ViewAuthentication *footerView = (ViewAuthentication *)self.tableView.tableFooterView;
    if (self.enableFaceID) {
        [footerView.btnFinger setImage:[UIImage imageNamed:@"face-id"] forState:UIControlStateNormal];
    } else {
        [footerView.btnFinger setImage:[UIImage imageNamed:@"finger"] forState:UIControlStateNormal];
    }
    [footerView.btnToken setImage:[UIImage imageNamed:@"token"] forState:UIControlStateNormal];
}

- (void)ketNoiLayThongTinQR {
    if (![self.sDataQR isEmpty]) {
        NSDictionary *dic = @{
                              @"dataQR": self.sDataQR,
                              @"user" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                              @"appId" : [NSString stringWithFormat:@"%d", APP_ID],
                              @"VMApp" : [NSNumber numberWithInt:VM_APP]
                              };
        NSLog(@"%s - dic : %@", __FUNCTION__, [dic JSONString]);
        self.mDinhDanhKetNoi = @"LAY_THONG_TIN_QR";
        [self hienThiLoading];
        [GiaoDichMang ketNoiLayThongTinQR:[dic JSONString] noiNhanKetQua:self];
    }
}

- (void)xuLyKetNoiThanhCong:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua {
    if ([sDinhDanhKetNoi isEqualToString:@"LAY_THONG_TIN_QR"]) {
        [self anLoading];
        NSDictionary *dictResult = (NSDictionary *)ketQua;
        NSLog(@"%s - line : %d - dictResult : %@", __FUNCTION__, __LINE__, dictResult);
        int maDonViCapQR = [[dictResult objectForKey:@"maDonViCapQR"] intValue];
        if (maDonViCapQR == 3) {
            [self addTitleView:@"Thanh toán QR code"];
            isQRNganHang = YES;
            rowTable = 4;
            arrTitleType1 = [self chuyenNgonNguQRNganHang];
            NSString * chiTiet = [dictResult objectForKey:@"chiTiet"];
            NSDictionary *dictTemp = [chiTiet objectFromJSONString];
            NSLog(@"%s - line : %d - chiTiet : %@", __FUNCTION__, __LINE__, [dictTemp objectForKey:@"tenTK"]);
            dictQRNganHang = [[NSDictionary alloc] initWithDictionary:dictTemp];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView setHidden:NO];
                [self.tableView reloadData];
                self.tableView.contentSize = CGSizeMake(self.tableView.frame.size.width, self.tableView.contentSize.height + 150);
            });
            return;
        }
        [self addTitleView:@"VNPay QR"];
        NSDictionary *dictChiTiet = [dictResult objectForKey:@"chiTiet"];
        NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:dictChiTiet];
        _itemQR = [[ItemVNPayQR alloc] initWithDict:dict];
        [_itemQR setData:dictChiTiet];
        sMaGiaoDich = [[NSString alloc] initWithString:(NSString *)[dictResult valueForKey:@"maGiaoDich"]];
        NSLog(@"%s - sMaGiaoDich : %@", __FUNCTION__, sMaGiaoDich);
        soTienType3 = [_itemQR.amount doubleValue];
        
        if (_itemQR.typeQRShow == 1) {
            rowTable = 7;
            arrTitleType1 = [self chuyenNgonNguType1];
        }
        else if (_itemQR.typeQRShow == 2) {
            if (_itemQR.purpose != nil && ![_itemQR.purpose isEmpty] && _itemQR.consumerData != nil && ![_itemQR.consumerData isEmpty]) {
                _itemQR.typeQRShow = 3;
                rowTable = 7;
                arrTitleType1 = [self chuyenNgonNguType3];
            } else if (_itemQR.purpose != nil && ![_itemQR.purpose isEmpty] && (_itemQR.billNumber == nil || [_itemQR.billNumber isEmpty]) && _itemQR.customerID != nil && ![_itemQR.customerID isEmpty]) {
                _itemQR.typeQRShow = 2;
                rowTable = 6;
                arrTitleType1 = [self chuyenNgonNguType2];
            } else {
                _itemQR.typeQRShow = 1;
                if (_itemQR.billNumber == nil || [_itemQR.billNumber isEmpty]) {
                    rowTable = 6;
                } else {
                    rowTable = 7;
                }
                arrTitleType1 = [self chuyenNgonNguType1];
            }
        } else if (_itemQR.typeQRShow == 3){
            rowTable = 8;
            arrTitleType1 = [self chuyenNgonNguType3];
        } else if (_itemQR.typeQRShow == 4) {
            if (_itemQR.consumerData != nil && ![_itemQR.consumerData isEmpty]) {
                _itemQR.typeQRShow = 3;
                rowTable = 8;
                arrTitleType1 = [self chuyenNgonNguType3];
            } else {
                rowTable = 8;
                arrTitleType1 = [self chuyenNgonNguType4];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView setHidden:NO];
            [self.tableView reloadData];
            self.tableView.contentSize = CGSizeMake(self.tableView.frame.size.width, self.tableView.contentSize.height + 150);
        });
    }
    else if ([sDinhDanhKetNoi isEqualToString:@"THANH_TOAN_VNPAY_QR"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self anLoading];
        });
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
    }
}

- (void)xuLyKetNoiThatBai:(NSString*)sDinhDanhKetNoi thongBao:(NSString*)sThongBao ketQua:(id)ketQua
{
    [self anLoading];
    [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
}

- (BOOL)validateVanTay {
    if (isQRNganHang) {
        double dAmount = [[dictQRNganHang objectForKey:@"amount"] doubleValue];
        if (dAmount < 10000) {
            VNPayQRInputMoneyViewCell *cell = (VNPayQRInputMoneyViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            NSString *sSoTien = cell.tfSoTien.text;
            sSoTien = [sSoTien stringByReplacingOccurrencesOfString:@"." withString:@""];
            dAmount = [sSoTien doubleValue];
        }
        if (dAmount < 10000 || dAmount > 300000000) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Số tiền được phép thanh toán từ 10.000 đ đến 300.000.000 đ "];
            return NO;
        }
    }
    return YES;
}

-(void) keyboardWillShow:(NSNotification *)note
{
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue: &keyboardBounds];
    UIEdgeInsets contentInserts =  UIEdgeInsetsMake(0, 0, keyboardBounds.size.height + 20, 0);
    self.tableView.contentInset = contentInserts;
    self.tableView.scrollIndicatorInsets = contentInserts;
}

-(void) keyboardWillHide:(NSNotification *)note
{
//    UIEdgeInsets contentInserts =  UIEdgeInsetsMake(0, 0, 0, 0);
//    self.tableView.contentInset = contentInserts;
//    self.tableView.scrollIndicatorInsets = contentInserts;
}

//MARK: ViewAuthenticationDelegate

- (void)updateXacThucKhac {
    dispatch_async(dispatch_get_main_queue(), ^{
        ViewAuthentication *footerView = (ViewAuthentication *)self.tableView.tableFooterView;
        [footerView xuLyKhiChonXacThucKhac];
    });
}

- (void)suKienChonXacThucVanTay {
    if([self validateVanTay])
    {
        [self xuLySuKienHienThiChucNangVanTayVoiTieuDe:@"Đặt vân tay của bạn để thực hiện giao dịch"];
    }
}

- (void)suKienChonXacThucToken {
    if([self.mThongTinTaiKhoanVi.nIsToken intValue] > 0)
    {
        self.mTypeAuthenticate = TYPE_AUTHENTICATE_TOKEN;
    }
    else
    {
        [UIAlertView alert:[@"thong_bao_loi_chua_dang_ky_token" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
    }
}

- (void)suKienChonXacThucSDSecure {
    self.mTypeAuthenticate = TYPE_AUTHENTICATE_PKI;
}

- (void)suKienBamNutThucHienAuthentication:(NSString *)sToken nType:(int)nType {
    NSLog(@"%s - sToken ; %@", __FUNCTION__, sToken);
    if (nType == TYPE_AUTHENTICATE_TOKEN) {
        NSString *token = [self xuLyKhiBamThucHienToken:sToken];
        [self xuLyThucHienKhiKiemTraThanhCongTraVeToken:token otp:@""];
    } else {
        [self xuLyThucHienKhiKiemTraThanhCongTraVeToken:@"" otp:sToken];
    }
}

- (void)xuLyThucHienKhiKiemTraThanhCongTraVeToken:(NSString *)sToken otp:(NSString *)sOtp {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hienThiLoadingChuyenTien];
        self.mDinhDanhKetNoi = @"THANH_TOAN_VNPAY_QR";
        if (isQRNganHang) {
            double dAmount = [[dictQRNganHang objectForKey:@"amount"] doubleValue];
            if (dAmount < 10000) {
                VNPayQRInputMoneyViewCell *cell = (VNPayQRInputMoneyViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                NSString *sSoTien = cell.tfSoTien.text;
                sSoTien = [sSoTien stringByReplacingOccurrencesOfString:@"." withString:@""];
                dAmount = [sSoTien doubleValue];
            }
            VNPayQRInputContentTableViewCell *cell = (VNPayQRInputContentTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
            NSString *sNoiDung = cell.lblContent.text;
            NSDictionary *dictPost = @{
                                       @"token" : sToken,
                                       @"otpConfirm" : sOtp,
                                       @"typeAuthenticate" : [NSNumber numberWithInt:self.mTypeAuthenticate],
                                       @"user" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                                       @"appId" : [NSNumber numberWithInt:APP_ID],
                                       @"VMApp" : [NSNumber numberWithInt:VM_APP],
                                       @"maNganHang" : (NSString *)[dictQRNganHang objectForKey:@"maNganHang"],
                                       @"stk" : (NSString *)[dictQRNganHang objectForKey:@"stk"],
                                       @"tenTK" : (NSString *)[dictQRNganHang objectForKey:@"tenTK"],
                                       @"dataCheck" : (NSString *)[dictQRNganHang objectForKey:@"dataCheck"],
                                       @"soTienThanhToan" : [NSNumber numberWithDouble:dAmount],
                                       @"user" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                                       @"noiDung" : sNoiDung
                                       };
            NSLog(@"%s - dictPost : %@", __FUNCTION__, [dictPost JSONString]);
            [GiaoDichMang ketNoiThanhToanQRNganHang:[dictPost JSONString] noiNhanKetQua:self];
            
        } else {
            NSString *sSoTien = @"";
            NSString *sPromotionCode = @"";
            NSString *sNoiDung = @"";
            if (_itemQR.typeQRShow == 1) {
                int indexSplit = 4;
                if (_itemQR.billNumber == nil || [_itemQR.billNumber isEmpty]) {
                    indexSplit = 3;
                }
                VNPayQRInputMoneyViewCell *cell = (VNPayQRInputMoneyViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexSplit inSection:0]];
                sSoTien = cell.tfSoTien.text;

                MaGiamGiaTableViewCell *cellPromotion = (MaGiamGiaTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(indexSplit + 3) inSection:0]];
                sPromotionCode = cellPromotion.lblMaGiamGia.text;

                VNPayQRInputContentTableViewCell *cellNoiDung = (VNPayQRInputContentTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(indexSplit + 4) inSection:0]];
                sNoiDung = cellNoiDung.lblContent.text;
            } else if (_itemQR.typeQRShow == 2) {
                VNPayQRInputMoneyViewCell *cell = (VNPayQRInputMoneyViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
                sSoTien = cell.tfSoTien.text;

                MaGiamGiaTableViewCell *cellPromotion = (MaGiamGiaTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
                sPromotionCode = cellPromotion.lblMaGiamGia.text;

                VNPayQRInputContentTableViewCell *cellNoiDung = (VNPayQRInputContentTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]];
                sNoiDung = cellNoiDung.lblContent.text;
            }
            else if (_itemQR.typeQRShow == 3){
                VNPayQRInputMoneyViewCell *cell = (VNPayQRInputMoneyViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
                sSoTien = cell.tfSoTien.text;

                MaGiamGiaTableViewCell *cellPromotion = (MaGiamGiaTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0]];
                sPromotionCode = cellPromotion.lblMaGiamGia.text;

                VNPayQRInputContentTableViewCell *cellNoiDung = (VNPayQRInputContentTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0]];
                sNoiDung = cellNoiDung.lblContent.text;
            }
            else if (_itemQR.typeQRShow == 4){
                VNPayQRInputMoneyViewCell *cell = (VNPayQRInputMoneyViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
                sSoTien = cell.tfSoTien.text;

                MaGiamGiaTableViewCell *cellPromotion = (MaGiamGiaTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0]];
                sPromotionCode = cellPromotion.lblMaGiamGia.text;

                VNPayQRInputContentTableViewCell *cellNoiDung = (VNPayQRInputContentTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0]];
                sNoiDung = cellNoiDung.lblContent.text;
            }

            double fSoTien = [[[sSoTien componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];

            NSDictionary *dictPost = @{
                                       @"token" : sToken,
                                       @"otpConfirm" : sOtp,
                                       @"typeAuthenticate" : [NSNumber numberWithInt:self.mTypeAuthenticate],
                                       @"user" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                                       @"appId" : [NSNumber numberWithInt:APP_ID],
                                       @"VMApp" : [NSNumber numberWithInt:VM_APP],
                                       @"maGiaoDich" : sMaGiaoDich,
                                       @"soTienThanhToan" : [NSNumber numberWithDouble:fSoTien],
                                       @"promotionCode" : sPromotionCode,
                                       @"noiDung" : sNoiDung
                                       };
            NSLog(@"%s - dictPost : %@", __FUNCTION__, [dictPost JSONString]);
            [GiaoDichMang ketNoiThanhToanVNPayQR:[dictPost JSONString] noiNhanKetQua:self];
        }
    });
}


//MARK: UITableViewDelegate
- (void)suKienGiamSoLuong:(int)nSoLuong {
    
}

- (void)suKienTangSoLuong:(int)nSoLuong {
    soTienType3 = nSoLuong * [_itemQR.amount doubleValue];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    });
}

- (void)configCellViewType1:(VNPayQRTableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    cell.lblTitle.text = arrTitleType1[indexPath.row];
    if (indexPath.row == 0) {
        cell.lblContent.text = _itemQR.merchantName;
    } else if (indexPath.row == 1) {
        cell.lblContent.text = _itemQR.storeID;
    } else if (indexPath.row == 2) {
        cell.lblContent.text = _itemQR.terminalID;
    } else {
        cell.lblContent.text = _itemQR.billNumber;
    }
}

- (void)configCellViewType2:(VNPayQRTableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    cell.lblTitle.text = arrTitleType1[indexPath.row];
    if (indexPath.row == 0) {
        cell.lblContent.text = _itemQR.merchantName;
    } else if (indexPath.row == 1) {
        cell.lblContent.text = _itemQR.purpose;
    } else if (indexPath.row == 2) {
        cell.lblContent.text = _itemQR.customerID;
    }
}

- (void)configCellViewType3:(VNPayQRTableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    cell.lblTitle.text = arrTitleType1[indexPath.row];
    if (indexPath.row == 0) {
        cell.lblContent.text = _itemQR.merchantName;
    } else if (indexPath.row == 1) {
        cell.lblContent.text = _itemQR.storeID;
    } else if (indexPath.row == 2) {
        cell.lblContent.text = _itemQR.purpose;
    } else if (indexPath.row == 3) {
        if ([_itemQR.referenceID hasPrefix:@"02"]) {
            cell.lblContent.text = [_itemQR.referenceID substringFromIndex:2];
        } else {
            cell.lblContent.text = _itemQR.referenceID;
        }
    }
}

- (void)configCellViewType4:(VNPayQRTableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    cell.lblTitle.text = arrTitleType1[indexPath.row];
    if (indexPath.row == 0) {
        cell.lblContent.text = _itemQR.merchantName;
    } else if (indexPath.row == 1) {
        cell.lblContent.text = _itemQR.storeID;
    } else if (indexPath.row == 2) {
        cell.lblContent.text = _itemQR.referenceID;
    } else if (indexPath.row == 3) {
        if (_itemQR.expDate != nil && ![_itemQR.expDate isEmpty]) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyMMddHHmm"];
            NSDate *date = [formatter dateFromString:_itemQR.expDate];
            [formatter setDateFormat:@"dd/MM/yyyy HH:mm"];
            NSString *timeString = [formatter stringFromDate:date];
            cell.lblContent.text = timeString;
        } else {
            cell.lblContent.text = @"";
        }
    } else if (indexPath.row == 4) {
        cell.lblContent.text = _itemQR.purpose;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isQRNganHang) {
        return rowTable;
    }
    if (!_itemQR) {
        return 0;
    }
    return rowTable + 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isQRNganHang) {
        return 50;
    }
    if (indexPath.row == rowTable + 1) {
        return 70.0;
    }
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isQRNganHang) {
        if (indexPath.row == 0 || indexPath.row == 1) {
            VNPayQRTableViewCell *cell = (VNPayQRTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"VNPayQRTableViewCell" forIndexPath:indexPath];
            cell.lblTitle.text = arrTitleType1[indexPath.row];
            if (indexPath.row == 0) {
                cell.lblContent.text = (NSString *)[dictQRNganHang objectForKey:@"tenTK"];
            } else {
                NSString *maNganHang = (NSString *)[dictQRNganHang objectForKey:@"maNganHang"];
                NSString *stk = (NSString *)[dictQRNganHang objectForKey:@"stk"];
                if (stk.length > 8) {
                    NSString *sTemp = @"";
                    for (int i = 3; i < stk.length - 2; i ++) {
                        sTemp = [sTemp stringByAppendingString:@"*"];
                    }
                    stk = [stk stringByReplacingCharactersInRange:NSMakeRange(3, stk.length - 5) withString:sTemp];
                }
                cell.lblContent.text = [NSString stringWithFormat:@"%@ - %@", maNganHang, stk];
            }
            return cell;
        } else if (indexPath.row == 2) {
            VNPayQRInputMoneyViewCell *cell = (VNPayQRInputMoneyViewCell *)[tableView dequeueReusableCellWithIdentifier:@"VNPayQRInputMoneyViewCell" forIndexPath:indexPath];
            cell.isQRNganHang = YES;
            cell.lblPhi.text = [self layLangLabelPhiQRNganHang];
            double dAmount = [[dictQRNganHang objectForKey:@"amount"] doubleValue];
            if (dAmount >= 10000) {
                [cell.tfSoTien setEnabled:NO];
                cell.tfSoTien.text = [Common hienThiTienTe:dAmount];
            } else {
                [cell.tfSoTien setEnabled:YES];
            }
            return cell;
        } else {
            VNPayQRInputContentTableViewCell *cell = (VNPayQRInputContentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"VNPayQRInputContentTableViewCell" forIndexPath:indexPath];
            cell.lblContent.placeholder = [self layLangLoiNhan];
            return cell;
        }
    } else {
        int nSoLuong = 1;
        if (_itemQR.typeQRShow == 1) {
            int indexSplit = 4;
            if (_itemQR.billNumber == nil || [_itemQR.billNumber isEmpty]) {
                indexSplit = 3;
            }
            if (indexPath.row < indexSplit) {
                VNPayQRTableViewCell *cell = (VNPayQRTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"VNPayQRTableViewCell" forIndexPath:indexPath];
                [self configCellViewType1:cell indexPath:indexPath];
                return cell;
            }
            else if (indexPath.row == indexSplit + 1 || indexPath.row == indexSplit + 2) {
                VNPayQRInputMoneyViewCell *cell = (VNPayQRInputMoneyViewCell *)[tableView dequeueReusableCellWithIdentifier:@"VNPayQRInputMoneyViewCell" forIndexPath:indexPath];
                [cell.tfSoTien setEnabled:NO];
                cell.tfSoTien.textColor = [UIColor blackColor];
                double dAmount = [_itemQR.amount doubleValue];
                if (indexPath.row == indexSplit + 1) {
                    double tiGia =  [self tinhTyGia:dAmount tyGiaNgoaiTe:_itemQR.tyGiaUSD];
                    cell.tfSoTien.text = [NSString stringWithFormat:@"%.2f $", tiGia];
                    cell.lblPhi.text = [NSString stringWithFormat:@"%@/$", [Common hienThiTienTe_1:_itemQR.tyGiaUSD]];
                } else {
                    double tiGia =  [self tinhTyGia:dAmount tyGiaNgoaiTe:_itemQR.tyGiaEUR];
                    cell.tfSoTien.text = [NSString stringWithFormat:@"%.2f €", tiGia];
                    cell.lblPhi.text = [NSString stringWithFormat:@"%@/€", [Common hienThiTienTe_1:_itemQR.tyGiaEUR]];
                }
                return cell;
            }
            else if (indexPath.row == indexSplit + 3) {
                MaGiamGiaTableViewCell *cell = (MaGiamGiaTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MaGiamGiaTableViewCell" forIndexPath:indexPath];
                cell.lblMaGiamGia.placeholder = [self layLangMaGiamGia];
                [cell.btnXemKM setTitle:[self layLangButtonMaGiamGia] forState:UIControlStateNormal];
                [cell.btnXemKM addTarget:self action:@selector(suKienChonKMDangCo:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }
            else if (indexPath.row == indexSplit + 4) {
                VNPayQRInputContentTableViewCell *cell = (VNPayQRInputContentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"VNPayQRInputContentTableViewCell" forIndexPath:indexPath];
                if (indexPath.row == indexSplit + 1) {
                    cell.lblContent.placeholder = [self layLangMaGiamGia];
                } else {
                    cell.lblContent.placeholder = [self layLangLoiNhan];
                }
                return cell;
            }
        }
        else if (_itemQR.typeQRShow == 2) {
            if (indexPath.row < 3) {
                VNPayQRTableViewCell *cell = (VNPayQRTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"VNPayQRTableViewCell" forIndexPath:indexPath];
                [self configCellViewType2:cell indexPath:indexPath];
                return cell;
            }
            else if (indexPath.row == 4 || indexPath.row == 5) {
                VNPayQRInputMoneyViewCell *cell = (VNPayQRInputMoneyViewCell *)[tableView dequeueReusableCellWithIdentifier:@"VNPayQRInputMoneyViewCell" forIndexPath:indexPath];
                [cell.tfSoTien setEnabled:NO];
                cell.tfSoTien.textColor = [UIColor blackColor];
                double dAmount = [_itemQR.amount doubleValue];
                if (indexPath.row == 4) {
                    double tiGia =  [self tinhTyGia:dAmount tyGiaNgoaiTe:_itemQR.tyGiaUSD];
                    cell.tfSoTien.text = [NSString stringWithFormat:@"%.2f $", tiGia];
                    cell.lblPhi.text = [NSString stringWithFormat:@"%@/$", [Common hienThiTienTe_1:_itemQR.tyGiaUSD]];
                } else {
                    double tiGia =  [self tinhTyGia:dAmount tyGiaNgoaiTe:_itemQR.tyGiaEUR];
                    cell.tfSoTien.text = [NSString stringWithFormat:@"%.2f €", tiGia];
                    cell.lblPhi.text = [NSString stringWithFormat:@"%@/€", [Common hienThiTienTe_1:_itemQR.tyGiaEUR]];
                }
                return cell;
            }
            else if (indexPath.row == 6) {
                MaGiamGiaTableViewCell *cell = (MaGiamGiaTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MaGiamGiaTableViewCell" forIndexPath:indexPath];
                cell.lblMaGiamGia.placeholder = [self layLangMaGiamGia];
                [cell.btnXemKM setTitle:[self layLangButtonMaGiamGia] forState:UIControlStateNormal];
                [cell.btnXemKM addTarget:self action:@selector(suKienChonKMDangCo:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }
            else if (indexPath.row == 7) {
                VNPayQRInputContentTableViewCell *cell = (VNPayQRInputContentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"VNPayQRInputContentTableViewCell" forIndexPath:indexPath];
                cell.lblContent.placeholder = [self layLangLoiNhan];
                return cell;
            }
        }
        else if (_itemQR.typeQRShow == 3) {
            if (indexPath.row < 4) {
                VNPayQRTableViewCell *cell = (VNPayQRTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"VNPayQRTableViewCell" forIndexPath:indexPath];
                [self configCellViewType3:cell indexPath:indexPath];
                return cell;
            }
            else if (indexPath.row == 4) {
                VNPayQRSoLuongTableViewCell *cell = (VNPayQRSoLuongTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"VNPayQRSoLuongTableViewCell" forIndexPath:indexPath];
                cell.lblTitleSoLuong.text = [self layLangLabelSoLuong];
                [cell setSoTien:_itemQR.amount];
                cell.lblDonGia.text = [NSString stringWithFormat:@"%@ %@", [self layLangLabelDonGia], [Common hienThiTienTeFromString:_itemQR.amount]];
                cell.delegate = self;
                nSoLuong = [cell getSoLuong];
                return cell;
            }
            else if (indexPath.row == 6 || indexPath.row == 7) {
                VNPayQRInputMoneyViewCell *cell = (VNPayQRInputMoneyViewCell *)[tableView dequeueReusableCellWithIdentifier:@"VNPayQRInputMoneyViewCell" forIndexPath:indexPath];
                [cell.tfSoTien setEnabled:NO];
                cell.tfSoTien.textColor = [UIColor blackColor];
                double dAmount = [_itemQR.amount doubleValue];
                if (indexPath.row == 6) {
                    double tiGia =  [self tinhTyGia:dAmount tyGiaNgoaiTe:_itemQR.tyGiaUSD];
                    cell.tfSoTien.text = [NSString stringWithFormat:@"%.2f $", tiGia];
                    cell.lblPhi.text = [NSString stringWithFormat:@"%@/$", [Common hienThiTienTe_1:_itemQR.tyGiaUSD]];
                } else {
                    double tiGia =  [self tinhTyGia:dAmount tyGiaNgoaiTe:_itemQR.tyGiaEUR];
                    cell.tfSoTien.text = [NSString stringWithFormat:@"%.2f €", tiGia];
                    cell.lblPhi.text = [NSString stringWithFormat:@"%@/€", [Common hienThiTienTe_1:_itemQR.tyGiaEUR]];
                }
                return cell;
            }
            else if (indexPath.row == 8) {
                MaGiamGiaTableViewCell *cell = (MaGiamGiaTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MaGiamGiaTableViewCell" forIndexPath:indexPath];
                cell.lblMaGiamGia.placeholder = [self layLangMaGiamGia];
                [cell.btnXemKM setTitle:[self layLangButtonMaGiamGia] forState:UIControlStateNormal];
                [cell.btnXemKM addTarget:self action:@selector(suKienChonKMDangCo:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }
            else if (indexPath.row == 9) {
                VNPayQRInputContentTableViewCell *cell = (VNPayQRInputContentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"VNPayQRInputContentTableViewCell" forIndexPath:indexPath];
                cell.lblContent.placeholder = [self layLangLoiNhan];
                return cell;
            }
            
        }
        else if (_itemQR.typeQRShow == 4) {
            if (indexPath.row < 5) {
                VNPayQRTableViewCell *cell = (VNPayQRTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"VNPayQRTableViewCell" forIndexPath:indexPath];
                [self configCellViewType4:cell indexPath:indexPath];
                return cell;
            }
            else if (indexPath.row == 6 || indexPath.row == 7) {
                VNPayQRInputMoneyViewCell *cell = (VNPayQRInputMoneyViewCell *)[tableView dequeueReusableCellWithIdentifier:@"VNPayQRInputMoneyViewCell" forIndexPath:indexPath];
                [cell.tfSoTien setEnabled:NO];
                cell.tfSoTien.textColor = [UIColor blackColor];
                double dAmount = [_itemQR.amount doubleValue];
                if (indexPath.row == 6) {
                    double tiGia =  [self tinhTyGia:dAmount tyGiaNgoaiTe:_itemQR.tyGiaUSD];
                    cell.tfSoTien.text = [NSString stringWithFormat:@"%.2f $", tiGia];
                    cell.lblPhi.text = [NSString stringWithFormat:@"%@/$", [Common hienThiTienTe_1:_itemQR.tyGiaUSD]];
                } else {
                    double tiGia =  [self tinhTyGia:dAmount tyGiaNgoaiTe:_itemQR.tyGiaEUR];
                    cell.tfSoTien.text = [NSString stringWithFormat:@"%.2f €", tiGia];
                    cell.lblPhi.text = [NSString stringWithFormat:@"%@/€", [Common hienThiTienTe_1:_itemQR.tyGiaEUR]];
                }
                return cell;
            }
            else if (indexPath.row == 8) {
                MaGiamGiaTableViewCell *cell = (MaGiamGiaTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MaGiamGiaTableViewCell" forIndexPath:indexPath];
                cell.lblMaGiamGia.placeholder = [self layLangMaGiamGia];
                [cell.btnXemKM setTitle:[self layLangButtonMaGiamGia] forState:UIControlStateNormal];
                [cell.btnXemKM addTarget:self action:@selector(suKienChonKMDangCo:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }
            else if (indexPath.row == 9) {
                VNPayQRInputContentTableViewCell *cell = (VNPayQRInputContentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"VNPayQRInputContentTableViewCell" forIndexPath:indexPath];
                cell.lblContent.placeholder = [self layLangLoiNhan];
                return cell;
            }
        }
        
        VNPayQRInputMoneyViewCell *cell = (VNPayQRInputMoneyViewCell *)[tableView dequeueReusableCellWithIdentifier:@"VNPayQRInputMoneyViewCell" forIndexPath:indexPath];
        cell.lblPhi.text = [self layLangLabelPhi];
        if ([_itemQR.amount isEmpty]) {
            [cell.tfSoTien setEnabled:YES];
        } else {
            NSLog(@"%s - _itemQR.amount : %@", __FUNCTION__, _itemQR.amount);
            [cell.tfSoTien setEnabled:NO];
            cell.tfSoTien.text = [Common hienThiTienTeFromString:_itemQR.amount];
        }
        if (_itemQR.typeQRShow == 3) {
            cell.tfSoTien.text = [Common hienThiTienTe:soTienType3];
        }
        return cell;
    }
}

- (NSString *)layLangLabelPhiQRNganHang {
    NSString *sLoiNhan = @"Phí: 3.300 đ";
    if (nIndexLang == 1) {
        sLoiNhan = @"Fee: 3.300 đ";
    }
    else if (nIndexLang == 2)
        sLoiNhan = @"费用: 3.300 đ";
    else if (nIndexLang == 3)
        sLoiNhan = @"плата: 3.300 đ";
    else if (nIndexLang == 4)
        sLoiNhan = @"보수: 3.300 đ";
    else if (nIndexLang == 5)
        sLoiNhan = @"費用: 3.300 đ";
    else if (nIndexLang == 6)
        sLoiNhan = @"Gebühr: 3.300 đ";
    return sLoiNhan;
}

- (NSString *)layLangLabelPhi {
    NSString *sLoiNhan = @"Phí: 330 đ";
    if (nIndexLang == 1) {
        sLoiNhan = @"Fee: 330 đ";
    }
    else if (nIndexLang == 2)
        sLoiNhan = @"费用: 330 đ";
    else if (nIndexLang == 3)
        sLoiNhan = @"плата: 330 đ";
    else if (nIndexLang == 4)
        sLoiNhan = @"보수: 330 đ";
    else if (nIndexLang == 5)
        sLoiNhan = @"費用: 330 đ";
    else if (nIndexLang == 6)
        sLoiNhan = @"Gebühr: 330 đ";
    return sLoiNhan;
}

- (NSString *)layLangLoiNhan {
    NSString *sLoiNhan = @"Lời nhắn (có thể bỏ qua)";
    if (isQRNganHang) {
        sLoiNhan = @"Nội dung (có thể bỏ qua)";
    }
    if (nIndexLang == 1) {
        sLoiNhan = @"Message (optional)";
    }
    else if (nIndexLang == 6)
        sLoiNhan = @"Nachricht (kann ignoriert werden)";
    else if (nIndexLang == 2)
        sLoiNhan = @"消息（可以忽略)";
    else if (nIndexLang == 3)
        sLoiNhan = @"Сообщение (можно игнорировать)";
    else if (nIndexLang == 4)
        sLoiNhan = @"메시지 (무시할 수 있음)";
    else if (nIndexLang == 5) {
        sLoiNhan = @"メッセージ（無視できます";
    }
    return sLoiNhan;
}

- (NSString *)layLangMaGiamGia {
    NSString *sLoiNhan = @"Mã giảm giá";
    if (nIndexLang == 1) {
        sLoiNhan = @"Discount code";
    }
    else if (nIndexLang == 2)
        sLoiNhan = @"优惠码";
    else if (nIndexLang == 3)
        sLoiNhan = @"код скидки";
    else if (nIndexLang == 4)
        sLoiNhan = @"할인 코드";
    else if (nIndexLang == 5)
        sLoiNhan = @"ディスカウントコード";
    else if (nIndexLang == 6)
        sLoiNhan = @"Rabattcode";
    return sLoiNhan;
}

- (NSString *)layLangButtonMaGiamGia {
    NSString *sLoiNhan = @"Xem mã KM đang có";
    if (nIndexLang == 1) {
        sLoiNhan = @"See the code available";
    }
    else if (nIndexLang == 2)
        sLoiNhan = @"查看可用代码";
    else if (nIndexLang == 3)
        sLoiNhan = @"Смотрите код в наличии";
    else if (nIndexLang == 4)
        sLoiNhan = @"사용 가능한 코드보기";
    else if (nIndexLang == 5)
        sLoiNhan = @"利用可能なコードを見る";
    else if (nIndexLang == 6)
        sLoiNhan = @"Siehe den verfügbaren Code";
    return sLoiNhan;
}

- (NSString *)layLangLabelXacThuc {
    NSString *sLoiNhan = @"Xác thực";
    if (nIndexLang == 1) {
        sLoiNhan = @"Authentic";
    }
    else if (nIndexLang == 2)
        sLoiNhan = @"真实";
    else if (nIndexLang == 3)
        sLoiNhan = @"Aуте тичный";
    else if (nIndexLang == 4)
        sLoiNhan = @"진정한";
    else if (nIndexLang == 5)
        sLoiNhan = @"本物の";
    else if (nIndexLang == 6)
        sLoiNhan = @"Authentisch";
    return sLoiNhan;
}

- (NSString *)layLangLabelSoLuong {
    NSString *sLoiNhan = @"Số lượng";
    if (nIndexLang == 1) {
        sLoiNhan = @"Amount";
    }
    else if (nIndexLang == 2)
        sLoiNhan = @"量";
    else if (nIndexLang == 3)
        sLoiNhan = @"Количество";
    else if (nIndexLang == 4)
        sLoiNhan = @"양";
    else if (nIndexLang == 5)
        sLoiNhan = @"量";
    else if (nIndexLang == 6)
        sLoiNhan = @"Menge";
    return sLoiNhan;
}

- (NSString *)layLangLabelDonGia {
    NSString *sLoiNhan = @"Đơn giá:";
    if (nIndexLang == 1) {
        sLoiNhan = @"Unit price:";
    }
    else if (nIndexLang == 2)
        sLoiNhan = @"单价:";
    else if (nIndexLang == 3)
        sLoiNhan = @"Цена за единицу:";
    else if (nIndexLang == 4)
        sLoiNhan = @"단가:";
    else if (nIndexLang == 5)
        sLoiNhan = @"単価:";
    else if (nIndexLang == 6)
        sLoiNhan = @"Stückpreis:";
    return sLoiNhan;
}

- (double)tinhTyGia:(double)dAmount tyGiaNgoaiTe:(double)dTyGia {
    double tyGiaTemp = ceil(dTyGia * 10) / 10;
    double tiGia =  dAmount / tyGiaTemp;
    tiGia = ceil(tiGia * 100) / 100;
    return tiGia;
}

- (void)suKienChonKMDangCo:(UIButton *)btn {
    GiaoDienMaGiamGiaVNPay *vc = [[GiaoDienMaGiamGiaVNPay alloc] initWithNibName:@"GiaoDienMaGiamGiaVNPay" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)dealloc {
    [_tableView release];
    [_heightGlobal release];
    [_stackGlobal release];
    [super dealloc];
}

- (void)xuLyChuyenNgonNgu {
    if (isQRNganHang) {
        arrTitleType1 = [self chuyenNgonNguQRNganHang];
    } else {
        if (_itemQR.typeQRShow == 1) {
            arrTitleType1 = [self chuyenNgonNguType1];
        } else if (_itemQR.typeQRShow == 2) {
            arrTitleType1 = [self chuyenNgonNguType2];
        } else if (_itemQR.typeQRShow == 3) {
            arrTitleType1 = [self chuyenNgonNguType3];
        } else {
            arrTitleType1 = [self chuyenNgonNguType4];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        ViewAuthentication *footer = (ViewAuthentication *)self.tableView.tableFooterView;
        footer.lblXacThuc.text = [self layLangLabelXacThuc];
        [self.tableView reloadData];
    });
}

- (IBAction)suKienChonLangViet:(id)sender {
    if (nIndexLang != 0) {
        nIndexLang = 0;
        [self xuLyChuyenNgonNgu];
    }
}

- (IBAction)suKienChonLangEng:(id)sender {
    if (nIndexLang != 1) {
        nIndexLang = 1;
        [self xuLyChuyenNgonNgu];
    }
}

- (IBAction)suKienChonLangChina:(id)sender {
    if (nIndexLang != 2) {
        nIndexLang = 2;
        [self xuLyChuyenNgonNgu];
    }
}

- (IBAction)suKienChonLangRussia:(id)sender {
    if (nIndexLang != 3) {
        nIndexLang = 3;
        [self xuLyChuyenNgonNgu];
    }
}

- (IBAction)suKienChonLangKorea:(id)sender {
    if (nIndexLang != 4) {
        nIndexLang = 4;
        [self xuLyChuyenNgonNgu];
    }
}

- (IBAction)suKienChonLangJapan:(id)sender {
    if (nIndexLang != 5) {
        nIndexLang = 5;
        [self xuLyChuyenNgonNgu];
    }
}

- (IBAction)suKienChonLangGerman:(id)sender {
    if (nIndexLang != 6) {
        nIndexLang = 6;
        [self xuLyChuyenNgonNgu];
    }
}
@end
