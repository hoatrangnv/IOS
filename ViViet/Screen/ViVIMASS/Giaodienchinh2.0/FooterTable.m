//
//  FooterTable.m
//  ViViMASS
//
//  Created by Mac Mini on 11/2/18.
//

#import "FooterTable.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "DucNT_LuuRMS.h"
@interface FooterTable()
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *contraintLeading;

@end
@implementation FooterTable

- (BOOL)kiemTraCoChucNangQuetVanTay
{
    LAContext *laContext = [[[LAContext alloc] init] autorelease];
    NSError *error = nil;
    if([laContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
    {
        if (error != NULL) {
            // handle error
        } else {
            
            if (@available(iOS 11.0.1, *)) {
                if (laContext.biometryType == LABiometryTypeFaceID) {
                    //localizedReason = "Unlock using Face ID"
                    return YES;
                } else if (laContext.biometryType == LABiometryTypeTouchID) {
                    //localizedReason = "Unlock using Touch ID"
                    return YES;
                } else {
                    //localizedReason = "Unlock using Application Passcode"
                    return NO;
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
    return NO;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadCount:) name:@"CountMoney" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ReloadFooter:) name:@"ReloadFooter" object:nil];
}
-(void)reloadCount:(NSNotification*)notification{
    NSDictionary *dict = (NSDictionary*)[notification object];
    self.lbTongPhi.text = [NSString stringWithFormat:@"%@ đ", [dict objectForKey:@"Fee"]];
    self.lbTongTien.text = [NSString stringWithFormat:@"%@ đ", [dict objectForKey:@"Total"]];
}
-(void)ReloadFooter:(NSNotification*)notification{
    int type = (int)[notification object];
    if(type == 1){
        self.txtOtp.hidden = false;
        self.btnSMS.hidden = false;
        self.btnToken.hidden = false;
        self.lbTime.hidden = false;
        self.lbCountTime.hidden = false;
        self.btnThucHien.hidden = false;
        self.txtOtp.placeholder = @"Mã xác thực";
    }
    else{
        self.txtOtp.hidden = false;
        self.btnSMS.hidden = false;
        self.btnToken.hidden = false;
        self.lbTime.hidden = true;
        self.lbCountTime.hidden = true;
        self.btnThucHien.hidden = false;
        self.txtOtp.placeholder = @"Mật khẩu token";
    }
}

- (void)dealloc {
    [_txtNoiDung release];
    [_lbTongTien release];
    [_lbTongPhi release];
    [_btnSMS release];
    [_btnToken release];
    [_btnVanTay release];
    [_txtOtp release];
    [_lbTime release];
    [_lbCountTime release];
    [_btnThucHien release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_contraintLeading release];
    [super dealloc];
}
-(void)setupView{
    
    if ([self kiemTraCoChucNangQuetVanTay]){
        self.btnSMS.hidden = true;
        self.btnToken.hidden = true;
        self.lbTime.hidden = true;
        self.lbCountTime.hidden = true;
        self.btnThucHien.hidden = true;
        self.txtOtp.hidden = true;
        _contraintLeading.constant = [UIScreen mainScreen].bounds.size.width/2 - 44/2;
//        [self layoutIfNeeded];
    }
    else{
        self.btnSMS.hidden = false;
        self.btnToken.hidden = false;
        self.btnVanTay.hidden = false;
        self.txtOtp.hidden = true;
        self.lbTime.hidden = true;
        self.lbCountTime.hidden = true;
        self.btnThucHien.hidden = true;
    }
}
- (IBAction)doToken:(id)sender {
    [self.btnToken setSelected:YES];
    [self.btnToken setBackgroundImage:[UIImage imageNamed:@"tokenv"] forState:UIControlStateSelected];
     [self.btnSMS setSelected:NO];
     [self.btnVanTay setSelected:NO];
    self.btnSMS.hidden = false;
    self.btnToken.hidden = false;
    [self.delegate doToken];
}

- (IBAction)doThucHien:(id)sender {
    [self.delegate doThucHien];
}

- (IBAction)doSMS:(id)sender {
    [self.btnSMS setSelected:YES];
    [self.btnSMS setBackgroundImage:[UIImage imageNamed:@"smsv"] forState:UIControlStateSelected];
    [self.btnToken setSelected:NO];
    [self.btnVanTay setSelected:NO];
    self.txtOtp.hidden = true;
    self.lbTime.hidden = true;
    self.lbCountTime.hidden = true;
    self.btnThucHien.hidden = true;

    [self.delegate doSMS];
}
- (IBAction)doVantay:(id)sender {
    [self.btnVanTay setSelected:YES];
    [self.btnVanTay setBackgroundImage:[UIImage imageNamed:@"fingerv"] forState:UIControlStateSelected];
    [self.btnSMS setSelected:NO];
    [self.btnToken setSelected:NO];
    self.txtOtp.hidden = true;
    self.lbTime.hidden = true;
    self.lbCountTime.hidden = true;
    self.btnThucHien.hidden = true;
    [self.delegate doVanTay];
 
}
@end
