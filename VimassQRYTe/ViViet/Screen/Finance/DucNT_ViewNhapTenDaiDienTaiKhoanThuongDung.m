//
//  DucNT_ViewNhapTenDaiDienTaiKhoanThuongDung.m
//  ViMASS
//
//  Created by MacBookPro on 7/29/14.
//
//

#import "DucNT_ViewNhapTenDaiDienTaiKhoanThuongDung.h"
#import "JSONKit.h"
#import "DucNT_DanhSachTaiKhoanThuongDungControllerViewController.h"
#import "DucNT_LuuRMS.h"
#import "DucNT_Token.h"

@implementation DucNT_ViewNhapTenDaiDienTaiKhoanThuongDung
{
    DucNT_TaiKhoanThuongDungObject *taiKhoanThuongDungObj;
    int nType;
}

@synthesize btnCancel;
@synthesize btnOK;
@synthesize edtTenHienThi;
@synthesize edtMatKhauToken;
@synthesize lbTitle;
@synthesize viewMain;

-(id)initWithNib:(DucNT_TaiKhoanThuongDungObject *)doiTuong withType:(int)nLoaiVi
{
    self = [[[[NSBundle mainBundle] loadNibNamed:@"DucNT_ViewNhapTenDaiDienTaiKhoanThuongDung" owner:self options:nil] objectAtIndex:0] retain];
    if(self)
    {
        if(doiTuong != nil)
            taiKhoanThuongDungObj = [doiTuong copy];
        if(nLoaiVi ==  TAI_KHOAN_TONG_HOP|| nLoaiVi == TAI_KHOAN_VI || nLoaiVi == TAI_KHOAN_THE || nLoaiVi == TAI_KHOAN_NGAN_HANG)
            nType = nLoaiVi;
        else
            nType = TAI_KHOAN_TONG_HOP;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.75]];
    lbTitle.text = [@"title_ten_dai_dien_tai_khoan" localizableString];
    edtTenHienThi.placeholder = [@"reg_nickname" localizableString];
    [edtTenHienThi setTextError:@"ten_dai_dien_tai_khoan_require".localizableString forType:ExTextFieldTypeEmpty];
    edtMatKhauToken.placeholder = [@"mat_khau_token" localizableString];
    edtMatKhauToken.max_length = 6;
    [edtMatKhauToken setTextError:[@"mat_khau_token_khong_dc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    [btnOK setTitle:[@"dong_y" localizableString] forState:UIControlStateNormal];
    [btnCancel setTitle:[@"huy" localizableString] forState:UIControlStateNormal];
    [edtTenHienThi becomeFirstResponder];
    if([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_TRANG_THAI_CO_TOKEN] isEqualToString:@"0"])
    {
        [edtMatKhauToken setHidden:YES];
        edtTenHienThi.frame = CGRectMake(edtTenHienThi.frame.origin.x, edtTenHienThi.frame.origin.y + edtMatKhauToken.frame.size.height/2, edtTenHienThi.frame.size.width, edtTenHienThi.frame.size.height);
        [self setNeedsDisplay];
    }
}

- (void)dealloc {
    if(btnCancel)
        [btnCancel release];
    if(btnOK)
        [btnOK release];
    if(edtTenHienThi)
        [edtTenHienThi release];
    if(lbTitle)
        [lbTitle release];
    if(viewMain)
        [viewMain release];
    if(taiKhoanThuongDungObj)
       [taiKhoanThuongDungObj release];
    if(edtMatKhauToken)
        [edtMatKhauToken release];
    NSLog(@"%s >> %s line: %d >> DEALLOC %@ ",__FILE__,__FUNCTION__ ,__LINE__, self.class);
    [super dealloc];
}

- (IBAction)suKienCancel:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)suKienOke:(id)sender {
    NSLog(@"%s >> %s line: %d >> OKE ",__FILE__,__FUNCTION__ ,__LINE__);
    [self khoiTaoKetNoiLuuTaiKhoan];
}

#pragma mark - khoi tao ket noi
-(void)khoiTaoKetNoiLuuTaiKhoan
{
    if(taiKhoanThuongDungObj != nil)
    {
        NSString *sToken = @"";
        if(![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_TRANG_THAI_CO_TOKEN] isEqualToString:@"0"])
        {
            if([edtTenHienThi validate] && [edtMatKhauToken validate])
            {
                sToken = [DucNT_Token OTPFromPIN:edtMatKhauToken.text seed:[DucNT_Token layThongTinTrongKeyChain:[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP]]];
                [self taoDuLieuKetNoi:sToken];
            }
        }
        else
        {
            if([edtTenHienThi validate])
            {
                [self taoDuLieuKetNoi:@""];
            }
        }
    }
}

-(void)taoDuLieuKetNoi:(NSString *) sToken
{
    NSDictionary *dic = @{
                          @"id":@"",
                          @"phoneOwner":[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                          @"type":[NSString stringWithFormat:@"%d", nType],
                          @"aliasName":edtTenHienThi.text,
                          @"amount":[NSString stringWithFormat:@"%f",taiKhoanThuongDungObj.nAmount],
                          @"desc":taiKhoanThuongDungObj.sDesc,
                          @"toAccWallet":taiKhoanThuongDungObj.sToAccWallet,
                          @"AccOwnerName":taiKhoanThuongDungObj.sAccOwnerName,
                          @"bankName":taiKhoanThuongDungObj.sBankName,
                          @"BankNumber":taiKhoanThuongDungObj.sBankNumber,
                          @"provinceName":taiKhoanThuongDungObj.sProvinceName,
                          @"provinceCode":[NSString stringWithFormat:@"%d",taiKhoanThuongDungObj.nProvinceCode],
                          @"provinceId":[NSString stringWithFormat:@"%d",taiKhoanThuongDungObj.nProvinceID],
                          @"bankCode":[NSString stringWithFormat:@"%d",taiKhoanThuongDungObj.nBankCode],
                          @"bankId":[NSString stringWithFormat:@"%d",taiKhoanThuongDungObj.nBankId],
                          @"branchId":[NSString stringWithFormat:@"%d",taiKhoanThuongDungObj.nBranchId],
                          @"branchName":taiKhoanThuongDungObj.sBranchName,
                          @"branchCode":taiKhoanThuongDungObj.sBranchCode,
//                          @"cardId":[NSString stringWithFormat:@"%d", taiKhoanThuongDungObj.nCardId],
                          @"cardTypeName": taiKhoanThuongDungObj.sCardTypeName,
                          @"cardNumber":taiKhoanThuongDungObj.sCardNumber,
                          @"cardOwnerName":taiKhoanThuongDungObj.sCardOwnerName,
                          @"dateReg":[NSString stringWithFormat:@"%lld",taiKhoanThuongDungObj.nDateReg],
                          @"dateExp":[NSString stringWithFormat:@"%lld",taiKhoanThuongDungObj.nDateExp],
                          @"token":sToken
                          };
    NSLog(@"%s >> %s line: %d >> Post: %@ ",__FILE__,__FUNCTION__ ,__LINE__, [dic JSONString]);
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:self];
    [connect connect:@"http://203.162.235.66:8080/vmbank/services/account/addAccUsed" withContent:[dic JSONString]];
    [connect release];
}

#pragma mark - service post delegate
-(void)ketNoiThanhCong:(NSString *)sKetQua
{
    NSDictionary *dic = [sKetQua objectFromJSONString];
    int nCode = [[dic objectForKey:@"msgCode"] intValue];
    NSString *sMessage = [dic objectForKey:@"msgContent"];
    if (Localization.getCurrentLang == ENGLISH) {
        sMessage = [dic objectForKey:@"msgContent_en"];
    }
    if(sMessage.length == 0)
        sMessage = @"Lỗi ko xác định";
    if(nCode == 1)
    {
        [[[[UIAlertView alloc] initWithTitle:[@"thong_bao" localizableString]  message:sMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
    }
    else{
        [[[[UIAlertView alloc] initWithTitle:[@"thong_bao" localizableString]  message:sMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == alertView.cancelButtonIndex)
    {
        [self removeFromSuperview];
    }
}
@end
