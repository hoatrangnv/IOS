//
//  ChiTietSoTietKiemViewController.m
//  ViViMASS
//
//  Created by DucBui on 5/21/15.
//
//

#import "ChiTietSoTietKiemViewController.h"
#import "Common.h"

@interface ChiTietSoTietKiemViewController () <UIWebViewDelegate>

@end

@implementation ChiTietSoTietKiemViewController

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self khoiTaoBanDau];
    NSMutableString *chiTietHienThi = [[[NSMutableString alloc] init] autorelease];
//    [chiTietHienThi appendString:@"<table border=\"0\" cellspacing=\"3\" cellpadding=\"0\" style=\"font-size:17px; font-family:arial\">"];
    [chiTietHienThi appendString:@"<div style=\"font-size:14px; font-family:arial\">"];
    NSString *sXauHtml = [_mSoTietKiem layChiTietSoTietKiemKieuHTML];
    [chiTietHienThi appendString:sXauHtml];
//    [chiTietHienThi appendString:@"</table>"];
        [chiTietHienThi appendString:@"</div>"];
    [self.mwvHienThi loadHTMLString:chiTietHienThi baseURL:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - khoiTao

- (void)khoiTaoBanDau
{
    [self addButtonBack];
    self.navigationItem.title = @"Chi tiết sổ tiết kiệm";
    [self addTitleView:@"Chi tiết sổ tiết kiệm"];
    self.mFuncID = FUNC_RUT_TIEN_TIET_KIEM;
}

#pragma mark - overriden GiaoDichViewController

- (BOOL)validateVanTay
{
    return YES;
}

- (void)xuLyThucHienKhiKiemTraThanhCongTraVeToken:(NSString*)sToken otp:(NSString*)sOtp
{
    self.mDinhDanhKetNoi = DINH_DANH_RUT_SO_TIET_KIEM;
    [GiaoDichMang ketNoiRutSoTietKiem:_mSoTietKiem.soSoTietKiem
                                token:sToken
                                  otp:sOtp
                     typeAuthenticate:self.mTypeAuthenticate
                        noiNhanKetQua:self];
}

- (void)xuLyKetNoiThanhCong:(NSString*)sDinhDanhKetNoi thongBao:(NSString*)sThongBao ketQua:(id)ketQua
{
    if([sDinhDanhKetNoi isEqualToString:DINH_DANH_RUT_SO_TIET_KIEM])
    {
        [self hienThiHopThoaiMotNutBamKieu:HOP_THOAI_XAC_NHAN_CHUYEN_TIEN_THANH_CONG cauThongBao:sThongBao];
    }
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGRect frame = _mwvHienThi.frame;
    frame.size.height = 1;
    _mwvHienThi.frame = frame;
    CGSize fittingSize = [_mwvHienThi sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    _mwvHienThi.frame = frame;
    
    CGRect rViewMain = self.mViewMain.frame;
    CGRect rViewButtonRutGocTruocHan = _mbtnRutGocTruochan.frame;
    if([_mSoTietKiem.trangThai intValue] != 1)
    {
        //Khong co nut rut goc truoc han
        rViewMain.size.height = frame.origin.y * 2 + frame.size.height;
        [_mbtnRutGocTruochan setHidden:YES];
    }
    else
    {
        rViewButtonRutGocTruocHan.origin.y = 2*frame.origin.y + frame.size.height;
        rViewMain.size.height = 2*frame.origin.y + rViewButtonRutGocTruocHan.origin.y + rViewButtonRutGocTruocHan.size.height;
        [_mbtnRutGocTruochan setHidden:NO];
    }
    
    self.mViewMain.frame = rViewMain;
    _mbtnRutGocTruochan.frame = rViewButtonRutGocTruocHan;
    _mscrView.contentSize = CGSizeMake(_mscrView.frame.size.width, rViewMain.origin.y * 2 + rViewMain.size.height);
    _mViewChuaThongBao.hidden = YES;
    _mViewChuaThongBao.frame = _mscrView.frame;
    [self.view addSubview:_mViewChuaThongBao];
}


#pragma mark - suKien

- (IBAction)suKienBamNutRutGocTruocHan:(id)sender
{
    [_mlblRutDungHan setText:[NSString stringWithFormat:@"Nếu rút đúng hạn tiền gốc và lãi Bạn nhận được sẽ là %@",[Common hienThiTienTe_1:[_mSoTietKiem laySoTienLaiTheoKyHan]]]];
    [_mlblRutTruocHan setText:[NSString stringWithFormat:@"Nếu rút trước hạn tiền gốc và lãi Bạn nhận được sẽ là %@",[Common hienThiTienTe_1:[_mSoTietKiem laySoTienLaiRutTruocHan]]]];
    _mViewChuaThongBao.hidden = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    UITouch *touch  = [touches anyObject];

    if(touch.view == _mViewDen)
    {
        [_mViewChuaThongBao setHidden:YES];
    }
    
}

#pragma mark - xuLy

#pragma mark - dealloc
- (void)dealloc
{
    [_mSoTietKiem release];
    [_mwvHienThi release];
    [_mbtnRutGocTruochan release];
    [_mscrView release];
    [_mlblRutDungHan release];
    [_mlblRutTruocHan release];
    [_mViewChuaThongBao release];
    [_mViewDen release];
    [super dealloc];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
