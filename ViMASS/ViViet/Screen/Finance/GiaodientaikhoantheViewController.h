

#import <UIKit/UIKit.h>
#import "LienketViewController.h"
@interface GiaodientaikhoantheViewController : LienketViewController
@property (retain, nonatomic) IBOutlet ExTextField *edSoThe;
@property (retain, nonatomic) IBOutlet ExTextField *edNgayMoThe;
@property (retain, nonatomic) IBOutlet ExTextField *edNamMoThe;
@property (retain, nonatomic) IBOutlet UILabel *lblUuTien;
@property (retain, nonatomic) IBOutlet UILabel *lblMacDinh;
-(void)showCvvField:(NSString*)nganhang;

@end
