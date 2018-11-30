//
//  DialogXoaTKLienketViewController.m
//  ViViMASS
//
//  Created by Nguyen Van Hoanh on 11/27/18.
//

#import "DialogXoaTKLienketViewController.h"
#import "ExTextField.h"
#import "CommonUtils.h"
@interface DialogXoaTKLienketViewController ()
@property (retain, nonatomic) IBOutlet UIButton *btnToken;
@property (retain, nonatomic) IBOutlet UIButton *btnVantay;
@property (retain, nonatomic) IBOutlet ExTextField *txtToken;
@property (retain, nonatomic) IBOutlet UIButton *btnThuchien;
@property (retain, nonatomic) IBOutlet UILabel *lblTitle;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *contraintLeading;
@property (retain, nonatomic) IBOutlet UIView *view_dialog;

@end

@implementation DialogXoaTKLienketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)setitleLable:(NSString*)title {
    _lblTitle.text = title;
}
- (void)xuLyKhiKhongCoChucNangQuetVanTay
{
    _btnToken.hidden = NO;
    _txtToken.hidden = YES;
    _btnThuchien.hidden = YES;
    _btnVantay.hidden = YES;
    _contraintLeading.constant = self.view_dialog.frame.size.width/2 - 22;
}

- (void)xuLyKhiCoChucNangQuetVanTay
{
    _btnToken.hidden = YES;
    _txtToken.hidden = YES;
    _btnThuchien.hidden = YES;
    _btnVantay.hidden = NO;
    _contraintLeading.constant = 95;
}

- (void)xuLySuKienDangNhapVanTay
{
    [self xuLySuKienHienThiChucNangVanTayVoiTieuDe:[@"su_dung_van_tay_dang_nhap_tai_khoan_token_VIMASS" localizableString]];
}

- (void)xuLySuKienXacThucVanTayThanhCong
{
    self.mTypeAuthenticate = 0;
    if([self.mDelegate respondsToSelector:@selector(xuLySuKienXacThucVoiKieu:token:otp:)])
    {
        NSString *sToken = @"";
        NSString *sOtp = @"";
        NSString *sMatKhau = self.txtToken.text;
        sMatKhau = [DucNT_Token layMatKhauVanTayToken];
        
        NSString *sSeed = [DucNT_Token laySeedTokenHienTai];
        sToken = [DucNT_Token OTPFromPIN:sMatKhau seed:sSeed];
        if([CommonUtils isEmptyOrNull:sToken])
        {
            [[[[UIAlertView alloc] initWithTitle:[@"@thong_bao" localizableString]  message:[@"@can_tao_token" localizableString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
            return;
        }
        [self.mDelegate xuLySuKienXacThucVoiKieu:self.mTypeAuthenticate token:sToken otp:sOtp];
    }

}
-(void)huyXacThucVanTay{
    [self dotoken:self];
}
- (void)hienThiThongBaoDienMatKhau
{
    [UIAlertView alert:[@"thong_bao_xac_thuc_van_tay_khong_dung" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
}

- (IBAction)dotoken:(id)sender {
    [self.btnToken setSelected:YES];
    [self.btnToken setBackgroundImage:[UIImage imageNamed:@"tokenv"] forState:UIControlStateSelected];
    [self.btnVantay setSelected:NO];
    self.btnToken.hidden = NO;
    self.txtToken.hidden = NO;
    self.btnThuchien.hidden = NO;
}
- (IBAction)doVantay:(id)sender {
    self.mTypeAuthenticate = 0;
    [self.btnVantay setBackgroundImage:[UIImage imageNamed:@"finger"] forState:UIControlStateNormal];
    [self.btnVantay setBackgroundImage:[UIImage imageNamed:@"fingerv"] forState:UIControlStateSelected];
    [self.btnVantay setSelected:YES];
    [self.btnToken setSelected:NO];
    self.txtToken.hidden = YES;
    self.btnThuchien.hidden = YES;
    
    NSString *sKeyDangNhap = [DucNT_LuuRMS layThongTinDangNhap:KEY_DANG_NHAP];
    if(sKeyDangNhap.length > 0)
    {
        [self xuLySuKienHienThiChucNangDangNhapVanTayVoiTieuDe:[@"su_dung_van_tay_dang_nhap_tai_khoan_VIMASS" localizableString]];
    }
    else
    {
        [UIAlertView alert:[@"thong_bao_chua_co_xac_thuc_van_tay" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
    }

}
- (IBAction)thuchien:(id)sender {
    self.mTypeAuthenticate = TYPE_AUTHENTICATE_TOKEN;
    if([self.txtToken validate])
    {
        if([self.mDelegate respondsToSelector:@selector(xuLySuKienXacThucVoiKieu:token:otp:)])
        {
            NSString *sOtp = @"";
            NSString *sMatKhau = self.txtToken.text;
            sMatKhau = [DucNT_Token layMatKhauVanTayToken];
            
            NSString *sSeed = [DucNT_Token laySeedTokenHienTai];
            NSString *sToken = [DucNT_Token OTPFromPIN:sMatKhau seed:sSeed];
            if([CommonUtils isEmptyOrNull:sToken])
            {
                [[[[UIAlertView alloc] initWithTitle:[@"@thong_bao" localizableString]  message:[@"@can_tao_token" localizableString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
                return;
            }
            [self.mDelegate xuLySuKienXacThucVoiKieu:self.mTypeAuthenticate token:sToken otp:sOtp];
        }
    }
    else
    {
        [self.txtToken show_error];
    }

}
- (IBAction)actionClose:(id)sender {
    [self.view removeFromSuperview];
}

- (void)dealloc {
    [_btnToken release];
    [_btnVantay release];
    [_txtToken release];
    [_btnThuchien release];
    [_lblTitle release];
    [_view_dialog release];
    [super dealloc];
}
@end
