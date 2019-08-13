//
//  BPRoundTextField.m
//  Best Player iOS App
//
//  Created by Thuong Ngo Ba on 7/18/12.
//  Copyright (c) 2012 CMC. All rights reserved.
//

#import "BPRoundTextField.h"



@implementation BPRoundTextField
{
    NSInteger leftcap, topcap, leftMargin;
}

@synthesize image, icon;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initialize];
    }
    return self;
}

-(void)dealloc
{
    if (image)
        [image release];
    if (self.icon)
        [icon release];
    
    [super dealloc];
}

-(void)initialize
{
    if (!self.image)
    {
        self.image = @"rounded_textfield.png";
    }
    
    self.borderStyle = UITextBorderStyleNone;
    
    @autoreleasepool
    {
        UIImage *img = [UIImage imageNamed:self.image];
        if (img)
        {
            leftcap = ceil(img.size.width / 2);
            topcap = ceil(img.size.height / 2);
        }
        img = [img stretchableImageWithLeftCapWidth:leftcap topCapHeight:topcap];
//        UIImageView *v = [[[UIImageView alloc] initWithImage:img] autorelease];
//        [v setFrame:self.bounds];
//        [self addSubview:v];
        self.background = img;
        
        // Create icon if icon is not null
        if (self.icon)
        {
            img = [UIImage imageNamed:self.icon];
            if (img)
            {
                UIImageView *v = [[[UIImageView alloc] initWithImage:img] autorelease];
                if (v)
                {
                    // Compute frame for the image by scaling the image vertically.
                    CGFloat w = self.bounds.size.height * img.size.width / img.size.height;
                    leftMargin = round(w);
                    [v setFrame: CGRectMake(0, 0, w, self.bounds.size.height)];
                    [self addSubview:v];
                    [self bringSubviewToFront:self.textInputView];
                }
            }
        }        
        [self bringSubviewToFront:self.textInputView];        
    }
}

#pragma mark - Override methods of UITextField to settext start at desired position

- (CGRect)textRectForBounds:(CGRect)bounds
{
    bounds.origin.x += leftcap > leftMargin ? leftcap : leftMargin;
    bounds.size.width -= bounds.origin.x + leftcap;
    return bounds;
}
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return [self textRectForBounds:bounds];
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    bounds.size.width = leftcap > leftMargin ? leftcap : leftMargin;
    return bounds;
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds
{
    bounds.size.width = leftcap;
    return bounds;
}

@end
