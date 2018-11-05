//
//  ExTextField.h
//  ExTextField
//
//  Created by Chung NV on 2/25/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kText_ERROR_EMPTY     @"Empty!"
#define kText_ERROR_PHONE     @"Số điện thoại không hợp lệ!"
#define kText_ERROR_MONEY     @"Money Wrong!"
#define kText_ERROR_CONTENT   @"Content Wrong!"
#define kText_ERROR_MAIL      @"Thư điện tử không hợp lệ!"
#define kText_ERROR_TOKEN     @"Token Wrong!"
#define kText_ERROR_PASSWORD  @"Từ 6 - 40 kí tự,không có dấu cách và ký tự đặc biệt"
#define kText_ERROR_ID_CARD   @"CMTND không hợp lệ!"
#define kText_ERROR_NAME      @"Họ và tên không hợp lệ"
#define kText_ERROR_DATE      @"Ngày tháng không hợp lệ"
#define kText_ERROR_VITOKEN_PWD      @"MK k hop le"
#define kText_ERROR_URL       @"textfield_error_msg_invalid_url"
#define kText_ERROR_BANK_ACCOUNT       @"Tài khoản ngân hàng không hợp lệ"
#define kText_ERROR_BANK_NUMBER @"Số tài khoản phải từ 6 đến 20 số!"
#define kText_ERROR_CARD_NUMBER @"Số thẻ phải là 16 hoặc 19 số!"
#define kText_ERROR_CARD_PAYMENT_NUMBER @"Số thẻ phải là 16 hoặc 19 số!"

#define kPATTERN_EMPTY        @""
#define kPATTERN_PHONE        @"^[0-9x\\*\\•]{10,11}$"
#define kPATTERN_MONEY        @"^[0-9]{1,3}([.,][0-9]{3}){0,5}$"
#define kPATTERN_CONTENT      @"^[^\\`\\~\\!\\@\\#\\$\\%\\^\\&\\*\\(\\)\\=\\+\\[\\{\\]\\}\\\\\\|\\'\\\"\\<\\>\\/\\?]+$"
#define kPATTERN_MAIL         @"^(\\s)*[0-9a-zA-Z.]+@[a-zA-Z0-9]+(\\.[a-zA-Z]{2,4}){1,2}(\\s)*$"
#define kPATTERN_TOKEN        @"^[0-9]{6,8}$"
#define kPATTERN_PASSWORD     @"^[0-9a-zA-Z]{6,40}$"
//#define kPATTERN_PASSWORD     @"^{6,40}$"
#define kPATTERN_ID_CARD      @"^\\d{9,10}$|^\\d{12}$"
// name not include following character: `~!@#$%^&*()-_=+[{]}\|'";:<,>./?0123456789
#define kPATTERN_NAME         @"^[^\\`\\~\\!\\@\\#\\$\\%\\^\\&\\*\\(\\)\\-\\_\\=\\+\\[\\{\\]\\}\\\\\\|\\'\\\"\\;\\:\\<\\,\\>\\.\\/\\?0123456789]+$"
#define kPATTERN_DATE         @"^([0-9]{2}){1,2}[-\\/][0-9]{2}[-\\/]([0-9]{2}){1,2}$"
#define kPATTERN_VITOKEN_PASSWORD     @"^[0-9a-zA-Z]{6}$"
//#define kPARTERN_URL          @"(?i)\\b(?:[a-z][\\w\\-]+://(?:\\S+?(?::\\S+?)?\\@)?)?(?:(?:(?<!:/|\\.)(?:(?:[a-z0-9\\-]+\\.)+[a-z]{2,4}(?![a-z]))|(?<=://)/))(?:(?:[^\\s()<>]+|\\((?:[^\\s()<>]+|(?:\\([^\\s()<>]*\\)))*\\))*)(?<![\\s`!()\\[\\]{};:'\".,<>?«»“”‘’])"
#define kPARTERN_URL          @"((http|ftp|https):\\/\\/)?[\\w\\-_]+(\\.[\\w\\-_]+)+([\\w\\-\\.,@?^=%&amp;:/~\\+#]*[\\w\\-\\@?^=%&amp;/~\\+#])?"
#define kPATTERN_BANK_ACCOUNT    @"(^[a-zA-Z][a-zA-Z0-9]*\\d+[a-zA-Z0-9]*$)|(^\\d[a-zA-Z0-9]*$)"
#define kPATTERN_CORP_CODE      @"^[0-9]{10,13}$"
#define kPATTERN_SUPPLIER_CODE  @"^[0-9]{10}$"
#define kPATTERN_BANK_NUMBER  @"^[0-9\\*]{6,20}$"
#define kPATTERN_CARD_NUMBER  @"^[0-9\\*]{16,19}$"
#define kPATTERN_CARD_PAYMENT_NUMBER  @"^[0-9\\*]{16,19}$"

#define kPATTERN_VN_NON_SPECIAL_CHAR @"^[^\\!\\@\\#\\$\\%\\^\\&\\*\\(\\)]+$"


typedef enum {
    ExTextFieldTypeNone     = -100,
    ExTextFieldTypeEmpty     = 0,
    ExTextFieldTypePhone     = 1,
    ExTextFieldTypeMoney     = 2,
    ExTextFieldTypeContent   = 3,
    ExTextFieldTypeMail      = 4,
    ExTextFieldTypeToken     = 5,
    ExTextFieldTypePassword  = 6,
    ExTextFieldTypeIDCard    = 7,
    ExTextFieldTypeName      = 8,
    ExTextFieldTypeDate      = 9,
    ExTextFieldTypeViTokenPassword      = 10,
    ExTextFieldTypeURL       = 11,
    ExTextFieldTypeBankAccount       = 12,
    ExTextFieldTypeCorpCode  = 13,
    ExTextFieldTypeSupplierCode     = 14,
    ExTextFieldTypeBankNumber     = 15,
    ExTextFieldTypeCardNumber     = 16,
    ExTextFieldTypeCardPaymentNumber     = 17
} ExTextFieldType;

#define TOTAL_TYPE            18




@class ExTextField;

@protocol ExTextFieldDelegate <NSObject>

- (void)suKienXuLySearchCuaExTextField:(UITextField*)textField;

@end


typedef  void (^IconErrorTapBlock)();
typedef BOOL (^ValidateBlock)(ExTextField *tf);

@interface ExTextField : UITextField <UITextFieldDelegate>
{
    BOOL                focusable;
    NSMutableArray *    textErrors;
    NSMutableArray *    patterns;
    UIImageView    *    notifyView;
    NSMutableDictionary * validateBlocks;
    
    /**
     *
     *  number of character that user is allowed to enter
     *
     **/
    @public
    int max_length;
}

@property (nonatomic, assign)    UIEdgeInsets       edgeInsets;
@property (nonatomic, assign)    BOOL               focusable;

@property (nonatomic, assign)    int                max_length;
@property (nonatomic, copy)      NSString *         imageStretch;
@property (nonatomic, assign)    BOOL               checkEmpty;
@property (nonatomic, assign)    ExTextFieldType    type;
@property (nonatomic, copy)      NSString *         textError;
@property (nonatomic, assign)   id<ExTextFieldDelegate> mDelegate;
@property (nonatomic, assign)   CGSize padding; //paddding-left,right

// Support hilight
- (void)setBackgroundImage:(UIImage *)background forState:(UIControlState)state;
- (UIImage *)backgroundImageForState:(UIControlState)state;

- (void)remove_highlight;

-(BOOL) validate;
-(BOOL)validate_internal;
-(void) setTextError:(NSString*) _txtError 
             forType:(ExTextFieldType) _type;

-(void) addConstraintWithBlock:(ValidateBlock) block
               andErrorMessage:(NSString *) _msgError;

-(UIView *) iconError;

-(void) iconErrorTapBlock:(IconErrorTapBlock) _tapBlock;

-(void) changePattern:(NSString*) _pattern;

- (void) isShowNotify:(BOOL) _isShow;
- (void) showNotify;
- (void) hideNotify;
- (void)show_error;
@end





#define kFONT_DEFAULT_NAME    @"Arial"
#define kFONT_DEFAULT_SIZE    14

#define kICON_WARNING         @"error_icon.png"
#define kWARNING_VIEW_TAG     254
#define kNOTIFY_LABEL_TAG     255

#define kPlaceHolder_Pattern  @"#type[0-9]"

