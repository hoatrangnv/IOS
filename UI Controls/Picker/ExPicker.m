//
//  ExPicker.m
//  ViMASS
//
//  Created by Chung NV on 8/7/13.
//
//

#import "ExPicker.h"

@implementation ExPicker
{
    void (^_pickerDone)(int,id);
    void(^_pickerCancel)(ExPicker *);
    int selected;
}
#define kTOOLBAR_HEIGHT 44
#define kWRAPPER_TAG    204
#define kTOOLBAR_TAG    2041

-(void)selectRow:(int)row animated:(BOOL)animated
{
    selected = row;
    [_pickerView selectRow:row inComponent:0 animated:animated];
}

-(void)didPickerDone:(void (^)(int, id))pickerDone
{
    [_pickerDone release];
    _pickerDone = [pickerDone copy];
}
-(void)didPickerCancel:(void (^)(ExPicker *))pickerCancel
{
    [_pickerCancel release];
    _pickerCancel = [pickerCancel copy];
}

-(void)barButtonItemAction:(UIButton *)sender
{
    if (sender.tag == 0)
    {
        if (_pickerCancel)
        {
            _pickerCancel(self);
        }
        return;
    }else
    {
        if (_pickerDone)
        {
            id obj = nil;
            if (_datasource)
                obj = [_datasource objectAtIndex:selected];
            
            _pickerDone(selected, obj);
        }
        return;
    }
    
    __block ExPicker *weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        UIView *supperView = weakSelf.superview;
        
        UIView *v = [supperView viewWithTag:kWRAPPER_TAG];
        v.hidden = YES;
        
        CGRect r = weakSelf.frame;
        r.origin.y = supperView.frame.size.height;
        weakSelf.frame = r;
    } completion:^(BOOL finished) {
        if (weakSelf->_pickerDone && sender.tag == 1)
        {
            id obj = nil;
            if (weakSelf.datasource)
                obj = [weakSelf.datasource objectAtIndex:weakSelf->selected];

            weakSelf->_pickerDone(weakSelf->selected, obj);
        }
    }];
}
#pragma mark - Datasource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger number = 0;
    number = _datasource ? _datasource.count : 0;
    return number;
}
-(UIView *)pickerView:(UIPickerView *)pickerView
           viewForRow:(NSInteger)row
         forComponent:(NSInteger)component
          reusingView:(UIView *)view
{
    
    if (view == nil)
    {
        int width = self.frame.size.width;
        view = [[UILabel alloc] initWithFrame:CGRectMake(5, 0,width - 5,40)];
    }
    NSString *text = [_datasource objectAtIndex:row];
    UILabel *lbl = (UILabel *)view;
    lbl.text = text;
    lbl.font = [UIFont boldSystemFontOfSize:20];
    lbl.textAlignment = NSTextAlignmentCenter;
    return view;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0f;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selected = (int)row;
}

#pragma mark - Inherit

-(UIToolbar *) toolBar
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0,_pickerView.frame.size.width,kTOOLBAR_HEIGHT)];
    
    UIBarButtonItem *btCancel = [[UIBarButtonItem alloc] initWithTitle:LocalizedString(@"Cancel") style:UIBarButtonSystemItemCancel target:self action:@selector(barButtonItemAction:)];
    btCancel.tag = 0;
    
    UIBarButtonItem *btDone = [[UIBarButtonItem alloc] initWithTitle:LocalizedString(@"Done") style:UIBarButtonItemStyleDone target:self action:@selector(barButtonItemAction:)];
    btDone.tag = 1;
    
    UIBarButtonItem * space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    toolbar.items = [NSArray arrayWithObjects:btCancel,space,btDone,nil];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    toolbar.tag = kTOOLBAR_TAG;
    
    [space release];
    [btDone release];
    [btCancel release];
    
    return toolbar;
}

-(void)didMoveToSuperview
{
    self.backgroundColor = [UIColor clearColor];
    [self.pickerView reloadAllComponents];
}

-(void) _init
{
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    _pickerView.showsSelectionIndicator = YES;
    
    CGRect r = _pickerView.frame;
    r.origin.y = kTOOLBAR_HEIGHT;
    _pickerView.frame = r;
    
    r.origin = self.frame.origin;
    r.size.height += kTOOLBAR_HEIGHT;
    self.frame = r;
    
    UIToolbar *toolbar = [self toolBar];
    [self addSubview:toolbar];
    [toolbar release];
    
    [self addSubview:_pickerView];
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
    [_pickerDone release];
    [_pickerCancel release];
    [_datasource release];
    [_pickerView release];
    [super dealloc];
}
@end
