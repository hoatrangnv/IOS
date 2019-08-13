//
//  SotaydienthoaiTableViewCell.m
//  ViViMASS
//
//  Created by Nguyen Van Hoanh on 11/7/18.
//

#import "SotaydienthoaiTableViewCell.h"

@interface SotaydienthoaiTableViewCell ()

@end

@implementation SotaydienthoaiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)onDelete:(id)sender {
    if (_delegate) {
        [_delegate actionDelete:_lblTitle.text andIdGiaoDich:self.idGiaodich];
    }
}
- (IBAction)onEdit:(id)sender {
    if (_delegate) {
        [_delegate actionEdit:_lblTitle.text andIdGiaoDich:self.idGiaodich];
    }
}
- (void)setHiddenBottomLine:(BOOL)isHidden {
    _imgBottom.hidden = isHidden;
}
- (void)dealloc {
    [_iconLogo release];
    [_lblTitle release];
    [_imgBottom release];
    [super dealloc];
}
@end
