//
//  ViewDoiTenGiaoDich.m
//  ViMASS
//
//  Created by DucBT on 10/21/14.
//
//

#import "ViewDoiTenGiaoDich.h"
#import "DichVuNotification.h"
#import "JSONKit.h"
#import "Alert+Block.h"
#import "DucNT_LuuRMS.h"
#import "Common.h"
#import "Localization.h"
@implementation ViewDoiTenGiaoDich 

- (void)awakeFromNib
{
    [self initSubview];
}

#pragma mark - khoi tao
- (void)initSubview
{
    
    _mViewChua.layer.masksToBounds = YES;
    _mViewChua.layer.cornerRadius = 8.0f;
    _mViewChua.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    _mViewChua.layer.borderWidth = 2.0f;
    [_mtfTenGiaoDich setPlaceholder:[@"ten_giao_dich" localizableString]];
    [_mtfMatKhau setPlaceholder:[@"mat_khau" localizableString]];
    [_mbtnThayDoi setTitle:[@"thay_doi" localizableString] forState:UIControlStateNormal];
    [self khoiTaoTextField];

}


-(BOOL)validate
{
    
    NSArray *tfs = @[_mtfTenGiaoDich, _mtfMatKhau];
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
    _mtfMatKhau.max_length = 20;
    [_mtfMatKhau setTextError:[@"lg - TRUONG_MAT_KHAU_KHONG_DUOC_DE_TRONG" localizableString]
                  forType:ExTextFieldTypeEmpty];
    
    [_mtfMatKhau setTextError:[@"lg - MAT_KHAU_O_HOP_LE" localizableString]
                  forType:ExTextFieldTypePassword];
    
    
    [_mtfTenGiaoDich setTextError:[@"lg - SO_VI_KHONG_DUOC_DE_TRONG" localizableString]
                      forType:ExTextFieldTypeEmpty];
    
    [_mtfTenGiaoDich setTextError:[@"lg - SO_VI_O_HOP_LE" localizableString]
                      forType:ExTextFieldTypeName];
    _mtfTenGiaoDich.delegate = self;
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
    [tf setBackgroundImage:[Common stretchImage:@"login_txt_bg"] forState:UIControlStateNormal];
    [tf setBackgroundImage:[Common stretchImage:@"login_txt_bg"] forState:UIControlStateHighlighted];
}


#pragma mark -  suKien
- (IBAction)suKienBamNutThayDoi:(id)sender
{
    if(_mtfTenGiaoDich.text.length <= 4)
    {
        [UIAlertView alert:@"Tên giao dịch phải lớn hơn 4 kí tự!" withTitle:[@"thong_bao" localizableString] block:nil];
        return;
    }
    if([self validate])
    {
        [_mtfTenGiaoDich resignFirstResponder];
        [_mtfMatKhau resignFirstResponder];
        NSString *sTenGiaoDichMoi = _mtfTenGiaoDich.text;
        NSString *account = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
        NSString *pass = _mtfMatKhau.text;
        [[DichVuNotification shareService] dichVuDoiTenGiaoDich:sTenGiaoDichMoi account:account pass:pass noiNhanKetQua:self];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag == 1)
    {
        [_mtfTenGiaoDich resignFirstResponder];
        [_mtfMatKhau becomeFirstResponder];
    }
    else if(textField.tag == 2)
    {
        [_mtfMatKhau resignFirstResponder];
        [_mtfTenGiaoDich resignFirstResponder];
    }
    return YES;
}
#pragma mark - DucNT_ServicePostDelegate
- (void)ketNoiThanhCong:(NSString *)sKetQua
{
    NSDictionary *dicKetQua = [sKetQua objectFromJSONString];
    int nCode = [[dicKetQua objectForKey:@"msgCode"] intValue];
    NSString *message = [dicKetQua objectForKey:@"msgContent"];
    if (Localization.getCurrentLang == ENGLISH) {
        message = [dicKetQua objectForKey:@"msgContent_en"];
    }
    if(nCode == 1)
    {
        if([self.mDelegate respondsToSelector:@selector(suKienThayDoiThanhCongTenGiaoDich)])
        {
            [DucNT_LuuRMS luuThongTinDangNhap:KEY_NAME_ALIAS value:_mtfTenGiaoDich.text];
            [self.mDelegate suKienThayDoiThanhCongTenGiaoDich];
        }
    }
    else
    {
        [UIAlertView alert:message withTitle:[@"thong_bao" localizableString] block:nil];
    }
}

#pragma mark - dealloc
- (void)dealloc {

    [_mblTieuDe release];
    [_mtfTenGiaoDich release];
    [_mtfMatKhau release];
    [_mbtnThayDoi release];
    [_mViewChua release];
    [super dealloc];
}
@end
