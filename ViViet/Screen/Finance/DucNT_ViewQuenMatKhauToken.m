//
//  DucNT_ViewQuenMatKhauToken.m
//  ViMASS
//
//  Created by MacBookPro on 7/9/14.
//
//

#import "DucNT_ViewQuenMatKhauToken.h"
#import "DucNT_ViewOTPConfirm.h"
#import "Common.h"

@implementation DucNT_ViewQuenMatKhauToken

@synthesize btnThucHien;
@synthesize edtID;
@synthesize edtMatKhauMoi;
@synthesize edtMatKhauMoiConfirm;
@synthesize viewKhung;

#pragma mark - init
-(id)initWithNib
{
    self = [[[[NSBundle mainBundle] loadNibNamed:@"DucNT_ViewQuenMatKhauToken" owner:self options:nil] objectAtIndex:0] retain];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

#pragma mark - life circle

- (void)awakeFromNib
{
    [super awakeFromNib];
    [viewKhung.layer setCornerRadius:3];
    [viewKhung.layer setMasksToBounds:YES];
    [self khoiTaoGiaoDien];
}

#pragma mark - khoi Tao

- (void)khoiTaoGiaoDien
{
//    [btnThucHien setTitle:[@"@thuc hien" localizableString] forState:UIControlStateNormal];
    edtMatKhauMoi.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[@"@new pin vitoken" localizableString] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    
    edtMatKhauMoiConfirm.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[@"@confirm new pin vitoken" localizableString] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    
    edtID.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[@"reg bds - phone" localizableString] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    [self khoiTaoTextField];
    NSString *sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    [_mtfTenTaiKhoan setText:[NSString stringWithFormat:@"%@: %@", [@"tai_khoan" localizableString], sTaiKhoan]];
    
    NSString *sSoDienThoaiDKToken = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_SO_DIEN_THOAI_DANG_KI_TOKEN];
    [edtID setText:sSoDienThoaiDKToken];
    edtID.enabled = NO;
}

#pragma mark - dealloc

- (void)dealloc {
    NSLog(@"%s >> %s line: %d >>  ",__FILE__,__FUNCTION__ ,__LINE__);
    if(btnThucHien)
        [btnThucHien release];
    if(edtID)
        [edtID release];
    if(edtMatKhauMoi)
        [edtMatKhauMoi release];
    if(edtMatKhauMoiConfirm)
        [edtMatKhauMoiConfirm release];
    if(viewKhung)
        [viewKhung release];
    [_mtfTenTaiKhoan release];
    [super dealloc];
}

#pragma mark - xu ly ket noi
-(void)suKienQuenMatKhau
{
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:self];
    NSString *sPhone = edtID.text;
    [connect connectGet:[NSString stringWithFormat:@"%@", LINK_QUEN_MAT_KHAU_TOKEN] withContent:[NSString stringWithFormat:@"&phone=%@", sPhone]];
    [connect release];
}

-(void)ketNoiThanhCong:(NSString *)sKetQua
{
    NSLog(@"%s >> %s line: %d >> sKETQUA: %@ ",__FILE__,__FUNCTION__ ,__LINE__, sKetQua);
    NSDictionary *dicKetQua = [sKetQua objectFromJSONString];
    int nCode = [[dicKetQua objectForKey:@"msgCode"] intValue];
    NSString *sMessage = [dicKetQua objectForKey:@"msgContent"];
    if(nCode == 1)
    {
         NSString *sResult = [dicKetQua objectForKey:@"result"];
        
        UIViewController *viewControllerGoc = [self viewController];
        DucNT_ViewOTPConfirm *view = [[DucNT_ViewOTPConfirm alloc] initwithNib];
        view.frame = CGRectMake(0, 0, viewControllerGoc.view.frame.size.width, viewControllerGoc.view.frame.size.height);
        NSString *sPhone = edtID.text;
        [view khoiTaoThamSoToken:KIEU_OTP_QUEN_MAT_KHAU_TOKEN withSeedStart:sResult withPhone:sPhone withPass:edtMatKhauMoi.text];
        [viewControllerGoc.view addSubview:view];
        [view release];
    }
    else
    {
        [[[[UIAlertView alloc] initWithTitle:[@"@thong_bao" localizableString]  message:sMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
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

#pragma mark - click
- (IBAction)suKienXacThucQuenMatKhau:(id)sender {
    if([edtMatKhauMoi.text isEqualToString:edtMatKhauMoiConfirm.text])
    {
        if([self validate] == YES)
            [self suKienQuenMatKhau];
    }
    else
    {
        [[[[UIAlertView alloc] initWithTitle:[@"@thong_bao" localizableString]  message:[@"@mat_khau_khong_trung_khop" localizableString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
    }
}

- (IBAction)suKienKetThucBanPhim:(id)sender
{
//    UITextField *tfTemp = (UITextField *)sender;
//    if (![tfTemp isEqual:edtMatKhauMoiConfirm]) {
//        [[self viewWithTag:tfTemp.tag + 1] becomeFirstResponder];
//    } else {
//        [sender resignFirstResponder];
//    }
}

#pragma mark - textfield
-(BOOL)validate
{
    NSArray *tfs = @[edtMatKhauMoi, edtMatKhauMoiConfirm, edtID];
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
    
    [edtID setTextError:[@"@so_dien_thoai_khong_dc_de_trong" localizableString]
                forType:ExTextFieldTypeEmpty];
    
    [edtID setTextError:[@"@so_dien_thoai_khong_hop_le" localizableString]
                forType:ExTextFieldTypePhone];
    
    edtMatKhauMoi.max_length = 6;
    [edtMatKhauMoi setTextError:[@"@mat_khau_token_khong_dc_de_trong" localizableString]
                        forType:ExTextFieldTypeEmpty];
    [edtMatKhauMoi setTextError:[@"@mat_khau_token_require" localizableString]
                        forType:ExTextFieldTypeViTokenPassword];
    
    edtMatKhauMoiConfirm.max_length = 6;
    [edtMatKhauMoiConfirm setTextError:[@"@mat_khau_token_khong_dc_de_trong" localizableString]
                               forType:ExTextFieldTypeEmpty];
    [edtMatKhauMoiConfirm setTextError:[@"@mat_khau_token_require" localizableString]
                               forType:ExTextFieldTypeViTokenPassword];
}

@end
