//
//  VNPayQRTableViewCell.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 3/26/19.
//

#import "VNPayQRTableViewCell.h"

@implementation VNPayQRTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_lblTitle release];
    [_lblContent release];
    [super dealloc];
}
@end
