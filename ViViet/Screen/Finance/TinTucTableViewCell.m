//
//  TinTucTableViewCell.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 1/8/19.
//

#import "TinTucTableViewCell.h"

@implementation TinTucTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    CGRect frame = self.contentView.frame;
//    CGRect newFrame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(10, 10, 10, 10));
//    self.contentView.frame = newFrame;
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_imgvIcon release];
    [_lblTitle release];
    [_lblContent release];
    [super dealloc];
}
@end
