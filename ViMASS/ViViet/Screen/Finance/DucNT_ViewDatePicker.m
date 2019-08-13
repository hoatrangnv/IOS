//
//  DucNT_ViewDatePicker.m
//  ViMASS
//
//  Created by MacBookPro on 7/16/14.
//
//

#import "DucNT_ViewDatePicker.h"

@implementation DucNT_ViewDatePicker
{
    GiaTriThoiGian giaTri;
}
@synthesize datePicker;
@synthesize btnConfirm;
@synthesize btnCancel;

-(id)initWithNib
{
    self = [[[[NSBundle mainBundle] loadNibNamed:@"DucNT_ViewDatePicker" owner:self options:nil] objectAtIndex:0] retain];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self khoiTaoGiaoDien];
}

- (void)dealloc
{
    if(datePicker)
        [datePicker release];
    if(btnConfirm)
        [btnConfirm release];
    if(btnCancel)
        [btnCancel release];
    if(giaTri)
        [giaTri release];
//    if(giaTri)
//        Block_release(giaTri);
    [super dealloc];
}

-(void)khoiTaoGiaoDien
{
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker setLocale:[NSLocale currentLocale]];
    [datePicker setDate:[NSDate date]];
}

- (IBAction)suKienConfirm:(id)sender
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd-MM-yyyy"];
    NSString *sThoiGian = [df stringFromDate:datePicker.date];
    [df release];
    if(giaTri)
        giaTri(sThoiGian);
}

- (IBAction)suKienCancel:(id)sender {
    if(giaTri)
        giaTri(nil);
}

-(void)truyenThongSoThoiGian:(GiaTriThoiGian)giaTriThoiGian
{
    [giaTri release];
    giaTri = [giaTriThoiGian copy];
//    giaTri = Block_copy(giaTriThoiGian);
}
@end
