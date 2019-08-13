//
//  HienThiNotificationTableViewCell.m
//  BIDV
//
//  Created by Mac Mini on 9/22/14.
//
//

#import "HienThiNotificationTableViewCell.h"
#import "DoiTuongGiaoDich.h"
#import "Common.h"
#import "DucNT_LuuRMS.h"

@implementation HienThiNotificationTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIImage *)getImageForNotification {
    int typeShow = [_mDoiTuongNotification.typeShow intValue];
    NSString *sData = [DucNT_LuuRMS layTypeShowNotification:KEY_TYPE_SHOW_NOTIFICATION];
    if (sData != nil && !sData.isEmpty) {
        NSDictionary *dicKetQua = [sData objectFromJSONString];
        if ([[dicKetQua valueForKey:@"msgCode"] intValue] == 1) {
            NSArray *result = (NSArray *)[dicKetQua valueForKey:@"result"];
            if (result != nil && result.count > 0) {
                for (NSDictionary *dict in result) {
                    int nPhanLoai = [[dict valueForKey:@"phanLoai"] intValue];
                    NSArray *dsTypeShow = (NSArray *)[dict valueForKey:@"dsTypeShow"];
                    for (int i = 0; i < dsTypeShow.count > 0; i ++) {
                        int typeTemp = [[dsTypeShow objectAtIndex:i] intValue];
                        if (typeTemp == typeShow) {
                            switch (nPhanLoai) {
                                case 0:
                                    return [UIImage imageNamed:@"icon-hethong"];
                                case 1:
                                    return [UIImage imageNamed:@"icon-taichinh"];
                                case 2:
                                    return [UIImage imageNamed:@"icon-thongtinquangcao-do"];
                                case 3:
                                    return [UIImage imageNamed:@"icon-taichinh"];
                                case 4:
                                    return [UIImage imageNamed:@"icon-hoadon"];
                                case 5:
                                    return [UIImage imageNamed:@"icon-muave"];
                                case 6:
                                    return [UIImage imageNamed:@"icon-muasam"];
                                default:
                                    return [UIImage imageNamed:@"icon-hethong"];
                            }
                        }
                    }
                    
                }
            }
        }
    }
    switch (typeShow) {
        case TYPE_TRA_CUU_VE_DUONG_SAT_VN:
            case TYPE_TRA_CUU_VE_MAY_BAY_VIETNAM_AIR_LINE:
            case TYPE_TRA_CUU_VE_MAY_BAY_VIET_JET_AIR:
            case TYPE_TRA_CUU_VE_MAY_BAY_JET_STAR:
            case TYPE_TRA_CUU_VE_MAY_BAY_AIR_ASIA:
            case TYPE_THANH_TOAN_VE_DUONG_SAT_VIET_NAM:
            case TYPE_THANH_TOAN_VE_MAY_BAY_VIETNAM_AIR_LINE:
            case TYPE_THANH_TOAN_VE_MAY_BAY_VIET_JET_AIR:
            case TYPE_THANH_TOAN_VE_MAY_BAY_JET_STAR:
            case TYPE_THANH_TOAN_VE_MAY_BAY_AIR_ASIA:
            case KIEU_NOTIFICATION_VE_MAY_BAY:
            case TYPE_THONG_BAO_DAT_VE_MAY_BAY:
            return [UIImage imageNamed:@"icon-muave"];
        case TYPE_THONG_BAO_TRA_CUU_INTERNET:
            case KIEU_NOTIFICATION_TIEN_TRUYEN_HINH:
            case TYPE_THONG_BAO_TRA_CUU_DIEN_THOAI_CO_DINH:
            case KIEU_NOTIFICATION_TIEN_NUOC:
            case KIEU_NOTIFICATION_TIEN_DIEN:
            case KIEU_NOTIFICATION_TRA_CUU_HOA_DON_VIETTEL:
            case KIEU_NOTIFICATION_TIEN_VAY:
            return [UIImage imageNamed:@"icon-hoadon"];
        case TYPE_THONG_BAO_MUA_SAM:
            return [UIImage imageNamed:@"icon-muasam"];
        case TYPE_THONG_BAO_YEU_CAU_DUYET_GIAO_DICH:
            case TYPE_THONG_BAO_XAC_THUC_TK_LIEN_KET:
            case TYPE_THONG_BAO_TRA_CUU_TEN_CHU_TK_NGAN_HANG:
            case TYPE_THONG_BAO_TRA_CUU_TEN_CMND:
            return [UIImage imageNamed:@"icon-taichinh"];
        case TYPE_THONG_BAO_GIAO_DICH_GUI_TIET_KIEM:
            case TYPE_THONG_BAO_CHUYEN_TIEN_MAT:
            case TYPE_THONG_BAO_NHAN_TIEN_ATM:
            case KIEU_NOTIFICATION_TANG_QUA://trc đây 3 là tặng quà, h thành thẻ cào
            return [UIImage imageNamed:@"icon-taichinh"];
        default:
            return [UIImage imageNamed:@"icon-hethong"];
    }
}

- (void)setMDoiTuongNotification:(DoiTuongNotification *)mDoiTuongNotification
{
    if(_mDoiTuongNotification)
        [_mDoiTuongNotification release];
    _mDoiTuongNotification = [mDoiTuongNotification retain];
    int typeShow = [_mDoiTuongNotification.typeShow intValue];
    int statusShow = [_mDoiTuongNotification.statusShow intValue];
    CGRect rFrame = self.frame;
    CGRect rViewThongTin = self.mViewHienThiThongTin.frame;
    CGRect rViewXacNhan = self.mViewXacNhan.frame;
    self.heightButtonDongY.constant = 0.0;
    if(typeShow == KIEU_NOTIFICATION_MUON_TIEN && statusShow == TRANG_THAI_SHOW_NOTIFICATION_CHUA_XU_LY)
    {
        [_mlblTrangThai setHidden:YES];
        rFrame.size.height = rViewThongTin.size.height + rViewXacNhan.size.height;
        self.heightButtonDongY.constant = 35.0;
        [_mViewXacNhan setHidden:NO];
    }
    else if (typeShow == KIEU_NOTIFICATION_MUON_TIEN  && statusShow == TRANG_THAI_SHOW_NOTIFICATION_DA_TU_CHOI)
    {
        [_mlblTrangThai setHidden:NO];
        [_mlblTrangThai setText:@"Đã từ chối"];
        rFrame.size.height = rViewThongTin.size.height;
        [_mViewXacNhan setHidden:YES];
    }
    else if (typeShow == KIEU_NOTIFICATION_MUON_TIEN  && statusShow == TRANG_THAI_SHOW_NOTIFICATION_DA_DONG_Y)
    {
        [_mlblTrangThai setHidden:NO];
        [_mlblTrangThai setText:@"Đã đồng ý"];
        rFrame.size.height = rViewThongTin.size.height;
        [_mViewXacNhan setHidden:YES];
    }
    else if (typeShow == TYPE_SHOW_HIEN_THI_THONG_BAO_DOANH_NGHIEP  && statusShow == DOANH_NGHIEP_DA_HUY)
    {
        [_mlblTrangThai setHidden:NO];
        [_mlblTrangThai setText:@"Đã huỷ"];
        rFrame.size.height = rViewThongTin.size.height;
        [_mViewXacNhan setHidden:YES];
    }
    else if (typeShow == TYPE_SHOW_HIEN_THI_THONG_BAO_DOANH_NGHIEP  && statusShow == DOANH_NGHIEP_DUYET_LENH_THANH_CONG)
    {
        [_mlblTrangThai setHidden:NO];
        [_mlblTrangThai setText:@"Đã duyệt"];
        rFrame.size.height = rViewThongTin.size.height;
        [_mViewXacNhan setHidden:YES];
    }
    else if (typeShow == TYPE_SHOW_HIEN_THI_THONG_BAO_DOANH_NGHIEP  && statusShow == DOANH_NGHIEP_HET_HAN_DUYET)
    {
        [_mlblTrangThai setHidden:NO];
        [_mlblTrangThai setText:@"Đã hết hạn"];
        rFrame.size.height = rViewThongTin.size.height;
        [_mViewXacNhan setHidden:YES];
    }
    else if (typeShow == TYPE_SHOW_HIEN_THI_THONG_BAO_DOANH_NGHIEP  && statusShow == DOANH_NGHIEP_LAP_LENH_THANH_CONG)
    {
        int nSoNgay = [self tinhSoNgayGiuaNgay1:[_mDoiTuongNotification layThoiGianTraVeNSDate] vaNgay2:[NSDate date]];
        [_mlblTrangThai setHidden:NO];
        if(nSoNgay == 0)
            [_mlblTrangThai setText:@"Đang chờ duyệt"];
        else
            [_mlblTrangThai setText:@"Đã hết hạn"];
        
        rFrame.size.height = rViewThongTin.size.height;
        [_mViewXacNhan setHidden:YES];
    }
    else if (typeShow == TYPE_SHOW_HIEN_THI_THONG_BAO_DOANH_NGHIEP  && statusShow == DOANH_NGHIEP_DUYET_LENH_XOA)
    {
        [_mlblTrangThai setText:@"Đã xoá"];
        rFrame.size.height = rViewThongTin.size.height;
        [_mViewXacNhan setHidden:YES];
    }
    else
    {
        [_mlblTrangThai setHidden:YES];
        [_mlblTrangThai setText:@"Đã đồng ý"];
        rFrame.size.height = rViewThongTin.size.height;
        [_mViewXacNhan setHidden:YES];
    }
    
    _mlblTieuDe.text = _mDoiTuongNotification.alert;
    if([_mDoiTuongNotification.status intValue] == 1)
    {
        _mlblTieuDe.textColor = [UIColor grayColor];
    }
    else if([_mDoiTuongNotification.status intValue] == 0)
    {
        _mlblTieuDe.textColor = [UIColor colorWithRed:16.0/255.0 green:122.0/255.0 blue:170.0/255.0 alpha:1];
    }
    _mlblChuThich.text = _mDoiTuongNotification.alertContent;
    _mlblThoiGian.text = [_mDoiTuongNotification layThoiGian];
    
    self.frame = rFrame;
    
    UIImage *image = [self getImageForNotification];
    [self.mbtnDaiDien setImage:image forState:UIControlStateNormal];
    
    [self setNeedsDisplay];
}

- (void)setMTrangThaiXoa:(BOOL)mTrangThaiXoa
{
    _mTrangThaiXoa = mTrangThaiXoa;
    if (mTrangThaiXoa) {
        [_mbtnDaiDien setImage:[UIImage imageNamed:@"icon_un_tick_thong_bao"] forState:UIControlStateNormal];
    } else {
        UIImage *image = [self getImageForNotification];
        [self.mbtnDaiDien setImage:image forState:UIControlStateNormal];
    }
//    CGRect rViewThongTin = self.mViewHienThiThongTin.frame;
//    CGRect rBtnDaiDien = self.mbtnDaiDien.frame;
//    if (mTrangThaiXoa)
//    {
//        [_mbtnDaiDien setBackgroundImage:[UIImage imageNamed:@"tick48"] forState:UIControlStateNormal];
//        [_mbtnDaiDien setHidden:NO];
//        rViewThongTin.origin.x = 2*rBtnDaiDien.origin.x + rBtnDaiDien.size.width;
//        rViewThongTin.size.width = self.bounds.size.width - rViewThongTin.origin.x;
//    }
//    else
//    {
//        rViewThongTin.origin.x = rBtnDaiDien.origin.x + rBtnDaiDien.size.width / 2;
//        rViewThongTin.size.width = self.bounds.size.width - rViewThongTin.origin.x;
//        [_mbtnDaiDien setBackgroundImage:[UIImage imageNamed:@"icon_notification_mess"] forState:UIControlStateNormal];
//        [_mbtnDaiDien setHidden:YES];
//    }
//    self.mViewHienThiThongTin.frame = rViewThongTin;
}

- (void)setMViTri:(int)mViTri
{
    _mViTri = mViTri;
    _mbtnDaiDien.tag = mViTri;
}

- (IBAction)suKienBamNutDongY:(id)sender
{
    if([self.mDelegate respondsToSelector:@selector(xuLySuKienBamNutDongYMuonTienTai:)])
    {
        [self.mDelegate xuLySuKienBamNutDongYMuonTienTai:self];
    }
}

- (IBAction)suKienBamNutTuChoi:(id)sender
{
    if([self.mDelegate respondsToSelector:@selector(xuLySuKienBamNutTuChoiMuonTienTai:)])
    {
        [self.mDelegate xuLySuKienBamNutTuChoiMuonTienTai:self];
    }
}

- (IBAction)suKienBamNutDaiDien:(id)sender {
    if([self.mDelegate respondsToSelector:@selector(xuLySuKienBamNutDaiDien:)])
    {
        [self.mDelegate xuLySuKienBamNutDaiDien:sender];
    }
}

- (CGFloat)height
{
    return 115.0f;
}


- (int)tinhSoNgayGiuaNgay1:(NSDate*)date1 vaNgay2:(NSDate*)date2
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    calendar.locale = [NSLocale currentLocale];
    unsigned int unitFlags = NSCalendarUnitDay;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date1  toDate:date2  options:0];
    return (int)[comps day];
}

- (void)dealloc {
    if(_mDoiTuongNotification)
        [_mDoiTuongNotification release];
    [_mlblTieuDe release];
    [_mlblChuThich release];
    [_mlblThoiGian release];
    [_mbtnDaiDien release];
    [_mlblTrangThai release];
    [_mViewHienThiThongTin release];
    [_mViewXacNhan release];
    [_heightButtonDongY release];
    [super dealloc];
}
@end
