//
//  TaoQRSanPhamViewController.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 12/5/17.
//

#import "TaoQRSanPhamViewController.h"
#import "CropImageHelper.h"
#import "Base64.h"
#import "UIImageView+WebCache.h"
#import <objc/runtime.h>
#import "CommonUtils.h"
@interface TaoQRSanPhamViewController () {
    BOOL bTrangThaiCoAnhDaiDienMoi;
    NSString *sMaOTP;
    NSString *sMaGiaoDich;
    NSString *sLinkAnhOld;
    NSArray<__kindof NSLayoutConstraint *> *constraintThoiGian;
}

@end

@implementation TaoQRSanPhamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Tạo QR sản phẩm";
    sMaOTP = @"";
    
    self.edTenSP.inputAccessoryView = nil;
    self.edGiaTien.inputAccessoryView = nil;
    self.edNoiDung.inputAccessoryView = nil;
    self.umiThongBao.inputAccessoryView = nil;
    self.tfThongBao.inputAccessoryView = nil;
    if (self.nType == 0) {
        self.heightViewEdit.constant = 0.0;
        [self.viewEdit setHidden:YES];
    }
    else {
        self.navigationItem.title = @"QR sản phẩm";
        [self khoiTaoThongTinSanPham];
    }
    constraintThoiGian = self.viewThoiGian.constraints;
    NSLog(@"%s - UIScreenHeight : %f", __FUNCTION__, UIScreenHeight);
    if (UIScreenHeight >= 736.0) {
        //self.heightMainConstrant.constant = -220;
    }
    // HOANHNV FIX
    self.edtVilienket1.attributedPlaceholder =[[NSAttributedString alloc] initWithString:[@"co_the_bo_qua_vi_lien_ket_1" localizableString] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.edtVilienket2.attributedPlaceholder =[[NSAttributedString alloc] initWithString:[@"co_the_bo_qua_vi_lien_ket_2" localizableString] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.edtVilienket3.attributedPlaceholder =[[NSAttributedString alloc] initWithString:[@"co_the_bo_qua_vi_lien_ket_3" localizableString] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.edtVilienket4.attributedPlaceholder =[[NSAttributedString alloc] initWithString:[@"co_the_bo_qua_vi_lien_ket_4" localizableString] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.edtVilienket5.attributedPlaceholder =[[NSAttributedString alloc] initWithString:[@"co_the_bo_qua_vi_lien_ket_5" localizableString] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    //END
//    [self.scrollView addSubview:self.mViewMain];
//    [self.mViewMain sizeToFit];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view endEditing:YES];
}

-(NSString*)dsNhanThongBao{
    NSMutableString *strFormat = [NSMutableString string];
    [strFormat appendString:@""];
    if([CommonUtils isEmptyOrNull:self.edtVilienket1.text] == false){
        [strFormat appendFormat:@"%@",self.edtVilienket1.text];
    }
    if ([CommonUtils isEmptyOrNull:self.edtVilienket2.text] == false){
        [strFormat appendFormat:@",%@",self.edtVilienket2.text];
    }
    if ([CommonUtils isEmptyOrNull:self.edtVilienket2.text] == false){
        [strFormat appendFormat:@",%@",self.edtVilienket2.text];
    }
    if ([CommonUtils isEmptyOrNull:self.edtVilienket3.text] == false){
        [strFormat appendFormat:@",%@",self.edtVilienket3.text];
    }
    if ([CommonUtils isEmptyOrNull:self.edtVilienket4.text] == false){
        [strFormat appendFormat:@",%@",self.edtVilienket4.text];
    }
    if ([CommonUtils isEmptyOrNull:self.edtVilienket5.text] == false){
        [strFormat appendFormat:@",%@",self.edtVilienket5.text];
    }
    return strFormat;
}
- (void)khoiTaoThongTinSanPham {
    NSString *maGiaoDich = (NSString *)[self.dictSanPham objectForKey:@"maGiaoDich"];
    sMaGiaoDich = [[NSString alloc] initWithString:maGiaoDich];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
        [self hienThiLoading];
    }
    self.mDinhDanhKetNoi = @"LAY_CHI_TIET_SAN_PHAM";
    [GiaoDichMang layThongTinSanPhamQRCode:sMaGiaoDich noiNhanKetQua:self];
}

- (IBAction)suKienChonChupAnh:(id)sender {
    __block typeof (self) weak = self;
    [self capture:UIImagePickerControllerSourceTypeCamera withImageView:self.imgvSP completed:^(BOOL change) {
        weak->bTrangThaiCoAnhDaiDienMoi = change;
    }];
}

- (IBAction)suKienChonLayAnh:(id)sender {
    __block typeof (self) weak = self;
    [self capture:UIImagePickerControllerSourceTypePhotoLibrary withImageView:self.imgvSP completed:^(BOOL change) {
        NSLog(@"%s - lay anh dai dien change : %d", __FUNCTION__, change);
        weak->bTrangThaiCoAnhDaiDienMoi = change;
        if (weak->bTrangThaiCoAnhDaiDienMoi) {
            NSLog(@"%s ======== bTrangThaiCoAnhDaiDienMoi == YES", __FUNCTION__);
        }
    }];
}

- (BOOL)kiemTraDieuDien {
    if ([self.edTenSP.text isEmpty]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Tên sản phẩm không được để trống"];
        return NO;
    }
    if ([self.edGiaTien.text isEmpty]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Giá tiền không được để trống"];
        return NO;
    }
    if (self.nType == 0 && !bTrangThaiCoAnhDaiDienMoi) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng chọn ảnh đại diện cuả sản phẩm"];
        return NO;
    }
    return YES;
}

- (IBAction)suKienChonTaoQRSanPham:(id)sender {
    NSString *sBase64 = [self convertImageToBase64:self.imgvSP.image];
    [self uploadAnh:sBase64];
}

-(void)uploadAnh:(NSString *)sDuLieuAnhBase64
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
        [self hienThiLoadingChuyenTien];
    }
    NSLog(@"%s - sDuLieuAnhBase64.length : %ld", __FUNCTION__, (unsigned long)sDuLieuAnhBase64.length);
    self.mDinhDanhKetNoi = @"TRANG_THAI_UP_DU_LIEU_ANH_SAN_PHAM";
    NSString *sUrl = [NSString stringWithFormat:@"%@%@", @"https://vimass.vn/vmbank/services/media/upload/", [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP]];
    NSLog(@"%s - sUrl : %@", __FUNCTION__, sUrl);
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:self];
    [connect connect:sUrl withContent:sDuLieuAnhBase64];
    [connect release];
}

- (IBAction)changeSoTien:(id)sender {
    NSString *sSoTien = [_edGiaTien.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    _edGiaTien.text = [Common hienThiTienTeFromString:sSoTien];
}

- (IBAction)suKienXoaSanPham:(id)sender {
    self.bHienViewXacThuc = YES;
    self.mtfMatKhauToken.text = @"";
    self.mtfMatKhauTokenView.text = @"";
    [UIView animateWithDuration:0.1 animations:^{
        [self.viewXacThuc setHidden:NO];
    }];
}

- (IBAction)suKienXemGiaoDich:(id)sender {
}

- (IBAction)suKienDongViewXacThuc:(id)sender {
    self.bHienViewXacThuc = NO;
    self.mtfMatKhauToken.text = @"";
    self.mtfMatKhauTokenView.text = @"";
    [UIView animateWithDuration:0.1 animations:^{
        [self.viewXacThuc setHidden:YES];
    }];
}

- (void)hienThiThongBaoNhapOTP:(NSString *)sLinkAnh {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Thông báo" message: @"Nhập mã xác thực OTP được gửi về tin nhắn." preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"OTP xác thực";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Xác thực" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * maOTP = textfields[0];
        NSLog(@"%s - maOTP : %@", __FUNCTION__, maOTP);
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
            [self hienThiLoadingChuyenTien];
        }
        NSString *sSoTien = [_edGiaTien.text stringByReplacingOccurrencesOfString:@"." withString:@""];
        double fSoTien = [sSoTien doubleValue];
        NSDictionary *dic = @{
                              @"ten" : self.edTenSP.text,
                              @"gia" : [NSNumber numberWithDouble:fSoTien],
                              @"image" : sLinkAnh,
                              @"video" : @"",
                              @"noiDung" : self.edNoiDung.text,
                              @"VMApp" : [NSNumber numberWithInt:VM_APP],
                              @"deviceId" : [NSNumber numberWithInt:DEVICE_REGIS_ID],
                              @"dsTKNhanThongBaoBienDongSoDu":[self dsNhanThongBao]
                              };
        self.mDinhDanhKetNoi = @"TAO_QR_SAN_PHAM";

    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Huỷ" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (BOOL)validateVanTay {
    if ([self.edTenSP.text isEmpty]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Tên sản phẩm không được để trống."];
        return NO;
    }
    if ([self.edGiaTien.text isEmpty]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Giá tiền không được để trống."];
        return NO;
    }
    return YES;
}

- (void)xuLyThucHienKhiKiemTraThanhCongTraVeToken:(NSString *)sToken otp:(NSString *)sOtp {
    if (self.mTypeAuthenticate == 0) {
        sMaOTP = [sToken copy];
    }
    else {
        sMaOTP = sOtp;
    }
    NSLog(@"%s - sMaOTP : %@", __FUNCTION__, sMaOTP);
    if (self.nType == 0) {
        NSString *sBase64 = [self convertImageToBase64:self.imgvSP.image];
        [self uploadAnh:sBase64];
    }
    else {
        if (!self.viewXacThuc.isHidden) {
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
                [self hienThiLoadingChuyenTien];
            }
            self.mDinhDanhKetNoi = @"XOA_THONG_TIN_SAN_PHAM";
            NSString *otpCheck = @"";
            NSString *token = @"";
            if (self.mTypeAuthenticate == 0) {
                token = sMaOTP;
            }
            else {
                otpCheck = sMaOTP;
            }
            NSDictionary *dict = @{@"maDaiLy" : self.maDaiLy,
                                   @"otpCheck" : otpCheck,
                                   @"token" : token,
                                   @"VMApp" : [NSNumber numberWithInt:VM_APP],
                                   @"dsMaGiaoDich" : [NSArray arrayWithObjects:sMaGiaoDich, nil]
                                   };
            [GiaoDichMang xoaThongTinSanPham:[dict JSONString] noiNhanKetQua:self];
        }
        else {
            if (bTrangThaiCoAnhDaiDienMoi) {
                NSString *sBase64 = [self convertImageToBase64:self.imgvSP.image];
                [self uploadAnh:sBase64];
            }
            else {
                [self taoHoacEditSanPham:sLinkAnhOld];
            }
        }
    }
}

-(NSString *)convertImageToBase64:(UIImage *)viewImage
{
    NSData *imageData = UIImagePNGRepresentation(viewImage);
    NSString *b64EncStr = [Base64 encode: imageData];
    return b64EncStr;
}

- (void)xuLyKetNoiLayMaXacThucChuyenDenTaiKhoan:(NSString *)sSendTo kieuXacThuc:(int)nKieu {
    NSLog(@"%s - self.maDaiLy : %@ - self.mTypeAuthenticate : %d", __FUNCTION__, self.maDaiLy, self.mTypeAuthenticate);
    int typeAuthenticate = 1;
    if([Common kiemTraLaMail:sSendTo])
        typeAuthenticate = 2;
    self.mTypeAuthenticate = typeAuthenticate;
    if (self.nType == 0) {
        self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_LAY_MA_XAC_THUC_TAO_DON_VI;
        NSDictionary *dict = @{@"maDaiLy":self.maDaiLy, @"typeAuthenticate":[NSNumber numberWithInt:self.mTypeAuthenticate], @"VMApp":[NSNumber numberWithInt:VM_APP]};
        [GiaoDichMang layMaOTPTaoSuaQRDonVi:[dict JSONString] noiNhanKetQua:self];
    }
    else {
        self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_LAY_MA_XAC_THUC_TAO_SAN_PHAM;
        NSDictionary *dict = @{@"maDaiLy":self.maDaiLy, @"typeAuthenticate":[NSNumber numberWithInt:self.mTypeAuthenticate], @"VMApp":[NSNumber numberWithInt:VM_APP]};
        [GiaoDichMang layMaOTPTaoSuaQRDonVi:[dict JSONString] noiNhanKetQua:self];
    }
}

- (void)xuLyKetNoiThanhCong:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua {
    NSLog(@"%s - ketQua : %@", __FUNCTION__, ketQua);
    if ([self.mDinhDanhKetNoi isEqualToString:@"LAY_MA_XAC_THUC"]) {

    }
    else if ([self.mDinhDanhKetNoi isEqualToString:@"LAY_CHI_TIET_SAN_PHAM"]) {
        NSDictionary *dict = (NSDictionary *)ketQua;
        NSString *dsNhanTHongBao = [dict objectForKey:@"dsTKNhanThongBaoBienDongSoDu"];
        NSArray *arrVi = [dsNhanTHongBao componentsSeparatedByString:@","];
        if ([arrVi count] >0 && ![CommonUtils isEmptyOrNull:dsNhanTHongBao]) {
            for (int i =0; i<[arrVi count]; i++) {
                if (i==0) {
                    self.edtVilienket1.text = [arrVi objectAtIndex:i];
                }
                else if (i==1){
                    self.edtVilienket2.text = [arrVi objectAtIndex:i];
                }
                else if (i==2){
                    self.edtVilienket3.text = [arrVi objectAtIndex:i];
                }else if (i==3){
                    self.edtVilienket4.text = [arrVi objectAtIndex:i];
                }else if (i==4){
                    self.edtVilienket5.text = [arrVi objectAtIndex:i];
                }
            }
        }
        NSString *ten = (NSString *)[dict objectForKey:@"ten"];
        NSString *noiDung = (NSString *)[dict objectForKey:@"noiDung"];
        NSString *thongBaoSauKhiNhanTien = (NSString *)[dict objectForKey:@"thongBaoSauKhiNhanTien"];
        NSString *sDuongDanAnhDaiDien = (NSString *)[dict objectForKey:@"image"];
        sDuongDanAnhDaiDien = [sDuongDanAnhDaiDien stringByReplacingOccurrencesOfString:@"[" withString:@""];
        sDuongDanAnhDaiDien = [sDuongDanAnhDaiDien stringByReplacingOccurrencesOfString:@"]" withString:@""];
        sLinkAnhOld = [[NSString alloc] initWithString:sDuongDanAnhDaiDien];
        double gia = [[dict objectForKey:@"gia"] doubleValue];
        int hienThiThongTinNguoiNhan = [[dict objectForKey:@"hienThiThongTinNguoiNhan"] intValue];
        int hienThiLoiNhan = [[dict objectForKey:@"hienThiLoiNhan"] intValue];
        int hienThiSoLuong = [[dict objectForKey:@"hienThiSoLuong"] intValue];
        self.maDaiLy =[dict objectForKey:@"maDaiLy"] ;
        self.edTenSP.text = ten;
        self.edGiaTien.text = [Common hienThiTienTe:gia];
        self.umiNoiDung.text = noiDung;
        self.umiThongBao.text = thongBaoSauKhiNhanTien;
        if (hienThiSoLuong == 0) {
            [self.swSoLuong setOn:false];
        }
        else {
            [self.swSoLuong setOn:true];
        }
        
        if (hienThiLoiNhan == 0) {
            [self.swLoiNhan setOn:false];
        }
        else {
            [self.swLoiNhan setOn:true];
        }
        
        if (hienThiThongTinNguoiNhan == 0) {
            [self.swThongTin setOn:false];
        }
        else {
            [self.swThongTin setOn:true];
        }
        
        [CommonUtils displayImage:[NSURL URLWithString:[NSString stringWithFormat:@"https://vimass.vn/vmbank/services/media/getImage?id=%@", sDuongDanAnhDaiDien]] toImageView:self.imgvSP placeHolder:[UIImage imageNamed:@"icon_danhba"]];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
            [self anLoading];
        }
    }
    else if ([self.mDinhDanhKetNoi isEqualToString:@"TRANG_THAI_UP_DU_LIEU_ANH_SAN_PHAM"]) {
        NSString *sLinkAnh = (NSString *)ketQua;
        [self taoHoacEditSanPham:sLinkAnh];
    }
    else if ([self.mDinhDanhKetNoi isEqualToString:@"TAO_QR_SAN_PHAM"]) {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
            [self anLoading];
        }
    }
    else if ([self.mDinhDanhKetNoi isEqualToString:@"XAC_THUC_OTP_QR_DON_VI"] || [self.mDinhDanhKetNoi isEqualToString:@"TAO_QR_SAN_PHAM"]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
    }
    else if ([self.mDinhDanhKetNoi isEqualToString:@"KET_NOI_TAO_SAN_PHAM"]) {
        [self hienThiHopThoaiMotNutBamKieu:226 cauThongBao:@"Tạo sản phẩm thành công"];
    }
    else if ([self.mDinhDanhKetNoi isEqualToString:@"KET_NOI_SUA_SAN_PHAM"]) {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
            [self anLoading];
        }
        [self hienThiHopThoaiMotNutBamKieu:119 cauThongBao:@"Sửa sản phẩm thành công"];
    }
    else if ([self.mDinhDanhKetNoi isEqualToString:@"XOA_THONG_TIN_SAN_PHAM"]) {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
            [self anLoading];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)xuLyKetNoiThatBai:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
        [self anLoading];
    }
    [super xuLyKetNoiThatBai:sDinhDanhKetNoi thongBao:sThongBao ketQua:ketQua];
}

- (void)taoHoacEditSanPham:(NSString *)sLinkAnh {
    NSString *sSoTien = [_edGiaTien.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    double fSoTien = [sSoTien doubleValue];
    NSString *otpCheck = @"";
    NSString *token = @"";
    if (self.mTypeAuthenticate == 0) {
        token = sMaOTP;
    }
    else {
        otpCheck = sMaOTP;
    }
    NSLog(@"%s - token : %@ - otpCheck : %@", __FUNCTION__, token, otpCheck);
    int nThongTin = 1;
    int nSoLuong = 1;
    if (!self.swThongTin.isOn) {
        nThongTin = 0;
    }
    if (!self.swSoLuong.isOn) {
        nSoLuong = 0;
    }
    int nLoiNhan = 1;
    if (!self.swLoiNhan.isOn) {
        nLoiNhan = 0;
    }
    if (self.nType == 0) {
        NSDictionary *dic = @{@"maDaiLy" : [CommonUtils isEmptyOrNull: self.maDaiLy]?@"":self.maDaiLy,
                              @"ten" : self.edTenSP.text,
                              @"gia" : [NSNumber numberWithDouble:fSoTien],
                              @"image" : sLinkAnh,
                              @"video" : @"",
                              @"noiDung" :[CommonUtils isEmptyOrNull: self.umiNoiDung.text]?@"":self.umiNoiDung.text,
                              @"otpCheck" : otpCheck,
                              @"token" : token,
                              @"hienThiLoiNhan":[NSNumber numberWithInt:nLoiNhan],
                              @"hienThiSoLuong":[NSNumber numberWithInt:nSoLuong],
                              @"tkNhanTien": @"V",
                              @"kieuNhanThanhToan": @"V",
                              @"hienThiThongTinNguoiNhan":[NSNumber numberWithInt:nThongTin],
                              @"hienThiChiTietThongTinNguoiNhan":@"",
                              @"dsThongTinNguoiDatHang":@"",
                              @"thongBaoSauKhiNhanTien" :[CommonUtils isEmptyOrNull:self.umiThongBao.text]?@"":self.umiThongBao.text,
                              @"VMApp" : [NSNumber numberWithInt:VM_APP],@"dsTKNhanThongBaoBienDongSoDu":[self dsNhanThongBao]                              };
        self.mDinhDanhKetNoi = @"KET_NOI_TAO_SAN_PHAM";
        [GiaoDichMang taoQRSanPhamCuaDonVi:[dic JSONString] noiNhanKetQua:self];
    }
    else {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
            [self hienThiLoadingChuyenTien];
        }
        NSDictionary *dic = @{@"maGiaoDich" : sMaGiaoDich,
                              @"maDaiLy" : self.maDaiLy,
                              @"ten" : self.edTenSP.text,
                              @"gia" : [NSNumber numberWithDouble:fSoTien],
                              @"image" : sLinkAnh,
                              @"video" : @"",
                              @"noiDung" :[CommonUtils isEmptyOrNull: self.umiNoiDung.text]?@"":self.umiNoiDung.text,
                              @"otpCheck" : otpCheck,
                              @"token" : token,
                              @"hienThiLoiNhan":[NSNumber numberWithInt:nLoiNhan],
                              @"hienThiSoLuong":[NSNumber numberWithInt:nSoLuong],
                              @"tkNhanTien": @"V",
                              @"kieuNhanThanhToan": @"V",
                              @"hienThiThongTinNguoiNhan":[NSNumber numberWithInt:nThongTin],
                              @"hienThiChiTietThongTinNguoiNhan":@"",
                              @"dsThongTinNguoiDatHang":@"",
                              @"thongBaoSauKhiNhanTien" :[CommonUtils isEmptyOrNull: self.umiThongBao.text]?@"": self.umiThongBao.text,
                              @"VMApp" : [NSNumber numberWithInt:VM_APP],@"dsTKNhanThongBaoBienDongSoDu":[self dsNhanThongBao]    
                              };
        self.mDinhDanhKetNoi = @"KET_NOI_SUA_SAN_PHAM";
        [GiaoDichMang suaThongTinSanPham:[dic JSONString] noiNhanKetQua:self];
    }
}

#pragma mark - lay anh va chup anh
// tạo thêm 1 cái block trả về giá trị void với tham số là biến bool trả ra giá trị bên ngoài dùng
-(void)capture:(int)source withImageView:(UIImageView *)imageView completed:(void(^)(BOOL)) completed
{
    if ([UIImagePickerController isSourceTypeAvailable:source])
    {
        __block UIViewController *vc = [Common top_view_controller];
        [vc.view endEditing:YES];
        [CropImageHelper crop_image_from:source ratio:imageView.frame.size.width/imageView.frame.size.height max_width:320 maxsize:320*600 viewcontroller:self callback:^(UIImage *img, NSData *data)
         {
             NSLog(@"ChangPrivateInfomationViewController : chupMatTruocCMND : START");
             if(img){
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [imageView setImage:img];
                 });
             }
             else{
                 NSLog(@"ChangPrivateInfomationViewController : chupMatTruocCMND : imag == nil");
             }
             if(data){
                 NSLog(@"ChangPrivateInfomationViewController : chupMatTruocCMND : data != nil");
                 objc_setAssociatedObject(img, "image_data", data, OBJC_ASSOCIATION_RETAIN);
             }
             else
                 NSLog(@"ChangPrivateInfomationViewController : chupMatTruocCMND : data == nil");

             [vc dismissViewControllerAnimated:YES completion:^{
                 if (completed)
                 {
                     completed(YES);
                 }
             }];
         }];
    }
    else
    {
        [UIAlertView alert:[@"thiet_bi_khong_ho_tro_chuc_nang_nay" localizableString] withTitle:nil block:nil];
    }
}

- (void)dealloc {
    [_edTenSP release];
    [_edGiaTien release];
    [_edNoiDung release];
    [_swSoLuong release];
    [_swThongTin release];
    [_imgvSP release];
    [_umiThongBao release];
    [_tfThongBao release];
    [_swLoiNhan release];
    [_viewEdit release];
    [_heightViewEdit release];
    [_umiNoiDung release];
    [_viewThoiGian release];
    [_viewXacThuc release];
    [_viewAddXacThuc release];
    [_heightMainConstrant release];
    [_scrollView release];
    [super dealloc];
}
@end
