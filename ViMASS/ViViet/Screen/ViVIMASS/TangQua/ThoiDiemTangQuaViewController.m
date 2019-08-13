//
//  ThoiDiemTangQuaViewController.m
//  ViViMASS
//
//  Created by DucBT on 3/27/15.
//
//

#import "CKCalendarView.h"
#import "ThoiDiemTangQuaViewController.h"

@interface ThoiDiemTangQuaViewController () <CKCalendarDelegate>

@property (nonatomic, retain) NSCalendar *mCal;
@property (nonatomic, retain) NSDateComponents *mComponent;
@property (nonatomic, retain) CKCalendarView *mCalendarView;

@end

@implementation ThoiDiemTangQuaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self khoiTaoBanDau];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - khoi tao

- (void)khoiTaoBanDau
{
    [self addButtonBack];
//    self.title = [@"hen_gio_tang_qua" localizableString];
    [self addTitleView:[@"hen_gio_tang_qua" localizableString]];
    [self.mtfThoiGianTangQua setTextAlignment:NSTextAlignmentCenter];
    [self.mbtnTangNay setTitle:[@"tang_ngay" localizableString] forState:UIControlStateNormal];

    CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
    calendar.delegate = self;
    calendar.onlyShowCurrentMonth = NO;
    calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    [calendar selectDate:[NSDate date] makeVisible:YES];
    
    CGRect calendarFrame = self.mViewChuaCalendar.bounds;
    calendar.frame = calendarFrame;
    
    self.mCal = [NSCalendar currentCalendar];
    [self.mCal setTimeZone:[NSTimeZone localTimeZone]];

    self.mComponent = [self.mCal components:(NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:[NSDate date]];
    self.mComponent.minute += 5;
    
    [self.mViewChuaCalendar addSubview:calendar];
    [calendar release];
    
    NSString *sThoiGianTangQua = [Common date:[self.mCal dateFromComponents:self.mComponent] toStringWithFormat:@"HH:mm"];
    [self.mtfThoiGianTangQua setText:sThoiGianTangQua];
    [self khoiTaoDatePicker];
}

- (void)khoiTaoDatePicker
{
    UIDatePicker *datePicker = [[[UIDatePicker alloc] init] autorelease];
    datePicker.date = [self.mCal dateFromComponents:self.mComponent];
    datePicker.datePickerMode = UIDatePickerModeTime;
    [datePicker addTarget:self action:@selector(suKienThayDoiDatePicker:) forControlEvents:UIControlEventValueChanged];
    self.mtfThoiGianTangQua.inputView = datePicker;
    self.mtfThoiGianTangQua.inputAccessoryView = nil;
}


#pragma mark - su Kien

- (IBAction)suKienBamNutThucHien:(id)sender
{
    if([self.mDelegate respondsToSelector:@selector(suKienChonThoiDiemTangQua:)])
    {
        [self.mDelegate suKienChonThoiDiemTangQua:[self.mCal dateFromComponents:self.mComponent]];
    }
    [self didSelectBackButton];
}


- (IBAction)suKienBamNutTangNgay:(id)sender
{
    if([self.mDelegate respondsToSelector:@selector(suKienChonThoiDiemTangQua:)])
    {
        [self.mDelegate suKienChonThoiDiemTangQua:nil];
    }
}

- (IBAction)suKienThayDoiDatePicker:(UIDatePicker*)sender
{
    NSDateComponents *components = [self.mCal components:(NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:sender.date];
    
    self.mComponent.hour = components.hour;
    self.mComponent.minute = components.minute;
    
    NSString *sThoiGianTangQua = [Common date:[self.mCal dateFromComponents:components] toStringWithFormat:@"HH:mm"];
    [self.mtfThoiGianTangQua setText:sThoiGianTangQua];
}

#pragma mark - CKCalendarDelegate

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
    // TODO: play with the coloring if we want to...
    //    if ([self dateIsDisabled:date]) {
    //        dateItem.backgroundColor = [UIColor redColor];
    //        dateItem.textColor = [UIColor whiteColor];
    //    }
}

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    return YES;
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date
{
    if(date)
    {
        NSDateComponents *components = [self.mCal components:(NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
        self.mComponent.day = components.day;
        self.mComponent.month = components.month;
        self.mComponent.year = components.year;
    }
    else
    {
        [calendar selectDate:[NSDate date] makeVisible:YES];
        NSDateComponents *components = [self.mCal components:(NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:[NSDate date]];
        self.mComponent.day = components.day;
        self.mComponent.month = components.month;
        self.mComponent.year = components.year;
    }
}

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date {
    //    if ([date laterDate:self.minimumDate] == date) {
    //        self.calendar.backgroundColor = [UIColor blueColor];
    //        return YES;
    //    } else {
    //        self.calendar.backgroundColor = [UIColor redColor];
    //        return NO;
    //    }
    return YES;
}

- (void)calendar:(CKCalendarView *)calendar didLayoutInRect:(CGRect)frame {
//    CGRect newFrame = self.mViewChuaCalendar.frame;
//    newFrame.size.height = frame.size.height;
//    self.mViewChuaCalendar.frame = newFrame;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_mCal release];
    [_mComponent release];
    [_mCalendarView release];
    [_mViewChuaCalendar release];
    [_mbtnChonThoiGian release];
    [_mbtnTangNay release];
    [_mtfThoiGianTangQua release];
    [super dealloc];
}

@end
