//
//  ViewNavigationGiaoDienChinh.h
//  ViViMASS
//
//  Created by DucBT on 1/14/15.
//
//

#import <UIKit/UIKit.h>


@protocol ViewNavigationGiaoDienChinhDelegate <NSObject>
@required
- (void)xuLySuKienBamNutThongBao;
- (void)xuLySuKienBamNutTroChuyen;
- (void)xuLySuKienBamNutSaoKe;
@end

@interface ViewNavigationGiaoDienChinh : UIView

@property (retain, nonatomic) IBOutlet UILabel *mlblThongBaoBadgeNumber;
@property (retain, nonatomic) IBOutlet UILabel *mlblBadgeNumberTroChuyen;
@property (assign, nonatomic) id<ViewNavigationGiaoDienChinhDelegate> mDelegate;
@property (retain, nonatomic) IBOutlet UILabel *lblSoDu;
@property (retain, nonatomic) IBOutlet UILabel *lblChinh;

- (void)hienThiBagdeNumber;
- (void)hienThiSoTien:(NSString *)sSoTien;
@end
