//
//  DucNT_LuuRMS.h
//  ViMASS
//
//  Created by MacBookPro on 7/8/14.
//
//

#import <Foundation/Foundation.h>
#import "DUcNT_TaiKhoanViObject.h"

#define DANG_NHAP_THANH_CONG @"DANG_NHAP_THANH_CONG"

#define KEY_DANG_NHAP @"KEY_DANG_NHAP"
#define KEY_DANG_NHAP_DOANH_NGHIEP @"KEY_DANG_NHAP_DOANH_NGHIEP"
#define KEY_LOGIN_ID @"ID_LOGIN"
#define KEY_LOGIN_COMPANY_ID @"KEY_LOGIN_COMPANY_ID"
#define KEY_LOGIN_PASS @"PASSWORD_LOGIN"
#define KEY_LOGIN_ID_TEMP @"ID_TEMP_LOGIN"
#define KEY_LOGIN_MA_DAI_LY @"KEY_LOGIN_MA_DAI_LY"
#define KEY_LOGIN_REMEMBER_STATE @"TRANG_THAI_NHO_THONG_TIN_DANG_NHAP"
#define KEY_LOGIN_STATE @"TRANG_THAI_DANG_NHAP"
#define KEY_LOGIN_SECSSION @"KEY_LOGIN_SECSSION"

#define KEY_DINH_DANH_DOANH_NGHIEP @"KEY_DINH_DANH_DOANH_NGHIEP"

#define KEY_LOGIN_TRANG_THAI_CO_TOKEN @"TRANG_THAI_CO_TOKEN"
#define KEY_LOGIN_SO_DIEN_THOAI_DANG_KI_TOKEN @"KEY_LOGIN_SO_DIEN_THOAI_DANG_KI_TOKEN"
#define KEY_LOGIN_THONG_TIN_TAI_KHOAN @"THONG_TIN_TAI_KHOAN"
#define KEY_LOGIN_TEN_VIEWCONTROLLER_CAN_TOI @"KEY_LOGIN_TEN_VIEWCONTROLLER_CAN_TOI"
#define KEY_LOGIN_KIEU_CHUYEN_GIAO_DIEN @"KEY_LOGIN_KIEU_CHUYEN_GIAO_DIEN"
#define KEY_DEVICE_TOKEN @"DEVICE_TOKEN"
#define KEY_SEED_TOKEN @"KEY_SEED_TOKEN"
#define KEY_PHONE_AUTHENTICATE @"KEY_PHONE_AUTHENTICATE"
#define KEY_TYPE_SHOW_NOTIFICATION @"KEY_TYPE_SHOW_NOTIFICATION"
#define KEY_EMAIL_AUTHENTICATE @"KEY_EMAIL_AUTHENTICATE"

#define KEY_LAST_PHONE_LOGIN_ID @"KEY_LAST_PHONE_LOGIN_ID"

#define KEY_HIEN_THI_VI @"KEY_HIEN_THI_VI"

#define KEY_ID_ACC @"KEY_ID_ACC"
#define KEY_NAME_ALIAS @"KEY_NAME_ALIAS"
#define KEY_LAST_ID_LOGIN @"LAST_ID_LOGIN"


#define KEY_LUU_DANH_MUC_BDS @"KEY_LUU_DANH_MUC_BDS"
#define KEY_LUU_DANH_MUC_VIEC_LAM @"KEY_LUU_DANH_MUC_VIEC_LAM"

#define KEY_LUU_DANH_SACH_CONTACT @"KEY_LUU_DANH_SACH_CONTACT"
#define KEY_LUU_DANH_SACH_CONTACT_1 @"KEY_LUU_DANH_SACH_CONTACT_1"

//#define KEY_PHIEN_BAN_DANH_SACH_NHA_CUNG_CAP @"KEY_LUU_DANH_SACH_CONTACT_1"

//Chi dung cho thanh toan dien thoai
#define KEY_LUU_KIEU_THANH_TOAN_DIEN_THOAI @"KEY_LUU_KIEU_THANH_TOAN_DIEN_THOAI"

#define KEY_TIME_SOFT_TOKEN @"KEY_TIME_SOFT_TOKEN"
#define KEY_DAY_SOFT_TOKEN @"KEY_DAY_SOFT_TOKEN"

#define KEY_TIME_VAN_TAY @"KEY_TIME_VAN_TAY"
#define KEY_DAY_VAN_TAY @"KEY_DAY_VAN_TAY"

#define KEY_TIME_MPKI @"KEY_TIME_MPKI"
#define KEY_DAY_MPKI @"KEY_DAY_MPKI"

@interface DucNT_LuuRMS : NSObject
+ (void)luuNgonNgu:(int)nValue;
+ (int)layNgonNgu;
+ (void)luuHanMuc:(NSString *)sKey dHanMuc:(double)dHanMuc;
+ (double)layHanMuc:(NSString *)sKey;
+(void)luuThongTinDangNhap:(NSString *)sKeyID value:(id)sValueID;
+(NSString *)layThongTinDangNhap:(NSString *)sKeyID;
+(void)xoaThongTinRMSTheoKey:(NSString *)sKeyID;
+(void)xoaThongTinRMS;

+(void)luuThongTinTaiKhoanViSauDangNhap:(DucNT_TaiKhoanViObject *)obj;
+(DucNT_TaiKhoanViObject *)layThongTinTaiKhoanVi;

+(void)xoaThongTinRMSLogout;

+ (id)layThongTinTrongRMSTheoKey:(NSString*)sKey;
+ (void)luuThongTinTrongRMSTheoKey:(NSString*)sKey value:(id)value;
+ (void)luuTypeShowNotification:(NSString*)sKey value:(NSString *)value;
+ (NSString *)layTypeShowNotification:(NSString*)sKey;
@end
