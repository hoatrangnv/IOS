//
//  TaoQRDonViViewController.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 12/1/17.
//

#import "TaoQRDonViViewController.h"
#import "CropImageHelper.h"
#import "Base64.h"
#import "UIImageView+WebCache.h"
#import <objc/runtime.h>
#import "CommonUtils.h"
@interface TaoQRDonViViewController () {
    BOOL bTrangThaiCoAnhDaiDienMoi;
    NSString *sOTP;
    NSString *sLinkAnhLayDuoc;
    
}

@end

@implementation TaoQRDonViViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.nType == 0) {
        self.navigationItem.title = @"Tạo QR đơn vị";
    } else {
        self.navigationItem.title = @"Sửa QR đơn vị";
        NSLog(@"%s - sMaQRDaiLy : %@", __FUNCTION__, self.sMaQRDonVi);
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
            [self hienThiLoading];
        }
        self.mDinhDanhKetNoi = @"KET_NOI_LAY_QR_SAN_PHAM";
        [GiaoDichMang ketNoiLayDanhSachQRSanPham:self.sMaQRDonVi noiNhanKetQua:self];
    }
    CGSize sizeOffset = self.scrMain.contentSize;
    sizeOffset.height += 50;
    self.scrMain.contentSize = sizeOffset;
    sLinkAnhLayDuoc = @"";

    self.edSoDienThoai.text = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    [self.edSoDienThoai setEnabled:NO];
    
    self.edTenDaiLy.inputAccessoryView = nil;
    self.edCMND.inputAccessoryView = nil;
    self.edEmail.inputAccessoryView = nil;
    self.edSoDienThoai.inputAccessoryView = nil;
    self.edDiaChi.inputAccessoryView = nil;
    self.tfNoiDung.inputAccessoryView = nil;
    self.umiNoiDung.inputAccessoryView = nil;
    
    if (UIScreenHeight >= 736.0) {
        self.heightMainContraint.constant = -140;
    }
    // HOANHNV FIX
    self.edtVilienket1.attributedPlaceholder =[[NSAttributedString alloc] initWithString:[@"co_the_bo_qua_vi_lien_ket_1" localizableString] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.edtVilienket2.attributedPlaceholder =[[NSAttributedString alloc] initWithString:[@"co_the_bo_qua_vi_lien_ket_2" localizableString] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.edtVilienket3.attributedPlaceholder =[[NSAttributedString alloc] initWithString:[@"co_the_bo_qua_vi_lien_ket_3" localizableString] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.edtVilienket4.attributedPlaceholder =[[NSAttributedString alloc] initWithString:[@"co_the_bo_qua_vi_lien_ket_4" localizableString] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.edtVilienket5.attributedPlaceholder =[[NSAttributedString alloc] initWithString:[@"co_the_bo_qua_vi_lien_ket_5" localizableString] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
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
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.umiNoiDung resignFirstResponder];
//    [self.scrMain setContentSize:CGSizeMake(self.scrMain.frame.size.width, self.mViewMain.frame.size.height + 10)];
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (IBAction)suKienChonChupAnh:(id)sender {
    __block typeof (self) weak = self;
    [self capture:UIImagePickerControllerSourceTypeCamera withImageView:self.imgvAvatar completed:^(BOOL change) {
        weak->bTrangThaiCoAnhDaiDienMoi = change;
    }];
}

- (IBAction)suKienChonLayAnh:(id)sender {
    __block typeof (self) weak = self;
    [self capture:UIImagePickerControllerSourceTypePhotoLibrary withImageView:self.imgvAvatar completed:^(BOOL change) {
        NSLog(@"%s - lay anh dai dien change : %d", __FUNCTION__, change);
        weak->bTrangThaiCoAnhDaiDienMoi = change;
        if (weak->bTrangThaiCoAnhDaiDienMoi) {
            NSLog(@"%s ======== bTrangThaiCoAnhDaiDienMoi == YES", __FUNCTION__);
        }
    }];
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
        [UIAlertView alert:[@"@thiet_bi_khong_ho_tro_chuc_nang_nay" localizableString] withTitle:nil block:nil];
    }
}

- (BOOL)kiemTraDieuKienTao {
    if ([self.edTenDaiLy.text isEmpty]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Tên đại lý không được để trống"];
        return NO;
    }
    if ([self.edCMND.text isEmpty]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"CMND/ Số hộ chiếu không được để trống"];
        return NO;
    }
    if ([self.edEmail.text isEmpty]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Email không được để trống"];
        return NO;
    }
    else if (![Common kiemTraLaMail:self.edEmail.text]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Email không đúng định dạng"];
        return NO;
    }
    if ([self.edSoDienThoai.text isEmpty]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Số điện thoại không được để trống"];
        return NO;
    }
    if (self.nType == 0) {
        if (!bTrangThaiCoAnhDaiDienMoi) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng chọn ảnh đại diện"];
            return NO;
        }
    }
    if ([self.edDiaChi.text isEmpty]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Địa chỉ không được để trống"];
        return NO;
    }
    return YES;
}

- (IBAction)suKienChonTaoQRDonVi:(id)sender {
    if ([self kiemTraDieuKienTao]) {
        NSString *sBase64 = [self convertImageToBase64:self.imgvAvatar.image];
        [self uploadAnh:sBase64];
    }
}

-(void)uploadAnh:(NSString *)sDuLieuAnhBase64
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
        [self hienThiLoadingChuyenTien];
    }
    NSLog(@"%s - sDuLieuAnhBase64.length : %ld", __FUNCTION__, (unsigned long)sDuLieuAnhBase64.length);
//    sOTP = @"";
    self.mDinhDanhKetNoi = @"TRANG_THAI_UP_DU_LIEU_ANH";
    NSString *sUrl = [NSString stringWithFormat:@"%@%@", @"https://vimass.vn/vmbank/services/media/upload/", [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP]];
    NSLog(@"%s - sUrl : %@", __FUNCTION__, sUrl);
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:self];
    [connect connect:sUrl withContent:sDuLieuAnhBase64];
    [connect release];
}

-(NSString *)convertImageToBase64:(UIImage *)viewImage
{
    NSData *imageData = UIImagePNGRepresentation(viewImage);
    NSString *b64EncStr = [Base64 encode: imageData];
    return b64EncStr;
}

- (void)hienThiThongBaoNhapOTP:(NSString *)sMaDaiLy {
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
        NSDictionary *dic = @{
                              @"otpCheck":maOTP.text,
                              @"maDaiLy":sMaDaiLy,
                              @"VMApp" : [NSNumber numberWithInt:VM_APP]
                              };
        self.mDinhDanhKetNoi = @"XAC_THUC_OTP_QR_DON_VI";
        [GiaoDichMang xacThucOTPTaoQRDonVi:[dic JSONString] noiNhanKetQua:self];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Huỷ" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (BOOL)validateVanTay {
    return [self kiemTraDieuKienTao];
}

- (void)xuLyKetNoiLayMaXacThucChuyenDenTaiKhoan:(NSString *)sSendTo kieuXacThuc:(int)nKieu {
    int typeAuthenticate = 1;
    if([Common kiemTraLaMail:sSendTo])
        typeAuthenticate = 2;
    self.mTypeAuthenticate = typeAuthenticate;
    NSLog(@"%s - start : sSendTo : %@ - kieuXacThuc : %d", __FUNCTION__, sSendTo, self.mTypeAuthenticate);
    
    if (self.nType == 1) {
        if (bTrangThaiCoAnhDaiDienMoi) {
            self.mDinhDanhKetNoi = @"TRANG_THAI_UP_DU_LIEU_ANH";
            NSString *sBase64 = [self convertImageToBase64:self.imgvAvatar.image];
            [self uploadAnh:sBase64];
        } else {
            //            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
            //                [self hienThiLoading];
            //            }
            self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_LAY_MA_XAC_THUC_TAO_DON_VI;
            NSDictionary *dict = @{@"maDaiLy":self.sMaQRDonVi, @"typeAuthenticate":[NSNumber numberWithInt:self.mTypeAuthenticate], @"VMApp":[NSNumber numberWithInt:VM_APP]};
            NSLog(@"%s - dict : %@", __FUNCTION__, [dict JSONString]);
            [GiaoDichMang layMaOTPTaoSuaQRDonVi:[dict JSONString] noiNhanKetQua:self];
        }
    } else {
        if (sLinkAnhLayDuoc.length > 0) {
            [self ketNoiTaoQRDonVi];
        }
        else {
            self.mDinhDanhKetNoi = @"TRANG_THAI_UP_DU_LIEU_ANH";
            NSString *sBase64 = [self convertImageToBase64:self.imgvAvatar.image];
            [self uploadAnh:sBase64];
        }
    }
}

- (void)xuLyThucHienKhiKiemTraThanhCongTraVeToken:(NSString *)sToken otp:(NSString *)sOtp {
    if (sOTP == nil) {
        sOTP = [[NSString alloc] init];
    }
    if (self.mTypeAuthenticate == 0) {
        sOTP = sToken;
    } else {
        sOTP = sOtp;
    }
    
    NSLog(@"%s - sOTP : %@", __FUNCTION__, sOTP);
    if (self.nType == 0) {
        if (sLinkAnhLayDuoc.length > 0) {
            [self ketNoiTaoQRDonVi];
        }
        else {
            self.mDinhDanhKetNoi = @"TRANG_THAI_UP_DU_LIEU_ANH";
            NSString *sBase64 = [self convertImageToBase64:self.imgvAvatar.image];
            [self uploadAnh:sBase64];
        }
    } else {
        if (bTrangThaiCoAnhDaiDienMoi) {
            self.mDinhDanhKetNoi = @"TRANG_THAI_UP_DU_LIEU_ANH";
            NSString *sBase64 = [self convertImageToBase64:self.imgvAvatar.image];
            [self uploadAnh:sBase64];
        } else {
            [self ketNoiSuaQRDonVi];
        }
    }
    
}

- (void)ketNoiTaoQRDonVi {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
        [self hienThiLoadingChuyenTien];
    }
    NSLog(@"%s - sOTP : %@", __FUNCTION__, sOTP);
    NSString *strND = self.umiNoiDung.text;
    NSString *strDL = self.edTenDaiLy.text;
    NSString *strDC = self.edDiaChi.text;
    NSString *strCMD = self.edCMND.text;
    NSString *strEM = self.edEmail.text;
    if([CommonUtils isEmptyOrNull:sOTP]){
        sOTP = @"";
    }
    NSDictionary *dic = @{@"thongBaoSauKhiNhanTien" : strND,
                          @"tenDaiLy" : strDL,
                          @"thongTinLienHe" : strDC,
                          @"cmtHoChieu" : strCMD,
                          @"email" : strEM,
                          @"cellphoneNumber" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                          @"avatar" : sLinkAnhLayDuoc,
                          @"VMApp" : [NSNumber numberWithInt:VM_APP],
                          @"deviceId" : [NSNumber numberWithInt:DEVICE_REGIS_ID],
                          @"token" : sOTP,@"dsTKNhanThongBaoBienDongSoDu":[self dsNhanThongBao] //HOANHNV
                          };
    NSLog(@"%s - dict : %@", __FUNCTION__, [dic JSONString]);
    self.mDinhDanhKetNoi = @"TAO_QR_DON_VI";
    [GiaoDichMang taoQRDonVi:[dic JSONString] noiNhanKetQua:self];
}

- (void)ketNoiSuaQRDonVi {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
        [self hienThiLoadingChuyenTien];
    }
    NSLog(@"%s - sLinkAnhLayDuoc : %@", __FUNCTION__, sLinkAnhLayDuoc);
    NSString *token = @"";
    NSString *otpCheck = @"";
    if (self.mTypeAuthenticate == 0) {
        token = sOTP;
    } else {
        otpCheck = sOTP;
    }
    NSString *strND = self.umiNoiDung.text;
    NSString *strDL = self.edTenDaiLy.text;
    NSString *strDC = self.edDiaChi.text;
    NSString *strCMD = self.edCMND.text;
    NSString *strEM = self.edEmail.text;
    
    NSDictionary *dic = @{@"thongBaoSauKhiNhanTien" : strND,
                          @"maDaiLy":self.sMaQRDonVi,
                          @"imageCompany1":@"",
                          @"imageCompany2":@"",
                          @"tenDaiLy" : strDL,
                          @"thongTinLienHe" : strDC,
                          @"cmtHoChieu" : strCMD,
                          @"email" : strEM,
                          @"cellphoneNumber" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                          @"avatar" : sLinkAnhLayDuoc,
                          @"VMApp" : [NSNumber numberWithInt:VM_APP],
                          @"deviceId" : [NSNumber numberWithInt:DEVICE_REGIS_ID],
                          @"token" : token,
                          @"otpCheck": otpCheck,
                          @"dsTKNhanThongBaoBienDongSoDu":[self dsNhanThongBao]
                          };
    NSLog(@"%s - dict : %@", __FUNCTION__, [dic JSONString]);
    self.mDinhDanhKetNoi = @"SUA_QR_DON_VI";
    [GiaoDichMang suaQRDonVi:[dic JSONString] noiNhanKetQua:self];
}

- (void)xuLyKetNoiThanhCong:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua {
    if ([self.mDinhDanhKetNoi isEqualToString:@"TRANG_THAI_UP_DU_LIEU_ANH"]) {
        NSString *sLinkAnh = (NSString *)ketQua;
        NSLog(@"%s - sLinkAnh : %@", __FUNCTION__, sLinkAnh);
        sLinkAnhLayDuoc = [[NSString alloc] initWithString:sLinkAnh];
        if (self.nType == 0) {
            [self ketNoiTaoQRDonVi];
        } else {
            if (sOTP.length == 0) {
                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
                    [self anLoading];
                }
                self.mDinhDanhKetNoi = @"KET_NOI_LAY_MA_SUA_DON_VI";
                NSDictionary *dict = @{@"maDaiLy":self.sMaQRDonVi, @"typeAuthenticate":[NSNumber numberWithInt:self.mTypeAuthenticate], @"VMApp":[NSNumber numberWithInt:VM_APP]};
                [GiaoDichMang layMaOTPTaoSuaQRDonVi:[dict JSONString] noiNhanKetQua:self];
            }
            else {
                [self ketNoiSuaQRDonVi];
            }
        }
    }
    else if ([self.mDinhDanhKetNoi isEqualToString:@"TAO_QR_DON_VI"]) {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
            [self anLoading];
        }
        if (sOTP.length == 0) {
            NSString *sMaDaiLy = (NSString *)ketQua;
            [self hienThiThongBaoNhapOTP:sMaDaiLy];
        }
        else {
            [self hienThiHopThoaiMotNutBamKieu:119 cauThongBao:@"Tạo đơn vị thành công"];
        }
    }
    else if ([self.mDinhDanhKetNoi isEqualToString:@"XAC_THUC_OTP_QR_DON_VI"]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
    }
    else if ([self.mDinhDanhKetNoi isEqualToString:@"KET_NOI_LAY_QR_SAN_PHAM"]) {
        NSDictionary *dict = (NSDictionary *)ketQua;
        self.edTenDaiLy.text = [dict objectForKey:@"tenDaiLy"];
        NSString *diaChi = [dict objectForKey:@"thongTinLienHe"];
        if ([diaChi isEqualToString: @"null"]) {
            diaChi = @"";
        }
        self.edDiaChi.text = diaChi;
        self.edCMND.text = [dict objectForKey:@"cmtHoChieu"];
        self.edEmail.text = [dict objectForKey:@"email"];
        NSString *thongBaoNhan = [dict objectForKey:@"thongBaoSauKhiNhanTien"];
        if ([thongBaoNhan isEqualToString: @"null"]) {
            thongBaoNhan = @"";
        }
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
        self.umiNoiDung.text = thongBaoNhan;
        NSString *sLinkAnh = (NSString *)[dict objectForKey:@"avatar"];
        sLinkAnhLayDuoc = [[NSString alloc] initWithString:sLinkAnh];
        NSLog(@"%s - sLinkAnhLayDuoc : %@", __FUNCTION__, sLinkAnhLayDuoc);
        [self.imgvAvatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://vimass.vn/vmbank/services/media/getImage?id=%@", sLinkAnhLayDuoc]] placeholderImage:[UIImage imageNamed:@"icon_danhba"]];
    }
    else if ([self.mDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_LAY_MA_XAC_THUC_TAO_DON_VI]) {
//         [self ketNoiSuaQRDonVi];
                if (sLinkAnhLayDuoc.length > 0) {
                    [self ketNoiTaoQRDonVi];
                }
                else {
                    self.mDinhDanhKetNoi = @"TRANG_THAI_UP_DU_LIEU_ANH";
                    NSString *sBase64 = [self convertImageToBase64:self.imgvAvatar.image];
                    [self uploadAnh:sBase64];
                }
    }
    else if ([self.mDinhDanhKetNoi isEqualToString:@"SUA_QR_DON_VI"]) {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
            [self anLoading];
        }
        [self hienThiHopThoaiMotNutBamKieu:226 cauThongBao:@"Sửa QR đơn vị thành công"];
    }
}

- (void)xuLyKetNoiThatBai:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
        [self anLoading];
    }
    [super xuLyKetNoiThatBai:sDinhDanhKetNoi thongBao:sThongBao ketQua:ketQua];
}

- (void)dealloc {
    [_edTenDaiLy release];
//    [_edTenHienThi release];
    [_edCMND release];
    [_edEmail release];
    [_edSoDienThoai release];
    [_imgvAvatar release];
    [_scrMain release];
    [_edDiaChi release];
    [_tfNoiDung release];
    [_umiNoiDung release];
    [_heightMainContraint release];
    [super dealloc];
}

@end
