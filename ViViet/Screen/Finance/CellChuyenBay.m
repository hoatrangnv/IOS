//
//  CellChuyenBay.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 1/7/16.
//
//

#import "CellChuyenBay.h"

@implementation CellChuyenBay

- (void)awakeFromNib {
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)doiMauChuTheoHang:(UIColor *)color{
    self.lblHang.textColor = color;
    self.lblSoHieu.textColor = color;
    self.lblGioDi.textColor = color;
    self.lblGioDen.textColor = color;
}

- (void)dealloc {
    [_lblHang release];
    [_lblSoHieu release];
    [_lblGioDi release];
    [_lblGioDen release];
    [_lblGiaTien release];
    [super dealloc];
}
@end
