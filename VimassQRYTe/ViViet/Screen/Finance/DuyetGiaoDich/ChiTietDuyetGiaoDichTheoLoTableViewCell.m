//
//  ChiTietDuyetGiaoDichTheoLoTableViewCell.m
//  ViViMASS
//
//  Created by DucBui on 7/1/15.
//
//

#import "ChiTietDuyetGiaoDichTheoLoTableViewCell.h"

@implementation ChiTietDuyetGiaoDichTheoLoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_mlblTieuDe release];
    [_mlblSoTien release];
    [_mlblNoiDung release];
    [super dealloc];
}
@end
