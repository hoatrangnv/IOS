//
//  CommonUtils.h
//  ViViMASS
//
//  Created by Mac Mini on 8/6/18.
//

#import <Foundation/Foundation.h>

@interface CommonUtils : NSObject
+ (BOOL)isEmptyOrNull:(NSString*) cached;
+(void)displayImage:(NSURL*)url toImageView:(UIImageView*)imgView placeHolder:(UIImage*)placeholder;
@end
