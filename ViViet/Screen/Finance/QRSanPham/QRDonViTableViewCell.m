//
//  QRDonViTableViewCell.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 12/1/17.
//

#import "QRDonViTableViewCell.h"

@implementation QRDonViTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_imgvAvatar release];
    [_imgvQR release];
    [_lblTenHienThi release];
    [_btnPhongToQR release];
    [super dealloc];
}
@end
