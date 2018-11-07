//
//  DucNT_LuuRMS.m
//  ViMASS
//
//  Created by MacBookPro on 7/8/14.
//
//

#import "DucNT_LuuRMS.h"

@implementation DucNT_LuuRMS

+ (void)luuTypeShowNotification:(NSString*)sKey value:(NSString *)value {
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:sKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)layTypeShowNotification:(NSString*)sKey {
    return [[NSUserDefaults standardUserDefaults] stringForKey:sKey];
}

+(void)luuThongTinDangNhap:(NSString *)sKeyID value:(id)sValueID
{
    [[NSUserDefaults standardUserDefaults] setValue:sValueID forKey:sKeyID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)luuThongTinTrongRMSTheoKey:(NSString*)sKey value:(id)value
{
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:sKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)layThongTinTrongRMSTheoKey:(NSString*)sKey
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:sKey];
}


+(NSString *)layThongTinDangNhap:(NSString *)sKeyID
{
    NSString *sThongTin = @"";
    sThongTin = [[NSUserDefaults standardUserDefaults] objectForKey:sKeyID];
    if(!sThongTin)
        sThongTin = @"";
    return sThongTin;
}

+(void)xoaThongTinRMS
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

+(void)xoaThongTinRMSTheoKey:(NSString *)sKeyID
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:sKeyID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)luuThongTinTaiKhoanViSauDangNhap:(DucNT_TaiKhoanViObject *)obj
{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:obj];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:KEY_LOGIN_THONG_TIN_TAI_KHOAN];
    [defaults synchronize];
}

+(DucNT_TaiKhoanViObject *)layThongTinTaiKhoanVi
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
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
//    [self xoaThongTinRMSTheoKey:KEY_DEVICE_TOKEN];
}
@end
