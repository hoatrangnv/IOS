//
//  VNPAYDienDiemCell.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 5/6/19.
//

#import "VNPAYDienDiemCell.h"

@implementation VNPAYDienDiemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _lblTitle.text = @"";
    _lblDiaChi.text = @"";
    _lblKhoangCach.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_lblTitle release];
    [_lblDiaChi release];
    [_lblKhoangCach release];
    [super dealloc];
}
@end
