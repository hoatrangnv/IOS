//
//  HomeCenterViewController.m
//  ViViMASS
//
//  Created by Mac Mini on 9/13/18.
//

#import "HomeCenterViewController.h"
#import "GiaoDienChinhV2.h"
#import "DichVuNotification.h"
#import "HienThiDanhSachTinQuangBaViewController.h"
#import "QRSearchViewController.h"
#import "GiaoDienGioiThieuVi.h"
#import "DucNT_TaiKhoanViObject.h"
#import "GiaoDienThanhToanQRCodeDonVi.h"
#import "GiaoDienThanhToanQRCode.h"
#import "GiaoDienDenKhac.h"
#import "NganhangVC.h"
#import "QRVC.h"
#import "VicuatoiVC.h"
#import "ViDienTuVC.h"
#import "ViewNavigationGiaoDienChinh.h"
#import "FBEncryptorAES.h"
#import "ChuyenTienDienThoaiVC.h"
#import "DucNT_ChuyenTienDenTaiKhoanViewController.h"
#import "DucNT_ChuyenTienDenTheViewController.h"
#import "GiaoDienChuyenTienATM.h"
#import "GiaoDienChuyenTienDenCMND.h"
#import "GuiTietKiemViewController.h"
#import "GiaoDienTraCuuTienVay.h"
#import "ChuyenTienTanNhaViewController.h"
#import "GiaoDienDiemGiaoDichV2.h"
#import "HanMucGiaoDichViewController.h"
#import "ChuyenTienDenViMomoViewController.h"
#import "ChuyenTienViewController.h"
#import "NapViTuTheNganHangViewController.h"
#import "GiaoDienTaiKhoanLienKet.h"
#import "DanhSachQuaTangViewController.h"
#import "DucNT_HienThiTokenViewController.h"
#import "DucNT_DangKyToken.h"
#import "GiaoDienThongTinViDoanhNghiep.h"
#import "DucNT_ChangPrivateInformationViewController.h"
#import "MuonTienViewController.h"
#import "DucNT_SaoKeViewController.h"
#import "GiaoDienTaiKhoanLienKet.h"
#import "DucBT_ShareViewController.h"
#import "GiaoDienGopY.h"
#import "UIButton+WebCache.h"
#import "DucNT_ChuyenTienViDenViViewController.h"
#import "CommonUtils.h"
#import "ChonAnSauDienThoaiViewController.h"
#import "HanMucMoiViewController.h"
#import "Giaodienlienket1ViewController.h"
#import "GiaoDienThanhToanQRVNPay.h"
#import "GiaoDienDiemThanhToanVNPAY.h"
#import "PKIViewController.h"
#import "ViVimass-Swift.h"
#import "QRDonViViewController.h"
#import <Contacts/Contacts.h>
@interface HomeCenterViewController ()<UIActionSheetDelegate, QRCodeReaderDelegate,RowSelectDelegate,ViewNavigationGiaoDienChinhDelegate>{
    ViewNavigationGiaoDienChinh *mViewNavigationGiaoDienChinh;
    NSString *keyPin;
    AppDelegate *app;

}
@property (retain,nonatomic) ChuyenTienDienThoaiVC *dienthoaiVC;
@property (retain,nonatomic) NganhangVC *nganhangVC;
@property (retain,nonatomic) ViDienTuVC *vidientuVC;
@property (retain,nonatomic) QRVC *qrVC;
@property (retain,nonatomic) VicuatoiVC *vicuatoiVC;
@property (assign,nonatomic) int currentTab;;

@end

@implementation HomeCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"QR Y TẾ";
    
    [self taoBtnRight];
    
    app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    keyPin = @"111111";
    
//    [self fetchContacts];
}

- (void) fetchContacts
{
    NSLog(@"HomeCenterViewController - %s - START", __FUNCTION__);
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusDenied || status == CNAuthorizationStatusDenied) {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"This app previously was refused permissions to contacts; Please go to settings and grant permission to this app so it can use contacts" preferredStyle:UIAlertControllerStyleAlert];
//
//        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
//        [self presentViewController:alert animated:TRUE completion:nil];
        return;
    }
    
    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // user didn't grant access;
                // so, again, tell user here why app needs permissions in order  to do it's job;
                // this is dispatched to the main queue because this request could be running on background thread
            });
            return;
        }
        
        // build array of contacts
        
        NSMutableArray *contacts = [NSMutableArray array];
        
        NSError *fetchError;
        CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:@[CNContactIdentifierKey, [CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName], CNContactPhoneNumbersKey]];
        
        BOOL success = [store enumerateContactsWithFetchRequest:request error:&fetchError usingBlock:^(CNContact *contact, BOOL *stop) {
            [contacts addObject:contact];
        }];
        
        
        
        if (!success) {
            NSLog(@"HomeCenterViewController - %s - fetchError : %@", __FUNCTION__, fetchError);
            return;
        }
        
        NSLog(@"HomeCenterViewController - %s - contacts : %ld", __FUNCTION__, (long)contacts.count);
        
        // you can now do something with the list of contacts, for example, to show the names
        
        CNContactFormatter *formatter = [[CNContactFormatter alloc] init];

        for (CNContact *contact in contacts) {
            NSString *sName = [formatter stringFromContact:contact];
            NSString *phoneMobile = @"";
            NSArray <CNLabeledValue<CNPhoneNumber *> *> *phoneNumbers = contact.phoneNumbers;
            for (CNLabeledValue<CNPhoneNumber *> *firstPhone in phoneNumbers) {
                CNPhoneNumber *number = firstPhone.value;
                NSString *digits = number.stringValue;
                if (digits.length > 0) {
                    NSLog(@"HomeCenterViewController - %s - digits : %@ - %@", __FUNCTION__, sName, digits);
                }
            }
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = UIColor.whiteColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self connectGetBadge];
}

- (void)connectGetBadge {
    NSString *sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    if(sTaiKhoan.length > 0)
    {
        NSMutableString *mess = [[NSMutableString alloc] init];
        [mess appendFormat:@"id=%@&",sTaiKhoan];
        [mess appendFormat:@"appId=%d&",APP_ID];
        [mess appendFormat:@"funcId=%d&",0];
        [mess appendFormat:@"phanLoaiTinNhan=%d",8];
        
        NSString *sUrl = [NSString stringWithFormat:@"%@/%@?id=%@&appId=5&funcId=0&phanLoaiTinNhan=8", BASE_URL_SERVICE_NOTIFICATION, @"getBadge", sTaiKhoan];
        NSLog(@"%s - sUrl : %@", __FUNCTION__, sUrl);
        NSURL *url = [NSURL URLWithString:sUrl];
        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
        [urlRequest setHTTPMethod:@"GET"];
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSString *sKetQua = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            NSLog(@"%s - sKetQua : %@", __FUNCTION__, sKetQua);
            NSDictionary *dicKetQua = [sKetQua objectFromJSONString];
            int nCode = [[dicKetQua objectForKey:@"msgCode"] intValue];
            if (nCode == 1) {
                int total = [[dicKetQua objectForKey:@"total"] intValue];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hienThiBagdeNumber:total];
                });
            }
        }];
        [dataTask resume];
    }
}

- (void)taoBtnRight {
    UIImageView *imgAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [imgAvatar setContentMode:UIViewContentModeScaleAspectFill];
    if (self.mThongTinTaiKhoanVi) {
        imgAvatar.clipsToBounds = YES;
        [imgAvatar.layer setCornerRadius:3];
        [imgAvatar.layer setBorderColor:UIColor.whiteColor.CGColor];
        [imgAvatar.layer setBorderWidth:1.5];
        NSString *sDuongDanAnhDaiDien = self.mThongTinTaiKhoanVi.sLinkAnhDaiDien;
        if([sDuongDanAnhDaiDien isEqualToString:@""])
        {
            imgAvatar.image = [UIImage imageNamed:@"icon_more"];
        }
        else
        {
            if([sDuongDanAnhDaiDien rangeOfString:@"http"].location != NSNotFound){
                [imgAvatar sd_setImageWithURL:[NSURL URLWithString:sDuongDanAnhDaiDien] placeholderImage:[UIImage imageNamed:@"icon_more"]];
            }
            else{
                [imgAvatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://vimass.vn/vmbank/services/media/getImage?id=%@", sDuongDanAnhDaiDien]] placeholderImage:[UIImage imageNamed:@"icon_danhba"]];
            }
        }
        
    }
    [imgAvatar setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapRightBtn = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(suKienBamNutMore:)];
    [imgAvatar addGestureRecognizer:tapRightBtn];
    
    UIBarButtonItem *btnRight = [[UIBarButtonItem alloc] initWithCustomView:imgAvatar];
    self.navigationItem.rightBarButtonItem = btnRight;
    
    [self.navigationItem.rightBarButtonItem.customView.widthAnchor constraintEqualToConstant:40].active = YES;
    [self.navigationItem.rightBarButtonItem.customView.heightAnchor constraintEqualToConstant:40].active = YES;
}

- (IBAction)suKienBamNutMore:(UITapGestureRecognizer *)sender
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *dong = [UIAlertAction actionWithTitle:@"Đóng" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *logout = [UIAlertAction actionWithTitle:@"Đăng xuất" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self suKienDangXuat];
    }];
    UIAlertAction *huongDan = [UIAlertAction actionWithTitle:@"Hướng dẫn" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        GiaoDienGioiThieuVi *vc = [[GiaoDienGioiThieuVi alloc] initWithNibName:@"GiaoDienGioiThieuVi" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }];
    [actionSheet addAction:logout];
    [actionSheet addAction:huongDan];
    [actionSheet addAction:dong];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (self.mThongTinTaiKhoanVi) {
        //NSLog(@"%s - buttonIndex : %d", __FUNCTION__, (int)buttonIndex);
        if (buttonIndex == 0) {
            [self suKienDangXuat];
        }
        else if (buttonIndex == 1){
            DucBT_ShareViewController *shareViewController = [[DucBT_ShareViewController alloc] initWithNibName:@"DucBT_ShareViewController" bundle:nil];
            [self.navigationController pushViewController:shareViewController animated:YES];
            [shareViewController release];
        }
        else if (buttonIndex == 2) {
            GiaoDienGopY *gopY = [[GiaoDienGopY alloc] initWithNibName:NSStringFromClass([GiaoDienGopY class]) bundle:nil];
            [self.navigationController pushViewController:gopY animated:YES];
            [gopY release];
        }
        else if (buttonIndex == 3){
            GiaoDienGioiThieuVi *vc = [[GiaoDienGioiThieuVi alloc] initWithNibName:@"GiaoDienGioiThieuVi" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
        }
    }
}

- (void)suKienDangXuat
{
    [DucNT_LuuRMS luuThongTinDangNhap:KEY_LOGIN_STATE value:@"NO"];
    
    NSString *sTaiKhoanDangNhapCuoi = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    [DucNT_LuuRMS luuThongTinDangNhap:KEY_LAST_ID_LOGIN value:sTaiKhoanDangNhapCuoi];
    
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sTaiKhoanDangNhapCuoi = self.mThongTinTaiKhoanVi.walletLogin;
    }
    
    if(sTaiKhoanDangNhapCuoi.length == 10 || sTaiKhoanDangNhapCuoi.length == 11)
    {
        [DucNT_LuuRMS luuThongTinDangNhap:KEY_LAST_PHONE_LOGIN_ID value:sTaiKhoanDangNhapCuoi];
    }
    //Xoa bagde number o icon tren man hinh iPhone
    [[DichVuNotification shareService] dichVuXacNhanDaDocTatCaCacTin];
    int nTongSoLuongTinChuaDoc = [[DichVuNotification shareService] laySoLuongTinChuaDocTrongChucNang:0];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:nTongSoLuongTinChuaDoc];
    [app showLogin];
}

- (void)xuLySuKienDangNhapThanhCong:(NSNotification *)notification
{
//    [self hienThiBagdeNumber];
}

- (void)hienThiBagdeNumber:(int)nBagdeNumberQuangBa {
//    int nBagdeNumberQuangBa = [[DichVuNotification shareService] laySoLuongTinChuaDocTrongChucNang:TIN_QUANG_BA];
    NSLog(@"%s - nBagdeNumberQuangBa : %d", __FUNCTION__, nBagdeNumberQuangBa);
    
    
    UIButton *notificationBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    [notificationBtn setBackgroundImage:[UIImage imageNamed:@"notification_24"] forState:UIControlStateNormal];
    [notificationBtn setTitle:@"" forState:UIControlStateNormal];
    [notificationBtn addTarget:self action:@selector(onClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if(nBagdeNumberQuangBa > 0) {
        UILabel *badgeLbl = [[UILabel alloc]initWithFrame:CGRectMake(16, -2, 22, 22)];
        badgeLbl.backgroundColor = [UIColor redColor];
        badgeLbl.textColor = [UIColor whiteColor];
        badgeLbl.textAlignment = NSTextAlignmentCenter;
        badgeLbl.layer.cornerRadius = 11.0;
        badgeLbl.layer.masksToBounds = true;
        badgeLbl.font = [UIFont systemFontOfSize:12];
        badgeLbl.text = [NSString stringWithFormat:@"%d", nBagdeNumberQuangBa];
        [notificationBtn addSubview:badgeLbl];
    }
    UIBarButtonItem *notificationBarBtn = [[UIBarButtonItem alloc]initWithCustomView:notificationBtn];
    self.navigationItem.leftBarButtonItem = notificationBarBtn;
}

- (void)onClickAction:(UIButton *)sender {
    HienThiDanhSachTinQuangBaViewController *hienThiTinQuangBaViewController = [[HienThiDanhSachTinQuangBaViewController alloc] initWithNibName:@"HienThiDanhSachTinQuangBaViewController" bundle:nil];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:hienThiTinQuangBaViewController animated:YES];
    [hienThiTinQuangBaViewController release];
}

- (void)reloadGiaoDien:(NSNotification *)notification{
    [self hienThiBagdeNumber:0];
}

- (void)suKienChonNotification:(UIBarButtonItem *)sender {
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.dienthoaiVC release];
    [_vNganHang release];
    [_vQR release];
    [_btnNganHang release];
    [_btnQR release];
    [_lblNganHang release];
    [_lblHoaDon release];
    [super dealloc];
}

- (IBAction)suKienChonVimass:(id)sender {
    QRDonViViewController *vc = [[QRDonViViewController alloc] initWithNibName:@"QRDonViViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (IBAction)suKienChonQRYTe:(id)sender {
    DanhSachQRYTeViewController *vc = [[DanhSachQRYTeViewController alloc] initWithNibName:@"DanhSachQRYTeViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
//    TaoQRYTeViewController * vc = [[TaoQRYTeViewController alloc] initWithNibName:@"TaoQRYTeViewController" bundle:nil];
//    [self.navigationController pushViewController:vc animated:YES];
//    [vc release];
}

- (IBAction)suKienChonVNPay:(id)sender {
    GiaoDienDiemThanhToanVNPAY *vc = [[GiaoDienDiemThanhToanVNPAY alloc] initWithNibName:@"GiaoDienDiemThanhToanVNPAY" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (IBAction)suKienChonGiaoDich:(id)sender {
    DucNT_SaoKeViewController *saoKeViewController = [[DucNT_SaoKeViewController alloc] initWithNibName:@"DucNT_SaoKeViewController" bundle:nil];
    saoKeViewController.nTrangThaiXem = SAO_KE_VI;
    [self.navigationController pushViewController:saoKeViewController animated:YES];
    [saoKeViewController release];
}

- (IBAction)suKienChonQuetQR:(id)sender {
    if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
        QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
        QRSearchViewController *vcQRCodeTemp = [[QRSearchViewController alloc]initWithNibName:@"QRSearchViewController" bundle:nil];
        vcQRCodeTemp.codeReader = reader;
        vcQRCodeTemp.modalPresentationStyle = UIModalPresentationFormSheet;
        vcQRCodeTemp.delegate = self;
        vcQRCodeTemp.nType = 1;
        [self presentViewController:vcQRCodeTemp animated:YES completion:NULL];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:@"Thiết bị không hỗ trợ chức năng này." delegate:nil cancelButtonTitle:@"Đóng" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)suKienChonToken:(id)sender {
    DucNT_HienThiTokenViewController *hienThiTokenViewController = [[DucNT_HienThiTokenViewController alloc] initWithNibName:@"DucNT_HienThiTokenViewController" bundle:nil];
    [self.navigationController pushViewController:hienThiTokenViewController animated:YES];
    [hienThiTokenViewController release];
}

- (IBAction)suKienChonCaNhan:(id)sender {
    DucNT_ChangPrivateInformationViewController *thayDoiThongTinCaNhan = [[DucNT_ChangPrivateInformationViewController alloc] initWithNibName:@"DucNT_ChangPrivateInformationViewController" bundle:nil];
    [self.navigationController pushViewController:thayDoiThongTinCaNhan animated:YES];
    [thayDoiThongTinCaNhan release];
}

- (IBAction)onNext:(id)sender {
    GiaoDienGioiThieuVi *vc = [[GiaoDienGioiThieuVi alloc] initWithNibName:@"GiaoDienGioiThieuVi" bundle:nil];
    vc.nType = 0;
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

#pragma mark - QRCodeReader Delegate Methods
- (void)reader:(QRSearchViewController *)reader didScanResultSearch:(NSString *)result
{
    [reader stopScanning];
    NSLog(@"%s - -->result : %@", __FUNCTION__, result);
    [reader dismissViewControllerAnimated:YES completion:^{
        if (![[result lowercaseString] containsString:@"http"] && ![[result lowercaseString] containsString:@"vimass"] && result.length > 20) {
            //NSLog(@"%s - chuyen huong vnpay QR", __FUNCTION__);
            GiaoDienThanhToanQRVNPay *vc = [[GiaoDienThanhToanQRVNPay alloc] initWithNibName:@"GiaoDienThanhToanQRVNPay" bundle:nil];
            vc.sDataQR = result;
            self.navigationController.navigationBar.hidden = NO;
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
        } else {
            NSArray *arrResult = [result componentsSeparatedByString:@"*"];
            //NSLog(@"%s - arrResult : %lu", __FUNCTION__, (unsigned long)arrResult.count);
            if (arrResult.count > 2) {
                NSString *str = arrResult[1];
                NSLog(@"%s ----> str : %@", __FUNCTION__, str);
                if ([str hasPrefix:@"V"] || [str hasPrefix:@"S"]) {
                    NSLog(@"%s - line : %d", __FUNCTION__, __LINE__);
                    [DucNT_LuuRMS luuThongTinTrongRMSTheoKey:@"KEY_QR_SAN_PHAM_VER_2" value:str];
                    GiaoDienThanhToanQRSanPham *vc = [[GiaoDienThanhToanQRSanPham alloc] initWithNibName:@"GiaoDienThanhToanQRSanPham" bundle:nil];
                    self.navigationController.navigationBar.hidden = NO;
                    [self.navigationController pushViewController:vc animated:YES];
                    [vc release];
                }
                else if ([str hasPrefix:@"M"]){
                    NSLog(@"%s - line : %d", __FUNCTION__, __LINE__);
                    //                    GiaoDienThanhToanQRCodeDonVi *vc = [[GiaoDienThanhToanQRCodeDonVi alloc] initWithNibName:@"GiaoDienThanhToanQRCodeDonVi" bundle:nil];
                    //                    vc.sIdQRCode = str ;
                    //                    vc.typeQRCode = 0;
                    //                    self.navigationController.navigationBar.hidden = NO;
                    //                    [self.navigationController pushViewController:vc animated:YES];
                    //                    [vc release];
                }
                else{
                }
            } else {
                [DucNT_LuuRMS luuThongTinTrongRMSTheoKey:@"KEY_QR_SAN_PHAM_VER_2" value:result];
                GiaoDienThanhToanQRSanPham *vc = [[GiaoDienThanhToanQRSanPham alloc] initWithNibName:@"GiaoDienThanhToanQRSanPham" bundle:nil];
                self.navigationController.navigationBar.hidden = NO;
                [self.navigationController pushViewController:vc animated:YES];
                [vc release];
            }
        }
    }];
}

- (void)reader:(QRSearchViewController *)reader didScanResult:(NSString *)result
{
    [reader stopScanning];
    NSLog(@"HomeCenterViewController - %s - -->result : %@", __FUNCTION__, result);
    [reader dismissViewControllerAnimated:YES completion:^{
        
        if (result.length > 0) {
            if (![[result lowercaseString] containsString:@"http"] && ![[result lowercaseString] containsString:@"vimass"] && result.length > 20) {
                GiaoDienThanhToanQRVNPay *vc = [[GiaoDienThanhToanQRVNPay alloc] initWithNibName:@"GiaoDienThanhToanQRVNPay" bundle:nil];
                vc.sDataQR = result;
                self.navigationController.navigationBar.hidden = NO;
                [self.navigationController pushViewController:vc animated:YES];
                [vc release];
            } else {
                if (![result hasPrefix:@"http"] || [result hasSuffix:@"/transfers"]) {
                    if ([result containsString:@"*"]) {
                        NSArray *arrQuery = [result componentsSeparatedByString:@"*"];
                        if (arrQuery.count > 2) {
                            [DucNT_LuuRMS luuThongTinTrongRMSTheoKey:@"KEY_QR_SAN_PHAM_VER_2" value:[arrQuery objectAtIndex:1]];
                            GiaoDienThanhToanQRSanPham *vc = [[GiaoDienThanhToanQRSanPham alloc] initWithNibName:@"GiaoDienThanhToanQRSanPham" bundle:nil];
                            self.navigationController.navigationBar.hidden = NO;
                            [self.navigationController pushViewController:vc animated:YES];
                            [vc release];
                        }
                    }
                }
                else {
                    NSURL *url = [NSURL URLWithString:result];
                    NSString *queryQRCode = url.query;
                    //NSLog(@"%s - -->queryQRCode : %@", __FUNCTION__, queryQRCode);
                    if (queryQRCode == nil && [[url lastPathComponent] isEqualToString:@"quickpay"]) {
                        //                        GiaoDienThanhToanQRCodeDonVi *vc = [[GiaoDienThanhToanQRCodeDonVi alloc] initWithNibName:@"GiaoDienThanhToanQRCodeDonVi" bundle:nil];
                        //                        if ([[url lastPathComponent] isEqualToString:@"quickpay"]) {
                        //                            NSString *sKQ = [result stringByReplacingOccurrencesOfString:@"/quickpay" withString:@""];
                        //                            NSURL *url1 = [NSURL URLWithString:sKQ];
                        //                            vc.sIdQRCode = [url1 lastPathComponent];
                        //                        } else {
                        //                            vc.sIdQRCode = [url lastPathComponent];
                        //                        }
                        //                        vc.typeQRCode = 0;
                        //                        self.navigationController.navigationBar.hidden = NO;
                        //                        [self.navigationController pushViewController:vc animated:YES];
                        //                        [vc release];
                    }
                    else {
                        //NSLog(@"%s - -->queryQRCode : %@", __FUNCTION__, queryQRCode);
                        NSArray *arrQuery = [queryQRCode componentsSeparatedByString:@"="];
                        if (arrQuery.count == 2) {
                            NSString *idQRCode = [arrQuery lastObject];
                            //NSLog(@"%s - -->idQRCode : %@", __FUNCTION__, idQRCode);
                            GiaoDienThanhToanQRCode *vc = [[GiaoDienThanhToanQRCode alloc] initWithNibName:@"GiaoDienThanhToanQRCode" bundle:nil];
                            vc.sIdQRCode = idQRCode;
                            [self.navigationController pushViewController:vc animated:YES];
                            self.navigationController.navigationBar.hidden = NO;
                            [vc release];
                        }
                    }
                }
            }
        }
        
    }];
}

- (void)readerDidCancel:(QRSearchViewController *)reader
{
    [reader dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
