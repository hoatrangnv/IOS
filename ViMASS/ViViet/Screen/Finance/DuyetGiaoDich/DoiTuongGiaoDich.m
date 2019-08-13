//
//  DoiTuongGiaoDich.m
//  ViViMASS
//
//  Created by DucBui on 6/9/15.
//
//

#import "DoiTuongGiaoDich.h"
#import "Common.h"
#import "DoiTuongChiTietGiaoDichChuyenTienDenVi.h"
#import "DoiTuongChiTietGiaoDichChuyenTienDenTaiKhoan.h"
#import "DoiTuongChiTietGiaoDichRutTietKiem.h"
#import "DoiTuongChiTietGiaoDichThanhToanDienThoai.h"
#import "DoiTuongGiaoDichTheoLo.h"
#import "DucNT_LuuRMS.h"
#import "DoiTuongChiTietGiaoDichGuiTietKiem.h"
#import "DoiTuongChiTietGiaoDichInternet.h"

@implementation DoiTuongGiaoDich

- (id)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        
        NSString *tuVi = [dict valueForKey:@"companyCode"];
        if (tuVi) {
            self.vi = tuVi;
        }
        else
            self.vi = @"";
        
        NSString *nameLap = [dict valueForKey:@"nameLap"];
        if(nameLap)
            self.nameLap = nameLap;
        else
            self.nameLap = @"";
        
        NSString *nameDuyet = [dict valueForKey:@"nameDuyet"];
        if(nameDuyet)
            self.nameDuyet = nameDuyet;
        else
            self.nameDuyet = @"";
        
        NSString *userLap = [dict valueForKey:@"userLap"];
        if(userLap)
            self.userLap = userLap;
        else
            self.userLap = @"";
        
        NSString *userDuyet = [dict valueForKey:@"userDuyet"];
        if(userDuyet)
            self.userDuyet = userDuyet;
        else
            self.userDuyet = @"";
        
        NSNumber *funcId = [dict valueForKey:@"funcId"];
        if(funcId)
            self.funcId = funcId;
        else
            self.funcId = [NSNumber numberWithInt:-1];
        
        NSString *maGiaoDich = [dict valueForKey:@"maGiaoDich"];
        if (maGiaoDich) {
            self.maGiaoDich = maGiaoDich;
        }
        else
            self.maGiaoDich = @"";
        
        NSString *companyCode = [dict valueForKey:@"companyCode"];
        if(companyCode)
            self.companyCode = companyCode;
        else
            self.companyCode = @"";
        
        NSNumber *soTien = [dict valueForKey:@"soTien"];
        if (soTien) {
            self.soTien = soTien;
        }
        else
            self.soTien = [NSNumber numberWithChar:0.0f];
        
        NSString *noiDungHienThi = [dict valueForKey:@"noiDungHienThi"];
        if(noiDungHienThi)
            self.noiDungHienThi = noiDungHienThi;
        else
            self.noiDungHienThi = @"";
        
        NSNumber *thoiGianLap = [dict valueForKey:@"thoiGianLap"];
        if(thoiGianLap)
            self.thoiGianLap = thoiGianLap;
        else
            self.thoiGianLap = [NSNumber numberWithLongLong:0];
        
        NSNumber *thoiGianDuyet = [dict valueForKey:@"thoiGianDuyet"];
        if(thoiGianDuyet)
            self.thoiGianDuyet = thoiGianDuyet;
        else
            self.thoiGianDuyet = [NSNumber numberWithLongLong:0];
        
        NSNumber *thoiGianHetHan = [dict valueForKey:@"thoiGianHetHan"];
        if(thoiGianHetHan)
            self.thoiGianHetHan = thoiGianHetHan;
        else
            self.thoiGianHetHan = [NSNumber numberWithLongLong:0];
        
        NSNumber *thoiGianHuy = [dict valueForKey:@"thoiGianHuy"];
        if(thoiGianHuy)
            self.thoiGianHuy = thoiGianHuy;
        else
            self.thoiGianHuy = [NSNumber numberWithLongLong:0];
        
        NSNumber *fee = [dict valueForKey:@"fee"];
        if(fee)
            self.fee = fee;
        else
            self.fee = [NSNumber numberWithDouble:0.0f];
        NSNumber *trangThai = [dict valueForKey:@"trangThai"];
        if(trangThai)
            self.trangThai = trangThai;
        else
            self.trangThai = [NSNumber numberWithInt:0.0f];
        
        NSString *lyDoDuyetThatBai = [dict valueForKey:@"lyDoDuyetThatBai"];
        if(lyDoDuyetThatBai)
            self.lyDoDuyetThatBai = lyDoDuyetThatBai;
        else
            self.lyDoDuyetThatBai = @"";
    }
    return self;
}

- (NSString*)layThoiGianHuy
{
    if(_thoiGianHuy && [_thoiGianHuy longLongValue] > 0)
    {
        NSDateFormatter *dtf = [[[NSDateFormatter alloc] init] autorelease];
        dtf.locale = [NSLocale currentLocale];
        [dtf setDateFormat:@"dd/MM/yyyy HH:mm"];
        NSDate *dtNgayHuy = [NSDate dateWithTimeIntervalSince1970:[_thoiGianHuy longLongValue] / 1000];
        return [dtf stringFromDate:dtNgayHuy];
    }
    return @"";
}

- (NSString*)layThoiGianLap
{
    if(_thoiGianLap && [_thoiGianLap longLongValue] > 0)
    {
        NSDateFormatter *dtf = [[[NSDateFormatter alloc] init] autorelease];
        dtf.locale = [NSLocale currentLocale];
        [dtf setDateFormat:@"dd/MM/yyyy HH:mm"];
        NSDate *dtNgayLap = [NSDate dateWithTimeIntervalSince1970:[_thoiGianLap longLongValue] / 1000];
        return [dtf stringFromDate:dtNgayLap];
    }
    return @"";
}

- (NSString*)layThoiGianHetHan
{
    if(_thoiGianHetHan && [_thoiGianHetHan longLongValue] > 0)
    {
        NSDateFormatter *dtf = [[[NSDateFormatter alloc] init] autorelease];
        dtf.locale = [NSLocale currentLocale];
        [dtf setDateFormat:@"dd/MM/yyyy HH:mm"];
        NSDate *dtNgayHetHan = [NSDate dateWithTimeIntervalSince1970:[_thoiGianHetHan longLongValue] / 1000];
        return [dtf stringFromDate:dtNgayHetHan];
    }
    return @"";
}

- (NSDate*)layThoiGianLapTraVeNSDate
{
    if(_thoiGianLap && [_thoiGianLap longLongValue] > 0)
    {
        NSDateFormatter *dtf = [[[NSDateFormatter alloc] init] autorelease];
        dtf.locale = [NSLocale currentLocale];
        [dtf setDateFormat:@"dd-MM-yyyy"];
        NSDate *dtNgayHetHan = [NSDate dateWithTimeIntervalSince1970:[_thoiGianLap longLongValue] / 1000];
        return dtNgayHetHan;
    }
    return [NSDate date];
}


- (NSString*)layThoiGianDuyet
{
    if(_thoiGianDuyet && [_thoiGianDuyet longLongValue] > 0)
    {
        NSDateFormatter *dtf = [[[NSDateFormatter alloc] init] autorelease];
        dtf.locale = [NSLocale currentLocale];
        [dtf setDateFormat:@"dd/MM/yyyy HH:mm"];
        NSDate *dtNgayDuyet = [NSDate dateWithTimeIntervalSince1970:[_thoiGianDuyet longLongValue] / 1000];
        return [dtf stringFromDate:dtNgayDuyet];
    }
    return @"";
}


- (NSString*)layTrangThai
{
    NSString *sTrangThai = @"";
    switch ([_trangThai intValue]) {
        case DOANH_NGHIEP_LAP_LENH_THANH_CONG:
            sTrangThai = @"Đang chờ duyệt";
            break;
        case DOANH_NGHIEP_DA_HUY:
            sTrangThai = @"Đã huỷ";
            break;
        case DOANH_NGHIEP_HET_HAN_DUYET:
            sTrangThai = @"Đã hết hạn";
            break;
        case DOANH_NGHIEP_DUYET_LENH_XOA:
            sTrangThai = @"Đã xoá";
            break;
        default:
            sTrangThai = @"Đã duyệt";
            break;
    }
    return sTrangThai;
}

+ (NSArray*)layDanhSachDuyetGiaoDich:(NSArray*)arr
{
    if(arr)
    {
        NSMutableArray *temp = [[[NSMutableArray alloc] initWithCapacity:arr.count] autorelease];
        for(NSDictionary *dict in arr)
        {
            DoiTuongGiaoDich *doiTuong = [[DoiTuongGiaoDich alloc] initWithDict:dict];
            [temp addObject:doiTuong];
            [doiTuong release];
        }
        return temp;
    }
    return nil;
}

- (void)khoiTaoDoiTuongChiTietGiaoDich:(NSDictionary*)dict
{
    if(_funcId)
    {
        switch ([_funcId intValue]) {
            case FUNC_ID_CHUYEN_TIEN:
                [self khoiTaoDoiTuongChiTietGiaoDichChuyenTienDenVi:dict];
                break;
            case FUNC_TRANSACTION_TO_BANK:
                [self khoiTaoDoiTuongChiTietGiaoDichChuyenTienDenTheNganHang:dict];
                break;
            case FUNC_RUT_TIEN_TIET_KIEM:
                [self khoiTaoDoiTuongChiTietGiaoDichRutTietKiem:dict];
                break;
            case FUNC_GUI_TIEN_TIET_KIEM:
                [self khoiTaoDoiTuongChiTietGiaoDichGuiTietKiem:dict];
                break;
            case FUNC_BILLING_CELLPHONE:
                [self khoiTaoDoiTuongChiTietGiaoDichThanhToanDienThoai:dict];
                break;
            case FUNC_DOANH_NGHIEP_LAP_LENH_THEO_LO:
                [self khoiTaoDoiTuongChiTietGiaoDichTheoLo:dict];
                break;
            case FUNC_THANH_TOAN_INTERNET:
                [self khoiTaoDoiTuongChiTietGiaoDichInternet:dict];
                break;
            case FUNC_THANH_TOAN_DT_CO_DINH:
                [self khoiTaoDoiTuongChiTietGiaoDichInternet:dict];
                break;
            default:
                break;
        }
    }
}

- (void)khoiTaoDoiTuongChiTietGiaoDichTheoLo:(NSDictionary*)dict
{
    DoiTuongGiaoDichTheoLo *doiTuong = [[DoiTuongGiaoDichTheoLo alloc] initWithDict:dict];
    self.mDoiTuongChiTietGiaoDich = doiTuong;
    [doiTuong release];
}

- (void)khoiTaoDoiTuongChiTietGiaoDichChuyenTienDenVi:(NSDictionary*)dict
{
    DoiTuongChiTietGiaoDichChuyenTienDenVi *doiTuong = [[DoiTuongChiTietGiaoDichChuyenTienDenVi alloc] initWithDict:dict];
    self.mDoiTuongChiTietGiaoDich = doiTuong;
    [doiTuong release];
}

- (void)khoiTaoDoiTuongChiTietGiaoDichChuyenTienDenTheNganHang:(NSDictionary*)dict
{
    DoiTuongChiTietGiaoDichChuyenTienDenTaiKhoan *doiTuong = [[DoiTuongChiTietGiaoDichChuyenTienDenTaiKhoan alloc] initWithDict:dict];
    self.mDoiTuongChiTietGiaoDich = doiTuong;
    [doiTuong release];
}

- (void)khoiTaoDoiTuongChiTietGiaoDichRutTietKiem:(NSDictionary*)dict
{
    NSString *secssion = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_SECSSION];
    DoiTuongChiTietGiaoDichRutTietKiem *doiTuong = [[DoiTuongChiTietGiaoDichRutTietKiem alloc] initWithDict:dict];
    doiTuong.mDinhDanhDoanhNghiep = _companyCode;
    doiTuong.secssion = secssion;
    self.mDoiTuongChiTietGiaoDich = doiTuong;
    [doiTuong release];
}

- (void)khoiTaoDoiTuongChiTietGiaoDichGuiTietKiem:(NSDictionary*)dict
{
//    NSString *secssion = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_SECSSION];
    DoiTuongChiTietGiaoDichGuiTietKiem *doiTuong = [[DoiTuongChiTietGiaoDichGuiTietKiem alloc] initWithDict:dict];
//    doiTuong.mDinhDanhDoanhNghiep = _companyCode;
//    doiTuong.secssion = secssion;
    self.mDoiTuongChiTietGiaoDich = doiTuong;
//    [doiTuong release];
}

- (void)khoiTaoDoiTuongChiTietGiaoDichThanhToanDienThoai:(NSDictionary*)dict
{
    DoiTuongChiTietGiaoDichThanhToanDienThoai *doiTuong = [[DoiTuongChiTietGiaoDichThanhToanDienThoai alloc] initWithDict:dict];
    self.mDoiTuongChiTietGiaoDich = doiTuong;
    [doiTuong release];
}

- (void)khoiTaoDoiTuongChiTietGiaoDichInternet:(NSDictionary *)dict{
    DoiTuongChiTietGiaoDichInternet *doiTuong = [[DoiTuongChiTietGiaoDichInternet alloc] initWithDict:dict];
    self.mDoiTuongChiTietGiaoDich = doiTuong;
    [doiTuong release];
}

- (NSString*)layTenChucNang
{
    NSString *sTenChucNang = @"";
    if(_funcId)
    {
        switch ([_funcId intValue]) {
            case FUNC_ID_CHUYEN_TIEN:
                sTenChucNang = @"Chuyển tiền đến Ví";
                break;
            case FUNC_TRANSACTION_TO_BANK:
                sTenChucNang = @"Chuyển tiền đến tài khoản";
                break;
            case FUNC_RUT_TIEN_TIET_KIEM:
                sTenChucNang = @"Rút tiết kiệm";
                break;
        case FUNC_GUI_TIEN_TIET_KIEM:
                sTenChucNang = @"Gửi tiết kiệm";
                break;
            case FUNC_BILLING_CELLPHONE:
                sTenChucNang = @"Thanh toán điện thoại";
                break;
            case FUNC_DOANH_NGHIEP_LAP_LENH_THEO_LO:
                sTenChucNang = @"Lập lệnh theo lô";
                break;
            case FUNC_THANH_TOAN_INTERNET:
                sTenChucNang = @"Thanh toán Internet";
                break;
            case FUNC_THANH_TOAN_DT_CO_DINH:
                sTenChucNang = @"Thanh toán điện thoại cố định";
                break;
            default:
                break;
        }
    }
    return sTenChucNang;
}


- (NSString*)layXauHTMLHienThiDoiTuongGiaoDich
{
    NSMutableString *chiTietHienThi = [[[NSMutableString alloc] init] autorelease];
    [chiTietHienThi appendString:@"<div style=\"font-size:14px; font-family:arial\">"];
    [chiTietHienThi appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH,@"Ví ",_vi];
    [chiTietHienThi appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH,@"Người lập",_nameLap];
    [chiTietHienThi appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH,@"TG lập",[self layThoiGianLap]];

    switch ([_trangThai intValue]) {
        case DOANH_NGHIEP_DA_HUY:
            [chiTietHienThi appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH,@"Người huỷ",_nameDuyet];
            [chiTietHienThi appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH,@"TG huỷ",[self layThoiGianHuy]];
            [chiTietHienThi appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH,@"Trạng thái",@"Đã huỷ"];
            break;
        case DOANH_NGHIEP_HET_HAN_DUYET:
            [chiTietHienThi appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH,@"Trạng thái",@"Đã hết hạn"];
            [chiTietHienThi appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH,@"TG hết hạn",[self layThoiGianHetHan]];
            break;
        case DOANH_NGHIEP_DUYET_LENH_THANH_CONG:
            [chiTietHienThi appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH,@"Người duyệt",_userDuyet];
            
            [chiTietHienThi appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH,@"TG duyệt",[self layThoiGianDuyet]];
            [chiTietHienThi appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH,@"Trạng thái",@"Đã duyệt"];
            break;
        case DOANH_NGHIEP_DUYET_LENH_XOA:
            [chiTietHienThi appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH,@"Trạng thái",@"Đã xoá"];
            break;
        default:
            [chiTietHienThi appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH,@"Trạng thái",@""];
            break;
    }
    [chiTietHienThi appendFormat:XAU_HTML_TITLE, [self layTenChucNang]];
    if(_mDoiTuongChiTietGiaoDich)
        [chiTietHienThi appendString:[_mDoiTuongChiTietGiaoDich layChiTietHienThi]];
    if(![_lyDoDuyetThatBai isEqualToString:@""])
        [chiTietHienThi appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH,@"Mô tả",_lyDoDuyetThatBai];
    [chiTietHienThi appendString:@"</div>"];
    return chiTietHienThi;
}

- (void)dealloc
{
    [_nameDuyet release];
    [_nameLap release];
    if(_mDoiTuongChiTietGiaoDich)
        [_mDoiTuongChiTietGiaoDich release];
    [_userLap release];
    [_userDuyet release];
    [_funcId release];
    [_maGiaoDich release];
    [_companyCode release];
    [_soTien release];
    [_noiDungHienThi release];
    [_thoiGianLap release];
    [_thoiGianDuyet release];
    [_thoiGianHetHan release];
    [_thoiGianHuy release];
    [_fee release];
    [_trangThai release];
    [_lyDoDuyetThatBai release];
    [super dealloc];
}

@end
