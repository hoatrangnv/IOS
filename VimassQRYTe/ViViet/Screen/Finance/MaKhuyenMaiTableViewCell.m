//
//  MaKhuyenMaiTableViewCell.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 5/2/19.
//

#import "MaKhuyenMaiTableViewCell.h"

@implementation MaKhuyenMaiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_lblMaKM release];
    [_lblDonViApDung release];
    [_lblUuDai release];
    [_lblSoLuong release];
    [super dealloc];
}
@end
