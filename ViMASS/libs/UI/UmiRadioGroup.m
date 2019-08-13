//
//  UmiRadioGroup.m
//  test_radios
//
//  Created by Ngo Ba Thuong on 8/17/13.
//  Copyright (c) 2013 ViMASS. All rights reserved.
//

#import "UmiRadioGroup.h"

@implementation UmiRadioGroup

- (void)setEnabled:(BOOL)state
{
    if (state == enabled)
        return;
    
    enabled = state;
    
    for (int i = 0; i < radios.count; i++)
    {
        UIButton *b = [radios objectAtIndex:i];
        b.userInteractionEnabled = enabled;
    }
}

- (void)setSelectedIndex:(int)idx
{
    if (idx < 0 || idx >= radios.count)
        return;
    
    [self on_change_radios:[radios objectAtIndex:idx]];
}

- (void)setContent_mode:(int)mode
{
    self->content_mode = mode;
    
    [self adjust_views];
}

- (void)adjust_button_width:(UIButton *)btn
{
    CGSize fitSize = [btn sizeThatFits:CGSizeMake(1000, 1000)];
    
    CGRect r = btn.frame;
    r.size.width = fitSize.width;
    btn.frame = r;
    
//    NSString *txt = btn.titleLabel.text;
//    
//    CGSize txt_size = [txt sizeWithFont:btn.titleLabel.font];
//    
//    [btn sizeToFit];
//    
//    CGFloat w = btn.frame.size.width + txt_size.width - btn.titleLabel.frame.size.width;
//    
//    CGRect r = btn.frame;
//    r.size.width = w;
//    btn.frame = r;
}

- (void)adjust_views
{
    if (content_mode <= 0)
        return;
    
    UIButton *first = [radios objectAtIndex:0];
    UIButton *last = [radios objectAtIndex:radios.count - 1];
    
    CGFloat right_margin = last.frame.origin.x + last.bounds.size.width;
    
    CGFloat left_margin = first.frame.origin.x;
    
    CGFloat available_width = right_margin - left_margin;
    CGFloat total_width = 0;
    
    CGFloat x = first.frame.origin.x;
    CGFloat y = first.frame.origin.y;
    CGRect r;
    
    for (int i = 0; i < radios.count; i++)
    {
        UIButton *btn = [radios objectAtIndex:i];
        [self adjust_button_width:btn];
        
        total_width += btn.bounds.size.width;
    }
    
    
    if (content_mode == UmiRadioGroup_ContentModeLeft)
    {
        for (int i = 0; i < radios.count; i++)
        {
            UIButton *btn = [radios objectAtIndex:i];
            
            btn = [radios objectAtIndex:i];
            
            r = btn.frame;
            r.origin.x = x;
            r.origin.y = y;
            btn.frame = r;
            x = btn.frame.origin.x + btn.frame.size.width + button_padding;
        }
    }
    else if (content_mode == UmiRadioGroup_ContentModeJustify && radios.count >= 2)
    {
        if (available_width < total_width)
        {
            CGFloat w = floorf(available_width / radios.count);
            for (int i = 0; i < radios.count; i++)
            {
                UIButton *btn = [radios objectAtIndex:i];
                CGRect r = btn.frame;
                r.size.width = w;
                r.origin.x = x;
                r.origin.y = y;
                btn.frame = r;
                
                x += r.size.width;
            }
        }
        else
        {
            CGFloat padding = (available_width - total_width) / (radios.count -1);
            padding = roundf(padding);
            
            for (int i = 0; i < radios.count; i++)
            {
                UIButton *btn = [radios objectAtIndex:i];
                r = btn.frame;
                r.origin.x = x;
                r.origin.y = y;
                btn.frame = r;
                x = btn.frame.origin.x + btn.bounds.size.width + padding;
            }
        }
    }
}

- (void)awakeFromNib
{
    for (int i = 0; i < radios.count; i++)
    {
        UIButton *btn = [radios objectAtIndex:i];
        
        [btn addTarget:self action:@selector(on_change_radios:) forControlEvents:UIControlEventTouchUpInside];
    };

    [self adjust_views];
}

- (void)on_change_radios:(UIButton *)btn
{
    if (selectedIndex >= 0 && btn.selected == YES)
        return;
    
    for (int i = 0; i < radios.count; i++)
    {
        UIButton *b = [radios objectAtIndex:i];
        if (btn == b)
        {
            selectedIndex = i;
            b.selected = YES;
            continue;
        }
        b.selected = NO;
    };
    
    if ([delegate respondsToSelector:@selector(UmiRadioGroup:did_select_item:)])
    {
        [delegate UmiRadioGroup:self did_select_item:selectedIndex];
    }
}

- (id)init
{
    if (self = [super init])
    {
        button_padding = 5;
        content_mode = 0;
    }
    return self;
}

- (void)dealloc
{
    self.radios = nil;
    [super dealloc];
}

@synthesize content_mode = content_mode;
@synthesize button_padding = button_padding;
@synthesize delegate = delegate;
@synthesize selectedIndex = selectedIndex;
@synthesize enabled = enabled;
@synthesize radios = radios;

@end
