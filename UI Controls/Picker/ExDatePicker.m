//
//  ExDatePicker.m
//  ViMASS
//
//  Created by Chung NV on 5/16/13.
//
//

#import "ExDatePicker.h"
#import "LocalizationSystem.h"

#define kTOOLBAR_HEIGHT 44
#define kWRAPPER_TAG    204
#define kTOOLBAR_TAG    2041
@implementation ExDatePicker
{
    void (^_completed)(UIDatePicker *picker, BOOL didClickedDone);
//    void (^_oncreate)(BaseScreen *vc);
    
}
-(void)showInView:(UIView *)view
         withDate:(NSDate *)date
         animated:(BOOL)animated
        completed:(void(^)(UIDatePicker *picker,BOOL didClickedDone))completed
{
    if (view == nil)
        return;
    
    if (date == nil)
        date = [NSDate date];
    
    [self setDate:date];
    
    if (completed)
    {
        [_completed release];
        _completed = [completed copy];
    }
    
    // add views
    UIView *v = [view viewWithTag:kWRAPPER_TAG];
    if (v == nil)
    {
        CGRect r = view.frame;
        r.origin = CGPointZero;
        
        v = [[UIView alloc] initWithFrame:r];
        v.tag = kWRAPPER_TAG;
        v.backgroundColor = [UIColor clearColor];
        
        [view addSubview:v];
        [v release];
    }
    
    [view bringSubviewToFront:v];
    v.hidden = NO;
    
    if ([view.subviews containsObject:self] == NO)
    {
        [view addSubview:self];
    }
    
    CGRect frameAppear = self.frame;
    frameAppear.origin.y    = view.frame.size.height - frameAppear.size.height;
    
    CGRect frameAnimated = self.frame;
    frameAnimated.origin.y  = view.frame.size.height;
    
    if (animated)
        self.frame = frameAnimated;
    else
        self.frame = frameAppear;
    
    [view bringSubviewToFront:self];
    self.hidden = NO;
    
    if (animated)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = frameAppear;
        } completion:^(BOOL finished) {
        }];
    }
}

-(void) hide
{
    [UIView animateWithDuration:0.3 animations:^
     {
         UIView *supperView = self.superview;
         
         UIView *v = [supperView viewWithTag:kWRAPPER_TAG];
         v.hidden = YES;
         
         CGRect r = self.frame;
         r.origin.y = supperView.frame.size.height;
         self.frame = r;
     } completion:^(BOOL finished)
    {}];
}

-(void)didSelectButtonAccessory:(void (^)(UIDatePicker *, BOOL))doneAction
{
    [_completed release];
    _completed = [doneAction copy];
}

-(void)barButtonItemAction:(UIButton *)sender
{
    if (_completed)
        _completed(_datePicker, sender.tag != 0);
}

#pragma mark - Inherit
-(void)setDate:(NSDate *)date
{
    if (date != _date)
    {
        [_date release];
        _date = [date retain];
        [_datePicker setDate:_date];
    }
}

-(void)setDatePickerMode:(UIDatePickerMode)datePickerMode
{
    [_datePicker setDatePickerMode:datePickerMode];
    CGRect r = _datePicker.frame;
    r.origin.y = kTOOLBAR_HEIGHT;
    _datePicker.frame = r;
    
    r.origin = self.frame.origin;
    r.size.height += kTOOLBAR_HEIGHT;
    self.frame = r;
    
    UIToolbar *toolbar = [self create_toolBar];
    [self addSubview:toolbar];
    [toolbar release];
    
    [self addSubview:_datePicker];

}

-(UIToolbar *) create_toolBar
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0,_datePicker.frame.size.width,kTOOLBAR_HEIGHT)];
    
    
//    UIBarButtonItem *btCancel = [[UIBarButtonItem alloc] initWithTitle:LocalizedString(@"Cancel") style:UIBarButtonSystemItemCancel target:self action:@selector(barButtonItemAction:)];
//    btCancel.tag = 0;
//    UIBarButtonItem *btDone = [[UIBarButtonItem alloc] initWithTitle:LocalizedString(@"Done") style:UIBarButtonItemStyleDone target:self action:@selector(barButtonItemAction:)];
//    btDone.tag = 1;
    
    UIBarButtonItem *btCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(barButtonItemAction:)];
    btCancel.tag = 0;
    UIBarButtonItem *btDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(barButtonItemAction:)];
    btDone.tag = 1;
    
    UIBarButtonItem * space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    toolbar.items = @[btCancel,space,btDone];
    [toolbar setBarStyle:UIBarStyleBlack];
    toolbar.tag = kTOOLBAR_TAG;
    
    [space release];
    [btDone release];
    [btCancel release];
    
    return toolbar;
}

-(void)didMoveToSuperview
{
    [super didMoveToSuperview];
    self.backgroundColor = [UIColor whiteColor];
}

-(void) _init
{
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.backgroundColor = [UIColor whiteColor];
    static NSString * locale_identifiers[] = {@"vi_VN",@"en_US"};
    int language = 0;
    NSNumber *tmp = [[NSUserDefaults standardUserDefaults] objectForKey:kOptionLanguage];
    if (tmp && [tmp isKindOfClass:[NSNumber class]])
        language = [tmp intValue];
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:locale_identifiers[language]];
    [_datePicker setLocale:locale];
    [locale release];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self _init];
    }
    return self;
}

-(id)init
{
    if (self = [super init])
    {
        [self _init];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self _init];
    }
    return self;
}

-(void)dealloc
{
    [_completed release];
    [_date release];
    [_datePicker release];
    [super dealloc];
}
@end
