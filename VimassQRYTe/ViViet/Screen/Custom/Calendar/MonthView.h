//
//  MonthView.h
//  MyCalendar
//
//  Created by MAC on 8/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
@class MonthView;
@protocol MonthViewDelegate <NSObject>
-(void)monthView:(MonthView *)_monthView valueChanged:(NSDate *) _dateChanged;
-(void)monthViewOnClicked:(MonthView *)_monthView andValue:(NSDate *) _dateChanged;
@end

#import <UIKit/UIKit.h>

@interface MonthView : UIView
{
    int currentIndex;
    int numRows;
    NSMutableArray * arrDates;
    NSDateComponents * dateComponentsCurrent;
}
@property (nonatomic,retain) NSDate * currentDate;
@property (retain) id<MonthViewDelegate> delegate;


/***/
- (id)initWithFrame:(CGRect)frame andCurrentDate:(NSDate*) _currentDate;
-(void)setCurrentDate:(NSDate *)currentDate andAnimation:(BOOL)_animation;
@end
