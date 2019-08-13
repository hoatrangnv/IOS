//
//  ExDatePicker.h
//  ViMASS
//
//  Created by Chung NV on 5/16/13.
//
//

#import <UIKit/UIKit.h>

@interface ExDatePicker : UIView

-(void) showInView:(UIView *) view
          withDate:(NSDate *) date
          animated:(BOOL) animated
         completed:(void(^)(UIDatePicker *picker,BOOL didClickedDone)) completed;

@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, assign) UIDatePickerMode datePickerMode;

-(void) hide;

-(void) didSelectButtonAccessory:(void(^)(UIDatePicker *picker,BOOL didClickedDone)) doneAction;

@end
