//
//  GiaoDienThanhToanKPlus.m
//  ViViMASS
//
//  Created by Tam Nguyen on 2/27/18.
//

#import "GiaoDienThanhToanKPlus.h"

@interface GiaoDienThanhToanKPlus ()<UIPickerViewDataSource, UIPickerViewDelegate> {
    int nIndex;
}

@end

@implementation GiaoDienThanhToanKPlus

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Thanh toán K+";
    self.mFuncID = FUNC_THANH_TOAN_TRUYEN_HINH_K_PLUS;
    self.edSoTK.inputAccessoryView = nil;
    nIndex = 0;
    self.edOption.text = [self getOptionThanhToan:nIndex];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_edOption.rightView == nil) {
        UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 12)];
        [btnRight setBackgroundImage:[UIImage imageNamed:@"muiten35x21.png"] forState:UIControlStateNormal];
        _edOption.rightView = btnRight;
        _edOption.rightViewMode = UITextFieldViewModeAlways;
        
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
        toolBar.barStyle = UIBarStyleBlackOpaque;
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneChonTruyenHinh:)];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelChonTruyenHinh:)];
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        [toolBar setItems:[NSArray arrayWithObjects:flexSpace, doneButton, nil]];
        UIPickerView *pickerChonRap = [[UIPickerView alloc] init];
        pickerChonRap.dataSource = self;
        pickerChonRap.delegate = self;
        pickerChonRap.tag = 100;
        _edOption.inputAccessoryView = toolBar;
        _edOption.inputView = pickerChonRap;
        [pickerChonRap release];
    }
}

- (void)doneChonTruyenHinh:(UIButton *)btn {
    [_edOption resignFirstResponder];
}

- (void)cancelChonTruyenHinh:(UIButton *)btn {
    [_edOption resignFirstResponder];
}

- (int)getSoTien:(int) index {
    if (index == 0) {
        return 125000;
    }
    else if (index == 1) {
        return 375000;
    }
    else if (index == 2) {
        return 750000;
    }
    return 1500000;
}

- (BOOL)validateVanTay {
    if ([self.edSoTK.text isEmpty]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập mã thuê bao"];
        return NO;
    }
    return YES;
}

- (void)xuLyThucHienKhiKiemTraThanhCongTraVeToken:(NSString *)sToken otp:(NSString *)sOtp {
    self.mDinhDanhKetNoi = @"DINH_DANH_THANH_TOAN_K_PLUS";
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self hienThiLoadingChuyenTien];
    }
    NSString *sMaDoanhNghiep = @"";
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sMaDoanhNghiep = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_COMPANY_ID];
    }
    NSDictionary *dic = @{@"companyCode" : sMaDoanhNghiep,
                          @"token" : sToken,
                          @"otpConfirm" : sOtp,
                          @"typeAuthenticate" : [NSNumber numberWithInt:self.mTypeAuthenticate],
                          @"user" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                          @"VMApp" : [NSNumber numberWithInt:VM_APP],
                          @"maThueBao" : self.edSoTK.text,
                          @"soTien" : [NSNumber numberWithInt:[self getSoTien:nIndex]]
                          };
    [GiaoDichMang thanhToanKPlus:[dic JSONString] noiNhanKetQua:self];
}

- (void)xuLyKetNoiThanhCong:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self anLoading];
    }
    if ([sDinhDanhKetNoi isEqualToString:@"DINH_DANH_THANH_TOAN_K_PLUS"]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
    }
}

- (void)xuLyKetNoiThatBai:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self anLoading];
    }
    [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
}

#pragma mark UIPickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 4;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self getOptionThanhToan:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.edOption.text = [self getOptionThanhToan:row];
    nIndex = (int)row;
}

- (NSString *)getOptionThanhToan:(NSInteger)index {
    switch (index) {
        case 0:
            return @"Gia hạn 1 tháng 125.000 đ";
        case 1:
            return @"Gia hạn 3 tháng 375.000 đ";
        case 2:
            return @"Gia hạn 6 tháng 750.000 đ";
        case 3:
            return @"Gia hạn 12 tháng 1.500.000 đ";
        default:
            break;
    }
    return @"";
}

- (void)dealloc {
    [_edSoTK release];
    [_edOption release];
    [super dealloc];
}
@end
