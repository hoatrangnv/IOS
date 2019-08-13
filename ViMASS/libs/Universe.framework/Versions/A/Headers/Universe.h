//
//  Universe.h
//  Universe
//
//  Created by Ngo Ba Thuong on 6/12/13.
//  Copyright (c) 2013 Universe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniTextField.h"
#import "UniImageSource.h"
#import "UniImageView.h"
#import "UniListView.h"

#pragma mark - UIImage

@interface UIImage (Uni)

+ (UIImage *)initWithSize:(CGSize)size drawing:(void (^)(CGContextRef ctx, CGSize size))drawing;

@end

@interface Universe : NSObject

+ (NSString *)version;

@end
