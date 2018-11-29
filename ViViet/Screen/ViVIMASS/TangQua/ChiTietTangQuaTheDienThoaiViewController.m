//
//  ChiTietTangQuaTheDienThoaiViewController.m
//  ViViMASS
//
//  Created by DucBT on 4/6/15.
//
//

#import "ChiTietTangQuaTheDienThoaiViewController.h"
#import "ThoiDiemTangQuaViewController.h"
#import "ContactScreen.h"
#import "DucNT_LoginSceen.h"

@interface ChiTietTangQuaTheDienThoaiViewController () <UITextViewDelegate, ThoiDiemTangQuaViewControllerDelegate>

@property (retain, nonatomic) NSDate *mdtThoiGianTangQua;
@end

@implementation ChiTietTangQuaTheDienThoaiViewController

#pragma mark - life circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self khoiTaoBanDau];
    [self khoiTaoGiaTri];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - khoiTao

- (void)khoiTaoBanDau
{
    [self addButtonBack];
//    self.title = [@"tang_qua" localizableString];
    [self addTitleView:[@"tang_qua" localizableString]];
    [self themButtonHuongDanSuDung:@selector(suKienChonHuongDanTangQua:)];
    self.mFuncID = FUNC_ID_TAO_QUA_TANG;
    
    self.mViewMain.frame = CGRectMake(10.0f, 10.0f, self.mViewMain.frame.size.width, self.mViewMain.frame.size.height);
    self.mbtnVanTay.frame = CGRectMake(self.mbtnVanTay.frame.origin.x,
                                       self.mViewMain.frame.size.height + self.mViewMain.frame.origin.y + 20.0f,
                                       self.mbtnVanTay.frame.size.width,
                                       self.mbtnVanTay.frame.size.height);
    [self.mscrvHienThi addSubview:self.mViewMain];
    self.mscrvHienThi.contentSize = CGSizeMake(self.mscrvHienThi.frame.size.width, self.mbtnVanTay.frame.size.height + self.mbtnVanTay.frame.origin.y + 10.0f);
    NSLog(@"%s - mMaSoThe : %@", __FUNCTION__, _mMaSoThe);
    NSLog(@"%s - mSoSeriThe : %@", __FUNCTION__, _mSoSeriThe);

}

- (void)suKienChonHuongDanTangQua:(UIButton *)sender {

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
    
    
    self.mtfNoiDung.placeholder = [@"noi_dung" localizableString];
    self.mtfNoiDung.text = self.mItemQuaTang.mMessage.content;
    self.mtfNoiDung.inputAccessoryView = nil;
    [self.mtfNoiDung setTextError:[@"thong_bao_nhap_noi_dung_tang_qua" localizableString] forType:ExTextFieldTypeEmpty];
    [self.mbtnThucHien setTitle:[@"thuc_hien" localizableString] forState:UIControlStateNormal];
    
    self.mtfMaThe.placeholder = [@"ma_so_the" localizableString];
    self.mtfMaThe.inputAccessoryView = nil;
    [self.mtfMaThe setTextError:[@"thong_bao_nhap_ma_so_the" localizableString] forType:ExTextFieldTypeEmpty];
    if(_mMaSoThe)
        self.mtfMaThe.text = _mMaSoThe;
    
    
    self.mtfSoSeriThe.placeholder = [@"so_seri_the" localizableString];
    self.mtfSoSeriThe.inputAccessoryView = nil;
    [self.mtfSoSeriThe setTextError:[@"thong_bao_nhap_so_seri_the" localizableString] forType:ExTextFieldTypeEmpty];
    if(_mSoSeriThe)
        self.mtfSoSeriThe.text = _mSoSeriThe;

    self.mdtThoiGianTangQua = nil;
    [self capNhatThoiGianTangQua];
    [self khoiTaoGiaTriViewQuaTang];
}

- (void)khoiTaoGiaTriViewQuaTang
{
    NSString *urlImage = [NSString stringWithFormat:@"https://vimass.vn/vmbank/services/media/getImage?id=%@", _mItemQuaTang.mImage];
    [self.mimgvHienThi setImageWithURL:[NSURL URLWithString:urlImage]];
    
    //set view qua tang
    self.mlblTieuDe.text = _mItemQuaTang.mName.content;
    self.mlblTieuDe.textColor = [UIColor colorWithHexString:_mItemQuaTang.mName.color];
    self.mlblTieuDe.font = [UIFont fontWithName:_mItemQuaTang.mName.font size:[_mItemQuaTang.mName.size floatValue]];
    
    if(_mItemQuaTang.mName.font.length > 0)
        self.mlblTieuDe.font = [UIFont fontWithName:_mItemQuaTang.mName.font size:[_mItemQuaTang.mName.size floatValue]];
    else
        self.mlblTieuDe.font =[UIFont systemFontOfSize:[_mItemQuaTang.mName.size floatValue]];
    
    if([_mItemQuaTang.mName.css rangeOfString:@"text-align: right;"].location != NSNotFound)
    {
        self.mlblTieuDe.textAlignment = NSTextAlignmentRight;
    }
    else if([_mItemQuaTang.mName.css rangeOfString:@"text-align: center;"].location != NSNotFound)
    {
        self.mlblTieuDe.textAlignment = NSTextAlignmentCenter;
    }
    else
    {
        self.mlblTieuDe.textAlignment = NSTextAlignmentLeft;
    }
    
    
    self.mlblNoiDungQuaTang.text = _mItemQuaTang.mMessage.content;
    self.mlblNoiDungQuaTang.textColor = [UIColor colorWithHexString:_mItemQuaTang.mMessage.color];
    
    if(_mItemQuaTang.mMessage.font.length > 0)
        self.mlblNoiDungQuaTang.font = [UIFont fontWithName:_mItemQuaTang.mMessage.font size:[_mItemQuaTang.mMessage.size floatValue]];
    else
        self.mlblNoiDungQuaTang.font =[UIFont systemFontOfSize:[_mItemQuaTang.mMessage.size floatValue]];
    
    if([_mItemQuaTang.mMessage.css rangeOfString:@"text-align: right;"].location != NSNotFound)
    {
        self.mlblNoiDungQuaTang.textAlignment = NSTextAlignmentRight;
    }
    else if([_mItemQuaTang.mMessage.css rangeOfString:@"text-align: center;"].location != NSNotFound)
    {
        self.mlblNoiDungQuaTang.textAlignment = NSTextAlignmentCenter;
    }
    else
    {
        self.mlblNoiDungQuaTang.textAlignment = NSTextAlignmentLeft;
    }
    
    self.mlblMaThe.textColor = [UIColor colorWithHexString:_mItemQuaTang.mAmount.color];
    self.mlblMaThe.font = [UIFont fontWithName:_mItemQuaTang.mAmount.font size:[_mItemQuaTang.mAmount.size floatValue]];
    
    self.mlblSoSeriThe.textColor = [UIColor colorWithHexString:_mItemQuaTang.mAmount.color];
    self.mlblSoSeriThe.font = [UIFont fontWithName:_mItemQuaTang.mAmount.font size:[_mItemQuaTang.mAmount.size floatValue]];
    
    if([_mItemQuaTang.mAmount.css rangeOfString:@"text-align: right;"].location != NSNotFound)
    {
        self.mlblSoSeriThe.textAlignment = NSTextAlignmentRight;
        self.mlblMaThe.textAlignment = NSTextAlignmentRight;
    }
    else if([_mItemQuaTang.mAmount.css rangeOfString:@"text-align: center;"].location != NSNotFound)
    {
        self.mlblSoSeriThe.textAlignment = NSTextAlignmentCenter;
        self.mlblMaThe.textAlignment = NSTextAlignmentCenter;
    }
    else
    {
        self.mlblSoSeriThe.textAlignment = NSTextAlignmentLeft;
        self.mlblMaThe.textAlignment = NSTextAlignmentLeft;
    }
}

- (void)hideViewNhapToken {
}
#pragma mark - overriden GiaoDichViewController

- (BOOL)validateVanTay
{
    return YES;
    NSArray *tfs = @[_mtfTieuDe, _mtfTaiKhoanNhanQua, _mtfMaThe, _mtfSoSeriThe, _mtfThoiGianTangQua];
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
    
    if(self.mtfNoiDung.text.length == 0)
    {
        [self.mtfNoiDung validate];
        [self.mtfNoiDung show_error];
        return false;
    }
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return NO;
    }
    return flg;
}

- (void)xuLyThucHienKhiKiemTraThanhCongTraVeToken:(NSString*)sToken otp:(NSString*)sOtp
{
    self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_TAO_QUA_TANG;
    NSString *sTieuDe = _mtfTieuDe.text;
    self.mItemQuaTang.mName.content = sTieuDe;
    NSString *sMessage = [NSString stringWithFormat:@"%@. %@: %@. %@: %@", _mtvNoiDung.text, [@"ma_the_cao" localizableString], _mtfMaThe.text, [@"so_seri_the" localizableString], _mtfSoSeriThe.text];
    self.mItemQuaTang.mMessage.content = sMessage;
    NSString *sTaiKhoanNhan = self.mtfTaiKhoanNhanQua.text;
    long milisecondThoiGianTangQua = [self.mdtThoiGianTangQua timeIntervalSince1970] * 1000;

    [GiaoDichMang ketNoiTaoKhuyenMaiDen:sTaiKhoanNhan
                               thoiGian:milisecondThoiGianTangQua
                                 soTien:0
                         sTieuDeQuaTang:self.mItemQuaTang.mName.content
                               sLoiChuc:self.mItemQuaTang.mMessage.content
                                 idIcon:[self.mItemQuaTang.mId intValue]
                                  token:sToken
                                    otp:sOtp
                       typeAuthenticate:self.mTypeAuthenticate
                          noiNhanKetQua:self];
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


#pragma mark - xuLySuKien

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




#pragma mark - suKien
- (IBAction)suKienBamNutChonThoiGianTangQua:(id)sender
{
    ThoiDiemTangQuaViewController *thoiDiemTangQuaViewController = [[ThoiDiemTangQuaViewController alloc] initWithNibName:@"ThoiDiemTangQuaViewController" bundle:nil];
    thoiDiemTangQuaViewController.mDelegate = self;
    [self.navigationController pushViewController:thoiDiemTangQuaViewController animated:YES];
    [thoiDiemTangQuaViewController release];
}

- (IBAction)suKienBamNutDanhBa:(UIButton *)sender
{
    ContactScreen *danhBa = [[[ContactScreen alloc] initWithNibName:@"ContactScreen" bundle:nil] autorelease];
    danhBa.mKieuHienThiLienHe = KIEU_HIEN_THI_LIEN_HE_THUONG;
    [self.navigationController pushViewController:danhBa animated:YES];
    __block ChiTietTangQuaTheDienThoaiViewController *weakSelf = self;
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

- (IBAction)suKienThayDoiGiaTriTieuDe:(id)sender
{
    NSString *sTieuDe = self.mtfTieuDe.text;
    self.mlblTieuDe.text = sTieuDe;
}

- (IBAction)suKienThayDoiGiaTriMaThe:(id)sender
{
    NSString *sMaThe = self.mtfMaThe.text;
    self.mlblMaThe.text = sMaThe;
}

- (IBAction)suKienThayDoiSoSeri:(id)sender
{
    NSString *sSoseri = self.mtfSoSeriThe.text;
    self.mlblSoSeriThe.text = sSoseri;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    [self.mtvNoiDung textViewDidChange:textView];
    NSString *sNoiDung = self.mtvNoiDung.text;
    self.mlblNoiDungQuaTang.text = sNoiDung;
}


#pragma mark - ThoiDiemTangQuaViewControllerDelegate

- (void)suKienChonThoiDiemTangQua:(NSDate*)date
{
    self.mdtThoiGianTangQua = date;
    [self capNhatThoiGianTangQua];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - dealloc

- (void)dealloc
{
    if(_mMaSoThe)
        [_mMaSoThe release];
    if(_mSoSeriThe)
        [_mSoSeriThe release];
    if(_mdtThoiGianTangQua)
        [_mdtThoiGianTangQua release];
    if(_mItemQuaTang)
        [_mItemQuaTang release];
    [_mtfTieuDe release];
    [_mtfTaiKhoanNhanQua release];
    [_mtfMaThe release];
    [_mtfSoSeriThe release];
    [_mtvNoiDung release];
    [_mtfThoiGianTangQua release];
    [_mimgvHienThi release];
    [_mlblTieuDe release];
    [_mlblMaThe release];
    [_mlblSoSeriThe release];
    [_mlblNoiDungQuaTang release];
    [_mscrvHienThi release];
    [_mtfNoiDung release];
    [super dealloc];
}
@end
