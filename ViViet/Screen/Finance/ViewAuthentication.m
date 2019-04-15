//
//  ViewAuthentication.m
//  ViViMASS
//
//  Created by Nguyen Van Tam on 4/1/19.
//

#import "ViewAuthentication.h"
#import "Common.h"
@implementation ViewAuthentication {
    int nType;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.viewNhapToken setHidden:YES];
    [self.btnThucHien setTitle:[@"button_thuc_hien" localizableString] forState:UIControlStateNormal];
    [self.btnSDSecure setHidden:YES];
    [self.btnToken setHidden:YES];
    [self.btnFinger.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.btnToken.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.btnSDSecure.imageView setContentMode:UIViewContentModeScaleAspectFit];
    nType = -1;
    _tfToken.max_length = 6;
    _tfToken.secureTextEntry = YES;
}

- (void)dealloc {
    [_btnSDSecure release];
    [_btnToken release];
    [_btnFinger release];
    [_viewNhapToken release];
    [_btnThucHien release];
    [_tfToken release];
    [super dealloc];
}

- (void)xuLyKhiChonXacThucKhac {
    [self.btnSDSecure setHidden:NO];
    [self.btnToken setHidden:NO];
    
}

- (IBAction)suKienChonSDSecure:(id)sender {
    nType = TYPE_AUTHENTICATE_PKI;
    [self.viewNhapToken setHidden:NO];
    [self.btnToken setImage:[UIImage imageNamed:@"token"] forState:UIControlStateNormal];
    [self.btnToken setTitleColor:nil forState:UIControlStateNormal];
    [self.btnToken setSelected:NO];
    if (self.enableFaceID) {
        [self.btnFinger setImage:[UIImage imageNamed:@"face-id"] forState:UIControlStateNormal];
    } else {
        [self.btnFinger setImage:[UIImage imageNamed:@"finger"] forState:UIControlStateNormal];
    }
    [self.btnFinger setTitleColor:nil forState:UIControlStateNormal];
    [self.btnFinger setSelected:NO];
    
    [self.btnSDSecure setSelected:YES];
    [self.btnSDSecure setImage:[UIImage imageNamed:@"pkiv"] forState:UIControlStateNormal];
    if (self.delegate) {
        [self.delegate suKienChonXacThucSDSecure];
    }
}

- (IBAction)suKienChonToken:(id)sender {
    nType = TYPE_AUTHENTICATE_TOKEN;
    [self.viewNhapToken setHidden:NO];
    if (self.enableFaceID) {
        [self.btnFinger setImage:[UIImage imageNamed:@"face-id"] forState:UIControlStateNormal];
    } else {
        [self.btnFinger setImage:[UIImage imageNamed:@"finger"] forState:UIControlStateNormal];
    }
    [self.btnFinger setTitleColor:nil forState:UIControlStateNormal];
    [self.btnFinger setSelected:NO];
    
    [self.btnSDSecure setImage:[UIImage imageNamed:@"pki"] forState:UIControlStateNormal];
    [self.btnSDSecure setTitleColor:nil forState:UIControlStateNormal];
    [self.btnSDSecure setSelected:NO];
    
    [self.btnToken setSelected:YES];
    [self.btnToken setImage:[UIImage imageNamed:@"tokenv"] forState:UIControlStateNormal];
    if (self.delegate) {
        [self.delegate suKienChonXacThucToken];
    }
}

- (IBAction)suKienChonFinger:(id)sender {
    [self.btnSDSecure setImage:[UIImage imageNamed:@"pki"] forState:UIControlStateNormal];
    [self.btnSDSecure setTitleColor:nil forState:UIControlStateNormal];
    [self.btnSDSecure setSelected:NO];
    
    [self.btnToken setImage:[UIImage imageNamed:@"token"] forState:UIControlStateNormal];
    [self.btnToken setTitleColor:nil forState:UIControlStateNormal];
    [self.btnToken setSelected:NO];
    
    if (self.enableFaceID) {
        [self.btnFinger setImage:[UIImage imageNamed:@"face_new_choose"] forState:UIControlStateNormal];
    } else {
        [self.btnFinger setImage:[UIImage imageNamed:@"fingerv"] forState:UIControlStateNormal];
    }
    if (self.delegate) {
        [self.delegate suKienChonXacThucVanTay];
    }
}

- (IBAction)suKienChonThucHien:(id)sender {
    NSString *sMatKhau = self.tfToken.text;
    if ([sMatKhau isEmpty]) {
        
    } else {
        if (self.delegate) {
            [self.delegate suKienBamNutThucHienAuthentication:self.tfToken.text nType:nType];
        }
    }
}
@end
