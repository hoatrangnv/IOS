//
//  GiaoDienDatVeXe.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 10/16/17.
//

#import "GiaoDienDatVeXe.h"
#import "CKCalendarView.h"
@interface GiaoDienDatVeXe ()<CKCalendarDelegate> {
    ViewQuangCao *viewQC;
}

@end

@implementation GiaoDienDatVeXe

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitleView:@"Đặt vé xe"];

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
    
    UIView *viewTemp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:viewTemp];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self khoiTaoQuangCao];
}

- (void)khoiTaoQuangCao {
    if (viewQC) {
        return;
    }
    viewQC = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ViewQuangCao class]) owner:self options:nil] objectAtIndex:0];
    //    viewQC.backgroundColor = UIColor.redColor;
    viewQC.mDelegate = self;
    CGRect rectToken = self.mViewNhapToken.frame;
    CGRect rectQC = viewQC.frame;
    CGRect rectMain = self.mViewMain.frame;
    rectQC.origin.x += 2;
    CGFloat fW = rectMain.size.width;
    CGFloat fH = fW * 0.4533;
    rectQC.origin.y = rectToken.origin.y + rectToken.size.height + 5;
    viewQC.frame = CGRectMake(0, rectQC.origin.y, fW, fH);
    //    NSLog(@"%s - %d - viewQC.frame : %f - %f - %f - %f", __FUNCTION__, __LINE__, viewQC.frame.origin.x, viewQC.frame.origin.y, viewQC.frame.size.width, viewQC.frame.size.height);
    viewQC.mDelegate = self;
    [viewQC updateSizeQuangCao];
    NSLog(@"%s - %d - [UIScreen mainScreen].bounds.size.width : %f", __FUNCTION__, __LINE__, [UIScreen mainScreen].bounds.size.height);
    float fThem = 0;
    if ([UIScreen mainScreen].bounds.size.height == 896.0) {
        fThem = 20;
    }
    rectMain.size.height = rectQC.origin.y + rectQC.size.height + fThem;
    self.mViewMain.frame = rectMain;
    [self.mViewMain addSubview:viewQC];
    [self.scrMain setContentSize:CGSizeMake(_scrMain.frame.size.width, viewQC.frame.origin.y + viewQC.frame.size.height + 10)];
    
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
    [_scrMain release];
    [super dealloc];
}
@end
