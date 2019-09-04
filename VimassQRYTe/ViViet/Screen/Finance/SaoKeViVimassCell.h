//
//  SaoKeViVimassCell.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 8/21/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SaoKeViVimassCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *imvAnhDaiDienHuongDiChuyen;
@property (retain, nonatomic) IBOutlet UILabel *lbSoTien;
@property (retain, nonatomic) IBOutlet UILabel *lbNoiDung;
@property (retain, nonatomic) IBOutlet UILabel *lbThoiGian;
@property (retain, nonatomic) IBOutlet UILabel *mlblSoPhi;
@property (retain, nonatomic) IBOutlet UILabel *mlblSoGio;
@property (retain, nonatomic) IBOutlet UIView *mViewChua;

@end

NS_ASSUME_NONNULL_END
