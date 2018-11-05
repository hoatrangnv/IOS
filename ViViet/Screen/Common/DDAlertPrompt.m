#import "DDAlertPrompt.h"
#import <QuartzCore/QuartzCore.h>

@interface DDAlertPrompt ()

@property(nonatomic, retain) UITableView *tableView;
@property(nonatomic, retain) UITextField *plainTextField;
@property(nonatomic, retain) UITextField *secretTextField;

@end


@implementation DDAlertPrompt
{
    NSString *_acceptTitle;
    UIButton *_acceptButton;
    void (^_callback)(DDAlertPrompt *, int);
    BOOL (^_validate_callback)(DDAlertPrompt *alert);
    
    int _max_text_length, _max_subtext_length;
    DDAlertPromptType _dialog_type;
}

- (void)setValidateMethod:(BOOL (^)(DDAlertPrompt *alert))validate_callback;
{
    if (validate_callback)
        _validate_callback = [validate_callback copy];
}

+ (void)prompt:(NSString *)msg
          type:(DDAlertPromptType)type
        option:(void (^)(DDAlertPrompt *alert))option_callback
      callback:(void (^)(DDAlertPrompt *alert, int selected_button))callback;
{
    if (msg != nil && [msg rangeOfString:@"@"].location == 0)
        msg = LocalizedString([msg substringFromIndex:1]);
    
    int the_type = 0;
    switch (type)
    {
        case DDAlertPromptType_PlainText:
            the_type = DDAlertPrompt_USERNAME;
            break;
            
        case DDAlertPromptType_SecureText:
            the_type = DDAlertPrompt_PASSWORD;
            break;
            
        case DDAlertPromptType_Login:
            the_type = DDAlertPrompt_USERNAME_PASSWORD;
            break;
    }
    
    DDAlertPrompt *alert = [[[DDAlertPrompt alloc] initWithTitle:msg
                                                        delegate:self
                                               cancelButtonTitle:LocalizedString(@"Cancel")
                                                otherButtonTitle:LocalizedString(@"OK")
                                                         andType:the_type] autorelease];
//    alert->_dialog_type = type;
    
    if (callback)
        alert->_callback = [callback copy];
    if (option_callback)
    {
        option_callback (alert);
    }
    
    [alert show];
}

- (UITextField *)textview
{
    if (SYSTEM_VERSION_LESS_THAN(@"5.0"))
    {
        return self.plainTextField;
    }
    
    return [self textFieldAtIndex:0];
}

- (UITextField *)subtextview
{
    if((_dialog_type & DDAlertPrompt_USERNAME_PASSWORD) != DDAlertPromptType_Login)
    {
        return nil;
    }
    
    if (SYSTEM_VERSION_LESS_THAN(@"5.0"))
    {
        return self.secretTextField;
    }
    
    return [self textFieldAtIndex:1];
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView;
{
    if (_validate_callback == nil)
        return YES;
    
    return _validate_callback (self);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if (_max_text_length > 0 && textField == self.textview)
    {
        NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if (str.length <= _max_text_length)
            return YES;
        
        if (textField.text.length == _max_text_length)
            return NO;
        
        return YES;
    }
    
    if (_max_subtext_length > 0 && textField == self.subtextview)
    {
        NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if (str.length <= _max_subtext_length)
            return YES;
        
        if (textField.text.length == _max_subtext_length)
            return NO;
        
        return YES;
    }
    
    return YES;
}

- (void)setMax_text_length:(int)max_text_length
{
    _max_text_length = max_text_length;
}

- (void)setMax_subtext_length:(int)max_subtext_length
{
    _max_subtext_length = max_subtext_length;
}

- (void)DDAlertPrompt_Validate
{
    BOOL enable = YES;
    if (secretTextField_)
    {
        NSString *txt = [secretTextField_.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (txt == nil || txt.length == 0)
        {
            enable = NO;
        }
    }
    if (plainTextField_)
    {
        NSString *txt = [plainTextField_.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (txt == nil || txt.length == 0)
        {
            enable = NO;
        }
    };
    self.acceptButton.enabled = enable;
}

#pragma mark - Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self)
    {
        if (_callback)
            _callback (self, (int)buttonIndex);
    }
}

#pragma mark - Views

- (void)initialize_DDAlertPrompt
{
    self.delegate = self;
    
    if(_dialog_type == DDAlertPrompt_USERNAME_PASSWORD)
    {
        self.textview.delegate = self;
        self.subtextview.delegate = self;
    }
    else
    {
        self.textview.delegate = self;
    }
}
//
//- (id)initWithMessage:(NSString*)msg cancelButton:(NSString *)cancelBtnTitle otherButtonTitle:(NSString *)otherBtnTitle type:(int)type_ callback:(void (^)(DDAlertPrompt *, int))callback
//{
//    self = [self initWithTitle:msg delegate:self cancelButtonTitle:cancelBtnTitle otherButtonTitle:otherBtnTitle andType:type_];
//    
//    _callback = [callback copy];
//    return self;
//}

- (id)initWithTitle:(NSString *)title delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)acceptTitle andType:(int)_type
{
    
    if (acceptTitle)
        _acceptTitle = [acceptTitle copy];

    NSString * mess = nil;
    self.type = _type;
    _dialog_type = _type;
    
    if (SYSTEM_VERSION_LESS_THAN(@"5.0"))
    {
        mess = @"\n";
        if (self.type ==  DDAlertPrompt_USERNAME_PASSWORD)
        {
            mess = @"\n\n\n";
        }
    }
    else
    {
        mess = @"";
    }
    
	if ((self = [super initWithTitle:title message:mess delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:acceptTitle, nil]))
    {
        if (self.type ==  DDAlertPrompt_USERNAME)
        {
            if (SYSTEM_VERSION_LESS_THAN(@"5.0"))
            {
                [self addSubview:self.plainTextField];
                [plainTextField_ becomeFirstResponder];
            }
            else
            {
                self.alertViewStyle = UIAlertViewStylePlainTextInput;
            }
        }
        
        if (self.type ==  DDAlertPrompt_USERNAME_PASSWORD)
        {
            if (SYSTEM_VERSION_LESS_THAN(@"5.0"))
            {
                [self addSubview:self.plainTextField];
                [plainTextField_ becomeFirstResponder];
                
                [self addSubview:self.secretTextField];
            }
            else
            {
                self.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
            }
        }
        
        if (self.type == DDAlertPrompt_PASSWORD)
        {
            if (SYSTEM_VERSION_LESS_THAN(@"5.0"))
            {
                [self addSubview:self.secretTextField];
                if (self.type == DDAlertPrompt_PASSWORD)
                    [secretTextField_ becomeFirstResponder];
            }
            else
            {
                self.alertViewStyle = UIAlertViewStyleSecureTextInput;
                
                UITextField *tf = [self textFieldAtIndex:0];
                tf.delegate = self;
                NSLog(@"%@", tf);
            }
        }
        
        self.acceptButton.enabled = NO;
        
        [self initialize_DDAlertPrompt];
	}
	return self;
}

- (NSString *)text
{
    if (SYSTEM_VERSION_LESS_THAN(@"5.0"))
    {
        return self.plainTextField.text;
    }
    
    return [self textFieldAtIndex:0].text;
}

#pragma mark layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
	// We assume keyboard is on.
    UILabel *lbTitle = nil;
    
    for (UIView *v in self.subviews)
    {
        if ([v isKindOfClass:[UILabel class]])
        {
            UILabel *lb = (UILabel *)v;
            NSString *txt = lb.text;
            if ([txt rangeOfString:@"\n"].location == 0)
                continue;
            
            lbTitle = lb;
            break;
        }
    }
    // Find best position to place our textfield
    // The position should be between lower edge of lbtitle and button top edge.
    CGFloat h = 30;
    if (plainTextField_ != nil && secretTextField_ != nil)
    {
        h = 65;
    }
    
    CGRect cancelRect = [self convertRect:self.acceptButton.frame fromView:self.acceptButton.superview];
    CGFloat delta = cancelRect.origin.y - lbTitle.frame.size.height - lbTitle.frame.origin.y - h;
    
    CGFloat startPoint = lbTitle.frame.origin.y + lbTitle.frame.size.height + delta/2;
    CGRect r = CGRectMake(12.0f, startPoint, 260.0f, 30);
    if (plainTextField_)
    {
        plainTextField_.frame = r;
        r.origin.y += 35;
    }
    if (secretTextField_)
    {
        secretTextField_.frame = r;
    }
}

#pragma mark Accessors

- (UIButton *)acceptButton
{
    if (_acceptButton == nil)
    {
        for (UIView *v in self.subviews)
        {
            if ([v isKindOfClass:[UIButton class]])
            {
                NSString *t = [((UIButton *)v) titleForState:UIControlStateNormal];
                if ([t compare:_acceptTitle] == NSOrderedSame)
                {
                    _acceptButton = (UIButton *)v;
                    break;
                }
            }
        }
    }
    return _acceptButton;
}

- (UITextField *)plainTextField {

	if (!plainTextField_)
    {
		plainTextField_ = [[UITextField alloc] initWithFrame:CGRectMake(5.0f, 0.0f, 255.0f, 28.0f)];
		plainTextField_.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		plainTextField_.clearButtonMode = UITextFieldViewModeWhileEditing;
		plainTextField_.placeholder = @"";
        plainTextField_.borderStyle = UITextBorderStyleRoundedRect;
        plainTextField_.secureTextEntry = NO;
        plainTextField_.tag = 10;
        
        [plainTextField_ addTarget:self action:@selector(DDAlertPrompt_Validate) forControlEvents:UIControlEventEditingChanged];
	}
	return plainTextField_;
}

- (UITextField *)secretTextField
{
	
	if (!secretTextField_) {
		secretTextField_ = [[UITextField alloc] initWithFrame:CGRectMake(5.0f, 0.0f, 255.0f, 28.0f)];
		secretTextField_.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		secretTextField_.secureTextEntry = YES;
        secretTextField_.borderStyle = UITextBorderStyleRoundedRect;
		secretTextField_.clearButtonMode = UITextFieldViewModeWhileEditing;
		secretTextField_.placeholder = @"";
        secretTextField_.tag = 11;
        secretTextField_.keyboardType = UIKeyboardTypeDefault;
        
        [secretTextField_ addTarget:self action:@selector(DDAlertPrompt_Validate) forControlEvents:UIControlEventEditingChanged];
	}
	return secretTextField_;
}

//+ (void)prompt:(NSString *)msg
//       secured:(int)secured
//      callback:(void (^)(DDAlertPrompt *alert, int selectedBtn))callback;
//{
//    [DDAlertPrompt prompt:msg secured:secured keyboard:UIKeyboardTypeDefault callback:callback];
//}

+ (void)prompt:(NSString *)msg
      secured:(int)secured
     keyboard:(UIKeyboardType)kb_type
     callback:(void (^)(DDAlertPrompt *, int))callback
{
    if (msg != nil && [msg rangeOfString:@"@"].location == 0)
        msg = LocalizedString([msg substringFromIndex:1]);
    
    DDAlertPrompt *alert = [[[DDAlertPrompt alloc] initWithMessage:msg
                                                      cancelButton:LocalizedString(@"Cancel")
                                                  otherButtonTitle:LocalizedString(@"OK")
                                                              type:secured ? DDAlertPrompt_PASSWORD : DDAlertPrompt_USERNAME
                                                          callback:callback] autorelease];
    if (secured)
        alert.secretTextField.keyboardType = kb_type;
    else
        alert.plainTextField.keyboardType = kb_type;
    
    [alert show];
}

- (void)dealloc
{
    [_callback release];
    [_acceptTitle release];
    
    [super dealloc];
}


@synthesize type;
@synthesize plainTextField = plainTextField_;
@synthesize secretTextField = secretTextField_;
@synthesize acceptButton = _acceptButton;

@end
