//
//  NonfinancialSession.h
//  ViMASS
//
//  Created by Chung NV on 2/19/14.
//
//

#import <Foundation/Foundation.h>

#define kNON_FINANCIAL_SESSION_1_DAY @"service : bds,rao vat,viec lam,tim viec"
#define kNON_FINANCIAL_SESSION_7_DAY @"service : dia diem"
#define kNON_FINANCIAL_SESSION_31_DAY @"service : dinh vi"

@interface NonfinancialSession : NSObject

/**
 *
 * Lấy session theo service.
 *
 * @param serviceKey thời gian quy định time out : kNON_FINANCIAL_SESSION_1_DAY, ...7_DAY, ...31_DAY
 * @param callback Block nhận kết quả trả về. "success" nếu thành công trả về YES, "session" & "phoneNumber".
 *
 */
+(void) service:(NSString *) serviceKey
    get_session:(void(^)(BOOL success,NSString *session,NSString *phoneNumber)) callBack;


+(void) set_session_invalid:(NSString *) serviceKey;

+(NSString *) phoneNumber;
+(NSString *) session;

/**
 *
 * Kiểm tra xem người dùng đã đăng ký ViToken chưa,
 *  + nếu đã đăng ký thì trả về callBack(YES).
 *  + nếu chưa đăng ký thì yêu cầu người dùng đăng ký.
 * @param callBack black nhận kết quả trả về.
 *
 */
+(void) check_vitoken_exist:(void(^)(BOOL exist)) callBack;
@end
