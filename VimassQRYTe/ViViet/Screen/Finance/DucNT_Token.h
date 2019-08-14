//
//  DucNT_Token.h
//  ViMASS
//
//  Created by MacBookPro on 7/8/14.
//
//

#import <Foundation/Foundation.h>
#import "NSString+Hex.h"
#import "HOTP.h"
#import "UICKeyChainStore.h"
#import "JSONKit.h"

#define keySeed @"TOKEN_SEED" //seed được lưu giữ
#define keyPassword @"TOKEN_PASSWORD"
#define keyVitokenAccount @"TOKEN_ACCOUNT_PHONE" //số phone + inforprefix -> key được lưu giữ
#define keyTime @"TOKEN_TIME_CACHE" //lưu thời gian cache để tránh request nhiều lần
#define keyInfoPrefix @"TOKEN_INFO_PREFIX_"
#define keyService @"TOKEN_SERVICE"
#define KEY_SEED_HIEN_TAI @"KEY_SEED_HIEN_TAI"
#define KEY_MAT_KHAU_SEED_HIEN_TAI @"KEY_MAT_KHAU_SEED_HIEN_TAI"
#define KEY_KHOA_MAT_KHAU_SEED_HIEN_TAI @"123456"


//@interface TokenInfo : NSObject
//
//@property (nonatomic, copy)         NSString *account;
//@property (nonatomic, copy)         NSString *seed;
//@property (nonatomic, copy)         NSNumber *time;
//@property (nonatomic, assign) BOOL  actived;
//
//@end

@interface DucNT_Token : NSObject

+ (NSString *)OTPFromPIN:(NSString *)pin seed:(NSString *)seed;
+ (NSString *)encryptSEED:(NSString *)seed withPin:(NSString *)pin;
+ (NSString *)decryptSEED:(NSString *)seed_encrypt withPin:(NSString *)pin;
+ (NSString *) hexstringFromBytes:(char *)data length:(int)l;

//+ (void)luuSeedToken:(NSString *)sSeed forAccountPhone:(NSString *)sPhone;
//+ (bool)daTonTaiAccountPhone:(NSString *)sPhone;
+ (NSString *)layThongTinTrongKeyChain:(NSString *)sPhone;
//+ (TokenInfo *)layThongTinDuocLuuTuKeyChain:(NSString *)sPhone;
+ (void)xoaKey:(NSString *)sPhone;
+ (void)xoaService;

+ (void)luuSeedToken:(NSString*)sSeed;
+ (NSString*)laySeedTokenHienTai;
+ (BOOL)daTonTaiToken;

+ (void)luuMatKhauVanTayToken:(NSString*)sMatKhau;
+ (NSString*)layMatKhauVanTayToken;
+ (BOOL)daTonTaiMatKhauVanTay;





@end


