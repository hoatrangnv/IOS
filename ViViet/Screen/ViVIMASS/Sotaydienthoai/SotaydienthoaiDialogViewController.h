

#import <UIKit/UIKit.h>
#import "GiaoDichViewController.h"

@protocol SotaydienthoaiDialogViewControllerDelegate <NSObject>
- (void)actionDeleleSotay:(NSString*)parameter andCode:(int)nCode andMessage:(NSString*)sThongBao;
- (void)actionEditSotay:(NSString*)parameter andCode:(int)nCode andMessage:(NSString*)sThongBao;
@end
@interface SotaydienthoaiDialogViewController : GiaoDichViewController
@property (nonatomic, strong) id<SotaydienthoaiDialogViewControllerDelegate> delegate;
@property (assign, nonatomic) BOOL *isDelete;
@property (strong, nonatomic) NSString *idGiaoDich;

- (void)showPopupDelete;
- (void)showPopupEdit;
- (void)setTextNameInput:(NSString*)text;
- (void)setNameDelete:(NSString*)text;
@end
