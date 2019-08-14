//
//  CellChuyenBay.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 1/7/16.
//
//

#import <UIKit/UIKit.h>

@interface CellChuyenBay : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *lblHang;
@property (retain, nonatomic) IBOutlet UILabel *lblSoHieu;
@property (retain, nonatomic) IBOutlet UILabel *lblGioDi;
@property (retain, nonatomic) IBOutlet UILabel *lblGioDen;
@property (retain, nonatomic) IBOutlet UILabel *lblGiaTien;

- (void)doiMauChuTheoHang:(UIColor *)color;
@end
