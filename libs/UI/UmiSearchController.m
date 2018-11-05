//
//  UmiSearchController.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 11/1/13.
//
//

#import "UmiSearchController.h"

@implementation UmiSearchController
{
    UITextField *_textfield;
    UIButton *_button;
    UIView *_bar;
    UIView *_bg_view;
}

- (CGFloat)animation_time
{
    return 0.35;
}

- (void)dismiss:(BOOL)animate
{
    [_textfield resignFirstResponder];
    if (animate == NO)
        [_bg_view removeFromSuperview];
    else
    {
        [UIView animateWithDuration:[self animation_time] animations:^
        {
            _bg_view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
            
        } completion:^(BOOL finished)
        {
            [_bg_view removeFromSuperview];
        }];
    }
}

- (void)add_background_in_view:(UIView *)view
{
    if (view == nil)
        view = _bar.window;
    
    CGRect r = _bar.frame;
    
    r = [_bar.superview convertRect:r toView:_bar.window];
    r.origin.x = 0;
    r.origin.y += r.size.height;
    r.size.height = _bar.window.frame.size.height - r.origin.y;
    r.size.width = view.bounds.size.width;
    
    r = [_bar.window convertRect:r toView:view];
    
    if (_bg_view == nil)
    {
        _bg_view = [[UIView alloc] initWithFrame:r];
        UITapGestureRecognizer *ges = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(did_tap_background:)] autorelease];
        [_bg_view addGestureRecognizer:ges];
        
        _bg_view.userInteractionEnabled = YES;
    }
    
    _bg_view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    _bg_view.frame = r;
    [view addSubview:_bg_view];
}

- (void)remove_background
{
    [_bg_view removeFromSuperview];
}

- (void)did_tap_background:(UIGestureRecognizer *)gesture
{
    [self dismiss:YES];
}

- (void)did_change_search_key
{
    if (self.table != nil)
    {
        [_bg_view removeFromSuperview];
    }
    return;
    if ([self.delegate respondsToSelector:@selector(UmiSearchController:text_change:)])
    {
        [self.delegate UmiSearchController:self text_change:_textfield.text];
        if (self.table != nil)
        {
            [_bg_view removeFromSuperview];
        }
    }
}

- (void)setTextfield:(UITextField *)tf
{
    _textfield = tf;
    _textfield.delegate = self;
    
    [_textfield addTarget:self action:@selector(did_change_search_key) forControlEvents:UIControlEventEditingChanged];
    
    if (_bar == nil)
    {
        _bar = tf;
    }
}

- (void)setButton:(UIButton *)btn
{
    _button = btn;
    [_button addTarget:self action:@selector(did_select_search_button) forControlEvents:UIControlEventTouchUpInside];
}

- (void)did_select_search_button
{
    [self textFieldShouldReturn:self.textfield];
}

#pragma mark - Textfield delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    [self add_background_in_view:nil];
    
    [UIView animateWithDuration:[self animation_time] animations:^
    {
        _bg_view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
        UIEdgeInsets edge = self.table.contentInset;
        edge.bottom = 214;
        self.table.contentInset = edge;
    } completion:^(BOOL finished) {
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    [self dismiss:NO];
    
    UIEdgeInsets edge = self.table.contentInset;
    edge.bottom = 0;
    self.table.contentInset = edge;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    if ([self.delegate respondsToSelector:@selector(UmiSearchController:search:)])
    {
        [self.delegate UmiSearchController:self search:_textfield.text];
    }
    
    UIEdgeInsets edge = self.table.contentInset;
    edge.bottom = 0;
    self.table.contentInset = edge;
    
    [self dismiss:NO];
    return YES;
}

- (void)dealloc
{
    [_bg_view release];
    [super dealloc];
}

@synthesize textfield = _textfield;
@synthesize button = _button;
@synthesize bar = _bar;

@end
