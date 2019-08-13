//
//  GiaoDienTaoTheLuu.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 11/18/15.
//
//

#import "GiaoDienTaoTheLuu.h"
#import "DucNT_TaiKhoanThuongDungObject.h"
#import "NganHangNapTien.h"
#import "TheNapTien.h"

@interface GiaoDienTaoTheLuu ()<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>{
    int nHinhThucThe;
    int nIndexBank;
    NSString *sCountryCode;
    NSMutableArray *arrBank, *dsCountryCode;
}

@end

@implementation GiaoDienTaoTheLuu
@synthesize objTheLuu;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%s - khoi tao giao dien sua so tay nap tien", __FUNCTION__);
    sCountryCode = @"VN";
    self.mFuncID = FUNC_THEM_CAP_NHAT_TAI_KHOAN_THUONG_DUNG;
    [self addBackButton:YES];
    nHinhThucThe = 9;
    nIndexBank = 0;
    [self.edSoThe setMax_length:19];
    self.edHo.delegate = self;
    self.edTenChuThe.delegate = self;
//    self.edTen.delegate = self;
    [self khoiTaoGiaoDienBanDau];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.nTrangThai == 0) {
        self.title = @"Thêm thẻ lưu";
    }
    else{
        self.title = @"Thay đổi thẻ lưu";
        [self capNhatThongTinThe];
    }
}

- (void)didSelectBackButton
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSRange lowercaseCharRange = [string rangeOfCharacterFromSet:[NSCharacterSet lowercaseLetterCharacterSet]];

    if (lowercaseCharRange.location != NSNotFound) {
        textField.text = [textField.text stringByReplacingCharactersInRange:range
                                                                 withString:[string uppercaseString]];
        return NO;
    }
    return YES;
}

- (void)khoiTaoGiaoDienBanDau{
    [self.edCVV setMax_length:3];
    [self.edSoThe setMax_length:19];
    self.edChonLoaiThe2.hidden = NO;
    self.viewTheVisa.hidden = NO;
    self.viewNoiDia.hidden = YES;

    if (!self.edChonLoaiThe2.rightView) {
        UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 12)];
        [btnRight setBackgroundImage:[UIImage imageNamed:@"muiten35x21.png"] forState:UIControlStateNormal];
        self.edChonLoaiThe2.rightView = btnRight;
        self.edChonLoaiThe2.rightViewMode = UITextFieldViewModeAlways;
    }

    CGRect rectViewVisa = self.viewTheVisa.frame;
    CGRect rectViewMain = self.mViewMain.frame;
    CGRect rectViewXacNhan = self.viewXacNhan.frame;
    CGRect rectEdLoaiThe = self.edChonLoaiThe2.frame;
    CGRect rButtonVanTay = self.mbtnVanTay.frame;

    rectViewVisa.origin.y = rectEdLoaiThe.origin.y + rectEdLoaiThe.size.height + 8;
    self.viewTheVisa.frame = rectViewVisa;
    rectViewXacNhan.origin.y = rectViewVisa.origin.y + rectViewVisa.size.height + 8;
    self.viewXacNhan.frame = rectViewXacNhan;
    if (![self.mViewMain.subviews containsObject:self.viewTheVisa]) {
        [self.mViewMain addSubview:self.viewTheVisa];
    }
    
    rectViewMain.size.height = rectViewXacNhan.origin.y + rectViewXacNhan.size.height + 10;
    self.mViewMain.frame = rectViewMain;

    if(self.mbtnVanTay.isHidden)
    {
        [self.scrMain setContentSize:CGSizeMake(self.scrMain.frame.size.width, rectViewMain.size.height + 100)];
    }
    else{
        rButtonVanTay.origin.y = rectViewMain.origin.y + rectViewMain.size.height + 10;
        self.mbtnVanTay.frame = rButtonVanTay;
        [self.scrMain setContentSize:CGSizeMake(self.scrMain.frame.size.width, rectViewMain.origin.y + rectViewMain.size.height + rButtonVanTay.size.height + 100)];
    }

    UIPickerView *picThe = [[UIPickerView alloc] init];
    picThe.delegate = self;
    picThe.dataSource = self;
    picThe.tag = 100;
    self.edChonLoaiThe2.inputView = picThe;
    self.edChonLoaiThe2.inputAccessoryView = nil;
    [picThe release];

    UIPickerView *picThang = [[UIPickerView alloc] init];
    picThang.delegate = self;
    picThang.dataSource = self;
    picThang.tag = 101;
    self.edThangHetHan.inputView = picThang;
    [picThang release];

    if (!self.edThangHetHan.rightView) {
        UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 12)];
        [btnRight setBackgroundImage:[UIImage imageNamed:@"muiten35x21.png"] forState:UIControlStateNormal];
        self.edThangHetHan.rightView = btnRight;
        self.edThangHetHan.rightViewMode = UITextFieldViewModeAlways;
    }


    UIPickerView *picNam = [[UIPickerView alloc] init];
    picNam.delegate = self;
    picNam.dataSource = self;
    picNam.tag = 102;
    self.edNamHetHan.inputView = picNam;
    [picNam release];

//    UIPickerView *picCountry = [[UIPickerView alloc] init];
//    picCountry.delegate = self;
//    picCountry.dataSource = self;
//    picCountry.tag = 110;
//    self.edCountry.inputView = picCountry;
//    [picCountry release];

    if (!self.edNamHetHan.rightView) {
        UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 12)];
        [btnRight setBackgroundImage:[UIImage imageNamed:@"muiten35x21.png"] forState:UIControlStateNormal];
        self.edNamHetHan.rightView = btnRight;
        self.edNamHetHan.rightViewMode = UITextFieldViewModeAlways;
    }
}

- (void)khoiTaoTheNoiDia{

    [self.edSoTheNoiDia setMax_length:16];
    [self.edNamMo setMax_length:2];
    if (!self.edBank.rightView) {
        UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 12)];
        [btnRight setBackgroundImage:[UIImage imageNamed:@"muiten35x21.png"] forState:UIControlStateNormal];
        self.edBank.rightView = btnRight;
        self.edBank.rightViewMode = UITextFieldViewModeAlways;
    }

    if (!arrBank) {
        arrBank = [[NSMutableArray alloc] init];
        NSArray *arrTemp = [NganHangNapTien layDanhSachNganHangNapTien];
        for (NganHangNapTien *temp in arrTemp) {
            if ([temp.trangThaiDirect intValue] == 1) {
                [arrBank addObject:temp];
            }
        }
    }

    self.viewTheVisa.hidden = YES;
    self.viewNoiDia.hidden = NO;
    self.edChonLoaiThe2.hidden = YES;
    CGRect rectViewVisa = self.viewNoiDia.frame;
    CGRect rectViewMain = self.mViewMain.frame;
    CGRect rectViewXacNhan = self.viewXacNhan.frame;
    CGRect rectEdLoaiThe = self.edChonLoaiThe2.frame;
    CGRect rButtonVanTay = self.mbtnVanTay.frame;

    rectViewVisa.origin.y = rectEdLoaiThe.origin.y;
    self.viewNoiDia.frame = rectViewVisa;
    rectViewXacNhan.origin.y = rectViewVisa.origin.y + rectViewVisa.size.height + 8;
    self.viewXacNhan.frame = rectViewXacNhan;
    if (![self.mViewMain.subviews containsObject:self.viewNoiDia]) {
        [self.mViewMain addSubview:self.viewNoiDia];
    }

    rectViewMain.size.height = rectViewXacNhan.origin.y + rectViewXacNhan.size.height + 10;
    self.mViewMain.frame = rectViewMain;

    if(self.mbtnVanTay.isHidden)
    {
        [self.scrMain setContentSize:CGSizeMake(self.scrMain.frame.size.width, rectViewMain.size.height + 100)];
    }
    else{
        rButtonVanTay.origin.y = rectViewMain.origin.y + rectViewMain.size.height + 10;
        self.mbtnVanTay.frame = rButtonVanTay;
        [self.scrMain setContentSize:CGSizeMake(self.scrMain.frame.size.width, rectViewMain.origin.y + rectViewMain.size.height + rButtonVanTay.size.height + 100)];
    }

    UIPickerView *picNam = [[UIPickerView alloc] init];
    picNam.delegate = self;
    picNam.dataSource = self;
    picNam.tag = 103;
    self.edBank.inputView = picNam;
    [picNam release];

    [self.rbSMS setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
    [self.rbSMS setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
    [self.rbToken setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateSelected];
    [self.rbToken setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];

    [self.rbSMS setSelected:YES];

}

- (void)capNhatThongTinThe{
    if (self.objTheLuu) {
        if (objTheLuu.nType == 9) {
            self.edChonLoaiThe2.text = @"Visa";
            nHinhThucThe = 9;
        }
        else if (objTheLuu.nType == 11) {
            self.edChonLoaiThe2.text = @"MasterCard";
            nHinhThucThe = 11;
        }
        else if (objTheLuu.nType == 10) {
            self.edChonLoaiThe2.text = @"JCB";
            nHinhThucThe = 10;
        }
        else if (objTheLuu.nType == 8) {
            self.edChonLoaiThe2.text = @"Thẻ nội địa";
            nHinhThucThe = 8;
        }
        if(objTheLuu.nType == 8){
            [self khoiTaoTheNoiDia];
            [self.edChonLoaiThe2 setEnabled:NO];
            self.edNameAlias.text = objTheLuu.sAliasName;
//            self.edSoTheNoiDia.text = objTheLuu.sCardNumber;
            self.edSoTheNoiDia.text = @"";
            self.edTenChuThe.text = objTheLuu.sCardOwnerName;
            self.edThangMo.text = [NSString stringWithFormat:@"%d", objTheLuu.cardMonth];
            self.edNamMo.text = [NSString stringWithFormat:@"%d", objTheLuu.cardYear];
            if ([objTheLuu.otpGetType isEqualToString:otpGetTypeSMS]) {
                [self.rbSMS setSelected:YES];
            }
            else{
                [self.rbToken setSelected:YES];
            }
            for (NganHangNapTien *bank in arrBank) {
                TheNapTien *theNap = [bank.danhSachTheNapTien objectAtIndex:0];
                if ([theNap.idBank intValue] == objTheLuu.nBankCode) {
                    self.edBank.text = bank.tenBank;
                    break;
                }
            }
        }
        else{
            [self.edChonLoaiThe2 setEnabled:YES];
            self.edNameAliasQT.text = objTheLuu.sAliasName;
//            self.edSoThe.text = objTheLuu.sCardNumber;
            self.edSoThe.text = @"";
            self.edCVV.text = objTheLuu.cvv;
            self.edThangHetHan.text = [NSString stringWithFormat:@"%d", objTheLuu.cardMonth];
            NSString *sNam =[NSString stringWithFormat:@"%d", objTheLuu.cardYear];
            if (objTheLuu.cardYear < 100) {
                sNam = [NSString stringWithFormat:@"%d", (objTheLuu.cardYear + 2000)];
            }
            self.edNamHetHan.text = sNam;
            self.edHo.text = objTheLuu.sCardOwnerName;
        }
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 100) {
        return 3;
    }
    else if (pickerView.tag == 101){
        return 12;
    }
    else if (pickerView.tag == 102){
        return 11;
    }
    else if (pickerView.tag == 103){
        return arrBank.count;
    }
    else if (pickerView.tag == 110){
        if (!dsCountryCode) {
            dsCountryCode = [[NSMutableArray alloc] initWithArray:[NSLocale ISOCountryCodes]];
        }
        return dsCountryCode.count;
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 100) {
        if (row == 0) {
            return @"Visa";
        }
        else if (row == 1) {
            return @"MasterCard";
        }
        else if (row == 2) {
            return @"JCB";
        }
        else if (row == 3) {
            return @"Thẻ nội địa";
        }
    }
    else if (pickerView.tag == 101){
        return [NSString stringWithFormat:@"Tháng %d", (int)row + 1];
    }
    else if (pickerView.tag == 102){
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
        NSInteger year = [components year];
        return [NSString stringWithFormat:@"%d", (int)(year + row)];
    }
    else if (pickerView.tag == 103){
        NganHangNapTien *item = [arrBank objectAtIndex:row];
        return item.tenBank;
    }
    else if (pickerView.tag == 110){
        NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"vi_VN"];
        NSString *countryCode = [dsCountryCode objectAtIndex:row];
        NSString *displayNameString = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
        return displayNameString;
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 100){
        if (row == 0) {
            self.edChonLoaiThe2.text = @"Visa";
            nHinhThucThe = 9;
            if (self.viewTheVisa.hidden == YES) {
                [self khoiTaoGiaoDienBanDau];
            }
        }
        else if (row == 1) {
            self.edChonLoaiThe2.text = @"MasterCard";
            nHinhThucThe = 11;
            if (self.viewTheVisa.hidden == YES) {
                [self khoiTaoGiaoDienBanDau];
            }
        }
        else if (row == 2) {
            self.edChonLoaiThe2.text = @"JCB";
            nHinhThucThe = 10;
            if (self.viewTheVisa.hidden == YES) {
                [self khoiTaoGiaoDienBanDau];
            }
        }
        else if (row == 3) {
            self.edChonLoaiThe2.text = @"Thẻ nội địa";
            nHinhThucThe = 8;
            [self khoiTaoTheNoiDia];
        }
        [self.edChonLoaiThe2 resignFirstResponder];
    }
    else if (pickerView.tag == 101){
        self.edThangHetHan.text = [NSString stringWithFormat:@"%d", (int)row + 1];
        [self.edThangHetHan resignFirstResponder];
    }
    else if (pickerView.tag == 102){
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
        NSInteger year = [components year];
        self.edNamHetHan.text = [NSString stringWithFormat:@"%d", (int)(year + row)];
        [self.edNamHetHan resignFirstResponder];
    }
    else if (pickerView.tag == 103){
        NganHangNapTien *item = [arrBank objectAtIndex:row];
        self.edBank.text = item.tenBank;
        nIndexBank = (int)row;
        [self.edBank resignFirstResponder];
    }
    else if (pickerView.tag == 110){
        NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"vi_VN"];
        NSString *countryCode = [dsCountryCode objectAtIndex:row];
        NSString *displayNameString = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
        NSLog(@"%s - %@ - %@", __FUNCTION__, displayNameString, countryCode);
//        self.edCountry.text = displayNameString;
//        [self.edCountry resignFirstResponder];
        sCountryCode = countryCode;
    }
}

- (BOOL)validateVanTay{
    if (nHinhThucThe == 0) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng chọn loại thẻ."];
        return NO;
    }
    if (nHinhThucThe != 8) {
        if ([self.edNameAlias.text isEmpty]) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập tên hiển thị."];
            return NO;
        }
        if (self.edSoThe.text.length == 0) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập số thẻ."];
            return NO;
        }
        else if (self.edSoThe.text.length < 16){
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Số thẻ bao gồm 16 số."];
            return NO;
        }
        if (self.edThangHetHan.text.length == 0) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng chọn tháng hết hạn in trên thẻ."];
            return NO;
        }
        if (self.edNamHetHan.text.length == 0) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng chọn năm hết hạn in trên thẻ."];
            return NO;
        }
        if (self.edHo.text.length == 0) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập họ và tên in trên thẻ. Ví dụ: NGUYEN VAN A"];
            return NO;
        }
        if (self.edCVV.text.length > 0 && self.edCVV.text.length < 3){
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Số CVV gồm 3 số in phía sau thẻ. Vui lòng kiểm tra lại."];
            return NO;
        }
    }
    else{
        if (nIndexBank == -1) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng chọn ngân hàng phát hành thẻ"];
            return NO;
        }
        if (self.edSoTheNoiDia.text.length == 0) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập số thẻ."];
            return NO;
        }
        else if (self.edSoTheNoiDia.text.length < 16){
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Số thẻ bao gồm 16 số."];
            return NO;
        }
        else{
            NganHangNapTien *bank = [arrBank objectAtIndex:nIndexBank];
            BOOL bTonTai = NO;
            for (TheNapTien *theNap in bank.danhSachTheNapTien) {
                if ([self.edSoTheNoiDia.text hasPrefix:theNap.idTheBankNet]) {
                    bTonTai = YES;
                    break;
                }
            }
            if (!bTonTai) {
                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:[NSString stringWithFormat:@"Ngân hàng %@ không phát hành số thẻ này.", bank.tenBank]];
                return NO;
            }
        }
        if (self.edTenChuThe.text.length == 0) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập họ và tên in trên thẻ."];
            return NO;
        }
        if (self.edThangMo.text.length == 0){
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập tháng mở thẻ."];
            return NO;
        }
        else{
            int thang = [self.edThangMo.text intValue];
            if (thang < 0 || thang > 12) {
                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Tháng mở thẻ sai. Vui lòng kiểm tra lại."];
                return NO;
            }
        }
        if (self.edNamMo.text.length == 0){
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập năm mở thẻ."];
            return NO;
        }
        else if (self.edNamMo.text.length < 2){
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Năm mở thẻ sai. Vui lòng kiểm tra lại."];
            return NO;
        }
        else{
            int nNam = [self.edNamMo.text intValue];
            if (nNam < 0 || nNam > 99) {
                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Năm mở thẻ sai. Vui lòng kiểm tra lại."];
                return NO;
            }
            else{
                NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
                NSInteger year = [components year];
                NSInteger month = [components month];
                nNam = nNam + 2000;
                if (nNam > year) {
                    [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Năm mở thẻ phải nhỏ hơn hoặc bằng năm hiện tại."];
                    return NO;
                }
                else if (nNam == year){
                    int nThang = [self.edThangMo.text intValue];
                    if (nThang > month) {
                        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Tháng mở thẻ sai. Vui lòng kiểm tra lại."];
                        return NO;
                    }
                }
            }
//            else{
//                NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
//                NSInteger year = [components year];
//                if (thang > year) {
//                    [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Năm mở thẻ sai. Vui lòng kiểm tra lại."];
//                    return NO;
//                }
//            }
        }
    }
    return YES;
}

- (void)xuLyThucHienKhiKiemTraThanhCongTraVeToken:(NSString *)sToken otp:(NSString *)sOtp{
    self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_THEM_CAP_NHAT_TAI_KHOAN_THUONG_DUNG;
    if (objTheLuu) {

    }
    else{
        objTheLuu = [[DucNT_TaiKhoanThuongDungObject alloc] init];
    }
    objTheLuu.nType = nHinhThucThe;
    if (nHinhThucThe != 8) {
        objTheLuu.sAliasName = self.edNameAlias.text;
        objTheLuu.sCardNumber = self.edSoThe.text;
        objTheLuu.cvv = self.edCVV.text;
        objTheLuu.cardMonth = [self.edThangHetHan.text intValue];
        if (self.edNamHetHan.text.length == 4) {
            objTheLuu.cardYear = [self.edNamHetHan.text intValue] - 2000;
        }
        else
            objTheLuu.cardYear = [self.edNamHetHan.text intValue];
        objTheLuu.sCardOwnerName = self.edHo.text;
        objTheLuu.sPhoneOwner = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    }
    else{
        objTheLuu.sAliasName = self.edNameAliasQT.text;
        objTheLuu.sPhoneOwner = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
        objTheLuu.sCardNumber = self.edSoTheNoiDia.text;
        objTheLuu.sCardOwnerName = self.edTenChuThe.text;
        objTheLuu.cardMonth = [self.edThangMo.text intValue];
        if (self.edNamMo.text.length == 4) {
            objTheLuu.cardYear = [self.edNamMo.text intValue] - 2000;
        }
        else
            objTheLuu.cardYear = [self.edNamMo.text intValue];
        if (self.rbSMS.selected) {
            objTheLuu.otpGetType = otpGetTypeSMS;
        }
        else{
            objTheLuu.otpGetType = otpGetTypeToken;
        }
        NganHangNapTien *bank = [arrBank objectAtIndex:nIndexBank];
        TheNapTien *theNap = [bank.danhSachTheNapTien objectAtIndex:0];
        objTheLuu.nBankCode = [theNap.idBank intValue];
    }

    NSString *s4SoCuoi = [objTheLuu.sCardNumber substringFromIndex:(objTheLuu.sCardNumber.length - 4)];
    NSString *sCheSoThe = [NSString stringWithFormat:@"xxxxxxxxxxxx%@", s4SoCuoi];
    NSLog(@"%s - sCheSoThe : %@ - sCardNumber : %@", __FUNCTION__, sCheSoThe, objTheLuu.sCardNumber);
    if (objTheLuu.nType == 9) {
        objTheLuu.sAliasName = [NSString stringWithFormat:@"Visa - %@", sCheSoThe];
    }
    else if (objTheLuu.nType == 10) {
        objTheLuu.sAliasName = [NSString stringWithFormat:@"JCB - %@", sCheSoThe];
    }
    else if (objTheLuu.nType == 11) {
        objTheLuu.sAliasName = [NSString stringWithFormat:@"Master - %@", sCheSoThe];
    }
    else if (objTheLuu.nType == 8){
        objTheLuu.cvv = @"123";
        for (NganHangNapTien *temp in arrBank) {
            if ([temp.trangThaiDirect intValue] == 1) {
                TheNapTien *tienTemp = [temp.danhSachTheNapTien objectAtIndex:0];
                if ([tienTemp.idBank intValue] == objTheLuu.nBankCode) {
                    NSArray *arrTemp = [temp.tenBank componentsSeparatedByString:@"-"];
                    NSString *aliasName = [NSString stringWithFormat:@"%@- %@", [arrTemp objectAtIndex:0], sCheSoThe];
                    objTheLuu.sAliasName = aliasName;
                    break;
                }
            }
        }
    }

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[objTheLuu toDict]];
    [dict setValue:sOtp forKey:@"otpConfirm"];
    [dict setValue:[NSNumber numberWithInt:self.mTypeAuthenticate] forKey:@"typeAuthenticate"];
    [dict setValue:sToken forKey:@"token"];
    [dict setValue:[NSNumber numberWithInt:APP_ID] forKey:@"appId"];
    NSString *sMaDoanhNghiep = @"";
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sMaDoanhNghiep = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_COMPANY_ID];
    }
    [dict setValue:sMaDoanhNghiep forKey:@"companyCode"];

    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:self];
    [connect connect:@"https://vimass.vn/vmbank/services/account/addAccUsed" withContent:[dict JSONString]];
    [connect release];
}

- (void)xuLyKetNoiThanhCong:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua{
    if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_THEM_CAP_NHAT_TAI_KHOAN_THUONG_DUNG]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Tạo thẻ lưu thành công"];
    }
}

- (void)xuLyKetNoiThatBai:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua{
    [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
}

- (void)dealloc {
    if (objTheLuu) {
        [objTheLuu release];
    }
    [_viewTheVisa release];
    [_viewXacNhan release];
    [_scrMain release];
    [_edSoThe release];
    [_edCVV release];
    [_edThangHetHan release];
    [_edNamHetHan release];
    [_edHo release];
    [_edBank release];
    [_edSoTheNoiDia release];
    [_edTenChuThe release];
    [_edThangMo release];
    [_edNamMo release];
    [_rbSMS release];
    [_rbToken release];
    [_viewNoiDia release];
    [_edChonLoaiThe2 release];
    [_edNameAlias release];
    [_edNameAliasQT release];
    [super dealloc];
}

- (IBAction)suKienXemZipCode:(id)sender {
    GiaoDienBangMaZipCode *zipcode = [[GiaoDienBangMaZipCode alloc] initWithNibName:NSStringFromClass([GiaoDienBangMaZipCode class]) bundle:nil];
    [self.navigationController pushViewController:zipcode animated:YES];
    [zipcode release];
}
@end
