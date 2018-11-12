//
//  TraCuuTienDienViewController.m
//  ViViMASS
//
//  Created by DucBT on 4/8/15.
//
//

#import "TraCuuTienDienViewController.h"
#import "DucNT_ServicePost.h"
#import "GiaoDichMang.h"
#import "ContactScreen.h"
#import "DoiTuongNotification.h"
#import "MaDienLuc.h"
#import "MoTaChiTietHoaDonDien.h"
#import "ThanhToanTienDienViewController.h"
#import "DucNT_DanhSachTaiKhoanThuongDungControllerViewController.h"
#import "GiaoDienThongTinPhim.h"
#import "DucNT_LoginSceen.h"
@interface TraCuuTienDienViewController () <DucNT_ServicePostDelegate, UIWebViewDelegate, UIScrollViewDelegate>
{
    NSTimer *mTimer;
    int mThoiGianDoi;
    NSString *mDinhDanhKetNoi;
    ViewQuangCao *viewQC;

}
@property (nonatomic, retain) MoTaChiTietKhachHang *mMoTaChiTietKhachHang;
@property (nonatomic, retain) DoiTuongNotification *mDoiTuongNotification;
@property (nonatomic, retain) NSArray *mDanhSachMaDienLuc;
@property (nonatomic, retain) NSMutableArray *mDanhSachMaDienLucDangTraCuu;
@property (nonatomic, retain) NSMutableDictionary *mDictNoiDungTheoMaDienLuc;
@end

@implementation TraCuuTienDienViewController

static NSString *css = @"<div style=\"text-align: center;\">%@</div>";
static NSString *textMaDienLucChoPhep = @"<b>PD: Điện lực Hà Nội</b><br/><b>PE: Điện lực HCM</b><br/><br/><b>ĐIỆN LỰC MIỀN TRUNG</b><br/><b>PC01</b>: Quảng Bình  <br/><b>PC02</b>: Quảng Trị <br/><b>PC03</b>: Thừa Thiên Huế <br/><b>PC05</b>: Quảng Nam <br/><b>PC06</b>: Quảng Ngãi <br/><b>PC07</b>: Bình Định<br/><b>PC08</b>: Phú Yên <br/><b>PC10</b>: Gia Lai <br/><b>PC11</b>: Kon Tum <br/><b>PC12</b>: Đăk Lăk <br/><b>PC13</b>: Đăk Nông <br/><b>PP</b>: Đà Nẵng <br/><b>PQ</b>: Khánh Hòa<br/><br/><b>ĐIỆN LỰC MIỀN BẮC</b><br/><b>PA05</b>: Bắc Giang <br/><b>PA22</b>: Bắc Ninh<br/><b>PA26</b>: Bắc Kạn <br/><b>PA14</b>: Cao Bằng <br/><b>PA19</b>: Điện Biên <br/><b>PA20</b>: Hà Giang <br/><b>PA24</b>: Hà Nam <br/><b>PA16</b>: Hà Tĩnh <br/><b>PM</b>: Hải Dương <br/><b>PH</b>: Hải phòng <br/><b>PA17</b>: Hòa Bình <br/><b>PA23</b>: Hưng Yên <br/><b>PA29</b>: Lai Châu <br/><b>PA18</b>: Lào Cai <br/><b>PA11</b>: Lạng Sơn <br/><b>PN</b>: Ninh Bình<br/><b>PA13</b>: Nghệ An<br/><b>PA02</b>: Phú Thọ <br/><b>PA03</b>: Quảng Ninh  <br/><b>PA15</b>: Sơn La <br/><b>PA09</b>: Thái Bình<br/><b>PA04</b>: Thái Nguyên <br/><b>PA07</b>: Thanh Hóa <br/><b>PA12</b>: Tuyên Quang <br/><b>PA25</b>: Vĩnh Phúc <br/><b>PA10</b>: Yên Bái <br/><br/><b>ĐIỆN LỰC MIỀN NAM</b><br/><b>PB12</b>: An Giang<br/><b>PB15</b>: Bà Rịa Vũng Tàu<br/><b>PB11</b>: Cần Thơ<br/><b>PB13</b>: Kiên Giang<br/><b>PB19</b>: Bạc Liêu<br/><b>PB03</b>: Lâm Đồng<br/><b>PB02</b>: Bình Thuận<br/><b>PB06</b>: Long An<br/><b>PB09</b>: Bến Tre<br/><b>PB04</b>: Bình Dương<br/><b>PB01</b>: Bình Phước<br/><b>PB14</b>: Cà Mau<br/><b>PK</b>: Đồng Nai<br/><b>PB07</b>: Đồng Tháp<br/><b>PB20</b>: Hậu Giang<br/><b>PB18</b>: Ninh Thuận<br/><b>PB17</b>: Sóc Trăng<br/><b>PB05</b>: Tây Ninh<br/><b>PB08</b>: Tiền Giang<br/><b>PB16</b>: Trà Vinh<br/><b>PB10</b>: Vĩnh Long<br/>";

static NSString *cssKhachHang = @"<div style=\"text-align: center;\"><b>THÔNG TIN HOÁ ĐƠN</b></div><div>Tên khách hàng: %@ <br /> Địa chỉ: %@<br />%@<br /><b>Tổng số tiền: %@</b></div>";
static NSString *cssHoaDon = @"<div><b>Hoá đơn %d:</b><br />Số hoá đơn: %@<br />Kỳ thanh toán: %@<br />Số tiền: %@</div>";
const int TIME_COUNT_DOWN_DIEN = 180;

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self khoiTaoBanDau];
    [self addButtonHuongDan];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)suKienBamNutHuongDanGiaoDichViewController:(UIButton *)sender {
    GiaoDienThongTinPhim *vc = [[GiaoDienThongTinPhim alloc] initWithNibName:@"GiaoDienThongTinPhim" bundle:nil];
    vc.nOption = HUONG_DAN_THANH_TOAN_DIEN;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setAnimationChoSoTay:self.btnSoTay];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.btnSoTay.imageView stopAnimating];
    [self ketThucDemThoiGian];
}

#pragma mark - khoiTao

- (void)khoiTaoBanDau
{
    //giao dien tra cuu dien khong can quang cao
    [self addButtonBack];
    _mDanhSachMaDienLucDangTraCuu = [[NSMutableArray alloc] init];
    _mDictNoiDungTheoMaDienLuc = [[NSMutableDictionary alloc] init];
    
    self.mViewChuaThongBao.layer.borderWidth = 1.0f;
    self.mViewChuaThongBao.layer.borderColor = [UIColor blueColor].CGColor;
    [self addTitleView:[@"thanh_toan_tien_dien" localizableString]];
    self.mDanhSachMaDienLuc = [MaDienLuc layDanhSachMaDienLucTuFile];
    self.mtfMaKhachHang.max_length = 13;
    self.mwvHienThiDanhSachMaDienLucChoPhep.scrollView.delegate = self;

    if(_mIdShow)
    {
        [_mwvHienThiDanhSachMaDienLucChoPhep setHidden:YES];
        mDinhDanhKetNoi = DINH_DANH_KET_NOI_LAY_CHI_TIET_HOA_DON_DIEN_KHACH_HANG;
        [GiaoDichMang ketNoiLayChiTietThongTinTraCuuHoaDon:_mIdShow noiNhanKetQua:self];
    }
    else
    {
        [_mwvHienThiDanhSachMaDienLucChoPhep setHidden:NO];
        NSString *sXauHTML = [NSString stringWithFormat:css, textMaDienLucChoPhep];
        [self.mwvHienThiDanhSachMaDienLucChoPhep loadHTMLString:sXauHTML baseURL:nil];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateThongTinTraCuuDien:) name:KEY_TAI_KHOAN_THUONG_DUNG object:nil];
}

- (void)khoiTaoQuangCao {
    if (viewQC) {
        return;
    }
    viewQC = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ViewQuangCao class]) owner:self options:nil] objectAtIndex:0];
    viewQC.mDelegate = self;
    CGRect rectQC = viewQC.frame;
    CGRect rectMain = self.mbtnTraCuu.frame;

    CGFloat fW = rectMain.size.width;
    CGFloat fH = fW * 0.45333;
    rectQC.size.width = fW;
    rectQC.origin.y = self.mScrv.frame.origin.y + self.mScrv.frame.size.height + 10;
    rectQC.origin.x = rectMain.origin.x;
    rectQC.size.height = fH;
    viewQC.frame = rectQC;
    [viewQC updateSizeQuangCao];
    [self.view addSubview:viewQC];
    CGRect rectWebMa = self.mwvHienThiDanhSachMaDienLucChoPhep.frame;
    NSLog(@"%s - height : %f - QC.height : %f", __FUNCTION__, rectQC.origin.y, rectQC.size.height);
    rectWebMa.origin.y = rectQC.origin.y + rectQC.size.height + 10;
    NSLog(@"%s - rectWebMa.origin.y : %f - QC.height : %f", __FUNCTION__, rectWebMa.origin.y, rectQC.size.height);
    self.mwvHienThiDanhSachMaDienLucChoPhep.frame = rectWebMa;
//    [self.mwvHienThiDanhSachMaDienLucChoPhep.superview setNeedsLayout];
//    [self.mwvHienThiDanhSachMaDienLucChoPhep.superview layoutIfNeeded];
}

- (void)updateThongTinTraCuuDien:(NSNotification *)notification
{
    NSLog(@"%s - notification : %@", __FUNCTION__, notification);
    if([[notification name] isEqualToString:KEY_TAI_KHOAN_THUONG_DUNG])
    {
        DucNT_TaiKhoanThuongDungObject *mTaiKhoanThuongDung = [notification object];
        self.mtfMaKhachHang.text = mTaiKhoanThuongDung.maKhachHang;
    }
}

- (void)khoiTaoGiaTriChiTietKhachHang
{
    if(_mMoTaChiTietKhachHang)
    {
        self.mtfMaKhachHang.text = _mMoTaChiTietKhachHang.maKhachHang;
        self.mtfMaKhachHang.enabled = NO;
        
        //Tao xau html o day
        NSMutableString *sCacHoaDon = [[NSMutableString alloc] init];
        int i = 0;
        for(MoTaChiTietHoaDonDien *moTaChiTietHoaDonDien in _mMoTaChiTietKhachHang.list)
        {
            i++;
            [sCacHoaDon appendFormat:cssHoaDon, i, moTaChiTietHoaDonDien.maHoaDon, moTaChiTietHoaDonDien.kyThanhToan, [Common hienThiTienTe_1:[moTaChiTietHoaDonDien.soTien doubleValue]]];
        }
        NSString *sXauHtml = [NSString stringWithFormat:cssKhachHang, _mMoTaChiTietKhachHang.tenKhachHang, _mMoTaChiTietKhachHang.diaChi, sCacHoaDon, [Common hienThiTienTe_1:[_mMoTaChiTietKhachHang.total doubleValue]]];
        [self.mwvHienThiNoiDungHoaDon loadHTMLString:sXauHtml baseURL:nil];
    }
}

- (void)khoiTaoMoTaChiTietKhachHang
{
    CGRect rViewHienThiMaKhachHang = _mViewHienThiMaKhachHang.frame;
    CGRect rScrollView = _mScrv.frame;
    CGRect rBtnTraCuu = _mbtnTraCuu.frame;
    CGRect rWvHienThiDanhSachMaDienLuc = _mwvHienThiDanhSachMaDienLucChoPhep.frame;
    CGRect rWvHienThiNoiDungHoaDon = _mwvHienThiNoiDungHoaDon.frame;
    CGRect rbtnDanhBa = _mbtnDanhBa.frame;
    CGRect rtfMaKhachHang = _mtfMaKhachHang.frame;
    if(_mMoTaChiTietKhachHang)
    {
        [_mbtnDanhBa setHidden:YES];
        rtfMaKhachHang.size.width = rbtnDanhBa.origin.x + rbtnDanhBa.size.width - rtfMaKhachHang.origin.x;
        rScrollView.origin.y = rViewHienThiMaKhachHang.origin.y + rViewHienThiMaKhachHang.size.height + 8;
        rScrollView.size.height = self.view.frame.size.height - rScrollView.origin.y;
        rWvHienThiNoiDungHoaDon.origin.y = 0;
        rBtnTraCuu.origin.y = rWvHienThiNoiDungHoaDon.origin.y + rWvHienThiNoiDungHoaDon.size.height + 8;
        _mScrv.contentSize = CGSizeMake(rScrollView.size.width, rBtnTraCuu.origin.y + rBtnTraCuu.size.height + 8);
        [_mbtnTraCuu setTitle:[@"thanh_toan" localizableString] forState:UIControlStateNormal];
        [_mwvHienThiDanhSachMaDienLucChoPhep setHidden:YES];
    }
    else
    {
        [_mbtnDanhBa setHidden:NO];
        rtfMaKhachHang.size.width = rbtnDanhBa.origin.x - rtfMaKhachHang.origin.x - 8;
        _mwvHienThiNoiDungHoaDon.hidden = YES;
        rBtnTraCuu.origin.y = 0;
        rScrollView.origin.y = rViewHienThiMaKhachHang.origin.y + rViewHienThiMaKhachHang.size.height + 8;
        rScrollView.size.height = rBtnTraCuu.size.height;
        rWvHienThiDanhSachMaDienLuc.origin.y = rScrollView.origin.y + rScrollView.size.height + 8;
        rWvHienThiDanhSachMaDienLuc.size.height = self.view.frame.size.height - rWvHienThiDanhSachMaDienLuc.origin.y;
        [_mwvHienThiDanhSachMaDienLucChoPhep setHidden:NO];
        [_mbtnTraCuu setTitle:[@"tra_cuu" localizableString] forState:UIControlStateNormal];
    }
    _mbtnDanhBa.frame = rbtnDanhBa;
    _mtfMaKhachHang.frame = rtfMaKhachHang;
    _mViewHienThiMaKhachHang.frame = rViewHienThiMaKhachHang;
    _mScrv.frame = rScrollView;
    _mbtnTraCuu.frame = rBtnTraCuu;
    _mwvHienThiDanhSachMaDienLucChoPhep.frame = rWvHienThiDanhSachMaDienLuc;
    _mwvHienThiNoiDungHoaDon.frame = rWvHienThiNoiDungHoaDon;
    
    [self khoiTaoQuangCao];
}

#pragma mark - overriden Base

- (void)didReceiveRemoteNotification:(NSDictionary *)Info
{
    NSDictionary *userInfo = [Info valueForKey:@"userInfo"];
    if(userInfo)
    {
        NSLog(@"Debug:%@: %@, jSonString : %@", NSStringFromClass([self class]),NSStringFromSelector(_cmd), [userInfo JSONString]);
        DoiTuongNotification *doiTuongNotification = [[DoiTuongNotification alloc] initWithDict:userInfo];
        if([doiTuongNotification.funcID intValue] == TYPE_SHOW_TRA_CUU_HOA_DON_DIEN)
        {

            for(NSString *sMaKhachHangDaTraCuu in _mDanhSachMaDienLucDangTraCuu)
            {
                if([doiTuongNotification.alertContent rangeOfString:sMaKhachHangDaTraCuu].location != NSNotFound)
                {
                    [_mDictNoiDungTheoMaDienLuc setValue:doiTuongNotification forKey:sMaKhachHangDaTraCuu];
                    break;
                }
            }
            NSString *sMaKhachHangDangTraCuu = _mtfMaKhachHang.text;
            if([doiTuongNotification.alertContent rangeOfString:sMaKhachHangDangTraCuu].location != NSNotFound)
            {
                self.mDoiTuongNotification = doiTuongNotification;
            }
            [doiTuongNotification release];
        }
    }
}

#pragma mark - suKien

- (IBAction)suKienBamNutDanhBa:(id)sender
{
    ContactScreen *danhBa = [[[ContactScreen alloc] initWithNibName:@"ContactScreen" bundle:nil] autorelease];
    danhBa.mKieuHienThiLienHe = KIEU_HIEN_THI_LIEN_HE_THUONG;
    [self.navigationController pushViewController:danhBa animated:YES];
    __block TraCuuTienDienViewController *weakSelf = self;
    [danhBa selectContact:^(NSString *phone,Contact *contact)
     {
         if (phone != nil && phone.length > 0)
         {
             weakSelf.mtfMaKhachHang.text = [phone uppercaseString];
         }
         [danhBa.navigationController popViewControllerAnimated:YES];
     }];
}

- (IBAction)suKienThayDoiMaKhachHang:(id)sender
{
//    UITextField *tf = (UITextField*)sender;
//    NSString *newText = [tf.text uppercaseString];
//    tf.text = newText;
}

- (IBAction)nhapMaKhachHang:(id)sender {
    UITextField *tf = (UITextField*)sender;
    NSString *newText = [tf.text uppercaseString];
    tf.text = newText;
}

- (IBAction)suKienBamNutTraCuu:(id)sender
{
    [self.view endEditing:YES];
    if(_mMoTaChiTietKhachHang)
    {
        //Thanh Toan
        ThanhToanTienDienViewController *thanhToanTienDienViewController = [[ThanhToanTienDienViewController alloc] initWithNibName:@"ThanhToanTienDienViewController" bundle:nil];
        thanhToanTienDienViewController.mMoTaChiTietKhachHang = _mMoTaChiTietKhachHang;
        thanhToanTienDienViewController.mDanhSachMaDienLuc = _mDanhSachMaDienLuc;
        [self.navigationController pushViewController:thanhToanTienDienViewController animated:YES];
        [thanhToanTienDienViewController release];
    }
    else
    {
        NSString *sMaKhachHangDangTraCuu = _mtfMaKhachHang.text;
        if([self kiemTraHoaDonDaTraCuuThanhCong])
        {
            [self ketThucDemThoiGian];
            DoiTuongNotification *doiTuong = [_mDictNoiDungTheoMaDienLuc valueForKey:sMaKhachHangDangTraCuu];
            self.mDoiTuongNotification = doiTuong;
            [self xuLyChuyenViewThanhToan];
        }
        else
        {
            NSInteger nIndex = [_mDanhSachMaDienLucDangTraCuu indexOfObject:sMaKhachHangDangTraCuu];
            if(nIndex == _mDanhSachMaDienLucDangTraCuu.count - 1 && mThoiGianDoi > 0 && mThoiGianDoi < TIME_COUNT_DOWN_DIEN)
                [self hienThiViewThongBaoHoaDonDien];
            else
            {
                if(nIndex != NSNotFound)
                {
                    [_mDanhSachMaDienLucDangTraCuu removeObjectAtIndex:nIndex];
                }
                
                [_mDanhSachMaDienLucDangTraCuu addObject:sMaKhachHangDangTraCuu];
                self.mDoiTuongNotification = nil;
                [self xuLyTraCuuHoaDonDien];
            }

        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if(webView == _mwvHienThiDanhSachMaDienLucChoPhep)
    {
        CGRect frame = _mwvHienThiDanhSachMaDienLucChoPhep.frame;
        frame.size.height = 1;
        _mwvHienThiDanhSachMaDienLucChoPhep.frame = frame;
        CGSize fittingSize = [_mwvHienThiDanhSachMaDienLucChoPhep sizeThatFits:CGSizeZero];
        frame.size = fittingSize;
        _mwvHienThiDanhSachMaDienLucChoPhep.frame = frame;
    }
    else if (webView == _mwvHienThiNoiDungHoaDon)
    {
        CGRect frame = _mwvHienThiNoiDungHoaDon.frame;
        frame.size.height = 1;
        _mwvHienThiNoiDungHoaDon.frame = frame;
        CGSize fittingSize = [_mwvHienThiNoiDungHoaDon sizeThatFits:CGSizeZero];
        frame.size = fittingSize;
        _mwvHienThiNoiDungHoaDon.frame = frame;
    }

    [self khoiTaoMoTaChiTietKhachHang];
}

#pragma mark - xuLyTimer
//pd16000182506
- (void)batDauDemThoiGian
{
    [self ketThucDemThoiGian];
    mThoiGianDoi = TIME_COUNT_DOWN_DIEN;
    NSString *sCauThongBao = [NSString stringWithFormat:@"%@ %d s",[@"thong_bao_dang_tra_cuu_hoa_don_dien" localizableString], mThoiGianDoi];
    [_mtvNoiDungThongBao setText:sCauThongBao];
    [self hienThiViewThongBaoHoaDonDien];
    mTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(capNhatDemThoiGian) userInfo:nil repeats:YES];
}

- (void)ketThucDemThoiGian
{
    mThoiGianDoi = TIME_COUNT_DOWN_DIEN;
    if(mTimer)
    {
        [mTimer invalidate];
        mTimer = nil;
    }
}

- (void)capNhatDemThoiGian
{
    mThoiGianDoi --;
    NSString *sCauThongBao = [NSString stringWithFormat:@"%@ %d s",[@"thong_bao_dang_tra_cuu_hoa_don_dien" localizableString], mThoiGianDoi];
    [_mtvNoiDungThongBao setText:sCauThongBao];

    if(mThoiGianDoi > 0 && _mDoiTuongNotification)
    {
        [self ketThucDemThoiGian];
        [self anViewThongBaoHoaDonDien];
//        [self.mtvNoiDungThongBao setText:_mDoiTuongNotification.alertContent];
        [self xuLyChuyenViewThanhToan];

    }
    else if(mThoiGianDoi == 0 && !_mDoiTuongNotification)
    {
        [self anViewThongBaoHoaDonDien];
        [self ketThucDemThoiGian];
    }
}

#pragma mark - xuLy Touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    if(view == _mViewNenThongBao)
    {
        [self anViewThongBaoHoaDonDien];
    }
}

//PP01000146528

#pragma mark - xuLy

- (void)xuLyChuyenViewThanhToan
{
   if(_mDoiTuongNotification)
   {
       NSString *idShow = _mDoiTuongNotification.idShow;
       if(![idShow isEqualToString:@""] && [_mDoiTuongNotification.typeShow intValue] == KIEU_NOTIFICATION_TIEN_DIEN)
       {
           TraCuuTienDienViewController *traCuuTienDienViewController = [[TraCuuTienDienViewController alloc] initWithNibName:@"TraCuuTienDienViewController" bundle: nil];
           traCuuTienDienViewController.mIdShow = idShow;
           [self.navigationController pushViewController:traCuuTienDienViewController animated:YES];
           [traCuuTienDienViewController release];
       }
       else
       {
           [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:_mDoiTuongNotification.alertContent];
       }
   }
}

- (void)xuLyCoGianViewThongBaoTheoNoiDung
{
    NSString *sText = _mtvNoiDungThongBao.text;
    CGSize textViewSize = [sText sizeWithFont:[UIFont systemFontOfSize:16.0f]
                           constrainedToSize:CGSizeMake(_mtvNoiDungThongBao.frame.size.width, FLT_MAX)
                               lineBreakMode:NSLineBreakByTruncatingTail];
    float fMaxHeightViewThongBao = _mViewNenThongBao.frame.size.height - 40;
    float fMinHeightViewThongBao = 150;
    

    float fHeightViewThongBao = textViewSize.height + 20 + _mViewTieuDeThongBao.frame.size.height;
    float fWithViewThongBao = _mViewChuaThongBao.frame.size.width;
    
    if(fHeightViewThongBao > fMaxHeightViewThongBao)
        fHeightViewThongBao = fMaxHeightViewThongBao;
    else if (fHeightViewThongBao < fMinHeightViewThongBao)
        fHeightViewThongBao = fMinHeightViewThongBao;
    
    _mtvNoiDungThongBao.frame = CGRectMake(_mtvNoiDungThongBao.frame.origin.x, _mtvNoiDungThongBao.frame.origin.y, _mtvNoiDungThongBao.frame.size.width, textViewSize.height + 20);
    _mViewChuaThongBao.frame = CGRectMake(0, 0, fWithViewThongBao, fHeightViewThongBao);
    _mViewChuaThongBao.center = _mViewNenThongBao.center;
}

- (BOOL)kiemTraHoaDonDaTraCuuThanhCong
{
    NSString *sMaKhachHangDangTraCuu = _mtfMaKhachHang.text;
    NSInteger nIndex = [_mDanhSachMaDienLucDangTraCuu indexOfObject:sMaKhachHangDangTraCuu];
    if(nIndex != NSNotFound)
    {
        DoiTuongNotification *doiTuong = [_mDictNoiDungTheoMaDienLuc valueForKey:sMaKhachHangDangTraCuu];
        if(doiTuong)
            return YES;
    }
    return NO;
}

- (void)xuLyTraCuuHoaDonDien
{
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return;
    }
    NSString *sText = _mtfMaKhachHang.text;
    int nKieuThanhToan = [Common layKieuTraCuuHoaDonDienTheoMaKhachHang:sText];
    if(nKieuThanhToan == -1)
    {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:[@"thong_bao_khong_phai_ma_khach_hang_dien" localizableString]];
    }
    else
    {
        NSString *seccsion = self.mThongTinTaiKhoanVi.secssion;
        if(seccsion)
        {
            mDinhDanhKetNoi = DINH_DANH_KET_NOI_TRA_CUU_HOA_DON_DIEN_KHACH_HANG;
            [GiaoDichMang ketNoiTraCuuHoaDonTienDien:nKieuThanhToan
                                         maKhachHang:sText
                                            secssion:self.mThongTinTaiKhoanVi.secssion
                                       noiNhanKetQua:self];
        }
        else
        {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Xin vui lòng đăng nhập lại để thực hiện chức năng này"];
        }
    }
}

- (void)hienThiViewThongBaoHoaDonDien
{
    if(!_mViewHienThiThongBaoHoaDonDien.superview)
    {
        _mViewHienThiThongBaoHoaDonDien.frame = self.view.bounds;
        [self.view addSubview:_mViewHienThiThongBaoHoaDonDien];
    }
    else
    {
        _mViewHienThiThongBaoHoaDonDien.frame = self.view.bounds;        
        [self.view bringSubviewToFront:_mViewHienThiThongBaoHoaDonDien];
    }
    [self xuLyCoGianViewThongBaoTheoNoiDung];
    [_mViewHienThiThongBaoHoaDonDien setHidden:NO];
}

- (void)anViewThongBaoHoaDonDien
{
    if(_mViewHienThiThongBaoHoaDonDien.superview)
        _mViewHienThiThongBaoHoaDonDien.hidden = YES;
}

#pragma mark - DucNT_ServicePostDelegate

-(void)ketNoiThanhCong:(NSString *)sKetQua
{
    NSDictionary *dicKetQua = [sKetQua objectFromJSONString];
    int nCode = [[dicKetQua objectForKey:@"msgCode"] intValue];
    NSString *message = [dicKetQua objectForKey:@"msgContent"];
    if(nCode == 1)
    {
        if([mDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_TRA_CUU_HOA_DON_DIEN_KHACH_HANG])
        {
            [self.view endEditing:YES];
            [self batDauDemThoiGian];
        }
        else if([mDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_LAY_CHI_TIET_HOA_DON_DIEN_KHACH_HANG])
        {
            [self.view endEditing:YES];
            NSDictionary *result = [dicKetQua valueForKey:@"result"];
            if(result)
            {
                NSString *jsonMoTa = [result valueForKey:@"moTa"];
                if(jsonMoTa)
                {
                    NSDictionary *moTa = [jsonMoTa objectFromJSONString];
                    MoTaChiTietKhachHang *moTaChiTietKhachHang = [[MoTaChiTietKhachHang alloc] initWithDictionary:moTa];
                    self.mMoTaChiTietKhachHang = moTaChiTietKhachHang;
                    [self khoiTaoGiaTriChiTietKhachHang];
                    [moTaChiTietKhachHang release];
                }
            }
        }
    }
    else
    {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:message];
    }

}
//pd16000182506
- (IBAction)suKienChonSoTay:(id)sender {
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return;
    }
    DucNT_DanhSachTaiKhoanThuongDungControllerViewController *vc = [[DucNT_DanhSachTaiKhoanThuongDungControllerViewController alloc] initWithType:TAI_KHOAN_NAP_TIEN_DIEN];
    [self.navigationController presentViewController:vc animated:YES completion:^{}];
    [vc release];
}

- (void)dealloc
{
    [viewQC release];
    NSLog(@"%s -> %d", __FUNCTION__, __LINE__);
    if(_mDanhSachMaDienLucDangTraCuu) {
        [_mDanhSachMaDienLucDangTraCuu release];
    }
    NSLog(@"%s -> %d", __FUNCTION__, __LINE__);
    if (_mDictNoiDungTheoMaDienLuc) {
        [_mDictNoiDungTheoMaDienLuc release];
    }
    NSLog(@"%s -> %d", __FUNCTION__, __LINE__);
    if(_mIdShow) {
        [_mIdShow release];
    }
    NSLog(@"%s -> %d", __FUNCTION__, __LINE__);
    if(_mDoiTuongNotification) {
        [_mDoiTuongNotification release];
    }
    NSLog(@"%s -> %d", __FUNCTION__, __LINE__);
    if(_mDanhSachMaDienLuc) {
        [_mDanhSachMaDienLuc release];
    }
    NSLog(@"%s -> %d", __FUNCTION__, __LINE__);
    if(_mMoTaChiTietKhachHang) {
        [_mMoTaChiTietKhachHang release];
    }
    NSLog(@"%s -> %d", __FUNCTION__, __LINE__);
    [_mtfMaKhachHang release];
    NSLog(@"%s -> %d", __FUNCTION__, __LINE__);
    [_mbtnDanhBa release];
    NSLog(@"%s -> %d", __FUNCTION__, __LINE__);
    [_mbtnTraCuu release];
    NSLog(@"%s -> %d", __FUNCTION__, __LINE__);
    [_mtvNoiDungThongBao release];
    NSLog(@"%s -> %d", __FUNCTION__, __LINE__);
    [_mlblThongBaoDoi release];
    NSLog(@"%s -> %d", __FUNCTION__, __LINE__);
    [_mwvHienThiNoiDungHoaDon release];
    NSLog(@"%s -> %d", __FUNCTION__, __LINE__);
    [_mwvHienThiDanhSachMaDienLucChoPhep release];
    NSLog(@"%s -> %d", __FUNCTION__, __LINE__);
    [_mViewHienThiMaKhachHang release];
    NSLog(@"%s -> %d", __FUNCTION__, __LINE__);
    [_mViewHienThiDanhSachMaDienLuc release];
    NSLog(@"%s -> %d", __FUNCTION__, __LINE__);
    [_mViewChuaThongBao release];
    NSLog(@"%s -> %d", __FUNCTION__, __LINE__);
    [_mViewHienThiThongBaoHoaDonDien release];
    NSLog(@"%s -> %d", __FUNCTION__, __LINE__);
    [_mViewNenThongBao release];
    NSLog(@"%s -> %d", __FUNCTION__, __LINE__);
    [_mViewTieuDeThongBao release];
    NSLog(@"%s -> %d", __FUNCTION__, __LINE__);
    [_mScrv release];
    NSLog(@"%s -> %d", __FUNCTION__, __LINE__);
    [super dealloc];
}

@end
