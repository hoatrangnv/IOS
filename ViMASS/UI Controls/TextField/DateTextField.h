//
//  DateTextField.h
//  Test
//
//  Created by Chung NV on 2/6/13.
//  Copyright (c) 2013 ViViet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExTextField.h"

typedef BOOL (^DateBlockValidate)(NSDate *date);

@interface DateTextField : ExTextField
{
    
}
/*
 * formating of date in text field
 * if NOT SET : + formating = placeHolder(from file .xib)
 * if formating not correct of formating standard , formating = defalut: @"mm/dd/yyyy"
 */
@property (nonatomic,copy) NSString * formating;

-(void) addDateConstraintWithBlock:(DateBlockValidate ) dateBlock
            withErrorMessage:(NSString *) messageError;

-(void) setText:(NSString *)text withDateFormatter:(NSString *) _formattig;
-(void) setDate:(NSDate *) date;
-(NSDate *) getDate;

@end

/* 
 *  @class DateComponent : There are 3 components of DATE : DAY, MONTH , YEAR
 */
typedef enum {
    DateComponentTypeDay    = 0,
    DateComponentTypeMonth  = 1,
    DateComponentTypeYear   = 2
}DateComponentType;
@interface DateComponent : NSObject
{
    DateComponentType type;
}
/* length of format string.
 * dd :length = 2, mm  :length = 2 , yyyy : length = 4
 */
@property (nonatomic, copy)     NSString * fomating;
@property (nonatomic, assign)   int        length;
@property (nonatomic, copy)     NSString * value;

/* @params : _strFormat : dd or mm or yy or yyyy
 * retun object
 */
-(id)initWithFormat:(NSString*) _strFormat;

/*
 * append new char
 */
-(void) appendChar:(char) _ch;

/*
 * empty value of component
 */
-(void) empty;

@end