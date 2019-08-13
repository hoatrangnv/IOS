
#import <UIKit/UIKit.h>
#import "GiaoDichViewController.h"
#import "RadioButton.h"
@class ItemTaiKhoanLienKet;
@interface LienketViewController : GiaoDichViewController
@property (retain, nonatomic) IBOutlet ExTextField *edBank;
@property (retain, nonatomic) IBOutlet ExTextField *edChuTK;
@property (retain, nonatomic) IBOutlet UIButton *btnVanTay;
@property (retain, nonatomic) IBOutlet UIButton *btnToken;
@property (retain, nonatomic) IBOutlet UITextField *txtOtp;
@property (retain, nonatomic) IBOutlet UIButton *btnThucHien;
@property (retain, nonatomic) IBOutlet RadioButton *btnSelect;
- (IBAction)doToken:(id)sender;
- (IBAction)doThucHien:(id)sender;
- (IBAction)doVantay:(id)sender;
- (IBAction)onMacding:(id)sender;
- (void)edittaikhoanlienket:(NSDictionary*)dic;
-(void)taotaikhoanlienket:(NSDictionary*)dic;
-(void)setIndexSelected:(NSInteger)indexSelected;
- (void)suKienChinhSuaTaiKhoanLienKet:(ItemTaiKhoanLienKet *)taiKhoan;
@end
