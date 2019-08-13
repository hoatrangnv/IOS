//
//  ViewThuongDungChuyenTienTanNha.m
//  ViViMASS
//
//  Created by DucBui on 7/17/15.
//
//

#import "ViewThuongDungChuyenTienTanNha.h"
#import "Common.h"
#import "ChonTinhThanhViewController.h"
#import "DoiTuongTinhThanh.h"
@interface ViewThuongDungChuyenTienTanNha()<UITextFieldDelegate, ChonTinhThanhViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>{
    int nKieuChonPicker;
}

@property (nonatomic, retain) NSArray *mDanhSachTinhThanh;
@property (nonatomic, retain) DoiTuongTinhThanh *mTinhThanhDuocChon;
@property (nonatomic, retain) DoiTuongQuanHuyen *mQuanHuyenDuocChon;
@property (nonatomic, assign) BOOL mChonNhapQuanHuyen;
@property (nonatomic, retain) DoiTuongPhuongXa *mPhuongXaDuocChon;
@property (nonatomic, assign) BOOL mChonNhapPhuongXa;

@end

@implementation ViewThuongDungChuyenTienTanNha

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)suKienChonDoiTuongDiaDiem:(DoiTuongDiaDiem *)doiTuongDiaDiem kieuChon:(NSInteger)nKieuChon{
    
}

- (void)setMTaiKhoanThuongDung:(DucNT_TaiKhoanThuongDungObject *)mTaiKhoanThuongDung
{
    NSLog(@"ViewThuongDungChuyenTienTanNha : setMTaiKhoanThuongDung : ======> START : %@", mTaiKhoanThuongDung.cellphoneNumber);
    
    if(_mTaiKhoanThuongDung)
        [_mTaiKhoanThuongDung release];
    _mTaiKhoanThuongDung = [mTaiKhoanThuongDung retain];
    
    [self.mtfNameAlias setText:_mTaiKhoanThuongDung.sAliasName];
    [self.mtfHoTenNguoiNhan setText:_mTaiKhoanThuongDung.tenNguoiThuHuong];
    [self.mtfCMNDNguoiNhan setText:_mTaiKhoanThuongDung.cmnd];
    [self.mtfSoDienThoaiNguoiNhan setText:_mTaiKhoanThuongDung.cellphoneNumber];
    [self.mtvNoiDung setText:_mTaiKhoanThuongDung.noiDung];
    NSString *sSoTien = [Common hienThiTienTe:self.mTaiKhoanThuongDung.soTien];
    [self.mtfSoTien setText:sSoTien];
    for (DoiTuongTinhThanh *item in _mDanhSachTinhThanh) {
        if([item.mTen isEqualToString:self.mTaiKhoanThuongDung.tinhThanh]){
            _mTinhThanhDuocChon = item;
            [self.mtfTinhThanhPho setText:self.mTaiKhoanThuongDung.tinhThanh];
            [self xuLyHienThiSauKhiChonTinhThanhPho];
            break;
        }
    }
    if (_mTinhThanhDuocChon) {
        for (DoiTuongQuanHuyen *item in _mTinhThanhDuocChon.dsQuanHuyen) {
            if ([item.mTen isEqualToString:self.mTaiKhoanThuongDung.quanHuyen]) {
                _mQuanHuyenDuocChon = item;
                [self.mtfQuanHuyen setText:self.mTaiKhoanThuongDung.quanHuyen];
                break;
            }
        }
    }
    if (_mQuanHuyenDuocChon) {
        self.mChonNhapQuanHuyen = NO;
        self.mChonNhapPhuongXa = NO;
    }
    else{
        self.mChonNhapQuanHuyen = YES;
        self.mChonNhapPhuongXa = YES;
    }
    [self xuLyHienThiSauKhiChonQuanHuyen];
    
    if (_mQuanHuyenDuocChon) {
        for (DoiTuongPhuongXa *item in _mQuanHuyenDuocChon.dsPhuongXa) {
            if ([item.mTen isEqualToString:self.mTaiKhoanThuongDung.phuongXa]) {
                _mPhuongXaDuocChon = item;
                [self.mtfTenDuong setText:self.mTaiKhoanThuongDung.diaChi];
                self.mChonNhapPhuongXa = YES;
                break;
            }
            self.mChonNhapPhuongXa = NO;
        }
    }
    [self xuLyHienThiSauKhiChonPhuongXa];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    if (!self.mDanhSachTinhThanh) {
        self.mDanhSachTinhThanh = [DoiTuongTinhThanh layDanhSachTinhThanh];
    }
    self.mChonNhapQuanHuyen = NO;
    self.mChonNhapPhuongXa = NO;
    [self khoiTaoTextField];
}

- (void)khoiTaoTextField
{
    [_mtfHoTenNguoiNhan setTextError:@"Tên người nhận không được để trống" forType:ExTextFieldTypeEmpty];
    [_mtfHoTenNguoiNhan setInputAccessoryView:nil];
    
    [_mtfCMNDNguoiNhan setTextError:@"CMND không được để trống" forType:ExTextFieldTypeEmpty];
    _mtfCMNDNguoiNhan.inputAccessoryView = nil;
    
    
    [_mtfSoTien setTextError:@"Số tiền không được để trống" forType:ExTextFieldTypeEmpty];
    _mtfSoTien.type = ExTextFieldTypeMoney;
    _mtfSoTien.inputAccessoryView = nil;
    
    [_mtfSoDienThoaiNguoiNhan setTextError:@"Số điện thoại người nhận không được để trống" forType:ExTextFieldTypeEmpty];
    _mtfSoDienThoaiNguoiNhan.type = ExTextFieldTypePhone;
    _mtfSoDienThoaiNguoiNhan.inputAccessoryView = nil;
    
    [_mtfTinhThanhPho setTextError:@"Tỉnh/Thành phố không được để trống" forType:ExTextFieldTypeEmpty];
    _mtfTinhThanhPho.inputAccessoryView = nil;
    _mtfTinhThanhPho.delegate = self;
    
    [_mtfQuanHuyen setTextError:@"Quận/Huyện không được để trống" forType:ExTextFieldTypeEmpty];
    _mtfQuanHuyen.inputAccessoryView = nil;
    _mtfQuanHuyen.delegate = self;
    
    [_mtfPhuongXa setTextError:@"Phường/Xã không được để trống" forType:ExTextFieldTypeEmpty];
    _mtfPhuongXa.inputAccessoryView = nil;
    _mtfPhuongXa.delegate = self;
    
    [_mtfTenDuong setTextError:@"Tên đường/Số nhà không được để trống" forType:ExTextFieldTypeEmpty];
    _mtfTenDuong.inputAccessoryView = nil;
    
    _mtvNoiDung.inputAccessoryView = nil;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.mtfTinhThanhPho) {
        [self xuLyHienThiViewChonDiaDiem:KIEU_CHON_TINH_THANH];
    }
}

- (void)xuLyHienThiViewChonDiaDiem:(NSInteger)nKieuView
{
    NSLog(@"ViewThuongDungChuyenTienTanNha : xuLyHienThiViewChonDiaDiem : START");
    nKieuChonPicker = (int)nKieuView;
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.dataSource = self;
    picker.delegate = self;
//    [picker reloadAllComponents];
    if (nKieuChonPicker == KIEU_CHON_TINH_THANH) {
        NSLog(@"ViewThuongDungChuyenTienTanNha : xuLyHienThiViewChonDiaDiem : _mTinhThanhDuocChon.mTen : %@", _mTinhThanhDuocChon.mTen);
        self.mtfTinhThanhPho.inputView = picker;
    }
    [picker release];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (nKieuChonPicker == KIEU_CHON_TINH_THANH) {
        if (_mDanhSachTinhThanh) {
            return _mDanhSachTinhThanh.count;
        }
        else
            return 0;
    } else if (nKieuChonPicker == KIEU_CHON_QUAN_HUYEN){
        if (_mTinhThanhDuocChon) {
            return _mTinhThanhDuocChon.dsQuanHuyen.count;
        }
        else
            return 0;
    } else if (nKieuChonPicker == KIEU_CHON_PHUONG_XA){
        if (_mQuanHuyenDuocChon) {
            return _mQuanHuyenDuocChon.dsPhuongXa.count;
        }
        else
            return 0;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *title = @"";
    if (nKieuChonPicker == KIEU_CHON_TINH_THANH) {
        DoiTuongTinhThanh *item = [_mDanhSachTinhThanh objectAtIndex:row];
        title = item.mTen;
    }
    else if (nKieuChonPicker == KIEU_CHON_QUAN_HUYEN) {
        DoiTuongQuanHuyen *item = [_mTinhThanhDuocChon.dsQuanHuyen objectAtIndex:row];
        title = item.mTen;
    }
    else if (nKieuChonPicker == KIEU_CHON_PHUONG_XA) {
        DoiTuongPhuongXa *item = [_mQuanHuyenDuocChon.dsPhuongXa objectAtIndex:row];
        title = item.mTen;
    }
    return title;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if(view == nil)
    {
        int width = self.frame.size.width;
        view = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, width - 5 , 45)];
    }
    UILabel *lb = (UILabel *)view;
    lb.textAlignment = NSTextAlignmentCenter;
    NSString *title = @"";
    if (nKieuChonPicker == KIEU_CHON_TINH_THANH) {
        DoiTuongTinhThanh *item = [_mDanhSachTinhThanh objectAtIndex:row];
        title = item.mTen;
    }
    else if (nKieuChonPicker == KIEU_CHON_QUAN_HUYEN) {
        DoiTuongQuanHuyen *item = [_mTinhThanhDuocChon.dsQuanHuyen objectAtIndex:row];
        title = item.mTen;
    }
    else if (nKieuChonPicker == KIEU_CHON_PHUONG_XA) {
        DoiTuongPhuongXa *item = [_mQuanHuyenDuocChon.dsPhuongXa objectAtIndex:row];
        title = item.mTen;
    }
    lb.text = title;
    lb.font = [UIFont systemFontOfSize:18.0f];
    return view;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (nKieuChonPicker == KIEU_CHON_TINH_THANH) {
        _mTinhThanhDuocChon = [_mDanhSachTinhThanh objectAtIndex:row];
        [self.mtfTinhThanhPho setText:_mTinhThanhDuocChon.mTen];
        [self.mtfTinhThanhPho resignFirstResponder];
    }
    else if (nKieuChonPicker == KIEU_CHON_QUAN_HUYEN) {
        
    }
    else if (nKieuChonPicker == KIEU_CHON_PHUONG_XA) {
        
    }
}

- (void)xuLyHienThiSauKhiChonTinhThanhPho
{
    _mtfTinhThanhPho.text = _mTinhThanhDuocChon.mTen;
    _mtfQuanHuyen.text = @"";
    _mtfPhuongXa.text = @"";
    self.mQuanHuyenDuocChon = nil;
    self.mChonNhapQuanHuyen = NO;
    self.mPhuongXaDuocChon = nil;
    self.mChonNhapPhuongXa = NO;
    
    CGRect rViewTenDuongSoNha = _viewChiTietDuongPho.frame;
    CGRect rViewMain = self.frame;
//    CGRect rbtnVanTay = self.mbtnVanTay.frame;
    rViewTenDuongSoNha.origin.y = _mtfPhuongXa.frame.origin.y;
    rViewMain.size.height = rViewTenDuongSoNha.origin.y + rViewTenDuongSoNha.size.height + 20.0f;
    
    float fHeight = 0.0f;
//    if([self kiemTraCoChucNangQuetVanTay])
//    {
//        rbtnVanTay.origin.y = rViewMain.size.height + rViewMain.origin.y + 20.0f;
//        fHeight = rbtnVanTay.origin.y + rbtnVanTay.size.height + 10.0f;
//    }
//    else
//    {
        fHeight = 2*rViewMain.origin.y + rViewMain.size.height;
//    }
    
    _viewChiTietDuongPho.frame = rViewTenDuongSoNha;
    self.frame = rViewMain;
//    self.mbtnVanTay.frame = rbtnVanTay;
//    [_mScrView setContentSize:CGSizeMake(_mScrView.frame.size.width, fHeight)];
}

- (void)xuLyHienThiSauKhiChonQuanHuyen
{
    if(_mQuanHuyenDuocChon)
        _mtfQuanHuyen.text = _mQuanHuyenDuocChon.mTen;
    else
    {
        _mtfQuanHuyen.text = @"";
        [_mtfQuanHuyen becomeFirstResponder];
    }
    
    _mtfPhuongXa.text = @"";
    self.mPhuongXaDuocChon = nil;
    self.mChonNhapPhuongXa = NO;
    
    CGRect rViewTenDuongSoNha = _viewChiTietDuongPho.frame;
    CGRect rViewMain = self.frame;
//    CGRect rbtnVanTay = self.mbtnVanTay.frame;
    rViewTenDuongSoNha.origin.y = _mtfPhuongXa.frame.origin.y + _mtfPhuongXa.frame.size.height + 8;
    rViewMain.size.height = rViewTenDuongSoNha.origin.y + rViewTenDuongSoNha.size.height + 20.0f;
    
    float fHeight = 0.0f;
//    if([self kiemTraCoChucNangQuetVanTay])
//    {
//        rbtnVanTay.origin.y = rViewMain.size.height + rViewMain.origin.y + 20.0f;
//        fHeight = rbtnVanTay.origin.y + rbtnVanTay.size.height + 10.0f;
//    }
//    else
//    {
        fHeight = 2*rViewMain.origin.y + rViewMain.size.height;
//    }
    _viewChiTietDuongPho.frame = rViewTenDuongSoNha;
    self.frame = rViewMain;
//    self.mbtnVanTay.frame = rbtnVanTay;
//    [_mScrView setContentSize:CGSizeMake(_mScrView.frame.size.width, fHeight)];
}

- (void)xuLyHienThiSauKhiChonPhuongXa
{
    if(_mPhuongXaDuocChon)
        _mtfPhuongXa.text = _mPhuongXaDuocChon.mTen;
    else
    {
        _mtfPhuongXa.text = @"";
        [_mtfPhuongXa becomeFirstResponder];
    }
}

#pragma mark - suKien
- (IBAction)suKienThayDoiSoTien:(id)sender {
    double fSoTien = [[_mtfSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
    _mtfSoTien.text = [Common hienThiTienTe:fSoTien];
}

- (BOOL)validate
{
    NSArray *tfs = @[_mtfHoTenNguoiNhan, _mtfCMNDNguoiNhan, _mtfSoDienThoaiNguoiNhan, _mtfTinhThanhPho, _mtfQuanHuyen, _mtfPhuongXa];
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
        return NO;
    }
    return flg;
}

- (DucNT_TaiKhoanThuongDungObject*)getTaiKhoanThuongDungDayLenServer
{
    DucNT_TaiKhoanThuongDungObject *taiKhoanThuongDung = nil;
    if([self validate])
    {
        if(_mTaiKhoanThuongDung)
        {
            taiKhoanThuongDung = _mTaiKhoanThuongDung;
        }
        else
        {
            taiKhoanThuongDung = [[[DucNT_TaiKhoanThuongDungObject alloc] init] autorelease];
        }
        taiKhoanThuongDung.nType = TAI_KHOAN_TAN_NHA;
        taiKhoanThuongDung.sAliasName = self.mtfNameAlias.text;
        taiKhoanThuongDung.tenNguoiThuHuong = self.mtfHoTenNguoiNhan.text;
        taiKhoanThuongDung.cmnd = self.mtfCMNDNguoiNhan.text;
        taiKhoanThuongDung.cellphoneNumber = self.mtfSoDienThoaiNguoiNhan.text;
        taiKhoanThuongDung.tinhThanh = self.mtfTinhThanhPho.text;
        taiKhoanThuongDung.quanHuyen = self.mtfQuanHuyen.text;
        taiKhoanThuongDung.phuongXa = self.mtfPhuongXa.text;
        NSString *sSoTien = [self.mtfSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""];
        taiKhoanThuongDung.soTien = [sSoTien intValue];
        taiKhoanThuongDung.diaChi = self.mtfTenDuong.text;
        taiKhoanThuongDung.noiDung = self.mtvNoiDung.text;
    }else{
        NSLog(@"ViewThuongDungChuyenTienTanNha : getTaiKhoanThuongDungDayLenServer : ");
    }
    return taiKhoanThuongDung;
}

- (void)dealloc {
    if (_mDanhSachTinhThanh) {
        [_mDanhSachTinhThanh release];
    }
    [_mtfHoTenNguoiNhan release];
    [_mtfCMNDNguoiNhan release];
    [_mtfSoTien release];
    [_mtfSoDienThoaiNguoiNhan release];
    [_mtfTinhThanhPho release];
    [_mtfTenDuong release];
    [_mtvNoiDung release];
    [_mtfQuanHuyen release];
    [_mtfPhuongXa release];
    [_viewChiTietDuongPho release];
    [_mtfNameAlias release];
    [super dealloc];
}
@end
