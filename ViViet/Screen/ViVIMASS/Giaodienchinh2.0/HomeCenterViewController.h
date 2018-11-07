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
@property (retain, nonatomic) IBOutlet UIView *vCenter;

@property (retain, nonatomic) IBOutlet UILabel *mlblThongBaoBadgeNumber;
@property (retain, nonatomic) IBOutlet UILabel *mlblBadgeNumberTroChuyen;
@property (retain, nonatomic) IBOutlet UILabel *lblSoDu;
@property (retain, nonatomic) IBOutlet UILabel *lblChinh;
@property (retain, nonatomic) IBOutlet UIView *vNganHang;
@property (retain, nonatomic) IBOutlet UIView *vViDienTu;
@property (retain, nonatomic) IBOutlet UIView *vQR;
@property (retain, nonatomic) IBOutlet UIView *vVicuatoi;


- (IBAction)onNext:(id)sender;

@end
