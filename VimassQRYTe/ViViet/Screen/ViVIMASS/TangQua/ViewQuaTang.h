//
//  ViewQuaTang.h
//  ViViMASS
//
//  Created by DucBT on 2/27/15.
//
//

#import <UIKit/UIKit.h>
#import "ItemQuaTang.h"

@interface ViewQuaTang : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *mlblTieuDe;
@property (retain, nonatomic) IBOutlet UILabel *mlblSoTien;
@property (retain, nonatomic) IBOutlet UILabel *mlblNoiDung;
@property (retain, nonatomic) IBOutlet UIImageView *mimgvHienThi;

@property (nonatomic, retain) ItemQuaTang *mItemQuaTang;


- (void)reloadData;

@end
