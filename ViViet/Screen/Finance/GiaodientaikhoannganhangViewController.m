

#import "GiaodientaikhoannganhangViewController.h"
#import "GiaoDienDanhSachTaiKhoanLienKet.h"
#import "ViewQuangCao.h"
@interface GiaodientaikhoannganhangViewController ()
{
    ViewQuangCao * viewQC;
    
    IBOutlet UIView *vMain;
}
@end

@implementation GiaodientaikhoannganhangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [dic setValue:tkLienket.sId forKey:@"id"];
    [dic setValue:tkLienket.idVi forKey:@"idVi"];
    [dic setValue:sBank forKey:@"maNganHang"];
    [dic setValue:self.edChuTK.text forKey:@"tenChuTaiKhoan"];
    [dic setValue:self.edSoTK.text forKey:@"soTaiKhoan"];
    [dic setValue:self.edTenDangNhap.text forKey:@"u"];
    [dic setValue:self.edMatKhau.text forKey:@"p"];

    
    [dic setValue:(isMacdinh ? @(1) : @(0)) forKey:@"danhDauTKMacDinh"];

    NSString *sMatKhau = self.txtOtp.text;
    sMatKhau = [DucNT_Token layMatKhauVanTayToken];
    
    NSString *sSeed = [DucNT_Token laySeedTokenHienTai];
    NSString *sToken = [DucNT_Token OTPFromPIN:sMatKhau seed:sSeed];

    [dic setValue:sToken forKey:@"token"];
    [dic setValue:[NSNumber numberWithInt:self.mTypeAuthenticate] forKey:@"typeAuthenticate"];
    [dic setValue:[NSNumber numberWithInt:APP_ID] forKey:@"appId"];
    [dic setValue:[NSNumber numberWithInt:VM_APP] forKey:@"VMApp"];
    [self edittaikhoanlienket:dic];
}
-(void)taotaikhoanlienket:(NSString*)sBank macdinh:(BOOL)isMacdinh{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP] forKey:@"idVi"];
    [dic setValue:sBank forKey:@"maNganHang"];
    [dic setValue:self.edChuTK.text forKey:@"tenChuTaiKhoan"];
    [dic setValue:self.edSoTK.text forKey:@"soTaiKhoan"];
    [dic setValue:self.edTenDangNhap.text forKey:@"u"];
    [dic setValue:self.edMatKhau.text forKey:@"p"];
    [dic setValue: (isMacdinh ? @(1) : @(0)) forKey:@"danhDauTKMacDinh"];
    NSString *sMatKhau = self.txtOtp.text;
    sMatKhau = [DucNT_Token layMatKhauVanTayToken];
    
    NSString *sSeed = [DucNT_Token laySeedTokenHienTai];
    NSString *sToken = [DucNT_Token OTPFromPIN:sMatKhau seed:sSeed];

    [dic setValue:sToken forKey:@"token"];
    [dic setValue:[NSNumber numberWithInt:self.mTypeAuthenticate] forKey:@"typeAuthenticate"];
    [dic setValue:[NSNumber numberWithInt:APP_ID] forKey:@"appId"];
    [dic setValue:[NSNumber numberWithInt:VM_APP] forKey:@"VMApp"];
    [self taotaikhoanlienket:dic];
}
- (void)dealloc {
    [vMain release];
    [super dealloc];
}
@end
