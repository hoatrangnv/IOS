//
//  QRSanPhamViewController.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 12/1/17.
//

#import "QRSanPhamViewController.h"
#import "QRDonViTableViewCell.h"
#import "TaoQRSanPhamViewController.h"
#import "TaoQRDonViViewController.h"
#import "CommonUtils.h"
@interface QRSanPhamViewController () <UIGestureRecognizerDelegate> {
    NSMutableArray *arrQRSanPham;
}

@end

@implementation QRSanPhamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"QRDonViTableViewCell" bundle:nil] forCellReuseIdentifier:@"CellQRDonVi"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    UILongPressGestureRecognizer *longHander = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleHoldGesture:)];
    longHander.delegate = self;
    longHander.minimumPressDuration = 1;
    [self.imgvQRPhongTo addGestureRecognizer:longHander];
//    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(0, 0, 30, 30);
//    [button setImage:[UIImage imageNamed:@"icon-themtk64x64.png"]forState:UIControlStateNormal];
//
//    button.backgroundColor = [UIColor clearColor];
//    button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//    [button addTarget:self action:@selector(suKienChonThemQRSanPham:) forControlEvents:UIControlEventTouchUpInside];
//
//    UIBarButtonItem *btnRight = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
//
//    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    if (SYSTEM_VERSION_LESS_THAN(@"11"))
//        negativeSeperator.width = -10;
//    else {
//        negativeSeperator.width = -15;
//    }
//    [btnRight.customView.widthAnchor constraintEqualToConstant:30].active = YES;
//    [btnRight.customView.heightAnchor constraintEqualToConstant:30].active = YES;
//    self.navigationItem.rightBarButtonItems = @[negativeSeperator, btnRight];
}

- (void) handleHoldGesture:(UILongPressGestureRecognizer *)gestureRecognizer
{
    [self showThongBaoLuuQRCode];
}

- (void)showThongBaoLuuQRCode {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Thông báo" message:@"Lưu ảnh QRCode vào thư viện ảnh của điện thoại?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Đóng" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Lưu" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImage *img = self.imgvQRPhongTo.image;
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

- (void)suKienChonThemQRSanPham:(UIButton *)sender {
    TaoQRSanPhamViewController *vc = [[TaoQRSanPhamViewController alloc] initWithNibName:@"TaoQRSanPhamViewController" bundle:nil];
    vc.maDaiLy = self.maDaiLy;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = self.sTitle;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self ketNoiLayDanhSachQRSanPham];
}

- (BOOL)validateVanTay {
    return YES;
}

- (void)xuLyKetNoiLayMaXacThucChuyenDenTaiKhoan:(NSString *)sSendTo kieuXacThuc:(int)nKieu {
    int typeAuthenticate = 1;
    if([Common kiemTraLaMail:sSendTo])
        typeAuthenticate = 2;
    self.mTypeAuthenticate = typeAuthenticate;
//    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
//        [self hienThiLoading];
//    }
    self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_LAY_MA_XAC_THUC_TAO_DON_VI;
    NSDictionary *dict = @{@"maDaiLy":self.maDaiLy, @"typeAuthenticate":[NSNumber numberWithInt:self.mTypeAuthenticate], @"VMApp":[NSNumber numberWithInt:VM_APP]};
    [GiaoDichMang layMaOTPTaoSuaQRDonVi:[dict JSONString] noiNhanKetQua:self];
}

- (void)xuLyThucHienKhiKiemTraThanhCongTraVeToken:(NSString *)sToken otp:(NSString *)sOtp {
    NSLog(@"%s - self.mTypeAuthenticate : %d", __FUNCTION__, self.mTypeAuthenticate);
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
        [self hienThiLoading];
    }
    NSDictionary *dict = @{@"maDaiLy":self.maDaiLy, @"otpCheck":sOtp, @"token":sToken, @"VMApp":[NSNumber numberWithInt:VM_APP]};
    self.mDinhDanhKetNoi = @"XOA_DON_VI_QR";
    [GiaoDichMang xoaThongTinDaiLy:[dict JSONString] noiNhanKetQua:self];
}


- (IBAction)suKienChonXoaDV:(id)sender {
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Thông báo" message:@"Bạn muốn xoá đơn vị này?" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Đóng" style:UIAlertActionStyleCancel handler:nil];
//    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"Xoá" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"%s - xoa don vi qr", __FUNCTION__);
//    }];
//    [alert addAction:cancel];
//    [alert addAction:delete];
//    [self presentViewController:alert animated:YES completion:nil];
    [self.viewXacThuc setHidden:NO];
}

- (IBAction)suKienChonSuaDV:(id)sender {
    TaoQRDonViViewController *vc = [[TaoQRDonViViewController alloc] initWithNibName:@"TaoQRDonViViewController" bundle:nil];
    vc.nType = 1;
    vc.sMaQRDonVi = self.maDaiLy;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (IBAction)suKienChonThemSP:(id)sender {
    TaoQRSanPhamViewController *vc = [[TaoQRSanPhamViewController alloc] initWithNibName:@"TaoQRSanPhamViewController" bundle:nil];
    vc.maDaiLy = self.maDaiLy;
    vc.nType = 0;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (IBAction)suKienAnViewXacThuc:(id)sender {
    [self.viewXacThuc setHidden:YES];
}

- (IBAction)suKienDongViewQR:(id)sender {
    [UIView animateWithDuration:0.1 animations:^{
        [self.viewQRPhongTo setHidden:YES];
    }];
}

- (void)suKienChonPhongToQR:(UIButton *)sender {
    UIButton *btnTemp = (UIButton *)sender;
    int tag = (int)btnTemp.tag;
    NSDictionary *dict = [arrQRSanPham objectAtIndex:tag];
    NSString *sLinkQR = (NSString *)[dict objectForKey:@"linkQR"];
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:sLinkQR]];
        if ( data == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            // WARNING: is the cell still using the same data by this point??
            [self.imgvQRPhongTo setImage:[UIImage imageWithData: data]];
        });
        [data release];
    });
    [UIView animateWithDuration:0.1 animations:^{
        [self.viewQRPhongTo setHidden:NO];
    }];
}

- (void)ketNoiLayDanhSachQRSanPham {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
        [self hienThiLoading];
    }
    self.mDinhDanhKetNoi = @"KET_NOI_LAY_QR_SAN_PHAM";
    [GiaoDichMang ketNoiLayDanhSachQRSanPham:self.maDaiLy noiNhanKetQua:self];
}

- (void)xuLyKetNoiThanhCong:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
        [self anLoading];
    }
    if ([sDinhDanhKetNoi isEqualToString:@"KET_NOI_LAY_QR_SAN_PHAM"]) {
        if (arrQRSanPham == nil) {
            arrQRSanPham = [[NSMutableArray alloc] init];
        }
        [arrQRSanPham removeAllObjects];
        NSDictionary *dict = (NSDictionary *)ketQua;
        
        NSArray *arrSP = (NSArray *)[dict objectForKey:@"dsSanPham"];
        if (arrSP != nil && arrSP.count > 0) {
            [arrQRSanPham addObjectsFromArray:arrSP];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            UIView *viewFooter = nil;
            if (arrQRSanPham.count == 0) {
                viewFooter = [[UIView alloc] initWithFrame:self.tableView.frame];
                UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, viewFooter.frame.size.width - 10, viewFooter.frame.size.height)];
                lblTitle.textAlignment = NSTextAlignmentCenter;
                lblTitle.text = @"Hiện chưa có sản phẩm nào trong đơn vị.";
                lblTitle.numberOfLines = 0;
                [lblTitle setTextColor:[UIColor blackColor]];
                [viewFooter addSubview:lblTitle];
            }
            else {
                viewFooter = [[UIView alloc] initWithFrame:CGRectZero];
            }
            self.tableView.tableFooterView = viewFooter;
            [self.tableView reloadData];
        });
    }
    else if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_LAY_MA_XAC_THUC_TAO_DON_VI]) {
        
    }
    else if ([sDinhDanhKetNoi isEqualToString:@"XOA_DON_VI_QR"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//pragma mark: UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrQRSanPham != nil ? arrQRSanPham.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QRDonViTableViewCell *cell = (QRDonViTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellQRDonVi" forIndexPath:indexPath];
    NSDictionary *dict = [arrQRSanPham objectAtIndex:indexPath.row];
    NSString *sTenHienThi = (NSString *)[dict objectForKey:@"ten"];
    cell.lblTenHienThi.text = sTenHienThi;
    NSString *sLinkQR = (NSString *)[dict objectForKey:@"linkQR"];
    [CommonUtils displayImage:[NSURL URLWithString:sLinkQR] toImageView:cell.imgvQR placeHolder:nil];
    NSString *sDuongDanAnhDaiDien = (NSString *)[dict objectForKey:@"image"];
    sDuongDanAnhDaiDien = [sDuongDanAnhDaiDien stringByReplacingOccurrencesOfString:@"[" withString:@""];
    sDuongDanAnhDaiDien = [sDuongDanAnhDaiDien stringByReplacingOccurrencesOfString:@"]" withString:@""];
    [cell.imgvAvatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://vimass.vn/vmbank/services/media/getImage?id=%@", sDuongDanAnhDaiDien]] placeholderImage:[UIImage imageNamed:@"icon_danhba"]];
    cell.btnPhongToQR.tag = indexPath.row;
    [cell.btnPhongToQR addTarget:self action:@selector(suKienChonPhongToQR:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [arrQRSanPham objectAtIndex:indexPath.row];
    TaoQRSanPhamViewController *vc = [[TaoQRSanPhamViewController alloc] initWithNibName:@"TaoQRSanPhamViewController" bundle:nil];
    vc.maDaiLy = self.maDaiLy;
    vc.nType = 1;
    vc.dictSanPham = dict;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
//    NSString *sTenHienThi = (NSString *)[dict objectForKey:@"tenHienThi"];
//    NSString *maDaiLy = (NSString *)[dict objectForKey:@"maDaiLy"];
//    QRSanPhamViewController *hienThiTokenViewController = [[QRSanPhamViewController alloc] initWithNibName:@"QRSanPhamViewController" bundle:nil];
//    hienThiTokenViewController.sTitle = sTenHienThi;
//    hienThiTokenViewController.maDaiLy = maDaiLy;
//    [self.navigationController pushViewController:hienThiTokenViewController animated:YES];
//    [hienThiTokenViewController release];
}

- (void)dealloc {
    [_tableView release];
    [_viewXacThuc release];
    [_viewXacThuc release];
    [_imgvQRPhongTo release];
    [_viewQRPhongTo release];
    [super dealloc];
}

@end
