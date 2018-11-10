

#import <UIKit/UIKit.h>
@protocol SotaydienthoaiTableViewCell<NSObject>
- (void)actionDelete:(NSString*)nameDelete;
- (void)actionEdit:(NSString*)nameEdit;
@end
@interface SotaydienthoaiTableViewCell : UITableViewCell
@property (nonatomic,retain) id<SotaydienthoaiTableViewCell> delegate;
@property (retain, nonatomic) NSIndexPath*indexPath;
@property (retain, nonatomic) IBOutlet UIImageView *imgBottom;
@property (retain, nonatomic) IBOutlet UILabel *lblTitle;
@property (retain, nonatomic) IBOutlet UIImageView *iconLogo;

- (void)setHiddenBottomLine:(BOOL)isHidden;
@end
