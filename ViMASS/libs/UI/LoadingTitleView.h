//
//  LoadingTitleView.h
//  ViMASS
//
//  Created by Ngo Ba Thuong on 1/12/14.
//
//

#import <UIKit/UIKit.h>

@protocol LoadingTitleViewDelegate <NSObject>

- (void)didSelectBackButton;

@end

@interface LoadingTitleView : UIView

+ (LoadingTitleView *)create;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *loading_title;
@property (nonatomic, assign) id<LoadingTitleViewDelegate> delegate;

@property (nonatomic, readonly) UILabel *title_view;

- (void)start_loading;
- (void)stop_loading;

@end
