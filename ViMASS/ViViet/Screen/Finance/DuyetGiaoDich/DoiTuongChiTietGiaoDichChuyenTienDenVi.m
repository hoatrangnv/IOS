//
//  DoiTuongChuyenTienDenVi.m
//  ViViMASS
//
//  Created by DucBui on 6/11/15.
//
//

#import "DoiTuongChiTietGiaoDichChuyenTienDenVi.h"

@implementation DoiTuongChiTietGiaoDichChuyenTienDenVi

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super initWithDict:dict];
    if(self)
    {
        NSString *tuVi = [dict valueForKey:@"companyCode"];
        if (tuVi) {
            self.vi = tuVi;
        }
        else
            self.vi = @"";
        
        NSString *fromAcc = [dict valueForKey:@"fromAcc"];
        if(fromAcc)
            self.fromAcc = fromAcc;
        else
            self.fromAcc = @"";
        
        NSString *toAcc = [dict valueForKey:@"toAcc"];
        if(toAcc)
            self.toAcc = toAcc;
        else
            self.toAcc = @"";
        
        NSString *transDesc = [dict valueForKey:@"transDesc"];
        if(transDesc)
            self.transDesc = transDesc;
        else
            self.transDesc = @"";
        
        NSNumber *amount = [dict valueForKey:@"amount"];
        if(amount)
            self.amount = amount;
        else
            self.amount = [NSNumber numberWithDouble:0.0f];
        NSNumber *transTime = [dict valueForKey:@"transTime"];
        if(transTime)
            self.transTime = transTime;
        else
            self.transTime = [NSNumber numberWithLongLong:0];
        NSNumber *feeAmount = [dict valueForKey:@"feeAmount"];
        if(feeAmount)
            self.feeAmount = feeAmount;
        else
            self.feeAmount = [NSNumber numberWithDouble:0.0f];
        
        NSString *companyCode = [dict valueForKey:@""];
        if(companyCode)
            self.companyCode = companyCode;
        else
            self.companyCode = @"";
    }
    return self;
}

- (NSString *)layChiTietHienThi
{
    NSMutableString *chiTietHienThi = [[[NSMutableString alloc] init] autorelease];
    [chiTietHienThi appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Từ", _fromAcc];
    [chiTietHienThi appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Đến", _toAcc];
    if([_amount doubleValue] > 0)
        [chiTietHienThi appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Số tiền", [Common hienThiTienTe_1:[_amount doubleValue]]];
    if([_feeAmount doubleValue] > 0)
        [chiTietHienThi appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Số phí", [Common hienThiTienTe_1:[_feeAmount doubleValue]]];
    if(![_transDesc isEqualToString:@""])
        [chiTietHienThi appendFormat:XAU_HTML_COT_DOI_TUONG_GIAO_DICH, @"Nội dung", _transDesc];
    
    return chiTietHienThi;
}

- (NSString *)layKieuGiaoDich
{
    return @"Chuyển tiền đến Ví";
}

- (double)laySoTienGiaoDich
{
    return [_amount doubleValue];
}

- (NSString *)layNoiDung
{
    return _transDesc;
}

- (double)laySoTienPhiGiaoDich
{
    double fSoPhi = [Common layPhiChuyenTienCuaSoTien:[_amount doubleValue] kieuChuyenTien:KIEU_CHUYEN_TIEN_DEN_VI maNganHang:@""];
    return fSoPhi;
}

- (void)dealloc
{
    [_fromAcc release];
    [_toAcc release];
    [_transDesc release];
    [_amount release];
    [_transTime release];
    [_feeAmount release];
    [_companyCode release];
    [super dealloc];
}
@end
