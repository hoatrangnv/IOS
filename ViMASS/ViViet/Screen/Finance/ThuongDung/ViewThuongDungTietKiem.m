//
//  ViewThuongDungTietKiem.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 5/5/16.
//
//

#import "ViewThuongDungTietKiem.h"
#import "Common.h"
#import "Alert+Block.h"
#import "DucNT_LuuRMS.h"
#import "NganHangGuiTietKiem.h"
#import "Banks.h"
#import "BankCoreData.h"

@implementation ViewThuongDungTietKiem {

    int nKyHanRow;
    NganHangGuiTietKiem *mNganHangDuocChon;
    KyHanNganHang *mKyHanDuocChon;
    KyLaiNganHang *mKyLaiDuocChon;
    CachQuayVongKyLai *mCachThucQuayVongDuocChon;

    NSMutableArray *mDanhSachCachNhanGocVaLai;
    NSArray *mDanhSachKyHanGui;
    NSArray *mDanhSachKyLinhLai;
    NSArray *mDanhSachCachThucQuayVong;
    NSArray *mDanhSachNganHangRutTienVe;
    Banks *mNganHangRutTienDuocChon;

    double mLaiSuatTheoKyLai;
}

typedef enum : NSUInteger {
    TF_NHAN_GOC_VA_LAI = 1,
    TF_NGAN_HANG_GUI_TK = 2,
    TF_KY_HAN_GUI_TK = 3,
    TF_KY_LINH_LAI = 4,
    TF_CACH_THUC_QUAY_VONG = 5,
    TF_DANH_SACH_NGAN_HANG= 6,
} TAG_THUONGDUNG_TK;

typedef enum : NSUInteger {
    KIEU_NHAN_TIEN_QUA_VI = 0,
    KIEU_NHAN_TIEN_QUA_TK = 1,
    KIEU_NHAN_TIEN_QUA_THE = 2,
    KIEU_NHAN_TIEN_TAI_QUAY = 3,
} KIEU_NHAN_TIEN_THUONG_DUNG_TK;

- (void)awakeFromNib {
    NSString *sID = @"";
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sID = [DucNT_LuuRMS layThongTinDangNhap:KEY_DINH_DANH_DOANH_NGHIEP];
    }
    else if(nKieuDangNhap == KIEU_CA_NHAN)
    {
        sID = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    }
    mDanhSachCachNhanGocVaLai = [[NSMutableArray alloc] init];
    [mDanhSachCachNhanGocVaLai addObjectsFromArray:@[[[NSString stringWithFormat:@"%@ %@",[@"vi_vimass" localizableString], sID] lowercaseString], [[@"Account" localizableString] lowercaseString], [[@"tao_tai_khoan_thuong_dung_the" localizableString] lowercaseString]]];
}

- (void)capNhatThongTin {
    NSLog(@"%s - START - _mDanhSachNganHangGuiTietKiem : %ld", __FUNCTION__, (unsigned long)_mDanhSachNganHangGuiTietKiem.count);
    mDanhSachNganHangRutTienVe = [BankCoreData allBanks];
    [self themPickerVaButtonRight:TF_NGAN_HANG_GUI_TK edTemp:_mtfNganHangGui];
    [self themPickerVaButtonRight:TF_NHAN_GOC_VA_LAI edTemp:_mtfNhanGocVaLaiVe];
    [self themPickerVaButtonRight:TF_KY_HAN_GUI_TK edTemp:_mtfKyHanGui];
    [self themPickerVaButtonRight:TF_KY_LINH_LAI edTemp:_mtfKyLinhLai];
    [self themPickerVaButtonRight:TF_CACH_THUC_QUAY_VONG edTemp:_mtfCachThucQuayVong];
    [self themPickerVaButtonRight:TF_DANH_SACH_NGAN_HANG edTemp:_mtfNganHangRutTienVe];

    if(_mDanhSachNganHangGuiTietKiem.count > 0)
    {
        for (int i = 0; i < _mDanhSachNganHangGuiTietKiem.count; i ++) {
            NganHangGuiTietKiem *temp = [_mDanhSachNganHangGuiTietKiem objectAtIndex:i];
            if ([temp.maNganHang isEqualToString:_mTaiKhoanThuongDung.maNganHang]) {
                mNganHangDuocChon = temp;
                [self xuLyChonNganHangGuiTietKiem:i];
                for (int j = 0; j < mNganHangDuocChon.mDanhSachKyHan.count; j ++) {
                    KyHanNganHang *temp1 = [mNganHangDuocChon.mDanhSachKyHan objectAtIndex:j];
                    if ([temp1.maKyHan isEqualToString:_mTaiKhoanThuongDung.kyHan]) {
                        mKyHanDuocChon = temp1;
                        [self xuLyChonKyHanGui:j];
                        for (int k = 0; k < mKyHanDuocChon.mDanhSachKyLai.count; k ++) {
                            KyLaiNganHang *temp2 = [mDanhSachKyLinhLai objectAtIndex:k];
                            if ([temp2.maLai intValue] == _mTaiKhoanThuongDung.kyLinhLai) {
                                mKyLaiDuocChon = temp2;
                                [self xuLyChonKyLinhLai:k];
                                for (int m = 0; m < mKyLaiDuocChon.mDanhSachCachQuayVong.count; m ++) {
                                    CachQuayVongKyLai *temp3 = [mKyLaiDuocChon.mDanhSachCachQuayVong objectAtIndex:m];
                                    if ([temp3.maQuayVong intValue] == _mTaiKhoanThuongDung.cachThucQuayVong) {
                                        mCachThucQuayVongDuocChon = temp3;
                                        [self xuLyChonCachThucQuayVong:m];
                                        break;
                                    }
                                }
                                break;
                            }
                        }
                        break;
                    }
                }
                break;
            }
        }

        [self xuLyHienThiKhiChonCachNhanTienGocVaLai:_mTaiKhoanThuongDung.kieuNhanTien];
        if (_mTaiKhoanThuongDung.kieuNhanTien == 2) {
            self.mtfSoThe.text = _mTaiKhoanThuongDung.maATM;
        }
        else if (_mTaiKhoanThuongDung.kieuNhanTien == 1) {
            for (int i = 0; i < mDanhSachNganHangRutTienVe.count; i++) {
                Banks *bank = [mDanhSachNganHangRutTienVe objectAtIndex:i];
                if ([bank.bank_sms isEqualToString:_mTaiKhoanThuongDung.maNganHangNhanTien]) {
                    self.mtfNganHangRutTienVe.text = bank.bank_name;
                    break;
                }
            }
            self.mtfTenChuTaiKhoan.text = _mTaiKhoanThuongDung.tenChuTaiKhoan;
            self.mtfSoTaiKhoanRutTienVe.text = _mTaiKhoanThuongDung.soTaiKhoan;
        }
    }
}

- (void)xuLyHienThiKhiChonCachNhanTienGocVaLai:(int)nCachChon
{
    _mTaiKhoanThuongDung.kieuNhanTien = nCachChon;
    NSString *sCachNhanTienGocVaLai = [mDanhSachCachNhanGocVaLai objectAtIndex:nCachChon];
    _mtfNhanGocVaLaiVe.text = sCachNhanTienGocVaLai;
    CGRect rViewNhanGocVaLaiVe = _mVIewNhanGocVaLaiVe.frame;
    CGRect rMain = self.frame;

    if(nCachChon == KIEU_NHAN_TIEN_QUA_VI)
    {
        if(_mViewChonNganHangNhanTienGocVaLaiTietKiem.superview)
            [_mViewChonNganHangNhanTienGocVaLaiTietKiem removeFromSuperview];
        if(_mViewRutGocVaLaiVeThe.superview)
            [_mViewRutGocVaLaiVeThe removeFromSuperview];
        rMain.size.height = rViewNhanGocVaLaiVe.origin.y + rViewNhanGocVaLaiVe.size.height + 8;

    }
    else if(nCachChon == KIEU_NHAN_TIEN_QUA_TK)
    {
        if(_mViewChonNganHangNhanTienGocVaLaiTietKiem.superview)
            [_mViewChonNganHangNhanTienGocVaLaiTietKiem removeFromSuperview];
        if(_mViewRutGocVaLaiVeThe.superview)
            [_mViewRutGocVaLaiVeThe removeFromSuperview];

        CGRect rViewChonNganHangNhanTienGocVaLai = _mViewChonNganHangNhanTienGocVaLaiTietKiem.frame;
        rViewChonNganHangNhanTienGocVaLai.origin.y = rViewNhanGocVaLaiVe.size.height + rViewNhanGocVaLaiVe.origin.y + 8;
        _mViewChonNganHangNhanTienGocVaLaiTietKiem.frame = rViewChonNganHangNhanTienGocVaLai;
        rMain.size.height = rViewChonNganHangNhanTienGocVaLai.origin.y + rViewChonNganHangNhanTienGocVaLai.size.height + 10;
        [self addSubview:_mViewChonNganHangNhanTienGocVaLaiTietKiem];
    }
    else if(nCachChon == KIEU_NHAN_TIEN_QUA_THE)
    {
        if(_mViewChonNganHangNhanTienGocVaLaiTietKiem.superview)
            [_mViewChonNganHangNhanTienGocVaLaiTietKiem removeFromSuperview];
        if(_mViewRutGocVaLaiVeThe.superview)
            [_mViewRutGocVaLaiVeThe removeFromSuperview];

        CGRect rViewChonTheNhanTienGocVaLai = _mViewRutGocVaLaiVeThe.frame;
        rViewChonTheNhanTienGocVaLai.origin.y = rViewNhanGocVaLaiVe.size.height + rViewNhanGocVaLaiVe.origin.y + 8;
        rMain.size.height = rViewChonTheNhanTienGocVaLai.origin.y + rViewChonTheNhanTienGocVaLai.size.height + 10;

        _mViewRutGocVaLaiVeThe.frame = rViewChonTheNhanTienGocVaLai;
        [self addSubview:_mViewRutGocVaLaiVeThe];
    }
    self.frame = rMain;
    if (_delegate) {
        [_delegate capNhatLaiGiaoDienTietKiem];
    }
}

- (void)xuLyChonNganHangRutTienVe:(int)nViTri
{
    mNganHangRutTienDuocChon = [mDanhSachNganHangRutTienVe objectAtIndex:nViTri];
    [_mtfNganHangRutTienVe setText:mNganHangRutTienDuocChon.bank_name];
    [(UIPickerView*)_mtfNganHangRutTienVe.inputView selectRow:nViTri inComponent:0 animated:YES];
}

- (void)themPickerVaButtonRight:(int)nTag edTemp:(ExTextField *)edTemp{
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 12)];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"muiten35x21.png"] forState:UIControlStateNormal];
    edTemp.rightView = btnRight;
    edTemp.rightViewMode = UITextFieldViewModeAlways;

    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneChonVi:)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelChonVi:)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

    [toolBar setItems:[NSArray arrayWithObjects:cancelButton, flexSpace, doneButton, nil]];
    UIPickerView *pickerChonRap = [[UIPickerView alloc] init];
    pickerChonRap.dataSource = self;
    pickerChonRap.delegate = self;
    pickerChonRap.tag = nTag;
    edTemp.inputAccessoryView = toolBar;
    edTemp.inputView = pickerChonRap;
    [pickerChonRap release];
}

- (void)doneChonVi:(UIBarButtonItem *)sender {
    [self endEditing:YES];
}

- (void)cancelChonVi:(UIBarButtonItem *)sender {
    [self endEditing:YES];
}

- (void)setMTaiKhoanThuongDung:(DucNT_TaiKhoanThuongDungObject *)mTaiKhoanThuongDung{
    if(mTaiKhoanThuongDung)
    {
        if(_mTaiKhoanThuongDung)
            [_mTaiKhoanThuongDung release];
        _mTaiKhoanThuongDung = [mTaiKhoanThuongDung retain];
        _edNameAlias.text = mTaiKhoanThuongDung.sAliasName;
        self.mtfSoTien.text = [Common hienThiTienTe:mTaiKhoanThuongDung.soTien];
    }
}

#pragma mark - xu ly thong tin day len server
- (BOOL)kiemTraNoiDung {
    if (self.edNameAlias.text.isEmpty) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập tên hiển thị"];
        return NO;
    }
    return YES;
}

- (void)hienThiHopThoaiMotNutBamKieu:(int)nIndex cauThongBao:(NSString *)sThongBao {
    [UIAlertView alert:sThongBao withTitle:@"Thông báo" block:nil];
}

- (DucNT_TaiKhoanThuongDungObject*)getTaiKhoanThuongDungDayLenServer{
    DucNT_TaiKhoanThuongDungObject *taiKhoanThuongDung = nil;
    if([self kiemTraNoiDung])
    {
        if(_mTaiKhoanThuongDung)
        {
            taiKhoanThuongDung = _mTaiKhoanThuongDung;
        }
        else
        {
            taiKhoanThuongDung = [[[DucNT_TaiKhoanThuongDungObject alloc] init] autorelease];
        }
        NSString *sID = @"";
        int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
        if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
        {
            sID = [DucNT_LuuRMS layThongTinDangNhap:KEY_DINH_DANH_DOANH_NGHIEP];
        }
        else if(nKieuDangNhap == KIEU_CA_NHAN)
        {
            sID = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
        }
        taiKhoanThuongDung.sPhoneOwner = sID;
        taiKhoanThuongDung.nType = TAI_KHOAN_CHUYEN_TIEN_CMND;
        taiKhoanThuongDung.sAliasName = self.edNameAlias.text;

        double fSoTien = [[[self.mtfSoTien.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
        taiKhoanThuongDung.soTien = fSoTien;
        taiKhoanThuongDung.maNganHang = mNganHangDuocChon.maNganHang;
        taiKhoanThuongDung.kyHan = mKyHanDuocChon.maKyHan;
        taiKhoanThuongDung.kyLinhLai = mKyLaiDuocChon.maLai;
        taiKhoanThuongDung.cachThucQuayVong = mCachThucQuayVongDuocChon.maQuayVong;
        if (taiKhoanThuongDung.kieuNhanTien == KIEU_NHAN_TIEN_QUA_TK) {
            taiKhoanThuongDung.tenChuTaiKhoan = self.mtfTenChuTaiKhoan.text;
            taiKhoanThuongDung.soTaiKhoan = self.mtfSoTaiKhoanRutTienVe.text;
            taiKhoanThuongDung.maNganHangNhanTien = mNganHangRutTienDuocChon.bank_sms;
        }
        else if (taiKhoanThuongDung.kieuNhanTien == KIEU_NHAN_TIEN_QUA_THE) {
            taiKhoanThuongDung.sCardNumber = _mtfSoThe.text;
        }
    }
    return taiKhoanThuongDung;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView.tag == TF_NHAN_GOC_VA_LAI)
    {
        if(mDanhSachCachNhanGocVaLai)
            return mDanhSachCachNhanGocVaLai.count;
    }
    else if(pickerView.tag == TF_KY_HAN_GUI_TK)
    {
        if(mDanhSachKyHanGui) {
            return mDanhSachKyHanGui.count;
        }
    }
    else if (pickerView.tag == TF_NGAN_HANG_GUI_TK)
    {
        if(_mDanhSachNganHangGuiTietKiem)
            return _mDanhSachNganHangGuiTietKiem.count;
    }
    else if (pickerView.tag == TF_KY_LINH_LAI)
    {
        if(mDanhSachKyLinhLai)
            return mDanhSachKyLinhLai.count;
    }
    else if (pickerView.tag == TF_CACH_THUC_QUAY_VONG)
    {
        if(mDanhSachCachThucQuayVong)
            return mDanhSachCachThucQuayVong.count;
    }
    else if (pickerView.tag == TF_DANH_SACH_NGAN_HANG)
    {
        return mDanhSachNganHangRutTienVe.count;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView.tag == TF_NHAN_GOC_VA_LAI)
    {
        return [mDanhSachCachNhanGocVaLai objectAtIndex:row];
    }
    else if (pickerView.tag == TF_NGAN_HANG_GUI_TK)
    {
        NganHangGuiTietKiem *nganHangGuiTietKiem = [_mDanhSachNganHangGuiTietKiem objectAtIndex:row];
        return nganHangGuiTietKiem.bank;
    }
    else if ( pickerView.tag == TF_KY_HAN_GUI_TK)
    {
        KyHanNganHang *kyHanNganHang = [mDanhSachKyHanGui objectAtIndex:row];
        if ([kyHanNganHang.noiDung hasPrefix:@"Không"]) {
            return kyHanNganHang.noiDung;
        }
        return [NSString stringWithFormat:@"Kỳ hạn %@", kyHanNganHang.noiDung];
    }
    else if ( pickerView.tag == TF_KY_LINH_LAI)
    {
        KyLaiNganHang *kyLaiNganHang = [mDanhSachKyLinhLai objectAtIndex:row];
        return [NSString stringWithFormat:@"Lĩnh lãi %@", kyLaiNganHang.noiDungLai];
    }
    else if (pickerView.tag == TF_CACH_THUC_QUAY_VONG)
    {
        CachQuayVongKyLai *cachThucQuayVong = [mDanhSachCachThucQuayVong objectAtIndex:row];
        if([cachThucQuayVong.noiDungQuayVong rangeOfString:@"không"].location != NSNotFound)
        {
            return cachThucQuayVong.noiDungQuayVong;
        }
        return [NSString stringWithFormat:@"Quay vòng %@", cachThucQuayVong.noiDungQuayVong];
    }
    else if (pickerView.tag == TF_DANH_SACH_NGAN_HANG)
    {
        Banks *bank = [mDanhSachNganHangRutTienVe objectAtIndex:row];
        return bank.bank_name;
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    int nRow = (int)row;
    if(pickerView.tag == TF_NHAN_GOC_VA_LAI)
    {
        [self xuLyHienThiKhiChonCachNhanTienGocVaLai:nRow];
    }
    else if (pickerView.tag == TF_NGAN_HANG_GUI_TK)
    {
        [self xuLyChonNganHangGuiTietKiem:nRow];
    }
    else if ( pickerView.tag == TF_KY_HAN_GUI_TK)
    {
        nKyHanRow = (int)row;
        [self xuLyChonKyHanGui:nKyHanRow];
    }
    else if ( pickerView.tag == TF_KY_LINH_LAI)
    {
        [self xuLyChonKyLinhLai:nRow];
    }
    else if (pickerView.tag == TF_CACH_THUC_QUAY_VONG)
    {
        [self xuLyChonCachThucQuayVong:nRow];
    }
    else if (pickerView.tag == TF_DANH_SACH_NGAN_HANG)
    {
        [self xuLyChonNganHangRutTienVe:nRow];
    }
}

- (void)xuLyChonKyHanGui:(int)nViTriKyHan
{
    if(mDanhSachKyHanGui.count > 0)
    {
        mKyHanDuocChon = [mDanhSachKyHanGui objectAtIndex:nViTriKyHan];
        if ([mKyHanDuocChon.noiDung hasPrefix:@"Không"]) {
            _mtfKyHanGui.text = mKyHanDuocChon.noiDung;
        }
        else
            _mtfKyHanGui.text = [NSString stringWithFormat:@"Kỳ hạn %@", mKyHanDuocChon.noiDung];
        [(UIPickerView*)_mtfKyHanGui.inputView reloadAllComponents];
        [(UIPickerView*)_mtfKyHanGui.inputView selectRow:nViTriKyHan inComponent:0 animated:YES];
        mDanhSachKyLinhLai = mKyHanDuocChon.mDanhSachKyLai;
        mLaiSuatTheoKyLai = [mKyHanDuocChon.laiSuat doubleValue];
        [self xuLyChonKyLinhLai:0];
    }
}

#pragma mark - xu ly thong tin ngan hang

- (void)xuLyChonNganHangGuiTietKiem:(int)nViTriNganHangDuocChon
{
    if(_mDanhSachNganHangGuiTietKiem.count > 0)
    {
        mNganHangDuocChon = [_mDanhSachNganHangGuiTietKiem objectAtIndex:nViTriNganHangDuocChon];
        _mtfNganHangGui.text = mNganHangDuocChon.bank;
        mDanhSachKyHanGui = mNganHangDuocChon.mDanhSachKyHan;
        NSLog(@"%s - mDanhSachKyHanGui : %ld", __FUNCTION__, (unsigned long)mDanhSachKyHanGui.count);
        [self xuLyChonKyHanGui:0];
    }
}

- (void)xuLyChonKyLinhLai:(int)nViTriKyLinhLai
{
    if(mDanhSachKyLinhLai.count > 0)
    {
        mKyLaiDuocChon = [mDanhSachKyLinhLai objectAtIndex:nViTriKyLinhLai];
        _mtfKyLinhLai.text = [NSString stringWithFormat:@"Lĩnh lãi %@", mKyLaiDuocChon.noiDungLai];
        mDanhSachCachThucQuayVong = mKyLaiDuocChon.mDanhSachCachQuayVong;
        [(UIPickerView*)_mtfKyLinhLai.inputView reloadAllComponents];
        [(UIPickerView*)_mtfKyLinhLai.inputView selectRow:nViTriKyLinhLai inComponent:0 animated:YES];
        //        [self xuLyLayLaiSuatTheoKyLinhLai];
        [self xuLyHienThiSoTienLai];
        [self xuLyChonCachThucQuayVong:0];
    }
}

- (void)xuLyChonCachThucQuayVong:(int)nViTriChonCachThucQuayVong
{
    if(mDanhSachCachThucQuayVong.count > 0)
    {
        mCachThucQuayVongDuocChon = [mDanhSachCachThucQuayVong objectAtIndex:nViTriChonCachThucQuayVong];
        _mtfCachThucQuayVong.text = mCachThucQuayVongDuocChon.noiDungQuayVong;
        _mtfCachThucQuayVong.text = [NSString stringWithFormat:@"Quay vòng %@", mCachThucQuayVongDuocChon.noiDungQuayVong];
        if([mCachThucQuayVongDuocChon.noiDungQuayVong rangeOfString:@"không"].location != NSNotFound)
        {
            _mtfCachThucQuayVong.text = mCachThucQuayVongDuocChon.noiDungQuayVong;
        }
        [(UIPickerView*)_mtfCachThucQuayVong.inputView reloadAllComponents];
        [(UIPickerView*)_mtfCachThucQuayVong.inputView selectRow:nViTriChonCachThucQuayVong inComponent:0 animated:YES];
    }
}

- (void)xuLyHienThiSoTienLai
{
    double fSoTien = [[[self.mtfSoTien.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
    _mlblLaiSuat.text = [NSString stringWithFormat:@"Lãi suất: %@\uFF05", [NSString stringWithFormat:@"%.02f", mLaiSuatTheoKyLai]];
    double fSoTienLai = 0;
    if([mKyHanDuocChon.maKyHan rangeOfString:@"M"].location != NSNotFound)
    {
        //La thang
        NSInteger nSoThang = [[mKyHanDuocChon.maKyHan stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, mKyHanDuocChon.maKyHan.length)] intValue];
        fSoTienLai = [self laySoTienLaiTheoThang:nSoThang];
    }
    else if([mKyHanDuocChon.maKyHan rangeOfString:@"D"].location != NSNotFound)
    {
        //La ngay
        NSInteger nSoNgay = [[mKyHanDuocChon.maKyHan stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, mKyHanDuocChon.maKyHan.length)] intValue];
        fSoTienLai = [self laySoTienLaiTheoNgay:nSoNgay];
    }
    else if ([mKyHanDuocChon.maKyHan rangeOfString:@"KKH"].location != NSNotFound)
    {
        fSoTienLai = [self laySoTienLaiTheoNgay:1];
        if(fSoTien > 0)
            _mlblTienLai.text = [NSString stringWithFormat:@"Tiền lãi: %@ đ/ngày", [Common hienThiTienTe:fSoTienLai]];
        else
            _mlblTienLai.text = @"Tiền lãi: 0 đ/ngày";
        return;
    }

    if(fSoTien > 0)
        _mlblTienLai.text = [NSString stringWithFormat:@"Tiền lãi: %@ đ", [Common hienThiTienTe:fSoTienLai]];
    else
        _mlblTienLai.text = @"Tiền lãi: 0 đ";
}

#pragma mark - tinh lai suat
- (double)laySoTienLaiTheoNgay:(NSInteger)nSoNgayTinhLai
{
    double fSoTien = [[[self.mtfSoTien.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
    return [Common laySoTienLaiTheoNgay:mLaiSuatTheoKyLai soNgayGui:nSoNgayTinhLai soTien:fSoTien];
}

- (double)laySoTienLaiTheoThang:(NSInteger)nSoThangTinhLai
{
    double fSoTien = [[[self.mtfSoTien.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
    return [Common laySoTienLaiTheoThang:mLaiSuatTheoKyLai soThangGui:nSoThangTinhLai soTien:fSoTien];
}

#pragma mark - dealloc

- (void)dealloc {
    [_mtfNhanGocVaLaiVe release];
    [_mDanhSachNganHangGuiTietKiem release];
    [_edNameAlias release];
    [_mtfNganHangGui release];
    [_mtfSoTien release];
    [_mtfKyHanGui release];
    [_mtfKyLinhLai release];
    [_mtfCachThucQuayVong release];
    [_mlblLaiSuat release];
    [_mtfSoPhi release];
    [_mlblTienLai release];

    //Ngan hang nhan tien
    [_mViewChonNganHangNhanTienGocVaLaiTietKiem release];
    [_mtfSoTaiKhoanRutTienVe release];
    [_mtfTenChuTaiKhoan release];
    [_mtfNganHangRutTienVe release];

    //The
    [_mViewRutGocVaLaiVeThe release];
    [_mtfSoThe release];

    //
    [mDanhSachCachNhanGocVaLai release];
    [_mVIewNhanGocVaLaiVe release];
    [mDanhSachKyHanGui release];
    [mDanhSachKyLinhLai release];
    [mDanhSachCachThucQuayVong release];
    [mDanhSachNganHangRutTienVe release];
    [super dealloc];
}

@end
