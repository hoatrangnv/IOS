//
//  MenuThongBaoCell.m
//  ViViMASS
//
//  Created by Tam Nguyen on 3/15/18.
//

#import "MenuThongBaoCell.h"

@implementation MenuThongBaoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_iconImageView release];
    [_titleLabel release];
    [super dealloc];
}
@end
