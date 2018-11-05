//
//  GiaoDienDatVeXe.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 10/16/17.
//

#import "GiaoDienDatVeXe.h"
#import "CKCalendarView.h"
@interface GiaoDienDatVeXe ()<CKCalendarDelegate> {
    
}

@end

@implementation GiaoDienDatVeXe

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Đặt vé xe";

    CKCalendarView *calendar = [[CKCalendarView alloc] init];
    calendar.onlyShowCurrentMonth = NO;
    calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    CGRect calendarFrame = self.viewCalendar.bounds;
    calendarFrame.origin.y = calendarFrame.origin.y + 10;
    calendar.frame = calendarFrame;
    [self.viewCalendar addSubview:calendar];
    calendar.delegate = self;
    [calendar selectDate:[NSDate date] makeVisible:YES];
    [calendar release];
    [self.viewCalendar bringSubviewToFront:self.btnCloseCalendarView];
    [self.mViewMain bringSubviewToFront:self.viewCalendar];
}

- (IBAction)suKienChonNgayDi:(id)sender {
    [self.viewCalendar setHidden:NO];
}

- (IBAction)suKienChonTiepTuc:(id)sender {
}

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    return [calendar dateIsInCurrentMonth:date];
}

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date {
    return YES;
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date{
//    NSDate *today = [NSDate date];
    NSCalendar *mCal = [NSCalendar currentCalendar];
    NSDateComponents *components = [mCal components:(NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
//    NSDateComponents *components2 = [mCal components:(NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:today];

    NSString *sDate = [NSString stringWithFormat:@"%ld-%ld-%ld", (long)components.day, (long)components.month, (long)components.year];
    NSString *sTimeCanLay = [NSString stringWithFormat:@"%ld%ld%ld", (long)components.year, (long)components.month, (long)components.day];
    if (components.day < 9 && components.month < 9) {
        sDate = [NSString stringWithFormat:@"0%ld-0%ld-%ld", (long)components.day, (long)components.month, (long)components.year];
        sTimeCanLay = [NSString stringWithFormat:@"%ld0%ld0%ld", (long)components.year, (long)components.month, (long)components.day];
    }
    else if (components.day < 9){
        sDate = [NSString stringWithFormat:@"0%ld-%ld-%ld", (long)components.day, (long)components.month, (long)components.year];
        sTimeCanLay = [NSString stringWithFormat:@"%ld%ld0%ld", (long)components.year, (long)components.month, (long)components.day];
    }
    else if (components.month < 9){
        sDate = [NSString stringWithFormat:@"%ld-0%ld-%ld", (long)components.day, (long)components.month, (long)components.year];
        sTimeCanLay = [NSString stringWithFormat:@"%ld0%ld%ld", (long)components.year, (long)components.month, (long)components.day];
    }
    self.edChonNgay.text = sDate;
}


- (void)dealloc {
    [_edChonNgay release];
    [_edTinhDi release];
    [_edHuyenDi release];
    [_edTinhDen release];
    [_edHuyenDen release];
    [_viewCalendar release];
    [_btnCloseCalendarView release];
    [super dealloc];
}
@end
