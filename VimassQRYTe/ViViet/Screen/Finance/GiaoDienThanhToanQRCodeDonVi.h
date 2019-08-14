//
//  GiaoDienThanhToanQRCodeDonVi.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 11/16/17.
//

#import <UIKit/UIKit.h>
#import "GiaoDichViewController.h"
#import "UmiTextView.h"
@interface GiaoDienThanhToanQRCodeDonVi : GiaoDichViewController
@property (nonatomic, retain) NSString *sIdQRCode;
@property (nonatomic, assign) int typeQRCode;

@property (retain, nonatomic) IBOutlet UILabel *lblTenCty;
@property (retain, nonatomic) IBOutlet UILabel *lblTenNguoiNhan;
@property (retain, nonatomic) IBOutlet UIImageView *imgvAvatar;
@property (retain, nonatomic) IBOutlet UIImageView *imgvQR;
@property (retain, nonatomic) IBOutlet ExTextField *edSoTien;
@property (retain, nonatomic) IBOutlet ExTextField *edNoiDung;
@property (retain, nonatomic) IBOutlet UmiTextView *tvNoiDung;

@property (retain, nonatomic) IBOutlet NSLayoutConstraint *constantHeightNoiDung;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *constantHeightViewMain;

- (IBAction)changeSoTien:(id)sender;

@end
