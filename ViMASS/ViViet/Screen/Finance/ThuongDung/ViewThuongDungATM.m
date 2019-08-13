//
//  ViewThuongDungATM.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 4/25/16.
//
//

#import "ViewThuongDungATM.h"
#import "Common.h"
#import "Alert+Block.h"
#import "DucNT_LuuRMS.h"

@implementation ViewThuongDungATM{
    int nMaATM;
}

- (void)awakeFromNib{
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 12)];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"muiten35x21.png"] forState:UIControlStateNormal];
    self.edATM.rightView = btnRight;
    self.edATM.rightViewMode = UITextFieldViewModeAlways;

    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneChonSanBay:)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelChonSanBay:)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

    [toolBar setItems:[NSArray arrayWithObjects:cancelButton, flexSpace, doneButton, nil]];

    UIPickerView *pickerNhaMang = [[UIPickerView alloc] init];
    pickerNhaMang.delegate = self;
    pickerNhaMang.dataSource = self;
    self.edATM.inputView = pickerNhaMang;
    [pickerNhaMang release];
}

- (void)layThongTinSoDienThoai:(NSString *)sSDT {
    
}

- (void)setMTaiKhoanThuongDung:(DucNT_TaiKhoanThuongDungObject *)mTaiKhoanThuongDung{
    if(mTaiKhoanThuongDung)
    {
        if(_mTaiKhoanThuongDung)
            [_mTaiKhoanThuongDung release];
        _mTaiKhoanThuongDung = [mTaiKhoanThuongDung retain];
        self.edNameAlias.text = mTaiKhoanThuongDung.sAliasName;
        self.btnSDT.text = mTaiKhoanThuongDung.soDienThoai;
        self.edSoTien.text = [Common hienThiTienTe:mTaiKhoanThuongDung.soTien];
        nMaATM = mTaiKhoanThuongDung.maATM;
        _edATM.text = [self layTenATM:nMaATM];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 3;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self layTenATM:(int)row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    nMaATM = (int)row;
    _edATM.text = [self layTenATM:nMaATM];
}

- (NSString *)layTenATM:(int)row {
    if (row == 0) {
        return @"Sacombank";
    }
    else if (row == 1) {
        return @"Techcombank";
    }
    else if (row == 2) {
        return @"Vietinbank";
    }
    return @"";
}

- (BOOL)kiemTraNoiDung {
    if (_edNameAlias.text.isEmpty) {
        [UIAlertView alert:@"Vui lòng nhập tên hiển thị" withTitle:@"Thông báo" block:nil];
        return NO;
    }
    if (_btnSDT.text.isEmpty) {
        [UIAlertView alert:@"Vui lòng nhập số điện thoại nhận tiền tại ATM" withTitle:@"Thông báo" block:nil];
        return NO;
    }
    return YES;
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
        taiKhoanThuongDung.nType = TAI_KHOAN_DIEN_THOAI;
        taiKhoanThuongDung.sAliasName = self.edNameAlias.text;
        taiKhoanThuongDung.soDienThoai = self.btnSDT.text;
        taiKhoanThuongDung.maATM = nMaATM;
    }
    return taiKhoanThuongDung;
}

- (void)dealloc {
    [_btnSacombank release];
    [_btnTechcombank release];
    [_btnVietin release];
    [_edNameAlias release];
    [_btnSDT release];
    [_edSoTien release];
    [_lblPhi release];
    [super dealloc];
}
@end
