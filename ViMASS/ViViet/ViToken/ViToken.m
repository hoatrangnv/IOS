//
//  ViToken.m
//  OATH Token
//
//  Created by Chung NV on 5/7/13.
//
//

#import "ViToken.h"
#import "NSString+Hex.h"
#import "NSString+Extended.h"
#import "AppDelegate.h"
#import "UICKeyChainStore.h"
#import "JSONKit.h"

#import "DDAlertPrompt.h"
#import "Alert+Block.h"

#define keySeed @"VITOKEN_SEED"
#define keySerialNo @"VITOKEN_SERIAL_NO"
#define keyVitokenAccount @"VITOKEN_ACCOUNT"
#define keyService @"VITOKEN"
#define keyInfoPrefix @"VITOKENINFO"

static ViToken * common_vitoken = nil;

@interface ViToken()
@property (nonatomic, assign) BOOL verifyWaiting;
@end

@implementation ViToken

+(ViToken *) common_vitoken
{
    if (common_vitoken == nil)
    {
        common_vitoken = [ViToken new];
        common_vitoken.verifyWaiting = NO;
    }
    return common_vitoken;
}

//For Verify Token
+(BOOL) verify_token_should_begin;
{
    ViToken *vitoken = [ViToken common_vitoken];
    BOOL wait = vitoken.verifyWaiting;
    return wait == NO;
}
+(void)verify_token_make_waiting
{
    ViToken *vitoken = [ViToken common_vitoken];
    
    int interval = [ViToken tokenInterval];
    
    if ([ViToken verify_token_should_begin])
    {
        vitoken.verifyWaiting = YES;
        NSDate *now = [NSDate date];
        NSTimeInterval delay = (NSTimeInterval)interval + 1 - (int)now.timeIntervalSince1970 % interval;
        [vitoken performSelector:@selector(not_wait) withObject:nil afterDelay:delay];
    }
}

-(void) not_wait
{
    self.verifyWaiting = NO;
}

+(void) alert_wating_token:(void(^)()) doSomething
{
    int interval = [ViToken tokenInterval];
    
    NSDate *now = [NSDate date];
    NSTimeInterval delay = (NSTimeInterval)interval + 1 - (int)now.timeIntervalSince1970 % interval;
    NSString *message = [NSString stringWithFormat:@"Bạn vui lòng thử lại sau %g giây",delay];
    [UIAlertView alert:message withTitle:nil block:^(UIAlertView *alert, int indexClicked){
         if (doSomething)
         {
             doSomething();
         }
     }];
}
+(void)enter_ViToken_pin:(void (^)(BOOL success, NSString *pin))doAction
{
    if ([ViToken verify_token_should_begin] == NO)
    {
        [ViToken alert_wating_token:^{
            if (doAction) {
                doAction(NO,nil);
            }
        }];
        return;
    }
    
    if (token_type == TOKEN_TYPE_HARD)
    {
        [DDAlertPrompt prompt:@"vitoken - enter 6 number" type:DDAlertPromptType_Login option:^(DDAlertPrompt *alert)
         {
             alert.textview.placeholder = @"mobile numbers".localizableString;
             alert.subtextview.placeholder = @"nhap_6_so_token".localizableString;
             
             alert.textview.keyboardType = UIKeyboardTypeNumberPad;
             alert.subtextview.keyboardType = UIKeyboardTypeNumberPad;
             alert.max_text_length = 11;
             alert.max_subtext_length = 6;
             [alert setValidateMethod:^BOOL(DDAlertPrompt *alert)
              {
                  BOOL check = alert.subtextview.text.length == 6 && alert.textview.text.length > 8;
                  return check;
              }];
             
         } callback:^(DDAlertPrompt *alert, int selected_button)
         {
             NSString *pin = alert.text;
             if (doAction)
                 doAction(selected_button == INDEX_OF_OK_BUTTON,pin);
         }];
    }else
    {
        [DDAlertPrompt prompt:@"vitoken - enter pin" type:DDAlertPromptType_SecureText option:^(DDAlertPrompt *alert)
         {
             alert.max_text_length = 6;
             alert.textview.keyboardType = UIKeyboardTypeDefault;
             
             [alert setValidateMethod:^BOOL(DDAlertPrompt *alert)
              {
                  return alert.text.length == 6;
              }];
             
         } callback:^(DDAlertPrompt *alert, int selected_button)
         {
             NSString *pin = alert.text;
             if (doAction)
                 doAction(selected_button == INDEX_OF_OK_BUTTON,pin);
         }];
    }
}


+ (NSString *)activeUser;
{
    NSString *mobile = [UICKeyChainStore stringForKey:keyVitokenAccount service:keyService];
    return mobile;
}
+ (void)setActiveUser:(NSString *)user;
{
    if (user == nil || user.length == 0)
    {
        [UICKeyChainStore removeItemForKey:keyVitokenAccount service:keyService];
        return;
    }
    
    [UICKeyChainStore setString:user forKey:keyVitokenAccount service:keyService];
}

+ (ViTokenInfo *)activeToken;
{
    NSString *mobile = [UICKeyChainStore stringForKey:keyVitokenAccount service:keyService];
    if (mobile == nil)
        return nil;
    
    ViTokenInfo *info = [ViToken getInfo:mobile];
    
    return info;
}

+ (BOOL)available;
{
    ViTokenInfo *info = [ViToken activeToken];
    if (info == nil || info.actived == NO)
        return NO;
    
    return YES;
}

+ (NSString *)OTPFromPIN:(NSString *)pin;
{
    if ([ViToken available] == NO)
        return nil;
    
    NSString *mobile = [UICKeyChainStore stringForKey:keyVitokenAccount service:keyService];
    
    return [ViToken OTPFromPIN:pin user:mobile];
}

+ (int)tokenInterval;
{
    ViTokenInfo *ifo = [self activeToken];
    if (ifo == nil)
        return 60;
    
    return ifo.time.intValue;
}

+ (void)convert_old_data;
{
//    return;
    if ([ViToken available] == YES)
        return;
    
    ViTokenInfo *info = [ViToken getInfo:@"0913201990"];
    if (info != nil)
    {
        [UICKeyChainStore setString:@"0913201990" forKey:keyVitokenAccount service:keyService];
        return;
    }
    
    info = [ViToken getInfo:@"0915152823"];
    if (info != nil)
    {
        [UICKeyChainStore setString:@"0915152823" forKey:keyVitokenAccount service:keyService];
        return;
    }
}

+ (void)storeSeed:(NSString *)seed serial:(NSString *)serial actived:(BOOL)actived user:(NSString *)user;
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         seed, @"seed",
                         serial, @"serial",
                         [NSNumber numberWithInt:actived], @"actived",
                         [NSNumber numberWithInt:30], @"time",
                         nil];
    
    if (actived == YES)
    {
        [UICKeyChainStore setString:user forKey:keyVitokenAccount service:keyService];
    }
    NSString *v = [dic JSONString];
    NSString *k = [NSString stringWithFormat:@"%@%@", keyInfoPrefix, user];
    
    [UICKeyChainStore setString:v forKey:k service:keyService];
}

+ (ViTokenInfo *)getInfo:(NSString *)user;
{
    NSString *k = [NSString stringWithFormat:@"%@%@", keyInfoPrefix, user];
    
    NSString *v = [UICKeyChainStore stringForKey:k service:keyService];
    
    if (v == nil || v.length == 0)
        return nil;
    
    NSDictionary *dic = [v objectFromJSONString];
    if (dic == nil)
        return nil;
    
    ViTokenInfo *info = [ViTokenInfo new];
    
    info.seed = [dic objectForKey:@"seed"];
    info.serial_no = [dic objectForKey:@"serial"];
    info.actived = ((NSNumber *)[dic objectForKey:@"actived"]).intValue;
    info.account = user;
    info.time =  [dic objectForKey:@"time"];
    if (info.time == nil || info.time.intValue == 0)
        info.time = [NSNumber numberWithInt:60];
    
    return [info autorelease];
}

+ (NSString *)OTPFromPIN:(NSString *)pin user:(NSString *)user;
{
    ViTokenInfo *info = [self getInfo:user];
    
    if (info == nil || info.seed == nil || info.seed.length == 0)
        return nil;
    
    return [ViToken OTPFromPIN:pin seed:info.seed interval:info.time == nil ? 60 : info.time.intValue];
}

+ (NSString *)OTPFromPIN:(NSString *)pin seed:(NSString *)seed;
{
    return [self OTPFromPIN:pin seed:seed interval:30];
}

+ (NSString *)OTPFromPIN:(NSString *)pin seed:(NSString *)seed interval:(int)interval;
{
    NSString *key_hex =[ViToken decryptSEED:seed withPin:pin];
    
    NSString *keyDigits = [key_hex validateHex];
    if (keyDigits == nil)
        return nil;
    
    NSData *key = [keyDigits parseHex];
    NSUInteger counter = time(NULL)/interval;
    
    HOTP *hotp = [HOTP hotpWithKey:key counter:counter numDigits:6];
    [hotp computePassword];
    return [NSString stringWithFormat:@"%@", hotp.dec];
}

+ (BOOL)canGenerateOTP:(NSString *)account;
{
    ViTokenInfo *info = [self getInfo:account];
    
    return info != nil && info.seed != nil && info.seed.length > 0 && info.actived == YES;
}


// deprecated

+ (BOOL)isAvailable;
{
    NSString *seed = [self getSeed];
    
    return !(seed == nil || seed.length == 0);
}

//+ (void)storeSeed:(NSString *)seed andSerialNo:(NSString *)serial_no activated:(BOOL)activated
//{
//    if (seed == nil)
//        seed = @"";
//    if (serial_no == nil)
//        serial_no = @"";
//    
//    if (activated == YES)
//    {
//        [UICKeyChainStore setString:seed forKey:keySeed service:keyService];
//        [UICKeyChainStore setString:serial_no forKey:keySerialNo service:keyService];
//    }
//    else
//    {
//        [[NSUserDefaults standardUserDefaults] setObject:seed forKey:keySeed];
//        [[NSUserDefaults standardUserDefaults] setObject:serial_no forKey:keySerialNo];
//    }
//}

+ (NSString *)getSeed;
{
    NSString *seed = [UICKeyChainStore stringForKey:keySeed service:keyService];
    return seed;
}
+ (NSString *)getSerialNo;
{
    NSString *seed = [UICKeyChainStore stringForKey:keySerialNo service:keyService];
//    return [[NSUserDefaults standardUserDefaults] objectForKey:keySerialNo];
    return seed;
}

+ (NSString *)getTemporarySeed;
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:keySeed];
}

+ (NSString *)getTemporarySerialNo
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:keySerialNo];
}


//+ (NSString *)genOTPWithPin:(NSString *)pin
//{
//    NSString *encryptedSeed = [ViToken getSeed];
//    
//    return [ViToken genOTPWithPin:pin usingSeed:encryptedSeed];
//}

#pragma mark - Base methods

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
    
    NSString *ret = [ViToken hexstringFromBytes:encrypt length:(int)seed_data.length];
    free(encrypt);
    return ret;
    
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
    
    
    NSString *ret = [ViToken hexstringFromBytes:decrypt length:seed_bytes_length];
    free(decrypt);
    NSLog(@"original seed: %@", ret);
    return ret;
}


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

-(void)dealloc
{
    [super dealloc];
}

@end


@implementation ViTokenInfo

@synthesize account;
@synthesize seed;
@synthesize serial_no;
@synthesize actived;

@end
