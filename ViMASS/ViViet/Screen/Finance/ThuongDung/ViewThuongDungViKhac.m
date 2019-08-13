//
//  ViewThuongDungViKhac.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 5/4/16.
//
//

#import "ViewThuongDungViKhac.h"
#import "Common.h"
#import "Alert+Block.h"
#import "DucNT_LuuRMS.h"

@implementation ViewThuongDungViKhac {
    int nRowNhaMay;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 12)];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"muiten35x21.png"] forState:UIControlStateNormal];
    _edChonVi.rightView = btnRight;
    _edChonVi.rightViewMode = UITextFieldViewModeAlways;

    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneChonVi:)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelChonVi:)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

    [toolBar setItems:[NSArray arrayWithObjects:cancelButton, flexSpace, doneButton, nil]];
    UIPickerView *pickerChonRap = [[UIPickerView alloc] init];
    pickerChonRap.dataSource = self;
    pickerChonRap.delegate = self;
    pickerChonRap.tag = 100;
    _edChonVi.inputAccessoryView = toolBar;
    _edChonVi.inputView = pickerChonRap;
    [pickerChonRap release];
}

- (void)setMTaiKhoanThuongDung:(DucNT_TaiKhoanThuongDungObject *)mTaiKhoanThuongDung{
    if(mTaiKhoanThuongDung)
    {
        if(_mTaiKhoanThuongDung)
            [_mTaiKhoanThuongDung release];
        _mTaiKhoanThuongDung = [mTaiKhoanThuongDung retain];
        _edNameAlias.text = mTaiKhoanThuongDung.sAliasName;
        self.tvNoiDung.text = mTaiKhoanThuongDung.noiDung;
        self.edSoTien.text = [Common hienThiTienTe:mTaiKhoanThuongDung.soTien];
        self.edSoVi.text = mTaiKhoanThuongDung.sToAccWallet;
        self.edChonVi.text = [self layTenNhaMayNuoc:mTaiKhoanThuongDung.nhaCungCap];
        nRowNhaMay = [self layIndexNhaMay:mTaiKhoanThuongDung.nhaCungCap];
        [self capNhatGiaoDien];
    }
}

- (void)doneChonVi:(UIBarButtonItem *)sender {
    [_edChonVi resignFirstResponder];
    _edChonVi.text = [self layTenNhaMayNuoc:nRowNhaMay];
    [self capNhatGiaoDien];
}

- (void)capNhatGiaoDien {
    CGRect rectMain = self.frame;
    _tvNoiDung.text = @"";
    if (nRowNhaMay != 2 && nRowNhaMay != 4 && nRowNhaMay != 6) {
        CGRect rectSoTien = self.tvNoiDung.frame;
        rectMain.size.height = rectSoTien.origin.y;
        self.frame = rectMain;
        _tvNoiDung.hidden = YES;
        _tfNoiDung.hidden = YES;
    }
    else {
        _tvNoiDung.hidden = NO;
        _tfNoiDung.hidden = NO;
        CGRect rectNoiDung = _tvNoiDung.frame;
        rectMain.size.height = rectNoiDung.size.height + rectNoiDung.origin.y;
        self.frame = rectMain;
    }
    if (_delegate) {
        [_delegate capNhatLaiGiaoDienViKhac];
    }
}

- (void)cancelChonVi:(UIBarButtonItem *)sender {
    [_edChonVi resignFirstResponder];
}

#pragma mark - uipickerview
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 6;
}

//{"msgCode":1,"msgContent":"Thành công","total":0,"result":[{"funcId":1,"badge":0},{"funcId":2,"badge":0},{"funcId":13,"badge":14},{"funcId":19,"badge":0}],"totalAll":0}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self layTenNhaMayNuoc:(int)row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    nRowNhaMay = (int)row;
}

- (NSString *)layTenNhaMayNuoc:(int)row{
    switch (row) {
        case 0:
            return @"Chọn ví nhận tiền";
        case 1: case MOMO:
            return @"Momo";
        case 2: case NGAN_LUONG:
            return @"Ngân Lượng";
        case 3: case PAYOO:
            return @"Payoo";
        case 4: case VIMO:
            return @"Vimo";
        case 5: case BAO_KIM:
            return @"Bảo Kim";
        default:
            break;
    }
    return @"";
}

- (int)layIndexNhaMay:(int)nMaNhaMay {
    switch (nMaNhaMay) {
        case 0:
            return 0;
        case MOMO:
            return 1;
        case NGAN_LUONG:
            return 2;
        case PAYOO:
            return 3;
        case VIMO:
            return 4;
        case BAO_KIM:
            return 5;
        default:
            break;
    }
    return 0;
}

- (int)layMaNhaNhaMay:(int)nRow {
    switch (nRow) {
        case 0:
            return 0;
        case 1:
            return MOMO;
        case 2:
            return NGAN_LUONG;
        case 3:
            return PAYOO;
        case 4:
            return VIMO;
        case 5:
            return BAO_KIM;
        default:
            break;
    }
    return 0;
}

#pragma mark - xu ly thong tin day len server
- (BOOL)kiemTraNoiDung {
    if (self.edNameAlias.text.isEmpty) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập tên hiển thị"];
        return NO;
    }
    if (self.edSoVi.text.isEmpty) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập số ví"];
        return NO;
    }
    if (nRowNhaMay == 0) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng chọn nhà cung cấp Ví"];
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
        taiKhoanThuongDung.noiDung = self.tvNoiDung.text;
        taiKhoanThuongDung.nhaCungCap = [self layMaNhaNhaMay:nRowNhaMay];

        double fSoTien = [[[self.edSoTien.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
        taiKhoanThuongDung.soTien = fSoTien;

    }
    return taiKhoanThuongDung;
}

- (void)dealloc {
    [_edNameAlias release];
    [_edChonVi release];
    [_edSoTien release];
    [_edSoVi release];
    [_tvNoiDung release];
    [_tfNoiDung release];
    [super dealloc];
}
- (IBAction)suKienChonDanhBaViKhac:(id)sender {
}
@end
