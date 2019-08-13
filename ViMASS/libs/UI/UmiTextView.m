//
//  UmiTextView.m
//  test_multilineedit
//
//  Created by Ngo Ba Thuong on 9/3/13.
//  Copyright (c) 2013 ViMASS. All rights reserved.
//

#import "UmiTextView.h"

@implementation UmiTextView

- (void)init_UmiTextView
{
    self.delegate = self;
    self.backgroundColor = [UIColor clearColor];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self update_textfield];
}
- (void)setTextfield:(UITextField *)tf
{
    textfield = tf;
    
    if (tf != nil)
    {
        self.textColor = textfield.textColor;
        self.font = textfield.font;
        
        textfield.textAlignment = NSTextAlignmentLeft;
        textfield.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        
        [self update_frame];
        
        //
        // Capture focus event
        //
        textfield.delegate = self;
    }
}
- (void)update_frame
{
    
    //
    // Align text same as text in the UITextfield
    //
    CGRect textrect = [textfield textRectForBounds:textfield.bounds];
    CGFloat padding_left = textrect.origin.x - 5;
    CGFloat padding_top = textrect.origin.y - 8;
    self.contentInset = UIEdgeInsetsMake(padding_top, padding_left, 0, 0);
    
    //
    // Resize the textview
    //
    CGRect newframe = self.frame;
    newframe.size.width = textfield.bounds.size.width - (textfield.bounds.size.width - textrect.size.width);
    newframe.size.height = textfield.bounds.size.height;
    
    self.frame = newframe;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    [self becomeFirstResponder];
    return NO;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    [self becomeFirstResponder];
}

- (void)update_textfield
{
    if (self.text.length == 0)
    {
        textfield.text = @"";
    }
    else
    {
        textfield.text = @" ";
    }
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self update_textfield];
}

- (void)textViewDidChange:(UITextView *)textView;
{
    [self update_textfield];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self init_UmiTextView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self init_UmiTextView];
    }
    return self;
}

- (void) setPlaceHolder:(NSString *)sPlace{
    if (textfield) {
        [textfield setPlaceholder:sPlace];
    }
}

@synthesize textfield = textfield;

@end
