//
//  TableCategoryCellViewController.h
//  ViMASS
//
//  Created by Chung NV on 6/28/13.
//
//

#import <UIKit/UIKit.h>
#import "SVCategory.h"

@interface TableCategoryCell : UITableViewCell
{
    IBOutlet UILabel *lblName;
    
    @public
    IBOutlet UIView *wrapper;
    IBOutlet UIButton *btTick;
    IBOutlet UIButton *btRemove;
    IBOutlet UIButton *btCount;
}
@property (nonatomic, retain) SVCategory *category;
-(void)setTick;

- (IBAction)btTickClicked:(id)sender;
@end
