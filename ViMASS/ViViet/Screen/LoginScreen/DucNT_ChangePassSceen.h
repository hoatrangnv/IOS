//
//  DucNT_ChangePassSceen.h
//  ViMASS
//
//  Created by MacBookPro on 7/12/14.
//
//

#import "GiaoDichViewController.h"
#import "ExTextField.h"
#import "DucNT_ServicePost.h"
#import "DucNT_LuuRMS.h"

@interface DucNT_ChangePassSceen : GiaoDichViewController<DucNT_ServicePostDelegate>

@property (retain, nonatomic) IBOutlet UIView *viewKhung;
@property (retain, nonatomic) IBOutlet ExTextField *edtOldPass;
@property (retain, nonatomic) IBOutlet ExTextField *edtNewPass;
@property (retain, nonatomic) IBOutlet ExTextField *edtReNewPass;
@property (retain, nonatomic) IBOutlet UIButton *btnExcute;

- (IBAction)suKienDoiMatKhau:(id)sender;
@end
