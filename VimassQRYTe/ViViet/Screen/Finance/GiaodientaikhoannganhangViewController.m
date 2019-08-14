

#import "GiaodientaikhoannganhangViewController.h"
#import "GiaoDienDanhSachTaiKhoanLienKet.h"
#import "ViewQuangCao.h"
#import "CommonUtils.h"

@interface GiaodientaikhoannganhangViewController ()
{
    ViewQuangCao * viewQC;
    
    IBOutlet UIView *vMain;
}
@end

@implementation GiaodientaikhoannganhangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edChuTK.placeholder = [@"register_account_link_account_holders" localizableString];
    self.edSoTK.placeholder = [@"transfer_tobank_hint_bankaccount" localizableString];
    self.edTenDangNhap.placeholder = [@"ten_dang_nhap_ibanking" localizableString];
    self.edMatKhau.placeholder = [@"matkhau_dang_nhap_ibanking" localizableString];
    self.lblUuTien.text = [@"uu_tien_su_dung" localizableString];
    self.lbl6KyTu1.text = [@"6_ky_tu" localizableString];
    self.lbl6KyTu.text = [@"6_ky_tu" localizableString];
    self.lblMacDinh.text = [@"mac_dinh" localizableString];
    [self.btnThucHien setTitle:[@"button_thuc_hien" localizableString] forState:UIControlStateNormal];
    [self.edTenDangNhap addTarget:self action:@selector(tenDangNhapDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.edMatKhau addTarget:self action:@selector(matKhauDidChange:) forControlEvents:UIControlEventEditingChanged];

    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)suKienChonQuangCao:(NSString *)sNameImage {
    [self suKienQuangCaoGoc:sNameImage];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)tenDangNhapDidChange:(UITextField *)tf {
}

- (void)matKhauDidChange:(UITextField *)tf {
}
-(void)taikhoanLienket:(ItemTaiKhoanLienKet*)tkLienket {
    _edSoTK.text = tkLienket.soTaiKhoan;
    _edTenDangNhap.text = tkLienket.u;
    _edMatKhau.text = tkLienket.p;
}
#pragma mark - data

- (void)suataikhoanlienket:(ItemTaiKhoanLienKet*)tkLienket sbank:(NSString*)sBank macdinh:(BOOL)isMacdinh {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSString *sMatKhau = self.txtOtp.text;
    sMatKhau = [DucNT_Token layMatKhauVanTayToken];
    
    NSString *sSeed = [DucNT_Token laySeedTokenHienTai];
    NSString *sToken = [DucNT_Token OTPFromPIN:sMatKhau seed:sSeed];

    [dic setValue:tkLienket.sId forKey:@"id"];
    [dic setValue:tkLienket.idVi forKey:@"idVi"];
    [dic setValue:(isMacdinh ? @1 : @0) forKey:@"tkMacDinh"];

    [dic setValue:sToken forKey:@"token"];
    [dic setValue:@"" forKey:@"otpConfirm"];
    [dic setValue:[NSNumber numberWithInt:0] forKey:@"typeAuthenticate"];
    [dic setValue:[NSNumber numberWithInt:APP_ID] forKey:@"appId"];
    [dic setValue:[NSNumber numberWithInt:VM_APP] forKey:@"VMApp"];
    
    [self edittaikhoanlienket:dic];
}
-(void)taotaikhoanlienket:(NSString*)sBank macdinh:(BOOL)isMacdinh{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSString *sMatKhau = self.txtOtp.text;
    sMatKhau = [DucNT_Token layMatKhauVanTayToken];
    
    NSString *sSeed = [DucNT_Token laySeedTokenHienTai];
    NSString *sToken = [DucNT_Token OTPFromPIN:sMatKhau seed:sSeed];
    if([CommonUtils isEmptyOrNull:sToken])
    {
        [[[[UIAlertView alloc] initWithTitle:[@"thong_bao" localizableString]  message:[@"can_tao_token" localizableString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
        return;
    }

    [dic setValue:sToken forKey:@"token"];
    [dic setValue:@"" forKey:@"otpConfirm"];
    [dic setValue:[NSNumber numberWithInt:TYPE_AUTHENTICATE_TOKEN] forKey:@"typeAuthenticate"];
    [dic setValue:[NSNumber numberWithInt:APP_ID] forKey:@"appId"];
    [dic setValue:[NSNumber numberWithInt:VM_APP] forKey:@"VMApp"];
    [dic setValue:[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP] forKey:@"idVi"];
    
    [dic setValue:sBank forKey:@"maNganHang"];
    [dic setValue:self.edChuTK.text forKey:@"tenChuTaiKhoan"];
    [dic setValue:self.edSoTK.text forKey:@"soTaiKhoan"];
    [dic setValue:(isMacdinh ? @1 : @0) forKey:@"tkMacDinh"];
    
    [dic setValue:self.edTenDangNhap.text forKey:@"u"];
    [dic setValue:self.edMatKhau.text forKey:@"p"];
    [dic setValue:[NSNumber numberWithInt:self.mTypeAuthenticate] forKey:@"kieuXacThuc"];
    [self taotaikhoanlienket:dic];
}
- (void)dealloc {
    [vMain release];
    [_lblUuTien release];
    [_lblMacDinh release];
    [_lbl6KyTu release];
    [super dealloc];
}
@end
