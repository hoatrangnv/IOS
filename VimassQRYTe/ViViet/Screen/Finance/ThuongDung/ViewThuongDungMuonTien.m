//
//  ViewThuongDungMuonTien.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 2/7/17.
//
//

#import "ViewThuongDungMuonTien.h"
#import "Common.h"
#import "Alert+Block.h"
#import "DucNT_LuuRMS.h"
@implementation ViewThuongDungMuonTien

//- (void)awakeFromNib {
//}

- (void)setMTaiKhoanThuongDung:(DucNT_TaiKhoanThuongDungObject *)mTaiKhoanThuongDung{
    if(mTaiKhoanThuongDung)
    {
        NSLog(@"%s - xu ly hien thi thong tin", __FUNCTION__);
        if(_mTaiKhoanThuongDung)
            [_mTaiKhoanThuongDung release];
        _mTaiKhoanThuongDung = [mTaiKhoanThuongDung retain];
        _edNameAlias.text = mTaiKhoanThuongDung.sAliasName;
        self.tvNoiDung.text = mTaiKhoanThuongDung.noiDung;
        self.edSoTien.text = [Common hienThiTienTe:mTaiKhoanThuongDung.soTien];
        self.edSoVi.text = mTaiKhoanThuongDung.sToAccWallet;
    }
}

- (BOOL)kiemTraNoiDung {
    if ([_edNameAlias.text isEmpty]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập tên hiển thị"];
        return NO;
    }
    if ([_edSoVi.text isEmpty]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng số ví mượn tiền"];
        return NO;
    }
    return YES;
}

- (void)hienThiHopThoaiMotNutBamKieu:(int)nIndex cauThongBao:(NSString *)sThongBao {
    [UIAlertView alert:sThongBao withTitle:@"Thông báo" block:nil];
}

- (DucNT_TaiKhoanThuongDungObject*)getTaiKhoanThuongDungDayLenServer {
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
        taiKhoanThuongDung.nType = TAI_KHOAN_MUON_TIEN;
        taiKhoanThuongDung.sAliasName = self.edNameAlias.text;
        taiKhoanThuongDung.sToAccWallet = self.edSoVi.text;
        double fSoTien = [[[self.edSoTien.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
        taiKhoanThuongDung.soTien = fSoTien;
    }
    return taiKhoanThuongDung;
}

- (IBAction)suKienBamNutDanhBa:(id)sender {
    if (self.mDelegate) {
        [self.mDelegate xuLySuKienBamNutDanhBaMuonTien];
    }
}

- (void)capNhatViMuonTien:(NSString *)sSoVi {
    self.edSoVi.text = sSoVi;
}

- (void)dealloc {
    [_edNameAlias release];
    [_edSoTien release];
    [_edSoVi release];
    [_tvNoiDung release];
    [super dealloc];
}

@end
