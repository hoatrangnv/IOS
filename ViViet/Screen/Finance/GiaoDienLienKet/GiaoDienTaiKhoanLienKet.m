//
//  GiaoDienTaiKhoanLienKet.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 10/4/16.
//
//

#import "GiaoDienTaiKhoanLienKet.h"
#import "ItemTaiKhoanLienKet.h"
#import "GiaoDienDanhSachTaiKhoanLienKet.h"
@interface GiaoDienTaiKhoanLienKet ()<UIPickerViewDelegate, UIPickerViewDataSource, GiaoDienDanhSachTaiKhoanLienKetDelegate> {
    NSArray *arrBank;
    int nIndexBank, nIndexBankTemp;
    NSMutableArray *arrTaiKhoan;
    ItemTaiKhoanLienKet *itemMacDinh;
}

@end

@implementation GiaoDienTaiKhoanLienKet

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Liên kết tài khoản / thẻ";
    self.mFuncID = 446;
//    [self addTitleView:@"Tài khoản liên kết"];
//    NSString *sDsBank = @"Chọn ngân hàng/BID - Đầu tư và phát triển Việt Nam/CTG - Công thương Việt Nam/VCB - Ngoại thương Việt Nam/ABB - An bình/ACB - Á châu/BAB - Bắc á/BVB - Bảo Việt/EAB - Đông á/EIB - Xuất nhập khẩu Việt Nam/GPB - Dầu khí toàn cầu/HDB - Phát triển TPHCM/KLB - Kiên Long/LPB - Bưu điện Liên Việt/MB - Quân đội/MSB - Hàng hải/NAB - Nam á/NCB - Quốc dân/OCB -  Phương đông/OJB - Đại dương/PGB - Xăng dầu Petrolimex/PVB - Đại chúng Việt Nam/SCB - Sài Gòn/SEAB - Đông nam á/SGB - Sài Gòn công thương/SHB - Sài Gòn - Hà Nội/STB - Sài Gòn thương tín/TCB - Kỹ thương Việt Nam/TPB - Tiên Phong/VAB - Việt Á/VB - Việt Nam thương tín/VCCB - Bản Việt/VIB - Quốc tế/VPB - Việt Nam thịnh vượng";
    NSString *sDsBank = @"Chọn ngân hàng/TPB - Ngân hàng Tiên Phong/ACB - Á châu/BID - Đầu tư và phát triển Việt Nam/CTG - Công thương Việt Nam/LPB - Bưu điện Liên Việt/NAB - Nam á/TCB - Kỹ thương Việt Nam/VCB - Ngoại thương Việt Nam/ABB - An bình/BAB - Bắc á/BVB - Bảo Việt/EAB - Đông á/EIB - Xuất nhập khẩu Việt Nam/GPB - Dầu khí toàn cầu/HDB - Phát triển TPHCM/KLB - Kiên Long/MB - Quân đội/MSB - Hàng hải/NCB - Quốc dân/OCB - Phương đông/OJB - Đại dương/PGB - Xăng dầu Petrolimex/PVB - Đại chúng Việt Nam/SCB - Sài Gòn/SEAB - Đông nam á/SGB - Sài Gòn công thương/SHB - Sài Gòn Hà Nội/STB - Sài Gòn thương tín/VAB - Việt á/VB - Việt Nam thương tín/VCCB - Bản Việt/VIB - Quốc tế/VPB - Việt Nam thịnh vượng";
    nIndexBank = -1;
    nIndexBankTemp = 0;
    NSArray *arrTemp = [sDsBank componentsSeparatedByString:@"/"];
    arrBank = [[NSArray alloc] initWithArray:arrTemp];
    NSLog(@"%s - arrBank.count : %ld", __FUNCTION__, (long)arrBank.count);
    _edBank.text = [arrBank objectAtIndex:0];
    [self.mbtnThucHien setTitle:@"Lưu" forState:UIControlStateNormal];
    [self khoiTaoGiaoDienTextFeild:self.edBank nTag:100];
    [self.edNgayMoThe setMax_length:2];
    [self.edNamMoThe setMax_length:2];
    
//    self.edTenDangNhap.delegate = self;
//    self.edMatKhau.delegate = self;
    [self.edTenDangNhap addTarget:self action:@selector(tenDangNhapDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.edMatKhau addTarget:self action:@selector(matKhauDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.edSoTK addTarget:self action:@selector(soTaiKhoanDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.edSoThe addTarget:self action:@selector(soTheDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.edNgayMoThe addTarget:self action:@selector(thoiDiemMoTheDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.edNamMoThe addTarget:self action:@selector(thoiDiemMoTheDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)thoiDiemMoTheDidChange:(UITextField *)tf {
    if (tf.text.length == 0) {

    }
}

- (void)soTheDidChange:(UITextField *)tf {
    if (tf.text.length == 0) {

    }
}

- (void)soTaiKhoanDidChange:(UITextField *)tf {
    if (tf.text.length == 0) {
        [self.swMacDinh setOn:NO];
    }
}

- (void)tenDangNhapDidChange:(UITextField *)tf {
    if (tf.text.length > 0) {
        [self.lblKyTuDangNhap setHidden:NO];
        self.lblKyTuDangNhap.text = [NSString stringWithFormat:@"%d ký tự", (int)tf.text.length];
    }
    else {
        [self.lblKyTuDangNhap setHidden:YES];
        [self.swMacDinh setOn:NO];
    }
}

- (void)matKhauDidChange:(UITextField *)tf {
    if (tf.text.length > 0) {
        [self.lblMatKhauDangNhap setHidden:NO];
        self.lblMatKhauDangNhap.text = [NSString stringWithFormat:@"%d ký tự", (int)tf.text.length];
    }
    else {
        [self.lblMatKhauDangNhap setHidden:YES];
        [self.swMacDinh setOn:NO];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setAnimationChoSoTay:self.btnSoTay];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.btnSoTay.imageView stopAnimating];
}

- (void)khoiTaoGiaoDienTextFeild:(ExTextField *)edTemp nTag:(int)nTag{
    if (!edTemp.rightView) {
        UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 12)];
        [btnRight setBackgroundImage:[UIImage imageNamed:@"muiten35x21.png"] forState:UIControlStateNormal];
        edTemp.rightView = btnRight;
        edTemp.rightViewMode = UITextFieldViewModeAlways;

        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
        toolBar.barStyle = UIBarStyleBlackOpaque;
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneChonBank:)];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelChonBank:)];
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
}

- (void)doneChonBank:(UIBarButtonItem *)sender {
    nIndexBank = nIndexBankTemp;
    self.edBank.text = [arrBank objectAtIndex:nIndexBank];
    [self.edBank resignFirstResponder];
}

- (void)cancelChonBank:(UIBarButtonItem *)sender {
    [self.edBank resignFirstResponder];
}

- (void)layDanhSachTheLienKet {
    self.mDinhDanhKetNoi = @"LAY_DANH_SACH_LIEN_KET";
    [GiaoDichMang layDanhSachTaiKhoanLienKet:self];
}

#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return arrBank.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [arrBank objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    nIndexBankTemp = (int)row;
}

#pragma mark - Xu ly ket noi thanh cong
- (void)xuLyKetNoiThanhCong:(NSString*)sDinhDanhKetNoi thongBao:(NSString*)sThongBao ketQua:(id)ketQua
{
    if ([sDinhDanhKetNoi isEqualToString:@"LAY_DANH_SACH_LIEN_KET"]) {
        NSLog(@"%s - ketQua : %@", __FUNCTION__, ketQua);
        if (!arrTaiKhoan) {
            arrTaiKhoan = [[NSMutableArray alloc] init];
        }
        [arrTaiKhoan removeAllObjects];
        NSArray *arrTemp = (NSArray *)ketQua;
        for (NSDictionary *dict in arrTemp) {
            ItemTaiKhoanLienKet *item = [[ItemTaiKhoanLienKet alloc] khoiTao:dict];
            if (item.danhDauTKMacDinh == 1) {
                itemMacDinh = item;
                int nDem = 0;
                for (NSString *sBank in arrBank) {
                    if ([sBank hasPrefix:item.maNganHang]) {
                        _edBank.text = sBank;
                        nIndexBank = nDem;
                        break;
                    }
                    nDem ++;
                }
                _edChuTK.text = item.tenChuTaiKhoan;
                _edSoTK.text = item.soTaiKhoan;
                _edTenDangNhap.text = item.u;
                _edMatKhau.text = item.p;
//                [_segLoaiTaiKhoan setSelectedSegmentIndex:item.tkMacDinh];
                [self.swMacDinh setOn:YES];
                [_segOTP setSelectedSegmentIndex:item.kieuXacThuc];
                [self.mbtnThucHien setTitle:@"Sửa" forState:UIControlStateNormal];
                break;
            }
            else {
                [self.swMacDinh setOn:NO];
            }
        }
    }
    else if ([self.mDinhDanhKetNoi isEqualToString:@"SUA_TAI_KHOAN_LIEN_KET"] || [self.mDinhDanhKetNoi isEqualToString:@"TAO_TAI_KHOAN_LIEN_KET"]){
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
            [self anLoading];
        }
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
    }
}

- (BOOL)validateVanTay {
    if (nIndexBank == -1) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng chọn ngân hàng liên kết"];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:@"Vui lòng chọn ngân hàng liên kết" delegate:nil cancelButtonTitle:@"Đóng" otherButtonTitles: nil];
//        [alert show];
        return NO;
    }
    if (![self.edSoThe.text isEmpty]) {
        if ([self.edNgayMoThe.text isEmpty] || [self.edNamMoThe.text isEmpty]) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập Tháng/Năm mở thẻ"];
            return NO;
        }
    }
    if (![self.edSoTK.text isEmpty]) {
        if ([self.edSoTK.text isEmpty]) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập số tài khoản internet banking"];
            return NO;
        }
        
        if ([self.edMatKhau.text isEmpty]) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập mật khẩu internet banking"];
            return NO;
        }
    }
    return YES;
}

- (void)xuLyThucHienKhiKiemTraThanhCongTraVeToken:(NSString *)sToken otp:(NSString *)sOtp {

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
        [self hienThiLoadingChuyenTien];
    }
    if (itemMacDinh) {
        self.mDinhDanhKetNoi = @"SUA_TAI_KHOAN_LIEN_KET";
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        NSString *sBank = [arrBank objectAtIndex:nIndexBank];
        NSArray *arrTemp = [sBank componentsSeparatedByString:@" - "];
        if (arrTemp.count == 2) {
            sBank = arrTemp[0];
        }
        [dic setValue:itemMacDinh.sId forKey:@"id"];
        [dic setValue:itemMacDinh.idVi forKey:@"idVi"];
        [dic setValue:sBank forKey:@"maNganHang"];
        [dic setValue:self.edChuTK.text forKey:@"tenChuTaiKhoan"];
        [dic setValue:self.edSoTK.text forKey:@"soTaiKhoan"];
        [dic setValue:self.edTenDangNhap.text forKey:@"u"];
        [dic setValue:self.edMatKhau.text forKey:@"p"];
        NSNumber *numberOTP = [NSNumber numberWithInteger:self.segOTP.selectedSegmentIndex];
        [dic setValue:numberOTP forKey:@"kieuXacThuc"];
//        int nMacDinh = 0;
//        if (self.swMacDinh.isOn) {
//            nMacDinh = 1;
//        }
//        NSNumber *numberLoaiTK = [NSNumber numberWithInteger:nMacDinh];
//        [dic setValue:numberLoaiTK forKey:@"tkMacDinh"];
        
        int nTKMacDinh = 0;
        int nTheMacDinh = 0;
        if (self.swMacDinh.isOn) {
            nTKMacDinh = 1;
        }
//        if (self.swMacDinhThe.isOn) {
//            nTheMacDinh = 1;
//        }
        [dic setValue:[NSNumber numberWithInt:nTKMacDinh] forKey:@"danhDauTKMacDinh"];
        [dic setValue:[NSNumber numberWithInt:nTheMacDinh] forKey:@"danhDauTheMacDinh"];
        
        [dic setValue:self.edSoThe.text forKey:@"soThe"];
        int cardMonth = 0;
        if (![self.edNgayMoThe.text isEmpty]) {
            cardMonth = [self.edNgayMoThe.text intValue];
        }
        
        int cardYear = 0;
        if (![self.edNamMoThe.text isEmpty]) {
            cardYear = [self.edNamMoThe.text intValue];
        }
        [dic setValue:[NSNumber numberWithInt:cardMonth] forKey:@"cardMonth"];
        [dic setValue:[NSNumber numberWithInt:cardYear] forKey:@"cardYear"];
        
        [dic setValue:sToken forKey:@"token"];
        [dic setValue:sOtp forKey:@"otpConfirm"];
        [dic setValue:[NSNumber numberWithInt:self.mTypeAuthenticate] forKey:@"typeAuthenticate"];
        [dic setValue:[NSNumber numberWithInt:APP_ID] forKey:@"appId"];
        [dic setValue:[NSNumber numberWithInt:VM_APP] forKey:@"VMApp"];
        NSString *sDic = [dic JSONString];
        NSLog(@"%s - sDic : %@)", __FUNCTION__, sDic);
        [GiaoDichMang editTaiKhoanLienKet:sDic noiNhanKetQua:self];
    }
    else {
        self.mDinhDanhKetNoi = @"TAO_TAI_KHOAN_LIEN_KET";
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        NSString *sBank = [arrBank objectAtIndex:nIndexBank];
        NSArray *arrTemp = [sBank componentsSeparatedByString:@" - "];
        if (arrTemp.count == 2) {
            sBank = arrTemp[0];
        }
        [dic setValue:[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP] forKey:@"idVi"];
        [dic setValue:sBank forKey:@"maNganHang"];
        [dic setValue:self.edChuTK.text forKey:@"tenChuTaiKhoan"];
        [dic setValue:self.edSoTK.text forKey:@"soTaiKhoan"];
        [dic setValue:self.edTenDangNhap.text forKey:@"u"];
        [dic setValue:self.edMatKhau.text forKey:@"p"];
        NSNumber *numberOTP = [NSNumber numberWithInteger:self.segOTP.selectedSegmentIndex];
        [dic setValue:numberOTP forKey:@"kieuXacThuc"];
        
//        NSNumber *numberLoaiTK = [NSNumber numberWithInteger:self.segLoaiTaiKhoan.selectedSegmentIndex];
//        [dic setValue:numberLoaiTK forKey:@"tkMacDinh"];
        int nTKMacDinh = 0;
        int nTheMacDinh = 0;
        if (self.swMacDinh.isOn) {
            nTKMacDinh = 1;
        }
//        if (self.swMacDinhThe.isOn) {
//            nTheMacDinh = 1;
//        }
        [dic setValue:[NSNumber numberWithInt:nTKMacDinh] forKey:@"danhDauTKMacDinh"];
        [dic setValue:[NSNumber numberWithInt:nTheMacDinh] forKey:@"danhDauTheMacDinh"];
        
        [dic setValue:self.edSoThe.text forKey:@"soThe"];
        int cardMonth = 0;
        if (![self.edNgayMoThe.text isEmpty]) {
            cardMonth = [self.edNgayMoThe.text intValue];
        }
        
        int cardYear = 0;
        if (![self.edNamMoThe.text isEmpty]) {
            cardYear = [self.edNamMoThe.text intValue];
        }
        [dic setValue:[NSNumber numberWithInt:cardMonth] forKey:@"cardMonth"];
        [dic setValue:[NSNumber numberWithInt:cardYear] forKey:@"cardYear"];
        
        [dic setValue:sToken forKey:@"token"];
        [dic setValue:sOtp forKey:@"otpConfirm"];
        [dic setValue:[NSNumber numberWithInt:self.mTypeAuthenticate] forKey:@"typeAuthenticate"];
        [dic setValue:[NSNumber numberWithInt:APP_ID] forKey:@"appId"];
        [dic setValue:[NSNumber numberWithInt:VM_APP] forKey:@"VMApp"];
        NSString *sDic = [dic JSONString];
        NSLog(@"%s - sDic : %@)", __FUNCTION__, sDic);
        [GiaoDichMang taoTaiKhoanLienKet:sDic noiNhanKetQua:self];
    }
}

- (IBAction)suKienChonSoTay:(id)sender {
    GiaoDienDanhSachTaiKhoanLienKet *vc = [[GiaoDienDanhSachTaiKhoanLienKet alloc] initWithNibName:@"GiaoDienDanhSachTaiKhoanLienKet" bundle:nil];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
    vc.delegate = self;
    [vc release];
}

- (IBAction)suKienChonSwitchThe:(id)sender {
    if ([self.edChuTK.text isEmpty] || [self.edSoThe.text isEmpty] || [self.edNgayMoThe.text isEmpty] || [self.edNamMoThe.text isEmpty]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Thông tin thẻ không được để trống"];

        return;
    }

    [self.swMacDinh setOn:NO];
}

- (IBAction)suKienTouchInsideTaiKhoan:(id)sender {
//    if ([self.edChuTK.text isEmpty] || [self.edSoTK.text isEmpty] || [self.edTenDangNhap.text isEmpty] || [self.edMatKhau.text isEmpty]) {
//        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Thông tin tài khoản không được để trống"];
//        [self.swMacDinh setOn:NO];
//        return;
//    }
//    [self.swMacDinh setOn:!self.swMacDinh.isOn];
}

- (void)suKienChinhSuaTaiKhoanLienKet:(ItemTaiKhoanLienKet *)taiKhoan {
    itemMacDinh = taiKhoan;
    int nDem = 0;
    for (NSString *sBank in arrBank) {
        if ([sBank hasPrefix:itemMacDinh.maNganHang]) {
            _edBank.text = sBank;
            nIndexBank = nDem;
            break;
        }
        nDem ++;
    }
    _edChuTK.text = itemMacDinh.tenChuTaiKhoan;
    _edSoTK.text = itemMacDinh.soTaiKhoan;
    _edTenDangNhap.text = itemMacDinh.u;
    _edMatKhau.text = itemMacDinh.p;
    if (![_edTenDangNhap.text isEmpty]) {
        [self.lblKyTuDangNhap setHidden:NO];
        self.lblKyTuDangNhap.text = [NSString stringWithFormat:@"%d ký tự", (int)_edTenDangNhap.text.length];
    }
    else {
        [self.lblKyTuDangNhap setHidden:YES];
    }
    
    if (![_edMatKhau.text isEmpty]) {
        [self.lblMatKhauDangNhap setHidden:NO];
        self.lblMatKhauDangNhap.text = [NSString stringWithFormat:@"%d ký tự", (int)_edMatKhau.text.length];
    }
    else {
        [self.lblMatKhauDangNhap setHidden:YES];
    }
    
    _edSoThe.text = itemMacDinh.soThe;
    if (itemMacDinh.cardMonth > 0) {
        if (itemMacDinh.cardMonth < 10) {
            _edNgayMoThe.text = [NSString stringWithFormat:@"0%d", itemMacDinh.cardMonth];
        }
        else {
            _edNgayMoThe.text = [NSString stringWithFormat:@"%d", itemMacDinh.cardMonth];
        }
    }
    else {
        _edNgayMoThe.text = @"";
    }
    
    if (itemMacDinh.cardYear > 0) {
        if (itemMacDinh.cardYear < 10) {
            _edNamMoThe.text = [NSString stringWithFormat:@"0%d", itemMacDinh.cardYear];
        }
        else {
            _edNamMoThe.text = [NSString stringWithFormat:@"%d", itemMacDinh.cardYear];
        }
    }
    else {
        _edNamMoThe.text = @"";
    }
    
//    [_segLoaiTaiKhoan setSelectedSegmentIndex:itemMacDinh.tkMacDinh];
    [self.swMacDinh setOn:YES];
    if (itemMacDinh.danhDauTKMacDinh == 0) {
        [self.swMacDinh setOn:NO];
    }

    [_segOTP setSelectedSegmentIndex:itemMacDinh.kieuXacThuc];
    [self.mbtnThucHien setTitle:@"Sửa" forState:UIControlStateNormal];
}

- (void)dealloc {
    [_edBank release];
    [_edChuTK release];
    [_edSoTK release];
    [_edTenDangNhap release];
    [_edMatKhau release];
    [_segOTP release];
    [_segLoaiTaiKhoan release];
    [_swMacDinh release];
    [_edSoThe release];
    [_edNgayMoThe release];
    [_edNamMoThe release];
    [_lblKyTuDangNhap release];
    [_lblMatKhauDangNhap release];

    [super dealloc];
}
@end
