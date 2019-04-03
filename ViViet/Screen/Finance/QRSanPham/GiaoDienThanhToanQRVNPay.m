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
@interface GiaoDienThanhToanQRVNPay () <UITableViewDelegate, UITableViewDataSource, ViewAuthenticationDelegate> {
    int rowTable;
    NSArray *arrTitleType1;
}

@end

@implementation GiaoDienThanhToanQRVNPay

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"VNPAY QR";
    rowTable = 0;
    [self.tableView registerNib:[UINib nibWithNibName:@"VNPayQRTableViewCell" bundle:nil] forCellReuseIdentifier:@"VNPayQRTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"VNPayQRInputMoneyViewCell" bundle:nil] forCellReuseIdentifier:@"VNPayQRInputMoneyViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"VNPayQRInputContentTableViewCell" bundle:nil] forCellReuseIdentifier:@"VNPayQRInputContentTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"VNPayQRSoLuongTableViewCell" bundle:nil] forCellReuseIdentifier:@"VNPayQRSoLuongTableViewCell"];
    ViewAuthentication *footerView = [[[NSBundle mainBundle] loadNibNamed:@"ViewAuthentication" owner:self options:nil] objectAtIndex:0];
    footerView.delegate = self;
    footerView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 110);
    [footerView.btnToken addTarget:self action:@selector(suKienBamNutToken:) forControlEvents:UIControlEventTouchUpInside];
    footerView.enableFaceID = self.enableFaceID;
    [self.tableView setTableFooterView:footerView];
    [self khoiTaoButtonXacThucBanDau];
    
    [self.tableView setHidden:YES];
    [self ketNoiLayThongTinQR];
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
        NSDictionary *dictChiTiet = [dictResult objectForKey:@"chiTiet"];
        NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:dictChiTiet];
        _itemQR = [[ItemVNPayQR alloc] initWithDict:dict];
        [_itemQR setData:dictChiTiet];
        NSString *temp =  _itemQR.merchantName;
        NSLog(@"%s - temp : %@", __FUNCTION__, temp);
        if (_itemQR.typeQRShow == 1) {
            rowTable = 7;
            arrTitleType1 = [[NSArray alloc] initWithObjects:@"Thanh toán cho", @"Điểm bán dịch vụ", @"Mã điểm bán", @"Số hoá đơn", nil];
        }
        else if (_itemQR.typeQRShow == 2) {
            if (_itemQR.purpose != nil && ![_itemQR.purpose isEmpty] && _itemQR.consumerData != nil && ![_itemQR.consumerData isEmpty]) {
                _itemQR.typeQRShow = 3;
                rowTable = 7;
                arrTitleType1 = [[NSArray alloc] initWithObjects:@"Thanh toán cho", @"Điểm bán dịch vụ", @"Tên sản phẩm", @"Mã sản phẩm", nil];
            } else if (_itemQR.purpose != nil && ![_itemQR.purpose isEmpty] && (_itemQR.billNumber == nil || [_itemQR.billNumber isEmpty]) && _itemQR.customerID != nil && ![_itemQR.customerID isEmpty]) {
                _itemQR.typeQRShow = 2;
                rowTable = 6;
                arrTitleType1 = [[NSArray alloc] initWithObjects:@"Nhà cung cấp", @"Dịch vụ", @"Mã khách hàng", nil];
            } else {
                _itemQR.typeQRShow = 1;
                if (_itemQR.billNumber == nil || [_itemQR.billNumber isEmpty]) {
                    rowTable = 6;
                    arrTitleType1 = [[NSArray alloc] initWithObjects:@"Thanh toán cho", @"Điểm bán dịch vụ", @"Mã điểm bán", nil];
                } else {
                    rowTable = 7;
                    arrTitleType1 = [[NSArray alloc] initWithObjects:@"Thanh toán cho", @"Điểm bán dịch vụ", @"Mã điểm bán", @"Số hoá đơn", nil];
                }
            }
        } else if (_itemQR.typeQRShow == 3){
            rowTable = 7;
            arrTitleType1 = [[NSArray alloc] initWithObjects:@"Thanh toán cho", @"Điểm bán dịch vụ", @"Tên sản phẩm", @"Mã sản phẩm", nil];
        } else if (_itemQR.typeQRShow == 4) {
            if (_itemQR.consumerData != nil && ![_itemQR.consumerData isEmpty]) {
                _itemQR.typeQRShow = 3;
                rowTable = 7;
                arrTitleType1 = [[NSArray alloc] initWithObjects:@"Thanh toán cho", @"Điểm bán dịch vụ", @"Tên sản phẩm", @"Mã sản phẩm", nil];
            } else {
                rowTable = 8;
                arrTitleType1 = [[NSArray alloc] initWithObjects:@"Thanh toán cho", @"Điểm bán dịch vụ", @"Số hoá đơn", @"Thời hạn thanh toán", @"Mô tả", nil];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView setHidden:NO];
            [self.tableView reloadData];
        });
    }
}

- (void)xuLyKetNoiThatBai:(NSString*)sDinhDanhKetNoi thongBao:(NSString*)sThongBao ketQua:(id)ketQua
{
    [self anLoading];
    [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
}

- (BOOL)validateVanTay {
    return YES;
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
    
}

- (void)suKienChonXacThucSDSecure {
    
}
//MARK: UITableViewDelegate
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
            
            NSDate *date = [NSDate dateWithTimeIntervalSinceNow:[_itemQR.expDate doubleValue]/1000.0];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"dd/MM/yyyy hh:mm"];
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
    return rowTable;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_itemQR.typeQRShow == 1) {
        int indexSplit = 4;
        if (_itemQR.billNumber == nil || [_itemQR.billNumber isEmpty]) {
            indexSplit = 3;
        }
        if (indexPath.row < indexSplit) {
            VNPayQRTableViewCell *cell = (VNPayQRTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"VNPayQRTableViewCell" forIndexPath:indexPath];
            [self configCellViewType1:cell indexPath:indexPath];
            return cell;
        } else if (indexPath.row == indexSplit + 1 || indexPath.row == indexSplit + 2) {
            VNPayQRInputContentTableViewCell *cell = (VNPayQRInputContentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"VNPayQRInputContentTableViewCell" forIndexPath:indexPath];
            if (indexPath.row == indexSplit + 1) {
                cell.lblContent.placeholder = @"Mã giảm giá";
            } else {
                cell.lblContent.placeholder = @"Lời nhắn (có thể bỏ qua)";
            }
            return cell;
        }
    } else if (_itemQR.typeQRShow == 2) {
        if (indexPath.row < 3) {
            VNPayQRTableViewCell *cell = (VNPayQRTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"VNPayQRTableViewCell" forIndexPath:indexPath];
            [self configCellViewType2:cell indexPath:indexPath];
            return cell;
        } else if (indexPath.row == 4 || indexPath.row == 5) {
            VNPayQRInputContentTableViewCell *cell = (VNPayQRInputContentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"VNPayQRInputContentTableViewCell" forIndexPath:indexPath];
            if (indexPath.row == 4) {
                cell.lblContent.placeholder = @"Mã giảm giá";
            } else {
                cell.lblContent.placeholder = @"Lời nhắn (có thể bỏ qua)";
            }
            return cell;
        }
    } else if (_itemQR.typeQRShow == 3) {
        if (indexPath.row < 4) {
            VNPayQRTableViewCell *cell = (VNPayQRTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"VNPayQRTableViewCell" forIndexPath:indexPath];
            [self configCellViewType3:cell indexPath:indexPath];
            return cell;
        }
        else if (indexPath.row == 5 || indexPath.row == 6) {
            VNPayQRInputContentTableViewCell *cell = (VNPayQRInputContentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"VNPayQRInputContentTableViewCell" forIndexPath:indexPath];
            if (indexPath.row == 5) {
                cell.lblContent.placeholder = @"Mã giảm giá";
            } else {
                cell.lblContent.placeholder = @"Lời nhắn (có thể bỏ qua)";
            }
            return cell;
        }
        else if (indexPath.row == 4) {
            VNPayQRSoLuongTableViewCell *cell = (VNPayQRSoLuongTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"VNPayQRSoLuongTableViewCell" forIndexPath:indexPath];
            cell.lblDonGia.text = [NSString stringWithFormat:@"%@ %@", [@"don_gia_qr" localizableString], [Common hienThiTienTeFromString:_itemQR.amount]];
            return cell;
        }
    } else if (_itemQR.typeQRShow == 4) {
        if (indexPath.row < 5) {
            VNPayQRTableViewCell *cell = (VNPayQRTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"VNPayQRTableViewCell" forIndexPath:indexPath];
            [self configCellViewType4:cell indexPath:indexPath];
            return cell;
        }
        else if (indexPath.row == 6 || indexPath.row == 7) {
            VNPayQRInputContentTableViewCell *cell = (VNPayQRInputContentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"VNPayQRInputContentTableViewCell" forIndexPath:indexPath];
            if (indexPath.row == 6) {
                cell.lblContent.placeholder = @"Mã giảm giá";
            } else {
                cell.lblContent.placeholder = @"Lời nhắn (có thể bỏ qua)";
            }
            return cell;
        }
    }
    
    VNPayQRInputMoneyViewCell *cell = (VNPayQRInputMoneyViewCell *)[tableView dequeueReusableCellWithIdentifier:@"VNPayQRInputMoneyViewCell" forIndexPath:indexPath];
    if ([_itemQR.amount isEmpty]) {
        [cell.tfSoTien setEnabled:YES];
    } else {
        [cell.tfSoTien setEnabled:NO];
        cell.tfSoTien.text = [Common hienThiTienTeFromString:_itemQR.amount];
    }
//    if (_itemQR.typeQRShow == 1) {
//        if (indexPath.row == 4) {
//            [cell setIsNhapTien:YES];
//        } else {
//            [cell setIsNhapTien:NO];
//        }
//    } else if (_itemQR.typeQRShow == 3 || _itemQR.typeQRShow == 4) {
//        cell.tfSoTien.text = [Common hienThiTienTeFromString:_itemQR.amount];
//    }
    return cell;
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
@end
