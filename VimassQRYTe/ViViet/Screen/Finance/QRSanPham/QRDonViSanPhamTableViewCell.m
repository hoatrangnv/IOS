//
//  QRDonViSanPhamTableViewCell.m
//  ViViMASS
//
//  Created by Tam Nguyen on 3/2/18.
//

#import "QRDonViSanPhamTableViewCell.h"

@implementation QRDonViSanPhamTableViewCell

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
    [_lblTenHienThi release];
    [_imgvQR release];
    [_btnPhongToQR release];
    [_btnPhongToAvatar release];
    [_lblGia release];
    [_lblDC1 release];
    [_lblDC2 release];
    [super dealloc];
}
@end
