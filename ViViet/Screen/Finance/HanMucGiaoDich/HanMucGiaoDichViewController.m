//
//  ViewController.m
//  ViViMASS
//
//  Created by DucBT on 2/7/15.
//
//

#import "HanMucGiaoDichViewController.h"
#import "HanMucGiaoDich.h"
#import "DucNT_ServicePost.h"
#import "GioiHanGiaoDich.h"
#import "GiaoDienThongTinPhim.h"


@interface HanMucGiaoDichViewController () <DucNT_ServicePostDelegate>
{
    NSTimer *mTimer;
    NSString *mDinhDanhKetNoi;
    int mTypeAuthenticate;
    BOOL mXacThucVanTay;
}

@property (assign, nonatomic) NSInteger mTongSoThoiGian;
@property (nonatomic, retain) HanMucGiaoDich *mHanMucGiaoDich;

@end

@implementation HanMucGiaoDichViewController
@synthesize mbtnVanTay;

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self khoiTaoBanDau];
    [self khoiTaoGiaoDien];
    [self khoiTaoGiaoDienChuyenTien];
    [self xuLyKetNoiLayHanMucGiaoDich];
    [self themButtonHuongDanSuDung:@selector(huongDanSuDungHanMuc:)];
}

- (void)huongDanSuDungHanMuc:(UIButton *)btn {
    GiaoDienThongTinPhim *vc = [[GiaoDienThongTinPhim alloc] initWithNibName:@"GiaoDienThongTinPhim" bundle:nil];
    vc.nOption = HUONG_DAN_DOI_HAN_MUC;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([self.mThongTinTaiKhoanVi.nIsToken intValue] > 0)
    {
        [self suKienBamNutToken:self.mbtnToken];
    }
}

#pragma mark - khoi Tao

- (void)khoiTaoBanDau
{
    [self addButtonBack];
//    self.title = [@"han_muc_giao_dich_1" localizableString];
    [self addTitleView:[@"han_muc_giao_dich_1" localizableString]];
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect rectMain = self.mViewMain.frame;
        rectMain.size.width = self.mScrollview.frame.size.width;
        self.mViewMain.frame = rectMain;
        [self.mScrollview setContentSize:CGSizeMake(self.mViewMain.frame.size.width, self.mViewMain.frame.size.height)];
        [self.mScrollview addSubview:self.mViewMain];
        [self.mViewMain2.layer setCornerRadius:4.0f];
        [self.mViewMain2.layer setMasksToBounds:YES];
    });
    mXacThucVanTay = NO;
}

- (void)khoiTaoGiaoDien
{
    NSString *sHanMucGiaoDichMotLan = [@"han_muc_giao_dich_mot_lan" localizableString];
    NSString *sHanMucGiaoDichMotNgay = [@"han_muc_giao_dich_mot_ngay" localizableString];
    NSString *sHanMucGiaoDichMotThang = [@"han_muc_giao_dich_mot_thang" localizableString];
    NSString *sVoi = [@"voi" localizableString];
    NSString *sKhongDuocBoTrong = [@"khong_duoc_bo_trong" localizableString];
    NSString *sTaiKhoan = [@"tao_tai_khoan_thuong_dung_tai_khoan" localizableString];
    NSString *sVi = [@"tao_tai_khoan_thuong_dung_vi" localizableString];
    NSString *sThe = [@"tao_tai_khoan_thuong_dung_the" localizableString];
    
    
    [_mtfHanMucGiaoDichMotLanVoiTKNganHang setPlaceholder:[@"han_muc_giao_dich_so_tien" localizableString]];
    [_mtfHanMucGiaoDichMotLanVoiTKNganHang setTextError:[NSString stringWithFormat:@"%@ %@ %@ %@", sHanMucGiaoDichMotLan, sVoi, sTaiKhoan, sKhongDuocBoTrong] forType:ExTextFieldTypeEmpty];
    _mtfHanMucGiaoDichMotLanVoiTKNganHang.inputAccessoryView = nil;
    
    [_mtfHanMucGiaoDichMotNgayVoiTKNganHang setPlaceholder:[@"han_muc_giao_dich_so_tien" localizableString]];
    [_mtfHanMucGiaoDichMotNgayVoiTKNganHang setTextError:[NSString stringWithFormat:@"%@ %@ %@ %@", sHanMucGiaoDichMotNgay, sVoi, sTaiKhoan, sKhongDuocBoTrong] forType:ExTextFieldTypeEmpty];
    _mtfHanMucGiaoDichMotNgayVoiTKNganHang.inputAccessoryView = nil;
    
    [_mtfHanMucGiaoDichMotThangVoiTKNganHang setPlaceholder:[@"han_muc_giao_dich_so_tien" localizableString]];
    [_mtfHanMucGiaoDichMotThangVoiTKNganHang setTextError:[NSString stringWithFormat:@"%@ %@ %@ %@", sHanMucGiaoDichMotThang, sVoi, sTaiKhoan, sKhongDuocBoTrong] forType:ExTextFieldTypeEmpty];
    _mtfHanMucGiaoDichMotThangVoiTKNganHang.inputAccessoryView = nil;
    
    [_mtfHanMucGiaoDichMotLanVoiTKThe setPlaceholder:[@"han_muc_giao_dich_so_tien" localizableString]];
    [_mtfHanMucGiaoDichMotLanVoiTKThe setTextError:[NSString stringWithFormat:@"%@ %@ %@ %@", sHanMucGiaoDichMotLan, sVoi, sThe, sKhongDuocBoTrong] forType:ExTextFieldTypeEmpty];
    _mtfHanMucGiaoDichMotLanVoiTKThe.inputAccessoryView = nil;
    
    [_mtfHanMucGiaoDichMotNgayVoiTKThe setPlaceholder:[@"han_muc_giao_dich_so_tien" localizableString]];
    [_mtfHanMucGiaoDichMotNgayVoiTKThe setTextError:[NSString stringWithFormat:@"%@ %@ %@ %@", sHanMucGiaoDichMotNgay, sVoi, sThe, sKhongDuocBoTrong] forType:ExTextFieldTypeEmpty];
    _mtfHanMucGiaoDichMotNgayVoiTKThe.inputAccessoryView = nil;
    
    [_mtfHanMucGiaoDichMotThangVoiTKThe setPlaceholder:[@"han_muc_giao_dich_so_tien" localizableString]];
    [_mtfHanMucGiaoDichMotThangVoiTKThe setTextError:[NSString stringWithFormat:@"%@ %@ %@ %@", sHanMucGiaoDichMotThang, sVoi, sThe, sKhongDuocBoTrong] forType:ExTextFieldTypeEmpty];
    _mtfHanMucGiaoDichMotThangVoiTKThe.inputAccessoryView = nil;
    
    [_mtfHanMucGiaoDichMotLanVoiVi setPlaceholder:[@"han_muc_giao_dich_so_tien" localizableString]];
    [_mtfHanMucGiaoDichMotLanVoiVi setTextError:[NSString stringWithFormat:@"%@ %@ %@ %@", sHanMucGiaoDichMotLan, sVoi, sVi, sKhongDuocBoTrong] forType:ExTextFieldTypeEmpty];
    _mtfHanMucGiaoDichMotLanVoiVi.inputAccessoryView = nil;
    
    [_mtfHanMucGiaoDichMotNgayVoiVi setPlaceholder:[@"han_muc_giao_dich_so_tien" localizableString]];
    [_mtfHanMucGiaoDichMotNgayVoiVi setTextError:[NSString stringWithFormat:@"%@ %@ %@ %@", sHanMucGiaoDichMotNgay, sVoi, sVi, sKhongDuocBoTrong] forType:ExTextFieldTypeEmpty];
    _mtfHanMucGiaoDichMotNgayVoiVi.inputAccessoryView = nil;
    
    [_mtfHanMucGiaoDichMotThangVoiVi setPlaceholder:[@"han_muc_giao_dich_so_tien" localizableString]];
    [_mtfHanMucGiaoDichMotThangVoiVi setTextError:[NSString stringWithFormat:@"%@ %@ %@ %@", sHanMucGiaoDichMotThang, sVoi, sVi, sKhongDuocBoTrong] forType:ExTextFieldTypeEmpty];
    _mtfHanMucGiaoDichMotThangVoiVi.inputAccessoryView = nil;
    
//    [_mbtnThucHien setTitle:[@"button_thuc_hien" localizableString] forState:UIControlStateNormal];

}

- (void)khoiTaoGiaoDienChuyenTien
{
    [self.mbtnToken setTitle:@"TOKEN" forState:UIControlStateNormal];
    [self.mbtnToken setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
    [self.mbtnSMS setTitle:@"SMS" forState:UIControlStateNormal];
    [self.mbtnSMS setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
    [self.mbtnEmail setTitle:@"EMAIL" forState:UIControlStateNormal];
    [self.mbtnEmail setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
    
    self.mbtnSMS.selected = NO;
    self.mbtnToken.selected = NO;
    self.mbtnEmail.selected = NO;
    self.mbtnEmail.enabled = YES;
    self.mbtnSMS.enabled = YES;
    self.mbtnToken.enabled = YES;
    [self.mtfMatKhauToken setText:@""];
    self.mtfMatKhauToken.max_length = 6;
    self.mtfMatKhauToken.inputAccessoryView = nil;
    self.mtfMatKhauToken.placeholder = [@"mat_khau_token" localizableString];
    [self.mtfMatKhauToken setTextError:[@"mat_khau_token_khong_dc_de_trong" localizableString]
                               forType:ExTextFieldTypeEmpty];
}

#pragma mark - suKien
- (IBAction)suKienBamNutThucHien:(id)sender
{
    if([self validate])
    {
        [self xuLyGuiHanMucGiaoDichLenServer];
    }
}

- (IBAction)suKienBamNutToken:(UIButton *)sender
{
    if([self.mThongTinTaiKhoanVi.nIsToken intValue] > 0)
    {
        if(!self.mbtnToken.selected)
        {
            mTypeAuthenticate = TYPE_AUTHENTICATE_TOKEN;
            [self.mbtnToken setSelected:YES];
            [self.mbtnToken setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            
            if(self.mbtnSMS.enabled)
            {
                [self.mbtnSMS setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
                [self.mbtnSMS setTitleColor:nil forState:UIControlStateNormal];
                [self.mbtnSMS setSelected:NO];
            }
            
            if(self.mbtnEmail.enabled)
            {
                [self.mbtnEmail setSelected:NO];
                [self.mbtnEmail setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
                [self.mbtnEmail setTitleColor:nil forState:UIControlStateNormal];
            }
            
            self.mtfMatKhauToken.placeholder = [@"mat_khau_token" localizableString];
            [self.mtfMatKhauToken setTextError:[@"mat_khau_token_khong_dc_de_trong" localizableString]
                                       forType:ExTextFieldTypeEmpty];
        }
    }
    else
    {
        [UIAlertView alert:[@"thong_bao_loi_chua_dang_ky_token" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
    }
}

- (IBAction)suKienBamNutSMS:(UIButton *)sender
{
    if(![self.mThongTinTaiKhoanVi.sPhoneAuthenticate isEqualToString:@""])
    {
        if(!self.mbtnSMS.selected && [self validateVanTay])
        {
            [self hienThiHopThoaiHaiNutBamKieu:HOP_THOAI_XAC_NHAN_XAC_THUC_SMS cauThongBao:[NSString stringWithFormat:@"%@ %@", [@"thong_bao_ma_xac_thuc_duoc_gui_ve_so_dien_thoai" localizableString], self.mThongTinTaiKhoanVi.sPhoneAuthenticate]];
        }
    }
    else
    {
        [UIAlertView alert:[@"thong_bao_chua_dang_ky_so_dien_thoai" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
    }
}

- (IBAction)suKienBamNutEmail:(UIButton *)sender
{
    if(![self.mThongTinTaiKhoanVi.sThuDienTu isEqualToString:@""])
    {
        if(!self.mbtnEmail.selected && [self validateVanTay])
        {
            [self hienThiHopThoaiHaiNutBamKieu:HOP_THOAI_XAC_NHAN_XAC_THUC_EMAIL cauThongBao:[NSString stringWithFormat:@"%@ %@", [@"thong_bao_ma_xac_thuc_duoc_gui_ve_thu_dien_tu" localizableString], self.mThongTinTaiKhoanVi.sThuDienTu]];
        }
    }
    else
    {
        [UIAlertView alert:[@"thong_bao_chua_dang_ky_thu_dien_tu" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
    }
}

- (IBAction)suKienBamNutMatKhauVanTay:(id)sender
{
    if([self validateVanTay])
    {
        [self xuLySuKienDangNhapVanTay];
    }
}

- (IBAction)suKienThayDoiGiaTriTextField:(UITextField*)sender
{
    NSString *sSoTien = [sender.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    [sender setText:[Common hienThiTienTeFromString:sSoTien]];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        if(alertView.tag == HOP_THOAI_XAC_NHAN_XAC_THUC_SMS)
        {
            [self xuLySuKienXacThucBangSMS];
        }
        else if(alertView.tag == HOP_THOAI_XAC_NHAN_XAC_THUC_EMAIL)
        {
            [self xuLySuKienXacThucBangEmail];
        }
        
    }
    else if(buttonIndex == 0)
    {
        if(alertView.tag == HOP_THOAI_XAC_NHAN_CHUYEN_TIEN_THANH_CONG)
        {
            //Xac nhan giao dichj thanh cong
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


#pragma mark - xuLy
- (void)xuLyHienThiHanMucGiaoDich
{
    if(_mHanMucGiaoDich)
    {
        for(GioiHanGiaoDich *gioiHanGiaoDich in _mHanMucGiaoDich.mDanhSachGioiHan)
        {
            if([gioiHanGiaoDich.typeTransfer intValue] == TRANSACTION_LIMIT_TO_ACCOUNT)
            {
                if (self.mThongTinTaiKhoanVi) {
                    self.mThongTinTaiKhoanVi.nHanMucDenTaiKhoan = gioiHanGiaoDich.oneTime;
                }
                self.mtfHanMucGiaoDichMotLanVoiTKNganHang.text = [Common hienThiTienTe:[gioiHanGiaoDich.oneTime doubleValue]];
                self.mtfHanMucGiaoDichMotNgayVoiTKNganHang.text = [Common hienThiTienTe:[gioiHanGiaoDich.oneDay doubleValue]];
                self.mtfHanMucGiaoDichMotThangVoiTKNganHang.text = [Common hienThiTienTe:[gioiHanGiaoDich.oneMonth doubleValue]];
            }
            else if([gioiHanGiaoDich.typeTransfer intValue] == TRANSACTION_LIMIT_TO_CARD)
            {
                if (self.mThongTinTaiKhoanVi) {
                    self.mThongTinTaiKhoanVi.nHanMucDenThe = gioiHanGiaoDich.oneTime;
                }
                self.mtfHanMucGiaoDichMotLanVoiTKThe.text = [Common hienThiTienTe:[gioiHanGiaoDich.oneTime doubleValue]];
                self.mtfHanMucGiaoDichMotNgayVoiTKThe.text = [Common hienThiTienTe:[gioiHanGiaoDich.oneDay doubleValue]];
                self.mtfHanMucGiaoDichMotThangVoiTKThe.text = [Common hienThiTienTe:[gioiHanGiaoDich.oneMonth doubleValue]];
            }
            else if([gioiHanGiaoDich.typeTransfer intValue] == TRANSACTION_LIMIT_TO_WALLET)
            {
                if (self.mThongTinTaiKhoanVi) {
                    self.mThongTinTaiKhoanVi.nHanMucDenVi = gioiHanGiaoDich.oneTime;
                }
                self.mtfHanMucGiaoDichMotLanVoiVi.text = [Common hienThiTienTe:[gioiHanGiaoDich.oneTime doubleValue]];
                self.mtfHanMucGiaoDichMotNgayVoiVi.text = [Common hienThiTienTe:[gioiHanGiaoDich.oneDay doubleValue]];
                self.mtfHanMucGiaoDichMotThangVoiVi.text = [Common hienThiTienTe:[gioiHanGiaoDich.oneMonth doubleValue]];
            }
            else if([gioiHanGiaoDich.typeTransfer intValue] == TRANSACTION_LIMIT_TO_VI_KHAC)
            {
                if (self.mThongTinTaiKhoanVi) {
                    self.mThongTinTaiKhoanVi.nHanMucDenViKhac = gioiHanGiaoDich.oneTime;
                }
                self.edChuyenTienDenViKhac.text = [Common hienThiTienTe:[gioiHanGiaoDich.oneTime doubleValue]];
            }
        }
        if (self.mThongTinTaiKhoanVi) {
            NSLog(@"%s - luu lai han muc", __FUNCTION__);
            NSLog(@"%s - luu lai han muc : den vi - %f", __FUNCTION__, [self.mThongTinTaiKhoanVi.nHanMucDenVi doubleValue]);
            NSLog(@"%s - luu lai han muc : den vi - %f", __FUNCTION__, [self.mThongTinTaiKhoanVi.nHanMucDenThe doubleValue]);
            NSLog(@"%s - luu lai han muc : den vi - %f", __FUNCTION__, [self.mThongTinTaiKhoanVi.nHanMucDenTaiKhoan doubleValue]);
            [DucNT_LuuRMS luuThongTinTaiKhoanViSauDangNhap:self.mThongTinTaiKhoanVi];
        }
    }
}

- (void)xuLySuKienXacThucBangEmail
{
    if(!self.mbtnEmail.selected)
    {
        mTypeAuthenticate = TYPE_AUTHENTICATE_EMAIL;
        [self.mbtnEmail setSelected:YES];
        [self.mbtnEmail setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        self.mTongSoThoiGian = THOI_GIAN_CHO_XAC_THUC_EMAIL;
        [self.mbtnEmail setTitle:[NSString stringWithFormat:@"%ld s", (long)self.mTongSoThoiGian] forState:UIControlStateNormal];
        [self.mbtnVanTay setHidden:YES];
        
        if(self.mbtnToken.enabled)
        {
            [self.mbtnToken setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
            [self.mbtnToken setTitleColor:nil forState:UIControlStateNormal];
            [self.mbtnToken setSelected:NO];
            [self.mbtnToken setEnabled:NO];
        }
        
        if(self.mbtnSMS.enabled)
        {
            [self.mbtnSMS setSelected:NO];
            [self.mbtnSMS setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
            [self.mbtnSMS setTitleColor:nil forState:UIControlStateNormal];
            [self.mbtnSMS setEnabled:NO];
        }
        
        self.mtfMatKhauToken.placeholder = [@"ma_xac_thuc" localizableString];
        [self.mtfMatKhauToken setTextError:[@"ma_xac_thuc_khong_duoc_de_trong" localizableString]
                                   forType:ExTextFieldTypeEmpty];
        
        
        NSString *sEmailAuthenticate = self.mThongTinTaiKhoanVi.sThuDienTu;
        int nKieuNhanXacThuc = 0;
        nKieuNhanXacThuc = FUNC_EDIT_HAN_MUC_GIAO_DICH;
        [self xuLyKetNoiLayMaXacThucChuyenDenTaiKhoan:sEmailAuthenticate kieuXacThuc:nKieuNhanXacThuc];
    }
}

- (void)xuLySuKienXacThucBangSMS
{
    if(!self.mbtnSMS.selected)
    {
        mTypeAuthenticate = TYPE_AUTHENTICATE_SMS;
        [self.mbtnSMS setSelected:YES];
        [self.mbtnSMS setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        self.mTongSoThoiGian = THOI_GIAN_CHO_XAC_THUC_SMS;
        [self.mbtnSMS setTitle:[NSString stringWithFormat:@"%ld s", (long)self.mTongSoThoiGian] forState:UIControlStateNormal];
        
        [self.mbtnVanTay setHidden:YES];
        
        if(self.mbtnToken.enabled)
        {
            [self.mbtnToken setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
            [self.mbtnToken setTitleColor:nil forState:UIControlStateNormal];
            [self.mbtnToken setSelected:NO];
            [self.mbtnToken setEnabled:NO];
        }
        
        if(self.mbtnEmail.enabled)
        {
            [self.mbtnEmail setSelected:NO];
            [self.mbtnEmail setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
            [self.mbtnEmail setTitleColor:nil forState:UIControlStateNormal];
            [self.mbtnEmail setEnabled:NO];
        }
        
        self.mtfMatKhauToken.placeholder = [@"ma_xac_thuc" localizableString];
        [self.mtfMatKhauToken setTextError:[@"ma_xac_thuc_khong_duoc_de_trong" localizableString]
                                   forType:ExTextFieldTypeEmpty];
        
        NSString *sPhoneAuthenticate = self.mThongTinTaiKhoanVi.sPhoneAuthenticate;
        int nKieuNhanXacThuc = 0;
        nKieuNhanXacThuc = FUNC_EDIT_HAN_MUC_GIAO_DICH;
        
        [self xuLyKetNoiLayMaXacThucChuyenDenTaiKhoan:sPhoneAuthenticate kieuXacThuc:nKieuNhanXacThuc];
    }
}

- (void)xuLyGuiHanMucGiaoDichLenServer
{
    if(_mHanMucGiaoDich)
    {
        for(GioiHanGiaoDich *gioiHanGiaoDich in _mHanMucGiaoDich.mDanhSachGioiHan)
        {
            NSString *sSoTien = @"";
            if([gioiHanGiaoDich.typeTransfer intValue] == TRANSACTION_LIMIT_TO_ACCOUNT)
            {
                sSoTien = [self.mtfHanMucGiaoDichMotLanVoiTKNganHang.text stringByReplacingOccurrencesOfString:@"." withString:@""];
                gioiHanGiaoDich.oneTime = [NSNumber numberWithDouble:[sSoTien doubleValue]];
                sSoTien = [self.mtfHanMucGiaoDichMotNgayVoiTKNganHang.text stringByReplacingOccurrencesOfString:@"." withString:@""];
                gioiHanGiaoDich.oneDay = [NSNumber numberWithDouble:[sSoTien doubleValue]];
                sSoTien = [self.mtfHanMucGiaoDichMotThangVoiTKNganHang.text stringByReplacingOccurrencesOfString:@"." withString:@""];
                gioiHanGiaoDich.oneMonth = [NSNumber numberWithDouble:[sSoTien doubleValue]];
            }
            else if([gioiHanGiaoDich.typeTransfer intValue] == TRANSACTION_LIMIT_TO_CARD)
            {
                sSoTien = [self.mtfHanMucGiaoDichMotLanVoiTKThe.text stringByReplacingOccurrencesOfString:@"." withString:@""];
                gioiHanGiaoDich.oneTime = [NSNumber numberWithDouble:[sSoTien doubleValue]];
                sSoTien = [self.mtfHanMucGiaoDichMotNgayVoiTKThe.text stringByReplacingOccurrencesOfString:@"." withString:@""];
                gioiHanGiaoDich.oneDay = [NSNumber numberWithDouble:[sSoTien doubleValue]];
                sSoTien = [self.mtfHanMucGiaoDichMotThangVoiTKThe.text stringByReplacingOccurrencesOfString:@"." withString:@""];
                gioiHanGiaoDich.oneMonth = [NSNumber numberWithDouble:[sSoTien doubleValue]];
            }
            else if([gioiHanGiaoDich.typeTransfer intValue] == TRANSACTION_LIMIT_TO_WALLET)
            {
                sSoTien = [self.mtfHanMucGiaoDichMotLanVoiVi.text stringByReplacingOccurrencesOfString:@"." withString:@""];
                gioiHanGiaoDich.oneTime = [NSNumber numberWithDouble:[sSoTien doubleValue]];
                sSoTien = [self.mtfHanMucGiaoDichMotNgayVoiVi.text stringByReplacingOccurrencesOfString:@"." withString:@""];
                gioiHanGiaoDich.oneDay = [NSNumber numberWithDouble:[sSoTien doubleValue]];
                sSoTien = [self.mtfHanMucGiaoDichMotThangVoiVi.text stringByReplacingOccurrencesOfString:@"." withString:@""];
                gioiHanGiaoDich.oneMonth = [NSNumber numberWithDouble:[sSoTien doubleValue]];
            }
            else if ([gioiHanGiaoDich.typeTransfer intValue] == TRANSACTION_LIMIT_TO_VI_KHAC) {
                sSoTien = [self.edChuyenTienDenViKhac.text stringByReplacingOccurrencesOfString:@"." withString:@""];
                gioiHanGiaoDich.oneTime = [NSNumber numberWithDouble:[sSoTien doubleValue]];
                gioiHanGiaoDich.oneDay = [NSNumber numberWithDouble:0.0];
                gioiHanGiaoDich.oneMonth = [NSNumber numberWithDouble:0.0];
            }
        }
        
        NSString *token = @"";
        NSString *otp = @"";
        if(mTypeAuthenticate == TYPE_AUTHENTICATE_TOKEN)
        {
            NSString *sMatKhau = @"";
            if(mXacThucVanTay)
            {
                mXacThucVanTay = NO;
                sMatKhau = [DucNT_Token layMatKhauVanTayToken];
            }
            else
            {
                sMatKhau = self.mtfMatKhauToken.text;
            }
            NSString *sSeed = [DucNT_Token laySeedTokenHienTai];
            if(sSeed != nil && sSeed.length > 0)
            {
                token = [DucNT_Token OTPFromPIN:sMatKhau seed:sSeed];
            }
            else
            {
                [[[[UIAlertView alloc] initWithTitle:[@"thong_bao" localizableString]  message:[@"can_tao_token" localizableString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
                return;
            }
        }
        else
        {
            otp = self.mtfMatKhauToken.text;
        }
        
        [self xuLyKetNoiGuiHanMucGiaoDich:token otp:otp];
    }
}


#pragma mark - cac ham kiem tra

-(BOOL)validate
{
    NSArray *tfs = @[_mtfHanMucGiaoDichMotLanVoiTKNganHang, _mtfHanMucGiaoDichMotLanVoiTKThe, _mtfHanMucGiaoDichMotLanVoiVi,
                     _mtfHanMucGiaoDichMotThangVoiTKNganHang, _mtfHanMucGiaoDichMotThangVoiTKThe, _mtfHanMucGiaoDichMotThangVoiVi,
                     _mtfHanMucGiaoDichMotNgayVoiTKNganHang, _mtfHanMucGiaoDichMotNgayVoiTKThe, _mtfHanMucGiaoDichMotNgayVoiVi,
                     ];
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
    
    return flg;
}

-(BOOL)validateVanTay
{
    NSArray *tfs = @[_mtfHanMucGiaoDichMotLanVoiTKNganHang, _mtfHanMucGiaoDichMotLanVoiTKThe, _mtfHanMucGiaoDichMotLanVoiVi,
                     _mtfHanMucGiaoDichMotThangVoiTKNganHang, _mtfHanMucGiaoDichMotThangVoiTKThe, _mtfHanMucGiaoDichMotThangVoiVi,
                     _mtfHanMucGiaoDichMotNgayVoiTKNganHang, _mtfHanMucGiaoDichMotNgayVoiTKThe, _mtfHanMucGiaoDichMotNgayVoiVi];
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
    
    return flg;
}


#pragma mark - xuLyKetNoi

- (void)xuLyKetNoiLayHanMucGiaoDich
{
    NSString *sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    NSMutableString *sUrl = [[NSMutableString alloc] init];
    [sUrl appendFormat:@"https://vimass.vn/vmbank/services/account/searchTransactionLimit?"];
    [sUrl appendFormat:@"idOwner=%@", sTaiKhoan];
    
    mDinhDanhKetNoi = DINH_DANH_KET_NOI_LAY_HAN_MUC_GIAO_DICH;
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:self];
    [connect connectGet:sUrl withContent:@""];
    [connect release];
    [sUrl release];
}

- (void)xuLyKetNoiLayMaXacThucChuyenDenTaiKhoan:(NSString*)sSendTo kieuXacThuc:(int)nKieu
{
    NSString *sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    int typeAuthenticate = 1;
    //    if(![Common kiemTraLaSoDienThoai:sSendTo])
    if([Common kiemTraLaMail:sSendTo])
        typeAuthenticate = 2;
    
    NSMutableString *sUrl = [[NSMutableString alloc] init];
    [sUrl appendFormat:@"https://vimass.vn/vmbank/services/account/getOTP?"];
    [sUrl appendFormat:@"id=%@&", sTaiKhoan];
    [sUrl appendFormat:@"appId=%d&", APP_ID];
    [sUrl appendFormat:@"funcId=%d&", nKieu];
    [sUrl appendFormat:@"typeAuthenticate=%d&", typeAuthenticate];
    [sUrl appendFormat:@"sendTo=%@", sSendTo];
    
    mDinhDanhKetNoi = DINH_DANH_KET_NOI_LAY_MA_XAC_THUC;
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:self];
    [connect connectGet:sUrl withContent:@""];
    [connect release];
    [sUrl release];
}

- (void)xuLyKetNoiGuiHanMucGiaoDich:(NSString*)sToken otp:(NSString*)sOtp
{
    if(_mHanMucGiaoDich)
    {
        NSMutableDictionary *dictPost = [NSMutableDictionary dictionaryWithDictionary:[_mHanMucGiaoDich toDict]];
        [dictPost setValue:sToken forKey:@"token"];
        [dictPost setValue:sOtp forKey:@"otpConfirm"];
        [dictPost setValue:self.mThongTinTaiKhoanVi.sID forKey:@"idOwner"];
        [dictPost setValue:[NSNumber numberWithInt:mTypeAuthenticate] forKey:@"typeAuthenticate"];
        [dictPost setValue:[NSNumber numberWithInt:APP_ID] forKey:@"appId"];
        [dictPost setValue:[NSNumber numberWithInt:VM_APP] forKey:@"VMApp"];
        
        DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
        [connect setDucnt_connectDelegate:self];
        mDinhDanhKetNoi = DINH_DANH_KET_NOI_THAY_DOI_HAN_MUC_GIAO_DICH;
        [connect connect:@"https://vimass.vn/vmbank/services/account/editTransactionLimit" withContent:[dictPost JSONString]];
        [connect release];
    }
}

#pragma mark - xuLySuKienVanTay

- (void)xuLyKhiKhongCoChucNangQuetVanTay
{
    [mbtnVanTay setHidden:YES];
}

- (void)xuLyKhiCoChucNangQuetVanTay
{
    [mbtnVanTay setHidden:NO];
}

- (void)xuLySuKienDangNhapVanTay
{
    [self xuLySuKienHienThiChucNangVanTayVoiTieuDe:[@"su_dung_van_tay_dang_nhap_tai_khoan_token_VIMASS" localizableString]];
}

- (void)xuLySuKienXacThucVanTayThanhCong
{
    mTypeAuthenticate = TYPE_AUTHENTICATE_TOKEN;
    mXacThucVanTay = YES;
    [self xuLyGuiHanMucGiaoDichLenServer];
}

- (void)hienThiThongBaoDienMatKhau
{
    [UIAlertView alert:[@"thong_bao_xac_thuc_van_tay_khong_dung" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
    [mbtnVanTay setHidden:YES];
}


#pragma mark - xuLyTimer

- (void)batDauDemThoiGian
{
    mTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(capNhatDemThoiGian) userInfo:nil repeats:YES];
}

- (void)ketThucDemThoiGian
{
    [self khoiTaoGiaoDienChuyenTien];
    if(mTimer)
    {
        [mTimer invalidate];
        mTimer = nil;
    }
}

- (void)capNhatDemThoiGian
{
    _mTongSoThoiGian --;
    if(mTypeAuthenticate == TYPE_AUTHENTICATE_SMS)
    {
        self.mbtnSMS.enabled = NO;
        [self.mbtnSMS setTitle:[NSString stringWithFormat:@"%ld s", (long)self.mTongSoThoiGian] forState:UIControlStateNormal];
        self.mbtnSMS.enabled = YES;
    }
    else if(mTypeAuthenticate == TYPE_AUTHENTICATE_EMAIL)
    {
        self.mbtnEmail.enabled = NO;
        [self.mbtnEmail setTitle:[NSString stringWithFormat:@"%ld s", (long)self.mTongSoThoiGian] forState:UIControlStateNormal];
        self.mbtnEmail.enabled = YES;
    }
    if(_mTongSoThoiGian == 0)
    {
        [self ketThucDemThoiGian];
    }
}


#pragma mark - DucNT_ServicePostDelegate

-(void)ketNoiThanhCong:(NSString *)sKetQua
{
    NSLog(@"%s - sKetQua : %@", __FUNCTION__, sKetQua);
    NSDictionary *dicKetQua = [sKetQua objectFromJSONString];
    int nCode = [[dicKetQua objectForKey:@"msgCode"] intValue];
    NSString *message = [dicKetQua objectForKey:@"msgContent"];
    if([mDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_LAY_MA_XAC_THUC])
    {
        NSDictionary *dic = [[[[sKetQua stringByReplacingOccurrencesOfString:@"\\" withString:@""] stringByReplacingOccurrencesOfString:@"\"{" withString:@"{"] stringByReplacingOccurrencesOfString:@"}\"" withString:@"}"] objectFromJSONString];
        int nCode = [[dic objectForKey:@"msgCode"] intValue];
        NSString *sMessage = [dic objectForKey:@"msgContent"];
        if(nCode == 31)
        {
            //Chay giay thong bao
            self.mTongSoThoiGian = THOI_GIAN_CHO_XAC_THUC_SMS;
            [self batDauDemThoiGian];
        }
        else if(nCode == 32)
        {
            self.mTongSoThoiGian = THOI_GIAN_CHO_XAC_THUC_EMAIL;
            [self batDauDemThoiGian];
        }
        else
        {
            [UIAlertView alert:sMessage withTitle:[@"thong_bao" localizableString] block:nil];
        }
    }
    else if([mDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_LAY_HAN_MUC_GIAO_DICH])
    {
        if(nCode == 1)
        {
            NSDictionary *dictHanMuc = [dicKetQua valueForKey:@"result"];
            HanMucGiaoDich *hanMucGiaoDich = [[HanMucGiaoDich alloc] initWithDictionary:dictHanMuc];
            self.mHanMucGiaoDich = hanMucGiaoDich;
            [self xuLyHienThiHanMucGiaoDich];
            [hanMucGiaoDich release];
        }
        else
        {
            [UIAlertView alert:message withTitle:[@"thong_bao" localizableString] block:nil];
        }
    }
    else if([mDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_THAY_DOI_HAN_MUC_GIAO_DICH])
    {
        if(nCode == 1)
        {
            [self xuLyHienThiHanMucGiaoDich];
            [self hienThiHopThoaiMotNutBamKieu:HOP_THOAI_XAC_NHAN_CHUYEN_TIEN_THANH_CONG cauThongBao:message];
        }
        else
        {
            [UIAlertView alert:message withTitle:[@"thong_bao" localizableString] block:nil];
        }
    }
}


#pragma mark - handler error
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - dealloc
- (void)dealloc {
    [_mScrollview release];
    [_mtfHanMucGiaoDichMotLanVoiTKNganHang release];
    [_mtfHanMucGiaoDichMotNgayVoiTKNganHang release];
    [_mtfHanMucGiaoDichMotThangVoiTKNganHang release];
    
    [_mtfHanMucGiaoDichMotLanVoiTKThe release];
    [_mtfHanMucGiaoDichMotNgayVoiTKThe release];
    [_mtfHanMucGiaoDichMotThangVoiTKThe release];
    [_mtfHanMucGiaoDichMotLanVoiVi release];
    [_mtfHanMucGiaoDichMotNgayVoiVi release];
    [_mtfHanMucGiaoDichMotThangVoiVi release];

    [mbtnVanTay release];
    [_mViewMain2 release];
    [_edChuyenTienDenViKhac release];
    [super dealloc];
}
@end
