

#import "ActionTableViewCell.h"
#import <LocalAuthentication/LocalAuthentication.h>
@implementation ActionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
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
-(void)setupView {
    if (_btnToken.isSelected || _btnVantay.isSelected) {
        return;
    }
    if ([self kiemTraCoChucNangQuetVanTay]){
        self.btnToken.hidden = true;
        self.btnThuchien.hidden = true;
        self.txtToken.hidden = true;
        _contraintLeading.constant = [UIScreen mainScreen].bounds.size.width/2 - 44/2;
    }
    else{
        self.btnToken.hidden = false;
        self.btnVantay.hidden = false;
        self.txtToken.hidden = true;
        self.btnThuchien.hidden = true;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)doToken:(id)sender {
    [self.btnToken setSelected:YES];
    [self.btnToken setBackgroundImage:[UIImage imageNamed:@"tokenv"] forState:UIControlStateSelected];
    [self.btnVantay setSelected:NO];
    self.btnToken.hidden = false;
    self.txtToken.hidden = false;
    self.btnThuchien.hidden = false;

}
- (IBAction)doVantay:(id)sender {
    [self.btnVantay setSelected:YES];
    [self.btnVantay setBackgroundImage:[UIImage imageNamed:@"fingerv"] forState:UIControlStateSelected];
    [self.btnToken setSelected:NO];
    self.txtToken.hidden = true;
    self.btnThuchien.hidden = true;
    if (_delegate) {
        [_delegate actionVantay];
    }
}
- (IBAction)doThuchien:(id)sender {
    if (_delegate) {
        [_delegate actionThucHien:_txtToken.text];
    }
}

- (void)dealloc {
    [_btnToken release];
    [_btnVantay release];
    [_txtToken release];
    [_btnThuchien release];
    [super dealloc];
}
@end
