//
//  HienThiChatTongTableViewCell.m
//  ViMASS
//
//  Created by DucBT on 10/30/14.
//
//

#import "HienThiChatTongTableViewCell.h"

@implementation HienThiChatTongTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _mlblBadgeNumber.layer.masksToBounds = YES;
    _mlblBadgeNumber.layer.cornerRadius = 12.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_mimgvDaiDien release];
    [_mlblTieuDe release];
    [_mlblBadgeNumber release];
    [super dealloc];
}
@end
