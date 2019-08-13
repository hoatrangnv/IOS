//
//  UniImageView.h
//  UniImageView
//
//  Created by Ngo Ba Thuong on 27/08/12.
//  Copyright Ngo Ba Thuong 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniImageSource.h"
#import "DACircularProgressView.h"
@class UniImageView;
@protocol UniImageViewDelegate <UIScrollViewDelegate>
@optional
/**
 *
 * User has single tap on this image view.
 *
 */
- (void)didTapOnUniImageView:(UniImageView *)view;

@end

@interface UniImageView : UIScrollView <UIScrollViewDelegate>
{
    UIImageView*    _imageView;
    id<UniImageSource> _source;
}

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) id<UniImageSource> source;
@property (nonatomic, assign) id<UniImageViewDelegate> delegate;
@property (nonatomic, readonly) DACircularProgressView *progress_view;

@end

