//
//  DanhSachNguoiChatTableViewCell.m
//  ViMASS
//
//  Created by DucBT on 10/2/14.
//
//

#import "DanhSachNguoiChatTableViewCell.h"

@implementation DanhSachNguoiChatTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_mlblTen release];
    [_mlblTinNhanCuoi release];
    [_mlblThoiGianTinCuoi release];
    [super dealloc];
}
@end
