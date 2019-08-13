//
//  DuyetGiaoDichTableViewCell.h
//  ViViMASS
//
//  Created by DucBui on 6/9/15.
//
//

#import <UIKit/UIKit.h>
#import "DoiTuongGiaoDich.h"

@interface DuyetGiaoDichTableViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *mlblNoiDungGiaoDich;
@property (retain, nonatomic) IBOutlet UILabel *mlblSoTienGiaoDich;
@property (retain, nonatomic) IBOutlet UILabel *mlblTrangThaiGiaoDich;
@property (retain, nonatomic) IBOutlet UILabel *mlblNgayLap;
@property (retain, nonatomic) IBOutlet UILabel *mlblNgayDuyet;

@property (nonatomic, retain) DoiTuongGiaoDich *mDoiTuongGiaoDich;

@end
