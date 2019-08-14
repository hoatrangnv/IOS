//
//  Localization.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 3/4/19.
//

#import <Foundation/Foundation.h>
#import "LocalizationHeader.h"
@interface Localization : NSObject
+ (Localization *)sharedInstance;
+ (NSString*) strSelectLanguage:(int)curLang;
+ (NSString*) languageSelectedStringForKey:(NSString*) key;
+ (int)getCurrentLang;
@end
