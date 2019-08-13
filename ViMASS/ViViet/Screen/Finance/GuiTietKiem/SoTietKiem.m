//
//  SoTietKiem.m
//  ViViMASS
//
//  Created by DucBui on 5/18/15.
//
//

#import "SoTietKiem.h"
#import "BankCoreData.h"
#import "DucNT_LuuRMS.h"
#import "Common.h"
#import "DucNT_LuuRMS.h"

//#define TEMP_HTML @"<b>%@</b>: %@<br />"


@implementation SoTietKiem

- (id)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if(self)
    {
        NSString *user = [dict valueForKey:@"user"];
        if(user)
            self.user = user;
        else
            self.user = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
        
        NSNumber *typeAuthenticate = [dict valueForKey:@"typeAuthenticate"];
        if(typeAuthenticate)
            self.typeAuthenticate = typeAuthenticate;
        else
            self.typeAuthenticate = [NSNumber numberWithInt:-1];
        
        NSString *maNganHang = [dict valueForKey:@"maNganHang"];
        if(maNganHang)
            self.maNganHang = maNganHang;
        else
            self.maNganHang = @"";
        
        NSNumber *soTien = [dict valueForKey:@"soTien"];
        if(soTien)
            self.soTien = soTien;
        else
            self.soTien = [NSNumber numberWithDouble:0.0f];
        
        NSNumber *cachThucQuayVong = [dict valueForKey:@"cachThucQuayVong"];
        if(cachThucQuayVong)
            self.cachThucQuayVong = cachThucQuayVong;
        else
            self.cachThucQuayVong = [NSNumber numberWithInt:-1];
        
        NSString *kyHan = [dict valueForKey:@"kyHan"];
        if(kyHan)
            self.kyHan = kyHan;
        else
            self.kyHan = @"";
        
        NSNumber *kyLinhLai = [dict valueForKey:@"kyLinhLai"];
        if(kyLinhLai)
            self.kyLinhLai = kyLinhLai;
        else
            self.kyLinhLai = [NSNumber numberWithInt:-1];
        
        NSString *tenNguoiGui = [dict valueForKey:@"tenNguoiGui"];
        if(tenNguoiGui)
            self.tenNguoiGui = tenNguoiGui;
        else
            self.tenNguoiGui = @"";
        
        NSString *soCmt = [dict valueForKey:@"soCmt"];
        if(soCmt)
            self.soCmt = soCmt;
        else
            self.soCmt = @"";
        
        NSString *diaChi = [dict valueForKey:@"diaChi"];
        if(diaChi)
            self.diaChi = diaChi;
        else
            self.diaChi = @"";
        
        NSNumber *kieuNhanTien = [dict valueForKey:@"kieuNhanTien"];
        if(kieuNhanTien)
            self.kieuNhanTien = kieuNhanTien;
        else
            self.kieuNhanTien = [NSNumber numberWithInt:-1];
        
        NSString *maNganHangNhanTien = [dict valueForKey:@"maNganHangNhanTien"];
        if(maNganHangNhanTien)
            self.maNganHangNhanTien = maNganHangNhanTien;
        else
            self.maNganHangNhanTien = @"";
        
        NSString *tenChuTaiKhoan = [dict valueForKey:@"tenChuTaiKhoan"];
        if(tenChuTaiKhoan)
            self.tenChuTaiKhoan = tenChuTaiKhoan;
        else
            self.tenChuTaiKhoan = @"";
        
        NSString *soTaiKhoan = [dict valueForKey:@"soTaiKhoan"];
        if(soTaiKhoan)
            self.soTaiKhoan = soTaiKhoan;
        else
            self.soTaiKhoan = @"";
        
        NSNumber *maGiaoDich = [dict valueForKey:@"maGiaoDich"];
        if(maGiaoDich)
            self.maGiaoDich = maGiaoDich;
        else
            self.maGiaoDich = [NSNumber numberWithInt:-1];
        
        NSString *soSoTietKiem = [dict valueForKey:@"soSoTietKiem"];
        if(soSoTietKiem)
            self.soSoTietKiem = soSoTietKiem;
        else
            self.soSoTietKiem = @"";
        
        NSNumber *trangThai = [dict valueForKey:@"trangThai"];
        if(trangThai)
            self.trangThai = trangThai;
        else
            self.trangThai = [NSNumber numberWithInt:-1];
        
        NSNumber *thoiGianGui = [dict valueForKey:@"thoiGianGui"];
        if(thoiGianGui)
            self.thoiGianGui = thoiGianGui;
        else
            self.thoiGianGui = [NSNumber numberWithLongLong:-1];
        
        NSNumber *thoiGianDaoHan = [dict valueForKey:@"thoiGianDaoHan"];
        if(thoiGianDaoHan)
            self.thoiGianDaoHan = thoiGianDaoHan;
        else
            self.thoiGianDaoHan = [NSNumber numberWithLongLong:-1];
        
        NSNumber *thoiGianHoanTien = [dict valueForKey:@"thoiGianHoanTien"];
        if(thoiGianHoanTien)
            self.thoiGianHoanTien = thoiGianHoanTien;
        else
            self.thoiGianHoanTien = [NSNumber numberWithLongLong:-1];
        
        NSNumber *thoiGianHieuLuc = [dict valueForKey:@"thoiGianHieuLuc"];
        if(thoiGianHieuLuc)
            self.thoiGianHieuLuc = thoiGianHieuLuc;
        else
            self.thoiGianHieuLuc = [NSNumber numberWithLongLong:-1];
        
        NSNumber *thoiGianRutSo = [dict valueForKey:@"thoiGianRutSo"];
        if(thoiGianRutSo)
            self.thoiGianRutSo = thoiGianRutSo;
        else
            self.thoiGianRutSo = [NSNumber numberWithLongLong:-1];
        
        NSNumber *laiSuat = [dict valueForKey:@"laiSuat"];
        if(laiSuat)
            self.laiSuat = laiSuat;
        else
            self.laiSuat = [NSNumber numberWithLongLong:-1];
        
        NSString *soSoVimass = [dict valueForKey:@"soSoVimass"];
        if(soSoVimass)
            self.soSoVimass = soSoVimass;
        else
            self.soSoVimass = @"";
        
        NSNumber *tienThucLinh = [dict valueForKey:@"tienThucLinh"];
        if(tienThucLinh)
            self.tienThucLinh = tienThucLinh;
        else
            self.tienThucLinh = [NSNumber numberWithDouble:-1];
    }
    return self;
}

- (NSString*)layLaiSuat
{
    if(_laiSuat)
        return [NSString stringWithFormat:@"%@\uFF05/năm", [NSString stringWithFormat:@"%.02f", [_laiSuat doubleValue]]];
    return @"";
}

- (NSString*)layNgayGui
{
    if(_thoiGianHieuLuc && [_thoiGianHieuLuc longLongValue] > 0)
    {
        NSDateFormatter *dtf = [[[NSDateFormatter alloc] init] autorelease];
        dtf.locale = [NSLocale currentLocale];
        [dtf setDateFormat:@"dd/MM/yyyy"];
        NSDate *dtNgayGui = [NSDate dateWithTimeIntervalSince1970:[_thoiGianHieuLuc longLongValue] / 1000];
        return [dtf stringFromDate:dtNgayGui];
    }
    return @"";
}

- (NSString*)layThoiDiemGui
{
    if(_thoiGianGui && [_thoiGianGui longLongValue] > 0)
    {
        NSDateFormatter *dtf = [[[NSDateFormatter alloc] init] autorelease];
        dtf.locale = [NSLocale currentLocale];
        [dtf setDateFormat:@"dd/MM/yyyy HH:mm"];
        NSDate *dtNgayGui = [NSDate dateWithTimeIntervalSince1970:[_thoiGianGui longLongValue] / 1000];
        return [dtf stringFromDate:dtNgayGui];
    }
    return @"";
}

- (NSString*)layThoiDiemRut
{
    if(_thoiGianRutSo && [_thoiGianRutSo longLongValue] > 0)
    {
        NSDateFormatter *dtf = [[[NSDateFormatter alloc] init] autorelease];
        dtf.locale = [NSLocale currentLocale];
        [dtf setDateFormat:@"dd/MM/yyyy HH:mm"];
        NSDate *dtNgayGui = [NSDate dateWithTimeIntervalSince1970:[_thoiGianRutSo longLongValue] / 1000];
        return [dtf stringFromDate:dtNgayGui];
    }
    return @"";
}



- (NSDate*)layNgayGuiTraVeNSDate
{
    if(_thoiGianGui)
    {
        return [NSDate dateWithTimeIntervalSince1970:[_thoiGianGui longLongValue] / 1000];
    }
    return nil;
}

- (NSString*)layNgayDaoHan
{
    if(_thoiGianDaoHan && [_thoiGianDaoHan longLongValue] > 0)
    {
        NSDateFormatter *dtf = [[[NSDateFormatter alloc] init] autorelease];
        dtf.locale = [NSLocale currentLocale];
        [dtf setDateFormat:@"dd/MM/yyyy"];
        NSDate *dtNgayGui = [NSDate dateWithTimeIntervalSince1970:[_thoiGianDaoHan longLongValue] / 1000];
        return [dtf stringFromDate:dtNgayGui];
    }
    return @"";
}


- (NSString*)layKyHan
{
    if(_kyHan)
    {
        NSString *sMaThoiGian = [_kyHan substringWithRange:NSMakeRange(_kyHan.length - 1, 1)];
        int nSoThoiGian = [[_kyHan substringWithRange:NSMakeRange(0, _kyHan.length - 1)] intValue];
        NSString *cachTinhThoiGian = @"";
        if([sMaThoiGian isEqualToString:@"D"])
        {
            cachTinhThoiGian = @"ngày";
        }
        else if([sMaThoiGian isEqualToString:@"M"])
        {
            cachTinhThoiGian = @"tháng";
        }
        else
        {
            cachTinhThoiGian = @"tháng";
        }
        return [NSString stringWithFormat:@"%d %@", nSoThoiGian, cachTinhThoiGian];
    }
    return @"";
}

- (NSString*)layKyLinhLai
{
    NSString *kyLai = @"";
    switch ([_kyLinhLai intValue]) {
        case 0:
            kyLai = @"Cuối kỳ";
            break;
        case 1:
            kyLai = @"Hàng tháng";
            break;
        case 2:
            kyLai = @"Đầu kỳ";
            break;
        case 3:
            kyLai = @"Hàng quý";
            break;
        case 4:
            kyLai = @"6 tháng";
            break;
        default:
            kyLai = @"Hàng năm";
            break;
    }
    return kyLai;
}

- (NSString*)layCachThucQuayVong
{
    NSString *sCachThucQuayVong = @"";
    switch ([_cachThucQuayVong intValue])
    {
        case 0:
            sCachThucQuayVong = @"Quay vòng gốc và lãi";
            break;
        case 1:
            sCachThucQuayVong = @"Quay vòng gốc";
            break;
        default:
            sCachThucQuayVong = @"Không quay vòng";
            break;
    }
    return sCachThucQuayVong;
}


- (NSString*)layTrangThai
{
    if(_trangThai)
    {
        int nTrangThai = [_trangThai intValue];
        NSString *sTrangThai = @"";
        switch (nTrangThai) {
            case 0:
                sTrangThai = @"Đang xử lý gửi";
                break;
            case 1:
                sTrangThai = @"Đang hiệu lực";
                break;
            case 5:
                sTrangThai = @"Gửi không thành";
                break;
            case 6:
                sTrangThai = @"Đang rút trước hạn";
                break;
            case 7:
                sTrangThai = @"Đã rút trước hạn";
                break;
            case 11:
                sTrangThai = @"Đã đáo hạn";
                break;
            default:
                break;
        }
        return sTrangThai;
    }
    return @"";
}

- (NSString*)layKieuNhanTien
{
    if(_kieuNhanTien)
    {
        int nKieuNhanTien = [_kieuNhanTien intValue];
        NSString *sKieuNhanTien = @"";
        switch (nKieuNhanTien) {
            case 0:
                sKieuNhanTien = [NSString stringWithFormat:@"ví %@", _user];
                break;
            case 1:
                sKieuNhanTien = @"tài khoản";
                break;
            case 2:
                sKieuNhanTien = @"tại quầy";
                break;
            case 3:
                sKieuNhanTien = [NSString stringWithFormat:@"thẻ %@", _soTaiKhoan];
                break;
            default:
                break;
        }
        return sKieuNhanTien;
    }
    return @"";
}

- (NSString*)layChiTietSoTietKiemKieuHTML
{
    NSMutableString *sXauHTML = [[[NSMutableString alloc] init] autorelease];
    [sXauHTML appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Mã sổ TK", _soSoVimass];
    Banks *bank = [BankCoreData getBankBySMS:_maNganHang];
    if(bank)
        [sXauHTML appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Gửi tại NH", bank.bank_name];
    else
        [sXauHTML appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Gửi tại NH", _maNganHang];
    
    [sXauHTML appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Số tiền", [NSString stringWithFormat:@"%@ đ", [Common hienThiTienTe:[_soTien doubleValue]]]];
    [sXauHTML appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Kỳ hạn", [self layKyHan]];
    [sXauHTML appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Lĩnh lãi", [self layKyLinhLai]];
    [sXauHTML appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Quay vòng", [self layCachThucQuayVong]];
    [sXauHTML appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Lãi suất", [self layLaiSuat]];
    
    [sXauHTML appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Tiền lãi", [NSString stringWithFormat:@"%@ đ", [Common hienThiTienTe:[self laySoTienLaiTheoKyHan]]]];
    
    NSString *sNgayGui = [self layNgayGui];
    if(![sNgayGui isEqualToString:@""])
        [sXauHTML appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Ngày gửi", sNgayGui];
    
    NSString *sNgayDaoHan = [self layNgayDaoHan];
    if(![sNgayDaoHan isEqualToString:@""])
        [sXauHTML appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Ngày đáo hạn", sNgayDaoHan];
    
    NSString *sThoiDiemGui = [self layThoiDiemGui];
    if(![sThoiDiemGui isEqualToString:@""])
    [sXauHTML appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"TĐ gửi", sThoiDiemGui];
    
    NSString *sThoiDiemRut = [self layThoiDiemRut];
    if(![sThoiDiemRut isEqualToString:@""])
        [sXauHTML appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"TĐ rút", sThoiDiemRut];
//    [sXauHTML appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Tên người gửi", _tenNguoiGui];
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        [sXauHTML appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Mã DN", _soCmt];
    }
    else
    {
//        [sXauHTML appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Số CMND/HC", _soCmt];
    }

//    if(![_diaChi isEqualToString:@""])
//        [sXauHTML appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Địa chỉ", _diaChi];
    [sXauHTML appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Nhận tiền về", [self layKieuNhanTien]];
    if([_kieuNhanTien intValue] == 1)
    {
        Banks *nganHangNhanTien = [BankCoreData getBankBySMS:_maNganHangNhanTien];
        [sXauHTML appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Ngân hàng nhận", nganHangNhanTien.bank_name];
        [sXauHTML appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Chủ tài khoản", _tenChuTaiKhoan];
        [sXauHTML appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Số tài khoản", _soTaiKhoan];
    }
    
    return sXauHTML;
}

- (double)laySoTienLaiTheoKyHan
{
    NSDate *dtNgayRutTruocHan = [NSDate date];
    NSDate *dtNgayHieuLuc = [NSDate dateWithTimeIntervalSince1970:[_thoiGianHieuLuc longLongValue] / 1000];
    NSString *sThangNgay = [self tinhSoNgayVaSoThangGiuaNgay1:dtNgayHieuLuc vaNgay2:dtNgayRutTruocHan];
    NSArray *temp = [sThangNgay componentsSeparatedByString:@"::"];
    int nSoThang = [temp[0] intValue];
    int nSoNgay = [temp[1] intValue];
    NSString *sMaThoiGian = [_kyHan substringWithRange:NSMakeRange(_kyHan.length - 1, 1)];
    NSLog(@"%s - sMaThoiGian : %@", __FUNCTION__, sMaThoiGian);
    int nSoThoiGian = [[_kyHan substringWithRange:NSMakeRange(0, _kyHan.length - 1)] intValue];
    int nChuKy = 0;
    double fSoTienLaiTheoKyHan = 0.0f;
    if([sMaThoiGian isEqualToString:@"D"])
    {
        fSoTienLaiTheoKyHan = [Common laySoTienLaiTheoNgay:[_laiSuat doubleValue] soNgayGui:nSoThoiGian soTien:[_soTien doubleValue]];
        nSoNgay = [self tinhSoNgayGiuaNgay1:dtNgayHieuLuc vaNgay2:dtNgayRutTruocHan];
        nChuKy = 0;
        if(nSoNgay % nSoThoiGian == 0)
        {
            //Chu ky chia het cho thoi gian
            nChuKy = nSoNgay / nSoThoiGian;
        }
        else
        {
            nChuKy = nSoNgay / nSoThoiGian;
        }
        
        fSoTienLaiTheoKyHan *= nChuKy;
    }
    else if([sMaThoiGian isEqualToString:@"M"])
    {
        fSoTienLaiTheoKyHan = [Common laySoTienLaiTheoThang:[_laiSuat doubleValue] soThangGui:nSoThoiGian soTien:[_soTien doubleValue]];
        
        if(nSoThang > 0)
        {
            //So thang > 0
            nChuKy = nSoThang / nSoThoiGian;
            if(nSoNgay > 0)
                nChuKy += 1;
            else if (nSoThang % nSoThoiGian != 0)
                nChuKy += 1;
            fSoTienLaiTheoKyHan *= nChuKy;
        }
    }
    else if ([sMaThoiGian isEqualToString:@"KKH"]) {
        fSoTienLaiTheoKyHan = [Common laySoTienLaiTheoNgay:[_laiSuat doubleValue] soNgayGui:nSoThoiGian soTien:[_soTien doubleValue]];
        nSoNgay = [self tinhSoNgayGiuaNgay1:dtNgayHieuLuc vaNgay2:dtNgayRutTruocHan];
        nChuKy = 0;
        if(nSoNgay % nSoThoiGian == 0)
        {
            //Chu ky chia het cho thoi gian
            nChuKy = nSoNgay / nSoThoiGian;
        }
        else
        {
            nChuKy = nSoNgay / nSoThoiGian;
        }

        fSoTienLaiTheoKyHan *= nChuKy;
    }
    return fSoTienLaiTheoKyHan/* + [_soTien doubleValue]*/;

}


//- (double)laySoTienGocVaLaiTheoKyHan
//{
//    NSDate *dtNgayRutTruocHan = [NSDate date];
//    NSDate *dtNgayHieuLuc = [NSDate dateWithTimeIntervalSince1970:[_thoiGianHieuLuc longLongValue] / 1000];
//    NSString *sThangNgay = [self tinhSoNgayVaSoThangGiuaNgay1:dtNgayHieuLuc vaNgay2:dtNgayRutTruocHan];
//    NSArray *temp = [sThangNgay componentsSeparatedByString:@"::"];
//    int nSoThang = [temp[0] intValue];
//    int nSoNgay = [temp[1] intValue];
//    NSString *sMaThoiGian = [_kyHan substringWithRange:NSMakeRange(_kyHan.length - 1, 1)];
//    int nSoThoiGian = [[_kyHan substringWithRange:NSMakeRange(0, _kyHan.length - 1)] intValue];
//    int nChuKy = 0;
//    double fSoTienLaiTheoKyHan = 0.0f;
//    if([sMaThoiGian isEqualToString:@"D"])
//    {
//        fSoTienLaiTheoKyHan = [Common laySoTienLaiTheoNgay:[_laiSuat doubleValue] soNgayGui:nSoThoiGian soTien:[_soTien doubleValue]];
//        nSoNgay = [self tinhSoNgayGiuaNgay1:dtNgayHieuLuc vaNgay2:dtNgayRutTruocHan];
//        nChuKy = 0;
//        if(nSoNgay % nSoThoiGian == 0)
//        {
//            //Chu ky chia het cho thoi gian
//            nChuKy = nSoNgay / nSoThoiGian;
//        }
//        else
//        {
//            nChuKy = nSoNgay / nSoThoiGian;
//        }
//        
//        fSoTienLaiTheoKyHan *= nChuKy;
//    }
//    else if([sMaThoiGian isEqualToString:@"M"])
//    {
//        fSoTienLaiTheoKyHan = [Common laySoTienLaiTheoThang:[_laiSuat doubleValue] soThangGui:nSoThoiGian soTien:[_soTien doubleValue]];
//        
//        if(nSoThang > 0)
//        {
//            //So thang > 0
//            nChuKy = nSoThang / nSoThoiGian;
//            if(nSoNgay > 0)
//                nChuKy += 1;
//            else if (nSoThang % nSoThoiGian != 0)
//                nChuKy += 1;
//            fSoTienLaiTheoKyHan *= nChuKy;
//        }
//    }
//    return fSoTienLaiTheoKyHan + [_soTien doubleValue];
//}


- (double)laySoTienLaiRutTruocHan
{
    double fSoTienLaiRutTruocHan = 0.0f;
    //Lai suat khong ky han
    float fLaiSuatKhongKyHan = 0.5f;
    if([_maNganHang isEqualToString:@"NAB"])
    {
        fLaiSuatKhongKyHan = 1.0f;
    }
    else if([_maNganHang isEqualToString:@"NCB"])
    {
        fLaiSuatKhongKyHan = 0.5f;
    }
    //Ngay rut truoc han la hom nay
    NSDate *dtNgayRutTruocHan = [NSDate date];
    NSDate *dtNgayHieuLuc = [NSDate dateWithTimeIntervalSince1970:[_thoiGianHieuLuc longLongValue] / 1000];
    NSString *sThangNgay = [self tinhSoNgayVaSoThangGiuaNgay1:dtNgayHieuLuc vaNgay2:dtNgayRutTruocHan];
    NSArray *temp = [sThangNgay componentsSeparatedByString:@"::"];
    int nSoThang = [temp[0] intValue];
    int nSoNgay = [temp[1] intValue];
    NSString *sMaThoiGian = [_kyHan substringWithRange:NSMakeRange(_kyHan.length - 1, 1)];
    int nSoThoiGian = [[_kyHan substringWithRange:NSMakeRange(0, _kyHan.length - 1)] intValue];
    if([sMaThoiGian isEqualToString:@"D"])
    {
        
        nSoNgay = [self tinhSoNgayGiuaNgay1:dtNgayHieuLuc vaNgay2:dtNgayRutTruocHan];
        int nChuKy = nSoNgay / nSoThoiGian;
        for (int i = 0; i < nChuKy; i ++) {
            fSoTienLaiRutTruocHan += [self tinhSoTienLaiTheoKyHan:_kyHan
                                                            chuKy:i
                                                 laiSuatTheoKyHan:[_laiSuat floatValue]
                                                        soTienGui:[_soTien doubleValue]
                                                 cachThucQuayVong:[_cachThucQuayVong intValue]];
        }
        
        NSDate *dtNgaySauKhiTruDiChuKy = [self layNgayCachNgay:dtNgayHieuLuc soNgay:nSoThoiGian*nChuKy];
        int nSoNgayLe = [self tinhSoNgayGiuaNgay1:dtNgaySauKhiTruDiChuKy vaNgay2:dtNgayRutTruocHan];
        if(nSoNgayLe > 0)
        {
            fSoTienLaiRutTruocHan += [Common laySoTienLaiTheoNgay:fLaiSuatKhongKyHan soNgayGui:nSoNgayLe soTien:[_soTien doubleValue]];
        }
    }
    else if([sMaThoiGian isEqualToString:@"M"])
    {
        if(nSoThang == 0)
        {
            //So thang = 0 thi chi tinh so ngay le rut truoc han va tra ve so tien lai theo lai suat khong ky han
            int nSoNgayLe = [self tinhSoNgayGiuaNgay1:dtNgayHieuLuc vaNgay2:dtNgayRutTruocHan];
            fSoTienLaiRutTruocHan = [Common laySoTienLaiTheoNgay:fLaiSuatKhongKyHan soNgayGui:nSoNgayLe soTien:[_soTien doubleValue]];
        }
        else
        {
            //So thang > 0
            int nChuKy = nSoThang / nSoThoiGian;
            for (int i = 0; i < nChuKy; i ++) {
                fSoTienLaiRutTruocHan += [self tinhSoTienLaiTheoKyHan:_kyHan
                                                                chuKy:i
                                                     laiSuatTheoKyHan:[_laiSuat floatValue]
                                                            soTienGui:[_soTien doubleValue]
                                                     cachThucQuayVong:[_cachThucQuayVong intValue]];
            }
            NSDate *dtNgaySauKhiTruDiChuKy = [self layNgayCachNgay:dtNgayHieuLuc soThang:nChuKy * nSoThoiGian];
            int nSoNgayLe = [self tinhSoNgayGiuaNgay1:dtNgaySauKhiTruDiChuKy vaNgay2:dtNgayRutTruocHan];
            if(nSoNgayLe > 0)
            {
                fSoTienLaiRutTruocHan += [Common laySoTienLaiTheoNgay:fLaiSuatKhongKyHan soNgayGui:nSoNgayLe soTien:[_soTien doubleValue]];
            }
        }
    }
    return fSoTienLaiRutTruocHan + [_soTien doubleValue];
}

- (NSDate*)layNgayCachNgay:(NSDate*)date1 soNgay:(int)nSoNgay
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    calendar.locale = [NSLocale currentLocale];
    unsigned int unitFlags = NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitYear;
    NSDateComponents *component = [calendar components:unitFlags fromDate:date1];
    component.day = component.day + nSoNgay;
    return [calendar dateFromComponents:component];
}

- (NSDate*)layNgayCachNgay:(NSDate*)date1 soThang:(int)nSoThang
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    calendar.locale = [NSLocale currentLocale];
    unsigned int unitFlags = NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitYear;
    NSDateComponents *component = [calendar components:unitFlags fromDate:date1];
    component.month = component.month + nSoThang;
    return [calendar dateFromComponents:component];
}

- (double)tinhSoTienLaiTheoKyHan:(NSString*)sMaKyHan
                         chuKy:(int)nSoChuKy
              laiSuatTheoKyHan:(double)fLaiSuatTheoKyHan
                     soTienGui:(double)fSoTienGui
                cachThucQuayVong:(int)nCachThucQuayVong
{
    nSoChuKy --;
    NSString *sMaThoiGian = [_kyHan substringWithRange:NSMakeRange(_kyHan.length - 1, 1)];
    int nSoThoiGian = [[_kyHan substringWithRange:NSMakeRange(0, _kyHan.length - 1)] intValue];
    //Tinh so tien lai theo so tien gui
    float fSoTienLai = 0.0f;
    if([sMaThoiGian isEqualToString:@"D"])
    {
        fSoTienLai = [Common laySoTienLaiTheoNgay:fLaiSuatTheoKyHan soNgayGui:nSoThoiGian soTien:fSoTienGui];
    }
    else if([sMaThoiGian isEqualToString:@"M"])
    {
        fSoTienLai = [Common laySoTienLaiTheoThang:fLaiSuatTheoKyHan soThangGui:nSoThoiGian soTien:fSoTienGui];
    }
    if(nCachThucQuayVong == 0)
    {
        //quay vong goc lai
        if(nSoChuKy <= 0)
        {
            return fSoTienLai;
        }
        else
        {
            return [self tinhSoTienLaiTheoKyHan:sMaKyHan chuKy:nSoChuKy laiSuatTheoKyHan:fLaiSuatTheoKyHan soTienGui:fSoTienGui + fSoTienLai cachThucQuayVong:nCachThucQuayVong];
        }

    }
    else if(nCachThucQuayVong == 1)
    {
        //Quay vong goc
        return fSoTienLai;
    }
    return fSoTienLai;
}

- (NSString*)tinhSoNgayVaSoThangGiuaNgay1:(NSDate*)date1 vaNgay2:(NSDate*)date2
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    calendar.locale = [NSLocale currentLocale];
    unsigned int unitFlags = NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date1  toDate:date2  options:0];
    int months = (int)[comps month];
    int days = (int)[comps day] + 1;
    return [NSString stringWithFormat:@"%d::%d", months, days];
}

- (int)tinhSoNgayGiuaNgay1:(NSDate*)date1 vaNgay2:(NSDate*)date2
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    calendar.locale = [NSLocale currentLocale];
    unsigned int unitFlags = NSCalendarUnitDay;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date1  toDate:date2  options:0];
    return (int)[comps day] + 1;
}


- (void)dealloc
{
    [_user release];
    [_typeAuthenticate release];
    [_maNganHang release];
    [_soTien release];
    [_cachThucQuayVong release];
    [_kyHan release];
    [_kyLinhLai release];
    [_tenNguoiGui release];
    [_soCmt release];
    [_diaChi release];
    [_kieuNhanTien release];
    [_maNganHangNhanTien release];
    [_tenChuTaiKhoan release];
    [_soTaiKhoan release];
    [_maGiaoDich release];
    [_soSoTietKiem release];
    [_trangThai release];
    [_thoiGianGui release];
    [_thoiGianDaoHan release];
    [_thoiGianHoanTien release];
    [_thoiGianHieuLuc release];
    [_thoiGianRutSo release];
    [_laiSuat release];
    [_soSoVimass release];
    [_tienThucLinh release];
    [super dealloc];
}

@end
