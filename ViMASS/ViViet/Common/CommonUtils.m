//
//  CommonUtils.m
//  ViViMASS
//
//  Created by Mac Mini on 8/6/18.
//

#import "CommonUtils.h"

@implementation CommonUtils
#pragma mark STRING UTILITYS
+ (BOOL)isEmptyOrNull:(NSString*) cached
{
    if ([cached class] == [NSNull class] || cached == Nil || [cached isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    NSString* trim = [cached stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([trim length] == 0) {
        return YES;
    }
    return NO;
}
+(void)displayImage:(NSURL*)url toImageView:(UIImageView*)imgView placeHolder:(UIImage *)placeholder{
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: url];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ( data == nil )
                imgView.image = placeholder;
            else{
                imgView.image = [UIImage imageWithData: data];
            }
        });
        [data release];
    });
}
@end
