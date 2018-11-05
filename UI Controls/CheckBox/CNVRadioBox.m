//
//  CNVRadioBox.m
//  CNVTextField
//
//  Created by Chung NV on 2/25/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "CNVRadioBox.h"

#define kDefault_Radio_Image_Checked [UIImage imageNamed:@"radio-selected.png"]
#define kDefault_Radio_Image_Uncheck [UIImage imageNamed:@"radio-unselected.png"]

@implementation CNVRadioBox
{
    RadioBoxBlock _blockValueChanged;
    int numberOfRadio;
    NSMutableArray *checkboxs;
    
    BOOL didInitialized;
}
@synthesize items               = _items;
@synthesize imageUnchecked      = _imageUnchecked;
@synthesize imageChecked        = _imageChecked;
@synthesize selectedRadioIndex  = _selectedRadioIndex;
@synthesize font                = _font;
@synthesize textColor           = _textColor;

- (void)setCheckedImage:(UIImage *)checkedImage uncheckedImage:(UIImage *)uncheckedImage
{
    self.imageChecked = checkedImage;
    self.imageUnchecked = uncheckedImage;
    
    for (int i=0; i< numberOfRadio; i++)
    {
        
        CNVCheckBox *checkbox = [checkboxs objectAtIndex:i];
        checkbox.imageChecked = _imageChecked;
        checkbox.imageUnchecked = _imageUnchecked;
        
        [checkbox setNeedsDisplay];
    }
}

-(void) _drawSubViews
{
    CGRect rect = self.frame;
    for (UIView *v in [self subviews])
        [v removeFromSuperview];
    
    if (checkboxs)
        [checkboxs removeAllObjects];
    else
        checkboxs = [[NSMutableArray alloc] init];
    
    int widthOfRadio = (int)rect.size.width / numberOfRadio;
    CGRect frame = CGRectMake(0,0, widthOfRadio,rect.size.height);
    int minSize = 1000;
    
    CGFloat ox = 0;
    
    for (int i=0; i<numberOfRadio; i++)
    {
        
        CGFloat width_i = [self widthForSegmentAtIndex:i];
        if (width_i == 0)
            width_i = widthOfRadio;
        
        frame.size.width = width_i;
        frame.origin.x = ox;
        ox +=width_i;
        
        CNVCheckBox *checkbox = [[CNVCheckBox alloc] initWithFrame:frame];
        checkbox.tag = i;
        checkbox.imageChecked = _imageChecked;
        checkbox.imageUnchecked = _imageUnchecked;
        [checkbox setTitleCheckbox:[_items objectAtIndex:i]];
        checkbox.delegate = self;
        
        checkbox.userInteractionEnabled = TRUE;
                
        if (self.selectedSegmentIndex == i)
        {
            checkbox.checked = YES;
            _selectedRadioIndex = i;
        }
        
        [self addSubview:checkbox];
        // find min font size
        if (minSize > checkbox.lblText.font.pointSize)
            minSize = checkbox.lblText.font.pointSize;
        
        [checkboxs addObject:checkbox];
        [checkbox release];
    }
    
    /* Set min font size + text color
     *
     */
    //    UIColor *txtColor = [self.backgroundColor copy];
    self.backgroundColor = [UIColor clearColor];
    
    for (CNVCheckBox* checkbox in checkboxs)
    {
        checkbox.lblText.textColor = _textColor;
        checkbox.lblText.font = _font;
    }
}

#pragma mark - Override Method

-(void)setTextColor:(UIColor *)textColor
{
    if (_textColor != textColor)
    {
        [_textColor release];
        _textColor = [textColor retain];
        for (CNVCheckBox* checkbox in checkboxs)
            checkbox.lblText.textColor = _textColor;
    }
}

-(void)setFont:(UIFont *)font
{
    if (_font != font)
    {
        [_font release];
        _font = [font retain];
        for (CNVCheckBox* checkbox in checkboxs)
            checkbox.lblText.font = _font;
    }
}

#pragma mark -Public Method
-(void)insertItemWithTitle:(NSString *)title atIndex:(NSUInteger)index
{
    if (!title)
        title = @"";
    if (index>=numberOfRadio)
        [_items addObject:title];
    else 
        [_items insertObject:title atIndex:index];
    
    numberOfRadio = (int)_items.count;
    [self drawRect:self.frame];
}

-(void)setSelectedAtIndex:(int)index
{
    if (index >= numberOfRadio) 
        return;
    
    for (CNVCheckBox *checkbox in checkboxs) 
        checkbox.checked = NO;
    
    CNVCheckBox *checkbox = [checkboxs objectAtIndex:index];
    checkbox.checked = YES;
    _selectedRadioIndex = index;
}

-(void)valueChanged:(RadioBoxBlock)block
{
    if (block)
        _blockValueChanged = [block copy];
}
#pragma mark - Delegate of Checkbox


-(void)CNVCheckBoxValueChanged:(CNVCheckBox *)_checkbox
{
    for (CNVCheckBox *checkbox in checkboxs)
        checkbox.checked = NO;

    _checkbox.checked = YES;
    int selected = (int)_checkbox.tag;
    
    if (selected != _selectedRadioIndex)
    {
        self.selectedSegmentIndex = selected;
        self.selectedRadioIndex   = selected;
        if (_blockValueChanged)
            _blockValueChanged(self);
    }
}

#pragma mark - Init - Inherited
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (!checkboxs || checkboxs.count > numberOfRadio)
        return;
    
    int widthOfRadio = (int)frame.size.width / numberOfRadio;
    CGRect f = CGRectMake(0,0, widthOfRadio,frame.size.height);
    for (int i=0; i<numberOfRadio; i++)
    {
        f.origin.x = i*widthOfRadio;
        CNVCheckBox *checkbox = [checkboxs objectAtIndex:i];
        checkbox.frame = f;
    }
}

-(void)didMoveToSuperview
{
    [super didMoveToSuperview];
    /*
     * FOR : initWithFrame | init | initWithItems
     */
    if (didInitialized == NO)
    {
        didInitialized = YES;
        [self _drawSubViews];
    }
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    if (didInitialized == NO)
    {
        didInitialized = YES;
        [self _drawSubViews];
    }
}
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
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
    {
        numberOfRadio = (int)self.numberOfSegments;
        [self _init];
    }
    return self;
}
-(id)initWithItems:(NSArray *)items
{
    if (self = [super init])
    {
        if (items)
        {
            [self setItems:[NSMutableArray arrayWithArray:items]];
            numberOfRadio = (int)items.count;
        }
        
        
        [self _init];
    }
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
    if(_items == nil)
    {
        self.items = [[NSMutableArray alloc] init];
        for (int i=0; i < numberOfRadio;i++)
        {
            NSString *item = [self titleForSegmentAtIndex:i];
            [_items addObject:item];
        }
    }
        
    
    
    self.imageChecked = kDefault_Radio_Image_Checked;
    self.imageUnchecked = kDefault_Radio_Image_Uncheck;
}

-(void)dealloc
{
    if (_items)
        [_items release];

    if (checkboxs)
        [checkboxs release];
    
    if (_imageChecked)
        [_imageChecked release];
    
    if (_imageUnchecked)
    {
        [_imageUnchecked release];
        _imageUnchecked = nil;
    }
    if (_font)
    {
        [_font release];
        _font = nil;
    }
    if (_textColor)
    {
        [_textColor release];
        _textColor = nil;
    }
    
    if (_blockValueChanged != nil)
    {
        [_blockValueChanged release];
        _blockValueChanged = nil;
    }
    
    [super dealloc];
}

@end
