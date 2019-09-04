//
//  HomeCenterViewController.h
//  ViViMASS
//
//  Created by Mac Mini on 9/13/18.
//

#import <UIKit/UIKit.h>
#import "GiaoDichViewController.h"
@interface HomeCenterViewController : GiaoDichViewController{
    
}

@property (retain, nonatomic) IBOutlet UIView *vNganHang;
@property (retain, nonatomic) IBOutlet UIView *vQR;
@property (retain, nonatomic) IBOutlet UIButton *btnNganHang;
@property (retain, nonatomic) IBOutlet UIButton *btnQR;
@property (retain, nonatomic) IBOutlet UILabel *lblNganHang;
@property (retain, nonatomic) IBOutlet UILabel *lblHoaDon;
@property (retain, nonatomic) IBOutlet UIButton *btnQuetQR;

- (IBAction)suKienChonVimass:(id)sender;
- (IBAction)suKienChonQRYTe:(id)sender;
- (IBAction)suKienChonVNPay:(id)sender;
- (IBAction)suKienChonGiaoDich:(id)sender;
- (IBAction)suKienChonQuetQR:(id)sender;
- (IBAction)suKienChonToken:(id)sender;
- (IBAction)suKienChonCaNhan:(id)sender;
- (IBAction)suKienChonTheVID:(id)sender;

- (IBAction)onNext:(id)sender;

@end
