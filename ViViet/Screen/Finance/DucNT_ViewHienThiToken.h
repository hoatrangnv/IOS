//
//  DucNT_ViewHienThiToken.h
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

@protocol DucNT_ViewHienThiToken<NSObject>
- (void)suKienClickSetting;
@end

@interface DucNT_ViewHienThiToken : UIView<UITextFieldDelegate, DucNT_ServicePostDelegate>

//+(id)ducnt_ViewHienThiToken;
@property (nonatomic, assign) id <DucNT_ViewHienThiToken> delegate;
@property (retain, nonatomic) IBOutlet UIView *viewKhung;
@property (retain, nonatomic) IBOutlet ExTextField *edtID;
@property (retain, nonatomic) IBOutlet UILabel *lbToken;
@property (retain, nonatomic) IBOutlet ExTextField *edtPassToken;
@property (retain, nonatomic) IBOutlet ExTextField *edtTimer;
@property (retain, nonatomic) IBOutlet UIButton *btnTestOTP;
@property (retain, nonatomic) IBOutlet UIButton *mbtnVanTay;

- (IBAction)suKienKetThucBanPhim:(id)sender;
- (IBAction)testOTPConfirm:(id)sender;
- (IBAction)suKienClickSetting:(id)sender;

//@property (retain, nonatomic) NSTimer *timer;
//@property (assign, nonatomic) bool bChayLanDau;

-(id)initWithNib;
-(void)stopTimer;
@end
