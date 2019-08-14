//
//  CalendarView.h
//  MyCalendar
//
//  Created by MAC on 8/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CalendarView.h"
#import "MonthView.h"
@class CalendarView;
@protocol CalendarViewDelegate <NSObject>
@optional
-(void)calendarView:(CalendarView *)_calendarView valueChanged:(NSDate *) _dateChanged;
-(void)calendarViewOnClicked:(CalendarView *)_calendarView andValue:(NSDate *) _dateChanged;
@end


@interface CalendarView : UIView<MonthViewDelegate>
@property (nonatomic,retain) NSDate * currentDate;
@property (retain) id<CalendarViewDelegate> delegate;


/***/
- (id)initWithFrame:(CGRect)frame andCurrentDate:(NSDate*) _currentDate;
@end
