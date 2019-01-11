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
#import "QRSearchViewController.h"
#import "HiNavigationBar.h"
#import "ChiTietDuyetGiaoDichViewController.h"
#import "GiaoDienTinTuc.h"

@interface GiaoDienChinhV2 ()< ViewNavigationGiaoDienChinhDelegate, DucNT_ServicePostDelegate, GiaoDienChinhHeaderV2Delegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UIActionSheetDelegate, GiaoDienTinTucProtocol>{
    ViewNavigationGiaoDienChinh *mViewNavigationGiaoDienChinh;
    NSString *mDinhDanhKetNoi;
    BOOL mTrangThaiDangOViewBenTrai;
    bool isChuyenGiaoDien;
    GiaoDienChinhHeaderV2 *headerView;
    KASlideShow *showQC;
    bool isLoadQC;
    NSString *keyPin;
    GiaoDienTinTuc *tinTucViewController;
}

@property (nonatomic, retain) ItemMenuTaiChinh *mItemDangChon;
@property (nonatomic, assign) NSInteger mSoDuVi;
@property (nonatomic, assign) NSInteger mSoDuKhuyenMaiVi;
@property (nonatomic, retain) NSArray *mDanhSachAnhQuangCao;
@property (nonatomic, retain) NSArray *arrData;

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
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        
        statusBar.backgroundColor = [UIColor colorWithRed:30.0/255 green:48.0/233 blue:63/255.0 alpha:1];//set whatever color you like
    }

    keyPin = @"11111111";
//    self.arrData = @[@{@"icon":@"6vephim",@"title":@"Vé phim"},@{@"icon":@"6vebay",@"title":@"Vé bay"},@{@"icon":@"6vetau",@"title":@"Vé tàu"},@{@"icon":@"6vexe",@"title":@"Vé xe"},@{@"icon":@"6dthoai",@"title":@"D. thoại"},@{@"icon":@"6tiendtu",@"title":@"Tiền đ.tử"},@{@"icon":@"6mathe",@"title":@"Mã thẻ"},@{@"icon":@"6travay",@"title":@"Trả vay"},@{@"icon":@"6dien",@"title":@"Điện"},@{@"icon":@"6nuoc",@"title":@"Nước"},@{@"icon":@"6internet",@"title":@"Internet"},@{@"icon":@"6trhinh",@"title":@"Tr.hình"},@{@"icon":@"6chkhoan",@"title":@"Ch.khoán"},@{@"icon":@"6hocphi",@"title":@"Học phí"},@{@"icon":@"6tangqua",@"title":@"Tặng quà"},@{@"icon":@"6baohiem",@"title":@"Bảo hiểm"},@{@"icon":@"6tuthien",@"title":@"Từ thiện"},@{@"icon":@"6lixi",@"title":@"Lì xì"},@{@"icon":@"6token.png",@"title":@"Token"},@{@"icon":@"6napvi",@"title":@"Nạp ví"}];
    self.arrData = @[@{@"icon":@"6vephim",@"title":@"Vé phim"},@{@"icon":@"6vebay",@"title":@"Vé bay"},@{@"icon":@"6vetau",@"title":@"Vé tàu"},@{@"icon":@"6vexe",@"title":@"Vé xe"},@{@"icon":@"6dthoai",@"title":@"D. thoại"},@{@"icon":@"6travay",@"title":@"Trả vay"},@{@"icon":@"6dien",@"title":@"Điện"},@{@"icon":@"6nuoc",@"title":@"Nước"},@{@"icon":@"6internet",@"title":@"Internet"},@{@"icon":@"6trhinh",@"title":@"Tr.hình"},@{@"icon":@"6chkhoan",@"title":@"Ch.khoán"},@{@"icon":@"6hocphi",@"title":@"Học phí"},@{@"icon":@"6tangqua",@"title":@"Tặng quà"},@{@"icon":@"6baohiem",@"title":@"Bảo hiểm"},@{@"icon":@"6token.png",@"title":@"Token"},@{@"icon":@"6napvi",@"title":@"Nạp ví"}];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setInteger:0 forKey:@"KEY_INDEX_CLICK_QC"];
    [user synchronize];
    isLoadQC = NO;
    int nTongSoLuongTinChuaDoc = [[DichVuNotification shareService] laySoLuongTinChuaDocTrongChucNang:0];
    NSLog(@"%s - nTongSoLuongTinChuaDoc : %d", __FUNCTION__, nTongSoLuongTinChuaDoc);

    for (UIGestureRecognizer *recognizer in self.view.gestureRecognizers) {
        [self.view removeGestureRecognizer:recognizer];
    }
    
//    vVicuatoi;
//    @property (retain, nonatomic) IBOutlet UIView *vHuongDan;
//    @property (retain, nonatomic) IBOutlet UIView *vSoTay;
//    @property (retain, nonatomic) IBOutlet UIView *vUuDai;
    
    UITapGestureRecognizer *tapHuongDan1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(suKienChonTapGesture:)];
    tapHuongDan1.numberOfTapsRequired = 1;
    [self.vHuongDan addGestureRecognizer:tapHuongDan1];
    
    UITapGestureRecognizer *tapHuongDan2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(suKienChonTapGesture:)];
    tapHuongDan2.numberOfTapsRequired = 1;
    [self.vVicuatoi addGestureRecognizer:tapHuongDan2];
    
    UITapGestureRecognizer *tapHuongDan3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(suKienChonTapGesture:)];
    tapHuongDan3.numberOfTapsRequired = 1;
    [self.vSoTay addGestureRecognizer:tapHuongDan3];
    
    UITapGestureRecognizer *tapHuongDan4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(suKienChonTapGesture:)];
    tapHuongDan4.numberOfTapsRequired = 1;
    [self.vUuDai addGestureRecognizer:tapHuongDan4];
    
    [self.vCenter setHidden:YES];
}

- (void)suKienChonTapGesture:(UITapGestureRecognizer *)tap {
    self.navigationController.navigationBar.hidden = false;
    [self suKienBamNutCachNapVi:nil];
}
//
//- (void)suKienChonTinTuc:(UITapGestureRecognizer *)tap {
//    NSLog(@"%s - #function - START", __FUNCTION__);
//    [self.quangcaoView setHidden:YES];
//    [self.collectionMain setHidden:YES];
//    if (tinTucViewController == nil) {
//        tinTucViewController = [[GiaoDienTinTuc alloc] initWithNibName:@"GiaoDienTinTuc" bundle:nil];
//    }
//    [self hienThiNoiDungTab:tinTucViewController];
//}

- (void)hienThiNoiDungTab:(UIViewController *)content {
    [self.vCenter setHidden:NO];
    [self addChildViewController:content];
    content.view.frame = self.vCenter.bounds;
    [self.vCenter addSubview:content.view];
    [content didMoveToParentViewController:self];
}

- (void) hideContentController: (UIViewController*) content
{
    NSLog(@"%s - remove view ngan hang", __FUNCTION__);
    [content willMoveToParentViewController:nil];  // 1
    [content.view removeFromSuperview];            // 2
    [content removeFromParentViewController];      // 3
    [self.vCenter setHidden:YES];
    [self.quangcaoView setHidden:NO];
    [self.collectionMain setHidden:NO];
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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = true;
    if (!headerView) {
        headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GiaoDienChinhHeaderV2 class]) owner:self options:nil] objectAtIndex:0];
        headerView.mDelegate = self;
        CGRect frameHeader = headerView.frame;
        frameHeader.size.width = self.view.frame.size.width;
        frameHeader.origin.x = 0;
        frameHeader.origin.y = 0;
        float scale = (750.0/340.0);
        self.slideShowHeigt.constant = [UIScreen mainScreen].bounds.size.width/scale;
        NSLog(@"%s - [UIScreen mainScreen].bounds.size.width : %f", __FUNCTION__, [UIScreen mainScreen].bounds.size.height);
        NSLog(@"%s - self.slideShowHeigt.constant : %f", __FUNCTION__, self.slideShowHeigt.constant);
        headerView.frame = [self.quangcaoView bounds];
        [headerView capNhatFrameSlide];
        [self.quangcaoView addSubview:headerView];
        [self.quangcaoView layoutIfNeeded];
        [self.quangcaoView layoutSubviews];
        
        if ([UIScreen mainScreen].bounds.size.height < 812.0) {
            self.topSlideConstraint.constant = 20.0;
        }
    }
    [self capNhatGiaoDienBenTraiVaGiaoDienHeader];
    self.collectionMain.delegate = self;
    [self.collectionMain setDataSource:self];
    UINib *cellNib = [UINib nibWithNibName:@"CollectionCellGiaoDienChinh" bundle:nil];
    [self.collectionMain registerNib:cellNib forCellWithReuseIdentifier:@"CollectionCellGiaoDienChinh"];

    [self.collectionMain reloadData];

    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapVicuatoi:)];
    tap4.numberOfTapsRequired = 1;
    [self.vVicuatoi addGestureRecognizer:tap4 ];}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(!isLoadQC) {
        [self ketNoiQuangCao];
    }
}
-(void)tapVicuatoi:(UITapGestureRecognizer*)gesture{
//    [self doBack:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickVicuatoi" object:nil];
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


- (void)xuLySuKienChonItemMenuTaiChinh:(ItemMenuTaiChinh*)item
{
    self.mItemDangChon = item;
    __block GiaoDienChinhV2 *blockSELF = self;
    [blockSELF xuLySuKienChonItemMenuDaDangNhap:item];
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
  //  [self xuLyGiaoDienKhiVaoApp];
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

- (void)capNhatGiaoDienBenTraiVaGiaoDienHeader
{
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
        ChuyenTienViewController *chuyenTienViewController = [[ChuyenTienViewController alloc] initWithNibName:@"ChuyenTienViewController" bundle:nil];
        [self.navigationController pushViewController:chuyenTienViewController animated:YES];
        [chuyenTienViewController release];
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

    } else {
        self.navigationController.navigationBar.hidden = false;
        if ([sNameImage containsString:@"vé phim"]) {
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
        else if ([sNameImage containsString:@"đến tài khoản"]) {
            [self suKienBamNutChuyenTienDenTaiKhoan:nil];
        }
        else if ([sNameImage containsString:@"đến ATM"] || [sNameImage containsString:@"atm"]) {
            [self suKienBamNutChuyenTienATM:nil];
        }
        else if ([sNameImage containsString:@"đến thẻ"]) {
            [self suKienBamNutChuyenTienDenThe:nil];
        }
        else if ([sNameImage containsString:@"tiết kiệm"]) {
            [self suKienBamNutChuyenTienTietKiem:nil];
        }
        else if ([sNameImage containsString:@"vé máy bay"]) {
            [self suKienBamNutVeMayBay:nil];
        }
        else if ([sNameImage containsString:@"đến tận nhà"]) {
            [self suKienBamNutChuyenTienTanNha:nil];
        }
        else if ([sNameImage containsString:@"tặng quà"]) {
            [self suKienBamNutTangQua:nil];
        }
        else if ([sNameImage containsString:@"đến cmnd"]) {
            [self suKienBamChuyenTienDenCMND:nil];
        }
        else if ([sNameImage containsString:@"trả tiền vay"]) {
            [self suKienBamNutTraTienVay:nil];
        }
        else if ([sNameImage containsString:@"cách nạp ví"]) {
            [self suKienBamNutCachNapVi:nil];
        }
        else if ([sNameImage containsString:@"điện"]) {
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
        else if ([sNameImage containsString:@"nước"]) {
            [self suKienBamNutNuoc:nil];
        }
        else if ([sNameImage containsString:@"internet"]) {
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
        else if ([sNameImage containsString:@"truyền hình"]) {
            [self suKienBamNutTruyenHinh:nil];
        }
        else if ([sNameImage containsString:@"nạp tiền"]) {
            [self xuLySuKienBamNutNapTien];
        }
        else if ([sNameImage containsString:@"điện thoại"]) {
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
        else if ([sNameImage containsString:@"quét QR"]) {
            [self suKienChonQRCode];
        }
        else if ([sNameImage containsString:@"mã QR"]) {
            [self suKienBamNutPhoneToKen:nil];
        }
    }
}

#pragma mark - Xu ly su kien
- (void)xuLySuKienDieuKhienGiongNoi {

}

- (void)xuLySuKienChonThongTinVi{
    if([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue])
    {
        mTrangThaiDangOViewBenTrai = YES;
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
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        loginSceen.sTenViewController = @"DucNT_ChangPrivateInformationViewController";
        loginSceen.sKieuChuyenGiaoDien = @"push";
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
    }
}

- (IBAction)suKienBamChuyenTienDenViNoiBo:(id)sender {
    DucNT_ChuyenTienViDenViViewController *chuyenTienDenVi = [[DucNT_ChuyenTienViDenViViewController alloc] initWithNibName:@"DucNT_ChuyenTienViDenViViewController" bundle:nil];
    [self.navigationController pushViewController:chuyenTienDenVi animated:YES];
    [chuyenTienDenVi release];
}

- (IBAction)suKienBamNutChuyenTienDenTaiKhoan:(id)sender {
    DucNT_ChuyenTienDenTaiKhoanViewController *chuyenTienDenTK = [[DucNT_ChuyenTienDenTaiKhoanViewController alloc] initWithNibName:@"DucNT_ChuyenTienDenTaiKhoanViewController" bundle:nil];
    [self.navigationController pushViewController:chuyenTienDenTK animated:YES];
    [chuyenTienDenTK release];
}

- (IBAction)suKienBamNutChuyenTienDenThe:(id)sender {
    DucNT_ChuyenTienDenTheViewController *chuyenTienDenThe = [[DucNT_ChuyenTienDenTheViewController alloc] initWithNibName:@"DucNT_ChuyenTienDenTheViewController" bundle:nil];
    [self.navigationController pushViewController:chuyenTienDenThe animated:YES];
    [chuyenTienDenThe release];
}

- (IBAction)suKienBamNutChuyenTienTanNha:(id)sender{
    ChuyenTienTanNhaViewController *chuyenTienTanNhaViewController = [[ChuyenTienTanNhaViewController alloc] initWithNibName:@"ChuyenTienTanNhaViewController" bundle:nil];
    [self.navigationController pushViewController:chuyenTienTanNhaViewController animated:YES];
    [chuyenTienTanNhaViewController release];
}

- (IBAction)suKienBamNutChuyenTienDenViKhac:(id)sender{
    GiaoDienDenKhac *vc = [[GiaoDienDenKhac alloc] initWithNibName:@"GiaoDienDenKhac" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (IBAction)suKienBamNutChuyenTienTietKiem:(id)sender{        GuiTietKiemViewController *guiTietKiemViewController = [[GuiTietKiemViewController alloc] initWithNibName:@"GuiTietKiemViewController" bundle:nil];
    [self.navigationController pushViewController:guiTietKiemViewController animated:YES];
    [guiTietKiemViewController release];
}

- (IBAction)suKienBamNutChuyenTienTuThien:(id)sender{
    [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Chức năng đang được phát triển"];
}

- (IBAction)suKienBamNutThanhToanDienThoai:(id)sender{
    NSLog(@"%s - thanh toan dien thoai nao", __FUNCTION__);
    ThanhToanDienThoaiKhacViewController *thanhToanDienThoaiKhac = [[ThanhToanDienThoaiKhacViewController alloc] initWithNibName:@"ThanhToanDienThoaiKhacViewController" bundle:nil];
        thanhToanDienThoaiKhac.mNhaMang = NHA_MANG_VIETTEL;
        [self.navigationController pushViewController:thanhToanDienThoaiKhac animated:YES];
        [thanhToanDienThoaiKhac release];
}

- (IBAction)suKienBamNutVePhim:(id)sender{
    GiaoDienDatVeXemPhim *muaTheTroChoiDienTuViewController = [[GiaoDienDatVeXemPhim alloc] initWithNibName:@"GiaoDienDatVeXemPhim" bundle:nil];
    [self.navigationController pushViewController:muaTheTroChoiDienTuViewController animated:YES];
    [muaTheTroChoiDienTuViewController release];
}

- (IBAction)suKienBamNutVeMayBay:(id)sender{
    GiaoDienDatVeMayBay *vc = [[GiaoDienDatVeMayBay alloc] initWithNibName:@"GiaoDienDatVeMayBay" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (IBAction)suKienBamNutVeTau:(id)sender{
//    ChiTietDuyetGiaoDichViewController *vc = [[ChiTietDuyetGiaoDichViewController alloc] initWithNibName:@"ChiTietDuyetGiaoDichViewController" bundle:nil];
//    [self.navigationController pushViewController:vc animated:YES];
//    [vc release];
    [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Đang phát triển"];
}

- (IBAction)suKienBamNutDien:(id)sender{
    TraCuuTienDienViewController *traCuuTienDienViewController = [[TraCuuTienDienViewController alloc] initWithNibName:@"TraCuuTienDienViewController" bundle:nil];
    [self.navigationController pushViewController:traCuuTienDienViewController animated:YES];
    [traCuuTienDienViewController release];
}

- (IBAction)suKienBamNutNuoc:(id)sender{
    GiaoDienThanhToanNuoc *internet = [[GiaoDienThanhToanNuoc alloc] initWithNibName:@"GiaoDienThanhToanNuoc" bundle:nil];
    [self.navigationController pushViewController:internet animated:YES];
    [internet release];
}

- (IBAction)suKienBamNutInternet:(id)sender{
    GiaoDienThanhToanInternet *internet = [[GiaoDienThanhToanInternet alloc] initWithNibName:@"GiaoDienThanhToanInternet" bundle:nil];
    [self.navigationController pushViewController:internet animated:YES];
    [internet release];
}

- (IBAction)suKienBamNutTruyenHinh:(id)sender{
    GiaoDienTraCuuTruyenHinh *internet = [[GiaoDienTraCuuTruyenHinh alloc] initWithNibName:@"GiaoDienTraCuuTruyenHinh" bundle:nil];
    [self.navigationController pushViewController:internet animated:YES];
    [internet release];
}

- (IBAction)suKienBamNutBaoHiem:(id)sender{
    GiaoDienBaoHiem *vc = [[GiaoDienBaoHiem alloc] initWithNibName:@"GiaoDienBaoHiem" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (IBAction)suKienBamNutChungKhoan:(id)sender{

    GiaoDienThanhToanChungKhoan *danhSachQuaTangViewController = [[GiaoDienThanhToanChungKhoan alloc] initWithNibName:@"GiaoDienThanhToanChungKhoan" bundle:nil];
    [self.navigationController pushViewController:danhSachQuaTangViewController animated:YES];
    [danhSachQuaTangViewController release];
}

- (IBAction)suKienBamNutTraTienVay:(id)sender{
    GiaoDienTraCuuTienVay *danhSachQuaTangViewController = [[GiaoDienTraCuuTienVay alloc] initWithNibName:@"GiaoDienTraCuuTienVay" bundle:nil];
    [self.navigationController pushViewController:danhSachQuaTangViewController animated:YES];
    [danhSachQuaTangViewController release];
}

- (IBAction)suKienBamNutHocPhi:(id)sender{
    NSLog(@"%s - click click!!!", __FUNCTION__);
    GiaoDienThanhToanHocPhi *danhSachQuaTangViewController = [[GiaoDienThanhToanHocPhi alloc] initWithNibName:@"GiaoDienThanhToanHocPhi" bundle:nil];
    [self.navigationController pushViewController:danhSachQuaTangViewController animated:YES];
    [danhSachQuaTangViewController release];
}

- (IBAction)suKienBamNutTangQua:(id)sender{
    NSLog(@"%s - click click!!!", __FUNCTION__);
    DanhSachQuaTangViewController *danhSachQuaTangViewController = [[DanhSachQuaTangViewController alloc] initWithNibName:@"DanhSachQuaTangViewController" bundle:nil];
    [self.navigationController pushViewController:danhSachQuaTangViewController animated:YES];
    [danhSachQuaTangViewController release];
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
        if([self.mThongTinTaiKhoanVi.nIsToken intValue] != 0)
        {
            DucNT_HienThiTokenViewController *hienThiTokenViewController = [[DucNT_HienThiTokenViewController alloc] initWithNibName:@"DucNT_HienThiTokenViewController" bundle:nil];
            [hienThiTokenViewController showBackButton];
            UINavigationController *navHome = [HiNavigationBar navigationControllerWithRootViewController: hienThiTokenViewController];
            [self presentViewController:navHome animated:YES completion:nil];
            [hienThiTokenViewController release];
        }
        else
        {
            DucNT_DangKyToken *vc = [[DucNT_DangKyToken alloc] init];
            UINavigationController *navHome = [HiNavigationBar navigationControllerWithRootViewController: vc];
            [self presentViewController:navHome animated:YES completion:nil];
            [vc release];
        }
//        QRDonViViewController *hienThiTokenViewController = [[QRDonViViewController alloc] initWithNibName:@"DucNT_HienThiTokenViewController" bundle:nil];
//        [self.navigationController pushViewController:hienThiTokenViewController animated:YES];
//        [hienThiTokenViewController release];
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
//    UINavigationController *navHome = [HiNavigationBar navigationControllerWithRootViewController: huongDanNapTienViewController];
//    [self.navigationController presentViewController:navHome animated:YES completion:nil];
    [self.navigationController pushViewController:huongDanNapTienViewController animated:YES];
    [huongDanNapTienViewController release];
}

- (IBAction)suKienBamNutChuyenTienATM:(id)sender {
    GiaoDienChuyenTienATM *internet = [[GiaoDienChuyenTienATM alloc] initWithNibName:@"GiaoDienChuyenTienATM" bundle:nil];
    [self.navigationController pushViewController:internet animated:YES];
    [internet release];
}

- (IBAction)suKienBamChuyenTienDenCMND:(id)sender {
    GiaoDienChuyenTienDenCMND *internet = [[GiaoDienChuyenTienDenCMND alloc] initWithNibName:@"GiaoDienChuyenTienDenCMND" bundle:nil];
    [self.navigationController pushViewController:internet animated:YES];
    [internet release];
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

- (IBAction)suKienChonTinTuc:(id)sender {
    NSLog(@"%s - #function - START", __FUNCTION__);
    [self.quangcaoView setHidden:YES];
    [self.collectionMain setHidden:YES];
    if (tinTucViewController == nil) {
        tinTucViewController = [[GiaoDienTinTuc alloc] initWithNibName:@"GiaoDienTinTuc" bundle:nil];
        tinTucViewController.delegate = self;
    }
    [self hienThiNoiDungTab:tinTucViewController];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.arrData count];
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    float cellWidth = ([[UIScreen mainScreen] bounds].size.width/4.0) - 1;
    float cellHeigh = (collectionView.frame.size.height/4.0);
    return CGSizeMake(cellWidth , cellHeigh);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CollectionCellGiaoDienChinh";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    NSDictionary *dict = [self.arrData objectAtIndex:indexPath.row];
    UIImageView *img = (UIImageView *)[cell viewWithTag:100];
    [img setImage:[UIImage imageNamed:[dict objectForKey:@"icon"]]];
//    UILabel *lbTitle = (UILabel *)[cell viewWithTag:101];
//    lbTitle.text = [dict objectForKey:@"title"];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.navigationController.navigationBar.hidden = false;
    switch (indexPath.row) {
        case 0:
        {
            [self suKienBamNutVePhim:nil];
        }
            break;
        case 1:
        {
            [self suKienBamNutVeMayBay:nil];
        }
            break;
        case 2:
        {
            self.navigationController.navigationBar.hidden = true;
            [self suKienBamNutVeTau:nil];
        }
            break;
        case 3:
        {
            [self suKienBamNutXeKhach:nil];
        }
            break;
        case 4:
        {
            [self suKienBamNutThanhToanDienThoai:nil];
        }
            break;
        case 5:
        {
            [self suKienBamNutTraTienVay:nil];
//            [self suKienBamNutChuyenTienDenTaiKhoan:nil];
        }
            break;
        case 6:
        {
            [self suKienBamNutDien:nil];
//            [self suKienBamNutChuyenTienDenThe:nil];
        }
            break;
        case 7:
        {
            [self suKienBamNutNuoc:nil];
//            [self suKienBamNutTraTienVay:nil];
        }
            break;
        case 8:
        {
            [self suKienBamNutInternet:nil];
//            [self suKienBamNutDien:nil];

        }
            break;
        case 9:
        {
            [self suKienBamNutTruyenHinh:nil];
//            [self suKienBamNutNuoc:nil];
        }
            break;
        case 10:
        {
            [self suKienBamNutChungKhoan:nil];
//             [self suKienBamNutInternet:nil];
        }
            break;
        case 11:
        {
            [self suKienBamNutHocPhi:nil];
//            [self suKienBamNutTruyenHinh:nil];
        }
            break;
        case 12:
        {
            [self suKienBamNutTangQua:nil];
//            [self suKienBamNutChungKhoan:nil];
        }
            break;
        case 13:
        {
            [self suKienBamNutBaoHiem:nil];
//            [self suKienBamNutHocPhi:nil];
        }
            break;
        case 14:
        {
            [self suKienBamNutPhoneToKen:nil];
        }
            break;
        case 15:
        {
            [self suKienBamNutCachNapVi:nil];
        }
            break;
        case 16:
        {
//            [self suKienBamNutChuyenTienTuThien:nil];
        }
            break;
        case 17:
        {
//            [self suKienChonLixi:nil];
        }
            break;
        case 18:
        {
            
        }
            break;
        case 19:
        {
            
        }
            break;
        default:
            break;
    }
}
- (void) updateThongTinViThanhCong:(NSNotification*) notification{
   DucNT_TaiKhoanViObject *objUpdate = (DucNT_TaiKhoanViObject*)[notification object];
    self.mThongTinTaiKhoanVi = objUpdate;
    [DucNT_LuuRMS luuThongTinTaiKhoanViSauDangNhap:self.mThongTinTaiKhoanVi];
}

//MARK : GiaoDienTinTucDelegate
- (void)suKienChonBackTinTuc {
    [self hideContentController:tinTucViewController];
}

- (void)dealloc {
    if (showQC) {
        [showQC release];
    }

    [_collectionMain release];
    [_collectionViewLayout release];
    [_slideShowHeigt release];
    [headerView release];
    [_vVicuatoi release];
    [_vHuongDan release];
    [_vSoTay release];
    [_vUuDai release];
    [_topSlideConstraint release];
    [_vCenter release];
    [super dealloc];
}

- (IBAction)doBack:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}
@end
