//
//  MuonTienViewController.m
//  ViViMASS
//
//  Created by DucBT on 2/4/15.
//
//

#import "MuonTienViewController.h"
#import "DucNT_ServicePost.h"
#import "ContactScreen.h"
#import "GiaoDichMang.h"
#import "GiaoDienThongTinPhim.h"
#import "DucNT_DanhSachTaiKhoanThuongDungControllerViewController.h"
#import "DucNT_LoginSceen.h"

@interface MuonTienViewController () <DucNT_ServicePostDelegate> {
    ViewQuangCao *viewQC;
}

@end

@implementation MuonTienViewController

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self khoiTaoBanDau];
    [self khoiTaoGiaoDien];
    [self addButtonHuongDan];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateThongTinMuonTien:) name:KEY_TAI_KHOAN_THUONG_DUNG object:nil];
}

- (void)khoiTaoQuangCao {
    if (!viewQC) {
        viewQC = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ViewQuangCao class]) owner:self options:nil] objectAtIndex:0];
        viewQC.mDelegate = self;
        CGRect rectToken = self.mViewNhapToken.frame;
        CGRect rectQC = viewQC.frame;
        CGRect rectMain = self.mViewMain.frame;

        CGFloat fW = rectMain.size.width;
        CGFloat fH = rectQC.size.height * ((rectMain.size.width) / rectQC.size.width);
        rectQC.origin.y = rectToken.origin.y + rectToken.size.height + 10;
        viewQC.frame = CGRectMake(0, rectQC.origin.y, fW, fH);
        viewQC.mDelegate = self;
        [viewQC updateSizeQuangCao];
        rectMain.size.height = rectQC.origin.y + rectQC.size.height + 30;
        self.mViewMain.frame = rectMain;
        [self.mViewMain addSubview:viewQC];
        self.scrMain.contentSize = CGSizeMake(rectMain.size.width, rectMain.size.height + 10);
    }
}

-(void)updateThongTinMuonTien:(NSNotification *)notification {
    if([[notification name] isEqualToString:KEY_TAI_KHOAN_THUONG_DUNG])
    {
        DucNT_TaiKhoanThuongDungObject *temp = [notification object];
        _mtfTenTKCanMuonTien.text = temp.sToAccWallet;
        _mtfSoTien.text = [Common hienThiTienTe:temp.nAmount];
        _mtvNoiDung.text = temp.noiDung;
    }
}

- (void)suKienBamNutHuongDanGiaoDichViewController:(UIButton *)sender {
    GiaoDienThongTinPhim *vc = [[GiaoDienThongTinPhim alloc] initWithNibName:@"GiaoDienThongTinPhim" bundle:nil];
    vc.nOption = HUONG_DAN_MUON_TIEN;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view endEditing:YES];
    [self setAnimationChoSoTay:self.btnSoTay];
    [self khoiTaoQuangCao];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.btnSoTay.imageView stopAnimating];
}

#pragma mark - khoi Tao

- (void)khoiTaoBanDau
{
    [self addButtonBack];
    self.mFuncID = FUNC_MUON_TIEN;
//    self.navigationItem.title = [@"muon_tien" localizableString];
    [self addTitleView:[@"muon_tien" localizableString]];
}

- (void)khoiTaoGiaoDien
{
//    [self.mtfTenTKCanMuonTien setPlaceholder:[@"ten_tk_rut_tien" localizableString]];
    [self.mtfTenTKCanMuonTien setTextError:[@"ten_tk_rut_tien_khong_duoc_de_tong" localizableString] forType:ExTextFieldTypeEmpty];
    self.mtfTenTKCanMuonTien.inputAccessoryView = nil;
    
    [self.mtfSoTien setTextError:[@"so_tien_khong_duoc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    [self.mtfSoTien setTextError:[@"@so_tien_khong_hop_le" localizableString]forType:ExTextFieldTypeMoney];
    [self.mtfSoTien setText:@""];
    self.mtfSoTien.inputAccessoryView = nil;
    
    self.mtvNoiDung.inputAccessoryView = nil;
    
}

#pragma mark - handler error
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - suKien

- (IBAction)suKienBamNutDanhBa:(id)sender
{
    ContactScreen *danhBa = [[[ContactScreen alloc] initWithNibName:@"ContactScreen" bundle:nil] autorelease];
    danhBa.mKieuHienThiLienHe = KIEU_HIEN_THI_LIEN_HE_MUON_TIEN;
    [self.navigationController pushViewController:danhBa animated:YES];
    __block MuonTienViewController *weakSelf = self;
    [danhBa selectContact:^(NSString *phone)
     {
         if (phone != nil && phone.length > 0)
         {
             if([Common kiemTraLaMail:phone])
             {
                 weakSelf.mtfTenTKCanMuonTien.text = phone;
             }
             else
             {
                 weakSelf.mtfTenTKCanMuonTien.text = [phone stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [phone length])];
             }
         }
         
         [danhBa.navigationController popViewControllerAnimated:YES];
     }];
}

- (IBAction)suKienThayDoiSoTien:(id)sender
{
    NSString *sText = [Common hienThiTienTeFromString:[self.mtfSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""]];
    self.mtfSoTien.text = sText;
}


#pragma mark - overriden GiaoDichViewController

-(BOOL)validateVanTay
{
    NSArray *tfs = @[_mtfSoTien, _mtfTenTKCanMuonTien];
    ExTextField *first = nil;
    BOOL flg = YES;
    for (ExTextField *tf in tfs)
    {
        flg = [tf validate] && flg;
        if (flg == NO && first == nil)
            first = tf;
    }
    if (first)
        [first show_error];
    if (flg) {
        if ([Common kiemTraLaSoDienThoai:self.mtfTenTKCanMuonTien.text]) {
            flg = flg && YES;
        }
        else if ([Common kiemTraLaMail:self.mtfTenTKCanMuonTien.text]) {
            flg = flg && YES;
        }
        else {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Số ví mượn tiền không đúng"];
            return NO;
        }
    }
    double fSoTien = [[_mtfSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
    if(fSoTien < 10000 && fSoTien > 2000000000)
    {
        [UIAlertView alert:@"Số tiền phải từ 10.000 đến 2 tỷ đồng" withTitle:[@"thong_bao" localizableString] block:nil];
        return NO;
    }
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return NO;
    }
    return flg;
}

- (void)xuLyThucHienKhiKiemTraThanhCongTraVeToken:(NSString*)sToken otp:(NSString*)sOtp
{
    double fSoTien = [[self.mtfSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
    self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_MUON_TIEN;
    [GiaoDichMang ketNoiMuonTienTaiKhoan:self.mtfTenTKCanMuonTien.text noiDung:self.mtvNoiDung.text soTien:fSoTien token:sToken otp:sOtp typeAuthenticate:self.mTypeAuthenticate noiNhanKetQua:self];
}

- (void)xuLyKetNoiThanhCong:(NSString*)sDinhDanhKetNoi thongBao:(NSString*)sThongBao ketQua:(id)ketQua
{
    if([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_MUON_TIEN])
    {
        [self hienThiHopThoaiMotNutBamKieu:HOP_THOAI_XAC_NHAN_CHUYEN_TIEN_THANH_CONG cauThongBao:sThongBao];
    }
}

- (IBAction)suKienClickSoTayMuonTien:(id)sender {
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return;
    }
    DucNT_DanhSachTaiKhoanThuongDungControllerViewController *vc = [[DucNT_DanhSachTaiKhoanThuongDungControllerViewController alloc] initWithType:TAI_KHOAN_MUON_TIEN];
    [self.navigationController presentViewController:vc animated:YES completion:^{}];
    [vc release];
}

#pragma mark - dealloc
- (void)dealloc
{
    [_mtfSoTien release];
    [_mtfTenTKCanMuonTien release];
    [_mtvNoiDung release];
    [_scrMain release];
    [super dealloc];
}

@end
