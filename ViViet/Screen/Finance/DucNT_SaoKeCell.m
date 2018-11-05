//
//  DucNT_SaoKeCell.m
//  ViMASS
//
//  Created by MacBookPro on 7/12/14.
//
//

#import "DucNT_SaoKeCell.h"

@implementation DucNT_SaoKeCell

@synthesize imvAnhDaiDienHuongDiChuyen;
@synthesize lbNoiDung;
@synthesize lbSoTien;
@synthesize lbThoiGian;


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
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
