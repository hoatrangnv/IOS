//
//  DemoImageSource.h
//  Universe
//
//  Created by Ngo Ba Thuong on 2/12/14.
//  Copyright (c) 2014 Universe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Universe/Universe.h>

@interface DemoImageSource : NSObject <UniImageSource>

- (id)initWithURL:(NSString *)url;
- (id)initWithImage:(UIImage *)img;

@end
