//
//  ViewThuongDungTienDien.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 5/30/16.
//
//

#import "ViewThuongDungTienDien.h"
#import "Alert+Block.h"
#import "DucNT_LuuRMS.h"
#import "Common.h"

@implementation ViewThuongDungTienDien

- (void)setMTaiKhoanThuongDung:(DucNT_TaiKhoanThuongDungObject *)mTaiKhoanThuongDung{
    if(mTaiKhoanThuongDung)
    {
        if(_mTaiKhoanThuongDung)
            [_mTaiKhoanThuongDung release];
        _mTaiKhoanThuongDung = [mTaiKhoanThuongDung retain];
        _edNameAlias.text = mTaiKhoanThuongDung.sAliasName;
        _edMaKhachHang.text = mTaiKhoanThuongDung.maKhachHang;
    }
}

- (BOOL)kiemTraNoiDung {
    if ([_edNameAlias.text isEmpty]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập tên hiển thị"];
        return NO;
    }
    if ([_edMaKhachHang.text isEmpty]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập mã khách hàng"];
        return NO;
    }
    return YES;
}

- (DucNT_TaiKhoanThuongDungObject*)getTaiKhoanThuongDungDayLenServer{
    DucNT_TaiKhoanThuongDungObject *taiKhoanThuongDung = nil;
    if([self kiemTraNoiDung])
    {
        if(_mTaiKhoanThuongDung)
        {
            taiKhoanThuongDung = _mTaiKhoanThuongDung;
        }
        else
        {
            taiKhoanThuongDung = [[[DucNT_TaiKhoanThuongDungObject alloc] init] autorelease];
        }
        NSString *sID = @"";
        int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
        if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
        {
            sID = [DucNT_LuuRMS layThongTinDangNhap:KEY_DINH_DANH_DOANH_NGHIEP];
        }
        else if(nKieuDangNhap == KIEU_CA_NHAN)
        {
            sID = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
        }
        taiKhoanThuongDung.sPhoneOwner = sID;
        taiKhoanThuongDung.nType = TAI_KHOAN_CHUYEN_TIEN_CMND;
        taiKhoanThuongDung.sAliasName = self.edNameAlias.text;
        taiKhoanThuongDung.maKhachHang = self.edMaKhachHang.text;
    }
    return taiKhoanThuongDung;
}

- (void)hienThiHopThoaiMotNutBamKieu:(int)nIndex cauThongBao:(NSString *)sThongBao {
    [UIAlertView alert:sThongBao withTitle:@"Thông báo" block:nil];
}

- (void)dealloc {
    [_edNameAlias release];
    [_edMaKhachHang release];
    [super dealloc];
}
@end
