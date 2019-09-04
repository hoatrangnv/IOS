//
//  SaoKeViVimassCell.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 8/21/19.
//

#import "SaoKeViVimassCell.h"

@implementation SaoKeViVimassCell
@synthesize imvAnhDaiDienHuongDiChuyen;
@synthesize lbNoiDung;
@synthesize lbSoTien;
@synthesize lbThoiGian;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    if(imvAnhDaiDienHuongDiChuyen)
        [imvAnhDaiDienHuongDiChuyen release];
    if(lbSoTien)
        [lbSoTien release];
    if(lbNoiDung)
        [lbNoiDung release];
    if(lbThoiGian)
        [lbThoiGian release];
    [_mlblSoPhi release];
    [_mlblSoGio release];
    [_mViewChua release];
    [super dealloc];
}
@end
