//
//  ViewThuongDungChuyenTienDenTaiKhoan.m
//  ViViMASS
//
//  Created by DucBT on 1/21/15.
//
//

#import "BankCoreData.h"
#import "BranchCoreData.h"
#import "ProvinceCoreData.h"
#import "DucNT_ViewPicker.h"
#import "ViewThuongDungChuyenTienDenTaiKhoan.h"
#import "Common.h"
#import "DucNT_LuuRMS.h"

@interface ViewThuongDungChuyenTienDenTaiKhoan () <UITextFieldDelegate>
{
    
}

@property (retain, nonatomic) NSArray *dsTinhThanh;
@property (retain, nonatomic) NSArray *dsNganHang;

@end

@implementation ViewThuongDungChuyenTienDenTaiKhoan
{
    DucNT_ViewPicker *mViewPickerTinhThanh;
    DucNT_ViewPicker *mViewPickerNganHang;
    int mViTriTinhThanhDuocChon;
    int mViTriNganHangDuocChon;
}

@synthesize dsTinhThanh;

#pragma mark - get & set

- (void)setMTaiKhoanThuongDung:(DucNT_TaiKhoanThuongDungObject *)mTaiKhoanThuongDung
{
    if(mTaiKhoanThuongDung)
    {
        if(_mTaiKhoanThuongDung)
            [_mTaiKhoanThuongDung release];
        _mTaiKhoanThuongDung = [mTaiKhoanThuongDung retain];
        [self.mtfTenDaiDien setText:_mTaiKhoanThuongDung.sAliasName];
        self.mtfNganHang.text = _mTaiKhoanThuongDung.sBankName;
        self.mtfTinhThanhPho.text = _mTaiKhoanThuongDung.sProvinceName;
        for (int i = 0; i < dsTinhThanh.count; i++)
        {
            Cities *city = [dsTinhThanh objectAtIndex:i];
            if([city.city_id intValue] == _mTaiKhoanThuongDung.nProvinceID)
            {
                mViTriTinhThanhDuocChon = i;
                [self khoiTaoDanhSachNganHang];
                break;
            }
        }
        
        for (int i = 0; i < _dsNganHang.count; i++)
        {
            Banks *bank = [_dsNganHang objectAtIndex:i];
            if([bank.bank_id intValue] == _mTaiKhoanThuongDung.nBankId)
            {
                [self.mtfNganHang setText:bank.bank_name];
                mViTriNganHangDuocChon = i;
                break;
            }
        }
    
        
        self.mtfTenChuTaiKhoan.text = _mTaiKhoanThuongDung.sAccOwnerName;
        self.mtfSoTaiKhoan.text = _mTaiKhoanThuongDung.sBankNumber;
        self.mtfSoTien.text = [Common hienThiTienTe:_mTaiKhoanThuongDung.nAmount];
        [self.mtvNoiDungGiaoDich setText:_mTaiKhoanThuongDung.sDesc];
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
        
        taiKhoanThuongDung.nType = TAI_KHOAN_NGAN_HANG;
        taiKhoanThuongDung.sPhoneOwner = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
        taiKhoanThuongDung.sAliasName = self.mtfTenDaiDien.text;
        Cities *city = [dsTinhThanh objectAtIndex:mViTriTinhThanhDuocChon];
        taiKhoanThuongDung.sProvinceName = city.city_name;
        taiKhoanThuongDung.nProvinceCode = [city.city_code intValue];
        taiKhoanThuongDung.nProvinceID = [city.city_id intValue];
        Banks *bank = [_dsNganHang objectAtIndex:mViTriNganHangDuocChon];
        taiKhoanThuongDung.sBankName = bank.bank_name;
        taiKhoanThuongDung.nBankCode = [bank.bank_code intValue];
        taiKhoanThuongDung.nBankId = [bank.bank_id intValue];
        taiKhoanThuongDung.sAccOwnerName = self.mtfTenChuTaiKhoan.text;
        taiKhoanThuongDung.sBankNumber = self.mtfSoTaiKhoan.text;
        taiKhoanThuongDung.sDesc = self.mtvNoiDungGiaoDich.text;
        NSString *sSoTien = [self.mtfSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""];
        taiKhoanThuongDung.nAmount = [sSoTien doubleValue];
    }
    return taiKhoanThuongDung;
}

#pragma mark - life circle
- (void)awakeFromNib
{
    [self khoiTaoGiaoDien];
    [self khoiTaoViewPickerTinhThanh];
    [self khoiTaoViewPickerNganHang];
}

#pragma mark - Khoi tao
- (void)khoiTaoGiaoDien
{
    [self.mtfSoTien setPlaceholder:[NSString stringWithFormat:@"%@ (%@)",[@"amount" localizableString], [@"co_the_bo_qua" localizableString]]];
    [self.mtfSoTien setTextError:[@"so_tien_khong_duoc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    [self.mtfSoTien setTextError:[@"so_tien_khong_hop_le" localizableString]forType:ExTextFieldTypeMoney];
    [self.mtfSoTien setText:@""];
    self.mtfSoTien.inputAccessoryView = nil;
    
    [self.mtfTenChuTaiKhoan setPlaceholder:[@"ten_chu_tai_khoan" localizableString]];
    [self.mtfTenChuTaiKhoan setTextError:[@"ten_tai_khoan_khong_duoc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    [self.mtfTenChuTaiKhoan setText:@""];
    self.mtfTenChuTaiKhoan.inputAccessoryView = nil;
    
    [self.mtfTenDaiDien setPlaceholder:[@"ten_hien_thi" localizableString]];
    [self.mtfTenDaiDien setTextError:[@"ten_hien_thi_khong_duoc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    [self.mtfTenDaiDien setText:@""];
    self.mtfTenDaiDien.inputAccessoryView = nil;
    
    [self.mtfNoiDungGiaoDich setPlaceholder:[@"place_holder_noi_dung" localizableString]];
    self.mtvNoiDungGiaoDich.inputAccessoryView = nil;
    self.mtvNoiDungGiaoDich.text = @"";
    
    self.mtfTinhThanhPho.placeholder = [@"tinh_thanh_pho" localizableString];
    [self.mtfTinhThanhPho setTextError:[@"tinh_thanh_khong_duoc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    [self.mtfTinhThanhPho setText:@""];
    self.mtfTinhThanhPho.inputAccessoryView = nil;
    
    [self.mtfNganHang setPlaceholder:[@"ngan_hang" localizableString]];
    [self.mtfNganHang setTextError:[@"ten_ngan_hang_khong_duoc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    self.mtfNganHang.text = @"";
    self.mtfNganHang.inputAccessoryView = nil;
    self.mtfNganHang.delegate = self;
    
    self.mtfSoTaiKhoan.placeholder = [@"so_tai_khoan" localizableString];
    [self.mtfSoTaiKhoan setTextError:[@"so_tai_khoan_khong_dc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    [self.mtfSoTaiKhoan setType:ExTextFieldTypeBankNumber];
    self.mtfSoTaiKhoan.inputAccessoryView = nil;
}


- (void)khoiTaoViewPickerTinhThanh
{
    if(!mViewPickerTinhThanh)
        mViewPickerTinhThanh = [[DucNT_ViewPicker alloc] initWithNib];
    self.dsTinhThanh = [ProvinceCoreData allProvinces];
    if(dsTinhThanh != nil && dsTinhThanh.count > 0)
    {
//        [self.mtfTinhThanhPho becomeFirstResponder];
        NSMutableArray *dsTenThanhPho = [[NSMutableArray alloc] init];
        for(int i = 0; i < dsTinhThanh.count; i++)
        {
            [dsTenThanhPho addObject:((Cities *)[dsTinhThanh objectAtIndex:i]).city_name];
        }
        [mViewPickerTinhThanh khoiTaoDuLieu:dsTenThanhPho];
        __block ViewThuongDungChuyenTienDenTaiKhoan *blockSELF = self;
        [mViewPickerTinhThanh capNhatKetQuaLuaChon:^(int nGiaTri) {
            [blockSELF.mtfTinhThanhPho resignFirstResponder];
            if(nGiaTri != -1)
            {
                blockSELF.mtfTinhThanhPho.text = [dsTenThanhPho objectAtIndex:nGiaTri];
                if(nGiaTri != blockSELF->mViTriTinhThanhDuocChon)
                {
                    blockSELF->mViTriTinhThanhDuocChon = nGiaTri;
//                    blockSELF->nMaTinhThanh = ((Cities *)[blockSELF.dsTinhThanh objectAtIndex:nGiaTri]).city_id.intValue;
                    blockSELF.mtfNganHang.text = @"";
                    blockSELF->mViTriNganHangDuocChon = -1;
                    [blockSELF khoiTaoDanhSachNganHang];
                }
            }
        }];
        [dsTenThanhPho release];
    }
    
    self.mtfTinhThanhPho.inputView = mViewPickerTinhThanh;
}

- (void)khoiTaoViewPickerNganHang
{
    if(!mViewPickerNganHang)
        mViewPickerNganHang = [[DucNT_ViewPicker alloc] initWithNib];
    
    [self khoiTaoDanhSachNganHang];
    
    if(_dsNganHang != nil && _dsNganHang.count > 0)
    {
        NSMutableArray *dsTenNganHang = [[NSMutableArray alloc] init];
//        for(int i = 0; i < _dsNganHang.count; i++)
//        {
//            [dsTenNganHang addObject:((Banks *)[_dsNganHang objectAtIndex:i]).bank_name];
//        }
        for(Banks *bank in _dsNganHang)
        {
//            NSArray *stringComponent = [bank.bank_sms componentsSeparatedByString:@"/"];
//            NSString *sTenNganHang = [NSString stringWithFormat:@"%@ - %@", [stringComponent objectAtIndex:0], bank.bank_name];
            [dsTenNganHang addObject:bank.bank_name];
        }
        [self.mtfNganHang becomeFirstResponder];
        __block ViewThuongDungChuyenTienDenTaiKhoan *blockSELF = self;
        [mViewPickerNganHang khoiTaoDuLieu:dsTenNganHang];
        [mViewPickerNganHang capNhatKetQuaLuaChon:^(int nGiaTri) {
            [blockSELF.mtfNganHang resignFirstResponder];
            if(nGiaTri != -1)
            {
                blockSELF.mtfNganHang.text = [dsTenNganHang objectAtIndex:nGiaTri];
                if(nGiaTri != blockSELF->mViTriNganHangDuocChon)
                {
                    blockSELF->mViTriNganHangDuocChon = nGiaTri;
//                    blockSELF->nMaNganHang = ((Banks *)[blockSELF.dsNganHang objectAtIndex:nGiaTri]).bank_id.intValue;
                }
            }
        }];
        [dsTenNganHang release];
    }
    self.mtfNganHang.inputView = mViewPickerNganHang;
}

- (void)khoiTaoDanhSachNganHang
{
//    Cities *city = [dsTinhThanh objectAtIndex:mViTriTinhThanhDuocChon];
//    int nProvinceCode = [city.city_id intValue];
//    NSArray *arr_bank_id = [BranchCoreData getBankIDsByProvince:1];
//    
//    NSMutableArray * bank_ids = [[NSMutableArray alloc] init];
//    for (NSDictionary *dic_bank_id in arr_bank_id)
//    {
//        [bank_ids addObject:[dic_bank_id objectForKey:@"bank_id"]];
//    }
//    self.dsNganHang = [BankCoreData getBanksByIDs:bank_ids];
//    [bank_ids release];
    
    self.dsNganHang = [BankCoreData allBanks];
}

#pragma mark - suKien

- (BOOL)validate
{
    NSArray *tfs = @[_mtfTenDaiDien/*, _mtfTinhThanhPho*/, _mtfNganHang, _mtfTenChuTaiKhoan, _mtfSoTaiKhoan];
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
    NSArray *tfs = @[_mtfTenDaiDien/*, _mtfTinhThanhPho*/, _mtfNganHang, _mtfTenChuTaiKhoan, _mtfSoTaiKhoan];
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

- (IBAction)suKienThayDoiSoTien:(id)sender
{
    NSString *sSoTien = [self.mtfSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *sText = [Common hienThiTienTeFromString:sSoTien];
    self.mtfSoTien.text = sText;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    if(textField == _mtfNganHang)
//    {
//        if([_mtfTinhThanhPho validate])
//        {
//            [self khoiTaoViewPickerNganHang];
//            [textField becomeFirstResponder];
//        }
//        else
//        {
//            [_mtfTinhThanhPho show_error];
//            [textField resignFirstResponder];
//        }
//    }
//    else
    if (textField == _mtfSoTaiKhoan)
    {
        NSString *sText = _mtfSoTaiKhoan.text;
        if([sText rangeOfString:@"*"].location != NSNotFound)
            _mtfSoTaiKhoan.text = @"";
    }
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
    if(_mTaiKhoanThuongDung)
        [_mTaiKhoanThuongDung release];
    if(mViewPickerTinhThanh)
        [mViewPickerTinhThanh release];
    if(mViewPickerNganHang)
        [mViewPickerNganHang release];
    if(dsTinhThanh)
        [dsTinhThanh release];
    if(_dsNganHang)
        [_dsNganHang release];
    [_mtfTenDaiDien release];
    [_mtfTinhThanhPho release];
    [_mtfNganHang release];
    [_mtfTenChuTaiKhoan release];
    [_mtfSoTaiKhoan release];
    [_mtfSoTien release];
    [_mtfNoiDungGiaoDich release];
    [_mtvNoiDungGiaoDich release];
    [super dealloc];
}
@end
