//
//  DucNT_ForgotPassAccViewController.m
//  ViMASS
//
//  Created by MacBookPro on 7/16/14.
//
//

#import "DucNT_ForgotPassAccViewController.h"
#import "DucNT_ViewOTPConfirm.h"
#import "DucNT_LoginSceen.h"

@interface DucNT_ForgotPassAccViewController ()

@end

@implementation DucNT_ForgotPassAccViewController

@synthesize edtSoDienThoai;
@synthesize edtMatKhau;
@synthesize edtMatKhauConfirm;
@synthesize btnQuenMatKhau;
@synthesize btnBack;
@synthesize lbTitle;
@synthesize viewRoot;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self addButtonBack];
//    lbTitle.text = [@"@title_quen_mat_khau" localizableString];
    [self addTitleView:[@"@title_quen_mat_khau" localizableString]];
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(didSelectBackButton)];
    btnBack.imageInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    self.navigationItem.leftBarButtonItem = btnBack;
    
    [self khoiTaoTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chuyenFormVeDangNhap:) name:@"XAC_THUC_OTP_THANH_CONG" object:nil];
}
- (void)didSelectBackButton{
    [self suKienBack:nil];
}
-(void)viewWillLayoutSubviews
{
    [viewRoot fix];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if(edtSoDienThoai)
        [edtSoDienThoai release];
    if(edtMatKhau)
        [edtMatKhau release];
    if(edtMatKhauConfirm)
        [edtMatKhauConfirm release];
    if(btnQuenMatKhau)
        [btnQuenMatKhau release];
    if(viewRoot)
        [viewRoot release];
    if(btnBack)
        [btnBack release];
    if(lbTitle)
        [lbTitle release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setEdtSoDienThoai:nil];
    [self setEdtMatKhau:nil];
    [self setEdtMatKhauConfirm:nil];
    [self setBtnQuenMatKhau:nil];
    [self setViewRoot:nil];
    [self setBtnBack:nil];
    [self setLbTitle:nil];
    [super viewDidUnload];
}

#pragma mark - notification thông tin xác thực otp thành công -> chuyển về đăng nhập
-(void)chuyenFormVeDangNhap:(NSNotification *)notification
{
    if([[notification name] isEqualToString:@"XAC_THUC_OTP_THANH_CONG"])
    {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//        [app.navigationController dismissViewControllerAnimated:NO completion:^
//         {
//             DucNT_LoginSceen *vc = [[DucNT_LoginSceen alloc] init];
//             vc.sTenViewController = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_TEN_VIEWCONTROLLER_CAN_TOI];
//             vc.sKieuChuyenGiaoDien = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_KIEU_CHUYEN_GIAO_DIEN];
////             [app.navigationController presentModalViewController:vc animated:YES];
//             [app.navigationController presentViewController:vc animated:YES completion:^{}];
//             [vc release];
//         }];
    }
}
#pragma mark - khởi tạo cho các text field
-(BOOL)validate
{
    NSArray *tfs = @[edtSoDienThoai, edtMatKhau, edtMatKhauConfirm];
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
    edtMatKhau.max_length = 20;
    [edtMatKhau setBackgroundImage:[Common stretchImage:@"login_txt_bg"] forState:UIControlStateNormal];
    [edtMatKhau setBackgroundImage:[Common stretchImage:@"login_txt_bg"] forState:UIControlStateHighlighted];
    [edtMatKhau setTextError:[@"@mat_khau_khong_dc_de_trong" localizableString]
                  forType:ExTextFieldTypeEmpty];
    [edtMatKhau setTextError:[@"@mat_khau_acc_require" localizableString]
                  forType:ExTextFieldTypePassword];
    
    edtMatKhauConfirm.max_length = 20;
    [edtMatKhauConfirm setBackgroundImage:[Common stretchImage:@"login_txt_bg"] forState:UIControlStateNormal];
    [edtMatKhauConfirm setBackgroundImage:[Common stretchImage:@"login_txt_bg"] forState:UIControlStateHighlighted];
    [edtMatKhauConfirm setTextError:[@"@mat_khau_khong_dc_de_trong" localizableString]
                      forType:ExTextFieldTypeEmpty];
    [edtMatKhauConfirm setTextError:[@"@mat_khau_acc_require" localizableString]
                      forType:ExTextFieldTypePassword];
    
    [edtSoDienThoai setBackgroundImage:[Common stretchImage:@"login_txt_bg"] forState:UIControlStateNormal];
    [edtSoDienThoai setBackgroundImage:[Common stretchImage:@"login_txt_bg"] forState:UIControlStateHighlighted];
    [edtSoDienThoai setTextError:[@"@so_dien_thoai_khong_dc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
}

#pragma mark - sự kiện click
- (IBAction)suKienQuenMatKhau:(id)sender {
    if([edtMatKhau.text isEqualToString:edtMatKhauConfirm.text])
    {
        if([self validate])
        {
            [self khoiTaoKetNoiQuenMatKhau];
        }
    }
    else{
        [[[[UIAlertView alloc] initWithTitle:[@"@thong_bao" localizableString] message:[@"@mat_khau_khong_trung_khop" localizableString] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
    }
}

- (IBAction)suKienBack:(id)sender {
//    [app.navigationController dismissModalViewControllerAnimated:YES];
//    [app.navigationController dismissViewControllerAnimated:YES completion:^{}];
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}

#pragma mark - xử lý kết nối
-(void)khoiTaoKetNoiQuenMatKhau
{
    NSDictionary *dicPost = @{
                              @"phone": edtSoDienThoai.text,
                              @"newPass": edtMatKhau.text
                              };
    NSString *sPost = [dicPost JSONString];
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:self];
    [connect connect:@"https://vimass.vn/vmbank/services/account/forgetPassAcc1" withContent:sPost];
    [connect release];
}

-(void)ketNoiThanhCong:(NSString *)sKetQua
{
    NSLog(@"%s >> %s line: %d >> sKQ: %@ ",__FILE__,__FUNCTION__ ,__LINE__, sKetQua);
    NSDictionary *dicKetQua = [sKetQua objectFromJSONString];
    int nCode = [[dicKetQua objectForKey:@"msgCode"] intValue];
    NSString *sMessage = [dicKetQua objectForKey:@"msgContent"];
    if(nCode == 1)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            DucNT_ViewOTPConfirm *view = [[DucNT_ViewOTPConfirm alloc] initwithNib];
            [view khoiTaoThamSoTaiKhoan:KIEU_OTP_QUEN_MAT_KHAU_TAI_KHOAN withPhone:edtSoDienThoai.text];
            view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:view];
            [view release];
        });
    }
    else{
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sMessage];
//        [[[[UIAlertView alloc] initWithTitle:[@"@thong_bao" localizableString] message:sMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
    }
}
@end
