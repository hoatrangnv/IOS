//
//  DucNT_TaiKhoanThuongDungObject.m
//  ViMASS
//
//  Created by MacBookPro on 7/24/14.
//
//

#import "DucNT_TaiKhoanThuongDungObject.h"

@implementation DucNT_TaiKhoanThuongDungObject

-(id)init
{
    self = [super init];
    if(self)
    {
        _sId = @"";
        _sPhoneOwner = @"";
        _nType = 0;
        _sAliasName = @"";
        _sDesc = @"";
        _nAmount = 0.0f;
        _sToAccWallet = @"";
        _sAccOwnerName = @"";
        _sBankName = @"";
        _sBankCode = @"";
        _sBankNumber = @"";
        _sProvinceName = @"";
        _sBranchName = @"";
        _sBranchCode = @"";
        _nBankCode = 0;
        _nBankId = 0;
        _nBranchId = 0;
        _nProvinceCode = 0;
        _nProvinceID = 0;
//        _nCardId = 0;
        _sCardTypeName = @"";
        _sCardNumber = @"";
        _sCardOwnerName = @"";
        _nDateReg = 0;
        _nDateExp = 0;
        _tenNguoiThuHuong = @"";
        _cellphoneNumber = @"";
        _cmnd = @"";
        _tinhThanh = @"";
        _quanHuyen = @"";
        _phuongXa = @"";
        _diaChi = @"";
        _noiDung = @"";
        _soTien = 0;

        _cardMonth = 0;
        _cardYear = 0;
        _ten = @"";
        _ho = @"";
        _cvv = @"";
        _zipCode = @"";
        _thanhPho = @"";
        _quocGia = @"";
        _otpGetType = @"";
        _email = @"";
        _phone = @"";
        _soDienThoai = @"";
        _avatar = @"";
        _nhaMang = 0;
        _loaiThueBao = 0;
        _ngayVang = NO;
        _nhaCungCap = 0;
        _taiKhoan = @"";
        _loaiGame = @"";
        _maKhachHang = @"";
        _tenChiNhanh = @"";
        _maChiNhanh = @"";

        _cachThucQuayVong = 0;
        _kyLinhLai = 0;
        _kieuNhanTien = 0;
        _maNganHang = @"";
        _kyHan = @"";
        _tenNguoiGui = @"";
        _soCmt = @"";
        _maNganHangNhanTien = @"";
        _tenChuTaiKhoan = @"";
        _soTaiKhoan = @"";
        //ATM
        _kieuThanhToan = 0;
        _maNhaCungCap = 0;
        _maATM = 0;
        _ngayCap = 0;
        _diaChiChiNhanh = @"";
        _noiCap = @"";
        //
        _giftName = @"";
        _idIcon = -1;
        //internet
        _maThueBao = @"";
        //
        _loaiDichVuHocPhi = 0 ;
        _maHocPhi = @"";
        _maKhachHangHocPhi = @"";
        _tenKhachHangHocPhi = @"";
        _maHopDong = @"";
        _idThongBaoDinhKy = @"";
        _trangThaiThongBaoDinhKy = -1;
        
        _tenCongTyXuatHoaDon = @"";
        _diaChiCongTyXuatHoaDon = @"";
        _maSoThueCongTyXuatHoaDon = @"";
        _diaChiNhanHoaDon = @"";
    }
    return self;
}

-(void)datLoaiTaiKhoan:(NSString *)sType
{
    _nType = [sType intValue];
}

-(id)copyWithZone:(NSZone *)zone
{
    DucNT_TaiKhoanThuongDungObject *data = [[DucNT_TaiKhoanThuongDungObject alloc] init];
    data.sId = _sId;
    data.sPhoneOwner = _sPhoneOwner;
    data.nType =  _nType;
    data.sAliasName = _sAliasName;
    data.sDesc = _sDesc;
    data.nAmount = _nAmount;
    data.sToAccWallet = _sToAccWallet;
    data.sAccOwnerName = _sAccOwnerName;
    data.sBankName = _sBankName;
    data.sBankNumber = _sBankNumber;
    data.sProvinceName = _sProvinceName;
    data.sBranchName = _sBranchName;
    data.sBranchCode = _sBranchCode;
    data.nBankCode = _nBankCode;
    data.nBankId = _nBankId;
    data.nBranchId = _nBranchId;
    data.nProvinceCode = _nProvinceCode;
    data.nProvinceID = _nProvinceID;
//    data.nCardId = _nCardId;
    data.sCardTypeName = _sCardTypeName;
    data.sCardNumber = _sCardNumber;
    data.sCardOwnerName = _sCardOwnerName;
    data.nDateReg = _nDateReg;
    data.nDateExp = _nDateExp;
    data.tenNguoiThuHuong = _tenNguoiThuHuong;
    data.cellphoneNumber = _cellphoneNumber;
    data.cmnd = _cmnd;
    data.tinhThanh = _tinhThanh;
    data.quanHuyen = _quanHuyen;
    data.phuongXa = _phuongXa;
    data.diaChi = _diaChi;
    data.soTien = _soTien;
    data.noiDung = _noiDung;
    data.cardMonth = _cardMonth;
    data.cardYear = _cardYear;
    data.ten = _ten;
    data.ho = _ho;
    data.cvv = _cvv;
    data.zipCode = _zipCode;
    data.thanhPho = _thanhPho;
    data.quocGia = _quocGia;
    data.otpGetType = _otpGetType;
    data.email = _email;
    data.phone = _phone;
    data.soDienThoai = _soDienThoai;
    data.nhaMang = _nhaMang;
    data.loaiThueBao = _loaiThueBao;
    data.avatar = _avatar;
    data.ngayVang = _ngayVang;
    data.nhaCungCap = _nhaCungCap;
    data.taiKhoan = _taiKhoan;
    data.loaiGame = _loaiGame;
    data.maKhachHang = _maKhachHang;
    data.tenChiNhanh = _tenChiNhanh;
    data.maChiNhanh = _maChiNhanh;
    data.cachThucQuayVong = _cachThucQuayVong;
    data.kyLinhLai =_kyLinhLai;
    data.kieuNhanTien = _kieuNhanTien;
    data.maNganHang = _maNganHang;
    data.kyHan = _kyHan;
    data.tenNguoiGui = _tenNguoiGui;
    data.soCmt = _soCmt;
    data.maNganHangNhanTien = _maNganHangNhanTien;
    data.tenChuTaiKhoan = _tenChuTaiKhoan;
    data.soTaiKhoan = _soTaiKhoan;
    //ATM
    data.kieuThanhToan = _kieuThanhToan;
    data.maNhaCungCap = _maNhaCungCap;
    data.maATM = _maATM;
    data.ngayCap = _ngayCap;
    data.diaChiChiNhanh = _diaChiChiNhanh;
    data.noiCap = _noiCap;
    //
    data.idIcon = _idIcon;
    data.giftName = _giftName;
    data.tenNguoiUngHo = _tenNguoiUngHo;
    data.maDuAnTuThien = _maDuAnTuThien;
    data.hoanCanhNguoiUngHo = _hoanCanhNguoiUngHo;
    data.diaChiNguoiUngHo = _diaChiNguoiUngHo;
    //internet
    data.maThueBao = _maThueBao;
    //hoc phi
    data.loaiDichVuHocPhi = _loaiDichVuHocPhi;
    data.maHocPhi = _maHocPhi;
    data.maKhachHangHocPhi = _maKhachHangHocPhi;
    data.tenKhachHangHocPhi = _tenKhachHangHocPhi;
    data.maHopDong = _maHopDong;
    data.trangThaiThongBaoDinhKy = _trangThaiThongBaoDinhKy;
    data.idThongBaoDinhKy = _idThongBaoDinhKy;
    
    data.tenCongTyXuatHoaDon = _tenCongTyXuatHoaDon;
    data.diaChiCongTyXuatHoaDon = _diaChiCongTyXuatHoaDon;
    data.maSoThueCongTyXuatHoaDon = _maSoThueCongTyXuatHoaDon;
    data.diaChiNhanHoaDon = _diaChiNhanHoaDon;
    return data;
}

- (void)fillDataWithDictionary:(NSDictionary*)dict loaiTaiKhoan:(int)nLoaiTaiKhoan
{
    for(NSString *sKey in [dict allKeys])
    {
        if([sKey isEqualToString:@"fromAcc"])
        {
            NSString *sFromAcc = [dict valueForKey:sKey];
            self.sToAccWallet = sFromAcc;
        }
        else if ([sKey isEqualToString:@"toAcc"])
        {
//            NSString *sToAcc = [dict valueForKey:sKey];
//            self.sToAccWallet = sToAcc;
        }
        else if ([sKey isEqualToString:@"amount"])
        {
            NSNumber *amount = [dict valueForKey:sKey];
            self.nAmount = [amount doubleValue];
        }
        else if ([sKey isEqualToString:@"message"])
        {
            NSString *sDesc = [dict valueForKey:sKey];
            self.sDesc = sDesc;
        }
    }
}

- (NSMutableDictionary*)toDict
{
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
    [dict setValue:_sId forKey:@"id"];
    [dict setValue:_sPhoneOwner forKey:@"phoneOwner"];
    [dict setValue:[NSNumber numberWithInt:_nType] forKey:@"type"];
    [dict setValue:_sAliasName forKey:@"aliasName"];
    [dict setValue:_sDesc forKey:@"desc"];
    [dict setValue:[NSNumber numberWithDouble:_nAmount] forKey:@"amount"];
    [dict setValue:_sToAccWallet forKey:@"toAccWallet"];
    [dict setValue:_sAccOwnerName forKey:@"AccOwnerName"];
    [dict setValue:_sBankName forKey:@"bankName"];
    [dict setValue:_sBankNumber forKey:@"BankNumber"];
    [dict setValue:_sProvinceName forKey:@"provinceName"];
    [dict setValue:_sBranchName forKey:@"branchName"];
    [dict setValue:_sBranchCode forKey:@"branchCode"];
    [dict setValue:[NSNumber numberWithInt:_nBankCode] forKey:@"bankCode"];
    [dict setValue:[NSNumber numberWithInt:_nBankId] forKey:@"bankId"];
    [dict setValue:[NSNumber numberWithInt:_nBranchId] forKey:@"branchId"];
    [dict setValue:[NSNumber numberWithInt:_nProvinceCode] forKey:@"provinceCode"];
    [dict setValue:[NSNumber numberWithInt:_nProvinceID] forKey:@"provinceId"];
    [dict setValue:_sCardTypeName forKey:@"cardTypeName"];
    [dict setValue:_sCardNumber forKey:@"cardNumber"];
    [dict setValue:_sCardOwnerName forKey:@"cardOwnerName"];
    [dict setValue:[NSNumber numberWithLongLong:_nDateReg] forKey:@"dateReg"];
    [dict setValue:[NSNumber numberWithLongLong:_nDateExp] forKey:@"dateExp"];
    
    [dict setValue:_tenNguoiThuHuong forKey:@"tenNguoiThuHuong"];
    [dict setValue:_cellphoneNumber forKey:@"cellphoneNumber"];
    [dict setValue:_cmnd forKey:@"cmnd"];
    [dict setValue:_tinhThanh forKey:@"tinhThanh"];
    [dict setValue:_quanHuyen forKey:@"quanHuyen"];
    [dict setValue:_phuongXa forKey:@"phuongXa"];
    [dict setValue:_diaChi forKey:@"diaChi"];
    [dict setValue:_noiDung forKey:@"noiDung"];
    [dict setValue:[NSNumber numberWithInt:_soTien] forKey:@"soTien"];
    [dict setValue:_phone forKey:@"phone"];
    [dict setValue:[NSNumber numberWithInt:_cardMonth] forKey:@"cardMonth"];
    [dict setValue:[NSNumber numberWithInt:_cardYear] forKey:@"cardYear"];
    [dict setValue:_ten forKey:@"ten"];
    [dict setValue:_ho forKey:@"ho"];
    [dict setValue:_cvv forKey:@"cvv"];
    [dict setValue:_zipCode forKey:@"zipCode"];
    [dict setValue:_thanhPho forKey:@"thanhPho"];
    [dict setValue:_quocGia forKey:@"quocGia"];
    [dict setValue:_otpGetType forKey:@"otpGetType"];
    [dict setValue:_email forKey:@"email"];
    [dict setValue:_soDienThoai forKey:@"soDienThoai"];
    [dict setValue:_avatar forKey:@"avatar"];
    [dict setValue:[NSNumber numberWithInt:_nhaMang] forKey:@"nhaMang"];
    [dict setValue:[NSNumber numberWithInt:_loaiThueBao] forKey:@"loaiThueBao"];
    [dict setValue:_ngayVang forKey:@"ngayVang"];
    [dict setValue:[NSNumber numberWithInt:_nhaCungCap] forKey:@"nhaCungCap"];
    [dict setValue:_taiKhoan forKey:@"taiKhoan"];
    [dict setValue:_loaiGame forKey:@"loaiGame"];
    [dict setValue:_maKhachHang forKey:@"maKhachHang"];
    [dict setValue:_tenChiNhanh forKey:@"tenChiNhanh"];
    [dict setValue:_maChiNhanh forKey:@"maChiNhanh"];
    [dict setValue:[NSNumber numberWithInt:_cachThucQuayVong] forKey:@"cachThucQuayVong"];
    [dict setValue:[NSNumber numberWithInt:_kyLinhLai] forKey:@"kyLinhLai"];
    [dict setValue:[NSNumber numberWithInt:_kieuNhanTien] forKey:@"kieuNhanTien"];
    [dict setValue:_maNganHang forKey:@"maNganHang"];
    [dict setValue:_kyHan forKey:@"kyHan"];
    [dict setValue:_tenNguoiGui forKey:@"tenNguoiGui"];
    [dict setValue:_soCmt forKey:@"soCmt"];
    [dict setValue:_maNganHangNhanTien forKey:@"maNganHangNhanTien"];
    [dict setValue:_tenChuTaiKhoan forKey:@"tenChuTaiKhoan"];
    [dict setValue:_soTaiKhoan forKey:@"soTaiKhoan"];
    //ATM
    [dict setValue:[NSNumber numberWithInt:_kieuThanhToan] forKey:@"kieuThanhToan"];
    [dict setValue:[NSNumber numberWithInt:_maNhaCungCap] forKey:@"maNhaCungCap"];
    [dict setValue:[NSNumber numberWithInt:_maATM] forKey:@"maATM"];
    //
    [dict setValue:_diaChiChiNhanh forKey:@"diaChiChiNhanh"];
    [dict setValue:_noiCap forKey:@"noiCap"];
    [dict setValue:[NSNumber numberWithLongLong:_ngayCap] forKey:@"ngayCap"];
    //
    [dict setValue:[NSNumber numberWithInt:_idIcon] forKey:@"idIcon"];
    [dict setValue:[NSNumber numberWithInt:_giftName] forKey:@"giftName"];
    //tu thien
    [dict setValue:_tenNguoiUngHo forKey:@"tenNguoiUngHo"];
    [dict setValue:[NSNumber numberWithInt:_maDuAnTuThien] forKey:@"maDuAnTuThien"];
    [dict setValue:_hoanCanhNguoiUngHo forKey:@"hoanCanhNguoiUngHo"];
    [dict setValue:_diaChiNguoiUngHo forKey:@"diaChiNguoiUngHo"];
    //internet
    [dict setValue:_maThueBao forKey:@"maThueBao"];
    //hoc phi
    [dict setValue:[NSNumber numberWithInt:_loaiDichVuHocPhi] forKey:@"loaiDichVuHocPhi"];
    [dict setValue:_maHocPhi forKey:@"maHocPhi"];
    [dict setValue:_maKhachHangHocPhi forKey:@"maKhachHangHocPhi"];
    [dict setValue:_tenKhachHangHocPhi forKey:@"tenKhachHangHocPhi"];
    [dict setValue:_maHopDong forKey:@"maHopDong"];
    [dict setValue:[NSNumber numberWithInt:_trangThaiThongBaoDinhKy] forKey:@"trangThaiThongBaoDinhKy"];
    [dict setValue:_idThongBaoDinhKy forKey:@"idThongBaoDinhKy"];
    
    [dict setValue:_tenCongTyXuatHoaDon forKey:@"tenCongTyXuatHoaDon"];
    [dict setValue:_diaChiCongTyXuatHoaDon forKey:@"diaChiCongTyXuatHoaDon"];
    [dict setValue:_maSoThueCongTyXuatHoaDon forKey:@"maSoThueCongTyXuatHoaDon"];
    [dict setValue:_diaChiNhanHoaDon forKey:@"diaChiNhanHoaDon"];
    return dict;
}

- (void)dealloc
{
    [_idThongBaoDinhKy release];
    [_maHopDong release];
    [_maHocPhi release];
    [_maKhachHangHocPhi release];
    [_tenKhachHangHocPhi release];
    [_maThueBao release];
    [_tenNguoiUngHo release];
    [_hoanCanhNguoiUngHo release];
    [_diaChiNguoiUngHo release];
    [_giftName release];
    [_noiCap release];
    [_diaChiChiNhanh release];
    [_maChiNhanh release];
    [_tenChiNhanh release];
    [_email release];
    [_otpGetType release];
    [_tenNguoiThuHuong release];
    [_cellphoneNumber release];
    [_cmnd release];
    [_tinhThanh release];
    [_quanHuyen release];
    [_phuongXa release];
    [_diaChi release];
    [_sId release];
    [_sPhoneOwner release];
    [_sAliasName release];
    [_sDesc release];
    [_sToAccWallet release];
    [_sAccOwnerName release];
    [_sBankName release];
    [_sBankCode release];
    [_sBankNumber release];
    [_sProvinceName release];
    [_sBranchName release];
    [_sBranchCode release];
    [_sCardTypeName release];
    [_sCardNumber release];
    [_sCardOwnerName release];
    [_noiDung release];
    [_ten release];
    [_ho release];
    [_cvv release];
    [_zipCode release];
    [_thanhPho release];
    [_quocGia release];
    [_phone release];
    [_soDienThoai release];
    [_avatar release];
    [_taiKhoan release];
    [_loaiGame release];
    [_maKhachHang release];
    [_maNganHang release];
    [_kyHan release];
    [_tenNguoiGui release];
    [_soCmt release];
    [_maNganHangNhanTien release];
    [_tenChuTaiKhoan release];
    [_soTaiKhoan release];
    
    [_tenCongTyXuatHoaDon release];
    [_diaChiCongTyXuatHoaDon release];
    [_maSoThueCongTyXuatHoaDon release];
    [_diaChiNhanHoaDon release];
    [super dealloc];
}

@end
