//
//  QRDonViViewController.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 12/1/17.
//

#import "QRDonViViewController.h"
#import "QRDonViTableViewCell.h"
#import "TaoQRDonViViewController.h"
#import "QRSanPhamViewController.h"
#import "QRDonViHeaderCuaToi.h"
#import "TaoQRSanPhamViewController.h"
#import "QRDonViSanPhamTableViewCell.h"
#import "CommonUtils.h"
#import "ViVimass-Swift.h"
#import "GiaoDienGioiThieuVi.h"
@interface QRDonViViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate> {
    NSMutableArray *arrQRDonVi;
    NSMutableArray *arrQRSanPham;
    BOOL isLongPress, isXoaCacheAnh;
}

@end

@implementation QRDonViViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"QRDonViTableViewCell" bundle:nil] forCellReuseIdentifier:@"CellQRDonVi"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QRDonViSanPhamTableViewCell" bundle:nil] forCellReuseIdentifier:@"QRDonViSanPhamTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QRDonViHeaderCuaToi" bundle:nil] forHeaderFooterViewReuseIdentifier:@"QRDonViHeaderCuaToi"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button setImage:[UIImage imageNamed:@"hdsd-icon"]forState:UIControlStateNormal];
    
    button.backgroundColor = [UIColor clearColor];
    button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [button addTarget:self action:@selector(suKienChonThongTin:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnRight = [[UIBarButtonItem alloc] initWithCustomView:button];
    [btnRight.customView.widthAnchor constraintEqualToConstant:32].active = YES;
    [btnRight.customView.heightAnchor constraintEqualToConstant:32].active = YES;
    self.navigationItem.rightBarButtonItem = btnRight;
    
    isLongPress = NO;
    isXoaCacheAnh = NO;
    self.imgvQRPhongTo.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longHander = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleHoldGesture:)];
    longHander.delegate = self;
    longHander.minimumPressDuration = 1;
    [self.imgvQRPhongTo addGestureRecognizer:longHander];
    //
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addTitleView:@"Vimass QR"];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!isXoaCacheAnh) {
        isXoaCacheAnh = YES;
        SDImageCache *imageCache = [SDImageCache sharedImageCache];
        [imageCache removeImageForKey:self.mThongTinTaiKhoanVi.linkQR fromDisk:YES withCompletion:^{
        }];
    }
    [self ketNoiLayDanhSachSanPham];
    
}

- (void)suKienChonThongTin:(UIButton *)sender {
    GiaoDienGioiThieuVi *vc = [[GiaoDienGioiThieuVi alloc] initWithNibName:@"GiaoDienGioiThieuVi" bundle:nil];
    vc.nType = 1;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)suKienChonBack {
    if (_nType == 1) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Thông báo" message:@"Lưu ảnh vào thư viện ảnh của điện thoại?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Đóng" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        isLongPress = NO;
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

- (void)ketNoiLayDanhSach {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
        [self hienThiLoadingChuyenTien];
    }
    self.mDinhDanhKetNoi = @"DINH_DANH_LAY_QR_DON_VI";
    [GiaoDichMang ketNoiLayDanhSachQRDonVi:self];
}

- (void)ketNoiLayDanhSachSanPham {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hienThiLoading];
    });
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://vimass.vn/vmbank/services/boYTe_SanPhamYTe/layThongTinDaiLy?maDaiLy=%@", [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_MA_DAI_LY]]]];
    //create the Method "GET"
    [urlRequest setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                          if(httpResponse.statusCode == 200)
                                          {
                                              NSError *parseError = nil;
                                              NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                                              int msgCode = [[responseDictionary valueForKey:@"msgCode"] intValue];
                                              if (msgCode == 1) {
                                                  NSDictionary *result = (NSDictionary *)[responseDictionary valueForKey:@"result"];
                                                  NSArray *arrDsSanPham = (NSArray *)[result valueForKey:@"dsSanPham"];
                                                  if (arrQRSanPham == nil) {
                                                      arrQRSanPham = [[NSMutableArray alloc] init];
                                                  }
                                                  [arrQRSanPham removeAllObjects];
                                                  for (NSDictionary *item in arrDsSanPham) {
                                                      int qrYte = [item[@"qrYTe"] intValue];
                                                      if (qrYte == 0) {
                                                          [arrQRSanPham addObject:item];
                                                      }
                                                  }
                                                  //                [arrQRSanPham addObjectsFromArray:arrDsSanPham];
                                                  NSLog(@"%s - arrQRSanPham.count : %ld", __FUNCTION__, arrQRSanPham.count);
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [self.tableView reloadData];
                                                  });
                                              }
                                          }
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              [self anLoading];
                                          });
                                      }];
    [dataTask resume];
}

- (void)suKienChonThemQRDonVi:(UIButton *)sender {
    TaoQRDonViViewController *vc = [[TaoQRDonViViewController alloc] initWithNibName:@"TaoQRDonViViewController" bundle:nil];
    vc.nType = 0;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)suKienPhongToQRCuaToi:(UIButton *)sender {
    QRDonViHeaderCuaToi *view = (QRDonViHeaderCuaToi *)[[sender superview] superview];
    [UIView animateWithDuration:0.1 animations:^{
        [self.viewQRPhongTo setHidden:NO];
        UIImage *imgQR = view.imgvQR.image;
        self.imgvQRPhongTo.image = imgQR;
    }];
}

- (void)suKienChonXemSanPhamQRCuaToi:(UIButton *)sender {
    QRSanPhamViewController *vc = [[QRSanPhamViewController alloc] initWithNibName:@"QRSanPhamViewController" bundle:nil];
    vc.sTitle = self.mThongTinTaiKhoanVi.sNameAlias;
    vc.maDaiLy = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)suKienChonPhongToQRSanPham:(UIButton *)sender {
    [UIView animateWithDuration:0.1 animations:^{
        [self.viewQRPhongTo setHidden:NO];
        
        QRDonViSanPhamTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
        UIImage *imgQR = cell.imgvQR.image;
        self.imgvQRPhongTo.image = imgQR;
    }];
}

- (void)suKienChonPhongToAvatarSanPham:(UIButton *)sender {
    [UIView animateWithDuration:0.1 animations:^{
        [self.viewQRPhongTo setHidden:NO];
        
        QRDonViSanPhamTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
        UIImage *imgQR = cell.imgvAvatar.image;
        self.imgvQRPhongTo.image = imgQR;
    }];
}

- (void)suKienChonPhongToQR:(UIButton *)sender {
    [UIView animateWithDuration:0.1 animations:^{
        [self.viewQRPhongTo setHidden:NO];
        
        QRDonViTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:1]];
        UIImage *imgQR = cell.imgvQR.image;
        self.imgvQRPhongTo.image = imgQR;
    }];
}

- (IBAction)suKienDongQRPhongTo:(id)sender {
    [UIView animateWithDuration:0.1 animations:^{
        [self.viewQRPhongTo setHidden:YES];
    }];
}

- (void)xuLyKetNoiThanhCong:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
        [self anLoading];
    }
    if ([sDinhDanhKetNoi isEqualToString:@"DINH_DANH_LAY_QR_DON_VI"]) {
        if (arrQRDonVi == nil) {
            arrQRDonVi = [[NSMutableArray alloc] init];
        }
        [arrQRDonVi removeAllObjects];
        NSArray *arrTemp = (NSArray *)ketQua;
        [arrQRDonVi addObjectsFromArray:arrTemp];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIView *viewFooter = nil;
            if (arrQRDonVi.count == 0) {
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
}

- (void)suKienChonThemSanPham:(UIButton *)sender {
    if (sender.tag == 1) {
        [self suKienChonThemQRDonVi:sender];
    }
    else if (sender.tag == 0) {
        [DucNT_LuuRMS luuThongTinTrongRMSTheoKey:@"VIMASS_MA_GIAO_DICH" value:@""];
        TaoQRSanPhamVer2Controller *vc = [[TaoQRSanPhamVer2Controller alloc] initWithNibName:@"TaoQRSanPhamVer2Controller" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //    self.navigationItem.title = @" ";
}

//pragma mark: UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return arrQRSanPham != nil ? arrQRSanPham.count : 0;
    }
    return arrQRDonVi != nil ? arrQRDonVi.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 165;
    }
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        QRDonViHeaderCuaToi *view = (QRDonViHeaderCuaToi *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"QRDonViHeaderCuaToi"];
        [CommonUtils displayImage:[NSURL URLWithString:self.mThongTinTaiKhoanVi.linkQR] toImageView:view.imgvQR placeHolder:nil];
        view.lblName.text = self.mThongTinTaiKhoanVi.sNameAlias;
        NSString *sDuongDanAnhDaiDien = self.mThongTinTaiKhoanVi.sLinkAnhDaiDien;
        [view.imgvAvatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://vimass.vn/vmbank/services/media/getImage?id=%@", sDuongDanAnhDaiDien]] placeholderImage:[UIImage imageNamed:@"icon_danhba"]];
        [view.btnThemSanPham addTarget:self action:@selector(suKienChonThemSanPham:) forControlEvents:UIControlEventTouchUpInside];
        [view.btnPhongToQR addTarget:self action:@selector(suKienPhongToQRCuaToi:) forControlEvents:UIControlEventTouchUpInside];
        [view.btnChonXemSanPham addTarget:self action:@selector(suKienChonXemSanPhamQRCuaToi:) forControlEvents:UIControlEventTouchUpInside];
        return view;
    }
    else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
        view.backgroundColor = [UIColor colorWithRed:67.0/255.0 green:156.0/255.0 blue:61.0/255.0 alpha:1];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:@"Thêm sản phẩm QR" forState:UIControlStateNormal];
        [btn setTag:section];
        [btn addTarget:self action:@selector(suKienChonThemSanPham:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        return view;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        QRDonViSanPhamTableViewCell *cell = (QRDonViSanPhamTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"QRDonViSanPhamTableViewCell" forIndexPath:indexPath];
        NSDictionary *dict = [arrQRSanPham objectAtIndex:indexPath.row];
        NSString *name = (NSString *)[dict valueForKey:@"ten"];
        NSString *linkQR = (NSString *)[dict valueForKey:@"linkQR"];
        NSString *image = (NSString *)[dict valueForKey:@"image"];
        image = [image stringByReplacingOccurrencesOfString:@"[" withString:@""];
        image = [image stringByReplacingOccurrencesOfString:@"]" withString:@""];
        NSArray *arrTemp = [image componentsSeparatedByString:@";"];
        //        NSLog(@"%s - arrTemp.count : %ld", __FUNCTION__, arrTemp.count);
        if (arrTemp.count > 0) {
            [cell.imgvAvatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://vimass.vn/vmbank/services/media/getImage?id=%@", [arrTemp firstObject]]] placeholderImage:nil];
        }
        cell.lblTenHienThi.text = name;
        [CommonUtils displayImage:[NSURL URLWithString:linkQR] toImageView:cell.imgvQR placeHolder:nil];
        
        NSNumber *nGia = (NSNumber *)[dict valueForKey:@"gia"];
        cell.lblGia.text = [Common hienThiTienTe_1:[nGia doubleValue]];
        
        NSString *sDC1 = (NSString *)[dict valueForKey:@"diaChi1"];
        NSString *sDC2 = (NSString *)[dict valueForKey:@"diaChi2"];
        cell.lblDC1.text = sDC1;
        cell.lblDC2.text = sDC2;
        
        cell.btnPhongToQR.tag = indexPath.row;
        [cell.btnPhongToQR addTarget:self action:@selector(suKienChonPhongToQRSanPham:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnPhongToAvatar.tag = indexPath.row;
        [cell.btnPhongToAvatar addTarget:self action:@selector(suKienChonPhongToAvatarSanPham:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else {
        QRDonViTableViewCell *cell = (QRDonViTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellQRDonVi" forIndexPath:indexPath];
        NSDictionary *dict = [arrQRDonVi objectAtIndex:indexPath.row];
        NSString *sTenHienThi = (NSString *)[dict objectForKey:@"tenHienThi"];
        cell.lblTenHienThi.text = sTenHienThi;
        NSString *sLinkQR = (NSString *)[dict objectForKey:@"linkQR"];
        [CommonUtils displayImage:[NSURL URLWithString:sLinkQR] toImageView:cell.imgvQR placeHolder:nil];
        
        NSString *sDuongDanAnhDaiDien = (NSString *)[dict objectForKey:@"avatar"];
        [cell.imgvAvatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://vimass.vn/vmbank/services/media/getImage?id=%@", sDuongDanAnhDaiDien]] placeholderImage:nil];
        cell.btnPhongToQR.tag = indexPath.row;
        [cell.btnPhongToQR addTarget:self action:@selector(suKienChonPhongToQR:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSDictionary *dict = [arrQRSanPham objectAtIndex:indexPath.row];
        NSString *maGiaoDich = [dict objectForKey:@"maGiaoDich"];
        TaoQRSanPhamVer2Controller *vc = [[TaoQRSanPhamVer2Controller alloc] initWithNibName:@"TaoQRSanPhamVer2Controller" bundle:nil];
        [DucNT_LuuRMS luuThongTinTrongRMSTheoKey:@"VIMASS_MA_GIAO_DICH" value:maGiaoDich];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
        //        TaoQRSanPhamViewController *vc = [[TaoQRSanPhamViewController alloc] initWithNibName:@"TaoQRSanPhamViewController" bundle:nil];
        //        vc.maDaiLy = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
        //        vc.nType = 1;
        //        vc.dictSanPham = dict;
        //        [self.navigationController pushViewController:vc animated:YES];
        //        [vc release];
    }
    else {
        NSDictionary *dict = [arrQRDonVi objectAtIndex:indexPath.row];
        NSString *sTenHienThi = (NSString *)[dict objectForKey:@"tenHienThi"];
        NSString *maDaiLy = (NSString *)[dict objectForKey:@"maDaiLy"];
        
        QRSanPhamViewController *vc = [[QRSanPhamViewController alloc] initWithNibName:@"QRSanPhamViewController" bundle:nil];
        vc.sTitle = sTenHienThi;
        vc.maDaiLy = maDaiLy;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

- (void)dealloc {
    [_tableView release];
    [_viewQRPhongTo release];
    [_imgvQRPhongTo release];
    [super dealloc];
}

@end
