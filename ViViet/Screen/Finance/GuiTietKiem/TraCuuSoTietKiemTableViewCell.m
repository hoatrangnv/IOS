//
//  TraCuuSoTietKiemTableViewCell.m
//  ViViMASS
//
//  Created by DucBui on 5/19/15.
//
//

#import "TraCuuSoTietKiemTableViewCell.h"
#import "Common.h"

@implementation TraCuuSoTietKiemTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMSoTietKiem:(SoTietKiem *)mSoTietKiem
{
    if(_mSoTietKiem)
        [_mSoTietKiem release];
    _mSoTietKiem = [mSoTietKiem retain];
    _mlblSoSoTietKiem.text = _mSoTietKiem.soSoVimass;
    _mlblSoTienTietKiem.text = [Common hienThiTienTe_1:[_mSoTietKiem.soTien doubleValue]];
    _mlblTrangThaiSo.text = [_mSoTietKiem layTrangThai];
    _mlblKyHan.text = [NSString stringWithFormat:@"Kỳ hạn: %@", [_mSoTietKiem layKyHan]];
    _mlblLaiSuat.text = [NSString stringWithFormat:@"Lãi suất: %@", [_mSoTietKiem layLaiSuat]];
    _mlblNgayGui.text = [NSString stringWithFormat:@"Ngày gửi %@", [_mSoTietKiem layNgayGui]];
    _mlblNgayDaohan.text = [NSString stringWithFormat:@"Đáo hạn %@", [_mSoTietKiem layNgayDaoHan]];
}

- (void)dealloc {
    if(_mSoTietKiem)
        [_mSoTietKiem release];
    [_mlblSoSoTietKiem release];
    [_mlblSoTienTietKiem release];
    [_mlblTrangThaiSo release];
    [_mlblLaiSuat release];
    [_mlblKyHan release];
    [_mlblNgayGui release];
    [_mlblNgayDaohan release];
    [super dealloc];
}
@end
