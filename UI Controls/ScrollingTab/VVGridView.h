//
//  VVGridView.h
//  VVGridView
//
//  Created by Chung NV on 2/28/13.
//  Copyright (c) 2013 ViViet. All rights reserved.
//


#import <UIKit/UIKit.h>
@protocol GridViewDelegate;
@protocol GridViewDataSource;

@interface VVGridView : UIView

#pragma mark - Properties
@property (nonatomic,retain) IBOutlet id<GridViewDelegate>     delegate;
@property (nonatomic,retain) IBOutlet id<GridViewDataSource>   datasource;

@property (nonatomic,readonly)        UIView                 * selectedView;
@property (nonatomic,readonly)        NSUInteger               selectedIndex;


#pragma mark - Public Method
-(void) reloadGridView;
@end






#pragma mark - Delegate && Datasource

@protocol GridViewDelegate <UITableViewDelegate>

@optional
-(void) gridView:(VVGridView*) gridView_ didSelectCellAtIndex:(NSInteger) index;

@end


@protocol GridViewDataSource <NSObject>

@required
/*
 * number CELLs of GridView
 */
-(NSUInteger) gridViewNumberCells    :(VVGridView*) gridView_;

/*
 * VIEW for CELL at index
 */
-(UIView*)    gridView:(VVGridView*) gridView_ 
    viewForCellAtIndex:(NSUInteger) index;

@optional
/*
 * number CELLs in a ROW
 * Default : return 3
 */
-(NSUInteger) gridViewNumberCellsInRow:(VVGridView*) gridView_;

/*
 *  Height of a CELL
 *  Default : return 100.0f
 */
-(CGFloat)    gridViewHeightOfCell   :(VVGridView*) gridView_;

@end


@interface UIView(GridViewExtend)



@end

#define kNUMBER_CELL_IN_ROW_DEFAULT 3
#define kHEIGHT_OF_CELL_DEFAULT     100.0f
#define kPADDING_BOTTOM_DEFAULT     10.0f



