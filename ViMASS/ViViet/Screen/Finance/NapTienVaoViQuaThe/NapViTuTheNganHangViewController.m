//
//  NapViTuTheNganHangViewController.m
//  ViViMASS
//
//  Created by DucBui on 4/20/15.
//
//

#import "NapViTuTheNganHangViewController.h"
#import "NapViTuTheKieuRedirectViewController.h"
#import "NganHangNapTien.h"
#import "GiaoDichMang.h"
#import "TheNapTien.h"
#import "ContactScreen.h"
#import "GiaoDienBangMaZipCode.h"
#import "DucNT_TaiKhoanThuongDungObject.h"
#import "GiaoDienTaoTheLuu.h"
#import "ViewXacThuc.h"
#import "DucNT_DanhSachTaiKhoanThuongDungControllerViewController.h"
#import "GiaoDienThongTinPhim.h"
#import "HuongDanNapTienViewController.h"
#import "ItemTaiKhoanLienKet.h"
#import "GiaoDienDanhSachTaiKhoanLienKet.h"
@interface NapViTuTheNganHangViewController () <DucNT_ServicePostDelegate, UIPickerViewDataSource, UIPickerViewDelegate, ViewXacThucDelegate, UITextFieldDelegate, UIAlertViewDelegate, GiaoDienDanhSachTaiKhoanLienKetDelegate>
{
    int mBuocKhoiTao;
    int nHinhThucNap;
    int nLoaiTheQuocTe;
    int nLoaiTheCao;
    int nSTT;
    int nIndexTheLuu;
    int nTimeDemGiay;
    BOOL bKiemTraQuocTe;
    BOOL bCheckTrangThaiTKLK;

    NSString *sCountryCode;
    NSString *mOtpDirect;
    NSMutableArray *dsTaiKhoanThuongDung;
    NSMutableArray *dsCountry;
    ViewXacThuc *viewXacThuc;
    NSTimer *timer;
    UIAlertView *alertTimeXacNhan;
    UIAlertView *alertTaiKhoanLienKet;
    DucNT_TaiKhoanThuongDungObject *mTaiKhoanSoTay;
    ItemTaiKhoanLienKet *tkLienKetHienTai;
    long backgroundTime;
}
@property (nonatomic, retain) NSString *sIdGiaoDichTKLK;
@property (nonatomic, retain) NSString *mIDOtpDirect;
@property (nonatomic, retain) NSArray *mDanhSachNganHangHoTroNapTien;
@property (nonatomic, retain) NganHangNapTien *mNganHangNapTienDaChon;
@property (nonatomic, retain) NSString *sIdTrangThaiTKLK;;
@end

@implementation NapViTuTheNganHangViewController

#pragma mark - life circle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    self.sIdTrangThaiTKLK = @"";
    self.sIdGiaoDichTKLK = @"";
    bKiemTraQuocTe = YES;
    sCountryCode = @"VN";
    nLoaiTheQuocTe = 1;
    nHinhThucNap = -1;
    nLoaiTheCao = 0;
    nIndexTheLuu = 0;
    nSTT = -1;
    [self khoiTaoBanDau];
    [self khoiTaoGiaoDien];
    bool bDaDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue];
    if(bDaDangNhap)
    {
        self.mtfSoViCanNapTien.text = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
        self.edViTheCao.text = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
        self.edViCanNapTheLuu.text = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
        self.edViCanNapQT.text = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    }

    self.edHo.delegate = self;
    self.mtfTenChuThe.delegate = self;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateThongTinTaiKhoanThuongDung:) name:KEY_TAI_KHOAN_THUONG_DUNG object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateThongTinThe:) name:KEY_TAI_KHOAN_NAP_TIEN object:nil];

    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 34, 34);
    [button setImage:[UIImage imageNamed:@"hdsd-icon"]forState:UIControlStateNormal];

    button.backgroundColor = [UIColor clearColor];
    button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [button addTarget:self action:@selector(suKienBamNutHuongDanNapTien:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *leftItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];

    UIButton * button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(0, 0, 34, 34);
    [button2 setImage:[UIImage imageNamed:@"icon10"]forState:UIControlStateNormal];

    button2.backgroundColor = [UIColor clearColor];
    button2.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [button2 addTarget:self action:@selector(suKienBamNutChuyenHuongDanNapTien:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *leftItem2 = [[[UIBarButtonItem alloc] initWithCustomView:button2] autorelease];

    UIBarButtonItem *negativeSeperator = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];

    if (SYSTEM_VERSION_LESS_THAN(@"11"))
        negativeSeperator.width = -10;
    else {
        negativeSeperator.width = -15;
        [button.widthAnchor constraintEqualToConstant:34].active = YES;
        [button.heightAnchor constraintEqualToConstant:34].active = YES;
        [button2.widthAnchor constraintEqualToConstant:34].active = YES;
        [button2.heightAnchor constraintEqualToConstant:34].active = YES;
    }

    self.navigationItem.rightBarButtonItems = @[negativeSeperator, leftItem2, leftItem];

    self.btnTheQuocTe.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.btnTheNoiDia.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.btnTheCao.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.btnTheLuu.titleLabel.textAlignment = NSTextAlignmentCenter;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(suKienAppToBackground:) name:UIApplicationDidEnterBackgroundNotification object:[UIApplication sharedApplication]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(suKienAppToForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.btnTheLienKet.titleLabel setTextAlignment:NSTextAlignmentCenter];
}

- (void)suKienAppToBackground:(NSNotification*)sender {
    backgroundTime = [[NSDate date] timeIntervalSince1970];
    NSLog(@"%s - backgroundTime : %ld", __FUNCTION__, backgroundTime);
}

- (void)suKienAppToForeground:(NSNotification*)sender {
    long currentTime = [[NSDate date] timeIntervalSince1970];
    long timeBetween = currentTime - backgroundTime;
    if (nTimeDemGiay - timeBetween > 0) {
        nTimeDemGiay = nTimeDemGiay - (int)timeBetween;
    }
    else {
        nTimeDemGiay = 0;
    }
    NSLog(@"%s - currentTime : %ld", __FUNCTION__, currentTime);
}

- (void)setAnimationChoSoTayThuongDung:(UIButton *)btn{
    UIImageView *imgSoTay = [btn imageView];
    NSArray *arrSoTay = [NSArray arrayWithObjects:[UIImage imageNamed:@"Tim32_5"], [UIImage imageNamed:@"Tim32_4"], [UIImage imageNamed:@"Tim32_3"], [UIImage imageNamed:@"Tim32_2"], [UIImage imageNamed:@"Tim32_5"], [UIImage imageNamed:@"Tim32_5"], [UIImage imageNamed:@"Tim32_5"], nil];
    [imgSoTay setAnimationDuration:1.85];
    [imgSoTay setAnimationImages:arrSoTay];
    [imgSoTay setAnimationRepeatCount:0];
    [imgSoTay startAnimating];
}

- (void)suKienBamNutChuyenHuongDanNapTien:(UIButton *)btn {
    HuongDanNapTienViewController *huongDanNapTienViewController = [[HuongDanNapTienViewController alloc] initWithNibName:@"HuongDanNapTienViewController" bundle:nil];
    [self.navigationController pushViewController:huongDanNapTienViewController animated:YES];
    [huongDanNapTienViewController release];
}

- (void)suKienBamNutHuongDanNapTien:(UIButton *)btn {
    GiaoDienThongTinPhim *vc = [[GiaoDienThongTinPhim alloc] initWithNibName:@"GiaoDienThongTinPhim" bundle:nil];
    if (nHinhThucNap == 0) {
        vc.nOption = HUONG_DAN_NAP_TIEN_BANG_THE;
    }
    else if (nHinhThucNap == 1) {
        vc.nOption = HUONG_DAN_NAP_TIEN_BANG_QUOC_TE;
    }
    else if (nHinhThucNap == 2) {
        vc.nOption = HUONG_DAN_NAP_TIEN_BANG_THE_CAO;
    }
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self setAnimationChoSoTayThuongDung:self.btnSoLuuDirect];
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setAnimationChoSoTayThuongDung:self.btnSoLuuQT];
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setAnimationChoSoTay:self.btnSoTayThuongDung];
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setAnimationChoSoTayThuongDung:self.btnSoTayThuongDungLoaiThe];
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setAnimationChoSoTay:self.btnSoTayNoiDia];
        });
    });
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    UIImageView *imgSoTay = [self.btnSoLuuDirect imageView];
    [imgSoTay stopAnimating];

    UIImageView *imgSoTay2 = [self.btnSoLuuQT imageView];
    [imgSoTay2 stopAnimating];

    UIImageView *imgSoTay1 = [self.btnSoTayThuongDung imageView];
    [imgSoTay1 stopAnimating];

    UIImageView *imgSoTay4 = [self.btnSoTayThuongDungLoaiThe imageView];
    [imgSoTay4 stopAnimating];
    if (timer) {
        [timer invalidate];
    }
}

-(void)updateThongTinThe:(NSNotification *)notification
{
    if([[notification name] isEqualToString:KEY_TAI_KHOAN_NAP_TIEN])
    {
        mTaiKhoanSoTay = [notification object];
        NSLog(@"%s - mTaiKhoanSoTay.sId : %@", __FUNCTION__, mTaiKhoanSoTay.sId);
        if (mTaiKhoanSoTay.nType == TAI_KHOAN_THE_DIRECT) {
            [self suKienChonTheNoiDia:nil];
            nHinhThucNap = 3;
            self.mtfSoTien.text = [Common hienThiTienTe:mTaiKhoanSoTay.nAmount];
            self.mtvNoiDung.text = mTaiKhoanSoTay.noiDung;
            for (NganHangNapTien *nganHangNapTien in _mDanhSachNganHangHoTroNapTien) {
                for (TheNapTien *theNapTien in nganHangNapTien.danhSachTheNapTien) {
                    NSString *idBank = theNapTien.idBank;
                    if ([idBank isEqualToString:[NSString stringWithFormat:@"%d", mTaiKhoanSoTay.nBankCode]]) {
                        _mtfChonNganHang.text = nganHangNapTien.tenBank;
                        if([nganHangNapTien.trangThaiDirect intValue] != 0)
                        {
                            mBuocKhoiTao = 2;
                            self.mtfSoThe.text = mTaiKhoanSoTay.sCardNumber;
                            self.mtfTenChuThe.text = mTaiKhoanSoTay.sCardOwnerName;
                            self.mtfThangMoThe.text = [NSString stringWithFormat:@"%d", mTaiKhoanSoTay.cardMonth];
                            self.mtfNamMoThe.text = [NSString stringWithFormat:@"%d", mTaiKhoanSoTay.cardYear];
                            if ([mTaiKhoanSoTay.otpGetType isEqualToString:@"SMS"]) {
                                [_mbtnChonMaXacThucNhanQuaSMS setSelected:YES];
                                [_mbtnChonMaXacThucSuDungToken setSelected:NO];
                            }
                            else{
                                [_mbtnChonMaXacThucNhanQuaSMS setSelected:NO];
                                [_mbtnChonMaXacThucSuDungToken setSelected:YES];
                            }
                            [self khoiTaoGiaoDien];
                        }
                        self.mNganHangNapTienDaChon = nganHangNapTien;
                        return;
                    }
                }
            }
        }
        else{
            [self suKienChonTheQuocTe:nil];
            nHinhThucNap = 3;
//            self.edViCanNapQT.text = mTaiKhoanSoTay.sToAccWallet;
            self.edSoThe.text = mTaiKhoanSoTay.sCardNumber;
            self.edSoTienQT.text = [Common hienThiTienTe:mTaiKhoanSoTay.nAmount];
            self.edCVV.text = mTaiKhoanSoTay.cvv;
            self.edHo.text = mTaiKhoanSoTay.sCardOwnerName;
            if (mTaiKhoanSoTay.nType == TAI_KHOAN_VISA) {
                nLoaiTheQuocTe = 1;
                self.edLoaiThe.text = @"Visa";
            }
            else if (mTaiKhoanSoTay.nType == TAI_KHOAN_MASTER_CARD){
                nLoaiTheQuocTe = 2;
                self.edLoaiThe.text = @"MasterCard";
            }
            else{
                nLoaiTheQuocTe = 3;
                self.edLoaiThe.text = @"JCB";
            }
            self.edThang.text = [NSString stringWithFormat:@"%d", mTaiKhoanSoTay.cardMonth];
            self.edNam.text = [NSString stringWithFormat:@"%d", mTaiKhoanSoTay.cardYear + 2000];
        }
    }
}

-(void)updateThongTinTaiKhoanThuongDung:(NSNotification *)notification
{
    NSLog(@"%s - nhan thong tin : %@", __FUNCTION__, [notification name]);
    if([[notification name] isEqualToString:KEY_TAI_KHOAN_THUONG_DUNG])
    {
        DucNT_TaiKhoanThuongDungObject *mTaiKhoanThuongDung = [notification object];
        NSLog(@"%s - sId : %@", __FUNCTION__, mTaiKhoanThuongDung.sToAccWallet);
        self.edViTheCao.text = mTaiKhoanThuongDung.sToAccWallet;
        self.edViCanNapQT.text = mTaiKhoanThuongDung.sToAccWallet;
        self.edViCanNapTheLuu.text = mTaiKhoanThuongDung.sToAccWallet;
        self.mtfSoViCanNapTien.text = mTaiKhoanThuongDung.sToAccWallet;

        self.mtfSoTien.text = [Common hienThiTienTe:mTaiKhoanThuongDung.nAmount];
        self.edSoTienQT.text = [Common hienThiTienTe:mTaiKhoanThuongDung.nAmount];
        self.edSoTienTheLuu.text = [Common hienThiTienTe:mTaiKhoanThuongDung.nAmount];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSRange lowercaseCharRange = [string rangeOfCharacterFromSet:[NSCharacterSet lowercaseLetterCharacterSet]];

    if (lowercaseCharRange.location != NSNotFound) {
        textField.text = [textField.text stringByReplacingCharactersInRange:range
                                                                 withString:[string uppercaseString]];
        return NO;
    }
    return YES;
}

- (void)xuLySuKienBamNutVanTay{
    NSLog(@"%s - bam van tay", __FUNCTION__);
    [self xuLySuKienDangNhapVanTay];
}

- (void)xuLySuKienDangNhapVanTay
{
    [self xuLySuKienHienThiChucNangVanTayVoiTieuDe:[@"su_dung_van_tay_dang_nhap_tai_khoan_token_VIMASS" localizableString]];
}

- (void)xuLySuKienXacThucVanTayThanhCong
{
    [viewXacThuc xuLyKhiXacThucVanTayThanhCong];
}

- (void)xuLyThucHienKhiKiemTraThanhCongTraVeToken:(NSString *)sToken otp:(NSString *)sOtp{
    DucNT_TaiKhoanThuongDungObject *obj = [dsTaiKhoanThuongDung objectAtIndex:nIndexTheLuu];
    if (obj.sId.length > 0) {
        self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_XOA_TAI_KHOAN_THUONG_DUNG;
        NSLog(@"%s - self.mDinhDanhKetNoi : %@", __FUNCTION__, self.mDinhDanhKetNoi);
        [GiaoDichMang ketNoiXoaTaiKhoanThuongDung:obj.sId kieuLay:obj.nType token:sToken otp:sOtp typeAuthenticate:0 noiNhanKetQua:self];
    }
}

- (void)khoiTaoViewXacThuc{
    if(!viewXacThuc)
    {
        viewXacThuc = [[[NSBundle mainBundle] loadNibNamed:@"ViewXacThuc" owner:self options:nil] objectAtIndex:0];
        viewXacThuc.mDelegate = self;
        viewXacThuc.mThongTinVi = self.mThongTinTaiKhoanVi;
        viewXacThuc.frame = self.view.bounds;

        if([self kiemTraCoChucNangQuetVanTay])
        {
            viewXacThuc.mbtnVanTay.hidden = NO;
        }
        else
        {
            viewXacThuc.mbtnVanTay.hidden = YES;
        }
        [self.view addSubview:viewXacThuc];
    }
    viewXacThuc.lblTitle.text = @"Xác thực";
    [viewXacThuc setHidden:NO];
}
#pragma mark - khoiTao

- (void)khoiTaoBanDau
{
//    [self addButtonBack];
    self.mbtnTiepTuc.hidden = NO;
    self.mViewMain.layer.masksToBounds = YES;
//    _mViewMain.layer.masksToBounds = YES;
    self.mViewMain.layer.cornerRadius = 4.0f;
    self.mViewMain.layer.borderWidth = 1.0f;
    self.mViewMain.layer.borderColor = [UIColor whiteColor].CGColor;
    mBuocKhoiTao = 1;
//    self.navigationItem.title = [@"nap_vi_tu_the_ngan_hang" localizableString];
    [self addTitleView:[@"nap_tien_tu_the_bank2" localizableString]];
    [self hienThiSoPhiCuaSoTien:0];
    [self khoiTaoViewThongTinBuoc1];
    [self khoiTaoViewThongTinBuoc2];
    [self.btnTheLienKet setTitle:[@"financer_viewer_bussiness_link_accounts" localizableString] forState:UIControlStateNormal];
    [self.btnTheLuu setTitle:[@"financer_viewer_ordinary_account" localizableString] forState:UIControlStateNormal];
    [self.btnTheQuocTe setTitle:[@"the_quoc_te" localizableString] forState:UIControlStateNormal];
    [self.mbtnTiepTuc setTitle:[@"label_next" localizableString] forState:UIControlStateNormal];
    [self.btnTiepTucTKLK setTitle:[@"label_next" localizableString] forState:UIControlStateNormal];
}

- (void)didSelectBackButton{
    [super didSelectBackButton];
    bKiemTraQuocTe = NO;
}

- (void)khoiTaoViewThongTinBuoc1
{
    [_mViewThongTinBuoc1 setHidden:NO];
    [_mtfSoViCanNapTien setPlaceholder:[@"vi_can_nap" localizableString]];
    _mtfSoViCanNapTien.inputAccessoryView = nil;
    [_mtfSoViCanNapTien setTextError:[@"lg - SO_VI_KHONG_DUOC_DE_TRONG" localizableString] forType:ExTextFieldTypeEmpty];

    [_mtfSoTien setPlaceholder:[@"place_holder_so_tien" localizableString]];
    _mtfSoTien.inputAccessoryView = nil;
    [_mtfSoTien setType:ExTextFieldTypeMoney];
    [_mtfSoTien setTextError:[@"so_tien_khong_duoc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    
    [_mtfNoiDung setPlaceholder:[@"place_holder_noi_dung" localizableString]];
    _mtfNoiDung.inputAccessoryView = nil;
    _mtvNoiDung.inputAccessoryView = nil;
    
    [self khoiTaoPickerChonNganHang];

    CGRect rectSoTien = self.mViewThongTinBuoc1.frame;
    CGRect rectTiepTuc = self.mbtnTiepTuc.frame;
    rectTiepTuc.origin.y = rectSoTien.origin.y + rectSoTien.size.height + 8;
    NSLog(@"%s - rectTiepTuc.origin.y : %f", __FUNCTION__, rectTiepTuc.origin.y);
    self.mbtnTiepTuc.frame = rectTiepTuc;
    CGRect rectMain = self.mViewMain.frame;
    rectMain.size.height = rectTiepTuc.origin.y + rectTiepTuc.size.height + 20;
    self.mViewMain.frame = rectMain;
}

- (void)khoiTaoViewThongTinBuoc2
{
    [_mtfSoThe setPlaceholder:[@"so_the_ngan_hang_16" localizableString]];
    [_mtfSoThe setTextError:[@"so_the_ngan_hang_khong_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    [_mtfSoThe setType:ExTextFieldTypeCardPaymentNumber];
    [_mtfSoThe setMax_length:16];
    _mtfSoThe.inputAccessoryView = nil;
    
    [_mtfTenChuThe setPlaceholder:[@"ten_chu_the" localizableString]];
    [_mtfTenChuThe setTextError:[@"ten_chu_the_khong_duoc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    _mtfTenChuThe.inputAccessoryView = nil;
    
    _mtfThangMoThe.inputAccessoryView = nil;
    [_mtfThangMoThe setTextError:[@"the_ngan_hang_thang_mo_the" localizableString] forType:ExTextFieldTypeEmpty];
    [_mtfThangMoThe setMax_length:2];
    _mtfThangMoThe.textAlignment = NSTextAlignmentCenter;
    
    _mtfNamMoThe.inputAccessoryView = nil;
    [_mtfNamMoThe setTextError:[@"tu_nam" localizableString] forType:ExTextFieldTypeEmpty];
    [_mtfNamMoThe setMax_length:2];
    _mtfNamMoThe.textAlignment = NSTextAlignmentCenter;
    
    [_mbtnChonMaXacThucNhanQuaSMS setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
    [_mbtnChonMaXacThucNhanQuaSMS setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
    [_mbtnChonMaXacThucSuDungToken setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateSelected];
    [_mbtnChonMaXacThucSuDungToken setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
    
    [_mbtnChonMaXacThucNhanQuaSMS setSelected:YES];
    mOtpDirect = otpGetTypeSMS;
}

- (void)khoiTaoPickerChonNganHang
{
    self.mDanhSachNganHangHoTroNapTien = [NganHangNapTien layDanhSachNganHangNapTien];

    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneChonNganHang:)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelChonNganHang:)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

    [toolBar setItems:[NSArray arrayWithObjects:cancelButton, flexSpace, doneButton, nil]];

    UIPickerView *pickerChonNganHang = [[UIPickerView alloc] init];
    pickerChonNganHang.dataSource = self;
    pickerChonNganHang.delegate = self;
    _mtfChonNganHang.inputAccessoryView = toolBar;
    _mtfChonNganHang.inputView = pickerChonNganHang;
    _mtfChonNganHang.text = [@"title_hien_thi_chon_ngan_hang" localizableString];
    [pickerChonNganHang release];
}

- (void)doneChonNganHang:(UIBarButtonItem *)sender{
    NSLog(@"%s - START", __FUNCTION__);
    if(!self.mNganHangNapTienDaChon)
    {
        _mtfChonNganHang.text = [@"title_hien_thi_chon_ngan_hang" localizableString];
        [self khoiTaoGiaoDien];
    }
    else
    {
        NSLog(@"%s - [self.mNganHangNapTienDaChon.trangThaiDirect intValue] : %d", __FUNCTION__, [self.mNganHangNapTienDaChon.trangThaiDirect intValue]);
        if([self.mNganHangNapTienDaChon.trangThaiDirect intValue] != 0)
        {
            mBuocKhoiTao = 2;
            switch (mBuocKhoiTao) {
                case 1:
                    [self khoiTaoGiaoDienBuoc1];
                    break;
                default:
                    [self khoiTaoGiaoDienBuoc2];
                    break;
            }
        }
//        else
//        {
//            mBuocKhoiTao = 1;
//            [self khoiTaoGiaoDien];
//        }
//
    }
    [_mtfChonNganHang resignFirstResponder];
}

- (void)cancelChonNganHang:(UIBarButtonItem *)sender{
    [_mtfChonNganHang resignFirstResponder];
}

- (void)khoiTaoGiaoDien
{
    switch (mBuocKhoiTao) {
        case 1:
            [self khoiTaoGiaoDienBuoc1];
            break;
        default:
            [self khoiTaoGiaoDienBuoc2];
            break;
    }
    [self khoiTaoViewThongBao];
    if ([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        [self suKienChonTaiKhoanLienKet:self.btnTiepTucTKLK];
    }
    else {
        nHinhThucNap = -1;
        [self suKienChonTheNoiDia:self.btnTheNoiDia];
    }
}

- (void)khoiTaoGiaoDienBuoc1
{
    if (!self.mtfChonNganHang.rightView) {
        UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 12)];
        [btnRight setBackgroundImage:[UIImage imageNamed:@"muiten35x21.png"] forState:UIControlStateNormal];
        self.mtfChonNganHang.rightView = btnRight;
        self.mtfChonNganHang.rightViewMode = UITextFieldViewModeAlways;
    }
    self.mtfSoTien.text = @"";
    [_mViewThongTinBuoc1 setHidden:NO];
    [_mViewThongTinBuoc2 setHidden:YES];
    NSLog(@"========= 1");
    [_viewNapTheCao setHidden:YES];
    NSLog(@"========= 2");
    [_viewQuocTe setHidden:YES];
    [_viewQuocTe2 setHidden:YES];
    [_viewTheLuu setHidden:YES];
    CGRect rViewMain = self.mViewMain.frame;
    CGRect rectViewTop = _viewTop.frame;
    CGRect rViewThongTinBuoc1 = _mViewThongTinBuoc1.frame;
    CGRect rButtonTiepTuc = _mbtnTiepTuc.frame;
    
    rViewThongTinBuoc1.origin.x = 0;
    rViewThongTinBuoc1.origin.y = self.viewTop.frame.size.height + 8;
    
    rButtonTiepTuc.origin.y = rViewThongTinBuoc1.origin.y + rViewThongTinBuoc1.size.height + 8;
    
//    rViewMain.size.height = rButtonTiepTuc.size.height + rButtonTiepTuc.origin.y + 8;

    _mViewThongTinBuoc1.frame = rViewThongTinBuoc1;
    _mbtnTiepTuc.frame = rButtonTiepTuc;
    if (![self.mViewMain.subviews containsObject:_mViewThongTinBuoc1]) {
        [self.mViewMain addSubview:_mViewThongTinBuoc1];
    }

    rViewMain.size.height = rButtonTiepTuc.origin.y + rButtonTiepTuc.size.height + 20;
    self.mViewMain.frame = rViewMain;

    [_mScrv setContentSize:CGSizeMake(_mScrv.frame.size.width, 2 * rViewMain.origin.y + rViewMain.size.height + rectViewTop.size.height + 10)];
    
    CGRect rtfSoViCanNap = _mtfSoViCanNapTien.frame;
    CGRect rbtnDanhBaViCanNap = _mbtnDanhBaViCanNap.frame;
    //Neu chua dang nhap
    if(![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue])
    {
        [_mbtnDanhBaViCanNap setHidden:YES];
        rtfSoViCanNap.size.width = rbtnDanhBaViCanNap.origin.x + rbtnDanhBaViCanNap.size.width - rtfSoViCanNap.origin.x;
        
    }
    else
    {
        [_mbtnDanhBaViCanNap setHidden:NO];
        rtfSoViCanNap.size.width = rbtnDanhBaViCanNap.origin.x - 8 - rtfSoViCanNap.origin.x;
    }
    _mtfSoViCanNapTien.frame = rtfSoViCanNap;
    _mbtnDanhBaViCanNap.frame = rbtnDanhBaViCanNap;
}

- (void)khoiTaoGiaoDienBuoc2
{
    [_mViewThongTinBuoc1 setHidden:NO];
    [_mViewThongTinBuoc2 setHidden:NO];
    CGRect rViewMain = self.mViewMain.frame;
    CGRect rectViewTop = _viewTop.frame;
    CGRect rViewThongTinBuoc1 = _mViewThongTinBuoc1.frame;
    CGRect rViewThongTinBuoc2 = _mViewThongTinBuoc2.frame;
    CGRect rButtonTiepTuc = _mbtnTiepTuc.frame;
    rViewThongTinBuoc2.origin.y = rViewThongTinBuoc1.origin.y + rViewThongTinBuoc1.size.height + 8;
    rButtonTiepTuc.origin.y = rViewThongTinBuoc2.origin.y + rViewThongTinBuoc2.size.height + 8;
    rViewMain.size.height = rButtonTiepTuc.size.height + rButtonTiepTuc.origin.y + 8;
    self.mViewMain.frame = rViewMain;
    _mViewThongTinBuoc1.frame = rViewThongTinBuoc1;
    _mViewThongTinBuoc2.frame = rViewThongTinBuoc2;
    _mbtnTiepTuc.frame = rButtonTiepTuc;
    [self.mViewMain addSubview:_mViewThongTinBuoc2];
    [_mScrv setContentSize:CGSizeMake(_mScrv.frame.size.width, 2*rViewMain.origin.y + rViewMain.size.height + rectViewTop.size.height + 10)];
    
    CGRect rTfSoThe = _mtfSoThe.frame;
    CGRect rViewChuaDanhBaVaThuongDung = _mViewChuaNutDanhBaVaThuongDung.frame;
    
    //Neu chua dang nhap
    if(![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue])
    {
        [_mViewChuaNutDanhBaVaThuongDung setHidden:YES];
        rTfSoThe.size.width = rViewChuaDanhBaVaThuongDung.origin.x + rViewChuaDanhBaVaThuongDung.size.width - rTfSoThe.origin.x;

    }
    else
    {
        [_mViewChuaNutDanhBaVaThuongDung setHidden:NO];
        rTfSoThe.size.width = rViewChuaDanhBaVaThuongDung.origin.x - 8 - rTfSoThe.origin.x;
    }
    _mtfSoThe.frame = rTfSoThe;
    _mViewChuaNutDanhBaVaThuongDung.frame = rViewChuaDanhBaVaThuongDung;
}

- (void)khoiTaoGiaoDienTheQuocTe{
    mBuocKhoiTao = 1;
    [_viewTheLuu setHidden:YES];
    [_mViewThongTinBuoc1 setHidden:YES];
    [_mViewThongTinBuoc2 setHidden:YES];
    [_viewNapTheCao setHidden:YES];

    [self.viewQuocTe setHidden:NO];
    self.edSoTienQT.text = @"";
    [self.edSoTienQT setType:ExTextFieldTypeMoney];

    self.edSoThe.text = @"";
    self.edNoiDungQT.text = @"";
    self.edCVV.text = @"";
    [self.edCVV setMax_length:4];

    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger year = [components year];
    self.edNam.text = [NSString stringWithFormat:@"%d", ((int)year + 1)];

    if (!self.edLoaiThe.rightView) {
        UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 12)];
        [btnRight setBackgroundImage:[UIImage imageNamed:@"muiten35x21.png"] forState:UIControlStateNormal];
        self.edLoaiThe.rightView = btnRight;
        self.edLoaiThe.rightViewMode = UITextFieldViewModeAlways;
    }

    CGRect rViewMain = self.mViewMain.frame;
    CGRect rectViewTop = _viewTop.frame;
    CGRect rViewThe = self.viewQuocTe.frame;
    rViewThe.origin.y = rectViewTop.origin.y + rectViewTop.size.height + 10;
    rViewThe.size.width = rViewMain.size.width;
    self.viewQuocTe.frame = rViewThe;
    if (![self.mViewMain.subviews containsObject:self.viewQuocTe]) {
        [self.mViewMain addSubview:self.viewQuocTe];
    }
    [_mScrv setContentSize:CGSizeMake(_mScrv.frame.size.width, 2 * rViewMain.origin.y + rViewMain.size.height + rectViewTop.size.height + 10)];

    UIPickerView *pickerChonNganHang = [[UIPickerView alloc] init];
    pickerChonNganHang.dataSource = self;
    pickerChonNganHang.delegate = self;
    pickerChonNganHang.tag = 100;

    self.edLoaiThe.inputView = pickerChonNganHang;
    self.edLoaiThe.text = @"Visa";
    [pickerChonNganHang release];

    [self.edSoThe setMax_length:16];

    CGRect rectSoTien = self.viewQuocTe.frame;
    CGRect rectTiepTuc = self.mbtnTiepTuc.frame;
    rectTiepTuc.origin.y = rectSoTien.origin.y + rectSoTien.size.height + 12;
    NSLog(@"%s - rectTiepTuc.origin.y : %f", __FUNCTION__, rectTiepTuc.origin.y);
    self.mbtnTiepTuc.frame = rectTiepTuc;
    CGRect rectMain = self.mViewMain.frame;
    rectMain.size.height = rectTiepTuc.origin.y + rectTiepTuc.size.height + 20;
    self.mViewMain.frame = rectMain;

    UIPickerView *picThang = [[UIPickerView alloc] init];
    picThang.delegate = self;
    picThang.dataSource = self;
    picThang.tag = 101;
    self.edThang.inputView = picThang;
    [picThang release];

    UIPickerView *picNam = [[UIPickerView alloc] init];
    picNam.delegate = self;
    picNam.dataSource = self;
    picNam.tag = 102;
    self.edNam.inputView = picNam;
    [picNam release];
}

- (void)khoiTaoGiaoDienTheQuocTeBuoc2{
    mBuocKhoiTao = 2;
    [self.viewQuocTe2 setHidden:NO];
    CGRect rViewMain = self.mViewMain.frame;
    CGRect rViewThe = self.viewQuocTe.frame;
    CGRect rViewThe2 = self.viewQuocTe2.frame;
    rViewThe2.origin.y = rViewThe.origin.y + rViewThe.size.height + 5;
    rViewThe2.size.width = rViewMain.size.width;
    self.viewQuocTe2.frame = rViewThe2;
    CGRect rectBtnTiepTuc = self.mbtnTiepTuc.frame;
    rectBtnTiepTuc.origin.y = rViewThe2.origin.y + rViewThe2.size.height + 10;
    self.mbtnTiepTuc.frame = rectBtnTiepTuc;
    if (![self.mViewMain.subviews containsObject:self.viewQuocTe2]) {
        [self.mViewMain addSubview:self.viewQuocTe2];
    }
//    [self.mViewMain addSubview:self.viewQuocTe2];
    rViewMain.size.height = rectBtnTiepTuc.origin.y + rectBtnTiepTuc.size.height + 10;
    self.mViewMain.frame = rViewMain;

    [_mScrv setContentSize:CGSizeMake(_mScrv.frame.size.width, 2 * rViewMain.origin.y + rViewMain.size.height + 50)];
    [self.view setNeedsLayout];
}

- (void)khoiTaoGiaoDienTaiKhoanLienKet {
    self.sIdGiaoDichTKLK = @"";
    self.viewXacThucTKLK.hidden = YES;
    self.btnTiepTucTKLK.hidden = NO;
    CGRect rViewMain = self.mViewMain.frame;
    CGRect rectViewTop = _viewTop.frame;
    CGRect rectLienKet = self.viewTaiKhoanLienKet.frame;
    CGRect rectBtnTiepTuc = self.btnTiepTucTKLK.frame;
    rectLienKet.origin.y = rectViewTop.origin.y + rectViewTop.size.height + 10;
    rectLienKet.size.height = rectBtnTiepTuc.origin.y + rectBtnTiepTuc.size.height + 10;
    self.viewTaiKhoanLienKet.frame = rectLienKet;
    if (![self.mViewMain.subviews containsObject:self.viewTaiKhoanLienKet]) {
        [self.mViewMain addSubview:self.viewTaiKhoanLienKet];
    }
    rViewMain.size.height = rectLienKet.origin.y + rectLienKet.size.height + 10;
    self.mViewMain.frame = rViewMain;
    [_mScrv setContentSize:CGSizeMake(_mScrv.frame.size.width, 2 * rViewMain.origin.y + rViewMain.size.height + 40)];
    [self.view setNeedsLayout];
}

- (void)khoiTaoGiaoDienNapTienBangTheCao{
    mBuocKhoiTao = 1;
    [self.viewTheLuu setHidden:YES];
    [self.viewQuocTe setHidden:YES];
    [self.viewQuocTe2 setHidden:YES];
    [_mViewThongTinBuoc1 setHidden:YES];
    [_mViewThongTinBuoc2 setHidden:YES];
    [self.viewNapTheCao setHidden:NO];

    self.edSoSerial.text = @"";
    self.edMaThe.text = @"";
    self.edNoiDungTheCao.text = @"";

    if (!self.edLoaiTheCao.rightView) {
        UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 12)];
        [btnRight setBackgroundImage:[UIImage imageNamed:@"muiten35x21.png"] forState:UIControlStateNormal];
        self.edLoaiTheCao.rightView = btnRight;
        self.edLoaiTheCao.rightViewMode = UITextFieldViewModeAlways;
    }

    CGRect rViewMain = self.mViewMain.frame;
    CGRect rectViewTop = _viewTop.frame;
    CGRect rViewThe = self.viewNapTheCao.frame;
    rViewThe.origin.y = rectViewTop.origin.y + rectViewTop.size.height + 10;
    rViewThe.size.width = rViewMain.size.width;
    self.viewNapTheCao.frame = rViewThe;
    if (![self.mViewMain.subviews containsObject:self.viewNapTheCao]) {
        [self.mViewMain addSubview:self.viewNapTheCao];
    }

    CGRect rectBtnTiepTuc = self.mbtnTiepTuc.frame;
    rectBtnTiepTuc.origin.y = rViewThe.origin.y + rViewThe.size.height + 10;
    self.mbtnTiepTuc.frame = rectBtnTiepTuc;
    rViewMain.size.height = rectBtnTiepTuc.origin.y + rectBtnTiepTuc.size.height + 10;
    self.mViewMain.frame = rViewMain;

    [_mScrv setContentSize:CGSizeMake(_mScrv.frame.size.width, 2 * rViewMain.origin.y + rViewMain.size.height + rectViewTop.size.height + 10)];

    UIPickerView *pickerChonNganHang = [[UIPickerView alloc] init];
    pickerChonNganHang.dataSource = self;
    pickerChonNganHang.delegate = self;
    pickerChonNganHang.tag = 103;

    self.edLoaiTheCao.inputView = pickerChonNganHang;
    self.edLoaiTheCao.text = @"Chọn loại thẻ";
    [pickerChonNganHang release];
}

- (void)khoiTaoGiaoDienTheLuu{
    mBuocKhoiTao = 1;
    [self.edCVVTheLuu setMax_length:4];
    self.edSoTienTheLuu.text = @"";
    self.edSoTienTheLuu.text = @"";
    self.edNoiDungTheLuu.text = @"";
    [_viewTheLuu setHidden:NO];
    [self.viewQuocTe setHidden:YES];
    [self.viewQuocTe2 setHidden:YES];
    [_mViewThongTinBuoc1 setHidden:YES];
    [_mViewThongTinBuoc2 setHidden:YES];
    [self.viewNapTheCao setHidden:YES];

    CGRect rViewMain = self.mViewMain.frame;
    CGRect rectViewTop = _viewTop.frame;
    CGRect rViewThe = self.viewTheLuu.frame;
    rViewThe.origin.y = rectViewTop.origin.y + rectViewTop.size.height + 10;
    self.viewTheLuu.frame = rViewThe;
    if (![self.mViewMain.subviews containsObject:self.viewTheLuu]) {
        [self.mViewMain addSubview:self.viewTheLuu];
    }

    CGRect rectBtnTiepTuc = self.mbtnTiepTuc.frame;
    rectBtnTiepTuc.origin.y = rViewThe.origin.y + rViewThe.size.height + 10;
    self.mbtnTiepTuc.frame = rectBtnTiepTuc;
    rViewMain.size.height = rectBtnTiepTuc.origin.y + rectBtnTiepTuc.size.height + 10;
    self.mViewMain.frame = rViewMain;

    [self taoPickerChonTheLuu];
    [_mScrv setContentSize:CGSizeMake(_mScrv.frame.size.width, 2 * rViewMain.origin.y + rViewMain.size.height + rectViewTop.size.height + 10)];
}

- (void)taoPickerChonTheLuu{
    UIPickerView *picThang = [[UIPickerView alloc] init];
    picThang.delegate = self;
    picThang.dataSource = self;
    picThang.tag = 104;
    self.edChonTheTheLuu.inputView = picThang;
    [picThang release];
    if (!self.edChonTheTheLuu.rightView) {
        UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 12)];
        [btnRight setBackgroundImage:[UIImage imageNamed:@"muiten35x21.png"] forState:UIControlStateNormal];
        self.edChonTheTheLuu.rightView = btnRight;
        self.edChonTheTheLuu.rightViewMode = UITextFieldViewModeAlways;
    }

    if (!dsTaiKhoanThuongDung) {
        dsTaiKhoanThuongDung = [[NSMutableArray alloc] init];
    }

    DucNT_TaiKhoanThuongDungObject *obj = [[DucNT_TaiKhoanThuongDungObject alloc] init];
    obj.sId = @"";
    obj.sPhoneOwner = @"";
    obj.nType = -1;
    obj.sAliasName = @"Thêm thẻ lưu";
    obj.nAmount = 0.0;
    obj.sDesc = @"";
    obj.sToAccWallet = @"";
    obj.sAccOwnerName = @"";
    obj.sBankName = @"";
    obj.sBankNumber = @"";
    obj.sProvinceName = @"";
    obj.nProvinceCode = -1;
    obj.nProvinceID = -1;
    obj.nBankCode = -1;
    obj.nBankId = -1;
    obj.nBranchId = -1;
    obj.sBranchName = @"";
    obj.sBranchCode = @"";
//    obj.nCardId = -1;
    obj.nDateExp = -1;
    obj.nDateReg = -1;
    obj.sCardNumber = @"";
    obj.sCardOwnerName = @"";
    obj.sCardTypeName = @"";
    obj.tenNguoiThuHuong = @"";
    obj.cellphoneNumber = @"";
    obj.soTien = @"";
    obj.cmnd = @"";
    obj.tinhThanh = @"";
    obj.quanHuyen = @"";
    obj.phuongXa = @"";
    obj.diaChi = @"";
    obj.noiDung = @"";
    obj.cvv = @"123";
    if(obj.nType != TAI_KHOAN_THE_RUT_TIEN)
    {
        [dsTaiKhoanThuongDung addObject:obj];
    }
    [self anNutSuaXoaTheLuu:YES];
}

- (void)khoiTaoViewThongBao
{
    self.mViewChuaThongBao.layer.masksToBounds = YES;
    self.mViewChuaThongBao.layer.cornerRadius = 4.0f;

    self.mViewXacNhanOtp.frame = self.view.bounds;
    _mtfXacNhan.placeholder = [@"ma_xac_thuc" localizableString];
    [_mtfXacNhan setTextError:[@"ma_xac_thuc_khong_duoc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    _mtfXacNhan.inputAccessoryView = nil;
}

#pragma mark - suKien

- (IBAction)suKienBamNutDanhBaSoThe:(UIButton *)sender
{
    ContactScreen *danhBa = [[[ContactScreen alloc] initWithNibName:@"ContactScreen" bundle:nil] autorelease];
    danhBa.mKieuHienThiLienHe = KIEU_HIEN_THI_LIEN_HE_THUONG;
    [self.navigationController pushViewController:danhBa animated:YES];
    __block NapViTuTheNganHangViewController *weakSelf = self;
    [danhBa selectContact:^(NSString *phone,Contact *contact)
     {
         if (phone != nil && phone.length > 0)
         {
             if([Common kiemTraLaMail:phone])
             {
                 weakSelf.mtfSoThe.text = phone;
             }
             else
             {
                 weakSelf.mtfSoThe.text = [phone stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [phone length])];
             }
         }
         
         [danhBa.navigationController popViewControllerAnimated:YES];
     }];

}

- (IBAction)suKienBamNutThuongDung:(id)sender
{
}

- (IBAction)suKienBamNutXacNhan:(id)sender
{
    if([_mtfXacNhan validate])
    {
        if (nHinhThucNap == 0) {
            @try {
                self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_XAC_NHAN_OTP_SAU_KHI_NAP_VI_TU_THE_KIEU_DIRECT;
                [GiaoDichMang ketNoiXacNhanOTPSauKhiNapTienKieuDirect:_mIDOtpDirect
                                                                  otp:_mtfXacNhan.text
                                                           otpGetType:mOtpDirect
                                                        noiNhanKetQua:self];
            }
            @catch (NSException *exception) {
                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:[@"co_loi_trong_qua_trinh_giao_dich" localizableString]];
            }
            @finally {
                
            }
        }
        else if (nHinhThucNap == 1){
            if (nSTT != -1) {
                self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_NAP_TIEN_TU_THE_QUOC_TE_CONFIRM;
                [GiaoDichMang confirmNapTienVaoViQuaTheQuocTe:_mtfXacNhan.text soThuTu:nSTT noiNhanKetQua:self];
            }
        }
        else if (nHinhThucNap == 3){
            DucNT_TaiKhoanThuongDungObject *obj = [dsTaiKhoanThuongDung objectAtIndex:nIndexTheLuu];
            if (obj.nType == 8) {
                @try {
                    self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_XAC_NHAN_OTP_SAU_KHI_NAP_VI_TU_THE_KIEU_DIRECT;
                    [GiaoDichMang ketNoiXacNhanOTPSauKhiNapTienKieuDirect:_mIDOtpDirect
                                                                      otp:_mtfXacNhan.text
                                                               otpGetType:mOtpDirect
                                                            noiNhanKetQua:self];
                }
                @catch (NSException *exception) {
                    [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:[@"co_loi_trong_qua_trinh_giao_dich" localizableString]];
                }
                @finally {
                    
                }
            }
            else{
                if (nSTT != -1) {
                    self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_NAP_TIEN_TU_THE_QUOC_TE_CONFIRM;
                    [GiaoDichMang confirmNapTienVaoViQuaTheQuocTe:_mtfXacNhan.text soThuTu:nSTT noiNhanKetQua:self];
                }
            }
        }
//        [self anViewXacThuc];
        [self.btnGuiXacNhan setHidden:YES];
        
//        if (!alertTimeXacNhan) {
//            alertTimeXacNhan = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
//        }
//        [alertTimeXacNhan show];
    }
}

- (IBAction)suKienBamNutDanhBa:(id)sender
{
    ContactScreen *danhBa = [[[ContactScreen alloc] initWithNibName:@"ContactScreen" bundle:nil] autorelease];
    danhBa.mKieuHienThiLienHe = KIEU_HIEN_THI_LIEN_HE_MUON_TIEN;
    [self.navigationController pushViewController:danhBa animated:YES];
    __block NapViTuTheNganHangViewController *weakSelf = self;
    [danhBa selectContact:^(NSString *phone,Contact *contact)
     {
         if (phone != nil && phone.length > 0)
         {
             if([Common kiemTraLaMail:phone])
             {
                 weakSelf.mtfSoViCanNapTien.text = phone;
             }
             else
             {
                 weakSelf.mtfSoViCanNapTien.text = [phone stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [phone length])];
             }
         }
         
         [danhBa.navigationController popViewControllerAnimated:YES];
     }];
}

- (IBAction)suKienBamNutTiepTuc:(id)sender
{
    if (nHinhThucNap == 0) {
        if(mBuocKhoiTao == 1 && [self validateBuoc1] && _mNganHangNapTienDaChon)
        {

            if([_mNganHangNapTienDaChon.trangThaiDirect intValue] != 0)
            {
                mBuocKhoiTao = 2;
                [self khoiTaoGiaoDien];
            }
            else
            {
                //Xu ly redirect
                self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_NAP_VI_TU_THE_KIEU_REDIRECT;
                double fSoTien = [[[self.mtfSoTien.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
                TheNapTien *theNapTien = [_mNganHangNapTienDaChon.danhSachTheNapTien objectAtIndex:0];
                NSString *idBank = theNapTien.idBank;

                [GiaoDichMang ketNoiNapTienTuTheNganHangKieuRedirectSoTienNap:fSoTien
                                                                      noiDung:_mtvNoiDung.text
                                                                     viCanNap:_mtfSoViCanNapTien.text nganHangLuaChon:idBank
                                                                noiNhanKetQua:self];
            }
        }
        else if(mBuocKhoiTao == 2 && [self validateBuoc2] && _mNganHangNapTienDaChon)
        {
            //Xu ly redirect
            self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_NAP_VI_TU_THE_KIEU_DIRECT;
            double fSoTien = [[[self.mtfSoTien.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
            TheNapTien *theNapTien = [_mNganHangNapTienDaChon.danhSachTheNapTien objectAtIndex:0];
            NSString *idBank = theNapTien.idBank;

            [GiaoDichMang ketNoiNapTienTuTheNganHangKieuDirectSoTienNap:fSoTien
                                                                noiDung:_mtvNoiDung.text
                                                               viCanNap:_mtfSoViCanNapTien.text
                                                        nganHangLuaChon:idBank
                                                             otpGetType:mOtpDirect
                                                             cardNumber:_mtfSoThe.text
                                                               cardName:_mtfTenChuThe.text
                                                              cardMonth:_mtfThangMoThe.text
                                                               cardYear:_mtfNamMoThe.text
                                                          noiNhanKetQua:self];
        }
    }
    else if (nHinhThucNap == 1){
        if (mBuocKhoiTao == 1 && [self validateBuoc2TheQuocTe]) {
            NSLog(@"%s ===============> nap tien quoc te : cvv : %@", __FUNCTION__, self.edCVV.text);
            bKiemTraQuocTe = YES;
            self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_NAP_TIEN_TU_THE_QUOC_TE;
            double fSoTien = [[[self.edSoTienQT.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
            NSDictionary *dic = @{@"soTienNap" : [NSNumber numberWithDouble:fSoTien],
                                  @"idViNap" : self.edViCanNapQT.text,
                                  @"typeCard" : [NSNumber numberWithInt:nLoaiTheQuocTe],
                                  @"cardNumber" : self.edSoThe.text,
                                  @"noiDung": self.tvNoiDungQT.text,
                                  @"cvv": self.edCVV.text,
                                  @"cardMonth": [NSNumber numberWithInt:[self.edThang.text intValue]],
                                  @"cardYear": [NSNumber numberWithInt:[self.edNam.text intValue]],
                                  @"VMApp" : [NSNumber numberWithInt:VM_APP]
                                  };
            NSLog(@"%s - dic : %@", __FUNCTION__, [dic JSONString]);
            [GiaoDichMang napTienVaoViQuaTheQuocTe:dic noiNhanKetQua:self];
        }
        else if (mBuocKhoiTao == 2 && [self validateBuoc2TheQuocTe]){
            self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_NAP_TIEN_TU_THE_QUOC_TE_BUOC_2;
            double fSoTien = [[[self.edSoTienQT.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
            NSDictionary *dic = @{@"soTienNap" : [NSNumber numberWithDouble:fSoTien],
                                  @"idViNap" : self.edViCanNapQT.text,
                                  @"typeCard" : [NSNumber numberWithInt:nLoaiTheQuocTe],
                                  @"cardNumber" : self.edSoThe.text,
                                  @"ten": self.edHo.text,
                                  @"cvv": self.edCVV.text,
                                  @"cardMonth": [NSNumber numberWithInt:[self.edThang.text intValue]],
                                  @"cardYear": [NSNumber numberWithInt:[self.edNam.text intValue]],
                                  @"noiDung": self.tvNoiDungQT.text,
                                  @"VMApp" : [NSNumber numberWithInt:VM_APP]
                                  };
            NSLog(@"%s - dic : %@", __FUNCTION__, [dic JSONString]);
            [GiaoDichMang napTienVaoViQuaTheQuocTe:dic noiNhanKetQua:self];
        }
    }
    else if (nHinhThucNap == 2){
        if ([self validateTheCao]) {
            self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_NAP_TIEN_TU_THE_CAO;
            [GiaoDichMang napTienVaoViQuaTheCao:self.edViTheCao.text maSoThe:self.edMaThe.text serial:self.edSoSerial.text nhaMang:nLoaiTheCao noiDung:self.edNoiDungTheCao.text noiNhanKetQua:self];
        }
    }
    else if (nHinhThucNap == 3){
        [self napTienTuTheLuu2];
//        if (!dsTaiKhoanThuongDung || dsTaiKhoanThuongDung.count <= 1) {
//            GiaoDienTaoTheLuu *theLuu = [[GiaoDienTaoTheLuu alloc] initWithNibName:@"GiaoDienTaoTheLuu" bundle:nil];
//            theLuu.nTrangThai = 0;
//            [self.navigationController pushViewController:theLuu animated:YES];
//            [theLuu release];
//        }
//        else{
//            if (nIndexTheLuu == dsTaiKhoanThuongDung.count - 1) {
//                GiaoDienTaoTheLuu *theLuu = [[GiaoDienTaoTheLuu alloc] initWithNibName:@"GiaoDienTaoTheLuu" bundle:nil];
//                theLuu.nTrangThai = 0;
//                [self.navigationController pushViewController:theLuu animated:YES];
//                [theLuu release];
//            }
//            else{
//
//                if ([self validateTheLuu]) {
//                    self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_NAP_TIEN_TU_THE_QUOC_TE;
//                    [self napTienTuTheLuu];
//                }
//            }
//        }
    }
}

- (void)napTienTuTheLuu2{
    [self showLoadingScreen];
    if (!mTaiKhoanSoTay) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Có lỗi khi lấy thông tin sổ tay"];
        return;
    }
    if (mTaiKhoanSoTay.nType == 8)
    {
        self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_NAP_VI_TU_THE_KIEU_DIRECT;
        mOtpDirect = mTaiKhoanSoTay.otpGetType;
        double fSoTien = [[[self.mtfSoTien.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];

        NSString *idBank = [NSString stringWithFormat:@"%d", mTaiKhoanSoTay.nBankCode];
        [GiaoDichMang ketNoiNapTienTuTheNganHangKieuDirectTheLuu:fSoTien idTheLuu:mTaiKhoanSoTay.sId noiDung:_tvNoiDungTheLuu.text viCanNap:self.edViCanNapTheLuu.text nganHangLuaChon:idBank otpGetType:mTaiKhoanSoTay.otpGetType cardNumber:mTaiKhoanSoTay.sCardNumber cardName:mTaiKhoanSoTay.sCardOwnerName cardMonth:[NSString stringWithFormat:@"%d", mTaiKhoanSoTay.cardMonth] cardYear:[NSString stringWithFormat:@"%d", mTaiKhoanSoTay.cardYear] noiNhanKetQua:self];
    }
    else{
        bKiemTraQuocTe = YES;
        self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_NAP_TIEN_TU_THE_QUOC_TE;
        double fSoTien = [[[self.edSoTienQT.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
        NSString *sCVV = mTaiKhoanSoTay.cvv;
        if (sCVV.length == 0) {
            sCVV = self.edCVVTheLuu.text;
        }
        NSDictionary *dic = @{@"idTheLuu" : mTaiKhoanSoTay.sId,
                              @"soTienNap" : [NSNumber numberWithDouble:fSoTien],
                              @"idViNap" : self.edViCanNapTheLuu.text,
                              @"typeCard" : [NSNumber numberWithInt:mTaiKhoanSoTay.nType],
                              @"cardNumber" : mTaiKhoanSoTay.sCardNumber,
                              @"cvv": sCVV,
                              @"cardMonth": [NSNumber numberWithInt:mTaiKhoanSoTay.cardMonth],
                              @"cardYear": [NSNumber numberWithInt:mTaiKhoanSoTay.cardYear],
                              @"noiDung": self.tvNoiDungTheLuu.text,
                              @"VMApp" : [NSNumber numberWithInt:VM_APP]
                              };
        NSLog(@"%s - dic : %@", __FUNCTION__, [dic JSONString]);
        [GiaoDichMang napTienVaoViQuaTheQuocTe:dic noiNhanKetQua:self];
    }
}

- (void)napTienTuTheLuu{
    DucNT_TaiKhoanThuongDungObject *obj = [dsTaiKhoanThuongDung objectAtIndex:nIndexTheLuu];
    if (obj.nType == 8)
    {
        self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_NAP_VI_TU_THE_KIEU_DIRECT;
        mOtpDirect = obj.otpGetType;
        double fSoTien = [[[self.edSoTienTheLuu.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];

        NSString *idBank = [NSString stringWithFormat:@"%d", obj.nBankCode];
        [GiaoDichMang ketNoiNapTienTuTheNganHangKieuDirectTheLuu:fSoTien idTheLuu:obj.sId noiDung:_tvNoiDungTheLuu.text viCanNap:self.edViCanNapTheLuu.text nganHangLuaChon:idBank otpGetType:obj.otpGetType cardNumber:obj.sCardNumber cardName:obj.sCardOwnerName cardMonth:[NSString stringWithFormat:@"%d", obj.cardMonth] cardYear:[NSString stringWithFormat:@"%d", obj.cardYear] noiNhanKetQua:self];
    }
    else{
        bKiemTraQuocTe = YES;
        self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_NAP_TIEN_TU_THE_QUOC_TE;
        double fSoTien = [[[self.edSoTienTheLuu.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
        NSString *sCVV = obj.cvv;
        if (sCVV.length == 0) {
            sCVV = self.edCVVTheLuu.text;
        }
        NSDictionary *dic = @{@"idTheLuu" : obj.sId,
                              @"soTienNap" : [NSNumber numberWithDouble:fSoTien],
                              @"idViNap" : self.edViCanNapTheLuu.text,
                              @"typeCard" : [NSNumber numberWithInt:obj.nType],
                              @"cardNumber" : obj.sCardNumber,
                              @"cvv": sCVV,
                              @"cardMonth": [NSNumber numberWithInt:obj.cardMonth],
                              @"cardYear": [NSNumber numberWithInt:obj.cardYear],
                              @"noiDung": self.tvNoiDungTheLuu.text,
                              @"VMApp" : [NSNumber numberWithInt:VM_APP]
                              };
        NSLog(@"%s - dic : %@", __FUNCTION__, [dic JSONString]);
        [GiaoDichMang napTienVaoViQuaTheQuocTe:dic noiNhanKetQua:self];
    }
}

- (IBAction)suKienThayDoiSoTien:(id)sender
{
    if (nHinhThucNap == 0){
        double fSoTien = [[[self.mtfSoTien.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
        if(fSoTien > 0)
            self.mtfSoTien.text = [Common hienThiTienTe:fSoTien];
        else
            self.mtfSoTien.text = @"";
        [self hienThiSoPhiCuaSoTien:fSoTien];
    }
    else if (nHinhThucNap == 1){
        double fSoTien = [[[self.edSoTienQT.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
        if(fSoTien > 0)
            self.edSoTienQT.text = [Common hienThiTienTe:fSoTien];
        else
            self.edSoTienQT.text = @"";
        [self hienThiSoPhiCuaSoTien:fSoTien];
    }
    else if (nHinhThucNap == 3){
//        double fSoTien = [[[self.edSoTienTheLuu.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
        if (mTaiKhoanSoTay){
            double fSoTien = 0;
            if (mTaiKhoanSoTay.nType == TAI_KHOAN_THE_DIRECT) {
                fSoTien = [[[self.mtfSoTien.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
            }
            else {
                fSoTien = [[[self.edSoTienQT.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
            }
            if(fSoTien > 0)
            {
                if (mTaiKhoanSoTay.nType == TAI_KHOAN_THE_DIRECT) {
                    self.mtfSoTien.text = [Common hienThiTienTe:fSoTien];
                }
                else{
                    self.edSoTienQT.text = [Common hienThiTienTe:fSoTien];
                }
//                self.edSoTienTheLuu.text = [Common hienThiTienTe:fSoTien];
            }
            else{
                if (mTaiKhoanSoTay.nType == TAI_KHOAN_THE_DIRECT) {
                    self.mtfSoTien.text = @"";
                }
                else{
                    self.edSoTienQT.text = @"";
                }
//                self.edSoTienTheLuu.text = @"";
            }
            [self hienThiSoPhiCuaSoTien:fSoTien];
        }
    }
    else {
        double fSoTien = [[[self.edSoTienLienKet.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
        if(fSoTien > 0)
            self.edSoTienLienKet.text = [Common hienThiTienTe:fSoTien];
        else
            self.edSoTienLienKet.text = @"";
        [self hienThiSoPhiCuaSoTien:fSoTien];
    }
}

- (void)hienThiSoPhiCuaSoTien:(double)fSoTien
{
    NSLog(@"%s - fSoTien : %f", __FUNCTION__, fSoTien);
    if (nHinhThucNap == 0) {
        _mtfSoPhi.minimumFontSize = 11.0f;
        NSString *sSoPhi = @"";
        if(fSoTien > 0)
        {
            double fSoPhi = [Common layPhiChuyenTienCuaSoTien:fSoTien kieuChuyenTien:KIEU_NAP_VI_TU_THE_NGAN_HANG maNganHang:@""];
            sSoPhi = [NSString stringWithFormat:@"%@ %@ đ", [@"phi_chuyen_tien" localizableString], [Common hienThiTienTe:fSoPhi]];
        }
        else
        {
            sSoPhi = @"1.1% + 1.100";
        }

        [self.mtfSoPhi setText:sSoPhi];
    }
    else if (nHinhThucNap == 1){
        NSString *sSoPhi = @"";
        if(fSoTien > 0)
        {
//            fSoTienPhi = 1100 + round((float)((0.011*fSoTien + 12.1)/0.989));

//            double fSoPhi = ceil((fSoTien + 3200) / 0.976 - fSoTien);
//            double fSoPhi = 3200 + (fSoTien * 2.4) / 100;
            double fSoPhi = (fSoTien * 1.02669405) - fSoTien;
            sSoPhi = [NSString stringWithFormat:@"%@ %@ đ", [@"phi_chuyen_tien" localizableString], [Common hienThiTienTe:fSoPhi]];
        }
        else
        {
            sSoPhi = @"Phí 2.67%";
        }
        self.lblPhiQT.text = sSoPhi;
    }
    else if (nHinhThucNap == 2){
        NSString *sSoPhi = @"";
        if(fSoTien > 0)
        {
            float nSoPhiTheoNhaMang = 20.5f;
//            if (nLoaiTheCao == 1 || nLoaiTheCao == 2) {
//                nSoPhiTheoNhaMang = 22.0f;
//            }
//            else if (nLoaiTheCao == 3) {
//                nSoPhiTheoNhaMang = 22.5f;
//            }
            double fSoPhi = (fSoTien * nSoPhiTheoNhaMang) / 100;
            sSoPhi = [NSString stringWithFormat:@"%@ đ", [Common hienThiTienTe:fSoPhi]];
        }
        else
        {
            sSoPhi = @"%@ 19.5%";
            if (nLoaiTheCao == 3 || nLoaiTheCao == 2) {
                sSoPhi = @"Phí 19%";
            }
            else if (nLoaiTheCao == 1) {
                sSoPhi = @"%@ 19.5%";
            }
//            else
//                sSoPhi = @"Phí 18%";
        }
        self.lblPhiTheCao.text = [NSString stringWithFormat:sSoPhi, [@"phi_chuyen_tien" localizableString]];
    }
    else if (nHinhThucNap == 3){
        if (mTaiKhoanSoTay) {
            double fSoPhi = 0.0;
            if (fSoTien == 0) {
                NSLog(@"%s - obj.nType : %d", __FUNCTION__, mTaiKhoanSoTay.nType);
                NSString *temp = @"";
                if (mTaiKhoanSoTay.nType == TAI_KHOAN_THE_DIRECT) {
                    temp = @"%@ 1.1% + 1.100 đ";
                    self.mtfSoPhi.text = [NSString stringWithFormat:temp, [@"phi_chuyen_tien" localizableString]];
                }
                else{
                    temp = @"Phí 2.67%";
                    self.lblPhiQT.text = [NSString stringWithFormat:temp, [@"phi_chuyen_tien" localizableString]];
                }
            }
            else{
                if (mTaiKhoanSoTay.nType == TAI_KHOAN_THE_DIRECT) {
                    fSoPhi = 1100 + (fSoTien * 1.1) / 100;
                    NSString *sSoPhi  = [NSString stringWithFormat:@"%@ %@ đ", [@"phi_chuyen_tien" localizableString], [Common hienThiTienTe:fSoPhi]];
                    self.mtfSoPhi.text = sSoPhi;
                }
                else{
                    fSoPhi = (fSoTien * 1.02669405) - fSoTien;
                    NSString *sSoPhi  = [NSString stringWithFormat:@"%@ %@ đ", [@"phi_chuyen_tien" localizableString], [Common hienThiTienTe:fSoPhi]];
                    self.lblPhiQT.text = sSoPhi;
                }
            }
        }
    }
}

- (IBAction)suKienBamNutChonRadioButton:(id)sender {
    UIButton *btn = (UIButton*)sender;
    if(btn.tag == 1)
    {
        mOtpDirect = otpGetTypeSMS;
    }
    else if(btn.tag == 2)
    {
        mOtpDirect = otpGetTypeToken;
    }
}

#pragma mark - xuLySuKien

- (void)hienThiViewXacThuc
{
    NSLog(@"%s - hien thi view xac thuc", __FUNCTION__);
    nTimeDemGiay = 300;
    if (nHinhThucNap == 1) {
        nTimeDemGiay = 420;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTick:) userInfo:nil repeats:YES];
    if(!_mViewXacNhanOtp.superview)
    {
        self.mViewXacNhanOtp.frame = self.view.bounds;
        [self.view addSubview:_mViewXacNhanOtp];
    }
    else
    {
        self.mViewXacNhanOtp.frame = self.view.bounds;
    }
    [self.mViewXacNhanOtp setHidden:NO];
    [self.btnGuiXacNhan setHidden:NO];
    [self.mtfXacNhan becomeFirstResponder];
    if (viewXacThuc) {
        viewXacThuc.lblTitle.text = [@"xac_thuc" localizableString];
    }
    if (nHinhThucNap == 0) {
        if ([self.mNganHangNapTienDaChon.tenBank hasPrefix:@"NAB"]) {
            [self.mtfXacNhan setKeyboardType:UIKeyboardTypeDefault];
        }
        else {
            [self.mtfXacNhan setKeyboardType:UIKeyboardTypeNumberPad];
        }
    }
    else if (nHinhThucNap == 1) {
        [self.mtfXacNhan setKeyboardType:UIKeyboardTypeNumberPad];
    }
    else if (nHinhThucNap == 3) {
        if (mTaiKhoanSoTay) {
            if (mTaiKhoanSoTay.nType == TAI_KHOAN_THE_DIRECT) {
                for (NganHangNapTien *nganHangNapTien in _mDanhSachNganHangHoTroNapTien) {
                    for (TheNapTien *theNapTien in nganHangNapTien.danhSachTheNapTien) {
                        NSString *idBank = theNapTien.idBank;
                        if ([idBank isEqualToString:[NSString stringWithFormat:@"%d", mTaiKhoanSoTay.nBankCode]]) {
                            _mtfChonNganHang.text = nganHangNapTien.tenBank;
                            if([nganHangNapTien.trangThaiDirect intValue] != 0)
                            {
                                mBuocKhoiTao = 2;
                                self.mtfSoThe.text = mTaiKhoanSoTay.sCardNumber;
                                self.mtfTenChuThe.text = mTaiKhoanSoTay.sCardOwnerName;
                                self.mtfThangMoThe.text = [NSString stringWithFormat:@"%d", mTaiKhoanSoTay.cardMonth];
                                self.mtfNamMoThe.text = [NSString stringWithFormat:@"%d", mTaiKhoanSoTay.cardYear];
                                if ([mTaiKhoanSoTay.otpGetType isEqualToString:@"SMS"]) {
                                    [_mbtnChonMaXacThucNhanQuaSMS setSelected:YES];
                                    [_mbtnChonMaXacThucSuDungToken setSelected:NO];
                                }
                                else{
                                    [_mbtnChonMaXacThucNhanQuaSMS setSelected:NO];
                                    [_mbtnChonMaXacThucSuDungToken setSelected:YES];
                                }
                                [self khoiTaoGiaoDien];
                            }
                            self.mNganHangNapTienDaChon = nganHangNapTien;
                            if ([self.mNganHangNapTienDaChon.tenBank hasPrefix:@"NAB"]) {
                                [self.mtfXacNhan setKeyboardType:UIKeyboardTypeDefault];
                            }
                            else {
                                [self.mtfXacNhan setKeyboardType:UIKeyboardTypeNumberPad];
                            }
                            [self.mtfXacNhan reloadInputViews];
                            return;
                        }
                    }
                }
            }
            else {
                [self.mtfXacNhan setKeyboardType:UIKeyboardTypeNumberPad];
            }
        }
    }
    [self.mtfXacNhan reloadInputViews];
}

- (void)onTick:(NSTimer *)time{
    nTimeDemGiay --;
    self.lblDemGiay.text = [NSString stringWithFormat:@"Còn %ds", nTimeDemGiay];
    if (nTimeDemGiay <= 0) {
        nTimeDemGiay = 0;
        [self anViewXacThuc];
        [self dungDemTime];
    }
}

- (void)dungDemTime{
    if (timer) {
        NSLog(@"%s =========> dung dem thoi gian", __FUNCTION__);
        [timer invalidate];
        timer = nil;
    }
}

- (void)anViewXacThuc
{
    NSLog(@"%s - START", __FUNCTION__);
    if(_mViewXacNhanOtp && _mViewXacNhanOtp.superview)
    {
        self.mViewXacNhanOtp.hidden = YES;
    }
    if (viewXacThuc && viewXacThuc.hidden == NO) {
        viewXacThuc.hidden = YES;
    }
    [self.view endEditing:YES];
}

- (BOOL)validateBuoc1
{
    //Buoc 1
    NSArray *tfs = @[_mtfSoViCanNapTien, _mtfSoTien];
    ExTextField *first = nil;
    BOOL flg = YES;
    for (ExTextField *tf in tfs)
    {
        flg = [tf validate] && flg;
        if (flg == NO && first == nil)
            first = tf;
    }
    if (first)
    {
        [first show_error];
        return flg;
    }

    if([_mtfChonNganHang.text isEqualToString:[@"title_hien_thi_chon_ngan_hang" localizableString]])
    {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:[@"thong_bao_chon_ngan_hang_phat_hanh" localizableString]];
        return NO;
    }
    return flg;
}

- (BOOL)validateBuoc2
{
    //Buoc 1
    NSArray *tfs = @[_mtfSoViCanNapTien, _mtfSoTien, _mtfSoThe];
    ExTextField *first = nil;
    BOOL flg = YES;
    for (ExTextField *tf in tfs)
    {
        flg = [tf validate] && flg;
        if (flg == NO && first == nil)
            first = tf;
    }
    if (first)
    {
        [first show_error];
        return flg;
    }
    if (self.mtfThangMoThe.text.length > 0) {
        int nThang = [self.mtfThangMoThe.text intValue];
        if (nThang < 1 || nThang > 12) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Tháng mở thẻ sai. Vui lòng kiểm tra lại."];
            return NO;
        }
    }
    if (self.mtfNamMoThe.text.length > 0) {
        int nNam = [self.mtfNamMoThe.text intValue];
        nNam = nNam + 2000;
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
        NSInteger year = [components year];
        NSInteger month = [components month];
        if (nNam > year) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Năm mở thẻ phải nhỏ hơn hoặc bằng năm hiện tại."];
            return NO;
        }
        else if (nNam == year){
            int nThang = [self.mtfThangMoThe.text intValue];
            if (nThang > month) {
                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Tháng mở thẻ sai. Vui lòng kiểm tra lại."];
                return NO;
            }
        }
    }
    if([_mtfChonNganHang.text isEqualToString:[@"title_hien_thi_chon_ngan_hang" localizableString]])
    {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:[@"thong_bao_chon_ngan_hang_phat_hanh" localizableString]];
        return NO;
    }
    
    NSString *sSoTheNganHang = [_mtfSoThe.text stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [_mtfSoThe.text length])];
    BOOL bTonTai = NO;
    for (TheNapTien *theNapTien in _mNganHangNapTienDaChon.danhSachTheNapTien) {
        if([sSoTheNganHang hasPrefix:theNapTien.idTheBankNet])
        {
            bTonTai = YES;
            break;
        }
    }
    if (!bTonTai) {
        NSString *sThongBao = [@"thong_bao_so_the_khong_thuoc_ngan_hang_phat_hanh_da_chon" localizableString];
        if ([sSoTheNganHang hasPrefix:@"436438"]) {
            sThongBao = [@"thong_bao_the_visa_platinum" localizableString];
        }
        else if ([sSoTheNganHang hasPrefix:@"472074"] || [sSoTheNganHang hasPrefix:@"472075"]){
            sThongBao = [@"thong_bao_the_sacombank_visa" localizableString];
        }
        else if ([sSoTheNganHang hasPrefix:@"512341"] || [sSoTheNganHang hasPrefix:@"526830"]){
            sThongBao = [@"thong_bao_the_sacombank_master_card" localizableString];
        }
        else if ([sSoTheNganHang hasPrefix:@"625002"]){
            sThongBao = [@"thong_bao_the_sacombank_union_pay" localizableString];
        }
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
        return NO;
    }

    return flg;
}

- (BOOL)validateBuoc1TheQuocTe{
    if (self.edViCanNapQT.text.length == 0) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập số Ví cần nạp"];
        return NO;
    }
    if (self.edSoThe.text.length == 0) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập số thẻ."];
        return NO;
    }
    else if (self.edSoThe.text.length < 16 || self.edSoThe.text.length > 16){
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Số thẻ bao gồm 16 chứ số."];
        return NO;
    }
    if (nLoaiTheQuocTe == 0) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng chọn loại thẻ."];
        return NO;
    }
    if (self.edSoTienQT.text.length == 0) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập số tiền muốn nạp."];
        return NO;
    }
    else if ([[[self.edSoTienQT.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue] < 10000){
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Số tiền cần nạp phải lớn hơn hoặc bằng 10.000 đ."];
        return NO;
    }
    else if ([[[self.edSoTienQT.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue] > 20000000){
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Số tiền cần nạp phải nhỏ hơn hoặc bằng 20.000.000 đ."];
        return NO;
    }
    
    return YES;
}

- (BOOL)validateBuoc2TheQuocTe{
    if ([self validateBuoc1TheQuocTe]) {
        if (self.edCVV.text.length == 0) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập số CVV in trên thẻ."];
            return NO;
        }
        else if (self.edCVV.text.length != 3 && self.edCVV.text.length != 4){
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Số CVV là 3 hoặc 4 số in trên thẻ."];
            return NO;
        }
        if (self.edHo.text.length == 0 || self.edHo.text.length < 4) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập họ in trên thẻ. Ví dụ: NGUYEN VAN A"];
            return NO;
        }
        if (self.edNam.text.length > 0) {
            int nNam = [self.edNam.text intValue];
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
            NSInteger year = [components year];
            NSInteger month = [components month];
            if (year > nNam) {
                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Năm hết hạn phải lớn hơn năm hiện tại."];
                return NO;
            }
            else if (year == nNam){
                int nThang = [self.edThang.text intValue];
                if (nThang < month) {
                    [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Tháng hết hạn sử dụng thẻ sai. Vui lòng kiểm tra lại."];
                    return NO;
                }
            }
        }
        return YES;
    }
    return NO;
}

- (BOOL)validateTheCao{
    if (self.edViTheCao.text.length == 0) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập Ví cần nạp."];
        return NO;
    }
    if (self.edSoSerial.text.length == 0) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập số Serial."];
        return NO;
    }
    if (self.edMaThe.text.length == 0) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập mã thẻ."];
        return NO;
    }
    if (nLoaiTheCao == 0) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng chọn loại thẻ."];
        return NO;
    }
    return YES;
}

- (BOOL)validateTheLuu{
    if (!dsTaiKhoanThuongDung || dsTaiKhoanThuongDung.count <= 1) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Bạn chưa có thẻ lưu. Vui lòng chọn tạo thẻ lưu và bấm nút tiếp tục để tạo."];
        return NO;
    }
    if (self.edViCanNapTheLuu.text.length == 0) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập số ví cần nạp."];
        return NO;
    }
    if (self.edSoTienTheLuu.text.length == 0) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập số tiền cần nạp."];
        return NO;
    }
    else if ([[[self.edSoTienTheLuu.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue] < 10000){
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Số tiền cần nạp phải lớn hơn hoặc bằng 10.000 đ."];
        return NO;
    }
    return YES;
}

#pragma mark - DucNT_ServicePostDelegate

- (void)xuLyKetNoiThanhCong:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua{
    [self hideLoadingScreen];
    NSLog(@"%s - sDinhDanhKetNoi : %@ - ketQua : %@", __FUNCTION__, sDinhDanhKetNoi, ketQua);
    if([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_NAP_VI_TU_THE_KIEU_REDIRECT])
    {
        NSString *sResult = ketQua;
        NapViTuTheKieuRedirectViewController *napViTuTheKieuRedirectViewController = [[NapViTuTheKieuRedirectViewController alloc] initWithNibName:@"NapViTuTheKieuRedirectViewController" bundle:nil];
        napViTuTheKieuRedirectViewController.mURLRedirect = sResult;
        [self.navigationController pushViewController:napViTuTheKieuRedirectViewController animated:YES];
        [napViTuTheKieuRedirectViewController release];
    }
    else if([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_NAP_VI_TU_THE_KIEU_DIRECT])
    {
        NSString *idOtp = ketQua;
        self.mIDOtpDirect = idOtp;
        [self hienThiViewXacThuc];
    }
    else if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_XAC_NHAN_OTP_SAU_KHI_NAP_VI_TU_THE_KIEU_DIRECT]
             || [sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_NAP_TIEN_TU_THE_QUOC_TE_CONFIRM])
    {
        [self anViewXacThuc];
        if (ketQua) {
            return;
        }
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];

    }
    else if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_NAP_TIEN_TU_THE_QUOC_TE]
             || [sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_NAP_TIEN_TU_THE_QUOC_TE_BUOC_2]){
        [self hienThiViewXacThuc];
        nSTT = (int)[ketQua integerValue];
        NSLog(@"%s - nSTT : %d", __FUNCTION__, nSTT);
        self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_KIEM_TRA_NAP_QUOC_TE;
        [GiaoDichMang kiemTraNapTienTheQuocTe:nSTT noiNhanKetQua:self];
    }
    else if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_NAP_TIEN_TU_THE_CAO]){
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
    }
    else if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_LAY_TAI_KHOAN_THUONG_DUNG]){
        [self.viewLoading setHidden:YES];
        NSArray *dsTaiKhoan = [ketQua objectForKey:@"list"];
        NSLog(@"%s - dsTaiKhoan.count : %d", __FUNCTION__, (int)dsTaiKhoan.count);
        if(dsTaiKhoan.count > 0)
        {
            if(dsTaiKhoanThuongDung)
                [dsTaiKhoanThuongDung removeAllObjects];
            else
                dsTaiKhoanThuongDung = [[NSMutableArray alloc] init];
            for(int i = 0; i < dsTaiKhoan.count; i++)
            {
                NSString *sTemp = [dsTaiKhoan objectAtIndex:i];
                NSDictionary *itemDs = [[[[sTemp stringByReplacingOccurrencesOfString:@"\\" withString:@""] stringByReplacingOccurrencesOfString:@"\"{" withString:@"{"] stringByReplacingOccurrencesOfString:@"}\"" withString:@"}"] objectFromJSONString];
                DucNT_TaiKhoanThuongDungObject *obj = [[DucNT_TaiKhoanThuongDungObject alloc] init];
                obj.sId = [itemDs objectForKey:@"id"];
                obj.sPhoneOwner = [itemDs objectForKey:@"phoneOwner"];
                obj.nType = [[itemDs objectForKey:@"type"] intValue];
                obj.sAliasName = [Common URLDecode:[itemDs objectForKey:@"aliasName"]];
                obj.nAmount = [[itemDs objectForKey:@"amount"] doubleValue];
                obj.sDesc = [Common URLDecode:[itemDs objectForKey:@"desc"]];
                obj.sToAccWallet = [itemDs objectForKey:@"toAccWallet"];
                obj.sAccOwnerName = [itemDs objectForKey:@"AccOwnerName"];
                obj.sBankName = [Common URLDecode:[itemDs objectForKey:@"bankName"]];
                obj.sBankNumber = [itemDs objectForKey:@"BankNumber"];
                obj.sProvinceName = [Common URLDecode:[itemDs objectForKey:@"provinceName"]];
                obj.nProvinceCode = [[itemDs objectForKey:@"provinceCode"] intValue];
                obj.nProvinceID = [[itemDs objectForKey:@"provinceId"]intValue];
                obj.nBankCode = [[itemDs objectForKey:@"bankCode"] intValue];
                obj.nBankId = [[itemDs objectForKey:@"bankId"] intValue];
                obj.nBranchId = [[itemDs objectForKey:@"branchId"] intValue];
                obj.sBranchName = [Common URLDecode:[itemDs objectForKey:@"branchName"]];
                obj.sBranchCode = [itemDs objectForKey:@"branchCode"];
//                obj.nCardId = [[itemDs objectForKey:@"cardId"] intValue];
                obj.nDateExp = [[itemDs objectForKey:@"dateExp"] longLongValue];
                obj.nDateReg = [[itemDs objectForKey:@"dateReg"] longLongValue];
                obj.sCardNumber = [itemDs objectForKey:@"cardNumber"];
                obj.sCardOwnerName = [itemDs objectForKey:@"cardOwnerName"];
                obj.sCardTypeName = [itemDs objectForKey:@"cardTypeName"];
                obj.tenNguoiThuHuong = [itemDs objectForKey:@"tenNguoiThuHuong"];
                obj.cellphoneNumber = [itemDs objectForKey:@"cellphoneNumber"];
                obj.soTien = [itemDs objectForKey:@"soTien"];
                obj.cmnd = [itemDs objectForKey:@"cmnd"];
                obj.tinhThanh = [itemDs objectForKey:@"tinhThanh"];
                obj.quanHuyen = [itemDs objectForKey:@"quanHuyen"];
                obj.phuongXa = [itemDs objectForKey:@"phuongXa"];
                obj.diaChi = [itemDs objectForKey:@"diaChi"];
                obj.noiDung = [itemDs objectForKey:@"noiDung"];
                obj.cardMonth = [[itemDs objectForKey:@"cardMonth"] intValue];
                obj.cardYear = [[itemDs objectForKey:@"cardYear"] intValue];
                obj.otpGetType = [itemDs objectForKey:@"otpGetType"];
                obj.zipCode = [itemDs objectForKey:@"zipCode"];
                obj.thanhPho = [itemDs objectForKey:@"thanhPho"];
                obj.quocGia = [itemDs objectForKey:@"quocGia"];
                obj.ten = [itemDs objectForKey:@"ten"];
                obj.ho = [itemDs objectForKey:@"ho"];
                obj.cvv = [itemDs objectForKey:@"cvv"];
                obj.email = [itemDs objectForKey:@"email"];
                obj.diaChi = [itemDs objectForKey:@"diaChi"];
                obj.sAliasName = [itemDs objectForKey:@"aliasName"];
                NSLog(@"%s - sAliasName : %@", __FUNCTION__, obj.sAliasName);
                if (obj.nType == 8){
                    obj.cvv = @"123";
                }

                if(obj.nType != TAI_KHOAN_THE_RUT_TIEN)
                {
                    NSLog(@"DanhSachTaiKhoanThuongDungController : cellphoneNumber : %@", [itemDs objectForKey:@"cellphoneNumber"]);
                    [dsTaiKhoanThuongDung addObject:obj];
                }
                if (i == 0) {
                    self.edChonTheTheLuu.text = obj.sAliasName;
                    [self capNhatViewTheLuu:obj.cvv];
                    nIndexTheLuu = 0;
                    double fSoTien = [[[self.edSoTienTheLuu.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
                    [self hienThiSoPhiCuaSoTien:fSoTien];
                    [self anNutSuaXoaTheLuu:NO];
                }
                [obj release];
            }

            DucNT_TaiKhoanThuongDungObject *obj = [[DucNT_TaiKhoanThuongDungObject alloc] init];
            obj.sId = @"";
            obj.sPhoneOwner = @"";
            obj.nType = -1;
            obj.sAliasName = @"Thêm thẻ lưu";
            obj.nAmount = 0.0;
            obj.sDesc = @"";
            obj.sToAccWallet = @"";
            obj.sAccOwnerName = @"";
            obj.sBankName = @"";
            obj.sBankNumber = @"";
            obj.sProvinceName = @"";
            obj.nProvinceCode = -1;
            obj.nProvinceID = -1;
            obj.nBankCode = -1;
            obj.nBankId = -1;
            obj.nBranchId = -1;
            obj.sBranchName = @"";
            obj.sBranchCode = @"";
//            obj.nCardId = -1;
            obj.nDateExp = -1;
            obj.nDateReg = -1;
            obj.sCardNumber = @"";
            obj.sCardOwnerName = @"";
            obj.sCardTypeName = @"";
            obj.tenNguoiThuHuong = @"";
            obj.cellphoneNumber = @"";
            obj.soTien = @"";
            obj.cmnd = @"";
            obj.tinhThanh = @"";
            obj.quanHuyen = @"";
            obj.phuongXa = @"";
            obj.diaChi = @"";
            obj.noiDung = @"";
            obj.cvv = @"123";
            if(obj.nType != TAI_KHOAN_THE_RUT_TIEN)
            {
                [dsTaiKhoanThuongDung addObject:obj];
            }
            [obj release];
            UIPickerView *picker = (UIPickerView *)self.edChonTheTheLuu.inputView;
            [picker reloadAllComponents];
        }
    }
    else if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_XOA_TAI_KHOAN_THUONG_DUNG]){
        if (dsTaiKhoanThuongDung.count > nIndexTheLuu) {
            [dsTaiKhoanThuongDung removeObjectAtIndex:nIndexTheLuu];
        }
        if (dsTaiKhoanThuongDung.count > 0) {
            DucNT_TaiKhoanThuongDungObject *obj = [dsTaiKhoanThuongDung objectAtIndex:0];
            self.edChonTheTheLuu.text = obj.sAliasName;
            if (obj.nBankId == -1) {
                [self anNutSuaXoaTheLuu:YES];
            }
        }
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Xoá thẻ lưu thành công"];
        [self anViewXacThuc];
        UIPickerView *picker = (UIPickerView *)self.edChonTheTheLuu.inputView;
        [picker reloadAllComponents];
    }
    else if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_KIEM_TRA_NAP_QUOC_TE]){
        if (!ketQua) {
            return;
        }
        int nValue = (int)[ketQua integerValue];
        NSLog(@"%s - nValue : %d", __FUNCTION__, nValue);
        if (nValue == 0){
            NSLog(@"%s - kiem tra nap tien quoc te", __FUNCTION__);
            if (bKiemTraQuocTe) {
                self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_KIEM_TRA_NAP_QUOC_TE;
                [GiaoDichMang kiemTraNapTienTheQuocTe:nSTT noiNhanKetQua:self];
            }
        }
        else{
            [self anViewXacThuc];
            bKiemTraQuocTe = NO;
            NSString *thongBaoQT = @"Đã trừ tiền thẻ quốc tế và nạp ví thành công";
            if (nValue == 20) {
                thongBaoQT = @"Sai mã OTP.";
            }
            else if (nValue == 19){
                thongBaoQT = @"Kết nối thất bại";
            }
            else if (nValue == 18){
                thongBaoQT = @"Giao dịch bị huỷ";
            }
            else if (nValue == 21){
                thongBaoQT = @"Thông tin thẻ không chính xác";
            }
            else if (nValue == 22){
                thongBaoQT = @"Sai số CVV";
            }
            else if (nValue == 23){
                thongBaoQT = @"Sai số thẻ";
            }
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:thongBaoQT];
        }
    }
    else if ([sDinhDanhKetNoi isEqualToString:@"LAY_DANH_SACH_LIEN_KET"]) {
        NSArray *arrTemp = (NSArray *)ketQua;
        for (NSDictionary *dict in arrTemp) {
            ItemTaiKhoanLienKet *item = [[ItemTaiKhoanLienKet alloc] khoiTao:dict];
            if (item.danhDauTKMacDinh == 1) {
                tkLienKetHienTai = item;
                [self khoiTaoThongTinTaiKhoanLienKet];
                break;
            }
        }
        if (tkLienKetHienTai == nil) {
            if (arrTemp.count > 0) {
                NSDictionary *dict = [arrTemp firstObject];
                ItemTaiKhoanLienKet *item = [[ItemTaiKhoanLienKet alloc] khoiTao:dict];
                tkLienKetHienTai = item;
                [self khoiTaoThongTinTaiKhoanLienKet];
            }
            else {
                NSLog(@"%s - tkLienKetHienTai == nil", __FUNCTION__);
                [self.btnSoTayTKLK setHidden:YES];
                [self.viewSoTienTKLK setHidden:YES];
                [self.btnTiepTucTKLK setHidden:YES];
                [self.lblThongBaoKhongCoTKLK setHidden:NO];
            }
        }
    }
    else if ([sDinhDanhKetNoi isEqualToString:@"YEU_CAU_NAP_TIEN_TAI_KHOAN_LIEN_KET"]) {
//        NSLog(@"%s - ketQua : %@", __FUNCTION__, (NSString *)ketQua);
        NSString *sIdTraVeLienKetTemp = (NSString *)ketQua;
        self.sIdTrangThaiTKLK = sIdTraVeLienKetTemp;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//            self.mDinhDanhKetNoi = @"KIEM_TRA_TRANG_THAI_NAP_TIEN_TAI_KHOAN_LIEN_KET";
//            [GiaoDichMang layTrangThaiNapTienTaiKhoanLienKet:sIdTraVeLienKet session:[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_SECSSION] noiNhanKetQua:self];
//        });
    }
    else if ([sDinhDanhKetNoi isEqualToString:@"KIEM_TRA_TRANG_THAI_NAP_TIEN_TAI_KHOAN_LIEN_KET"]) {
//        NSLog(@"%s - ketQua : %@", __FUNCTION__, (NSString *)ketQua);
        NSDictionary *dict = (NSDictionary *)ketQua;
        int trangThai = [[dict valueForKey:@"trangThai"] intValue];
        if (trangThai == 0) {
            if (nTimeDemGiay > 0) {
                NSString *sIdTraVeLienKet = [dict valueForKey:@"maGiaoDich"];
                NSLog(@"%s - sIdTraVeLienKet : %@", __FUNCTION__, sIdTraVeLienKet);
               self.sIdTrangThaiTKLK = sIdTraVeLienKet;
//                self.mDinhDanhKetNoi = @"KIEM_TRA_TRANG_THAI_NAP_TIEN_TAI_KHOAN_LIEN_KET";
//                [GiaoDichMang layTrangThaiNapTienTaiKhoanLienKet:sIdTraVeLienKet session:[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_SECSSION] noiNhanKetQua:self];
            }
        }
        else if (trangThai == 1 || trangThai == 2) {
            [alertTaiKhoanLienKet dismissWithClickedButtonIndex:0 animated:YES];
            if (timer) {
                [timer invalidate];
                timer = nil;
            }
            NSDictionary *dict = (NSDictionary *)ketQua;
            NSString *sMoTa = [dict valueForKey:@"moTa"];
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sMoTa];

        }
        else if (trangThai == 22) {
            NSDictionary *dict = (NSDictionary *)ketQua;
            self.sIdGiaoDichTKLK = [dict valueForKey:@"maGiaoDich"];
            NSLog(@"%s =================> sIdGiaoDichTKLK : %@", __FUNCTION__, self.sIdGiaoDichTKLK);
            NSString *sMoTa = [dict valueForKey:@"moTa"];
            if (timer) {
                [timer invalidate];
                timer = nil;
            }
            [alertTaiKhoanLienKet dismissWithClickedButtonIndex:0 animated:YES];
            self.lblThongBaoTKLK.text = sMoTa;
            self.viewXacThucTKLK.hidden = NO;
            self.btnTiepTucTKLK.hidden = YES;
            if ([tkLienKetHienTai.maNganHang.lowercaseString hasPrefix:@"nab"]) {
                self.edMaTKLK1.hidden = YES;
                self.edMaTKLK2.hidden = NO;
                self.edMaTKLK3.hidden = NO;
            }
            else {
                self.edMaTKLK1.hidden = NO;
                self.edMaTKLK2.hidden = YES;
                self.edMaTKLK3.hidden = YES;
            }
            CGRect rViewMain = self.mViewMain.frame;
            CGRect rectViewTop = _viewTop.frame;
            CGRect rectLienKet = self.viewTaiKhoanLienKet.frame;
            CGRect rectBtnTiepTuc = self.viewXacThucTKLK.frame;
            rectLienKet.origin.y = rectViewTop.origin.y + rectViewTop.size.height + 10;
            rectLienKet.size.height = rectBtnTiepTuc.origin.y + rectBtnTiepTuc.size.height + 10;
            self.viewTaiKhoanLienKet.frame = rectLienKet;
            if (![self.mViewMain.subviews containsObject:self.viewTaiKhoanLienKet]) {
                [self.mViewMain addSubview:self.viewTaiKhoanLienKet];
            }
            rViewMain.size.height = rectLienKet.origin.y + rectLienKet.size.height + 10;
            self.mViewMain.frame = rViewMain;
            [_mScrv setContentSize:CGSizeMake(_mScrv.frame.size.width, 2 * rViewMain.origin.y + rViewMain.size.height + 40)];
            [self.view setNeedsLayout];
            nTimeDemGiay = 300;
            if ([tkLienKetHienTai.maNganHang.lowercaseString hasPrefix:@"bidv"]) {
                nTimeDemGiay = 120;
            }
            timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownMaXacThucTaiKhoanLienKet:) userInfo:nil repeats:YES];

        }
    }
    else if ([sDinhDanhKetNoi isEqualToString:@"XAC_THUC_NAP_TIEN_TAI_KHOAN_LIEN_KET"]) {
        [self hienThiHopThoaiMotNutBamKieu:110 cauThongBao:sThongBao];
    }
    else if ([sDinhDanhKetNoi isEqualToString:@"HUY_NAP_TIEN_TAI_KHOAN_LIEN_KET"]) {
        [self dungDemTime];
        [self khoiTaoGiaoDienTaiKhoanLienKet];
    }
}

- (void)checkTrangThaiYeuCauNapTienTKLK:(NSString *)sIdTrangThai {
    NSLog(@"%s - sIdTrangThai : %@", __FUNCTION__, sIdTrangThai);
    self.mDinhDanhKetNoi = @"KIEM_TRA_TRANG_THAI_NAP_TIEN_TAI_KHOAN_LIEN_KET";
    [GiaoDichMang layTrangThaiNapTienTaiKhoanLienKet:sIdTrangThai session:[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_SECSSION] noiNhanKetQua:self];
}

- (void)xuLyKetNoiThatBai:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua{
    [self hideLoadingScreen];
    [self anViewXacThuc];
    if(!self.viewLoading.hidden){
        _viewLoading.hidden = YES;
    }
    int nCode = [[ketQua objectForKey:@"msgCode"] intValue];
    if (nCode == 59) {
        if ([self.mDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_NAP_TIEN_TU_THE_QUOC_TE]) {
            if (nHinhThucNap == 1) {
//                [self khoiTaoGiaoDienTheQuocTeBuoc2];
            }
            else if (nHinhThucNap == 3){
                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
            }
        }
    }
    else if ([sDinhDanhKetNoi isEqualToString:@"YEU_CAU_NAP_TIEN_TAI_KHOAN_LIEN_KET"] || [sDinhDanhKetNoi isEqualToString:@"KIEM_TRA_TRANG_THAI_NAP_TIEN_TAI_KHOAN_LIEN_KET"]) {
        bCheckTrangThaiTKLK = NO;
        [alertTaiKhoanLienKet dismissWithClickedButtonIndex:0 animated:YES];
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
    }
    else{
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
    }
}

#pragma mark - UIPickerViewDataSource

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 100) {
        return 3;
    }
    else if (pickerView.tag == 101){
        return 12;
    }
    else if (pickerView.tag == 102){
        return 11;
    }
    else if (pickerView.tag == 103){
            return 3;
    }
    else if (pickerView.tag == 104){
        return dsTaiKhoanThuongDung.count;
    }
    else if (pickerView.tag == 110){
        if (!dsCountry) {
            dsCountry = [[NSMutableArray alloc] initWithArray:[NSLocale ISOCountryCodes]];
        }
        return dsCountry.count;
    }
    if(_mDanhSachNganHangHoTroNapTien)
        return _mDanhSachNganHangHoTroNapTien.count + 1;
    return 1;
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 100) {
        if (row == 0) {
            return @"Visa";
        }
        else if (row == 1){
            return @"MasterCard";
        }
        else{
            return @"JCB";
        }
    }
    else if (pickerView.tag == 101){
        return [NSString stringWithFormat:@"Tháng %d", (int)row + 1];
    }
    else if (pickerView.tag == 102){
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
        NSInteger year = [components year];
        return [NSString stringWithFormat:@"%d", (int)(year + row)];
    }
    else if (pickerView.tag == 103){
        if (row == 0) {
            return @"Viettel";
        }
        else if (row == 1){
            return @"VinaPhone";
        }
        else if (row == 2){
            return @"Mobifone";
        }
        else if (row == 3){
            return @"Vietnamobile";
        }
    }
    else if (pickerView.tag == 104){
        DucNT_TaiKhoanThuongDungObject *item = [dsTaiKhoanThuongDung objectAtIndex:row];
        return item.sAliasName;
    }
    else if (pickerView.tag == 110){
        NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"vi_VN"];
        NSString *countryCode = [dsCountry objectAtIndex:row];
        NSString *displayNameString = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
        return displayNameString;
    }
    if(row == 0)
    {
        return [@"title_hien_thi_chon_ngan_hang" localizableString];
    }
    
    NganHangNapTien *nganHangNapTien = [_mDanhSachNganHangHoTroNapTien objectAtIndex:row - 1];
    return nganHangNapTien.tenBank;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"%s - pickerView.tag : %d", __FUNCTION__, pickerView.tag);
    if (pickerView.tag == 100) {
        if (row == 0) {
            nLoaiTheQuocTe = 1;
            self.edLoaiThe.text = @"Visa";
        }
        else if (row == 1){
            nLoaiTheQuocTe = 2;
            self.edLoaiThe.text = @"MasterCard";
        }
        else{
            nLoaiTheQuocTe = 3;
            self.edLoaiThe.text = @"JCB";
        }
        [self.edLoaiThe resignFirstResponder];
    }
    else if (pickerView.tag == 101){
        self.edThang.text = [NSString stringWithFormat:@"%d", (int)row + 1];
        [self.edThang resignFirstResponder];
    }
    else if (pickerView.tag == 102){
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
        NSInteger year = [components year];
        self.edNam.text = [NSString stringWithFormat:@"%d", (int)(year + row)];
        [self.edNam resignFirstResponder];
    }
    else if (pickerView.tag == 103){
        if (row == 0) {
            nLoaiTheCao = 1;
            self.edLoaiTheCao.text = @"Viettel";
        }
        else if (row == 1){
            nLoaiTheCao = 2;
            self.edLoaiTheCao.text = @"VinaPhone";
        }
        else if (row == 2){
            nLoaiTheCao = 3;
            self.edLoaiTheCao.text = @"Mobifone";
        }
        else if (row == 3){
            nLoaiTheCao = 5;
            self.edLoaiTheCao.text = @"Vietnamobile";
        }
        if (nLoaiTheCao == 12) {
            [_edSoSerial setKeyboardType:UIKeyboardTypeDefault];
        }
        else {
            [_edSoSerial setKeyboardType:UIKeyboardTypeNumberPad];
        }
        [self.edLoaiTheCao resignFirstResponder];
    }
    else if (pickerView.tag == 104){
        nIndexTheLuu = (int)row;
        DucNT_TaiKhoanThuongDungObject *obj = [dsTaiKhoanThuongDung objectAtIndex:nIndexTheLuu];
        self.edChonTheTheLuu.text = obj.sAliasName;
        [self capNhatViewTheLuu:obj.cvv];
        [self.edChonTheTheLuu resignFirstResponder];
        if (nIndexTheLuu == dsTaiKhoanThuongDung.count - 1) {
            [self anNutSuaXoaTheLuu:YES];
        }
        else{
            [self anNutSuaXoaTheLuu:NO];
        }
    }
    else if (pickerView.tag == 110){
        NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"vi_VN"];
        NSString *countryCode = [dsCountry objectAtIndex:row];
        NSString *displayNameString = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
        NSLog(@"%s - %@ - %@", __FUNCTION__, displayNameString, countryCode);
//        self.edQuocGia.text = displayNameString;
//        [self.edQuocGia resignFirstResponder];
        sCountryCode = countryCode;
    }
    else{
        if(row == 0)
        {
            _mtfChonNganHang.text = [@"title_hien_thi_chon_ngan_hang" localizableString];
            self.mNganHangNapTienDaChon = nil;
            mBuocKhoiTao = 1;
//            [self khoiTaoGiaoDien];
        }
        else
        {
            NganHangNapTien *nganHangNapTien = [_mDanhSachNganHangHoTroNapTien objectAtIndex:row - 1];
            _mtfChonNganHang.text = nganHangNapTien.tenBank;
            self.mNganHangNapTienDaChon = nganHangNapTien;
        }
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView isEqual:alertTaiKhoanLienKet]) {
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
    else if (alertView.tag == 110) {
        [self dungDemTime];
        [self khoiTaoGiaoDienTaiKhoanLienKet];
    }
}

#pragma mark - su kien click button
- (void)capNhatViewTheLuu:(NSString *)sCVV{
    NSLog(@"%s - sCVV : %@", __FUNCTION__, sCVV);
    CGRect rectTheLuu = self.viewTheLuu.frame;
    CGRect rectBtnTiepTuc = self.mbtnTiepTuc.frame;
    CGRect rViewMain = self.mViewMain.frame;
    CGRect rectViewTop = self.viewTop.frame;
    if (!sCVV || sCVV.length == 0) {
        if (self.viewCVV.hidden) {
            self.viewCVV.hidden = NO;
            rectTheLuu.size.height = rectTheLuu.size.height + self.viewCVV.frame.size.height;
        }
    }
    else{
        if (!self.viewCVV.hidden) {
            self.viewCVV.hidden = YES;
            rectTheLuu.size.height = rectTheLuu.size.height - self.viewCVV.frame.size.height;
        }
    }
    self.viewTheLuu.frame = rectTheLuu;
    rectBtnTiepTuc.origin.y = rectTheLuu.origin.y + rectTheLuu.size.height + 10;
    self.mbtnTiepTuc.frame = rectBtnTiepTuc;
    rViewMain.size.height = rectBtnTiepTuc.origin.y + rectBtnTiepTuc.size.height + 10;
    self.mViewMain.frame = rViewMain;
    [_mScrv setContentSize:CGSizeMake(_mScrv.frame.size.width, 2 * rViewMain.origin.y + rViewMain.size.height + rectViewTop.size.height + 10)];
}

- (void)anNutSuaXoaTheLuu:(BOOL)bAn{
    self.btnSuaTheLuu.hidden = bAn;
    self.btnXoaTheLuu.hidden = bAn;
    if (bAn) {
        CGRect rectTheLuu = self.edChonTheTheLuu.frame;
        rectTheLuu.size.width = self.edNoiDungTheLuu.frame.size.width;
        self.edChonTheTheLuu.frame = rectTheLuu;
    }
    else{
        CGRect rectTheLuu = self.edChonTheTheLuu.frame;
        rectTheLuu.size.width = 215;
        self.edChonTheTheLuu.frame = rectTheLuu;
    }
}

- (void)thayDoiTrangThaiButtonLuaChon:(int)nIndex{
    mBuocKhoiTao = 1;
    nHinhThucNap = nIndex;
    nSTT = -1;
    [self.btnTheNoiDia setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnTheQuocTe setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnTheCao setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnTheLuu setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnTheLienKet setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

    [self.lblTheNoiDia setBackgroundColor:[UIColor whiteColor]];
    [self.lblTheQuocTe setBackgroundColor:[UIColor whiteColor]];
    [self.lblTheNoiDia setTextColor:[UIColor grayColor]];
    [self.lblTheQuocTe setTextColor:[UIColor grayColor]];

    [self.btnTheQuocTe setBackgroundColor:[UIColor whiteColor]];
    [self.btnTheNoiDia setBackgroundColor:[UIColor whiteColor]];
    [self.btnTheCao setBackgroundColor:[UIColor whiteColor]];
    [self.btnTheLuu setBackgroundColor:[UIColor whiteColor]];
    [self.btnTheLienKet setBackgroundColor:[UIColor whiteColor]];
    switch (nIndex) {
        case 0:
            [self.btnTheNoiDia setBackgroundColor:[UIColor colorWithHexString:@"#015079"]];
            [self.btnTheNoiDia setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        case 1:
            [self.btnTheQuocTe setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.btnTheQuocTe setBackgroundColor:[UIColor colorWithHexString:@"#015079"]];
            break;
        case 2:
            [self.btnTheCao setBackgroundColor:[UIColor colorWithHexString:@"#015079"]];
            [self.btnTheCao setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        case 3:
            [self.btnTheLuu setBackgroundColor:[UIColor colorWithHexString:@"#015079"]];
            [self.btnTheLuu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        case 4:
            [self.btnTheLienKet setBackgroundColor:[UIColor colorWithHexString:@"#015079"]];
            [self.btnTheLienKet setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (IBAction)thayDoiSoTienTKLienKet:(id)sender {
    double fSoTien = [[[self.edSoTienLienKet.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
    if(fSoTien > 0)
        self.edSoTienLienKet.text = [Common hienThiTienTe:fSoTien];
    else
        self.edSoTienLienKet.text = @"";
//    [self hienThiSoPhiCuaSoTien:fSoTien];
}

- (IBAction)suKienChonDanhBaTheQuocTe:(id)sender {
    ContactScreen *danhBa = [[[ContactScreen alloc] initWithNibName:@"ContactScreen" bundle:nil] autorelease];
    danhBa.mKieuHienThiLienHe = KIEU_HIEN_THI_LIEN_HE_THUONG;
    [self.navigationController pushViewController:danhBa animated:YES];
    __block NapViTuTheNganHangViewController *weakSelf = self;
    [danhBa selectContact:^(NSString *phone, Contact *contact)
     {
         if (phone != nil && phone.length > 0)
         {
             if([Common kiemTraLaMail:phone])
             {
                 weakSelf.edViCanNapQT.text = phone;
             }
             else
             {
                 weakSelf.edViCanNapQT.text = [phone stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [phone length])];
             }
         }
         [danhBa.navigationController popViewControllerAnimated:YES];
     }];
}

- (IBAction)suKienChonDanhBaTheCao:(id)sender {
    ContactScreen *danhBa = [[[ContactScreen alloc] initWithNibName:@"ContactScreen" bundle:nil] autorelease];
    danhBa.mKieuHienThiLienHe = KIEU_HIEN_THI_LIEN_HE_THUONG;
    [self.navigationController pushViewController:danhBa animated:YES];
    __block NapViTuTheNganHangViewController *weakSelf = self;
    [danhBa selectContact:^(NSString *phone,Contact *contact)
     {
         if (phone != nil && phone.length > 0)
         {
             if([Common kiemTraLaMail:phone])
             {
                 weakSelf.edViTheCao.text = phone;
             }
             else
             {
                 weakSelf.edViTheCao.text = [phone stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [phone length])];
             }
         }

         [danhBa.navigationController popViewControllerAnimated:YES];
     }];
}

- (IBAction)suKienChonThLuu:(id)sender {
    if (nHinhThucNap == 3) {
        return;
    }
    NSString *sHtml = @"<html><head><style>body {font-size: 15px;}</style></head><body><p>1. CHUYỂN KHOẢN ĐẾN 1 TRONG 34 NGÂN HÀNG:</br></p><p ><strong>Trong nội dung phải ghi ví nhận !</strong></br><em>ví dụ: 0xxxxxxxxx; fb_xxx@gmail.com;gg_xxx@gmail.com; dn_xxxxxxxxxx</em></br><em>(thực hiện từ 3 tới 5 phút sau khi nhận tiền)</em></br></p>  <p><strong>Nông nghiệp &amp; PTNT VN - Đông Hà Nội</strong></br>Chủ TK: <strong>Vimass</strong> | Số TK: <strong >1420201006070</strong> </br></p>  <p><strong>Đầu tư phát triển VN (BID) - CN Tràng An</strong></br>Chủ TK: <strong>Vimass</strong> | Số TK: <strong >26110001036666</strong> </br></p>  <p><strong>Công thương Việt Nam (CTG) - CN Hà Nội</strong></br>Chủ TK: <strong>Vimass</strong> | Số TK: <strong >102010001821271</strong> </br></p>  <p><strong>Ngoại thương VN (VCB) - Sở giao dịch</strong></br>Chủ TK: <strong>Vimass</strong> | Số TK: <strong >0011004226666</strong> </br></p>  <p><strong>An Bình (ABB) - CN Hà Nội</strong></br>Chủ TK: <strong>Vimass</strong> | Số TK: <strong >0771003852052</strong> </br></p>  <p><strong>Á Châu (ACB) - CN Hà Nội</strong></br>Chủ TK: <strong>Vimass</strong> | Số TK: <strong >1155668888</strong> </br></p>  <p><strong>Bắc Á (BAB) - CN Thái Hà</strong></br>Chủ TK: <strong>Vimass</strong> | Số TK: <strong >130001060001329</strong> </br></p>  <p><strong>Bảo Việt (BVB) - CN Sở giao dịch</strong></br><strong>Cty TNHH dịch vụ nền di động Việt Nam</strong></br>Số TK: <strong >0171001829003</strong> </br></p>  <p><strong>Đông Á (EAB) - CN Hà Nội</strong></br>Chủ TK: <strong>Vimass</strong> | Số TK: <strong >012846470001</strong> </br></p><p><strong>Xuất nhập khẩu VN (EIB) - CN Ba Đình</strong></br>Chủ TK: <strong>Vimass</strong> | Số TK: <strong >172314851023516 </strong></p><p><strong>Dầu khí toàn cầu - Sở giao dịch</strong></br>Chủ TK: <strong>Cty TNHH dịch vụ nền di động Việt Nam</strong> | Số TK: <strong >00100001176147</strong><br/></p><p><strong>Phát triển HCM (HDB) - CN Hoàn Kiếm</strong></br>Chủ TK: <strong>Vimass</strong> | Số TK: <strong >020704070028086</strong></br></p><p><strong>Kiên Long (KLB) - CN Hà Nội</strong></br>Chủ TK: <strong>Vimass</strong> | Số TK: <strong >9467353</strong> </br></p><p><strong>Bưu điện Liên Việt (LPB) - CN Đông đô </strong></br>Chủ TK: <strong>Vimass</strong> | Số TK: <strong >999994949999</strong></br></p><p><strong>Quân đội (MB) - CN Ba Đình</strong></br>Chủ TK: <strong>Vimass</strong> | Số TK: <strong >0861111006666</strong></br></p><p><strong>Hàng hải (MSB) – CN Hà Nội </strong></br>Chủ TK: <strong>Vimass</strong> | Số TK: <strong >03001010510159</strong></br></p><p><strong>Nam Á (NAB) - CN Hà Nội  </strong> </br>Chủ TK: <strong>Vimass</strong> | Số TK: <strong >801014987666666 </strong></br></p><p><strong>Quốc Dân (NCB) - CN Hà Nội</strong> </br>Chủ TK: <strong>Vimass</strong> | Số TK: <strong >10410000866666</strong> </br></p><p><strong>Phương đông (OCB) - CN Thăng Long</strong></br>Chủ TK: <strong>Vimass</strong> | Số TK: <strong >0117100003492007</strong></br></p><p><strong>Đại dương - CN Hà Nội</strong></br>Chủ TK: <strong>Cty TNHH dịch vụ nền di động VN</strong> | Số TK: <strong >83083076783500068</strong></br></p><p><strong>Xăng dầu Petrolimex - CN Hà Nội</strong></br>Chủ TK: <strong>Cty TNHH dịch vụ nền di động VN</strong> | Số TK: <strong >1267040071134</strong></br></p><p><strong>Đại chúng Việt Nam (PVB) - CN Hà Nội</strong></br>Chủ TK: <strong>Vimass</strong> | Số TK: <strong >000000003332</strong></br></p><p><strong>Sài Gòn (SCB) - CN Hai Bà Trưng</strong> </br>Chủ TK: <strong>Vimass</strong> | Số TK: <strong >0510105531750001</strong></br></p><p><strong>Đông Nam Á (SEAB) - Sở Giao dịch</strong></br><strong>Cty TNHH dịch vụ nền di động Việt Nam</strong></br>Số TK: <strong >00200013739536 </strong></br></p>  <p><strong>Sài Gòn công thương (SGB) - CN Cầu Giấy</strong></br>Chủ TK: <strong>Vimass</strong> | Số TK: <strong >700770406001292</strong> </br></p><p><strong>Sài Gòn - Hà Nội (SHB) - Hội Sở</strong></br>Chủ TK: <strong>Vimass</strong> | Số TK: <strong >1003827810 </strong></br></p><p><strong>Sài Gòn thương tín (STB) - CN Thủ Đô  </strong> </br>Chủ TK: <strong>Vimass</strong> | Số TK: <strong >020025881266 </strong> </br></p><p><strong>Techcombank (TCB) - CN Hà Thành</strong></br><strong>Cty TNHH dịch vụ nền di động Việt Nam</strong></br>Số TK: <strong >19027805721010</strong></br></p>  <p><strong>Tiên Phong (TPB) - Hoàn Kiếm</strong></br><strong>Cty TNHH dịch vụ nền di động Việt Nam</strong></br>Số TK: <strong >00199734001 </strong></br></p>  <p><strong>Việt Á (VAB) - CN Hà Nội</strong></br>Chủ TK: <strong>Vimass</strong> | Số TK: <strong >5020000002829000</strong> </br></p><p><strong>Việt Nam Thương Tín (VB)</strong></br><strong>Cty TNHH dịch vụ nền di động Việt Nam</strong><br/>Số TK: <strong >12525537</strong> </br></p>  <p><strong>Bản Việt (VCCB) - CN Hà Nội</strong></br>Chủ TK: <strong>Vimass</strong> | Số TK: <strong >0217041086666</strong> </br></p>  <p><strong>Quốc tế (VIB) - CN Ba Đình</strong></br><strong>Cty TNHH dịch vụ nền di động Việt Nam</strong> </br>Số TK: <strong >040704060027887 </strong></br></p>  <p><strong>Việt Nam Thịnh Vượng (VPB) - Hội sở</strong></br>Chủ TK: <strong>Vimass</strong> | Số TK: <strong >59523333 </strong></br></p></body></html>";
    [self.webTaiKhoan loadHTMLString:sHtml baseURL:nil];
    [self thayDoiTrangThaiButtonLuaChon:3];
    [self dungDemTime];
    bKiemTraQuocTe = NO;
    mBuocKhoiTao = 1;
    [self.edCVVTheLuu setMax_length:4];
    self.edSoTienTheLuu.text = @"";
    self.edSoTienTheLuu.text = @"";
    self.edNoiDungTheLuu.text = @"";
    [_viewTheLuu setHidden:NO];
    [self.viewQuocTe setHidden:YES];
    [self.viewQuocTe2 setHidden:YES];
    [_mViewThongTinBuoc1 setHidden:YES];
    [_mViewThongTinBuoc2 setHidden:YES];
    [self.viewNapTheCao setHidden:YES];
    self.mbtnTiepTuc.hidden = YES;
    self.viewTaiKhoanLienKet.hidden = YES;
    self.webTaiKhoan.hidden = NO;
    CGRect rectMain = self.mViewMain.frame;
    rectMain.size.height = [UIScreen mainScreen].bounds.size.height - self.viewTop.frame.size.height- 35;
    self.mViewMain.frame = rectMain;
}

- (IBAction)suKienChonDanhBaTheLuu:(id)sender {
    ContactScreen *danhBa = [[[ContactScreen alloc] initWithNibName:@"ContactScreen" bundle:nil] autorelease];
    danhBa.mKieuHienThiLienHe = KIEU_HIEN_THI_LIEN_HE_THUONG;
    [self.navigationController pushViewController:danhBa animated:YES];
    __block NapViTuTheNganHangViewController *weakSelf = self;
    [danhBa selectContact:^(NSString *phone, Contact *contact)
     {
         if (phone != nil && phone.length > 0)
         {
             if([Common kiemTraLaMail:phone])
             {
                 weakSelf.edViCanNapTheLuu.text = phone;
             }
             else
             {
                 weakSelf.edViCanNapTheLuu.text = [phone stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [phone length])];
             }
         }
         [danhBa.navigationController popViewControllerAnimated:YES];
     }];
}

- (IBAction)suKienChonSoTayDirect:(id)sender {
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return;
    }
    int nLoaiTaiKhoan = 8;
    if (nHinhThucNap == 1) {
        nLoaiTaiKhoan = 9;
    }
    DucNT_DanhSachTaiKhoanThuongDungControllerViewController *vc = [[DucNT_DanhSachTaiKhoanThuongDungControllerViewController alloc] initWithType:nLoaiTaiKhoan];
    [self.navigationController presentViewController:vc animated:YES completion:^{}];
    [vc release];
}

- (IBAction)suKienChonSoTayTKLK:(id)sender {
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return;
    }
    GiaoDienDanhSachTaiKhoanLienKet *vc = [[GiaoDienDanhSachTaiKhoanLienKet alloc] initWithNibName:@"GiaoDienDanhSachTaiKhoanLienKet" bundle:nil];
    vc.nType = 1;
    [self.navigationController presentViewController:vc animated:YES completion:nil];
    vc.delegate = self;
    [vc release];
}

- (void)suKienChinhSuaTaiKhoanLienKet:(ItemTaiKhoanLienKet *)taiKhoan {
    tkLienKetHienTai = taiKhoan;
    [self khoiTaoThongTinTaiKhoanLienKet];
}

- (IBAction)suKienChonTheNoiDia:(id)sender {
    self.viewTaiKhoanLienKet.hidden = YES;
    [self.webTaiKhoan setHidden:YES];
    [self.webTaiKhoan setHidden:YES];
    [self.mbtnTiepTuc setHidden:NO];
    [self.mViewMain bringSubviewToFront:self.mbtnTiepTuc];
    if (nHinhThucNap == 0) {
        return;
    }
    self.mtfSoTien.text = @"";
    [self hienThiSoPhiCuaSoTien:0];
    [self dungDemTime];
    bKiemTraQuocTe = NO;
    mOtpDirect = otpGetTypeSMS;
    [self thayDoiTrangThaiButtonLuaChon:0];
    [self.viewNapTheCao setHidden:YES];
    [self.viewTheLuu setHidden:YES];
    [self.viewQuocTe setHidden:YES];
    [self.viewQuocTe2 setHidden:YES];
    [self khoiTaoBanDau];
}

- (IBAction)suKienChonTheQuocTe:(id)sender {
    if (nHinhThucNap == 1) {
        return;
    }
    self.viewTaiKhoanLienKet.hidden = YES;
    [self.webTaiKhoan setHidden:YES];
    self.mbtnTiepTuc.hidden = NO;
    self.edHo.text = @"";
    [self hienThiSoPhiCuaSoTien:0];
    [self dungDemTime];
    bKiemTraQuocTe = NO;
    [self thayDoiTrangThaiButtonLuaChon:1];
    [self khoiTaoGiaoDienTheQuocTe];
    [self khoiTaoGiaoDienTheQuocTeBuoc2];
}

- (IBAction)suKienChonTheCao:(id)sender {
    if (nHinhThucNap == 2) {
        return;
    }
    self.viewTaiKhoanLienKet.hidden = YES;
    [self.webTaiKhoan setHidden:YES];
    self.mbtnTiepTuc.hidden = NO;
    [self hienThiSoPhiCuaSoTien:0];
    [self dungDemTime];
    bKiemTraQuocTe = NO;
    [self thayDoiTrangThaiButtonLuaChon:2];
    [self khoiTaoGiaoDienNapTienBangTheCao];
}

- (IBAction)suKienChonTaiKhoanLienKet:(id)sender {
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return;
    }
    if (nHinhThucNap == 4) {
        return;
    }
    self.viewTaiKhoanLienKet.hidden = NO;
    [self.webTaiKhoan setHidden:YES];
    self.mbtnTiepTuc.hidden = YES;

    [self.viewNapTheCao setHidden:YES];
    [self.viewTheLuu setHidden:YES];
    [self.viewQuocTe setHidden:YES];
    [self.viewQuocTe2 setHidden:YES];
    [_mViewThongTinBuoc1 setHidden:YES];
    [_mViewThongTinBuoc2 setHidden:YES];
    
    [self hienThiSoPhiCuaSoTien:0];
    [self dungDemTime];
    bKiemTraQuocTe = NO;
    [self thayDoiTrangThaiButtonLuaChon:4];
    [self khoiTaoGiaoDienTaiKhoanLienKet];
    if (!tkLienKetHienTai) {
        self.mDinhDanhKetNoi = @"LAY_DANH_SACH_LIEN_KET";
        [GiaoDichMang layDanhSachTaiKhoanLienKet:self];
    }
}

- (void)khoiTaoThongTinTaiKhoanLienKet {
    NSString *sDsBank = @"BID - Đầu tư và phát triển Việt Nam/CTG - Công thương Việt Nam/VCB - Ngoại thương Việt Nam/ABB - An bình/ACB - Á châu/BAB - Bắc á/BVB - Bảo Việt/EAB - Đông á/EIB - Xuất nhập khẩu Việt Nam/GPB - Dầu khí toàn cầu/HDB - Phát triển TPHCM/KLB - Kiên Long/LPB - Bưu điện Liên Việt/MB - Quân đội/MSB - Hàng hải/NAB - Nam á/NCB - Quốc dân/OCB -  Phương đông/OJB - Đại dương/PGB - Xăng dầu Petrolimex/PVB - Đại chúng Việt Nam/SCB - Sài Gòn/SEAB - Đông nam á/SGB - Sài Gòn công thương/SHB - Sài Gòn - Hà Nội/STB - Sài Gòn thương tín/TCB - Kỹ thương Việt Nam/TPB - Tiên Phong/VAB - Việt Á/VB - Việt Nam thương tín/VCCB - Bản Việt/VIB - Quốc tế/VPB - Việt Nam thịnh vượng";
    NSArray *arrTemp = [sDsBank componentsSeparatedByString:@"/"];
    for (NSString *sBank in arrTemp) {
        if ([sBank hasPrefix:tkLienKetHienTai.maNganHang]) {
            self.lblBankLienKet.text = sBank;
            break;
        }
    }
    self.lblChuTKLienKet.text = [NSString stringWithFormat:@"%@: %@", [@"chu_tai_khoan" localizableString], tkLienKetHienTai.tenChuTaiKhoan];
    self.lblSoTKLienKet.text = [NSString stringWithFormat:@"%@: %@", [@"register_account_link_acc_no" localizableString], tkLienKetHienTai.soTaiKhoan];
    self.lblUserTKLK.text = [NSString stringWithFormat:@"%@: %d %@", [@"ten_dang_nhap_ibanking" localizableString], tkLienKetHienTai.lengthU, [@"ky_tu" localizableString]];
    self.lblMKTKLK.text = [NSString stringWithFormat:@"%@: %d %@", [@"matkhau_dang_nhap_ibanking" localizableString], tkLienKetHienTai.lengthP, [@"ky_tu" localizableString]];
    self.lblViCanNapTKLK.text = [NSString stringWithFormat:@"%@: %@", [@"vi_can_nap" localizableString], [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP]];
}

- (IBAction)suKienChonTiepTucTaiKhoanLienKet:(id)sender {
    NSLog(@"%s - click", __FUNCTION__);

    if (self.edSoTienLienKet.text.length == 0) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập số tiền muốn nạp"];
        return;
    }
    else {
        double fSoTien = [[[self.edSoTienLienKet.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
        if (fSoTien < 10000) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Số tiền nạp ví phải lớn hơn 10.000 đ"];
            return;
        }
    }
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    nTimeDemGiay = 180;
    [self hienThiThongBaoNapTienTaiKhoanLienKet:[NSString stringWithFormat:@"%d", nTimeDemGiay]];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownTaiKhoanLienKet:) userInfo:nil repeats:YES];
    bCheckTrangThaiTKLK = NO;
    self.sIdTrangThaiTKLK = @"";
    self.mDinhDanhKetNoi = @"YEU_CAU_NAP_TIEN_TAI_KHOAN_LIEN_KET";
    double fSoTien = [[[self.edSoTienLienKet.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
    [GiaoDichMang yeuCauNapTienTuTaiKhoanLienKet:tkLienKetHienTai.sId session:[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_SECSSION] soTien:[NSString stringWithFormat:@"%.0f", fSoTien] noiNhanKetQua:self];
}

- (IBAction)suKienChonThucHienNapTienTKLK:(id)sender {

    NSString *sMaXacThuc = self.edMaTKLK1.text;
    if ([tkLienKetHienTai.maNganHang.lowercaseString hasPrefix:@"nab"]) {
        if (self.edMaTKLK2.text.length == 1 && self.edMaTKLK3.text.length == 1) {
            sMaXacThuc = [NSString stringWithFormat:@"%@,%@", self.edMaTKLK2.text, self.edMaTKLK2.text];
        }
        else {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Mã xác thực trong mỗi ô nhập là 1 ký tự. Vui lòng xem hướng dẫn."];
            sMaXacThuc = @"";
        }
    }
    if (sMaXacThuc.length > 0) {
        self.mDinhDanhKetNoi = @"XAC_THUC_NAP_TIEN_TAI_KHOAN_LIEN_KET";
        [GiaoDichMang xacThucYeuCauNapTienTaiKhoanLienKet:self.sIdGiaoDichTKLK maXacThuc:sMaXacThuc noiNhanKetQua:self];
    }
}

- (IBAction)suKienChonHuyNapTienTKLK:(id)sender {
    [self dungDemTime];
    self.mDinhDanhKetNoi = @"HUY_NAP_TIEN_TAI_KHOAN_LIEN_KET";
    [GiaoDichMang huyYeuCauNapTienTaiKhoanLienKet:self.sIdGiaoDichTKLK noiNhanKetQua:self];
}

- (void)countDownTaiKhoanLienKet:(NSTimer *)time {
    nTimeDemGiay --;
    [self hienThiThongBaoNapTienTaiKhoanLienKet:[NSString stringWithFormat:@"%d", nTimeDemGiay]];
    if (nTimeDemGiay <= 0) {
        nTimeDemGiay = 0;
        [alertTaiKhoanLienKet dismissWithClickedButtonIndex:1 animated:YES];
        [self dungDemTime];
    }
    else {
        NSLog(@"%s - self.sIdTrangThaiTKLK : %@", __FUNCTION__, self.sIdTrangThaiTKLK);
        if (self.sIdTrangThaiTKLK.length > 0) {
            self.mDinhDanhKetNoi = @"KIEM_TRA_TRANG_THAI_NAP_TIEN_TAI_KHOAN_LIEN_KET";
            [GiaoDichMang layTrangThaiNapTienTaiKhoanLienKet:self.sIdTrangThaiTKLK session:[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_SECSSION] noiNhanKetQua:self];
            self.sIdTrangThaiTKLK = @"";
        }
    }
}

- (void)countDownMaXacThucTaiKhoanLienKet:(NSTimer *)time {
    NSLog(@"%s - tick", __FUNCTION__);
    nTimeDemGiay --;
    self.lblXacThucTKLK.text = [NSString stringWithFormat:@"%@ %d s", [@"thoi_gian_cho" localizableString], nTimeDemGiay];
    if (nTimeDemGiay <= 0) {
        nTimeDemGiay = 0;
        [self dungDemTime];
        self.lblXacThucTKLK.text = [NSString stringWithFormat:@"%@ 300s", [@"thoi_gian_cho" localizableString]];
        self.viewXacThucTKLK.hidden = YES;
        self.btnTiepTucTKLK.hidden = NO;
        CGRect rViewMain = self.mViewMain.frame;
        CGRect rectBtnTiepTuc = self.viewXacThucTKLK.frame;
        rViewMain.size.height = rectBtnTiepTuc.origin.y + rectBtnTiepTuc.size.height - 30;
        self.mViewMain.frame = rViewMain;
        [self.mScrv setContentOffset:CGPointMake(0, 0) animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[@"thong_bao" localizableString] message:@"Hết thời hạn giao dịch" delegate:nil cancelButtonTitle:[@"close" localizableString] otherButtonTitles: nil];
        [alert show];
    }
}

- (void)hienThiThongBaoNapTienTaiKhoanLienKet:(NSString *)thongBao {
    if (!alertTaiKhoanLienKet) {
        alertTaiKhoanLienKet = [[UIAlertView alloc] initWithTitle:[@"thong_bao" localizableString] message:thongBao delegate:self cancelButtonTitle:[@"huy_giao_dich" localizableString] otherButtonTitles: nil];
        alertTaiKhoanLienKet.tag = 1101988;
        alertTaiKhoanLienKet.delegate = self;
    }
    [alertTaiKhoanLienKet show];
    dispatch_async(dispatch_get_main_queue(), ^{
        [alertTaiKhoanLienKet setMessage:[NSString stringWithFormat:@"%@: %@ s", [@"thoi_gian_cho" localizableString], thongBao]];
    });
}

- (IBAction)suKienChonXemZipCode:(id)sender {
    GiaoDienBangMaZipCode *zipcode = [[GiaoDienBangMaZipCode alloc] initWithNibName:NSStringFromClass([GiaoDienBangMaZipCode class]) bundle:nil];
    [self.navigationController pushViewController:zipcode animated:YES];
    [zipcode release];
}

- (IBAction)suKienChonSuaThongTinTheLuu:(id)sender {
    if (dsTaiKhoanThuongDung && dsTaiKhoanThuongDung.count > 1) {
        DucNT_TaiKhoanThuongDungObject *obj = [dsTaiKhoanThuongDung objectAtIndex:nIndexTheLuu];
        GiaoDienTaoTheLuu *theLuu = [[GiaoDienTaoTheLuu alloc] initWithNibName:@"GiaoDienTaoTheLuu" bundle:nil];
        theLuu.nTrangThai = 1;
        theLuu.objTheLuu = obj;
        [self.navigationController pushViewController:theLuu animated:YES];
        [theLuu release];
    }
}

- (IBAction)suKienXoaTheLuu:(id)sender {
    if (dsTaiKhoanThuongDung && dsTaiKhoanThuongDung.count > 1) {
        [self khoiTaoViewXacThuc];
        DucNT_TaiKhoanThuongDungObject *obj = [dsTaiKhoanThuongDung objectAtIndex:nIndexTheLuu];
        if (viewXacThuc) {
            viewXacThuc.lblTitle.text = [NSString stringWithFormat:@"Xoá thẻ %@", obj.sAliasName];
        }
    }
}

- (IBAction)suKienChonViThuongDung:(id)sender {
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return;
    }
    DucNT_DanhSachTaiKhoanThuongDungControllerViewController *vc = [[DucNT_DanhSachTaiKhoanThuongDungControllerViewController alloc] initWithType:TAI_KHOAN_VI];
    vc.bChuyenGiaoDien = YES;
    [self.navigationController presentViewController:vc animated:YES completion:^{}];
    [vc release];
}

- (void)xuLySuKienXacThucVoiKieu:(NSInteger)nKieuXacThuc token:(NSString*)sToken otp:(NSString*)sOtp{
    DucNT_TaiKhoanThuongDungObject *obj = [dsTaiKhoanThuongDung objectAtIndex:nIndexTheLuu];
    if (obj.sId.length > 0) {
        self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_XOA_TAI_KHOAN_THUONG_DUNG;
        NSLog(@"%s - self.mDinhDanhKetNoi : %@", __FUNCTION__, self.mDinhDanhKetNoi);
        [GiaoDichMang ketNoiXoaTaiKhoanThuongDung:obj.sId kieuLay:obj.nType token:sToken otp:sOtp typeAuthenticate:(int)nKieuXacThuc noiNhanKetQua:self];
    }
}

#pragma mark - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [_webTaiKhoan release];
    if(_mIDOtpDirect)
        [_mIDOtpDirect release];
    if(_mNganHangNapTienDaChon)
        [_mNganHangNapTienDaChon release];
    if(_mDanhSachNganHangHoTroNapTien)
        [_mDanhSachNganHangHoTroNapTien release];
//    [_mViewMain release];
    [_mViewThongTinBuoc1 release];
    [_mViewThongTinBuoc2 release];
    [_mtfSoViCanNapTien release];
    [_mtfSoTien release];
    [_mtfSoPhi release];
    [_mtvNoiDung release];
    [_mtfNoiDung release];
    [_mtfChonNganHang release];
    [_mtfSoThe release];
    [_mtfTenChuThe release];
    [_mtfNamMoThe release];
    [_mtfThangMoThe release];
    [_mbtnTiepTuc release];
    [_mScrv release];
    [_mbtnChonMaXacThucNhanQuaSMS release];
    [_mbtnChonMaXacThucSuDungToken release];
    [_mViewXacNhanOtp release];
    [_mViewChuaThongBao release];
    [_mtfXacNhan release];
    [_mViewChuaNutDanhBaVaThuongDung release];
    [_mbtnDanhBaViCanNap release];
    [_viewTop release];
    [_btnTheNoiDia release];
    [_btnTheQuocTe release];
    [_btnTheCao release];
    [_viewQuocTe release];
    [_edViCanNapQT release];
    [_edLoaiThe release];
    [_edSoThe release];
    [_edSoTienQT release];
    [_lblPhiQT release];
    [_viewQuocTe2 release];
    [_edNoiDungQT release];
    [_tvNoiDungQT release];

    [_edCVV release];
    [_edThang release];
    [_edNam release];
    [_edHo release];

    [_viewNapTheCao release];
    [_edViTheCao release];
    [_edLoaiTheCao release];
    [_edSoSerial release];
    [_edMaThe release];
    [_edNoiDungTheCao release];
    [_lblTheNoiDia release];
    [_lblTheQuocTe release];
    [_btnTheLuu release];
    [_viewTheLuu release];
    [_edViCanNapTheLuu release];
    [_edSoTienTheLuu release];
    [_edNoiDungTheLuu release];
    [_edChonTheTheLuu release];
    [_viewCVV release];

    [_tvNoiDungTheLuu release];
    [_viewLoading release];
    [_lblPhiTheLuu release];
    [_lblPhiTheCao release];
    [_lblDemGiay release];
    [_btnSuaTheLuu release];
    [_btnXoaTheLuu release];
    [_btnGuiXacNhan release];
    [_btnSoLuuDirect release];
    [_btnSoLuuQT release];
    [_btnSoTayThuongDung release];
    [_btnSoTayThuongDungLoaiThe release];
    [_btnSoTayNoiDia release];
    [_viewTaiKhoanLienKet release];
    [_btnTheLienKet release];
    [_lblBankLienKet release];
    [_lblChuTKLienKet release];
    [_lblSoTKLienKet release];
    [_lblUserTKLK release];
    [_lblMKTKLK release];
    [_lblViCanNapTKLK release];
    [_edSoTienLienKet release];
    [_viewXacThucTKLK release];
    [_edMaTKLK1 release];
    [_edMaTKLK2 release];
    [_edMaTKLK3 release];
    [_lblXacThucTKLK release];
    [_lblThongBaoTKLK release];
    [_btnTiepTucTKLK release];
    [_btnSoTayTKLK release];
    [_sIdGiaoDichTKLK release];
    [_lblThongBaoKhongCoTKLK release];
    [_viewSoTienTKLK release];
    [super dealloc];
}
@end
