//
//  CellHeaderChuyenBay.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 1/9/16.
//
//

#import "CellHeaderChuyenBay.h"

@implementation CellHeaderChuyenBay

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_lblChuyen release];
    [super dealloc];
}
@end
