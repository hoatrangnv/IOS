//
//  CellDiemGiaoDich.m
//  ViViMASS
//
//  Created by nguyen tam on 9/8/15.
//
//

#import "CellDiemGiaoDich.h"

@implementation CellDiemGiaoDich

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
    [_lblName release];
    [_lblAdress release];
    [_lblDistance release];
    [_lblPhone release];
    [super dealloc];
}
@end
