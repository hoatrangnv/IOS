//
//  UniImageSource.h
//  Universe
//
//  Created by Ngo Ba Thuong on 2/12/14.
//  Copyright (c) 2014 Universe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol UniImageSource;

@protocol UniImageSourceDelegate <NSObject>
@optional
- (void)UniImageSource:(id<UniImageSource>)image available_data_length:(int)length total_length:(int)total;
- (void)UniImageSource_download_completed:(id<UniImageSource>)image;
- (void)UniImageSource_download_failed:(id<UniImageSource>)image;

@end

@protocol UniImageSource <NSObject>

@property (nonatomic, readonly) BOOL available;
@property (nonatomic, readonly) UIImage *image;
@property (nonatomic, assign) id<UniImageSourceDelegate> delegate;

- (void)get_image;

@end