//
//  ThemTaiKhoanThuongDungDienThoai.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 1/13/16.
//
//

#import "ThemTaiKhoanThuongDungDienThoai.h"
#import "Common.h"
#import "Alert+Block.h"
#import "DucNT_LuuRMS.h"
@implementation ThemTaiKhoanThuongDungDienThoai

- (void)awakeFromNib{
    self.nNhaMang = -1;
    self.nLoaiThueBao = -1;
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 12)];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"muiten35x21.png"] forState:UIControlStateNormal];
    self.edNhaMang.rightView = btnRight;
    self.edNhaMang.rightViewMode = UITextFieldViewModeAlways;

    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneChonSanBay:)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelChonSanBay:)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

    [toolBar setItems:[NSArray arrayWithObjects:cancelButton, flexSpace, doneButton, nil]];

    UIPickerView *pickerNhaMang = [[UIPickerView alloc] init];
    pickerNhaMang.delegate = self;
    pickerNhaMang.dataSource = self;
    self.edNhaMang.inputView = pickerNhaMang;
    [pickerNhaMang release];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 8;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self getTenLoaiThueBao:(int)row];
}

- (NSString *)getTenLoaiThueBao:(int)nRow{
    switch (nRow) {
        case 0:
            return @"VinaPhone trả trước";
            break;
        case 1:
            return @"VinaPhone trả sau";
            break;
        case 2:
            return @"Mobifone trả trước";
            break;
        case 3:
            return @"Mobifone trả sau";
            break;
        case 4:
            return @"Viettel trả trước";
            break;
        case 5:
            return @"Viettel trả trước";
            break;
        case 6:
            return @"Gmobile trả trước";
            break;
        case 7:
            return @"Vietnamobile trả trước";
            break;
        default:
            break;
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *sTenThueBao = [self getTenLoaiThueBao:(int)row];
    self.edNhaMang.text = sTenThueBao;
    [self.edNhaMang resignFirstResponder];
    if ([sTenThueBao containsString:@"sau"] || [sTenThueBao containsString:@"Gmobile"] || [sTenThueBao containsString:@"Vietnamobile"]) {
        self.nLoaiThueBao = 1;
    }
    else
        self.nLoaiThueBao = 2;
    if (row == 0 || row == 1) {
        self.nNhaMang = 2;
    }
    else if (row == 2 || row == 3) {
        self.nNhaMang = 3;
    }
    else if (row == 4 || row == 5) {
        self.nNhaMang = 1;
    }
    else if (row == 6){
        self.nNhaMang = 4;
    }
    else if (row == 7){
        self.nNhaMang = 5;
    }
}

- (BOOL)kiemTraNoiDung{
    if ([self.edTenHienThi.text isEmpty]) {
        [UIAlertView alert:@"Vui lòng nhập tên hiển thị" withTitle:nil block:nil];
        return NO;
    }
    if ([self.edSDT.text isEmpty]) {
        [UIAlertView alert:@"Vui lòng nhập số điện thoại" withTitle:nil block:nil];
        return NO;
    }
    else if (self.edSDT.text.length < 10 || self.edSDT.text.length > 11) {
        [UIAlertView alert:@"Số điện thoại không hợp lệ" withTitle:nil block:nil];
        return NO;
    }
    if (self.nNhaMang == -1) {
        [UIAlertView alert:@"Vui lòng chọn loại thuê bao" withTitle:nil block:nil];
        return NO;
    }
    if (self.nNhaMang == 2) {
        BOOL bKT = [Common kiemTralaSoDienThoaiVina:self.edSDT.text];
        if (!bKT) {
            [UIAlertView alert:@"Số điện thoại không thuộc danh sách đầu số VinaPhone. Vui lòng kiểm tra lại" withTitle:nil block:nil];
            return NO;
        }
    }
    return YES;
}
//
//if ([sTenThueBao containsString:@"sau"] || [sTenThueBao containsString:@"Gmobile"] || [sTenThueBao containsString:@"Vietnamobile"]) {
//    self.nLoaiThueBao = 1;
//}
//else
//self.nLoaiThueBao = 2;
//if (row == 0 || row == 1) {
//    self.nNhaMang = 2;
//}
//else if (row == 2 || row == 3) {
//    self.nNhaMang = 3;
//}
//else if (row == 4 || row == 5) {
//    self.nNhaMang = 1;
//}
//else if (row == 6){
//    self.nNhaMang = 4;
//}
//else if (row == 7){
//    self.nNhaMang = 5;
//}


- (void)setMTaiKhoanThuongDung:(DucNT_TaiKhoanThuongDungObject *)mTaiKhoanThuongDung{
    if(mTaiKhoanThuongDung)
    {
        if(_mTaiKhoanThuongDung)
            [_mTaiKhoanThuongDung release];
        _mTaiKhoanThuongDung = [mTaiKhoanThuongDung retain];
        self.edTenHienThi.text = mTaiKhoanThuongDung.sAliasName;
        self.edSDT.text = mTaiKhoanThuongDung.soDienThoai;
        self.nNhaMang = mTaiKhoanThuongDung.nhaMang;
        self.nLoaiThueBao = mTaiKhoanThuongDung.loaiThueBao;
        if (self.nNhaMang == 2) {
            if (self.nLoaiThueBao == 2) {
                self.edNhaMang.text = @"VinaPhone trả trước";
            }
            else
                self.edNhaMang.text = @"VinaPhone trả trước";
        }
        else if (self.nNhaMang == 3) {
            if (self.nLoaiThueBao == 2) {
                self.edNhaMang.text = @"Mobifone trả trước";
            }
            else
                self.edNhaMang.text = @"Mobifone trả trước";
        }
        else if (self.nNhaMang == 1) {
            if (self.nLoaiThueBao == 2) {
                self.edNhaMang.text = @"Viettel trả trước";
            }
            else
                self.edNhaMang.text = @"Viettel trả trước";
        }
        else if (self.nNhaMang == 4) {
            self.edNhaMang.text = @"Gmobile trả trước";
        }
        else if (self.nNhaMang == 5) {
            self.edNhaMang.text = @"Vietnamobile trả trước";
        }
    }
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
        taiKhoanThuongDung.sAliasName = self.edTenHienThi.text;
        taiKhoanThuongDung.soDienThoai = self.edSDT.text;
        taiKhoanThuongDung.nhaMang = self.nNhaMang;
        taiKhoanThuongDung.loaiThueBao = self.nLoaiThueBao;
    }else{
        NSLog(@"ViewThuongDungChuyenTienTanNha : getTaiKhoanThuongDungDayLenServer : ");
    }
    return taiKhoanThuongDung;
}

- (void)dealloc {
    [_edNhaMang release];
    [_edSDT release];
    [_edTenHienThi release];
    [super dealloc];
}
- (IBAction)suKienBamNutDanhBa:(id)sender {
}
@end
