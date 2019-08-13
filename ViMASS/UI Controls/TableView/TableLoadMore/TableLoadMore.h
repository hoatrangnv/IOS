//
//  TableLoadMore.h
//  ViMASS
//
//  Created by Chung NV on 6/10/13.
//
//

#import <UIKit/UIKit.h>
#import "TableLoadMoreCell.h"

@interface TableLoadMore : UITableView<UITableViewDataSource,UITableViewDelegate>
{
    void (^didBeginReload)();
    void (^didBeginLoadMore)();
    void (^didSelectedRow)(id dataSelected);
    void (^didScrolling)();
}

@property (nonatomic, assign) id cellDelegate;
@property (nonatomic,copy) NSString * cellClass;
@property (nonatomic,retain) NSMutableArray *datas;
@property (nonatomic, assign) BOOL isSelectedBackground;

-(void) stopAnimating_reload;
-(void) stopAnimating_load_more;

-(void) didSelectedRow:(void(^)(id dataSelected)) selectedRow;
-(void) didBeginReload:(void(^)()) beginReload;
-(void) didBeginLoadMore:(void(^)()) beginLoadMore;
-(void) didScrolling:(void(^)()) didScrolling;

-(void) insertMoreData:(NSArray *) moreData;
-(void)insertMoreData:(NSArray *)moreData animated:(BOOL) animated;
@end
