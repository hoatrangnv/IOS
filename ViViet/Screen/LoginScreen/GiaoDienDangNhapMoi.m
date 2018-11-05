//
//  GiaoDienDangNhapMoi.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 9/1/16.
//
//
#import "DucNT_Token.h"
#import "GiaoDienDangNhapMoi.h"
#import "DucNT_LuuRMS.h"
#import "DucNT_ForgotPassAccViewController.h"
#import "DucNT_ChangePassSceen.h"
#import "DucNT_TaiKhoanViObject.h"
#import "DichVuNotification.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "FBEncryptorAES.h"
#import "GiaoDienBenTrai.h"
#import "GiaoDichMang.h"
#import "GiaoDienThongTinPhim.h"
@interface GiaoDienDangNhapMoi () <GPPSignInDelegate>
{
    BOOL mDangNhapBangGoogle;
    BOOL mDangNhapBangTaiKhoanViMASS;
    LAContext *mLAContext;
    NSString *sDinhDanhKetNoi;
    bool bTrangThaiLuuMatKhauDangNhap;
}
@property (nonatomic, copy) NSString *mID;
@end

@implementation GiaoDienDangNhapMoi

static NSString * const DINH_DANH_KET_NOI_DANG_NHAP = @"DINH_DANH_KET_NOI_DANG_NHAP";
static NSString * const keyPin = @"11111111";
static NSString * const kClientID = @"537567037170-08arkno7qbpi1ngtig4qb255atgq077l.apps.googleusercontent.com";
static int const KIEU_KET_NOI_FACEBOOK = 1;
static int const KIEU_KET_NOI_GOOGLE = 2;

- (void)viewDidLoad {
    [super viewDidLoad];
    bTrangThaiLuuMatKhauDangNhap = NO;
    [self.viewDangNhap.layer setCornerRadius:4.0f];

    _mViewChuaNutLuaChonVi.layer.masksToBounds = YES;
    _mViewChuaNutLuaChonVi.layer.cornerRadius = 4.0f;
    [_mbtnViCaNhan setBackgroundImage:[UIImage imageNamed:@"login_tabactive"] forState:UIControlStateSelected];
    [_mbtnViCaNhan setBackgroundImage:[UIImage imageNamed:@"login_tabthuong"] forState:UIControlStateNormal];
    [_mbtnViCaNhan setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [_mbtnViCaNhan setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [_mbtnViDoanhNghiep setBackgroundImage:[UIImage imageNamed:@"login_tabactive"] forState:UIControlStateSelected];
    [_mbtnViDoanhNghiep setBackgroundImage:[UIImage imageNamed:@"login_tabthuong"] forState:UIControlStateNormal];
    [_mbtnViDoanhNghiep setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [_mbtnViDoanhNghiep setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [self khoiTaoTextField];
    NSString *sIDcu = [DucNT_LuuRMS layThongTinDangNhap:KEY_LAST_PHONE_LOGIN_ID];
    self.mID = sIDcu;
//    NSString *sXauHienThi = [Common giauSoTaiKhoanDienThoai:sIDcu];
    _edtMainInfo.text = sIDcu;

    NSString *sPassCu = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_PASS];
    if(sPassCu != nil && [Common trim:sPassCu].length > 0)
    {
        _edtPass.text = sPassCu;
    }

    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        [self suKienChonViDoanhNghiep:_mbtnViDoanhNghiep];
    }
    else
    {
        [self suKienChonViCaNhan:_mbtnViCaNhan];
    }

    bTrangThaiLuuMatKhauDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_REMEMBER_STATE] boolValue];
    if(bTrangThaiLuuMatKhauDangNhap)
    {
        [_btnLuuMatKhau setImage:[UIImage imageNamed:@"icon_checked.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_btnLuuMatKhau setImage:[UIImage imageNamed:@"icon_unchecked.png"] forState:UIControlStateNormal];
    }
}

- (void)khoiTaoGiaoDienDangNhap
{
    _mtfMaDoanhNghiep.text = @"";
    NSString *sMaDoanhNghiepCu = @"";
    NSString *sDictDoanhNghiep = [DucNT_LuuRMS layThongTinDangNhap:KEY_DANG_NHAP_DOANH_NGHIEP];
    if(![sDictDoanhNghiep isEqualToString:@""])
    {
        NSDictionary *dictDN = [sDictDoanhNghiep objectFromJSONString];
        sMaDoanhNghiepCu = [dictDN valueForKey:self.mID];
    }

    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        if(sMaDoanhNghiepCu != nil && [Common trim:sMaDoanhNghiepCu].length > 0)
        {
            _mtfMaDoanhNghiep.text = sMaDoanhNghiepCu;
        }
    }
    else
    {
        _mtfMaDoanhNghiep.text = @"";
    }
}

-(void)khoiTaoTextField
{
    _edtPass.placeholder = [@"lg - pwd" localizableString];
    _edtPass.max_length = 20;
    [_edtPass setTextError:[@"@lg - TRUONG_MAT_KHAU_KHONG_DUOC_DE_TRONG" localizableString]
                  forType:ExTextFieldTypeEmpty];

    [_edtPass setTextError:[@"@lg - MAT_KHAU_O_HOP_LE" localizableString]
                  forType:ExTextFieldTypePassword];
    _edtPass.inputAccessoryView = nil;

    [self setupTextField:_edtMainInfo icon:@"login_acc_ic"];

    [self setupTextField:_edtPass icon:@"login_pwd_ic"];

    [self setupTextField:_mtfMaDoanhNghiep icon:@"dnicon"];

    _edtMainInfo.placeholder = [@"so_vi" localizableString];
    [_edtMainInfo setTextError:[@"@lg - SO_VI_KHONG_DUOC_DE_TRONG" localizableString]
                      forType:ExTextFieldTypeEmpty];
    _edtMainInfo.delegate = self;
    _edtMainInfo.inputAccessoryView = nil;

    [_mtfMaDoanhNghiep setTextError:[@"ma_doanh_nghiep_khong_duoc_de_trong" localizableString]
                            forType:ExTextFieldTypeEmpty];
    _mtfMaDoanhNghiep.inputAccessoryView = nil;
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

#pragma mark - sự kiện chọn các phím
- (IBAction)suKienChonViCaNhan:(id)sender {
    if(!_mbtnViCaNhan.selected)
    {
        [self.mViewChuaNutLuaChonVi bringSubviewToFront:_mbtnViCaNhan];
        _mtfMaDoanhNghiep.hidden = YES;
        _mbtnViCaNhan.selected = YES;
        _mbtnViDoanhNghiep.selected = NO;

        CGRect rectSoVi = self.edtMainInfo.frame;
        CGRect rectPass = self.edtPass.frame;
        CGRect rectMaDoanhNghiep = self.mtfMaDoanhNghiep.frame;
        CGRect rectViewDN = self.viewDangNhap.frame;
        CGRect rectViewButton = self.viewChuaButton.frame;

        rectSoVi.origin.y = rectMaDoanhNghiep.origin.y;
        rectPass.origin.y = rectSoVi.origin.y + rectSoVi.size.height + 8;
        rectViewDN.size.height = rectPass.origin.y + rectPass.size.height
        + 10;
        rectViewButton.origin.y = rectViewDN.origin.y + rectViewDN.size.height + 8;

        self.edtMainInfo.frame = rectSoVi;
        self.edtPass.frame = rectPass;
        self.viewDangNhap.frame = rectViewDN;
        self.viewChuaButton.frame = rectViewButton;

        [DucNT_LuuRMS luuThongTinDangNhap:KEY_HIEN_THI_VI value:[NSString stringWithFormat:@"%d", KIEU_CA_NHAN]];
        [self khoiTaoGiaoDienDangNhap];
    }
}

- (IBAction)suKienChonViDoanhNghiep:(id)sender {
    if(!_mbtnViDoanhNghiep.selected)
    {
        [self.mViewChuaNutLuaChonVi bringSubviewToFront:_mbtnViDoanhNghiep];
        _mtfMaDoanhNghiep.hidden = NO;
        _mbtnViDoanhNghiep.selected = YES;
        _mbtnViCaNhan.selected = NO;
        CGRect rectSoVi = self.edtMainInfo.frame;
        CGRect rectPass = self.edtPass.frame;
        CGRect rectMaDoanhNghiep = self.mtfMaDoanhNghiep.frame;
        CGRect rectViewDN = self.viewDangNhap.frame;
        CGRect rectViewButton = self.viewChuaButton.frame;

        rectSoVi.origin.y = rectMaDoanhNghiep.origin.y + rectMaDoanhNghiep.size.height + 8;
        rectPass.origin.y = rectSoVi.origin.y + rectSoVi.size.height + 8;
        rectViewDN.size.height = rectPass.origin.y + rectPass.size.height
        + 10;
        rectViewButton.origin.y = rectViewDN.origin.y + rectViewDN.size.height + 8;

        self.edtMainInfo.frame = rectSoVi;
        self.edtPass.frame = rectPass;
        self.viewDangNhap.frame = rectViewDN;
        self.viewChuaButton.frame = rectViewButton;

        [DucNT_LuuRMS luuThongTinDangNhap:KEY_HIEN_THI_VI value:[NSString stringWithFormat:@"%d", KIEU_DOANH_NGHIEP]];
        [self khoiTaoGiaoDienDangNhap];
    }
}

- (void)hienThiThongBaoDienMatKhau
{
    [_mbtnDangNhapBangVanTay setHidden:YES];
    [UIAlertView alert:[@"thong_bao_xac_thuc_van_tay_khong_dung" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
}

- (IBAction)suKienChonBaoMatVanTay:(id)sender
{
    NSString *sKeyDangNhap = [DucNT_LuuRMS layThongTinDangNhap:KEY_DANG_NHAP];
    if(sKeyDangNhap.length > 0)
    {
        int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
        if(nKieuDangNhap == KIEU_DOANH_NGHIEP && ![_mtfMaDoanhNghiep validate])
        {
            [_mtfMaDoanhNghiep show_error];
            return;
        }
        [self xuLySuKienHienThiChucNangDangNhapVanTayVoiTieuDe:[@"su_dung_van_tay_dang_nhap_tai_khoan_VIMASS" localizableString]];
    }
    else
    {
        [UIAlertView alert:[@"thong_bao_chua_co_xac_thuc_van_tay" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
    }
}

- (IBAction)suKienLuuMatKhau:(id)sender {
    if(bTrangThaiLuuMatKhauDangNhap)
    {
        bTrangThaiLuuMatKhauDangNhap = FALSE;
        [_btnLuuMatKhau setImage:[UIImage imageNamed:@"icon_unchecked.png"] forState:UIControlStateNormal];
    }
    else if(bTrangThaiLuuMatKhauDangNhap == FALSE)
    {
        bTrangThaiLuuMatKhauDangNhap = TRUE;
        [_btnLuuMatKhau setImage:[UIImage imageNamed:@"icon_checked.png"] forState:UIControlStateNormal];
    }
}

-(BOOL)validate
{
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    NSArray *tfs = @[_edtMainInfo, _edtPass];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
        tfs = @[_mtfMaDoanhNghiep, _edtMainInfo, _edtPass];

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

- (IBAction)suKienDangNhap:(id)sender {
    if([self validate] == YES)
    {
        [self hienThiLoading];
        mDangNhapBangTaiKhoanViMASS = YES;
        sDinhDanhKetNoi = DINH_DANH_KET_NOI_DANG_NHAP;
        [GiaoDichMang ketNoiDangNhapTaiKhoanViViMASS:self.mID
                                             matKhau:_edtPass.text
                                       maDoanhNghiep:_mtfMaDoanhNghiep.text
                                       noiNhanKetQua:self];
    }
}

- (IBAction)suKienQuenMatKhau:(id)sender {
    DucNT_ForgotPassAccViewController *vc = [[DucNT_ForgotPassAccViewController alloc] initWithNibName:@"DucNT_ForgotPassAccViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (IBAction)suKienDangKy:(id)sender {

}

- (IBAction)suKienDangNhapBangFacebook:(UIButton *)sender {

}

- (IBAction)suKienDangNhapBangGoogle:(UIButton *)sender {

}

- (IBAction)suKienBamNutHuongDan:(id)sender {
    
}

#pragma mark - facebook private
// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen)
    {
        [self userLoggedIn];
        return;
    }

    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        // Show the user the logged-out UI
        [self userLoggedOut];
    }

    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = [@"thong_bao_loi_trong_qua_trinh_dang_nhap_facebook" localizableString];
            alertText = [FBErrorUtility userMessageForError:error];
            [self hienThiHopThoaiHaiNutBamKieu:-1 cauThongBao:alertText];
        } else {

        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
}

// Show the user the logged-out UI
- (void)userLoggedOut
{

}

// Show the user the logged-in UI
- (void)userLoggedIn
{
    [RoundAlert show];
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection,
       NSDictionary<FBGraphUser> *user,
       NSError *error) {
         [RoundAlert hide];
         if (!error)
         {
             NSString *email = [user objectForKey:@"email"];
             if(!email)
                 email = @"";
             NSString *facebookId = user.id;

             NSString *sName = user.name;
             NSString *sAvatar = [self layLinkImageFacebook:facebookId];

             [self xuLyKetNoiDangNhapCoKieu:KIEU_KET_NOI_FACEBOOK coID:facebookId nameAlias:sName email:email avatar:sAvatar];
         }
         else
         {
             [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:error.localizedDescription];
         }
     }];
}

- (NSString*)layLinkImageFacebook:(NSString*)sID
{
    NSString *sLinkImage = @"";
    NSString *sUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?redirect=false", sID];

    NSURL *url = [NSURL URLWithString:sUrl];
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 15;

    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    NSData *conn = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if([response statusCode] == 200 && !error)
    {
        sLinkImage = [[[NSString alloc] initWithData:conn encoding:NSUTF8StringEncoding] autorelease];
        NSDictionary *dict = [sLinkImage objectFromJSONString];
        if(dict)
        {
            NSDictionary *dict_data = [dict valueForKey:@"data"];
            sLinkImage = [dict_data valueForKey:@"url"];
            if(!sLinkImage)
                sLinkImage = @"";
        }
    }
    return sLinkImage;
}


#pragma mark - UITextFieldDelegate

//Hàm này dùng đúng với UITextField (chú ý nhớ set edtpass.delegate = self)
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.mID = [self.mID stringByReplacingCharactersInRange:range withString:string];
    return YES;
}

#pragma mark - xử lý kết nối

- (void)xuLyKetNoiDangNhapCoKieu:(int)nKieuKetNoi coID:(NSString*)sID nameAlias:(NSString*)sNameAlias email:(NSString*)sEmail avatar:(NSString*)sAvatar
{
    NSLog(@"%s - DEVICE_REGIS_ID : %d", __FUNCTION__, DEVICE_REGIS_ID);
    NSDictionary *postBody = @{
                               @"type" : [NSNumber numberWithInt:nKieuKetNoi],
                               @"id" : sID,
                               @"email" : sEmail,
                               @"nameAlias" : sNameAlias,
                               @"avatar" : sAvatar,
                               @"companyCode":_mtfMaDoanhNghiep.text,
                               @"appId"    : [NSNumber numberWithInt:APP_ID],
                               @"funcId"   : [NSNumber numberWithInt:FUNC_REGIS_ID],
                               @"deviceId" : [NSNumber numberWithInt:DEVICE_REGIS_ID]
                               };
    NSString *postString = [postBody JSONString];
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    sDinhDanhKetNoi = DINH_DANH_KET_NOI_DANG_NHAP;
    [connect setDucnt_connectDelegate:self];
    [connect connect:LINK_DANG_NHAP_TAI_KHOAN_KHAC withContent:postString];
    [connect release];
}

-(void)ketNoiThanhCong:(NSString *)sKetQua
{
    NSLog(@"%s - sKetQua : %@", __FUNCTION__, sKetQua);
    NSDictionary *dicKetQua = [sKetQua objectFromJSONString];
    int nCode = [[dicKetQua objectForKey:@"msgCode"] intValue];
    NSString *message = [dicKetQua objectForKey:@"msgContent"];
    if(nCode == 1)
    {
        int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
        if([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_DANG_NHAP])
        {
            [self anLoading];
            NSDictionary *dicKQ2 = [dicKetQua objectForKey:@"result"];
            self.mThongTinTaiKhoanVi = [[DucNT_TaiKhoanViObject alloc] initWithDict:dicKQ2];
            if(nKieuDangNhap == KIEU_CA_NHAN)
            {
                self.mID = self.mThongTinTaiKhoanVi.sID;
            }
            else if (nKieuDangNhap == KIEU_DOANH_NGHIEP)
            {
                self.mID = self.mThongTinTaiKhoanVi.walletLogin;
            }
            [DucNT_LuuRMS luuThongTinDangNhap:KEY_LOGIN_ID_TEMP value:self.mID];
            sDinhDanhKetNoi = DINH_DANH_DANG_KI_THIET_BI;
            [[DichVuNotification shareService] dichVuDangKyThietBi:self];
        }
        else if([sDinhDanhKetNoi isEqualToString:DINH_DANH_DANG_KI_THIET_BI])
        {
            if(bTrangThaiLuuMatKhauDangNhap)
            {
                [DucNT_LuuRMS luuThongTinDangNhap:KEY_LOGIN_ID value:self.mID];
                [DucNT_LuuRMS luuThongTinDangNhap:KEY_LOGIN_PASS value:_edtPass.text];
                NSString *sLuuMatKhauDangNhap = [NSString stringWithFormat:@"%@", bTrangThaiLuuMatKhauDangNhap ? @"YES":@"NO"];
                [DucNT_LuuRMS luuThongTinDangNhap:KEY_LOGIN_REMEMBER_STATE value:sLuuMatKhauDangNhap];
            }
            else
            {
                [DucNT_LuuRMS xoaThongTinRMSTheoKey:KEY_LOGIN_PASS];
                [DucNT_LuuRMS xoaThongTinRMSTheoKey:KEY_LOGIN_ID];
                [DucNT_LuuRMS xoaThongTinRMSTheoKey:KEY_LOGIN_REMEMBER_STATE];
                [DucNT_LuuRMS xoaThongTinRMSTheoKey:KEY_LOGIN_COMPANY_ID];
            }

            [DucNT_LuuRMS luuThongTinDangNhap:KEY_LOGIN_SECSSION value:self.mThongTinTaiKhoanVi.secssion];
            [DucNT_LuuRMS luuThongTinDangNhap:KEY_LOGIN_STATE value:@"YES"];
            if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
            {
                [DucNT_LuuRMS luuThongTinDangNhap:KEY_LOGIN_COMPANY_ID value:_mtfMaDoanhNghiep.text];
                [DucNT_LuuRMS luuThongTinDangNhap:KEY_DINH_DANH_DOANH_NGHIEP value:self.mThongTinTaiKhoanVi.sID];
            }

            if(mDangNhapBangTaiKhoanViMASS)
            {
                mDangNhapBangTaiKhoanViMASS = NO;
                if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
                {
                    [self luuMatKhauDangNhap:_edtPass.text cuaTaiKhoanViMASS:self.mThongTinTaiKhoanVi.walletLogin];
                    NSDictionary *dictDN = @{self.mThongTinTaiKhoanVi.walletLogin : _mtfMaDoanhNghiep.text};
                    [DucNT_LuuRMS luuThongTinDangNhap:KEY_DANG_NHAP_DOANH_NGHIEP value:[dictDN JSONString]];
                }
                else
                {
                    [self luuMatKhauDangNhap:_edtPass.text cuaTaiKhoanViMASS:self.mID];
                }
            }

            [DucNT_LuuRMS luuThongTinTaiKhoanViSauDangNhap:self.mThongTinTaiKhoanVi];

            [[NSNotificationCenter defaultCenter] postNotificationName:DANG_NHAP_THANH_CONG object:nil];
            [(AppDelegate*)[[UIApplication sharedApplication] delegate] reloadGiaoDienHome];
            [self chuyenGiaoDienTiepTheoTuLogin];
        }

    }
    else
    {
        [self anLoading];
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:message];
    }
}

- (void)chuyenGiaoDienTiepTheoTuLogin {
    NSLog(@"%s -> START", __FUNCTION__);
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"%s -> STAT 1", __FUNCTION__);
        [self.navigationController popToRootViewControllerAnimated:YES];
        NSLog(@"%s -> STAT 2", __FUNCTION__);
    }];
}

#pragma mark - login private
- (NSString*)maHoa:(NSString*)s
{
    NSString *s1 = [FBEncryptorAES encryptBase64String:s keyString:keyPin separateLines:NO];
    return s1;
}

- (NSString*)giaiMa:(NSString*)s
{
    NSString *s1 = [FBEncryptorAES decryptBase64String:s keyString:keyPin];
    return s1;
}


- (void)luuMatKhauDangNhap:(NSString*)sMatKhau cuaTaiKhoanViMASS:(NSString*)sTaiKhoanViMASS
{
    if(![sMatKhau isEqualToString:@""])
    {
        NSString *sMatKhauDaMaHoa = [self maHoa:sMatKhau];
        NSDictionary *dictDangNhap = @{
                                       sTaiKhoanViMASS : sMatKhauDaMaHoa
                                       };
        [DucNT_LuuRMS luuThongTinDangNhap:KEY_DANG_NHAP value:[dictDangNhap JSONString]];
    }
}

- (void)dealloc {
    [_viewDangNhap release];
    [_mbtnViCaNhan release];
    [_mbtnViDoanhNghiep release];
    [_viewChuaButton release];
    [_edtMainInfo release];
    [_edtPass release];
    [_btnLuuMatKhau release];
    [_btnDangNhap release];
    [_btnQuenMatKhau release];
    [_btnDangKy release];
    [_mViewChuaNutLuaChonVi release];
    [_mbtnDangNhapBangVanTay release];
    [super dealloc];
}
@end
