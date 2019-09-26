//
//  ExTextField.m
//  ExTextField
//
//  Created by Chung NV on 2/25/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//
#define kTEXT_FIELDS_BACKGOUND_CUSTOM @"text-field-bg"
#define kTEXT_FIELDS_BACKGOUND_CUSTOM_SELECTED @"text-field-bg-selected"

#import "ExTextField.h"
#import "Common.h"
#import "UIView+EmphasizeShaking.h"
#import "Alert+Block.h"
#import <objc/runtime.h>
/**
 *
 * @author: Ngo Ba Thuong
 *
 * @description: class này dùng để walkaround lỗi trên iOS 5.1(???) nếu để textfield delegate là self
 * sẽ dẫn đến crash không rõ nguyên nhân.
 *
 **/
@interface UITextFieldDelegateImpl : NSObject <UITextFieldDelegate>
{
    ExTextField *txtfield;
}
-(id)initWithTextField:(UITextField *)txtfield;

@end

@implementation UITextFieldDelegateImpl

-(id)initWithTextField:(ExTextField *)tf;
{
    if (self = [super init])
    {
        self->txtfield = tf;
        if (@available(iOS 13, *)) {
            Ivar ivar =  class_getInstanceVariable([UITextField class], "_placeholderLabel");
            UILabel *placeholderLabel = object_getIvar(self->txtfield, ivar);

            placeholderLabel.textColor = [UIColor lightGrayColor];
        }
//        [self->txtfield.inputAccessoryView setHidden:YES];
//        [self->txtfield.inputAccessoryView setUserInteractionEnabled:NO];
    }
    return self;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return [txtfield textFieldShouldBeginEditing:textField];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    return [txtfield textFieldDidBeginEditing:textField];
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return [txtfield textFieldShouldEndEditing:textField];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    return [txtfield textFieldDidEndEditing:textField];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [txtfield textField:textField shouldChangeCharactersInRange:range replacementString:string];
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return [txtfield textFieldShouldClear:textField];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [txtfield textFieldShouldReturn:textField];
}

@end


@implementation ExTextField
{
    BOOL isShowNotify;
    IconErrorTapBlock _tapBlock;
    
    id<UITextFieldDelegate> true_delegate;
    UITextFieldDelegateImpl *proxy_delegate;
    BOOL highlight_background;
    
    NSMutableDictionary *background_images;
}

@synthesize checkEmpty      = _checkEmpty;
@synthesize type            = _type;
@synthesize imageStretch    = _imageStretch;
@synthesize textError       = _textError;
@synthesize focusable       = focusable;


#pragma mark - Public Method

-(void)addConstraintWithBlock:(ValidateBlock)block
              andErrorMessage:(NSString *)msgError
{
    if (!validateBlocks)
        validateBlocks = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    [validateBlocks setObject:msgError forKey:[block copy]];
}
- (BOOL)validate
{
    BOOL r = [self validate_internal];
    [self showIconError:!r];
    if (r == NO)
        [self shakingHorizontalInDuration:0.5 withAmplitude:10 andRepeat:3];
    
    return r;
}
- (NSString *)text
{
    NSString *s = [super text];
    if (s == nil)
        s = @"";
    return s;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self layoutSubviews];
}

- (BOOL)validate_internal
{
    if (notifyView && isShowNotify)
        [notifyView removeFromSuperview];
    self.iconError.hidden = YES;
    self.rightView.hidden = YES;
    
    if (_type == ExTextFieldTypeEmpty)
    {
        if ([Common isEmptyString:self.text])
        {
            self.textError = [textErrors objectAtIndex:ExTextFieldTypeEmpty];
            return NO;
        }
        else
            return YES;
    }
    
    if (_checkEmpty == YES)
    {
        if ([Common isEmptyString:self.text])
        {
            self.textError = [textErrors objectAtIndex:ExTextFieldTypeEmpty];
            return NO;
        }
    }
    else if ([Common isEmptyString:self.text] == YES)
        return YES;
    
    // Predefined tytpe
    if (_type >= 0)
    {
        NSString *pattern = [patterns objectAtIndex:_type];
        NSError *error = nil;
        NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern
                                                                          options:NSRegularExpressionCaseInsensitive
                                                                            error:&error];
        NSString *s = self.text;
        NSArray *arr = [regex matchesInString:s
                                      options:0
                                        range:NSMakeRange(0,s.length)];
        [regex release];
        
        if (arr == nil || error != nil || arr.count != 1)
        {
            self.textError = [textErrors objectAtIndex:_type];
            return NO;
        }
        
        if(_type == [patterns indexOfObject:kPATTERN_CARD_NUMBER])
        {
            if(![Common kiemTraTheDaDuocKetNoiDeChuyenTien:self.text])
            {
                self.textError = [@"thong_bao_the_khong_thuoc_24_ngan_hang_lien_ket" localizableString];
                return NO;
            }
        }
        else if(_type == [patterns indexOfObject:kPATTERN_MONEY])
        {
            double fSoTien = [[[self.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
            if(fSoTien < 10000)
            {
                self.textError = [@"thong_bao_so_tien_mot_lan_rut" localizableString];
                return NO;                
            }
        }
    }
    
    if (validateBlocks && validateBlocks.count > 0)
    {
        for (ValidateBlock block in validateBlocks)
        {
            BOOL validate = block(self);
            if (validate == NO)
            {
                UIView *iconError = [self iconError];
                iconError.hidden = NO;
                NSString *messError = [validateBlocks objectForKey:block];
                if (messError)
                    self.textError = messError;
                return NO;
            }
        }
    }
    return YES;
}

-(void)setTextError:(NSString *)txtError forType:(ExTextFieldType)type_
{
    if (type_ >= TOTAL_TYPE)
        return;
    
    if (textErrors && textErrors.count > type_)
        [textErrors replaceObjectAtIndex:type_ withObject:txtError];
    
    self.textError = txtError;
    /*
     * if type_ != EMPTY => set TYPE = _type
     * if type_ == EMPTY => check Empty = YES
     */
    if (type_ != ExTextFieldTypeEmpty)
        _type = type_;
    else
        _checkEmpty = YES;
}

-(void)iconErrorTapBlock:(IconErrorTapBlock) _tapBlock_
{
    if (_tapBlock_ == nil)
        return;
    
    _tapBlock = [_tapBlock_ copy];
}

-(UIView *) iconError
{
    UIButton *btIconError = (UIButton*)[self viewWithTag:kWARNING_VIEW_TAG];
    if (!btIconError)
    {
        UIButton *btIconError = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                           0,
                                                                           30,
                                                                           self.frame.size.height)];
        [btIconError setImage:[UIImage imageNamed:kICON_WARNING]
                     forState:UIControlStateNormal];
        [btIconError addTarget:self
                        action:@selector(btIconErrorTapped:)
              forControlEvents:UIControlEventTouchUpInside];
        
        self.rightView = btIconError;
        btIconError.tag = kWARNING_VIEW_TAG;
        self.rightViewMode = UITextFieldViewModeAlways;
        [self bringSubviewToFront:btIconError];
        [btIconError release];
    }
    
    return btIconError;
}

-(void)isShowNotify:(BOOL)_isShow
{
    isShowNotify = _isShow;
}
-(void)showNotify
{
    
}
- (void)show_error;
{
    [UIAlertView alert:self.textError withTitle:nil block:nil];
}


-(void)hideNotify
{
    
}
-(void)changePattern:(NSString *)_pattern
{
    if (_pattern == nil)
        return;
    
    [patterns replaceObjectAtIndex:_type withObject:_pattern];
}
-(void)setImageStretch:(NSString *)imageStretch
{
    if (imageStretch != nil && [Common isEmptyString:imageStretch] == NO)
    {
        [_imageStretch release];
        _imageStretch = [imageStretch copy];
        self.borderStyle = UITextBorderStyleNone;
        self.background = [Common stretchImage:imageStretch];
    }
}

-(CGRect)textRectForBounds:(CGRect)bounds
{
    CGFloat right_view_width = self.rightView.hidden == YES ? 0 : self.rightView.bounds.size.width;
    
    CGRect r = CGRectMake(bounds.origin.x + self.edgeInsets.left,
                      bounds.origin.y + self.edgeInsets.top,
                      bounds.size.width - self.edgeInsets.left - self.edgeInsets.right - right_view_width,
                      bounds.size.height - self.edgeInsets.bottom - self.edgeInsets.top);
    return r;
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return [self textRectForBounds:bounds];
}
- (CGRect)placeholderRectForBounds:(CGRect)bounds;
{
    return [self textRectForBounds:bounds];
}
#pragma mark - Override Method

#pragma mark - SEL(s)
-(void)btIconErrorTapped:(id)sender
{
    if(_tapBlock)
        _tapBlock();
}

#pragma mark - Private Method
-(void)showIconError:(BOOL) isShown
{
    UIView *iconError = [self iconError];
    iconError.hidden = !isShown;
    self.rightView.hidden = !isShown;
}

-(void) showNotifyErrorOfType:(ExTextFieldType) type_
{
    
    self.textError = [textErrors objectAtIndex:type_];
    if (!isShowNotify)
        return;
    
    
    CGSize sizeError = CGSizeMake(self.frame.size.width,20);
    
    if (!notifyView)
    {
        CGRect frame_ = self.frame;
        frame_.origin.y += frame_.size.height - 10;
        frame_.size = sizeError;
        
        notifyView = [[UIImageView alloc] initWithFrame:frame_];
        notifyView.image = [UIImage imageNamed:@"bubble_text_bg.png"];
        notifyView.opaque = TRUE;
        notifyView.contentMode = UIViewContentModeScaleToFill;
        
        UITextView *txtView = [[UITextView alloc] init];
        txtView.editable = NO;
        txtView.tag = kNOTIFY_LABEL_TAG;
        txtView.text = _textError;
        txtView.backgroundColor = [UIColor clearColor];
        txtView.frame = CGRectMake(0,0, frame_.size.width, frame_.size.height);
        
        // size to fit => set again FRAME of TxtView anh notify
        CGSize size = txtView.contentSize;
        CGRect r = txtView.frame;
        r.size = size;
        txtView.frame = r;
        // set notify
        r = notifyView.frame;
        r.size.height += 40;
        r.origin.y = self.frame.origin.y - r.size.height + 10;
        notifyView.frame = r;
        
        UIFont *font = [UIFont fontWithName:kFONT_DEFAULT_NAME size:12];
        [txtView setFont:font];
        
        [notifyView addSubview:txtView];
        [txtView release];
    }
    else
        ((UILabel*)[notifyView viewWithTag:kNOTIFY_LABEL_TAG]).text = _textError;
    
    if ([self superview])
        [[self superview] addSubview:notifyView];
    
}
#pragma mark - Delegate injection

-(void)setDelegate:(id<UITextFieldDelegate>)dl
{
    true_delegate = dl;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([true_delegate respondsToSelector:@selector(textFieldShouldBeginEditing:)])
        return [true_delegate textFieldShouldBeginEditing:textField];
    
    return focusable;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    ExTextField *tf = (ExTextField *) textField;
//    if (highlight_background == YES)
//        [tf setImageStretch:kTEXT_FIELDS_BACKGOUND_CUSTOM_SELECTED];
    
    if ([self can_hilight])
    {
        if([background_images objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)UIControlStateHighlighted]] != nil)
            tf.background = [background_images objectForKey:[NSString stringWithFormat:@"%ld", (unsigned long)
                                                             UIControlStateHighlighted]];
        else
            [tf setImageStretch:kTEXT_FIELDS_BACKGOUND_CUSTOM_SELECTED];
    }
    
//
    if ([true_delegate respondsToSelector:@selector(textFieldDidBeginEditing:)])
        [true_delegate textFieldDidBeginEditing:textField];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([true_delegate respondsToSelector:@selector(textFieldShouldEndEditing:)])
        return [true_delegate textFieldShouldEndEditing:self];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    ExTextField *tf = (ExTextField *) textField;
//    if (highlight_background == YES)
    if ([self can_hilight])
    {
        if([background_images objectForKey:[NSString stringWithFormat:@"%ld", (unsigned long)UIControlStateHighlighted]] != nil)
            tf.background = [background_images objectForKey:[NSString stringWithFormat:@"%ld", (unsigned long)UIControlStateNormal]];
        else
            [tf setImageStretch:kTEXT_FIELDS_BACKGOUND_CUSTOM];
    }
    
//    if(self.checkEmpty == YES || self.type != ExTextFieldTypeNone)
//    {
//        BOOL check = [self validate_internal];
//        [self showIconError:!check];
//    }
    if ([true_delegate respondsToSelector:@selector(textFieldDidEndEditing:)])
        [true_delegate textFieldDidEndEditing:self];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (max_length > 0)
    {
        NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (str.length > max_length)
            return NO;
    }
        
    if ([true_delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)])
        return [true_delegate textField:self shouldChangeCharactersInRange:range replacementString:string];
    
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if ([true_delegate respondsToSelector:@selector(textFieldShouldClear:)])
        return [true_delegate textFieldShouldClear:self];
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([true_delegate respondsToSelector:@selector(textFieldShouldReturn:)])
        return [true_delegate textFieldShouldReturn:self];

    if(textField.returnKeyType == UIReturnKeyNext)
        [self focus_next_textfield];
    else if(textField.returnKeyType == UIReturnKeyDone || textField.returnKeyType == UIReturnKeyDefault || textField.returnKeyType == UIReturnKeySearch)
    {
        [self resignFirstResponder];
    }
    else if (textField.returnKeyType == UIReturnKeySearch)
    {
        if([self.mDelegate respondsToSelector:@selector(suKienXuLySearchCuaExTextField:)])
        {
            [self.mDelegate suKienXuLySearchCuaExTextField:textField];
        }
    }
    
    return NO;
}

- (void)focus_next_textfield
{
    NSMutableArray *a = [NSMutableArray new];
    
    for (UIView *v in self.superview.subviews)
    {
        if (v != self && [v respondsToSelector:@selector(canBecomeFirstResponder)] && [v canBecomeFirstResponder] == YES)
        {
            [a addObject:v];
        }
    }
    
    // Tim view o gan nhat sau view hien tai
    UIView *match_view = nil;
    CGFloat dmin = MAXFLOAT;
    
    for (UIView *v in a)
    {
        if (v.frame.origin.y < self.frame.origin.y)
            continue;
        
        CGFloat d = fabs(v.frame.origin.y - self.frame.origin.y - self.frame.size.height);
        if (d <= dmin)
        {
            dmin = d;
            match_view = v;
        }
    }
    if (match_view)
    {
        [self resignFirstResponder];

        [match_view becomeFirstResponder];
    }
    else
        [self.superview endEditing:YES];
    [a release];
}

#pragma mark - Override

//- (BOOL)canBecomeFirstResponder
//{
//    return focusable;
//}

#pragma mark - View hierarchy - Init

- (void)setBackgroundImage:(UIImage *)background forState:(UIControlState)state;
{
    if (background_images == nil)
    {
        background_images = [[NSMutableDictionary alloc] initWithCapacity:3];
    }
    
    if (background == nil)
    {
        [background_images removeObjectForKey:[NSString stringWithFormat:@"%ld", (unsigned long)state]];
    }
    else
    {
        [background_images setObject:background forKey:[NSString stringWithFormat:@"%ld", (unsigned long)state]];
    }
    if (state == UIControlStateNormal)
    {
        super.background = background;
    }
}

- (UIImage *)backgroundImageForState:(UIControlState)state;
{
    UIImage *img = [background_images objectForKey:[NSString stringWithFormat:@"%ld", (unsigned long)state]];
    return img;
}

- (void)remove_highlight;
{
    
}

- (BOOL)can_hilight
{
    UIImage *img = [background_images objectForKey:[NSString stringWithFormat:@"%ld", (unsigned long)UIControlStateHighlighted]];
    return img != nil;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    
    if (self.background == nil)
    {
        [self setBackgroundImage:[Common stretchImage:kTEXT_FIELDS_BACKGOUND_CUSTOM_SELECTED]
                        forState:UIControlStateHighlighted];
    }
    
    [self setBackgroundImage:[Common stretchImage:kTEXT_FIELDS_BACKGOUND_CUSTOM]
                    forState:UIControlStateNormal];
    self.borderStyle = UITextBorderStyleNone;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        if (self.background == nil)
        {
            [self setBackgroundImage:[Common stretchImage:kTEXT_FIELDS_BACKGOUND_CUSTOM_SELECTED]
                            forState:UIControlStateHighlighted];
        }
        
        [self setBackgroundImage:[Common stretchImage:kTEXT_FIELDS_BACKGOUND_CUSTOM]
                        forState:UIControlStateNormal];
        self.borderStyle = UITextBorderStyleNone;
        [self _init];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self _init];
    }
    return self;
}
- (id)init
{
    if (self = [super init])
        [self _init];
    
    return self;
}
- (void) _init
{
    self.edgeInsets = UIEdgeInsetsMake(0, 3, 3, 3);
    self.textAlignment = NSTextAlignmentLeft;
    
    focusable = YES;
    proxy_delegate = [[UITextFieldDelegateImpl alloc] initWithTextField:self];
    super.delegate = proxy_delegate;
    
    self.type = ExTextFieldTypeNone;
    self.checkEmpty = NO;
    
    textErrors = [[NSMutableArray alloc] initWithObjects:
                  kText_ERROR_EMPTY,
                  kText_ERROR_PHONE,
                  kText_ERROR_MONEY,
                  kText_ERROR_CONTENT,
                  kText_ERROR_MAIL,
                  kText_ERROR_TOKEN,
                  kText_ERROR_PASSWORD,
                  kText_ERROR_ID_CARD,
                  kText_ERROR_NAME,
                  kText_ERROR_DATE,
                  kText_ERROR_VITOKEN_PWD,
                  LocalizedString(kText_ERROR_URL),
                  kText_ERROR_BANK_ACCOUNT,
                  kText_ERROR_BANK_ACCOUNT,
                  kText_ERROR_BANK_ACCOUNT,
                  kText_ERROR_BANK_NUMBER,
                  kText_ERROR_CARD_NUMBER,
                  kText_ERROR_CARD_PAYMENT_NUMBER,
                  nil];
    
    patterns = [[NSMutableArray alloc] initWithObjects:
                kPATTERN_EMPTY,
                kPATTERN_PHONE,
                kPATTERN_MONEY,
                kPATTERN_CONTENT,
                kPATTERN_MAIL,
                kPATTERN_TOKEN,
                kPATTERN_PASSWORD,
                kPATTERN_ID_CARD,
                kPATTERN_NAME,
                kPATTERN_DATE,
                kPATTERN_VITOKEN_PASSWORD,
                kPARTERN_URL,
                kPATTERN_BANK_ACCOUNT,
                kPATTERN_CORP_CODE,
                kPATTERN_SUPPLIER_CODE,
                kPATTERN_BANK_NUMBER,
                kPATTERN_CARD_NUMBER,
                kPATTERN_CARD_PAYMENT_NUMBER,
                nil];
    
    __block ExTextField *wself = self;
    [self iconErrorTapBlock:^
    {
        [UIAlertView alert:wself.textError withTitle:nil block:^(UIAlertView *alert, int indexClicked)
        {
            [wself becomeFirstResponder];
        }];
    }];
}

-(void)dealloc
{
    if(background_images)
        [background_images release];
    if(validateBlocks)
        [validateBlocks release];
    if(proxy_delegate)
        [proxy_delegate release];
    
    if (textErrors)
        [textErrors release];
    
    if (patterns)
        [patterns release];
    
    if (notifyView)
        [notifyView release];
    if (_textError)
        [_textError release];
    [super dealloc];
}

@synthesize max_length = max_length;
@end
