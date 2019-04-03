//
//  DucNT_ChangePassSceen.m
//  ViMASS
//
//  Created by MacBookPro on 7/12/14.
//
//

#import "DucNT_ChangePassSceen.h"
#import "Common.h"

@interface DucNT_ChangePassSceen ()

@end

@implementation DucNT_ChangePassSceen

@synthesize edtNewPass;
@synthesize edtOldPass;
@synthesize edtReNewPass;
@synthesize btnExcute;
@synthesize viewKhung;

#pragma mark - init
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
    [self addButtonBack];
//    self.title = [@"@title_doi_mat_khau" localizableString];
    [self addTitleView:[@"title_doi_mat_khau" localizableString]];
    [viewKhung.layer setCornerRadius:3];
    [viewKhung.layer setMasksToBounds:YES];
    [self khoiTaoTextField];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    if(edtOldPass)
        [edtOldPass release];
    if(edtNewPass)
        [edtNewPass release];
    if(edtReNewPass)
        [edtReNewPass release];
    if(btnExcute)
        [btnExcute release];
    if(viewKhung)
        [viewKhung release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setEdtOldPass:nil];
    [self setEdtNewPass:nil];
    [self setEdtReNewPass:nil];
    [self setBtnExcute:nil];
    [self setViewKhung:nil];
    [super viewDidUnload];
}

#pragma mark - khởi tạo textField
-(BOOL)validate
{
    NSArray *tfs = @[edtOldPass, edtNewPass, edtReNewPass];
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
    edtOldPass.max_length = 40;
//    [edtOldPass setBackgroundImage:[Common stretchImage:@"login_txt_bg"] forState:UIControlStateNormal];
//    [edtOldPass setBackgroundImage:[Common stretchImage:@"login_txt_bg"] forState:UIControlStateHighlighted];
    [edtOldPass setTextError:[@"lg - TRUONG_MAT_KHAU_KHONG_DUOC_DE_TRONG" localizableString]
                     forType:ExTextFieldTypeEmpty];
    [edtOldPass setTextError:[@"lg - MAT_KHAU_O_HOP_LE" localizableString]
                     forType:ExTextFieldTypePassword];
    
    edtNewPass.max_length = 40;
//    [edtNewPass setBackgroundImage:[Common stretchImage:@"login_txt_bg"] forState:UIControlStateNormal];
//    [edtNewPass setBackgroundImage:[Common stretchImage:@"login_txt_bg"] forState:UIControlStateHighlighted];
    [edtNewPass setTextError:[@"lg - TRUONG_MAT_KHAU_KHONG_DUOC_DE_TRONG" localizableString]
                     forType:ExTextFieldTypeEmpty];
    [edtNewPass setTextError:[@"lg - MAT_KHAU_O_HOP_LE" localizableString]
                     forType:ExTextFieldTypePassword];
    
    edtReNewPass.max_length = 40;
//    [edtReNewPass setBackgroundImage:[Common stretchImage:@"login_txt_bg"] forState:UIControlStateNormal];
//    [edtReNewPass setBackgroundImage:[Common stretchImage:@"login_txt_bg"] forState:UIControlStateHighlighted];
    [edtReNewPass setTextError:[@"lg - TRUONG_MAT_KHAU_KHONG_DUOC_DE_TRONG" localizableString]
                       forType:ExTextFieldTypeEmpty];
    [edtReNewPass setTextError:[@"lg - MAT_KHAU_O_HOP_LE" localizableString]
                       forType:ExTextFieldTypePassword];
}

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


#pragma mark - sự kiện click

- (IBAction)suKienDoiMatKhau:(id)sender {
    if([edtNewPass.text isEqualToString:edtReNewPass.text])
    {
        if([self validate] == YES)
            [self khoiTaoKetNoi];
    }
    else
    {
        [[[[UIAlertView alloc] initWithTitle:[@"thong_bao" localizableString]  message:[@"mat_khau_khong_trung_khop" localizableString] delegate:nil cancelButtonTitle:[@"OK" localizableString] otherButtonTitles:nil] autorelease] show];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == HOP_THOAI_XAC_NHAN_CHUYEN_TIEN_THANH_CONG)
    {
        if(buttonIndex == 0)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - xử lý kết nối
-(void)khoiTaoKetNoi
{
    NSString *sIDTemp = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    if(sIDTemp != nil && sIDTemp.length > 0)
    {
        NSDictionary *dicPost = @{
                                  @"user":sIDTemp,
                                  @"pass":edtOldPass.text,
                                  @"newPass":edtNewPass.text
                                  };
        NSString *sPost = [dicPost JSONString];
        DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
        [connect setDucnt_connectDelegate:self];
        [connect connect:@"https://vimass.vn/vmbank/services/account/changePass1" withContent:sPost];
        [connect release];
    }
    else
    {
       [[[[UIAlertView alloc] initWithTitle:[@"thong_bao" localizableString]  message:[@"co_loi_trong_qua_trinh_doi_mat_khau" localizableString] delegate:nil cancelButtonTitle:[@"OK" localizableString] otherButtonTitles:nil] autorelease] show];
    }
}

-(void)ketNoiThanhCong:(NSString *)sKetQua
{
    NSDictionary *dicKetQua = [sKetQua objectFromJSONString];
    int nCode = [[dicKetQua objectForKey:@"msgCode"] intValue];
    NSString *sMessage = [dicKetQua objectForKey:@"msgContent"];
    if(nCode == 1)
    {
        [self hienThiHopThoaiMotNutBamKieu:HOP_THOAI_XAC_NHAN_CHUYEN_TIEN_THANH_CONG cauThongBao:sMessage];
    }
    else
    {
        [[[[UIAlertView alloc] initWithTitle:[@"thong_bao" localizableString]  message:sMessage delegate:nil cancelButtonTitle:[@"OK" localizableString] otherButtonTitles:nil] autorelease] show];
    }
}

@end
