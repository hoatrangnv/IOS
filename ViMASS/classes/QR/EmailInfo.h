//
//  EmailInfo.h
//  ViMASS
//
//  Created by Ngo Ba Thuong on 12/13/12.
//
//

#import <Foundation/Foundation.h>

@interface EmailInfo : NSObject

@property (nonatomic, copy) NSString *to;
@property (nonatomic, copy) NSString *cc;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *body;

+ (EmailInfo *)parse:(NSString *) str;
+ (EmailInfo *)parseFromQRCode:(NSString *) str;
- (NSString *) toURL;
- (NSString *) toQRCodeURL;

@end
