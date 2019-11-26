//
//  GiaoDienDangKyViDoanhNghiep.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 12/23/15.
//
//

#import "GiaoDienDangKyViDoanhNghiep.h"
#import "CropImageHelper.h"
#import "Base64.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+WebCache.h"
#import "GiaoDichMang.h"
#import "GiaoDienDieuKhoanCongTy.h"
#import <objc/runtime.h>

@interface GiaoDienDangKyViDoanhNghiep ()<UIWebViewDelegate>{
    BOOL bTrangThaiCoAnhTruoc;
    BOOL bTrangThaiCoAnhSau;
    NSString *sImageTruoc, *sImageSau;
    NSString *sMaDn, *sTenDn, *sTenDD, *sSDT, *sEmail;
    NSMutableDictionary *dicInfo;
}

@end

@implementation GiaoDienDangKyViDoanhNghiep

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addBackButton:YES];
//    self.title = @"Tạo tài khoản ví doanh nghiệp";
    [self addTitleView:[@"tao_tai_khoan_vi_doanh_nghiep" localizableString]];
    [self.viewScroll addSubview:self.viewMain];
    CGRect rectView = self.viewScroll.frame;
    rectView.size.height = self.viewMain.frame.size.height + 10;
    self.viewScroll.frame = rectView;
    self.viewScroll.layer.borderColor = [UIColor whiteColor].CGColor;
    self.viewScroll.layer.borderWidth = 1.0f;
    self.viewScroll.layer.cornerRadius = 3.0f;

    self.viewMain.layer.borderColor = [UIColor whiteColor].CGColor;
    self.viewMain.layer.borderWidth = 1.0f;
    self.viewMain.layer.cornerRadius = 3.0f;

    [self.scrMain setContentSize:CGSizeMake(self.scrMain.frame.size.width, 3000)];

    [self.edMaDN setMax_length:14];
    [self.edSoDienThoai setMax_length:11];
    NSString *sDieuKhoan = @"<span style=\"color:#000; text-align:center; width:100%; float:left\">Tôi đồng ý với <a style=\"color:#000; font-weight:bold; text-decoration:none\" target=\"_blank\" href=\"click\">Điều khoản sử dụng và Chính sách bảo mật</a> của Vimass</span>";
    self.webDieuKhoan.delegate = self;
    [self.webDieuKhoan loadHTMLString:sDieuKhoan baseURL:nil];

}

- (IBAction)suKienChupAnhTruoc:(id)sender {
    __block typeof (self) weak = self;
    [self capture:UIImagePickerControllerSourceTypeCamera withImageView:self.imgTruoc completed:^(BOOL change) {
        weak->bTrangThaiCoAnhTruoc = change;
    }];
}

- (IBAction)suKienLayAnhTruoc:(id)sender {
    __block typeof (self) weak = self;
    [self capture:UIImagePickerControllerSourceTypePhotoLibrary withImageView:self.imgTruoc completed:^(BOOL change) {
        weak->bTrangThaiCoAnhTruoc = change;
    }];
}

- (IBAction)suKienChupAnhSau:(id)sender {
    __block typeof (self) weak = self;
    [self capture:UIImagePickerControllerSourceTypeCamera withImageView:self.imgSau completed:^(BOOL change) {
        weak->bTrangThaiCoAnhSau = change;
    }];
}

- (IBAction)suKienLayAnhSau:(id)sender {
    __block typeof (self) weak = self;
    [self capture:UIImagePickerControllerSourceTypePhotoLibrary withImageView:self.imgSau completed:^(BOOL change) {
        weak->bTrangThaiCoAnhSau = change;
    }];

}

- (IBAction)suKienDangKyTaiKhoan:(id)sender {
    if (![self kiemTraTruocKhiDangKy]) {
        return;
    }
    if (!dicInfo) {
        dicInfo = [[NSMutableDictionary alloc] init];
    }

    [self dangKyTaiKhoan];
    [dicInfo setValue:self.edMaDN.text forKey:@"companyCode"];
    [dicInfo setValue:self.tfTenCongTy.text forKey:@"companyName"];
    [dicInfo setValue:self.edTenDaiDien.text forKey:@"nameRepresent"];
    [dicInfo setValue:self.edSoDienThoai.text forKey:@"walletId"];
    [dicInfo setValue:self.edEmail.text forKey:@"email"];

    if (bTrangThaiCoAnhTruoc || bTrangThaiCoAnhSau) {
        [self uploadAnhDoanhNghiep];
    }
}

- (void)uploadAnhDoanhNghiep{
    if (bTrangThaiCoAnhTruoc) {
        NSString *sValue = [self convertImageToBase64:self.imgTruoc.image];
//        self.mDinhDanhKetNoi = @"UP_LOAD_TRUOC";
        [self uploadAnh:sValue];
    }
    else if (bTrangThaiCoAnhSau) {
        NSString *sValue = [self convertImageToBase64:self.imgSau.image];
//        self.mDinhDanhKetNoi = @"UP_LOAD_SAU";
        [self uploadAnh:sValue];
    }
    else{
        [GiaoDichMang dangKyDoanhNghiep2:[dicInfo valueForKey:@"companyCode"] sTenDn:[dicInfo valueForKey:@"companyName"] sTenDD:[dicInfo valueForKey:@"nameRepresent"] sSDT:[dicInfo valueForKey:@"walletId"] sEmail:[dicInfo valueForKey:@"email"] sImage1:[dicInfo valueForKey:@"imageCompany1"] sImage2:[dicInfo valueForKey:@"imageCompany2"] noiNhanKetQua:self];
    }
}

-(NSString *)convertImageToBase64:(UIImage *)viewImage
{
    NSData *imageData = UIImagePNGRepresentation(viewImage);
    NSString *b64EncStr = [Base64 encode: imageData];
    return b64EncStr;
}

-(void)capture:(int)source withImageView:(UIImageView *)imageView completed:(void(^)(BOOL)) completed
{
    if ([UIImagePickerController isSourceTypeAvailable:source])
    {
        __block UIViewController *vc = [Common top_view_controller];
        [vc.view endEditing:YES];
        [CropImageHelper crop_image_from:source
                                   ratio:imageView.frame.size.width/imageView.frame.size.height
                               max_width:310
                                 maxsize:310*600
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

- (void)uploadAnh:(NSString *)sBase64{
    [GiaoDichMang uploadAnhViDoanhNghiep:self.edMaDN.text value:sBase64 noiNhanKetQua:self];
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (BOOL)kiemTraTruocKhiDangKy{
    if (self.edMaDN.text.length == 0) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập mã số doanh nghiệp"];
        return NO;
    }
    else if (self.edMaDN.text.length != 10 && self.edMaDN.text.length != 14){
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Mã số doanh nghiệp gồm 10 số hoặc - 3 số"];
        return NO;
    }
    if (self.tfTenCongTy.text.length == 0) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập tên doanh nghiệp"];
        return NO;
    }
    if (self.edTenDaiDien.text.length == 0) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập tên đại diện theo pháp luật"];
        return NO;
    }
    if (self.edSoDienThoai.text.length == 0) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập số điện thoại"];
        return NO;
    }
    else if (self.edSoDienThoai.text.length < 10){
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Số điện thoại là 10 hoặc 11 số"];
        return NO;
    }
    if (self.edEmail.text.length > 0) {
        if (![self NSStringIsValidEmail:self.edEmail.text]) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Email không đúng định dạng"];
            return NO;
        }
    }
    if (!bTrangThaiCoAnhTruoc) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng chọn ảnh đăng ký kinh doanh"];
        return NO;
    }
    if (!bTrangThaiCoAnhSau) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng chọn ảnh đăng ký kinh doanh"];
        return NO;
    }
    return YES;
}

- (void)ketNoiThanhCong:(NSString *)sKetQua{
    NSLog(@"%s - sKetQua : %@", __FUNCTION__, sKetQua);
    NSDictionary *dicKetQua = [sKetQua objectFromJSONString];
    int nCode = [[dicKetQua objectForKey:@"msgCode"] intValue];
    NSString *message = [dicKetQua objectForKey:@"msgContent"];
    NSString *result = [dicKetQua objectForKey:@"result"];
    if (nCode != 1) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:message];
        return;
    }

    if (bTrangThaiCoAnhTruoc) {
        [dicInfo setValue:result forKey:@"imageCompany1"];
        sImageTruoc = result;
        bTrangThaiCoAnhTruoc = NO;
        [self dangKyTaiKhoan];
        [self uploadAnhDoanhNghiep];
    }
    else{
        if (bTrangThaiCoAnhSau) {
            [dicInfo setValue:result forKey:@"imageCompany2"];
            sImageSau = result;
            bTrangThaiCoAnhSau = NO;
            [self dangKyTaiKhoan];
            [self uploadAnhDoanhNghiep];
        }
        else{
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:message];
        }
    }
}

- (void)ketNoiThanhCong:(NSString *)sDinhDanh ketQua:(NSString *)sKetQua{
    NSLog(@"%s - sKetQua : %@", __FUNCTION__, sKetQua);
}

- (void)dangKyTaiKhoan{
    NSLog(@"%s - dicInfo : %@", __FUNCTION__, dicInfo);
    sMaDn = self.edMaDN.text;
    sTenDn = self.tfTenCongTy.text;
    sTenDD = self.edTenDaiDien.text;
    sSDT = self.edSoDienThoai.text;
    sEmail = self.edEmail.text;
    NSLog(@"%s - sMaDn : %@", __FUNCTION__, sMaDn);
    NSLog(@"%s - sTenDn : %@", __FUNCTION__, sTenDn);
    NSLog(@"%s - sTenDD : %@", __FUNCTION__, sTenDD);
    NSLog(@"%s - sSDT : %@", __FUNCTION__, sSDT);
    NSLog(@"%s - sEmail : %@", __FUNCTION__, sEmail);
//    NSLog(@"%s - sImageTruoc : %@", __FUNCTION__, sImageTruoc);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        GiaoDienDieuKhoanCongTy *vc = [[GiaoDienDieuKhoanCongTy alloc] initWithNibName:@"GiaoDienDieuKhoanCongTy" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
        return NO;
    }
    return YES;
}

- (void)dealloc {
    NSLog(@"===========================><==============================");
    [_scrMain release];
    [_viewMain release];
    [_edMaDN release];
    [_tfTenCongTy release];
    [_edTenDaiDien release];
    [_edSoDienThoai release];
    [_edEmail release];
    [_imgTruoc release];
    [_imgSau release];
    [_viewScroll release];
    [_webDieuKhoan release];
    [_edTenCongTy release];
    [super dealloc];
}
@end
