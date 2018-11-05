//
//  ViewThuongDungInternet.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 6/2/16.
//
//

#import "ViewThuongDungInternet.h"
#import "Alert+Block.h"
#import "DucNT_LuuRMS.h"
#import "Common.h"

@implementation ViewThuongDungInternet {
    int nIdVNPT;
}
const int NHA_CUNG_CAP_INTERNET_VNPT_HA_NOI_TD = 1;
const int NHA_CUNG_CAP_INTERNET_VNPT_HAI_PHONG_TD = 2;
const int NHA_CUNG_CAP_INTERNET_VNPT_HO_CHI_MINH_TD = 3;
const int NHA_CUNG_CAP_INTERNET_ADSL_FPT_TD = 4;
const int NHA_CUNG_CAP_INTERNET_VIETTEL_TD = 5;
const int NHA_CUNG_CAP_INTERNET_CMC_TD = 6;

- (void)awakeFromNib {
    nIdVNPT = NHA_CUNG_CAP_INTERNET_VNPT_HA_NOI_TD;
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 12)];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"muiten35x21.png"] forState:UIControlStateNormal];
    _mtfChonVNPT.rightView = btnRight;
    _mtfChonVNPT.rightViewMode = UITextFieldViewModeAlways;
    [btnRight release];

    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(chonNhaPhatHanh:)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(chonNhaPhatHanh:)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

    [toolBar setItems:[NSArray arrayWithObjects:cancelButton, flexSpace, doneButton, nil]];

    UIPickerView *pickerChonThe = [[UIPickerView alloc] init];
    pickerChonThe.tag = 100;
    pickerChonThe.backgroundColor = [UIColor whiteColor];
    pickerChonThe.dataSource = self;
    pickerChonThe.delegate = self;
    _mtfChonVNPT.inputView = pickerChonThe;
    _mtfChonVNPT.inputAccessoryView = toolBar;
    [toolBar release];
    [pickerChonThe release];
}

- (void)chonNhaPhatHanh:(id)sender {
    [_mtfChonVNPT resignFirstResponder];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 100) {
        return 3;
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 100) {
        switch (row) {
            case 0:
                return @"VNPT Hà Nội";
            case 1:
                return @"VNPT Hồ Chí Minh";
            case 2:
                return @"VNPT Hải Phòng";
            default:
                break;
        }
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (row) {
        case 0:
            nIdVNPT = NHA_CUNG_CAP_INTERNET_VNPT_HA_NOI_TD;
            self.mtfChonVNPT.text = @"VNPT Hà Nội";
            break;
        case 1:
            nIdVNPT = NHA_CUNG_CAP_INTERNET_VNPT_HO_CHI_MINH_TD;
            self.mtfChonVNPT.text = @"VNPT Hồ Chí Minh";
            break;
        case 2:
            nIdVNPT = NHA_CUNG_CAP_INTERNET_VNPT_HAI_PHONG_TD;
            self.mtfChonVNPT.text = @"VNPT Hải Phòng";
            break;
        default:
            break;
    }
}

- (void)setMTaiKhoanThuongDung:(DucNT_TaiKhoanThuongDungObject *)mTaiKhoanThuongDung{
    if(mTaiKhoanThuongDung)
    {
        if(_mTaiKhoanThuongDung)
            [_mTaiKhoanThuongDung release];
        _mTaiKhoanThuongDung = [mTaiKhoanThuongDung retain];
        _edNameAlias.text = mTaiKhoanThuongDung.sAliasName;
        _edMaKhachHang.text = mTaiKhoanThuongDung.maThueBao;
        int nMaNhaCungCap = mTaiKhoanThuongDung.maNhaCungCap;
        if (nMaNhaCungCap == NHA_CUNG_CAP_INTERNET_VNPT_HA_NOI_TD || nMaNhaCungCap == NHA_CUNG_CAP_INTERNET_VNPT_HAI_PHONG_TD || nMaNhaCungCap == NHA_CUNG_CAP_INTERNET_VNPT_HO_CHI_MINH_TD) {
            if (nMaNhaCungCap == NHA_CUNG_CAP_INTERNET_VNPT_HA_NOI_TD) {
                _mtfChonVNPT.text = @"VNPT Hà Nội";
            }
            else if (nMaNhaCungCap == NHA_CUNG_CAP_INTERNET_VNPT_HAI_PHONG_TD) {
                _mtfChonVNPT.text = @"VNPT Hải Phòng";
            }
            else if (nMaNhaCungCap == NHA_CUNG_CAP_INTERNET_VNPT_HO_CHI_MINH_TD) {
                _mtfChonVNPT.text = @"VNPT Hồ Chí Minh";
            }
            [self suKienChonVNPT:nil];
        }
        else if (nMaNhaCungCap == NHA_CUNG_CAP_INTERNET_VIETTEL_TD) {
            [self suKienViettel:nil];
        }
        else if (nMaNhaCungCap == NHA_CUNG_CAP_INTERNET_ADSL_FPT_TD) {
            [self suKienChonFPT:nil];
        }
        else if (nMaNhaCungCap == NHA_CUNG_CAP_INTERNET_CMC_TD) {
            [self suKienChonCMC:nil];
        }
    }
}

- (BOOL)kiemTraNoiDung {
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
        taiKhoanThuongDung.nType = TAI_KHOAN_NAP_TIEN_INTERNET;
        taiKhoanThuongDung.sAliasName = self.edNameAlias.text;
        taiKhoanThuongDung.maKhachHang = self.edMaKhachHang.text;
        taiKhoanThuongDung.maNhaCungCap = nIdVNPT;
    }
    return taiKhoanThuongDung;
}

- (IBAction)suKienChonVNPT:(id)sender {
    nIdVNPT = NHA_CUNG_CAP_INTERNET_VNPT_HA_NOI_TD;
    CGRect rectDonVi = self.mtfChonVNPT.frame;
    CGRect rectMaKH = self.edMaKhachHang.frame;
    rectMaKH.origin.y = rectDonVi.origin.y + rectDonVi.size.height + 8;
    self.edMaKhachHang.frame = rectMaKH;
    self.mtfChonVNPT.hidden = NO;
    CGRect rectMain = self.frame;
    rectMain.size.height = rectMaKH.origin.y + rectMaKH.size.height + 8;
    self.frame = rectMain;
    [self thayDoiTrangThaiButton:0];
    if (_delegate) {
        [_delegate capNhatLaiGiaoDienNapTienInternet];
    }
}

- (IBAction)suKienViettel:(id)sender {
    nIdVNPT = NHA_CUNG_CAP_INTERNET_VIETTEL_TD;
    CGRect rectDonVi = self.mtfChonVNPT.frame;
    self.edMaKhachHang.frame = rectDonVi;
    self.mtfChonVNPT.hidden = YES;
    CGRect rectMain = self.frame;
    rectMain.size.height = rectDonVi.origin.y + rectDonVi.size.height + 8;
    self.frame = rectMain;
    [self thayDoiTrangThaiButton:2];
    if (_delegate) {
        [_delegate capNhatLaiGiaoDienNapTienInternet];
    }
}

- (IBAction)suKienChonFPT:(id)sender {
    nIdVNPT = NHA_CUNG_CAP_INTERNET_ADSL_FPT_TD;
    CGRect rectDonVi = self.mtfChonVNPT.frame;
    self.edMaKhachHang.frame = rectDonVi;
    self.mtfChonVNPT.hidden = YES;
    CGRect rectMain = self.frame;
    rectMain.size.height = rectDonVi.origin.y + rectDonVi.size.height + 8;
    self.frame = rectMain;
    [self thayDoiTrangThaiButton:1];
    if (_delegate) {
        [_delegate capNhatLaiGiaoDienNapTienInternet];
    }
}

- (IBAction)suKienChonCMC:(id)sender {
    nIdVNPT = NHA_CUNG_CAP_INTERNET_CMC_TD;
    CGRect rectDonVi = self.mtfChonVNPT.frame;
    self.edMaKhachHang.frame = rectDonVi;
    self.mtfChonVNPT.hidden = YES;
    CGRect rectMain = self.frame;
    rectMain.size.height = rectDonVi.origin.y + rectDonVi.size.height + 8;
    self.frame = rectMain;
    [self thayDoiTrangThaiButton:3];
    if (_delegate) {
        [_delegate capNhatLaiGiaoDienNapTienInternet];
    }
}

- (void)thayDoiTrangThaiButton:(int)nIndex{
    [self.btnViettel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnFPT setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnVNPT setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnCMC setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

    [self.btnViettel setBackgroundColor:[UIColor whiteColor]];
    [self.btnFPT setBackgroundColor:[UIColor whiteColor]];
    [self.btnVNPT setBackgroundColor:[UIColor whiteColor]];
    [self.btnCMC setBackgroundColor:[UIColor whiteColor]];

    switch (nIndex) {
        case 0:
            [self.btnVNPT setBackgroundColor:[UIColor colorWithHexString:@"#015079"]];
            [self.btnVNPT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        case 1:
            [self.btnFPT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.btnFPT setBackgroundColor:[UIColor colorWithHexString:@"#015079"]];
            break;
        case 2:
            [self.btnViettel setBackgroundColor:[UIColor colorWithHexString:@"#015079"]];
            [self.btnViettel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        case 3:
            NSLog(@"%s - doi mau button CMC", __FUNCTION__);
            [self.btnCMC setBackgroundColor:[UIColor colorWithHexString:@"#015079"]];
            [self.btnCMC setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (void)dealloc {
    [_edNameAlias release];
    [_edMaKhachHang release];
    [_btnVNPT release];
    [_btnViettel release];
    [_btnFPT release];
    [_btnCMC release];
    [_mtfChonVNPT release];
    [super dealloc];
}
@end
