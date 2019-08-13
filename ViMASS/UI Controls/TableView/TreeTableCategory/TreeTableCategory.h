//
//  TreeTableCategory.h
//  ViMASS
//
//  Created by Chung NV on 6/13/13.
//
//

#import <UIKit/UIKit.h>

@interface TreeTableCategory : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) NSArray * datas;

-(NSArray *) getSelectedCategories;
-(void) didSelectedRow:(void(^)(id objectSelected)) didSelectedRow;

@end
