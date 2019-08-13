//
//  DoiTuongChiTietGiaoDichChuyenTienDenTaiKhoan.m
//  ViViMASS
//
//  Created by DucBui on 6/11/15.
//
//

#import "BankCoreData.h"
#import "DoiTuongChiTietGiaoDichChuyenTienDenTaiKhoan.h"

@implementation DoiTuongChiTietGiaoDichChuyenTienDenTaiKhoan


- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if(self)
    {
        NSString *tuVi = [dict valueForKey:@"companyCode"];
        if (tuVi) {
            self.vi = tuVi;
        }
        else
            self.vi = @"";
        
        NSNumber *amount = [dict valueForKey:@"amount"];
        if(amount)
            self.amount = amount;
        else
            self.amount = [NSNumber numberWithDouble:0.0f];
        NSString *bankCode = [dict valueForKey:@"bankCode"];
        if(bankCode)
            self.bankCode = bankCode;
        else
            self.bankCode = @"";
        
        NSString *content = [dict valueForKey:@"content"];
        if(content)
            self.content = content;
        else
            self.content = @"";
        
        
        NSString *bankNumber = [dict valueForKey:@"bankNumber"];
        if(bankNumber)
            self.bankNumber = bankNumber;
        else
            self.bankNumber = @"";
        NSString *chiNhanhName = [dict valueForKey:@"maChiNhanh"];
        if (chiNhanhName) {
            if ([chiNhanhName isEqualToString:@"11111111"]) {
                self.chiNhanh = [dict valueForKey:@"tenChiNhanh"];
            }
            else
            {
                NSMutableArray *arrChiNhanhBank = [[NSMutableArray alloc] init];
                arrChiNhanhBank = [[NSMutableArray alloc] init];
                [arrChiNhanhBank addObject:@"CN Bà Rịa Vũng Tàu"];
                [arrChiNhanhBank addObject:@"77204001"];
                [arrChiNhanhBank addObject:@"CN Bắc Hà Nội"];
                [arrChiNhanhBank addObject:@"1204006"];
                [arrChiNhanhBank addObject:@"CN Bình Phước"];
                [arrChiNhanhBank addObject:@"70204001"];
                [arrChiNhanhBank addObject:@"CN Đồng Nai"];
                [arrChiNhanhBank addObject:@"75204001"];
                [arrChiNhanhBank addObject:@"CN Gia Lai"];
                [arrChiNhanhBank addObject:@"64204001"];
                [arrChiNhanhBank addObject:@"CN Hà Nội"];
                [arrChiNhanhBank addObject:@"1204003"];
                [arrChiNhanhBank addObject:@"CN Hà Nội"];
                [arrChiNhanhBank addObject:@"1204003"];
                [arrChiNhanhBank addObject:@"CN Hà Tây"];
                [arrChiNhanhBank addObject:@"1204036"];
                [arrChiNhanhBank addObject:@"CN Láng Hà Nội"];
                [arrChiNhanhBank addObject:@"1204010"];
                [arrChiNhanhBank addObject:@"CN Nam Hà Nội"];
                [arrChiNhanhBank addObject:@"1204017"];
                [arrChiNhanhBank addObject:@"CN Nghệ An"];
                [arrChiNhanhBank addObject:@"40204001"];
                [arrChiNhanhBank addObject:@"CN Sài Gòn"];
                [arrChiNhanhBank addObject:@"79204023"];
                [arrChiNhanhBank addObject:@"CN Sở giao dịch"];
                [arrChiNhanhBank addObject:@"1204002"];
                [arrChiNhanhBank addObject:@"CN TP Hồ Chí Minh"];
                [arrChiNhanhBank addObject:@"79204001"];
                [arrChiNhanhBank addObject:@"CN TT Thanh Toán"];
                [arrChiNhanhBank addObject:@"1204009"];
                [arrChiNhanhBank addObject:@"CN Thăng Long"];
                [arrChiNhanhBank addObject:@"1204011"];
                [arrChiNhanhBank addObject:@"CN Thừa Thiên Huế"];
                [arrChiNhanhBank addObject:@"46204001"];
                [arrChiNhanhBank addObject:@"CN tỉnh Bắc Giang"];
                [arrChiNhanhBank addObject:@"24204001"];
                [arrChiNhanhBank addObject:@"CN tỉnh Bình Dương"];
                [arrChiNhanhBank addObject:@"74204001"];
                [arrChiNhanhBank addObject:@"CN tỉnh Bình Thuận"];
                [arrChiNhanhBank addObject:@"60204001"];
                [arrChiNhanhBank addObject:@"CN tỉnh Cao Bằng"];
                [arrChiNhanhBank addObject:@"4204001"];
                [arrChiNhanhBank addObject:@"CN tỉnh Điện Biên"];
                [arrChiNhanhBank addObject:@"11204001"];
                [arrChiNhanhBank addObject:@"CN tỉnh Hà Nam"];
                [arrChiNhanhBank addObject:@"35204001"];
                [arrChiNhanhBank addObject:@"CN tỉnh Hà Tĩnh"];
                [arrChiNhanhBank addObject:@"42204001"];
                [arrChiNhanhBank addObject:@"CN tỉnh Hoà Bình"];
                [arrChiNhanhBank addObject:@"17204001"];
                [arrChiNhanhBank addObject:@"CN tỉnh Khánh Hoà"];
                [arrChiNhanhBank addObject:@"56204001"];
                [arrChiNhanhBank addObject:@"CN tỉnh Kon Tum"];
                [arrChiNhanhBank addObject:@"62204001"];
                [arrChiNhanhBank addObject:@"CN tỉnh Lào Cai"];
                [arrChiNhanhBank addObject:@"10204001"];
                [arrChiNhanhBank addObject:@"CN tỉnh Nam Định"];
                [arrChiNhanhBank addObject:@"36204001"];
                [arrChiNhanhBank addObject:@"CN tỉnh Ninh Bình"];
                [arrChiNhanhBank addObject:@"37204001"];
                [arrChiNhanhBank addObject:@"CN tỉnh Ninh Thuận"];
                [arrChiNhanhBank addObject:@"58204001"];
                [arrChiNhanhBank addObject:@"CN tỉnh Quảng Bình"];
                [arrChiNhanhBank addObject:@"44204001"];
                [arrChiNhanhBank addObject:@"CN tỉnh Sơn La"];
                [arrChiNhanhBank addObject:@"14204001"];
                [arrChiNhanhBank addObject:@"CN tỉnh Thái Bình"];
                [arrChiNhanhBank addObject:@"34204001"];
                [arrChiNhanhBank addObject:@"CN tỉnh Thái Nguyên"];
                [arrChiNhanhBank addObject:@"19204001"];
                [arrChiNhanhBank addObject:@"CN tỉnh Tuyên Quang"];
                [arrChiNhanhBank addObject:@"8204001"];
                [arrChiNhanhBank addObject:@"CN tỉnh Vĩnh Phúc"];
                [arrChiNhanhBank addObject:@"26204001"];
                [arrChiNhanhBank addObject:@"Tự nhập chi nhánh"];
                [arrChiNhanhBank addObject:@"11111111"];
                for (int i = 1; i < arrChiNhanhBank.count; i += 2) {
                    NSString *temp = [arrChiNhanhBank objectAtIndex:i];
                    if ([chiNhanhName isEqualToString:temp]) {
                        self.chiNhanh = [arrChiNhanhBank objectAtIndex:i-1];
                        break;
                    }
                }
                [arrChiNhanhBank release];
            }
        }
        else {
            self.chiNhanh = @"";
        }

        NSString *sID = [dict valueForKey:@"id"];
        if(sID)
            self.sID = sID;
        else
            self.sID = @"";
        
        NSString *companyCode = [dict valueForKey:@"companyCode"];
        if(companyCode)
            self.companyCode = companyCode;
        else
            self.companyCode = @"";
        
        NSString *nameBenefit = [dict valueForKey:@"nameBenefit"];
        if(nameBenefit)
            self.nameBenefit = nameBenefit;
        else
            self.nameBenefit = @"";
        
        NSString *maGiaoDich = [dict valueForKey:@"maGiaoDich"];
        if(maGiaoDich)
            self.maGiaoDich = maGiaoDich;
        else
            self.maGiaoDich = @"";
        
        NSNumber *tranTime = [dict valueForKey:@"tranTime"];
        if(tranTime)
            self.tranTime = tranTime;
        else
            self.tranTime = [NSNumber numberWithLongLong:0];
        
        NSString *nameBenefitSaoKe = [dict valueForKey:@"nameBenefitSaoKe"];
        if(nameBenefitSaoKe)
            self.nameBenefitSaoKe = nameBenefitSaoKe;
        else
            self.nameBenefitSaoKe = @"";
        
        NSString *bankAcc = [dict valueForKey:@"bankAcc"];
        if(bankAcc)
            self.bankAcc = bankAcc;
        else
            self.bankAcc = @"";
        
        NSString *nameUsed = [dict valueForKey:@"nameUsed"];
        if(nameUsed)
            self.nameUsed = nameUsed;
        else
            self.nameUsed = @"";
    }
    return self;
}

- (NSString *)layChiTietHienThi
{
    NSArray *allBanks = [BankCoreData allBanks];
    Banks *banks = nil;
    for(Banks *bank in allBanks)
    {
        if([bank.bank_sms isEqualToString:_bankCode])
        {
            banks = bank;
            break;
        }
    }
    
    NSMutableString *chiTietHienThi = [[[NSMutableString alloc] init] autorelease];
    [chiTietHienThi appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Ngân hàng", banks.bank_name];
    if (!self.chiNhanh.isEmpty && [banks.bank_sms isEqualToString:@"AGR"]) {
        [chiTietHienThi appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Chi nhánh", self.chiNhanh];
    }
    [chiTietHienThi appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Chủ tài khoản", _nameBenefit];
        [chiTietHienThi appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Số tài khoản", _bankAcc];
    if([_amount doubleValue] > 0)
        [chiTietHienThi appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Số tiền", [Common hienThiTienTe_1:[_amount doubleValue]]];
    double fSoPhi = [Common layPhiChuyenTienCuaSoTien:[_amount doubleValue] kieuChuyenTien:KIEU_CHUYEN_TIEN_DEN_TAI_KHOAN_NGAN_HANG maNganHang:banks.bank_sms];
    if(fSoPhi > 0)
        [chiTietHienThi appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Số phí", [Common hienThiTienTe_1:fSoPhi]];
    if(![_content isEqualToString:@""])
        [chiTietHienThi appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Nội dung", _content];
    
    return chiTietHienThi;
}

- (NSString *)layKieuGiaoDich
{
    return @"Chuyển tiền đến Tài khoản";
}

- (double)laySoTienGiaoDich
{
    return [_amount doubleValue];
}

- (NSString *)layNoiDung
{
    return _content;
}

- (double)laySoTienPhiGiaoDich
{
    NSArray *allBanks = [BankCoreData allBanks];
    Banks *banks = nil;
    for(Banks *bank in allBanks)
    {
        if([bank.bank_sms isEqualToString:_bankCode])
        {
            banks = bank;
            break;
        }
    }
    double fSoPhi = [Common layPhiChuyenTienCuaSoTien:[_amount doubleValue] kieuChuyenTien:KIEU_CHUYEN_TIEN_DEN_TAI_KHOAN_NGAN_HANG maNganHang:banks.bank_sms];
    return fSoPhi;
}

- (void)dealloc
{
    [_amount release];
    [_bankCode release];
    [_content release];
    [_bankNumber release];
    [_sID release];
    [_companyCode release];
    [_nameBenefit release];
    [_maGiaoDich release];
    [_tranTime release];
    [_nameBenefitSaoKe release];
    [_bankAcc release];
    [_nameUsed release];
    [super dealloc];
}

@end
