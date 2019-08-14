//
//  VNPayQRInputMoneyViewCell.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 3/27/19.
//

#import "VNPayQRInputMoneyViewCell.h"
#import "Common.h"

@implementation VNPayQRInputMoneyViewCell {
    bool isNhapTien;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    isNhapTien = YES;
    self.accessoryType = UITableViewCellAccessoryNone;
}

- (void)setIsNhapTien:(BOOL)isNhap {
    isNhapTien = isNhap;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)changeSoTien:(id)sender {
    if (isNhapTien) {
        NSString *sSoTien = [_tfSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""];
        _tfSoTien.text = [Common hienThiTienTeFromString:sSoTien];
    }
}

- (void)dealloc {
    [_tfSoTien release];
    [_lblPhi release];
    [super dealloc];
}
@end
