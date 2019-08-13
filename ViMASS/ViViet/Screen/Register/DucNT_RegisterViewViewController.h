//
//  DucNT_RegisterViewViewController.h
//  ViMASS
//
//  Created by MacBookPro on 7/3/14.
//
//

#import <UIKit/UIKit.h>
#import "DucNT_ServicePost.h"
#import "GiaoDichViewController.h"
#import "ExTextField.h"
#import "TPKeyboardAvoidAcessory.h"
#import "FixIOS7StatusBarRootView.h"

@interface DucNT_RegisterViewViewController : GiaoDichViewController<DucNT_ServicePostDelegate, UITextFieldDelegate>


@property (retain, nonatomic) IBOutlet FixIOS7StatusBarRootView *viewRoot;
@property (retain, nonatomic) IBOutlet TPKeyboardAvoidAcessory *viewScroll;
@property (retain, nonatomic) IBOutlet ExTextField *edtId;
@property (retain, nonatomic) IBOutlet ExTextField *edtPassword;
@property (retain, nonatomic) IBOutlet ExTextField *edtPasswordConfirm;
@property (retain, nonatomic) IBOutlet UIButton *btnRegister;
@property (retain, nonatomic) IBOutlet UILabel *mlblTitle;
@property (retain, nonatomic) IBOutlet UIWebView *mwvDongYDieuKhoan;
@property (retain, nonatomic) IBOutlet UIWebView *webDieuKhoan;
@property (retain, nonatomic) IBOutlet UIView *viewDieuKhoan;
@property (retain, nonatomic) IBOutlet UIButton *btnBackMain;

- (IBAction)clickBtnRegister:(id)sender;
- (IBAction)suKienBamNutBack:(id)sender;
- (IBAction)suKienBackDieuKhoan:(id)sender;

@end
