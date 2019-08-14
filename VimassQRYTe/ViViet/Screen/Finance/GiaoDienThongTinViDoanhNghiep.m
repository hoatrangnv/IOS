//
//  GiaoDienThongTinViDoanhNghiep.m
//  ViViMASS
//
//  Created by nguyen tam on 9/15/15.
//
//

#import "GiaoDienThongTinViDoanhNghiep.h"
#import "UIImageView+WebCache.h"
#import "CropImageHelper.h"
#import "Base64.h"
#import <objc/runtime.h>

@interface GiaoDienThongTinViDoanhNghiep (){
    bool bTrangThaiCoAnhMatTruocMoi;
    bool bTrangThaiCoAnhMatSauMoi;
    bool bTrangThaiCoAnhLogoMoi;
    NSMutableDictionary *dsUploadAnh;
    NSString *sTokenChinh, *sOtpChinh;
}

@end

#define TAG @"GiaoDienThongTinViDoanhNghiep"
#define LINK_GOC_IMAGE @"https://vimass.vn/vmbank/services/media/getImage?id="
#define UPLOAD_IMAGE_1 @"image1";
#define UPLOAD_IMAGE_2 @"image2";
#define UPLOAD_COMPANY_INFO @"upload_info";

@implementation GiaoDienThongTinViDoanhNghiep

- (void)viewDidLoad {
    [super viewDidLoad];
    sTokenChinh = [[NSString alloc] init];
    sOtpChinh = [[NSString alloc] init];
    bTrangThaiCoAnhMatSauMoi = NO;
    bTrangThaiCoAnhMatTruocMoi = NO;
    bTrangThaiCoAnhLogoMoi = NO;
    self.mFuncID = 3;
    [self.scrView setContentSize:CGSizeMake(self.viewMain.frame.size.width, self.viewMain.frame.size.height + 50)];
    [self.scrView addSubview:self.viewMain];
    
    [self addButtonBack];
    [self addTitleView:[@"thay_doi_thong_tin_vi" localizableString]];
    if (!self.mThongTinTaiKhoanVi) {
        self.mThongTinTaiKhoanVi = [DucNT_LuuRMS layThongTinTaiKhoanVi];
    }
    [self hienThiThongTinVi];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)hienThiThongTinVi{
    if (self.mThongTinTaiKhoanVi) {
        self.edMaDoanhNghiep.text = self.mThongTinTaiKhoanVi.companyCode;
        self.edTenDoanhNghiep.text = self.mThongTinTaiKhoanVi.companyName;
        self.edNguoiDaiDien.text = self.mThongTinTaiKhoanVi.nameRepresent;
        self.edEmail.text = self.mThongTinTaiKhoanVi.sEmail;
        self.edSDT.text = self.mThongTinTaiKhoanVi.sdtNguoiDuyet;
        self.edDsLap.text = self.mThongTinTaiKhoanVi.dsLap;
        self.edDsDuyet.text = self.mThongTinTaiKhoanVi.dsDuyet;
        self.edNameAlias.text = self.mThongTinTaiKhoanVi.sNameAlias;

        NSString *sLinkImage1 = self.mThongTinTaiKhoanVi.imageCompany1;
        sLinkImage1 = [NSString stringWithFormat:@"%@%@", LINK_GOC_IMAGE, sLinkImage1];
        [self.imgTruoc setImageWithURL:[NSURL URLWithString:sLinkImage1] placeholderImage:[UIImage imageNamed:@"bg_noavatar.png"]];
        
        NSString *sLinkImage2 = self.mThongTinTaiKhoanVi.imageCompany2;
        sLinkImage2 = [NSString stringWithFormat:@"%@%@", LINK_GOC_IMAGE, sLinkImage2];
        [self.imgSau setImageWithURL:[NSURL URLWithString:sLinkImage2] placeholderImage:[UIImage imageNamed:@"bg_noavatar.png"]];

        NSString *sLinkImage3 = self.mThongTinTaiKhoanVi.sLinkAnhDaiDien;
        sLinkImage3 = [NSString stringWithFormat:@"%@%@", LINK_GOC_IMAGE, sLinkImage3];
        [self.imgLogo setImageWithURL:[NSURL URLWithString:sLinkImage3] placeholderImage:[UIImage imageNamed:@"bg_noavatar.png"]];
    }
}

- (BOOL)validateVanTay{
    return YES;
}

//- (void)suKienBamNutSMS:(UIButton *)sender{
//    if(self.edSDT.text.length > 0){
//        if(!self.mbtnSMS.selected && [self validateVanTay])
//        {
//            [self hienThiHopThoaiHaiNutBamKieu:HOP_THOAI_XAC_NHAN_XAC_THUC_SMS cauThongBao:[NSString stringWithFormat:@"%@ %@", [@"thong_bao_ma_xac_thuc_duoc_gui_ve_so_dien_thoai" localizableString], self.edSDT.text]];
//        }
//    }
//}
//
//- (void)suKienBamNutEmail:(UIButton *)sender{
//    if (self.edEmail.text.length > 0){
//        if(!self.mbtnEmail.selected && [self validateVanTay])
//        {
//            [self hienThiHopThoaiHaiNutBamKieu:HOP_THOAI_XAC_NHAN_XAC_THUC_EMAIL cauThongBao:[NSString stringWithFormat:@"%@ %@", [@"thong_bao_ma_xac_thuc_duoc_gui_ve_thu_dien_tu" localizableString], self.edEmail.text]];
//        }
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)suKienChupAnhMatTruoc:(id)sender {
    __block typeof (self) weak = self;
    [self capture:UIImagePickerControllerSourceTypeCamera withImageView:self.imgTruoc completed:^(BOOL change) {
        weak->bTrangThaiCoAnhMatTruocMoi = change;
    }];
}

- (IBAction)suKienLayAnhMatTruoc:(id)sender{
    __block typeof (self) weak = self;
    [self capture:UIImagePickerControllerSourceTypePhotoLibrary withImageView:self.imgTruoc completed:^(BOOL change) {
        weak->bTrangThaiCoAnhMatTruocMoi = change;
    }];
}

- (IBAction)suKienChupAnhMatSau:(id)sender{
    __block typeof (self) weak = self;
    [self capture:UIImagePickerControllerSourceTypeCamera withImageView:self.imgSau completed:^(BOOL change) {
        weak->bTrangThaiCoAnhMatSauMoi = change;
    }];
}

- (IBAction)suKienLayAnhMatSau:(id)sender{
    __block typeof (self) weak = self;
    [self capture:UIImagePickerControllerSourceTypePhotoLibrary withImageView:self.imgSau completed:^(BOOL change) {
        weak->bTrangThaiCoAnhMatSauMoi = change;
    }];
}

- (IBAction)suKienChupAnhLogo:(id)sender {
    __block typeof (self) weak = self;
    [self capture:UIImagePickerControllerSourceTypeCamera withImageView:self.imgLogo completed:^(BOOL change) {

        weak->bTrangThaiCoAnhLogoMoi = change;
    }];
}

- (IBAction)suKienLayAnhLogo:(id)sender {
    __block typeof (self) weak = self;
    [self capture:UIImagePickerControllerSourceTypePhotoLibrary withImageView:self.imgLogo completed:^(BOOL change) {
        NSLog(@"%s - change : %d", __FUNCTION__, change);
        weak->bTrangThaiCoAnhLogoMoi = change;
    }];
}

-(void)capture:(int)source withImageView:(UIImageView *)imageView completed:(void(^)(BOOL)) completed
{
    if ([UIImagePickerController isSourceTypeAvailable:source])
    {
        __block UIViewController *vc = [Common top_view_controller];
        [vc.view endEditing:YES];
        [CropImageHelper crop_image_from:source
                                   ratio:imageView.frame.size.width/imageView.frame.size.height
                               max_width:320
                                 maxsize:320*600
                          viewcontroller:vc
                                callback:^(UIImage *img, NSData *data)
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
             
             [vc dismissViewControllerAnimated:YES completion:^{}];
             if (completed)
             {
                 completed(YES);
             }
         }];
    }
    else
    {
        [UIAlertView alert:[@"thiet_bi_khong_ho_tro_chuc_nang_nay" localizableString] withTitle:nil block:nil];
    }
}

-(NSString *)convertImageToBase64:(UIImage *)viewImage
{
    NSData *imageData = UIImagePNGRepresentation(viewImage);
    NSString *b64EncStr = [Base64 encode: imageData];
    NSLog(@"%@ - %s : b64EncStr.length : %ld", TAG, __FUNCTION__, (unsigned long)b64EncStr.length);
    return b64EncStr;
}

- (void)xuLyThucHienKhiKiemTraThanhCongTraVeToken:(NSString *)sToken otp:(NSString *)sOtp{
//    self.mDinhDanhKetNoi = @"THAY_DOI_VI_DOANH_NGHIEP";
    NSLog(@"%s - %s : =========><=========", __FILE__, __FUNCTION__);
    sTokenChinh = sToken;
    sOtpChinh = sOtp;
    if (bTrangThaiCoAnhMatSauMoi || bTrangThaiCoAnhMatTruocMoi || bTrangThaiCoAnhLogoMoi) {
        if (!dsUploadAnh) {
            dsUploadAnh = [[NSMutableDictionary alloc] init];
        }
        [dsUploadAnh removeAllObjects];
        if (bTrangThaiCoAnhMatTruocMoi) {
            [dsUploadAnh setObject:[self convertImageToBase64:self.imgTruoc.image] forKey:@"image1"];
        }
        if (bTrangThaiCoAnhMatSauMoi) {
            [dsUploadAnh setObject:[self convertImageToBase64:self.imgSau.image] forKey:@"image2"];
        }
        if (bTrangThaiCoAnhLogoMoi) {
            [dsUploadAnh setObject:[self convertImageToBase64:self.imgLogo.image] forKey:@"image3"];
        }
        [self xuLyViecThayDoiAnh];
    }
    else
        [self uploadThongTinViDoanhNghiep:sToken otp:sOtp];
}

- (void)xuLyViecThayDoiAnh{
    if (dsUploadAnh && dsUploadAnh.count > 0) {
        NSArray *arrTemp = [dsUploadAnh allKeys];
        NSString *data = [dsUploadAnh objectForKey:[arrTemp objectAtIndex:0]];
        self.mDinhDanhKetNoi = [NSString stringWithFormat:@"%@", arrTemp[0]];
        [self uploadAnh:data];
        [dsUploadAnh removeObjectForKey:arrTemp[0]];
        NSLog(@"key : %@", self.mDinhDanhKetNoi);
    }
    else{
        [self uploadThongTinViDoanhNghiep:sTokenChinh otp:sOtpChinh];
    }
}

-(void)uploadAnh:(NSString *)sDuLieuAnhBase64
{
    NSString *sUrl = [NSString stringWithFormat:@"%@%@", @"https://vimass.vn/vmbank/services/media/upload/", [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP]];
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:self];
    [connect connect:sUrl withContent:sDuLieuAnhBase64];
    [connect release];
}

- (void)uploadThongTinViDoanhNghiep:(NSString *)sToken otp:(NSString *)sOtp{
    NSLog(@"%s - =========> change info", __FUNCTION__);
    self.mDinhDanhKetNoi = @"uploadinfo";
    
    NSString *sID = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    NSString *sTenDN = self.edTenDoanhNghiep.text;
    NSString *sNguoiDaiDien = self.edNguoiDaiDien.text;
    NSString *sEmail = self.edEmail.text;
    NSString *sSDT = self.edSDT.text;
    NSString *dsLap = self.edDsLap.text;
    NSString *dsDuyet = self.edDsDuyet.text;
    NSDictionary *dicPost = @{
                              @"id":sID,
                              @"companyName" : sTenDN,
                              @"nguoiDuyet": sSDT,
                              @"nameRepresent": sNguoiDaiDien,
                              @"email":sEmail,
                              @"dsLap":dsLap,
                              @"dsDuyet":dsDuyet,
                              @"nameAlias":self.edNameAlias.text,
//                              @"acc_name":self.mThongTinTaiKhoanVi.sTenCMND,
//                              @"dateIdCard":self.mThongTinTaiKhoanVi.sNgayCapCMND,
//                              @"placeIdCard":self.mThongTinTaiKhoanVi.sNoiCapCMND,
//                              @"birthday":self.mThongTinTaiKhoanVi.sNgaySinh,
//                              @"idCard":self.mThongTinTaiKhoanVi.sCMND,
//                              @"home":self.mThongTinTaiKhoanVi.sDiaChiNha,
                              @"avatar":self.mThongTinTaiKhoanVi.sLinkAnhDaiDien,
                              @"imageCompany1":self.mThongTinTaiKhoanVi.imageCompany1,
                              @"imageCompany2":self.mThongTinTaiKhoanVi.imageCompany2,
                              @"token":sToken,
                              @"otpConfirm" : sOtp,
                              @"typeAuthenticate" : [NSNumber numberWithInt:self.mTypeAuthenticate],
                              @"email": sEmail,
                              @"appId":[NSNumber numberWithInt:APP_ID],
                              @"companyCode":self.mThongTinTaiKhoanVi.companyCode,
                              @"walletId":sID,
                              @"VMApp" : [NSNumber numberWithInt:VM_APP]
                              };
    
    NSString *sPost = [dicPost JSONString];
//    [GiaoDichMang thayDoiThongTinViDoanhNghiep:dicPost noiNhanKetQua:self];
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:self];
    [connect connect:@"https://vimass.vn/vmbank/services/account/editAcc1" withContent:sPost];
    [connect release];
}

- (void)xuLyKetNoiThanhCong:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua{
    if ([sDinhDanhKetNoi isEqualToString:@"image1"]) {
        bTrangThaiCoAnhMatTruocMoi = NO;
        self.mThongTinTaiKhoanVi.imageCompany1 = ketQua;
//        if (dsUploadAnh && dsUploadAnh.count > 0) {
            [self xuLyViecThayDoiAnh];
//        }
    }
    else if ([sDinhDanhKetNoi isEqualToString:@"image2"]){
        bTrangThaiCoAnhMatSauMoi = NO;
        self.mThongTinTaiKhoanVi.imageCompany2 = ketQua;
//        if (dsUploadAnh && dsUploadAnh.count > 0) {
            [self xuLyViecThayDoiAnh];
//        }
    }
    else if ([sDinhDanhKetNoi isEqualToString:@"image3"]){
        bTrangThaiCoAnhLogoMoi = NO;
        NSLog(@"%s - image3 : %@", __FUNCTION__, ketQua);
        self.mThongTinTaiKhoanVi.sLinkAnhDaiDien = ketQua;
//        if (dsUploadAnh && dsUploadAnh.count > 0) {
            [self xuLyViecThayDoiAnh];
//        }
    }
    else if ([sDinhDanhKetNoi isEqualToString:@"uploadinfo"]){
        NSLog(@"%s ==================> line : %d", __FUNCTION__, __LINE__);
//        [self uploadThongTinViDoanhNghiep:sTokenChinh otp:sOtpChinh];
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Thay đổi thông tin Ví thành công"];
        NSString *sTenDN = self.edTenDoanhNghiep.text;
        NSString *sNguoiDaiDien = self.edNguoiDaiDien.text;
        NSString *sEmail = self.edEmail.text;
        NSString *sSDT = self.edSDT.text;
        NSString *dsLap = self.edDsLap.text;
        NSString *dsDuyet = self.edDsDuyet.text;
        self.mThongTinTaiKhoanVi.dsDuyet = dsDuyet;
        self.mThongTinTaiKhoanVi.dsLap = dsLap;
        self.mThongTinTaiKhoanVi.companyName = sTenDN;
        self.mThongTinTaiKhoanVi.nameRepresent = sNguoiDaiDien;
        self.mThongTinTaiKhoanVi.sEmail = sEmail;
        self.mThongTinTaiKhoanVi.sdtNguoiDuyet = sSDT;
        self.mThongTinTaiKhoanVi.sNameAlias = self.edNameAlias.text;

        DucNT_TaiKhoanViObject *newThongTin = [[DucNT_TaiKhoanViObject alloc] init];
        newThongTin.sID = self.mThongTinTaiKhoanVi.sID;
        newThongTin.companyCode = self.mThongTinTaiKhoanVi.companyCode;
        newThongTin.sNameAlias = self.mThongTinTaiKhoanVi.sNameAlias;
        newThongTin.companyName = self.mThongTinTaiKhoanVi.companyName;
        newThongTin.dsDuyet = self.mThongTinTaiKhoanVi.dsDuyet;
        newThongTin.dsLap = self.mThongTinTaiKhoanVi.dsLap;
        newThongTin.sEmail = self.mThongTinTaiKhoanVi.sEmail;
        newThongTin.sdtNguoiDuyet = self.mThongTinTaiKhoanVi.sdtNguoiDuyet;
        newThongTin.nameRepresent = self.mThongTinTaiKhoanVi.nameRepresent;
        newThongTin.imageCompany1 = self.mThongTinTaiKhoanVi.imageCompany1;
        newThongTin.imageCompany2 = self.mThongTinTaiKhoanVi.imageCompany2;
        newThongTin.sLinkAnhDaiDien = self.mThongTinTaiKhoanVi.sLinkAnhDaiDien;
        newThongTin.sPhoneAuthenticate = self.mThongTinTaiKhoanVi.sPhoneAuthenticate;
        NSLog(@"%s - newThongTin.sLinkAnhDaiDien : %@", __FUNCTION__, newThongTin.sLinkAnhDaiDien);
        [DucNT_LuuRMS luuThongTinTaiKhoanViSauDangNhap:newThongTin];
        // HOANHNV FIX
        AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        app.objUpdateProfile = newThongTin;
        [newThongTin release];
        //END
    }
}

- (void)xuLyKetNoiLayMaXacThucChuyenDenTaiKhoan:(NSString*)sSendTo kieuXacThuc:(int)nKieu{
    NSString *sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    
    int typeAuthenticate = 1;
    if([Common kiemTraLaMail:sSendTo]){
        typeAuthenticate = 2;
        sSendTo = self.mThongTinTaiKhoanVi.walletLoginEmail;
    }
    else{
        sSendTo = self.mThongTinTaiKhoanVi.sdtNguoiDuyet;
    }
    NSLog(@"%s - %s : sSendTo : %@", __FILE__, __FUNCTION__, sSendTo);
    NSString *companyCode = @"";
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        companyCode = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_COMPANY_ID];
    }
    NSMutableString *sUrl = [[NSMutableString alloc] init];
    [sUrl appendFormat:@"https://vimass.vn/vmbank/services/account/getOTP?"];
    if(![companyCode isEqualToString:@""])
        [sUrl appendFormat:@"companyCode=%@&", companyCode];
    [sUrl appendFormat:@"id=%@&", sTaiKhoan];
    [sUrl appendFormat:@"appId=%d&", APP_ID];
    [sUrl appendFormat:@"funcId=%d&", nKieu];
    [sUrl appendFormat:@"typeAuthenticate=%d&", typeAuthenticate];
    [sUrl appendFormat:@"sendTo=%@", sSendTo];
    
    self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_LAY_MA_XAC_THUC;
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:self];
    [connect connectGet:sUrl withContent:@""];
    [connect release];
    [sUrl release];
}

- (void)dealloc {
    [_scrView release];
    [_edMaDoanhNghiep release];
    [_imgTruoc release];
    [_imgSau release];

    [_viewMain release];
    [_edTenDoanhNghiep release];
    [_edNguoiDaiDien release];
    [_edSDT release];
    [_edEmail release];
    [_edDsLap release];
    [_edDsDuyet release];
    if (sOtpChinh) {
        [sOtpChinh release];
    }
    if (sTokenChinh) {
        [sTokenChinh release];
    }
    [_imgLogo release];
    [_edNameAlias release];
    [super dealloc];
}

@end
