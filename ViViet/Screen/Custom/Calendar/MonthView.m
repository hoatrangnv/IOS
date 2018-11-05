//
//  MonthView.m
//  MyCalendar
//
//  Created by MAC on 8/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MonthView.h"

// <=1-1-2012 => 1-12-2011

#define Time_Interval_Of_Day 86400;

@implementation MonthView
@synthesize delegate;
@synthesize currentDate;

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
        self.currentDate = [self dateWithYear:2012 month:7 day:20];
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
    //set default
    currentIndex =0;
    dateComponentsCurrent = [[self getDateComponentsFromDate:self.currentDate] retain];
    arrDates = [[NSMutableArray alloc] init];
    [self setNumRows];
    [self setArrDates];
    
    
    
    //
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CalendarBG.png"]];
    imgV.frame = self.bounds;
    [self addSubview:imgV];
    [imgV release];
    
    CGRect rect = self.frame;
    //draw vertical seperator
    int cellWith = (int)rect.size.width/7;
    int cellHeight = (int)rect.size.height/numRows;
    float paddingLeft =(int)(self.frame.size.width-cellWith * 7)/2; 
    float paddingTop =(int)(self.frame.size.height-cellHeight * numRows)/2;
    float originX = paddingLeft,originY =paddingTop;
    
    for (int i=0;i<8;i++) {
        CGRect rectSep = CGRectMake(originX,paddingTop,1,cellHeight*numRows);
        UIView * sepWhite= [[UIView alloc] initWithFrame:rectSep];
        sepWhite.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"seperator1.png"]];
        rectSep.origin.x +=1;
        UIView * sepBlack= [[UIView alloc] initWithFrame:rectSep];
        sepBlack.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"seperator2.png"]];
        [self addSubview:sepWhite];
        [self addSubview:sepBlack];
        [sepBlack release];
        [sepWhite release];
        
        originX += cellWith;
    }
    //draw horintical seperator
    for (int i=0;i<numRows+1;i++) {
        CGRect rectSep = CGRectMake(paddingLeft+1,originY,cellWith*7,1);
        UIView * sepWhite= [[UIView alloc] initWithFrame:rectSep];
        sepWhite.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"seperator2.png"]];
        rectSep.origin.y +=1;
        UIView * sepBlack= [[UIView alloc] initWithFrame:rectSep];
        sepBlack.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"seperator1.png"]];
        [self addSubview:sepWhite];
        [self addSubview:sepBlack];
        [sepBlack release];
        [sepWhite release];
        
        originY += cellHeight;
    }
    
    //draw button
    float btOriginY = paddingTop;
    for (int i=0;i<numRows;i++) {
        float btOriginX = paddingLeft;
        for (int j=0; j<7; j++) {
            int index= i*7+j;
            if (index >=arrDates.count) {
                break;
            }
            NSDateComponents *dComponents = [self getDateComponentsFromDate:[arrDates objectAtIndex:index]];
            //set rect of button
            CGRect rectBt = CGRectMake(btOriginX,btOriginY,cellWith+2,cellHeight+2);
            UIButton *bt = [[UIButton alloc] init];
            bt.frame = rectBt;
            //set title and title color
            [bt setTitle:[NSString stringWithFormat:@"%d",(int)dComponents.day] forState:UIControlStateNormal];
            if (dComponents.month != dateComponentsCurrent.month) {
                [bt setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            }else {
                [bt setTitleColor:[UIColor colorWithRed:0.192 green:0.2353 blue:0.286 alpha:1.0] forState:UIControlStateNormal];
            }
            //set font and background for highlighted
            bt.titleLabel.font = [UIFont boldSystemFontOfSize:20];
            //nếu đây là nút của thời gian hiện tại
            if ([dateComponentsCurrent isEqual:dComponents]) {
                [bt setBackgroundImage:[UIImage imageNamed:@"bt_bg_selected.png"] forState:UIControlStateNormal];
                [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                currentIndex = index;
            }
            // if day is the current time of system
            if ([dComponents isEqual:[self getDateComponentsFromDate:[NSDate date]]]) {
                [bt setBackgroundImage:[UIImage imageNamed:@"bt_currentDay_bg.png"] forState:UIControlStateNormal];
                [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                bt.titleLabel.textColor = [UIColor whiteColor];
            }
            [bt setBackgroundImage:[UIImage imageNamed:@"bt_bg_selected.png"] forState:UIControlStateHighlighted];
            
            //set tag = index and set event touch up inside
            bt.tag = index;
            [bt addTarget:self action:@selector(buttonTouchInside:) forControlEvents:UIControlEventTouchUpInside];
            
            //add subview
            [self addSubview:bt];
            [bt release];
            //calc originx again
            btOriginX += cellWith;
            
        }
        //calc origin y
        btOriginY +=cellHeight;
    }
}
-(void)buttonTouchInside:(UIButton *) button
{
    UIButton *bt = (UIButton*) [self getViewAtIndex:currentIndex];
    
    //set before button image for button 
    NSDateComponents *dateCurrentSystemComponents = [self getDateComponentsFromDate:[NSDate date]];
    NSDateComponents *dateBeforeComponents = [self getDateComponentsFromDate:[arrDates objectAtIndex:currentIndex]];
    // nếu thời gian hiện tại là thời gian của hệ thống
    if ([dateCurrentSystemComponents isEqual:dateBeforeComponents]) {
        [bt setBackgroundImage:[UIImage imageNamed:@"bt_currentDay_bg.png"] forState:UIControlStateNormal];
        [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else {
        [bt setBackgroundImage:nil forState:UIControlStateNormal];
    }
    
    
    if ([self getDateComponentsFromDate:[arrDates objectAtIndex:bt.tag]].month == dateComponentsCurrent.month) {
        [bt setTitleColor:[UIColor colorWithRed:0.192 green:0.2353 blue:0.286 alpha:1.0] forState:UIControlStateNormal];
        [bt setTitleColor:[UIColor colorWithRed:0.192 green:0.2353 blue:0.286 alpha:1.0] forState:UIControlStateNormal];
    }else {
        [bt setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    
    currentIndex =  (int)button.tag;
    [button setBackgroundImage:[UIImage imageNamed:@"bt_bg_selected.png"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (bt.tag != button.tag) {
        if ([self.delegate respondsToSelector:@selector(monthView:valueChanged:)]) {
            [self.delegate monthView:self valueChanged:[arrDates objectAtIndex:button.tag]];
        }
    }
    
    //delegate on clicked
    if ([self.delegate respondsToSelector:@selector(monthViewOnClicked:andValue:)]) {
        [self.delegate monthViewOnClicked:self andValue:[arrDates objectAtIndex:button.tag]];
    }
}
#pragma mark
#pragma mark Setter
-(void)setCurrentDate:(NSDate *)currentDate andAnimation:(BOOL)_animation
{
    
}
-(void) setDefaultButton:(UIButton*) _button
{
    
}
-(void) setSelectedButton:(UIButton*) _button
{
    
}
-(void) setNumRows
{
    /*
     * calculate số tuần trong tháng
     */
    int count = 0;
    //number days of current month
    int numberDaysOfMonth = [self getNumberDaysOfMonth:self.currentDate];
    
    //get the first day of month
    NSDate * firstDay = [self dateWithYear:dateComponentsCurrent.year month:dateComponentsCurrent.month day:1];
    
    // trừ đi số ngày của tuần đầu tiên và tăng lên 1 tuần
    int firstDayWeekDay = (int)[self getDateComponentsFromDate:firstDay].weekday;
    if (firstDayWeekDay != 1) {
        numberDaysOfMonth -= 7 - firstDayWeekDay+1;
        count +=1;
    }
    //
    count += ceil((double)numberDaysOfMonth/7);
    numRows = count;
}
-(void) setArrDates
{
    int numDaysOfCurrentDate = [self getNumberDaysOfMonth:self.currentDate];
    NSDate * firstDay = [self dateWithYear:dateComponentsCurrent.year month:dateComponentsCurrent.month day:1];
    int firstDayWeekDay = (int)[self getDateComponentsFromDate:firstDay].weekday;
    // days of  previous month
    NSDate *prevMonth = [self previousMonthsFromDate:firstDay];
    int numDaysOfPrevMonth = [self getNumberDaysOfMonth:prevMonth];
    int i = numDaysOfPrevMonth + 1 - (firstDayWeekDay -1);
    NSDateComponents * prevDateComponents = [self getDateComponentsFromDate:prevMonth];
    for (;i<=numDaysOfPrevMonth;i++) {
        NSDate * d = [self dateWithYear:prevDateComponents.year month:prevDateComponents.month day:i];
        [arrDates addObject:d];
    }
    
    //days of current month
    
    for (i=1;i<=numDaysOfCurrentDate;i++) {
        NSDate * d = [self dateWithYear:dateComponentsCurrent.year month:dateComponentsCurrent.month day:i];
        [arrDates addObject:d];
    }
    
    //days of next month
    NSDate *lastDaysOfMonth = [self dateWithYear:dateComponentsCurrent.year month:dateComponentsCurrent.month day:numDaysOfCurrentDate];
    int lastDaysOfmonthWeekday = (int)[self getDateComponentsFromDate:lastDaysOfMonth].weekday;
    if (lastDaysOfmonthWeekday != 7) {
        NSDate *nextMonth = [self nextMonthsFromDate:firstDay];
        NSDateComponents * nextMonthComponents = [self getDateComponentsFromDate:nextMonth];
        i = lastDaysOfmonthWeekday + 1;
        int count =1;
        for (;i<=7;i++) {
            NSDate * d = [self dateWithYear:nextMonthComponents.year month:nextMonthComponents.month day:count++];
            [arrDates addObject:d];
        }
    }
}
#pragma mark
#pragma mark Getter
-(UIView *) getViewAtIndex:(int) _index
{
    UIView * result = nil;
    for (UIView *v in [self subviews]) {
        if ([v isKindOfClass:[UIButton class]]) {
            if (v.tag == _index) {
                result = v;
                break;
            }
        }
    }
    return result;
}


#pragma mark
#pragma mark function date
-(int) getNumberDaysOfMonth:(NSDate *) date
{
    NSCalendar *c = [NSCalendar currentCalendar];
    NSRange days = [c rangeOfUnit:NSDayCalendarUnit 
                           inUnit:NSMonthCalendarUnit 
                          forDate:date];
    return (int)days.length;
}
-(NSDateComponents *) getDateComponentsFromDate:(NSDate *) _date
{
    NSCalendar *gregorian = [[[NSCalendar alloc]
                              initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    //    [gregorian setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:7]];
    NSDateComponents *dateComponents =[gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit) fromDate:_date];
    return dateComponents;
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
#pragma mark
#pragma mark Dealloc
-(void)dealloc
{
    [arrDates release];
    [currentDate release];
    [dateComponentsCurrent release];
    [super dealloc];
}

@end



















