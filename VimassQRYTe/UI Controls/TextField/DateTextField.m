//
//  DateTextField.m
//  Test
//
//  Created by Chung NV on 2/6/13.
//  Copyright (c) 2013 ViViet. All rights reserved.
//

#import "DateTextField.h"
#import "Common.h"

#define kPATTERN_FORMATING_1        @"^dd[/-]{0,1}MM[/-]{0,1}(yy){1,2}$"
#define kPATTERN_FORMATING_2        @"^(yy){1,2}[/-]{0,1}MM[/-]{0,1}dd$"
#define kPATTERN_FORMATING_3        @"^MM[/-]{0,1}dd[/-]{0,1}(yy){1,2}$"

#define kFOMAT_DEFAULT              @"dd/MM/yyyy"
#define kKEYBOARD_TYPE_DEFALUT      UIKeyboardTypeNumberPad
#define kICON_ERROR_TAG_VIEW        12365



@implementation DateTextField
{
    char separator;
    DateComponent   *   component_1;
    DateComponent   *   component_2;
    DateComponent   *   component_3;
    
    NSString        * oldText;
    
    NSMutableDictionary * _validateBlocks;
    
    BOOL setTextFlag;
}
@synthesize formating = _formating;
#pragma mark - Public Method
-(BOOL)validate
{
    return [super validate];
}

-(BOOL)validate_internal
{
    if([super validate_internal] == NO)
        return NO;
    
    if ([Common isEmptyString:self.text] && self.checkEmpty == NO)
        return YES;
    
    if (_validateBlocks && _validateBlocks.count > 0)
    {
        for (DateBlockValidate block in _validateBlocks)
        {
            BOOL validate = block(self.getDate);
            if (validate == NO)
            {
                UIView *iconError = [self iconError];
                iconError.hidden = NO;
                NSString *messError = [_validateBlocks objectForKey:block];
                if (messError)
                    self.textError = messError;
                return NO;
            }
        }
    }
    return YES;
}

-(void)setText:(NSString *)text withDateFormatter:(NSString *)formatting_
{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:formatting_];
    NSDate *date = [formatter dateFromString:text];
    if (date)
        [self setDate:date];
    else
        NSLog(@"%s : %@ or %@ - NOT Wrong.",__FUNCTION__,text,formatting_);
}

-(void)addDateConstraintWithBlock:(DateBlockValidate)dateBlock
           withErrorMessage:(NSString *)messageError
{
    if (!_validateBlocks)
        _validateBlocks = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    [_validateBlocks setObject:messageError forKey:[dateBlock copy]];
    
    return;
    
}

-(NSDate *)getDate
{
    NSDate *date = nil;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:self.formating];
    
    date = [formatter dateFromString:self.text];
    [formatter release];
    
    return date;
}

/*
 * when text value of text field was changed
 */
-(void)setText:(NSString *)text
{
    setTextFlag = YES;
    [super setText:text];
}

-(void) textFieldTextEditingChanged:(id) sender
{
    if (setTextFlag && SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(@"5.1"))
    {
        setTextFlag = NO;
        return;
    }
    
    NSString *text = self.text;
    int l = (int)text.length;
    if (text.length > self->oldText.length) {
        // append new char
        char lastChar = [text characterAtIndex:l-1];
        if (lastChar < '0' || lastChar > '9')
            // if append char not is numberic => remove it.
            text = [text substringToIndex:l-1];
        else
            [self appendChar:lastChar
                  atPosition:(int)text.length - 1];
    }else
    {
        // delete last character
        char oldTextLastChar = [oldText characterAtIndex:oldText.length-1];
        if (oldTextLastChar == separator && oldText.length >= 2)
            self.text = [oldText substringToIndex:oldText.length-2];
        
        [self didFinishDeleteCharacter];
    }
    
    [self setText:self.valuesOfComponents];
    self->oldText = [self.text copy];
}



#pragma mark - - PRIVATE METHOD
/* when a character number is append in text field
 * @do:
 * apeend new char into components
 */
-(void)appendChar:(char) _char
       atPosition:(int) position
{
    int l_seperator = separator != 0 ? 1 : 0;
    
    int position_component_1 = component_1.length + l_seperator;
    int position_component_2 = component_2.length + component_1.length + l_seperator;
    
    if (position < position_component_1)
        [component_1 appendChar:_char];
    
    else if(position < position_component_2)
        [component_2 appendChar:_char];
    
    else
        [component_3 appendChar:_char];
    
}


/* when delete a character or button clear was pressed
 * @do:
  + Update VALUE of Components.
 */
-(void) didFinishDeleteCharacter
{
    NSString *text = self.text;
    if(separator != 0)
    {
        NSArray *arr = [text componentsSeparatedByString:[NSString stringWithFormat:@"%c",separator]];
        if (arr.count > 0)
            component_1.value = [arr objectAtIndex:0];
        
        if (arr.count > 1)
            component_2.value = [arr objectAtIndex:1];
        
        if (arr.count > 2)
            component_3.value = [arr objectAtIndex:2];
    }else
    {
        // FORMAT ddMMyyyy
        
        int l1 = component_1.length;
        component_1.value = [text substringWithRange:NSMakeRange(0, l1 > text.length ? text.length : l1)];
        
        int l2 = component_2.length;
        if (text.length > l1)
        {
            int lengthOfRange = (int)text.length - l1;
            NSRange r = NSMakeRange(l1, l2 > lengthOfRange ? lengthOfRange : l2);
            component_2.value = [text substringWithRange:r];
        }else
            [component_2 empty];
        
        if (text.length > l1 + l2)
        {
            int lengthOfRange = (int)text.length - (l1 + l2);
            NSRange r = NSMakeRange(l1+l2, lengthOfRange);
            component_3.value = [text substringWithRange:r];
        }else
            [component_3 empty];
    }
}

/*
 * @return text of 3 components : component_1 + separator +component_2 + separator +  component_3
 */
-(NSString*) valuesOfComponents
{
    NSString *com_1 = @"";
    NSString *com_2 = @"";
    NSString *com_3 = @"";
    
    int lseparator = separator == 0 ? 0 : 1;
    
    com_1 = component_1.value.length == component_1.length ? [NSString stringWithFormat:@"%@%c",component_1.value,separator] : component_1.value;
    
    if (com_1.length == component_1.length + lseparator)
    {
        com_2 = component_2.value.length == component_2.length ? [NSString stringWithFormat:@"%@%c",component_2.value,separator] : component_2.value;
        
        if (com_2.length == component_2.length + lseparator)
            com_3 = component_3.value;
        else
            [component_3 empty];
        
    }else{
        component_2.value = @"";
        component_3.value = @"";
    }
    
    return [NSString stringWithFormat:@"%@%@%@",com_1,com_2,com_3];
}

/* 
 *      find separator '-' or '/'
 *      alloc and init : 3 components of DATE (day,month,year)
 */
-(void) getFormats
{
    /*
     * get char separator
     */
    
    NSRange sepRange = [self.formating rangeOfString:@"-"];
    if (sepRange.location == NSNotFound)
    {
        sepRange = [self.formating rangeOfString:@"/"];
        if (sepRange.location != NSNotFound)
            separator = '/';
    }else
        separator = '-';
    
    /*
     * replace and get array of components
     */
    NSString *tmpPlace = [NSString stringWithFormat:@"%@",self.formating];
    tmpPlace = [tmpPlace stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    NSArray *fComponents = [tmpPlace componentsSeparatedByString:@"-"];
    if (fComponents.count != 3)
    {
        if (tmpPlace.length != 6 && tmpPlace.length != 8)
        {
            NSLog(@"????? isTextFormatDate NOT Correct! => Test agian it! Hurry up! %s",__FUNCTION__);
            return;
        }
        // ddMMyyyy || MMddyyyy || yyyyMMdd || ddMMyy || MMddyy || yyMMdd
        
        NSRange r1 = [tmpPlace rangeOfString:@"dd" options:NSRegularExpressionSearch];
        NSRange r2 = [tmpPlace.lowercaseString rangeOfString:@"mm" options:NSRegularExpressionSearch];
        NSRange r3 = [tmpPlace rangeOfString:@"(yy){1,2}" options:NSRegularExpressionSearch];
        
        NSRange arr[] = {r1,r2,r3};
        separator = '/';
        int minLocation = 10,maxLocation = 0;
        for (int i = 0; i<3; i++)
        {
            NSRange r = arr[i];
            if (r.location < minLocation)
                minLocation = (int)r.location;
            if (r.location > maxLocation)
                maxLocation = (int)r.location;
        }
        
        for (int i = 0; i<3; i++)
        {
            NSRange r = arr[i];
            NSString *comp_str = [tmpPlace substringWithRange:r];
            if (r.location == minLocation)
                component_1 = [[DateComponent alloc] initWithFormat:comp_str];
            if (r.location != minLocation && r.location != maxLocation)
                component_2 = [[DateComponent alloc] initWithFormat:comp_str];
            if (r.location == maxLocation)
                component_3 = [[DateComponent alloc] initWithFormat:comp_str];
        }
    }else
    {
        NSString *component_fmt = [fComponents objectAtIndex:0];
        if (component_1)
            [component_1 setFomating:component_fmt];
        else
            component_1 = [[DateComponent alloc] initWithFormat:component_fmt];
        
        
        component_fmt = [fComponents objectAtIndex:1];
        if (component_2)
            [component_2 setFomating:component_fmt];
        else
            component_2 = [[DateComponent alloc] initWithFormat:component_fmt];
        
        
        component_fmt = [fComponents objectAtIndex:2];
        if (component_3)
            [component_3 setFomating:component_fmt];
        else
            component_3 = [[DateComponent alloc] initWithFormat:component_fmt];
    }
    
    
    
    /*
     * with this FOMATING : set Partern of SELF  for SUPER:ExTextField
     */
    NSString * pattern = [NSString stringWithFormat:@"%@%c%@%c%@",component_1.fomating,separator,component_2.fomating,separator,component_3.fomating];
    
    if (pattern != _formating && [_formating isEqualToString:pattern] == NO)
    {
        [_formating release];
        _formating = [pattern copy];
    }
    
    pattern = [[NSString stringWithFormat:@"^%@$",pattern] lowercaseString];
    pattern = [pattern stringByReplacingOccurrencesOfString:@"[dmy]" withString:@"[0-9]" options:NSRegularExpressionSearch range:NSMakeRange(0, pattern.length)];

    [self changePattern:pattern];
}

/* @return TRUE if
 * _txtFormat is formating of 
 *    @"^dd[/-]mm[/-](yy){1,2}$"
 *    @"^(yy){1,2}[/-]mm[/-]dd$"
 *    @"^mm[/-]dd[/-](yy){1,2}$"
 */
-(BOOL) isTextFormatDate:(NSString*) _txtFormat
{
    NSString *format = [_txtFormat stringByReplacingOccurrencesOfString:@"mm" withString:@"MM"];
    if ([self matchesInString:format withPattern:kPATTERN_FORMATING_1])
        return TRUE;
    
    if ([self matchesInString:format withPattern:kPATTERN_FORMATING_2])
        return TRUE;
    
    return [self matchesInString:format withPattern:kPATTERN_FORMATING_3];
}


-(BOOL) matchesInString:(NSString *) _str 
            withPattern:(NSString *) _pattern
{
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:_pattern
                                                                      options:NSRegularExpressionCaseInsensitive
                                                                        error:nil];
    NSArray *arr_result = [regex matchesInString:_str
                                         options:0
                                           range:NSMakeRange(0, _str.length)];
    [regex release];
    if (arr_result && arr_result.count == 1)
        return TRUE;
    
    return FALSE;
}
#pragma mark - Setter
-(void)setPlaceholder:(NSString *)placeholder
{
    [super setPlaceholder:placeholder];
    NSString *place = self.placeholder;
    if (   place == nil
        || [place isEqualToString:@""]
        || ![self isTextFormatDate:place])
    {
        place = kFOMAT_DEFAULT;
    }
    [self setFormating:[[place lowercaseString] stringByReplacingOccurrencesOfString:@"mm" withString:@"MM"]];
}
-(void)setFormating:(NSString *)fmt
{
    if (fmt != _formating && [_formating isEqualToString:fmt] == NO)
    {
        [_formating release];
        _formating = [fmt copy];
        [self getFormats];
    }
}
-(void)setDate:(NSDate *)date
{
    if (date == nil || self.formating == nil )
        return;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:self.formating];
    NSString *text = [formatter stringFromDate:date];
    self.text = text;
}

#pragma mark - View hierarchy - Init
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setPlaceholder:self.placeholder];
    
    if(!self.keyboardType)
        self.keyboardType = kKEYBOARD_TYPE_DEFALUT;
}


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
        [self _init_];
    
    return self;
}
-(id)init
{
    if (self = [super init])
        [self _init_];
    
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        self.type = ExTextFieldTypeDate;
        [self _init_];
    }
    return self;
}
-(void) _init_
{
    [self addTarget:self
             action:@selector(textFieldTextEditingChanged:)
   forControlEvents:UIControlEventEditingChanged];
    separator = 0;
    
}

-(void)dealloc
{
    if (component_1)
        [component_1 release];
    
    if (component_2)
        [component_2 release];
    
    if (component_3)
        [component_3 release];
    
    if (oldText)
        [oldText release];
    
    if (_validateBlocks)
        [_validateBlocks release];
    
    [super dealloc];
}

@end




#pragma mark -
#pragma mark -
#pragma mark - Date Component Implement


@implementation DateComponent


-(id)initWithFormat:(NSString *)_strFormat 
{
    if (self = [super init])
    {
        self.fomating = [_strFormat lowercaseString];
        [self _initType];
        _length = (int)_strFormat.length;
        self.value = @"";
    }
    return self;
}

-(void)setFomating:(NSString *)fmt_
{
    if (fmt_ != _fomating)
    {
        if ([fmt_.lowercaseString isEqualToString:@"mm"])
            fmt_ = fmt_.uppercaseString;

        [_fomating release];
        _fomating = [fmt_ copy];
        [self _initType];
        _length = (int)_fomating.length;
        self.value = @"";
    }
}

-(void) _initType
{
    char fChar = [_fomating characterAtIndex:0];
    type = fChar == 'd' ? DateComponentTypeDay : (fChar == 'M' || fChar == 'm') ? DateComponentTypeMonth : DateComponentTypeYear;
}

-(void)appendChar:(char)_char
{
    if (_char < '0' || _char > '9')
        return;
    
    switch (type) {
        case DateComponentTypeDay:
            [self appendCharForDay:_char];
            break;
        case DateComponentTypeMonth:
            [self appendCharForMonth:_char];
            break;
        default:
            [self appendCharForYear:_char];
            break;
    }
}

-(void)empty
{
    self.value = @"";
}


-(void)appendCharForDay:(char)_char
{
    if (_value.length >= _length)
        return;
    
    if (_value.length == 0) {
        if (_char >= '4')
            self.value = [_value stringByAppendingFormat:@"0%c",_char];
        else
            self.value = [_value stringByAppendingFormat:@"%c",_char];
        
    }else if(_value.length == 1) {
        self.value = [_value stringByAppendingFormat:@"%c",_char];
        
        self.value = [_value intValue] > 31 ? @"31" : _value;
    }
}

-(void)appendCharForMonth:(char)_char
{
    if (_value.length >= _length)
        return;
    
    if (_value.length == 0) {
        if (_char > '1')
            self.value = [_value stringByAppendingFormat:@"0%c",_char];
        else
            self.value = [_value stringByAppendingFormat:@"%c",_char];
        
    }else if(_value.length == 1) {
        self.value = [_value stringByAppendingFormat:@"%c",_char];
        
        if (_value.intValue > 12) {
            self.value = @"12";
        }
    }
}
-(void)appendCharForYear:(char)_char
{
    if (_value.length >= _length)
        return;
    
    switch (_value.length) {
        case 0:
        case 1:
            self.value = [_value stringByAppendingFormat:@"%c",_char];
            /* if value > 21(2100) => append @"19xx"
             * type 23 => 1923, 45=> 1945 if length == 4
             */
            if (_value.intValue > 21 && _length == 4)
                self.value = [NSString stringWithFormat:@"19%@",_value];
            break;
        case 3:
            self.value = [_value stringByAppendingFormat:@"%c",_char];
            break;
        default:
            self.value = [_value stringByAppendingFormat:@"%c",_char];
            self.value = _value.intValue > 2100 ? @"2013" : _value;
            break;
    }
}
@synthesize fomating = _fomating,length = _length,value = _value;
-(void)dealloc
{
    [_fomating release];
    if (_value)
        [_value release];
    
    [super dealloc];
}
@end