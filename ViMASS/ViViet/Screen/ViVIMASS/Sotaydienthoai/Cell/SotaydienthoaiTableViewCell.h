

#import <UIKit/UIKit.h>
@protocol SotaydienthoaiTableViewCell<NSObject>
- (void)actionDelete:(NSString*)nameDelete andIdGiaoDich:(NSString*)idGiaodich;
- (void)actionEdit:(NSString*)nameEdit andIdGiaoDich:(NSString*)idGiaodich;
@end
@interface SotaydienthoaiTableViewCell : UITableViewCell
@property (nonatomic,retain) id<SotaydienthoaiTableViewCell> delegate;
@property (retain, nonatomic) NSIndexPath*indexPath;
@property (retain, nonatomic) IBOutlet UIImageView *imgBottom;
@property (retain, nonatomic) IBOutlet UILabel *lblTitle;
@property (retain, nonatomic) IBOutlet UIImageView *iconLogo;
@property (retain, nonatomic) NSString *idGiaodich;
- (void)setHiddenBottomLine:(BOOL)isHidden;
@end
