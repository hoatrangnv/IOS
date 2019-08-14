//
//  ExScrollSlide.h
//  Test
//
//  Created by Chung NV on 2/11/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ScrollingMenu;
@protocol ExScrollSlideDelegate <UIScrollViewDelegate>

-(void) exScrollViewSelectedChanged:(ScrollingMenu*) exScrollView_;

@end

@interface ScrollingMenu : UIScrollView
{
    NSMutableArray            * views;
    UIImageView               * imgViewIcon;
    
    BOOL                        isFirstFill;
    float                       lblHeight;
    float                       paddingTop;
}
//@property (nonatomic,strong)    NSMutableArray            * views;
@property (nonatomic,assign)    id<ExScrollSlideDelegate>   delegate;
@property (nonatomic,readonly)  UIView                    * currentItem;
@property (nonatomic, assign)           int                         currentIndex;

@property (nonatomic,retain)    UIColor                   * textColor;
@property (nonatomic,retain)    UIColor                   * textColorSelected;
@property (nonatomic,retain)    UIImage                   * iconImage;
@property (nonatomic)           float                       padding;
@property (nonatomic,retain)    UIFont                    * font;


-(void) setSelectedIndex:(int) _index 
                animated:(BOOL) animated;

-(UIView*) getItemAtIndex:(int) _index;

-(void) insertItem:(id) _item 
           atIndex:(int) _atIndex;


-(void) fillItems:(NSArray*) _items;
/*
 * remove Item at _atIndex
 */
-(void) removeItemAtIndex:(NSUInteger) _atIndex;

/*
 *  remove Items from _fromIndex to _toIndex 
 *  if _fromIndex > _toIndex => NOT do anything
 */
-(void) removeItemFromIndex:(NSUInteger)_fromIndex 
                    toIndex:(NSUInteger) _toIndex;

/*
 * remove from index = 0 to _toIndex
 */
-(void) removeItemToIndex:(NSUInteger) _toIndex;

/*
 * remmove from _fromIndex to lastIndex
 */
-(void) removeItemFromIndex:(NSUInteger) _fromIndex;
@end


@interface UIButton(ScollerMenu)
+(UIButton*) createDefaultButton:(NSString*) title;
@end