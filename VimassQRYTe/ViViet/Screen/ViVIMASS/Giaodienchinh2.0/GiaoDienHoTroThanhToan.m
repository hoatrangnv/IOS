//
//  GiaoDienHoTroThanhToan.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 9/8/19.
//

#import "GiaoDienHoTroThanhToan.h"
#import "ViVimass-Swift.h"
#import "GiaoDienThanhToanQRVNPay.h"
#import "GiaoDienThanhToanQRCode.h"
@interface GiaoDienHoTroThanhToan () <UITableViewDataSource, UITableViewDelegate, QRCodeReaderDelegate> {
    NSArray *arrOptions;
}

@end

@implementation GiaoDienHoTroThanhToan

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitleView:@"Hỗ trợ thanh toán"];
    
    UIBarButtonItem *btnRight = [[UIBarButtonItem alloc] initWithTitle:@"Hướng dẫn" style:UIBarButtonItemStylePlain target:self action:@selector(suKienChonHuongDan)];
    self.navigationItem.rightBarButtonItem = btnRight;
    
    arrOptions = @[@"Tra cứu chưa thanh toán", @"Tra cứu đã thanh toán", @"Tra cứu hoàn tiền", @"Tra cứu thẻ y tế", @"Điểm mua, mượn, trả thẻ"];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

- (void)suKienChonHuongDan {
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrOptions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.frame.size.height / 5.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIdentifier"];
    }
    cell.textLabel.textColor = [UIColor colorWithRed:0 green:114.0/255.0 blue:187.0/255.0 alpha:1];
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    cell.textLabel.text = arrOptions[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        GiaoDienDiemThanhToanVNPAY *vc = [[GiaoDienDiemThanhToanVNPAY alloc] initWithNibName:@"GiaoDienDiemThanhToanVNPAY" bundle:nil];
        vc.nType = 1;
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    } else {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Chức năng đang được phát triển."];
    }
//    if (indexPath.row == 0) {
//        TimQRYTeViewController *vc = [[TimQRYTeViewController alloc] initWithNibName:@"TimQRYTeViewController" bundle:nil];
//        [self.navigationController pushViewController:vc animated:YES];
//        [vc release];
//    } else if (indexPath.row == 1) {
//        GiaoDienDiemThanhToanVNPAY *vc = [[GiaoDienDiemThanhToanVNPAY alloc] initWithNibName:@"GiaoDienDiemThanhToanVNPAY" bundle:nil];
//        vc.nType = 1;
//        [self.navigationController pushViewController:vc animated:YES];
//        [vc release];
//    } else {
//        if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
//            QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
//            QRSearchViewController *vcQRCodeTemp = [[QRSearchViewController alloc]initWithNibName:@"QRSearchViewController" bundle:nil];
//            vcQRCodeTemp.codeReader = reader;
//            vcQRCodeTemp.modalPresentationStyle = UIModalPresentationFormSheet;
//            vcQRCodeTemp.delegate = self;
//            vcQRCodeTemp.nType = 1;
//            [self presentViewController:vcQRCodeTemp animated:YES completion:NULL];
//        }
//        else {
//            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Thiết bị không hỗ trợ chức năng này."];
//        }
//    }
}

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result {
    [reader stopScanning];
    NSLog(@"HomeCenterViewController - %s - line : %d- -->result : %@", __FUNCTION__, __LINE__, result);
    [reader dismissViewControllerAnimated:YES completion:^{
        
        if (result.length > 0) {
            if (![[result lowercaseString] containsString:@"http"] && ![[result lowercaseString] containsString:@"vimass"] && result.length > 20) {
                GiaoDienThanhToanQRVNPay *vc = [[GiaoDienThanhToanQRVNPay alloc] initWithNibName:@"GiaoDienThanhToanQRVNPay" bundle:nil];
                vc.sDataQR = result;
                self.navigationController.navigationBar.hidden = NO;
                [self.navigationController pushViewController:vc animated:YES];
                [vc release];
            } else {
                if (![result hasPrefix:@"http"] || [result hasSuffix:@"/transfers"]) {
                    if ([result containsString:@"*"]) {
                        NSArray *arrQuery = [result componentsSeparatedByString:@"*"];
                        if (arrQuery.count > 2) {
                            [DucNT_LuuRMS luuThongTinTrongRMSTheoKey:@"KEY_QR_SAN_PHAM_VER_2" value:[arrQuery objectAtIndex:1]];
                            GiaoDienThanhToanQRSanPham *vc = [[GiaoDienThanhToanQRSanPham alloc] initWithNibName:@"GiaoDienThanhToanQRSanPham" bundle:nil];
                            self.navigationController.navigationBar.hidden = NO;
                            [self.navigationController pushViewController:vc animated:YES];
                            [vc release];
                        }
                    }
                }
                else {
                    NSURL *url = [NSURL URLWithString:result];
                    NSString *queryQRCode = url.query;
                    //NSLog(@"%s - -->queryQRCode : %@", __FUNCTION__, queryQRCode);
                    if (queryQRCode == nil && [[url lastPathComponent] isEqualToString:@"quickpay"]) {

                    }
                    else {
                        NSLog(@"%s - line : %d ->queryQRCode : %@", __FUNCTION__, __LINE__, queryQRCode);
                        NSArray *arrQuery = [queryQRCode componentsSeparatedByString:@"="];
                        if (arrQuery.count == 2) {
                            NSString *idQRCode = [arrQuery lastObject];
                            //NSLog(@"%s - -->idQRCode : %@", __FUNCTION__, idQRCode);
                            GiaoDienThanhToanQRCode *vc = [[GiaoDienThanhToanQRCode alloc] initWithNibName:@"GiaoDienThanhToanQRCode" bundle:nil];
                            vc.sIdQRCode = idQRCode;
                            [self.navigationController pushViewController:vc animated:YES];
                            self.navigationController.navigationBar.hidden = NO;
                            [vc release];
                        }
                    }
                }
            }
        }
        
    }];
}

- (void)readerDidCancel:(QRSearchViewController *)reader {
    [reader dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
@end
