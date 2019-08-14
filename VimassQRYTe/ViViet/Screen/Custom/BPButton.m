//
//  BPButton.m
//  test
//
//  Created by Thuong Ngo Ba on 7/22/12.
//  Copyright (c) 2012 CMC. All rights reserved.
//

#import "BPButton.h"
#import "Common.h"

@implementation BPButton
{
    CGRect _margin;
    BOOL _autoResizeWidth;
    BOOL _layouting;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect titleFrame = self.titleLabel.frame;
    CGRect selfFrame = self.frame;
    
    
    if (_margin.origin.x != 0 || _margin.size.width != 0)
    {
        titleFrame.origin.x = _margin.origin.x;
        titleFrame.size.width = selfFrame.size.width - _margin.origin.x - _margin.size.width;
    }
    
    if (!CGRectEqualToRect(self.titleLabel.frame, titleFrame))
        self.titleLabel.frame = titleFrame;
}

#pragma mark - Override

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    if (_autoResizeWidth)
    {
        CGRect selfFrame = self.frame;
        CGRect titleFrame = self.titleLabel.frame;
        
        NSString *str = [title localizableString];
        UIFont *font = self.titleLabel.font;
        
        CGSize textSize = [str sizeWithFont:font];
        titleFrame.size.width = textSize.width;
        selfFrame.size.width = titleFrame.size.width + _margin.origin.x + _margin.size.width;
        
        self.frame = selfFrame;
        [self layoutSubviews];
    }
    
    [super setTitle:title forState:state];
}

- (void)setMargin:(CGRect)margin
{
    _margin = margin;
    [self layoutIfNeeded];
}

- (void)setAutoResizeWidth:(BOOL)autoResizeWidth
{
    _autoResizeWidth = autoResizeWidth;
    [self layoutIfNeeded];
}
-(id) init
{
    if (self == [super init]) {
        [self setImage:@"blue-button-01"];
    }
    return self;
}
-(id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setImage:@"blue-button-01"];
    }
    return self;
}
-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        /*
         * @CHUNG edit
         */
        UIImage *img = [self backgroundImageForState:UIControlStateNormal];

        if (img == nil)
        {
            [self setImage:@"blue-button-01"];
        }
        else
        {
            NSInteger leftcap = floor(img.size.width / 2);
            NSInteger topcap = floor(img.size.height / 2);
            img = [img stretchableImageWithLeftCapWidth:leftcap topCapHeight:topcap];
            [self setBackgroundImage:img forState:UIControlStateNormal];
        }
        
        UIImage *highlighted_img = [self backgroundImageForState:UIControlStateHighlighted];
        if (highlighted_img != nil && highlighted_img.CGImage != img.CGImage)
        {
            NSInteger leftcap = floor(highlighted_img.size.width / 2);
            NSInteger topcap = floor(highlighted_img.size.height / 2);
            highlighted_img = [highlighted_img stretchableImageWithLeftCapWidth:leftcap topCapHeight:topcap];
            [self setBackgroundImage:highlighted_img forState:UIControlStateHighlighted];
        }
        
        UIImage *selected_img = [self backgroundImageForState:UIControlStateSelected];
        
        if (selected_img != nil && img.CGImage != selected_img.CGImage)
        {
            NSInteger leftcap = floor(selected_img.size.width / 2);
            NSInteger topcap = floor(selected_img.size.height / 2);
            selected_img = [selected_img stretchableImageWithLeftCapWidth:leftcap topCapHeight:topcap];
            [self setBackgroundImage:selected_img forState:UIControlStateSelected];
        }
        
        NSString *t = [self titleForState:UIControlStateNormal];
        
        if (t != nil && t.length > 0 && [t rangeOfString:@"@"].location == 0)
        {
            t = LocalizedString([t substringFromIndex:1]);
            self.titleLabel.text = t;
            [self setTitle:t forState:UIControlStateNormal];
        }
        
        if (self.autoresizingMask & UIViewAutoresizingFlexibleWidth)
            self.autoResizeWidth = YES;
    }
    return self;
}

-(void)setBackgroundImage:(UIImage *)img forState:(UIControlState)state
{
    @autoreleasepool
    {
        NSInteger leftcap = floor(img.size.width / 2);
        NSInteger topcap = floor(img.size.height / 2);
        img = [img stretchableImageWithLeftCapWidth:leftcap topCapHeight:topcap];
        [super setBackgroundImage:img forState:state];
    }
}

-(void)setImage:(NSString *)imageFile
{
    @autoreleasepool
    {
        UIImage *img = [UIImage imageNamed:imageFile];
        
        NSInteger leftcap = floor(img.size.width / 2);
        NSInteger topcap = floor(img.size.height / 2);
        img = [img stretchableImageWithLeftCapWidth:leftcap topCapHeight:topcap];
        [self setBackgroundImage:img forState:UIControlStateNormal];
    }
}

@synthesize margin = _margin;
@synthesize autoResizeWidth = _autoResizeWidth;

@end
