//
//  ThanhToanDienThoaiViettelViewController.m
//  ViViMASS
//
//  Created by DucBT on 3/23/15.
//
//

#import "ThanhToanDienThoaiViettelViewController.h"
#import "DoiTuongNotification.h"
#import "ContactScreen.h"
#import "GiaoDichMang.h"

@interface ThanhToanDienThoaiViettelViewController () <UITableViewDelegate, UITableViewDataSource>
{

    NSInteger mKieuThanhToan;
    int mThoiGianDoi;
    NSTimer *mTimer1;
}

@property (retain, nonatomic) DoiTuongNotification *mDoiTuongNotification;
@property (retain, nonatomic) IBOutlet UITableView *mtbKieuThanhToan;
@property (retain, nonatomic) NSArray *mDanhSachLuaChonThanhToan;
@property (retain, nonatomic) NSString *mSoDienThoaiDangTraCuuTraSau;
@end

@implementation ThanhToanDienThoaiViettelViewController


#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self khoiTaoBanDau];
    [self khoiTaoDanhSachLuaChonThanhToan];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - khoiTao

- (void)khoiTaoBanDau
{
    //Khoi tao tieu de
    [self addButtonBack];
//    self.title = [@"title_thanh_toan_viettel" localizableString];
    [self addTitleView:[@"title_thanh_toan_viettel" localizableString]];
    [self.mtfSoDienThoai setPlaceholder:[@"so_dien_thoai_dd" localizableString]];
    [self.mtfSoDienThoai setTextError:[@"so_dien_thoai_khong_dc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    self.mtfSoDienThoai.inputAccessoryView = nil;
    
    [self.mtfSoTien setTextError:[@"so_tien_khong_duoc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    [self.mtfSoTien setTextError:[@"so_tien_khong_hop_le" localizableString] forType:ExTextFieldTypeMoney];
    self.mtfSoTien.inputAccessoryView = nil;
    
    [self hienThiSoPhi];
    [self hienThiSoTienDuocKhuyenMai];
    
    self.mFuncID = FUNC_BILLING_CELLPHONE;
}

- (void)khoiTaoDanhSachLuaChonThanhToan
{
    _mtbKieuThanhToan.layer.borderWidth = 1.0f;
    _mtbKieuThanhToan.layer.borderColor = [UIColor blackColor].CGColor;
    self.mDanhSachLuaChonThanhToan = @[
                                       [@"thanh_toan_viettel_thanh_toan_di_dong_hoac_dcom_tra_truoc" localizableString],[@"thanh_toan_viettel_thanh_toan_di_dong_hoac_dcom_tra_sau" localizableString],
                                       [@"thanh_toan_viettel_thanh_toan_dien_thoai_co_dinh" localizableString],
                                       [@"thanh_toan_viettel_thanh_toan_homephone" localizableString],
                                       [@"thanh_toan_viettel_thanh_toan_truyen_hinh_va_internet" localizableString]
                                       ];
    
    if(!_mDoiTuongThanhToanCuocDienThoaiViettel)
        self.mtfTenLoaiThanhToan.text = [_mDanhSachLuaChonThanhToan objectAtIndex:0];
    else
    {
        self.mtfTenLoaiThanhToan.text = [_mDanhSachLuaChonThanhToan objectAtIndex:1];
        [self capNhatThongTinTraSau];
    }
    [self khoiTaoGiaoDienTheoKieuLuaChon];
    
    mKieuThanhToan = TRA_TRUOC;
    [self.mtbKieuThanhToan reloadData];
}

- (void)khoiTaoGiaoDienTheoKieuLuaChon
{
    NSString *sText = _mtfTenLoaiThanhToan.text;
    int nIndex = (int)[_mDanhSachLuaChonThanhToan indexOfObject:sText];
    switch (nIndex) {
        case 0:
            _mtfSoDienThoai.type = ExTextFieldTypePhone;
            [self khoiTaoGiaoDienKhac];
            break;
        case 1:
            _mtfSoDienThoai.type = ExTextFieldTypePhone;
            [self khoiTaoGiaoDienDiDongVaDcomTraSau];
            break;
        default:
            [self.mtfSoDienThoai setTextError:[@"so_dien_thoai_khong_dc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
            [self khoiTaoGiaoDienKhac];
            break;
    }
}

- (void)khoiTaoGiaoDienDiDongVaDcomTraSau
{
    CGRect rViewMain = self.mViewMain.frame;
    CGRect rViewSoDienThoai = _mViewSoDienThoai.frame;
    CGRect rViewThanhToan = _mViewThanhToan.frame;
    CGRect rButtonTraCuu = _mbtnTraCuu.frame;
    
    if(_mDoiTuongThanhToanCuocDienThoaiViettel)
    {
        rViewThanhToan.origin.y = rButtonTraCuu.origin.y;
        rViewMain.size.height = rViewThanhToan.origin.y + rViewThanhToan.size.height + 8;
        [_mViewThanhToan setHidden:NO];
        [_mbtnTraCuu setHidden:YES];
        
        if([self kiemTraCoChucNangQuetVanTay])
        {
            [self.mbtnVanTay setHidden:NO];
        }

    }
    else
    {
        rViewMain.size.height = rButtonTraCuu.origin.y + rButtonTraCuu.size.height + 8;
        [_mViewThanhToan setHidden:YES];
        [_mbtnTraCuu setHidden:NO];
        [self.mbtnVanTay setHidden:YES];
    }
    
    
    _mViewSoDienThoai.frame = rViewSoDienThoai;
    _mViewThanhToan.frame = rViewThanhToan;
    _mbtnTraCuu.frame = rButtonTraCuu;
    self.mViewMain.frame = rViewMain;
    _mtfSoTien.enabled = NO;
    
}

- (void)khoiTaoGiaoDienKhac
{
    CGRect rViewMain = self.mViewMain.frame;
    CGRect rViewSoDienThoai = _mViewSoDienThoai.frame;
    CGRect rViewThanhToan = _mViewThanhToan.frame;
    CGRect rButtonTraCuu = _mbtnTraCuu.frame;
    rViewThanhToan.origin.y = rButtonTraCuu.origin.y;
    rViewMain.size.height = rViewThanhToan.origin.y + rViewThanhToan.size.height + 8;
    [_mViewThanhToan setHidden:NO];
    [_mbtnTraCuu setHidden:YES];

    _mViewSoDienThoai.frame = rViewSoDienThoai;
    _mViewThanhToan.frame = rViewThanhToan;
    _mbtnTraCuu.frame = rButtonTraCuu;
    self.mViewMain.frame = rViewMain;
    _mtfSoTien.enabled = YES;
}

- (void)khoiTaoGiaTri
{
    [self.view endEditing:YES];
    self.mDoiTuongNotification = nil;
    self.mDoiTuongThanhToanCuocDienThoaiViettel = nil;
    [self.mtfSoTien setText:@""];
    [self.mtfSoDienThoai setText:@""];
    [self hienThiSoTienDuocKhuyenMai];
    [self hienThiSoPhi];
}

#pragma mark - overriden GiaoDienViewController

- (BOOL)validateVanTay
{
    NSArray *tfs = @[_mtfSoDienThoai, _mtfSoTien];
    ExTextField *first = nil;
    BOOL flg = YES;
    for (ExTextField *tf in tfs)
    {
        flg = [tf validate] && flg;
        if (flg == NO && first == nil)
            first = tf;
    }
    if (first)
    {
        [first show_error];
        return flg;
    }

    NSString *sText = _mtfTenLoaiThanhToan.text;
    int nIndex = (int)[_mDanhSachLuaChonThanhToan indexOfObject:sText];
    NSString *sSoDienThoai = _mtfSoDienThoai.text;
    switch (nIndex) {
        case 0:
        case 1:
            sSoDienThoai = [sSoDienThoai stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [_mtfSoDienThoai.text length])];
            if(![Common kiemTralaSoDienThoaiViettel:sSoDienThoai])
            {
                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:[NSString stringWithFormat:@"%@ %@",[@"qrcode_phone_empty" localizableString], [@"title_viettel" localizableString]]];
                return NO;
            }
        default:

            break;
    }

    
    return flg;
}

- (void)xuLyThucHienKhiKiemTraThanhCongTraVeToken:(NSString *)sToken otp:(NSString *)sOtp
{
    double fSoTien = [[[self.mtfSoTien.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
    self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_THANH_TOAN_CUOC;
    NSString *sText = _mtfTenLoaiThanhToan.text;
    int nIndex = (int)[_mDanhSachLuaChonThanhToan indexOfObject:sText];
    NSString *sSoDienThoai = _mtfSoDienThoai.text;
    switch (nIndex) {
        case 0:
        case 1:
            sSoDienThoai = [sSoDienThoai stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [_mtfSoDienThoai.text length])];
        default:
            break;
    }
    [GiaoDichMang ketNoiThanhToanCuocDienThoaiChoSo:sSoDienThoai
                                          maNhaMang:NHA_MANG_VIETTEL
                                      kieuThanhToan:(int)mKieuThanhToan
                                             soTien:fSoTien
                                              token:sToken
                                                otp:sOtp
                                   typeAuthenticate:self.mTypeAuthenticate
                                      noiNhanKetQua:self];
}

- (void)xuLyKetNoiThanhCong:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua
{
    if([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_THANH_TOAN_CUOC])
    {
        [self hienThiHopThoaiMotNutBamKieu:HOP_THOAI_XAC_NHAN_CHUYEN_TIEN_THANH_CONG cauThongBao:sThongBao];
    }
    else if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_TRA_CUU_THANH_TOAN_DIEN_THOAI_VIETTEL])
    {
        //Hien thi thong bao
        [self batDauDemThoiGian1];
    }
}

- (void)xuLyKetNoiThatBai:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua
{
    [super xuLyKetNoiThatBai:sDinhDanhKetNoi thongBao:sThongBao ketQua:ketQua];
}

#pragma mark - BaseScreen

-(void)didReceiveRemoteNotification:(NSDictionary *)Info
{
    NSDictionary *userInfo = [Info valueForKey:@"userInfo"];
    if(userInfo)
    {
        DoiTuongNotification *doiTuongNotification = [[DoiTuongNotification alloc] initWithDict:userInfo];
        if([doiTuongNotification.funcID intValue] == TYPE_SHOW_TRA_CUU_HOA_DON_DIEN && [doiTuongNotification. typeShow intValue] == KIEU_NOTIFICATION_TRA_CUU_HOA_DON_VIETTEL)
        {
            self.mDoiTuongNotification = doiTuongNotification;
            [doiTuongNotification release];
            
//            [self anViewThongBao];
//            [self ketThucDemThoiGian];
            [self hienThiThongTinThanhToan];
        }
    }
}


#pragma mark - suKien

- (IBAction)suKienThayDoiGiaTriSoDienThoai:(id)sender {
    NSString *sText = _mtfTenLoaiThanhToan.text;
    int nIndex = (int)[_mDanhSachLuaChonThanhToan indexOfObject:sText];
    if(nIndex == 1)
    {
        //Tra sau
        self.mDoiTuongThanhToanCuocDienThoaiViettel = nil;
        [self khoiTaoGiaoDienDiDongVaDcomTraSau];
    }
    
}

- (IBAction)suKienBamNutDanhBa:(id)sender
{
    ContactScreen *danhBa = [[[ContactScreen alloc] initWithNibName:@"ContactScreen" bundle:nil] autorelease];
    danhBa.mKieuHienThiLienHe = KIEU_HIEN_THI_LIEN_HE_THUONG;
    [self.navigationController pushViewController:danhBa animated:YES];
    __block ThanhToanDienThoaiViettelViewController *weakSelf = self;
    [danhBa selectContact:^(NSString *phone)
     {
         if (phone != nil && phone.length > 0)
         {
             if([Common kiemTraLaMail:phone])
             {
                 weakSelf.mtfSoDienThoai.text = phone;
             }
             else
             {
                 weakSelf.mtfSoDienThoai.text = [phone stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [phone length])];
             }
         }
         [danhBa.navigationController popViewControllerAnimated:YES];
     }];
}

- (IBAction)suKienBamNutChonKieuThanhToan:(id)sender
{
    if(_mtbKieuThanhToan.isHidden == YES)
    {
        [self hienTableLuaChonKieuThanhToan];
    }
    else
    {
        [self anTableLuaChonKieuThanhToan];
    }
    
}

- (IBAction)suKienThayDoiGiaTriTextFieldSoTien:(id)sender
{
    double fSoTien = [[[self.mtfSoTien.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
    if(fSoTien > 0)
        self.mtfSoTien.text = [Common hienThiTienTe:fSoTien];
    else
        self.mtfSoTien.text = @"";
    [self hienThiSoPhi];
    [self hienThiSoTienDuocKhuyenMai];
}

- (IBAction)suKienBamNutTraCuu:(id)sender
{
    if([_mtfSoDienThoai validate])
    {
        NSString *sSoDienThoai = [_mtfSoDienThoai.text stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [_mtfSoDienThoai.text length])];
        if(![sSoDienThoai isEqualToString:self.mSoDienThoaiDangTraCuuTraSau] || mThoiGianDoi == 0)
        {
            if([Common kiemTralaSoDienThoaiViettel:sSoDienThoai])
            {
                self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_TRA_CUU_THANH_TOAN_DIEN_THOAI_VIETTEL;
                self.mSoDienThoaiDangTraCuuTraSau = sSoDienThoai;
                [GiaoDichMang ketNoiTraCuuThanhToanDienThoaiViettel:sSoDienThoai noiNhanKetQua:self];
            }
            else
            {
                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:[NSString stringWithFormat:@"%@ %@",[@"qrcode_phone_empty" localizableString], [@"title_viettel" localizableString]]];
            }
        }
        else
        {
            [self hienThiViewThongBao];
        }
    }
    else
    {
        [_mtfSoDienThoai show_error];
    }
}

#pragma mark - xuLyTimer

- (void)batDauDemThoiGian1
{
    [self ketThucDemThoiGian1];
    mThoiGianDoi = 45;
    NSString *sCauThongBao = [NSString stringWithFormat:@"%@ %d s",[@"thong_bao_dang_tra_cuu_thong_tin_thanh_toan_viettel" localizableString], mThoiGianDoi];
    [_mtvHienThiThongBao setText:sCauThongBao];
    [self hienThiViewThongBao];
    self.mDoiTuongNotification = nil;
    mTimer1 = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(capNhatDemThoiGian1) userInfo:nil repeats:YES];
}

- (void)ketThucDemThoiGian1
{
    if(mTimer1)
    {
        [mTimer1 invalidate];
        mTimer1 = nil;
    }
}

- (void)capNhatDemThoiGian1
{
    mThoiGianDoi --;
    NSString *sCauThongBao = [NSString stringWithFormat:@"%@ %d s",[@"thong_bao_dang_tra_cuu_thong_tin_thanh_toan_viettel" localizableString], mThoiGianDoi];
    [_mtvHienThiThongBao setText:sCauThongBao];
    if(mThoiGianDoi == 0)
    {
        [self anViewThongBao];
        [self ketThucDemThoiGian1];
    }
}

#pragma mark - xuLy Touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    if(view == _mViewNenThongBao)
    {
        [self anViewThongBao];
    }
}


#pragma mark - xuly

- (void)capNhatThongTinTraSau
{
    if(_mDoiTuongThanhToanCuocDienThoaiViettel)
    {
        [_mtfSoDienThoai setText:_mDoiTuongThanhToanCuocDienThoaiViettel.soDienThoai];
        [_mtfSoTien setText:[Common hienThiTienTeFromString:_mDoiTuongThanhToanCuocDienThoaiViettel.tienCuocPhaiThanhToan]];
        _mtfSoTien.enabled = NO;
        [self hienThiSoPhi];
        [self hienThiSoTienDuocKhuyenMai];
    }
}

- (void)hienThiThongTinThanhToan
{
    NSString *idShow = _mDoiTuongNotification.idShow;
    if(idShow && ![idShow isEqualToString:@""])
    {
        if([idShow rangeOfString:self.mSoDienThoaiDangTraCuuTraSau].location != NSNotFound)
        {
            [self anViewThongBao];
            [self ketThucDemThoiGian1];
//            [self hienThiThongTinThanhToan];
            NSArray *arrTemp = [idShow componentsSeparatedByString:@"_"];
            @try {
                DoiTuongThanhToanCuocDienThoaiViettel *doiTuongThanhToanCuocDienThoaiViettel = [[DoiTuongThanhToanCuocDienThoaiViettel alloc] initWithMaGiaoDich:arrTemp[0] soDienThoai:arrTemp[1] tienCuocPhaiThanhToan:arrTemp[2]];
                self.mDoiTuongThanhToanCuocDienThoaiViettel = doiTuongThanhToanCuocDienThoaiViettel;
                [doiTuongThanhToanCuocDienThoaiViettel release];
                if([doiTuongThanhToanCuocDienThoaiViettel.tienCuocPhaiThanhToan doubleValue] > 0)
                {
                    [self khoiTaoGiaoDienDiDongVaDcomTraSau];
                    [self capNhatThongTinTraSau];
                }
                else
                {
                    [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:_mDoiTuongNotification.alertContent];
                }
            }
            @catch (NSException *exception) {
                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:_mDoiTuongNotification.alertContent];
            }
            @finally {
                
            }
        }
        else if([_mDoiTuongNotification.alertContent rangeOfString:self.mSoDienThoaiDangTraCuuTraSau].location != NSNotFound)
        {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:_mDoiTuongNotification.alertContent];
        }
    }
}

- (void)hienThiSoPhi
{
    double fSoTien = [[[self.mtfSoTien.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
    double fSoPhi = [Common layPhiChuyenTienCuaSoTien:fSoTien kieuChuyenTien:KIEU_CHUYEN_TIEN_NAP_THE_DIEN_THOAI maNganHang:@""];
    self.mtfSoPhi.text = [Common hienThiTienTe_1:fSoPhi];
}

- (void)hienThiSoTienDuocKhuyenMai
{
    NSString *sSoTienDuocKhuyenMai = @"";
    double fSoTien = [[[self.mtfSoTien.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
    double fSoTienDuocKhuyenMai = (fSoTien*5)/100;
    NSString *sPhanTramKhuyenMai = @"5 %";
    if(fSoTienDuocKhuyenMai > 0)
    {
        sSoTienDuocKhuyenMai = [Common hienThiTienTe_1:fSoTienDuocKhuyenMai];
    }
    else
    {
        sSoTienDuocKhuyenMai = sPhanTramKhuyenMai;
    }
    [self.mlblKhuyenMai setText:[NSString stringWithFormat:@"%@: %@",[@"khuyen_mai" localizableString], sSoTienDuocKhuyenMai]];
}

- (void)anTableLuaChonKieuThanhToan
{
    if(self.mtbKieuThanhToan.isHidden == NO)
    {
        self.mtbKieuThanhToan.hidden = YES;
    }
}

- (void)hienTableLuaChonKieuThanhToan
{
    if(self.mtbKieuThanhToan.isHidden == YES)
    {
        self.mtbKieuThanhToan.hidden = NO;
    }
}

- (void)hienThiViewThongBao
{
    if(!_mViewThongBao.superview)
    {
        _mViewThongBao.frame = self.view.bounds;
        [self.view addSubview:_mViewThongBao];
    }
    else
    {
        _mViewThongBao.frame = self.view.bounds;
        [self.view bringSubviewToFront:_mViewThongBao];
    }
    [self.view endEditing:YES];
    [_mViewThongBao setHidden:NO];
}

- (void)anViewThongBao
{
    if(_mViewThongBao.superview)
        _mViewThongBao.hidden = YES;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _mDanhSachLuaChonThanhToan.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellLuaChonThanhToanIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    NSString *sText = [_mDanhSachLuaChonThanhToan objectAtIndex:indexPath.row];
    cell.textLabel.text = sText;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self khoiTaoGiaTri];
    self.mtfTenLoaiThanhToan.text = [_mDanhSachLuaChonThanhToan objectAtIndex:indexPath.row];
    [self khoiTaoGiaoDienTheoKieuLuaChon];
    if(indexPath.row != 0 && indexPath.row != 1)
    {
        NSLog(@"%s - row : %ld", __FUNCTION__, (long)indexPath.row);
        mKieuThanhToan = TRA_SAU_HOAC_TRA_TRUOC_VIETNAMMOBILE_GMOBILE;
        if(indexPath.row == 3)
        {
            [self.mtfSoDienThoai setTextError:[@"ma_khach_hang_khong_duoc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
            self.mtfSoDienThoai.placeholder = [@"ma_khach_hang" localizableString];
        }
        else
        {
            [self.mtfSoDienThoai setPlaceholder:[@"so_dien_thoai_dd" localizableString]];
            [self.mtfSoDienThoai setTextError:[@"so_dien_thoai_khong_dc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
        }
    }
    else
    {
        [self.mtfSoDienThoai setPlaceholder:[@"so_dien_thoai_dd" localizableString]];
        [self.mtfSoDienThoai setTextError:[@"so_dien_thoai_khong_dc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
        mKieuThanhToan = TRA_TRUOC;
    }
    [self anTableLuaChonKieuThanhToan];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - dealloc

- (void)dealloc {
    if(_mDoiTuongThanhToanCuocDienThoaiViettel)
        [_mDoiTuongThanhToanCuocDienThoaiViettel release];
    if(_mDoiTuongNotification)
        [_mDoiTuongNotification release];
    [_mDanhSachLuaChonThanhToan release];
    [_mtfSoDienThoai release];
    [_mtfSoTien release];
    [_mtfSoPhi release];
    [_mlblKhuyenMai release];
    [_mtbKieuThanhToan release];
    [_mtfTenLoaiThanhToan release];
    [_mbtnTraCuu release];
    [_mViewThanhToan release];
    [_mViewSoDienThoai release];
    [_mViewThongBao release];
    [_mtvHienThiThongBao release];
    [_mViewNenThongBao release];
    [super dealloc];
}
@end
