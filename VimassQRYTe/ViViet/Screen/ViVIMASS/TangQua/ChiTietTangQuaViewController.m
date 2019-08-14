//
//  ChiTietTangQuaViewController.m
//  ViViMASS
//
//  Created by DucBT on 3/26/15.
//
//

#import "ChiTietTangQuaViewController.h"
#import "ThoiDiemTangQuaViewController.h"
#import "ContactScreen.h"

@interface ChiTietTangQuaViewController () <UITextViewDelegate, ThoiDiemTangQuaViewControllerDelegate>
{
//    double mSoTienThanhToan;
    ViewQuangCao *viewQC;
}
@property (retain, nonatomic) ViewQuaTang *mViewQuaTang;
@property (retain, nonatomic) NSDate *mdtThoiGianTangQua;

@end

@implementation ChiTietTangQuaViewController

#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self khoiTaoBanDau];
    self.mbtnToken.hidden = NO;
}

#pragma mark - khoiTao

- (void)khoiTaoBanDau
{

    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 34, 34);
    button.backgroundColor = [UIColor clearColor];
    button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
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
    [self addButtonBack];
    [self addTitleView:[@"tang_qua" localizableString]];
    self.mFuncID = FUNC_ID_TAO_QUA_TANG;
    
    self.mViewMain.frame = CGRectMake(10.0f, 10.0f, self.mViewMain.frame.size.width, self.mViewMain.frame.size.height);
    self.mbtnVanTay.frame = CGRectMake(self.mbtnVanTay.frame.origin.x,
                                       self.mViewMain.frame.size.height + self.mViewMain.frame.origin.y + 20.0f,
                                       self.mbtnVanTay.frame.size.width,
                                       self.mbtnVanTay.frame.size.height);
    [self.mscrvHienThi addSubview:self.mViewMain];
    self.mscrvHienThi.contentSize = CGSizeMake(self.mscrvHienThi.frame.size.width,
                                               self.mbtnVanTay.frame.size.height + self.mbtnVanTay.frame.origin.y + 10.0f);
    
    NSLog(@"%s - _mItemQuaTang.mAmount.content : %@", __FUNCTION__, _mItemQuaTang.mAmount.content);
    self.mViewQuaTang = [[[NSBundle mainBundle] loadNibNamed:@"ViewQuaTang" owner:self options:nil] objectAtIndex:0];
    self.mViewQuaTang.mItemQuaTang = _mItemQuaTang;
    self.mViewQuaTang.frame = self.mViewChuaViewQuaTang.bounds;
    [self.mViewChuaViewQuaTang addSubview:self.mViewQuaTang];
    [self.mViewChuaViewQuaTang bringSubviewToFront:self.mViewQuaTang];
    if (_mItemQuaTang) {
        if (!_mItemQuaTang.mAmount.content.isEmpty) {
            _mtfSoTien.text = [Common hienThiTienTe:[_mItemQuaTang.mAmount.content doubleValue]];
            [self suKienThayDoiGiaTriSoTien:nil];
        }
        if (!_sToAccWallet.isEmpty) {
            _mtfTaiKhoanNhanQua.text = _sToAccWallet;
        }
    }
    [self khoiTaoGiaTri];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_mtvNoiDungChuyenTien resignFirstResponder];
    [_mtfNoiDungChuyenTien resignFirstResponder];
//    [self khoiTaoQuangCao];
}

- (void)hideViewNhapToken {
    
}

- (void)khoiTaoGiaTri
{
    self.mtfTieuDe.text = self.mItemQuaTang.mName.content;
    self.mtfTieuDe.placeholder = [@"reg bds - title" localizableString];
    self.mtfTieuDe.inputAccessoryView = nil;
    [self.mtfTieuDe setTextError:[@"thong_bao_nhap_tieu_de" localizableString] forType:ExTextFieldTypeEmpty];
    
    self.mtfTaiKhoanNhanQua.placeholder = [@"btf - receiver" localizableString];
    self.mtfTaiKhoanNhanQua.inputAccessoryView = nil;
    [self.mtfTaiKhoanNhanQua setTextError:[@"thong_bao_nhap_nguoi_nhan_qua" localizableString] forType:ExTextFieldTypeEmpty];
    
    self.mtfSoTien.placeholder = [@"amount" localizableString];
    self.mtfSoTien.inputAccessoryView = nil;
    [self.mtfSoTien setTextError:[@"so_tien_khong_duoc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];

    self.mtfNoiDungChuyenTien.placeholder = [@"noi_dung" localizableString];
    self.mtvNoiDungChuyenTien.text = self.mItemQuaTang.mMessage.content;
    self.mtfNoiDungChuyenTien.inputAccessoryView = nil;
    [self.mtfNoiDungChuyenTien setTextError:[@"thong_bao_nhap_noi_dung_tang_qua" localizableString] forType:ExTextFieldTypeEmpty];
    [self.mbtnThucHien setTitle:[@"thuc_hien" localizableString] forState:UIControlStateNormal];

    [self hienThiSoPhi];
    self.mdtThoiGianTangQua = nil;
    [self capNhatThoiGianTangQua];
}

- (void)khoiTaoQuangCao {
    if (viewQC == nil) {
        viewQC = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ViewQuangCao class]) owner:self options:nil] objectAtIndex:0];
        viewQC.mDelegate = self;
        CGRect rectToken = self.mViewChuaViewQuaTang.frame;
        CGRect rectQC = viewQC.frame;
        CGRect rectMain = self.mViewMain.frame;
        
        CGFloat fW = rectMain.size.width;
        CGFloat fH = fW * 0.45333;
        rectQC.origin.y = rectToken.origin.y + rectToken.size.height + 15.0;
        viewQC.frame = CGRectMake(0, rectQC.origin.y, fW, fH);
        viewQC.mDelegate = self;
        [viewQC updateSizeQuangCao];
        rectMain.size.height = rectQC.origin.y + rectQC.size.height + 10;
        self.mViewMain.frame = rectMain;
        [self.mViewMain addSubview:viewQC];
        [self.mscrvHienThi setContentSize:CGSizeMake(_mscrvHienThi.frame.size.width, rectMain.origin.y +rectMain.size.height + 20)];
    }
    
}

#pragma mark - overriden GiaoDichViewController

- (BOOL)validateVanTay
{
    return YES;
    NSArray *tfs = @[_mtfTieuDe, _mtfTaiKhoanNhanQua, _mtfSoTien, _mtfThoiGianTangQua];
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
    
    if(self.mtvNoiDungChuyenTien.text.length == 0)
    {
        [self.mtfNoiDungChuyenTien validate];
        [self.mtfNoiDungChuyenTien show_error];
        return false;
    }
    
    return flg;
}

- (void)xuLyThucHienKhiKiemTraThanhCongTraVeToken:(NSString*)sToken otp:(NSString*)sOtp
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_TAO_QUA_TANG;
        double fSoTienThanhToan = [[[self.mtfSoTien.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
        NSString *sTaiKhoanNhan = self.mtfTaiKhoanNhanQua.text;
        long milisecondThoiGianTangQua = [self.mdtThoiGianTangQua timeIntervalSince1970] * 1000;
        if([self.mItemQuaTang.mId intValue] == 14)
        {
            [GiaoDichMang ketNoiTaoKhuyenMaiDen:sTaiKhoanNhan
                                       thoiGian:milisecondThoiGianTangQua
                                         soTien:fSoTienThanhToan
                                 sTieuDeQuaTang:self.mItemQuaTang.mName.content
                                       sLoiChuc:self.mItemQuaTang.mMessage.content
                                         idIcon:[self.mItemQuaTang.mId intValue]
                                          token:sToken
                                            otp:sOtp
                               typeAuthenticate:self.mTypeAuthenticate
                                  noiNhanKetQua:self];
        }
        
        else
        {
            [GiaoDichMang ketNoiTaoQuaTangDen:sTaiKhoanNhan
                                     thoiGian:milisecondThoiGianTangQua
                                       soTien:fSoTienThanhToan
                               sTieuDeQuaTang:self.mItemQuaTang.mName.content
                                     sLoiChuc:self.mItemQuaTang.mMessage.content
                                       idIcon:[self.mItemQuaTang.mId intValue]
                                        token:sToken
                                          otp:sOtp
                             typeAuthenticate:self.mTypeAuthenticate
                                noiNhanKetQua:self];
        }
    });
}

- (void)xuLyKetNoiThanhCong:(NSString*)sDinhDanhKetNoi thongBao:(NSString*)sThongBao ketQua:(id)ketQua
{
    if([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_TAO_QUA_TANG])
    {
        [self hienThiHopThoaiMotNutBamKieu:HOP_THOAI_XAC_NHAN_CHUYEN_TIEN_THANH_CONG cauThongBao:sThongBao];
    }
}

- (void)xuLyKetNoiThatBai:(NSString*)sDinhDanhKetNoi thongBao:(NSString*)sThongBao ketQua:(id)ketQua
{
    [super xuLyKetNoiThatBai:sDinhDanhKetNoi thongBao:sThongBao ketQua:ketQua];
}

#pragma mark - suKien

- (IBAction)suKienThayDoiGiaTriTieuDe:(id)sender
{
    NSString *sTieuDe = self.mtfTieuDe.text;
    self.mItemQuaTang.mName.content = sTieuDe;
    [self.mViewQuaTang reloadData];
}

- (IBAction)suKienThayDoiGiaTriSoTien:(id)sender
{
    double fSoTienThanhToan = [[[self.mtfSoTien.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
    self.mtfSoTien.text = [Common hienThiTienTe:fSoTienThanhToan];
    [self hienThiSoPhi];
    for(UIButton *button in _mDsBtnSoTien)
    {
        [self huyHienThiLuaChonButton:button];
    }
    
    self.mItemQuaTang.mAmount.content = [NSString stringWithFormat:@"%ld", (long)fSoTienThanhToan];
    [self.mViewQuaTang reloadData];
}

- (IBAction)suKienBamNutDanhBa:(id)sender
{
    ContactScreen *danhBa = [[[ContactScreen alloc] initWithNibName:@"ContactScreen" bundle:nil] autorelease];
    danhBa.mKieuHienThiLienHe = KIEU_HIEN_THI_LIEN_HE_THUONG;
    [self.navigationController pushViewController:danhBa animated:YES];
    __block ChiTietTangQuaViewController *weakSelf = self;
    [danhBa selectContact:^(NSString *phone,Contact *contact)
     {
         if (phone != nil && phone.length > 0)
         {
             if([Common kiemTraLaMail:phone])
             {
                 weakSelf.mtfTaiKhoanNhanQua.text = phone;
             }
             else
             {
                 weakSelf.mtfTaiKhoanNhanQua.text = [phone stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [phone length])];
             }
         }
         [danhBa.navigationController popViewControllerAnimated:YES];
     }];
    
}

- (IBAction)suKienBamNutSoTien:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    if(btn.isSelected == NO)
    {
        double fSoTienThanhToan = [[[btn.titleLabel.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
        for(UIButton *button in _mDsBtnSoTien)
        {
            [self huyHienThiLuaChonButton:button];
        }
        self.mtfSoTien.text = [Common hienThiTienTe:fSoTienThanhToan];
        [self hienThiLuaChonButton:btn];
        [self hienThiSoPhi];
        
        self.mItemQuaTang.mAmount.content = [NSString stringWithFormat:@"%ld", (long)fSoTienThanhToan];
        [self.mViewQuaTang reloadData];
    }
}

- (IBAction)suKienBamNutChonThoiGianTangQua:(id)sender
{
    ThoiDiemTangQuaViewController *thoiDiemTangQuaViewController = [[ThoiDiemTangQuaViewController alloc] initWithNibName:@"ThoiDiemTangQuaViewController" bundle:nil];
    thoiDiemTangQuaViewController.mDelegate = self;
    [self.navigationController pushViewController:thoiDiemTangQuaViewController animated:YES];
    [thoiDiemTangQuaViewController release];
}

- (IBAction)suKienChonSoTayQuaTang:(id)sender {

}

- (IBAction)suKienChonThoiGianTangQua:(id)sender
{
//    ThoiDiemTangQuaViewController *thoiDiemTangQuaViewController = [[ThoiDiemTangQuaViewController alloc] initWithNibName:@"ThoiDiemTangQuaViewController" bundle:nil];
//    thoiDiemTangQuaViewController.mDelegate = self;
//    [self.navigationController pushViewController:thoiDiemTangQuaViewController animated:YES];
//    [thoiDiemTangQuaViewController release];
}

#pragma mark - xuLy

- (void)hienThiLuaChonButton:(UIButton*)btn
{
    [btn setSelected:YES];
    [btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
}

- (void)huyHienThiLuaChonButton:(UIButton*)btn
{
    [btn setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setSelected:NO];
}

- (void)hienThiSoPhi
{
    double fSoTienThanhToan = [[[self.mtfSoTien.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
    double fSoPhi = [Common layPhiChuyenTienCuaSoTien:fSoTienThanhToan kieuChuyenTien:KIEU_CHUYEN_TIEN_NAP_THE_DIEN_THOAI maNganHang:@""];
    self.mtfSoPhi.text = [Common hienThiTienTe_1:fSoPhi];
}

- (void)capNhatThoiGianTangQua
{
    if(!_mdtThoiGianTangQua)
    {
        [self.mtfThoiGianTangQua setText:[@"tang_ngay" localizableString]];
    }
    else
    {
        NSString *sThoiGianTangQua = [Common date:self.mdtThoiGianTangQua toStringWithFormat:@"HH:mm dd/MM/yyyy"];
        [self.mtfThoiGianTangQua setText:sThoiGianTangQua];
    }
    
}


#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    [self.mtvNoiDungChuyenTien textViewDidChange:textView];
    NSString *sNoiDung = self.mtvNoiDungChuyenTien.text;
    self.mItemQuaTang.mMessage.content = sNoiDung;
    [self.mViewQuaTang reloadData];
}

#pragma mark - ThoiDiemTangQuaViewControllerDelegate

- (void)suKienChonThoiDiemTangQua:(NSDate*)date
{
    self.mdtThoiGianTangQua = date;
    [self capNhatThoiGianTangQua];
}

#pragma mark - dealloc

- (void)dealloc {
    [viewQC release];
    if(_mItemQuaTang)
        [_mItemQuaTang release];
    if(_mdtThoiGianTangQua)
        [_mdtThoiGianTangQua release];
    [_sToAccWallet release];
    [_mtfTieuDe release];
    [_mtfTaiKhoanNhanQua release];
    [_mbtnDanhBa release];
    [_mDsBtnSoTien release];
    [_mtfSoTien release];
    [_mtfNoiDungChuyenTien release];
    [_mtvNoiDungChuyenTien release];
    [_mtfThoiGianTangQua release];
    [_mViewQuaTang release];
    [_mscrvHienThi release];
    [_mViewChuaViewQuaTang release];
    [_mtfSoPhi release];
    [super dealloc];
}

@end
