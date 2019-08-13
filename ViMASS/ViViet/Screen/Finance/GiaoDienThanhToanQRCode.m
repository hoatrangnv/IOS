//
//  GiaoDienThanhToanQRCode.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 11/8/17.
//

#import "GiaoDienThanhToanQRCode.h"
#import "DucNT_LoginSceen.h"
#import "CommonUtils.h"
@interface GiaoDienThanhToanQRCode ()<UIGestureRecognizerDelegate> {
    NSDictionary *dictKetQua;
    BOOL isLongPress;
}

@end

@implementation GiaoDienThanhToanQRCode

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Thanh toán QR";
    self.lblTenSP.text = @"";
    self.mDinhDanhKetNoi = @"KET_NOI_LAY_QRCODE";
    [GiaoDichMang layThongTinSanPhamQRCode:self.sIdQRCode noiNhanKetQua:self];

    isLongPress = NO;
    self.imgvQR.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longHander = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleHoldGesture:)];
    longHander.delegate = self;
    longHander.minimumPressDuration = 1;
    [self.imgvQR addGestureRecognizer:longHander];

    UITapGestureRecognizer *tapHander = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.imgvQR addGestureRecognizer:tapHander];
    
    self.heightViewNhanHang.constant = 0.0;
    self.heightContentView.constant = -300.0;
    [self.viewThongTInNhanHang setHidden:YES];
    
    UITapGestureRecognizer *tapAvatar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(suKienChonPhongToAvatar:)];
    [self.imgvAvatar setUserInteractionEnabled:YES];
    [self.imgvAvatar addGestureRecognizer:tapAvatar];
    
    UITapGestureRecognizer *tapQR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(suKienChonPhongToQR:)];
    [self.imgvQR setUserInteractionEnabled:YES];
    [self.imgvQR addGestureRecognizer:tapQR];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)suKienChonPhongToAvatar:(UITapGestureRecognizer *)gesture {
    NSString *image = (NSString *)[dictKetQua objectForKey:@"image"];
    if ([image containsString:@";"]) {
        image = [[image componentsSeparatedByString:@";"] firstObject];
    }
    if (![image hasPrefix:@"https"]) {
        image = [NSString stringWithFormat:@"https://vimass.vn/vmbank/services/media/getImage?id=%@", image];
    }
    [CommonUtils displayImage:[NSURL URLWithString:image] toImageView:self.imgvPhongTo placeHolder:[UIImage imageNamed:@"icon_danhba"]];
    [self.viewPhongTo setHidden:NO];
}

- (void)suKienChonPhongToQR:(UITapGestureRecognizer *)gesture {
    NSString *linkQR = (NSString *)[dictKetQua objectForKey:@"linkQR"];
    [CommonUtils displayImage:[NSURL URLWithString:linkQR] toImageView:self.imgvPhongTo placeHolder:[UIImage imageNamed:@"icon_danhba"]];

    [self.viewPhongTo setHidden:NO];
}

- (void) handleHoldGesture:(UILongPressGestureRecognizer *)gestureRecognizer
{
    NSLog(@"%s - START", __FUNCTION__);
    if (!isLongPress) {
        isLongPress = YES;
        [self showThongBaoLuuQRCode];
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)gestureRecognizer {

}

- (void)showThongBaoLuuQRCode {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Thông báo" message:@"Lưu ảnh QRCode vào thư viện ảnh của điện thoại?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Đóng" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        isLongPress = NO;
    }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Lưu" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImage *img = self.imgvQR.image;
        if (img != nil) {
            UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
        }
        [alert dismissViewControllerAnimated:YES completion:^{
        }];
    }];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)xuLyKetNoiThanhCong:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua{
    if ([sDinhDanhKetNoi isEqualToString:@"KET_NOI_LAY_QRCODE"]) {
        NSDictionary *dict = (NSDictionary *)ketQua;
        dictKetQua  = [[NSDictionary alloc] initWithDictionary:dict];
        NSString *ten = (NSString *)[dict objectForKey:@"ten"];
        NSString *noiDung = (NSString *)[dict objectForKey:@"noiDung"];
        self.lblTenSP.text = noiDung;
        double soTien = [[dict objectForKey:@"gia"] doubleValue];
        self.lblSoTien.text = [Common hienThiTienTe:soTien];
        NSDictionary *dictDonVi = [dict objectForKey:@"objectThongTinDonViThanhToan"];
        NSString *tenHienThi = (NSString *)[dictDonVi objectForKey:@"tenHienThi"];
        NSString *linkQR = (NSString *)[dict objectForKey:@"linkQR"];
        [CommonUtils displayImage:[NSURL URLWithString:linkQR] toImageView:self.imgvQR placeHolder:[UIImage imageNamed:@"icon_danhba"]];

        NSString *image = (NSString *)[dict objectForKey:@"image"];
        if ([image containsString:@";"]) {
            image = [[image componentsSeparatedByString:@";"] firstObject];
        }
        if (![image hasPrefix:@"https"]) {
            image = [NSString stringWithFormat:@"https://vimass.vn/vmbank/services/media/getImage?id=%@", image];
        }
        [self.imgvAvatar sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"icon_danhba"]];
        self.lblTenCty.text = ten;
        
        int hienThiThongTinNguoiNhan = [[dict valueForKey:@"hienThiThongTinNguoiNhan"] intValue];
        if (hienThiThongTinNguoiNhan == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.heightViewNhanHang.constant = 250.0;
                self.heightContentView.constant = 0;
                [self.viewThongTInNhanHang setHidden:NO];
            });
        }
    }
}

- (BOOL)validateVanTay {
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return NO;
    }
    if ([self.edSoTien.text isEmpty]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Số tiền không được để trống."];
        return NO;
    }
    if (!self.viewThongTInNhanHang.isHidden) {
        if ([self.edHoTenNhanHang.text isEmpty]) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Họ và tên người nhận hàng không được để trống."];
            return NO;
        }
        if ([self.edSoDTNhanHang.text isEmpty]) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Số điện thoại người nhận hàng không được để trống."];
            return NO;
        }
        if ([self.edDiaChiNhanHang.text isEmpty]) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Địa chỉ nhận hàng không được để trống."];
            return NO;
        }
    }
    return true;
}

- (IBAction)suKienNhapSoTien:(id)sender {
    NSString *sSoTien = [_edSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    _edSoTien.text = [Common hienThiTienTeFromString:sSoTien];
}

- (IBAction)suKienDongPhongTo:(id)sender {
    [self.viewPhongTo setHidden:!self.viewPhongTo.isHidden];
}

- (void)xuLyThucHienKhiKiemTraThanhCongTraVeToken:(NSString *)sToken otp:(NSString *)sOtp {
    NSString *sMaDoanhNghiep = @"";
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sMaDoanhNghiep = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_COMPANY_ID];
    }
    NSString *maDonVi = [NSString stringWithFormat:@"%@%@", (NSString *)[dictKetQua objectForKey:@"maDaiLy"], (NSString *)[dictKetQua objectForKey:@"tkNhanTien"]];
    int giauViChuyen = 0;
    if (self.swHienSoVi.on){
        giauViChuyen = 1;
    }
    NSDictionary *dicPost = @{
                              @"companyCode":sMaDoanhNghiep,
                              @"loaiHinhThanhToan": [NSNumber numberWithInt:0],
                              @"maDonViThanhToan":maDonVi,
                              @"soTien":[dictKetQua objectForKey:@"gia"],
                              @"tenSP":(NSString *)[dictKetQua objectForKey:@"ten"],
                              @"maDonHang":(NSString *)[dictKetQua objectForKey:@"maGiaoDich"],
                              @"noiDung": (NSString *)[dictKetQua objectForKey:@"noiDung"],
                              @"idViThanhToan":[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                              @"appId" : [NSString stringWithFormat:@"%d", APP_ID],
                              @"token": sToken,
                              @"otpConfirm": sOtp,
                              @"typeAuthenticate": [NSNumber numberWithInt:self.mTypeAuthenticate],
                              @"VMApp" : [NSNumber numberWithInt:VM_APP],
                              @"tenNguoiNhanHang":self.edHoTenNhanHang.text,
                              @"soDienThoaiNguoiNhan":self.edSoDTNhanHang.text,
                              @"emailNguoiNhan":self.edEmailNhanHang.text,
                              @"diaChiNguoiNhan":self.edDiaChiNhanHang.text,
                              @"cmndNguoiNhan":self.edCMNDNhanHang.text,
                              @"maKhachHang":self.edMaKHNhanHang.text,
                              @"giauViChuyen":[NSNumber numberWithInt:giauViChuyen]
                              };
    self.mDinhDanhKetNoi = @"KET_NOI_MUA_SAN_PHAM_QR";
    [GiaoDichMang muaSanPhamTuQRCode:[dicPost JSONString] noiNhanKetQua:self];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_lblSanPham release];
    [_lblSoTien release];
    [_lblTenCty release];
    [_imgvAvatar release];
    [_imgvQR release];
    [_lblTenSP release];
    [_edSoTien release];
    [_swHienSoVi release];
    [_viewThongTInNhanHang release];
    [_heightViewNhanHang release];
    [_heightContentView release];
    [_imgvPhongTo release];
    [_viewPhongTo release];
    [_edHoTenNhanHang release];
    [_edSoDTNhanHang release];
    [_edEmailNhanHang release];
    [_edDiaChiNhanHang release];
    [_edCMNDNhanHang release];
    [_edMaKHNhanHang release];
    [super dealloc];
}

@end
