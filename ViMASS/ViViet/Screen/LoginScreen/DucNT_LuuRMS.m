//
//  DucNT_LuuRMS.m
//  ViMASS
//
//  Created by MacBookPro on 7/8/14.
//
//

#import "DucNT_LuuRMS.h"

@implementation DucNT_LuuRMS

+ (void)luuNgonNgu:(int)nValue {
    NSUserDefaults *myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.vimass.sharing"];
    [myDefaults setInteger:nValue forKey:@"NGON_NGU"];
    [myDefaults synchronize];
//    [[NSUserDefaults standardUserDefaults] setInteger:nValue forKey:@"NGON_NGU"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (int)layNgonNgu {
    NSUserDefaults *myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.vimass.sharing"];
    return (int)[myDefaults integerForKey:@"NGON_NGU"];
//    return (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"NGON_NGU"];
}

+ (void)luuHanMuc:(NSString *)sKey dHanMuc:(double)dHanMuc {
    NSUserDefaults *myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.vimass.sharing"];
    [myDefaults setDouble:dHanMuc forKey:sKey];
    [myDefaults synchronize];
//    [[NSUserDefaults standardUserDefaults] setDouble:dHanMuc forKey:sKey];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (double)layHanMuc:(NSString *)sKey {
    NSUserDefaults *myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.vimass.sharing"];
    return [myDefaults doubleForKey:sKey];
//    return [[NSUserDefaults standardUserDefaults] doubleForKey:sKey];
}

+ (void)luuTypeShowNotification:(NSString*)sKey value:(NSString *)value {
    NSUserDefaults *myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.vimass.sharing"];
    [myDefaults setValue:value forKey:sKey];
    [myDefaults synchronize];
//    [[NSUserDefaults standardUserDefaults] setValue:value forKey:sKey];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)layTypeShowNotification:(NSString*)sKey {
    NSUserDefaults *myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.vimass.sharing"];
    return [myDefaults stringForKey:sKey];
//    return [[NSUserDefaults standardUserDefaults] stringForKey:sKey];
}

+(void)luuThongTinDangNhap:(NSString *)sKeyID value:(id)sValueID
{
    NSUserDefaults *myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.vimass.sharing"];
    [myDefaults setValue:sValueID forKey:sKeyID];
    [myDefaults synchronize];
//    [[NSUserDefaults standardUserDefaults] setValue:sValueID forKey:sKeyID];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)luuThongTinTrongRMSTheoKey:(NSString*)sKey value:(id)value
{
    NSUserDefaults *myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.vimass.sharing"];
    [myDefaults setValue:value forKey:sKey];
    [myDefaults synchronize];
//    [[NSUserDefaults standardUserDefaults] setValue:value forKey:sKey];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)layThongTinTrongRMSTheoKey:(NSString*)sKey
{
    NSUserDefaults *myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.vimass.sharing"];
    return [myDefaults objectForKey:sKey];
//    return [[NSUserDefaults standardUserDefaults] objectForKey:sKey];
}


+(NSString *)layThongTinDangNhap:(NSString *)sKeyID
{
    NSUserDefaults *myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.vimass.sharing"];
    NSString *sThongTin = @"";
    sThongTin = [myDefaults objectForKey:sKeyID];
    if(!sThongTin)
        sThongTin = @"";
    return sThongTin;
}

+(void)xoaThongTinRMS
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    NSUserDefaults *myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.vimass.sharing"];
    [myDefaults removePersistentDomainForName:appDomain];
//    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

+(void)xoaThongTinRMSTheoKey:(NSString *)sKeyID
{
    NSUserDefaults *myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.vimass.sharing"];
    [myDefaults removeObjectForKey:sKeyID];
    [myDefaults synchronize];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:sKeyID];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)luuThongTinTaiKhoanViSauDangNhap:(DucNT_TaiKhoanViObject *)obj
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.vimass.sharing"];
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:obj];
    [defaults setObject:encodedObject forKey:KEY_LOGIN_THONG_TIN_TAI_KHOAN];
    [defaults synchronize];
}

+(DucNT_TaiKhoanViObject *)layThongTinTaiKhoanVi
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.vimass.sharing"];
    NSData *myEncodedObject = [defaults objectForKey:KEY_LOGIN_THONG_TIN_TAI_KHOAN];
    DucNT_TaiKhoanViObject* obj = (DucNT_TaiKhoanViObject*)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    return obj;
}

+(void)xoaThongTinRMSLogout
{
    [self xoaThongTinRMSTheoKey:KEY_DANG_NHAP];
    [self xoaThongTinRMSTheoKey:KEY_LOGIN_STATE];
    [self xoaThongTinRMSTheoKey:KEY_LOGIN_ID_TEMP];
    [self xoaThongTinRMSTheoKey:KEY_LOGIN_TRANG_THAI_CO_TOKEN];
    [self xoaThongTinRMSTheoKey:KEY_LOGIN_THONG_TIN_TAI_KHOAN];
    [self xoaThongTinRMSTheoKey:KEY_LOGIN_TEN_VIEWCONTROLLER_CAN_TOI];
    [self xoaThongTinRMSTheoKey:KEY_LOGIN_KIEU_CHUYEN_GIAO_DIEN];
    [self xoaThongTinRMSTheoKey:KEY_LOGIN_SECSSION];
    [self xoaThongTinRMSTheoKey:KEY_TIME_SOFT_TOKEN];
    [self xoaThongTinRMSTheoKey:KEY_DAY_SOFT_TOKEN];
    [self xoaThongTinRMSTheoKey:KEY_TIME_VAN_TAY];
    [self xoaThongTinRMSTheoKey:KEY_DAY_VAN_TAY];
    [self xoaThongTinRMSTheoKey:KEY_TIME_MPKI];
    [self xoaThongTinRMSTheoKey:KEY_DAY_MPKI];
//    [self xoaThongTinRMSTheoKey:KEY_DEVICE_TOKEN];
}
@end
