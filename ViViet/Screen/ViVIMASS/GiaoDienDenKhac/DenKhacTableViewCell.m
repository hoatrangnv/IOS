//
//  DenKhacTableViewCell.m
//  ViViMASS
//
//  Created by Tam Nguyen on 2/24/18.
//

#import "DenKhacTableViewCell.h"

@implementation DenKhacTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_imgvDaiDien release];
    [_lblName release];
    [super dealloc];
}
@end
