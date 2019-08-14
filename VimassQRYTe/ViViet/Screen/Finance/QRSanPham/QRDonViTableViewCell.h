//
//  QRDonViTableViewCell.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 12/1/17.
//

#import <UIKit/UIKit.h>

@interface QRDonViTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *imgvAvatar;
@property (retain, nonatomic) IBOutlet UIImageView *imgvQR;
@property (retain, nonatomic) IBOutlet UILabel *lblTenHienThi;
@property (retain, nonatomic) IBOutlet UIButton *btnPhongToQR;
@property (retain, nonatomic) IBOutlet UILabel *lblGia;
@property (retain, nonatomic) IBOutlet UILabel *lblDC1;
@property (retain, nonatomic) IBOutlet UILabel *lblDC2;

@end
