

#import "GiaodientaikhoantheViewController.h"
#import "GiaoDienDanhSachTaiKhoanLienKet.h"
#import "ViewQuangCao.h"
@interface GiaodientaikhoantheViewController ()
{
    ViewQuangCao * viewQC;
    IBOutlet UIImageView *imgQC;
    IBOutlet UIView *vMain;

}
@end

@implementation GiaodientaikhoantheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.edSoThe addTarget:self action:@selector(soTheDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.edNgayMoThe addTarget:self action:@selector(thoiDiemMoTheDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.edNamMoThe addTarget:self action:@selector(thoiDiemMoTheDidChange:) forControlEvents:UIControlEventEditingChanged];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self khoiTaoQuangCao];
}
- (void)khoiTaoQuangCao {
    if (!viewQC) {
        NSLog(@"%s - [UIScreen mainScreen].bounds.size.height : %f", __FUNCTION__, [UIScreen mainScreen].bounds.size.height);
        viewQC = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ViewQuangCao class]) owner:self options:nil] objectAtIndex:0];
        CGRect rectQC = imgQC.frame;
        viewQC.mDelegate = self;
        viewQC.frame = rectQC;
        [vMain addSubview:viewQC];
        [viewQC updateSizeQuangCao];
    }
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
-(void)taikhoanLienket:(ItemTaiKhoanLienKet*)tkLienket {
    _edSoThe.text = tkLienket.soThe;
    if (tkLienket.cardMonth > 0) {
        if (tkLienket.cardMonth < 10) {
            _edNgayMoThe.text = [NSString stringWithFormat:@"0%d", tkLienket.cardMonth];
        }
        else {
            _edNgayMoThe.text = [NSString stringWithFormat:@"%d", tkLienket.cardMonth];
        }
    }
    else {
        _edNgayMoThe.text = @"";
    }
    if (tkLienket.cardYear > 0) {
        if (tkLienket.cardYear < 10) {
            _edNamMoThe.text = [NSString stringWithFormat:@"0%d", tkLienket.cardYear];
        }
        else {
            _edNamMoThe.text = [NSString stringWithFormat:@"%d", tkLienket.cardYear];
        }
    }
    else {
        _edNamMoThe.text = @"";
    }
}
-(void)suataikhoanlienket:(ItemTaiKhoanLienKet*)tkLienket sbank:(NSString*)sBank macdinh:(BOOL)isMacdinh{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:tkLienket.sId forKey:@"id"];
    [dic setValue:tkLienket.idVi forKey:@"idVi"];
    [dic setValue:sBank forKey:@"maNganHang"];
    [dic setValue:[NSNumber numberWithBool:isMacdinh] forKey:@"danhDauTheMacDinh"];
    [dic setValue:self.edSoThe.text forKey:@"soThe"];
    int cardMonth = 0;
    if (![self.edNgayMoThe.text isEmpty]) {
        cardMonth = [self.edNgayMoThe.text intValue];
    }
    
    int cardYear = 0;
    if (![self.edNamMoThe.text isEmpty]) {
        cardYear = [self.edNamMoThe.text intValue];
    }
    [dic setValue:[NSNumber numberWithInt:cardMonth] forKey:@"cardMonth"];
    [dic setValue:[NSNumber numberWithInt:cardYear] forKey:@"cardYear"];
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
    [dic setValue:[NSNumber numberWithBool:isMacdinh] forKey:@"danhDauTheMacDinh"];
    
    [dic setValue:self.edSoThe.text forKey:@"soThe"];
    int cardMonth = 0;
    if (![self.edNgayMoThe.text isEmpty]) {
        cardMonth = [self.edNgayMoThe.text intValue];
    }
    
    int cardYear = 0;
    if (![self.edNamMoThe.text isEmpty]) {
        cardYear = [self.edNamMoThe.text intValue];
    }
    [dic setValue:[NSNumber numberWithInt:cardMonth] forKey:@"cardMonth"];
    [dic setValue:[NSNumber numberWithInt:cardYear] forKey:@"cardYear"];
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
@end
