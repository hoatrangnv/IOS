//
//  Currency.h
//  Curency
//
//  Created by MAC on 7/20/12.
//  Copyright (c) 2012 Ngo Ba Thuong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Currency : NSObject
@property(nonatomic,copy) NSString* currencyValue;
@property bool valid;

-(id) initWithCurrencyValue:(long long int) _value;
-(id) initWithCurrencyValueString:(NSString*) _valueString;

-(NSString *) getCurrencyFomat;
-(NSString*) toString;

+(NSString *) numberFromFormattedString:(NSString *) str;
+(NSString *) formatNumber:(id) str;
+(NSString *) wordsForNumber:(NSString *) str;

@end
