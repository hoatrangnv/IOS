//
//  GiaoDienThanhToanQRCode.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 11/8/17.
//

#import <UIKit/UIKit.h>
#import "GiaoDichViewController.h"
@interface GiaoDienThanhToanQRCode : GiaoDichViewController
@property (nonatomic, retain) NSString *sIdQRCode;
@property (retain, nonatomic) IBOutlet ExTextField *lblSanPham;
@property (retain, nonatomic) IBOutlet ExTextField *lblSoTien;
@property (retain, nonatomic) IBOutlet UILabel *lblTenCty;
@property (retain, nonatomic) IBOutlet UIImageView *imgvAvatar;
@property (retain, nonatomic) IBOutlet UIImageView *imgvQR;
@property (retain, nonatomic) IBOutlet UILabel *lblTenSP;
@property (retain, nonatomic) IBOutlet ExTextField *edSoTien;
@property (retain, nonatomic) IBOutlet UISwitch *swHienSoVi;
@property (retain, nonatomic) IBOutlet UIView *viewThongTInNhanHang;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *heightViewNhanHang;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *heightContentView;
@property (retain, nonatomic) IBOutlet UIImageView *imgvPhongTo;
@property (retain, nonatomic) IBOutlet UIView *viewPhongTo;
@property (retain, nonatomic) IBOutlet ExTextField *edHoTenNhanHang;
@property (retain, nonatomic) IBOutlet ExTextField *edSoDTNhanHang;
@property (retain, nonatomic) IBOutlet ExTextField *edEmailNhanHang;
@property (retain, nonatomic) IBOutlet ExTextField *edDiaChiNhanHang;
@property (retain, nonatomic) IBOutlet ExTextField *edCMNDNhanHang;
@property (retain, nonatomic) IBOutlet ExTextField *edMaKHNhanHang;



- (IBAction)suKienNhapSoTien:(id)sender;
- (IBAction)suKienDongPhongTo:(id)sender;

@end
