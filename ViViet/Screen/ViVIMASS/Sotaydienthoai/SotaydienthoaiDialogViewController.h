

#import <UIKit/UIKit.h>
#import "GiaoDichViewController.h"

@protocol SotaydienthoaiDialogViewControllerDelegate <NSObject>
- (void)actionDeleleSotay:(NSString*)parameter;
- (void)actionEditSotay:(NSString*)parameter;
@end
@interface SotaydienthoaiDialogViewController : GiaoDichViewController
@property (nonatomic, strong) id<SotaydienthoaiDialogViewControllerDelegate> delegate;
@property (assign, nonatomic) BOOL *isDelete;

- (void)showPopupDelete;
- (void)showPopupEdit;
- (void)setTextNameInput:(NSString*)text;
- (void)setNameDelete:(NSString*)text;
@end
