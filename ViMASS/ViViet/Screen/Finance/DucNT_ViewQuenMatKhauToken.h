//
//  DucNT_ViewQuenMatKhauToken.h
//  ViMASS
//
//  Created by MacBookPro on 7/9/14.
//
//

#import <UIKit/UIKit.h>
#import "DucNT_Token.h"
#import "DucNT_LuuRMS.h"
#import "DucNT_ServicePost.h"
#import "ExTextField.h"

@interface DucNT_ViewQuenMatKhauToken : UIView<DucNT_ServicePostDelegate, UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UIView *viewKhung;
@property (retain, nonatomic) IBOutlet UIButton *btnThucHien;
@property (retain, nonatomic) IBOutlet ExTextField *edtID;
@property (retain, nonatomic) IBOutlet ExTextField *edtMatKhauMoi;
@property (retain, nonatomic) IBOutlet ExTextField *edtMatKhauMoiConfirm;
@property (retain, nonatomic) IBOutlet ExTextField *mtfTenTaiKhoan;

- (IBAction)suKienXacThucQuenMatKhau:(id)sender;
- (IBAction)suKienKetThucBanPhim:(id)sender;

-(id)initWithNib;
@end
