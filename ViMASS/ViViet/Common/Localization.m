//
//  Localization.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 3/4/19.
//

#import <Foundation/Foundation.h>
#import "Localization.h"

int currentLanguage,selectedrow;
@implementation Localization

+ (Localization *)sharedInstance
{
    static Localization *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Localization alloc] init];
    });
    return sharedInstance;
}


+ (NSString*) strSelectLanguage:(int)curLang{
    if(curLang == VIET){
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"vi", nil]forKey:@"AppleLanguages"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"en", nil]forKey:@"AppleLanguages"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    currentLanguage = curLang;
    NSString *strLangSelect = [[[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"] objectAtIndex:0];
    return strLangSelect;
}

+ (NSString*) languageSelectedStringForKey:(NSString*) key
{
    NSString *path;
    NSString *strSelectedLanguage = [[[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"] objectAtIndex:0];
    //When we check with iPhone,iPad device it shows "en-US".So we need to change it to "en"
    if([strSelectedLanguage hasPrefix:@"en-"])
        strSelectedLanguage = [strSelectedLanguage stringByReplacingOccurrencesOfString:@"en-US" withString:@"en"];
    if([strSelectedLanguage isEqualToString:[NSString stringWithFormat: @"en"]]){
        currentLanguage = ENGLISH;
        selectedrow = ENGLISH;
        path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
    }
    else{
        currentLanguage = VIET;
        selectedrow = VIET;
        path = [[NSBundle mainBundle] pathForResource:@"vi" ofType:@"lproj"];
    }
    NSBundle* languageBundle = [NSBundle bundleWithPath:path];
    NSString* str=[languageBundle localizedStringForKey:key value:@"" table:@"Localizable"];
    return str;
}

+ (int)getCurrentLang {
    return currentLanguage;
}
@end
