//
//  HienThiChiTietNotificationViewController.m
//  ViMASS
//
//  Created by Mac Mini on 9/24/14.
//
//

#import "HienThiChiTietNotificationViewController.h"
#import "DichVuNotification.h"
#import "DoiTuongNotification.h"
#import "GiaoDichMang.h"
#import "DucNT_TaiKhoanThuongDungObject.h"
#import "DucNT_ChuyenTienViDenViViewController.h"
#import "ItemQuaTang.h"
#import "ChiTietTangQuaTheDienThoaiViewController.h"
#import "DoiTuongThanhToanCuocDienThoaiViettel.h"
#import "ThanhToanDienThoaiKhacViewController.h"

@interface HienThiChiTietNotificationViewController () <DucNT_ServicePostDelegate,UIWebViewDelegate>
{
    NSString *mDinhDanhKetNoi;
    BOOL bHuyDinhKy;
}

@property (nonatomic ,retain) DucNT_TaiKhoanThuongDungObject *mTaiKhoanThuongDung;

@property (nonatomic ,copy) NSString *mAlertID;
@property (retain, nonatomic) IBOutlet UIWebView *mwvHienThi;

@end

@implementation HienThiChiTietNotificationViewController

static NSString * css = @"<html xmlns=\"http://www.w3.org/1999/xhtml\"><header><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" /><link rel=\"stylesheet\" href=\"http://cdn.readability.com/a67566/css/print.css\" media=\"print\"><style type='text/css'>body{font-family:Arial !important;font-size:16px !important;background-color:#ffffff;}img{width:100%%;}p,strong{padding-left:10px;padding-right:10px;text-align:justify;}h1{text-align:justify;font-weight:bolder;}table,table tr{width:100%%;}</style></header><body><script type='text/javascript'>var wd_width = document.body.clientWidth;var imgs = document.getElementsByTagName('img');for(var i = 0;i< imgs.length;i++){var img = imgs[i];img.removeAttribute('height');img.style.paddingRight = '10px';img.style.width = (wd_width - 20) + 'px';var sup_img = img.parentNode;if(sup_img.nodeName == 'td'){sup_img.style.width = '100%%';}}</script>%@</body></html>";

static NSString *jsonMobiphone = @"{\"id\":7,\"type\":1,\"image\":\"09840098151425025637516.jpg\",\"name\":{\"content\":\"Thẻ cào Mobifone\",\"color\":\"#ffffff\",\"font\":\"\",\"size\":20,\"line\":0,\"style\":-1,\"css\":\"50000\"},\"message\":{\"content\":\"\",\"color\":\"#ffffff\",\"font\":\"\",\"size\":12,\"line\":0,\"style\":-1,\"css\":\"\"},\"amount\":{\"content\":\"0\",\"color\":\"#ffffff\",\"font\":\"\",\"size\":18,\"line\":0,\"style\":-1,\"css\":\"\"},\"status\":0,\"pos\":7}";
static NSString *jsonVinaphone = @"{\"id\":8,\"type\":1,\"image\":\"09840098151425025654944.jpg\",\"name\":{\"content\":\"Thẻ cào Vinaphone\",\"color\":\"#ffffff\",\"font\":\"\",\"size\":20,\"line\":0,\"style\":-1,\"css\":\"\"},\"message\":{\"content\":\"\",\"color\":\"#ffffff\",\"font\":\"\",\"size\":12,\"line\":0,\"style\":-1,\"css\":\"\"},\"amount\":{\"content\":\"0\",\"color\":\"#ffffff\",\"font\":\"\",\"size\":18,\"line\":0,\"style\":-1,\"css\":\"\"},\"status\":0,\"pos\":8}";
static NSString *jsonVietNamobile = @"{\"id\":9,\"type\":1,\"image\":\"09840098151426761177467.jpg\",\"name\":{\"content\":\"Thẻ cào Vietnamobile\",\"color\":\"#d66500\",\"font\":\"\",\"size\":20,\"line\":0,\"style\":-1,\"css\":\"\"},\"message\":{\"content\":\"\",\"color\":\"#111111\",\"font\":\"\",\"size\":12,\"line\":0,\"style\":-1,\"css\":\"\"},\"amount\":{\"content\":\"0\",\"color\":\"#111111\",\"font\":\"\",\"size\":18,\"line\":0,\"style\":-1,\"css\":\"\"},\"status\":0,\"pos\":9}";
static NSString *jsonGMobile = @"{\"id\":12,\"type\":1,\"image\":\"098400981514267612990.jpg\",\"name\":{\"content\":\"Thẻ cào Gmobile\",\"color\":\"#111111\",\"font\":\"\",\"size\":20,\"line\":0,\"style\":-1,\"css\":\"\"},\"message\":{\"content\":\"\",\"color\":\"#111111\",\"font\":\"#111111\",\"size\":12,\"line\":0,\"style\":-1,\"css\":\"\"},\"amount\":{\"content\":\"0\",\"color\":\"#111111\",\"font\":\"\",\"size\":18,\"line\":0,\"style\":-1,\"css\":\"\"},\"status\":0,\"pos\":10}";


#pragma mark - init
- (id)initWithAlertID:(NSString*)alertID
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if(self)
    {
        self.mAlertID = alertID;
    }
    return self;
}



#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%s - %s : khoi tao giao dien chi tiet thong bao", __FILE__, __FUNCTION__);
//    [self addBackButton:YES];
//    self.title = [@"thong_bao" localizableString];
    [self addTitleView:[@"thong_bao" localizableString]];
    [self khoiTaoBanDau];
    mDinhDanhKetNoi = DINH_DANH_LAY_CHI_TIET_MOT_TIN;
    [[DichVuNotification shareService] dichVuLayChiTietMotTin:_mDoiTuongNotification.alertId noiNhanKetQua:self];
    bHuyDinhKy = NO;
    [self.mwvHienThi setDelegate:self];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *fontSize=@"143";
    NSString *jsString = [[NSString alloc]      initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'",[fontSize intValue]];
    [_mwvHienThi stringByEvaluatingJavaScriptFromString:jsString];
}

#pragma mark - khoiTao

- (void)khoiTaoBanDau
{
    
    int nTypeShow = [_mDoiTuongNotification.typeShow intValue];
//    nTypeShow = KIEU_NOTIFICATION_VE_MAY_BAY;
    NSLog(@"%s -======> nTypeShow : %d", __FUNCTION__, nTypeShow);
    if(nTypeShow == KIEU_NOTIFICATION_TANG_QUA)
    {
        [self khoiTaoTheoKieuTangQua];
    }
    else if (nTypeShow == KIEU_NOTIFICATION_MUON_TIEN || nTypeShow == KIEU_NOTIFICATION_VE_MAY_BAY)
    {
        [self khoiTaoTheoKieuMuonTien];
    }
    else if (nTypeShow == KIEU_NOTIFICATION_THONG_BAO)
    {
        [self khoiTaoTheoKieuThongBao];
    }
    else if (nTypeShow == KIEU_NOTIFICATION_TRA_CUU_HOA_DON_VIETTEL) {
        [self khoiTaoTheoKieuDinhKy];
    }
    else
    {
        [self khoiTaoTheoKieuThongBao];
    }
}

- (void)khoiTaoTheoKieuThongBao
{
    
    CGRect rWebViewHienThi = _mwvHienThi.frame;
    CGRect rViewLuaChon = _mViewLuaChon.frame;
    CGRect rButtonDongY = _mbtnDongY.frame;
    CGRect rButtonTuChoi = _mbtnTuChoi.frame;
    rWebViewHienThi.origin.y = rViewLuaChon.origin.y;
    rWebViewHienThi.size.height += rViewLuaChon.size.height;
    [_mViewLuaChon setHidden:YES];
    
    _mwvHienThi.frame = rWebViewHienThi;
    _mViewLuaChon.frame = rViewLuaChon;
    _mbtnDongY.frame = rButtonDongY;
    _mbtnTuChoi.frame = rButtonTuChoi;
}

- (void)khoiTaoTheoKieuDinhKy
{
    
    [_mbtnDongY setTitle:@"Thanh toán" forState:UIControlStateNormal];
    [_mbtnTuChoi setTitle:@"Huỷ định kỳ" forState:UIControlStateNormal];
    CGRect rWebViewHienThi = _mwvHienThi.frame;
    CGRect rViewLuaChon = _mViewLuaChon.frame;
    CGRect rButtonDongY = _mbtnDongY.frame;
    CGRect rButtonTuChoi = _mbtnTuChoi.frame;
    
    [_mbtnTuChoi setHidden:NO];
    
    _mwvHienThi.frame = rWebViewHienThi;
    _mViewLuaChon.frame = rViewLuaChon;
    _mbtnDongY.frame = rButtonDongY;
    _mbtnTuChoi.frame = rButtonTuChoi;
    self.mbtnDongY.hidden = NO;
}

- (void)khoiTaoTheoKieuMuonTien
{
    int nStatusShow = [_mDoiTuongNotification.statusShow intValue];
    NSLog(@"%s - nStatusShow : %d", __FUNCTION__, nStatusShow);
    CGRect rWebViewHienThi = _mwvHienThi.frame;
    CGRect rViewLuaChon = _mViewLuaChon.frame;
    CGRect rButtonDongY = _mbtnDongY.frame;
    CGRect rButtonTuChoi = _mbtnTuChoi.frame;
    
    if(nStatusShow == TRANG_THAI_SHOW_NOTIFICATION_CHUA_XU_LY)
    {
        [_mbtnDongY setHidden:NO];
        [_mbtnTuChoi setHidden:NO];
    }
    else if(nStatusShow == TRANG_THAI_SHOW_NOTIFICATION_DA_TU_CHOI)
    {
        [_mbtnDongY setHidden:NO];
        [_mbtnTuChoi setHidden:YES];
        CGPoint newPoint = CGPointMake(_mViewLuaChon.center.x - rButtonDongY.size.width / 2, _mViewLuaChon.center.y - rButtonDongY.size.height / 2);
        rButtonDongY.origin = newPoint;
    }
    else if(nStatusShow == TRANG_THAI_SHOW_NOTIFICATION_DA_DONG_Y)
    {
        [_mbtnDongY setHidden:NO];
        [_mbtnTuChoi setHidden:YES];
        CGPoint newPoint = CGPointMake(_mViewLuaChon.center.x - rButtonDongY.size.width / 2, _mViewLuaChon.center.y - rButtonDongY.size.height / 2);
        rButtonDongY.origin = newPoint;
    }
    else
    {
        rWebViewHienThi.origin.y = rViewLuaChon.origin.y;
        rWebViewHienThi.size.height += rViewLuaChon.size.height;
        [_mViewLuaChon setHidden:YES];
    }
    
    _mwvHienThi.frame = rWebViewHienThi;
    _mViewLuaChon.frame = rViewLuaChon;
    _mbtnDongY.frame = rButtonDongY;
    _mbtnTuChoi.frame = rButtonTuChoi;
}

- (void)khoiTaoTheoKieuTangQua
{
    CGRect rWebViewHienThi = _mwvHienThi.frame;
    CGRect rViewLuaChon = _mViewLuaChon.frame;
    CGRect rButtonDongY = _mbtnDongY.frame;
    CGRect rButtonTuChoi = _mbtnTuChoi.frame;
    
    [_mbtnTuChoi setHidden:YES];
    CGPoint newPoint = CGPointMake(_mViewLuaChon.center.x - rButtonDongY.size.width / 2, _mViewLuaChon.center.y - rButtonDongY.size.height / 2);
    rButtonDongY.origin = newPoint;
    
    _mwvHienThi.frame = rWebViewHienThi;
    _mViewLuaChon.frame = rViewLuaChon;
    _mbtnDongY.frame = rButtonDongY;
    _mbtnTuChoi.frame = rButtonTuChoi;
    self.mbtnDongY.hidden = YES;
//    [self.mbtnDongY setTitle:[@"tang_qua" localizableString] forState:UIControlStateNormal];
}

#pragma mark - handler error
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - suKien

- (IBAction)suKienBamNutDongY:(id)sender
{
    int nTypeShow = [_mDoiTuongNotification.typeShow intValue];
    if(nTypeShow == KIEU_NOTIFICATION_TANG_QUA)
    {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
            [self hienThiLoadingChuyenTien];
        }
        mDinhDanhKetNoi = DINH_DANH_LAY_CHI_TIET_TIN_MUA_THE_CAO;
        [GiaoDichMang ketNoiLayChiTietTinMuaTheCao:_mDoiTuongNotification.idShow noiNhanKetQua:self];
    }
    else if (nTypeShow == KIEU_NOTIFICATION_MUON_TIEN)
    {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
            [self hienThiLoadingChuyenTien];
        }
        mDinhDanhKetNoi = DINH_DANH_LAY_CHI_TIET_TIN_MUON_TIEN;
        [GiaoDichMang ketNoiLayChiTietTinMuonTien:_mDoiTuongNotification.idShow noiNhanKetQua:self];
    }
    else if (nTypeShow == KIEU_NOTIFICATION_VE_MAY_BAY)
    {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
            [self hienThiLoadingChuyenTien];
        }
        mDinhDanhKetNoi = DINH_DANH_TRA_CUU_TANG_GIA_VE_MAY_BAY;
        [GiaoDichMang traCuuTrangThaiVeMayBay:_mDoiTuongNotification.idShow noiNhanKetQua:self];
    }
    else if (nTypeShow == KIEU_NOTIFICATION_TRA_CUU_HOA_DON_VIETTEL) {
        NSString *idShow = _mDoiTuongNotification.idShow;
        NSArray *arrTemp = [idShow componentsSeparatedByString:@"_"];
        @try {
            DoiTuongThanhToanCuocDienThoaiViettel *doiTuongThanhToanCuocDienThoaiViettel = [[DoiTuongThanhToanCuocDienThoaiViettel alloc] initWithMaGiaoDich:arrTemp[0] soDienThoai:arrTemp[1] tienCuocPhaiThanhToan:arrTemp[2]];
            if([doiTuongThanhToanCuocDienThoaiViettel.tienCuocPhaiThanhToan doubleValue] > 0)
            {
                ThanhToanDienThoaiKhacViewController *tt = [[ThanhToanDienThoaiKhacViewController alloc] initWithNibName:@"ThanhToanDienThoaiKhacViewController" bundle:nil];
                tt.mNhaMang = NHA_MANG_VIETTEL;
                tt.mDoiTuongThanhToanCuocDienThoaiViettel = doiTuongThanhToanCuocDienThoaiViettel;
                [self.navigationController pushViewController:tt animated:YES];
                [doiTuongThanhToanCuocDienThoaiViettel release];
                [tt release];
            }
            else
            {
//                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:doiTuongNofitication.alertContent];
            }
        }
        @catch (NSException *exception) {
//            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:doiTuongNofitication.alertContent];
        }
        @finally {
            
        }
    }
}

- (IBAction)suKienBamNutTuChoi:(id)sender
{
    int nTypeShow = [_mDoiTuongNotification.typeShow intValue];
    NSLog(@"%s - nTypeShow : %d", __FUNCTION__, nTypeShow);
    if (nTypeShow == KIEU_NOTIFICATION_TRA_CUU_HOA_DON_VIETTEL) {
        [self.viewXacThuc setHidden:NO];
        bHuyDinhKy = YES;
    }
    else {
        mDinhDanhKetNoi = DINH_DANH_KET_NOI_XAC_NHAN_TIN_MUON_TIEN;
        int mTrangThaiHienThi = 0;
        _mDoiTuongNotification.statusShow = [NSNumber numberWithInt:mTrangThaiHienThi];
        [[DichVuNotification shareService] dichVuXacNhanTrangThaiTinNotificationMuonTien:_mDoiTuongNotification.alertId
                                                                           trangThai:mTrangThaiHienThi
                                                                       noiNhanKetQua:self];
    }
}

- (IBAction)suKienChonCloseViewXacThuc:(id)sender {
    [self.viewXacThuc setHidden:YES];
    bHuyDinhKy = NO;
}

#pragma mark - DucNT_ServicePostDelegate

- (void)ketNoiThanhCong:(NSString *)sKetQua
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
        [self anLoading];
    }
    NSLog(@"mDinhDanhKetNoi : %@", mDinhDanhKetNoi);
    NSLog(@"sKetQua : %@", sKetQua);
    if ([mDinhDanhKetNoi isEqualToString:DINH_DANH_LAY_CHI_TIET_TIN_MUON_TIEN])
    {
        NSDictionary *dict = [sKetQua objectFromJSONString];
        mDinhDanhKetNoi = DINH_DANH_KET_NOI_XAC_NHAN_TIN_MUON_TIEN;
        _mTaiKhoanThuongDung = [[DucNT_TaiKhoanThuongDungObject alloc] init];
        [_mTaiKhoanThuongDung fillDataWithDictionary:dict loaiTaiKhoan:TAI_KHOAN_VI];
        int mTrangThaiHienThi = 1;
        _mDoiTuongNotification.statusShow = [NSNumber numberWithInt:mTrangThaiHienThi];
        NSString *content = [NSString stringWithFormat:css, _mDoiTuongNotification.alertContent];
        [self.mwvHienThi loadHTMLString:content baseURL:nil];
        [[DichVuNotification shareService] dichVuXacNhanTrangThaiTinNotificationMuonTien:_mDoiTuongNotification.alertId trangThai:mTrangThaiHienThi noiNhanKetQua:self];
        return;
    }
    else if ([mDinhDanhKetNoi isEqualToString:@"MUA_VE_GIA_CAO"]) {
        self.viewXacThuc.hidden = YES;
        return;
    }
    else if ([mDinhDanhKetNoi isEqualToString:@"HUY_THONG_BAO_DINH_KY"]) {
        self.viewXacThuc.hidden = YES;
        [self.mbtnTuChoi setHidden:YES];
        return;
    }
    NSDictionary *dicKetQua = [sKetQua objectFromJSONString];
    int nCode = [[dicKetQua objectForKey:@"msgCode"] intValue];
    NSString *message = [dicKetQua objectForKey:@"msgContent"];
    if(nCode == 1)
    {
        
        if([mDinhDanhKetNoi isEqualToString:DINH_DANH_LAY_CHI_TIET_MOT_TIN])
        {
            NSDictionary *results = [dicKetQua objectForKey:@"result"];
            DoiTuongNotification *doiTuongNotification = [[DoiTuongNotification alloc] initWithDict:results];
            NSLog(@"%s - doiTuongNotification.alertContent : %@", __FUNCTION__, doiTuongNotification.alertContent);
            NSString *content = [NSString stringWithFormat:css, doiTuongNotification.alertContent];
            while ([content containsString:@"\n\n"]) {
                content = [content stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\n"];
            }
            content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
            [self.mwvHienThi loadHTMLString:content baseURL:nil];
            if([_mDoiTuongNotification.status intValue] == 0)
            {
                _mDoiTuongNotification.status = [NSNumber numberWithInt:1];
                [(AppDelegate*)[[UIApplication sharedApplication] delegate] reloadGiaoDienHome];
            }
        }
        else if ([mDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_XAC_NHAN_TIN_MUON_TIEN])
        {
            [self khoiTaoBanDau];
            if([self.mDelegate respondsToSelector:@selector(xacNhanTinMuonTien:)])
            {
                [self.mDelegate xacNhanTinMuonTien:_mDoiTuongNotification];
            }
            if([self.mDoiTuongNotification.statusShow intValue] == TRANG_THAI_SHOW_NOTIFICATION_DA_DONG_Y)
            {
                [self chuyenTienDenVi];
            }
        }
        else if ([mDinhDanhKetNoi isEqualToString:DINH_DANH_LAY_CHI_TIET_TIN_MUA_THE_CAO])
        {
            NSDictionary *results = [dicKetQua objectForKey:@"result"];
            NSString *sMaTheCao = [results valueForKey:@"maTheCao"];
            NSString *sSeriaTheCao = [results valueForKey:@"serialTheCao"];
            NSNumber *nNhaMang = [results valueForKey:@"nhaMang"];
            [self tangQuaTheoNhaMang:[nNhaMang intValue] maTheCao:sMaTheCao serialTheCao:sSeriaTheCao];
        }
        else if ([mDinhDanhKetNoi isEqualToString:DINH_DANH_TRA_CUU_TANG_GIA_VE_MAY_BAY])
        {
            NSDictionary *results = [dicKetQua objectForKey:@"result"];
            int nTrangThai = [[results valueForKey:@"trangThai"] intValue];
            if(nTrangThai == 30) {
                //show view token
                self.viewXacThuc.hidden = NO;
                self.sIDDatVeGiaCaoMayBay = (NSString *)[results valueForKey:@"id"];
                NSLog(@"%s - sIDDatVeGiaCaoMayBay : %@", __FUNCTION__, self.sIDDatVeGiaCaoMayBay);
                NSString *html = [NSString stringWithFormat:@"<p>%@</p><p>Số tiền phải thanh toán: %@</p>", (NSString *)[results valueForKey:@"moTaThayDoi"], [Common hienThiTienTe_1:[[results valueForKey:@"soTienPhaiThanhToan"] doubleValue]]];
                [self.webThanhToan loadHTMLString:html baseURL:nil];
            }
            else {
//                (NSString *)[results valueForKey:@"trangThai"]
                NSString *tb = @"";
                if (nTrangThai == 0) {
                    tb = @"Đang đặt vé";
                }
                else if (nTrangThai == 1) {
                    tb = @"Đặt vé thành công";
                }
                else if (nTrangThai == 2) {
                    tb = @"Đặt vé không thành công";
                }
                else if (nTrangThai == 4) {
                    tb = @"Hết thời gian đặt vé";
                }
                else if (nTrangThai == 5) {
                    tb = @"Thông tin người lớn sai";
                }
                else if (nTrangThai == 6) {
                    tb = @"Thông tin trẻ em sai";
                }
                else if (nTrangThai == 7) {
                    tb = @"Thông tin em bé sai";
                }
                else if (nTrangThai == 8) {
                    tb = @"Không tra cứu được chuyến bay";
                }
                else if (nTrangThai == 9) {
                    tb = @"Chuyến bay đã hết chỗ";
                }
                else if (nTrangThai == 10) {
                    tb = @"Không đặt được chuyến bay";
                }
                else if (nTrangThai == 11) {
                    tb = @"Không đặt được chuyến bay do quá giờ";
                }
                else if (nTrangThai == 12) {
                    tb = @"Không lấy được phí chuyển tiền";
                }
                else if (nTrangThai == 13) {
                    tb = @"Có thay đổi chuyến bay";
                }
                else if (nTrangThai == 31) {
                    tb = @"Đã thanh toán giá vé cao hơn giá vé tra cứu";
                }
//                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:tb];
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:tb delegate:nil cancelButtonTitle:@"Đóng" otherButtonTitles: nil];
//                [alert show];
            }
        }
    }
    else
    {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:message];
//        [UIAlertView alert:message withTitle:[@"thong_bao" localizableString] block:^(UIAlertView *alert,int indexClicked){
//            [self.navigationController popViewControllerAnimated:YES];
//        }];
    }
}

- (BOOL)validateVanTay
{
    return YES;
}

- (void)xuLyThucHienKhiKiemTraThanhCongTraVeToken:(NSString*)sToken otp:(NSString*)sOtp
{
    if (bHuyDinhKy) {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
            [self hienThiLoadingChuyenTien];
        }
        mDinhDanhKetNoi = @"HUY_THONG_BAO_DINH_KY";
        NSDictionary *dicPost = @{@"id" : _mDoiTuongNotification.alertId,
                                  @"user" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                                  @"session" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_SECSSION],
                                  @"token":sToken,
                                  @"otpConfirm":sOtp,
                                  @"typeAuthenticate" : [NSNumber numberWithInteger:self.mTypeAuthenticate],
                                  @"VMApp" : [NSNumber numberWithInt:VM_APP],
                                  @"appId" : [NSNumber numberWithInt:APP_ID],
                                  };
        [GiaoDichMang ketNoiHuyThongBaoDinhKy:[dicPost JSONString] noiNhanKetQua:self];
    }
    else {
        self.mDinhDanhKetNoi = @"MUA_VE_GIA_CAO";
        NSLog(@"%s - sIDDatVeGiaCaoMayBay : %@", __FUNCTION__, self.sIDDatVeGiaCaoMayBay);
        [GiaoDichMang muaVeMayBayGiaCao:self.sIDDatVeGiaCaoMayBay token:sToken otpConfirm:sOtp typeAuthenticate:self.mTypeAuthenticate noiNhanKetQua:self];
    }
}

#pragma mark - xu Ly

- (void)chuyenTienDenVi
{
    DucNT_ChuyenTienViDenViViewController *chuyenTienViDenVi = [[DucNT_ChuyenTienViDenViViewController alloc] initWithNibName:@"DucNT_ChuyenTienViDenViViewController" bundle:nil];
    chuyenTienViDenVi.mTaiKhoanThuongDung = self.mTaiKhoanThuongDung;
    [self.navigationController pushViewController:chuyenTienViDenVi animated:YES];
    [chuyenTienViDenVi release];
}

- (void)tangQuaTheoNhaMang:(int)nNhaMang maTheCao:(NSString*)sMaTheCao serialTheCao:(NSString*)sSerial
{
    NSString *sJsonString = @"";
    if(nNhaMang == NHA_MANG_VINA)
    {
        sJsonString = jsonVinaphone;
    }
    else if (nNhaMang == NHA_MANG_MOBI)
    {
        sJsonString = jsonMobiphone;
    }
    else if(nNhaMang == NHA_MANG_GMOBILE)
    {
        sJsonString = jsonGMobile;
    }
    else if (nNhaMang == NHA_MANG_VIETNAMMOBILE)
    {
        sJsonString = jsonVietNamobile;
    }
    NSDictionary *dict = [sJsonString objectFromJSONString];
    ItemQuaTang *item = [[ItemQuaTang alloc] initWithDictionary:dict];
    
    ChiTietTangQuaTheDienThoaiViewController *chiTietTangQuaTheDienThoaiViewController = [[ChiTietTangQuaTheDienThoaiViewController alloc] initWithNibName:@"ChiTietTangQuaTheDienThoaiViewController" bundle:nil];
    chiTietTangQuaTheDienThoaiViewController.mItemQuaTang = item;
    chiTietTangQuaTheDienThoaiViewController.mMaSoThe = sMaTheCao;
    chiTietTangQuaTheDienThoaiViewController.mSoSeriThe = sSerial;
    [self.navigationController pushViewController:chiTietTangQuaTheDienThoaiViewController animated:YES];
    [chiTietTangQuaTheDienThoaiViewController release];
    [item release];
}

#pragma mark - dealloc
- (void)dealloc {
    if(_mTaiKhoanThuongDung)
        [_mTaiKhoanThuongDung release];
    [_mDoiTuongNotification release];
    [_mAlertID release];
    [_mwvHienThi release];
    [_mbtnTuChoi release];
    [_mbtnDongY release];
    [_mViewLuaChon release];
    [_viewXacThuc release];
    [_webThanhToan release];
    [super dealloc];
}

@end
