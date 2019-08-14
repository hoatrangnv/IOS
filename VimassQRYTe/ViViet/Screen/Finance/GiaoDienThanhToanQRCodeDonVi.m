//
//  GiaoDienThanhToanQRCodeDonVi.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 11/16/17.
//

#import "GiaoDienThanhToanQRCodeDonVi.h"
#import "DucNT_LoginSceen.h"
#import "CommonUtils.h"
@interface GiaoDienThanhToanQRCodeDonVi () <UIGestureRecognizerDelegate>{
    NSString *maQRViThanhToan;
    BOOL isLongPress;
}

@end

@implementation GiaoDienThanhToanQRCodeDonVi

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Thanh toán QR";
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hienThiLoading];
    });
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
    }
    if (self.typeQRCode == 0) {
        self.mFuncID = 458;
        self.mDinhDanhKetNoi = @"KET_NOI_LAY_QRCODE_DON_VI";
        [GiaoDichMang layThongTinDonViQRCode:self.sIdQRCode noiNhanKetQua:self];
    }
    else {
        self.mFuncID = 459;
        self.mDinhDanhKetNoi = @"KET_NOI_LAY_QRCODE_VI";
        [GiaoDichMang layThongTinViQRCode:self.sIdQRCode noiNhanKetQua:self];
    }

    isLongPress = NO;
    self.imgvQR.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longHander = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleHoldGesture:)];
    longHander.delegate = self;
    longHander.minimumPressDuration = 1;
    [self.imgvQR addGestureRecognizer:longHander];
    
    NSLog(@"%s - START", __FUNCTION__);
    [self.mbtnToken setHidden:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tvNoiDung resignFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tvNoiDung resignFirstResponder];
}

- (void) handleHoldGesture:(UILongPressGestureRecognizer *)gestureRecognizer
{
    NSLog(@"%s - START", __FUNCTION__);
    if (!isLongPress) {
        isLongPress = YES;
        [self showThongBaoLuuQRCode];
    }
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

- (IBAction)changeSoTien:(id)sender {
    NSString *sSoTien = [_edSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    _edSoTien.text = [Common hienThiTienTeFromString:sSoTien];
}

- (void)xuLyKetNoiThanhCong:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self anLoading];
    });
    if([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_CHUYEN_TIEN_DEN_VI])
    {
        [self hienThiHopThoaiMotNutBamKieu:HOP_THOAI_XAC_NHAN_CHUYEN_TIEN_THANH_CONG cauThongBao:sThongBao];
    }
    else
    {
        NSDictionary *dict = (NSDictionary *)ketQua;
        NSString *avatar = @"";
        if ([sDinhDanhKetNoi isEqualToString:@"KET_NOI_LAY_QRCODE_DON_VI"]) {
            NSString *tenDaiLy = (NSString *)[dict objectForKey:@"tenHienThi"];
            NSString *tenHienThi = @"";
            avatar = (NSString *)[dict objectForKey:@"imageCompany1"];
            if (![avatar hasPrefix:@"https"]) {
                avatar = [NSString stringWithFormat:@"https://vimass.vn/vmbank/services/media/getImage?id=%@", avatar];
            }
            maQRViThanhToan = (NSString *)[dict objectForKey:@"maDaiLy"];
            NSString *linkQR = (NSString *)[dict objectForKey:@"linkQR"];
            self.lblTenCty.text = tenDaiLy;
            self.lblTenNguoiNhan.text = tenHienThi;
            [CommonUtils displayImage:[NSURL URLWithString:linkQR] toImageView:self.imgvQR placeHolder:[UIImage imageNamed:@"icon_danhba"]];
        }
        else if ([sDinhDanhKetNoi isEqualToString:@"KET_NOI_LAY_QRCODE_VI"]) {
            avatar = (NSString *)[dict objectForKey:@"avatar"];
            if (![avatar hasPrefix:@"https"]) {
                avatar = [NSString stringWithFormat:@"https://vimass.vn/vmbank/services/media/getImage?id=%@", avatar];
            }
            maQRViThanhToan = (NSString *)[dict objectForKey:@"maGiaoDich"];
            NSString *linkQR = (NSString *)[dict objectForKey:@"linkQR"];
            [CommonUtils displayImage:[NSURL URLWithString:linkQR] toImageView:self.imgvQR placeHolder:[UIImage imageNamed:@"icon_danhba"]];
            NSString *nameAlias = (NSString *)[dict objectForKey:@"nameAlias"];
            self.lblTenCty.text = nameAlias;
            self.lblTenNguoiNhan.text = @"";
            int nHienNoiDung = [[dict objectForKey:@"hienThiNoiDungThanhToanQR"] intValue];
            if (nHienNoiDung == 0) {
                [self.edNoiDung setHidden:YES];
                [self.tvNoiDung setHidden:YES];
                self.constantHeightNoiDung.constant = 0.0;
                self.constantHeightViewMain.constant = -50;
                [self.mViewMain setNeedsLayout];
                [self.mViewMain layoutIfNeeded];
            }
        }
        
        [self.imgvAvatar sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"icon_danhba"]];
    }

}

- (void)xuLyKetNoiThatBai:(NSString*)sDinhDanhKetNoi thongBao:(NSString*)sThongBao ketQua:(id)ketQua
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self anLoading];
    });
    [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
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
    return YES;
}

- (void)xuLyThucHienKhiKiemTraThanhCongTraVeToken:(NSString *)sToken otp:(NSString *)sOtp {
    NSLog(@"%s - sToken : %@ - otp : %@ - maQRViThanhToan : %@", __FUNCTION__, sToken, sOtp, maQRViThanhToan);
    self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_CHUYEN_TIEN_DEN_VI;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hienThiLoadingChuyenTien];
        NSString *sSoTien = [_edSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""];
        double fSoTien = [sSoTien doubleValue];
        int giauViChuyen = 0;
        if (self.typeQRCode == 0) {
            NSDictionary *dic = @{
                                  @"token" : sToken,
                                  @"otpConfirm" : sOtp,
                                  @"typeAuthenticate" : [NSNumber numberWithInt:self.mTypeAuthenticate],
                                  @"idViThanhToan" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                                  @"appId"         : [NSNumber numberWithInt:APP_ID],
                                  @"VMApp" : [NSNumber numberWithInt:VM_APP],
                                  @"maDaiLy" : maQRViThanhToan,
                                  @"soTien" : [NSNumber numberWithDouble:fSoTien],
                                  @"noiDung" : self.edNoiDung.text,
                                  @"giauViChuyen":[NSNumber numberWithInt:giauViChuyen]
                                  };
//            [GiaoDichMang chuyenTienDenDonViBangQRCode:[dic JSONString] noiNhanKetQua:self];
            [self chuyenTienDenDonViBangQRCode:[dic JSONString]];
        }
        else {
            NSDictionary *dic = @{
                                  @"token" : sToken,
                                  @"otpConfirm" : sOtp,
                                  @"typeAuthenticate" : [NSNumber numberWithInt:self.mTypeAuthenticate],
                                  @"idViThanhToan" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                                  @"appId"         : [NSNumber numberWithInt:APP_ID],
                                  @"VMApp" : [NSNumber numberWithInt:VM_APP],
                                  @"maQRViThanhToan" : maQRViThanhToan,
                                  @"soTien" : [NSNumber numberWithDouble:fSoTien],
                                  @"noiDung" : self.edNoiDung.text,
                                  @"giauViChuyen":[NSNumber numberWithInt:giauViChuyen]
                                  };
            NSLog(@"%s - dic : %@", __FUNCTION__, [dic JSONString]);
//            [GiaoDichMang chuyenTienDenViBangQRCode:[dic JSONString] noiNhanKetQua:self];
            [self chuyenTienDenViBangQRCode:[dic JSONString]];
        }
    });
}

- (void)chuyenTienDenDonViBangQRCode:(NSString *)dic {
    [GiaoDichMang chuyenTienDenDonViBangQRCode:dic noiNhanKetQua:self];
}

- (void)chuyenTienDenViBangQRCode:(NSString *)dic {
    [GiaoDichMang chuyenTienDenViBangQRCode:dic noiNhanKetQua:self];
}

- (void)dealloc {
    [_lblTenCty release];
    [_lblTenNguoiNhan release];
    [_imgvAvatar release];
    [_edSoTien release];
    [_edNoiDung release];
    [_tvNoiDung release];
    [_constantHeightNoiDung release];
    [_constantHeightViewMain release];
    [super dealloc];
}

@end
