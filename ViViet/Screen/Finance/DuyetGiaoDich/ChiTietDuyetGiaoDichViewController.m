//
//  ChiTietDuyetGiaoDichViewController.m
//  ViViMASS
//
//  Created by DucBui on 6/11/15.
//
//

#import <WebKit/WebKit.h>
#import "ChiTietDuyetGiaoDichViewController.h"
#import "DoiTuongChiTietGiaoDichTheoLo.h"
#import "DoiTuongGiaoDichTheoLo.h"
#import "ViewChiTietMotGiaoDichTheoLo.h"
#import "ChiTietDuyetGiaoDichTheoLoTableViewCell.h"


#define DINH_DANH_KET_NOI_LAY_CHI_TIET_DUYET_GIAO_DICH @"DINH_DANH_KET_NOI_LAY_CHI_TIET_DUYET_GIAO_DICH"

#define DINH_DANH_KET_NOI_HUY_GIAO_DICH @"DINH_DANH_KET_NOI_HUY_GIAO_DICH"
#define DINH_DANH_KET_NOI_DUYET_GIAO_DICH @"DINH_DANH_KET_NOI_DUYET_GIAO_DICH"

@interface ChiTietDuyetGiaoDichViewController () <UITableViewDataSource, UITableViewDelegate>
{
    BOOL mLanDauTien;
}
@property (nonatomic, retain) ViewChiTietMotGiaoDichTheoLo *mViewChiTietMotGiaoDichTheoLo;
@property (nonatomic, retain) NSArray *mDanhSachGiaoDich;
@end

@implementation ChiTietDuyetGiaoDichViewController


#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self khoiTaoBanDau];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self khoiTaoGiaoDienTheoQuyenCuaDoiTuong];
    [self.view endEditing:YES];
    
//    [self xuLyKetNoiThanhCong:DINH_DANH_KET_NOI_DUYET_GIAO_DICH thongBao:@"Thanh Cong" ketQua:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - khoiTao

- (void)khoiTaoBanDau
{
    mLanDauTien = YES;
    [self addButtonBack];
//    self.navigationItem.title = @"Chi tiết giao dịch";
    [self addTitleView:@"Chi tiết giao dịch"];
    self.mFuncID = FUNC_DUYET_GIAO_DICH_DOANH_NGHIEP;
    _mtvNoiDung.inputAccessoryView = nil;
    
    [_mbtnHuy setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateSelected];
    [_mbtnHuy setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_mbtnHuy setBackgroundImage:[UIImage imageNamed:@"bg_button"] forState:UIControlStateNormal];
    [_mbtnHuy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_mbtnDuyet setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateSelected];
    [_mbtnDuyet setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_mbtnDuyet setBackgroundImage:[UIImage imageNamed:@"bg_button"] forState:UIControlStateNormal];
    [_mbtnDuyet setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.mtbDsGiaoDich setHidden:YES];
    [_mViewChuaNoiDung setHidden:YES];
    [self.mViewNhapToken setHidden:YES];
    [_mViewThoiGianConLai setHidden:YES];
    [_mViewChuaNutXacNhan setHidden:YES];
    [self.mViewTongSoTien setHidden:YES];
    [self.mViewMain setHidden:YES];
    if(_mDoiTuongGiaoDich)
    {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
            [self hienThiLoading];
        }
        self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_LAY_CHI_TIET_DUYET_GIAO_DICH;
        [GiaoDichMang ketNoiLayChiTietDuyetGiaoDich:_mDoiTuongGiaoDich.maGiaoDich noiNhanKetQua:self];
    }
    else {
        NSLog(@"%s - doiTuongGiaoDich == nil", __FUNCTION__);
        self.mViewMain.hidden = NO;
    }
}

- (void)khoiTaoGiaoDienTheoQuyenCuaDoiTuong
{
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(mLanDauTien && nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        mLanDauTien = NO;
        if([self.mThongTinTaiKhoanVi layQuyenDuocDuyetGiaoDichTrongChucNang:[_mDoiTuongGiaoDich.funcId intValue]])
        {
//             || [[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP] isEqualToString:@"0913201990"]
            [_mbtnDuyet setHidden:NO];
        }
        else
        {
            [_mbtnDuyet setHidden:YES];
            CGRect rbtnHuy = _mbtnHuy.frame;
            rbtnHuy.origin.x = (_mViewChuaNutXacNhan.frame.size.width - rbtnHuy.size.width) / 2;
            _mbtnHuy.frame = rbtnHuy;
        }
        
    }
}

- (void)khoiTaoGiaoDienTheoDoiTuongDuyetGiaoDich
{
    NSLog(@"%s - line : %d - [_mDoiTuongGiaoDich.trangThai intValue] : %d", __FUNCTION__, __LINE__, [_mDoiTuongGiaoDich.trangThai intValue]);
    NSLog(@"%s - line : %d - _mDoiTuongGiaoDich.funcId : %d", __FUNCTION__, __LINE__, [_mDoiTuongGiaoDich.funcId intValue]);
    [_mtbDsGiaoDich layoutIfNeeded];
    self.heightTableView.constant = _mtbDsGiaoDich.contentSize.height;
    NSLog(@"%s - line : %d - self.heightTableView.constant : %f", __FUNCTION__, __LINE__, self.heightTableView.constant);
    if([_mDoiTuongGiaoDich.trangThai intValue] == DOANH_NGHIEP_LAP_LENH_THANH_CONG)
    {
        [_mViewChuaNoiDung setHidden:YES];
        self.heightViewNoiDung.constant = 0.0;
        [self.mViewNhapToken setHidden:YES];
        self.heightViewNhapXacThuc.constant = 0.0;
        [_mViewThoiGianConLai setHidden:YES];

        
        [_mViewChuaNutXacNhan setHidden:NO];

        if([_mDoiTuongGiaoDich.funcId intValue] == FUNC_DOANH_NGHIEP_LAP_LENH_THEO_LO)
        {
            [_mtbDsGiaoDich setHidden:NO];
            [_mViewTongSoTien setHidden:NO];
            self.heightViewTongSoTien.constant = 50.0;
        }
        else
        {
            [_mtbDsGiaoDich setHidden:YES];
            [_mViewTongSoTien setHidden:YES];
            self.heightTableView.constant = 0;
            self.heightViewTongSoTien.constant = 0.0;
        }
    }
    else
    {
        [_mViewChuaNoiDung setHidden:YES];
        self.heightViewNoiDung.constant = 0.0;
        [self.mViewNhapToken setHidden:YES];
        self.heightViewNhapXacThuc.constant = 0.0;
        [_mViewThoiGianConLai setHidden:YES];
        [_mViewChuaNutXacNhan setHidden:YES];
        [self.mbtnVanTay setHidden:YES];
        if([_mDoiTuongGiaoDich.funcId intValue] == FUNC_DOANH_NGHIEP_LAP_LENH_THEO_LO)
        {
            [_mtbDsGiaoDich setHidden:NO];
            [_mViewTongSoTien setHidden:NO];
            self.heightViewTongSoTien.constant = 50.0;
        }
        else
        {
            [_mtbDsGiaoDich setHidden:YES];
            [_mViewTongSoTien setHidden:YES];
            self.heightViewTongSoTien.constant = 0.0;
            self.heightTableView.constant = 0.0;
        }

    }
    if (self.heightTableView.constant > 0) {
        [_mscvHienThi setContentSize:CGSizeMake(_mscvHienThi.frame.size.width, _mtbDsGiaoDich.frame.origin.y + self.heightTableView.constant + _mViewTongSoTien.frame.origin.y + self.heightViewTongSoTien.constant)];
        NSLog(@"%s - line : %d - size contnt : %f", __FUNCTION__, __LINE__, _mtbDsGiaoDich.frame.origin.y + self.heightTableView.constant + _mViewTongSoTien.frame.origin.y + self.heightViewTongSoTien.constant);
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_mscvHienThi setContentSize:CGSizeMake(_mscvHienThi.frame.size.width, self.mViewMain.frame.size.height + self.mViewMain.frame.origin.y)];
        NSLog(@"%s - line : %d - size mViewMain : %f", __FUNCTION__, __LINE__, self.mViewMain.frame.size.height);
    });
    [_mscvHienThi setContentOffset:CGPointMake(0.0f, 0.0f) animated:NO];
}

#pragma mark - overriden GiaoDichViewController

- (BOOL)validateVanTay
{
    return YES;
}

- (void)xuLyThucHienKhiKiemTraThanhCongTraVeToken:(NSString*)sToken otp:(NSString*)sOtp
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
            [self hienThiLoading];
        }
        if(_mbtnDuyet.selected)
        {
            self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_DUYET_GIAO_DICH;
            [GiaoDichMang ketNoiDuyetGiaoDich:@[_mDoiTuongGiaoDich.maGiaoDich]
                                     chucNang:[_mDoiTuongGiaoDich.funcId intValue]
                                      noiDung:_mtvNoiDung.text
                                maDoanhNghiep:_mDoiTuongGiaoDich.companyCode
                                        token:sToken
                                          otp:sOtp
                             typeAuthenticate:self.mTypeAuthenticate
                                noiNhanKetQua:self];
        }
        else if (_mbtnHuy.selected)
        {
            self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_HUY_GIAO_DICH;
            [GiaoDichMang ketNoiHuyDuyetGiaoDich:@[_mDoiTuongGiaoDich.maGiaoDich]
                                        chucNang:[_mDoiTuongGiaoDich.funcId intValue]
                                   maDoanhNghiep:_mDoiTuongGiaoDich.companyCode
                                         noiDung:_mtvNoiDung.text
                                           token:sToken
                                             otp:sOtp
                                typeAuthenticate:self.mTypeAuthenticate
                                   noiNhanKetQua:self];
        }
    });
}

- (void)xuLyKetNoiThanhCong:(NSString*)sDinhDanhKetNoi thongBao:(NSString*)sThongBao ketQua:(id)ketQua
{
    NSLog(@"%s - sDinhDanhKetNoi : %@", __FUNCTION__, sDinhDanhKetNoi);

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self anLoading];
    }
    if([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_LAY_CHI_TIET_DUYET_GIAO_DICH])
    {
        NSString *fullInput = [(NSDictionary*)ketQua valueForKey:@"fullInput"];
        if(fullInput)
        {
            NSDictionary *dictFullInput = [fullInput objectFromJSONString];
            [_mDoiTuongGiaoDich khoiTaoDoiTuongChiTietGiaoDich:dictFullInput];
            NSString *sXauHTML = [_mDoiTuongGiaoDich layXauHTMLHienThiDoiTuongGiaoDich];
            [_mwvHienThi loadHTMLString:sXauHTML baseURL:nil];
            if([_mDoiTuongGiaoDich.funcId intValue] == FUNC_DOANH_NGHIEP_LAP_LENH_THEO_LO)
            {
                DoiTuongGiaoDichTheoLo *mDoiTuongGiaoDichTheoLo = (DoiTuongGiaoDichTheoLo*)_mDoiTuongGiaoDich.mDoiTuongChiTietGiaoDich;
                double fSoTienGiaoDich = 0.0f;
                double fSoPhiGiaoDich = 0.0f;
                for(DoiTuongChiTietGiaoDichTheoLo *doiTuong in mDoiTuongGiaoDichTheoLo.mDsGiaoDich)
                {
                    if([doiTuong.funcId intValue] > 0)
                    {
                        fSoTienGiaoDich += [doiTuong.mDoiTuongChiTietGiaoDich laySoTienGiaoDich];
                        fSoPhiGiaoDich += [doiTuong.mDoiTuongChiTietGiaoDich laySoTienPhiGiaoDich];
                    }
                }
                _mTongSoTien.text = [Common hienThiTienTe_1:fSoTienGiaoDich];
                _mlblTongSoPhi.text = [Common hienThiTienTe_1:fSoPhiGiaoDich];
                self.mDanhSachGiaoDich = [(DoiTuongGiaoDichTheoLo*)_mDoiTuongGiaoDich.mDoiTuongChiTietGiaoDich mDsGiaoDich];
                [_mtbDsGiaoDich reloadData];
            }
        }
//        else
//        {
//            [self hienThiHopThoaiMotNutBamKieu:HOP_THOAI_XAC_NHAN_CHUYEN_TIEN_THANH_CONG cauThongBao:@"Có lỗi trong quá trình lấy dữ liệu. Vui lòng thử lại sau!"];
//        }
    }
    else if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_DUYET_GIAO_DICH])
    {
        //Duyet thanh cong thay doi trang thai
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
        _mDoiTuongGiaoDich.trangThai = [NSNumber numberWithInt:DOANH_NGHIEP_DUYET_LENH_THANH_CONG];
        if([self.mDelegate respondsToSelector:@selector(suKienDuyetGiaoDichThanhCong)])
        {
            [self.mDelegate suKienDuyetGiaoDichThanhCong];
        }
    }
    else if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_HUY_GIAO_DICH])
    {
        _mDoiTuongGiaoDich.trangThai = [NSNumber numberWithInt:DOANH_NGHIEP_DA_HUY];
        if([self.mDelegate respondsToSelector:@selector(suKienHuyDuyetGiaoDichThanhCong)])
        {
            [self.mDelegate suKienHuyDuyetGiaoDichThanhCong];
        }
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
    }
    self.mViewMain.hidden = NO;
}

- (void)xuLyKetNoiThatBai:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self anLoading];
    }
    [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_mDanhSachGiaoDich)
        return  _mDanhSachGiaoDich.count;
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DoiTuongChiTietGiaoDichTheoLo *doiTuongChiTietGiaoDichTheoLo = [_mDanhSachGiaoDich objectAtIndex:indexPath.row];
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        if([doiTuongChiTietGiaoDichTheoLo.funcId intValue] > 0)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ChiTietDuyetGiaoDichTheoLoTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        else
            
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }

    }
    if([doiTuongChiTietGiaoDichTheoLo.funcId intValue] > 0)
    {
        double fSoTienGiaoDich = [doiTuongChiTietGiaoDichTheoLo.mDoiTuongChiTietGiaoDich laySoTienGiaoDich];
        ChiTietDuyetGiaoDichTheoLoTableViewCell *chiTietCell = (ChiTietDuyetGiaoDichTheoLoTableViewCell *)cell;
        chiTietCell.mlblTieuDe.text = [doiTuongChiTietGiaoDichTheoLo.mDoiTuongChiTietGiaoDich layKieuGiaoDich];
        chiTietCell.mlblSoTien.text = [Common hienThiTienTe_1:fSoTienGiaoDich];
        chiTietCell.mlblNoiDung.text = [doiTuongChiTietGiaoDichTheoLo.mDoiTuongChiTietGiaoDich layNoiDung];
    }
    else
    {
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.textLabel.text = doiTuongChiTietGiaoDichTheoLo.moTa;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DoiTuongChiTietGiaoDichTheoLo *doiTuongChiTietGiaoDichTheoLo = [_mDanhSachGiaoDich objectAtIndex:indexPath.row];
    if([doiTuongChiTietGiaoDichTheoLo.funcId intValue] > 0)
    {
        [self.view endEditing:YES];
        if(!_mViewChiTietMotGiaoDichTheoLo)
        {
            self.mViewChiTietMotGiaoDichTheoLo = [[[NSBundle mainBundle] loadNibNamed:@"ViewChiTietMotGiaoDichTheoLo" owner:self options:nil] objectAtIndex:0];
        }
        _mViewChiTietMotGiaoDichTheoLo.frame = _mscvHienThi.frame;
        NSMutableString *chiTietHienThi = [[NSMutableString alloc] init] ;
        [chiTietHienThi appendString:@"<div style=\"font-size:14px; font-family:arial\">"];

        [chiTietHienThi appendString:[doiTuongChiTietGiaoDichTheoLo.mDoiTuongChiTietGiaoDich layChiTietHienThi]];
        [chiTietHienThi appendString:@"</div>"];
        _mViewChiTietMotGiaoDichTheoLo.mXauHtmlHienThi = chiTietHienThi;
        [chiTietHienThi release];
        
        [self.view addSubview:_mViewChiTietMotGiaoDichTheoLo];
    }
    else
    {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:doiTuongChiTietGiaoDichTheoLo.moTa];
    }
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DoiTuongChiTietGiaoDichTheoLo *doiTuongChiTietGiaoDichTheoLo = [_mDanhSachGiaoDich objectAtIndex:indexPath.row];
    if([doiTuongChiTietGiaoDichTheoLo.funcId intValue] > 0)
    {
        return 60.0f;
    }
    return 44.0f;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGRect frame = _mwvHienThi.frame;
//    frame.size.height = 1;
//    _mwvHienThi.frame = frame;
    CGSize fittingSize = [_mwvHienThi sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
//    _mwvHienThi.frame = frame;
    self.heightWebHienThi.constant = frame.size.height;
    
    [self khoiTaoGiaoDienTheoDoiTuongDuyetGiaoDich];
    
//    self.mscvHienThi setContentSize:CGSizeMake(self.mscvHienThi.frame.size.width, self.)
}

#pragma mark - suKien
- (IBAction)suKienBamNutHuy:(id)sender
{
    if(!_mbtnHuy.selected)
        [self xuLyHienThiKhiBamNutHuy];
}

- (IBAction)suKienBamNutDuyet:(id)sender
{
    if(!_mbtnDuyet.selected)
        [self xuLyHienThiKhiBamNutDuyet];
}

#pragma mark - xuLySuKien

- (void)xuLyHienThiKhiBamNutHuy
{
    [_mbtnHuy setSelected:YES];
    [_mbtnDuyet setSelected:NO];
    
    [_mViewChuaNoiDung setHidden:NO];
    [self.mViewNhapToken setHidden:YES];
    [_mViewThoiGianConLai setHidden:NO];
    self.heightViewNhapXacThuc.constant = 0.0;
    self.heightViewNoiDung.constant = 70.0;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _mscvHienThi.contentSize = CGSizeMake(_mscvHienThi.frame.size.width, self.mViewMain.frame.origin.y + self.mViewMain.frame.size.height + 20);
    });
    
//    CGRect rViewThoiGianConLai = _mViewThoiGianConLai.frame;
//    CGRect rViewNhapToken = self.mViewNhapToken.frame;
//    CGRect rViewChuaNutXacNhan = _mViewChuaNutXacNhan.frame;
//    CGRect rViewChuaNoiDung = _mViewChuaNoiDung.frame;
//    CGRect rBtnVanTay = self.mbtnVanTay.frame;
//    CGRect rViewMain = self.mViewMain.frame;
//
//    [_mViewChuaNoiDung setHidden:NO];
//    [self.mViewNhapToken setHidden:NO];
//    [_mViewThoiGianConLai setHidden:NO];
//
//    rViewChuaNoiDung.origin.y = rViewChuaNutXacNhan.origin.y + rViewChuaNutXacNhan.size.height + 8;
//    rViewThoiGianConLai.origin.y = rViewChuaNoiDung.origin.y + rViewChuaNoiDung.size.height + 8;
//    rViewNhapToken.origin.y = rViewThoiGianConLai.origin.y + rViewThoiGianConLai.size.height + 8;
//    rViewMain.size.height = rViewNhapToken.origin.y + rViewNhapToken.size.height + 10;
//
//    if([self kiemTraCoChucNangQuetVanTay])
//    {
//        [self.mbtnVanTay setHidden:NO];
//        rBtnVanTay.origin.y = rViewMain.origin.y + rViewMain.size.height + 20;
//        float fHeight = rBtnVanTay.origin.y + rBtnVanTay.size.height + 10;
//        _mscvHienThi.contentSize = CGSizeMake(_mscvHienThi.frame.size.width, fHeight);
//    }
//    else
//    {
//        [self.mbtnVanTay setHidden:YES];
//        float fHeight = 2*rViewMain.origin.y + rViewMain.size.height;
//        _mscvHienThi.contentSize = CGSizeMake(_mscvHienThi.frame.size.width, fHeight);
//    }
//
//    _mViewThoiGianConLai.frame = rViewThoiGianConLai;
//    self.mViewNhapToken.frame = rViewNhapToken;
//    _mViewChuaNutXacNhan.frame = rViewChuaNutXacNhan;
//    _mViewChuaNoiDung.frame = rViewChuaNoiDung;
//    self.mbtnVanTay.frame = rBtnVanTay;
//    self.mViewMain.frame = rViewMain;
    
}

- (void)xuLyHienThiKhiBamNutDuyet
{
    [_mbtnHuy setSelected:NO];
    [_mbtnDuyet setSelected:YES];
    
    [_mViewChuaNoiDung setHidden:YES];
    [self.mViewNhapToken setHidden:YES];
    [_mViewThoiGianConLai setHidden:NO];
    self.heightViewNhapXacThuc.constant = 0.0;
    self.heightViewNoiDung.constant = 0.0;
    
    _mscvHienThi.contentSize = CGSizeMake(_mscvHienThi.frame.size.width, self.mViewMain.frame.origin.y + self.mViewMain.frame.size.height + 20);
//
//    CGRect rViewThoiGianConLai = _mViewThoiGianConLai.frame;
//    CGRect rViewNhapToken = self.mViewNhapToken.frame;
//    CGRect rViewChuaNutXacNhan = _mViewChuaNutXacNhan.frame;
//    CGRect rViewChuaNoiDung = _mViewChuaNoiDung.frame;
//    CGRect rBtnVanTay = self.mbtnVanTay.frame;
//    CGRect rViewMain = self.mViewMain.frame;
//
//    [_mViewChuaNoiDung setHidden:YES];
//    [self.mViewNhapToken setHidden:NO];
//    [_mViewThoiGianConLai setHidden:NO];
//
//    rViewThoiGianConLai.origin.y = rViewChuaNutXacNhan.origin.y + rViewChuaNutXacNhan.size.height + 8;
//    rViewNhapToken.origin.y = rViewThoiGianConLai.origin.y + rViewThoiGianConLai.size.height + 8;
//    rViewMain.size.height = rViewNhapToken.origin.y + rViewNhapToken.size.height + 10;
//
//    if([self kiemTraCoChucNangQuetVanTay])
//    {
//        [self.mbtnVanTay setHidden:NO];
//        rBtnVanTay.origin.y = rViewMain.origin.y + rViewMain.size.height + 20;
//        float fHeight = rBtnVanTay.origin.y + rBtnVanTay.size.height + 10;
//        _mscvHienThi.contentSize = CGSizeMake(_mscvHienThi.frame.size.width, fHeight);
//    }
//    else
//    {
//        [self.mbtnVanTay setHidden:YES];
//        float fHeight = 2*rViewMain.origin.y + rViewMain.size.height;
//        _mscvHienThi.contentSize = CGSizeMake(_mscvHienThi.frame.size.width, fHeight);
//    }
//
//    _mViewThoiGianConLai.frame = rViewThoiGianConLai;
//    self.mViewNhapToken.frame = rViewNhapToken;
//    _mViewChuaNutXacNhan.frame = rViewChuaNutXacNhan;
//    _mViewChuaNoiDung.frame = rViewChuaNoiDung;
//    self.mbtnVanTay.frame = rBtnVanTay;
//    self.mViewMain.frame = rViewMain;
}

- (void)hideViewNhapToken {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//    });
}

#pragma mark - dealloc
- (void)dealloc
{
    if(_mViewChiTietMotGiaoDichTheoLo)
        [_mViewChiTietMotGiaoDichTheoLo release];
    [_mDoiTuongGiaoDich release];
    [_mViewThoiGianConLai release];
    [self.mViewNhapToken release];
    [_mViewChuaNutXacNhan release];
    [_mViewChuaNoiDung release];
    [_mwvHienThi release];
    [_mbtnDuyet release];
    [_mbtnHuy release];
    [_mtvNoiDung release];
//    if (_mscvHienThi) {
//        [_mscvHienThi release];
//    }
    [_mtbDsGiaoDich release];
    [_mViewTongSoTien release];
    [_mTongSoTien release];
    [_mlblTongSoPhi release];
    [_heightWebHienThi release];
    [_heightTableView release];
    [_heightViewNoiDung release];
    [_heightViewTongSoTien release];
    [super dealloc];
}
@end
