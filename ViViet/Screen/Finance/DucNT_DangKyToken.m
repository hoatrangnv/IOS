//
//  DucNT_DangKyToken.m
//  ViMASS
//
//  Created by MacBookPro on 7/8/14.
//
//

#import "DucNT_DangKyToken.h"
#import "Common.h"
#import "DucNT_ViewOTPConfirm.h"

@interface DucNT_DangKyToken ()
{
    IBOutlet ExTextField *mtfTenTaiKhoan;
}

@end

@implementation DucNT_DangKyToken

@synthesize edtSoDienThoai;
@synthesize edtMatKhauToken;
@synthesize edtMatKhauTokenConfirm;
@synthesize btnDangKyToken;



#pragma mark - init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - life circle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showBackButton];
    [self addTitleView:[@"title_dang_ky_token" localizableString]];
    [self khoiTaoTextFieldSoDienThoai];
    [self khoiTaoTextField];
    // Do any additional setup after loading the view from its nib.
}

- (void)showBackButton {
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(suKienChonBack:)];
    btnBack.imageInsets = UIEdgeInsetsMake(0, -10.0, 0, 0);
    self.navigationItem.leftBarButtonItem = btnBack;
}

- (void)suKienChonBack:(UIBarButtonItem *) sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - handler error
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - dealloc

- (void)dealloc {
    if(edtSoDienThoai)
        [edtSoDienThoai release];
    if(edtMatKhauToken)
        [edtMatKhauToken release];
    if(edtMatKhauTokenConfirm)
        [edtMatKhauTokenConfirm release];
    if(btnDangKyToken)
        [btnDangKyToken release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setEdtSoDienThoai:nil];
    [self setEdtMatKhauToken:nil];
    [self setEdtMatKhauTokenConfirm:nil];
    [self setBtnDangKyToken:nil];
    [mtfTenTaiKhoan release];
    mtfTenTaiKhoan = nil;
    [super viewDidUnload];
}



#pragma mark - private

- (BOOL)kiemTraLaSoDienThoai:(NSString*)sXau
{
    NSError *error = nil;
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:PATTERN_PHONE
                                                                      options:NSRegularExpressionCaseInsensitive
                                                                        error:&error];
    NSString *s = sXau;
    NSArray *arr = [regex matchesInString:s
                                  options:0
                                    range:NSMakeRange(0,s.length)];
    [regex release];
    if (arr != nil && error == nil && arr.count == 1)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (UIViewController *)viewController {
    UIResponder *responder = self;
    while (![responder isKindOfClass:[UIViewController class]]) {
        responder = [responder nextResponder];
        if (nil == responder) {
            break;
        }
    }
    return (UIViewController *)responder;
}


#pragma mark - khởi tạo TextField

- (void)khoiTaoTextFieldSoDienThoai
{
    NSString *sTenTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    [mtfTenTaiKhoan setText:[NSString stringWithFormat:@"%@: %@",[@"tai_khoan" localizableString],sTenTaiKhoan]];

    if([self kiemTraLaSoDienThoai:sTenTaiKhoan])
    {
        [edtSoDienThoai setText:sTenTaiKhoan];
        [edtSoDienThoai setEnabled:NO];
    }
    else
    {
        [edtSoDienThoai setEnabled:YES];
    }
}

-(BOOL)validate
{
    NSArray *tfs = @[edtMatKhauToken, edtMatKhauTokenConfirm, edtSoDienThoai];
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
    
    return flg;
}

-(void)khoiTaoTextField
{
    [mtfTenTaiKhoan setBackgroundImage:[Common stretchImage:@"login_txt_bg"] forState:UIControlStateNormal];
    [mtfTenTaiKhoan setBackgroundImage:[Common stretchImage:@"login_txt_bg"] forState:UIControlStateHighlighted];
    
    [edtSoDienThoai setBackgroundImage:[Common stretchImage:@"login_txt_bg"] forState:UIControlStateNormal];
    [edtSoDienThoai setBackgroundImage:[Common stretchImage:@"login_txt_bg"] forState:UIControlStateHighlighted];
    [edtSoDienThoai setTextError: [@"@so_dien_thoai_khong_dc_de_trong" localizableString]
                         forType: ExTextFieldTypeEmpty];
    [edtSoDienThoai setTextError: [@"@qrcode_phone_invalid" localizableString]
                         forType: ExTextFieldTypePhone];
    
    edtMatKhauToken.max_length = 6;
    [edtMatKhauToken setBackgroundImage: [Common stretchImage:@"login_txt_bg"]
                               forState: UIControlStateNormal];
    
    [edtMatKhauToken setBackgroundImage: [Common stretchImage:@"login_txt_bg"]
                               forState: UIControlStateHighlighted];
    [edtMatKhauToken setTextError:[@"@mat_khau_token_khong_dc_de_trong" localizableString]
                      forType:ExTextFieldTypeEmpty];
    [edtMatKhauToken setTextError:[@"@mat_khau_token_require" localizableString]
                      forType:ExTextFieldTypeViTokenPassword];
    
    edtMatKhauTokenConfirm.max_length = 6;
    [edtMatKhauTokenConfirm setBackgroundImage:[Common stretchImage:@"login_txt_bg"] forState:UIControlStateNormal];
    [edtMatKhauTokenConfirm setBackgroundImage:[Common stretchImage:@"login_txt_bg"] forState:UIControlStateHighlighted];
    [edtMatKhauTokenConfirm setTextError:[@"@mat_khau_token_khong_dc_de_trong" localizableString]
                             forType:ExTextFieldTypeEmpty];
    [edtMatKhauTokenConfirm setTextError:[@"@mat_khau_token_require" localizableString]
                             forType:ExTextFieldTypeViTokenPassword];
}

//set ảnh bên phải cho textfield - tiện thay luôn background cho các trạng thái
- (void)setupTextField:(ExTextField *)tf icon:(NSString *)icon
{
    UIImage *img = [UIImage imageNamed:icon];
    UIImageView *imgv = [[[UIImageView alloc] initWithImage:img] autorelease];
    imgv.contentMode = UIViewContentModeCenter;
    imgv.frame = CGRectMake(0, 0, 20, img.size.height);
    tf.leftView = imgv;
    tf.leftViewMode = UITextFieldViewModeAlways;
    tf.edgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
//    [tf setBackgroundImage:[Common stretchImage:@"login_txt_bg"] forState:UIControlStateNormal];
//    [tf setBackgroundImage:[Common stretchImage:@"login_txt_bg"] forState:UIControlStateHighlighted];
}

#pragma mark - dich vu Dang ky token

- (void)dangKyTokenBangTaiKhoanDienThoai:(NSString*)sSoDienThoai
{
    NSString *surlContent = [NSString stringWithFormat:@"phone=%@", sSoDienThoai];
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:self];
    [connect connectGet:LINK_DANG_KY_TOKEN  withContent:surlContent];
    [connect release];
}

- (void)dangKyTokenBangTaiKhoanKhac:(NSString*)sTaiKhoan soDienThoai:(NSString*)sSoDienThoai
{
    NSString *sUrl = [NSString stringWithFormat:@"phone=%@&id=%@",sSoDienThoai, sTaiKhoan];
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:self];
    [connect connectGet:LINK_DANG_KY_TOKEN_TAI_KHOAN_KHAC withContent:sUrl];
    [connect release];
}



#pragma mark - su kien click
-(void)didSelectBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)suKienDangKyToken:(id)sender
{
    if([self validate] == YES)
    {
        NSString *sMatKhau = edtMatKhauToken.text;
        NSString *sMatKhauConfirm = edtMatKhauTokenConfirm.text;
        if([sMatKhau isEqualToString:sMatKhauConfirm])
        {
            NSString *sPhone = edtSoDienThoai.text;
            NSString *sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
            if(sTaiKhoan.length == 11 || sTaiKhoan.length == 10)
            {
                [self dangKyTokenBangTaiKhoanDienThoai:sPhone];
            }
            else
            {
                [self dangKyTokenBangTaiKhoanKhac:sTaiKhoan soDienThoai:sPhone];
            }
        }
        else{
            [[[[UIAlertView alloc] initWithTitle:[@"@thong_bao" localizableString]  message:[@"@mat_khau_khong_trung_khop" localizableString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
        }
    }
}

- (IBAction)suKienKetThucBanPhim:(id)sender
{

}

#pragma mark - kết quả kết nối thành công xác thực = OTP
-(void)ketNoiThanhCong:(NSString *)sKetQua
{
    NSLog(@"%s >> %s line: %d >> SKQ: %@ ",__FILE__,__FUNCTION__ ,__LINE__, sKetQua);
    NSDictionary *dicKetQua = [sKetQua objectFromJSONString];
    int nCode = [[dicKetQua objectForKey:@"msgCode"] intValue];
    NSString *message = [dicKetQua objectForKey:@"msgContent"];
    if(nCode == 1)
    {
        NSDictionary *dicKetQua2 = [dicKetQua objectForKey:@"result"];
        NSString *sSeed = [dicKetQua2 objectForKey:@"seedStart"];
        NSString *sPhone = [dicKetQua2 objectForKey:@"phone"];
        
        DucNT_ViewOTPConfirm *view = [[DucNT_ViewOTPConfirm alloc] initwithNib];
            [view khoiTaoThamSoToken: KIEU_OTP_DANG_KY_TOKEN
                       withSeedStart: sSeed
                           withPhone: sPhone
                            withPass: edtMatKhauToken.text];
        [self.view addSubview:view];
        [view release];
        
    }
    else if(nCode == 26)
    {
        NSString *sMatKhau = edtMatKhauTokenConfirm.text;
        NSString *sPhone = edtSoDienThoai.text;
        NSString *sResult = [dicKetQua objectForKey:@"result"];
        UIViewController *viewControllerGoc = [self viewController];
        
        DucNT_ViewOTPConfirm *view = [[DucNT_ViewOTPConfirm alloc] initwithNib];
        
        [view khoiTaoThamSoToken:KIEU_OTP_DANG_KY_TOKEN_TAI_KHOAN_KHAC
                   withSeedStart:sResult
                       withPhone:sPhone
                        withPass:sMatKhau];
        
        [viewControllerGoc.view addSubview:view];
        [view release];
    }
    else
    {
        [[[[UIAlertView alloc] initWithTitle:[@"@thong_bao" localizableString]  message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
    }
}

@end
