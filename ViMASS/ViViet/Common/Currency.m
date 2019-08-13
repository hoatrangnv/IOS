//
//  Currency.m
//  Curency
//
//  Created by MAC on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Currency.h"
#import "Static.h"
#import "AppDelegate.h"
@implementation Currency


+(NSString *) numberFromFormattedString:(NSString *) str
{
    if (str == nil)
    {
        return @"0";
    }
    NSString *re = [str stringByReplacingOccurrencesOfString:@"[.,]"
                                                  withString:@""
                                                     options:NSRegularExpressionSearch
                                                       range:NSMakeRange(0, str.length)];
    return re;
    
    
    NSNumberFormatter *fmt = [[[NSNumberFormatter alloc] init] autorelease];
    fmt.numberStyle = NSNumberFormatterCurrencyStyle;
    fmt.currencySymbol = @"";
    fmt.maximumFractionDigits = 0;
    fmt.formatterBehavior = NSNumberFormatterBehaviorDefault;
    
    return [NSString stringWithFormat:@"%@",[fmt numberFromString:str]];
}

+(NSString *) formatNumber:(id)n
{
    if (n == nil)
        return nil;
    
    NSNumber *number = nil;
    if ([n isKindOfClass:[NSNumber class]])
    {
        number = (NSNumber *)n;
    }
    else
    {
        NSString *str = nil;
        if ([str isKindOfClass:[NSString class]])
            str = n;
        else
            str = [NSString stringWithFormat:@"%@", n];
        
        number = [NSNumber numberWithDouble:[str doubleValue]];
    }
    
    NSNumberFormatter *fmt = [[[NSNumberFormatter alloc] init] autorelease];
    fmt.numberStyle = NSNumberFormatterCurrencyStyle;
    fmt.currencySymbol = @"";
    fmt.maximumFractionDigits = 0;
    fmt.formatterBehavior = NSNumberFormatterBehaviorDefault;
    
    NSString *strNumber = [fmt stringFromNumber:number];
    
    return [NSString stringWithFormat:@"%@", strNumber.trim];
}
+(NSString *) wordsForNumber:(NSString *) str
{
    Currency *cur = [[[Currency alloc] initWithCurrencyValueString:str] autorelease];
    return [cur toString];
}

@synthesize currencyValue,valid;

-(id) initWithCurrencyValue:(long long int) _value
{
    if(self = [super init])
    {
        self.currencyValue = [NSString stringWithFormat:@"%lld",_value];
        self.valid = true;
    }
    return self;
}

-(id)initWithCurrencyValueString:(NSString *)_valueString
{
    if(self = [super init])
    {
        self.currencyValue = _valueString;
        NSString * regex = @"^[0-9,\\s]+$";
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        
        self.valid = [predicate evaluateWithObject:self.currencyValue];
        self.currencyValue = [self.currencyValue stringByReplacingOccurrencesOfString:@","
                                                                           withString:@""];
        self.currencyValue = [self.currencyValue stringByReplacingOccurrencesOfString:@"."
                                                                           withString:@""];
        self.currencyValue = [self.currencyValue stringByReplacingOccurrencesOfString:@" "
                                                                           withString:@""];
    }
    return self;
}

-(NSString *) getCurrencyFomat
{
    NSNumberFormatter *formatter = [[[NSNumberFormatter alloc] init] autorelease];
    
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = 0;
    formatter.formatterBehavior = NSNumberFormatterBehaviorDefault;
    
    NSNumber * balance = [formatter numberFromString:self.currencyValue];
    
    NSString* formatted = [formatter stringFromNumber:balance];
    //    [formatted release];
    
    return formatted;
}

-(NSString *) numberString:(int) _number
{
    /*
     * @pragam int 1->9
     * return không , một ,.... ,chín
     */
    NSArray *str = [NSArray arrayWithObjects:@"không",@"một",@"hai",@"ba",@"bốn",@"năm",@"sáu",@"bảy",@"tám",@"chín",nil];
    _number = _number%10;
    return [str objectAtIndex:_number];
}
-(NSString *) readNumber:(int) _number andFlag:(bool) flag
{
    /*
     * read numbers less than 1000
     * flag = true =>has "không trăm"
     *
     * int abc return a trăm b mươi c
     * int a0c return a trăm linh c
     * int a00 return a trăm
     * int bc return b mươi c
     * int b0 return b mươi
     * int 1c return mười c
     int c rturn c
     */
    _number = _number%1000;
    if (_number == 0)
    {
        return @"";
    }
    
    NSString *result = @"";
    int tram = _number/100;
    int chuc = (_number%100)/10;
    int dv = (_number%100)%10;
    if (tram != 0) { // if >=100
        result = [NSString stringWithFormat:@"%@ trăm",[self numberString:tram]];
        if (chuc != 0)
        { //312 , 123 ,121.....
            if (chuc==1)
                result = [NSString stringWithFormat:@"%@ mười",result];
            else
                result = [NSString stringWithFormat:@"%@ %@ mươi",result,[self numberString:chuc]];
            
            if (dv != 0)
                result = [NSString stringWithFormat:@"%@ %@",result,[self numberString:dv]];
            
        }else
        {// 102 203 304
            if (dv != 0)
                result = [NSString stringWithFormat:@"%@ linh %@",result,[self numberString:dv]];
        }
    }
    else
    { //if < 100
        result = flag ? @"không trăm" :@"";
        if (chuc != 0)
        { // if >= 10
            if (chuc==1)
                result = [NSString stringWithFormat:@"%@ mười",result];
            else
                result = [NSString stringWithFormat:@"%@ %@ mươi",result,[self numberString:chuc]];
        }
        if (dv != 0)
            result = [NSString stringWithFormat:@"%@ %@",result,[self numberString:dv]];
    }
    return [result stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
-(NSString*) toString
{
    NSString * tem = [[NSUserDefaults standardUserDefaults] objectForKey:LANGUAGE];
    AppDelegate * app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSString * currentL = [[app dicLaguage] objectForKey:tem];
    if ([currentL isEqualToString:@"en"])
        return [self formatCurrencyE:self.currencyValue];
    else
        return [self formatCurrencyV];
}
-(void)dealloc
{
    [currencyValue release];
    [super dealloc];
}
-(NSString * ) formatCurrencyV
{
    /*
     * return string of currency
     */
    if (!self.valid)
        return @"";
    NSString * number = [self getCurrencyFomat];
    if (number == nil || [number.trim isEqualToString:@"0"] || number.trim.length == 0)
    {
        return @"Không đồng";
    }
    
    NSString *result = @"";
    NSArray *ti_trieu_nghin = [NSArray arrayWithObjects:@"",@"nghìn",@"triệu",@"tỷ",@"nghìn tỷ",@"tỷ tỷ",@"tỷ tỷ tỷ",@"tỷ tỷ tỷ tỷ",@"tỷ tỷ tỷ tỷ tỷ",nil];
    number = [number stringByReplacingOccurrencesOfString:@"." withString:@","];
    
    NSArray * arrSeparator = [number componentsSeparatedByString:@","];
    for (int i=0; i<arrSeparator.count;i++) {
        if (i > ti_trieu_nghin.count-1 || arrSeparator.count-i> ti_trieu_nghin.count) {
            //NSLog(@"breakkkkkkkk : %d",arrSeparator.count);
            break;
        }
        //int abc = a trăm b mươi c
        NSString *readNumber = [self readNumber:[[arrSeparator objectAtIndex:i] intValue] andFlag:(i!=0)];
        if ([readNumber isEqualToString:@""] == NO)
        {
            //            NSString *separator = i != arrSeparator.count - 1 ? @" ," : @"";
            NSString *separator = i != arrSeparator.count - 1 ? @"" : @"";
            if (result == nil)
                result = [NSString stringWithFormat:@"%@ %@%@",readNumber,[ti_trieu_nghin objectAtIndex:(arrSeparator.count-i-1)],separator];
            else
                result = [NSString stringWithFormat:@"%@ %@ %@%@",result,readNumber,[ti_trieu_nghin objectAtIndex:(arrSeparator.count-i-1)],separator];
            //NSLog(@"------------%d--------",arrSeparator.count-i-1);
        }
    }
    result = [NSString stringWithFormat:@"%@ đồng",[result trim]];
    result = [result stringByReplacingOccurrencesOfString:@"mươi một" withString:@"mươi mốt"];
    result = [result stringByReplacingOccurrencesOfString:@"mươi năm" withString:@"mươi lăm"];
    result = [result stringByReplacingOccurrencesOfString:@"mười năm" withString:@"mười lăm"];
    
    result = result.trim;
    NSString *cappedString = result.upperCaseFirstChar;
    return cappedString ;//[result capitalizedString];
}
-(NSString * ) formatCurrencyE:(NSString *) mynumber
{
    NSString * temp = @"";
    int nCount = 1;
    while (mynumber.length != 0) {
        if (mynumber.length > 3) {
            NSString * sub = [mynumber substringWithRange:NSMakeRange(mynumber.length - 3, 3)];
            if ([((NSString *)[NSString stringWithFormat:@"%c", [sub characterAtIndex:0]]) isEqualToString:@"0"] &&
                ![((NSString *)[NSString stringWithFormat:@"%c", [sub characterAtIndex:1]]) isEqualToString:@"0"]) {
                temp = [NSString stringWithFormat:@"%@ and %@ %@",[self place:nCount], [self getHundreds:[sub substringWithRange:NSMakeRange(1, 2)]], temp];
            }
            else
            {
                temp = [NSString stringWithFormat:@"and %@ %@ %@", [self getHundreds:sub],[self place:nCount], temp];
                
                if ([sub isEqualToString:@"000"]) {
                    temp = @"";
                }
            }
            mynumber = [mynumber substringToIndex:mynumber.length - 3];// sub 3
            
        }
        else
        {
            temp = [NSString stringWithFormat:@"%@ %@ %@" ,[self getHundreds:mynumber],[self place:nCount], temp];
            mynumber = @"";
        }
        nCount ++;
    }
    //    temp = [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return temp.trim.upperCaseFirstChar;
}
-(NSString *) place:(int) n
{
    NSString * data = nil;
    switch (n) {
        case 2:
            data = @"thousand";
            break;
        case 3:
            data = @"million";
            break;
        case 4:
            data = @"billion";
            break;
        case 5:
            data = @"trillion";
            break;
        default:
            data = @"";
            break;
    }
    return data;
}
-(NSString * ) getHundreds:(NSString *) mynumber
{
    NSString * data = nil;
    if ([mynumber integerValue] == 0) {
        return @"";
    }
    else if ([mynumber integerValue] <= 10) {
        return [self getDigit:mynumber ];
    }
    else if ([mynumber integerValue] < 100 && [mynumber integerValue] > 10) {
        return [self getTens:mynumber ];
    }
    //Convert the hundreds place.
    
    NSString * hundred = [NSString stringWithFormat:@"%c", [mynumber characterAtIndex:0]];
    NSString * temp = [self getDigit:hundred];
    data = [NSString stringWithFormat:@"%@ %@", temp , @"hundred"];
    NSString * hundred1 = [NSString stringWithFormat:@"%c", [mynumber characterAtIndex:1]];
    NSString * hundred2 = [NSString stringWithFormat:@"%c", [mynumber characterAtIndex:2]];
    
    if (![hundred1 isEqualToString:@"0"]) {
        NSString * a = [mynumber substringWithRange:NSMakeRange(1, 2)];
        NSString * temp1 = [self getTens:a];
        data = [NSString stringWithFormat:@"%@ and %@", data , temp1];
    }
    else if ([hundred1 isEqualToString:@"0"] && ![hundred2 isEqualToString:@"0"])
    {
        NSString * temp2 = [self getDigit:[mynumber substringWithRange:NSMakeRange(2, 1)]];
        data = [NSString stringWithFormat:@"%@ and %@", data , temp2];
    }
    else
    {
        //        NSString * a = [mynumber substringWithRange:NSMakeRange(1, 2)];
        //        NSString * temp1 = [self getTens:a];
        data = [NSString stringWithFormat:@"%@", data];
    }
    return  data;
}

-(NSString * ) getTens:(NSString *) tensText
{
    NSString * data = nil;
    NSString *string = [NSString stringWithFormat:@"%c",[tensText characterAtIndex:0]];
    
    if([string isEqualToString:@"1"])
    {
        switch ([tensText integerValue]) {
            case 10:
                data = @"ten";
                break;
            case 11:
                data = @"eleven";
                break;
            case 12:
                data = @"twelve";
                break;
            case 13:
                data = @"thirteen";
                break;
            case 14:
                data = @"fourteen";
                break;
            case 15:
                data = @"fifteen";
                break;
            case 16:
                data = @"sixteen";
                break;
            case 17:
                data = @"seventeen";
                break;
            case 18:
                data = @"eighteen";
                break;
            case 19:
                data = @"nineteen";
                break;
            default:
                break;
        }
        return data;
    }
    else
    {
        switch ([string integerValue]) {
            case 2:
                data = @"twenty";
                break;
            case 3:
                data = @"thirty";
                break;
            case 4:
                data = @"forty";
                break;
            case 5:
                data = @"fifty";
                break;
            case 6:
                data = @"sixty";
                break;
            case 7:
                data = @"seventy";
                break;
            case 8:
                data = @"eighty";
                break;
            case 9:
                data = @"ninety";
                break;
            default:
                break;
        }
        NSString * dv = [NSString stringWithFormat:@"%c",[tensText characterAtIndex:1]];
        data = [NSString stringWithFormat:@"%@ %@", data,[self getDigit:dv]];
        return data;
    }
    
}


-(NSString *) getDigit:(NSString*) digit
{
    NSString * data = nil;
    switch ([digit integerValue]) {
        case 1:
            data = @"one";
            break;
        case 2:
            data = @"two";
            break;
        case 3:
            data = @"three";
            break;
        case 4:
            data = @"four";
            break;
        case 5:
            data = @"five";
            break;
        case 6:
            data = @"six";
            break;
        case 7:
            data = @"seven";
            break;
        case 8:
            data = @"eight";
            break;
        case 9:
            data = @"nine";
            break;
        case 10:
            data = @"ten";
            break;
        default:
            data = @"";
            break;
    }
    
    return data;
}

@end
