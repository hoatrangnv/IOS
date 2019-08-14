//
//  DucNT_SaoKeObject.m
//  ViMASS
//
//  Created by MacBookPro on 7/11/14.
//
//

#import "DucNT_SaoKeObject.h"
#import "Common.h"

@implementation DucNT_SaoKeObject

- (id)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if(self)
    {
        NSString *sId = [dict objectForKey:@"id"];
        NSString *amount = [dict objectForKey:@"amount"];
        NSString *bankAcc = [dict objectForKey:@"bankAcc"];
        NSString *bankShortName = [dict objectForKey:@"bankShortName"];
        NSNumber *feeAmount = [dict objectForKey:@"feeAmount"];
        NSString *fromAcc = [dict objectForKey:@"fromAcc"];
        NSString *giftName = [dict objectForKey:@"giftName"];

        NSNumber *idIcon = [dict objectForKey:@"idIcon"];
        NSString *nameBenefit = [dict objectForKey:@"nameBenefit"];
        NSString *nameUsed = [dict objectForKey:@"nameUsed"];
        NSString *toAcc = [dict objectForKey:@"toAcc"];
        NSNumber *totalAmount = [dict objectForKey:@"totalAmount"];
        NSNumber *totalAmountToAcc = [dict objectForKey:@"totalAmountToAcc"];
        NSNumber *totalPromotion = [dict objectForKey:@"totalPromotion"];
        NSNumber *totalPromotionToAcc = [dict objectForKey:@"totalPromotionToAcc"];
        NSString *transDesc = [dict objectForKey:@"transDesc"];
        NSString *transTime = [dict objectForKey:@"transTime"];
        NSNumber *type = [dict objectForKey:@"type"];
        NSNumber *timeAction = [dict objectForKey:@"timeAction"];
        NSNumber *nVMApp = [dict objectForKey:@"VMApp"];
        
        NSNumber *nKieuXacThuc = [dict objectForKey:@"kieuXacThuc"];
        NSNumber *nDonViXacThuc = [dict objectForKey:@"donViXacThuc"];
        
        self.sId = sId;
        self.amount = amount;
        self.bankAcc = bankAcc;
        self.bankShortName = bankShortName;
        self.feeAmount = feeAmount;
        self.fromAcc = fromAcc;
        self.giftName = giftName;
        self.idIcon = idIcon;
        self.nameBenefit = nameBenefit;
        self.nameUsed = nameUsed;
        self.toAcc = toAcc;
        self.totalAmount = totalAmount;
        self.totalAmountToAcc = totalAmountToAcc;
        self.totalPromotion = totalPromotion;
        self.totalPromotionToAcc = totalPromotionToAcc;
        self.transDesc = transDesc;
        self.transTime = transTime;
        self.type = type;
        self.timeAction = timeAction;
        self.VMApp = nVMApp;
        self.kieuXacThuc = nKieuXacThuc;
        self.donViXacThuc = nDonViXacThuc;
    }
    return self;
}

- (NSString*)layThoiGianChuyenTien
{
    NSString *sThoiGianChuyenTien = @"";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[_transTime longLongValue] / 1000];
    sThoiGianChuyenTien = [Common date:date toStringWithFormat:@"dd.MM.yy HH:mm"];
    return sThoiGianChuyenTien;
}

- (NSString*)layNgayThangChuyenTien
{
//    NSLog(@"%s - _transTime : %@", __FUNCTION__, _transTime);
    NSString *sThoiGianChuyenTien = @"";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[_transTime longLongValue] / 1000];
    sThoiGianChuyenTien = [Common date:date toStringWithFormat:@"dd-MM-yyyy"];
    return sThoiGianChuyenTien;
}

- (NSString*)layNgayGioChuyenTien
{
    NSString *sThoiGianChuyenTien = @"";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[_transTime longLongValue] / 1000];
    sThoiGianChuyenTien = [Common date:date toStringWithFormat:@"HH:mm"];
    return sThoiGianChuyenTien;
}

- (NSString*)layNoiDung
{
    NSString *sNoiDung = @"";
    sNoiDung = [Common URLDecode:_transDesc];
    if(!sNoiDung)
        sNoiDung = _transDesc;
    return sNoiDung;
}

- (NSString*)layGiftName
{
    NSString *sNoiDung = @"";
    sNoiDung = [Common URLDecode:_giftName];
    if(sNoiDung)
        sNoiDung = _giftName;
    return sNoiDung;
}

- (NSString*)layTimeAction
{
    NSString *sTimeAction = @"";
    long long nThoiGianTang = [_timeAction longLongValue];
    long long nThoiGianGiaoDich = [_transTime longLongValue];
    if(nThoiGianTang > nThoiGianGiaoDich)
    {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[_timeAction longLongValue] / 1000];
        sTimeAction = [Common date:date toStringWithFormat:@"dd/MM/yyyy HH:mm"];
    }
    else
    {
        sTimeAction = [@"tang_ngay" localizableString];
    }
    return sTimeAction;
}


- (void)dealloc
{
    if (_VMApp) {
        [_VMApp release];
    }
    if(_timeAction)
        [_timeAction release];
    if(_totalAmount)
        [_totalAmount release];
    if(_type)
        [_type release];
    if(_giftName)
        [_giftName release];
    if(_idIcon)
        [_idIcon release];
    if(_bankAcc)
        [_bankAcc release];
    if(_bankShortName)
        [_bankShortName release];
    if(_nameBenefit)
        [_nameBenefit release];
    if(_nameUsed)
        [_nameUsed release];
    if(_sId)
        [_sId release];
    if(_transTime)
        [_transTime release];
    if(_amount)
        [_amount release];
    if(_transDesc)
        [_transDesc release];
    if(_fromAcc)
        [_fromAcc release];
    if(_toAcc)
        [_toAcc release];
    if(_feeAmount)
        [_feeAmount release];
    if(_totalAmountToAcc)
        [_totalAmountToAcc release];
    if(_totalPromotion)
        [_totalPromotion release];
    if(_totalPromotionToAcc)
        [_totalPromotionToAcc release];
    [super dealloc];
}

@end
