//
//  Static.h
//  ViMASS
//
//  Copyright (c) 2012 PMU-ViMASS. All rights reserved.
//

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


#ifndef ViViet_Static_h
#define ViViet_Static_h

extern NSString *current_account;
extern NSString *active_token_serial;

extern NSString *baseURL;

extern int token_type;
extern BOOL hard_token_available;
extern BOOL soft_token_available;
extern int current_account_type;


#define APP_ID 5
#define VM_APP 2
#define DEVICE_REGIS_ID 2
#define FUNC_REGIS_ID 21

#define VI_TRI_GIAO_DIEN_CHINH 0

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define IMAGE_CREATE(name) [UIImage imageNamed:name]

#define kLOCATION_SERVICE_DEVICE_ID @"LOCATION_SERVICE_DEVICE_ID"

#define kRealTimeHeight 220

#define kViVietDefaultAnimationTime 0.35
#define INDEX_OF_OK_BUTTON 1

#define TOKEN_TYPE_HARD 1
#define TOKEN_TYPE_SOFT 3
#define VI_USER_HAS_TOKEN(token_type) (token_type == TOKEN_TYPE_HARD || token_type == TOKEN_TYPE_SOFT)

#define NUMBER_CONTACT_TO_REQUEST 60
#define MIN_TRANSFERING_MONEY 10000
#define MAX_TRANSFERING_MONEY 10000000

#define TIME_TO_SCAN_CONTACT 3
#define MAXLENGTH_AMOUNT 12
#define MESS_TYLE_SUCCESS 0
#define MESS_TYLE_FAILED 1
#define MESS_TYLE_WARNING 2

#define TIME_WAIT_QRCODE 120
#define TIME_REQUEST_CHECKQRCODE = 5
#define DUPLICATE_LOGIN @"LG005"
#define USER_ACCESS_DENINED @"CM002"
#define TRANSACTION_SUCCESS @"TM001"
#define GETBALANCE_INFO_SUCCESS @"GB001"
#define KY_TU_NGAN_CACH @"KY_TU_NGAN_CACH"
#define LANGUAGE @"LANGUAGE"

#define DISTANCE_FOR_SEARCH @"distance of searching in MAP"
#define TIME_OUT @"time out"

#pragma mark
#pragma mark Messager
#define messTitle @"messTitle"
#define messContentOPT @"messContentOPT"
#define messContentOPTSuccess @"messContentOPTSuccess"
#define messContentOPTFail @"messContentOPTFail"
#define messTitleButtonComfirm @"messTitleButtonComfirm"
#define messTitleButtonCancel @"messTitleButtonCancel"
#define messContentOfSignIn @"messContentOfSignIn"
#define messPlaceHolderUsername @"messPlaceHolderUsername"
#define messPlaceHolderPasswords @"messPlaceHolderPasswords"

#pragma mark
#pragma mark Username - Password
#define SAVEUSERLOGIN @"SAVEUSERLOGIN"
#define USERNAME @"USERNAME"
#define PINCODE @"PINCODE"
#define PASSWORD @"PASSWORD"

#pragma mark - Messager

#define VIVIET_ERROR_USER_CANCEL @"VV_UserCancel"


#define kMailformedResponse @"XX999"
#define kInternalError      @"XX998"

#define kNotificationLogin @"ViVietLoggedIn"
#define kNotificationLogout @"ViVietLoggedOut"





#define SERVER_DOMAIN_TEST @"http://10.254.1.179/viviet/"
#define SERVER_DOMAIN_BASE @"https://vimass.vn"
#define SERVER_DOMAIN_BASE_WWW @"http://www.vimass.vn"

//#define SERVER_DOMAIN @"https://webmail.cmc.com.vn/owa/"
#define NOTIFI_FAILD @"RequestFailed"
#define NOTIFI_CONNECTED @"Connected"
#define NOTIFY_SERVER_ERR @"NOTIFY_SERVER_ERR"
//#define NOTIFY_NETWORK_FAILED @"NETWORK_FAILED"
#define NOTIFI_REGISTER @"NOTIFI_REGISTER"

#define NOTIFI_RESPONSE @"NOTIFI_RESPONSE"
#define NOTIFI_LOGIN @"Login"
#define NOTIFI_LOGINED @"LG001"
#define NOTIFI_SET_FIRST_LOGIN @"SetFirstLogin"
#define NOTIFI_LOGOUT @"Logout"
#define NOTIFI_CHANGEPASSWORD @"NOTIFI_CHANGEPASSWORD"
#define NOTIFI_CHANGEPIN @"NOTIFI_CHANGEPIN"

#define NOTIFI_TRANSFERMONEY @"NOTIFI_TRANSFERMONEY"
#define NOTIFI_CONFIRMTRANSACTION @"NOTIFI_CONFIRMTRANSACTION"
#define NOTIFI_GETTRANSACTIONINFO @"NOTIFI_GETTRANSACTIONINFO"
#define NOTIFI_GENERATEQRCODE @"NOTIFI_GENERATEQRCODE"
#define NOTIFI_GETQRCODEINFO @"NOTIFI_GETQRCODEINFO"
#define NOTIFI_GENERATEQRCODE_SUCCESS @"QRC001"



#define NOTIFI_TRANSFERMONEY_SUCCESS @"TM001"


#define NOTIFI_SIGNUP @"NOTIFI_SIGNUP"
#define NOTIFI_SIGNUPED @"RE001"

#define NOTIFI_GETBALANCE @"NOTIFI_GETBALANCE"

#define RESPONSE @"Response"
#define SHOWOTPCONFRIM @"SHOWOTPCONFRIM"
#define LOCKDEVICE @"LOCKDEVICE"

/**
 *
 *   Setting Keys
 *
 **/

#define kOptionLanguage @"OptionLanguage"
#define kOptionFont @"OptionFont"
#define kOptionSound @"OptionSound"
#define kOptionSendLocation @"phát vị trí"
#define kOptionPublicLocation @"cho phép xem vị trí"
#define kOptionViewOtherLocation @"xem vị trí người khác"



#endif
