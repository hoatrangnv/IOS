//
//  DucNT_SaoKe_ViewChiTiet.m
//  ViMASS
//
//  Created by MacBookPro on 7/11/14.
//
//

#import "DucNT_SaoKe_ViewChiTiet.h"
#import "DucNT_SaoKeObject.h"
#import "DucNT_LuuRMS.h"
#import "Alert+Block.h"
#import "Common.h"
#import "JSONKit.h"
#import "UmiTextView.h"

@implementation DucNT_SaoKe_ViewChiTiet{
    UmiTextView *edNoiDungKhieuNai;
    UIButton *btnGuiKhieuNai;
}

@synthesize lbAmount;
@synthesize lbFromAcc;
@synthesize lbToAcc;
@synthesize lbTime;
@synthesize tvDescrip;
@synthesize viewMain;

#pragma mark - init
- (IBAction)suKienBamGuiKhieuNai:(id)sender {
    [self capNhatGiaoDienKhieuNai];
}

- (IBAction)suKienBamNutClose:(id)sender {
    if (edNoiDungKhieuNai && [edNoiDungKhieuNai superview]){
        [viewMain setFrame:CGRectMake(viewMain.frame.origin.x, viewMain.frame.origin.y, viewMain.frame.size.width, viewMain.frame.size.height - 135)];
        [edNoiDungKhieuNai.textfield removeFromSuperview];
        [edNoiDungKhieuNai removeFromSuperview];
        [btnGuiKhieuNai removeFromSuperview];
        [_scrMain setContentSize:CGSizeMake(_scrMain.frame.size.width, viewMain.frame.size.height)];
    }
    [self removeFromSuperview];
}

-(id)initWithNib
{
    self = [[[[NSBundle mainBundle] loadNibNamed:@"DucNT_SaoKe_ViewChiTiet" owner:self options:nil] objectAtIndex:0] retain];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.viewLoading.hidden = YES;
    [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.75]];
    [viewMain.layer setCornerRadius:4];
    [viewMain.layer setMasksToBounds:YES];
    lbFromAcc.text = [@"tu" localizableString];
    lbToAcc.text = [@"den" localizableString];
    lbAmount.text = [@"so_tien_giao_dich" localizableString];
    lbTime.text = [@"thoi_diem_giao_dich" localizableString];
    tvDescrip.text = [@"place_holder_noi_dung" localizableString];
}

- (void)dealloc {
    if(_mXauHTMLGuiVeMail)
        [_mXauHTMLGuiVeMail release];
    if(_mThongTinTaiKhoan)
        [_mThongTinTaiKhoan release];
    if(lbFromAcc)
        [lbFromAcc release];
    if(lbToAcc)
        [lbToAcc release];
    if(lbAmount)
        [lbAmount release];
    if(lbTime)
        [lbTime release];
    if(tvDescrip)
        [tvDescrip release];
    if(viewMain)
        [viewMain release];
    if (edNoiDungKhieuNai) {
        [edNoiDungKhieuNai release];
    }
    if (btnGuiKhieuNai) {
        [btnGuiKhieuNai release];
    }
    [_mlblSoPhi release];
    [_mViewSoPhi release];
    [_mViewThoiGian release];
    [_mViewSoTien release];
    [_mtfTenNguoiThuHuong release];
    [_mtfTenVietTatNganHang release];
    [_mViewTenNHVietTat release];
    [_mViewTenNguoiThuHuong release];
    [_ViewDen release];
    [_mViewSoTien_ release];
    [_mlblSoDu release];
    [_mViewThoiDiemVaSoDuVi release];
    [_mViewTieuDe release];
    [_mbtnGuiMailVeThuDienTu release];
    [_mViewGuiKhieuNai release];
    [_scrMain release];
    [_webNoiDung release];
    [_viewLoading release];
    [super dealloc];
}

- (void)setMThongTinTaiKhoan:(DucNT_TaiKhoanViObject *)mThongTinTaiKhoan
{
    if(_mThongTinTaiKhoan)
        [_mThongTinTaiKhoan release];
    _mThongTinTaiKhoan = [mThongTinTaiKhoan retain];
//    CGRect rtfSoDuVi = _mlblSoDu.frame;
//    CGRect rViewThoiDiem = _mViewThoiDiemVaSoDuVi.frame;
//    CGRect rViewThoiGian = _mViewThoiGian.frame;
//    CGRect rViewMain = viewMain.frame;
//    CGRect rbtnGuiMail = _mbtnGuiMailVeThuDienTu.frame;

    if([_mThongTinTaiKhoan kiemTraCoThuDienTu])
    {
        //Co mail
        [_mbtnGuiMailVeThuDienTu setHidden:NO];
//        rbtnGuiMail.origin.y = rtfSoDuVi.size.height + rtfSoDuVi.origin.y;
//        rViewThoiDiem.size.height = rbtnGuiMail.origin.y + rbtnGuiMail.size.height;
        [_mbtnGuiMailVeThuDienTu setTitle:[NSString stringWithFormat:@"Gửi mail về %@", [_mThongTinTaiKhoan layThuDienTu]] forState:UIControlStateNormal];
    }
    else
    {
        //Khong co mail
        [_mbtnGuiMailVeThuDienTu setHidden:YES];
//        rViewThoiDiem.size.height = rtfSoDuVi.origin.y + rtfSoDuVi.size.height;
    }
    
//    rViewThoiGian.size.height = rViewThoiDiem.origin.y + rViewThoiDiem.size.height;
//    rViewMain.size.height = rViewThoiGian.size.height + rViewThoiGian.origin.y;
//    
//    _mlblSoDu.frame = rtfSoDuVi;
//    _mViewThoiDiemVaSoDuVi.frame = rViewThoiDiem;
//    _mViewThoiGian.frame = rViewThoiGian;
//    viewMain.frame = rViewMain;
//    _mbtnGuiMailVeThuDienTu.frame = rbtnGuiMail;
}

#pragma mark - update info view

- (IBAction)suKienBamNutGuiMailVeThuDienTu:(id)sender {
    [GiaoDichMang ketNoiGuiMailSaoKeDen:[self.mThongTinTaiKhoan layThuDienTu]
                             tieuDeMail:@"Sao kê giao dịch ví điện tử"
                                noiDung:self.mXauHTMLGuiVeMail
                          noiNhanKetQua:self];
}


-(void)updateView:(NSString *)sFromAcc toAcc:(NSString *)sToAcc withAmount:(NSString *)sAmount withTime:(NSString *)sTime withDesc:(NSString *)sDescrip
{
    lbFromAcc.text = [NSString stringWithFormat:@"%@: %@", [@"tu" localizableString], sFromAcc];
    lbToAcc.text = [NSString stringWithFormat:@"%@: %@", [@"den" localizableString], sToAcc];
    lbAmount.text = [NSString stringWithFormat:@"%@: %@", [@"so_tien_giao_dich" localizableString], sAmount];
    lbTime.text = [NSString stringWithFormat:@"%@: %@", [@"thoi_diem_giao_dich" localizableString], sTime];
    tvDescrip.text = [NSString stringWithFormat:@"%@ %@", [@"sk noi dung" localizableString], sDescrip];
}

-(void)updateView:(DucNT_SaoKeObject*)item
{
    NSString *sDenTK = @"";
    NSString *sTenNguoiThuHuong = @"";
    NSString *sTenVietTat = @"";
    
    NSMutableString *sXauTraVe = [[NSMutableString alloc] init];
    
    if(item.bankShortName && item.bankAcc && item.bankShortName.length > 0 && item.bankAcc.length > 0)
    {
        //tk ngan hang
        if(item.nameUsed && item.nameUsed.length > 0)
        {
            NSString *idVi = [DucNT_LuuRMS layThongTinTaiKhoanVi].sID;
            if([item.fromAcc hasPrefix:idVi])
            {
                sDenTK = item.nameUsed;
                sTenNguoiThuHuong = item.nameBenefit;
            }
            else
            {
                sDenTK = item.nameBenefit;
            }
        }
        else
        {
            sDenTK = item.nameBenefit;
        }
        sTenVietTat = [NSString stringWithFormat:@"%@ %@", item.bankShortName, item.bankAcc];
    }
    else if(item.bankAcc && item.bankAcc.length > 0)
    {
        //The ngan hang
        if(item.nameUsed && item.nameUsed.length > 0)
        {
            NSString *idVi = [DucNT_LuuRMS layThongTinTaiKhoanVi].sID;
            if([item.fromAcc hasPrefix:idVi])
            {
                sDenTK = item.nameUsed;
                sTenNguoiThuHuong = item.bankAcc;
            }
            else
            {
                sDenTK = item.bankAcc;
            }
        }
        else
        {
            sDenTK = item.bankAcc;
        }
    }
    else
    {
        //Den vi
        if(item.nameUsed && item.nameUsed.length > 0)
        {
            NSString *idVi = [DucNT_LuuRMS layThongTinTaiKhoanVi].sID;
            if([item.fromAcc hasPrefix:idVi])
            {
                sDenTK = item.nameUsed;
                sTenNguoiThuHuong = item.toAcc;
            }
            else
            {
                sDenTK = item.toAcc;
            }
        }
        else
        {
            sDenTK = item.toAcc;
        }
    }

    if([item.type integerValue] == 3)
    {
        lbFromAcc.text = [NSString stringWithFormat:@"%@: %@", [@"qua_tang_tang" localizableString], item.fromAcc];
    }
    else
    {
        lbFromAcc.text = [NSString stringWithFormat:@"%@: %@", [@"tu" localizableString], item.fromAcc];
    }

    lbToAcc.text = [NSString stringWithFormat:@"%@: %@", [@"den" localizableString], sDenTK];
    
    
    NSString *sAmount = @"";
    NSString *sSoDu = @"";
    NSString *idVi = [DucNT_LuuRMS layThongTinTaiKhoanVi].sID;
    if([item.fromAcc hasPrefix:idVi])
    {
        sAmount = [NSString stringWithFormat:@"%@: - %@ đ", [@"so_tien_giao_dich" localizableString], [Common hienThiTienTe:[item.amount doubleValue]]];
        if([item.type intValue] != 4)
        {
            // so du vi
            sSoDu = [NSString stringWithFormat:@"%@%@: %@ đ", [@"inquiry_balance_value" localizableString], [@"tao_tai_khoan_thuong_dung_vi" localizableString], [Common hienThiTienTe:[item.totalAmount doubleValue]]];
        }
        else
        {
            // so du km
            sSoDu = [NSString stringWithFormat:@"%@%@: %@ đ", [@"inquiry_balance_value" localizableString], [@"TKKM" localizableString], [Common hienThiTienTe:[item.totalPromotion doubleValue]]];
        }
    }
    else
    {
        sAmount = [NSString stringWithFormat:@"%@: +%@ đ", [@"so_tien_giao_dich" localizableString], [Common hienThiTienTe:[item.amount doubleValue]]];
        if([item.type intValue] != 4)
        {
            // so du vi
            sSoDu = [NSString stringWithFormat:@"%@%@: %@ đ", [@"inquiry_balance_value" localizableString], [@"tao_tai_khoan_thuong_dung_vi" localizableString], [Common hienThiTienTe:[item.totalAmountToAcc doubleValue]]];
        }
        else
        {
            // so du km
            sSoDu = [NSString stringWithFormat:@"%@%@: %@", [@"inquiry_balance_value" localizableString], [@"TKKM" localizableString], [Common hienThiTienTe_1:[item.totalPromotionToAcc doubleValue]]];
        }
    }

    self.mlblSoDu.text = sSoDu;
    lbAmount.text = sAmount;
    lbTime.text = [NSString stringWithFormat:@"%@: %@", [@"thoi_diem_giao_dich" localizableString],  [item layThoiGianChuyenTien]];
    self.mlblSoPhi.text = [NSString stringWithFormat:@"%@: %@ đ", [@"phi_chuyen_tien" localizableString], [Common hienThiTienTe:[item.feeAmount doubleValue]]];
    
    
//    if([item.type intValue] != 3 && [item.type intValue] != 4)
//        tvDescrip.text = [NSString stringWithFormat:@"%@ %@", [@"sk noi dung" localizableString], [item layNoiDung]];
//    else
//        tvDescrip.text = [NSString stringWithFormat:@"%@ %@ : %@", [@"sk noi dung" localizableString], [item layNoiDung], [item layGiftName]];
    NSString *sDes = @"";
    if([item.type intValue] != 3 && [item.type intValue] != 4)
        sDes = [NSString stringWithFormat:@"%@ %@", [@"sk noi dung" localizableString], [item layNoiDung]];
    else
        sDes = [NSString stringWithFormat:@"%@ %@ : %@", [@"sk noi dung" localizableString], [item layNoiDung], [item layGiftName]];
    //Tu
    [sXauTraVe appendFormat:@"%@ <br/>",lbFromAcc.text];
    //Den
    [sXauTraVe appendFormat:@"%@ <br/>",lbToAcc.text];
    if(sTenNguoiThuHuong.length > 0)
        [sXauTraVe appendFormat:@"%@<br/>",sTenNguoiThuHuong];
    if(sTenVietTat.length > 0)
        [sXauTraVe appendFormat:@"%@<br/>",sTenVietTat];
    //soTien
    [sXauTraVe appendFormat:@"%@<br/>", lbAmount.text];
    //sophi
    [sXauTraVe appendFormat:@"%@<br/>", _mlblSoPhi.text];
    //noidung
    [sXauTraVe appendFormat:@"%@<br/>",sDes];

    [_webNoiDung loadHTMLString:sXauTraVe baseURL:nil];
    
    //thoiDiem
    [sXauTraVe appendFormat:@"%@<br/>", lbTime.text];
    //soDu
    [sXauTraVe appendFormat:@"%@<br/>", _mlblSoDu.text];
    
    [self.mtfTenNguoiThuHuong setText:sTenNguoiThuHuong];
    [self.mtfTenVietTatNganHang setText:sTenVietTat];
    [self hienThiTenNguoiThuHuong:sTenNguoiThuHuong tenVietTat:sTenVietTat];
//    [self hienThiViewSoPhi:[item.feeAmount doubleValue]];
//    [self tinhToanLaiDoRongDoCao];

    self.mXauHTMLGuiVeMail = sXauTraVe;
    NSLog(@"%s - %s : mXauHTMLGuiVeMail : %@", __FILE__, __FUNCTION__, self.mXauHTMLGuiVeMail);
    [sXauTraVe release];
}

- (void)hienThiTenNguoiThuHuong:(NSString*)sTenNguoiThuHuong tenVietTat:(NSString*)sTenVietTatNganHang
{
    NSLog(@"ChiTietSaoKe : hienThiTenNguoiThuHuong : START");
    CGRect rViewSoPhi = _mViewSoPhi.frame;
    CGRect rViewThoiGian = _mViewThoiGian.frame;
    CGRect rViewMain = viewMain.frame;
    
    CGRect rViewSoTien = _mViewSoTien.frame;
    CGRect rViewDen = _ViewDen.frame;
    CGRect rViewSoTien_ = _mViewSoTien_.frame;
    CGRect rViewNguoiThuHuong = _mViewTenNguoiThuHuong.frame;
    CGRect rViewTenVietTat = _mViewTenNHVietTat.frame;
    
    if(sTenNguoiThuHuong.length > 0 && sTenVietTatNganHang.length > 0)
    {
        [_mViewTenNguoiThuHuong setHidden:NO];
        [_mViewTenNHVietTat setHidden:NO];
        rViewNguoiThuHuong.origin.y = rViewDen.origin.y + rViewDen.size.height;
        rViewTenVietTat.origin.y = rViewNguoiThuHuong.origin.y + rViewNguoiThuHuong.size.height;
        rViewSoTien_.origin.y = rViewTenVietTat.origin.y + rViewTenVietTat.size.height;

    }
    else if (sTenNguoiThuHuong.length > 0)
    {
        [_mViewTenNguoiThuHuong setHidden:NO];
        [_mViewTenNHVietTat setHidden:YES];
        rViewNguoiThuHuong.origin.y = rViewDen.origin.y + rViewDen.size.height;
        rViewSoTien_.origin.y = rViewNguoiThuHuong.origin.y + rViewNguoiThuHuong.size.height;
    }
    else if (sTenVietTatNganHang.length > 0)
    {
        [_mViewTenNguoiThuHuong setHidden:YES];
        [_mViewTenNHVietTat setHidden:NO];
        rViewTenVietTat.origin.y = rViewDen.origin.y + rViewDen.size.height;
        rViewSoTien_.origin.y = rViewTenVietTat.origin.y + rViewTenVietTat.size.height;
    }
    else
    {
        [_mViewTenNguoiThuHuong setHidden:YES];
        [_mViewTenNHVietTat setHidden:YES];
        rViewSoTien_.origin.y = rViewDen.origin.y + rViewDen.size.height;
    }
    
    rViewSoTien.size.height = rViewSoTien_.origin.y + rViewSoTien_.size.height;
    
    _mViewSoPhi.frame = rViewSoPhi ;
    _mViewThoiGian.frame = rViewThoiGian;
    viewMain.frame = rViewMain;
    _mViewSoTien.frame = rViewSoTien;
    _ViewDen.frame = rViewDen;
    _mViewSoTien_.frame = rViewSoTien_;
    _mViewTenNguoiThuHuong.frame = rViewNguoiThuHuong;
    _mViewTenNHVietTat.frame = rViewTenVietTat;
}

- (void)hienThiViewSoPhi:(double)fSoPhi
{
    NSLog(@"ChiTietSaoKe : hienThiViewSoPhi : START");
    CGRect rViewSoTien = self.mViewSoTien.frame;
    CGRect rViewSoPhi = self.mViewSoPhi.frame;
    CGRect rViewThoiGian = self.mViewThoiGian.frame;
    CGRect rViewMain = self.viewMain.frame;
    if(fSoPhi > 0)
    {
        [self.mViewSoPhi setHidden:NO];
        rViewSoPhi.origin.y = rViewSoTien.origin.y + rViewSoTien.size.height;
        rViewThoiGian.origin.y = rViewSoPhi.origin.y + rViewSoPhi.size.height;
        rViewMain.size.height = rViewThoiGian.origin.y + rViewThoiGian.size.height + 10;
    }
    else
    {
        [self.mViewSoPhi setHidden:YES];
        rViewThoiGian.origin.y = rViewSoTien.origin.y + rViewSoTien.size.height;
//        rViewThoiGian.origin.y = rViewSoPhi.origin.y;
        rViewMain.size.height = rViewThoiGian.origin.y + rViewThoiGian.size.height + 10;
    }
    self.mViewSoPhi.frame = rViewSoPhi;
    self.mViewThoiGian.frame = rViewThoiGian;
    self.viewMain.frame = rViewMain;
    [self setNeedsDisplay];
}

- (void)tinhToanLaiDoRongDoCao
{
    NSLog(@"ChiTietSaoKe : tinhToanLaiDoRongDoCao : START");
    float fDoCaoTextView = 0.0f;
    float fCanhLeTren = 10.0f;
    float fHeightPhanConLai = 288.0f;
    float fMinTextView = 30.0f;
    float fMaxTextView = self.bounds.size.height - fCanhLeTren - fHeightPhanConLai - 80;
    NSString *sText = tvDescrip.text;
    CGSize textViewSize = [sText sizeWithFont:[UIFont systemFontOfSize:18.0]
                            constrainedToSize:CGSizeMake(_mViewThoiDiemVaSoDuVi.frame.size.width, FLT_MAX)
                                lineBreakMode:NSLineBreakByTruncatingTail];
//    NSLog(@"ChiTietSaoKe : tinhToanLaiDoRongDoCao : fMaxTextView : %f", fMaxTextView);
//    NSLog(@"ChiTietSaoKe : tinhToanLaiDoRongDoCao : textViewSize.height : %f", textViewSize.height);
    if(textViewSize.height < fMinTextView)
    {
        fDoCaoTextView = fMinTextView;
    }
    else if (textViewSize.height > fMaxTextView)
    {
        fDoCaoTextView = fMaxTextView;
    }
    else
    {
        fDoCaoTextView = textViewSize.height + 10;
    }
    
    CGRect rtvDes = tvDescrip.frame;
    rtvDes.size = CGSizeMake(_mViewThoiDiemVaSoDuVi.frame.size.width, fDoCaoTextView);
    CGRect rViewThoiDiemVaSoDu = _mViewThoiDiemVaSoDuVi.frame;
    rViewThoiDiemVaSoDu.origin.y = rtvDes.origin.y + rtvDes.size.height;
    CGRect rViewThoiGian = _mViewThoiGian.frame;
    rViewThoiGian.size.height = rViewThoiDiemVaSoDu.origin.y + rViewThoiDiemVaSoDu.size.height + 30;

    CGRect rViewMain = viewMain.frame;
    rViewMain.size.height = rViewThoiGian.origin.y + rViewThoiGian.size.height + 20;
    rViewMain.origin.y = (self.frame.size.height - rViewMain.size.height) / 2;
    NSLog(@"%s - %s : y : %f", __FILE__, __FUNCTION__, rViewMain.origin.y);
    if (rViewMain.origin.y > 20) {
        rViewMain.origin.y = 20;
    }
    viewMain.frame = rViewMain;
    _mViewThoiGian.frame = rViewThoiGian;
    _mViewThoiDiemVaSoDuVi.frame = rViewThoiDiemVaSoDu;
    tvDescrip.frame = rtvDes;
    
    [_mViewGuiKhieuNai setFrame:CGRectMake(_mViewGuiKhieuNai.frame.origin.x, rViewMain.size.height - _mViewGuiKhieuNai.frame.size.height - 5, _mViewGuiKhieuNai.frame.size.width, _mViewGuiKhieuNai.frame.size.height)];
}

#pragma mark - DucNT_ServicePostDelegate

- (void)ketNoiThanhCong:(NSString *)sKetQua
{
    self.viewLoading.hidden = YES;
    NSDictionary *dict = [sKetQua objectFromJSONString];
    NSString *sMessage = [dict objectForKey:@"msgContent"];
    [UIAlertView alert:sMessage withTitle:@"Thông báo" block:nil];
}

#pragma mark - touch event
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if([touch view] != self.tvDescrip)
    {
        [self removeFromSuperview];
        if (edNoiDungKhieuNai && [edNoiDungKhieuNai superview]){
            [viewMain setFrame:CGRectMake(viewMain.frame.origin.x, viewMain.frame.origin.y, viewMain.frame.size.width, viewMain.frame.size.height - 135)];
            [edNoiDungKhieuNai.textfield removeFromSuperview];
            [edNoiDungKhieuNai removeFromSuperview];
            [btnGuiKhieuNai removeFromSuperview];
            [_scrMain setContentSize:CGSizeMake(_scrMain.frame.size.width, viewMain.frame.size.height)];
        }
    }
}

- (void)capNhatGiaoDienKhieuNai{
    NSLog(@"SaoKeViewChiTiet : capNhatGiaoDienKhieuNai : START");
    int nHeight = 85;
    if (!edNoiDungKhieuNai || ![edNoiDungKhieuNai superview]) {
        [viewMain setFrame:CGRectMake(viewMain.frame.origin.x, viewMain.frame.origin.y, viewMain.frame.size.width, viewMain.frame.size.height + nHeight + 50)];
        if (!edNoiDungKhieuNai) {
            CGRect rectMain = viewMain.frame;
            edNoiDungKhieuNai = [[UmiTextView alloc] initWithFrame:CGRectMake(rectMain.origin.x + 5, rectMain.size.height - nHeight - 45, rectMain.size.width - 10, nHeight)];
            [edNoiDungKhieuNai setBackgroundColor:[UIColor clearColor]];
            UITextField *exTemp = [[UITextField alloc] initWithFrame:CGRectMake(edNoiDungKhieuNai.frame.origin.x, edNoiDungKhieuNai.frame.origin.y, edNoiDungKhieuNai.frame.size.width, edNoiDungKhieuNai.frame.size.height + 3)];
            [exTemp setPlaceholder:@"Nội dung khiếu nại"];
            [edNoiDungKhieuNai becomeFirstResponder];
            [edNoiDungKhieuNai setTextfield:exTemp];
            edNoiDungKhieuNai.layer.borderColor = [UIColor blackColor].CGColor;
            edNoiDungKhieuNai.layer.borderWidth = 1.0f;
            btnGuiKhieuNai = [[UIButton alloc] initWithFrame:CGRectMake(rectMain.origin.x + 5, rectMain.size.height - 39, rectMain.size.width - 10, 35)];
            [btnGuiKhieuNai addTarget:self action:@selector(suKienBamGuiNoiDungKhieuNai:) forControlEvents:UIControlEventTouchUpInside];
            [btnGuiKhieuNai setTitle:@"Gửi khiếu nại" forState:UIControlStateNormal];
            [btnGuiKhieuNai setBackgroundColor:[UIColor blueColor]];
        }
        [viewMain addSubview:edNoiDungKhieuNai.textfield];
        [viewMain addSubview:edNoiDungKhieuNai];
        [viewMain addSubview:btnGuiKhieuNai];
        [_scrMain setContentSize:CGSizeMake(_scrMain.frame.size.width, viewMain.frame.size.height + viewMain.frame.origin.y)];
    }
    else if (edNoiDungKhieuNai && [edNoiDungKhieuNai superview]){
        [viewMain setFrame:CGRectMake(viewMain.frame.origin.x, viewMain.frame.origin.y, viewMain.frame.size.width, viewMain.frame.size.height - nHeight - 50)];
        [edNoiDungKhieuNai.textfield removeFromSuperview];
        [edNoiDungKhieuNai removeFromSuperview];
        [btnGuiKhieuNai removeFromSuperview];
        [_scrMain setContentSize:CGSizeMake(_scrMain.frame.size.width, viewMain.frame.size.height)];
    }
    
}

- (void)suKienBamGuiNoiDungKhieuNai:(id)sender{
    [edNoiDungKhieuNai endEditing:YES];
    self.viewLoading.hidden = NO;
    NSString *sNoiDung = @"Người gửi: %@<br/>Email: %@<br/>SDT: %@<br/>Khiếu nại: %@<br/>%@";
    sNoiDung = [NSString stringWithFormat:sNoiDung, _mThongTinTaiKhoan.sNameAlias, [_mThongTinTaiKhoan layThuDienTu], _mThongTinTaiKhoan.sPhone, edNoiDungKhieuNai.text, self.mXauHTMLGuiVeMail];
    NSLog(@"%s - %s : sNoiDung : %@", __FILE__, __FUNCTION__, sNoiDung);
    [GiaoDichMang ketNoiGuiMailSaoKeDen:@"hotro@vimass.vn"
                             tieuDeMail:@"Khiếu nại giao dịch Ví điện tử"
                                noiDung:sNoiDung
                          noiNhanKetQua:self];
}

@end
