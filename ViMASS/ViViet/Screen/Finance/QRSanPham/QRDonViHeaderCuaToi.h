//
//  QRDonViHeaderCuaToi.h
//  ViViMASS
//
//  Created by Tam Nguyen on 3/1/18.
//

#import <UIKit/UIKit.h>

@interface QRDonViHeaderCuaToi : UITableViewHeaderFooterView
@property (retain, nonatomic) IBOutlet UIImageView *imgvAvatar;
@property (retain, nonatomic) IBOutlet UIImageView *imgvQR;
@property (retain, nonatomic) IBOutlet UILabel *lblName;
@property (retain, nonatomic) IBOutlet UIButton *btnThemSanPham;
@property (retain, nonatomic) IBOutlet UIButton *btnPhongToQR;
@property (retain, nonatomic) IBOutlet UIButton *btnChonXemSanPham;

@end
