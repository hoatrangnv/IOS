//
//  DucNT_ViewDoiMatKhauToken.m
//  ViMASS
//
//  Created by MacBookPro on 7/9/14.
//
//

#import "DucNT_ViewDoiMatKhauToken.h"
#import "RoundAlert.h"
@implementation DucNT_ViewDoiMatKhauToken

@synthesize edtID;
@synthesize edtMatKhauCu;
@synthesize edtMatKhauMoi;
@synthesize edtMatKhauMoiConfirm;
@synthesize btnThucHien;
@synthesize viewKhung;

#pragma mark - init
-(id)initWithNib
{
    self =  [[[[NSBundle mainBundle] loadNibNamed:@"DucNT_ViewDoiMatKhauToken" owner:self options:nil] objectAtIndex:0] retain];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [viewKhung.layer setCornerRadius:3];
    [viewKhung.layer setMasksToBounds:YES];
    [self khoiTaoTextField];
    [btnThucHien setTitle:[@"@thuc_hien" localizableString] forState:UIControlStateNormal];
}

- (void)dealloc {
    if(edtID)
        [edtID release];
    if(edtMatKhauCu)
        [edtMatKhauCu release];
    if(edtMatKhauMoi)
        [edtMatKhauMoi release];
    if(edtMatKhauMoiConfirm)
        [edtMatKhauMoiConfirm release];
    if(btnThucHien)
        [btnThucHien release];
    if(viewKhung)
        [viewKhung release];
    [super dealloc];
}

#pragma mark - xử lý sự kiện kết nối
-(void)ketNoiThanhCong:(NSString *)sKetQua
{
    NSLog(@"%s >> %s line: %d >> sKETQUA: %@ ",__FILE__,__FUNCTION__ ,__LINE__, sKetQua);
    NSDictionary *dicKetQua = [sKetQua objectFromJSONString];
    int nCode = [[dicKetQua objectForKey:@"msgCode"] intValue];
    NSString *sMessage = [dicKetQua objectForKey:@"msgContent"];
    if(nCode == 1)
    {
        [RoundAlert show];
        NSString *sSeed = [DucNT_Token layThongTinTrongKeyChain:[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP]];
        NSString * decrypt_seed = [DucNT_Token decryptSEED:sSeed withPin:edtMatKhauCu.text];
        NSLog(@"%s >> %s line: %d >>seedGoc: %@  ",__FILE__,__FUNCTION__ ,__LINE__, decrypt_seed);
        
        NSString * user_seed = [DucNT_Token encryptSEED:decrypt_seed withPin:edtMatKhauMoi.text];
        [DucNT_Token luuSeedToken:user_seed];
        [DucNT_Token luuMatKhauVanTayToken:edtMatKhauMoi.text];
        
        edtMatKhauCu.text = @"";
        edtMatKhauMoi.text = @"";
        edtMatKhauMoiConfirm.text = @"";
        [RoundAlert hide];
        [[[[UIAlertView alloc] initWithTitle:[@"@thong_bao" localizableString]  message:sMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
    }
    else
    {
        [[[[UIAlertView alloc] initWithTitle:[@"@thong_bao" localizableString]  message:sMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
    }
}
#pragma mark - xử lý sự kiện click
- (IBAction)suKienThucHienDoiMatKhau:(id)sender {
    if(![edtMatKhauCu.text isEqualToString:edtMatKhauMoi.text])
    {
        if([edtMatKhauMoi.text isEqualToString:edtMatKhauMoiConfirm.text])
        {
            if([self validate] == YES)
                [self suKienDoiMatKhau];
        }
        else
        {
            [[[[UIAlertView alloc] initWithTitle:[@"@thong_bao" localizableString]  message:[@"@mat_khau_khong_trung_khop" localizableString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
        }
    }
    else
    {
        [[[[UIAlertView alloc] initWithTitle:[@"@thong_bao" localizableString]  message:[@"@mat_khau_token_cu_phai_khac_mat_khau_moi" localizableString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
    }
}

/*Gửi mật khẩu cũ lên xác thực chính xác -> decrypt -> lấy ra seed gốc -> encrypt lại với pass mới*/
-(void)suKienDoiMatKhau
{
    NSString *sSeed = [DucNT_Token layThongTinTrongKeyChain:[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP]];
    NSString *sOTP = [DucNT_Token OTPFromPIN:edtMatKhauCu.text seed:sSeed];
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:self];
    [connect connectGet:[NSString stringWithFormat:@"%@%@%@", LINK_BASE, @"/auth/getAuth?phone=", [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP]] withContent:[NSString stringWithFormat:@"&otp=%@%@", sOTP , @"&tokenType=1"]];
    [connect release];
}

#pragma mark - xử lý TextField
- (IBAction)suKienKetThucBanPhim:(id)sender {
    //    UITextField *tfTemp = (UITextField *)sender;
    //    if (![tfTemp isEqual:edtMatKhauMoiConfirm]) {
    //        [[self viewWithTag:tfTemp.tag + 1] becomeFirstResponder];
    //    } else {
    //        [sender resignFirstResponder];
    //    }
}

-(BOOL)validate
{
    NSArray *tfs = @[edtID, edtMatKhauCu, edtMatKhauMoi, edtMatKhauMoiConfirm];
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
    [edtID setText:[NSString stringWithFormat:@"%@: %@", [@"so_dien_thoai_dd" localizableString], [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP]]];
    edtID.inputAccessoryView = nil;
    edtID.enabled = NO;
    
    
    edtMatKhauCu.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[@"@mat_khau_token_cu" localizableString] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    edtMatKhauCu.max_length = 6;
    [edtMatKhauCu setTextError:[@"@mat_khau_token_khong_dc_de_trong" localizableString]
                       forType:ExTextFieldTypeEmpty];
    [edtMatKhauCu setTextError:[@"mat_khau_token_require" localizableString]
                       forType:ExTextFieldTypeViTokenPassword];
    
    edtMatKhauMoi.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[@"@new pin vitoken" localizableString] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    edtMatKhauMoi.max_length = 6;
    [edtMatKhauMoi setTextError:[@"@mat_khau_token_khong_dc_de_trong" localizableString]
                        forType:ExTextFieldTypeEmpty];
    [edtMatKhauMoi setTextError:[@"@mat_khau_token_require" localizableString]
                        forType:ExTextFieldTypeViTokenPassword];
    
    edtMatKhauMoiConfirm.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[@"@confirm new pin vitoken" localizableString] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    edtMatKhauMoiConfirm.max_length = 6;
    [edtMatKhauMoiConfirm setTextError:[@"mat_khau_token_khong_dc_de_trong" localizableString]
                               forType:ExTextFieldTypeEmpty];
    [edtMatKhauMoiConfirm setTextError:[@"@mat_khau_token_require" localizableString]
                               forType:ExTextFieldTypeViTokenPassword];
}

@end
