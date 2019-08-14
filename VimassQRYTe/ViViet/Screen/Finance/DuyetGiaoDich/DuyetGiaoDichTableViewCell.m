//
//  DuyetGiaoDichTableViewCell.m
//  ViViMASS
//
//  Created by DucBui on 6/9/15.
//
//

#import "DuyetGiaoDichTableViewCell.h"
#import "Common.h"

@implementation DuyetGiaoDichTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMDoiTuongGiaoDich:(DoiTuongGiaoDich *)mDoiTuongGiaoDich
{
    if(_mDoiTuongGiaoDich)
        [_mDoiTuongGiaoDich release];
    _mDoiTuongGiaoDich = [mDoiTuongGiaoDich retain];
    _mlblNoiDungGiaoDich.text = _mDoiTuongGiaoDich.noiDungHienThi;
    _mlblSoTienGiaoDich.text = [Common hienThiTienTe_1:[_mDoiTuongGiaoDich.soTien doubleValue]];
    _mlblTrangThaiGiaoDich.text = [_mDoiTuongGiaoDich layTrangThai];
    _mlblNgayLap.text = [NSString stringWithFormat:@"Lập %@", [_mDoiTuongGiaoDich layThoiGianLap]];
    NSLog(@"%s - [_mDoiTuongGiaoDich.trangThai intValue] : %d", __FUNCTION__, [_mDoiTuongGiaoDich.trangThai intValue]);
    switch ([_mDoiTuongGiaoDich.trangThai intValue]) {
        case DOANH_NGHIEP_DUYET_LENH_THANH_CONG:
            _mlblNgayDuyet.text = [NSString stringWithFormat:@"Duyệt %@", [_mDoiTuongGiaoDich layThoiGianDuyet]];
            break;
        case DOANH_NGHIEP_DA_HUY:
            _mlblNgayDuyet.text = [NSString stringWithFormat:@"Huỷ %@", [_mDoiTuongGiaoDich layThoiGianHuy]];
            break;
        case DOANH_NGHIEP_HET_HAN_DUYET:
            _mlblNgayDuyet.text = [NSString stringWithFormat:@"Hết hạn %@", [_mDoiTuongGiaoDich layThoiGianHetHan]];
            break;
        case DOANH_NGHIEP_DUYET_LENH_XOA:
        _mlblNgayDuyet.text = @"Đã xoá";
            break;
        default:
            _mlblNgayDuyet.text = @"";
            break;
    }
}

- (void)dealloc {
    [_mDoiTuongGiaoDich release];
    [_mlblNoiDungGiaoDich release];
    [_mlblSoTienGiaoDich release];
    [_mlblTrangThaiGiaoDich release];
    [_mlblNgayLap release];
    [_mlblNgayDuyet release];
    [super dealloc];
}
@end
