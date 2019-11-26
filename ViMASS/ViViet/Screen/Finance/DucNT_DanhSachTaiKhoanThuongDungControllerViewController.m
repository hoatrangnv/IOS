//
//  DucNT_DanhSachTaiKhoanThuongDungControllerViewController.m
//  ViMASS
//
//  Created by MacBookPro on 7/24/14.
//
//

#import "DucNT_DanhSachTaiKhoanThuongDungControllerViewController.h"
#import "DucNT_TaiKhoanThuongDungObject.h"
#import "DucNT_ChuyenTienDenTaiKhoanViewController.h"
#import "DucNT_ChuyenTienViDenViViewController.h"
#import "DucNT_ChuyenTienDenTheViewController.h"
#import "ThemTaiKhoanThuongDungViewController.h"
#import "ViewXacThuc.h"
#import "Common.h"
#import "HiNavigationBar.h"
#import "ChuyenTienViewController.h"
#import "ChuyenTienDenViMomoViewController.h"
#import "UIImageView+WebCache.h"
#import "GiaoDienTaoTheLuu.h"
@interface DucNT_DanhSachTaiKhoanThuongDungControllerViewController () <ViewXacThucDelegate, ThemTaiKhoanThuongDungViewControllerDelegate>
{
    int mKieuDangNhap;
}

@property (nonatomic, retain) ViewXacThuc *mViewXacThuc;

@end

@implementation DucNT_DanhSachTaiKhoanThuongDungControllerViewController
{
    int nDinhDanhKetNoi;
    int nViTriTKCanXoa;
}

@synthesize lvDanhSachTaiKhoan;
@synthesize lbTitle;
@synthesize dsTaiKhoanThuongDung;
@synthesize nLoaiTaiKhoan;
@synthesize rootView;
@synthesize btnBack;

static NSString *sReuseId = @"DucNT_TaiKhoanThuongDungCellId";
NSString *KEY_TAI_KHOAN_THUONG_DUNG = @"KEY_TAI_KHOAN_THUONG_DUNG";
NSString *KEY_TAI_KHOAN_NAP_TIEN = @"KEY_TAI_KHOAN_NAP_TIEN";

#pragma mark - init
- (id)initWithType:(int)nLoaiVi
{
    self = [super init];
    if(self)
    {
//       if(nLoaiVi == TAI_KHOAN_VI || nLoaiVi == TAI_KHOAN_THE || nLoaiVi == TAI_KHOAN_NGAN_HANG || nLoaiVi == TAI_KHOAN_MOMO)
//         self.nLoaiTaiKhoan = nLoaiVi;
//       else
//           self.nLoaiTaiKhoan = TAI_KHOAN_TONG_HOP;
        self.nLoaiTaiKhoan = nLoaiVi;
        nDinhDanhKetNoi = KET_NOI_LAY_DANH_SACH_TAI_KHOAN;
        nViTriTKCanXoa = -1;
    }
    return self;
}

- (IBAction)suKienBamTitle:(id)sender {
    [app.navigationController dismissViewControllerAnimated:NO completion:^
     {

     }];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    mKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    [self addTitleView:@"Sổ tay thường dùng"];
    
    self.lvDanhSachTaiKhoan.delegate = self;
    self.lvDanhSachTaiKhoan.dataSource = self;
    if(dsTaiKhoanThuongDung == nil)
        dsTaiKhoanThuongDung = [[NSMutableArray alloc] init];
    [dsTaiKhoanThuongDung removeAllObjects];
    
    [self.lvDanhSachTaiKhoan setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.lvDanhSachTaiKhoan registerNib:[UINib nibWithNibName:@"DucNT_TaiKhoanThuongDungCell" bundle:nil] forCellReuseIdentifier:sReuseId];
    
    NSLog(@"%s - [UIScreen mainScreen].bounds.size.height : %f", __FUNCTION__, [UIScreen mainScreen].bounds.size.height);
    NSLog(@"%s - self.topRootView.constant : %f", __FUNCTION__, self.topRootView.constant);
    if ([UIScreen mainScreen].bounds.size.height >= 812 && self.topRootView.constant == 0) {
        self.topRootView.constant += 12.0;
    }
    NSLog(@"%s - self.topRootView.constant : %f", __FUNCTION__, self.topRootView.constant);
    
    [self khoiTaoKetNoiLayDanhSachTaiKhoanThuongDung];
    [self khoiTaoViewXacThuc];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

-(void)viewDidLayoutSubviews
{
    [rootView fix];
}

#pragma mark - xu Ly view xac thuc
- (void)khoiTaoViewXacThuc
{
    if(!_mViewXacThuc)
    {
        self.mViewXacThuc = [[[NSBundle mainBundle] loadNibNamed:@"ViewXacThuc" owner:self options:nil] objectAtIndex:0];
        self.mViewXacThuc.mDelegate = self;
        self.mViewXacThuc.mThongTinVi = self.mThongTinTaiKhoanVi;
        
        [self.mViewXacThuc.mbtnSMS addTarget:self action:@selector(suKienBamNutMatKhauVanTay:) forControlEvents:UIControlEventTouchUpInside];
        if([self kiemTraCoChucNangQuetVanTay])
        {
            [self xuLyKhiCoChucNangQuetVanTay];
        }
        else
        {
            [self xuLyKhiKhongCoChucNangQuetVanTay];
        }
    }
    
}

- (void)anViewXacThuc
{
    if(_mViewXacThuc.superview)
    {
        [_mViewXacThuc removeFromSuperview];
    }
}

- (void)hienThiViewXacThuc
{
    if(!_mViewXacThuc.superview) {
        self.mViewXacThuc.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:_mViewXacThuc];
    }
    if (self.enableFaceID) {
        [_mViewXacThuc.mbtnSMS setImage:[UIImage imageNamed:@"face-id"] forState:UIControlStateNormal];
    } else {
        [_mViewXacThuc.mbtnSMS setImage:[UIImage imageNamed:@"finger"] forState:UIControlStateNormal];
    }
    _mViewXacThuc.hidden = NO;
}

- (void)updateXacThucKhac {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mViewXacThuc.mbtnToken setHidden:NO];
    });
}

- (void)showViewNhapToken:(int)type {
    [super showViewNhapToken:type];
    [_mViewXacThuc.viewNhapToken setHidden:NO];
}

- (void)hideViewNhapToken {
    [_mViewXacThuc.viewNhapToken setHidden:YES];
}

- (BOOL)validateVanTay {
    return YES;
}

#pragma mark - xu ly su kien

- (IBAction)suKienBack:(id)sender
{
    [app.navigationController dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)suKienThemTaiKhoanThuongDung:(id)sender
{
    ThemTaiKhoanThuongDungViewController *themTaiKhoanThuongDung = [[ThemTaiKhoanThuongDungViewController alloc] initWithNibName:@"ThemTaiKhoanThuongDungViewController" bundle:nil];
    themTaiKhoanThuongDung.modalPresentationStyle = UIModalPresentationFullScreen;
    themTaiKhoanThuongDung.mKieuThemTaiKhoanThuongDung = nLoaiTaiKhoan;
    themTaiKhoanThuongDung.mDelegate = self;

    UINavigationController *nav = [HiNavigationBar navigationControllerWithRootViewController: themTaiKhoanThuongDung];
    [themTaiKhoanThuongDung release];
    nav.navigationBar.barStyle = UIBarStyleBlackOpaque;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self presentViewController:nav animated:YES completion:^{}];

}

#pragma mark - ViewXacThucDelegate
- (void)xuLySuKienXacThucVoiKieu:(NSInteger)nKieuXacThuc token:(NSString*)sToken otp:(NSString*)sOtp
{
    NSLog(@"%s - nDinhDanhKetNoi : %d - sToken : %@", __FUNCTION__, nDinhDanhKetNoi, sToken);
    if(nDinhDanhKetNoi == KET_NOI_XOA_TAI_KHOAN)
    {
        if(nViTriTKCanXoa >= 0 && nViTriTKCanXoa < dsTaiKhoanThuongDung.count)
        {
            DucNT_TaiKhoanThuongDungObject *objTemp = [dsTaiKhoanThuongDung objectAtIndex:nViTriTKCanXoa];
            [self khoiTaoKetNoiXoaTaiKhoanThuongDung:objTemp.sId withType:objTemp.nType typeAuthenticate:nKieuXacThuc token:sToken otp:sOtp];
        } else {
            NSLog(@"%s - khong xoa duoc", __FUNCTION__);
        }
    }
    else if (nDinhDanhKetNoi == KET_NOI_DANG_KY_DINH_KY) {
        DucNT_TaiKhoanThuongDungObject *item = [dsTaiKhoanThuongDung objectAtIndex:nViTriTKCanXoa];
        int maDichVu = item.nType;
        int nKieuThanhToan = 3;
        if (maDichVu == TAI_KHOAN_NAP_TIEN_DIEN) {
            maDichVu = 1;
            if ([item.maKhachHang.lowercaseString hasPrefix:@"pd"]) {
                nKieuThanhToan = 0;
            }
            else if ([item.maKhachHang.lowercaseString hasPrefix:@"pe"]) {
                nKieuThanhToan = 2;
            }else if ([item.maKhachHang.lowercaseString hasPrefix:@"pc"] || [item.maKhachHang.lowercaseString hasPrefix:@"pp"] || [item.maKhachHang.lowercaseString hasPrefix:@"pq"]) {
                nKieuThanhToan = 1;
            }
            else if ([item.maKhachHang.lowercaseString hasPrefix:@"pa25"]) {
                nKieuThanhToan = 8;
            }
        }
        else if (maDichVu == TAI_KHOAN_HOA_DON_NUOC) {
            maDichVu = 2;
            if (item.nhaCungCap == 103) {
                nKieuThanhToan = 102;
            }
            else if (item.nhaCungCap == 105) {
                nKieuThanhToan = 104;
            }
            else if (item.nhaCungCap == 107) {
                nKieuThanhToan = 106;
            }
            else if (item.nhaCungCap == 115) {
                nKieuThanhToan = 114;
            }
            else if (item.nhaCungCap == 113) {
                nKieuThanhToan = 112;
            }
            else if (item.nhaCungCap == 109) {
                nKieuThanhToan = 108;
            }
        }
        else if (maDichVu == TAI_KHOAN_DIEN_THOAI) {
            maDichVu = 3;
            if (item.nhaMang == NHA_MANG_VIETTEL) {
                nKieuThanhToan = 1;
            }
            else if (item.nhaMang == NHA_MANG_VINA) {
                nKieuThanhToan = 31;
            }
            else {
                nKieuThanhToan = 33;
            }
        }
        NSDictionary *dicPost = @{@"user" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                                  @"maDichVu":[NSNumber numberWithInt:maDichVu],
                                  @"kieuThanhToan":[NSNumber numberWithInt:nKieuThanhToan],
                                  @"maKhachHang":item.maKhachHang,
                                  @"token":sToken,
                                  @"otpConfirm":sOtp,
                                  @"typeAuthenticate" : [NSNumber numberWithInteger:nKieuXacThuc],
                                  @"VMApp" : [NSNumber numberWithInt:VM_APP],
                                  @"appId" : [NSNumber numberWithInt:APP_ID],
                                  };
        [GiaoDichMang ketNoiDangKyThongBaoDinhKy:[dicPost JSONString] noiNhanKetQua:self];
        [self.mViewXacThuc setHidden:YES];
    }
    else if (nDinhDanhKetNoi == KET_NOI_HUY_DINH_KY) {
        DucNT_TaiKhoanThuongDungObject *item = [dsTaiKhoanThuongDung objectAtIndex:nViTriTKCanXoa];
        NSDictionary *dicPost = @{@"id" : item.idThongBaoDinhKy,
                                  @"user" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                                  @"session" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_SECSSION],
                                  @"token":sToken,
                                  @"otpConfirm":sOtp,
                                  @"typeAuthenticate" : [NSNumber numberWithInteger:nKieuXacThuc],
                                  @"VMApp" : [NSNumber numberWithInt:VM_APP],
                                  @"appId" : [NSNumber numberWithInt:APP_ID],
                                  };
        [GiaoDichMang ketNoiHuyThongBaoDinhKy:[dicPost JSONString] noiNhanKetQua:self];
        [self.mViewXacThuc setHidden:YES];
    }
}

- (void)xuLySuKienBamNutVanTay
{
    [self xuLySuKienDangNhapVanTay];
}

#pragma mark - khởi tạo kết nối
-(void)khoiTaoKetNoiLayDanhSachTaiKhoanThuongDung
{
    [self hienThiLoading];
    nDinhDanhKetNoi = KET_NOI_LAY_DANH_SACH_TAI_KHOAN;
    [GiaoDichMang ketNoiLayDanhSachTaiKhoanThuongDung:nLoaiTaiKhoan noiNhanKetQua:self];
}

-(void)khoiTaoKetNoiXoaTaiKhoanThuongDung:(NSString *)sId withType:(int) nType typeAuthenticate:(NSInteger)nTypeAuthenticate token:(NSString*)sToken otp:(NSString*)sOtp
{
    nDinhDanhKetNoi = KET_NOI_XOA_TAI_KHOAN;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self anViewXacThuc];
        [self hienThiLoadingChuyenTien];
    });
    
//    [GiaoDichMang ketNoiXoaTaiKhoanThuongDung:sId kieuLay:nType token:sToken otp:sOtp typeAuthenticate:(int)nTypeAuthenticate noiNhanKetQua:self];
    NSString *sMaDoanhNghiep = @"";
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sMaDoanhNghiep = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_COMPANY_ID];
    }
    NSDictionary *dicPost = @{
                              @"id":sId,
                              @"phoneOwner":[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                              @"companyCode": sMaDoanhNghiep,
                              @"type":[NSString stringWithFormat:@"%d", nType],
                              @"token" : sToken,
                              @"otpConfirm" : sOtp,
                              @"typeAuthenticate" : [NSNumber numberWithInteger:nTypeAuthenticate],
                              @"appId" : [NSNumber numberWithInt:APP_ID],
                              @"VMApp" : [NSNumber numberWithInt:VM_APP]
                              };
    NSString *sLinkDelete = [NSString stringWithFormat:@"%@%@", ROOT_URL, @"account/deleteAccUsed"];
    NSLog(@"%s - sLinkDelete : %@", __FUNCTION__, sLinkDelete);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:sLinkDelete]];
        
    // Specify that it will be a POST request
    request.HTTPMethod = @"POST";
        
    // This is how we set header fields
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
     
    // Convert your data and set your request's HTTPBody property
    NSString *stringData = [dicPost JSONString];
    NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBodyData;
        
    // Create url connection and fire request
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self anLoading];
        });
        if (error == nil && data != nil) {
            NSString *sKetQua = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%s - sKetQua : %@", __FUNCTION__, sKetQua);
            NSDictionary *dicKetQua = [sKetQua objectFromJSONString];
            NSString *msgContent = [dicKetQua objectForKey:@"msgContent"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:msgContent];
            });
        }
    }] resume];
}

#pragma mark - xử lý kết nối
-(void)ketNoiThanhCong:(NSString *)sKetQua
{
    NSLog(@"%s - nDinhDanhKetNoi : %d - sKetQua : %@", __FUNCTION__, nDinhDanhKetNoi, sKetQua);
    if(nDinhDanhKetNoi == KET_NOI_LAY_DANH_SACH_TAI_KHOAN)
    {
        [self anLoading];
        [self xuLyketNoiLayDanhSachTaiKhoan:sKetQua];
    }
    else if(nDinhDanhKetNoi == KET_NOI_XOA_TAI_KHOAN)
    {
        [self xuLyKetNoiXoaTaiKhoan:sKetQua];
    }
    else if (nDinhDanhKetNoi == KET_NOI_DANG_KY_DINH_KY || nDinhDanhKetNoi == KET_NOI_HUY_DINH_KY) {
        [self anLoading];
        DucNT_TaiKhoanThuongDungObject *item = [dsTaiKhoanThuongDung objectAtIndex:nViTriTKCanXoa];
        if (nDinhDanhKetNoi == KET_NOI_DANG_KY_DINH_KY) {
            item.trangThaiThongBaoDinhKy = 1;
        }
        else {
            item.trangThaiThongBaoDinhKy = 0;
        }
        [self.lvDanhSachTaiKhoan reloadData];
    }
}

- (void)xuLyKetNoiThanhCong:(NSString*)sDinhDanhKetNoi thongBao:(NSString*)sThongBao ketQua:(id)ketQua
{
    NSLog(@"%s - nDinhDanhKetNoi : %d - sKetQua : %@", __FUNCTION__, nDinhDanhKetNoi, ketQua);
}

-(void)xuLyketNoiLayDanhSachTaiKhoan:(NSString *)sKetQua
{
//    NSLog(@"%s - sKetQua : %@", __FUNCTION__, sKetQua);
    NSDictionary *dic = [sKetQua objectFromJSONString];
//    NSLog(@"%s - dictTemp : %@", __FUNCTION__, [dic description]);
//    NSDictionary *dic = [[[[sKetQua stringByReplacingOccurrencesOfString:@"\\" withString:@""] stringByReplacingOccurrencesOfString:@"\"{" withString:@"{"] stringByReplacingOccurrencesOfString:@"}\"" withString:@"}"] objectFromJSONString];
//    NSLog(@"%s - dic : %@", __FUNCTION__, [dic description]);
    int nCode = [[dic objectForKey:@"msgCode"] intValue];
    NSLog(@"%s - nCode : %d", __FUNCTION__, nCode);
    NSString *sMessage = [dic objectForKey:@"msgContent"];
    if(nCode == 1)
    {
        NSDictionary *dic2 = [dic objectForKey:@"result"];
        NSArray *dsTaiKhoan = [dic2 objectForKey:@"list"];
        NSLog(@"%s - dsTaiKhoan : %ld", __FUNCTION__, (long)dsTaiKhoan.count);
        if(dsTaiKhoan.count > 0)
        {
            if(dsTaiKhoanThuongDung)
                [dsTaiKhoanThuongDung removeAllObjects];
            else
                dsTaiKhoanThuongDung = [[NSMutableArray alloc] init];
            for(int i = 0; i < dsTaiKhoan.count; i++)
            {
                NSString *value = [dsTaiKhoan objectAtIndex:i];
                NSDictionary *itemDs = [value objectFromJSONString];
                DucNT_TaiKhoanThuongDungObject *obj = [[DucNT_TaiKhoanThuongDungObject alloc] init];
                obj.sId = [itemDs objectForKey:@"id"];
                obj.sPhoneOwner = [itemDs objectForKey:@"phoneOwner"];
                obj.nType = [[itemDs objectForKey:@"type"] intValue];
                NSString *sAlias = [Common URLDecode:[itemDs objectForKey:@"aliasName"]];
                if ([sAlias containsString:@"u0026"]) {
                    sAlias = [sAlias stringByReplacingOccurrencesOfString:@"u0026" withString:@"&"];
                }
                obj.sAliasName = sAlias;
                obj.nAmount = [[itemDs objectForKey:@"amount"] doubleValue];
                obj.sDesc = [Common URLDecode:[itemDs objectForKey:@"desc"]];
                obj.sToAccWallet = [itemDs objectForKey:@"toAccWallet"];
                NSString *sAccOwnerName = [Common URLDecode:[itemDs objectForKey:@"AccOwnerName"]];
                if ([sAccOwnerName containsString:@"u0026"]) {
                    sAccOwnerName = [sAccOwnerName stringByReplacingOccurrencesOfString:@"u0026" withString:@"&"];
                }
                obj.sAccOwnerName = sAccOwnerName;
                obj.sBankName = [Common URLDecode:[itemDs objectForKey:@"bankName"]];
                obj.sBankNumber = [itemDs objectForKey:@"BankNumber"];
                obj.sProvinceName = [Common URLDecode:[itemDs objectForKey:@"provinceName"]];
                obj.nProvinceCode = [[itemDs objectForKey:@"provinceCode"] intValue];
                obj.nProvinceID = [[itemDs objectForKey:@"provinceId"]intValue];
                obj.nBankCode = [[itemDs objectForKey:@"bankCode"] intValue];
                obj.nBankId = [[itemDs objectForKey:@"bankId"] intValue];
                obj.nBranchId = [[itemDs objectForKey:@"branchId"] intValue];
                obj.sBranchName = [Common URLDecode:[itemDs objectForKey:@"branchName"]];
                obj.sBranchCode = [itemDs objectForKey:@"branchCode"];
//                obj.nCardId = [[itemDs objectForKey:@"cardId"] intValue];
                obj.nDateExp = [[itemDs objectForKey:@"dateExp"] longLongValue];
                obj.nDateReg = [[itemDs objectForKey:@"dateReg"] longLongValue];
                obj.sCardNumber = [itemDs objectForKey:@"cardNumber"];
                obj.sCardOwnerName = [itemDs objectForKey:@"cardOwnerName"];
                obj.sCardTypeName = [itemDs objectForKey:@"cardTypeName"];
                obj.tenNguoiThuHuong = [itemDs objectForKey:@"tenNguoiThuHuong"];
                obj.cellphoneNumber = [itemDs objectForKey:@"cellphoneNumber"];
                obj.soTien = [[itemDs objectForKey:@"soTien"] intValue];
                obj.cmnd = [itemDs objectForKey:@"cmnd"];
                obj.tinhThanh = [itemDs objectForKey:@"tinhThanh"];
                obj.quanHuyen = [itemDs objectForKey:@"quanHuyen"];
                obj.phuongXa = [itemDs objectForKey:@"phuongXa"];
                obj.diaChi = [itemDs objectForKey:@"diaChi"];
                obj.noiDung = [itemDs objectForKey:@"noiDung"];
                obj.nhaMang = [[itemDs objectForKey:@"nhaMang"] intValue];
                obj.loaiThueBao = [[itemDs objectForKey:@"loaiThueBao"] intValue];
                obj.soDienThoai = [itemDs objectForKey:@"soDienThoai"];
                obj.avatar = [itemDs objectForKey:@"avatar"];
                obj.cvv = [itemDs objectForKey:@"cvv"];
                obj.cardMonth = [[itemDs objectForKey:@"cardMonth"] intValue];
                obj.cardYear = [[itemDs objectForKey:@"cardYear"] intValue];
                obj.otpGetType = [itemDs objectForKey:@"otpGetType"];
                obj.nhaCungCap = [[itemDs objectForKey:@"nhaCungCap"] intValue];
                obj.taiKhoan = [itemDs objectForKey:@"taiKhoan"];
                obj.loaiGame = [itemDs objectForKey:@"loaiGame"];
                obj.maKhachHang = [itemDs objectForKey:@"maKhachHang"];

                obj.cachThucQuayVong = [[itemDs objectForKey:@"cachThucQuayVong"] intValue];
                obj.kyLinhLai = [[itemDs objectForKey:@"kyLinhLai"] intValue];
                obj.kieuNhanTien = [[itemDs objectForKey:@"kieuNhanTien"] intValue];
                obj.maNganHang = [itemDs objectForKey:@"maNganHang"];
                obj.kyHan = [itemDs objectForKey:@"kyHan"];
                obj.tenNguoiGui = [itemDs objectForKey:@"tenNguoiGui"];
                obj.soCmt = [itemDs objectForKey:@"soCmt"];
                obj.maNganHangNhanTien = [itemDs objectForKey:@"maNganHangNhanTien"];
                obj.tenChuTaiKhoan = [itemDs objectForKey:@"tenChuTaiKhoan"];
                obj.soTaiKhoan = [itemDs objectForKey:@"soTaiKhoan"];
                //ATM
                obj.kieuThanhToan = [[itemDs objectForKey:@"kieuThanhToan"] intValue];
                obj.maNhaCungCap = [[itemDs objectForKey:@"maNhaCungCap"] intValue];
                obj.maATM = [[itemDs objectForKey:@"maATM"] intValue];
                //cmnd
                obj.ngayCap = [[itemDs objectForKey:@"ngayCap"] longLongValue];
                obj.noiCap = [itemDs objectForKey:@"noiCap"];
                obj.diaChiChiNhanh = [itemDs objectForKey:@"diaChiChiNhanh"];
                obj.tenChiNhanh = [itemDs objectForKey:@"tenChiNhanh"];
                //
                obj.idIcon = [[itemDs objectForKey:@"idIcon"] intValue];
                obj.giftName = [itemDs objectForKey:@"giftName"];
                obj.tenNguoiUngHo = [itemDs objectForKey:@"tenNguoiUngHo"];
                obj.maDuAnTuThien = [[itemDs objectForKey:@"maDuAnTuThien"] intValue];
                obj.hoanCanhNguoiUngHo = [itemDs objectForKey:@"hoanCanhNguoiUngHo"];
                obj.diaChiNguoiUngHo = [itemDs objectForKey:@"diaChiNguoiUngHo"];
                obj.maThueBao = [itemDs objectForKey:@"maThueBao"];
                // hoc phi
                obj.loaiDichVuHocPhi = [[itemDs objectForKey:@"loaiDichVuHocPhi"] intValue];
                obj.maHocPhi = [itemDs objectForKey:@"maHocPhi"];
                obj.maKhachHangHocPhi = [itemDs objectForKey:@"maKhachHangHocPhi"];
                obj.tenKhachHangHocPhi = [itemDs objectForKey:@"tenKhachHangHocPhi"];
                obj.maHopDong = [itemDs objectForKey:@"maHopDong"];
                obj.maChiNhanh = [itemDs objectForKey:@"maChiNhanh"];
                obj.idThongBaoDinhKy = [itemDs objectForKey:@"idThongBaoDinhKy"];
                obj.trangThaiThongBaoDinhKy = [[itemDs objectForKey:@"trangThaiThongBaoDinhKy"] intValue];
                
                obj.tenCongTyXuatHoaDon = [itemDs objectForKey:@"tenCongTyXuatHoaDon"];
                obj.diaChiCongTyXuatHoaDon = [itemDs objectForKey:@"diaChiCongTyXuatHoaDon"];
                obj.maSoThueCongTyXuatHoaDon = [itemDs objectForKey:@"maSoThueCongTyXuatHoaDon"];
                obj.diaChiNhanHoaDon = [itemDs objectForKey:@"diaChiNhanHoaDon"];
                
                if(obj.nType != TAI_KHOAN_THE_RUT_TIEN)
                {
//                    NSLog(@"DanhSachTaiKhoanThuongDungController : cellphoneNumber : %@", [itemDs objectForKey:@"cellphoneNumber"]);
//                    if (self.nLoaiTaiKhoan == TAI_KHOAN_THE_DIRECT && obj.nType == self.nLoaiTaiKhoan) {
//                        [dsTaiKhoanThuongDung addObject:obj];
//                    }
//                    if (self.nLoaiTaiKhoan == TAI_KHOAN_VISA) {
//                        if (obj.nType == TAI_KHOAN_VISA || obj.nType == TAI_KHOAN_MASTER_CARD || obj.nType == TAI_KHOAN_JCB) {
//                            [dsTaiKhoanThuongDung addObject:obj];
//                        }
//                    }
//                    else if (self.nLoaiTaiKhoan != TAI_KHOAN_THE_DIRECT)
                        [dsTaiKhoanThuongDung addObject:obj];
                }
                [obj release];
            }
            if (dsTaiKhoanThuongDung.count == 0){
                [[[[UIAlertView alloc] initWithTitle:[@"thong_bao" localizableString]  message:[@"tai_khoan_thuong_dung_khong_co" localizableString] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
                return;
            }
            [lvDanhSachTaiKhoan reloadData];
        }
        else
        {
            [[[[UIAlertView alloc] initWithTitle:[@"thong_bao" localizableString]  message:[@"tai_khoan_thuong_dung_khong_co" localizableString] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
        }
    }
    else
        [[[[UIAlertView alloc] initWithTitle:[@"thong_bao" localizableString]  message:sMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
}

-(void)xuLyKetNoiXoaTaiKhoan:(NSString *)sKetQua
{
    NSLog(@"%s - sKetQua : %@", __FUNCTION__, sKetQua);
    NSDictionary *dic = [sKetQua objectFromJSONString];
    int nCode = [[dic objectForKey:@"msgCode"] intValue];
    NSString *sMessage = [dic objectForKey:@"msgContent"];
    if(nCode == 1)
    {
        [self hienThiHopThoaiMotNutBamKieu:HOP_THOAI_XAC_NHAN_CHUYEN_TIEN_THANH_CONG cauThongBao:sMessage];
    }
    else
    {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:[@"thong_bao" localizableString] message:sMessage delegate:self cancelButtonTitle:[@"dong" localizableString] otherButtonTitles:nil, nil] autorelease];
        alert.tag = HOP_THOAI_XAC_NHAN_KHONG_THANH_CONG;
        [alert show];
    }
}

///*Hàm này để convert string dạng URL:@"N%E1%BA%A1p+v%C3%AD+cho+Trung+TV" thành bt*/
//- (NSString *)URLDecode:(NSString *)sTring
//{
//    NSString *result = [sTring stringByReplacingOccurrencesOfString:@"+" withString:@" "];
//    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    return result;
//}

#pragma mark - xuLySuKienVanTay

- (void)xuLyKhiKhongCoChucNangQuetVanTay
{
    if(_mViewXacThuc)
        [_mViewXacThuc.mbtnVanTay setHidden:YES];
}

- (void)xuLyKhiCoChucNangQuetVanTay
{
    if(_mViewXacThuc)
        [_mViewXacThuc.mbtnVanTay setHidden:NO];
}

- (void)xuLySuKienDangNhapVanTay
{
    [self xuLySuKienHienThiChucNangVanTayVoiTieuDe:[@"su_dung_van_tay_dang_nhap_tai_khoan_token_VIMASS" localizableString]];
}

- (void)xuLySuKienXacThucVanTayThanhCong
{
    [_mViewXacThuc xuLyKhiXacThucVanTayThanhCong];
}

- (void)hienThiThongBaoDienMatKhau
{
    [UIAlertView alert:[@"thong_bao_xac_thuc_van_tay_khong_dung" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
    if(_mViewXacThuc)
        [_mViewXacThuc.mbtnVanTay setHidden:NO];
}



#pragma mark xử lý click button on alertview khi thông báo
/* thông báo kết nối lấy danh sách tài khoản (load danh sách lúc đầu)
 * thông báo kết nối xoá tài khoản thường dùng;
 */
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(nDinhDanhKetNoi == KET_NOI_LAY_DANH_SACH_TAI_KHOAN)
    {
        if(buttonIndex == alertView.cancelButtonIndex)
        {
//            [app.navigationController dismissModalViewControllerAnimated:YES];
//            [app.navigationController dismissViewControllerAnimated:YES completion:^{}];
        }
    }
    else if(nDinhDanhKetNoi == KET_NOI_XOA_TAI_KHOAN)
    {
        if(buttonIndex == alertView.cancelButtonIndex)
        {
            if(alertView.tag == HOP_THOAI_XAC_NHAN_CHUYEN_TIEN_THANH_CONG)
            {
                nDinhDanhKetNoi = KET_NOI_LAY_DANH_SACH_TAI_KHOAN;
                [_mViewXacThuc ketThucDemThoiGian];
                [self anViewXacThuc];
                [dsTaiKhoanThuongDung removeObjectAtIndex:nViTriTKCanXoa];
                nViTriTKCanXoa = -1;
                [lvDanhSachTaiKhoan reloadData];
            }
            else
            {
                nDinhDanhKetNoi = KET_NOI_XOA_TAI_KHOAN;
            }
        }
        else
        {
            nDinhDanhKetNoi = KET_NOI_XOA_TAI_KHOAN;
            [self hienThiViewXacThuc];
            NSLog(@"%s >> %s line: %d >> Dong y xoa ",__FILE__,__FUNCTION__ ,__LINE__);
        }
    }
}

#pragma mark - ThemTaiKhoanThuongDungViewControllerDelegate

- (void)xuLySuKienThem_CapNhatTaiKhoanThuongDungThanhCong
{
    [self khoiTaoKetNoiLayDanhSachTaiKhoanThuongDung];
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dsTaiKhoanThuongDung.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DucNT_TaiKhoanThuongDungObject *item = [dsTaiKhoanThuongDung objectAtIndex:indexPath.row];
    int n = item.nType;
    if (n == TAI_KHOAN_DIEN_THOAI || n == TAI_KHOAN_NAP_TIEN_DIEN || n == TAI_KHOAN_HOA_DON_NUOC) {
        return 110.0;
    }
    else {
        return 90.0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DucNT_TaiKhoanThuongDungCell *cell = [tableView dequeueReusableCellWithIdentifier:sReuseId];

    if (cell == nil) {
        cell = [[DucNT_TaiKhoanThuongDungCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sReuseId];
    }

    [cell.btnCheckThongBao addTarget:self action:@selector(suKienChonCheckThongBao:) forControlEvents:UIControlEventTouchUpInside];

    DucNT_TaiKhoanThuongDungObject *item = [dsTaiKhoanThuongDung objectAtIndex:indexPath.row];
    cell.lbTenTaoKhoan.text = item.sAliasName;
    cell.lbTenTaoKhoan.textColor = [UIColor blackColor];
    int n = item.nType;
    UIImage *image = [UIImage imageNamed:@"ck-vi-vi.png"];
    NSString *sAvatarLink = item.avatar;
//    NSLog(@"%s - sAvatarLink : %@", __FUNCTION__, sAvatarLink);
    if (sAvatarLink.length > 0 && ![sAvatarLink hasPrefix:@"http"]) {
        sAvatarLink = [NSString stringWithFormat:@"%@%@", @"https://vimass.vn/vmbank/services/media/getImage?id=", sAvatarLink];
    }
    if (!sAvatarLink || [sAvatarLink isEqualToString:@"(null)"]) {
        sAvatarLink = @"";
    }

    if (n == TAI_KHOAN_DIEN_THOAI || n == TAI_KHOAN_NAP_TIEN_DIEN || n == TAI_KHOAN_HOA_DON_NUOC) {
        NSLog(@"%s - trangThaiThongBaoDinhKy : %d", __FUNCTION__, item.trangThaiThongBaoDinhKy);
        [cell.btnCheckThongBao setHidden:NO];
        if (item.trangThaiThongBaoDinhKy == 1) {
            [cell.btnCheckThongBao setImage:[UIImage imageNamed:@"icon-tracudinhky"] forState:UIControlStateNormal];
            [cell.btnCheckThongBao setTitle:@"Huỷ nhận thông báo định kỳ" forState:UIControlStateNormal];
        }
        else if (item.trangThaiThongBaoDinhKy == 0){
            [cell.btnCheckThongBao setImage:[UIImage imageNamed:@"icon-Botracudinhky"] forState:UIControlStateNormal];
            [cell.btnCheckThongBao setTitle:@"Đăng ký nhận thông báo định kỳ" forState:UIControlStateNormal];
        }
        else {
            [cell.btnCheckThongBao setHidden:YES];
        }
    }
    else {
        [cell.btnCheckThongBao setHidden:YES];
    }

    if(n == TAI_KHOAN_VI)
    {
        if (sAvatarLink.isEmpty) {
            image = [UIImage imageNamed:@"icon_v2_denvivimass.png"];
            cell.imvLoaiTaiKhoan.image = image;
        }
        else{
            [cell.imvLoaiTaiKhoan sd_setImageWithURL:[NSURL URLWithString:sAvatarLink] placeholderImage:[UIImage imageNamed:@"icon_v2_denvivimass.png"]];
        }
    }
    else if(n == TAI_KHOAN_THE)
    {
        if (sAvatarLink.isEmpty) {
            image = [UIImage imageNamed:@"icon_v2_denthe.png"];
            cell.imvLoaiTaiKhoan.image = image;
        }
        else{
            [cell.imvLoaiTaiKhoan sd_setImageWithURL:[NSURL URLWithString:sAvatarLink] placeholderImage:[UIImage imageNamed:@"icon_v2_denthe.png"]];
        }
    }
    else if(n == TAI_KHOAN_NGAN_HANG)
    {
        if (sAvatarLink.isEmpty) {
            image = [UIImage imageNamed:@"icon_v2_dentaikhoan.png"];
            cell.imvLoaiTaiKhoan.image = image;
        }
        else{
            [cell.imvLoaiTaiKhoan sd_setImageWithURL:[NSURL URLWithString:sAvatarLink] placeholderImage:[UIImage imageNamed:@"icon_v2_dentaikhoan.png"]];
        }
    }
    else if(n == TAI_KHOAN_THE_RUT_TIEN)
    {
        if (sAvatarLink.isEmpty) {
            image = [UIImage imageNamed:@"icon-theruttien64x64"];
            cell.imvLoaiTaiKhoan.image = image;
        }
        else{
            [cell.imvLoaiTaiKhoan sd_setImageWithURL:[NSURL URLWithString:sAvatarLink] placeholderImage:[UIImage imageNamed:@"icon-theruttien64x64.png"]];
        }
    }
    else if(n == TAI_KHOAN_NGAN_HANG_RUT_TIEN)
    {
        if (sAvatarLink.isEmpty) {
            image = [UIImage imageNamed:@"icon-taikhoanrutien64x64"];
            cell.imvLoaiTaiKhoan.image = image;
        }
        else{
            [cell.imvLoaiTaiKhoan sd_setImageWithURL:[NSURL URLWithString:sAvatarLink] placeholderImage:[UIImage imageNamed:@"icon-taikhoanrutien64x64.png"]];
        }
    }
    else if(n == TAI_KHOAN_VI_KHAC)
    {
        if (sAvatarLink.isEmpty) {
            image = [UIImage imageNamed:@"icon_v2_denvikhac.png"];
            cell.imvLoaiTaiKhoan.image = image;
        }
        else{
            [cell.imvLoaiTaiKhoan sd_setImageWithURL:[NSURL URLWithString:sAvatarLink] placeholderImage:[UIImage imageNamed:@"icon_v2_denvikhac.png"]];
        }
    }
    else if (n == TAI_KHOAN_TAN_NHA){
        if (sAvatarLink.isEmpty) {
            image = [UIImage imageNamed:@"icon_v2_dentannha.png"];
            cell.imvLoaiTaiKhoan.image = image;
        }
        else{
            [cell.imvLoaiTaiKhoan sd_setImageWithURL:[NSURL URLWithString:sAvatarLink] placeholderImage:[UIImage imageNamed:@"icon_v2_dentannha.png"]];
        }
    }
    else if (n == TAI_KHOAN_DIEN_THOAI){
        if (sAvatarLink.isEmpty) {
            image = [UIImage imageNamed:@"icon_v2_ttdienthoai.png"];
            cell.imvLoaiTaiKhoan.image = image;
        }
        else{
            [cell.imvLoaiTaiKhoan sd_setImageWithURL:[NSURL URLWithString:sAvatarLink] placeholderImage:[UIImage imageNamed:@"icon_v2_ttdienthoai.png"]];
        }
    }
    else if (n == TAI_KHOAN_THE_DIRECT || n == TAI_KHOAN_VISA || n == TAI_KHOAN_MASTER_CARD || n == TAI_KHOAN_JCB){
//        image = [UIImage imageNamed:@"icon_v2_cachnapvi.png"];
//        cell.imvLoaiTaiKhoan.image = image;
        if (sAvatarLink.isEmpty) {
            image = [UIImage imageNamed:@"icon_v2_theluunaptien.png"];
            cell.imvLoaiTaiKhoan.image = image;
        }
        else{
            [cell.imvLoaiTaiKhoan sd_setImageWithURL:[NSURL URLWithString:sAvatarLink] placeholderImage:[UIImage imageNamed:@"icon_v2_theluunaptien.png"]];
        }
    }
    else if (n == TAI_KHOAN_NAP_TIEN_GAME) {
        if (sAvatarLink.isEmpty) {
            image = [UIImage imageNamed:@"icon_v2_naptiendientu.png"];
            cell.imvLoaiTaiKhoan.image = image;
        }
        else{
            [cell.imvLoaiTaiKhoan sd_setImageWithURL:[NSURL URLWithString:sAvatarLink] placeholderImage:[UIImage imageNamed:@"icon_v2_naptiendientu.png"]];
        }
    }
    else if (n == TAI_KHOAN_GUI_TIET_KIEM) {
        if (sAvatarLink.isEmpty) {
            image = [UIImage imageNamed:@"icon_v2_tietkiem.png"];
            cell.imvLoaiTaiKhoan.image = image;
        }
        else{
            [cell.imvLoaiTaiKhoan sd_setImageWithURL:[NSURL URLWithString:sAvatarLink] placeholderImage:[UIImage imageNamed:@"icon_v2_tietkiem.png"]];
        }
    }
    else if (n == TAI_KHOAN_NAP_TIEN_DIEN) {
        if (sAvatarLink.isEmpty) {
            image = [UIImage imageNamed:@"icon_v2_dien.png"];
            cell.imvLoaiTaiKhoan.image = image;
        }
        else{
            [cell.imvLoaiTaiKhoan sd_setImageWithURL:[NSURL URLWithString:sAvatarLink] placeholderImage:[UIImage imageNamed:@"icon_v2_dien.png"]];
        }
    }
    else if (n == TAI_KHOAN_CHUYEN_TIEN_CMND) {
        if (sAvatarLink.isEmpty) {
            image = [UIImage imageNamed:@"icon_v2_denCMND.png"];
            cell.imvLoaiTaiKhoan.image = image;
        }
        else{
            [cell.imvLoaiTaiKhoan sd_setImageWithURL:[NSURL URLWithString:sAvatarLink] placeholderImage:[UIImage imageNamed:@"icon_v2_denCMND.png"]];
        }
    }
    else if (n == TAI_KHOAN_CHUYEN_TIEN_ATM) {
        if (sAvatarLink.isEmpty) {
            image = [UIImage imageNamed:@"icon_v2_denatm.png"];
            cell.imvLoaiTaiKhoan.image = image;
        }
        else{
            [cell.imvLoaiTaiKhoan sd_setImageWithURL:[NSURL URLWithString:sAvatarLink] placeholderImage:[UIImage imageNamed:@"icon_v2_denatm.png"]];
        }
    }
    else if (n == TAI_KHOAN_CHUNG_KHOAN) {
        if (sAvatarLink.isEmpty) {
            image = [UIImage imageNamed:@"icon_v2_chungkhoan.png"];
            cell.imvLoaiTaiKhoan.image = image;
        }
        else{
            [cell.imvLoaiTaiKhoan sd_setImageWithURL:[NSURL URLWithString:sAvatarLink] placeholderImage:[UIImage imageNamed:@"icon_v2_chungkhoan.png"]];
        }
    }
    else if (n == TAI_KHOAN_MUON_TIEN) {
        if (sAvatarLink.isEmpty) {
            image = [UIImage imageNamed:@"icon_v2_muontien.png"];
            cell.imvLoaiTaiKhoan.image = image;
        }
        else{
            [cell.imvLoaiTaiKhoan sd_setImageWithURL:[NSURL URLWithString:sAvatarLink] placeholderImage:[UIImage imageNamed:@"icon_v2_muontien.png"]];
        }
    }
    else if (n == TAI_KHOAN_QUA_TANG) {
        if (sAvatarLink.isEmpty) {
            image = [UIImage imageNamed:@"icon_v2_tangqua.png"];
            cell.imvLoaiTaiKhoan.image = image;
        }
        else{
            [cell.imvLoaiTaiKhoan sd_setImageWithURL:[NSURL URLWithString:sAvatarLink] placeholderImage:[UIImage imageNamed:@"icon_v2_tangqua.png"]];
        }
    }
    else if (n == TAI_KHOAN_NAP_TIEN_TU_THIEN) {
        if (sAvatarLink.isEmpty) {
            image = [UIImage imageNamed:@"icon_v2_tuthien.png"];
            cell.imvLoaiTaiKhoan.image = image;
        }
        else{
            [cell.imvLoaiTaiKhoan sd_setImageWithURL:[NSURL URLWithString:sAvatarLink] placeholderImage:[UIImage imageNamed:@"icon_v2_tuthien.png"]];
        }
    }
    else if (n == TAI_KHOAN_HOA_DON_NUOC) {
        if (sAvatarLink.isEmpty) {
            image = [UIImage imageNamed:@"icon_v2_nuoc.png"];
            cell.imvLoaiTaiKhoan.image = image;
        }
        else{
            [cell.imvLoaiTaiKhoan sd_setImageWithURL:[NSURL URLWithString:sAvatarLink] placeholderImage:[UIImage imageNamed:@"icon_v2_nuoc.png"]];
        }
    }
    else if (n == TAI_KHOAN_NAP_TIEN_INTERNET) {
        if (sAvatarLink.isEmpty) {
            image = [UIImage imageNamed:@"icon_v2_internet.png"];
            cell.imvLoaiTaiKhoan.image = image;
        }
        else{
            [cell.imvLoaiTaiKhoan sd_setImageWithURL:[NSURL URLWithString:sAvatarLink] placeholderImage:[UIImage imageNamed:@"icon_v2_internet.png"]];
        }
    }
    else if (n == TAI_KHOAN_HOC_PHI) {
        if (sAvatarLink.isEmpty) {
            image = [UIImage imageNamed:@"icon_v2_hocphi.png"];
            cell.imvLoaiTaiKhoan.image = image;
        }
        else{
            [cell.imvLoaiTaiKhoan sd_setImageWithURL:[NSURL URLWithString:sAvatarLink] placeholderImage:[UIImage imageNamed:@"icon_v2_hocphi.png"]];
        }
    }
    else if (n == TAI_KHOAN_TIEN_VAY) {
        if (sAvatarLink.isEmpty) {
            image = [UIImage imageNamed:@"icon_v2_tratienvay.png"];
            cell.imvLoaiTaiKhoan.image = image;
        }
        else{
            [cell.imvLoaiTaiKhoan sd_setImageWithURL:[NSURL URLWithString:sAvatarLink] placeholderImage:[UIImage imageNamed:@"icon_v2_tratienvay.png"]];
        }
    }
    else if (n == TAI_KHOAN_NAP_TIEN_TRUYEN_HINH) {
        if (sAvatarLink.isEmpty) {
            image = [UIImage imageNamed:@"icon_v2_truyenhinh.png"];
            cell.imvLoaiTaiKhoan.image = image;
        }
        else{
            [cell.imvLoaiTaiKhoan sd_setImageWithURL:[NSURL URLWithString:sAvatarLink] placeholderImage:[UIImage imageNamed:@"icon_v2_truyenhinh.png"]];
        }
    }
    else if (n == TAI_KHOAN_HOA_DON_MAY_BAY) {
        if (sAvatarLink.isEmpty) {
            image = [UIImage imageNamed:@"icon_v2_vemaybay.png"];
            cell.imvLoaiTaiKhoan.image = image;
        }
        else{
            [cell.imvLoaiTaiKhoan sd_setImageWithURL:[NSURL URLWithString:sAvatarLink] placeholderImage:[UIImage imageNamed:@"icon_v2_vemaybay.png"]];
        }
    }
    else{
        cell.imvLoaiTaiKhoan.image = image;
    }
    cell.delegate = self;
    return cell;
}

- (void)suKienChonCheckThongBao:(UIButton *)sender {
    DucNT_TaiKhoanThuongDungCell *cell = (DucNT_TaiKhoanThuongDungCell *)[[sender superview] superview];
    NSIndexPath *indexPath = [self.lvDanhSachTaiKhoan indexPathForCell:cell];
    NSLog(@"%s - indexPath : %d", __FUNCTION__, (int)indexPath.row);
    DucNT_TaiKhoanThuongDungObject *item = [dsTaiKhoanThuongDung objectAtIndex:indexPath.row];
    if (item.trangThaiThongBaoDinhKy == 0) {
        nDinhDanhKetNoi = KET_NOI_DANG_KY_DINH_KY;
        if (_mViewXacThuc) {
            _mViewXacThuc.lblTitle.text = @"Đăng ký nhận thông báo định kỳ";
        }
    }
    else {
        nDinhDanhKetNoi = KET_NOI_HUY_DINH_KY;
        if (_mViewXacThuc) {
            _mViewXacThuc.lblTitle.text = @"Huỷ nhận thông báo định kỳ";
        }
    }
    nViTriTKCanXoa = (int)indexPath.row;
    [self hienThiViewXacThuc];
}

#pragma mark - UITableViewDelegate

/* Chuyến đến giao diện chuyển tiền lưu obj Tài khoản vào notification bên kia nhận là oke*/
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*chuyển giao diện theo luồng từ  view chuyển tiền -> danh sách thường dùng -> view chuyển tiền 
     * KO EDIT <-> id = @"";
     */
    DucNT_TaiKhoanThuongDungObject *item = [dsTaiKhoanThuongDung objectAtIndex:indexPath.row];
//    item.sId = @"";
    int nType = item.nType;
//    NSLog(@"DanhSachTaiKhoanThuongDung : didSelectRow : nLoaiTaiKhoan : %d", nLoaiTaiKhoan);
//    NSLog(@"DanhSachTaiKhoanThuongDung : didSelectRow : nType : %d", nType);
    if(nLoaiTaiKhoan != TAI_KHOAN_TONG_HOP)
    {
        if (self.bChuyenGiaoDien) {
            [self chuyeGiaoDien:@"NapViTuTheNganHangViewController" withData:item];
        }
        else{
            if(nType == TAI_KHOAN_VI)
                [self chuyenGiaoDienTaiKhoanVi:item];
            else if(nType == TAI_KHOAN_THE)
                [self chuyenGiaoDienTaiKhoanThe:item];
            else if(nType == TAI_KHOAN_NGAN_HANG)
                [self chuyenGiaoDienTaiKhoanNganHang:item];
            else if (nType == TAI_KHOAN_VI_KHAC)
                [self chuyenGiaoDienChuyenTienDenViMomo:item];
            else if (nType == TAI_KHOAN_TAN_NHA)
                [self chuyenGiaoDienChuyenTienDenTanNha:item];
            else if (nType == TAI_KHOAN_DIEN_THOAI)
                [self chuyenGiaoDienDienThoai:item];
            else if (nType == TAI_KHOAN_THE_DIRECT || nType == TAI_KHOAN_VISA || nType == TAI_KHOAN_MASTER_CARD || nType == TAI_KHOAN_JCB)
                [self chuyenGiaoDienNapVi:item];
            else if (nType == TAI_KHOAN_NAP_TIEN_GAME){
                [self chuyenGiaoDienNapTienGame:item];
//                0914825581
            }
            else if (nType == TAI_KHOAN_GUI_TIET_KIEM){
                [self chuyenGiaoDienGuiTietKiem:item];
            }
            else if (nType == TAI_KHOAN_NAP_TIEN_DIEN){
                [self chuyenGiaoDienTienDien:item];
            }
            else if (nType == TAI_KHOAN_CHUYEN_TIEN_ATM) {
                [self chuyenGiaoDienChuyenTienATM:item];
            }
            else if (nType == TAI_KHOAN_CHUYEN_TIEN_CMND) {
                [self chuyenGiaoDienChuyenTienCMND:item];
            }
            else if (nType == TAI_KHOAN_CHUNG_KHOAN) {
                [self chuyenGiaoDienChuyenTienChungKhoan:item];
            }
            else if (nType == TAI_KHOAN_MUON_TIEN) {
                [self chuyeGiaoDien:@"MuonTienViewController" withData:item];
            }
            else if (nType == TAI_KHOAN_QUA_TANG) {
                [self chuyeGiaoDien:@"DanhSachQuaTangViewController" withData:item];
            }
            else if (nType == TAI_KHOAN_NAP_TIEN_TU_THIEN) {
                [self chuyeGiaoDien:@"GiaoDichTienTuThien" withData:item];
            }
            else if (nType == TAI_KHOAN_HOA_DON_NUOC) {
                [self chuyeGiaoDien:@"GiaoDienThanhToanNuoc" withData:item];
            }
            else if (nType == TAI_KHOAN_NAP_TIEN_INTERNET) {
                [self chuyeGiaoDien:@"GiaoDienThanhToanInternet" withData:item];
            }
            else if (nType == TAI_KHOAN_HOC_PHI) {
                [self chuyeGiaoDien:@"GiaoDienThanhToanHocPhi" withData:item];
            }
            else if (nType == TAI_KHOAN_TIEN_VAY) {
                [self chuyeGiaoDien:@"GiaoDienTraCuuTienVay" withData:item];
            }
            else if (nType == TAI_KHOAN_NAP_TIEN_TRUYEN_HINH) {
                [self chuyeGiaoDien:@"GiaoDienTraCuuTruyenHinh" withData:item];
            }
            else if (nType == TAI_KHOAN_HOA_DON_MAY_BAY) {
                [self chuyeGiaoDien:@"GiaoDienDatVeMayBay" withData:item];
            }
        }
    }
    /*chuyển giao diện theo luồng danh sách thường dùng -> view chuyển tiền : KO EDIT*/
    else
    {
        NSLog(@"DanhSachTaiKhoanThuongDung : didSelectRow 2: item.tenThuHuong : %@", item.tenNguoiThuHuong);
        if(nType == TAI_KHOAN_VI)
            [self chuyenGiaoDienChuyenDenVi:item];
        else if(nType == TAI_KHOAN_THE)
            [self chuyenGiaoDienChuyenDenThe:item];
        else if(nType == TAI_KHOAN_NGAN_HANG)
            [self chuyenGiaoDienChuyenDenNganHang:item];
        else if (nType == TAI_KHOAN_VI_KHAC)
            [self chuyenGiaoDienChuyenTienDenViMomo1:item];
        else if (nType == TAI_KHOAN_TAN_NHA){
            NSLog(@"DanhSachTaiKhoanThuongDung : didSelectRow : item.tenThuHuong : %@", item.tenNguoiThuHuong);
            [self chuyenGiaoDienChuyenTienDenTanNha:item];
        }
    }
}

#pragma mark - xử lý chuyển giao diện (kiểu notification)
-(void)chuyenGiaoDienTaiKhoanVi:(DucNT_TaiKhoanThuongDungObject *)data
{
    [self chuyeGiaoDien:@"DucNT_ChuyenTienViDenViViewController" withData:data];
}

-(void)chuyenGiaoDienTaiKhoanThe:(DucNT_TaiKhoanThuongDungObject *)data
{
    [self chuyeGiaoDien:@"DucNT_ChuyenTienDenTheViewController" withData:data];
}

-(void)chuyenGiaoDienTaiKhoanNganHang:(DucNT_TaiKhoanThuongDungObject *)data
{
     [self chuyeGiaoDien:@"DucNT_ChuyenTienDenTaiKhoanViewController" withData:data];
}

- (void)chuyenGiaoDienChuyenTienDenViMomo:(DucNT_TaiKhoanThuongDungObject *)data
{
    [self chuyeGiaoDien:@"ChuyenTienDenViMomoViewController" withData:data];
}

- (void)chuyenGiaoDienChuyenTienDenTanNha:(DucNT_TaiKhoanThuongDungObject *)data
{
    [self chuyeGiaoDien:@"ChuyenTienTanNhaViewController" withData:data];
}

- (void)chuyenGiaoDienDienThoai:(DucNT_TaiKhoanThuongDungObject *)data
{
    NSLog(@"%s - data : %d", __FUNCTION__, data.nhaMang);
    [self chuyeGiaoDien:@"ThanhToanDienThoaiKhacViewController" withData:data];
}

- (void)chuyenGiaoDienNapVi:(DucNT_TaiKhoanThuongDungObject *)data{
    NSLog(@"%s ======> data.sId : %@", __FUNCTION__, data.sId);
    [self chuyeGiaoDien:@"NapViTuTheNganHangViewController" withData:data];
}

- (void)chuyenGiaoDienNapTienGame:(DucNT_TaiKhoanThuongDungObject *)data{
    NSLog(@"%s ======> data.sId : %@", __FUNCTION__, data.sId);
    [self chuyeGiaoDien:@"GiaoDienNapTienDienTu" withData:data];
}

- (void)chuyenGiaoDienGuiTietKiem:(DucNT_TaiKhoanThuongDungObject *)data{
    [self chuyeGiaoDien:@"GuiTietKiemViewController" withData:data];
}

- (void)chuyenGiaoDienTienDien:(DucNT_TaiKhoanThuongDungObject *)data{
    [self chuyeGiaoDien:@"TraCuuTienDienViewController" withData:data];
}

- (void)chuyenGiaoDienChuyenTienATM:(DucNT_TaiKhoanThuongDungObject *)data{
    [self chuyeGiaoDien:@"GiaoDienChuyenTienATM" withData:data];
}

- (void)chuyenGiaoDienChuyenTienCMND:(DucNT_TaiKhoanThuongDungObject *)data{
    [self chuyeGiaoDien:@"GiaoDienChuyenTienDenCMND" withData:data];
}

- (void)chuyenGiaoDienChuyenTienChungKhoan:(DucNT_TaiKhoanThuongDungObject *)data {
    [self chuyeGiaoDien:@"GiaoDienThanhToanChungKhoan" withData:data];
}

-(void) chuyeGiaoDien:(NSString *)sTenClass withData:(DucNT_TaiKhoanThuongDungObject *)data
{
    __block BaseScreen* vc = nil;
    if(sTenClass != nil && sTenClass.length > 0)
    {
        vc = (BaseScreen*)[[NSClassFromString(sTenClass) alloc] init];
    }
    else
    {
        [[[[UIAlertView alloc] initWithTitle:[@"thong_bao" localizableString]  message:[@"Under development" localizableString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
        vc = (BaseScreen*)[[NSClassFromString(@"DucNT_FinanceController") alloc] init];
    }
    [app.navigationController dismissViewControllerAnimated:NO completion:^
     {
         bool bCoGiaoDien = false;
         for (UIViewController *controller in app.navigationController.viewControllers)
         {
             if ([controller isKindOfClass:[vc class]])
             {
                 [vc release]; //Giải phóng viewcontroller trước khi đc gán = ;
                 vc = (BaseScreen *)controller;
                 bCoGiaoDien = true;
                 break;
             }
         }
         NSString *sKey = KEY_TAI_KHOAN_THUONG_DUNG;
         if (data.nType == TAI_KHOAN_JCB || data.nType == TAI_KHOAN_MASTER_CARD || data.nType == TAI_KHOAN_VISA || data.nType == TAI_KHOAN_THE_DIRECT) {
             sKey = KEY_TAI_KHOAN_NAP_TIEN;
         }
         NSLog(@"%s - sKey : %@", __FUNCTION__, sKey);
         if(bCoGiaoDien)
         {
             NSLog(@"%s >> %s line: %d >> starthere %@",__FILE__,__FUNCTION__ ,__LINE__, data);
             [[NSNotificationCenter defaultCenter] postNotificationName:sKey object:data];
             [app.navigationController popToViewController:vc animated:YES];
         }
         else
         {
             NSLog(@"%s >> %s line: %d >> Drawer 2 ",__FILE__,__FUNCTION__ ,__LINE__);
             [app.navigationController pushViewController:vc animated:YES];
             [[NSNotificationCenter defaultCenter] postNotificationName:sKey object:data];
             [vc release];
         }
     }];
}

#pragma mark - xử lý chuyển giao diện kiểu thông thường
-(void)chuyenGiaoDienChuyenDenVi:(DucNT_TaiKhoanThuongDungObject *)item
{

}

-(void)chuyenGiaoDienChuyenDenNganHang:(DucNT_TaiKhoanThuongDungObject *)item
{

}

-(void)chuyenGiaoDienChuyenDenThe:(DucNT_TaiKhoanThuongDungObject *)item
{

}

- (void)chuyenGiaoDienChuyenTienDenViMomo1:(DucNT_TaiKhoanThuongDungObject *)data
{

}

-(void)chuyenGiaoDienTaoTaiKhoanRutTien:(DucNT_TaiKhoanThuongDungObject *)item
{

}

-(void)chuyenGiaoDienTaoTheRutTien:(DucNT_TaiKhoanThuongDungObject *)item
{

}

#pragma mark - xử lý sự kiện chọn delete và edit trên danh sach
-(void)deleteCell:(id)sender
{
    NSLog(@"%s - hien thi view xac thuc", __FUNCTION__);
    nDinhDanhKetNoi = KET_NOI_XOA_TAI_KHOAN;
    NSIndexPath *indepath = [self.lvDanhSachTaiKhoan indexPathForCell:sender];
    nViTriTKCanXoa = (int)indepath.row;
    DucNT_TaiKhoanThuongDungObject *obj = [dsTaiKhoanThuongDung objectAtIndex:nViTriTKCanXoa];
    if (_mViewXacThuc) {
        _mViewXacThuc.lblTitle.text = [NSString stringWithFormat:@"Xoá %@", obj.sAliasName];
    }
    [self hienThiViewXacThuc];
}

-(void)editCell:(id)sender
{
    NSIndexPath *indexPath = [self.lvDanhSachTaiKhoan indexPathForCell:sender];
    DucNT_TaiKhoanThuongDungObject *item = [dsTaiKhoanThuongDung objectAtIndex:indexPath.row];
    NSLog(@"%s - item.nType : %d", __FUNCTION__, item.nType);
    if (item.nType == TAI_KHOAN_THE_DIRECT || item.nType == TAI_KHOAN_VISA || item.nType == TAI_KHOAN_MASTER_CARD || item.nType == TAI_KHOAN_JCB) {
        GiaoDienTaoTheLuu *theLuu = [[GiaoDienTaoTheLuu alloc] initWithNibName:@"GiaoDienTaoTheLuu" bundle:nil];
        theLuu.nTrangThai = 1;
        theLuu.objTheLuu = item;
        UINavigationController *nav = [HiNavigationBar navigationControllerWithRootViewController: theLuu];
        [theLuu release];
        nav.navigationBar.barStyle = UIBarStyleBlackOpaque;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        [self presentViewController:nav animated:YES completion:^{}];
//        [self.navigationController pushViewController:theLuu animated:YES];
//        [theLuu release];
    }
    else{
        ThemTaiKhoanThuongDungViewController *themTaiKhoanThuongDung = [[ThemTaiKhoanThuongDungViewController alloc] initWithNibName:@"ThemTaiKhoanThuongDungViewController" bundle:nil];
        themTaiKhoanThuongDung.modalPresentationStyle = UIModalPresentationFullScreen;
        themTaiKhoanThuongDung.mDelegate = self;
        themTaiKhoanThuongDung.mTaiKhoanThuongDung = item;
        UINavigationController *nav = [HiNavigationBar navigationControllerWithRootViewController: themTaiKhoanThuongDung];
        [themTaiKhoanThuongDung release];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        nav.navigationBar.barStyle = UIBarStyleBlackOpaque;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        [self presentViewController:nav animated:YES completion:^{}];
    }
}

#pragma mark - dealloc
- (void)dealloc {
    if(lbTitle)
        [lbTitle release];
    if(lvDanhSachTaiKhoan)
        [lvDanhSachTaiKhoan release];
    if(dsTaiKhoanThuongDung)
        [dsTaiKhoanThuongDung release];
    if(rootView)
        [rootView release];
    if(btnBack)
        [btnBack release];
    [_topRootView release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setLbTitle:nil];
    [self setLvDanhSachTaiKhoan:nil];
    [self setRootView:nil];
    [self setBtnBack:nil];
    [super viewDidUnload];
}

@end
