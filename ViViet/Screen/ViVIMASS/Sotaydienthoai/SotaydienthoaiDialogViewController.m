

#import "SotaydienthoaiDialogViewController.h"
#import "CommonUtils.h"
@interface SotaydienthoaiDialogViewController ()<UIAlertViewDelegate>{
    int nTrangThaiXuLyKetNoi;//0 = traCuuSoTay,1 = xoaSoTay,2 = suaThongTinSoTay
    NSTimer *mTimer;

}
@property (retain, nonatomic) IBOutlet UIView *popupEdit;
@property (retain, nonatomic) IBOutlet UITextField *txtEditName;
@property (retain, nonatomic) IBOutlet UIButton *btnVantay;
@property (retain, nonatomic) IBOutlet UIButton *btnToken;
@property (retain, nonatomic) IBOutlet UIButton *btnsms;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *contraintVantay;
@property (retain, nonatomic) IBOutlet UILabel *lbCountTime;
@property (retain, nonatomic) IBOutlet UITextField *txtOtp;
@property (retain, nonatomic) IBOutlet UIButton *btnThucHien;
@property (retain, nonatomic) IBOutlet UILabel *lbTime;
@property (retain, nonatomic) IBOutlet UIView *editNameView;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *contraintEditName;
@property (retain, nonatomic) IBOutlet UILabel *lblTitle;

@property (retain, nonatomic) NSString *mPhoneAuthenticate;
@property (assign, nonatomic) NSString *mIsToken;

@property (assign, nonatomic) NSInteger mTongSoThoiGian;
@property (assign, nonatomic) BOOL mChayLanDau;

@end

@implementation SotaydienthoaiDialogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    //Xac thuc = dien thoai
    self.mPhoneAuthenticate = [DucNT_LuuRMS layThongTinDangNhap:KEY_PHONE_AUTHENTICATE];
    //Xac thuc = token
    self.mIsToken = [[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_TRANG_THAI_CO_TOKEN] intValue];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doThucHien:(id)sender {
    [self doThucHien];
}
- (void)showPopupDelete {
    [self setupWithFinger];
    _contraintEditName.constant = 0;
    _editNameView.hidden = true;
}
- (void)showPopupEdit {
    [self setupWithFinger];
    [_txtEditName becomeFirstResponder];
    _contraintEditName.constant = 60;
    _editNameView.hidden = false;
    
}
- (IBAction)onDismiss:(id)sender {
    
    if ([self.view superview]) {
        [self.view removeFromSuperview];
    }
}
- (void)setTextNameInput:(NSString*)text {
    _txtEditName.text = text;
}
- (void)setNameDelete:(NSString*)text {
    _lblTitle.text = text;
}
- (void)dealloc {
    [_popupEdit release];
    [_txtEditName release];
    [_btnVantay release];
    [_btnToken release];
    [_btnsms release];
    [_contraintVantay release];
    [_editNameView release];
    [_contraintEditName release];
    [_lblTitle release];
    [super dealloc];
}
- (void)setupWithFinger {
    if ([self kiemTraCoChucNangQuetVanTay]) {
        _btnsms.hidden = YES;
        _btnToken.hidden = YES;
        _btnVantay.hidden = NO;
        _contraintVantay.constant = [[UIScreen mainScreen] bounds].size.width/2 - 44/2;
    } else {
        _btnsms.hidden = NO;
        _btnToken.hidden = NO;
        _btnVantay.hidden = YES;
    }
    _lbCountTime.hidden = true;
    _lbTime.hidden = true;
    _btnThucHien.hidden = true;
    _txtOtp.hidden = true;

}
- (BOOL)kiemTraCoChucNangQuetVanTay
{
    LAContext *laContext = [[[LAContext alloc] init] autorelease];
    NSError *error = nil;
    if([laContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
    {
        if (error != NULL) {
            // handle error
        } else {
            
            if (@available(iOS 11.0.1, *)) {
                if (laContext.biometryType == LABiometryTypeFaceID) {
                    //localizedReason = "Unlock using Face ID"
                    self.hasFaceID = YES;
                    [self.btnVantay setBackgroundImage:[UIImage imageNamed:@"face_new"] forState:UIControlStateNormal];
                    [self.btnVantay setBackgroundImage:[UIImage imageNamed:@"face_new_selected"] forState:UIControlStateSelected];

                    return YES;
                } else if (laContext.biometryType == LABiometryTypeTouchID) {
                    //localizedReason = "Unlock using Touch ID"
                    self.hasFaceID = NO;
                    [self.btnVantay setBackgroundImage:[UIImage imageNamed:@"finger"] forState:UIControlStateNormal];
                    [self.btnVantay setBackgroundImage:[UIImage imageNamed:@"fingerv"] forState:UIControlStateSelected];
                    return YES;
                } else {
                    //localizedReason = "Unlock using Application Passcode"
                    self.hasFaceID = NO;
                    return NO;
                }
            } else {
                // Fallback on earlier versions
                self.hasFaceID = NO;
            }
        }
    }
    self.hasFaceID = NO;
    return NO;
}
- (IBAction)onVantay:(id)sender {
    // todo
    if(self.hasFaceID){
        [self.btnVantay setBackgroundImage:[UIImage imageNamed:@"face_new"] forState:UIControlStateNormal];
        [self.btnVantay setBackgroundImage:[UIImage imageNamed:@"face_new_selected"] forState:UIControlStateSelected];

    }
    else{
        [self.btnVantay setBackgroundImage:[UIImage imageNamed:@"finger"] forState:UIControlStateNormal];
        [self.btnVantay setBackgroundImage:[UIImage imageNamed:@"fingerv"] forState:UIControlStateSelected];
    }
    [self.btnVantay setSelected:YES];
    [self.btnsms setSelected:NO];
    [self.btnToken setSelected:NO];

    [self doVanTay];

}
- (IBAction)onSMS:(id)sender {
    // todo
    [self.btnsms setSelected:YES];
    [self.btnsms setBackgroundImage:[UIImage imageNamed:@"smsv"] forState:UIControlStateSelected];
    [self.btnToken setSelected:NO];
    [self.btnVantay setSelected:NO];
   
    [self doSMS];

}
- (IBAction)onToken:(id)sender {
    // todo
    [self.btnToken setSelected:YES];
    [self.btnToken setBackgroundImage:[UIImage imageNamed:@"tokenv"] forState:UIControlStateSelected];
    [self.btnsms setSelected:NO];
    [self.btnVantay setSelected:NO];

    [self doToken];

}
- (void)keyboardDidShow:(NSNotification *)notification
{
    CGPoint keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin;
    NSInteger compare = _popupEdit.frame.origin.y + _popupEdit.frame.size.height;
    if (compare > keyboardSize.y) {
        NSInteger margin = compare - keyboardSize.y;
        CGRect rect = _popupEdit.frame;
        rect.origin.y -= margin;
        _popupEdit.frame = rect;
    }
}
-(void)keyboardDidHide:(NSNotification *)notification
{
    _popupEdit.center = self.view.center;
}
#pragma mark - UIAlertViewDelegate

- (void)hienThiHopThoaiHaiNutBamKieu:(int)nKieu cauThongBao:(NSString*)sCauThongBao
{
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:[@"thong_bao" localizableString] message:sCauThongBao delegate:self cancelButtonTitle:[@"huy" localizableString] otherButtonTitles:[@"dong_y" localizableString], nil] autorelease];
    alertView.tag = nKieu;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        if(alertView.tag == HOP_THOAI_XAC_NHAN_XAC_THUC_SMS)
        {
            [self xuLyKetNoiLayMaXacThucChuyenDenTaiKhoan:self.mPhoneAuthenticate];
            //[[NSNotificationCenter  defaultCenter]postNotificationName:@"ReloadFooter" object:1];
        }
        else if(alertView.tag == 198){
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
                [self hienThiLoadingChuyenTien];
            }
            NSDictionary *dicPost = @{@"id" : self.idGiaoDich,
                                      @"user" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                                      @"session" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_SECSSION],
                                      @"status":[NSNumber numberWithBool:YES]
                                      };
            NSLog(@"%s - dicPost : %@", __FUNCTION__, [dicPost JSONString]);
            
            [GiaoDichMang confirmChuyenTienDienThoai:[dicPost JSONString] noiNhanKetQua:self];
            
        }
    }
    else if(buttonIndex == 0)
    {
    }
}

- (void)doThucHien{
    if([CommonUtils isEmptyOrNull:_txtOtp.text]){
        if(self.mTypeAuthenticate == TYPE_AUTHENTICATE_SMS){
            [UIAlertView alert:@"Vui lòng nhập mã xác thực" withTitle:[@"thong_bao" localizableString] block:nil];
        }
        else{
            [UIAlertView alert:@"Vui lòng nhập mật khẩu " withTitle:[@"thong_bao" localizableString] block:nil];
        }
        return;
    }
    [self xuLySuKienXoaHoacSuaSoTay];
}
- (void)doToken{
    if (self.isDelete){
        
    }
    else{
        if([CommonUtils isEmptyOrNull:self.txtEditName.text]){
            [UIAlertView alert:@"Vui lòng điền tên lưu sổ tay" withTitle:[@"thong_bao" localizableString] block:nil];
            return;
        }
    }
    self.mTypeAuthenticate = TYPE_AUTHENTICATE_TOKEN;
    self.txtOtp.hidden = false;
    self.txtOtp.text = @"";
    self.txtOtp.placeholder = @"Mật khẩu token";
    self.btnThucHien.hidden = false;
    self.lbCountTime.hidden = true;
    self.lbTime.hidden = true;
}
-(void)doVanTay{
    if (self.isDelete){
        
    }
    else{
        if([CommonUtils isEmptyOrNull:self.txtEditName.text]){
            [UIAlertView alert:@"Vui lòng điền tên lưu sổ tay" withTitle:[@"thong_bao" localizableString] block:nil];
            return;
        }
    }
    self.mTypeAuthenticate = TYPE_AUTHENTICATE_TOKEN;
    NSString *sKeyDangNhap = [DucNT_LuuRMS layThongTinDangNhap:KEY_DANG_NHAP];
    if(sKeyDangNhap.length > 0)
    {
        [self xuLySuKienHienThiChucNangDangNhapVanTayVoiTieuDe:[@"su_dung_van_tay_dang_nhap_tai_khoan_VIMASS" localizableString]];
    }
    else
    {
        [UIAlertView alert:[@"thong_bao_chua_co_xac_thuc_van_tay" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
    }
}
-(void)doSMS{
    if (self.isDelete){
        
    }
    else{
        if([CommonUtils isEmptyOrNull:self.txtEditName.text]){
            [UIAlertView alert:@"Vui lòng điền tên lưu sổ tay" withTitle:[@"thong_bao" localizableString] block:nil];
            return;
        }
    }
    [self hienThiHopThoaiHaiNutBamKieu:HOP_THOAI_XAC_NHAN_XAC_THUC_SMS cauThongBao:[NSString stringWithFormat:@"%@ %@", [@"thong_bao_ma_xac_thuc_duoc_gui_ve_so_dien_thoai" localizableString], self.mPhoneAuthenticate]];
    
    self.mTongSoThoiGian = THOI_GIAN_CHO_XAC_THUC_SMS;
    self.mTypeAuthenticate = TYPE_AUTHENTICATE_SMS;
}
- (void)xuLySuKienXacThucVanTayThanhCong{
    [self xuLySuKienXoaHoacSuaSoTay];
}
- (void)xuLyKetNoiLayMaXacThucChuyenDenTaiKhoan:(NSString*)sSendTo
{
    NSString *sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    int typeAuthenticate = 1;
    NSMutableString *sUrl = [[NSMutableString alloc] init];
    [sUrl appendFormat:@"https://vimass.vn/vmbank/services/account/getOTP?"];
    [sUrl appendFormat:@"id=%@&", sTaiKhoan];
    [sUrl appendFormat:@"appId=%d&", APP_ID];
    if(self.isDelete){
        [sUrl appendFormat:@"funcId=%d&", FUNC_XOA_SO_TAY_CHUYEN_TIEN_AN_DANH];
    }
    else{
        [sUrl appendFormat:@"funcId=%d&", FUNC_SUA_SO_TAY_CHUYEN_TIEN_AN_DANH];
    }
    [sUrl appendFormat:@"typeAuthenticate=%d&", typeAuthenticate];
    [sUrl appendFormat:@"sendTo=%@", sSendTo];
    
    nTrangThaiXuLyKetNoi = 0;
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:self];
    [connect connectGet:sUrl withContent:@""];
    [connect release];
    [sUrl release];
}

- (void)hienThiThongBaoDienMatKhau
{
    [UIAlertView alert:[@"thong_bao_xac_thuc_van_tay_khong_dung" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
}

#pragma mark - xuLyTimer
- (void)batDauDemThoiGian
{
    mTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(capNhatDemThoiGianThayDoiThongTin) userInfo:nil repeats:YES];
}
- (void)ketThucDemThoiGian
{
    self.lbCountTime.hidden = true;
    self.lbTime.hidden = true;
    if(mTimer)
    {
        [mTimer invalidate];
        mTimer = nil;
    }
}
- (void)capNhatDemThoiGianThayDoiThongTin
{
    _mTongSoThoiGian --;
    
    if(self.mTypeAuthenticate == TYPE_AUTHENTICATE_SMS)
    {
        self.lbCountTime.text = [NSString stringWithFormat:@"%ld s", (long)self.mTongSoThoiGian];
    }
    if(_mTongSoThoiGian == 0)
    {
        [self ketThucDemThoiGian];
    }
}
-(void)xuLySuKienXoaHoacSuaSoTay{
    if(self.isDelete){
        [self xoaSotay:self.idGiaoDich];
    }
    else{
        [self suaSotay:self.idGiaoDich withName:self.txtEditName.text];
    }
}
-(void)xoaSotay:(NSString*)idSotay{
    NSString *sToken = @"";
    NSString *sOtpConfirm = @"";
    
    if(self.mTypeAuthenticate == TYPE_AUTHENTICATE_TOKEN)
    {
        NSString *sMatKhau = @"";
        sMatKhau = [DucNT_Token layMatKhauVanTayToken];
        
        NSString *sSeed = [DucNT_Token laySeedTokenHienTai];
        sToken = [DucNT_Token OTPFromPIN:sMatKhau seed:sSeed];
    }
    else if(self.mTypeAuthenticate == TYPE_AUTHENTICATE_SMS )
    {
        sOtpConfirm = @"";
    }
    NSString *user = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    
    NSDictionary *dictPost = @{
                               @"user" : user,
                               @"token" : sToken,
                               @"otpConfirm" : sOtpConfirm,
                               @"typeAuthenticate" : [NSNumber numberWithInt:self.mTypeAuthenticate],
                               @"appId" : [NSNumber numberWithInt:APP_ID],
                               @"id":idSotay
                               };
    NSString *sPost = [dictPost JSONString];
    NSLog(@"%s - sPost : %@", __FUNCTION__, sPost);
    nTrangThaiXuLyKetNoi = 1;
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:self];
    [connect connect:@"https://vimass.vn/vmbank/services/danhBa/xoaSoTay" withContent:sPost];
    [connect release];
}
-(void)suaSotay:(NSString*)idSotay withName:(NSString*)tenLuu{
    NSString *sToken = @"";
    NSString *sOtpConfirm = @"";
    if(self.mTypeAuthenticate == TYPE_AUTHENTICATE_TOKEN)
    {
        NSString *sMatKhau = @"";
        sMatKhau = [DucNT_Token layMatKhauVanTayToken];
        
        NSString *sSeed = [DucNT_Token laySeedTokenHienTai];
        sToken = [DucNT_Token OTPFromPIN:sMatKhau seed:sSeed];
    }
    else if(self.mTypeAuthenticate == TYPE_AUTHENTICATE_SMS )
    {
        sOtpConfirm = @"";
    }
    NSString *user = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    
    NSDictionary *dictPost = @{
                               @"user" : user,
                               @"token" : sToken,
                               @"otpConfirm" : sOtpConfirm,
                               @"typeAuthenticate" : [NSNumber numberWithInt:self.mTypeAuthenticate],
                               @"appId" : [NSNumber numberWithInt:APP_ID],
                               @"id":idSotay,
                               @"tenLuu":tenLuu
                               };
    NSString *sPost = [dictPost JSONString];
    NSLog(@"%s - sPost : %@", __FUNCTION__, sPost);
    nTrangThaiXuLyKetNoi = 2;
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:self];
    [connect connect:@"https://vimass.vn/vmbank/services/danhBa/xoaSoTay" withContent:sPost];
    [connect release];
}
- (void)ketNoiThanhCong:(NSString *)sKetQua{
    NSLog(@"%s - sKetQua : %@", __FUNCTION__, sKetQua);
    NSDictionary *dicKQ = [sKetQua objectFromJSONString];
    int nCode = [[dicKQ objectForKey:@"msgCode"] intValue];
    NSString *sThongBao = [dicKQ objectForKey:@"msgContent"];
    if(nTrangThaiXuLyKetNoi == 0){
        if(nCode == 31)
        {
            //Chay giay thong bao
            self.mTongSoThoiGian = THOI_GIAN_CHO_XAC_THUC_SMS;
            self.lbCountTime.hidden = false;
            self.lbTime.hidden = false;
            self.txtOtp.hidden = false;
            self.txtOtp.text = @"";
            self.btnThucHien.hidden = false;
            self.txtOtp.placeholder = @"Mã xác thực";
            
            [self batDauDemThoiGian];
        }
        else
        {
            [UIAlertView alert:sThongBao withTitle:[@"thong_bao" localizableString] block:nil];
        }
    }
    else if(nTrangThaiXuLyKetNoi == 2)
    {
        [self.delegate actionEditSotay:self.idGiaoDich andCode:nCode andMessage:sThongBao];
        [self willMoveToParentViewController:nil];  // 1
        [self.view removeFromSuperview];            // 2
        [self removeFromParentViewController];      // 3
    }
    else if (nTrangThaiXuLyKetNoi == 1){
        [self.delegate actionDeleleSotay:self.idGiaoDich andCode:nCode andMessage:sThongBao];
        [self willMoveToParentViewController:nil];  // 1
        [self.view removeFromSuperview];            // 2
        [self removeFromParentViewController];      // 3

    }
}
@end
