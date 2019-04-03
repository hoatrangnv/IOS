//
//  VNPayQRSoLuongTableViewCell.m
//  ViViMASS
//
//  Created by Nguyen Van Tam on 4/1/19.
//

#import "VNPayQRSoLuongTableViewCell.h"
#import "Common.h"
@implementation VNPayQRSoLuongTableViewCell {
    double dAmount;
    int soLuong;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _lblTitleSoLuong.text = [@"so_luong_type3_qr" localizableString];
    soLuong = 1;
    [self createLayerButton:_btnTru];
    [self createLayerButton:_btnCong];
}

- (void)createLayerButton:(UIButton *)btn {
    btn.layer.cornerRadius = 3.0;
    btn.layer.borderColor = UIColor.darkGrayColor.CGColor;
    btn.layer.borderWidth = 1.0;
}

- (void)setSoTien:(NSString *)amount {
    dAmount = [amount doubleValue];
    _lblDonGia.text = [NSString stringWithFormat:@"%@ %@", [@"don_gia_qr" localizableString], [Common hienThiTienTeFromString:amount]];
}

- (IBAction)suKienChonTru:(id)sender {
    if (soLuong > 1) {
        soLuong--;
        _lblDonGia.text = [NSString stringWithFormat:@"%@ %@", [@"don_gia_qr" localizableString], [Common hienThiTienTe_1:(soLuong * dAmount)]];
    }
}

- (IBAction)suKienChonCong:(id)sender {
    soLuong++;
    _lblDonGia.text = [NSString stringWithFormat:@"%@ %@", [@"don_gia_qr" localizableString], [Common hienThiTienTe_1:(soLuong * dAmount)]];
}

- (void)dealloc {
    [_btnTru release];
    [_btnCong release];
    [_lblSoLuong release];
    [_lblDonGia release];
    [_lblTitleSoLuong release];
    [super dealloc];
}
@end
