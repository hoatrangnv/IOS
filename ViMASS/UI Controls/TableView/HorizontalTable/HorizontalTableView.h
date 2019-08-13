//
//  HorizontalTableView.h
//  Test_HorizontalTable
//
//  Created by Chung NV on 2/15/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface HorizontalTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, copy) NSString *cellClass;

@property (nonatomic, retain) NSMutableArray *datas;
@property (nonatomic, assign) CGFloat rowWidth;
@property (nonatomic, assign) BOOL makeCellFull;

- (void)set_update_more_handle:(void (^)(HorizontalTableView *table))update_more_callback;

/*
 *  When user select a Row : _block is called;
 */
- (void)didSelectedRow:(void(^)(id object)) didSelectedRow;

/*
 *  Will dragging scroll table : _block is called;
 */
- (void)willBeginDragging:(void(^)(HorizontalTableView *table)) willBeginDragging;


/*
 *  When user end dragging scroll table : _block is called;
 */
- (void)didEndDragging:(void(^)(HorizontalTableView *table)) didEndDragging;

/*  When table scroll by CODING
 *      + ex : [table scrollToOffset...]
 *  ==> block is called!
 */
- (void)didScrollEndAnimation:(void(^)(HorizontalTableView *table)) didScrollEndAnimation;

-(void) insertMoreData:(NSArray *)moreData;


-(void) scrollingWithVelocity:(CGPoint)velocity
          targetContentOffset:(inout CGPoint *)targetContentOffset;
@end
