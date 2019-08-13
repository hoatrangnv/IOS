//
//  DanhSachTaiKhoanThuongDungViewController.m
//  ViViMASS
//
//  Created by DucBT on 1/28/15.
//
//

#import "DanhSachTaiKhoanThuongDungViewController.h"
#import "ThemTaiKhoanThuongDungViewController.h"
#import "DucNT_TaiKhoanThuongDungObject.h"
#import "DucNT_TaiKhoanThuongDungCell.h"
#import "FixIOS7StatusBarRootView.h"
#import "Ducnt_ServicePost.h"
#import "HiNavigationBar.h"
#import "GiaoDichMang.h"
#import "ViewXacThuc.h"

@interface DanhSachTaiKhoanThuongDungViewController () <UITableViewDataSource, UITableViewDelegate, DucNT_ServicePostDelegate, ViewXacThucDelegate, UIAlertViewDelegate, ThemTaiKhoanThuongDungViewControllerDelegate>
{
    NSString *mDinhDanhKetNoi;
    int mViTriTaiKhoanCanXoa;
}

@property (retain, nonatomic) ViewXacThuc *mViewXacThuc;
@property (retain, nonatomic) NSArray *mDanhSachTaiKhoanThuongDung;
@property (retain, nonatomic) IBOutlet UILabel *mlblTitle;
@property (retain, nonatomic) IBOutlet UITableView *mtbHienThi;
@property (retain, nonatomic) IBOutlet FixIOS7StatusBarRootView *mRootView;
@end

@implementation DanhSachTaiKhoanThuongDungViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        _mKieuChucNang = CHUC_NANG_CHINH_SUA;
        _mKieuHienThiDanhSachTaiKhoan = TAI_KHOAN_TONG_HOP;
    }
    return self;
}

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self khoiTaoBanDau];
    [self xuLyKetNoiLayDanhSachTaiKhoanThuongDung];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self khoiTaoViewXacThuc];
}

-(void)viewDidLayoutSubviews
{
    [_mRootView fix];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mtbHienThi setEditing:NO];
}

#pragma mark - handler error
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - khoi Tao

- (void)khoiTaoBanDau
{
    [self.mlblTitle setText:[@"title_tai_khoan_thuong_dung" localizableString]];
}

- (void)khoiTaoViewXacThuc
{
    if(!_mViewXacThuc)
    {
        self.mViewXacThuc = [[[NSBundle mainBundle] loadNibNamed:@"ViewXacThuc" owner:self options:nil] objectAtIndex:0];
        self.mViewXacThuc.mDelegate = self;
        self.mViewXacThuc.mThongTinVi = self.mThongTinTaiKhoanVi;
        self.mViewXacThuc.frame = self.view.bounds;
        
        if([self kiemTraCoChucNangQuetVanTay])
        {
            [self xuLyKhiCoChucNangQuetVanTay];
        }
        else
        {
            [self xuLyKhiKhongCoChucNangQuetVanTay];
        }
    }
    
}


#pragma mark - suKien

- (IBAction)suKienBamNutThemTaiKhoanThuongDung:(id)sender
{
    ThemTaiKhoanThuongDungViewController *themTaiKhoanThuongDung = [[ThemTaiKhoanThuongDungViewController alloc] initWithNibName:@"ThemTaiKhoanThuongDungViewController" bundle:nil];
    themTaiKhoanThuongDung.mDelegate = self;
    UINavigationController *nav = [HiNavigationBar navigationControllerWithRootViewController: themTaiKhoanThuongDung];
    [themTaiKhoanThuongDung release];
    nav.navigationBar.barStyle = UIBarStyleBlackOpaque;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self presentViewController:nav animated:YES completion:^{}];
}

- (IBAction)suKienBamNutBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - xu Ly view xac thuc

- (void)anViewXacThuc
{
    if(_mViewXacThuc.superview)
    {
        [_mViewXacThuc removeFromSuperview];
    }
}

- (void)hienThiViewXacThuc
{
    if(!_mViewXacThuc.superview)
        [self.view addSubview:_mViewXacThuc];
}


#pragma mark - xu ly

- (void)xuLyLayDanhSachTaiKhoanThuongDungThanhCong:(NSArray*)dsTaiKhoan
{
    if(dsTaiKhoan.count > 0)
    {
        NSMutableArray *arrTemp = [[NSMutableArray alloc] initWithCapacity:dsTaiKhoan.count];
        for(int i = 0; i < dsTaiKhoan.count; i++)
        {
            NSDictionary *itemDs = [dsTaiKhoan objectAtIndex:i];
            DucNT_TaiKhoanThuongDungObject *obj = [[DucNT_TaiKhoanThuongDungObject alloc] init];
            obj.sId = [itemDs objectForKey:@"id"];
            obj.sPhoneOwner = [itemDs objectForKey:@"phoneOwner"];
            obj.nType = [[itemDs objectForKey:@"type"] intValue];
            obj.sAliasName = [Common URLDecode:[itemDs objectForKey:@"aliasName"]];
            obj.nAmount = [[itemDs objectForKey:@"amount"] doubleValue];
            obj.sDesc = [Common URLDecode:[itemDs objectForKey:@"desc"]];
            obj.sToAccWallet = [itemDs objectForKey:@"toAccWallet"];
            obj.sAccOwnerName = [itemDs objectForKey:@"AccOwnerName"];
            obj.sBankName = [Common URLDecode:[itemDs objectForKey:@"bankName"]];
            obj.sBankNumber = [itemDs objectForKey:@"BankNumber"];
            obj.sProvinceName = [Common URLDecode:[itemDs objectForKey:@"provinceName"]];
            obj.nProvinceCode = [[itemDs objectForKey:@"provinceCode"] intValue];
            obj.nProvinceID = [[itemDs objectForKey:@"provinceId"]intValue];
            obj.nBankCode = [[itemDs objectForKey:@"bankCode"] intValue];
            obj.nBankId = [[itemDs objectForKey:@"bankId"] intValue];
            obj.nBranchId = [[itemDs objectForKey:@"branchId"] intValue];
            obj.sBranchName = [Common URLDecode:[itemDs objectForKey:@"branchName"]];
            obj.sBranchCode = [itemDs objectForKey:@"branchCode"];
//            obj.nCardId = [[itemDs objectForKey:@"cardId"] intValue];
            obj.nDateExp = [[itemDs objectForKey:@"dateExp"] longLongValue];
            obj.nDateReg = [[itemDs objectForKey:@"dateReg"] longLongValue];
            obj.sCardNumber = [itemDs objectForKey:@"cardNumber"];
            obj.sCardOwnerName = [itemDs objectForKey:@"cardOwnerName"];
            obj.sCardTypeName = [itemDs objectForKey:@"cardTypeName"];
            obj.tenNguoiThuHuong = [itemDs objectForKey:@"tenNguoiThuHuong"];
            obj.cellphoneNumber = [itemDs objectForKey:@"cellphoneNumber"];
            obj.cmnd = [itemDs objectForKey:@"cmnd"];
            obj.tinhThanh = [itemDs objectForKey:@"tinhThanh"];
            obj.quanHuyen = [itemDs objectForKey:@"quanHuyen"];
            obj.phuongXa = [itemDs objectForKey:@"phuongXa"];
            obj.diaChi = [itemDs objectForKey:@"diaChi"];
            obj.noiDung = [itemDs objectForKey:@"noiDung"];
            obj.soTien = [[itemDs objectForKey:@"soTien"] intValue];
            
            if(self.mKieuHienThiDanhSachTaiKhoan == TAI_KHOAN_TONG_HOP)
            {
                if(obj.nType != TAI_KHOAN_THE_RUT_TIEN)
                {
                    [arrTemp addObject:obj];
                }
            }
            else if(self.mKieuHienThiDanhSachTaiKhoan == TAI_KHOAN_NGAN_HANG_RUT_TIEN)
            {
                if(obj.nType == TAI_KHOAN_NGAN_HANG_RUT_TIEN)
                {
                    [arrTemp addObject:obj];
                }
            }
            else if(self.mKieuHienThiDanhSachTaiKhoan == TAI_KHOAN_VI)
            {
                if(obj.nType == TAI_KHOAN_VI)
                {
                    [arrTemp addObject:obj];
                }
            }
            else if(self.mKieuHienThiDanhSachTaiKhoan == TAI_KHOAN_THE)
            {
                if(obj.nType == TAI_KHOAN_THE)
                {
                    [arrTemp addObject:obj];
                }
            }
            else if(self.mKieuHienThiDanhSachTaiKhoan == TAI_KHOAN_NGAN_HANG)
            {
                if(obj.nType == TAI_KHOAN_NGAN_HANG)
                {
                    [arrTemp addObject:obj];
                }
            }
            else if (self.mKieuHienThiDanhSachTaiKhoan == TAI_KHOAN_TAN_NHA){
                if(obj.nType == TAI_KHOAN_TAN_NHA){
                    [arrTemp addObject:obj];
                }
            }
            [obj release];
        }
//        self.mDanhSachTaiKhoanThuongDung = arrTemp;
        self.mDanhSachTaiKhoanThuongDung = [[NSArray alloc] initWithArray:arrTemp];
        [arrTemp release];
        [self.mtbHienThi reloadData];
    }
}

- (void)xuLyXoaTaiKhoanThuongDungThanhCong
{
    [self anViewXacThuc];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:_mDanhSachTaiKhoanThuongDung];
    [arr removeObjectAtIndex:mViTriTaiKhoanCanXoa];
    mViTriTaiKhoanCanXoa = -1;
    self.mDanhSachTaiKhoanThuongDung = arr;
    [self.mtbHienThi reloadData];
}

#pragma mark - xu ly ket noi

- (void)xuLyKetNoiLayDanhSachTaiKhoanThuongDung
{
    [self showLoadingScreen];
    mDinhDanhKetNoi = DINH_DANH_KET_NOI_LAY_TAI_KHOAN_THUONG_DUNG;
    [GiaoDichMang ketNoiLayDanhSachTaiKhoanThuongDung:TAI_KHOAN_TONG_HOP noiNhanKetQua:self];
}

-(void)xuLyKetNoiXoaTaiKhoanThuongDung:(NSString *)sId withType:(int) nType typeAuthenticate:(NSInteger)nTypeAuthenticate token:(NSString*)sToken otp:(NSString*)sOtp
{
    [self showLoadingScreen];
    mDinhDanhKetNoi = DINH_DANH_KET_NOI_XOA_TAI_KHOAN_THUONG_DUNG;
    [GiaoDichMang ketNoiXoaTaiKhoanThuongDung:sId kieuLay:nType token:sToken otp:sOtp typeAuthenticate:(int)nTypeAuthenticate noiNhanKetQua:self];
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_mDanhSachTaiKhoanThuongDung)
        return _mDanhSachTaiKhoanThuongDung.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellTaiKhoanThuongDungIdentifier = @"cellTaiKhoanThuongDungIdentifier";
    
    
    DucNT_TaiKhoanThuongDungCell *cell = [tableView dequeueReusableCellWithIdentifier:cellTaiKhoanThuongDungIdentifier];
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DucNT_TaiKhoanThuongDungCell" owner:self options:nil] objectAtIndex:0];
    }
    DucNT_TaiKhoanThuongDungObject *item = [_mDanhSachTaiKhoanThuongDung objectAtIndex:indexPath.row];
    
    cell.lbTenTaoKhoan.text = item.sAliasName;
    cell.lbTenTaoKhoan.textColor = [UIColor blackColor];
    int n = item.nType;
    UIImage *image = [UIImage imageNamed:@"ck-vi-vi.png"];
    if(n == TAI_KHOAN_VI)
    {
        image = [UIImage imageNamed:@"icon-vivimass64x64"];
        if([item.sToAccWallet hasPrefix:@"fb"])
        {
            image = [UIImage imageNamed:@"icon-vifb64x64"];
        }
        else if([item.sToAccWallet hasPrefix:@"gg"])
        {
            image = [UIImage imageNamed:@"icon-vigg64x64"];
        }
    }
    else if(n == TAI_KHOAN_THE)
    {
        image = [UIImage imageNamed:@"icon-the64x64"];
    }
    else if(n == TAI_KHOAN_NGAN_HANG)
    {
        image = [UIImage imageNamed:@"icon-taikhoan64x64"];
    }
    else if(n == TAI_KHOAN_THE_RUT_TIEN)
    {
        image = [UIImage imageNamed:@"icon-theruttien64x64"];
    }
    else if(n == TAI_KHOAN_NGAN_HANG_RUT_TIEN)
    {
        image = [UIImage imageNamed:@"icon-taikhoanrutien64x64"];
    }
    else if(n == TAI_KHOAN_MOMO)
    {
        image = [UIImage imageNamed:@"momo64"];
    }
    else if (n == TAI_KHOAN_TAN_NHA){
        image = [UIImage imageNamed:@"icon-tannha64x64"];
    }
    
    [cell.imvLoaiTaiKhoan setImage:image];
    
    [cell.btnDelete setHidden:YES];
    [cell.btnEdit setHidden:YES];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        mViTriTaiKhoanCanXoa = (int)indexPath.row;
//        [self hienThiHopThoaiHaiNutBamKieu:HOP_THOAI_XAC_NHAN_VIEC_XOA cauThongBao:[@"thong_bao_xac_nhan_xoa_tai_khoan_thuong_dung" localizableString]];
        mDinhDanhKetNoi = DINH_DANH_KET_NOI_XOA_TAI_KHOAN_THUONG_DUNG;
        [self hienThiViewXacThuc];
        
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DucNT_TaiKhoanThuongDungObject *item = [_mDanhSachTaiKhoanThuongDung objectAtIndex:indexPath.row];
    NSLog(@"DanhSachTaiKhoanThuongDung : didSelectRow : mKieuChucNang : %ld", (long)self.mKieuChucNang);
    NSLog(@"DanhSachTaiKhoanThuongDung : didSelectRow : tenThuHuong : %@", item.tenNguoiThuHuong);
    if(self.mKieuChucNang == CHUC_NANG_CHINH_SUA)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];

        ThemTaiKhoanThuongDungViewController *themTaiKhoanThuongDung = [[ThemTaiKhoanThuongDungViewController alloc] initWithNibName:@"ThemTaiKhoanThuongDungViewController" bundle:nil];
        themTaiKhoanThuongDung.mDelegate = self;
        themTaiKhoanThuongDung.mTaiKhoanThuongDung = item;
        UINavigationController *nav = [HiNavigationBar navigationControllerWithRootViewController: themTaiKhoanThuongDung];
        nav.navigationBar.barStyle = UIBarStyleBlackOpaque;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        [self presentViewController:nav animated:YES completion:^{}];
        [themTaiKhoanThuongDung release];
    }
    else if (self.mKieuChucNang == CHUC_NANG_CHON)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LAY_TAI_KHOAN_THUONG_DUNG object:item];
        [self suKienBamNutBack:nil];
    }
}

#pragma mark - ViewXacThucDelegate

- (void)xuLySuKienXacThucVoiKieu:(NSInteger)nKieuXacThuc token:(NSString*)sToken otp:(NSString*)sOtp
{
    if([mDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_XOA_TAI_KHOAN_THUONG_DUNG])
    {
        if(mViTriTaiKhoanCanXoa > -1)
        {
            DucNT_TaiKhoanThuongDungObject *objTemp = [_mDanhSachTaiKhoanThuongDung objectAtIndex:mViTriTaiKhoanCanXoa];
            [self xuLyKetNoiXoaTaiKhoanThuongDung:objTemp.sId withType:objTemp.nType typeAuthenticate:nKieuXacThuc token:sToken otp:sOtp];
        }
    }
}

- (void)xuLySuKienBamNutVanTay
{
    [self xuLySuKienDangNhapVanTay];
}

#pragma mark - xuLySuKienVanTay

- (void)xuLyKhiKhongCoChucNangQuetVanTay
{
    if(_mViewXacThuc)
        [_mViewXacThuc.mbtnVanTay setHidden:YES];
}

- (void)xuLyKhiCoChucNangQuetVanTay
{
    if(_mViewXacThuc)
        [_mViewXacThuc.mbtnVanTay setHidden:NO];
}

- (void)xuLySuKienDangNhapVanTay
{
    [self xuLySuKienHienThiChucNangVanTayVoiTieuDe:[@"su_dung_van_tay_dang_nhap_tai_khoan_token_VIMASS" localizableString]];
}

- (void)xuLySuKienXacThucVanTayThanhCong
{
    [_mViewXacThuc xuLyKhiXacThucVanTayThanhCong];
}

- (void)hienThiThongBaoDienMatKhau
{
    [UIAlertView alert:[@"thong_bao_xac_thuc_van_tay_khong_dung" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
    if(_mViewXacThuc)
        [_mViewXacThuc.mbtnVanTay setHidden:NO];
}


#pragma mark - ThemTaiKhoanThuongDungViewControllerDelegate

- (void)xuLySuKienThem_CapNhatTaiKhoanThuongDungThanhCong
{
    [self xuLyKetNoiLayDanhSachTaiKhoanThuongDung];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == HOP_THOAI_XAC_NHAN_VIEC_XOA)
    {
        if(buttonIndex == 1)
        {

            [self hienThiViewXacThuc];
        }
        else if(buttonIndex == 0)
        {
            mViTriTaiKhoanCanXoa = -1;
        }
    }
    else if (alertView.tag == HOP_THOAI_XAC_NHAN_CHUYEN_TIEN_THANH_CONG)
    {
        if(buttonIndex == 0)
        {
            [self xuLyXoaTaiKhoanThuongDungThanhCong];
        }
    }
}

#pragma mark - DucNT_ServicePostDelegate

-(void)ketNoiThanhCong:(NSString *)sKetQua
{
    [self hideLoadingScreen];
    NSDictionary *dic = [[[[sKetQua stringByReplacingOccurrencesOfString:@"\\" withString:@""] stringByReplacingOccurrencesOfString:@"\"{" withString:@"{"] stringByReplacingOccurrencesOfString:@"}\"" withString:@"}"] objectFromJSONString];
    NSLog(@"%s - dic : %@", __FUNCTION__, dic);
    int nCode = [[dic objectForKey:@"msgCode"] intValue];
    NSString *sMessage = [dic objectForKey:@"msgContent"];
    if(nCode == 1)
    {
        if([mDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_LAY_TAI_KHOAN_THUONG_DUNG])
        {
            NSDictionary *dic2 = [dic objectForKey:@"result"];
            NSArray *dsTaiKhoan = [dic2 objectForKey:@"list"];
            [self xuLyLayDanhSachTaiKhoanThuongDungThanhCong:dsTaiKhoan];
        }
        else if ([mDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_XOA_TAI_KHOAN_THUONG_DUNG])
        {
            [self hienThiHopThoaiMotNutBamKieu:HOP_THOAI_XAC_NHAN_CHUYEN_TIEN_THANH_CONG cauThongBao:sMessage];
        }
    }
    else
    {
        [UIAlertView alert:sMessage withTitle:[@"thong_bao" localizableString] block:nil];
    }
}

- (void)xuLyKetNoiThatBai:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua{
    [self hideLoadingScreen];
}

#pragma mark - dealloc
- (void)dealloc
{
    if(_mViewXacThuc)
        [_mViewXacThuc release];
    [_mtbHienThi release];
    [_mlblTitle release];
    [_mRootView release];
    [super dealloc];
}
@end
