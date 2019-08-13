//
//  DucNT_DangKyToken.h
//  ViMASS
//
//  Created by MacBookPro on 7/8/14.
//
//

#import <UIKit/UIKit.h>
#import "GiaodichViewController.h"
#import "DucNT_ServicePost.h"
#import "ExTextField.h"

@interface DucNT_DangKyToken : GiaoDichViewController<UITextFieldDelegate, DucNT_ServicePostDelegate>
@property (retain, nonatomic) IBOutlet ExTextField *edtSoDienThoai;
@property (retain, nonatomic) IBOutlet ExTextField *edtMatKhauToken;
@property (retain, nonatomic) IBOutlet ExTextField *edtMatKhauTokenConfirm;
@property (retain, nonatomic) IBOutlet UIButton *btnDangKyToken;

- (IBAction)suKienDangKyToken:(id)sender;
- (IBAction)suKienKetThucBanPhim:(id)sender;
@end
