//
//  CalendarView.m
//  MyCalendar
//
//  Created by MAC on 8/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalendarView.h"
#define TAG_VIEW_CURRENT 200489
#define TAG_VIEW_ANIMATE 180589
#define TAG_HEADER_LABEL 204185
#define TAG_VIEW_CONTENT 8080
@implementation CalendarView
{
    BOOL synsAnimate;
    float headerHeight;
}
@synthesize currentDate,delegate;
#pragma mark
#pragma mark Init
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.currentDate = [NSDate date];
        [self draw];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.currentDate = [NSDate date];
        [self draw];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame andCurrentDate:(NSDate *)_currentDate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.currentDate = _currentDate;
        [self draw];
    }
    return self;
}
#pragma mark
#pragma mark Draw
-(void)draw
{
    self.clipsToBounds = TRUE;
    headerHeight =54.0;
    int cellWith = (int)self.frame.size.width/7;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,cellWith *7,self.frame.size.height);
    // add header view
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0,self.frame.size.width,headerHeight)];
    header.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cal_header_bg.png"]];
    int monthLabelWith = (int)(self.frame.size.width*0.78);
    int monthLabelOriginX = (int)(self.frame.size.width - monthLabelWith)/2;
    UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(monthLabelOriginX,0.0,monthLabelWith,40)];
    monthLabel.tag = TAG_HEADER_LABEL;
    NSString *textLabel = [NSString stringWithFormat:@"%@ %d",[self getMonthToString:(int)[self getDateComponentsFromDate:self.currentDate].month],(int)[self getDateComponentsFromDate:self.currentDate].year];
    monthLabel.text = textLabel;
    monthLabel.font = [UIFont boldSystemFontOfSize:22];
    monthLabel.textColor = [UIColor grayColor];
//    monthLabel.highlightedTextColor = [UIColor grayColor];
    monthLabel.shadowColor = [UIColor whiteColor];
    monthLabel.textAlignment = NSTextAlignmentCenter;
    monthLabel.backgroundColor = [UIColor clearColor];
    [header addSubview:monthLabel];
    //add button acction
    UIButton *btPrev = [[UIButton alloc] initWithFrame:CGRectMake(10.0,5,30,30)];
    UIButton *btNext = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-40,5,30,30)];
    [btPrev setImage:[UIImage imageNamed:@"arrow-left.png"] forState:UIControlStateNormal];
    [btNext setImage:[UIImage imageNamed:@"arrow-right.png"] forState:UIControlStateNormal];
    [btNext addTarget:self action:@selector(buttonNextAction:) forControlEvents:UIControlEventTouchUpInside];
    [btPrev addTarget:self action:@selector(buttonPrevAction:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:btPrev];
    [header addSubview:btNext];
    [btPrev release];
    [btNext release];
    //add dayweek
    
    [self addSubview:header];
    [header release];
    [monthLabel release];
    
    float originX = 0;
    for (int i=1; i<=7; i++) {
        UILabel *dayWeek = [[UILabel alloc] initWithFrame:CGRectMake(originX,40,cellWith,14)];
        dayWeek.font = [UIFont boldSystemFontOfSize:10];
        dayWeek.textColor = [UIColor grayColor];
        dayWeek.textAlignment = NSTextAlignmentCenter;
        dayWeek.backgroundColor = [UIColor whiteColor];
        dayWeek.text = [self getDayWeekToString:i];
        [self addSubview:dayWeek];
        [dayWeek release];
        originX += cellWith;
    }
    //add month view
    CGRect monthViewRect = CGRectMake(0.0,headerHeight,self.frame.size.width,self.frame.size.height -headerHeight);
    UIView * viewContent = [[UIView alloc] initWithFrame:monthViewRect];
    viewContent.tag = TAG_VIEW_CONTENT;
    monthViewRect.origin.y = 0.0;
    MonthView *monthView = [[MonthView alloc] initWithFrame:monthViewRect andCurrentDate:self.currentDate];
    monthView.delegate = self;
    monthView.tag = TAG_VIEW_CURRENT;
    [viewContent addSubview:monthView];
    viewContent.clipsToBounds = TRUE;
    [monthView release];
    [self addSubview:viewContent];
    
    
}

#pragma mark
#pragma mark SELECTOR
-(void)buttonNextAction:(UIButton*) _bt
{
    if (!synsAnimate) {
        synsAnimate = !synsAnimate;
        NSDate * nextMonth = [self nextMonthsFromDate:self.currentDate];
        [self animateChangedMonth:nextMonth andOrientUP:TRUE];      
    }
}
-(void)buttonPrevAction:(UIButton*) _bt
{
    if (!synsAnimate) {
        synsAnimate = !synsAnimate;
        NSDate * prevMonth = [self previousMonthsFromDate:self.currentDate];
        [self animateChangedMonth:prevMonth andOrientUP:FALSE];        
    }
}

#pragma mark
#pragma mark getter
-(NSDateComponents *) getDateComponentsFromDate:(NSDate *) _date
{
    NSCalendar *gregorian = [[[NSCalendar alloc]
                              initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    //    [gregorian setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:7]];
    NSDateComponents *dateComponents =[gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit) fromDate:_date];
    return dateComponents;
}

-(NSString *) getDayWeekToString:(int) _day
{
    NSString * result = nil;
    switch (_day) {
        case 1:
            result =@"Sun";
            break;
        case 2:
            result =@"Mon";
            break;
        case 3:
            result =@"Tue";
            break;
        case 4:
            result =@"Web";
            break;
        case 5:
            result =@"Thu";
            break;
        case 6:
            result =@"Fri";
            break;
        case 7:
            result =@"Sat";
            break;
        default:
            break;
    }
    return result;
}

-(NSString *) getMonthToString:(int) _month
{
    NSString * result = nil;
    switch (_month) {
        case 1:
            result =@"January";
            break;
        case 2:
            result =@"February";
            break;
        case 3:
            result =@"March";
            break;
        case 4:
            result =@"April";
            break;
        case 5:
            result =@"May";
            break;
        case 6:
            result =@"June";
            break;
        case 7:
            result =@"July";
            break;
        case 8:
            result =@"August";
            break;
        case 9:
            result =@"September";
            break;
        case 10:
            result =@"October";
            break;
        case 11:
            result =@"November";
            break;
        case 12:
            result =@"December";
            break;
        default:
            break;
    }
    return result;
}
-(void) animateChangedMonth:(NSDate *) _date andOrientUP:(BOOL) _orientUP
{
    float monthViewHeight = self.frame.size.height-headerHeight;
    CGRect rectView,rectViewCurentAnimate,rectViewAnimate;
    if (_orientUP) {
        rectView = CGRectMake(0.0,monthViewHeight,self.frame.size.width,monthViewHeight);
        rectViewCurentAnimate = CGRectMake(0.0,-monthViewHeight,self.frame.size.width, monthViewHeight);
        rectViewAnimate = CGRectMake(0.0,0.0,self.frame.size.width, monthViewHeight);
    }else {
        rectView = CGRectMake(0.0,-monthViewHeight,self.frame.size.width,monthViewHeight);
        rectViewCurentAnimate = CGRectMake(0.0,monthViewHeight,self.frame.size.width, monthViewHeight);
        rectViewAnimate = CGRectMake(0.0,0.0,self.frame.size.width, monthViewHeight);
    }
    
    MonthView *monthView = [[MonthView alloc] initWithFrame:rectView andCurrentDate:_date];
    monthView.delegate = self;
    monthView.tag = TAG_VIEW_ANIMATE;
    [[self viewWithTag:TAG_VIEW_CONTENT] addSubview:monthView];
    [monthView release];
    
    [UIView animateWithDuration:0.4 animations:^{
        [self viewWithTag:TAG_VIEW_CURRENT].frame = rectViewCurentAnimate;
        [self viewWithTag:TAG_VIEW_ANIMATE].frame = rectViewAnimate;
    } completion:^(BOOL fis){
        [[self viewWithTag:TAG_VIEW_CURRENT] removeFromSuperview];
        [self viewWithTag:TAG_VIEW_ANIMATE].tag = TAG_VIEW_CURRENT;
        synsAnimate = FALSE;
    }];
    
    self.currentDate = _date;
    [self updateLabel];
}
-(void)updateLabel
{
    NSString *textLabel = [NSString stringWithFormat:@"%@ %d",[self getMonthToString:(int)[self getDateComponentsFromDate:self.currentDate].month],(int)[self getDateComponentsFromDate:self.currentDate].year];
    ((UILabel*)[self viewWithTag:TAG_HEADER_LABEL]).text = textLabel;
}

#pragma mark
#pragma mark handle DATE
-(NSDate *) previousMonthsFromDate:(NSDate*) _date
{
    NSDateComponents *dateComponents = [self getDateComponentsFromDate:_date];
    int year = (int)dateComponents.year;
    int month = (int)dateComponents.month;
    if (month == 1) {
        year -= 1;
        month = 12;
    }else {
        month -=1;
    }
    return [self dateWithYear:year month:month day:1];
}
-(NSDate *) nextMonthsFromDate:(NSDate*) _date
{
    NSDateComponents *dateComponents = [self getDateComponentsFromDate:_date];
    int year = (int)dateComponents.year;
    int month = (int)dateComponents.month;
    if (month == 12) {
        year += 1;
        month = 1;
    }else {
        month +=1;
    }
    return [self dateWithYear:year month:month day:1];
}
-(NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day 
{
    //    day +=1;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[[NSDateComponents alloc] init] autorelease];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    return [calendar dateFromComponents:components];
}

#pragma mark
#pragma mark delegate
-(void)monthView:(MonthView *)_monthView valueChanged:(NSDate *)_dateChanged
{
    
    NSDateComponents *dateChangedComponents = [self getDateComponentsFromDate:_dateChanged];
    NSDateComponents *dateCurrentComponents = [self getDateComponentsFromDate:self.currentDate];
    // if dateChanged not the same date current
    NSComparisonResult re = [_dateChanged compare:self.currentDate];

    if (re != 0) { // nếu currentDate và _dateChanged là khác nhau
        
        if(dateChangedComponents.month != dateCurrentComponents.month){
            /*
             * nếu khác tháng thì animate
             * re > 0 animate UP
             * re < 0 animate DOWN
             */
            if (re > 0) {
                [self animateChangedMonth:_dateChanged andOrientUP:TRUE];
            }else{
                [self animateChangedMonth:_dateChanged andOrientUP:FALSE];
            }
        }
        self.currentDate = _dateChanged;
        //invoke delegate
        if ([self.delegate respondsToSelector:@selector(calendarView:valueChanged:)]) {
            [self.delegate calendarView:self valueChanged:_dateChanged];
        }
    }
}
-(void)monthViewOnClicked:(MonthView *)_monthView andValue:(NSDate *)_dateChanged
{
    //delegate onclick
    if ([self.delegate respondsToSelector:@selector(calendarViewOnClicked:andValue:)]) {
        [self.delegate calendarViewOnClicked:self andValue:self.currentDate];
    }
}
#pragma mark
#pragma mark Dealloc
-(void)dealloc
{
    [super dealloc];
    [currentDate release];
}
@end
