//
//  GiaoDienDatVeXemPhim.m
//  ViViMASS
//
//  Created by nguyen tam on 9/17/15.
//
//

#import "GiaoDienDatVeXemPhim.h"
#import "ItemPhongXemFilm.h"
#import "ItemHangXemFilm.h"
#import "ItemGheXemFilm.h"
#import "ObjectFilm.h"
#import "ObjectGioChieu.h"
#import "CellGroupNgayChieuPhim.h"
#import "CellGioChieuPhim.h"
#import "GiaoDienDatChoXemPhim.h"
#import "GiaoDienThongTinPhim.h"
#import "GiaoDienChonGheCGV.h"
#import "ItemGiaVeCGV.h"
#import "ItemChonGheCGV.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
@import WebKit;
@interface GiaoDienDatVeXemPhim ()<UIPickerViewDataSource, UIPickerViewDelegate, UIGestureRecognizerDelegate, UIWebViewDelegate, GiaoDienDatChoXemPhimProtocol, CLLocationManagerDelegate>{
    NSMutableArray *arrRapPhim;
    NSMutableArray *arrDanhSachPhim;
    NSMutableArray *arrDanhSachPhimHienTai;
    NSMutableArray *arrGheChon;
    NSMutableArray *arrRapHienTai;
    NSMutableArray *arrGiaTienCGV;
    NSString *sIdRap, *sGioChieu, *sNgayChieu;
    ObjectFilm *itemFilmHienTai;
    int nIndexNgay, nIndexPicker, nIndexTinhThanh, nIndexPhim;
    NSString *sIdGioChieu;
    ItemPhongXemFilm *phongHienTai;
    BOOL isSau17h, isNextPage;
    NSMutableArray *arrTinhThanh;
//    NSArray *arrTinhThanhKhongDau;
    ViewQuangCao *viewQC;
    float fHeightQc;
    
}

@end

@implementation GiaoDienDatVeXemPhim

static NSString *youTubeVideoHTML = @"<html><body style='margin:0px;padding:0px;'><script type='text/javascript' src='http://www.youtube.com/iframe_api'></script><script type='text/javascript'>function onYouTubeIframeAPIReady(){ytplayer=new YT.Player('playerId',{events:{onReady:onPlayerReady}})}function onPlayerReady(a){a.target.playVideo();}</script><iframe id='playerId' type='text/html' width='100%%'  src='http://www.youtube.com/embed/%@?enablejsapi=1&rel=0&playsinline=1&autoplay=1' frameborder='0'></body></html>";

//[5/21/16, 12:02:33 PM] Thanh Nguyen Trong: public static final int FUNC_DAT_VE_XEM_PHIM_CGV = 445;
//[5/21/16, 12:02:44 PM] Thanh Nguyen Trong: public static final int FUNC_DAT_VE_XEM_PHIM_PLATINUM = 432;

//[4/13/16, 3:22:07 PM] Thanh Nguyen Trong: https://vimass.vn/vmbank/services/vePhim/datVeCGV
//[4/13/16, 3:26:37 PM] Thanh Nguyen Trong: {"idRap":"123","idPhim":"123","idKhungGio":"322126""dsGhe":"pos-0000000001-3-5","soTien":115000.0,"appId": 1,
//    "typeAuthenticate": 0,
//    "token": "645654",
//    "otpConfirm": "",
//    "user": "0933201990","dsSoLuongVe":[{"idVe":"0058","sl":1,"gia":0.0}]}
//[3/31/16, 11:40:08 AM] Thanh Nguyen Trong: https://vimass.vn/vmbank/services/vePhim/getFull
//[3/31/16, 11:40:13 AM] Thanh Nguyen Trong: giờ trong dịch vụ đó
//[3/31/16, 11:40:29 AM] Thanh Nguyen Trong: sẽ trả về thêm 1 ds Tỉnh thành kèm ds tên rạp và id rạp tương ứng
//[3/31/16, 11:40:49 AM] Thanh Nguyen Trong: còn nếu muốn lấy riêng tỉnh thành
//[3/31/16, 11:40:52 AM] Thanh Nguyen Trong: thì gọi dịch vụ này
//[3/31/16, 11:40:53 AM] Thanh Nguyen Trong: https://vimass.vn/vmbank/services/vePhim/getTinhThanhRapPhim
//[3/31/16, 11:52:07 AM] Thanh Nguyen Trong: ===========
//[3/31/16, 11:52:25 AM] Thanh Nguyen Trong: còn nếu muốn lấy ds rạp và danh sách phim theo 1 thành phố cụ thể
//[3/31/16, 11:52:26 AM] Thanh Nguyen Trong: thì gọi
//[3/31/16, 11:52:26 AM] Thanh Nguyen Trong: https://vimass.vn/vmbank/services/vePhim/getRapVaPhimCuaThanhPho?thanhPho=xxxx
//[3/31/16, 11:52:55 AM] Thanh Nguyen Trong: trong đó
//[3/31/16, 11:53:22 AM] Thanh Nguyen Trong: xxx là tên thành phố trả về ở https://vimass.vn/vmbank/services/vePhim/getTinhThanhRapPhim
- (void)viewDidLoad {
    [super viewDidLoad];

    [self addButtonBack];
    [self addRightButton];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(windowVisible:)
                                                 name:UIWindowDidBecomeVisibleNotification
                                               object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(windowHidden:)
                                                 name:UIWindowDidBecomeHiddenNotification
                                               object:self.view.window];
    self.sTenThanhPhoCurrent = @"";
    self.mFuncID = FUNC_DAT_VE_XEM_PHIM;
    nIndexPhim = 0;
    nIndexTinhThanh = 0;
    isNextPage = NO;
    isSau17h = NO;
    nIndexNgay = 0;
    nIndexPicker = -1;
    sIdGioChieu = @"";
    sGioChieu = @"";
    fHeightQc = 200.0f;
//    self.title = @"Mua vé xem phim";
    [self addTitleView:@"Mua vé xem phim"];
    sIdRap = @"-1";
    [self.webPhongChieu setScalesPageToFit:YES];
//    self.webPhongChieu.delegate = self;
    [self khoiTaoBanDau];

    [self.collectionNgayChieu registerClass:[CellGroupNgayChieuPhim class] forCellWithReuseIdentifier:@"CellGroupNgayChieuPhim"];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(95, 30)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 5;
    [self.collectionNgayChieu setCollectionViewLayout:flowLayout];

    [self.collectionGioChieu registerClass:[CellGioChieuPhim class] forCellWithReuseIdentifier:@"CellGioChieuPhim"];
    UICollectionViewFlowLayout *flowLayout2 = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout2 setItemSize:CGSizeMake(70, 30)];
    [flowLayout2 setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout2.minimumInteritemSpacing = 5;
    flowLayout2.minimumLineSpacing = 5;
    [self.collectionGioChieu setCollectionViewLayout:flowLayout2];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tap.delegate = self;
    [self.webPhongChieu addGestureRecognizer:tap];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateThongTinGheCGV:) name:@"CHON_GHE_CGV" object:nil];
    self.edChonRap.enabled = NO;
}

- (void)windowVisible:(NSNotification *)notification
{
    NSLog(@"%s - windowVisible", __FUNCTION__);
    [self playerStarted];
}

- (void)windowHidden:(NSNotification *)notification
{
    NSLog(@"%s - windowHidden", __FUNCTION__);
    [self playerEnded];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self khoiTaoQuangCao];
}

- (void)khoiTaoQuangCao {
    if (viewQC) {
        return;
    }
    viewQC = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ViewQuangCao class]) owner:self options:nil] objectAtIndex:0];
//    viewQC.backgroundColor = UIColor.redColor;
    viewQC.mDelegate = self;
    CGRect rectToken = self.edChonPhim.frame;
    CGRect rectQC = viewQC.frame;
    CGRect rectMain = self.mViewMain.frame;
    rectQC.origin.x += 2;
    CGFloat fW = rectMain.size.width;
    CGFloat fH = fW * 0.4533;
    rectQC.origin.y = rectToken.origin.y + rectToken.size.height + 5;
    viewQC.frame = CGRectMake(0, rectQC.origin.y, fW, fH);
//    NSLog(@"%s - %d - viewQC.frame : %f - %f - %f - %f", __FUNCTION__, __LINE__, viewQC.frame.origin.x, viewQC.frame.origin.y, viewQC.frame.size.width, viewQC.frame.size.height);
    viewQC.mDelegate = self;
    [viewQC updateSizeQuangCao];
    NSLog(@"%s - %d - [UIScreen mainScreen].bounds.size.width : %f", __FUNCTION__, __LINE__, [UIScreen mainScreen].bounds.size.height);
    float fThem = 0;
    if ([UIScreen mainScreen].bounds.size.height == 896.0) {
        fThem = 20;
    }
    rectMain.size.height = rectQC.origin.y + rectQC.size.height + fThem;
    self.mViewMain.frame = rectMain;
    [self.mViewMain addSubview:viewQC];
    [self.scrMain setContentSize:CGSizeMake(_scrMain.frame.size.width, viewQC.frame.origin.y + viewQC.frame.size.height + 10)];
    
}

- (void)updateThongTinGheCGV:(NSNotification *)notification {
    if ([notification.name isEqualToString:@"CHON_GHE_CGV"]) {
        NSLog(@"%s - arrGiaTienCGV.count : %ld", __FUNCTION__, (long)arrGiaTienCGV.count);
        if ([self.edChonRap.text hasPrefix:@"BHD"]) {
            NSString *thongTinVe = @"";
            for (ItemGiaVeCGV *item in arrGiaTienCGV) {
                if (item.sl > 0) {
                    NSLog(@"%s - item : %@ - %d", __FUNCTION__, item.tenVe, item.sl);
                    thongTinVe = [thongTinVe stringByAppendingString:[NSString stringWithFormat:@"%@:%d;", item.idVe, item.sl]];
                }
            }
            NSLog(@"%s - thongTinVe : %@", __FUNCTION__, thongTinVe);
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
                [self hienThiLoading];
            }
            else {
                [RoundAlert show];
            }
            self.mDinhDanhKetNoi = DINH_DANH_LAY_THONG_TIN_GHE_NGOI_BHD;
            [GiaoDichMang layThongTinGheNgoiSauKhiChonGheBHD:sIdRap idPhim:itemFilmHienTai.idPhim idKhungGio:sIdGioChieu thongTinVe:thongTinVe noiNhanKetQua:self];
        }
        else if ([self.edChonRap.text.lowercaseString containsString:@"galaxy"]) {
            NSString *thongTinVe = @"";
            for (ItemGiaVeCGV *item in arrGiaTienCGV) {
                if (item.sl > 0) {
                    NSLog(@"%s - item : %@ - %d", __FUNCTION__, item.tenVe, item.sl);
                    thongTinVe = [thongTinVe stringByAppendingString:[NSString stringWithFormat:@"%@:%d;", item.idVe, item.sl]];
                }
            }
            NSLog(@"%s - thongTinVe : %@", __FUNCTION__, thongTinVe);
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
                [self hienThiLoading];
            }
            else {
                [RoundAlert show];
            }
            self.mDinhDanhKetNoi = DINH_DANH_LAY_THONG_TIN_GHE_NGOI_GALAXY;
            [GiaoDichMang layThongTinGheNgoiSauKhiChonGheGalaxy:sIdRap idPhim:itemFilmHienTai.idPhim idKhungGio:sIdGioChieu thongTinVe:thongTinVe noiNhanKetQua:self];
        }
    }
}

- (void)addRightButton{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 34, 34);
    [button setImage:[UIImage imageNamed:@"hdsd-icon"]forState:UIControlStateNormal];

    button.backgroundColor = [UIColor clearColor];
    button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [button addTarget:self action:@selector(suKienBamNutHuongDan:) forControlEvents:UIControlEventTouchUpInside];

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

- (IBAction)suKienBamNutHuongDan:(UIButton *)sender
{
    GiaoDienThongTinPhim *vc = [[GiaoDienThongTinPhim alloc] initWithNibName:@"GiaoDienThongTinPhim" bundle:nil];
    vc.nOption = HUONG_DAN_XEM_FILM;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)gestureRecognizer
{
    NSLog(@"%s - tap tap tap", __FUNCTION__);
    if (arrGheChon) {
        [arrGheChon removeAllObjects];
    }
    isNextPage = YES;
    GiaoDienDatChoXemPhim *vc = [[GiaoDienDatChoXemPhim alloc] initWithNibName:@"GiaoDienDatChoXemPhim" bundle:nil];
    vc.phongHienTai = phongHienTai;
    vc.isSau17h = isSau17h;
    vc.sTenFilm = itemFilmHienTai.tenPhim;
    vc.delegate = self;
    vc.sHeaderRap = self.edChonRap.text;
    NSLog(@"%s - vc.sHeaderRap : %@", __FUNCTION__, vc.sHeaderRap);
    if ([vc.sHeaderRap hasPrefix:@"CGV"] || [vc.sHeaderRap hasPrefix:@"BHD"] || [vc.sHeaderRap.lowercaseString containsString:@"galaxy"]) {
        vc.arrGheCGV = arrGiaTienCGV;
    }
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"%s - cap nhat =====> START", __FUNCTION__);
    if (isNextPage) {
        isNextPage = NO;
        return;
    }
    NSLog(@"%s - cap nhat =====> START 2", __FUNCTION__);
    webView.scrollView.scrollEnabled = NO;
    CGRect rectWeb = webView.frame;
    rectWeb.size.height = webView.scrollView.contentSize.height;
    webView.frame = rectWeb;
    [self capNhatGiaoDienThemWebviewKhiChonGioChieu];
//
//    [webView stringByEvaluatingJavaScriptFromString:@" for (var i = 0, videos = document.getElementsByTagName('video'); i < videos.length; i++) {"
//     @"      videos[i].addEventListener('webkitbeginfullscreen', function(){ "
//     @"           window.location = 'videohandler://begin-fullscreen';"
//     @"      }, false);"
//     @""
//     @"      videos[i].addEventListener('webkitendfullscreen', function(){ "
//     @"           window.location = 'videohandler://end-fullscreen';"
//     @"      }, false);"
//     @" }"
//     ];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // allows youtube player in landscape mode
    if ([request.URL.absoluteString isEqualToString:@"ytplayer://onStateChange?data=3"])
    {
        [self playerStarted];

        return NO;
    }
    if ([request.URL.absoluteString isEqualToString:@"ytplayer://onStateChange?data=2"])
    {
        [self playerEnded];

        return NO;
    }
    return NO;
}

- (void)playerStarted {
    NSLog(@"%s - play video", __FUNCTION__);
//    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationLandscapeLeft] forKey:@"orientation"];

    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).isVideoFullscreen = YES;

    [self supportedInterfaceOrientations];

    [self shouldAutorotate:UIInterfaceOrientationLandscapeLeft];

    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:NO];
}

- (void)playerEnded
{
//    [[UIDevice currentDevic] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).isVideoFullscreen = NO;
    [self supportedInterfaceOrientations];
    [self shouldAutorotate:UIInterfaceOrientationPortrait];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
//    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)sendLaiRapPhim:(ItemPhongXemFilm *)item gheChon:(NSMutableArray *)arrGhe{
    NSLog(@"%s - start !!!! : arrGhe.count : %d", __FUNCTION__, (int)arrGhe.count);
    phongHienTai = item;
    if (!arrGheChon) {
        arrGheChon = [[NSMutableArray alloc] init];
    }
    [arrGheChon removeAllObjects];
    [arrGheChon addObjectsFromArray:arrGhe];
    if (arrGheChon.count > 0) {
        if ([self.edChonRap.text hasPrefix:@"CGV"] || [self.edChonRap.text hasPrefix:@"BHD"] || [self.edChonRap.text.lowercaseString containsString:@"galaxy"]) {
            [self khoiTaoThongTinViewThanhToanCGV];
        }
        else if ([sIdRap isEqualToString:@"TTCPQG_NCC"]) {
            [self khoiTaoThongTinViewThanhToanQuocGia];
        }
        else {
            [self khoiTaoThongTinViewThanhToan];
        }
    }
    else {
        if (self.viewThongTinThanhToan != nil) {
            self.viewThongTinThanhToan.hidden = YES;
        }
        if (self.viewThongTinRapQuocGia != nil) {
            self.viewThongTinRapQuocGia.hidden = NO;
        }
    }
}

- (void)khoiTaoThongTinViewThanhToanCGV{
    self.mbtnVanTay.hidden = NO;
    CGRect rectQC = viewQC.frame;
    CGRect rectInfo = self.viewThongTinThanhToan.frame;
    CGRect rectWeb = self.webPhongChieu.frame;
    CGRect rectMain = self.mViewMain.frame;
    CGRect rectVanTay = self.mbtnVanTay.frame;
    rectInfo.origin.y = rectWeb.origin.y + rectWeb.size.height + 8;
    rectInfo.origin.x = 4;
    self.viewThongTinThanhToan.frame = rectInfo;

    if (![self.mViewMain.subviews containsObject:self.viewThongTinThanhToan]) {
        [self.mViewMain addSubview:self.viewThongTinThanhToan];
    }
    else{
        self.viewThongTinThanhToan.hidden = NO;
    }
    if (![self.mViewMain.subviews containsObject:self.viewThongTinRapQuocGia]) {
    }
    else{
        self.viewThongTinRapQuocGia.hidden = YES;
    }

    rectQC.origin.y = rectInfo.origin.y + rectInfo.size.height + 15;
    rectMain.size.height = rectQC.origin.y + 310.0f;
    viewQC.frame = rectQC;
    self.mViewMain.frame = rectMain;
    rectVanTay.origin.y = rectMain.origin.y + rectMain.size.height + 8;
    self.mbtnVanTay.frame = rectVanTay;
    [self.scrMain setContentSize:CGSizeMake(self.scrMain.frame.size.width, rectVanTay.size.height + rectVanTay.origin.y + 10)];
    NSString *htmlString = [self hienThiPhongChieu];
    [self.webPhongChieu loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];

    for (NSDictionary *dic in arrRapPhim) {
        NSString *sIdTemp = [dic valueForKey:@"idRap"];
        if ([sIdTemp isEqualToString:sIdRap]) {
            self.lblRap.text = [dic valueForKey:@"tenRap"];
            break;
        }
    }
    NSString *sTenFilm = [itemFilmHienTai.tenPhim stringByReplacingOccurrencesOfString:@"&#8805;" withString:@"≥"];
    self.lblPhim.text = sTenFilm;
    self.lblPhongChieu.text = phongHienTai.phong;
    ObjectGioChieu *item = [itemFilmHienTai.arrNgayChieu objectAtIndex:nIndexNgay];
    long weekday = [self getNgayChieuPhim:item];
    ObjectGioChieu *itemNgay = [itemFilmHienTai.arrNgayChieu objectAtIndex:nIndexNgay];

    switch (weekday) {
        case 1:
            self.lblGioChieu.text = [NSString stringWithFormat:@"%@ Chủ Nhật - %@", sGioChieu, itemNgay.ngayChieu];
            break;
        case 2:
            self.lblGioChieu.text = [NSString stringWithFormat:@"%@ Thứ 2 - %@", sGioChieu, itemNgay.ngayChieu];
            break;
        case 3:
            self.lblGioChieu.text = [NSString stringWithFormat:@"%@ Thứ 3 - %@", sGioChieu, itemNgay.ngayChieu];
            break;
        case 4:
            self.lblGioChieu.text = [NSString stringWithFormat:@"%@ Thứ 4 - %@", sGioChieu, itemNgay.ngayChieu];
            break;
        case 5:
            self.lblGioChieu.text = [NSString stringWithFormat:@"%@ Thứ 5 - %@", sGioChieu, itemNgay.ngayChieu];
            break;
        case 6:
            self.lblGioChieu.text = [NSString stringWithFormat:@"%@ Thứ 6 - %@", sGioChieu, itemNgay.ngayChieu];
            break;
        case 7:
            self.lblGioChieu.text = [NSString stringWithFormat:@"%@ Thứ 7 - %@", sGioChieu, itemNgay.ngayChieu];
            break;
        default:
            break;
    }


    if (arrGheChon) {
        NSString *sDanhSachGhe = @"";
        for (int i = 0; i < arrGheChon.count; i ++) {
            ItemGheXemFilm *item = [arrGheChon objectAtIndex:i];
            NSLog(@"%s - item.stt : %@", __FUNCTION__, item.stt);
            if (i == 0 && sDanhSachGhe.length == 0) {
                sDanhSachGhe = [sDanhSachGhe stringByAppendingString:item.stt];
            }
            else{
                sDanhSachGhe = [sDanhSachGhe stringByAppendingString:[NSString stringWithFormat:@", %@ ", item.stt]];
            }
        }
        self.lblSoGhe.text = [NSString stringWithFormat:@"%@", sDanhSachGhe];

    }
    if (arrGiaTienCGV) {
        NSLog(@"%s - arrGiaTienCGV.count : %d", __FUNCTION__, (int)arrGiaTienCGV.count);
        double nSoTien = 0.0;
        int nTongPhi = 0;
        for (ItemGiaVeCGV *dic in arrGiaTienCGV) {
//            nSoTien += dic.sl * dic.gia;
            if (dic.sl > 0) {
                nTongPhi += dic.sl * 1100;
            }
        }
        for (int i = 0; i < arrGheChon.count; i ++) {
            ItemGheXemFilm *item = [arrGheChon objectAtIndex:i];
            nSoTien += [item.gia doubleValue];
        }
        self.lblSoTien.text = [NSString stringWithFormat:@"%@ đ", [Common hienThiTienTe:nSoTien]];
        self.lblPhi.text = [NSString stringWithFormat:@"%@ đ", [Common hienThiTienTe:nTongPhi]];
    }
}

- (void)khoiTaoThongTinViewThanhToan{
    self.mbtnVanTay.hidden = NO;
    CGRect rectQC = viewQC.frame;
    CGRect rectInfo = self.viewThongTinThanhToan.frame;
    CGRect rectWeb = self.webPhongChieu.frame;
    CGRect rectMain = self.mViewMain.frame;
//    CGRect rectVanTay = self.mbtnVanTay.frame;
    rectInfo.origin.y = rectWeb.origin.y + rectWeb.size.height + 8;
    rectInfo.origin.x = 4;
    self.viewThongTinThanhToan.frame = rectInfo;

    if (![self.mViewMain.subviews containsObject:self.viewThongTinThanhToan]) {
        [self.mViewMain addSubview:self.viewThongTinThanhToan];
    }
    else{
        self.viewThongTinThanhToan.hidden = NO;
    }
    if (![self.mViewMain.subviews containsObject:self.viewThongTinRapQuocGia]) {

    }
    else{
        self.viewThongTinRapQuocGia.hidden = NO;
    }
//    rectMain.size.height = rectInfo.origin.y + rectInfo.size.height + 20;
    rectQC.origin.y = rectInfo.origin.y + rectInfo.size.height + 15;
    NSLog(@"%s - rectQC.size.height : %f", __FUNCTION__, rectQC.size.height);
    rectMain.size.height = rectQC.origin.y + 280.0f;
    viewQC.frame = rectQC;
    self.mViewMain.frame = rectMain;
    [self.scrMain setContentSize:CGSizeMake(self.scrMain.frame.size.width, rectMain.origin.y + rectMain.size.height + 10)];

    NSString *htmlString = [self hienThiPhongChieu];
    [self.webPhongChieu loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];

    for (NSDictionary *dic in arrRapPhim) {
        NSString *sIdTemp = [dic valueForKey:@"idRap"];
        if ([sIdTemp isEqualToString:sIdRap]) {
            self.lblRap.text = [dic valueForKey:@"tenRap"];
            break;
        }
    }
    NSString *sTenFilm = [itemFilmHienTai.tenPhim stringByReplacingOccurrencesOfString:@"&#8805;" withString:@"≥"];
    self.lblPhim.text = sTenFilm;
    self.lblPhongChieu.text = phongHienTai.phong;
    ObjectGioChieu *item = [itemFilmHienTai.arrNgayChieu objectAtIndex:nIndexNgay];
    long weekday = [self getNgayChieuPhim:item];
    ObjectGioChieu *itemNgay = [itemFilmHienTai.arrNgayChieu objectAtIndex:nIndexNgay];

    switch (weekday) {
        case 1:
            self.lblGioChieu.text = [NSString stringWithFormat:@"%@ Chủ Nhật - %@", sGioChieu, itemNgay.ngayChieu];
            break;
        case 2:
            self.lblGioChieu.text = [NSString stringWithFormat:@"%@ Thứ 2 - %@", sGioChieu, itemNgay.ngayChieu];
            break;
        case 3:
            self.lblGioChieu.text = [NSString stringWithFormat:@"%@ Thứ 3 - %@", sGioChieu, itemNgay.ngayChieu];
            break;
        case 4:
            self.lblGioChieu.text = [NSString stringWithFormat:@"%@ Thứ 4 - %@", sGioChieu, itemNgay.ngayChieu];
            break;
        case 5:
            self.lblGioChieu.text = [NSString stringWithFormat:@"%@ Thứ 5 - %@", sGioChieu, itemNgay.ngayChieu];
            break;
        case 6:
            self.lblGioChieu.text = [NSString stringWithFormat:@"%@ Thứ 6 - %@", sGioChieu, itemNgay.ngayChieu];
            break;
        case 7:
            self.lblGioChieu.text = [NSString stringWithFormat:@"%@ Thứ 7 - %@", sGioChieu, itemNgay.ngayChieu];
            break;
        default:
            break;
    }
    if (arrGheChon) {
        int nTongTien = 0;
        int nTongPhi = 0;
        NSString *soGhe = @"";
        for (int i = 0; i < arrGheChon.count; i++) {
            ItemGheXemFilm *item = [arrGheChon objectAtIndex:i];
            if (i != arrGheChon.count - 1) {
                soGhe = [soGhe stringByAppendingString:[NSString stringWithFormat:@"%@%@, ", item.sHangGhe, item.stt]];
            }
            else{
                soGhe = [soGhe stringByAppendingString:[NSString stringWithFormat:@"%@%@", item.sHangGhe, item.stt]];
            }
            int nSoTien = [item.gia intValue];
            nTongTien += nSoTien;
            nTongPhi += 1100;
        }
        self.lblSoGhe.text = soGhe;
        self.lblSoTien.text = [NSString stringWithFormat:@"%@ đ", [Common hienThiTienTe:nTongTien]];
        self.lblPhi.text = [NSString stringWithFormat:@"%@ đ", [Common hienThiTienTe:nTongPhi]];
    }
}

- (void)khoiTaoThongTinViewThanhToanQuocGia{
    self.mbtnVanTay.hidden = NO;
    CGRect rectQC = viewQC.frame;
    CGRect rectInfoUser = self.viewThongTinRapQuocGia.frame;
    CGRect rectInfo = self.viewThongTinThanhToan.frame;
    CGRect rectWeb = self.webPhongChieu.frame;
    CGRect rectMain = self.mViewMain.frame;
    //    CGRect rectVanTay = self.mbtnVanTay.frame;
    rectInfoUser.origin.y = rectWeb.origin.y + rectWeb.size.height + 8;
    rectInfoUser.origin.x = 4;
    rectInfo.origin.y = rectInfoUser.origin.y + rectInfoUser.size.height + 8;
    rectInfo.origin.x = 4;
    self.viewThongTinThanhToan.frame = rectInfo;
    self.viewThongTinRapQuocGia.frame = rectInfoUser;
    if (![self.mViewMain.subviews containsObject:self.viewThongTinThanhToan]) {
        [self.mViewMain addSubview:self.viewThongTinThanhToan];
    }
    else{
        self.viewThongTinThanhToan.hidden = NO;
    }
    if (![self.mViewMain.subviews containsObject:self.viewThongTinRapQuocGia]) {
        [self.mViewMain addSubview:self.viewThongTinRapQuocGia];
    }
    else{
        self.viewThongTinRapQuocGia.hidden = NO;
    }
    rectQC.origin.y = rectInfo.origin.y + rectInfo.size.height + 15;
    NSLog(@"%s - rectQC.size.height : %f", __FUNCTION__, rectQC.size.height);
    rectMain.size.height = rectQC.origin.y + 280.0f;
    viewQC.frame = rectQC;
    self.mViewMain.frame = rectMain;
    [self.scrMain setContentSize:CGSizeMake(self.scrMain.frame.size.width, rectMain.origin.y + rectMain.size.height + 10)];

    NSString *htmlString = [self hienThiPhongChieu];
    [self.webPhongChieu loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];

    for (NSDictionary *dic in arrRapPhim) {
        NSString *sIdTemp = [dic valueForKey:@"idRap"];
        if ([sIdTemp isEqualToString:sIdRap]) {
            self.lblRap.text = [dic valueForKey:@"tenRap"];
            break;
        }
    }
    NSString *sTenFilm = [itemFilmHienTai.tenPhim stringByReplacingOccurrencesOfString:@"&#8805;" withString:@"≥"];
    self.lblPhim.text = sTenFilm;
    self.lblPhongChieu.text = phongHienTai.phong;
    ObjectGioChieu *item = [itemFilmHienTai.arrNgayChieu objectAtIndex:nIndexNgay];
    long weekday = [self getNgayChieuPhim:item];
    ObjectGioChieu *itemNgay = [itemFilmHienTai.arrNgayChieu objectAtIndex:nIndexNgay];

    switch (weekday) {
        case 1:
            self.lblGioChieu.text = [NSString stringWithFormat:@"%@ Chủ Nhật - %@", sGioChieu, itemNgay.ngayChieu];
            break;
        case 2:
            self.lblGioChieu.text = [NSString stringWithFormat:@"%@ Thứ 2 - %@", sGioChieu, itemNgay.ngayChieu];
            break;
        case 3:
            self.lblGioChieu.text = [NSString stringWithFormat:@"%@ Thứ 3 - %@", sGioChieu, itemNgay.ngayChieu];
            break;
        case 4:
            self.lblGioChieu.text = [NSString stringWithFormat:@"%@ Thứ 4 - %@", sGioChieu, itemNgay.ngayChieu];
            break;
        case 5:
            self.lblGioChieu.text = [NSString stringWithFormat:@"%@ Thứ 5 - %@", sGioChieu, itemNgay.ngayChieu];
            break;
        case 6:
            self.lblGioChieu.text = [NSString stringWithFormat:@"%@ Thứ 6 - %@", sGioChieu, itemNgay.ngayChieu];
            break;
        case 7:
            self.lblGioChieu.text = [NSString stringWithFormat:@"%@ Thứ 7 - %@", sGioChieu, itemNgay.ngayChieu];
            break;
        default:
            break;
    }
    if (arrGheChon) {
        int nTongTien = 0;
        int nTongPhi = 0;
        NSString *soGhe = @"";
        for (int i = 0; i < arrGheChon.count; i++) {
            ItemGheXemFilm *item = [arrGheChon objectAtIndex:i];
            if (i != arrGheChon.count - 1) {
                soGhe = [soGhe stringByAppendingString:[NSString stringWithFormat:@"%@%@, ", item.sHangGhe, item.stt]];
            }
            else{
                soGhe = [soGhe stringByAppendingString:[NSString stringWithFormat:@"%@%@", item.sHangGhe, item.stt]];
            }
            int nSoTien = [item.gia intValue];
            nTongTien += nSoTien;
            nTongPhi += 1100;
        }
        self.lblSoGhe.text = soGhe;
        self.lblSoTien.text = [NSString stringWithFormat:@"%@ đ", [Common hienThiTienTe:nTongTien]];
        self.lblPhi.text = [NSString stringWithFormat:@"%@ đ", [Common hienThiTienTe:nTongPhi]];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (void)khoiTaoBanDau{
    self.edChonPhim.hidden = NO;
    self.viewInfo.hidden = YES;
    self.mbtnVanTay.hidden = YES;
    if ([self.mViewMain.subviews containsObject:self.viewThongTinThanhToan]) {
        self.viewThongTinThanhToan.hidden = YES;
    }
    if ([self.mViewMain.subviews containsObject:self.viewThongTinRapQuocGia]) {
        self.viewThongTinRapQuocGia.hidden = YES;
    }
    if (!self.edChonRap.rightView) {
        UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 12)];
        [btnRight setBackgroundImage:[UIImage imageNamed:@"muiten35x21.png"] forState:UIControlStateNormal];
        self.edChonRap.rightView = btnRight;
        self.edChonRap.rightViewMode = UITextFieldViewModeAlways;
    }

    if (!self.edChonPhim.rightView) {
        UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 12)];
        [btnRight setBackgroundImage:[UIImage imageNamed:@"muiten35x21.png"] forState:UIControlStateNormal];
        self.edChonPhim.rightView = btnRight;
        self.edChonPhim.rightViewMode = UITextFieldViewModeAlways;

        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
        toolBar.barStyle = UIBarStyleBlackOpaque;
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneChonPhim:)];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelChonPhim:)];
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

        [toolBar setItems:[NSArray arrayWithObjects:cancelButton, flexSpace, doneButton, nil]];
        UIPickerView *pickerChonRap = [[UIPickerView alloc] init];
        pickerChonRap.dataSource = self;
        pickerChonRap.delegate = self;
        pickerChonRap.tag = 101;
        self.edChonPhim.inputAccessoryView = toolBar;
        self.edChonPhim.inputView = pickerChonRap;
        [pickerChonRap release];
    }

    if (!self.edChonTinhThanh.rightView) {
        UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 12)];
        [btnRight setBackgroundImage:[UIImage imageNamed:@"muiten35x21.png"] forState:UIControlStateNormal];
        self.edChonTinhThanh.rightView = btnRight;
        self.edChonTinhThanh.rightViewMode = UITextFieldViewModeAlways;

        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
        toolBar.barStyle = UIBarStyleBlackOpaque;
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneChonTinhThanh:)];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelChonTinhThanh:)];
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

        [toolBar setItems:[NSArray arrayWithObjects:cancelButton, flexSpace, doneButton, nil]];
        UIPickerView *pickerChonRap = [[UIPickerView alloc] init];
        pickerChonRap.dataSource = self;
        pickerChonRap.delegate = self;
        pickerChonRap.tag = 102;
        self.edChonTinhThanh.inputAccessoryView = toolBar;
        self.edChonTinhThanh.inputView = pickerChonRap;
        [pickerChonRap release];
    }

    CGRect rectQC = viewQC.frame;
    CGRect rectMain = self.mViewMain.frame;
    CGRect rectRap = self.edChonPhim.frame;
    rectQC.origin.y = rectRap.origin.y + rectRap.size.height + 15;
    rectMain.size.height = rectQC.origin.y + rectQC.size.height / 2 + 20;
    viewQC.frame = rectQC;
    self.mViewMain.frame = rectMain;

    if (!arrRapHienTai) {
        arrRapHienTai = [[NSMutableArray alloc] init];
    }
    [arrRapHienTai removeAllObjects];

    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    [locationManager startUpdatingLocation];
    [locationManager requestWhenInUseAuthorization];
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    CLLocationCoordinate2D coordinate;
    coordinate.latitude=locationManager.location.coordinate.latitude;
    coordinate.longitude=locationManager.location.coordinate.longitude;
    MKPointAnnotation *marker = [MKPointAnnotation new];
    marker.coordinate = coordinate;
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude
                       ];
    CLGeocoder *ceo= [[CLGeocoder alloc]init];
    [ceo reverseGeocodeLocation:loc
              completionHandler:^(NSArray *placemarks, NSError *error) {
                  CLPlacemark *placemark = [placemarks objectAtIndex:0];
                  NSLog(@"thanh pho: %@",[placemark.addressDictionary valueForKey:@"State"] );
                  self.sTenThanhPhoCurrent = [placemark.addressDictionary valueForKey:@"State"];
                  [locationManager stopUpdatingLocation];
                  self.mDinhDanhKetNoi = DINH_DANH_LAY_DANH_SACH_TINH_THANH_PHIM;
                  if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
                      NSLog(@"%s ******** START", __FUNCTION__);
                      [self hienThiLoading];
                  }
                  [GiaoDichMang layDanhSachTinhThanhRapPhim:self];
              }
     
     ];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    self.sTenThanhPhoCurrent = @"";
    self.mDinhDanhKetNoi = DINH_DANH_LAY_DANH_SACH_TINH_THANH_PHIM;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self hienThiLoading];
    }
    [GiaoDichMang layDanhSachTinhThanhRapPhim:self];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {

}

- (void)doneChonPhim:(UIBarButtonItem *)sender
{
    [self.edChonPhim resignFirstResponder];
    [self.viewThongTinThanhToan setHidden:YES];
    [self xuLyChonPhim];
}

- (void)xuLyChonPhim {
    if (!arrDanhSachPhimHienTai || arrDanhSachPhimHienTai.count == 0 || arrDanhSachPhimHienTai.count <= nIndexPhim) {
        return;
    }
    itemFilmHienTai = [arrDanhSachPhimHienTai objectAtIndex:nIndexPhim];
    NSLog(@"%s - itemFilmHienTai.trailer : %@", __FUNCTION__, itemFilmHienTai.trailer);
    NSLog(@"%s - itemFilmHienTai.sIdRap : %@ - tenPhim : %@", __FUNCTION__, itemFilmHienTai.dsRap, itemFilmHienTai.tenPhim);
    NSString *sTenFilm = [itemFilmHienTai.tenPhim stringByReplacingOccurrencesOfString:@"&#8805;" withString:@"≥"];
    self.edChonPhim.text = sTenFilm;
    [self.edChonPhim resignFirstResponder];
    if ([self kiemTraPhimCoTaiRap]) {
        [self layDanhSachThoiDiemChieuPhim];
//        [self capNhatGiaoDienKhiChonPhim];
    }
    else{
        //        [self khoiTaoBanDau];
        sIdRap = @"-1";
        UIPickerView *picChonPhim = (UIPickerView *)self.edChonRap.inputView;
        [picChonPhim reloadAllComponents];
        [picChonPhim selectRow:0 inComponent:0 animated:YES];
        [self.edChonRap setText:@"Chọn rạp phim"];
    }
    //dong nay moi su theo y quan ly
    [self capNhatGiaoDienKhiChonPhim];
}

- (void)cancelChonPhim:(UIBarButtonItem *)sender
{
    [self.edChonPhim resignFirstResponder];
}

- (void)doneChonTinhThanh:(UIBarButtonItem *)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionGioChieu setHidden:YES];
        [self.collectionNgayChieu setHidden:YES];
        self.edChonTinhThanh.text = [arrTinhThanh objectAtIndex:nIndexTinhThanh];
        [self.edChonTinhThanh resignFirstResponder];
        if (nIndexTinhThanh != 0) {
            if (!arrRapHienTai) {
                arrRapHienTai = [[NSMutableArray alloc] init];
            }
            [arrRapHienTai removeAllObjects];
            self.mDinhDanhKetNoi = DINH_DANH_LAY_RAP_PHIM;
            NSString *sTinhThanh = [self xoaTiengVietTaiTinhThanhPho:[arrTinhThanh objectAtIndex:nIndexTinhThanh]];
            NSLog(@"%s - sTinhThanh : %@", __FUNCTION__, sTinhThanh);
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
                [self hienThiLoading];
            }
            [GiaoDichMang layDanhSachRapPhimTheoTinh:sTinhThanh noiNhanKetQua:self];
            nIndexPicker = 0;
            NSLog(@"%s - arrRapHienTai : %d", __FUNCTION__, (int)arrRapHienTai.count);
        }
        self.edChonRap.text = @"Chọn rạp phim";
        self.edChonPhim.text = @"Chọn phim";
        self.viewInfo.hidden = YES;
        self.webTrailer.hidden = YES;
        [self.webTrailer loadHTMLString:@"" baseURL:nil];
        CGRect rectQC = viewQC.frame;
        CGRect rectMain = self.mViewMain.frame;
        CGRect rectRap = self.edChonPhim.frame;
        rectQC.origin.y = rectRap.origin.y + rectRap.size.height + 15;
        rectMain.size.height = rectQC.origin.y + rectQC.size.height / 2 + 120;
        viewQC.frame = rectQC;
        self.mViewMain.frame = rectMain;
    });
}

- (void)cancelChonTinhThanh:(UIBarButtonItem *)sender
{
    [self.edChonTinhThanh resignFirstResponder];
}

- (void)doneChonRap:(UIBarButtonItem *)sender
{
    if (!arrRapPhim || arrRapPhim.count == 0) {
        [self.edChonRap resignFirstResponder];
        return;
    }
    [self.edChonRap resignFirstResponder];
    NSDictionary *dic = [arrRapHienTai objectAtIndex:nIndexPicker];
    self.edChonRap.text = [dic valueForKey:@"tenRap"];
    [self.edChonRap resignFirstResponder];
    sIdRap = [dic valueForKey:@"idRap"];
    NSLog(@"%s - sIdRap : %@", __FUNCTION__, sIdRap);
    if (!arrDanhSachPhimHienTai)
        arrDanhSachPhimHienTai = [[NSMutableArray alloc] init];
    [arrDanhSachPhimHienTai removeAllObjects];
    ObjectFilm *temp = [[ObjectFilm alloc] init];
    temp.tenPhim = @"Chọn phim";
    temp.idPhim = @"-1";
    [arrDanhSachPhimHienTai addObject:temp];
    if (itemFilmHienTai) {
        if ([itemFilmHienTai.dsRap containsString:sIdRap]) {
            if ([self.edChonRap.text hasPrefix:@"BHD"]) {

            }
            else {

            }
            [self layDanhSachThoiDiemChieuPhim];
            [self capNhatGiaoDienKhiChonPhim];
        }
        else {
            self.edChonPhim.text = @"Chọn phim";
            itemFilmHienTai = nil;
            [self.collectionNgayChieu reloadData];
            [self.collectionGioChieu reloadData];
            self.viewInfo.hidden = YES;
            self.webTrailer.hidden = YES;
            [self.webTrailer loadHTMLString:@"" baseURL:nil];
            CGRect rectQC = viewQC.frame;
            rectQC.origin.y = self.edChonPhim.frame.origin.y + self.edChonPhim.frame.size.height + 8;
            viewQC.frame = rectQC;
            CGRect rectMain = self.mViewMain.frame;
            rectMain.size.height = rectQC.origin.y + fHeightQc + 10;
            self.mViewMain.frame = rectMain;
            [self.scrMain setContentSize:CGSizeMake(rectMain.size.width, rectMain.size.height + self.viewOptionTop.frame.origin.y + self.viewOptionTop.frame.size.height + 10)];
        }
    }
}

- (void)cancelChonRap:(UIBarButtonItem *)sender
{
    [self.edChonRap resignFirstResponder];
}

- (void)capNhatGiaoDienDanhSachPhim{
    self.edChonPhim.hidden = NO;
    self.viewInfo.hidden = YES;
    self.webTrailer.hidden = YES;
    [self.webTrailer loadHTMLString:@"" baseURL:nil];
    CGRect rectQC = viewQC.frame;
    CGRect rectMain = self.mViewMain.frame;
    CGRect rectPhim = self.edChonPhim.frame;
    rectQC.origin.y = rectPhim.origin.y + rectPhim.size.height + 15;
    rectMain.size.height = rectQC.origin.y + fHeightQc;
    viewQC.frame = rectQC;
    self.mViewMain.frame = rectMain;
    [self.scrMain setContentSize:CGSizeMake(rectMain.size.width, rectMain.size.height + self.viewOptionTop.frame.origin.y + self.viewOptionTop.frame.size.height + 10)];
}

- (void)capNhatGiaoDienHienThiInfoPhim{
    self.collectionNgayChieu.hidden = YES;
    self.collectionGioChieu.hidden = YES;
    self.viewInfo.hidden = NO;
    CGRect rectQC = viewQC.frame;
    CGRect rectMain = self.mViewMain.frame;
    CGRect rectPhim = self.viewInfo.frame;
    rectQC.origin.y = rectPhim.origin.y + rectPhim.size.height + 15;
    rectMain.size.height = rectQC.origin.y + fHeightQc + 10;
    viewQC.frame = rectQC;
    self.mViewMain.frame = rectMain;
    [self.scrMain setContentSize:CGSizeMake(rectMain.size.width, rectMain.size.height + self.viewOptionTop.frame.origin.y + self.viewOptionTop.frame.size.height + 10)];
}

- (void)capNhatGiaoDienKhiChonPhim{
    self.webTrailer.hidden = NO;
    self.viewInfo.hidden = NO;
    self.collectionNgayChieu.hidden = NO;
    self.btnChonGhe.hidden = YES;
    if (!self.webPhongChieu.hidden) {
        self.webPhongChieu.hidden = YES;
    }
    CGRect rectTrailer = self.webTrailer.frame;
    CGRect rectInfo = self.viewInfo.frame;
    CGRect rectMain = self.mViewMain.frame;
    CGRect rectPhim = self.collectionNgayChieu.frame;
    CGRect rectGioChieu = self.collectionGioChieu.frame;
    CGRect rectQC = viewQC.frame;

    rectInfo.origin.y = rectTrailer.origin.y + rectTrailer.size.height + 8;
    self.viewInfo.frame = rectInfo;

    rectPhim.origin.y = rectInfo.origin.y + rectInfo.size.height + 8;
    self.collectionNgayChieu.frame = rectPhim;

    rectGioChieu.origin.y = rectPhim.origin.y + rectPhim.size.height + 8;
    self.collectionGioChieu.frame = rectGioChieu;

    rectQC.origin.y = rectPhim.origin.y + rectPhim.size.height + 15;
    rectMain.size.height = rectQC.origin.y+ rectQC.size.height + 20;
    viewQC.frame = rectQC;
    self.mViewMain.frame = rectMain;
    [self.scrMain setContentSize:CGSizeMake(rectMain.size.width, rectMain.size.height + self.viewOptionTop.frame.origin.y + self.viewOptionTop.frame.size.height + 10)];
    [self playTrailerLuon];
}

- (void)playTrailerLuon {
    self.webTrailer.backgroundColor = [UIColor clearColor];
    NSString *videoId = [self extractYoutubeIdFromLink:itemFilmHienTai.trailer];
    if (videoId) {
//        self.webTrailer.frame.size.height,
        NSString *html = [NSString stringWithFormat:youTubeVideoHTML, videoId];
        self.webTrailer.mediaPlaybackRequiresUserAction = NO;
        self.webTrailer.allowsInlineMediaPlayback = YES;
        [self.webTrailer loadHTMLString:html baseURL:[[NSBundle mainBundle] resourceURL]];
    }
}

- (NSString *)extractYoutubeIdFromLink:(NSString *)link {
    NSString *regexString = @"((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)";
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                            options:NSRegularExpressionCaseInsensitive
                                                                              error:nil];

    NSArray *array = [regExp matchesInString:link options:0 range:NSMakeRange(0,link.length)];
    if (array.count > 0) {
        NSTextCheckingResult *result = array.firstObject;
        return [link substringWithRange:result.range];
    }
    return nil;
}

- (void)capNhatDoCaoCollectionViewNgayChieu{
    self.collectionNgayChieu.hidden = NO;
    CGRect rectPhim = self.collectionNgayChieu.frame;
    CGRect rectTime = self.collectionGioChieu.frame;
    if (itemFilmHienTai.arrNgayChieu) {
        int dong = (int)itemFilmHienTai.arrNgayChieu.count / 3;
        int nSizeBanDau = 30;
        if (dong > 1) {
            nSizeBanDau = dong * nSizeBanDau + ((dong - 1) * 10);
        }
        rectPhim.size.height = nSizeBanDau;
        self.collectionNgayChieu.frame = rectPhim;

        rectTime.origin.y = rectPhim.origin.y + rectPhim.size.height + 3;
        self.collectionGioChieu.frame = rectTime;
    }
}

- (void)capNhatDoCaoCollectionViewGioChieu{
    self.collectionGioChieu.hidden = NO;
    CGRect rectMain = self.mViewMain.frame;
    CGRect rectPhim = self.collectionGioChieu.frame;
    if (itemFilmHienTai.arrNgayChieu && itemFilmHienTai.arrNgayChieu.count > nIndexNgay) {
        ObjectGioChieu *item = [itemFilmHienTai.arrNgayChieu objectAtIndex:nIndexNgay];
        int dong = (int)item.groupNgayChieu.count / 4;
        if ((int)item.groupNgayChieu.count % 4 != 0)
            dong += 1;
        NSLog(@"%s - dong : %d", __FUNCTION__, dong);
        int nSizeBanDau = 30;
        if (dong > 1) {
            nSizeBanDau = dong * nSizeBanDau + ((dong - 1) * 8);
        }
        rectPhim.size.height = nSizeBanDau;
    }

    CGRect rectQC = viewQC.frame;
    rectQC.origin.y = rectPhim.origin.y + rectPhim.size.height + 5;
    rectMain.size.height = rectQC.origin.y + fHeightQc + 10;
    self.collectionGioChieu.frame = rectPhim;
    viewQC.frame = rectQC;
    self.mViewMain.frame = rectMain;
    [self.scrMain setContentSize:CGSizeMake(rectMain.size.width, rectMain.size.height + self.viewOptionTop.frame.origin.y + self.viewOptionTop.frame.size.height + 20)];
}

- (void)capNhatGiaoDienThemWebviewKhiChonGioChieu{
    self.webPhongChieu.hidden = NO;
    CGRect rectMain = self.mViewMain.frame;
    CGRect rectWeb = self.webPhongChieu.frame;
    CGRect rectPhim = self.collectionGioChieu.frame;
    self.collectionGioChieu.frame = rectPhim;
    if ([self.edChonRap.text hasPrefix:@"CGV"] || [self.edChonRap.text hasPrefix:@"BHD"] || [self.edChonRap.text.lowercaseString containsString:@"galaxy"]) {
        _btnChonGhe.hidden = NO;
        CGRect rectBtnChon = self.btnChonGhe.frame;
        rectBtnChon.origin.y = rectPhim.origin.y + rectPhim.size.height;
        rectWeb.origin.y = rectBtnChon.origin.y + rectBtnChon.size.height + 5;
        self.btnChonGhe.frame = rectBtnChon;
    }
    else {
        _btnChonGhe.hidden = YES;
        rectWeb.origin.y = rectPhim.origin.y + rectPhim.size.height;
    }

    self.webPhongChieu.frame = rectWeb;
//    [self.webPhongChieu setBackgroundColor:[UIColor redColor]];
    CGRect rectQC = viewQC.frame;
    rectQC.origin.y = rectWeb.origin.y + rectWeb.size.height + 15;
    rectMain.size.height = rectQC.origin.y + fHeightQc + 10;
    viewQC.frame = rectQC;
    self.mViewMain.frame = rectMain;
    [self.scrMain setContentSize:CGSizeMake(rectMain.size.width, rectMain.size.height + self.viewOptionTop.frame.origin.y + self.viewOptionTop.frame.size.height + 10)];
}

- (void)layDanhSachPhimTheoId{
    if (sIdRap.length == 0) {
        [self khoiTaoBanDau];
        return;
    }
    self.mDinhDanhKetNoi = DINH_DANH_LAY_DANH_SACH_PHIM;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self hienThiLoading];
    }
    [GiaoDichMang layDanhSAchPhimCuaRap:sIdRap noiNhanKetQua:self];
}

- (void)layDanhSachThoiDiemChieuPhimBHD {
    if (itemFilmHienTai.idPhim.length == 0) {
        [self capNhatGiaoDienDanhSachPhim];
        return;
    }
    NSLog(@"%s - itemFilmHienTai.idPhim : %@", __FUNCTION__, itemFilmHienTai.idPhim);
    self.mDinhDanhKetNoi = DINH_DANH_LAY_THOI_DIEM_CHIEU_PHIM_BHD;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self hienThiLoading];
    }
    [GiaoDichMang layDanhSachGioChieuPhimCuaRap:sIdRap idPhim:itemFilmHienTai.idPhim noiNhanKetQua:self];
}

- (void)layDanhSachThoiDiemChieuPhim{
    if (itemFilmHienTai.idPhim.length == 0) {
        [self capNhatGiaoDienDanhSachPhim];
        return;
    }
    NSLog(@"%s - itemFilmHienTai.idPhim : %@", __FUNCTION__, itemFilmHienTai.idPhim);
    self.mDinhDanhKetNoi = DINH_DANH_LAY_THOI_DIEM_CHIEU_PHIM;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self hienThiLoading];
    }
    [GiaoDichMang layDanhSachGioChieuPhimCuaRap:sIdRap idPhim:itemFilmHienTai.idPhim noiNhanKetQua:self];
}

- (NSString *)xoaTiengVietTaiTinhThanhPho:(NSString *)sTinhThanh {
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"à" withString:@"a"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"á" withString:@"a"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ạ" withString:@"a"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ã" withString:@"a"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ả" withString:@"a"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ă" withString:@"a"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ắ" withString:@"a"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ằ" withString:@"a"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ẵ" withString:@"a"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ặ" withString:@"a"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"â" withString:@"a"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ầ" withString:@"a"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ấ" withString:@"a"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ậ" withString:@"a"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ẩ" withString:@"a"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ẫ" withString:@"a"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"đ" withString:@"d"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"Đ" withString:@"D"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ụ" withString:@"u"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ú" withString:@"u"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ù" withString:@"u"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ủ" withString:@"u"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ũ" withString:@"u"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ư" withString:@"u"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ử" withString:@"u"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ừ" withString:@"u"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ứ" withString:@"u"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ự" withString:@"u"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ữ" withString:@"u"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ê" withString:@"e"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ế" withString:@"e"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ể" withString:@"e"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ề" withString:@"e"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ệ" withString:@"e"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ể" withString:@"e"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ễ" withString:@"e"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ì" withString:@"i"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"í" withString:@"i"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ỉ" withString:@"i"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ị" withString:@"i"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ĩ" withString:@"i"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ô" withString:@"o"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ố" withString:@"o"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ồ" withString:@"o"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ổ" withString:@"o"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ộ" withString:@"o"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ỗ" withString:@"o"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ò" withString:@"o"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ó" withString:@"o"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ỏ" withString:@"o"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ọ" withString:@"o"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"õ" withString:@"o"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ơ" withString:@"o"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ở" withString:@"o"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ớ" withString:@"o"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ờ" withString:@"o"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ợ" withString:@"o"];
    sTinhThanh = [sTinhThanh stringByReplacingOccurrencesOfString:@"ỡ" withString:@"o"];
    return sTinhThanh;
}

#pragma mark - Xu Ly Ket Noi

- (void)xuLyKetNoiThanhCong:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua{
    NSLog(@"%s - sDinhDanhKetNoi : %@", __FUNCTION__, sDinhDanhKetNoi);
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self anLoading];
    }
    self.edChonRap.enabled = YES;
    if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_LAY_RAP_PHIM]) {
        NSArray *arrRapPhimTemp = [((NSDictionary *)ketQua) valueForKey:@"dsRapPhim"];
        arrRapPhim = [[NSMutableArray alloc] initWithArray:arrRapPhimTemp];
        NSDictionary *dicChon = @{@"tenRap":@"Chọn rạp phim", @"idRap":@"", @"urlRap":@""};
        [arrRapPhim insertObject:dicChon atIndex:0];

        if (!arrDanhSachPhim) {
            arrDanhSachPhim = [[NSMutableArray alloc] init];
        }
        [arrDanhSachPhim removeAllObjects];
        NSArray *arrTemp = [((NSDictionary *)ketQua) valueForKey:@"dsPhim"];
        NSMutableArray *arrPhimTemp = [[NSMutableArray alloc] init];
        for (NSDictionary *dicTemp  in arrTemp) {
            ObjectFilm *item = [[ObjectFilm alloc] initWithDictionary:dicTemp];
            [arrPhimTemp addObject:item];
        }
        NSArray *arrSorted = [arrPhimTemp sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            ObjectFilm *item1 = obj1;
            ObjectFilm *item2 = obj2;

            NSString *char1 = [self xoaTiengVietTaiTinhThanhPho:[[item1.tenPhim substringToIndex:1] lowercaseString]];
            NSString *char2 = [self xoaTiengVietTaiTinhThanhPho:[[item2.tenPhim substringToIndex:1] lowercaseString]];
            if ([char1.lowercaseString isEqualToString:char2.lowercaseString]) {
                char1 = [[[item1.tenPhim componentsSeparatedByString:@" "] firstObject] lowercaseString];
                char2 = [[[item2.tenPhim componentsSeparatedByString:@" "] firstObject] lowercaseString];
                char1 = [self xoaTiengVietTaiTinhThanhPho:char1];
                char2 = [self xoaTiengVietTaiTinhThanhPho:char2];
            }
            return [char1 caseInsensitiveCompare:char2];
        }];
        [arrDanhSachPhim addObjectsFromArray:arrSorted];

        if (!arrDanhSachPhimHienTai) {
            arrDanhSachPhimHienTai = [[NSMutableArray alloc] init];
        }
        [arrDanhSachPhimHienTai removeAllObjects];

        UIPickerView *picChonPhim = (UIPickerView *)self.edChonPhim.inputView;
        [picChonPhim reloadAllComponents];

        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
        toolBar.barStyle = UIBarStyleBlackOpaque;
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneChonRap:)];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelChonRap:)];
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

        [toolBar setItems:[NSArray arrayWithObjects:cancelButton, flexSpace, doneButton, nil]];

        UIPickerView *pickerChonRap = [[UIPickerView alloc] init];
        pickerChonRap.dataSource = self;
        pickerChonRap.delegate = self;
        pickerChonRap.tag = 100;
        self.edChonRap.inputAccessoryView = toolBar;
        self.edChonRap.inputView = pickerChonRap;
        [pickerChonRap release];

        if (!arrRapHienTai) {
            arrRapHienTai = [[NSMutableArray alloc] init];
        }
        [arrRapHienTai removeAllObjects];
        for (NSDictionary *temp in arrRapPhim) {
            [arrRapHienTai addObject:temp];
        }
        if (arrRapHienTai.count == 1) {
            nIndexPicker = 0;
            NSDictionary *dic = [arrRapHienTai objectAtIndex:nIndexPicker];
            self.edChonRap.text = [dic valueForKey:@"tenRap"];
            sIdRap = [dic valueForKey:@"idRap"];
            if (!arrDanhSachPhimHienTai)
                arrDanhSachPhimHienTai = [[NSMutableArray alloc] init];
            [arrDanhSachPhimHienTai removeAllObjects];
            ObjectFilm *temp = [[ObjectFilm alloc] init];
            temp.tenPhim = @"Chọn phim";
            temp.idPhim = @"-1";
            [arrDanhSachPhimHienTai addObject:temp];
        }
        if (self.sTenFilmTimKiem.length > 0) {
            NSLog(@"%s - sTenFilmTimKiem : %@", __FUNCTION__, self.sTenFilmTimKiem);
            [arrDanhSachPhimHienTai addObjectsFromArray:arrDanhSachPhim];
            for (int i = 0; i < arrDanhSachPhimHienTai.count; i ++) {
                ObjectFilm *item = [arrDanhSachPhimHienTai objectAtIndex:i];
                if ([item.tenPhim.lowercaseString containsString:self.sTenFilmTimKiem.lowercaseString]) {
                    nIndexPhim = i;
                    [self xuLyChonPhim];
                    break;
                }
            }
        }
    }
    else if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_LAY_DANH_SACH_TINH_THANH_PHIM]) {
        if (!arrTinhThanh) {
            arrTinhThanh = [[NSMutableArray alloc] init];
        }
        [arrTinhThanh removeAllObjects];
        [arrTinhThanh addObject:@"Chọn tỉnh thành phố"];
        NSArray *arrTemp = (NSArray *)ketQua;
        for (NSDictionary *dicTemp  in arrTemp) {
            NSString *sTinhThanh = [dicTemp objectForKey:@"tinhThanh"];
            [arrTinhThanh addObject:sTinhThanh];
        }
        if (arrTinhThanh.count > 0) {
            for (int i = 0; i < arrTinhThanh.count; i ++) {
                NSString *sTinhThanh = [arrTinhThanh objectAtIndex:i];
                if (self.sTenThanhPhoCurrent != nil && self.sTenThanhPhoCurrent.length > 0) {
                    if ([[self.sTenThanhPhoCurrent lowercaseString] containsString:[sTinhThanh lowercaseString]]) {
                        nIndexTinhThanh = i;
                        NSLog(@"%s ==========> nIndexTinhThanh : %d", __FUNCTION__, nIndexTinhThanh);
                        break;
                    }
                }
                else {
                    if ([[sTinhThanh lowercaseString] isEqualToString:@"hà nội"]) {
                        nIndexTinhThanh = i;
                        break;
                    }
                }
            }

            self.edChonTinhThanh.text = [arrTinhThanh objectAtIndex:nIndexTinhThanh];
            if (!arrRapPhim || arrRapPhim.count == 0) {
                self.mDinhDanhKetNoi = DINH_DANH_LAY_RAP_PHIM;
                NSString *sTinhThanh = [self xoaTiengVietTaiTinhThanhPho:[arrTinhThanh objectAtIndex:nIndexTinhThanh]];
                NSLog(@"%s - sTinhThanh : %@", __FUNCTION__, sTinhThanh);
                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
                    [self hienThiLoading];
                }
                [GiaoDichMang layDanhSachRapPhimTheoTinh:sTinhThanh noiNhanKetQua:self];
            }
        }
    }
    else if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_LAY_DANH_SACH_PHIM]){

        if (!arrDanhSachPhim) {
            arrDanhSachPhim = [[NSMutableArray alloc] init];
        }
        [arrDanhSachPhim removeAllObjects];
        NSArray *arrTemp = (NSArray *)ketQua;
        NSMutableArray *arrPhimTemp = [[NSMutableArray alloc] init];
        for (NSDictionary *dicTemp  in arrTemp) {
            ObjectFilm *item = [[ObjectFilm alloc] initWithDictionary:dicTemp];
            [arrPhimTemp addObject:item];
        }
        NSArray *arrSorted = [arrPhimTemp sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            ObjectFilm *item1 = obj1;
            ObjectFilm *item2 = obj2;

            NSString *char1 = [self xoaTiengVietTaiTinhThanhPho:[[item1.tenPhim substringToIndex:1] lowercaseString]];
            NSString *char2 = [self xoaTiengVietTaiTinhThanhPho:[[item2.tenPhim substringToIndex:1] lowercaseString]];
            if ([char1.lowercaseString isEqualToString:char2.lowercaseString]) {
                char1 = [[[item1.tenPhim componentsSeparatedByString:@" "] firstObject] lowercaseString];
                char2 = [[[item2.tenPhim componentsSeparatedByString:@" "] firstObject] lowercaseString];
                char1 = [self xoaTiengVietTaiTinhThanhPho:char1];
                char2 = [self xoaTiengVietTaiTinhThanhPho:char2];
            }
            return [char1 caseInsensitiveCompare:char2];
        }];
        [arrDanhSachPhim addObjectsFromArray:arrSorted];

        ObjectFilm *temp = [[ObjectFilm alloc] init];
        temp.tenPhim = @"Chọn phim";
        temp.idPhim = @"";
        [arrDanhSachPhim insertObject:temp atIndex:0];
        UIPickerView *picChonPhim = (UIPickerView *)self.edChonPhim.inputView;
        [picChonPhim reloadAllComponents];

        [self capNhatGiaoDienDanhSachPhim];
    }
    else if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_LAY_THOI_DIEM_CHIEU_PHIM]){
        if (itemFilmHienTai && ketQua) {
            if (!itemFilmHienTai.arrNgayChieu) {
                itemFilmHienTai.arrNgayChieu = [[NSMutableArray alloc] init];
            }
            [itemFilmHienTai.arrNgayChieu removeAllObjects];
            if (![ketQua isKindOfClass:[NSArray class]] || ((NSArray *)ketQua).count == 0) {
                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Không lấy được thông tin giờ chiếu. Vui lòng thử lại sau."];
                [self.collectionNgayChieu reloadData];
                [self.collectionGioChieu reloadData];
                return;
            }
            if ([ketQua isKindOfClass:[NSArray class]] && ((NSArray *)ketQua).count == 0) {
                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Không lấy được thông tin giờ chiếu. Vui lòng thử lại sau."];
                [self.collectionNgayChieu reloadData];
                [self.collectionGioChieu reloadData];
                return;
            }
            for (NSDictionary *temp in ketQua) {
                ObjectGioChieu *item = [[ObjectGioChieu alloc] khoiTaoObjectGioChieu:temp];
                [itemFilmHienTai.arrNgayChieu addObject:item];
            }
            if(itemFilmHienTai.arrNgayChieu.count > 0) {
                [self.collectionNgayChieu reloadData];
                [self.collectionGioChieu reloadData];
                [self capNhatDoCaoCollectionViewNgayChieu];
                [self capNhatDoCaoCollectionViewGioChieu];
            }
        }
        else {
//            [itemFilmHienTai.arrNgayChieu removeAllObjects];
            [self.collectionNgayChieu reloadData];
            [self.collectionGioChieu reloadData];
        }
    }
    else if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_LAY_THONG_TIN_GHE_NGOI_BHD]) {
        [RoundAlert hide];
        if (ketQua == nil) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Không lấy được thông tin phòng chiếu. Vui lòng thử lại sau"];
            return;
        }
        if (!phongHienTai) {
            phongHienTai = [[ItemPhongXemFilm alloc] init];
        }
        NSArray *arrTemp = (NSArray *)ketQua;
//        if (!arrGiaTienCGV) {
//            arrGiaTienCGV = [[NSMutableArray alloc] init];
//        }
//        [arrGiaTienCGV removeAllObjects];
//        for(NSDictionary *temp in arrTemp) {
//            ItemGiaVeCGV *itemGia = [[ItemGiaVeCGV alloc] initWithDictionary:temp];
//            NSLog(@"%s - tenVe : %@", __FUNCTION__, [temp objectForKey:@"tenVe"]);
//            NSLog(@"%s - itemGia : %@ - %@", __FUNCTION__, itemGia.idVe, itemGia.tenVe);
//            [arrGiaTienCGV addObject:itemGia];
//        }
//        [self suKienBamChonGhe:nil];
        NSDictionary *dictKQ = [arrTemp firstObject];
        if (dictKQ != nil) {
            [phongHienTai khoiTaoPhongXemFilm:dictKQ];
            NSString *htmlString = [self hienThiPhongChieu];
//            NSLog(@"%s - tao xong html %@", __FUNCTION__, htmlString);
            [self.webPhongChieu loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
            [self capNhatGiaoDienThemWebviewKhiChonGioChieu];
        }
    }
    else if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_LAY_THONG_TIN_GHE_NGOI_GALAXY]) {
        [RoundAlert hide];
        if (ketQua == nil) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Không lấy được thông tin phòng chiếu. Vui lòng thử lại sau"];
            return;
        }
        if (!phongHienTai) {
            phongHienTai = [[ItemPhongXemFilm alloc] init];
        }
        NSArray *arrTemp = (NSArray *)ketQua;

        NSDictionary *dictKQ = [arrTemp firstObject];
        if (dictKQ != nil) {
            [phongHienTai khoiTaoPhongXemFilm:dictKQ];
            NSString *htmlString = [self hienThiPhongChieu];
            //            NSLog(@"%s - tao xong html %@", __FUNCTION__, htmlString);
            [self.webPhongChieu loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
            [self capNhatGiaoDienThemWebviewKhiChonGioChieu];
        }
    }
    else if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_LAY_THONG_TIN_GHE_NGOI]){
        NSLog(@"%s - xu ly khi lay duoc ve", __FUNCTION__);
        if (ketQua == nil) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Không lấy được thông tin phòng chiếu. Vui lòng thử lại sau"];
            return;
        }
        if (!phongHienTai) {
            phongHienTai = [[ItemPhongXemFilm alloc] init];
        }
        if ([self.edChonRap.text hasPrefix:@"CGV"]) {
            NSDictionary *dic = (NSDictionary *)ketQua;
            NSArray *arrTemp = [dic objectForKey:@"giaVe"];
            if (!arrGiaTienCGV) {
                arrGiaTienCGV = [[NSMutableArray alloc] init];
            }
            [arrGiaTienCGV removeAllObjects];
            for(NSDictionary *temp in arrTemp) {
                ItemGiaVeCGV *itemGia = [[ItemGiaVeCGV alloc] initWithDictionary:temp];
                [arrGiaTienCGV addObject:itemGia];
            }
            [self suKienBamChonGhe:nil];
            [phongHienTai khoiTaoPhongXemFilm:ketQua];
            for (ItemHangXemFilm *hang in phongHienTai.arrDayGhe) {
                for (ItemGheXemFilm *ghe in hang.arrGhe) {
                    for(NSDictionary *temp in arrTemp) {
                        double gia = [[temp objectForKey:@"gia"] doubleValue];
                        NSString *tenVe = [temp objectForKey:@"tenVe"];
                        if ([tenVe.lowercaseString isEqualToString:ghe.type.lowercaseString]) {
                            ghe.gia = [NSString stringWithFormat:@"%f", gia];
                            break;
                        }
                    }
                }
            }
            NSString *htmlString = [self hienThiPhongChieu];
            [self.webPhongChieu loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
            [self capNhatGiaoDienThemWebviewKhiChonGioChieu];
        }
        else if ([sIdRap hasPrefix:@"TTCPQG_NCC"]) {
            phongHienTai.typeRap = 1;
            [phongHienTai khoiTaoPhongXemFilm:ketQua];
            NSString *htmlString = [self hienThiPhongChieu];
            NSLog(@"%s - Quoc Gia : %@", __FUNCTION__, htmlString);
            [self.webPhongChieu loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
            [self capNhatGiaoDienThemWebviewKhiChonGioChieu];
        }
        else if ([self.edChonRap.text hasPrefix:@"BHD"]) {
            NSArray *arrTemp = (NSArray *)ketQua;
            if (!arrGiaTienCGV) {
                arrGiaTienCGV = [[NSMutableArray alloc] init];
            }
            [arrGiaTienCGV removeAllObjects];
            for(NSDictionary *temp in arrTemp) {
                ItemGiaVeCGV *itemGia = [[ItemGiaVeCGV alloc] initWithDictionary:temp];
//                NSLog(@"%s - tenVe : %@", __FUNCTION__, [temp objectForKey:@"tenVe"]);
//                NSLog(@"%s - itemGia : %@ - %@", __FUNCTION__, itemGia.idVe, itemGia.tenVe);
                [arrGiaTienCGV addObject:itemGia];
            }
            [self suKienBamChonGhe:nil];
        }
        else if ([self.edChonRap.text.lowercaseString containsString:@"galaxy"]) {
            NSArray *arrTemp = (NSArray *)ketQua;
            if (!arrGiaTienCGV) {
                arrGiaTienCGV = [[NSMutableArray alloc] init];
            }
            [arrGiaTienCGV removeAllObjects];
            for(NSDictionary *temp in arrTemp) {
                ItemGiaVeCGV *itemGia = [[ItemGiaVeCGV alloc] initWithDictionary:temp];
                [arrGiaTienCGV addObject:itemGia];
            }
            [self suKienBamChonGhe:nil];
        }
        else {
            [phongHienTai khoiTaoPhongXemFilm:ketQua];
            NSString *sJsonName = [self taoTenJsonPhongChieu:phongHienTai.phong];
            NSLog(@"%s - ten phong chieu : %@", __FUNCTION__, sJsonName);
            [self mergeThongTinPhongChieu:sJsonName];
        }

    }
    else if ([sDinhDanhKetNoi isEqualToString:@"MUA_VE_XEM_FILM"]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
    }
}

- (void)xuLyKetNoiThatBai:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self anLoading];
    }
    if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_LAY_THONG_TIN_GHE_NGOI_BHD]) {
        [RoundAlert hide];
    }
    [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
}

#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 100) {
        return arrRapHienTai.count;
    }
    else if (pickerView.tag == 101) {
        [arrDanhSachPhimHienTai removeAllObjects];
//        NSMutableArray *arrFilm = [[NSMutableArray alloc] init];
        for (int i = 0; i < arrDanhSachPhim.count; i ++) {
            ObjectFilm *item = [arrDanhSachPhim objectAtIndex:i];
            if (![self.edTinhThanh.text isEqualToString:@"Chọn tỉnh thành phố"] && ![self.edChonRap.text isEqualToString:@"Chọn rạp phim"]) {
                NSArray *arrTemp = [item.dsRap componentsSeparatedByString:@","];
                for (NSString *sIdRapTemp in arrTemp) {
                    if ([sIdRapTemp isEqualToString:sIdRap]) {
                        [arrDanhSachPhimHienTai addObject:item];
//                        [arrFilm addObject:item];
                        break;
                    }
                }
            }
            else {
                [arrDanhSachPhimHienTai addObject:item];
//                [arrFilm addObject:item];
            }
        }
        return arrDanhSachPhimHienTai.count;
    }
    else if (pickerView.tag == 102) {
        return arrTinhThanh.count;
    }
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UIView * newView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textAlignment = NSTextAlignmentCenter;
    [newView addSubview:lbl];
    if (pickerView.tag == 100) {
        lbl.font=[UIFont systemFontOfSize:22.0f];
        NSDictionary *dic = [arrRapHienTai objectAtIndex:row];
        lbl.text = [dic valueForKey:@"tenRap"];
        NSString *sDanhSachPhim = [dic valueForKey:@"dsPhim"];
        if (itemFilmHienTai && [sDanhSachPhim containsString:itemFilmHienTai.idPhim]) {
            lbl.textColor = [UIColor blueColor];
        }
        else {
            lbl.textColor = [UIColor blackColor];
        }
    }
    else if (pickerView.tag == 101) {
        lbl.font=[UIFont systemFontOfSize:19.0f];
        ObjectFilm *item = [arrDanhSachPhimHienTai objectAtIndex:row];
        NSString *sTenFilm = item.tenPhim;
        if ([sTenFilm containsString:@"&#8805;"]) {
            sTenFilm = [sTenFilm stringByReplacingOccurrencesOfString:@"&#8805;" withString:@"≥"];
        }
        lbl.text = sTenFilm;
        NSArray *arrTemp = [item.dsRap componentsSeparatedByString:@","];
        BOOL bTimThay = NO;
        for (NSString *sIdRapTemp in arrTemp) {
            if ([sIdRapTemp isEqualToString:sIdRap]) {
                bTimThay = YES;
                break;
            }
        }
        if (bTimThay) {
            lbl.textColor = [UIColor blueColor];
        }
        else{
            lbl.textColor = [UIColor blackColor];
        }
    }
    else if (pickerView.tag == 102) {
        lbl.font=[UIFont systemFontOfSize:22.0f];
        NSString *sTenTinhThanh = [arrTinhThanh objectAtIndex:row];
        lbl.text = sTenTinhThanh;
    }
    return newView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    nIndexNgay = 0;
    sIdGioChieu = @"";
    if (pickerView.tag == 102) {
        nIndexTinhThanh = (int)row;
    }
    else if (pickerView.tag == 100) {
        nIndexPicker = (int)row;
    }
    else if (pickerView.tag == 101) {
        nIndexPhim = (int)row;
    }
}

- (BOOL)kiemTraPhimCoTaiRap{
    if (itemFilmHienTai) {
        if ([itemFilmHienTai.dsRap containsString:sIdRap]) {
            return YES;
        }
        else
            return NO;
    }
    return NO;
}
#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([collectionView isEqual:self.collectionNgayChieu]) {
        return itemFilmHienTai.arrNgayChieu.count;
    }
    else if ([collectionView isEqual:self.collectionGioChieu]){
        if (itemFilmHienTai.arrNgayChieu.count == 0) {
            return 0;
        }
        ObjectGioChieu *item = [itemFilmHienTai.arrNgayChieu objectAtIndex:nIndexNgay];
        return item.groupNgayChieu.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isEqual:self.collectionNgayChieu]) {
        static NSString *cellIdentifier = @"CellGroupNgayChieuPhim";
        CellGroupNgayChieuPhim *cell = (CellGroupNgayChieuPhim *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.layer.borderWidth = 1.0f;
        cell.layer.borderColor = [UIColor darkGrayColor].CGColor;
        cell.layer.cornerRadius = 4.0f;

        ObjectGioChieu *item = [itemFilmHienTai.arrNgayChieu objectAtIndex:indexPath.row];


        cell.lblTime.text = [self taoNgayChieu:item.ngayChieu];

        if (indexPath.row == nIndexNgay) {
            cell.backgroundColor =[UIColor colorWithHexString:@"#015079"];
            cell.lblTime.textColor = [UIColor whiteColor];
            sNgayChieu = item.ngayChieu;
        }
        else{
            cell.backgroundColor = [UIColor whiteColor];
            cell.lblTime.textColor = [UIColor blackColor];
        }

        return cell;
    }else{
        static NSString *cellIdentifier2 = @"CellGioChieuPhim";
        CellGioChieuPhim *cell = (CellGioChieuPhim *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier2 forIndexPath:indexPath];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier2 owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        ObjectGioChieu *item = [itemFilmHienTai.arrNgayChieu objectAtIndex:nIndexNgay];
        NSDictionary *dic = [item.groupNgayChieu objectAtIndex:indexPath.row];
        NSString *sTime = [dic objectForKey:@"khungGio"];
        cell.lblGio.text = sTime;
        if ([[dic objectForKey:@"idKhungGio"] isEqualToString:sIdGioChieu]) {
            cell.lblGio.textColor =[UIColor colorWithHexString:@"#015079"];
        }
        else{
            cell.lblGio.textColor =[UIColor blackColor];
        }
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isEqual:self.collectionNgayChieu]) {
        nIndexNgay = (int)indexPath.row;
        sIdGioChieu = @"";
        sGioChieu = @"";
        isSau17h = NO;

        [self.collectionGioChieu reloadData];
        [self.collectionNgayChieu reloadData];
        [self.webPhongChieu setHidden:YES];
        [self.btnChonGhe setHidden:YES];
        [self capNhatDoCaoCollectionViewGioChieu];
    }
    else{
        ObjectGioChieu *item = [itemFilmHienTai.arrNgayChieu objectAtIndex:nIndexNgay];
        NSDictionary *dic = [item.groupNgayChieu objectAtIndex:indexPath.row];
        sIdGioChieu = [dic objectForKey:@"idKhungGio"];
        [self.collectionGioChieu reloadData];
        self.mDinhDanhKetNoi = DINH_DANH_LAY_THONG_TIN_GHE_NGOI;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
            [self hienThiLoading];
        }
        if ([self.edChonRap.text.lowercaseString isEqualToString:@"trung tâm chiếu phim quốc gia"]) {
            [GiaoDichMang layThongTinGheNgoiQuocGia:sIdRap idPhim:itemFilmHienTai.idPhim idKhungGio:sIdGioChieu noiNhanKetQua:self];
        }
        else if ([self.edChonRap.text hasPrefix:@"BHD"]) {
            NSLog(@"%s - lay ve BHD", __FUNCTION__);
            [GiaoDichMang layThongTinGheNgoiQuocGiaBHD:sIdRap idPhim:itemFilmHienTai.idPhim idKhungGio:sIdGioChieu noiNhanKetQua:self];
        }
        else if ([self.edChonRap.text.lowercaseString containsString:@"galaxy"]) {
            [GiaoDichMang layThongTinGheNgoiGalaxy:sIdRap idPhim:itemFilmHienTai.idPhim idKhungGio:sIdGioChieu noiNhanKetQua:self];
        }
        else {
            [GiaoDichMang layThongTinGheNgoi:sIdRap idPhim:itemFilmHienTai.idPhim idKhungGio:sIdGioChieu noiNhanKetQua:self];
        }

        NSString *sTime = [dic objectForKey:@"khungGio"];
        sGioChieu = sTime;
        NSScanner* timeScanner=[NSScanner scannerWithString:sTime];
        int hours;
        [timeScanner scanInt:&hours];
        if (hours >= 17) {
            isSau17h = YES;
        }
        else{
            isSau17h = NO;
        }
    }
}
//163,22
//237,72

#pragma mark - Hien thi rap

- (NSString *)taoNgayChieu:(NSString *)sNgay{
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy"];
    NSDate *myDate = [df dateFromString:sNgay];
    NSDateComponents *dateComponents = [sysCalendar components:NSWeekdayCalendarUnit|NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:myDate];
    NSString *info = @"";
    switch ([dateComponents weekday]) {
        case 1:
            info = @"CN";
            break;
        case 2:
            info = @"T2";
            break;
        case 3:
            info = @"T3";
            break;
        case 4:
            info = @"T4";
            break;
        case 5:
            info = @"T5";
            break;
        case 6:
            info = @"T6";
            break;
        case 7:
            info = @"T7";
            break;
        default:
            break;
    }
    info = [NSString stringWithFormat:@"%@ %ld/%ld", info, (long)[dateComponents day], (long)[dateComponents month]];
    return info;
}

- (NSString *)taoTenJsonPhongChieu : (NSString *)sTenPhong{
    NSLog(@"%s - sIdRap : %@", __FUNCTION__, sIdRap);
    NSString *sJsonName = @"phong%@_";
    sJsonName = [NSString stringWithFormat:sJsonName, sTenPhong];
    if ([sIdRap isEqualToString:@"29"]) {
        sJsonName = [NSString stringWithFormat:@"%@%@", sJsonName, @"garden"];
    }
    else if ([sIdRap isEqualToString:@"30"]) {
        sJsonName = [NSString stringWithFormat:@"%@%@", sJsonName, @"longbien"];
    }
    else if ([sIdRap isEqualToString:@"31"]) {
        sJsonName = [NSString stringWithFormat:@"%@%@", sJsonName, @"nhatrang"];
    }
    else if ([sIdRap isEqualToString:@"32"]) {
        sJsonName = [NSString stringWithFormat:@"%@%@", sJsonName, @"royal"];
    }
    else if ([sIdRap isEqualToString:@"33"]) {
        sJsonName = [NSString stringWithFormat:@"%@%@", sJsonName, @"timecity"];
    }
    else if ([sIdRap hasPrefix:@"vn-0"] || [sIdRap hasPrefix:@"cgv_city"]){
        sJsonName = @"phong";
        NSString *sSoPhong = [[phongHienTai.phong stringByReplacingOccurrencesOfString:@"Cinema" withString:@""]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if([sIdRap isEqualToString:@"vn-04_nba_cgv-aeon-long-bien"] || [sIdRap isEqualToString:@"cgv_city_3_nba_cgv_site_027"])
        {
            sJsonName = [NSString stringWithFormat:@"%@%@%@", sJsonName, sSoPhong, @"_aeonLongBien"];
        }
        else if([sIdRap isEqualToString:@"vn-04_nba_cgv-ho-guom-plaza"] || [sIdRap isEqualToString:@"cgv_city_3_nba_cgv_site_018"])
        {
            sJsonName = [NSString stringWithFormat:@"%@%@%@", sJsonName, sSoPhong, @"_HoGuomPlaza"];
        }
        else if([sIdRap isEqualToString:@"vn-04_nba_iph-ha-noi"] || [sIdRap isEqualToString:@"cgv_city_3_nba_cgv_site_032"])
        {
            sJsonName = [NSString stringWithFormat:@"%@%@%@", sJsonName, sSoPhong, @"_IPHHaNoi"];
        }
        else if([sIdRap isEqualToString:@"vn-04_nba_cgv-mipec-tower"] || [sIdRap isEqualToString:@"cgv_city_3_nba_cgv_site_009"])
        {
            sJsonName = [NSString stringWithFormat:@"%@%@%@", sJsonName, sSoPhong, @"_MipecTower"];
        }
        else if([sIdRap isEqualToString:@"vn-04_nba_cgv-vincom-center-ba-trieu"] || [sIdRap isEqualToString:@"cgv_city_3_nba_cgv_site_001"])
        {
            sJsonName = [NSString stringWithFormat:@"%@%@%@", sJsonName, sSoPhong, @"_VincomBaTrieu"];
        }
        else if([sIdRap isEqualToString:@"vn-04_nba_cgv-vincom-nguyen-chi-thanh"] || [sIdRap isEqualToString:@"cgv_city_3_nba_cgv_site_028"])
        {
            sJsonName = [NSString stringWithFormat:@"%@%@%@", sJsonName, sSoPhong, @"_Nguyenchithanh"];
        }
        else if([sIdRap isEqualToString:@"vn-064_nba_cgv-lam-son-square"])
        {
            sJsonName = [NSString stringWithFormat:@"%@%@%@", sJsonName, sSoPhong, @"_CGVLamSonSquare"];
        }
        else if([sIdRap isEqualToString:@"vn-0650_nba_cgv-aeon-canary"])
        {
            sJsonName = [NSString stringWithFormat:@"%@%@%@", sJsonName, sSoPhong, @"_CGVAeonCanary"];
        }
        else if([sIdRap isEqualToString:@"vn-0650_nba_cgv-binh-duong-square"])
        {
            sJsonName = [NSString stringWithFormat:@"%@%@%@", sJsonName, sSoPhong, @"_CGVBinhDuongSquare"];
        }
        else if([sIdRap isEqualToString:@"vn-056_nba_cgv-kim-cuc-plaza"])
        {
            sJsonName = [NSString stringWithFormat:@"%@%@%@", sJsonName, sSoPhong, @"_CGVKimCucPlaza"];
        }
        else if([sIdRap isEqualToString:@"vn-0710_nba_cgv-sense-city"])
        {
            sJsonName = [NSString stringWithFormat:@"%@%@%@", sJsonName, sSoPhong, @"_CGVSenseCity"];
        }
        else if([sIdRap isEqualToString:@"vn-08_nba_cgv-go-vap"])
        {
            sJsonName = [NSString stringWithFormat:@"%@%@%@", sJsonName, sSoPhong, @"_GoVap"];
        }
        else if([sIdRap isEqualToString:@"vn-08_nba_cgv-hung-vuong-plaza"])
        {
            sJsonName = [NSString stringWithFormat:@"%@%@%@", sJsonName, sSoPhong, @"_HungVuongPlaza"];
        }
        else if([sIdRap isEqualToString:@"vn-031_nba_cgv-thuy-duong-plaza"])
        {
            sJsonName = [NSString stringWithFormat:@"%@%@%@", sJsonName, sSoPhong, @"_CGVThuyDuongPlaza"];
        }
        else if([sIdRap isEqualToString:@"vn-033_nba_cgv-marine-plaza"])
        {
            sJsonName = [NSString stringWithFormat:@"%@%@%@", sJsonName, sSoPhong, @"_CGVMarinePlaza"];
        }
        else if([sIdRap isEqualToString:@"vn-033_nba_cgv-vincom-ha-long"])
        {
            sJsonName = [NSString stringWithFormat:@"%@%@%@", sJsonName, sSoPhong, @"_CGVVincomHaLong"];
        }
        else if([sIdRap isEqualToString:@"vn-08_nba_cgv-celadon-tan-phu"])
        {
            sJsonName = [NSString stringWithFormat:@"%@%@%@", sJsonName, sSoPhong, @"_CeladonTanPhu"];
        }
        else if([sIdRap isEqualToString:@"vn-08_nba_cgv-crescent-mall"])
        {
            sJsonName = [NSString stringWithFormat:@"%@%@%@", sJsonName, sSoPhong, @"_CrescentMall"];
        }
        else if([sIdRap isEqualToString:@"vn-08_nba_cgv-ct-plaza"])
        {
            sJsonName = [NSString stringWithFormat:@"%@%@%@", sJsonName, sSoPhong, @"_CTPlaza"];
        }
        else if([sIdRap isEqualToString:@"vn-08_nba_cgv-liberty-citypoint"])
        {
            sJsonName = [NSString stringWithFormat:@"%@%@%@", sJsonName, sSoPhong, @"_LibertyCitypoint"];
        }
        else if([sIdRap isEqualToString:@"vn-08_nba_cgv-pandora-city"])
        {
            sJsonName = [NSString stringWithFormat:@"%@%@%@", sJsonName, sSoPhong, @"_PandoraCity"];
        }
        else if([sIdRap isEqualToString:@"vn-08_nba_cgv-parkson-paragon"])
        {
            sJsonName = [NSString stringWithFormat:@"%@%@%@", sJsonName, sSoPhong, @"_PaksonParagon"];
        }
        else if([sIdRap isEqualToString:@"vn-08_nba_cgv-pearl-plaza"])
        {
            sJsonName = [NSString stringWithFormat:@"%@%@%@", sJsonName, sSoPhong, @"_PearlPlaza"];
        }
        else if([sIdRap isEqualToString:@"vn-08_nba_cgv-sc-vivocity"])
        {
            sJsonName = [NSString stringWithFormat:@"%@%@%@", sJsonName, sSoPhong, @"_SCVivoCity"];
        }
        else if([sIdRap isEqualToString:@"vn-08_nba_cgv-thao-dien-pearl"])
        {
            sJsonName = [NSString stringWithFormat:@"%@%@%@", sJsonName, sSoPhong, @"_ThaoDienPearl"];
        }
        else if([sIdRap isEqualToString:@"vn-08_nba_cgv-thu-duc"])
        {
            sJsonName = [NSString stringWithFormat:@"%@%@%@", sJsonName, sSoPhong, @"_ThuDuc"];
        }
        else if([sIdRap isEqualToString:@"vn-0511_nba_cgv-vincom-da-nang"])
        {
            sJsonName = [NSString stringWithFormat:@"%@%@%@", sJsonName, sSoPhong, @"_CGVVincomDanang"];
        }
        else if([sIdRap isEqualToString:@"vn-0511_nba_cgv-vinh-trung-plaza"])
        {
            sJsonName = [NSString stringWithFormat:@"%@%@%@", sJsonName, sSoPhong, @"_CGVVinhTrungPlaza"];
        }
        else if([sIdRap isEqualToString:@"vn-0500_nba_cgv-ban-me-thuot"])
        {
            sJsonName = [NSString stringWithFormat:@"%@%@%@", sJsonName, sSoPhong, @"_CGVBuonMaThuat"];
        }
        else if([sIdRap isEqualToString:@"vn-061_nba_cgv-bien-hoa"])
        {
            sJsonName = [NSString stringWithFormat:@"%@%@%@", sJsonName, sSoPhong, @"_CGVBienHoa"];
        }
        else if([sIdRap isEqualToString:@"vn-061_nba_cgv-dong-nai"])
        {
            sJsonName = [NSString stringWithFormat:@"%@%@%@", sJsonName, sSoPhong, @"_CGVBigCDongNai"];
        }
        else if([sIdRap isEqualToString:@"vn-0710_nba_cgv-vincom-hung-vuong"])
        {
            sJsonName = [NSString stringWithFormat:@"%@%@%@", sJsonName, sSoPhong, @"_CGVVincomHungVuong"];
        }
    }
    else if ([sIdRap hasPrefix:@"TTCPQG_NCC"]) {
        sJsonName = @"phong";
        NSLog(@"%s - sTenPhong : %@", __FUNCTION__, sTenPhong);
        if ([sTenPhong hasSuffix:@"1"]) {
            sJsonName = @"phong1_RapchieuphimQG";
        }
        else if ([sTenPhong hasSuffix:@"2"]) {
            sJsonName = @"phong2_RapchieuphimQG";
        }
        else if ([sTenPhong hasSuffix:@"3"]) {
            sJsonName = @"phong3_RapchieuphimQG";
        }
        else if ([sTenPhong hasSuffix:@"4"]) {
            sJsonName = @"phong4_RapchieuphimQG";
        }
        else if ([sTenPhong hasSuffix:@"4D"]) {
            sJsonName = @"phong4D_RapchieuphimQG";
        }
        else if ([sTenPhong hasSuffix:@"5"]) {
            sJsonName = @"phong5_RapchieuphimQG";
        }
        else if ([sTenPhong hasSuffix:@"6"]) {
            sJsonName = @"phong6_RapchieuphimQG";
        }
        else if ([sTenPhong hasSuffix:@"7"]) {
            sJsonName = @"phong7_RapchieuphimQG";
        }
        else if ([sTenPhong hasSuffix:@"8"]) {
            sJsonName = @"phong8_RapchieuphimQG";
        }
        else if ([sTenPhong hasSuffix:@"9"]) {
            sJsonName = @"phong9_RapchieuphimQG";
        }
        else if ([sTenPhong hasSuffix:@"10"]) {
            sJsonName = @"phong10_RapchieuphimQG";
        }
        else if ([sTenPhong hasSuffix:@"11"]) {
            sJsonName = @"phong11_RapchieuphimQG";
        }
        else if ([sTenPhong hasSuffix:@"12"]) {
            sJsonName = @"phong12_RapchieuphimQG";
        }
    }
    return sJsonName;
}

- (void)mergeThongTinPhongChieu:(NSString *)sJsonName{
    if (phongHienTai) {
        NSString *path = [[NSBundle mainBundle] pathForResource:sJsonName ofType:@"txt"];
        NSLog(@"%s - path : %@", __FUNCTION__, path);
        NSError *error;
        NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
        NSLog(@"%s - sJsonName : %@", __FUNCTION__, sJsonName);
        NSData *jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
        NSError *errJson;
        if (!jsonData) {
            NSLog(@"%s - jsondata is nil", __FUNCTION__);
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Không lấy được thông tin phòng chiếu. Vui lòng thử lại sau"];
            return;
        }

        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:nil error:&errJson];
        NSDictionary *dicKQ = [dic objectForKey:@"result"];
        NSArray *arrTemp = [dicKQ objectForKey:@"day"];
        if (arrTemp) {
            for (int i = 0; i < arrTemp.count; i++) {
                NSDictionary *item = [arrTemp objectAtIndex:i];
                for (ItemHangXemFilm *hangGhe in phongHienTai.arrDayGhe) {
                    NSString *tenDay = [item objectForKey:@"stt"];
                    NSString *tenDayHangGhe = [hangGhe.stt stringByReplacingOccurrencesOfString:@"[A-Z]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [hangGhe.stt length])];
                    if ([sJsonName.lowercaseString hasSuffix:@"rapchieuphimqg"] || [self.edChonRap.text.lowercaseString containsString:@"platinum"] || [sJsonName.lowercaseString hasSuffix:@"RapchieuphimQG"]) {
                        if ([sJsonName.lowercaseString hasSuffix:@"rapchieuphimqg"]) {
                            tenDay = [item objectForKey:@"stt_day"];
                            tenDayHangGhe = hangGhe.stt;
                        }
                        else if ([self.edChonRap.text.lowercaseString containsString:@"platinum"]) {
                            tenDayHangGhe = hangGhe.stt;
                        }
                        NSLog(@"%s - [hangGhe.stt : %@ - tenDayHangGhe : %@", __FUNCTION__, hangGhe.stt, tenDayHangGhe);
                        if ([tenDay isEqualToString:tenDayHangGhe]) {
                            NSArray *arrGhe = [item objectForKey:@"ghe"];
                            for (int j = 0; j < arrGhe.count; j ++) {
                                NSDictionary *ghe = [arrGhe objectAtIndex:j];
                                NSString *tenGhe = [ghe objectForKey:@"stt"];
                                for (ItemGheXemFilm *itemGhe in hangGhe.arrGhe) {
                                    if ([tenGhe intValue] == [itemGhe.stt intValue])
                                    {
                                        NSString *giaTien = [ghe objectForKey:@"gia"];
                                        NSLog(@"%s - tenDay : %@ - hangGhe.stt : %@ - giaTien : %@", __FUNCTION__, tenDay, hangGhe.stt, giaTien);
                                        NSString *sVip = [ghe objectForKey:@"vip"];
                                        NSString *sHien = [ghe objectForKey:@"hien"];
                                        if ([sHien isEqualToString:@"1"]) {
                                            itemGhe.vip = sVip;
                                            itemGhe.hienThi = sHien;
                                            if (![self.edChonRap.text hasPrefix:@"CGV"]) {
                                                if ([sIdRap isEqualToString:@"TTCPQG_NCC"]) {

                                                }
                                                else
                                                    [self capNhatGiaTien:itemGhe];
                                            }
                                            else if ([self.edChonRap.text hasPrefix:@"CGV"]) {
                                                itemGhe.gia = giaTien;
                                            }
                                            break;
                                        }
                                    }
                                }
                            }
                            break;
                        }
                    }
                    else if ([self.edChonRap.text.lowercaseString containsString:@"CGV"]){

                    }
                }
            }
        }
        NSString *htmlString = [self hienThiPhongChieu];
//        NSLog(@"%s - tao xong html %@", __FUNCTION__, htmlString);
        [self.webPhongChieu loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
        [self capNhatGiaoDienThemWebviewKhiChonGioChieu];
    }
    else{
        NSLog(@"%s - phongHienTai == nill", __FUNCTION__);
    }
}

- (long)getNgayChieuPhim:(ObjectGioChieu *)item{
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy"];
    NSDate *myDate = [df dateFromString:item.ngayChieu];
    NSDateComponents *dateComponents = [sysCalendar components:NSWeekdayCalendarUnit|NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:myDate];
    long weekday = [dateComponents weekday];
    return weekday;
}

- (void)capNhatGiaTienCGV:(ItemGheXemFilm *)itemGhe{
    
}

- (void)capNhatGiaTien:(ItemGheXemFilm *)itemGhe{
//    NSLog(@"%s - itemFilmHienTai.tenPhim : %@", __FUNCTION__, itemFilmHienTai.tenPhim);
    BOOL is3D = NO;
    if ([itemFilmHienTai.tenPhim hasPrefix:@"3D"]) {
        is3D = YES;
    }
    ObjectGioChieu *item = [itemFilmHienTai.arrNgayChieu objectAtIndex:nIndexNgay];
    long weekday = [self getNgayChieuPhim:item];
    BOOL isWeekend = YES;
    if (weekday != 1 && weekday != 6 && weekday != 7) {
        isWeekend = NO;
    }
    if ([sIdRap isEqualToString:@"29"]) {
        //                                        garden
        if ([itemGhe.vip isEqualToString:@"0"]){
            if (isWeekend) {
                //ghe thuong vao ngay cuoi tuan va ngay le
                if (is3D) {
                    if (isSau17h) {
                        itemGhe.gia = @"150000";
                    }
                    else
                        itemGhe.gia = @"110000";
                }
                else{
                    if (isSau17h) {
                        itemGhe.gia = @"80000";
                    }
                    else
                        itemGhe.gia = @"70000";
                }
            }
            else{
                if (is3D) {
                    if (isSau17h) {
                        itemGhe.gia = @"120000";
                    }
                    else
                        itemGhe.gia = @"90000";
                }
                else{
                    if (isSau17h) {
                        itemGhe.gia = @"70000";
                    }
                    else
                        itemGhe.gia = @"60000";
                }
            }
        }
        else{
            if (isWeekend) {
                //ghe vip vao ngay cuoi tuan va ngay le
                if (is3D) {
                    if (isSau17h) {
                        itemGhe.gia = @"160000";
                    }
                    else
                        itemGhe.gia = @"120000";
                }
                else{
                    if (isSau17h) {
                        itemGhe.gia = @"85000";
                    }
                    else
                        itemGhe.gia = @"75000";
                }
            }
            else{
                if (is3D) {
                    if (isSau17h) {
                        itemGhe.gia = @"130000";
                    }
                    else
                        itemGhe.gia = @"100000";
                }
                else{
                    if (isSau17h) {
                        itemGhe.gia = @"75000";
                    }
                    else
                        itemGhe.gia = @"65000";
                }
            }
        }

    }
    else if ([sIdRap isEqualToString:@"30"]) {
        // longbien
        if ([itemGhe.vip isEqualToString:@"0"]){
            if (isWeekend) {
                //ghe thuong vao ngay cuoi tuan va ngay le
                if (is3D) {
                    if (isSau17h) {
                        itemGhe.gia = @"140000";
                    }
                    else
                        itemGhe.gia = @"100000";
                }
                else{
                    if (isSau17h) {
                        itemGhe.gia = @"75000";
                    }
                    else
                        itemGhe.gia = @"65000";
                }
            }
            else{
                if (is3D) {
                    if (isSau17h) {
                        itemGhe.gia = @"110000";
                    }
                    else
                        itemGhe.gia = @"80000";
                }
                else{
                    if (isSau17h) {
                        itemGhe.gia = @"65000";
                    }
                    else
                        itemGhe.gia = @"55000";
                }
            }
        }
        else{
            if (isWeekend) {
                //ghe vip vao ngay cuoi tuan va ngay le
                if (is3D) {
                    if (isSau17h) {
                        itemGhe.gia = @"150000";
                    }
                    else
                        itemGhe.gia = @"110000";
                }
                else{
                    if (isSau17h) {
                        itemGhe.gia = @"80000";
                    }
                    else
                        itemGhe.gia = @"70000";
                }
            }
            else{
                if (is3D) {
                    if (isSau17h) {
                        itemGhe.gia = @"120000";
                    }
                    else
                        itemGhe.gia = @"90000";
                }
                else{
                    if (isSau17h) {
                        itemGhe.gia = @"70000";
                    }
                    else
                        itemGhe.gia = @"60000";
                }
            }
        }
    }
    else if ([sIdRap isEqualToString:@"31"]) {
        //                                        nhatrang
        if ([itemGhe.vip isEqualToString:@"0"]){
            if (isWeekend) {
                //ghe thuong vao ngay cuoi tuan va ngay le
                if (is3D) {
                    if (isSau17h) {
                        itemGhe.gia = @"110000";
                    }
                    else
                        itemGhe.gia = @"80000";
                }
                else{
                    if (isSau17h) {
                        itemGhe.gia = @"65000";
                    }
                    else
                        itemGhe.gia = @"60000";
                }
            }
            else{
                if (is3D) {
                    if (isSau17h) {
                        itemGhe.gia = @"90000";
                    }
                    else
                        itemGhe.gia = @"60000";
                }
                else{
                    if (isSau17h) {
                        itemGhe.gia = @"55000";
                    }
                    else
                        itemGhe.gia = @"50000";
                }
            }
        }
        else{
            if (isWeekend) {
                //ghe vip vao ngay cuoi tuan va ngay le
                if (is3D) {
                    if (isSau17h) {
                        itemGhe.gia = @"120000";
                    }
                    else
                        itemGhe.gia = @"90000";
                }
                else{
                    if (isSau17h) {
                        itemGhe.gia = @"70000";
                    }
                    else
                        itemGhe.gia = @"60000";
                }
            }
            else{
                if (is3D) {
                    if (isSau17h) {
                        itemGhe.gia = @"100000";
                    }
                    else
                        itemGhe.gia = @"70000";
                }
                else{
                    if (isSau17h) {
                        itemGhe.gia = @"60000";
                    }
                    else
                        itemGhe.gia = @"50000";
                }
            }
        }
    }
    else if ([sIdRap isEqualToString:@"32"]) {
        //                                        royal
        if([itemFilmHienTai.tenPhim containsString:@"D Lounge"])
        {
            if (isWeekend) {
                //ghe Lounge vao ngay cuoi tuan va ngay le
                if (is3D) {
                    if (isSau17h) {
                        itemGhe.gia = @"300000";
                    }
                    else
                        itemGhe.gia = @"250000";
                }
                else{
                    if (isSau17h) {
                        itemGhe.gia = @"220000";
                    }
                    else
                        itemGhe.gia = @"180000";
                }
            }
            else{
                if (!is3D) {
                    if (isSau17h) {
                        itemGhe.gia = @"180000";
                    }
                    else
                        itemGhe.gia = @"150000";
                }
                else{
                    if (isSau17h) {
                        itemGhe.gia = @"250000";
                    }
                    else
                        itemGhe.gia = @"200000";
                }
            }
        }
        else{
            if ([itemGhe.vip isEqualToString:@"0"]){
                if (isWeekend) {
                    //ghe thuong vao ngay cuoi tuan va ngay le
                    if (is3D) {
                        if (isSau17h) {
                            itemGhe.gia = @"190000";
                        }
                        else
                            itemGhe.gia = @"170000";
                    }
                    else{
                        if (isSau17h) {
                            itemGhe.gia = @"90000";
                        }
                        else
                            itemGhe.gia = @"80000";
                    }
                }
                else{
                    if (is3D) {
                        if (isSau17h) {
                            itemGhe.gia = @"150000";
                        }
                        else
                            itemGhe.gia = @"130000";
                    }
                    else{
                        if (isSau17h) {
                            itemGhe.gia = @"80000";
                        }
                        else
                            itemGhe.gia = @"70000";
                    }
                }
            }
            else if([itemGhe.vip isEqualToString:@"1"]){
                if (isWeekend) {
                    //ghe vip vao ngay cuoi tuan va ngay le
                    if (is3D) {
                        if (isSau17h) {
                            itemGhe.gia = @"200000";
                        }
                        else
                            itemGhe.gia = @"180000";
                    }
                    else{
                        if (isSau17h) {
                            itemGhe.gia = @"95000";
                        }
                        else
                            itemGhe.gia = @"85000";
                    }
                }
                else{
                    if (is3D) {
                        if (isSau17h) {
                            itemGhe.gia = @"160000";
                        }
                        else
                            itemGhe.gia = @"140000";
                    }
                    else{
                        if (isSau17h) {
                            itemGhe.gia = @"85000";
                        }
                        else
                            itemGhe.gia = @"75000";
                    }
                }
            }
            else{
                if (isWeekend) {
                    //ghe doi vao ngay cuoi tuan va ngay le
                    if (is3D) {
                        if (isSau17h) {
                            itemGhe.gia = @"410000";
                        }
                        else
                            itemGhe.gia = @"370000";
                    }
                    else{
                        if (isSau17h) {
                            itemGhe.gia = @"200000";
                        }
                        else
                            itemGhe.gia = @"180000";
                    }
                }
                else{
                    if (is3D) {
                        if (isSau17h) {
                            itemGhe.gia = @"160000";
                        }
                        else
                            itemGhe.gia = @"140000";
                    }
                    else{
                        if (isSau17h) {
                            itemGhe.gia = @"180000";
                        }
                        else
                            itemGhe.gia = @"160000";
                    }
                }
            }
        }
    }
    else if ([sIdRap isEqualToString:@"33"]) {
        // timecity
        if([itemFilmHienTai.tenPhim containsString:@"D Lounge"])
        {
            if (isWeekend) {
                //ghe Lounge vao ngay cuoi tuan va ngay le
                if (is3D) {
                    if (isSau17h) {
                        itemGhe.gia = @"300000";
                    }
                    else
                        itemGhe.gia = @"250000";
                }
                else{
                    if (isSau17h) {
                        itemGhe.gia = @"220000";
                    }
                    else
                        itemGhe.gia = @"180000";
                }
            }
            else{
                if (!is3D) {
                    if (isSau17h) {
                        itemGhe.gia = @"180000";
                    }
                    else
                        itemGhe.gia = @"150000";
                }
                else{
                    if (isSau17h) {
                        itemGhe.gia = @"250000";
                    }
                    else
                        itemGhe.gia = @"200000";
                }
            }
        }
        else{
            if ([itemGhe.vip isEqualToString:@"0"]){
                if (isWeekend) {
                    //ghe thuong vao ngay cuoi tuan va ngay le
                    if (is3D) {
                        if (isSau17h) {
                            itemGhe.gia = @"190000";
                        }
                        else
                            itemGhe.gia = @"170000";
                    }
                    else{
                        if (isSau17h) {
                            itemGhe.gia = @"90000";
                        }
                        else
                            itemGhe.gia = @"80000";
                    }
                }
                else{
                    if (is3D) {
                        if (isSau17h) {
                            itemGhe.gia = @"150000";
                        }
                        else
                            itemGhe.gia = @"130000";
                    }
                    else{
                        if (isSau17h) {
                            itemGhe.gia = @"80000";
                        }
                        else
                            itemGhe.gia = @"70000";
                    }
                }
            }
            else if([itemGhe.vip isEqualToString:@"1"]){
                if (isWeekend) {
                    //ghe vip vao ngay cuoi tuan va ngay le
                    if (is3D) {
                        if (isSau17h) {
                            itemGhe.gia = @"200000";
                        }
                        else
                            itemGhe.gia = @"180000";
                    }
                    else{
                        if (isSau17h) {
                            itemGhe.gia = @"95000";
                        }
                        else
                            itemGhe.gia = @"85000";
                    }
                }
                else{
                    if (is3D) {
                        if (isSau17h) {
                            itemGhe.gia = @"160000";
                        }
                        else
                            itemGhe.gia = @"140000";
                    }
                    else{
                        if (isSau17h) {
                            itemGhe.gia = @"85000";
                        }
                        else
                            itemGhe.gia = @"75000";
                    }
                }
            }
            else{
                if (isWeekend) {
                    //ghe doi vao ngay cuoi tuan va ngay le
                    if (is3D) {
                        if (isSau17h) {
                            itemGhe.gia = @"410000";
                        }
                        else
                            itemGhe.gia = @"370000";
                    }
                    else{
                        if (isSau17h) {
                            itemGhe.gia = @"200000";
                        }
                        else
                            itemGhe.gia = @"180000";
                    }
                }
                else{
                    if (is3D) {
                        if (isSau17h) {
                            itemGhe.gia = @"160000";
                        }
                        else
                            itemGhe.gia = @"140000";
                    }
                    else{
                        if (isSau17h) {
                            itemGhe.gia = @"180000";
                        }
                        else
                            itemGhe.gia = @"160000";
                    }
                }
            }
        }
    }
}

- (NSString *)hienThiPhongChieu{
    NSString *sTenCss = @"rapphim";
    if ([self.edChonRap.text hasPrefix:@"CGV"] || [self.edChonRap.text hasPrefix:@"BHD"] || [self.edChonRap.text.lowercaseString containsString:@"galaxy"]) {
        sTenCss = @"raphimcgvtam";
    }
    else if ([self.edChonRap.text.lowercaseString isEqualToString:@"trung tâm chiếu phim quốc gia"]) {
        sTenCss = @"rapphimquocgia";
    }
//    NSLog(@"%s - sTenCss : %@", __FUNCTION__, sTenCss);
    NSString *html = [self getHtmlPhongChieu:phongHienTai];
    NSString *HTML_HEADER=@"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"><html xmlns=\"http://www.w3.org/1999/xhtml\"><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" /><meta name=\"viewport\" content=\"width=720\"><title>Untitled Document</title><style>%@</style></head><body>";
    NSString *HTML_FOOTER=@"</body></html>";
    NSString *path2 = [[NSBundle mainBundle] pathForResource:sTenCss ofType:@"css"];
    NSString *css = [NSString stringWithContentsOfFile:path2 encoding:NSUTF8StringEncoding error:nil];
//    NSLog(@"%s - css : %@", __FUNCTION__, css);
    NSString *cache = [self absolutePathToCacheDirectory];
    css = [css stringByReplacingOccurrencesOfString:@"tamnv" withString:cache];
    NSString *headerWithCss = [NSString stringWithFormat:HTML_HEADER, css];
    NSString *htmlString = [NSString stringWithFormat:@"%@%@%@",headerWithCss, html, HTML_FOOTER];
//    NSLog(@"%s - htmlString : %@", __FUNCTION__, htmlString);
    return htmlString;
}

- (NSString *)absolutePathToCacheDirectory{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [cachePath stringByExpandingTildeInPath];
    if ([path characterAtIndex:0] != '/') {
        path = [[NSString stringWithFormat:@"~/Documents/%@", path] stringByExpandingTildeInPath];
    }
    return path;
}

- (NSString *) getHtmlPhongChieu:(ItemPhongXemFilm*)item{
    NSString *html = @"";
    if ([self.edChonRap.text hasPrefix:@"CGV"] || [self.edChonRap.text hasPrefix:@"BHD"] || [self.edChonRap.text.lowercaseString containsString:@"galaxy"]) {
        html = [self taoHtmlPhongChieuCGV2:item];
    }
    else if ([sIdRap hasPrefix:@"TTCPQG_NCC"]) {
        html = [self taoHtmlPhongChieuQuocGia:item];
    }
    else {
        if (item) {
            NSLog(@"%s - khoi tao html rap platium", __FUNCTION__);
            html = [NSString stringWithFormat:@"<div class=\"screen\">Màn hình - phòng chiếu %@</div><div class=\"row\">", item.phong];
            if ([self.edChonRap.text hasPrefix:@"BHD"]) {
                html = [NSString stringWithFormat:@"<div class=\"screen\">Màn hình - <span id=\"soPhong\">%@</span></div>", item.phong];
            }
            for (int i = 0; i < item.arrDayGhe.count; i++) {
                ItemHangXemFilm *hang = [item.arrDayGhe objectAtIndex:i];
                html = [html stringByAppendingString:@"<ul>\n"];
                html = [html stringByAppendingString:[NSString stringWithFormat:@"<li class=\"anpha\">%@</li>\n", hang.stt]];
                for (int j = (int)hang.arrGhe.count -1; j >= 0; j --) {
                    ItemGheXemFilm *ghe = [hang.arrGhe objectAtIndex:j];
//                    NSLog(@"%s - ghe.hienThi : %@", __FUNCTION__, ghe.hienThi);
                    if ([ghe.hienThi isEqualToString:@"1"]) {
                        if ([ghe.vip isEqualToString:@"0"]) {
                            if (ghe.trangthai == 0) {
                                html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\">%@</li>\n", hang.stt, ghe.stt, ghe.stt]];
                            }
                            else{
                                if (![arrGheChon containsObject:ghe]) {
                                    html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" class=\"lovebook\"><&nbsp;</li>\n", hang.stt, ghe.stt]];
                                }
                                else{
                                    html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" class=\"vip select\">&nbsp;</li>\n", hang.stt, ghe.stt]];
                                }
                            }
                        }
                        else if ([ghe.vip isEqualToString:@"1"]) {
                            if (ghe.trangthai == 0) {
                                html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" class=\"vip\">%@</li>\n", hang.stt, ghe.stt, ghe.stt]];
                            }
                            else{
                                if (![arrGheChon containsObject:ghe]) {
                                    html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" class=\"lovebook\">&nbsp;</li>\n", hang.stt, ghe.stt]];
                                }
                                else{
                                    html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" class=\"vip select\">&nbsp;</li>\n", hang.stt, ghe.stt]];
                                }
                            }
                        }
                        else {
                            if (ghe.trangthai == 0) {
                                html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" class=\"love\">%@</li>\n", hang.stt, ghe.stt, ghe.stt]];
                            }
                            else{
                                if (![arrGheChon containsObject:ghe]) {
                                    html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" class=\"lovebook\">&nbsp;</li>\n", hang.stt, ghe.stt]];
                                }
                                else{
                                    html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" class=\"vip select\">&nbsp;</li>\n", hang.stt, ghe.stt]];
                                }
                            }
                        }
                    }
                    else {
                        html = [html stringByAppendingString:@"<li class=\"trang\">&nbsp;</li>\n"];
                    }
                }
                html = [html stringByAppendingString:[NSString stringWithFormat:@"<li class=\"anpha2\">%@</li></ul>\n", hang.stt]];
            }
            html = [html stringByAppendingString:@"</div>"];
        }
    }
    return html;
}

- (NSString *)taoHtmlPhongChieuCGV2:(ItemPhongXemFilm*)item {
    NSString *html = @"";
    if (item) {
        html = [NSString stringWithFormat:@"<div class=\"screen\">Màn hình - phòng chiếu <span id=\"soPhong\">%@</span></div>", item.phong];
        if ([self.edChonRap.text hasPrefix:@"BHD"]) {
            html = [NSString stringWithFormat:@"<div class=\"screen\">Màn hình - <span id=\"soPhong\">%@</span></div>", item.phong];
        }
        html = [html stringByAppendingString:@"<div class=\"rowcgv\">\n"];
        for (int i = 0; i < item.arrDayGhe.count; i++) {
            ItemHangXemFilm *hang = [item.arrDayGhe objectAtIndex:i];
            NSLog(@"%s =================== hang : %@", __FUNCTION__, hang.stt);
            html = [html stringByAppendingString:@"<ul>"];
            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li class=\"anpha\">%@</li>\n", hang.stt]];
            for (int j = 0; j < hang.arrGhe.count; j ++) {
                ItemGheXemFilm *ghe = [hang.arrGhe objectAtIndex:j];
                NSLog(@"%s - hang : %@ - ghe : %@ - type : %@ - vip : %@ - hienThi : %@ - ghe.trangthai : %d", __FUNCTION__, hang.stt, ghe.stt, ghe.type, ghe.vip, ghe.hienThi, ghe.trangthai);
                if (![ghe.type isEmpty] && ghe.stt.length > 0) {
                    if (ghe.trangthai != 1) {
                        if ([ghe.type.lowercaseString containsString:@"vip"]) {
                            NSString *class = @"vip";
                            if (ghe.trangthai != 0) {
                                class = @"book";
                            }
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%d\" class=\"%@\">%@</li>\n", hang.stt, j, class, ghe.stt]];
                        }
                        else if ([ghe.type.lowercaseString containsString:@"standard"] || [ghe.type.lowercaseString containsString:@"happy day"]) {
                            NSString *class = @"";
                            if (ghe.trangthai != 0) {
                                class = @"class=\"book\"";
                            }
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%d\" %@>%@</li>\n", hang.stt, j, class, ghe.stt]];
                        }
                        else if ([ghe.type.lowercaseString containsString:@"sweetbox"] || [ghe.type.lowercaseString containsString:@"couple"]) {
                            NSString *class = @"love";
                            if (ghe.trangthai != 0) {
                                class = @"book";
                            }
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%d\" class=\"%@\">%@</li>\n", hang.stt, j, class, ghe.stt]];
                        }
                    }
                    else {
                        html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%d\" class=\"book\">&nbsp;</li>\n", hang.stt, j]];
                    }
                }
                else {
                    html = [html stringByAppendingString:@"<li class=\"trang\">&nbsp;</li>\n"];
                }
            }
            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li class=\"anpha2\">%@</li></ul>\n", hang.stt]];
        }
        html = [html stringByAppendingString:@"</div>"];
    }
    return html;
}

- (NSString *)taoHtmlPhongChieuCGV:(ItemPhongXemFilm*)item {
    NSString *html = @"";
    if (item) {
        html = [NSString stringWithFormat:@"<div class=\"screen\">Màn hình - phòng chiếu <span id=\"soPhong\">%@</span></div>", item.phong];
        html = [html stringByAppendingString:@"<div class=\"rowcgv\">\n"];
        for (int i = 0; i < item.arrDayGhe.count; i++) {
            ItemHangXemFilm *hang = [item.arrDayGhe objectAtIndex:i];
            html = [html stringByAppendingString:@"<ul>"];
            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li class=\"anpha\">%@</li>\n", hang.stt]];
            for (int j = (int)hang.arrGhe.count - 1; j >= 0; j --) {
                ItemGheXemFilm *ghe = [hang.arrGhe objectAtIndex:j];
                    if ([ghe.vip isEqualToString:@"0"]) {
                        if (ghe.trangthai == 0) {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\">%@</li>\n", hang.stt, ghe.stt, ghe.stt]];
                        }
                        else {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" class=\"book\">&nbsp;</li>\n", hang.stt, ghe.stt]];
                        }
                    }
                    else if ([ghe.vip isEqualToString:@"1"]) {
                        if (ghe.trangthai == 0) {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" class=\"vip\">%@</li>\n", hang.stt, ghe.stt, ghe.stt]];
                        }
                        else {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" class=\"book\">&nbsp;</li>\n", hang.stt, ghe.stt]];
                        }
                    }
                    else if ([ghe.vip isEqualToString:@"2"]) {
                        if (ghe.trangthai == 0) {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" class=\"love\">%@</li>\n", hang.stt, ghe.stt, ghe.stt]];
                        }
                        else {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" class=\"book\">&nbsp;</li>\n", hang.stt, ghe.stt]];
                        }
                    }
                    else if ([ghe.vip isEqualToString:@"3"]) {
                        if (ghe.trangthai == 0) {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" class=\"premium\">%@</li>\n", hang.stt, ghe.stt, ghe.stt]];
                        }
                        else {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" class=\"book\">&nbsp;</li>\n", hang.stt, ghe.stt]];
                        }
                    }
                    else if ([ghe.vip isEqualToString:@"4"]) {
                        if (ghe.trangthai == 0) {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" class=\"handicap\">%@</li>\n", hang.stt, ghe.stt, ghe.stt]];
                        }
                        else {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" class=\"book\">&nbsp;</li>\n", hang.stt, ghe.stt]];
                        }
                    }
                    else if ([ghe.vip isEqualToString:@"5"]) {
                        if (ghe.trangthai == 0) {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" class=\"bond\">%@</li>\n", hang.stt, ghe.stt, ghe.stt]];
                        }
                        else {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" class=\"book\">&nbsp;</li>\n", hang.stt, ghe.stt]];
                        }
                    }
                    else if ([ghe.vip isEqualToString:@"6"]) {
                        if (ghe.trangthai == 0) {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" class=\"couple\">%@</li>\n", hang.stt, ghe.stt, ghe.stt]];
                        }
                        else {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" class=\"book\">&nbsp;</li>\n", hang.stt, ghe.stt]];
                        }
                    }
                    else if ([ghe.vip isEqualToString:@"7"]) {
                        if (ghe.trangthai == 0) {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" class=\"deluxe\">%@</li>\n", hang.stt, ghe.stt, ghe.stt]];
                        }
                        else {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" class=\"book\">&nbsp;</li>\n", hang.stt, ghe.stt]];
                        }
                    }
                    else if ([ghe.vip isEqualToString:@"8"]) {
                        if (ghe.trangthai == 0) {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" class=\"coupleS\">%@</li>\n", hang.stt, ghe.stt, ghe.stt]];
                        }
                        else {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" class=\"book\">&nbsp;</li>\n", hang.stt, ghe.stt]];
                        }
                    }
                    else if ([ghe.vip isEqualToString:@"9"]) {
                        if (ghe.trangthai == 0) {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" class=\"gold\">%@</li>\n", hang.stt, ghe.stt, ghe.stt]];
                        }
                        else {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" class=\"book\">&nbsp;</li>\n", hang.stt, ghe.stt]];
                        }
                    }
            }
            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li class=\"anpha2\">%@</li></ul>\n", hang.stt]];
        }
        html = [html stringByAppendingString:@"</div>"];
    }
    return html;
}

- (NSString *)taoHtmlPhongChieuQuocGia:(ItemPhongXemFilm*)item {
    NSString *html = @"";
    if (item) {
        html = [NSString stringWithFormat:@"<div class=\"screen\">Màn hình - phòng chiếu %@</div><div class=\"rowquocgia\">", item.phong];
        for (int i = 0; i < item.arrDayGhe.count; i++) {
            ItemHangXemFilm *hang = [item.arrDayGhe objectAtIndex:i];
            html = [html stringByAppendingString:@"<ul>\n"];
            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li class=\"anpha\">%@</li>\n", hang.stt]];
//            for (int j = (int)hang.arrGhe.count - 1; j >= 0; j --) {
            for (int j = 0; j < (int)hang.arrGhe.count; j ++) {
                ItemGheXemFilm *ghe = [hang.arrGhe objectAtIndex:j];
                if ([ghe.hienThi isEqualToString:@"1"] && ghe.stt.length > 0) {
                    if ([ghe.name.lowercaseString isEqualToString:@"ghế thường"]) {
                        if (ghe.trangthai == 0) {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)'>%@</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt, ghe.stt]];
                        }
                        else {
                            if (![arrGheChon containsObject:ghe]) {
                                html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"lovebook\">&nbsp;</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt]];
                            }
                            else{
                                html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"book\">&nbsp;</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt]];
                            }
                        }
                    }
                    else if ([ghe.name.lowercaseString isEqualToString:@"ghế vip"]) {
                        if (ghe.trangthai == 0) {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"vip\">%@</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt, ghe.stt]];
                        }
                        else{
                            if (![arrGheChon containsObject:ghe]) {
                                html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"lovebook\">&nbsp;</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt]];
                            }
                            else{
                                html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"book\">&nbsp;</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt]];
                            }
                        }
                    }
                    else {
                        if (ghe.trangthai == 0) {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"love\">%@</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt, ghe.stt]];
                        }
                        else{
                            if (![arrGheChon containsObject:ghe]) {
                                html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"lovebook\">&nbsp;</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt]];
                            }
                            else{
                                html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"book\">&nbsp;</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt]];
                            }
                        }
                    }
                }
                else {
                    html = [html stringByAppendingString:@"<li class=\"trang\"><a href=\"\">&nbsp;</a></li>\n"];
                }
            }
            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li class=\"anpha2\">%@</li></ul>\n", hang.stt]];
        }
        html = [html stringByAppendingString:@"</div>"];
    }

    return html;
}

- (int)getMaChuyenTuChuCaiSangSo:(NSString *)sChu{
    return [sChu characterAtIndex:0];
}

- (BOOL)validateVanTay{
    if ([sIdRap isEqualToString:@"TTCPQG_NCC"]) {
        if ([self.edHo.text isEmpty] || [self.edTen.text isEmpty] || [self.edEmail.text isEmpty] || [self.edTinhThanhQuocGia.text isEmpty] || [self.edPhuongXa.text isEmpty] || [self.edDiaChi.text isEmpty]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:@"Vui lòng điền đầy đủ thông tin khách hàng." delegate:nil cancelButtonTitle:@"Đóng" otherButtonTitles: nil];
            [alert show];
            return NO;
        }
    }
    if (![self.edEmail.text isEmpty]) {
        if (![self validateEmailWithString:self.edEmail.text]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:@"Định dạng email không đúng. Vui lòng kiểm tra lại." delegate:nil cancelButtonTitle:@"Đóng" otherButtonTitles: nil];
            [alert show];
            return NO;
        }
    }
    return YES;
}

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (void)xuLyThucHienKhiKiemTraThanhCongTraVeToken:(NSString *)sToken otp:(NSString *)sOtp{
    NSLog(@"%s - START!!!!", __FUNCTION__);
    NSString *sMaDoanhNghiep = @"";
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sMaDoanhNghiep = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_COMPANY_ID];
    }
    NSString *sDanhSachGhe = @"";
    NSString *sDanhSachChoGhe = @"";
    int nTongTien = 0;
    int nTongPhi = 0;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self hienThiLoading];
    }
    if ([sIdRap hasPrefix:@"TTCPQG_NCC"]) {
        for (int i = 0; i < arrGheChon.count; i ++) {
            ItemGheXemFilm *item = [arrGheChon objectAtIndex:i];
            sDanhSachChoGhe = [sDanhSachChoGhe stringByAppendingString:[NSString stringWithFormat:@"%@%@,", item.sHangGhe, item.stt]];
            int nSoTien = [item.gia intValue];
            nTongTien += nSoTien;
            nTongPhi += 1100;
        }
        if ([sDanhSachChoGhe hasSuffix:@","]) {
            sDanhSachChoGhe = [sDanhSachChoGhe substringToIndex:[sDanhSachChoGhe length] - 1];
        }
        NSLog(@"%s - sDanhSachChoGhe : %@", __FUNCTION__, sDanhSachChoGhe);
        NSDictionary *postBody = @{@"companyCode" : sMaDoanhNghiep,
                                   @"user" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                                   @"token" : sToken,
                                   @"otpConfirm" : sOtp,
                                   @"typeAuthenticate" : [NSNumber numberWithInt:self.mTypeAuthenticate],
                                   @"appId" : [NSNumber numberWithInt:APP_ID],
                                   @"funcId"   : [NSNumber numberWithInt:445],
                                   @"VMApp" : [NSNumber numberWithInt:VM_APP],
                                   @"idRap" : sIdRap,
                                   @"idPhim" : itemFilmHienTai.idPhim,
                                   @"idKhungGio" : sIdGioChieu,
                                   @"dsCho" : sDanhSachChoGhe,
                                   @"soTien" : [NSNumber numberWithInt:nTongTien],
                                   @"soDienThoaiXuLyThongTin" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                                   @"email" : self.edEmail.text,
                                   @"ho" : self.edHo.text,
                                   @"ten" : self.edTen.text,
                                   @"dienThoaiLienHe" : self.edDienThoaiLienHe.text,
                                   @"thanhPho" : self.edTinhThanhQuocGia.text,
                                   @"phuongXa" : self.edPhuongXa.text,
                                   @"diaChi" : self.edDiaChi.text
                                   };
        self.mDinhDanhKetNoi = @"MUA_VE_XEM_FILM";
        NSLog(@"%s - postBody quoc gia : %@", __FUNCTION__, [postBody JSONString]);
        [GiaoDichMang muaVeXemPhimQuocGia:[postBody JSONString] noiNhanKetQua:self];
    }
    else if ([self.edChonRap.text.lowercaseString hasPrefix:@"bhd"]) {
        NSString *thongTinVe = @"";
        for (ItemGiaVeCGV *item in arrGiaTienCGV) {
            if (item.sl > 0) {
                NSLog(@"%s - item : %@ - %d", __FUNCTION__, item.tenVe, item.sl);
                thongTinVe = [thongTinVe stringByAppendingString:[NSString stringWithFormat:@"%@:%d;", item.idVe, item.sl]];
            }
        }
        NSString *sDanhSachGhe = @"";
        if (arrGheChon) {
            for (int i = 0; i < arrGheChon.count; i ++) {
                ItemGheXemFilm *item = [arrGheChon objectAtIndex:i];
                nTongTien += [item.gia intValue];
                if ([item.type.lowercaseString containsString:@"vip"] || [item.type.lowercaseString containsString:@"standard"]) {
                    sDanhSachGhe = [sDanhSachGhe stringByAppendingString:[NSString stringWithFormat:@"%@;", item.stt]];
                }
                else {
                    ItemGheXemFilm *item2 = [arrGheChon objectAtIndex:i+1];
                    i+=1;
                    sDanhSachGhe = [sDanhSachGhe stringByAppendingString:[NSString stringWithFormat:@"%@_%@;", item.stt, item2.stt]];
                }
            }
        }
        NSLog(@"%s - thongTinVe : %@ - sDanhSachGhe : %@", __FUNCTION__, thongTinVe, sDanhSachGhe);
        NSDictionary *postBody = @{@"idPhim" : itemFilmHienTai.idPhim,
                                   @"idKhungGio" : sIdGioChieu,
                                   @"dsGhe" : sDanhSachGhe,
                                   @"dsVe" : thongTinVe,
                                   @"amount" : [NSNumber numberWithInt:nTongTien],
                                   @"appId" : [NSNumber numberWithInt:APP_ID],
                                   @"typeAuthenticate" : [NSNumber numberWithInt:self.mTypeAuthenticate],
                                   @"token" : sToken,
                                   @"otpConfirm" : sOtp,
                                   @"user" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                                   @"companyCode" : sMaDoanhNghiep,

                                   };
        NSLog(@"%s - [postBody JSONString] : %@", __FUNCTION__, [postBody JSONString]);
        self.mDinhDanhKetNoi = @"MUA_VE_XEM_FILM";
        [GiaoDichMang muaVeXemPhimBHD:[postBody JSONString] noiNhanKetQua:self];
    }
    else if ([self.edChonRap.text.lowercaseString containsString:@"galaxy"]) {
        NSString *thongTinVe = @"";
        for (ItemGiaVeCGV *item in arrGiaTienCGV) {
            if (item.sl > 0) {
                NSLog(@"%s - item : %@ - %d", __FUNCTION__, item.tenVe, item.sl);
                thongTinVe = [thongTinVe stringByAppendingString:[NSString stringWithFormat:@"%@:%d;", item.idVe, item.sl]];
            }
        }
        NSString *sDanhSachGhe = @"";
        if (arrGheChon) {
            for (int i = 0; i < arrGheChon.count; i ++) {
                ItemGheXemFilm *item = [arrGheChon objectAtIndex:i];
                nTongTien += [item.gia intValue];
                if ([item.type.lowercaseString containsString:@"vip"] || [item.type.lowercaseString containsString:@"standard"]) {
                    sDanhSachGhe = [sDanhSachGhe stringByAppendingString:[NSString stringWithFormat:@"%@;", item.stt]];
                }
                else {
                    ItemGheXemFilm *item2 = [arrGheChon objectAtIndex:i+1];
                    i+=1;
                    sDanhSachGhe = [sDanhSachGhe stringByAppendingString:[NSString stringWithFormat:@"%@_%@;", item.stt, item2.stt]];
                }
            }
        }
        NSLog(@"%s - thongTinVe : %@ - sDanhSachGhe : %@", __FUNCTION__, thongTinVe, sDanhSachGhe);
        NSDictionary *postBody = @{@"idPhim" : itemFilmHienTai.idPhim,
                                   @"idKhungGio" : sIdGioChieu,
                                   @"dsGhe" : sDanhSachGhe,
                                   @"dsVe" : thongTinVe,
                                   @"amount" : [NSNumber numberWithInt:nTongTien],
                                   @"appId" : [NSNumber numberWithInt:APP_ID],
                                   @"typeAuthenticate" : [NSNumber numberWithInt:self.mTypeAuthenticate],
                                   @"token" : sToken,
                                   @"otpConfirm" : sOtp,
                                   @"user" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                                   @"companyCode" : sMaDoanhNghiep,
                                    @"idRap" : sIdRap,
                                   };
        NSLog(@"%s - [postBody JSONString] : %@", __FUNCTION__, [postBody JSONString]);
        self.mDinhDanhKetNoi = @"MUA_VE_XEM_FILM";
        [GiaoDichMang muaVeXemPhimGalaxy:[postBody JSONString] noiNhanKetQua:self];
    }
    else {
        if ([self.edChonRap.text hasPrefix:@"CGV"]) {
            for (ItemGheXemFilm *item in arrGheChon) {
                int nSoTien = [item.gia intValue];
                nTongTien += nSoTien;
                nTongPhi += 1100;
            }
            for (int i = 0; i < arrGheChon.count; i ++) {
                ItemGheXemFilm *item = [arrGheChon objectAtIndex:i];
                if (i == 0) {
                    if (sDanhSachGhe.length == 0) {
                        sDanhSachGhe = item.sId;
                    }
                    else {
                        sDanhSachGhe = [sDanhSachGhe stringByAppendingString:[NSString stringWithFormat:@"%@", item.sId]];
                    }
                    if (sDanhSachChoGhe.length == 0) {
                        sDanhSachChoGhe = [NSString stringWithFormat:@"%@%@", item.sHangGhe, item.stt];
                    }
                    else {
                        sDanhSachChoGhe = [sDanhSachChoGhe stringByAppendingString:[NSString stringWithFormat:@"%@%@", item.sHangGhe, item.stt]];
                    }
                }
                else{
                    sDanhSachGhe = [sDanhSachGhe stringByAppendingString:[NSString stringWithFormat:@",%@", item.sId]];
                    sDanhSachChoGhe = [sDanhSachChoGhe stringByAppendingString:[NSString stringWithFormat:@"%@%@", item.sHangGhe, item.stt]];
                }
            }
        }
        else {
            for (int i = 0; i < arrGheChon.count; i ++) {
                ItemGheXemFilm *item = [arrGheChon objectAtIndex:i];
                if (i == 0) {
                    sDanhSachGhe = item.sId;
                    sDanhSachChoGhe = [NSString stringWithFormat:@"%@%@", item.sHangGhe, item.stt];
                }
                else{
                    sDanhSachGhe = [sDanhSachGhe stringByAppendingString:[NSString stringWithFormat:@",%@", item.sId]];
                    sDanhSachChoGhe = [sDanhSachChoGhe stringByAppendingString:[NSString stringWithFormat:@"%@%@", item.sHangGhe, item.stt]];
                }
            }

            for (ItemGheXemFilm *item in arrGheChon) {
                int nSoTien = [item.gia intValue];
                nTongTien += nSoTien;
                nTongPhi += 1100;
            }
        }
        NSString *sTail = @"";
        NSNumber *nhaSanXuat = [NSNumber numberWithInteger:NHA_CUNG_CAP_PLATINUM];
        if ([self.edChonRap.text hasPrefix:@"CGV"]) {
            nhaSanXuat = [NSNumber numberWithInteger:NHA_CUNG_CAP_CGV];
        }
        if (sMaDoanhNghiep.length > 0) {
            sTail = [NSString stringWithFormat:@"nhaCungCap=%@&soTien=%@&user=%@&companyCode=%@&token=%@&otpConfirm=%@&typeAuthenticate=%@&appId=%@&idRap=%@&idPhim=%@&idKhungGio=%@&dsCho=%@&khungGio=%@&dsChoTheoHangGhe=%@&ngayChieu=%@", nhaSanXuat, [NSNumber numberWithInt:nTongTien], [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP], sMaDoanhNghiep, sToken, sOtp, [NSNumber numberWithInt:self.mTypeAuthenticate], [NSNumber numberWithInt:APP_ID], sIdRap, itemFilmHienTai.idPhim, sIdGioChieu, sDanhSachGhe, sGioChieu, sDanhSachChoGhe, sNgayChieu];
            NSLog(@"%s - sTail : %@", __FUNCTION__, sTail);
            self.mDinhDanhKetNoi = @"MUA_VE_XEM_FILM";
            [GiaoDichMang muaVeXemPhim:sTail noiNhanKetQua:self];
        }
        else{
            NSString *sDsGheDon = @"";
            NSString *sDsGheDoi = @"";
            NSString *sDsGheBon = @"";
            NSMutableArray *arrSoLuongVe = [[NSMutableArray alloc] init];
            NSString *sDsGhe = @"";
            for (int i = 0; i < arrGheChon.count; i ++) {
                ItemGheXemFilm *item = [arrGheChon objectAtIndex:i];
                if (i == 0) {
                    sDsGhe = item.sId;
                    if (item.trangthai == 2 || item.trangthai == 3) {
                        sDsGheDon = [sDsGheDon stringByAppendingString:item.sId];
                    }
                    else if (item.trangthai == 4 || item.trangthai == 5) {
                        sDsGheDoi = [sDsGheDoi stringByAppendingString:item.sId];
                    }
                }
                else {
                    sDsGhe = [sDanhSachGhe stringByAppendingString:[NSString stringWithFormat:@",%@", item.sId]];
                    if (item.trangthai == 2 || item.trangthai == 3) {
                        sDsGheDon = [sDsGheDon stringByAppendingString:[NSString stringWithFormat:@",%@", item.sId]];
                    }
                    else if (item.trangthai == 4 || item.trangthai == 5) {
                        sDsGheDoi = [sDsGheDoi stringByAppendingString:[NSString stringWithFormat:@",%@", item.sId]];
                    }
                }
            }
            NSString *sDsSoLuongGhe = @"[";
            for (ItemGiaVeCGV *item in arrGiaTienCGV) {
                if (item.sl > 0) {
                    [arrSoLuongVe addObject:[item convertJSON]];
                    sDsSoLuongGhe = [sDsSoLuongGhe stringByAppendingString:[item convertJSON]];
                }
            }
            sDsSoLuongGhe = [sDsSoLuongGhe stringByAppendingString:@"]"];
            sDsSoLuongGhe = [sDsSoLuongGhe stringByReplacingOccurrencesOfString:@"}{" withString:@"},{"];

            NSDictionary *postBody = @{@"nhaCungCap" : nhaSanXuat,
                                       @"idPhim" : itemFilmHienTai.idPhim,
                                       @"idKhungGio" : sIdGioChieu,
                                       @"dsGhe" : @"",
                                       @"soTien" : [NSNumber numberWithInt:nTongTien],
                                       @"appId" : [NSNumber numberWithInt:APP_ID],
                                       @"typeAuthenticate" : [NSNumber numberWithInt:self.mTypeAuthenticate],
                                       @"token" : sToken,
                                       @"otpConfirm" : sOtp,
                                       @"user" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                                       @"dsSoLuongVe" : sDsSoLuongGhe,
                                       @"dsGheDon" : sDsGheDon,
                                       @"dsGheDoi" : sDsGheDoi,
                                       @"dsGheBon" : sDsGheBon
                                       };
            NSLog(@"%s - [postBody JSONString] : %@", __FUNCTION__, [postBody JSONString]);
            self.mDinhDanhKetNoi = @"MUA_VE_XEM_FILM";
            [GiaoDichMang muaVeXemPhimCGV:[postBody JSONString] noiNhanKetQua:self];
        }
    }
}

- (IBAction)suKienChonThongTin:(id)sender {
    GiaoDienThongTinPhim *vc = [[GiaoDienThongTinPhim alloc] initWithNibName:@"GiaoDienThongTinPhim" bundle:nil];
    vc.itemFilmHienTai = itemFilmHienTai;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (IBAction)suKienChonTrailer:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:itemFilmHienTai.trailer]];
}

- (IBAction)suKienBamChonGhe:(id)sender {
    NSLog(@"%s - arrGiaTienCGV : %ld", __FUNCTION__, (unsigned long)arrGiaTienCGV.count);
    GiaoDienChonGheCGV *vc = [[GiaoDienChonGheCGV alloc] initWithNibName:@"GiaoDienChonGheCGV" bundle:nil];
    vc.arrGiaTien = arrGiaTienCGV;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)dealloc {
    [viewQC release];
    [_webPhongChieu release];
    [_edChonRap release];
    [_edChonPhim release];
    [_viewInfo release];
//    [_scrMain release];
    if(arrRapPhim)
        [arrRapPhim release];
    if (arrDanhSachPhim)
        [arrDanhSachPhim release];
    if (itemFilmHienTai)
        [itemFilmHienTai release];
    if (phongHienTai)
        [phongHienTai release];
    //    [_collectionNgayChieu release];
    //    [_collectionGioChieu release];
    [_viewThongTinThanhToan release];
    [_lblRap release];
    [_lblPhim release];
    [_lblPhongChieu release];
    [_lblGioChieu release];
    [_lblSoGhe release];
    [_lblSoTien release];
    [_lblPhi release];
    [arrGheChon release];
    [_edTinhThanh release];
    [_edChonTinhThanh release];
    [_btnChonGhe release];
    if (arrGiaTienCGV) {
        [arrGiaTienCGV release];
    }
    [arrTinhThanh release];
    [_sTenFilmTimKiem release];
    [_webTrailer release];
    [_viewThongTinRapQuocGia release];
    [_edHo release];
    [_edTen release];
    [_edEmail release];
    [_edDienThoaiLienHe release];
    [_edTinhThanhQuocGia release];
    [_edPhuongXa release];
    [_edDiaChi release];
    [super dealloc];
}
@end
