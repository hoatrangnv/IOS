

#import "GiaodientaikhoantheViewController.h"
#import "GiaoDienDanhSachTaiKhoanLienKet.h"
#import "ViewQuangCao.h"
#import "CommonUtils.h"

@interface GiaodientaikhoantheViewController ()
{
    ViewQuangCao * viewQC;
    IBOutlet UIView *vMain;
    IBOutlet NSLayoutConstraint *contraintHeightCvv;
    IBOutlet ExTextField *txtCvv;
    NSInteger year;
}
@end

@implementation GiaodientaikhoantheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.edSoThe addTarget:self action:@selector(soTheDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.edNgayMoThe addTarget:self action:@selector(thoiDiemMoTheDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.edNamMoThe addTarget:self action:@selector(thoiDiemMoTheDidChange:) forControlEvents:UIControlEventEditingChanged];
    [txtCvv addTarget:self action:@selector(cvvDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self showCvvField:@""];
    NSCalendar * calendar = [NSCalendar currentCalendar];
    year = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];

    // Do any additional setup after loading the view from its nib.
}
- (void)soTheDidChange:(UITextField *)tf {
}
- (void)thoiDiemMoTheDidChange:(UITextField *)tf {
    if (tf.text.length >= 2) {
        tf.text = [tf.text substringToIndex:2];
        if (tf == _edNgayMoThe) {
            if (tf.text.integerValue > 12 || tf.text.integerValue == 0) {
                tf.text = @"";
            }
        } else {
            NSInteger temp = year % 100;
            
            if ([self.edBank.text.lowercaseString isEqualToString:@"Visa".lowercaseString] || [self.edBank.text.lowercaseString isEqualToString:@"MasterCard".lowercaseString] || [self.edBank.text.lowercaseString isEqualToString:@"JCB".lowercaseString]) {
                if (((tf.text.integerValue - temp) > 5) || ((tf.text.integerValue - temp) < 0)) {
                    tf.text = @"";
                }

            } else {
                if (((tf.text.integerValue - temp) > 5)) {
                    tf.text = @"";
                }
            }
        }
    }
}
- (void)cvvDidChange:(UITextField *)tf {
    if (tf.text.length > 3) {
        tf.text = [tf.text substringToIndex:3];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
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
    txtCvv.text = tkLienket.cvv;
    [self showCvvField:tkLienket.maNganHang];
}
-(void)showCvvField:(NSString*)nganhang {
    if ([nganhang.lowercaseString isEqualToString:@"Visa".lowercaseString] || [nganhang.lowercaseString isEqualToString:@"MasterCard".lowercaseString] || [nganhang.lowercaseString isEqualToString:@"JCB".lowercaseString]) {
        txtCvv.hidden = NO;
        contraintHeightCvv.constant = 35;
        _edNgayMoThe.placeholder = @"Tháng hết hạn";
        _edNamMoThe.placeholder = @"Năm hết hạn";

    }else {
        contraintHeightCvv.constant = 0;
        txtCvv.hidden = YES;
        _edNgayMoThe.placeholder = @"Từ tháng";
        _edNamMoThe.placeholder = @"Năm";

    }
}
-(void)suataikhoanlienket:(ItemTaiKhoanLienKet*)tkLienket sbank:(NSString*)sBank macdinh:(BOOL)isMacdinh{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:tkLienket.sId forKey:@"id"];
    [dic setValue:tkLienket.idVi forKey:@"idVi"];
    [dic setValue:(isMacdinh ? @1 : @0) forKey:@"tkMacDinh"];

    NSString *sMatKhau = self.txtOtp.text;
    sMatKhau = [DucNT_Token layMatKhauVanTayToken];
    NSString *sSeed = [DucNT_Token laySeedTokenHienTai];
    NSString *sToken = [DucNT_Token OTPFromPIN:sMatKhau seed:sSeed];
    [dic setValue:sToken forKey:@"token"];
    [dic setValue:@"" forKey:@"otpConfirm"];
    [dic setValue:[NSNumber numberWithInt:self.mTypeAuthenticate] forKey:@"typeAuthenticate"];
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
        [[[[UIAlertView alloc] initWithTitle:[@"@thong_bao" localizableString]  message:[@"@can_tao_token" localizableString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
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
    [dic setValue:self.edSoThe.text forKey:@"soThe"];
    int cardMonth = 0;
    if (![self.edNgayMoThe.text isEmpty]) {
        cardMonth = [self.edNgayMoThe.text intValue];
    }
    
    int cardYear = 0;
    if (![self.edNamMoThe.text isEmpty]) {
        cardYear = [self.edNamMoThe.text intValue];
    }
    if (txtCvv.isHidden) {
        [dic setValue:[NSNumber numberWithInt:cardMonth] forKey:@"cardMonth"];
        [dic setValue:[NSNumber numberWithInt:cardYear] forKey:@"cardYear"];
    } else {
        [dic setValue:[NSNumber numberWithInt:cardMonth] forKey:@"cardMonthExp"];
        [dic setValue:[NSNumber numberWithInt:cardYear] forKey:@"cardYearExp"];
        [dic setValue:txtCvv.text forKey:@"cvv"];
    }
    [dic setValue:(isMacdinh ? @1 : @0) forKey:@"tkMacDinh"];
    
    [dic setValue:@"" forKey:@"u"];
    [dic setValue:@"" forKey:@"p"];
    [dic setValue:[NSNumber numberWithInt:self.mTypeAuthenticate] forKey:@"kieuXacThuc"];

    [self taotaikhoanlienket:dic];
}
- (void)dealloc {
    [contraintHeightCvv release];
    [super dealloc];
}
@end
