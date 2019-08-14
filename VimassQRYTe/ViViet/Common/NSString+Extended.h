//
//  NSString+Extended.h
//  ViMASS
//
//  Created by QUANGHIEP on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extended)
- (BOOL) likeString:(NSString *) likeString;
- (BOOL) isEmpty;
- (NSString *) trim;
- (NSString *) urlencode;
- (NSString *) localizableString;
- (NSString *) upperCaseFirstChar;

- (NSString *) md5;
- (NSString *) md5_3;
- (NSString *) sha1;
- (NSData *) sha256;

- (NSString *)isHexString;
- (NSData *) hexData;

- (NSString *)bo_dau_tieng_viet;

// Return true if match with the regular expression
- (BOOL)match_with_exp:(NSString *)reg;

-(BOOL) isYoutubeVideo;
-(BOOL) isHTTP;

@end
