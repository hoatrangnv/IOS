//
//  ViToken.h
//  OATH Token
//
//  Created by Chung NV on 5/7/13.
//
//

#import <Foundation/Foundation.h>
#import "HOTP.h"
#import "NSString+Hex.h"

@interface ViTokenInfo : NSObject

@property (nonatomic, copy)         NSString *account;
@property (nonatomic, copy)         NSString *seed;
@property (nonatomic, copy)         NSString *serial_no;
@property (nonatomic, copy)         NSNumber *time;
@property (nonatomic, assign) BOOL  actived;

@end



@interface ViToken : NSObject

/**
 *
 * Kiểm tra xem có được phép verify token hay không.
 * @return YES nếu lần verify token "Đúng" trước đó lớn hơn 30s , NO nếu nhỏ hơn 30s
 *
 */
+(BOOL) verify_token_should_begin;

/**
 *
 * Khi có gặp sự kiện verify token "Đúng" thì gọi hàm này ,để cảnh bảo cho các trường hợp sau chờ đợi sau 30s mới được dùng
 *
 */
+(void) verify_token_make_waiting;

/**
 *
 * Thông báo người dùng chờ đợi sau 1 khoảng thời gian để sử dụng token
 * @param doSomething Block thực hiện sau khi người dùng click vào nút OK
 *
 */
+(void) alert_wating_token:(void(^)()) doSomething;

/**
 *
 * Hiện alert để hỏi người dùng mật khẩu token.
 *
 */
+ (void) enter_ViToken_pin:(void(^)(BOOL success,NSString *pin)) doAction;


+ (NSString *)activeUser;
+ (void)setActiveUser:(NSString *)user;
/**
 *
 * Trả về thời gian 6 số token thay đổi của account token hiện tại.
 *
 */
+ (int)tokenInterval;

+ (ViTokenInfo *)activeToken;
+ (BOOL)available;
+ (NSString *)OTPFromPIN:(NSString *)pin;
+ (void)storeSeed:(NSString *)seed serial:(NSString *)serial actived:(BOOL)actived user:(NSString *)user;
+ (void)convert_old_data;


+ (NSString *)OTPFromPIN:(NSString *)pin user:(NSString *)user;
+ (NSString *)OTPFromPIN:(NSString *)pin seed:(NSString *)seed;
+ (BOOL)canGenerateOTP:(NSString *)user;
+ (ViTokenInfo *)getInfo:(NSString *)user;
+ (NSString *)encryptSEED:(NSString *)seed withPin:(NSString *)pin;
+ (NSString *)decryptSEED:(NSString *)seed_encrypt withPin:(NSString *)pin;

@end
