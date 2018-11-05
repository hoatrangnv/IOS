//
//  UIView+Localization.h
//  ViMASS
//
//  Created by Ngo Ba Thuong on 8/7/13.
//
//

#import <UIKit/UIKit.h>

@interface UIView (Localization)

@property (nonatomic, retain) NSMutableArray *viewToText;

- (void)localizeViews;
- (void)initAutoLocalizeView;
- (void)localizeView:(UIView *)parentView;

@end
