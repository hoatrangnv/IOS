

#import "LienketViewController.h"
#import "GiaoDienDanhSachTaiKhoanLienKet.h"
#import "GiaodientaikhoantheViewController.h"
#import "GiaodientaikhoannganhangViewController.h"
#import "DanhsachNganHangViewController.h"
@interface LienketViewController ()<UIPickerViewDelegate, UIPickerViewDataSource,GiaoDienDanhSachTaiKhoanLienKetDelegate,DanhsachNganHangViewControllerDelegate,UITextFieldDelegate>
{
    NSArray *arrBank;
    NSInteger nIndexBank, nIndexBankTemp;
    BOOL isMacdinh;
    ItemTaiKhoanLienKet *itemMacDinh;
    IBOutlet NSLayoutConstraint *contraintLeading;
    
}
@end

@implementation LienketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mFuncID = 446;
    nIndexBank = -1;
    nIndexBankTemp = 0;
    NSString *sDsBank = @"TPB - Ngân hàng Tiên Phong/ACB - Á châu/BID - Đầu tư và phát triển Việt Nam/CTG - Công thương Việt Nam/LPB - Bưu điện Liên Việt/NAB - Nam á/TCB - Kỹ thương Việt Nam/VCB - Ngoại thương Việt Nam/ABB - An bình/BAB - Bắc á/BVB - Bảo Việt/EAB - Đông á/EIB - Xuất nhập khẩu Việt Nam/GPB - Dầu khí toàn cầu/HDB - Phát triển TPHCM/KLB - Kiên Long/MB - Quân đội/MSB - Hàng hải/NCB - Quốc dân/OCB - Phương đông/OJB - Đại dương/PGB - Xăng dầu Petrolimex/PVB - Đại chúng Việt Nam/SCB - Sài Gòn/SEAB - Đông nam á/SGB - Sài Gòn công thương/SHB - Sài Gòn Hà Nội/STB - Sài Gòn thương tín/VAB - Việt á/VB - Việt Nam thương tín/VCCB - Bản Việt/VIB - Quốc tế/VPB - Việt Nam thịnh vượng/Visa/MasterCard/JCB";
    NSArray *arrTemp = [sDsBank componentsSeparatedByString:@"/"];
    arrBank = [[NSArray alloc] initWithArray:arrTemp];
    NSLog(@"%s - arrBank.count : %ld", __FUNCTION__, (long)arrBank.count);
    _edBank.text = @"Chọn ngân hàng";
    _edBank.delegate = self;
    [self khoiTaoGiaoDienTextFeild:self.edBank nTag:100];
    self.btnThucHien.hidden = true;
    self.txtOtp.hidden = true;
    [self.btnSelect setBackgroundImage:[UIImage imageNamed:@"checkbox-unselected"] forState:UIControlStateNormal];
    [self.btnSelect setBackgroundImage:[UIImage imageNamed:@"checkbox-selected"] forState:UIControlStateSelected];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)khoiTaoGiaoDienTextFeild:(ExTextField *)edTemp nTag:(int)nTag{
    if (!edTemp.rightView) {
        UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 12)];
        [btnRight setBackgroundImage:[UIImage imageNamed:@"muiten35x21.png"] forState:UIControlStateNormal];
        edTemp.rightView = btnRight;
        edTemp.rightViewMode = UITextFieldViewModeAlways;
    }
}
- (void)layDanhSachTheLienKet {
    self.mDinhDanhKetNoi = @"LAY_DANH_SACH_LIEN_KET";
    [GiaoDichMang layDanhSachTaiKhoanLienKet:self];
}
- (IBAction)suKienChonSoTay:(id)sender {
    GiaoDienDanhSachTaiKhoanLienKet *vc = [[GiaoDienDanhSachTaiKhoanLienKet alloc] initWithNibName:@"GiaoDienDanhSachTaiKhoanLienKet" bundle:nil];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
    vc.delegate = self;
    [vc release];
}
- (void)dealloc {
    [_edBank release];
    [super dealloc];
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
- (void)doneChonBank:(UIBarButtonItem *)sender {
    nIndexBank = nIndexBankTemp;
    self.edBank.text = [arrBank objectAtIndex:nIndexBank];
    [self.edBank resignFirstResponder];
}

- (void)cancelChonBank:(UIBarButtonItem *)sender {
    [self.edBank resignFirstResponder];
}

- (void)xuLyKhiKhongCoChucNangQuetVanTay
{
    _btnVanTay.hidden = YES;
    _txtOtp.hidden = NO;
    _btnThucHien.hidden = NO;
    _btnToken.hidden = NO;
    contraintLeading.constant = ([UIScreen mainScreen].bounds.size.width - _btnToken.frame.size.width)/2 - _btnToken.frame.size.width/2;

}

- (void)xuLyKhiCoChucNangQuetVanTay
{
    _btnVanTay.hidden = NO;
    _txtOtp.hidden = YES;
    _btnThucHien.hidden = YES;
    _btnToken.hidden = YES;
    _btnVanTay.center = self.view.center;
    contraintLeading.constant = 106;
}

- (void)xuLySuKienDangNhapVanTay
{
    [self xuLySuKienHienThiChucNangVanTayVoiTieuDe:[@"su_dung_van_tay_dang_nhap_tai_khoan_token_VIMASS" localizableString]];
}

- (void)xuLySuKienXacThucVanTayThanhCong
{
    if (nIndexBank < 0 ){
        [UIAlertView alert:@"Vui lòng chọn mã ngân hàng" withTitle:[@"thong_bao" localizableString] block:nil];
        return;
    }
    [self thuchienxuly];
}

- (void)hienThiThongBaoDienMatKhau
{
    [UIAlertView alert:[@"thong_bao_xac_thuc_van_tay_khong_dung" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
}
- (IBAction)doToken:(id)sender{
    [self.btnToken setSelected:YES];
    [self.btnToken setBackgroundImage:[UIImage imageNamed:@"tokenv"] forState:UIControlStateSelected];
    [self.btnVanTay setSelected:NO];
    self.btnToken.hidden = false;
    self.txtOtp.hidden = NO;
    self.btnThucHien.hidden = NO;
}
- (IBAction)doThucHien:(id)sender{
    self.mTypeAuthenticate = TYPE_kieuXacThuc_token;
    if (nIndexBank < 0 ){
          [UIAlertView alert:@"Vui lòng chọn mã ngân hàng" withTitle:[@"thong_bao" localizableString] block:nil];
        return;
    }
    [self thuchienxuly];
}
- (IBAction)doVantay:(id)sender{
    self.mTypeAuthenticate = TYPE_kieuXacThuc_khac;
    [self.btnVanTay setBackgroundImage:[UIImage imageNamed:@"finger"] forState:UIControlStateNormal];
    [self.btnVanTay setBackgroundImage:[UIImage imageNamed:@"fingerv"] forState:UIControlStateSelected];
    [self.btnVanTay setSelected:YES];
    [self.btnToken setSelected:NO];
    self.txtOtp.hidden = YES;
    self.btnThucHien.hidden = YES;
    
    NSString *sKeyDangNhap = [DucNT_LuuRMS layThongTinDangNhap:KEY_DANG_NHAP];
    if(sKeyDangNhap.length > 0)
    {
        [self xuLySuKienHienThiChucNangDangNhapVanTayVoiTieuDe:[@"su_dung_van_tay_dang_nhap_tai_khoan_VIMASS" localizableString]];
    }
    else
    {
        [UIAlertView alert:[@"thong_bao_chua_co_xac_thuc_van_tay" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
    }
}
- (IBAction)onMacding:(id)sender {
    isMacdinh = !isMacdinh;
    [self.btnSelect setSelected:isMacdinh];
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
    self.edChuTK.text = itemMacDinh.tenChuTaiKhoan;
    [self taikhoanLienket:itemMacDinh];
    if ([self isKindOfClass:[GiaodientaikhoannganhangViewController class]]) {
        isMacdinh =  @(itemMacDinh.danhDauTKMacDinh).boolValue;
    } else {
        isMacdinh =  @(itemMacDinh.danhDauTheMacDinh).boolValue;
    }
    [self.btnSelect setSelected:isMacdinh];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changetab" object:taiKhoan];

}
-(void)taikhoanLienket:(ItemTaiKhoanLienKet*)tkLienket {
    
}
-(void)suataikhoanlienket:(ItemTaiKhoanLienKet*)tkLienket sbank:(NSString*)sBank macdinh:(BOOL)isMacdinh{
    
}
-(void)taotaikhoanlienket:(NSString*)sBank macdinh:(BOOL)isMacdinh{
    
}


#pragma mark - Call API
- (void)edittaikhoanlienket:(NSDictionary*)dic {
    NSString *sDic = [dic JSONString];
    NSLog(@"%s - sDic : %@)", __FUNCTION__, sDic);
    [GiaoDichMang editTaiKhoanLienKet:sDic noiNhanKetQua:self];
    return;
    if (nIndexBank == -1) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng chọn ngân hàng liên kết"];
        return;
    }
    if ([self isKindOfClass:[GiaodientaikhoantheViewController class]]) {
        if ([dic valueForKey:@"cvv"]) {
            if ([[dic objectForKey:@"cardMonthExp"] intValue] == 0 || [[dic objectForKey:@"cardYearExp"] intValue] == 0) {
                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập Tháng/Năm hết hạn"];
                return;
            }
            if ([[dic valueForKey:@"cvv"] isEmpty]) {
                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập CVV"];
                return;
            }

        } else {
            if ([[dic objectForKey:@"cardMonth"] intValue] == 0 || [[dic objectForKey:@"cardYear"] intValue] == 0) {
                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập Tháng/Năm mở thẻ"];
                return;
            }

        }
    } else {
        if (![[dic objectForKey:@"soTaiKhoan"] isEmpty]) {
            if ([[dic objectForKey:@"u"] isEmpty]) {
                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập số tài khoản "];
                return;
            }
            if ([[dic objectForKey:@"p"] isEmpty]) {
                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập mật khẩu internet banking"];
                return;
            }
        }

    }


}
-(void)taotaikhoanlienket:(NSDictionary*)dic{
    NSString *sDic = [dic JSONString];
    NSLog(@"%s - sDic : %@)", __FUNCTION__, sDic);
    if (nIndexBank == -1) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng chọn ngân hàng liên kết"];
        return;
    }
    if ([self isKindOfClass:[GiaodientaikhoantheViewController class]]) {
        if ([dic valueForKey:@"cvv"]) {
            if ([[dic objectForKey:@"cardMonthExp"] intValue] == 0 || [[dic objectForKey:@"cardYearExp"] intValue] == 0) {
                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập Tháng/Năm hết hạn"];
                return;
            }
            if ([[dic valueForKey:@"cvv"] isEmpty]) {
                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập CVV"];
                return;
            }

            
        } else {
            if ([[dic objectForKey:@"cardMonth"] intValue] == 0 || [[dic objectForKey:@"cardYear"] intValue] == 0) {
                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập Tháng/Năm mở thẻ"];
                return;
            }
            
        }

    } else {
        if (![[dic objectForKey:@"soTaiKhoan"] isEmpty]) {
            if ([[dic objectForKey:@"u"] isEmpty]) {
                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập số tài khoản internet banking"];
                return;
            }
            if ([[dic objectForKey:@"p"] isEmpty]) {
                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập mật khẩu internet banking"];
                return;
            }
        }
    }
    [GiaoDichMang taoTaiKhoanLienKet:sDic noiNhanKetQua:self];
}
- (void)thuchienxuly{
    NSString *sBank = [arrBank objectAtIndex:nIndexBank];
    NSArray *arrTemp = [sBank componentsSeparatedByString:@" - "];
    if (arrTemp.count == 2) {
        sBank = arrTemp[0];
    }

    if (itemMacDinh) {
        self.mDinhDanhKetNoi = @"SUA_TAI_KHOAN_LIEN_KET";
        [self suataikhoanlienket:itemMacDinh sbank:sBank macdinh:isMacdinh];
    } else {
        self.mDinhDanhKetNoi = @"TAO_TAI_KHOAN_LIEN_KET";
        [self taotaikhoanlienket:sBank macdinh:isMacdinh];
    }
}
#pragma mark - Xu ly ket noi thanh cong
- (void)xuLyKetNoiThanhCong:(NSString*)sDinhDanhKetNoi thongBao:(NSString*)sThongBao ketQua:(id)ketQua
{
    if ([sDinhDanhKetNoi isEqualToString:@"LAY_DANH_SACH_LIEN_KET"]) {
        
    }
    else if ([self.mDinhDanhKetNoi isEqualToString:@"SUA_TAI_KHOAN_LIEN_KET"] || [self.mDinhDanhKetNoi isEqualToString:@"TAO_TAI_KHOAN_LIEN_KET"]){
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
            [self anLoading];
        }
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
    }
}
#pragma mark - others
-(void)setIndexSelected:(NSInteger)indexSelected {
    nIndexBank = indexSelected;
    self.edBank.text = [arrBank objectAtIndex:nIndexBank];
    [self.edBank resignFirstResponder];
    if ([self isKindOfClass:[GiaodientaikhoantheViewController class]]) {
        [(GiaodientaikhoantheViewController*)self showCvvField:self.edBank.text];
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    DanhsachNganHangViewController * ds = [[DanhsachNganHangViewController alloc] initWithNibName:@"DanhsachNganHangViewController" bundle:nil];
    ds.delegate = self;
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:ds];
    [self presentViewController:nav animated:YES completion:nil];
}
#pragma mark -DanhsachNganHangViewControllerDelegate
-(void)didSeletedBank:(NSInteger)indexSelected {
    [self setIndexSelected:indexSelected];
}
@end
