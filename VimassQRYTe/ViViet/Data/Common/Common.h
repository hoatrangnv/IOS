//
//  Common.h
//  ViVietApp
//
//  Created by QUANGHIEP on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import <Foundation/Foundation.h>
@interface Common : NSObject
+ (NSDictionary * ) getLaguages:(NSString *) _lagName;
+ (NSString *) giaiMaDataToString:(NSData *) data;
+ (NSData *) maHoaStringToData:(NSString *) string;
+ (NSString *) getKeyMaHoa;
+ (NSString *)toMD5:(NSString *)source;
@end
