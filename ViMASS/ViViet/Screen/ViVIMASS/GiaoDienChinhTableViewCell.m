//
//  GiaoDienChinhTableViewCell.m
//  ViViMASS
//
//  Created by DucBT on 1/16/15.
//
//

#import "GiaoDienChinhTableViewCell.h"

@implementation GiaoDienChinhTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_mimgvDaiDien release];
    [super dealloc];
}
@end
