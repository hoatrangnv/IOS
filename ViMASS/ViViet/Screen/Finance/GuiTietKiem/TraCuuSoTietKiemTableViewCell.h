//
//  TraCuuSoTietKiemTableViewCell.h
//  ViViMASS
//
//  Created by DucBui on 5/19/15.
//
//

#import <UIKit/UIKit.h>
#import "SoTietKiem.h"

@interface TraCuuSoTietKiemTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *mlblSoSoTietKiem;
@property (retain, nonatomic) IBOutlet UILabel *mlblSoTienTietKiem;
@property (retain, nonatomic) IBOutlet UILabel *mlblTrangThaiSo;
@property (retain, nonatomic) IBOutlet UILabel *mlblLaiSuat;
@property (retain, nonatomic) IBOutlet UILabel *mlblKyHan;
@property (retain, nonatomic) IBOutlet UILabel *mlblNgayGui;
@property (retain, nonatomic) IBOutlet UILabel *mlblNgayDaohan;
@property (retain, nonatomic) SoTietKiem *mSoTietKiem;

@end
