//
//  TableCategory.h
//  ViMASS
//
//  Created by Chung NV on 6/27/13.
//
//

#import <UIKit/UIKit.h>
#import "SVCategory.h"

@class TableCategory;
@protocol TableCategoryDelegate <NSObject>

-(BOOL)tableCategory:(TableCategory *) table willSelectCategory:(SVCategory *)cate;

@end

@interface TableCategory : UIView<UITableViewDataSource,UITableViewDelegate>
{
    void (^_didSelectedChanged)(TableCategory *tblCate);
    
    @public
    NSMutableArray * selected_parent;
}
-(TableCategory *) initWithFrame:(CGRect) rect
               isSingleSelection:(BOOL) singleSelection;

@property (nonatomic, assign) int mKieuHienThiTimKiem;
@property (nonatomic, retain) NSArray *categories;
@property (nonatomic, assign) BOOL isSingleSelection;
@property (nonatomic, assign) IBOutlet id<TableCategoryDelegate> delegate;


-(void)didSelectedChanged:(void(^)(TableCategory *tblCate)) didChanged;
-(NSMutableArray *) getSelectedCateIDs;
-(NSArray *) selected_cate_IDs;
- (NSDictionary *)getSelectedCategory;

-(NSArray *) selected_categories;

-(void) setSelectedCateIDs:(NSString *) cateIds;

@end

