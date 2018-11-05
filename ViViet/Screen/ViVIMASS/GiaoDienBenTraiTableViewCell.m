//
//  GiaoDienBenTraiTableViewCell.m
//  ViViMASS
//
//  Created by DucBT on 1/7/15.
//
//

#import "GiaoDienBenTraiTableViewCell.h"

@implementation GiaoDienBenTraiTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.mlblBadgeNumber.layer.masksToBounds = YES;
    self.mlblBadgeNumber.layer.cornerRadius = 15.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    UIView *bgColorView = [[[UIView alloc] init] autorelease];
    if(self.mKieuHienThi == KIEU_CA_NHAN)
    {

        bgColorView.backgroundColor = [UIColor colorWithHexString:@"#3c97d2"];

    }
    else if(self.mKieuHienThi == KIEU_DOANH_NGHIEP)
    {
        bgColorView.backgroundColor = [UIColor colorWithHexString:@"#43b030"];
    }
    [self setSelectedBackgroundView:bgColorView];

}

- (void)dealloc {
    [_mimgvDaiDien release];
    [_mlblTieuDe release];
    [_mlblBadgeNumber release];
    [super dealloc];
}
@end
