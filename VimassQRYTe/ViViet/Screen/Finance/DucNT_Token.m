
//
//  DucNT_Token.m
//  ViMASS
//
//  Created by MacBookPro on 7/8/14.
//
//

#import "DucNT_Token.h"
#import "FBEncryptorAES.h"

@implementation DucNT_Token

#pragma mark - DESCRYPT va ENCRYPT OTP
+(NSString *) hexstringFromBytes:(char *)data length:(int)l
{
    char * o = malloc (l * 2 + 1);
    o[l*2 + 1] = 0;
    char *ret = o;
    
    for (int i = 0; i < l; i++)
    {
        o += sprintf(o, "%02X", ((int)data[i]) & 0xFF);
    }
    
    NSString *tmp = [[NSString alloc] initWithBytes:ret length:l*2 encoding:NSASCIIStringEncoding];
    free(ret);
    return tmp;
}

+(NSString *)decryptSEED:(NSString *)seed_encrypt withPin:(NSString *)pin
{
    if (seed_encrypt == nil || pin == nil)
        return nil;
    
    NSData *seed_data = seed_encrypt.hexData;
    const char *seed_bytes = seed_data.bytes;
    int seed_bytes_length = (int)seed_data.length;
    
    NSData *pin_sha256 = pin.sha256;
    const char *pin_bytes = pin_sha256.bytes;
    
    char * decrypt = malloc(seed_bytes_length + 1);
    decrypt[seed_bytes_length] = 0;
    
    for (int i = 0; i < seed_data.length; i++)
    {
        decrypt[i] = (seed_bytes[i] - pin_bytes[i]);
    }
    
    
    NSString *ret = [self hexstringFromBytes:decrypt length:seed_bytes_length];
    free(decrypt);
    NSLog(@"%s >> %s line: %d >> orginalSeed: %@ ",__FILE__,__FUNCTION__ ,__LINE__, ret);
    return ret;
}

+ (NSString *)encryptSEED:(NSString *)seed withPin:(NSString *)pin
{
    NSData *seed_data = seed.hexData;
    
    const char *seed_bytes =seed_data.bytes;
    
    NSData *pin_sha256 =pin.sha256;
    const char *pin_bytes = pin_sha256.bytes;
    
    char * encrypt = malloc(seed_data.length + 1);
    encrypt[seed_data.length] = 0;
    
    for (int i = 0; i < seed_data.length; i++)
    {
        char byte_i = seed_bytes[i] + pin_bytes[i];
        encrypt[i] = byte_i;
    }
    
    NSString *ret = [self hexstringFromBytes:encrypt length:(int)seed_data.length];
    free(encrypt);
    return ret;
    
}

#pragma mark - sinh OTP từ seed với 30s thay một lần
+ (NSString *)OTPFromPIN:(NSString *)pin seed:(NSString *)seed;
{
    return [self OTPFromPIN:pin seed:seed interval:30];
}


+ (NSString *)OTPFromPIN:(NSString *)pin seed:(NSString *)seed interval:(int)interval;
{
    NSString *key_hex =[self decryptSEED:seed withPin:pin];
    NSLog(@"Debug:%@: %@, key_hex : %@", NSStringFromClass([self class]),NSStringFromSelector(_cmd), key_hex);
    NSString *keyDigits = [key_hex validateHex];
    if (keyDigits == nil)
        return nil;
    
    NSData *key = [keyDigits parseHex];
    NSUInteger counter = time(NULL)/interval;
    
    HOTP *hotp = [HOTP hotpWithKey:key counter:counter numDigits:6];
    [hotp computePassword];
    return [NSString stringWithFormat:@"%@", [hotp.dec copy]];
}

#pragma mark - xử lý lưu và truy vấn token (lưu sau khi thực hiện otp)

+(void)luuSeedToken:(NSString *)sSeed forAccountPhone:(NSString *)sPhone
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         sSeed, keySeed,
                         nil];
    NSString *sKeyPhone = [NSString stringWithFormat:@"%@%@", keyInfoPrefix, sPhone];
    NSUserDefaults *myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.vimass.sharing"];
    [myDefaults setObject:[dic JSONString] forKey:sKeyPhone];
    [myDefaults synchronize];
    //    if([DucNT_Token daTonTaiAccountPhone:sKeyPhone] == false)
    //    {
    //        UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:keyService];
    //        [store setString:[dic JSONString] forKey:sKeyPhone];
    //        [store synchronize];
    //    }
    //    else
    //    {
    //        NSLog(@"%s >> %s line: %d >> da ton tai ",__FILE__,__FUNCTION__ ,__LINE__);
    //        [UICKeyChainStore setString:[dic JSONString] forKey:sKeyPhone service:keyService];
    //    }
}

+(bool)daTonTaiAccountPhone:(NSString *)sPhone
{
    bool bDaTonTai = true;
    NSString *sKeyPhone = [NSString stringWithFormat:@"%@%@", keyInfoPrefix, sPhone];
    //    NSString *sValue = [UICKeyChainStore stringForKey:sKeyPhone service:keyService];
    NSUserDefaults *myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.vimass.sharing"];
    NSString *sValue = (NSString *)[myDefaults objectForKey:sKeyPhone];
    if(sValue == nil || sValue.length == 0)
    {
        bDaTonTai = false;
    }
    return bDaTonTai;
}

#pragma mark - luu seed moi

+ (void)luuSeedToken:(NSString*)sSeed
{
    NSUserDefaults *myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.vimass.sharing"];
    [myDefaults setObject:sSeed forKey:KEY_SEED_HIEN_TAI];
    [myDefaults synchronize];
    //    if(![DucNT_Token daTonTaiToken])
    //    {
    //        UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:keyService];
    //        [store setString:sSeed forKey:KEY_SEED_HIEN_TAI];
    //        [store synchronize];
    //    }
    //    else
    //    {
    //        [UICKeyChainStore setString:sSeed forKey:KEY_SEED_HIEN_TAI service:keyService];
    //    }
}

+ (NSString*)laySeedTokenHienTai
{
    NSUserDefaults *myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.vimass.sharing"];
    NSString *sSeed = @"";
    NSString *sValue = (NSString *)[myDefaults objectForKey:KEY_SEED_HIEN_TAI];
    //    NSString *sValue = [UICKeyChainStore stringForKey:KEY_SEED_HIEN_TAI service:keyService];
    
    if(sValue && sValue.length > 0)
    {
        sSeed = sValue;
    }
    return sSeed;
}

+ (BOOL)daTonTaiToken
{
    NSUserDefaults *myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.vimass.sharing"];
    NSString *sSeedHienTai = (NSString *)[myDefaults objectForKey:KEY_SEED_HIEN_TAI];
    //    NSString *sSeedHienTai = [UICKeyChainStore stringForKey:KEY_SEED_HIEN_TAI service:keyService];
    NSLog(@"Debug:%@: %@, sSeedHienTai : %@", NSStringFromClass([self class]),NSStringFromSelector(_cmd), sSeedHienTai);
    if(sSeedHienTai && sSeedHienTai.length > 0)
        return YES;
    return NO;
}

//+(TokenInfo *)layThongTinDuocLuuTuKeyChain:(NSString *)sPhone
//{
//    NSString *sKeyPhone = [NSString stringWithFormat:@"%@%@", keyInfoPrefix, sPhone];
//    NSString *sValue = [UICKeyChainStore stringForKey:sKeyPhone service:keyService];
//    if(sValue != nil && sValue.length > 0)
//    {
//        NSDictionary *dic = [sValue objectFromJSONString];
//        if(dic != nil)
//        {
//            TokenInfo *info = [[TokenInfo alloc] init];
//            info.seed = [dic objectForKey:keySeed];
//            return [info autorelease];
//        }
//        return nil;
//    }
//    return nil;
//}

/*
 * không hiểu sao ko có tác dụng
 */

+(void)xoaKey:(NSString *)sPhone
{
    NSString *sKeyPhone = [NSString stringWithFormat:@"%@%@", keyInfoPrefix, sPhone];
    //    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:keyService];
    //    [store removeItemForKey:sKeyPhone];
    //    [store synchronize];
    NSUserDefaults *myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.vimass.sharing"];
    [myDefaults removeObjectForKey:sKeyPhone];
    [myDefaults synchronize];
}

+(void)xoaService
{
    [UICKeyChainStore removeAllItemsForService:keyService];
}

+(NSString *)layThongTinTrongKeyChain:(NSString *)sPhone
{
    NSString *sSeed = @"";
    //    NSString *sValue = [UICKeyChainStore stringForKey:KEY_SEED_HIEN_TAI service:keyService];
    NSUserDefaults *myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.vimass.sharing"];
    NSString *sValue = (NSString *)[myDefaults objectForKey:KEY_SEED_HIEN_TAI];
    NSLog(@"DUCNT_Token - %s - sValue : %@", __FUNCTION__, sValue);
    if(sValue && sValue.length > 0)
    {
        sSeed = sValue;
    }
    return sSeed;
}

+ (void)luuMatKhauVanTayToken:(NSString*)sMatKhau
{
    NSString *sMatKhauMaHoa = [FBEncryptorAES encryptBase64String:sMatKhau keyString:KEY_KHOA_MAT_KHAU_SEED_HIEN_TAI separateLines:NO];
    NSUserDefaults *myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.vimass.sharing"];
    if(![DucNT_Token daTonTaiMatKhauVanTay])
    {
        [myDefaults setObject:sMatKhauMaHoa forKey:KEY_MAT_KHAU_SEED_HIEN_TAI];
        //        UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:keyService];
        //        [store setString:sMatKhauMaHoa forKey:KEY_MAT_KHAU_SEED_HIEN_TAI];
        //        [store synchronize];
    }
    else
    {
        [myDefaults setObject:sMatKhauMaHoa forKey:KEY_MAT_KHAU_SEED_HIEN_TAI];
        //        [UICKeyChainStore setString:sMatKhauMaHoa forKey:KEY_MAT_KHAU_SEED_HIEN_TAI service:keyService];
    }
    [myDefaults synchronize];
}

+ (NSString*)layMatKhauVanTayToken
{
    //    NSString *sMatKhauHienTai = [UICKeyChainStore stringForKey:KEY_MAT_KHAU_SEED_HIEN_TAI service:keyService];
    NSUserDefaults *myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.vimass.sharing"];
    NSString *sMatKhauHienTai = (NSString *)[myDefaults objectForKey:KEY_MAT_KHAU_SEED_HIEN_TAI];
    if(sMatKhauHienTai && sMatKhauHienTai.length > 0)
    {
        NSString *returnValue = [FBEncryptorAES decryptBase64String:sMatKhauHienTai keyString:KEY_KHOA_MAT_KHAU_SEED_HIEN_TAI];
        return returnValue;
    }
    return @"";
}

+ (BOOL)daTonTaiMatKhauVanTay
{
    //    NSString *sSeedHienTai = [UICKeyChainStore stringForKey:KEY_MAT_KHAU_SEED_HIEN_TAI service:keyService];
    NSUserDefaults *myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.vimass.sharing"];
    NSString *sSeedHienTai = (NSString *)[myDefaults objectForKey:KEY_MAT_KHAU_SEED_HIEN_TAI];
    if(sSeedHienTai && sSeedHienTai.length > 0)
        return YES;
    return NO;
}
@end

////
////  DucNT_Token.m
////  ViMASS
////
////  Created by MacBookPro on 7/8/14.
////
////
//
//#import "DucNT_Token.h"
//#import "FBEncryptorAES.h"
//
//@implementation DucNT_Token
//
//#pragma mark - DESCRYPT va ENCRYPT OTP
//+(NSString *) hexstringFromBytes:(char *)data length:(int)l
//{
//    char * o = malloc (l * 2 + 1);
//    o[l*2 + 1] = 0;
//    char *ret = o;
//
//    for (int i = 0; i < l; i++)
//    {
//        o += sprintf(o, "%02X", ((int)data[i]) & 0xFF);
//    }
//
//    NSString *tmp = [[NSString alloc] initWithBytes:ret length:l*2 encoding:NSASCIIStringEncoding];
//    free(ret);
//    return tmp;
//}
//
//+(NSString *)decryptSEED:(NSString *)seed_encrypt withPin:(NSString *)pin
//{
//    if (seed_encrypt == nil || pin == nil)
//        return nil;
//
//    NSData *seed_data = seed_encrypt.hexData;
//    const char *seed_bytes = seed_data.bytes;
//    int seed_bytes_length = (int)seed_data.length;
//
//    NSData *pin_sha256 = pin.sha256;
//    const char *pin_bytes = pin_sha256.bytes;
//
//    char * decrypt = malloc(seed_bytes_length + 1);
//    decrypt[seed_bytes_length] = 0;
//
//    for (int i = 0; i < seed_data.length; i++)
//    {
//        decrypt[i] = (seed_bytes[i] - pin_bytes[i]);
//    }
//
//
//    NSString *ret = [self hexstringFromBytes:decrypt length:seed_bytes_length];
//    free(decrypt);
//    NSLog(@"%s >> %s line: %d >> orginalSeed: %@ ",__FILE__,__FUNCTION__ ,__LINE__, ret);
//    return ret;
//}
//
//+ (NSString *)encryptSEED:(NSString *)seed withPin:(NSString *)pin
//{
//    NSData *seed_data = seed.hexData;
//
//    const char *seed_bytes =seed_data.bytes;
//
//    NSData *pin_sha256 =pin.sha256;
//    const char *pin_bytes = pin_sha256.bytes;
//
//    char * encrypt = malloc(seed_data.length + 1);
//    encrypt[seed_data.length] = 0;
//
//    for (int i = 0; i < seed_data.length; i++)
//    {
//        char byte_i = seed_bytes[i] + pin_bytes[i];
//        encrypt[i] = byte_i;
//    }
//
//    NSString *ret = [self hexstringFromBytes:encrypt length:(int)seed_data.length];
//    free(encrypt);
//    return ret;
//
//}
//
//#pragma mark - sinh OTP từ seed với 30s thay một lần
//+ (NSString *)OTPFromPIN:(NSString *)pin seed:(NSString *)seed;
//{
//    return [self OTPFromPIN:pin seed:seed interval:30];
//}
//
//
//+ (NSString *)OTPFromPIN:(NSString *)pin seed:(NSString *)seed interval:(int)interval;
//{
//    NSString *key_hex =[self decryptSEED:seed withPin:pin];
//    NSLog(@"Debug:%@: %@, key_hex : %@", NSStringFromClass([self class]),NSStringFromSelector(_cmd), key_hex);
//    NSString *keyDigits = [key_hex validateHex];
//    if (keyDigits == nil)
//        return nil;
//
//    NSData *key = [keyDigits parseHex];
//    NSUInteger counter = time(NULL)/interval;
//
//    HOTP *hotp = [HOTP hotpWithKey:key counter:counter numDigits:6];
//    [hotp computePassword];
//    return [NSString stringWithFormat:@"%@", [hotp.dec copy]];
//}
//
//#pragma mark - xử lý lưu và truy vấn token (lưu sau khi thực hiện otp)
//+(void)luuSeedToken:(NSString *)sSeed forAccountPhone:(NSString *)sPhone
//{
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                         sSeed, keySeed,
//                         nil];
//    NSString *sKeyPhone = [NSString stringWithFormat:@"%@%@", keyInfoPrefix, sPhone];
//    if([DucNT_Token daTonTaiAccountPhone:sKeyPhone] == false)
//    {
//        UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:keyService];
//        [store setString:[dic JSONString] forKey:sKeyPhone];
//        [store synchronize];
//    }
//    else
//    {
//        NSLog(@"%s >> %s line: %d >> da ton tai ",__FILE__,__FUNCTION__ ,__LINE__);
//        [UICKeyChainStore setString:[dic JSONString] forKey:sKeyPhone service:keyService];
//    }
//}
//
//+(bool)daTonTaiAccountPhone:(NSString *)sPhone
//{
//    bool bDaTonTai = true;
//    NSString *sKeyPhone = [NSString stringWithFormat:@"%@%@", keyInfoPrefix, sPhone];
//    NSString *sValue = [UICKeyChainStore stringForKey:sKeyPhone service:keyService];
//    if(sValue == nil || sValue.length == 0)
//    {
//        bDaTonTai = false;
//    }
//    return bDaTonTai;
//}
//
//#pragma mark - luu seed moi
//
//+ (void)luuSeedToken:(NSString*)sSeed
//{
//    if(![DucNT_Token daTonTaiToken])
//    {
//        UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:keyService];
//        [store setString:sSeed forKey:KEY_SEED_HIEN_TAI];
//        [store synchronize];
//    }
//    else
//    {
//        [UICKeyChainStore setString:sSeed forKey:KEY_SEED_HIEN_TAI service:keyService];
//    }
//}
//
//+ (NSString*)laySeedTokenHienTai
//{
//    NSString *sSeed = @"";
//    NSString *sValue = [UICKeyChainStore stringForKey:KEY_SEED_HIEN_TAI service:keyService];
//
//    if(sValue && sValue.length > 0)
//    {
//        sSeed = sValue;
//    }
//    return sSeed;
//}
//
//+ (BOOL)daTonTaiToken
//{
//    NSString *sSeedHienTai = [UICKeyChainStore stringForKey:KEY_SEED_HIEN_TAI service:keyService];
//    NSLog(@"Debug:%@: %@, sSeedHienTai : %@", NSStringFromClass([self class]),NSStringFromSelector(_cmd), sSeedHienTai);
//    if(sSeedHienTai && sSeedHienTai.length > 0)
//        return YES;
//    return NO;
//}
//
////+(TokenInfo *)layThongTinDuocLuuTuKeyChain:(NSString *)sPhone
////{
////    NSString *sKeyPhone = [NSString stringWithFormat:@"%@%@", keyInfoPrefix, sPhone];
////    NSString *sValue = [UICKeyChainStore stringForKey:sKeyPhone service:keyService];
////    if(sValue != nil && sValue.length > 0)
////    {
////        NSDictionary *dic = [sValue objectFromJSONString];
////        if(dic != nil)
////        {
////            TokenInfo *info = [[TokenInfo alloc] init];
////            info.seed = [dic objectForKey:keySeed];
////            return [info autorelease];
////        }
////        return nil;
////    }
////    return nil;
////}
//
///*
// * không hiểu sao ko có tác dụng
// */
//
//+(void)xoaKey:(NSString *)sPhone
//{
//    NSString *sKeyPhone = [NSString stringWithFormat:@"%@%@", keyInfoPrefix, sPhone];
//    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:keyService];
//    [store removeItemForKey:sKeyPhone];
//    [store synchronize];
//}
//
//+(void)xoaService
//{
//    [UICKeyChainStore removeAllItemsForService:keyService];
//}
//
//+(NSString *)layThongTinTrongKeyChain:(NSString *)sPhone
//{
////    NSString *sKeyPhone = [NSString stringWithFormat:@"%@%@", keyInfoPrefix, sPhone];
////    NSString *sValue = [UICKeyChainStore stringForKey:sKeyPhone service:keyService];
////    if(sValue != nil && sValue.length > 0)
////    {
////        NSDictionary *dic = [sValue objectFromJSONString];
////        NSString *sSeed = [dic objectForKey:keySeed];
////        return sSeed;
////    }
////    return @"";
//    NSString *sSeed = @"";
//    NSString *sValue = [UICKeyChainStore stringForKey:KEY_SEED_HIEN_TAI service:keyService];
//
//    if(sValue && sValue.length > 0)
//    {
//        sSeed = sValue;
//    }
//    return sSeed;
//}
//
//+ (void)luuMatKhauVanTayToken:(NSString*)sMatKhau
//{
//    NSString *sMatKhauMaHoa = [FBEncryptorAES encryptBase64String:sMatKhau keyString:KEY_KHOA_MAT_KHAU_SEED_HIEN_TAI separateLines:NO];
//    if(![DucNT_Token daTonTaiMatKhauVanTay])
//    {
//        UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:keyService];
//        [store setString:sMatKhauMaHoa forKey:KEY_MAT_KHAU_SEED_HIEN_TAI];
//        [store synchronize];
//    }
//    else
//    {
//        [UICKeyChainStore setString:sMatKhauMaHoa forKey:KEY_MAT_KHAU_SEED_HIEN_TAI service:keyService];
//    }
//}
//
//+ (NSString*)layMatKhauVanTayToken
//{
//    NSString *sMatKhauHienTai = [UICKeyChainStore stringForKey:KEY_MAT_KHAU_SEED_HIEN_TAI service:keyService];
//    if(sMatKhauHienTai && sMatKhauHienTai.length > 0)
//    {
//        NSString *returnValue = [FBEncryptorAES decryptBase64String:sMatKhauHienTai keyString:KEY_KHOA_MAT_KHAU_SEED_HIEN_TAI];
//        return returnValue;
//    }
//    return @"";
//}
//
//+ (BOOL)daTonTaiMatKhauVanTay
//{
//    NSString *sSeedHienTai = [UICKeyChainStore stringForKey:KEY_MAT_KHAU_SEED_HIEN_TAI service:keyService];
//    if(sSeedHienTai && sSeedHienTai.length > 0)
//        return YES;
//    return NO;
//}
//@end
