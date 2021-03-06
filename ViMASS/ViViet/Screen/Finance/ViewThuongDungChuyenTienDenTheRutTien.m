//
//  ViewThuongDungChuyenTienDenTheRutTien.m
//  ViViMASS
//
//  Created by DucBT on 1/28/15.
//
//

#import "Common.h"
#import "BankCoreData.h"
#import "BranchCoreData.h"
#import "DucNT_ViewPicker.h"
#import "ViewThuongDungChuyenTienDenTheRutTien.h"

@interface ViewThuongDungChuyenTienDenTheRutTien () <UITextFieldDelegate>
{
    NSInteger mViTriNganHangDuocChon;
    
}

@property (nonatomic, retain) NSArray *mDanhSachNganHang;

@end

@implementation ViewThuongDungChuyenTienDenTheRutTien
{
    DucNT_ViewPicker *mPickerNganHang;
    
}

#pragma mark - get & set

- (void)setMTaiKhoanThuongDung:(DucNT_TaiKhoanThuongDungObject *)mTaiKhoanThuongDung
{
    if(mTaiKhoanThuongDung)
    {
        if(_mTaiKhoanThuongDung)
            [_mTaiKhoanThuongDung release];
        _mTaiKhoanThuongDung = [mTaiKhoanThuongDung retain];
        [self.mtfTenDaiDien setText:_mTaiKhoanThuongDung.sAliasName];
        [self.mtfNganHang setText:_mTaiKhoanThuongDung.sBankName];
        for (int i = 0; i < _mDanhSachNganHang.count; i++)
        {
            Banks *bank = [_mDanhSachNganHang objectAtIndex:i];
            if([bank.bank_id intValue] == _mTaiKhoanThuongDung.nBankId)
            {
//                NSArray *stringComponent = [bank.bank_sms componentsSeparatedByString:@"/"];
//                NSString *sTenNganHang = [NSString stringWithFormat:@"%@ - %@", [stringComponent objectAtIndex:0], bank.bank_name];
                [self.mtfNganHang setText:bank.bank_name];
                mViTriNganHangDuocChon = i;
                break;
            }
        }
        self.mtfSoThe.text = _mTaiKhoanThuongDung.sCardNumber;
//        self.mtfSoTien.text = [NSString stringWithFormat:@"%ld", (long)_mTaiKhoanThuongDung.nAmount];
    }
}

- (DucNT_TaiKhoanThuongDungObject*)getTaiKhoanThuongDungDayLenServer
{
    DucNT_TaiKhoanThuongDungObject *taiKhoanThuongDung = nil;
    if([self validateShowError:NO])
    {
        if(_mTaiKhoanThuongDung)
        {
            taiKhoanThuongDung = _mTaiKhoanThuongDung;
        }
        else
        {
            taiKhoanThuongDung = [[[DucNT_TaiKhoanThuongDungObject alloc] init] autorelease];
        }
        
        taiKhoanThuongDung.nType = TAI_KHOAN_THE_RUT_TIEN;
        taiKhoanThuongDung.sPhoneOwner = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
        taiKhoanThuongDung.sAliasName = self.mtfTenDaiDien.text;
        Banks *bank = [self getBanks];
        taiKhoanThuongDung.sBankName =  bank.bank_name;
        taiKhoanThuongDung.nBankCode = [bank.bank_code intValue];
        taiKhoanThuongDung.nBankId = [bank.bank_id intValue];
        taiKhoanThuongDung.sCardNumber = self.mtfSoThe.text;
//        NSString *sSoTien = [self.mtfSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""];
//        taiKhoanThuongDung.nAmount = [sSoTien doubleValue];
    }
    return taiKhoanThuongDung;
}

#pragma mark - lifecircle
- (void)awakeFromNib
{
    [self khoiTaoGiaoDien];
}

#pragma mark - khoiTao

- (void)khoiTaoGiaoDien
{
    [self khoiTaoTextFieldNganHang];
    
    [self.mtfNganHang setPlaceholder:[@"ngan_hang" localizableString]];
    [self.mtfNganHang setTextError:[@"ten_ngan_hang_khong_duoc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    self.mtfNganHang.text = @"";
    
    [self.mtfSoThe setPlaceholder:[@"card_number" localizableString]];
    [self.mtfSoThe setTextError:[@"so_the_ngan_hang_khong_duoc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    [self.mtfSoThe setType:ExTextFieldTypeCardNumber];
    [self.mtfSoThe setText:@""];
    
    [self.mtfTenDaiDien setPlaceholder:[@"ten_hien_thi" localizableString]];
    [self.mtfTenDaiDien setTextError:[@"ten_hien_thi_khong_duoc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    [self.mtfTenDaiDien setText:@""];

    [self xuLyHienThiTextTenDaiDienCuaTaiKhoanTheRutTien];
    [self.mtfTenDaiDien setEnabled:NO];
}

- (void)khoiTaoTextFieldNganHang
{
    mViTriNganHangDuocChon = -1;
    [_mtfNganHang setText:@""];
    
    if(!mPickerNganHang)
        mPickerNganHang = [[DucNT_ViewPicker alloc] initWithNib];
    _mtfNganHang.inputView = mPickerNganHang;
    _mtfNganHang.inputAccessoryView = nil;
    
//    NSArray *arr_bank_id = [BranchCoreData getBankIDsByProvince:1];
//    NSMutableArray * bank_ids = [[NSMutableArray alloc] initWithCapacity:arr_bank_id.count];
//    for (NSDictionary *dic_bank_id in arr_bank_id)
//    {
//        [bank_ids addObject:[dic_bank_id objectForKey:@"bank_id"]];
//    }
//    self.mDanhSachNganHang = [BankCoreData getBanksByIDs:bank_ids];
//    [bank_ids release];
    [self khoiTaoDanhSachNganHang];
    if(_mDanhSachNganHang)
    {
        [self.mtfNganHang becomeFirstResponder];
        NSMutableArray *dsTenNganHang = [[NSMutableArray alloc] init];
        for(Banks *bank in _mDanhSachNganHang)
        {
//            NSArray *stringComponent = [bank.bank_sms componentsSeparatedByString:@"/"];
//            NSString *sTenNganHang = [NSString stringWithFormat:@"%@ - %@", [stringComponent objectAtIndex:0], bank.bank_name];
            [dsTenNganHang addObject:bank.bank_name];
        }
        
        __block ViewThuongDungChuyenTienDenTheRutTien *blockSELF = self;
        [mPickerNganHang khoiTaoDuLieu:dsTenNganHang];
        [mPickerNganHang capNhatKetQuaLuaChon:^(int nGiaTri) {
            [blockSELF.mtfNganHang resignFirstResponder];
            if(nGiaTri != -1)
            {
                blockSELF.mtfNganHang.text = [dsTenNganHang objectAtIndex:nGiaTri];
                
                if(nGiaTri != blockSELF->mViTriNganHangDuocChon)
                {
                    blockSELF->mViTriNganHangDuocChon = nGiaTri;
                }
                [blockSELF xuLyHienThiTextTenDaiDienCuaTaiKhoanTheRutTien];
            }
        }];
        [dsTenNganHang release];
    }
    
}

- (void)khoiTaoDanhSachNganHang
{
//    Cities *city = [dsTinhThanh objectAtIndex:mViTriTinhThanhDuocChon];
//    int nProvinceCode = [city.city_id intValue];
    NSArray *arr_bank_id = [BranchCoreData getBankIDsByProvince:1];
    
    NSMutableArray * bank_ids = [[NSMutableArray alloc] init];
    for (NSDictionary *dic_bank_id in arr_bank_id)
    {
        [bank_ids addObject:[dic_bank_id objectForKey:@"bank_id"]];
    }
    self.mDanhSachNganHang = [BankCoreData getBanksByIDs:bank_ids];
    [bank_ids release];
}

#pragma mark - getBank
- (Banks*)getBanks
{
    if(mViTriNganHangDuocChon > -1)
    {
        Banks *bank = [_mDanhSachNganHang objectAtIndex:mViTriNganHangDuocChon];
        return bank;
    }
    return nil;
}

#pragma mark - suKien

- (BOOL)validate
{
    [self xuLyHienThiTextTenDaiDienCuaTaiKhoanTheRutTien];
    NSArray *tfs = @[_mtfNganHang, _mtfSoThe, _mtfTenDaiDien];
    ExTextField *first = nil;
    BOOL flg = YES;
    for (ExTextField *tf in tfs)
    {
        flg = [tf validate] && flg;
        if (flg == NO && first == nil)
            first = tf;
    }
    if (first)
        [first show_error];
    
    return flg;
}

- (BOOL)validateShowError:(BOOL)showError
{
    NSArray *tfs = @[_mtfNganHang, _mtfSoThe, _mtfTenDaiDien];
    ExTextField *first = nil;
    BOOL flg = YES;
    for (ExTextField *tf in tfs)
    {
        flg = [tf validate] && flg;
        if (flg == NO && first == nil)
            first = tf;
    }
    if (first && showError)
        [first show_error];
    
    return flg;
}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _mtfSoThe)
    {
        NSString *sText = _mtfSoThe.text;
        if([sText rangeOfString:@"*"].location != NSNotFound)
            _mtfSoThe.text = @"";
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self xuLyHienThiTextTenDaiDienCuaTaiKhoanTheRutTien];
}

- (void)xuLyHienThiTextTenDaiDienCuaTaiKhoanTheRutTien
{
    NSString *sTenVietTatNganHang = @"";
    NSString *sBonSoCuoiTheNganHang = @"";
    
    if(mViTriNganHangDuocChon != -1)
    {
        Banks *bank = [self.mDanhSachNganHang objectAtIndex:mViTriNganHangDuocChon];
        NSArray *stringComponent = [bank.bank_sms componentsSeparatedByString:@"/"];
//        NSString *sTenNganHang = [NSString stringWithFormat:@"%@ - %@", [stringComponent objectAtIndex:0], bank.bank_name];
        sTenVietTatNganHang = [stringComponent objectAtIndex:0];
    }
    
    NSString *sTempSoThe = [self.mtfSoThe.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(sTempSoThe.length > 4)
    {
        NSInteger nStart = sTempSoThe.length - 4;
        NSInteger nLength = 4;
        sBonSoCuoiTheNganHang = [sTempSoThe substringWithRange:NSMakeRange(nStart, nLength)];
    }
    
    NSString *sTenDaiDien = [NSString stringWithFormat:@"Thẻ %@ - %@", sTenVietTatNganHang, sBonSoCuoiTheNganHang];
    self.mtfTenDaiDien.text = sTenDaiDien;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

#pragma mark - dealloc
- (void)dealloc {
    if(mPickerNganHang)
        [mPickerNganHang release];
    [_mtfTenDaiDien release];
    [_mtfNganHang release];
    [_mtfSoThe release];
    [super dealloc];
}

@end
