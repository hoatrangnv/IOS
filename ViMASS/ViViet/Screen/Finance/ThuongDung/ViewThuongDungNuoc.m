//
//  ViewThuongDungNuoc.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 5/30/16.
//
//

#import "ViewThuongDungNuoc.h"
#import "Alert+Block.h"
#import "DucNT_LuuRMS.h"
#import "Common.h"
@implementation ViewThuongDungNuoc {
    int nRowNhaMay;
}

- (void)awakeFromNib {
    nRowNhaMay = 0;

    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 12)];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"muiten35x21.png"] forState:UIControlStateNormal];
    _edDonVi.rightView = btnRight;
    _edDonVi.rightViewMode = UITextFieldViewModeAlways;
    [btnRight release];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(chonNhaPhatHanh:)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelChonNhaPhatHanh:)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

    [toolBar setItems:[NSArray arrayWithObjects:cancelButton, flexSpace, doneButton, nil]];

    UIPickerView *pickerChonThe = [[UIPickerView alloc] init];
    pickerChonThe.tag = 100;
    pickerChonThe.backgroundColor = [UIColor whiteColor];
    pickerChonThe.dataSource = self;
    pickerChonThe.delegate = self;
    _edDonVi.inputView = pickerChonThe;
    _edDonVi.inputAccessoryView = toolBar;
    [toolBar release];
    [pickerChonThe release];

    _edDonVi.text = [self layTenNhaMayNuoc:nRowNhaMay];
}

- (void)chonNhaPhatHanh:(id)sender {
    [_edDonVi resignFirstResponder];
    _edDonVi.text = [self layTenNhaMayNuoc:nRowNhaMay];
}

- (void)cancelChonNhaPhatHanh:(id)sender {
    [_edDonVi resignFirstResponder];
}

- (void)setMTaiKhoanThuongDung:(DucNT_TaiKhoanThuongDungObject *)mTaiKhoanThuongDung{
    if(mTaiKhoanThuongDung)
    {
        if(_mTaiKhoanThuongDung)
            [_mTaiKhoanThuongDung release];
        _mTaiKhoanThuongDung = [mTaiKhoanThuongDung retain];
        _edNameAlias.text = mTaiKhoanThuongDung.sAliasName;
        _edMaKhachHang.text = mTaiKhoanThuongDung.maKhachHang;
        _edDonVi.text = [self layTenNhaMayNuocTheoMaThanhToan:mTaiKhoanThuongDung.kieuThanhToan];
    }
}

- (BOOL)kiemTraNoiDung {
    if (nRowNhaMay == 0) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng chọn đơn vị cung cấp"];
        return NO;
    }
    if ([_edNameAlias.text isEmpty]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập tên hiển thị"];
        return NO;
    }
    if ([_edMaKhachHang.text isEmpty]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập mã khách hàng"];
        return NO;
    }
    return YES;
}

- (void)hienThiHopThoaiMotNutBamKieu:(int)nIndex cauThongBao:(NSString *)sThongBao {
    [UIAlertView alert:sThongBao withTitle:@"Thông báo" block:nil];
}

- (DucNT_TaiKhoanThuongDungObject*)getTaiKhoanThuongDungDayLenServer {
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
        taiKhoanThuongDung.maKhachHang = self.edMaKhachHang.text;
        int nKieuThanhToan = [self layMaTraCuu:nRowNhaMay];
        taiKhoanThuongDung.kieuThanhToan = nKieuThanhToan;
    }
    return taiKhoanThuongDung;
}

#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 8;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self layTenNhaMayNuoc:(int)row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    nRowNhaMay = (int)row;
    _edDonVi.text = [self layTenNhaMayNuoc:nRowNhaMay];
}

#pragma mark - xu ly ma nha may
- (int)layMaTraCuu:(int)row{
    switch (row) {
        case 0:
            return -1;
            break;
        case 1:
            return 102;
            break;
        case 2:
            return 104;
            break;
        case 3:
            return 106;
            break;
        case 4:
            return 108;
            break;
        case 5:
            return 110;
            break;
        case 6:
            return 112;
            break;
        case 7:
            return 114;
            break;
        default:
            break;
    }
    return -1;
}

- (NSString *)layTenNhaMayNuoc:(int)row{
    switch (row) {
        case 0:
            return @"Chọn đơn vị cung cấp";
            break;
        case 1:
            return @"Nhà Bè";
            break;
        case 2:
            return @"Bến Thành";
            break;
        case 3:
            return @"Chợ Lớn";
            break;
        case 4:
            return @"Phú Hòa Tân";
            break;
        case 5:
            return @"Thủ Đức";
            break;
        case 6:
            return @"Trung An";
            break;
        case 7:
            return @"Tân Hòa";
            break;
        default:
            break;
    }
    return @"";
}

- (NSString *)layTenNhaMayNuocTheoMaThanhToan:(int)row{
    switch (row) {
        case -1:
            return @"Chọn đơn vị cung cấp";
            break;
        case 103:
            return @"Nhà Bè";
            break;
        case 105:
            return @"Bến Thành";
            break;
        case 107:
            return @"Chợ Lớn";
            break;
        case 109:
            return @"Phú Hòa Tân";
            break;
        case 111:
            return @"Thủ Đức";
            break;
        case 113:
            return @"Trung An";
            break;
        case 115:
            return @"Tân Hòa";
            break;
        default:
            break;
    }
    return @"Chọn đơn vị cung cấp";
}

- (void)dealloc {
    [_edNameAlias release];
    [_edDonVi release];
    [_edMaKhachHang release];
    [super dealloc];
}
@end
