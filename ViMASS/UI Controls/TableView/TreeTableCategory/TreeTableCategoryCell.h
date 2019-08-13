//
//  TreeTableCategoryCell.h
//  ViMASS
//
//  Created by Chung NV on 5/30/13.
//
//

#import <UIKit/UIKit.h>
#import "SVCategory.h"

@interface TreeTableCategoryCell : UITableViewCell
{
    @public
    IBOutlet UIImageView *bg;
    IBOutlet UILabel *lblName;
    IBOutlet UIButton *btTick;
}
@property (nonatomic, retain) SVCategory *category;

- (IBAction)btTick_Clicked;
@end
