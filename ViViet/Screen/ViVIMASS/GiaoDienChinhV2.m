//
//  GiaoDienChinhV2.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 10/30/15.
// Đồng chí nào tiếp nhận sau bỏ thời gian ra chỉnh lại cho chuyên nghiệp nhé :))
//
//

#import "GiaoDienChinhV2.h"
#import "GiaoDienBenTrai.h"
#import "DucNT_LoginSceen.h"
#import "DucNT_LoginSceen.h"
#import "ViewNavigationGiaoDienChinh.h"
#import "DichVuNotification.h"
#import "GiaoDienChinhTableViewCell.h"
#import "DucNT_ChangPrivateInformationViewController.h"
#import "DucNT_SaoKeViewController.h"
#import "DucNT_ChuyenTienViDenViViewController.h"
#import "DucNT_ChuyenTienDenTheViewController.h"
#import "DucNT_ChuyenTienDenTaiKhoanViewController.h"
#import "HienThiDanhSachTinQuangBaViewController.h"
#import "HuongDanNapTienViewController.h"
#import "ChuyenTienViewController.h"
#import "MuonTienViewController.h"
#import "DucNT_HienThiTokenViewController.h"
#import "ThanhToanDienThoaiKhacViewController.h"
#import "DanhSachQuaTangViewController.h"
#import "ThanhToanDienThoaiViettelViewController.h"
#import "TraCuuTienDienViewController.h"
#import "DucNT_DangKyToken.h"
#import "DucBT_ShareViewController.h"
#import "NapViTuTheNganHangViewController.h"
#import "SideViewController.h"
#import "GuiTietKiemViewController.h"
#import "ChuyenTienDenViMomoViewController.h"
#import "ChuyenTienTanNhaViewController.h"
#import "DanhSachNguoiDangChatTaiChinhViewController.h"
#import "GiaoDienThongTinViDoanhNghiep.h"
#import "GiaoDienDatVeXemPhim.h"
#import "GiaoDienThanhToanInternet.h"
#import "GiaoDienChinhHeaderV2.h"
#import "KASlideShow.h"
#import "GiaoDienDiemGiaoDichV2.h"
#import "GiaoDienGopY.h"
#import "GiaoDienDatVeMayBay.h"
#import "GiaoDienThanhToanNuoc.h"
#import "GiaoDienChuyenTienATM.h"
#import "GiaoDienTraCuuTruyenHinh.h"
#import "GiaoDienThanhToanHocPhi.h"
#import "GiaoDienChuyenTienDenCMND.h"
#import "UIButton+WebCache.h"
#import "GiaoDienTraCuuTienVay.h"
#import "GiaoDienThanhToanChungKhoan.h"
#import "CollectionCellGiaoDienChinh.h"
#import "GiaoDienDangNhapMoi.h"
#import "GiaoDienTaiKhoanLienKet.h"
#import "Reachability.h"
#import "GiaoDienBaoHiem.h"
#import "GiaoDienDatVeXe.h"
#import "QRCodeReaderDelegate.h"
#import "QRCodeReaderViewController.h"
#import "QRCodeReader.h"
#import "GiaoDienThanhToanQRCode.h"
#import "GiaoDienThanhToanQRCodeDonVi.h"
#import "GiaoDienGioiThieuVi.h"
#import "QRDonViViewController.h"
#import "FBEncryptorAES.h"
#import "GiaoDienDenKhac.h"


@interface GiaoDienChinhV2 ()<GiaoDienBenTraiDelegate, ViewNavigationGiaoDienChinhDelegate, DucNT_ServicePostDelegate, GiaoDienChinhHeaderV2Delegate, UIActionSheetDelegate, QRCodeReaderDelegate>{
    IBOutlet SideViewContainer *mSliderContainer;
    ViewNavigationGiaoDienChinh *mViewNavigationGiaoDienChinh;
    Drawer *mDrawer;
    GiaoDienBenTrai *mGiaoDienBenTrai;
    NSString *mDinhDanhKetNoi;
    BOOL mTrangThaiDangOViewBenTrai;
    bool isChuyenGiaoDien;
    GiaoDienChinhHeaderV2 *headerView;
    KASlideShow *showQC;
    bool isLoadQC;
    QRCodeReaderViewController *vcQRCode;
    NSString *keyPin;
}

@property (nonatomic, retain) ItemMenuTaiChinh *mItemDangChon;
@property (nonatomic, assign) NSInteger mSoDuVi;
@property (nonatomic, assign) NSInteger mSoDuKhuyenMaiVi;
@property (nonatomic, retain) NSArray *mDanhSachAnhQuangCao;
@property (nonatomic, assign) BOOL mKhongMoGiaoDienBenTrai;
@end

@implementation GiaoDienChinhV2

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    keyPin = @"11111111";
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setInteger:0 forKey:@"KEY_INDEX_CLICK_QC"];
    [user synchronize];
    isLoadQC = NO;
    int nTongSoLuongTinChuaDoc = [[DichVuNotification shareService] laySoLuongTinChuaDocTrongChucNang:0];
    NSLog(@"%s - nTongSoLuongTinChuaDoc : %d", __FUNCTION__, nTongSoLuongTinChuaDoc);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xuLySuKienDangNhapThanhCong:) name:DANG_NHAP_THANH_CONG object:nil];

//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    BOOL bShowQC = [defaults boolForKey:@"tamnv_show_quangcao"];
//    if (!bShowQC) {
//        [self khoiTaoQuangCao];
//        [defaults setBool:YES forKey:@"tamnv_show_quangcao"];
//    }

    mDrawer = (Drawer*)self.view;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GiaoDienChinhHeaderV2 class]) owner:self options:nil] objectAtIndex:0];
    headerView.mDelegate = self;
    CGRect frameHeader = headerView.frame;
    frameHeader.size.width = self.view.frame.size.width;
    headerView.frame = frameHeader;
    [self.viewMain addSubview:headerView];

    
    NSLog(@"%s - width : %f - %f", __FUNCTION__, width, height);
    if (width <= 320.0) {
        int nCongThem = 0;
        if (height == 480) {
            nCongThem = 30;
        }
        CGRect rectViewMain1 = self.viewMain1.frame;
        rectViewMain1.origin.y = headerView.frame.size.height + 7;
        self.viewMain1.frame = rectViewMain1;
        [self.viewMain addSubview:self.viewMain1];
        [self.viewMain bringSubviewToFront:self.viewMain1];
        CGRect rectViewMain = self.viewMain.frame;
        rectViewMain.size.height = rectViewMain1.origin.y + rectViewMain1.size.height + 50;
        self.viewMain.frame = rectViewMain;
        [self.scrMain setContentSize:CGSizeMake(50, rectViewMain.size.height)];
    }
    else{
        CGRect rectViewMain1 = self.viewMain2.frame;
        CGRect rectHeader = headerView.frame;
        BOOL isChange = NO;
        if (width >= 400) {
            NSLog(@"%s - update size height header 1 : %f", __FUNCTION__, rectHeader.size.height);
            rectHeader.size.height += 60;
            NSLog(@"%s - update size height header 2 : %f", __FUNCTION__, rectHeader.size.height);
            isChange = YES;
        }
        headerView.frame = rectHeader;
        [headerView updateFontChu];
        if (isChange) {
            [headerView capNhatFrameSlide];
        }
        NSLog(@"%s - rectViewMain1.size.width : %f - %f", __FUNCTION__, rectViewMain1.size.width, rectViewMain1.size.height);
        rectViewMain1.origin.y = headerView.frame.size.height + 7;
        rectViewMain1.size.width = width;
        self.viewMain2.frame = rectViewMain1;
        [self.viewMain addSubview:self.viewMain2];
//        self.viewMain2.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self.viewMain bringSubviewToFront:self.viewMain2];
        CGRect rectViewMain = self.viewMain.frame;
        rectViewMain.size.height = rectViewMain1.origin.y + rectViewMain1.size.height + 50;
        self.viewMain.frame = rectViewMain;
        [self.scrMain setContentSize:CGSizeMake(50, rectViewMain.size.height)];
    }

    [self khoiTaoGiaoDienBenTrai];
    [self khoiTaoAnhQuangCao];

    for (UIGestureRecognizer *recognizer in self.view.gestureRecognizers) {
        [self.view removeGestureRecognizer:recognizer];
    }

    UINib *cellNib = [UINib nibWithNibName:@"CollectionCellGiaoDienChinh" bundle:nil];
    [self.collectionMain registerNib:cellNib forCellWithReuseIdentifier:@"CollectionCellGiaoDienChinh"];
}

- (void)ketNoiQuangCao {
    NSLog(@"%s -============> START", __FUNCTION__);
    isLoadQC = YES;
    self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_LAY_QUANG_CAO;
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];

    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    BOOL isWifi = YES;
    NetworkStatus status = [reachability currentReachabilityStatus];

    if(status == NotReachable)
    {
        //No internet
    }
    else if (status == ReachableViaWiFi)
    {
        isWifi = YES;
        [GiaoDichMang layDanhSachQuangCao:self];
    }
    else if (status == ReachableViaWWAN)
    {
        isWifi = NO;
        [GiaoDichMang layDanhSachQuangCao3G:self];
    }
    [user setBool:isWifi forKey:@"QUANG_CAO_WIFI"];
    [user synchronize];
}

- (void)khoiTaoQuangCao{
    if (!showQC) {
        showQC = [[KASlideShow alloc] initWithFrame:self.navigationController.view.frame];
        [showQC setDelay:20.0];
        [showQC setTransitionDuration:1];
        [showQC setTransitionType:KASlideShowTransitionSlide];
        [showQC setImagesContentMode:UIViewContentModeScaleAspectFill];
        [showQC addImagesFromResources:@[@"huongdan1.png", @"huongdan2.png", @"huongdan3.png", @"huongdan4.png", @"huongdan5.png"]];
        UIButton *btnClose = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 37, 5, 32, 32)];
        [btnClose setBackgroundImage:[UIImage imageNamed:@"icon_close.png"] forState:UIControlStateNormal];
        [btnClose addTarget:self action:@selector(suKienDongQuangCao) forControlEvents:UIControlEventTouchUpInside];
        [showQC addSubview:btnClose];
        [btnClose release];
        [showQC addGesture:KASlideShowGestureSwipe];
    }
    [self.navigationController.view addSubview:showQC];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.navigationController.view setNeedsLayout];
    [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(chaySlideShowQC:) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:110 target:self selector:@selector(dongSlideShowQC:) userInfo:nil repeats:NO];
}

- (void)suKienDongQuangCao{
    [showQC stop];
    [showQC removeFromSuperview];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController.view setNeedsLayout];
}

- (void)chaySlideShowQC:(NSTimer*)time{
    [showQC start];
}

- (void)dongSlideShowQC:(NSTimer*)time{
    [self suKienDongQuangCao];
}

- (void)reloadGiaoDien:(NSNotification *)notification{
    NSLog(@"%s =========================================>", __FUNCTION__);
    [mViewNavigationGiaoDienChinh hienThiBagdeNumber];
    if (self.mThongTinTaiKhoanVi) {
        [mViewNavigationGiaoDienChinh hienThiSoTien:[NSString stringWithFormat:@"%@ đ", [Common hienThiTienTe:[self.mThongTinTaiKhoanVi.nAmount doubleValue]]]];
    }
    else {
        [mViewNavigationGiaoDienChinh hienThiSoTien:@""];
    }
    [mGiaoDienBenTrai reloadDataBagde];
    int nBagdeNumber = [[DichVuNotification shareService] laySoLuongTinChuaDocTrongChucNang:TIN_TAI_CHINH];
    if(nBagdeNumber > 0)
    {
        [headerView.lblSaoKeChinh setHidden:NO];
    }
    else
    {
        [headerView.lblSaoKeChinh setHidden:YES];
    }
    [headerView.lblSaoKeChinh setText:[NSString stringWithFormat:@"%d", nBagdeNumber]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    isChuyenGiaoDien = NO;

    [self khoiTaoThongTinVi];
    [self reloadGiaoDien:nil];
    [self capNhatGiaoDienBenTraiVaGiaoDienHeader];

    if(mTrangThaiDangOViewBenTrai && !_mKhongMoGiaoDienBenTrai)
    {
        mTrangThaiDangOViewBenTrai = NO;
        [mDrawer openLeft];
    }
    else if (_mKhongMoGiaoDienBenTrai)
    {
        _mKhongMoGiaoDienBenTrai = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [headerView tamDungQuangCao];
    [self khoiTaoNaviGationBar];
    [self xuLyGiaoDienKhiVaoApp];
//    if (@available(iOS 11, *)) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            self.navigationController.navigationBar.layoutMargins = UIEdgeInsetsZero;
//            for (UIView *subview in self.navigationController.navigationBar.subviews) {
//                if ([NSStringFromClass([subview class]) containsString:@"ContentView"]) {
//                    subview.layoutMargins = UIEdgeInsetsZero;
//                }
//            }
//        });
//    }

}

- (void)xuLyGiaoDienKhiVaoApp {
    if (self.mThongTinTaiKhoanVi) {
        UIButton * btnTemp = [UIButton buttonWithType:UIButtonTypeCustom];
        btnTemp.frame = CGRectMake(0, 0, 40, 40);
        [[btnTemp layer] setBorderWidth:2.0f];
        [[btnTemp layer] setBorderColor:[UIColor whiteColor].CGColor];
        [btnTemp.layer setCornerRadius:3.0f];
        if (btnTemp && self.mThongTinTaiKhoanVi) {
            NSString *sDuongDanAnhDaiDien = self.mThongTinTaiKhoanVi.sLinkAnhDaiDien;
            NSLog(@"%s +++++++++++++++ sDuongDanAnhDaiDien : %@", __FUNCTION__, sDuongDanAnhDaiDien);
            if([sDuongDanAnhDaiDien isEqualToString:@""])
            {
                [btnTemp setBackgroundImage:[UIImage imageNamed:@"icon_danhba"] forState:UIControlStateNormal];
            }
            else
            {
                if([sDuongDanAnhDaiDien rangeOfString:@"http"].location != NSNotFound){
                    [btnTemp sd_setBackgroundImageWithURL:[NSURL URLWithString:sDuongDanAnhDaiDien] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_danhba"]];
                }
                else{
                    [btnTemp sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://203.162.235.66:8080/vmbank/services/media/getImage?id=%@", sDuongDanAnhDaiDien]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_danhba"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        NSLog(@"%s - error : %@", __FUNCTION__, error);
                        NSLog(@"%s - imageURL : %@", __FUNCTION__, imageURL);

                    }];
                }
            }
        }
        btnTemp.backgroundColor = [UIColor clearColor];
        btnTemp.frame = CGRectMake(0, 0, 40, 40);
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
            [btnTemp.widthAnchor constraintEqualToConstant:40].active = YES;
            [btnTemp.heightAnchor constraintEqualToConstant:40].active = YES;
        }

        //        btnTemp.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [btnTemp addTarget:self action:@selector(suKienBamNutMore:) forControlEvents:UIControlEventTouchUpInside];

        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btnTemp];
        //        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_danhba"] style:UIBarButtonItemStyleDone target:self action:@selector(suKienBamNutMore:)];
        leftItem.width = 30;
        UIBarButtonItem *negativeSeperator = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];

        if (SYSTEM_VERSION_LESS_THAN(@"11"))
            negativeSeperator.width = -10;
        else
            negativeSeperator.width = -15;
        self.navigationItem.rightBarButtonItems = @[negativeSeperator, leftItem];

        [self capNhatSoDuVi];
    }
    else {
        if(!isLoadQC) {
            [self ketNoiQuangCao];
        }
        [self addButton:@"icon_more" selector:@selector(suKienBamNutMore:) atSide:1];
        NSString *sKeyDangNhap = [DucNT_LuuRMS layThongTinDangNhap:KEY_DANG_NHAP];
        NSLog(@"%s - sKeyDangNhap : %@", __FUNCTION__, sKeyDangNhap);
        if(sKeyDangNhap.length > 0)
        {
            NSDictionary *dict = [sKeyDangNhap objectFromJSONString];
            NSArray *arrTemp = [dict allKeys];
            if (arrTemp != nil && arrTemp.count > 0) {
                NSString *sTaiKhoan = (NSString *)[arrTemp firstObject];
                NSLog(@"%s - tai khoan : %@", __FUNCTION__, sTaiKhoan);
                [self hienThongBaoDangNhapVanTay:sTaiKhoan];
            }
        }
    }
}

- (void)hienThongBaoDangNhapVanTay:(NSString *)taiKhoan {
    LAContext *context = [[[LAContext alloc] init] autorelease];
    NSError *err = nil;
    if([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&err])
    {
        if (@available(iOS 11.0, *)) {
            [self hienThiLoading];
        }
        else {
            [RoundAlert show];
        }
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:[NSString stringWithFormat:@"Đăng nhập tài khoản : %@", taiKhoan]
                          reply:^(BOOL success, NSError *error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (error) {
                     if (@available(iOS 11.0, *)) {
                         [self anLoading];
                     }
                     else {
                         [RoundAlert hide];
                     }
                     [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Có lỗi khi đăng nhập bằng vân tay. Vui lòng thử lại sau."];
                     return;
                 }
                 if(success)
                 {
                     [self xuLySuKienXacThucVanTayThanhCong];
                 }
             });
         }];
    }
}

- (void)xuLySuKienXacThucVanTayThanhCong
{
    NSString *sDictDangNhap = [DucNT_LuuRMS layThongTinDangNhap:KEY_DANG_NHAP];
    NSDictionary *dictDangNhap = [sDictDangNhap objectFromJSONString];
    NSArray *arrTemp = [dictDangNhap allKeys];
    if (arrTemp != nil && arrTemp.count > 0) {
        NSString *sTaiKhoan = (NSString *)[arrTemp firstObject];
        NSString *sMatKhauMaHoa = [dictDangNhap valueForKey:sTaiKhoan];
        NSString *sMatKhauGiaiMa = [self giaiMa:sMatKhauMaHoa];
        self.mDinhDanhKetNoi = @"DANG_NHAP_VAN_TAY";
        [GiaoDichMang ketNoiDangNhapTaiKhoanViViMASS:sTaiKhoan matKhau:sMatKhauGiaiMa maDoanhNghiep:@"" noiNhanKetQua:self];
    }
}

- (NSString*)giaiMa:(NSString*)s
{
    NSString *s1 = [FBEncryptorAES decryptBase64String:s keyString:keyPin];
    return s1;
}

- (void)capNhatSoDuVi
{
    if([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue])
    {
        NSLog(@"%s - ============> DINH_DANH_KET_NOI_LAY_SO_DU_TAI_KHOAN", __FUNCTION__);
        self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_LAY_SO_DU_TAI_KHOAN;
        [GiaoDichMang ketNoiLaySoDuTaiKhoan:self];
    }
    else {
        if(!isLoadQC) {
            NSLog(@"%s - isLoadQC = NO", __FUNCTION__);
            [self ketNoiQuangCao];
//            isLoadQC = YES;
//            mDinhDanhKetNoi = DINH_DANH_KET_NOI_LAY_QUANG_CAO;
//            [GiaoDichMang layDanhSachQuangCao:self];
        }
    }
}

- (void)khoiTaoThongTinVi
{
    [mViewNavigationGiaoDienChinh hienThiBagdeNumber];
    [mGiaoDienBenTrai.mtbHienThi reloadData];
    headerView.mThongTinTaiKhoanVi = self.mThongTinTaiKhoanVi;
    mGiaoDienBenTrai.mThongTinTaiKhoanVi = self.mThongTinTaiKhoanVi;
}

- (void)khoiTaoNaviGationBar
{
    //    [self addButtonBack];
    if (mViewNavigationGiaoDienChinh == nil) {
        mViewNavigationGiaoDienChinh = [[[NSBundle mainBundle] loadNibNamed:@"ViewNavigationGiaoDienChinh" owner:self options:nil] objectAtIndex:0];
        mViewNavigationGiaoDienChinh.mDelegate = self;
        self.navigationItem.titleView = mViewNavigationGiaoDienChinh;
        [self addButton:@"icon_menu_1" selector:@selector(suKienBamNutMenuLeft:) atSide:0];
    }
}

- (void)khoiTaoGiaoDienBenTrai
{
    if(mDrawer.left != nil)
        return;
    mGiaoDienBenTrai = [[[NSBundle mainBundle] loadNibNamed:@"GiaoDienBenTrai" owner:self options:nil] objectAtIndex:0];
    mGiaoDienBenTrai.mDelegate = self;
    mDrawer.left = mGiaoDienBenTrai;
}

- (void)khoiTaoAnhQuangCao
{

}

- (IBAction)suKienBamNutMenuLeft:(UIButton *)sender
{
    [mDrawer openLeft];
}

- (IBAction)suKienBamNutMore:(UIButton *)sender
{
    Drawer *drawer = (Drawer *)self.view;
    [drawer close:^()
     {
         if (self.mThongTinTaiKhoanVi) {
             UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Đóng" destructiveButtonTitle:nil otherButtonTitles:@"Đăng xuất", @"Đổi thông tin", @"Giới thiệu bạn bè", @"Góp ý", @"Trò truyện", @"Phone token", nil];
             [actionSheet showInView:self.view];
             [actionSheet release];
         }
         else {
             UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Đóng" destructiveButtonTitle:nil otherButtonTitles:@"Đăng nhập / Đăng ký", @"Giới thiệu bạn bè", @"Góp ý", @"Trò truyện", @"Phone token", nil];
             [actionSheet showInView:self.view];
             [actionSheet release];
         }
     }];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (self.mThongTinTaiKhoanVi) {
        NSLog(@"%s - buttonIndex : %d", __FUNCTION__, (int)buttonIndex);
        if (buttonIndex == 0) {
            [self suKienDangXuat];
        }
        else if (buttonIndex == 1){
            [self xuLySuKienChonThongTinVi];
        }
        else if (buttonIndex == 2) {
            DucBT_ShareViewController *shareViewController = [[DucBT_ShareViewController alloc] initWithNibName:@"DucBT_ShareViewController" bundle:nil];
            [self.navigationController pushViewController:shareViewController animated:YES];
            [shareViewController release];
        }
        else if (buttonIndex == 3){
            NSString *sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
            if(sTaiKhoan.length > 0)
            {
                GiaoDienGopY *gopY = [[GiaoDienGopY alloc] initWithNibName:NSStringFromClass([GiaoDienGopY class]) bundle:nil];
                [self.navigationController pushViewController:gopY animated:YES];
                [gopY release];
            }
            else{
                DucNT_LoginSceen *login = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
                [self presentViewController:login animated:YES completion:^{}];
                [login release];
            }
        }
        else if (buttonIndex == 4){
            NSString *sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
            if(sTaiKhoan.length > 0)
            {
                DanhSachNguoiDangChatTaiChinhViewController *danhSachNguoiDangChatViewController = [[DanhSachNguoiDangChatTaiChinhViewController alloc] initWithNibName:@"DanhSachNguoiDangChatTaiChinhViewController" bundle:nil];
                [self.navigationController pushViewController:danhSachNguoiDangChatViewController animated:YES];
                [danhSachNguoiDangChatViewController release];
            }
            else
            {
                DucNT_LoginSceen *login = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
                [self presentViewController:login animated:YES completion:^{}];
                [login release];
            }
        }
        else if (buttonIndex == 5) {
            [self suKienChonPhoneToken];
        }
    }
    else
    {
        if (buttonIndex == 0) {
            [self chuyenGiaoDienDangNhap];
        }
        else if (buttonIndex == 1) {
            DucBT_ShareViewController *shareViewController = [[DucBT_ShareViewController alloc] initWithNibName:@"DucBT_ShareViewController" bundle:nil];
            [self.navigationController pushViewController:shareViewController animated:YES];
            [shareViewController release];
        }
        else if (buttonIndex == 2){
            NSString *sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
            if(sTaiKhoan.length > 0)
            {
                GiaoDienGopY *gopY = [[GiaoDienGopY alloc] initWithNibName:NSStringFromClass([GiaoDienGopY class]) bundle:nil];
                [self.navigationController pushViewController:gopY animated:YES];
                [gopY release];
            }
            else{
                DucNT_LoginSceen *login = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
                [self presentViewController:login animated:YES completion:^{}];
                [login release];
            }
        }
        else if (buttonIndex == 3){
            NSString *sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
            if(sTaiKhoan.length > 0)
            {
                DanhSachNguoiDangChatTaiChinhViewController *danhSachNguoiDangChatViewController = [[DanhSachNguoiDangChatTaiChinhViewController alloc] initWithNibName:@"DanhSachNguoiDangChatTaiChinhViewController" bundle:nil];
                [self.navigationController pushViewController:danhSachNguoiDangChatViewController animated:YES];
                [danhSachNguoiDangChatViewController release];
            }
            else
            {
                DucNT_LoginSceen *login = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
                [self presentViewController:login animated:YES completion:^{}];
                [login release];
            }
        }
        else if (buttonIndex == 4) {
            [self suKienChonPhoneToken];
        }
    }

}

#pragma mark - menu trai

- (void)xuLySuKienDangNhapThanhCong:(NSNotification *)notification
{
    //Khoi tao thong tin vi
    [self khoiTaoThongTinVi];
    [self capNhatGiaoDienBenTraiVaGiaoDienHeader];
    //Cap nhat so du
//        [self capNhatSoDuVi];

    //Chuyen view
    if([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue])
    {
        //Dang nhap thanh cong
        if(![self.mItemDangChon.mTieuDe isEqualToString:@"dang_xuat"])
        {
            [self xuLySuKienChonItemMenuDaDangNhap:self.mItemDangChon];
        }
    }
}

- (void)xuLySuKienChonItemMenuDaDangNhap:(ItemMenuTaiChinh*)item
{
    if(item)
    {
        if(![item.mTenHamXuLy isEqualToString:@""])
        {
            //Neu co ten ham xu ly thi nhay vao ham
            NSString *sTenHamXuLy = item.mTenHamXuLy;
            SEL s = NSSelectorFromString(sTenHamXuLy);
            [self performSelector:s];
        }
        else if(![item.mTenViewController isEqualToString:@""])
        {
            //Khong co ten ham xu ly thi kiem tra xem co Ten view con troller khong
            //Chuyen viewcontroller
            mTrangThaiDangOViewBenTrai = YES;
            NSString *sKieuChuyenView = item.mKieuChuyenView;
            NSString *sTenViewController = item.mTenViewController;
            NSLog(@"%s - sTenViewController : %@", __FUNCTION__, sTenViewController);

            NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:@"tamnv_hienthi"];
            NSLog(@"%s - %s : ==========> value : %@", __FILE__, __FUNCTION__, value);
            if ([value isEqualToString:@"0"] && [sTenViewController isEqualToString:@"MuaTheTroChoiDienTuViewController"]) {
                [UIAlertView alert:@"Đang phát triển" withTitle:[@"thong_bao" localizableString] block:nil];
                return;
            }
            UIViewController *vc = [[NSClassFromString(sTenViewController) alloc] initWithNibName:sTenViewController bundle:nil];
            if([sKieuChuyenView isEqualToString:@"push"])
            {
                [mDrawer close:^{}];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                [self presentViewController:vc animated:YES completion:^{}];
            }
            [vc release];
        }
        else
        {
            //thong bao la dang phat trien
            [UIAlertView alert:@"Đang phát triển" withTitle:[@"thong_bao" localizableString] block:nil];
        }
    }
}

- (void)suKienDangXuat
{
    if([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue])
    {
        NSString *sTaiKhoanDangNhapCuoi = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
        [DucNT_LuuRMS luuThongTinDangNhap:KEY_LAST_ID_LOGIN value:sTaiKhoanDangNhapCuoi];

        int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
        if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
        {
            sTaiKhoanDangNhapCuoi = self.mThongTinTaiKhoanVi.walletLogin;
        }

        if(sTaiKhoanDangNhapCuoi.length == 10 || sTaiKhoanDangNhapCuoi.length == 11)
        {
            [DucNT_LuuRMS luuThongTinDangNhap:KEY_LAST_PHONE_LOGIN_ID value:sTaiKhoanDangNhapCuoi];
        }

        if (FBSession.activeSession.state == FBSessionStateOpen
            || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {

            // Close the session and remove the access token from the cache
            // The session state handler (in the app delegate) will be called automatically
            [FBSession.activeSession closeAndClearTokenInformation];

            // If the session state is not any of the two "open" states when the button is clicked
        }

        [[GPPSignIn sharedInstance] signOut];

        [DucNT_LuuRMS xoaThongTinRMSLogout];

        //Xoa bagde number o icon tren man hinh iPhone
        [[DichVuNotification shareService] dichVuXacNhanDaDocTatCaCacTin];
        int nTongSoLuongTinChuaDoc = [[DichVuNotification shareService] laySoLuongTinChuaDocTrongChucNang:0];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:nTongSoLuongTinChuaDoc];
        [self reloadGiaoDien:nil];
        [self addButton:@"icon_danhba" selector:@selector(suKienBamNutMore:) atSide:1];
        //Khoi tao lai giao dien ben trai
        [mGiaoDienBenTrai khoiTaoViewThongTinTaiKhoan];
        self.mThongTinTaiKhoanVi = nil;
        [self addButton:@"icon_more" selector:@selector(suKienBamNutMore:) atSide:1];
        [mViewNavigationGiaoDienChinh hienThiSoTien:@""];
        [DucNT_LuuRMS luuThongTinDangNhap:KEY_LOGIN_STATE value:@"NO"];
    }
    else
    {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
    }
    
}

- (void)xuLySuKienChonItemMenuTaiChinh:(ItemMenuTaiChinh*)item
{
    self.mItemDangChon = item;
//    if(item.mCanDangNhap && ![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue])
//    {
//        //Bat dang nhap
//        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
//        [self presentViewController:loginSceen animated:YES completion:^{}];
////        [self.navigationController pushViewController:loginSceen animated:YES];
//        [loginSceen release];
//    }
//    else
//    {
        //khong can dang nhap thi xu ly luon
        __block GiaoDienChinhV2 *blockSELF = self;
        [blockSELF xuLySuKienChonItemMenuDaDangNhap:item];
//    }
}

#pragma mark - DucNT_ServicePostDelegate

- (void)ketNoiThanhCong:(NSString *)sKetQua {
    NSDictionary *dicKetQua = [sKetQua objectFromJSONString];
    int nCode = [[dicKetQua objectForKey:@"msgCode"] intValue];
    NSString *message = [dicKetQua objectForKey:@"msgContent"];
    id result = [dicKetQua objectForKey:@"result"];
    if (nCode == 1) {
        [self xuLyKetNoiThanhCong:self.mDinhDanhKetNoi thongBao:message ketQua:result];
    }
    else {
        [self xuLyKetNoiThatBai:self.mDinhDanhKetNoi thongBao:message ketQua:result];
    }
}

- (void)xuLyKetNoiThanhCong:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua {
    NSLog(@"%s - nhan ket qua thanh cong : %@", __FUNCTION__, sDinhDanhKetNoi);
    if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_LAY_SO_DU_TAI_KHOAN])
    {
        NSDictionary *dictResult = (NSDictionary *)ketQua;
        NSNumber *nAmount = [dictResult objectForKey:@"amount"];
        NSNumber *promotionTotal = [dictResult objectForKey:@"promotionTotal"];
        NSNumber *promotionStatus = [dictResult objectForKey:@"promotionStatus"];
        NSNumber *totalCreateGift = [dictResult objectForKey:@"totalCreateGift"];
        NSNumber *totalGift = [dictResult objectForKey:@"totalGift"];

        if(nAmount) {
            self.mThongTinTaiKhoanVi.nAmount = nAmount;
        }
        if(promotionStatus) {
            self.mThongTinTaiKhoanVi.nPromotionStatus = promotionStatus;
        }
        if(promotionTotal) {
            self.mThongTinTaiKhoanVi.nPromotionTotal = promotionTotal;
        }
        if(totalCreateGift) {
            self.mThongTinTaiKhoanVi.totalCreateGift = totalCreateGift;
        }
        if(totalCreateGift) {
            self.mThongTinTaiKhoanVi.toTalGift = totalGift;
        }

        self.mThongTinTaiKhoanVi.nPromotionStatus = promotionStatus;
        self.mThongTinTaiKhoanVi.nPromotionTotal = promotionTotal;
        self.mThongTinTaiKhoanVi.totalCreateGift = totalCreateGift;
        self.mThongTinTaiKhoanVi.toTalGift = totalGift;
        [mViewNavigationGiaoDienChinh hienThiSoTien:[NSString stringWithFormat:@"%@ đ", [Common hienThiTienTe:[self.mThongTinTaiKhoanVi.nAmount doubleValue]]]];
        //HOANHNV FIX
        AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        if(app.objUpdateProfile == nil){
            [DucNT_LuuRMS luuThongTinTaiKhoanViSauDangNhap:self.mThongTinTaiKhoanVi];
        }
        else{
            // Already update info to userdefault
            // TODO
        }
        //END
        [self capNhatGiaoDienBenTraiVaGiaoDienHeader];
        NSLog(@"%s - vao den day", __FUNCTION__);
        if(!isLoadQC) {
            NSLog(@"%s - isLoadQC = NO", __FUNCTION__);
            [self ketNoiQuangCao];
        }
    }
    else if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_LAY_QUANG_CAO]) {
        NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:@"tamnv_hienthi"];
        NSLog(@"%s - %s : ==========> value : %@", __FILE__, __FUNCTION__, value);
        NSLog(@"%s - %s : ==========> value : %@", __FILE__, __FUNCTION__, ketQua);

        NSArray *dictResult = (NSArray *)ketQua;
        NSString *sQC = [dictResult JSONString];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setValue:sQC forKey:@"QUANG_CAO_VI_VIMASS"];
        [user synchronize];
        NSLog(@"%s - dictResult : %ld", __FUNCTION__, (long)dictResult.count);

        NSMutableArray *arrQC = [[NSMutableArray alloc] init];
        for (NSDictionary *dicTemp in dictResult) {

            int nVMApp = [[dicTemp objectForKey:@"VMApp"] intValue];
            NSString *nameImage = (NSString *)[dicTemp objectForKey:@"nameImage"];
            if (nVMApp == 1 && ![nameImage containsString:@"mua mã thẻ"] && ![nameImage containsString:@"FPT"]) {
                [arrQC addObject:dicTemp];
            }
        }
        [headerView setAnhQuangCao:arrQC];
        isLoadQC = NO;
    }
    else if ([sDinhDanhKetNoi isEqualToString:@"DANG_NHAP_VAN_TAY"]) {
        int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
        NSDictionary *dicKQ2 = (NSDictionary *)ketQua;
        self.mThongTinTaiKhoanVi = [[DucNT_TaiKhoanViObject alloc] initWithDict:dicKQ2];
        [DucNT_LuuRMS luuThongTinDangNhap:KEY_LOGIN_ID_TEMP value:self.mThongTinTaiKhoanVi.sID];
        self.mDinhDanhKetNoi = DINH_DANH_DANG_KI_THIET_BI;

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
                [connectUpDeviceToken connect:sUrl withContent:[dicPost JSONString]];
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
        int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
        [self xuLySauKhiDangKyThietBi:nKieuDangNhap];
    }
}

- (void)xuLySauKhiDangKyThietBi:(int)nKieuDangNhap {
    [DucNT_LuuRMS luuThongTinTaiKhoanViSauDangNhap:self.mThongTinTaiKhoanVi];
    [DucNT_LuuRMS luuThongTinDangNhap:KEY_LOGIN_STATE value:@"YES"];
    [self xuLyGiaoDienKhiVaoApp];
//    [[NSNotificationCenter defaultCenter] postNotificationName:DANG_NHAP_THANH_CONG object:nil];
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] reloadGiaoDienHome];
    if (@available(iOS 11.0, *)) {
        [self anLoading];
    }
    else {
        [RoundAlert hide];
    }
}

- (void)xuLyKetNoiThatBai:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua {
    if ([mDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_LAY_QUANG_CAO]) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *sQC = [user stringForKey:@"QUANG_CAO_VI_VIMASS"];
        if (sQC && sQC.length > 0) {
            NSArray *dict = [sQC objectFromJSONString];
            NSMutableArray *arrQC = [[NSMutableArray alloc] init];
            for (NSDictionary *dicTemp in dict) {
                int nVMApp = [[dicTemp objectForKey:@"VMApp"] intValue];
                if (nVMApp == 1) {
                    [arrQC addObject:dicTemp];
                }
            }
            [headerView setAnhQuangCao:arrQC];
        }
        isLoadQC = NO;
    }
    if (@available(iOS 11.0, *)) {
        [self anLoading];
    }
    else {
        [RoundAlert hide];
    }
}

//-(void)ketNoiThanhCong:(NSString *)sKetQua
//{
////    NSLog(@"%s - sKetQua : %@", __FUNCTION__, sKetQua);
//    NSDictionary *dicKetQua = [sKetQua objectFromJSONString];
//    int nCode = [[dicKetQua objectForKey:@"msgCode"] intValue];
//    //    NSString *message = [dicKetQua objectForKey:@"msgContent"];
//
//}

- (void)capNhatGiaoDienBenTraiVaGiaoDienHeader
{
    [mGiaoDienBenTrai xuLyHienThiGiaoDien];
    [mGiaoDienBenTrai capNhatSoDu:[self.mThongTinTaiKhoanVi.nAmount doubleValue] soDuKhuyenMai:[self.mThongTinTaiKhoanVi.nPromotionTotal doubleValue]];
    [headerView capNhatSoDu:[self.mThongTinTaiKhoanVi.nAmount doubleValue] soDuKhuyenMai:[self.mThongTinTaiKhoanVi.nPromotionTotal doubleValue] theQuaTang:0];
    [headerView updateTrangThaiAnhSlide];
}

#pragma mark - su kien click

- (void)chuyenGiaoDienDangNhap{
    DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
    loginSceen.sKieuChuyenGiaoDien = @"push";
    [self presentViewController:loginSceen animated:YES completion:^{}];
    [loginSceen release];
}

#pragma mark - header view

- (void)xuLySuKienBamNutSaoKe {
//    [self xuLySuKienXemSaoKe:nil];
    GiaoDienGioiThieuVi *vc = [[GiaoDienGioiThieuVi alloc] initWithNibName:@"GiaoDienGioiThieuVi" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)xuLySuKienBamNutNapTien{
    NapViTuTheNganHangViewController *napViTuTheNganHangViewController = [[NapViTuTheNganHangViewController alloc] initWithNibName:@"NapViTuTheNganHangViewController" bundle:nil];
    [self.navigationController pushViewController:napViTuTheNganHangViewController animated:YES];
    [napViTuTheNganHangViewController release];
}

- (void)xuLySuKienbamNutRutTien{
    NSLog(@"%s - xuLySuKienbamNutRutTien", __FUNCTION__);
//    if([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue])
//    {
        ChuyenTienViewController *chuyenTienViewController = [[ChuyenTienViewController alloc] initWithNibName:@"ChuyenTienViewController" bundle:nil];
        [self.navigationController pushViewController:chuyenTienViewController animated:YES];
        [chuyenTienViewController release];
//    }
//    else
//    {
//        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
//        loginSceen.sTenViewController = @"ChuyenTienViewController";
//        loginSceen.sKieuChuyenGiaoDien = @"push";
//        [self presentViewController:loginSceen animated:YES completion:^{}];
//        [loginSceen release];
//    }
}

- (void)xuLySuKienBamNutMuonTien{
    if([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue])
    {
        GiaoDienTaiKhoanLienKet *vc = [[GiaoDienTaiKhoanLienKet alloc] initWithNibName:@"GiaoDienTaiKhoanLienKet" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
    else
    {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        loginSceen.sTenViewController = @"GiaoDienTaiKhoanLienKet";
        loginSceen.sKieuChuyenGiaoDien = @"push";
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
    }
}

- (void)suKienChonQuangCao:(NSString *)sNameImage {
    NSLog(@"%s - sNameImage : %@", __FUNCTION__, sNameImage);
    if ([sNameImage hasPrefix:@"giới thiệu"]) {

    }
    else if ([sNameImage hasPrefix:@"vé phim"]) {
        NSArray *arrSplit = [sNameImage componentsSeparatedByString:@"_"];
        NSString *sTenFilm = @"";
        if (arrSplit.count == 2) {
            sTenFilm = [arrSplit objectAtIndex:1];
        }
        else if (arrSplit.count == 3) {
            sTenFilm = [arrSplit objectAtIndex:2];
        }
        
        if([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue])
        {
            GiaoDienDatVeXemPhim *muaTheTroChoiDienTuViewController = [[GiaoDienDatVeXemPhim alloc] initWithNibName:@"GiaoDienDatVeXemPhim" bundle:nil];
            muaTheTroChoiDienTuViewController.sTenFilmTimKiem = sTenFilm;
            [self.navigationController pushViewController:muaTheTroChoiDienTuViewController animated:YES];
            [muaTheTroChoiDienTuViewController release];
        }
        else
        {
            DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
            loginSceen.sTenViewController = @"GiaoDienDatVeXemPhim";
            loginSceen.sKieuChuyenGiaoDien = @"push";
            [self presentViewController:loginSceen animated:YES completion:^{}];
            [loginSceen release];
        }
    }
    else if ([sNameImage hasPrefix:@"đến tài khoản"]) {
        [self suKienBamNutChuyenTienDenTaiKhoan:nil];
    }
    else if ([sNameImage hasPrefix:@"đến ATM"] || [sNameImage hasPrefix:@"atm"]) {
        [self suKienBamNutChuyenTienATM:nil];
    }
    else if ([sNameImage hasPrefix:@"đến thẻ"]) {
        [self suKienBamNutChuyenTienDenThe:nil];
    }
    else if ([sNameImage hasPrefix:@"tiết kiệm"]) {
        [self suKienBamNutChuyenTienTietKiem:nil];
    }
    else if ([sNameImage hasPrefix:@"vé máy bay"]) {
        [self suKienBamNutVeMayBay:nil];
    }
    else if ([sNameImage hasPrefix:@"đến tận nhà"]) {
        [self suKienBamNutChuyenTienTanNha:nil];
    }
    else if ([sNameImage hasPrefix:@"tặng quà"]) {
        [self suKienBamNutTangQua:nil];
    }
    else if ([sNameImage hasPrefix:@"đến cmnd"]) {
        [self suKienBamChuyenTienDenCMND:nil];
    }
    else if ([sNameImage hasPrefix:@"trả tiền vay"]) {
        [self suKienBamNutTraTienVay:nil];
    }
    else if ([sNameImage hasPrefix:@"cách nạp ví"]) {
        [self suKienBamNutCachNapVi:nil];
    }
    else if ([sNameImage hasPrefix:@"điện"]) {
        if ([sNameImage containsString:@"điện thoại"]) {
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
                    [thanhToanDienThoaiKhac release];
                }
                else
                {
                    DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
                    loginSceen.sTenViewController = @"ThanhToanDienThoaiKhacViewController";
                    loginSceen.sKieuChuyenGiaoDien = @"push";
                    [self presentViewController:loginSceen animated:YES completion:^{}];
                    [loginSceen release];
                }
            }
            else {
                [self suKienBamNutThanhToanDienThoai:nil];
            }
        }
        else
            [self suKienBamNutDien:nil];
    }
    else if ([sNameImage hasPrefix:@"nước"]) {
        [self suKienBamNutNuoc:nil];
    }
    else if ([sNameImage hasPrefix:@"internet"]) {
        NSArray *arrSplit = [sNameImage componentsSeparatedByString:@"_"];
        if (arrSplit.count == 2) {
            NSString *sChucNang = [[arrSplit objectAtIndex:1] lowercaseString];
            if([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]){
                GiaoDienThanhToanInternet *internet = [[GiaoDienThanhToanInternet alloc] initWithNibName:@"GiaoDienThanhToanInternet" bundle:nil];
                if ([sChucNang isEqualToString:@"vnpt"]) {
                    internet.nChucNang = 0;
                }
                else if ([sChucNang isEqualToString:@"viettel"]) {
                    internet.nChucNang = 1;
                }
                else if ([sChucNang isEqualToString:@"fpt"]) {
                    internet.nChucNang = 2;
                }
                else if ([sChucNang isEqualToString:@"cmc"]) {
                    internet.nChucNang = 3;
                }
                [self.navigationController pushViewController:internet animated:YES];
                [internet release];
            }
            else
            {
                DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
                loginSceen.sTenViewController = @"GiaoDienThanhToanInternet";
                loginSceen.sKieuChuyenGiaoDien = @"push";
                [self presentViewController:loginSceen animated:YES completion:^{}];
                [loginSceen release];
            }
        }
        else
            [self suKienBamNutInternet:nil];
    }
    else if ([sNameImage hasPrefix:@"truyền hình"]) {
        [self suKienBamNutTruyenHinh:nil];
    }
    else if ([sNameImage hasPrefix:@"nạp tiền"]) {
        [self xuLySuKienBamNutNapTien];
    }
    else if ([sNameImage hasPrefix:@"điện thoại"]) {
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
                [thanhToanDienThoaiKhac release];
            }
            else
            {
                DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
                loginSceen.sTenViewController = @"ThanhToanDienThoaiKhacViewController";
                loginSceen.sKieuChuyenGiaoDien = @"push";
                [self presentViewController:loginSceen animated:YES completion:^{}];
                [loginSceen release];
            }
        }
        else {
            [self suKienBamNutThanhToanDienThoai:nil];
        }
    }
    else if ([sNameImage hasPrefix:@"quét QR"]) {
        [self suKienChonQRCode];
    }
    else if ([sNameImage hasPrefix:@"mã QR"]) {
        [self suKienBamNutPhoneToKen:nil];
    }
}

- (void)suKienChonQRCode {
    if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
        QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
        QRCodeReaderViewController *vcQRCodeTemp = [QRCodeReaderViewController readerWithCancelButtonTitle:@"Đóng" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:YES showTorchButton:YES];
        vcQRCodeTemp.modalPresentationStyle = UIModalPresentationFormSheet;
        vcQRCodeTemp.delegate = self;
        [self presentViewController:vcQRCodeTemp animated:YES completion:NULL];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:@"Thiết bị không hỗ trợ chức năng này." delegate:nil cancelButtonTitle:@"Đóng" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [reader stopScanning];
    NSLog(@"%s - -->result : %@", __FUNCTION__, result);
    [reader dismissViewControllerAnimated:YES completion:^{
        if (result.length > 0) {
            if (![result hasPrefix:@"http"] || [result hasSuffix:@"/transfers"]) {

                GiaoDienThanhToanQRCodeDonVi *vc = [[GiaoDienThanhToanQRCodeDonVi alloc] initWithNibName:@"GiaoDienThanhToanQRCodeDonVi" bundle:nil];
                if ([result containsString:@"/transfers"]) {
                    NSString *qrcode = [result stringByReplacingOccurrencesOfString:@"/transfers" withString:@""];
                    vc.sIdQRCode = qrcode;
                }
                else {
                    vc.sIdQRCode = result;
                }
                vc.typeQRCode = 1;
                [self.navigationController pushViewController:vc animated:YES];
                [vc release];
            }
            else {
                NSURL *url = [NSURL URLWithString:result];
                NSString *queryQRCode = url.query;
                NSLog(@"%s - -->queryQRCode : %@", __FUNCTION__, queryQRCode);
                if (queryQRCode == nil && [[url lastPathComponent] isEqualToString:@"quickpay"]) {
                    NSLog(@"%s - -->queryQRCode == null", __FUNCTION__);
                    NSLog(@"%s - -->queryQRCode == null : %@", __FUNCTION__, [url lastPathComponent]);
                    GiaoDienThanhToanQRCodeDonVi *vc = [[GiaoDienThanhToanQRCodeDonVi alloc] initWithNibName:@"GiaoDienThanhToanQRCodeDonVi" bundle:nil];
                    if ([[url lastPathComponent] isEqualToString:@"quickpay"]) {
                        NSString *sKQ = [result stringByReplacingOccurrencesOfString:@"/quickpay" withString:@""];
                        NSURL *url1 = [NSURL URLWithString:sKQ];
                        vc.sIdQRCode = [url1 lastPathComponent];
                    } else {
                        vc.sIdQRCode = [url lastPathComponent];
                    }
                    vc.typeQRCode = 0;
                    [self.navigationController pushViewController:vc animated:YES];
                    [vc release];
                }
                else {
                    NSLog(@"%s - -->queryQRCode : %@", __FUNCTION__, queryQRCode);
                    NSArray *arrQuery = [queryQRCode componentsSeparatedByString:@"="];
                    if (arrQuery.count == 2) {
                        NSString *idQRCode = [arrQuery lastObject];
                        NSLog(@"%s - -->idQRCode : %@", __FUNCTION__, idQRCode);
                        GiaoDienThanhToanQRCode *vc = [[GiaoDienThanhToanQRCode alloc] initWithNibName:@"GiaoDienThanhToanQRCode" bundle:nil];
                        vc.sIdQRCode = idQRCode;
                        [self.navigationController pushViewController:vc animated:YES];
                        [vc release];
                    }
                }
            }
        }
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [reader dismissViewControllerAnimated:YES completion:^{

    }];
}

#pragma mark - Xu ly su kien
- (void)xuLySuKienDieuKhienGiongNoi {

}

- (void)xuLySuKienChonThongTinVi{
    if([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue])
    {
        mTrangThaiDangOViewBenTrai = YES;
        [mDrawer close:^{}];
        int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
        NSLog(@"%s - %s : nKieuDangNhap : %d", __FILE__, __FUNCTION__,nKieuDangNhap);
        if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
        {
            GiaoDienThongTinViDoanhNghiep *info = [[GiaoDienThongTinViDoanhNghiep alloc] initWithNibName:@"GiaoDienThongTinViDoanhNghiep" bundle:nil];
            [self.navigationController pushViewController:info animated:YES];
            [info release];
        }
        else{
            DucNT_ChangPrivateInformationViewController *thayDoiThongTinCaNhan = [[DucNT_ChangPrivateInformationViewController alloc] initWithNibName:@"DucNT_ChangPrivateInformationViewController" bundle:nil];
            [self.navigationController pushViewController:thayDoiThongTinCaNhan animated:YES];
            [thayDoiThongTinCaNhan release];
        }
    }
    else
    {
        //        mTrangThaiDangOViewBenTrai = YES;
        //        [mDrawer close:^{}];
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        loginSceen.sTenViewController = @"DucNT_ChangPrivateInformationViewController";
        loginSceen.sKieuChuyenGiaoDien = @"push";
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
    }
}

- (void)xuLySuKienDongViewBenTrai{
    [mDrawer close:^{
        //Xu ly su kien dong view ben trai
    }];
}

- (IBAction)suKienBamChuyenTienDenViNoiBo:(id)sender {
//    if([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue])
//    {
        DucNT_ChuyenTienViDenViViewController *chuyenTienDenVi = [[DucNT_ChuyenTienViDenViViewController alloc] initWithNibName:@"DucNT_ChuyenTienViDenViViewController" bundle:nil];
        [self.navigationController pushViewController:chuyenTienDenVi animated:YES];
        [chuyenTienDenVi release];
//    }
//    else
//    {
//        [self chuyenGiaoDienDangNhap];
//    }
}

- (IBAction)suKienBamNutChuyenTienDenTaiKhoan:(id)sender {
//    if([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue])
//    {
        DucNT_ChuyenTienDenTaiKhoanViewController *chuyenTienDenTK = [[DucNT_ChuyenTienDenTaiKhoanViewController alloc] initWithNibName:@"DucNT_ChuyenTienDenTaiKhoanViewController" bundle:nil];
        [self.navigationController pushViewController:chuyenTienDenTK animated:YES];
        [chuyenTienDenTK release];
//    }
//    else
//    {
//        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
//        loginSceen.sTenViewController = @"DucNT_ChuyenTienDenTaiKhoanViewController";
//        loginSceen.sKieuChuyenGiaoDien = @"push";
//        [self presentViewController:loginSceen animated:YES completion:^{}];
//        [loginSceen release];
//    }
}

- (IBAction)suKienBamNutChuyenTienDenThe:(id)sender {
//    if([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue])
//    {
        DucNT_ChuyenTienDenTheViewController *chuyenTienDenThe = [[DucNT_ChuyenTienDenTheViewController alloc] initWithNibName:@"DucNT_ChuyenTienDenTheViewController" bundle:nil];
        [self.navigationController pushViewController:chuyenTienDenThe animated:YES];
        [chuyenTienDenThe release];
//    }
//    else
//    {
//        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
//        loginSceen.sTenViewController = @"DucNT_ChuyenTienDenTheViewController";
//        loginSceen.sKieuChuyenGiaoDien = @"push";
//        [self presentViewController:loginSceen animated:YES completion:^{}];
//        [loginSceen release];
//    }
}

- (IBAction)suKienBamNutChuyenTienTanNha:(id)sender{
//    if([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue])
//    {
        ChuyenTienTanNhaViewController *chuyenTienTanNhaViewController = [[ChuyenTienTanNhaViewController alloc] initWithNibName:@"ChuyenTienTanNhaViewController" bundle:nil];
        [self.navigationController pushViewController:chuyenTienTanNhaViewController animated:YES];
        [chuyenTienTanNhaViewController release];
//    }
//    else
//    {
//        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
//        loginSceen.sTenViewController = @"ChuyenTienTanNhaViewController";
//        loginSceen.sKieuChuyenGiaoDien = @"push";
//        [self presentViewController:loginSceen animated:YES completion:^{}];
//        [loginSceen release];
//    }
}

- (IBAction)suKienBamNutChuyenTienDenViKhac:(id)sender{
    GiaoDienDenKhac *vc = [[GiaoDienDenKhac alloc] initWithNibName:@"GiaoDienDenKhac" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
//    if([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue])
//    {
    
//        ChuyenTienDenViMomoViewController *chuyenTienDenViMomoViewController = [[ChuyenTienDenViMomoViewController alloc] initWithNibName:@"ChuyenTienDenViMomoViewController" bundle:nil];
//        [self.navigationController pushViewController:chuyenTienDenViMomoViewController animated:YES];
//        [chuyenTienDenViMomoViewController release];
    
//    }
//    else
//    {
//        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
//        loginSceen.sTenViewController = @"ChuyenTienDenViMomoViewController";
//        loginSceen.sKieuChuyenGiaoDien = @"push";
//        [self presentViewController:loginSceen animated:YES completion:^{}];
//        [loginSceen release];
//    }
}

- (IBAction)suKienBamNutChuyenTienTietKiem:(id)sender{
//    if([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue])
//    {
        GuiTietKiemViewController *guiTietKiemViewController = [[GuiTietKiemViewController alloc] initWithNibName:@"GuiTietKiemViewController" bundle:nil];
        [self.navigationController pushViewController:guiTietKiemViewController animated:YES];
        [guiTietKiemViewController release];
//    }
//    else
//    {
//        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
//        loginSceen.sTenViewController = @"GuiTietKiemViewController";
//        loginSceen.sKieuChuyenGiaoDien = @"push";
//        [self presentViewController:loginSceen animated:YES completion:^{}];
//        [loginSceen release];
//    }
}

- (IBAction)suKienBamNutChuyenTienTuThien:(id)sender{
    [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Chức năng đang được phát triển"];
}

- (IBAction)suKienBamNutThanhToanDienThoai:(id)sender{
    NSLog(@"%s - thanh toan dien thoai nao", __FUNCTION__);
//    if([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue])
//    {
        ThanhToanDienThoaiKhacViewController *thanhToanDienThoaiKhac = [[ThanhToanDienThoaiKhacViewController alloc] initWithNibName:@"ThanhToanDienThoaiKhacViewController" bundle:nil];
        thanhToanDienThoaiKhac.mNhaMang = NHA_MANG_VIETTEL;
        [self.navigationController pushViewController:thanhToanDienThoaiKhac animated:YES];
        [thanhToanDienThoaiKhac release];
//    }
//    else
//    {
//        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
//        loginSceen.sTenViewController = @"ThanhToanDienThoaiKhacViewController";
//        loginSceen.sKieuChuyenGiaoDien = @"push";
//        [self presentViewController:loginSceen animated:YES completion:^{}];
//        [loginSceen release];
//    }
}

- (IBAction)suKienBamNutVePhim:(id)sender{
    GiaoDienDatVeXemPhim *muaTheTroChoiDienTuViewController = [[GiaoDienDatVeXemPhim alloc] initWithNibName:@"GiaoDienDatVeXemPhim" bundle:nil];
    [self.navigationController pushViewController:muaTheTroChoiDienTuViewController animated:YES];
    [muaTheTroChoiDienTuViewController release];
//    if([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue])
//    {
//        GiaoDienDatVeXemPhim *muaTheTroChoiDienTuViewController = [[GiaoDienDatVeXemPhim alloc] initWithNibName:@"GiaoDienDatVeXemPhim" bundle:nil];
//        [self.navigationController pushViewController:muaTheTroChoiDienTuViewController animated:YES];
//        [muaTheTroChoiDienTuViewController release];
//    }
//    else
//    {
//        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
//        loginSceen.sTenViewController = @"GiaoDienDatVeXemPhim";
//        loginSceen.sKieuChuyenGiaoDien = @"push";
//        [self presentViewController:loginSceen animated:YES completion:^{}];
//        [loginSceen release];
//    }
}

- (IBAction)suKienBamNutVeMayBay:(id)sender{
//    if([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue])
//    {
        GiaoDienDatVeMayBay *vc = [[GiaoDienDatVeMayBay alloc] initWithNibName:@"GiaoDienDatVeMayBay" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
//    }
//    else
//    {
//        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
//        loginSceen.sTenViewController = @"GiaoDienDatVeMayBay";
//        loginSceen.sKieuChuyenGiaoDien = @"push";
//        [self presentViewController:loginSceen animated:YES completion:^{}];
//        [loginSceen release];
//    }
}

- (IBAction)suKienBamNutVeTau:(id)sender{
//    [@"Under development" localizableString]
    [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Đang phát triển"];
}

- (IBAction)suKienBamNutDien:(id)sender{
//    if([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue])
//    {
        TraCuuTienDienViewController *traCuuTienDienViewController = [[TraCuuTienDienViewController alloc] initWithNibName:@"TraCuuTienDienViewController" bundle:nil];
        [self.navigationController pushViewController:traCuuTienDienViewController animated:YES];
        [traCuuTienDienViewController release];
//    }
//    else
//    {
//        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
//        loginSceen.sTenViewController = @"TraCuuTienDienViewController";
//        loginSceen.sKieuChuyenGiaoDien = @"push";
//        [self presentViewController:loginSceen animated:YES completion:^{}];
//        [loginSceen release];
//    }
}

- (IBAction)suKienBamNutNuoc:(id)sender{
//    if([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]){
        GiaoDienThanhToanNuoc *internet = [[GiaoDienThanhToanNuoc alloc] initWithNibName:@"GiaoDienThanhToanNuoc" bundle:nil];
        [self.navigationController pushViewController:internet animated:YES];
        [internet release];
//    }
//    else
//    {
//        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
//        loginSceen.sTenViewController = @"GiaoDienThanhToanNuoc";
//        loginSceen.sKieuChuyenGiaoDien = @"push";
//        [self presentViewController:loginSceen animated:YES completion:^{}];
//        [loginSceen release];
//    }
}

- (IBAction)suKienBamNutInternet:(id)sender{
//    if([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]){
        GiaoDienThanhToanInternet *internet = [[GiaoDienThanhToanInternet alloc] initWithNibName:@"GiaoDienThanhToanInternet" bundle:nil];
        [self.navigationController pushViewController:internet animated:YES];
        [internet release];
//    }
//    else
//    {
//        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
//        loginSceen.sTenViewController = @"GiaoDienThanhToanInternet";
//        loginSceen.sKieuChuyenGiaoDien = @"push";
//        [self presentViewController:loginSceen animated:YES completion:^{}];
//        [loginSceen release];
//    }
}

- (IBAction)suKienBamNutTruyenHinh:(id)sender{
//    [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:[@"Under development" localizableString]];
//    if([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]){
        GiaoDienTraCuuTruyenHinh *internet = [[GiaoDienTraCuuTruyenHinh alloc] initWithNibName:@"GiaoDienTraCuuTruyenHinh" bundle:nil];
        [self.navigationController pushViewController:internet animated:YES];
        [internet release];
//    }
//    else
//    {
//        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
//        loginSceen.sTenViewController = @"GiaoDienTraCuuTruyenHinh";
//        loginSceen.sKieuChuyenGiaoDien = @"push";
//        [self presentViewController:loginSceen animated:YES completion:^{}];
//        [loginSceen release];
//    }
}

- (IBAction)suKienBamNutBaoHiem:(id)sender{
    GiaoDienBaoHiem *vc = [[GiaoDienBaoHiem alloc] initWithNibName:@"GiaoDienBaoHiem" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (IBAction)suKienBamNutChungKhoan:(id)sender{
//    if([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue])
//    {
        GiaoDienThanhToanChungKhoan *danhSachQuaTangViewController = [[GiaoDienThanhToanChungKhoan alloc] initWithNibName:@"GiaoDienThanhToanChungKhoan" bundle:nil];
        [self.navigationController pushViewController:danhSachQuaTangViewController animated:YES];
        [danhSachQuaTangViewController release];
//    }
//    else
//    {
//        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
//        loginSceen.sTenViewController = @"GiaoDienThanhToanChungKhoan";
//        loginSceen.sKieuChuyenGiaoDien = @"push";
//        [self presentViewController:loginSceen animated:YES completion:^{}];
//        [loginSceen release];
//    }
}

- (IBAction)suKienBamNutTraTienVay:(id)sender{
//    if([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue])
//    {
        GiaoDienTraCuuTienVay *danhSachQuaTangViewController = [[GiaoDienTraCuuTienVay alloc] initWithNibName:@"GiaoDienTraCuuTienVay" bundle:nil];
        [self.navigationController pushViewController:danhSachQuaTangViewController animated:YES];
        [danhSachQuaTangViewController release];
//    }
//    else
//    {
//        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
//        loginSceen.sTenViewController = @"GiaoDienTraCuuTienVay";
//        loginSceen.sKieuChuyenGiaoDien = @"push";
//        [self presentViewController:loginSceen animated:YES completion:^{}];
//        [loginSceen release];
//    }
}

- (IBAction)suKienBamNutHocPhi:(id)sender{
    NSLog(@"%s - click click!!!", __FUNCTION__);
//    if([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue])
//    {
        GiaoDienThanhToanHocPhi *danhSachQuaTangViewController = [[GiaoDienThanhToanHocPhi alloc] initWithNibName:@"GiaoDienThanhToanHocPhi" bundle:nil];
        [self.navigationController pushViewController:danhSachQuaTangViewController animated:YES];
        [danhSachQuaTangViewController release];
//    }
//    else
//    {
//        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
//        loginSceen.sTenViewController = @"GiaoDienThanhToanHocPhi";
//        loginSceen.sKieuChuyenGiaoDien = @"push";
//        [self presentViewController:loginSceen animated:YES completion:^{}];
//        [loginSceen release];
//    }
}

- (IBAction)suKienBamNutTangQua:(id)sender{
    NSLog(@"%s - click click!!!", __FUNCTION__);
//    if([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue])
//    {
        DanhSachQuaTangViewController *danhSachQuaTangViewController = [[DanhSachQuaTangViewController alloc] initWithNibName:@"DanhSachQuaTangViewController" bundle:nil];
        [self.navigationController pushViewController:danhSachQuaTangViewController animated:YES];
        [danhSachQuaTangViewController release];
//    }
//    else
//    {
//        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
//        loginSceen.sTenViewController = @"DanhSachQuaTangViewController";
//        loginSceen.sKieuChuyenGiaoDien = @"push";
//        [self presentViewController:loginSceen animated:YES completion:^{}];
//        [loginSceen release];
//    }
}

- (void)suKienChonPhoneToken {
    if([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue])
    {
        if([self.mThongTinTaiKhoanVi.nIsToken intValue] != 0)
        {
            DucNT_HienThiTokenViewController *hienThiTokenViewController = [[DucNT_HienThiTokenViewController alloc] initWithNibName:@"DucNT_HienThiTokenViewController" bundle:nil];
            [self.navigationController pushViewController:hienThiTokenViewController animated:YES];
            [hienThiTokenViewController release];
        }
        else
        {
            DucNT_DangKyToken *vc = [[DucNT_DangKyToken alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
        }
    }
    else
    {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        loginSceen.sTenViewController = @"DucNT_HienThiTokenViewController";
        loginSceen.sKieuChuyenGiaoDien = @"push";
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
    }
}

//Chuyen phone token sang qr san pham theo y chu tịt
- (IBAction)suKienBamNutPhoneToKen:(id)sender{
    NSLog(@"%s - click click!!!", __FUNCTION__);
    if([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue])
    {
        QRDonViViewController *hienThiTokenViewController = [[QRDonViViewController alloc] initWithNibName:@"QRDonViViewController" bundle:nil];
        [self.navigationController pushViewController:hienThiTokenViewController animated:YES];
        [hienThiTokenViewController release];
    }
    else
    {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        loginSceen.sTenViewController = @"DucNT_HienThiTokenViewController";
        loginSceen.sKieuChuyenGiaoDien = @"push";
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
    }
}

- (IBAction)suKienBamNutCachNapVi:(id)sender{
    HuongDanNapTienViewController *huongDanNapTienViewController = [[HuongDanNapTienViewController alloc] initWithNibName:@"HuongDanNapTienViewController" bundle:nil];
    [self.navigationController pushViewController:huongDanNapTienViewController animated:YES];
    [huongDanNapTienViewController release];
}

- (IBAction)suKienBamNutChuyenTienATM:(id)sender {
//    if([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]){
        GiaoDienChuyenTienATM *internet = [[GiaoDienChuyenTienATM alloc] initWithNibName:@"GiaoDienChuyenTienATM" bundle:nil];
        [self.navigationController pushViewController:internet animated:YES];
        [internet release];
//    }
//    else
//    {
//        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
//        loginSceen.sTenViewController = @"GiaoDienChuyenTienATM";
//        loginSceen.sKieuChuyenGiaoDien = @"push";
//        [self presentViewController:loginSceen animated:YES completion:^{}];
//        [loginSceen release];
//    }
}

- (IBAction)suKienBamChuyenTienDenCMND:(id)sender {
//    if([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]){
        GiaoDienChuyenTienDenCMND *internet = [[GiaoDienChuyenTienDenCMND alloc] initWithNibName:@"GiaoDienChuyenTienDenCMND" bundle:nil];
        [self.navigationController pushViewController:internet animated:YES];
        [internet release];
//    }
//    else
//    {
//        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
//        loginSceen.sTenViewController = @"GiaoDienChuyenTienDenCMND";
//        loginSceen.sKieuChuyenGiaoDien = @"push";
//        [self presentViewController:loginSceen animated:YES completion:^{}];
//        [loginSceen release];
//    }
}

- (IBAction)suKienBamNutXeKhach:(id)sender {
    GiaoDienDatVeXe *internet = [[GiaoDienDatVeXe alloc] initWithNibName:@"GiaoDienDatVeXe" bundle:nil];
    [self.navigationController pushViewController:internet animated:YES];
    [internet release];
}

- (IBAction)suKienBamNutMuaSam:(id)sender {
    [UIAlertView alert:@"Đang phát triển" withTitle:[@"thong_bao" localizableString] block:nil];
}

- (IBAction)suKienKetThucSpeak:(id)sender {

}

- (IBAction)suKienChonPhoneTokenLan2:(id)sender {
    [self suKienChonPhoneToken];
}

- (IBAction)suKienChonLixi:(id)sender {
    [UIAlertView alert:@"Đang phát triển" withTitle:[@"thong_bao" localizableString] block:nil];
}

- (IBAction)suKienChonXemGiayPhep:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.sbv.gov.vn/webcenter/portal/vi/menu/trangchu/ttsk/ttsk_chitiet?centerWidth=80%25&dDocName=SBV331391&leftWidth=20%25&rightWidth=0%25&showFooter=false&showHeader=false&_adf.ctrl-state=1c7kax1f62_4&_afrLoop=1291034936391000"]];
}

- (void)capNhatTrangThaiGiongNoi {
    if (isChuyenGiaoDien) {
        return;
    }
    isChuyenGiaoDien = YES;

}

- (void)xuLySuKienBamNutPhoneToken
{
    mTrangThaiDangOViewBenTrai = YES;
    [mDrawer close:^{}];
    if([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue])
    {
        int nTrangThaiCoToken = [[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_TRANG_THAI_CO_TOKEN ] intValue];
        if( nTrangThaiCoToken != 0)
        {
            DucNT_HienThiTokenViewController *hienThiTokenViewController = [[DucNT_HienThiTokenViewController alloc] initWithNibName:@"DucNT_HienThiTokenViewController" bundle:nil];
            [self.navigationController pushViewController:hienThiTokenViewController animated:YES];
            [hienThiTokenViewController release];
        }
        else
        {
            DucNT_DangKyToken *vc = [[DucNT_DangKyToken alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
        }
    }
    else
    {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        loginSceen.sTenViewController = @"DucNT_HienThiTokenViewController";
        loginSceen.sKieuChuyenGiaoDien = @"push";
        if([self.mThongTinTaiKhoanVi.nIsToken intValue] == 0)
        {
            loginSceen.sTenViewController = @"DucNT_DangKyToken";
            loginSceen.sKieuChuyenGiaoDien = @"push";
        }
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
    }
}

- (void)xuLySuKienChonThanhToanMobifone
{
    mTrangThaiDangOViewBenTrai = YES;
    ThanhToanDienThoaiKhacViewController *thanhToanDienThoaiKhac = [[ThanhToanDienThoaiKhacViewController alloc] initWithNibName:@"ThanhToanDienThoaiKhacViewController" bundle:nil];
    thanhToanDienThoaiKhac.mNhaMang = NHA_MANG_VIETTEL;
    [mDrawer close:^{}];
    [self.navigationController pushViewController:thanhToanDienThoaiKhac animated:YES];
    [thanhToanDienThoaiKhac release];
}

- (void)xuLySuKienBamNutThongBao
{
    //thong bao la dang phat trien
    HienThiDanhSachTinQuangBaViewController *hienThiTinQuangBaViewController = [[HienThiDanhSachTinQuangBaViewController alloc] initWithNibName:@"HienThiDanhSachTinQuangBaViewController" bundle:nil];

    [self.navigationController pushViewController:hienThiTinQuangBaViewController animated:YES];
    [hienThiTinQuangBaViewController release];
}

- (void)xuLySuKienBamNutTroChuyen{
//    [self khoiTaoQuangCao];
    [self suKienChonQRCode];
}

- (void)xuLySuKienXemSaoKe:(UIButton*)sender
{
    if([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue])
    {
        DucNT_SaoKeViewController *saoKeViewController = [[DucNT_SaoKeViewController alloc] initWithNibName:@"DucNT_SaoKeViewController" bundle:nil];
        saoKeViewController.nTrangThaiXem = (int)sender.tag;
        [self.navigationController pushViewController:saoKeViewController animated:YES];
        [saoKeViewController release];
    }
    else
    {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        loginSceen.sTenViewController = @"DucNT_SaoKeViewController";
        loginSceen.sKieuChuyenGiaoDien = @"push";
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
    }
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CollectionCellGiaoDienChinh";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    UIImageView *img = (UIImageView *)[cell viewWithTag:100];
    [img setImage:[UIImage imageNamed:@"icon_v2_denvivimass.png"]];
    return cell;
}
- (void) updateThongTinViThanhCong:(NSNotification*) notification{
   DucNT_TaiKhoanViObject *objUpdate = (DucNT_TaiKhoanViObject*)[notification object];
    self.mThongTinTaiKhoanVi = objUpdate;
    [DucNT_LuuRMS luuThongTinTaiKhoanViSauDangNhap:self.mThongTinTaiKhoanVi];
    //[self capNhatGiaoDienBenTraiVaGiaoDienHeader];
}
- (void)dealloc {
    [_scrMain release];
    [_viewMain1 release];
    [_viewMain2 release];
    [_viewMain release];
    [mGiaoDienBenTrai release];
    if (showQC) {
        [showQC release];
    }

    [_collectionMain release];
    [super dealloc];
}

@end
