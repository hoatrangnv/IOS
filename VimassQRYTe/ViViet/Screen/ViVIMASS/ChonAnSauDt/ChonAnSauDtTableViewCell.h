

#import <UIKit/UIKit.h>
#import "RadioButton.h"
@class ChonAnSauDtTableViewCell;
@protocol ChonAnSauDtTableViewCellDelegate<NSObject>
-(void)actionSelect:(NSDictionary*)dicData;
@end
@interface ChonAnSauDtTableViewCell : UITableViewCell
@property (retain, nonatomic) id<ChonAnSauDtTableViewCellDelegate>delegate;
@property (retain, nonatomic) IBOutlet UILabel *lblTitle;
@property (retain, nonatomic) IBOutlet UIImageView *lblLogo;
@property (retain, nonatomic) IBOutlet RadioButton *btnSelect;
@property (retain, nonatomic) NSDictionary * dicData;
- (void)setDataForCell:(NSDictionary*)dic;
- (void)dataSelected:(BOOL)selected;
@end
