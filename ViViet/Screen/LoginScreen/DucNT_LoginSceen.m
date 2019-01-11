//
//  DucNT_LoginSceen.m
//  ViMASS
//
//  Created by MacBookPro on 7/5/14.
//
//

#import "DucNT_Token.h"
#import "DucNT_LoginSceen.h"
#import "DucNT_ChangePassSceen.h"
#import "DucNT_TaiKhoanViObject.h"
#import "DichVuNotification.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "FBEncryptorAES.h"
#import "GiaoDienBenTrai.h"
#import "GiaoDichMang.h"
#import "GiaoDienThongTinPhim.h"
#import "GiaoDienHuongDanDangNhap.h"
#import "HiNavigationBar.h"
//#import <FBSDKCoreKit/FBSDKCoreKit.h>
//#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "CommonUtils.h"
@interface DucNT_LoginSceen () <GPPSignInDelegate>
{
    BOOL mDangNhapBangGoogle;
    BOOL mDangNhapBangTaiKhoanViMASS;
    LAContext *mLAContext;
    BOOL isFaceId;
}

@property (nonatomic, copy) NSString *mID;


@end

/*
 * Chú ý view này ko sử dụng pushcontroller nên ko có naviagation nên ko add đc button back
 * Thích thì làm 1 button back giả navigationbar
 */
@implementation DucNT_LoginSceen
{
    NSString *sDinhDanhKetNoi;
    AppDelegate *app;
    BOOL isVanTay;
}
@synthesize edtMainInfo;
@synthesize edtPass;
@synthesize btnDangNhap;
@synthesize btnQuenMatKhau;
@synthesize btnDangKy;
@synthesize btnBack;
@synthesize mbtnDangNhapGoogle;
@synthesize mbtnDangNhapBangVanTay;


static NSString * const DINH_DANH_KET_NOI_DANG_NHAP = @"DINH_DANH_KET_NOI_DANG_NHAP";
static NSString * const keyPin = @"11111111";
static NSString * const kClientID = @"537567037170-08arkno7qbpi1ngtig4qb255atgq077l.apps.googleusercontent.com";
static int const KIEU_KET_NOI_FACEBOOK = 1;
static int const KIEU_KET_NOI_GOOGLE = 2;

#pragma mark - init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.mID = @"";
        mDangNhapBangGoogle = NO;
        mDangNhapBangTaiKhoanViMASS = NO;
    }
    return self;
}

#pragma mark - life circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    isVanTay = YES;
    app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSLog(@"%s - %s : ================><===============", __FILE__, __FUNCTION__);
    [self khoiTaoGiaoDien];
    [self khoiTaoNutFacebook];
    [self khoiTaoNutDangNhapBangGoogle];
    isFaceId = false;
    if([self kiemTraCoChucNangQuetVanTay1])
    {
        self.mbtnDangNhapBangVanTay.hidden = NO;
    }
    else{
        self.mbtnDangNhapBangVanTay.hidden = YES;
    }
    self.imgVimass.layer.cornerRadius = 7;
    self.imgVimass.clipsToBounds = true;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.txtGiayPhep setText:[NSString stringWithFormat:@"Giấy phép Ví điện tử số 41/GP-NHNN\nNgân hàng nhà nước VN cấp 12/3/2018"]];
}
 
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if([self kiemTraCoChucNangQuetVanTay])
    {
        self.mbtnDangNhapBangVanTay.hidden = NO;
    }
    else{
        self.mbtnDangNhapBangVanTay.hidden = YES;
    }
}
- (BOOL)kiemTraCoChucNangQuetVanTay1
{
    LAContext *laContext = [[[LAContext alloc] init] autorelease];
    NSError *error = nil;
    if([laContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
    {
        if (error != NULL) {
            // handle error
        } else {
            [self.mbtnDangNhapBangVanTay setImage:[UIImage imageNamed:@"vantay"] forState:UIControlStateNormal];
            if (@available(iOS 11.0.1, *)) {
                if (laContext.biometryType == LABiometryTypeFaceID) {
                    //localizedReason = "Unlock using Face ID"
                    [self.mbtnDangNhapBangVanTay setImage:[UIImage imageNamed:@"face-sang"] forState:UIControlStateNormal];
                    self.mbtnDangNhapBangVanTay.hidden = false;
                    isVanTay = NO;
                    return YES;
                } else if (laContext.biometryType == LABiometryTypeTouchID) {
                    //localizedReason = "Unlock using Touch ID"
                    [self.mbtnDangNhapBangVanTay setImage:[UIImage imageNamed:@"vantay"] forState:UIControlStateNormal];
                    self.mbtnDangNhapBangVanTay.hidden = false;
                    isVanTay = YES;
                    return YES;
                } else {
                    //localizedReason = "Unlock using Application Passcode"
                    self.mbtnDangNhapBangVanTay.hidden = true;
                    return NO;
                }
            } else {
                // Fallback on earlier versions
//                self.mbtnDangNhapBangVanTay.hidden = true;
                return YES;
            }
        }
    }
    return NO;
}

#pragma mark - handler error
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - khoi Tao
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

- (void)khoiTaoGiaoDien
{
    [self addTitleView:[@"title_dang_nhap" localizableString]];
    [self addButtonHuongDan];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button setImage:[UIImage imageNamed:@"hdsd-icon.png"]forState:UIControlStateNormal];
    
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
    NSString *sXauHienThi = [Common giauSoTaiKhoanDienThoai:sIDcu];
    edtMainInfo.text = sXauHienThi;
    edtPass.text = @"";
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        [self suKienChonViDoanhNghiep:_mbtnViDoanhNghiep];
    }
    else
    {
        [self suKienChonViCaNhan:_mbtnViCaNhan];
    }
    [self.viewDangNhap.layer setCornerRadius:4.0f];
}
-(void)didSelectHDSD{
    [self suKienBamNutHuongDan:nil];
}
- (void)khoiTaoNutFacebook
{
    [self.mbtnDangNhapFacebook.layer setMasksToBounds:YES];
    [self.mbtnDangNhapFacebook.layer setCornerRadius:5.0f];
}

- (void)khoiTaoNutDangNhapBangGoogle
{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:@"tamnv_hienthi"];
    NSLog(@"%s - %s : ==========> value : %@", __FILE__, __FUNCTION__, value);
    if ([value isEqualToString:@"1"]) {
        self.mbtnDangNhapGoogle.hidden = NO;
        [self.mbtnDangNhapGoogle.layer setMasksToBounds:YES];
        [self.mbtnDangNhapGoogle.layer setCornerRadius:5.0f];
    }
}

#pragma mark - Van tay
- (void)xuLyKhiCoChucNangQuetVanTay
{
    [self.mbtnDangNhapBangVanTay setHidden:NO];
}

- (void)xuLyKhiKhongCoChucNangQuetVanTay
{
    [self.mbtnDangNhapBangVanTay setHidden:YES];
}

- (void)xuLySuKienXacThucVanTayThanhCong
{
    NSString *sDictDangNhap = [DucNT_LuuRMS layThongTinDangNhap:KEY_DANG_NHAP];
    NSDictionary *dictDangNhap = [sDictDangNhap objectFromJSONString];
    for(NSString *sKey in [dictDangNhap allKeys])
    {
        NSString *sTaiKhoan = sKey;
        NSString *sMatKhauMaHoa = [dictDangNhap valueForKey:sKey];
        mDangNhapBangTaiKhoanViMASS = YES;
        sDinhDanhKetNoi = DINH_DANH_KET_NOI_DANG_NHAP;
        NSString *sMatKhauGiaiMa = [self giaiMa:sMatKhauMaHoa];
        return [GiaoDichMang ketNoiDangNhapTaiKhoanViViMASS:sTaiKhoan
                                                    matKhau:sMatKhauGiaiMa
                                              maDoanhNghiep:_mtfMaDoanhNghiep.text
                                              noiNhanKetQua:self];
    }
}

#pragma mark - sự kiện chọn các phím
- (IBAction)suKienChonViCaNhan:(id)sender {
    if(!_mbtnViCaNhan.selected)
    {
        [self.mViewChuaNutLuaChonVi bringSubviewToFront:_mbtnViCaNhan];
        _mtfMaDoanhNghiep.hidden = YES; 
        _btnTaoDoanhNghiep.hidden = YES;
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
        _btnTaoDoanhNghiep.hidden = NO;
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
    [mbtnDangNhapBangVanTay setHidden:YES];
    [UIAlertView alert:[@"thong_bao_xac_thuc_van_tay_khong_dung" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
}

- (IBAction)suKienChonBaoMatVanTay:(id)sender
{
    if (isVanTay) {
        
    } else {
        [self.mbtnDangNhapBangVanTay setImage:[UIImage imageNamed:@"face-sang-v"] forState:UIControlStateNormal];
    }
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
//        [self suKienChonBaoMatVanTay:nil];
    }
    else
    {
        [UIAlertView alert:[@"thong_bao_chua_co_xac_thuc_van_tay" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];        
    }
}
- (IBAction)suKienDangNhap:(id)sender
{
    if([self validate] == YES)
    {
        [self hienThiLoading];
        mDangNhapBangTaiKhoanViMASS = YES;
        sDinhDanhKetNoi = DINH_DANH_KET_NOI_DANG_NHAP;
        [GiaoDichMang ketNoiDangNhapTaiKhoanViViMASS:self.mID
                                             matKhau:edtPass.text
                                       maDoanhNghiep:_mtfMaDoanhNghiep.text
                                       noiNhanKetQua:self];
    }
}

/*
 * Dùng cho đăng ký + Quên mật khẩu
 * đẩy sang bên OTP tên file cần chuyển đến tý sau khi otp xác thực xong thì nhận lại
 */
- (IBAction)suKienQuenMatKhau:(id)sender {
    NSLog(@"%s - click click", __FUNCTION__);
    [DucNT_LuuRMS luuThongTinDangNhap:KEY_LOGIN_TEN_VIEWCONTROLLER_CAN_TOI value:_sTenViewController];
    [DucNT_LuuRMS luuThongTinDangNhap:KEY_LOGIN_KIEU_CHUYEN_GIAO_DIEN value:_sKieuChuyenGiaoDien];
    DucNT_ForgotPassAccViewController *vc = [[DucNT_ForgotPassAccViewController alloc] initWithNibName:@"DucNT_ForgotPassAccViewController" bundle:nil];
    UINavigationController *nav = [HiNavigationBar navigationControllerWithRootViewController: vc];
    [vc release];
    [self presentViewController:nav animated:YES completion:nil];
    
}

- (IBAction)suKienDangKy:(id)sender {
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:@"Chức năng đang được phát triển" delegate:nil cancelButtonTitle:@"Đóng" otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        [DucNT_LuuRMS luuThongTinDangNhap:KEY_LOGIN_TEN_VIEWCONTROLLER_CAN_TOI value:_sTenViewController];
        [DucNT_LuuRMS luuThongTinDangNhap:KEY_LOGIN_KIEU_CHUYEN_GIAO_DIEN value:_sKieuChuyenGiaoDien];
        DucNT_RegisterViewViewController *vc = [[DucNT_RegisterViewViewController alloc] initWithNibName:@"DucNT_RegisterViewViewController" bundle:nil];
        [self presentViewController:vc animated:YES completion:nil];
        [vc release];
    }

}

- (IBAction)suKienBack:(id)sender {
    [self huyGiaoDienLogin];
}

- (IBAction)suKienDangNhapBangFacebook:(UIButton *)sender
{
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP && ![_mtfMaDoanhNghiep validate])
    {
        [_mtfMaDoanhNghiep show_error];
        return;
    }
    
    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email"]
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                      [self sessionStateChanged:session state:state error:error];
                                  }];
}

- (IBAction)suKienDangNhapBangGoogle:(UIButton *)sender
{
    if(!mDangNhapBangGoogle)
    {
        int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
        if(nKieuDangNhap == KIEU_DOANH_NGHIEP && ![_mtfMaDoanhNghiep validate])
        {
            [_mtfMaDoanhNghiep show_error];
            return;
        }
        [GPPSignIn class];
        [GPPSignIn sharedInstance].clientID = kClientID;
        [GPPSignIn sharedInstance].scopes= [NSArray arrayWithObjects:kGTLAuthScopePlusLogin, nil];
        [GPPSignIn sharedInstance].shouldFetchGoogleUserID=YES;
        [GPPSignIn sharedInstance].shouldFetchGoogleUserEmail=YES;
        [GPPSignIn sharedInstance].delegate = self;
        [[GPPSignIn sharedInstance] authenticate];
        mDangNhapBangGoogle = YES;
        [RoundAlert show];
    }
}

- (IBAction)suKienChonTaoDoanhNghep:(id)sender {
    [DucNT_LuuRMS luuThongTinDangNhap:KEY_LOGIN_TEN_VIEWCONTROLLER_CAN_TOI value:_sTenViewController];
    [DucNT_LuuRMS luuThongTinDangNhap:KEY_LOGIN_KIEU_CHUYEN_GIAO_DIEN value:_sKieuChuyenGiaoDien];
    _sTenViewController = @"GiaoDienDangKyViDoanhNghiep";
    [self chuyenGiaoDienTiepTheoTuLogin];
}
- (void)suKienBamNutHuongDanGiaoDichViewController:(UIButton *)sender {
    GiaoDienHuongDanDangNhap *vc = [[GiaoDienHuongDanDangNhap alloc] initWithNibName:@"GiaoDienHuongDanDangNhap" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}

- (IBAction)suKienChonXemGiayPhep:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.sbv.gov.vn/webcenter/portal/vi/menu/trangchu/ttsk/ttsk_chitiet?centerWidth=80%25&dDocName=SBV331391&leftWidth=20%25&rightWidth=0%25&showFooter=false&showHeader=false&_adf.ctrl-state=1c7kax1f62_4&_afrLoop=1291034936391000"]];
}

#pragma mark - GPPSignInDelegate

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth
                   error:(NSError *)error
{

    if(!error)
    {
        NSString *googleID = [GPPSignIn sharedInstance].userID;

        NSString *googleEmail = [GPPSignIn sharedInstance].userEmail;
        if(!googleEmail)
            googleEmail = @"";
        
        __block DucNT_LoginSceen *blockSELF = self;
        
        GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:googleID];
        GTLServicePlus* plusService = [[[GTLServicePlus alloc] init] autorelease];
        plusService.retryEnabled = YES;
        [plusService setAuthorizer:[[GPPSignIn sharedInstance] authentication]];
        [plusService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLPlusPerson *person, NSError *error)
        {
            [RoundAlert hide];
            if (error)
            {
                [UIAlertView alert:error.localizedDescription withTitle:[@"thong_bao" localizableString] block:nil];
            }
            else
            {
                [[person retain] autorelease];
                NSString *sName = person.displayName;
                NSString *sUrlAvatar = person.image.url;
                [blockSELF xuLyKetNoiDangNhapCoKieu:KIEU_KET_NOI_GOOGLE coID:googleID nameAlias:sName email:googleEmail avatar:sUrlAvatar];
            }
        }];
    }
    else
    {
        [RoundAlert hide];
        [UIAlertView alert:error.localizedDescription withTitle:[@"thong_bao" localizableString] block:nil];
    }
    
}

- (void)didDisconnectWithError:(NSError *)error
{
    [RoundAlert hide];
    [UIAlertView alert:error.localizedDescription withTitle:[@"thong_bao" localizableString] block:nil];
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

#pragma mark - facebook private
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
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                //                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                //                alertTitle = @"Session Error";
                //                alertText = @"Your current session is no longer valid. Please log in again.";
                //                [self showMessage:alertText withTitle:alertTitle];
                
                // For simplicity, here we just show a generic message for all other errors
                // You can learn how to handle other errors using our guide: https://developers.facebook.com/docs/ios/errors
            } else {
                //Get more error information from the error
                //                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                //
                //                // Show the user an error message
                //                alertTitle = @"Something went wrong";
                //                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                //                [self showMessage:alertText withTitle:alertTitle];
            }
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
        NSLog(@"%s - sDinhDanhKetNoi : %@", __FUNCTION__, sDinhDanhKetNoi);
        if([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_DANG_NHAP])
        {
            [self anLoading];
            NSDictionary *dicKQ2 = [dicKetQua objectForKey:@"result"];
            NSLog(@"%s - [dicKQ2 JSONString] : %@", __FUNCTION__, [dicKQ2 JSONString]);
            app.mThongTinTaiKhoanVi = [[DucNT_TaiKhoanViObject alloc] initWithDict:dicKQ2];
            if(nKieuDangNhap == KIEU_CA_NHAN)
            {
                self.mID = app.mThongTinTaiKhoanVi.sID;
            }
            else if (nKieuDangNhap == KIEU_DOANH_NGHIEP)
            {
                self.mID = app.mThongTinTaiKhoanVi.walletLogin;
            }
            [DucNT_LuuRMS luuThongTinDangNhap:KEY_LOGIN_ID_TEMP value:self.mID];
            sDinhDanhKetNoi = DINH_DANH_DANG_KI_THIET_BI;

            NSString *sDeviceToken = [DucNT_LuuRMS layThongTinDangNhap:KEY_DEVICE_TOKEN];
            NSLog(@"%s - sDeviceToken : %@", __FUNCTION__, sDeviceToken);
            if(sDeviceToken.length > 0)
            {
                NSString *sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
                if(sTaiKhoan.length == 0)
                    sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LAST_ID_LOGIN];

                if(sTaiKhoan.length > 0)
                {
                    NSDictionary *dicPost = @{
                                              @"deviceId":sDeviceToken,
                                              @"id":@"",
                                              @"deviceOS":@"2",
                                              @"phone":sTaiKhoan,
                                              @"appId":[NSString stringWithFormat:@"%d", APP_ID]
                                              };
                    NSLog(@"%s - [dicPost JSONString] : %@", __FUNCTION__, [dicPost JSONString]);
                    DucNT_ServicePost *connectUpDeviceToken = [[DucNT_ServicePost alloc] init];
                    NSString *sUrl = [NSString stringWithFormat:@"%@/%@", BASE_URL_SERVICE_NOTIFICATION, @"addDevice"];
                    [connectUpDeviceToken connect:sUrl
                                      withContent:[dicPost JSONString]];
                    connectUpDeviceToken.ducnt_connectDelegate = self;
                    [connectUpDeviceToken release];
                }
            }
            else {
                [self xuLySauKhiDangKyThietBi:nKieuDangNhap];
            }
        }
        else if([sDinhDanhKetNoi isEqualToString:DINH_DANH_DANG_KI_THIET_BI])
        {
            [self xuLySauKhiDangKyThietBi:nKieuDangNhap];
        }
    }
    else
    {
        [self anLoading];
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:message];
    }
}

- (void)xuLyKetNoiThatBai:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua {
    [self anLoading];
}

- (void)xuLySauKhiDangKyThietBi:(int)nKieuDangNhap {
     [DucNT_LuuRMS luuThongTinDangNhap:KEY_LOGIN_ID value:self.mID];
        [DucNT_LuuRMS luuThongTinDangNhap:KEY_LOGIN_PASS value:edtPass.text];
    [DucNT_LuuRMS luuThongTinDangNhap:KEY_LOGIN_SECSSION value:app.mThongTinTaiKhoanVi.secssion];
    [DucNT_LuuRMS luuThongTinDangNhap:KEY_LOGIN_STATE value:@"YES"];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        [DucNT_LuuRMS luuThongTinDangNhap:KEY_LOGIN_COMPANY_ID value:_mtfMaDoanhNghiep.text];
        [DucNT_LuuRMS luuThongTinDangNhap:KEY_DINH_DANH_DOANH_NGHIEP value:app.mThongTinTaiKhoanVi.sID];
    }

    if(mDangNhapBangTaiKhoanViMASS)
    {
        mDangNhapBangTaiKhoanViMASS = NO;
        if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
        {
            [self luuMatKhauDangNhap:edtPass.text cuaTaiKhoanViMASS:app.mThongTinTaiKhoanVi.walletLogin];
            NSDictionary *dictDN = @{app.mThongTinTaiKhoanVi.walletLogin : _mtfMaDoanhNghiep.text};
            [DucNT_LuuRMS luuThongTinDangNhap:KEY_DANG_NHAP_DOANH_NGHIEP value:[dictDN JSONString]];
        }
        else
        {
            [self luuMatKhauDangNhap:edtPass.text cuaTaiKhoanViMASS:self.mID];
        }
    }

    [DucNT_LuuRMS luuThongTinTaiKhoanViSauDangNhap:app.mThongTinTaiKhoanVi];

    [[NSNotificationCenter defaultCenter] postNotificationName:DANG_NHAP_THANH_CONG object:nil];
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] reloadGiaoDienHome];
    [self chuyenGiaoDienTiepTheoTuLogin];
}

#pragma mark - khởi tạo cho các text field

-(BOOL)validate
{
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    NSArray *tfs = @[edtMainInfo, edtPass];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
        tfs = @[_mtfMaDoanhNghiep, edtMainInfo, edtPass];

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
    edtPass.placeholder = [@"lg - pwd" localizableString];
    edtPass.max_length = 20;
    [edtPass setTextError:[@"@lg - TRUONG_MAT_KHAU_KHONG_DUOC_DE_TRONG" localizableString]
                  forType:ExTextFieldTypeEmpty];
    
    [edtPass setTextError:[@"@lg - MAT_KHAU_O_HOP_LE" localizableString]
                  forType:ExTextFieldTypePassword];
    edtPass.inputAccessoryView = nil;
    
    [self setupTextField:edtMainInfo icon:@"login_acc_ic"];
    
    [self setupTextField:edtPass icon:@"login_pwd_ic"];
    
    [self setupTextField:_mtfMaDoanhNghiep icon:@"dnicon"];

//    edtMainInfo.placeholder = [@"so_vi" localizableString];
    edtMainInfo.placeholder = @" Số điện thoại";
    [edtMainInfo setTextError:[@"@lg - SO_VI_KHONG_DUOC_DE_TRONG" localizableString]
                      forType:ExTextFieldTypeEmpty];
    edtMainInfo.delegate = self;
    edtMainInfo.inputAccessoryView = nil;
    
    _mtfMaDoanhNghiep.placeholder = [@"ma_doan_nghiep" localizableString];
    [_mtfMaDoanhNghiep setTextError:[@"ma_doanh_nghiep_khong_duoc_de_trong" localizableString]
                      forType:ExTextFieldTypeEmpty];
    _mtfMaDoanhNghiep.inputAccessoryView = nil;
    
//    [btnLuuMatKhau setTitle:[@"lg - luu mat khau" localizableString] forState:UIControlStateNormal];
//    [btnDangNhap setTitle:[@"dang_nhap_tk_vimass" localizableString] forState:UIControlStateNormal];
    [btnQuenMatKhau setTitle:[@"quen_mat_khau" localizableString] forState:UIControlStateNormal];
//    [btnDangKy setTitle:[@"dang_ky_tai_khoan" localizableString] forState:UIControlStateNormal];
    [mbtnDangNhapGoogle setTitle:[@"dang_nhap_bang_google" localizableString] forState:UIControlStateNormal];
    [_mbtnDangNhapFacebook setTitle:[@"dang_nhap_bang_facebook" localizableString] forState:UIControlStateNormal];
    
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

#pragma mark - xu ly su kien

- (void) updateSegmentColors
{
    UIColor *checkColor = [UIColor colorWithHexString:@"#4cd964"];
    UIColor *nonCheckColor = [UIColor whiteColor];
//    NSArray *segmentColors = [[NSArray alloc] initWithObjects:checkColor, [UIColor blueColor], [UIColor redColor], nil];
    
    UISegmentedControl *betterSegmentedControl = self.mSegment;
    
    // Get number of segments
    NSUInteger numSegments = [betterSegmentedControl.subviews count];
    
    // Reset segment's color (non selected color)
    for( int i = 0; i < numSegments; i++ ) {
        // reset color
        [[betterSegmentedControl.subviews objectAtIndex:i] setTintColor:nil];
        [[betterSegmentedControl.subviews objectAtIndex:i] setTintColor:[UIColor whiteColor]];
    }
    
    // Sort segments from left to right
    NSArray *sortedViews = [betterSegmentedControl.subviews sortedArrayUsingFunction:compareViewsByOrigin context:NULL];
    
    // Change color of selected segment
    NSInteger selectedIdx = betterSegmentedControl.selectedSegmentIndex;
    [[sortedViews objectAtIndex:selectedIdx] setTintColor:checkColor];
    
    // Remove all original segments from the control
    for (id view in betterSegmentedControl.subviews) {
        [view removeFromSuperview];
    }
    
    // Append sorted and colored segments to the control
    for (id view in sortedViews) {
        [betterSegmentedControl addSubview:view];
    }
}

NSInteger static compareViewsByOrigin(id sp1, id sp2, void *context)
{
    // UISegmentedControl segments use UISegment objects (private API). But we can safely cast them to UIView objects.
    float v1 = ((UIView *)sp1).frame.origin.x;
    float v2 = ((UIView *)sp2).frame.origin.x;
    if (v1 < v2)
        return NSOrderedAscending;
    else if (v1 > v2)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}

/*Chuyen giao dien tu login nếu _sTenViewController có giá trị thì chuyển đến giá trị đấy
 *Còn không thì về home + thông báo đang phát triển
 */
-(void)chuyenGiaoDienTiepTheoTuLogin
{
    [DucNT_LuuRMS luuThongTinDangNhap:KEY_LOGIN_STATE value:@"YES"];

    [app showHowScreen:app.mThongTinTaiKhoanVi];
}

-(void)huyGiaoDienLogin
{
    NSLog(@"%s - START", __FUNCTION__);
    [app.navigationController dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - dealloc
- (void)dealloc {
    if(_mID)
        [_mID release];
    if(edtMainInfo)
        [edtMainInfo release];
    if(edtPass)
        [edtPass release];
    if(btnDangNhap)
        [btnDangNhap release];
    if(btnQuenMatKhau)
        [btnQuenMatKhau release];
    if(btnDangKy)
        [btnDangKy release];
    [mLAContext release];
    [_mbtnDangNhapFacebook release];
    [mbtnDangNhapGoogle release];
    [mbtnDangNhapBangVanTay release];
    [_mtfMaDoanhNghiep release];
//    [_mViewDangNhapThuong release];
    [_mscrvHienThi release];
    [_mViewCaNhan release];
    [_mSegment release];
    [_mbtnViCaNhan release];
    [_mbtnViDoanhNghiep release];
    [_mViewChuaNutLuaChonVi release];
    [_btnTaoDoanhNghiep release];
    [_viewDangNhap release];
    [_viewChuaButton release];
    [_imgVimass release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setEdtMainInfo:nil];
    [self setEdtPass:nil];
    [self setBtnDangNhap:nil];
    [self setBtnQuenMatKhau:nil];
    [self setBtnDangKy:nil];
    [self setBtnBack:nil];
    [self setLbTitle:nil];
    [self setMbtnDangNhapFacebook:nil];
    [self setMbtnDangNhapGoogle:nil];
    [super viewDidUnload];
}


@end
