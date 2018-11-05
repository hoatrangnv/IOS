//
//  DucNT_RegisterViewViewController.m
//  ViMASS
//
//  Created by MacBookPro on 7/3/14.
//
//

#import "DucNT_RegisterViewViewController.h"
#import "DucNT_ViewOTPConfirm.h"
#import "Common.h"
#import "DucNT_LoginSceen.h"
#import "GiaoDichMang.h"
#import "GiaoDienDieuKhoanCongTy.h"

@interface DucNT_RegisterViewViewController () <UIWebViewDelegate>
{
    BOOL bChecked;
}
@end


@implementation DucNT_RegisterViewViewController

static NSString *dongYDieuKhoan = @"<span style=\"color:#fff; text-align:center; width:100%; float:left\">Tôi đồng ý với <a style=\"color:#fff; font-weight:bold; text-decoration:none\" target=\"_blank\" href=\"http://tmdd.vn/news/70-dieu-khoan-su-dung.aspx\">Điều khoản sử dụng và Chính sách bảo mật</a> của Vimass</span>";

@synthesize edtId;
@synthesize edtPassword;
@synthesize edtPasswordConfirm;
@synthesize btnRegister;
@synthesize viewScroll;

#pragma mark - init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        bChecked = YES;
    }
    return self;
}

#pragma mark - life circle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self khoiTaoBanDau];
    

}

-(void)viewWillLayoutSubviews
{
    [_viewRoot fix];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - khoi Tao
- (void)khoiTaoBanDau
{
    [_mwvDongYDieuKhoan setDelegate:self];
    [_mwvDongYDieuKhoan setBackgroundColor:[UIColor clearColor]];
    [_mwvDongYDieuKhoan setOpaque:NO];
    [_mwvDongYDieuKhoan loadHTMLString:dongYDieuKhoan baseURL:nil];
    [self khoiTaoTextField];
//    self.mlblTitle.text = [@"@title_dang_ky_tai_khoan" localizableString];
    [self addTitleView:[@"title_dang_ky_tai_khoan" localizableString]];
//    [viewScroll setContentSize:CGSizeMake(self.view.frame.size.width, btnRegister.frame.origin.y + btnRegister.frame.size.height + 20)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chuyenFormVeDangNhap:) name:@"XAC_THUC_OTP_THANH_CONG" object:nil];

    
}

-(void)khoiTaoTextField
{
    edtPassword.max_length = 40;
    edtPassword.inputAccessoryView = nil;
    [edtPassword setTextError:[@"@mat_khau_khong_dc_de_trong" localizableString]
                      forType:ExTextFieldTypeEmpty];
    [edtPassword setTextError:[@"@mat_khau_acc_require" localizableString]
                      forType:ExTextFieldTypePassword];
    [edtPassword setBackgroundImage:[Common stretchImage:@"login_txt_bg"] forState:UIControlStateNormal];
    [edtPassword setBackgroundImage:[Common stretchImage:@"login_txt_bg"] forState:UIControlStateHighlighted];
    
    edtPasswordConfirm.max_length = 40;
    edtPasswordConfirm.inputAccessoryView = nil;
    [edtPasswordConfirm setTextError:[@"@mat_khau_khong_dc_de_trong" localizableString]
                             forType:ExTextFieldTypeEmpty];
    [edtPasswordConfirm setTextError:[@"@mat_khau_acc_require" localizableString]
                             forType:ExTextFieldTypePassword];
    [edtPasswordConfirm setBackgroundImage:[Common stretchImage:@"login_txt_bg"] forState:UIControlStateNormal];
    [edtPasswordConfirm setBackgroundImage:[Common stretchImage:@"login_txt_bg"] forState:UIControlStateHighlighted];
    
    [edtId setTextError:[@"@so_dien_thoai_khong_dc_de_trong" localizableString]
                forType:ExTextFieldTypeEmpty];
    [edtId setTextError:[@"@so_dien_thoai_khong_hop_le" localizableString]
                forType:ExTextFieldTypePhone];
    edtId.inputAccessoryView = nil;
    [edtId setBackgroundImage:[Common stretchImage:@"login_txt_bg"] forState:UIControlStateNormal];
    [edtId setBackgroundImage:[Common stretchImage:@"login_txt_bg"] forState:UIControlStateHighlighted];
    
}



#pragma mark - khởi tạo cho các textField
-(BOOL)validate
{
    NSArray *tfs = @[edtId, edtPassword, edtPasswordConfirm];
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
    
    if(![edtPassword.text isEqualToString:edtPasswordConfirm.text])
    {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:[@"mat_khau_khong_trung_khop" localizableString]];
        return NO;
    }
    
    return flg;
}



- (IBAction)clickBtnRegister:(id)sender
{
    [self.view endEditing:YES];
    if(bChecked)
    {
        if([self validate])
        {
            [self showLoadingScreen];
            [self khoiTaoKetNoi];
            btnRegister.enabled = NO;
        }
    }
    else
    {
        btnRegister.enabled = YES;
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:[@"dong_y_dieu_khoan" localizableString]];
    }
}

- (IBAction)suKienBamNutBack:(id)sender
{
    NSLog(@"%s - back ra ngoai", __FUNCTION__);
    if (self.viewDieuKhoan.hidden) {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
    else{
        self.viewDieuKhoan.hidden = YES;
    }
}

- (IBAction)suKienBackDieuKhoan:(id)sender {
//    self.viewDieuKhoan.hidden = YES;
//    self.btnBackMain.enabled = YES;
}
- (IBAction)suKienBamNutCheck:(UIButton *)sender
{
    if(bChecked)
    {
        [sender setImage:[UIImage imageNamed:@"icon_unchecked"] forState:UIControlStateNormal];
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"icon_checked"] forState:UIControlStateNormal];        
    }
    bChecked = !bChecked;
}


#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        if (![[self.viewRoot subviews] containsObject:self.viewDieuKhoan]) {
            [self.viewRoot addSubview:self.viewDieuKhoan];
            NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"dieukhoanchinhsach" ofType:@"html"];
            NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
            [self.webDieuKhoan loadHTMLString:htmlString baseURL:nil];
        }
//        self.btnBackMain.enabled = NO;
        self.viewDieuKhoan.hidden = NO;
        return NO;
    }
    return YES;
}

#pragma mark - notification thông tin xác thực otp thành công -> chuyển về đăng nhập
-(void)chuyenFormVeDangNhap:(NSNotification *)notification
{
    if([[notification name] isEqualToString:@"XAC_THUC_OTP_THANH_CONG"])
    {
        [app.navigationController dismissViewControllerAnimated:NO completion:^
         {
             DucNT_LoginSceen *vc = [[DucNT_LoginSceen alloc] init];
             vc.sTenViewController = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_TEN_VIEWCONTROLLER_CAN_TOI];
             vc.sKieuChuyenGiaoDien = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_KIEU_CHUYEN_GIAO_DIEN];
             [app.navigationController presentViewController:vc animated:YES completion:^{}];
             [vc release];
         }];
    }
}

#pragma mark - xử lý kết nối
-(void)khoiTaoKetNoi
{
    NSLog(@"%s - click click", __FUNCTION__);
    self.mDinhDanhKetNoi = @"KET_NOI_DANG_KY";
    [GiaoDichMang ketNoiDangKyTaiKhoanViViMASS:edtId.text
                                       matKhau:edtPassword.text
                                     nameAlias:@""
                                         email:@""
                                 noiNhanKetQua:self];
}

//- (void)ketNoiThanhCong:(NSString *)sDinhDanh ketQua:(NSString *)sKetQua {
//    [self hideLoadingScreen];
//
//    if ([sDinhDanh isEqualToString:@"KET_NOI_DANG_KY"]) {
//        DucNT_ViewOTPConfirm *view = [[DucNT_ViewOTPConfirm alloc] initwithNib];
//        [view khoiTaoThamSoTaiKhoan:KIEU_OTP_DANG_KY_TAI_KHOAN withPhone:edtId.text];
//        [self.view addSubview:view];
//        [view release];
//        btnRegister.enabled = YES;
//    }
//}
//
//- (void)xuLyKetNoiThatBai:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua {
//    btnRegister.enabled = YES;
//     [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
//}

-(void)ketNoiThanhCong:(NSString *)sKetQua
{
    [self hideLoadingScreen];
    NSDictionary *dicKetQua = [sKetQua objectFromJSONString];
    int nCode = [[dicKetQua objectForKey:@"msgCode"] intValue];
    NSString *message = [dicKetQua objectForKey:@"msgContent"];
    if(nCode == 1)
    {
        DucNT_ViewOTPConfirm *view = [[DucNT_ViewOTPConfirm alloc] initwithNib];
        [view khoiTaoThamSoTaiKhoan:KIEU_OTP_DANG_KY_TAI_KHOAN withPhone:edtId.text];
        [self.view addSubview:view];
        [view release];
    }
    else
    {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:message];
    }
    btnRegister.enabled = YES;
}

#pragma mark - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if(edtId)
        [edtId release];
    if(edtPassword)
        [edtPassword release];
    if(edtPasswordConfirm)
        [edtPasswordConfirm release];
    if(btnRegister)
        [btnRegister release];
    if(viewScroll)
        [viewScroll release];
    [_viewRoot release];
    [_mlblTitle release];
    [_mwvDongYDieuKhoan release];
    [_webDieuKhoan release];
    [_viewDieuKhoan release];
    [_btnBackMain release];
    [super dealloc];
}
@end
