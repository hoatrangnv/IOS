//
//  UniListView.h
//  iRSS
//
//  Created by Ngo Ba Thuong on 10/19/13.
//  Copyright (c) 2013 CMC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UniListView;

@protocol UniListViewDelegate <UIScrollViewDelegate, NSObject>

- (UIView *)UniListView:(UniListView *)scrv viewAtIndex:(int)index;
- (int)numberOfItemInUniListView:(UniListView *)scrv;

@optional
- (CGFloat)UniListView:(UniListView *)scrv itemWidthAtIndex:(int)index;

@end

@interface UniListView : UIScrollView<UIScrollViewDelegate>
{
    NSMutableArray *recycled_views;
    id<UniListViewDelegate> delegate;
}

@property (nonatomic, assign) IBOutlet id<UniListViewDelegate> delegate;
@property (nonatomic, assign) CGFloat item_width;
@property (nonatomic, assign) BOOL smoothloading;

/**
 *
 * Return recycled view to increase performance.
 *
 */
- (UIView *)recycled_view;
/**
 *
 * Scroll to view at index item + offset.
 *
 * @param item Index of item will be scrolled to. The item will stop at left side of this view.
 * @param offset Additional distance will be scrolled to.
 *
 */
- (void)scroll_to_item:(int)item offset:(CGFloat)offset animate:(BOOL)animate;
/**
 *
 * Reload the list.
 *
 */
- (void)reload;

@end
