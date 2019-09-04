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

- (IBAction)suKienThayDoiSoTien:(id)sender {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)changeSoTien:(id)sender {
    NSString *sSoTien = [_tfSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    if (isNhapTien) {
        _tfSoTien.text = [Common hienThiTienTeFromString:sSoTien];
    }
    if (_isQRNganHang) {
        double dSoTien = [sSoTien doubleValue];
        double fSoPhi = [Common layPhiChuyenTienCuaSoTien:dSoTien kieuChuyenTien:KIEU_CHUYEN_TIEN_DEN_TAI_KHOAN_NGAN_HANG maNganHang:@""];
        self.lblPhi.text = [NSString stringWithFormat:@"Phí: %@", [Common hienThiTienTe_1:fSoPhi]];
    }
}

- (void)dealloc {
    [_tfSoTien release];
    [_lblPhi release];
    [super dealloc];
}
@end
