//
//  ScrollPaginate.h
//  Test
//
//  Created by Chung NV on 2/7/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollingMenu.h"

@class ScrollingTab;
@protocol ScrollingTabDatasource <NSObject>

@required
-(NSUInteger) numberTabOfScrollingTab:(ScrollingTab*) scrollPage_;

-(id)scrollingTab:(ScrollingTab*) _scrollingTab 
 tapHeaderAtIndex:(NSUInteger) index_;

-(UIView*)scrollingTab:(ScrollingTab*) _scrollingTab 
        tapViewAtIndex:(NSUInteger) index_;
@optional
-(CGFloat)heightForHeaderOfScrollingTab:(ScrollingTab*) _scrollingTab;

@end

@protocol ScrollingTabDelegate <NSObject>



@end


@interface ScrollingTab : UIView<UIScrollViewDelegate,ExScrollSlideDelegate>
{
    NSMutableArray * pageViews;
    UIScrollView   * scrollView;
    ScrollingMenu   * titleScroll;
}
@property (nonatomic,assign)  IBOutlet id<ScrollingTabDatasource> datasource;
@property (nonatomic,assign)  IBOutlet id<ScrollingTabDelegate>   delegate;

@property (nonatomic,assign)         NSUInteger    currentPage;
@property (nonatomic,readonly)         NSUInteger    numberPages;

-(void) goToTap:(NSUInteger) _pageNumber 
        animated:(BOOL)animated;
-(void) goToTapView:(UIView*) _tapView 
           animated:(BOOL) _animated;

-(UIView*) tapViewAtIndex:(NSUInteger) _indexPage;
-(int)     indexOfTap:(UIView*) pageView;


-(void)insertTapView:(UIView*) _tapView 
           tapHeader:(id) _tapHeader  
             atIndex:(NSUInteger) _atIdx;

-(void) insertTapView:(UIView *)_tapView 
            tapHeader:(id)_tapHeader
             afterTap:(UIView*)afterTap;

-(void) insertTapView:(UIView *)_tapView 
            tapHeader:(id)_tapHeader
            beforeTap:(UIView*)beforeTap;

/*
 * remove Page at _atIndex
 */
-(BOOL) removePageAtIndex:(NSUInteger) _atIndex;

/*
 *
 */
-(void) removeTapView:(UIView*) _tapView;
/*
 *
 */
-(void) removeTapViews:(NSArray*) _tapViews;


/*
 *  remove Pages from _fromIndex to _toIndex 
 *  if _fromIndex > _toIndex => NOT do nothing
 */
-(BOOL) removePageFromIndex:(NSUInteger)_fromIndex 
                    toIndex:(NSUInteger) _toIndex;

/*
 * remove from index = 0 to _toIndex
 */
-(BOOL) removePageToIndex:(NSUInteger) _toIndex;

/*
 * remmove from _fromIndex to lastIndex
 */
-(BOOL) removePageFromIndex:(NSUInteger) _fromIndex;

-(NSMutableArray*) pageViews;

@end
