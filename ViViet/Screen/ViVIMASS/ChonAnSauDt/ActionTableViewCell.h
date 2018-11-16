

#import <UIKit/UIKit.h>
#import "ExTextField.h"
@protocol ActionTableViewCellDelegate<NSObject>
- (void)actionVantay;
- (void)actionThucHien:(NSString*)token;
@end
@interface ActionTableViewCell : UITableViewCell
@property (nonatomic,retain) id<ActionTableViewCellDelegate> delegate;
@property (retain, nonatomic) IBOutlet UIButton *btnToken;
@property (retain, nonatomic) IBOutlet UIButton *btnVantay;
@property (retain, nonatomic) IBOutlet ExTextField *txtToken;
@property (retain, nonatomic) IBOutlet UIButton *btnThuchien;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *contraintLeading;
-(void)setupView;
- (IBAction)doToken:(id)sender;
@end
