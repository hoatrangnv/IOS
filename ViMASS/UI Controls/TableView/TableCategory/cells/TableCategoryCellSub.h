//
//  TableCategoryCellSub.h
//  ViMASS
//
//  Created by Chung NV on 7/4/13.
//
//

#import <UIKit/UIKit.h>
#import "SVCategory.h"
@interface TableCategoryCellSub : UITableViewCell
{
    IBOutlet UILabel *lblName;
    IBOutlet UIButton *btTick;
}
-(void)setTick;
@property (nonatomic, retain) SVCategory *category;


@end
