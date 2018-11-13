

#import <UIKit/UIKit.h>
#import "RadioButton.h"
@class ChonAnSauDtTableViewCell;
@protocol ChonAnSauDtTableViewCellDelegate<NSObject>
-(void)actionSelect:(ChonAnSauDtTableViewCell*)cell;
@end
@interface ChonAnSauDtTableViewCell : UITableViewCell
@property (retain, nonatomic) id<ChonAnSauDtTableViewCellDelegate>delegate;
@property (retain, nonatomic) IBOutlet UILabel *lblTitle;
@property (retain, nonatomic) IBOutlet UIImageView *lblLogo;
@property (retain, nonatomic) IBOutlet RadioButton *btnSelect;

@end
