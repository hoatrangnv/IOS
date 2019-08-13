//
//  DemoImageSource.m
//  Universe
//
//  Created by Ngo Ba Thuong on 2/12/14.
//  Copyright (c) 2014 Universe. All rights reserved.
//

#import "DemoImageSource.h"
#import "SDWebImageManager.h"

@interface DemoImageSource ()
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, copy) NSString *url;
@end

@implementation DemoImageSource
{
    UIImage *_image;
    NSString *_url;
    id _download_operation;
}

- (void)get_image
{
    [self download_image];
}

- (void)download_image
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    __block DemoImageSource *SELF = self;
    
    _download_operation = [manager downloadImageWithURL:[NSURL URLWithString:_url] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        if ([SELF.delegate respondsToSelector:@selector(UniImageSource:available_data_length:total_length:)])
        {
            [SELF.delegate UniImageSource:SELF available_data_length:(int)receivedSize total_length:(int)expectedSize];
        }
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (image == nil)
        {
            if ([SELF.delegate respondsToSelector:@selector(UniImageSource_download_failed:)])
            {
                [SELF.delegate UniImageSource_download_failed:SELF];
            }
            return;
        }
        SELF.image = image;
        if ([SELF.delegate respondsToSelector:@selector(UniImageSource_download_completed:)])
        {
            [SELF.delegate UniImageSource_download_completed:SELF];
        }
    }];
    
//    _download_operation = [manager downloadWithURL:[NSURL URLWithString:_url]
//                                           options:0
//                                          progress:^(NSUInteger receivedSize, long long expectedSize)
//                           {
//                               NSLog(@"downloaded %lu", (unsigned long)receivedSize);
//                               if ([SELF.delegate respondsToSelector:@selector(UniImageSource:available_data_length:total_length:)])
//                               {
//                                   [SELF.delegate UniImageSource:SELF available_data_length:(int)receivedSize total_length:(int)expectedSize];
//                               }
//                           }
//                                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
//                           {
//                               if (image == nil)
//                               {
//                                   if ([SELF.delegate respondsToSelector:@selector(UniImageSource_download_failed:)])
//                                   {
//                                       [SELF.delegate UniImageSource_download_failed:SELF];
//                                   }
//                                   return;
//                               }
//                               
//                               SELF.image = image;
//                               if ([SELF.delegate respondsToSelector:@selector(UniImageSource_download_completed:)])
//                               {
//                                   [SELF.delegate UniImageSource_download_completed:SELF];
//                               }
//                           }];
    [_download_operation retain];
}

- (id)initWithURL:(NSString *)url
{
    if (self = [super init])
    {
        self.url = url;
        //        [self download_image];
    }
    return self;
}

- (id)initWithImage:(UIImage *)img
{
    if (self = [super init])
    {
        self.image = img;
    }
    return self;
}

- (BOOL)available
{
    return _image != nil;
    
}

- (void)dealloc
{
    NSLog(@"******** DEALLOC %@", NSStringFromClass([self class]));
    [_download_operation cancel];
    [_download_operation release];
    
    self.image = nil;
    self.url = nil;
    
    
    [super dealloc];
}

@synthesize image = _image;
@synthesize url = _url;
@synthesize delegate;

@end
