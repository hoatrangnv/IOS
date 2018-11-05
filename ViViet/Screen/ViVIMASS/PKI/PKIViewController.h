//
//  PKIViewController.h
//  ViViMASS
//
//  Created by Mac Mini on 8/12/18.
//

#import <UIKit/UIKit.h>
#import "GiaoDichViewController.h"

@class ExTextField;
@interface PKIViewController : GiaoDichViewController
@property  (nonatomic,retain) IBOutlet UIView *vHanMuc;
@property  (nonatomic,retain) IBOutlet UIView *vDangKy;
@property  (nonatomic,retain) IBOutlet UIView *vMatKhau;
@property  (nonatomic,retain) IBOutlet UIView *vXacNhanDangKy;
- (IBAction)sukienDangKy:(id)sender;
@property (retain, nonatomic) IBOutlet ExTextField *edMatkhauPKI;
- (IBAction)sukienXacNhan:(id)sender;
@property (retain, nonatomic) IBOutlet ExTextField *edMatKhauHanMuc;
@property (retain, nonatomic) IBOutlet ExTextField *edOTPXacNhan;
@property (retain, nonatomic) IBOutlet ExTextField *edHanMuc;
- (IBAction)sukienHanMuc:(id)sender;
@property (retain, nonatomic) IBOutlet ExTextField *edDoiMatKhau1;
@property (retain, nonatomic) IBOutlet ExTextField *edDoiMatKhau2;
@property (retain, nonatomic) IBOutlet ExTextField *edDoiMatKhau3;
- (IBAction)sukienDoiMatKhau:(id)sender;

@end
