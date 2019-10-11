//
//  GiaoDichViewController.m
//  ViViMASS
//
//  Created by DucBT on 3/24/15.
//
//

#import "GiaoDichViewController.h"
#import "GiaoDienDatVeXemPhim.h"
#import "DucNT_ChuyenTienDenTaiKhoanViewController.h"
#import "GiaoDienChuyenTienATM.h"
#import "DucNT_ChuyenTienDenTheViewController.h"
#import "GuiTietKiemViewController.h"
#import "GiaoDienDatVeMayBay.h"
#import "ChuyenTienTanNhaViewController.h"
#import "DanhSachQuaTangViewController.h"
#import "GiaoDienChuyenTienDenCMND.h"
#import "GiaoDienTraCuuTienVay.h"
#import "TraCuuTienDienViewController.h"
#import "GiaoDienThanhToanNuoc.h"
#import "GiaoDienThanhToanNuoc.h"
#import "GiaoDienThanhToanInternet.h"
#import "GiaoDienTraCuuTruyenHinh.h"
#import "NapViTuTheNganHangViewController.h"
#import "ThanhToanDienThoaiKhacViewController.h"
#import "DucNT_LoginSceen.h"
#import "MBProgressHUD.h"
#import "CommonUtils.h"

@interface GiaoDichViewController () 
{
    int mTongSoThoiGian;
    NSTimer *mTimer;

}

@end

@implementation GiaoDichViewController

#pragma mark - lifecircle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor]];
    _mViewMain.layer.masksToBounds = YES;
    _mViewMain.layer.cornerRadius = 4.0f;
    self.mtfMatKhauToken.textAlignment = NSTextAlignmentCenter;
    self.mtfMatKhauTokenView.textAlignment = NSTextAlignmentCenter;
    [self.mbtnThucHien setTitle:[@"button_thuc_hien" localizableString] forState:UIControlStateNormal];
    [self.mbtnThucHienView setTitle:[@"button_thuc_hien" localizableString] forState:UIControlStateNormal];
    
    [self khoiTaoGiaoDienChuyenTien];

//    //NSLog(@"%s - class name : %@", __FUNCTION__, NSStringFromClass([self class]));
    if (self.bChuyenGiaoDienQuangCao && ![NSStringFromClass([self class]) isEqualToString:@"GiaoDienChinhV2"]) {
        NSMutableArray *arrNavi = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
        if (arrNavi.count == 3) {
            [arrNavi removeObjectAtIndex:1];
            self.navigationController.viewControllers = arrNavi;
        }
        [arrNavi release];
    }
    self.bHienViewXacThuc = NO;
    [self khoiTaoButtonXacThucBanDau];
    
    
    self.mlblPhi.text = [Localization languageSelectedStringForKey:@"title_phi"];
    self.mlblXacThuc.text = [Localization languageSelectedStringForKey:@"xac_thuc_boi"];
    
    self.mbtnPKI.hidden = YES;
}

- (void)khoiTaoButtonXacThucBanDau {
    
    if (self.enableFaceID) {
        [self.btnVanTayMini setImage:[UIImage imageNamed:@"face-id"] forState:UIControlStateNormal];
    } else {
        [self.btnVanTayMini setImage:[UIImage imageNamed:@"finger"] forState:UIControlStateNormal];
    }
    [self.mbtnToken setImage:[UIImage imageNamed:@"token"] forState:UIControlStateNormal];
}

- (void)addTitleView:(NSString *)sTitle {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    label.autoresizingMask =
    UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 2;
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.minimumScaleFactor = 0.8f;
    label.textColor = [UIColor whiteColor];
    label.text = sTitle;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(suKienBamVaoTitle:)];
    label.userInteractionEnabled = YES;
    [label addGestureRecognizer:tapGesture];
    self.navigationItem.titleView = label;
    [label release];
}

- (void)suKienBamVaoTitle:(UITapGestureRecognizer *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self khoiTaoGiaoDienKhuyenMaiVaSoDu];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)checkButtonPKI {
    if(![CommonUtils isEmptyOrNull:self.mThongTinTaiKhoanVi.pki3] && [self.mThongTinTaiKhoanVi.hanMucPki3 doubleValue] >0 ){
        self.mbtnPKI.hidden = YES;
    }
    else{
        self.mbtnPKI.hidden = YES;
    }
}

- (void)addButtonHuongDan {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 34, 34);
    [button setImage:[UIImage imageNamed:@"hdsd-icon"]forState:UIControlStateNormal];

    button.backgroundColor = [UIColor clearColor];
    button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [button addTarget:self action:@selector(suKienBamNutHuongDanGiaoDichViewController:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *leftItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];

    UIBarButtonItem *negativeSeperator = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];

    if (SYSTEM_VERSION_LESS_THAN(@"11"))
        negativeSeperator.width = -10;
    else {
        negativeSeperator.width = -15;
        [button.widthAnchor constraintEqualToConstant:34].active = YES;
        [button.heightAnchor constraintEqualToConstant:34].active = YES;
    }

    self.navigationItem.rightBarButtonItems = @[negativeSeperator, leftItem];
}

- (void)suKienBamNutHuongDanGiaoDichViewController:(UIButton *)sender {
    
}

- (void)khoiTaoTextFeildTheoYChuTit:(ExTextField *)edTemp nTag:(int)nTag dataPicker : (id<UIPickerViewDataSource>) dataSource delegatePicker : (id<UIPickerViewDelegate>) delegate{
    if (!edTemp.rightView) {
        UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 12)];
        [btnRight setBackgroundImage:[UIImage imageNamed:@"muiten35x21.png"] forState:UIControlStateNormal];
        edTemp.rightView = btnRight;
        edTemp.rightViewMode = UITextFieldViewModeAlways;

        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
        toolBar.barStyle = UIBarStyleBlackOpaque;
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(suKienDonePicker:)];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(suKienCancelPicker:)];
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

        [toolBar setItems:[NSArray arrayWithObjects:cancelButton, flexSpace, doneButton, nil]];
        UIPickerView *pickerChonRap = [[UIPickerView alloc] init];
        pickerChonRap.dataSource = dataSource;
        pickerChonRap.delegate = delegate;
        pickerChonRap.tag = nTag;
        edTemp.inputAccessoryView = toolBar;
        edTemp.inputView = pickerChonRap;
        [pickerChonRap release];
    }
}

- (void)themButtonHuongDanSuDung:(SEL)action {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 34, 34);
    [button setImage:[UIImage imageNamed:@"hdsd-icon"]forState:UIControlStateNormal];

    button.backgroundColor = [UIColor clearColor];
    button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *leftItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];

    UIBarButtonItem *negativeSeperator = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];

    if (SYSTEM_VERSION_LESS_THAN(@"11"))
        negativeSeperator.width = -10;
    else {
        negativeSeperator.width = -15;
        [button.widthAnchor constraintEqualToConstant:34].active = YES;
        [button.heightAnchor constraintEqualToConstant:34].active = YES;
    }

    self.navigationItem.rightBarButtonItems = @[negativeSeperator, leftItem];
}

#pragma mark - khoiTao
- (void)khoiTaoGiaoDienKhuyenMaiVaSoDu
{
    NSString *sSoDu = [Common hienThiTienTe:[self.mThongTinTaiKhoanVi.nAmount doubleValue]];
    //NSLog(@"%s ======================> sSoDu : %@", __FUNCTION__, sSoDu);
    self.mlblSoDu.text = [NSString stringWithFormat:@"%@ %@ đ", [@"so_du" localizableString], sSoDu];
    NSString *sSoDuKhuyenMai = [Common hienThiTienTe:[self.mThongTinTaiKhoanVi.nPromotionTotal doubleValue]];
    self.mlblSoDuKhuyenMai.text = [NSString stringWithFormat:@"%@: %@ đ", [@"khuyen_mai" localizableString], sSoDuKhuyenMai];
    
    BOOL status = [self.mThongTinTaiKhoanVi.nPromotionStatus boolValue];
    if(status)
    {
        self.mlblSoDuKhuyenMai.textColor = [UIColor colorWithHexString:@"#14ab00"];
    }
    else
    {
        self.mlblSoDuKhuyenMai.textColor = [UIColor darkGrayColor];
    }
    self.mswtKhuyenMai.on = status;
    [self.mswtKhuyenMai addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
}

- (void)khoiTaoGiaoDienChuyenTien
{
    //NSLog(@"%s =========================> 1", __FUNCTION__);
    [self.mbtnPKI.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.btnVanTayMini.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.mbtnVanTay.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.mbtnToken.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    self.mbtnPKI.selected = NO;
    
    self.mbtnSMS.selected = NO;
    
    self.mbtnToken.selected = NO;
    
    self.mbtnEmail.selected = NO;
    
    self.mbtnEmail.enabled = YES;
    self.mbtnSMS.enabled = YES;
    self.mbtnToken.enabled = YES;
    self.mbtnPKI.enabled = YES;
    
    [self.mtfMatKhauToken setText:@""];
    self.mtfMatKhauToken.max_length = 6;
    self.mtfMatKhauToken.inputAccessoryView = nil;
    self.mtfMatKhauToken.placeholder = [@"mat_khau_token" localizableString];
    [self.mtfMatKhauToken setTextError:[@"mat_khau_token_khong_dc_de_trong" localizableString]
                               forType:ExTextFieldTypeEmpty];
    
    [self.mbtnThucHien addTarget:self action:@selector(suKienBamNutThucHien:) forControlEvents:UIControlEventTouchUpInside];
    [self.mbtnSMS addTarget:self action:@selector(suKienBamNutSMS:) forControlEvents:UIControlEventTouchUpInside];
    [self.mbtnToken addTarget:self action:@selector(suKienBamNutToken:) forControlEvents:UIControlEventTouchUpInside];
    [self.mbtnEmail addTarget:self action:@selector(suKienBamNutEmail:) forControlEvents:UIControlEventTouchUpInside];
    [self.mbtnVanTay addTarget:self action:@selector(suKienBamNutMatKhauVanTay:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.mbtnPKI addTarget:self action:@selector(suKienBamNutPKI:) forControlEvents:UIControlEventTouchUpInside];
    [self.mbtnTokenView setTitle:@"TOKEN" forState:UIControlStateNormal];
    [self.mbtnTokenView setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
    [self.mbtnSMSView setTitle:@"SMS" forState:UIControlStateNormal];
    [self.mbtnSMSView setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
    [self.mbtnEmailView setTitle:@"EMAIL" forState:UIControlStateNormal];
    [self.mbtnEmailView setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
    
    self.mbtnSMSView.selected = NO;
    self.mbtnTokenView.selected = NO;
    self.mbtnEmailView.selected = NO;
    self.mbtnEmailView.enabled = YES;
    self.mbtnSMSView.enabled = YES;
    self.mbtnTokenView.enabled = YES;
    [self.mtfMatKhauTokenView setText:@""];
    self.mtfMatKhauTokenView.max_length = 6;
    self.mtfMatKhauTokenView.inputAccessoryView = nil;
    self.mtfMatKhauTokenView.placeholder = [@"mat_khau_token" localizableString];
    [self.mtfMatKhauTokenView setTextError:[@"mat_khau_token_khong_dc_de_trong" localizableString]
                               forType:ExTextFieldTypeEmpty];
    
    [self.mbtnThucHienView addTarget:self action:@selector(suKienBamNutThucHien:) forControlEvents:UIControlEventTouchUpInside];
    [self.mbtnSMSView addTarget:self action:@selector(suKienBamNutSMS:) forControlEvents:UIControlEventTouchUpInside];
    [self.mbtnTokenView addTarget:self action:@selector(suKienBamNutToken:) forControlEvents:UIControlEventTouchUpInside];
    [self.mbtnEmailView addTarget:self action:@selector(suKienBamNutEmail:) forControlEvents:UIControlEventTouchUpInside];
    
//    [self.mbtnPKI setHidden:YES];
//    [self.mbtnToken setHidden:YES];
    self.heightViewNhapXacThuc.constant = 0;
    [self.mViewNhapToken setHidden:YES];
}

- (void)updateXacThucKhac {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self khoiTaoButtonXacThucBanDau];
        [self.mbtnToken setHidden:NO];
//        [self checkButtonPKI];
        [self.view layoutIfNeeded];
        [self.view layoutSubviews];
    });
}

- (void)showViewNhapToken:(int)type {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (type == 1) {
            self.mtfMatKhauToken.placeholder = [@"mat_khau_token" localizableString];
        } else {
            self.mtfMatKhauToken.placeholder = [@"chu_ky_mpki" localizableString];
        }
        self.heightViewNhapXacThuc.constant = 35;
        [self.mViewNhapToken setHidden:NO];
        [self.view layoutIfNeeded];
        [self.view layoutSubviews];
    });
}

- (void)changeSwitch:(UISwitch*)sender
{
    BOOL status = [self.mThongTinTaiKhoanVi.nPromotionStatus boolValue];
    if(sender.isOn != status)
    {
        NSString * secssion = self.mThongTinTaiKhoanVi.secssion ;
        if(secssion)
        {
            self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_THAY_DOI_TRANG_THAI_KHUYEN_MAI;
            [GiaoDichMang ketNoiLayGuiTrangThaiSuDungKhuyenMai:secssion trangThai:sender.isOn noiNhanKetQua:self];
        }
        else
        {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng đăng nhập lại để thực hiện chức năng này!"];
        }
    }
}

- (IBAction)suKienBamNutThucHien:(id)sender
{
    if([self validate])
    {
        NSString *token = @"";
        NSString *otp = @"";
        if(self.mTypeAuthenticate == TYPE_AUTHENTICATE_TOKEN)
        {
            NSString *sMatKhau = @"";
            sMatKhau = self.mtfMatKhauToken.text;
            if (self.bHienViewXacThuc) {
                sMatKhau = self.mtfMatKhauTokenView.text;
            }
            token = [self xuLyKhiBamThucHienToken:sMatKhau];
        }
        else
        {
            if (self.bHienViewXacThuc) {
                otp = self.mtfMatKhauTokenView.text;
            }
            else {
                otp = self.mtfMatKhauToken.text;
            }
        }
        [self xuLyThucHienKhiKiemTraThanhCongTraVeToken:token otp:otp];
    }
}

- (NSString *)xuLyKhiBamThucHienToken:(NSString *)sMatKhau {
    NSString *token = @"";
    NSString *sSeed = [DucNT_Token laySeedTokenHienTai];
    if(sSeed != nil && sSeed.length > 0)
    {
        token = [DucNT_Token OTPFromPIN:sMatKhau seed:sSeed];
    }
    else
    {
        [[[[UIAlertView alloc] initWithTitle:[@"thong_bao" localizableString]  message:[@"can_tao_token" localizableString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
    }
    return token;
}

- (void)xuLySuKienXacThucVanTayThanhCong
{
    //NSLog(@"%s - .....START", __FUNCTION__);
    NSString *token = @"";
    NSString *otp = @"";
    self.mTypeAuthenticate = TYPE_AUTHENTICATE_TOKEN;
    NSString *sMatKhau = @"";
    sMatKhau = [DucNT_Token layMatKhauVanTayToken];
    NSString *sSeed = [DucNT_Token laySeedTokenHienTai];
    if(sSeed != nil && sSeed.length > 0)
    {
        token = [DucNT_Token OTPFromPIN:sMatKhau seed:sSeed];
    }
    else
    {
        [[[[UIAlertView alloc] initWithTitle:[@"thong_bao" localizableString]  message:[@"can_tao_token" localizableString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
        return;
    }
    
    [self xuLyThucHienKhiKiemTraThanhCongTraVeToken:token otp:otp];
}

- (IBAction)suKienBamNutToken:(UIButton *)sender
{
    if([self.mThongTinTaiKhoanVi.nIsToken intValue] > 0)
    {
        [self showViewNhapToken:1];
        if(!self.mbtnToken.selected || !self.mbtnTokenView.selected)
        {
            [self.mtfMatKhauToken setKeyboardType:UIKeyboardTypeDefault];
            self.mtfMatKhauToken.secureTextEntry = YES;
            self.mTypeAuthenticate = TYPE_AUTHENTICATE_TOKEN;
            [self.mbtnToken setSelected:YES];
            [self.mbtnToken setImage:[UIImage imageNamed:@"tokenv"] forState:UIControlStateNormal];
            
            [self.mtfMatKhauTokenView setKeyboardType:UIKeyboardTypeDefault];
            self.mtfMatKhauTokenView.secureTextEntry = YES;
            [self.mbtnTokenView setSelected:YES];
            [self.mbtnTokenView setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            if(self.mbtnPKI.enabled)
            {
                [self.mbtnPKI setImage:[UIImage imageNamed:@"pki"] forState:UIControlStateNormal];
                [self.mbtnPKI setTitleColor:nil forState:UIControlStateNormal];
                [self.mbtnPKI setSelected:NO];
            }
            if (self.btnVanTayMini.enabled) {
                if (self.enableFaceID) {
                    [self.btnVanTayMini setImage:[UIImage imageNamed:@"face-id"] forState:UIControlStateNormal];
                } else {
                    [self.btnVanTayMini setImage:[UIImage imageNamed:@"finger"] forState:UIControlStateNormal];
                }
                [self.btnVanTayMini setTitleColor:nil forState:UIControlStateNormal];
                [self.btnVanTayMini setSelected:NO];
            }
            if(self.mbtnSMS.enabled)
            {
                [self.mbtnSMS setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
                [self.mbtnSMS setTitleColor:nil forState:UIControlStateNormal];
                [self.mbtnSMS setSelected:NO];
            }
            if (self.mbtnSMSView.enabled) {
                [self.mbtnSMSView setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
                [self.mbtnSMSView setTitleColor:nil forState:UIControlStateNormal];
                [self.mbtnSMSView setSelected:NO];
            }
            if(self.mbtnEmail.enabled)
            {
                [self.mbtnEmail setSelected:NO];
                [self.mbtnEmail setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
                [self.mbtnEmail setTitleColor:nil forState:UIControlStateNormal];
            }
            if(self.mbtnEmailView.enabled)
            {
                [self.mbtnEmailView setSelected:NO];
                [self.mbtnEmailView setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
                [self.mbtnEmailView setTitleColor:nil forState:UIControlStateNormal];
            }
            self.mtfMatKhauToken.placeholder = [@"mat_khau_token" localizableString];
            self.mtfMatKhauTokenView.placeholder = [@"mat_khau_token" localizableString];
            [self.mtfMatKhauToken setTextError:[@"mat_khau_token_khong_dc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
            [self.mtfMatKhauTokenView setTextError:[@"mat_khau_token_khong_dc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
        }
    }
    else
    {
        [UIAlertView alert:[@"thong_bao_loi_chua_dang_ky_token" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
    }
}
- (IBAction)suKienBamNutPKI:(UIButton *)sender
{
    //NSLog(@"%s - %s : click lick click", __FILE__, __FUNCTION__);
    [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Thiết bị chưa hỗ trợ ký số"];
//    [self showViewNhapToken:2];
//    if(!self.mbtnPKI.selected)
//    {
//        [self.mtfMatKhauToken setKeyboardType:UIKeyboardTypeDefault];
//        self.mtfMatKhauToken.secureTextEntry = YES;
//        self.mTypeAuthenticate = TYPE_AUTHENTICATE_PKI;
//        [self.mbtnPKI setSelected:YES];
//        [self.mbtnPKI setImage:[UIImage imageNamed:@"pkiv"] forState:UIControlStateNormal];
//        if(self.mbtnToken.enabled)
//        {
//            [self.mbtnToken setImage:[UIImage imageNamed:@"token"] forState:UIControlStateNormal];
//            [self.mbtnToken setTitleColor:nil forState:UIControlStateNormal];
//            [self.mbtnToken setSelected:NO];
//        }
//        if (self.btnVanTayMini.enabled) {
//            if (self.enableFaceID) {
//                [self.btnVanTayMini setImage:[UIImage imageNamed:@"face-id"] forState:UIControlStateNormal];
//            } else {
//                [self.btnVanTayMini setImage:[UIImage imageNamed:@"finger"] forState:UIControlStateNormal];
//            }
//            [self.btnVanTayMini setTitleColor:nil forState:UIControlStateNormal];
//            [self.btnVanTayMini setSelected:NO];
//        }
//        if(self.mbtnSMS.enabled)
//        {
//            [self.mbtnSMS setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
//            [self.mbtnSMS setTitleColor:nil forState:UIControlStateNormal];
//            [self.mbtnSMS setSelected:NO];
//        }
//        if(self.mbtnEmail.enabled)
//        {
//            [self.mbtnEmail setSelected:NO];
//            [self.mbtnEmail setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
//            [self.mbtnEmail setTitleColor:nil forState:UIControlStateNormal];
//        }
//        self.mtfMatKhauToken.placeholder = [@"mat_khau_token" localizableString];
//        self.mtfMatKhauTokenView.placeholder = [@"mat_khau_token" localizableString];
//        [self.mtfMatKhauToken setTextError:[@"mat_khau_token_khong_dc_de_trong" localizableString]
//                                   forType:ExTextFieldTypeEmpty];
//        [self.mtfMatKhauTokenView setTextError:[@"mat_khau_token_khong_dc_de_trong" localizableString]
//                                       forType:ExTextFieldTypeEmpty];
//    }
}
- (IBAction)suKienBamNutSMS:(UIButton *)sender
{
    //NSLog(@"%s - %s : click lick click", __FILE__, __FUNCTION__);
    if(![self.mThongTinTaiKhoanVi.sPhoneAuthenticate isEqualToString:@""])
    {
        if((!self.mbtnSMS.selected && [self validateVanTay]) || !self.mbtnSMSView.selected)
        {
            self.mtfMatKhauToken.text = @"";
            self.mtfMatKhauTokenView.text = @"";
            [self hienThiHopThoaiHaiNutBamKieu:HOP_THOAI_XAC_NHAN_XAC_THUC_SMS cauThongBao:[NSString stringWithFormat:@"%@ %@", [@"thong_bao_ma_xac_thuc_duoc_gui_ve_so_dien_thoai" localizableString], self.mThongTinTaiKhoanVi.sPhoneAuthenticate]];
        }
    }
    else if(self.mThongTinTaiKhoanVi.walletLogin.length > 0){
        if((!self.mbtnSMS.selected && [self validateVanTay]) || !self.mbtnSMSView.selected)
        {
            self.mtfMatKhauToken.text = @"";
            self.mtfMatKhauTokenView.text = @"";
            [self hienThiHopThoaiHaiNutBamKieu:HOP_THOAI_XAC_NHAN_XAC_THUC_SMS cauThongBao:[NSString stringWithFormat:@"%@ %@", [@"thong_bao_ma_xac_thuc_duoc_gui_ve_so_dien_thoai" localizableString], self.mThongTinTaiKhoanVi.sPhoneAuthenticate]];
        }
    }
    else
    {
        [UIAlertView alert:[@"thong_bao_chua_dang_ky_so_dien_thoai" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
    }
}

- (IBAction)suKienBamNutEmail:(UIButton *)sender
{
    if(![self.mThongTinTaiKhoanVi.sThuDienTu isEqualToString:@""])
    {
        if((!self.mbtnEmail.selected && [self validateVanTay]) || !self.mbtnEmailView.selected)
        {
            self.mtfMatKhauToken.text = @"";
            self.mtfMatKhauTokenView.text = @"";
            [self hienThiHopThoaiHaiNutBamKieu:HOP_THOAI_XAC_NHAN_XAC_THUC_EMAIL cauThongBao:[NSString stringWithFormat:@"%@ %@", [@"thong_bao_ma_xac_thuc_duoc_gui_ve_thu_dien_tu" localizableString], self.mThongTinTaiKhoanVi.sThuDienTu]];
        }
    }
    else if (self.mThongTinTaiKhoanVi.walletLoginEmail.length > 0){
        if((!self.mbtnEmail.selected && [self validateVanTay]) || !self.mbtnEmailView.selected)
        {
            self.mtfMatKhauToken.text = @"";
            self.mtfMatKhauTokenView.text = @"";
            [self hienThiHopThoaiHaiNutBamKieu:HOP_THOAI_XAC_NHAN_XAC_THUC_EMAIL cauThongBao:[NSString stringWithFormat:@"%@ %@", [@"thong_bao_ma_xac_thuc_duoc_gui_ve_thu_dien_tu" localizableString], self.mThongTinTaiKhoanVi.walletLoginEmail]];
        }
    }
    else
    {
        [UIAlertView alert:[@"thong_bao_chua_dang_ky_thu_dien_tu" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
    }
}

- (IBAction)suKienBamNutMatKhauVanTay:(id)sender
{
    NSLog(@"%s - van tay!!!!", __FUNCTION__);
    self.mbtnToken.hidden = YES;
    self.mbtnPKI.hidden = YES;
    if (self.heightViewNhapXacThuc.constant > 0) {
        self.heightViewNhapXacThuc.constant = 0;
        self.mViewNhapToken.hidden = YES;
        [self hideViewNhapToken];
    }
    if (self.enableFaceID) {
        [self.btnVanTayMini setImage:[UIImage imageNamed:@"face_new_choose"] forState:UIControlStateNormal];
    } else {
        [self.btnVanTayMini setImage:[UIImage imageNamed:@"fingerv"] forState:UIControlStateNormal];
    }
    if(self.mbtnToken.enabled)
    {
        [self.mbtnToken setImage:[UIImage imageNamed:@"token"] forState:UIControlStateNormal];
        [self.mbtnToken setTitleColor:nil forState:UIControlStateNormal];
        [self.mbtnToken setSelected:NO];
    }
    if(self.mbtnPKI.enabled)
    {
        [self.mbtnPKI setImage:[UIImage imageNamed:@"pki"] forState:UIControlStateNormal];
        [self.mbtnPKI setTitleColor:nil forState:UIControlStateNormal];
        [self.mbtnPKI setSelected:NO];
    }
    if([self validateVanTay])
    {
        [self xuLySuKienHienThiChucNangVanTayVoiTieuDe:@"Đặt vân tay của bạn để thực hiện giao dịch"];
    }
    else {
        //NSLog(@"%s - chua validate", __FUNCTION__);
        if (self.enableFaceID) {
            [self.btnVanTayMini setImage:[UIImage imageNamed:@"face-id"] forState:UIControlStateNormal];
        } else {
            [self.btnVanTayMini setImage:[UIImage imageNamed:@"finger"] forState:UIControlStateNormal];
        }
    }
}

- (BOOL)validate
{
    BOOL flg = [self validateVanTay];
    if(flg)
    {
        if (!self.bHienViewXacThuc) {
            flg = [self.mtfMatKhauToken validate];
            if(!flg)
            {
                [self.mtfMatKhauToken show_error];
            }
        }
        else {
            flg = [self.mtfMatKhauTokenView validate];
            if(!flg)
            {
                [self.mtfMatKhauTokenView show_error];
            }
        }
    }
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return NO;
    }
    return flg;
}


- (void)xuLyKhiCoChucNangQuetVanTay
{
    //NSLog(@"%s - ============> co van tay", __FUNCTION__);
    [self.mbtnVanTay setHidden:YES];
    [self.mbtnPKI setHidden:YES];
    [self.mbtnToken setHidden:YES];
    _btnVanTayMini.enabled = YES;
}

- (void)xuLyKhiCoChucNangFaceID {
    //NSLog(@"%s - ============> co face id", __FUNCTION__);
    [self.mbtnVanTay setHidden:YES];
    [self.mbtnPKI setHidden:YES];
    [self.mbtnToken setHidden:YES];
    _btnVanTayMini.enabled = YES;
    [_btnVanTayMini setImage:[UIImage imageNamed:@"face-id"] forState:UIControlStateNormal];
}

- (void)xuLyKhiChiCoToken {
    //NSLog(@"%s - ============> co face id", __FUNCTION__);
    [self.mbtnVanTay setHidden:YES];
    [self.mbtnToken setHidden:NO];
}

- (void)xuLyKhiKhongCoChucNangQuetVanTay
{
    //NSLog(@"%s - ============> khong van tay", __FUNCTION__);
    [self.mbtnVanTay setHidden:YES];
    [self.btnVanTayMini setHidden:YES];
    [self.mbtnPKI setHidden:YES];
    _btnVanTayMini.enabled = NO;
    [self.mbtnToken setHidden:NO];
}

#pragma mark - xuly

- (void)xuLyKetNoiLaySoDuTaiKhoan
{
    self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_LAY_SO_DU_TAI_KHOAN;
    [GiaoDichMang ketNoiLaySoDuTaiKhoan:self];
}

- (void)xuLySuKienXacThucBangEmail
{
    if(!self.mbtnEmail.selected)
    {
        _mTypeAuthenticate = TYPE_AUTHENTICATE_EMAIL;
        [self.mbtnEmail setSelected:YES];
        [self.mbtnEmail setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        mTongSoThoiGian = THOI_GIAN_CHO_XAC_THUC_EMAIL;
        [self.mbtnEmail setTitle:[NSString stringWithFormat:@"%ld s", (long)mTongSoThoiGian] forState:UIControlStateNormal];
        [self.mbtnVanTay setHidden:YES];
        
        if(self.mbtnToken.enabled)
        {
            [self.mbtnToken setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
            [self.mbtnToken setTitleColor:nil forState:UIControlStateNormal];
            [self.mbtnToken setSelected:NO];
            [self.mbtnToken setEnabled:NO];
        }
        
        if(self.mbtnSMS.enabled)
        {
            [self.mbtnSMS setSelected:NO];
            [self.mbtnSMS setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
            [self.mbtnSMS setTitleColor:nil forState:UIControlStateNormal];
            [self.mbtnSMS setEnabled:NO];
        }
        
        self.mtfMatKhauToken.placeholder = [@"ma_xac_thuc" localizableString];
        [self.mtfMatKhauToken setTextError:[@"ma_xac_thuc_khong_duoc_de_trong" localizableString]
                                   forType:ExTextFieldTypeEmpty];
        
        NSString *sEmailAuthenticate = self.mThongTinTaiKhoanVi.sThuDienTu;
        [self xuLyKetNoiLayMaXacThucChuyenDenTaiKhoan:sEmailAuthenticate kieuXacThuc:self.mFuncID];
    }
}

- (void)xuLySuKienXacThucBangSMS
{
    if(!self.mbtnSMS.selected)
    {
        self.mTypeAuthenticate = TYPE_AUTHENTICATE_SMS;
        [self.mbtnSMS setSelected:YES];
        [self.mbtnSMS setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        mTongSoThoiGian = THOI_GIAN_CHO_XAC_THUC_SMS;
        [self.mbtnSMS setTitle:[NSString stringWithFormat:@"%ld s", (long)mTongSoThoiGian] forState:UIControlStateNormal];
        
        [self.mbtnVanTay setHidden:YES];
        
        if(self.mbtnToken.enabled)
        {
            [self.mbtnToken setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
            [self.mbtnToken setTitleColor:nil forState:UIControlStateNormal];
            [self.mbtnToken setSelected:NO];
            [self.mbtnToken setEnabled:NO];
        }
        
        if(self.mbtnEmail.enabled)
        {
            [self.mbtnEmail setSelected:NO];
            [self.mbtnEmail setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
            [self.mbtnEmail setTitleColor:nil forState:UIControlStateNormal];
            [self.mbtnEmail setEnabled:NO];
        }
        
        self.mtfMatKhauToken.placeholder = [@"ma_xac_thuc" localizableString];
        [self.mtfMatKhauToken setTextError:[@"ma_xac_thuc_khong_duoc_de_trong" localizableString]
                                   forType:ExTextFieldTypeEmpty];
        
        NSString *sPhoneAuthenticate = self.mThongTinTaiKhoanVi.sPhoneAuthenticate;
        [self xuLyKetNoiLayMaXacThucChuyenDenTaiKhoan:sPhoneAuthenticate kieuXacThuc:self.mFuncID];
    }
}

- (void)xuLyKetNoiLayMaXacThucChuyenDenTaiKhoan:(NSString*)sSendTo kieuXacThuc:(int)nKieu
{
    NSString *sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    int typeAuthenticate = 1;
    if([Common kiemTraLaMail:sSendTo])
        typeAuthenticate = 2;

    NSMutableString *sUrl = [[NSMutableString alloc] init];
    [sUrl appendFormat:@"https://vimass.vn/vmbank/services/account/getOTP?"];
    [sUrl appendFormat:@"id=%@&", sTaiKhoan];
    [sUrl appendFormat:@"appId=%d&", APP_ID];
    [sUrl appendFormat:@"funcId=%d&", nKieu];
    [sUrl appendFormat:@"typeAuthenticate=%d&", typeAuthenticate];
    [sUrl appendFormat:@"sendTo=%@", sSendTo];

    self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_LAY_MA_XAC_THUC;
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:self];
    [connect connectGet:sUrl withContent:@""];
    [connect release];
    [sUrl release];
}

#pragma mark - xuLyTimer

- (void)batDauDemThoiGian
{
    mTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(capNhatDemThoiGian) userInfo:nil repeats:YES];
}

- (void)ketThucDemThoiGian
{
    [self khoiTaoGiaoDienChuyenTien];
    if(mTimer)
    {
        [mTimer invalidate];
        mTimer = nil;
    }
}

- (void)capNhatDemThoiGian
{
    mTongSoThoiGian --;
    if(self.mTypeAuthenticate == TYPE_AUTHENTICATE_SMS)
    {
        if (self.bHienViewXacThuc) {
            self.mbtnSMSView.enabled = NO;
            [self.mbtnSMSView setTitle:[NSString stringWithFormat:@"%ld s", (long)mTongSoThoiGian] forState:UIControlStateNormal];
            self.mbtnSMSView.enabled = YES;
        }
        else {
            self.mbtnSMS.enabled = NO;
            [self.mbtnSMS setTitle:[NSString stringWithFormat:@"%ld s", (long)mTongSoThoiGian] forState:UIControlStateNormal];
            self.mbtnSMS.enabled = YES;
        }
    }
    else if(self.mTypeAuthenticate == TYPE_AUTHENTICATE_EMAIL)
    {
        if (self.bHienViewXacThuc) {
            self.mbtnEmailView.enabled = NO;
            [self.mbtnEmailView setTitle:[NSString stringWithFormat:@"%ld s", (long)mTongSoThoiGian] forState:UIControlStateNormal];
            self.mbtnEmailView.enabled = YES;
        }
        else {
            self.mbtnEmail.enabled = NO;
            [self.mbtnEmail setTitle:[NSString stringWithFormat:@"%ld s", (long)mTongSoThoiGian] forState:UIControlStateNormal];
            self.mbtnEmail.enabled = YES;
        }
    }
    if(mTongSoThoiGian == 0)
    {
        [self ketThucDemThoiGian];
    }
}

#pragma mark - public

- (void)refreshGiaoDienGiaoDich
{
    [self ketThucDemThoiGian];
    if([self.mThongTinTaiKhoanVi.nIsToken intValue] > 0)
    {
        [self suKienBamNutToken:self.mbtnToken];
    }
}

- (BOOL)validateVanTay
{
    return false;
}

- (void)xuLyThucHienKhiKiemTraThanhCongTraVeToken:(NSString*)sToken otp:(NSString*)sOtp
{
    
}

- (void)xuLyKetNoiThanhCong:(NSString*)sDinhDanhKetNoi thongBao:(NSString*)sThongBao ketQua:(id)ketQua
{
    
}

- (void)xuLyKetNoiThatBai:(NSString*)sDinhDanhKetNoi thongBao:(NSString*)sThongBao ketQua:(id)ketQua
{
    //NSLog(@"%s - sDinhDanhKetNoi : %@", __FUNCTION__, sDinhDanhKetNoi);
    dispatch_async(dispatch_get_main_queue(), ^{
        //NSLog(@"%s - an loading", __FUNCTION__);
        [self anLoading];
    });
    [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        if(alertView.tag == HOP_THOAI_XAC_NHAN_XAC_THUC_SMS)
        {
            [self.mtfMatKhauToken setKeyboardType:UIKeyboardTypeNumberPad];
            self.mtfMatKhauToken.text = @"";
            self.mtfMatKhauToken.secureTextEntry = NO;
            [self xuLySuKienXacThucBangSMS];
        }
        else if(alertView.tag == HOP_THOAI_XAC_NHAN_XAC_THUC_EMAIL)
        {
            [self.mtfMatKhauToken setKeyboardType:UIKeyboardTypeNumberPad];
            self.mtfMatKhauToken.text = @"";
            self.mtfMatKhauToken.secureTextEntry = NO;
            [self xuLySuKienXacThucBangEmail];
        }
    }
    else if(buttonIndex == 0)
    {
        if(alertView.tag == HOP_THOAI_XAC_NHAN_CHUYEN_TIEN_THANH_CONG)
        {
            //Xac nhan giao dich thanh cong
            [self.navigationController popViewControllerAnimated:YES];
        }else
        
        if(alertView.tag == 226||alertView.tag == 119)//Tao,sua san pham thanh cong
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


#pragma mark - DucNT_ServicePostDelegate
-(void)ketNoiThanhCong:(NSString *)sKetQua
{
    //NSLog(@"%s - mDinhDanhKetNoi : %@ - sKetQua : %@", __FUNCTION__, self.mDinhDanhKetNoi, sKetQua);
    NSDictionary *dicKetQua = [sKetQua objectFromJSONString];
    int nCode = [[dicKetQua objectForKey:@"msgCode"] intValue];
    NSString *message = [dicKetQua objectForKey:@"msgContent"];
    if (Localization.getCurrentLang == ENGLISH) {
        message = [dicKetQua objectForKey:@"msgContent_en"];
        if ([message isEmpty]) {
            message = [dicKetQua objectForKey:@"msgContent"];
        }
    }
    id result = [dicKetQua objectForKey:@"result"];
    if ([self.mDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_LAY_MA_XAC_THUC_TAO_SAN_PHAM]) {
        if (self.mTypeAuthenticate == 1) {
            mTongSoThoiGian = THOI_GIAN_CHO_XAC_THUC_SMS;
            [self batDauDemThoiGian];
        }
        else if (self.mTypeAuthenticate == 2) {
            mTongSoThoiGian = THOI_GIAN_CHO_XAC_THUC_EMAIL;
            [self batDauDemThoiGian];
        }
    }
    else if([self.mDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_LAY_MA_XAC_THUC])
    {
        if(nCode == 31)
        {
            //Chay giay thong bao
            mTongSoThoiGian = THOI_GIAN_CHO_XAC_THUC_SMS;
            [self batDauDemThoiGian];
        }
        else if(nCode == 32)
        {
            mTongSoThoiGian = THOI_GIAN_CHO_XAC_THUC_EMAIL;
            [self batDauDemThoiGian];
        }
        else
        {
            [UIAlertView alert:message withTitle:[@"thong_bao" localizableString] block:nil];
        }
    }
    else if ([self.mDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_THAY_DOI_TRANG_THAI_KHUYEN_MAI])
    {
        if(nCode==1)
        {
            self.mThongTinTaiKhoanVi.nPromotionStatus = [NSNumber numberWithBool:self.mswtKhuyenMai.isOn];
            [DucNT_LuuRMS luuThongTinTaiKhoanViSauDangNhap:self.mThongTinTaiKhoanVi];
            [self khoiTaoGiaoDienKhuyenMaiVaSoDu];
        }
        else
        {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:message];
            [self khoiTaoGiaoDienKhuyenMaiVaSoDu];
        }
    }
    else if([self.mDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_LAY_SO_DU_TAI_KHOAN])
    {
        if(nCode==1)
        {
            NSDictionary *dictResult = (NSDictionary*)result;
            NSNumber *amount = [dictResult valueForKey:@"amount"];
            NSNumber *promotionStatus = [dictResult valueForKey:@"promotionStatus"];
            NSNumber *promotionTotal = [dictResult valueForKey:@"promotionTotal"];
            NSNumber *totalCreateGift = [dictResult valueForKey:@"totalCreateGift"];
            NSNumber *totalGift = [dictResult valueForKey:@"totalGift"];
            self.mThongTinTaiKhoanVi.nAmount = amount;
            self.mThongTinTaiKhoanVi.nPromotionTotal = promotionTotal;
            self.mThongTinTaiKhoanVi.nPromotionStatus = promotionStatus;
            self.mThongTinTaiKhoanVi.totalCreateGift = totalCreateGift;
            self.mThongTinTaiKhoanVi.toTalGift = totalGift;
            [DucNT_LuuRMS luuThongTinTaiKhoanViSauDangNhap:self.mThongTinTaiKhoanVi];
            [self khoiTaoGiaoDienKhuyenMaiVaSoDu];
        }
    }
    else if([self.mDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_DANH_SACH_DIA_DIEM]){
        id temp = [dicKetQua objectForKey:@"list"];
        [self xuLyKetNoiThanhCong:self.mDinhDanhKetNoi thongBao:message ketQua:temp];
    }
    else
    {
        if(nCode == 1)
        {
//            //NSLog(@"%s ============> vao day %@", __FUNCTION__, result);
            [self xuLyKetNoiThanhCong:self.mDinhDanhKetNoi thongBao:message ketQua:result];
        }
        else
        {
            [self xuLyKetNoiThatBai:self.mDinhDanhKetNoi thongBao:message ketQua:dicKetQua];
        }
    }
    [self anLoading];
}

- (void)setAnimationChoSoTay:(UIButton *)btn{
    UIImageView *imgSoTay = [btn imageView];
    NSArray *arrSoTay = [NSArray arrayWithObjects:[UIImage imageNamed:@"iconSoTay5.png"], [UIImage imageNamed:@"iconSoTay4.png"], [UIImage imageNamed:@"iconSoTay3.png"], [UIImage imageNamed:@"iconSoTay2.png"], [UIImage imageNamed:@"iconSoTay.png"], [UIImage imageNamed:@"iconSoTay.png"], [UIImage imageNamed:@"iconSoTay.png"], nil];
    [imgSoTay setAnimationDuration:2.0];
    [imgSoTay setAnimationImages:arrSoTay];
    [imgSoTay setAnimationRepeatCount:0];
    [imgSoTay startAnimating];
}

- (void)addRightButtonForPicker:(ExTextField *)textView{
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 12)];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"muiten35x21.png"] forState:UIControlStateNormal];
    textView.rightView = btnRight;
    textView.rightViewMode = UITextFieldViewModeAlways;
}

- (void)hienThiLoading {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = [Localization languageSelectedStringForKey:@"dang_lay_du_lieu"];
}

- (void)hienThiLoadingLayDanhBa {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = [Localization languageSelectedStringForKey:@"dang_lay_danh_ba"];
}

- (void)hienThiLoadingChuyenTien {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = [Localization languageSelectedStringForKey:@"dang_xu_ly"];
}

- (void)anLoading {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)suKienChonQuangCao:(NSString *)sNameImage {
    [self suKienQuangCaoGoc:sNameImage];
}

- (void)suKienQuangCaoGoc:(NSString *)sNameImage {
    if ([sNameImage hasPrefix:@"vé phim"]) {
        //NSLog(@"%s - sNameImage : %@", __FUNCTION__, sNameImage);
        NSArray *arrSplit = [sNameImage componentsSeparatedByString:@"_"];
        if (arrSplit.count == 3) {
            if([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue])
            {
                GiaoDienDatVeXemPhim *muaTheTroChoiDienTuViewController = [[GiaoDienDatVeXemPhim alloc] initWithNibName:@"GiaoDienDatVeXemPhim" bundle:nil];
                muaTheTroChoiDienTuViewController.bChuyenGiaoDienQuangCao = YES;
                muaTheTroChoiDienTuViewController.sTenFilmTimKiem = [arrSplit objectAtIndex:2];
                [self.navigationController pushViewController:muaTheTroChoiDienTuViewController animated:YES];
                [muaTheTroChoiDienTuViewController release];
            }
        }
        else if (arrSplit.count == 2){
            GiaoDienDatVeXemPhim *muaTheTroChoiDienTuViewController = [[GiaoDienDatVeXemPhim alloc] initWithNibName:@"GiaoDienDatVeXemPhim" bundle:nil];
            muaTheTroChoiDienTuViewController.bChuyenGiaoDienQuangCao = YES;
            muaTheTroChoiDienTuViewController.sTenFilmTimKiem = [arrSplit objectAtIndex:1];
            [self.navigationController pushViewController:muaTheTroChoiDienTuViewController animated:YES];
            [muaTheTroChoiDienTuViewController release];
        }
        else {
            GiaoDienDatVeXemPhim *muaTheTroChoiDienTuViewController = [[GiaoDienDatVeXemPhim alloc] initWithNibName:@"GiaoDienDatVeXemPhim" bundle:nil];
            muaTheTroChoiDienTuViewController.bChuyenGiaoDienQuangCao = YES;
            [self.navigationController pushViewController:muaTheTroChoiDienTuViewController animated:YES];
            [muaTheTroChoiDienTuViewController release];
        }
    }
    else if ([sNameImage hasPrefix:@"đến tài khoản"]) {
        DucNT_ChuyenTienDenTaiKhoanViewController *chuyenTienDenTK = [[DucNT_ChuyenTienDenTaiKhoanViewController alloc] initWithNibName:@"DucNT_ChuyenTienDenTaiKhoanViewController" bundle:nil];
        chuyenTienDenTK.bChuyenGiaoDienQuangCao = YES;
        [self.navigationController pushViewController:chuyenTienDenTK animated:YES];
        [chuyenTienDenTK release];
    }
    else if ([sNameImage hasPrefix:@"đến ATM"]) {
        NSArray *arrSplit = [sNameImage componentsSeparatedByString:@"_"];
        GiaoDienChuyenTienATM *internet = [[GiaoDienChuyenTienATM alloc] initWithNibName:@"GiaoDienChuyenTienATM" bundle:nil];
        internet.nIndexBank = 0;
        if (arrSplit.count == 2) {
            NSString *sBank = arrSplit[1];
            if ([sBank.lowercaseString isEqualToString:@"techcombank"]) {
                internet.nIndexBank = 1;
            }
            else if ([sBank.lowercaseString isEqualToString:@"vietinbank"]) {
                internet.nIndexBank = 2;
            }
        }
        internet.bChuyenGiaoDienQuangCao = YES;
        [self.navigationController pushViewController:internet animated:YES];
        [internet release];
    }
    else if ([sNameImage hasPrefix:@"đến thẻ"]) {
        DucNT_ChuyenTienDenTheViewController *chuyenTienDenThe = [[DucNT_ChuyenTienDenTheViewController alloc]
                                                                  initWithNibName:@"DucNT_ChuyenTienDenTheViewController" bundle:nil];
        chuyenTienDenThe.bChuyenGiaoDienQuangCao = YES;
        [self.navigationController pushViewController:chuyenTienDenThe animated:YES];
        [chuyenTienDenThe release];
    }
    else if ([sNameImage hasPrefix:@"tiết kiệm"]) {
        GuiTietKiemViewController *guiTietKiemViewController = [[GuiTietKiemViewController alloc] initWithNibName:@"GuiTietKiemViewController" bundle:nil];
        [self.navigationController pushViewController:guiTietKiemViewController animated:YES];
        guiTietKiemViewController.bChuyenGiaoDienQuangCao = YES;
        [guiTietKiemViewController release];
    }
    else if ([sNameImage hasPrefix:@"vé máy bay"]) {
        GiaoDienDatVeMayBay *vc = [[GiaoDienDatVeMayBay alloc] initWithNibName:@"GiaoDienDatVeMayBay" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        vc.bChuyenGiaoDienQuangCao = true;
        [vc release];
    }
    else if ([sNameImage hasPrefix:@"đến tận nhà"]) {
        ChuyenTienTanNhaViewController *chuyenTienTanNhaViewController = [[ChuyenTienTanNhaViewController alloc] initWithNibName:@"ChuyenTienTanNhaViewController" bundle:nil];
        [self.navigationController pushViewController:chuyenTienTanNhaViewController animated:YES];
        chuyenTienTanNhaViewController.bChuyenGiaoDienQuangCao = YES;
        [chuyenTienTanNhaViewController release];
    }
    else if ([sNameImage hasPrefix:@"tặng quà"]) {
        DanhSachQuaTangViewController *danhSachQuaTangViewController = [[DanhSachQuaTangViewController alloc] initWithNibName:@"DanhSachQuaTangViewController" bundle:nil];
        [self.navigationController pushViewController:danhSachQuaTangViewController animated:YES];
        danhSachQuaTangViewController.bChuyenGiaoDienQuangCao = YES;
        [danhSachQuaTangViewController release];
    }
    else if ([sNameImage hasPrefix:@"đến cmnd"]) {
        GiaoDienChuyenTienDenCMND *internet = [[GiaoDienChuyenTienDenCMND alloc] initWithNibName:@"GiaoDienChuyenTienDenCMND" bundle:nil];
        [self.navigationController pushViewController:internet animated:YES];
        internet.bChuyenGiaoDienQuangCao = true;
        [internet release];
    }
    else if ([sNameImage hasPrefix:@"trả tiền vay"]) {
        GiaoDienTraCuuTienVay *danhSachQuaTangViewController = [[GiaoDienTraCuuTienVay alloc] initWithNibName:@"GiaoDienTraCuuTienVay" bundle:nil];
        [self.navigationController pushViewController:danhSachQuaTangViewController animated:YES];
        danhSachQuaTangViewController.bChuyenGiaoDienQuangCao = true;
        [danhSachQuaTangViewController release];
    }
    else if ([sNameImage hasPrefix:@"điện"]) {
        if ([sNameImage.lowercaseString containsString:@"điện thoại"]) {
            NSArray *arrSplit = [sNameImage componentsSeparatedByString:@"_"];
            if (arrSplit.count == 3) {
                if([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue])
                {
                    ThanhToanDienThoaiKhacViewController *thanhToanDienThoaiKhac = [[ThanhToanDienThoaiKhacViewController alloc] initWithNibName:@"ThanhToanDienThoaiKhacViewController" bundle:nil];
                    int nNhaMang = NHA_MANG_VIETTEL;
                    NSString *sNhaMang = arrSplit[1];
                    if ([sNhaMang isEqualToString:@"vina"]) {
                        nNhaMang = NHA_MANG_VINA;
                    }
                    else if ([sNhaMang hasPrefix:@"mob"]) {
                        nNhaMang = NHA_MANG_MOBI;
                    }
                    else if ([sNhaMang hasPrefix:@"vietn"] || [sNhaMang hasPrefix:@"gmo"]) {
                        nNhaMang = NHA_MANG_GMOBILE;
                    }
                    thanhToanDienThoaiKhac.mNhaMang = nNhaMang;
                    [self.navigationController pushViewController:thanhToanDienThoaiKhac animated:YES];
                    thanhToanDienThoaiKhac.bChuyenGiaoDienQuangCao = YES;
                    [thanhToanDienThoaiKhac release];
                }
            }
            else {
                ThanhToanDienThoaiKhacViewController *thanhToanDienThoaiKhac = [[ThanhToanDienThoaiKhacViewController alloc] initWithNibName:@"ThanhToanDienThoaiKhacViewController" bundle:nil];
                thanhToanDienThoaiKhac.mNhaMang = NHA_MANG_VIETTEL;
                [self.navigationController pushViewController:thanhToanDienThoaiKhac animated:YES];
                thanhToanDienThoaiKhac.bChuyenGiaoDienQuangCao = YES;
                [thanhToanDienThoaiKhac release];
            }

        }
        else {
            TraCuuTienDienViewController *traCuuTienDienViewController = [[TraCuuTienDienViewController alloc] initWithNibName:@"TraCuuTienDienViewController" bundle:nil];
            [self.navigationController pushViewController:traCuuTienDienViewController animated:YES];
            traCuuTienDienViewController.bChuyenGiaoDienQuangCao = true;
            [traCuuTienDienViewController release];
        }
    }
    else if ([sNameImage hasPrefix:@"nước"]) {
        GiaoDienThanhToanNuoc *internet = [[GiaoDienThanhToanNuoc alloc] initWithNibName:@"GiaoDienThanhToanNuoc" bundle:nil];
        [self.navigationController pushViewController:internet animated:YES];
        internet.bChuyenGiaoDienQuangCao = YES;
        [internet release];
    }
    else if ([sNameImage hasPrefix:@"internet"]) {
        GiaoDienThanhToanInternet *internet = [[GiaoDienThanhToanInternet alloc] initWithNibName:@"GiaoDienThanhToanInternet" bundle:nil];
        [self.navigationController pushViewController:internet animated:YES];
        internet.bChuyenGiaoDienQuangCao = YES;
        [internet release];
    }
    else if ([sNameImage hasPrefix:@"truyền hình"]) {
        GiaoDienTraCuuTruyenHinh *internet = [[GiaoDienTraCuuTruyenHinh alloc] initWithNibName:@"GiaoDienTraCuuTruyenHinh" bundle:nil];
        [self.navigationController pushViewController:internet animated:YES];
        internet.bChuyenGiaoDienQuangCao = YES;
        [internet release];
    }
    else if ([sNameImage hasPrefix:@"nạp tiền"]) {
        NapViTuTheNganHangViewController *napViTuTheNganHangViewController = [[NapViTuTheNganHangViewController alloc] initWithNibName:@"NapViTuTheNganHangViewController" bundle:nil];
        [self.navigationController pushViewController:napViTuTheNganHangViewController animated:YES];
        napViTuTheNganHangViewController.bChuyenGiaoDienQuangCao = YES;
        [napViTuTheNganHangViewController release];
    }
}

#pragma mark - click tab top
- (IBAction)suKienBamNutVi:(UIButton *)sender {
    [_imgTabTop setImage:[UIImage imageNamed:@"tab-cat1"]];
    [_btnTabTop1 setSelected:YES];
    [_btnTabTop2 setSelected:NO];
    [_btnTabTop3 setSelected:NO];
}

- (IBAction)suKienBamNutLienKet:(UIButton *)sender {
    NapViTuTheNganHangViewController *napViTuTheNganHangViewController = [[NapViTuTheNganHangViewController alloc] initWithNibName:@"NapViTuTheNganHangViewController" bundle:nil];
    [self.navigationController pushViewController:napViTuTheNganHangViewController animated:YES];
    [napViTuTheNganHangViewController release];
}

- (IBAction)suKienBamNutTaiKhoan:(UIButton *)sender {
    [_imgTabTop setImage:[UIImage imageNamed:@"tab-cat3"]];
    [_btnTabTop3 setSelected:YES];
    [_btnTabTop2 setSelected:NO];
    [_btnTabTop1 setSelected:NO];
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"huongdannaptien" ofType:@"txt"]];
    
    NSString *sXauHtml = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self.webGioiThieuTaiKhoan loadHTMLString:sXauHtml baseURL:nil];
}

#pragma mark - dealloc
- (void)dealloc
{
    if(_mlblSoDuKhuyenMai)
        [_mlblSoDuKhuyenMai release];
    if(_mlblSoDu)
        [_mlblSoDu release];
    if(_mswtKhuyenMai)
        [_mswtKhuyenMai release];
    [_mViewMain release];
    [_mtfMatKhauToken release];
    [_mDinhDanhKetNoi release];
    [_mbtnEmail release];
    [_mbtnSMS release];
    [_mbtnThucHien release];
    [_mbtnToken release];
    [_mbtnVanTay release];
    [_btnSoTay release];
    [_btnVanTayMini release];
    [_mViewNhapToken release];
    [_viewOptionTop release];
    [super dealloc];
}

@end
