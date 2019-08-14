

#import <UIKit/UIKit.h>

enum
{
    DDAlertPrompt_USERNAME_PASSWORD = 3,
    DDAlertPrompt_USERNAME = 1,
    DDAlertPrompt_PASSWORD = 2
};

typedef enum
{
    DDAlertPromptType_Login = 3,
    DDAlertPromptType_PlainText = 1,
    DDAlertPromptType_SecureText = 2
    
} DDAlertPromptType;

@interface DDAlertPrompt : UIAlertView <UIAlertViewDelegate, UITextFieldDelegate>
{
	UITextField *plainTextField_;
	UITextField *secretTextField_;
}
//
// Get first text input
//
@property(nonatomic, readonly) NSString *text;
@property(nonatomic, readonly) UITextField *textview;
@property(nonatomic, assign) int max_text_length;
//
// Get second text input
//
@property(nonatomic, readonly) NSString *subtext;
@property(nonatomic, readonly) UITextField *subtextview;
@property(nonatomic, assign) int max_subtext_length;

- (id)initWithTitle:(NSString *)title
           delegate:(id)delegate
  cancelButtonTitle:(NSString *)cancelButtonTitle
   otherButtonTitle:(NSString *)otherButtonTitles
            andType:(int) _type;

+ (void)prompt:(NSString *)msg
          type:(DDAlertPromptType)type
        option:(void (^)(DDAlertPrompt *alert))option_callback
      callback:(void (^)(DDAlertPrompt *alert, int selected_button))callback;


- (void)setValidateMethod:(BOOL (^)(DDAlertPrompt *alert))validate_callback;

#warning Tat ca cac ham duoi day se bi loai bo o version sau

@property(nonatomic, assign) int type;
@property (nonatomic, assign) UIButton *acceptButton;

//- (id)initWithMessage:(NSString*)msg
//         cancelButton:(NSString *)cancelBtnTitle
//     otherButtonTitle:(NSString *)otherBtnTitle
//                 type:(int)type
//             callback:(void (^)(DDAlertPrompt *, int))callback;

//+ (void)prompt:(NSString *)msg
//       secured:(int)secured
//      callback:(void (^)(DDAlertPrompt *alert, int selectedBtn))callback;

+ (void)prompt:(NSString *)msg
       secured:(int)secured
      keyboard:(UIKeyboardType) keyboardType
      callback:(void (^)(DDAlertPrompt *alert, int selectedBtn))callback;




@end
