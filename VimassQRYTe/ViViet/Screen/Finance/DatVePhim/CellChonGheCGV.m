//
//  CellChonGheCGV.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 6/23/16.
//
//

#import "CellChonGheCGV.h"

@implementation CellChonGheCGV

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_lblLoaiVe release];
    [_lblGia release];
    [_edSoLuong release];
    [super dealloc];
}
@end
