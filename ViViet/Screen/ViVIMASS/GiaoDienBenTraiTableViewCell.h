//
//  GiaoDienBenTraiTableViewCell.h
//  ViViMASS
//
//  Created by DucBT on 1/7/15.
//
//

#import <UIKit/UIKit.h>
#import "Common.h"


@interface GiaoDienBenTraiTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *mimgvDaiDien;
@property (retain, nonatomic) IBOutlet UILabel *mlblTieuDe;
@property (nonatomic, assign) NSInteger mKieuHienThi;
@property (retain, nonatomic) IBOutlet UILabel *mlblBadgeNumber;
@property (retain, nonatomic) IBOutlet UILabel *lblRight;

@end
