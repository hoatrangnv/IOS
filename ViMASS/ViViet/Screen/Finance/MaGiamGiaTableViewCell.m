//
//  MaGiamGiaTableViewCell.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 5/2/19.
//

#import "MaGiamGiaTableViewCell.h"

@implementation MaGiamGiaTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.btnXemKM.titleLabel setTextAlignment:NSTextAlignmentCenter];
    self.btnXemKM.layer.cornerRadius = 3.0;
}

- (void)dealloc {
    [_lblMaGiamGia release];
    [_btnXemKM release];
    [super dealloc];
}
@end
