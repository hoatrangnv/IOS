//
//  DucNT_ForgotPassAccViewController.h
//  ViMASS
//
//  Created by MacBookPro on 7/16/14.
//
//

#import "GiaoDichViewController.h"
#import "ExTextField.h"
#import "Common.h"
#import "DucNT_ServicePost.h"
#import "FixIOS7StatusBarRootView.h"

@interface DucNT_ForgotPassAccViewController : GiaoDichViewController<UITextFieldDelegate, DucNT_ServicePostDelegate>

@property (retain, nonatomic) IBOutlet FixIOS7StatusBarRootView *viewRoot;
@property (retain, nonatomic) IBOutlet UILabel *lbTitle;
@property (retain, nonatomic) IBOutlet UIButton *btnBack;
@property (retain, nonatomic) IBOutlet ExTextField *edtSoDienThoai;
@property (retain, nonatomic) IBOutlet ExTextField *edtMatKhau;
@property (retain, nonatomic) IBOutlet ExTextField *edtMatKhauConfirm;
@property (retain, nonatomic) IBOutlet UIButton *btnQuenMatKhau;

- (IBAction)suKienQuenMatKhau:(id)sender;
- (IBAction)suKienBack:(id)sender;
@end
