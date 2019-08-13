//
//  VRequest.h
//  ViMASS
//
//  Created by Ngo Ba Thuong on 8/2/13.
//
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "Msg.h"
#import "VIPersonalProfile.h"
#import "ViLinkedAccount.h"

typedef enum
{
    WALLET_TYPE_MOBILE = 0,
    WALLET_TYPE_ID = 1,
    WALLET_TYPE_PASSPORT = 2,
    WALLET_TYPE_CORP = 3,
    WALLET_TYPE_SUPPLIER = 4
} WALLET_TYPE;

typedef enum
{
    PERSONAL_IMAGE_TYPE_CMND1 = 0,
    PERSONAL_IMAGE_TYPE_CMND2,
    PERSONAL_IMAGE_TYPE_PASSPORT,
    PERSONAL_IMAGE_TYPE_PHOTO,
    PERSONAL_IMAGE_TYPE_SIG,
    
} PERSONAL_IMAGE_TYPE;

typedef enum
{
    VIMASS_TOKEN_TYPE_HARD = 1,
    VIMASS_TOKEN_TYPE_SOFT = 3
    
} VIMASS_TOKEN_TYPE;

void set_domain(NSString *domain);

@interface VRequest : NSObject
{
    ASIHTTPRequest * request;
    NSTimeInterval timeout;
    SEL completed_handle;
    
    Msg *_msg;
    NSDictionary *_dict;
    NSObject *_data;
    
    NSString *response;
    NSObject *_tag;
}

@property (nonatomic, copy) NSString *response;
@property (nonatomic, retain) Msg *msg;
@property (nonatomic, retain) NSObject *data;
@property (nonatomic, retain) NSDictionary *dict;
@property (nonatomic, retain) NSObject *tag;
@property (nonatomic, assign) NSTimeInterval timeout;

- (void)cancel;

//
// ViToken methods
//
- (void)register_softtoken:(NSString *)phone;
- (void)confirm_register_softtoken_otp:(NSString *)otp serial:(NSString *)serial_no phone:(NSString *)phone;
- (void)verify_vitoken:(NSString *)otp phone:(NSString *)phone;
- (void)verify_token:(NSString *)token type:(int) tokentype;
- (void)get_token_type;
- (void)change_token_type:(int)type token:(NSString *)token;
// Huy 2 loai token lien quan den vi

- (void)delete_softtoken:(NSString *)token token_type:(int)token_type;
- (void)unregister_hardtoken:(NSString *)otp token_type:(int)token_type;;


// Huy soft token ma khong lien quan den vi
- (void)delete_softtoken_with_phone:(NSString *)phone;
- (void)registerToken:(NSString *)serial token:(NSString *) token;
// Huy token (hard/soft) bang cau hoi bao mat/hard token/soft token
- (void)delete_token:(int)type
                 otp:(NSString *)otp otp_type:(int)otp_type
   security_question:(NSString *)security_question
     security_answer:(NSString *)security_answer;
//
// Registration methods
//
- (void)set_personal_profile:(VIPersonalProfile *)profile token:(NSString *)token;
- (void)get_personal_info;
- (void)get_personal_image:(PERSONAL_IMAGE_TYPE)type;
- (void)get_question_list;
- (void)upload_registration_images:(NSData *)data;
/**
 *
 * Dang ky Vi theo kieu cu, khong con dung nua.
 *
 */
- (void)submit_wallet_registration_type:(WALLET_TYPE)type
                                   name:(NSString *)fullname
                                    DOB:(NSString *)DOB
                                     ID:(NSString *)ID
                             issue_date:(NSString *)isd
                            issue_place:(NSString *)isp
                                  phone:(NSString *)phone
                                    pwd:(NSString *)pwd
                                   mail:(NSString *)mail
                                   addr:(NSString *)addr
                                   secQ:(NSString *)secQ
                                   secA:(NSString *)secA
                                 avatar:(NSString *)avatar
                                   sig:(NSString *)sig
                               front_id:(NSString *)front_id
                                back_id:(NSString *)back_id
                               passport:(NSString *)passport;
/**
 *
 * Dang ky Vi theo kieu moi
 * @param account So dtdd, cmnd, ho chieu.
 *
 */

- (void)registerWithType:(WALLET_TYPE)type
                 account:(NSString *)account
                    name:(NSString *)name
                nickname:(NSString *)nickname
                   email:(NSString *)email
                password:(NSString *)password;

//
// Login
//
- (void)login_user:(NSString *)user pwd:(NSString *)password type:(WALLET_TYPE)type;
/**
 *
 * Đăng nhập, địa điểm, ....
 *
 */
- (void)nonFinancialLoginWithUser:(NSString *)user pwd:(NSString *)pwd;
/**
 *
 * Thêm tài khoản liên kết.
 * @param account Thông tin tài khoản được thêm vào.
 * @param otp 6 số token phương pháp hiện tại.
 * @return Thành công hoặc không.
 */
- (void)addLinkedAccount:(ViLinkedAccount *)account otp:(NSString *)otp;
/**
 *
 * Lấy danh sách các tài khoản liên kết gắn với ví.
 * @return Danh sách NSArray<ViLinkedAccount>
 */
- (void)getLinkedAccounts;
/**
 *
 * Xoá tài khoản liên kết khỏi danh sách.
 * @param accountNumber Số tài khoản cần xoá.
 * @param otp 6 số token phương pháp hiện tại.
 * @return Thành công hay không.
 */
- (void)removeLinkedAccount:(NSString *)accountNumber otp:(NSString *)otp;


//
// Transfer methods
//
- (void)transferAmount:(NSString *) amount
                    to:(NSString *) receiver
           description:(NSString *) description
                 token:(NSString *) token
            notiPhones:(NSString *) phones
             anonymous:(BOOL ) anonymous;

- (void)transferToBank:(NSString *)bankAccount
                branch:(NSString *)branchCode
                amount:(NSString *)amount
          receiverName:(NSString *)receiverName
           description:(NSString *)description
            notiPhones:(NSString *)phones
                 token:(NSString *)token;

- (void)transferToID:(NSString *)IDNo
           issueDate:(NSString *)issueDate
          issuePlace:(NSString *)issuePlace
              amount:(NSString *)amount
        receiverName:(NSString *)receiverName
              branch:(NSString *)branchCode
         description:(NSString *)description
          notiPhones:(NSString *)phones
               token:(NSString *)token;

- (void) getBalance;
- (void) getProfileInfo;
- (void) changeProfileWithName:(NSString *) name
                         email:(NSString*)email
                       address:(NSString*) address
                      tpeValue:(NSString*) tpeValue
                         token:(NSString*) token;

- (void)withdraw:(NSString *)amount token:(NSString *)token;


- (void)registerWalletWithType:(int)type
                         phone:(NSString *)phone
                      IDNumber:(NSString *)IDNumber
                     issueDate:(NSString *)issueDate
                    issuePlace:(NSString *)issuePlace
                          name:(NSString *)name
                           sex:(int)sex
                           DOB:(NSString *)DOB
                           POB:(NSString *)POB address:(NSString *)addr
                         email:(NSString *)email
                       secretQ:(NSString *)secretQ
                       secretA:(NSString *)secretA;

- (void)registerConfirm:(NSString *)account otp:(NSString *)otp;


- (void)confirmOTP:(NSString *) otp;

#pragma mark - Confirm method

- (void)getConfirmMethod;
- (void)setConfirmMethod:(NSString *)method token:(NSString *)token;
+ (BOOL)requireOTP:(int)method;
+ (BOOL)requireHardToken:(int)method;


- (void)changePasswordFrom:(NSString *)oldpwd to:(NSString *)newpwd withToken:(NSString *)token;

-(void) getAgentsMatchKeyword: (NSString *)keyword withBoundariesTop:(CGFloat) top left:(CGFloat)left right: (CGFloat)right bottom:(CGFloat)bottom;

-(void) getBanks;
-(void) getProvinces;
-(void) getBrachesByBank:(NSString *)bankCode andProvince:(NSString *)provinceID;


- (void)getTransactionsAtPage:(int) pageCount
                      numRows:(int) numRow
                     fromDate:(NSDate *)dFrom
                       toDate:(NSDate *) dTo;

- (void)checkContact:(NSMutableArray *) listAcc;
@end
