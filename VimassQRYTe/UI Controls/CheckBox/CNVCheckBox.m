    //
    //  CNVCheckBox.m
    //  CNVTextField
    //
    //  Created by Chung NV on 2/25/13.
    //  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
    //

#import "CNVCheckBox.h"

//#define DEBUG_LAYER

#ifdef DEBUG_LAYER
#import <QuartzCore/QuartzCore.h>
#endif

#define kDefault_Font_Name @"Arial"
#define kDefault_Font_Size 13
#define kImage_Height 15  // 15% * width
#define kPadding_Left 0   // 5px

#define kIMAGE_WIDTH_DEFAULT 16
#define kDefault_Image_Checked [UIImage imageNamed:@"transfer_checked"]
#define kDefault_Image_Uncheck [UIImage imageNamed:@"transfer_unchecked"]


@implementation CNVCheckBox
{
    CheckBoxValueChanged    _blockValueChanged;
}
@synthesize checked            = _checked;
@synthesize lblText            = _lblText;
@synthesize imageCheckbox      = _imageCheckbox;
@synthesize imageUnchecked     = _imageUnchecked;
@synthesize imageChecked       = _imageChecked;
@synthesize delegate           = _delegate;


-(void) _drawSubViews
{
    UIImage *image;
    //image for state UnChecked = UIControlStateNormal
    image = [self imageForState:UIControlStateNormal];
    if (image)
        self.imageUnchecked = image;
    
    //image for state UnChecked = UIControlStateNormal
    image = [self imageForState:UIControlStateSelected];
    if (image)
        self.imageChecked = image;
    
    //add Icon view
    [self addIconView];
    // add UILabel
    [self setTitleCheckbox:self.titleLabel.text];
    
#ifdef DEBUG_LAYER
    self.layer.borderColor = [[UIColor blueColor] CGColor];
    self.layer.borderWidth = 2;
#endif
}

-(CGSize) getIconSize
{
    CGRect rect = self.frame;
    float iconWidth,iconHeight;
    CGSize iconSize = _imageChecked.size;
    
    iconHeight = iconSize.height > rect.size.height ? rect.size.height : iconSize.height;
    iconWidth = iconHeight * iconSize.width / iconSize.height;
    
    return CGSizeMake(iconWidth, iconHeight);
}

/*
 * add icon checkbox
 */
- (void)addIconView
{
    // add Image view
    UIImage *image;
    CGRect rect = self.frame;
    
//    float iconWidth,iconHeight;
    CGSize iconSize = [self getIconSize];
    
    CGRect frame = CGRectMake(0,
                              roundf((rect.size.height-iconSize.height)/2),
                              iconSize.width,
                              iconSize.height
                              );
    
    if (!_imageCheckbox)
    {
        image = _checked ? _imageChecked :_imageUnchecked;
        _imageCheckbox = [[UIImageView alloc] initWithImage:image];
        _imageCheckbox.frame = frame;
        _imageCheckbox.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:_imageCheckbox];
    }
    else
        _imageCheckbox.frame = frame;
}

-(void) setTitleCheckbox:(NSString *)_text
{
    if (!_text || [_text isEqualToString:@""])
        return;
    CGSize iconSize = [self getIconSize];
    int paddingLeft = kPadding_Left;
    CGRect txtFrame = CGRectMake(iconSize.width + paddingLeft,
                                 0,
                                 self.frame.size.width - iconSize.width - paddingLeft,
                                 self.frame.size.height
                                 );
    
    
    UILabel *lbl = self.titleLabel;
    UIFont *font;
    UIColor *color;
    if (lbl)
    {
        font = lbl.font;
        color = lbl.textColor;
        [lbl removeFromSuperview];
    }else
    {
        font = [UIFont fontWithName:kDefault_Font_Name size:kDefault_Font_Size];
        color = [UIColor blackColor];
    }
    
    
    
    if (_lblText)
    {
        _lblText.frame = txtFrame;
        _lblText.text  = _text;
    }else
    {
        _lblText = [[UILabel alloc] initWithFrame:txtFrame];
        _lblText.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        _lblText.backgroundColor = [UIColor clearColor];
        _lblText.textColor = color;
        [self addSubview:_lblText];
    }
    [self setText:_text forLabel:_lblText withFont:font];
}

-(void)setText:(NSString*) _txt forLabel:(UILabel*) label withFont:(UIFont*)font
{
    int fSize           = kDefault_Font_Size;
    NSString *fontName  = kDefault_Font_Name;
    if (font)
    {
        fSize = font.pointSize;
        fontName = font.fontName;
    }
    /*
     * mutil language
     * found '@' and get string with key in localizableString
     */
    NSString * text = [_txt localizableString];
    
    label.text = text;
    while (true)
    {
        UIFont *font = [UIFont fontWithName:fontName size:fSize];
        CGSize size = [text sizeWithFont:font];
        if (size.width > label.frame.size.width)
            fSize--;
        else
        {
            if (fSize > 0)
                label.font = font;
            break;
        }
    }
}

#pragma mark - SETTER(s)

-(void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [self setTitleCheckbox:title];
}
-(void)setImage:(UIImage *)image forState:(UIControlState)state
{
    if (state == UIControlStateNormal && image){
        self.imageUnchecked = image;
    }
    if (state == UIControlStateSelected && image){
        self.imageChecked = image;
    }
}
-(void)setImageChecked:(UIImage *)imageChecked
{
    if (imageChecked != _imageChecked)
    {
        [_imageChecked release];
        _imageChecked = [imageChecked retain];
    }
}
-(void)setImageUnchecked:(UIImage *)imageUnchecked
{
    if (imageUnchecked != _imageUnchecked)
    {
        [_imageUnchecked release];
        _imageUnchecked = [imageUnchecked retain];
    }
}

#pragma mark - Public Method
-(void)valueChanged:(CheckBoxValueChanged) valueChangedBlock
{
    if (valueChangedBlock)
        _blockValueChanged = [valueChangedBlock copy];
}

-(void)setChecked:(BOOL)checked
{
    if (checked != _checked)
    {
        _checked = checked;
        if (_imageCheckbox)
        {
            UIImage *image = _checked ? _imageChecked : _imageUnchecked;
            _imageCheckbox.image = image;
            CGRect r = _imageCheckbox.frame;
            r.size = [self getIconSize];
            _imageCheckbox.frame = r;
        }
    }
}

#pragma mark - SEL(s)
-(void)actionTouchUpInside:(id)sender
{
    self.checked = !_checked;
    if ([_delegate respondsToSelector:@selector(CNVCheckBoxValueChanged:)])
        [_delegate CNVCheckBoxValueChanged:self];
    
    if (_blockValueChanged)
        _blockValueChanged(self);
}

#pragma mark - Init - Inherit

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self _drawSubViews];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (!_lblText || !_imageCheckbox)
        return;
    
    [self addIconView];
    [self setTitleCheckbox:_lblText.text];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
        [self _init];
    
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
        [self _init];
    
    return self;
}
-(id)init
{
    if (self = [super init])
        [self _init];
    
    return self;
}

-(void) _init
{
    _checked = NO;
    _checked = self.reversesTitleShadowWhenHighlighted;
    self.reversesTitleShadowWhenHighlighted = NO;
    
    self.imageChecked = kDefault_Image_Checked;
    self.imageUnchecked = kDefault_Image_Uncheck;
    
    [self addTarget:self action:@selector(actionTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)dealloc
{
    if (_blockValueChanged)
        [_blockValueChanged release];
    
    if (_lblText)
        [_lblText release];
    
    if (_imageCheckbox)
        [_imageCheckbox release];
    
    if (_imageChecked)
        [_imageChecked release];
    
    if (_imageUnchecked)
        [_imageUnchecked release];
    
    [super dealloc];
}


@end
