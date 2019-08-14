//
//  PKIViewController.m
//  ViViMASS
//
//  Created by Mac Mini on 8/12/18.
//

#import "PKIViewController.h"
#import "ExTextField.h"

@interface PKIViewController ()
- (IBAction)ChangVaue:(id)sender;

@end

@implementation PKIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Chữ ký số PKI";
    // HOANHNV FIX
//    self.edMatkhauPKI.attributedPlaceholder =[[NSAttributedString alloc] initWithString:[@"edMatkhauPKI" localizableString] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
//    self.edOTPXacNhan.attributedPlaceholder =[[NSAttributedString alloc] initWithString:[@"edOTPXacNhan" localizableString] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
//    self.edHanMuc.attributedPlaceholder =[[NSAttributedString alloc] initWithString:[@"edHanMuc" localizableString] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
//    self.edMatKhauHanMuc.attributedPlaceholder =[[NSAttributedString alloc] initWithString:[@"edMatKhauHanMuc" localizableString] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
//    self.edDoiMatKhau1.attributedPlaceholder =[[NSAttributedString alloc] initWithString:[@"edDoiMatKhau1" localizableString] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
//    self.edDoiMatKhau2.attributedPlaceholder =[[NSAttributedString alloc] initWithString:[@"edDoiMatKhau2" localizableString] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
//    self.edDoiMatKhau3.attributedPlaceholder =[[NSAttributedString alloc] initWithString:[@"edDoiMatKhau3" localizableString] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)ChangVaue:(id)sender {
    UISegmentedControl *seg = (UISegmentedControl*)sender;
    if(seg.selectedSegmentIndex == 0){
        // Dang Ky
        self.vHanMuc.hidden = true;
        self.vDangKy.hidden = false;
        self.vMatKhau.hidden = true;
    }
    else if (seg.selectedSegmentIndex == 1){
        // Han Muc
        self.vHanMuc.hidden = false;
        self.vDangKy.hidden = true;
        self.vMatKhau.hidden = true;
    }
    else if (seg.selectedSegmentIndex == 2){
        // Doi mat khau
        self.vHanMuc.hidden = true;
        self.vDangKy.hidden = true;
        self.vMatKhau.hidden = false;
    }
}
- (void)dealloc {
    [_edMatkhauPKI release];
    [_edOTPXacNhan release];
    [_edHanMuc release];
    [_edMatKhauHanMuc release];
    [_edDoiMatKhau1 release];
    [_edDoiMatKhau2 release];
    [_edDoiMatKhau3 release];
    [super dealloc];
}
- (IBAction)sukienDangKy:(id)sender {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
            [self hienThiLoadingChuyenTien];
        }
        self.mDinhDanhKetNoi = @"TRANG_THAI_DANG_KY_KPI";
    NSDictionary *dic = @{@"user" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                          @"valuePKI" : @"strDL"
                          };
    NSLog(@"%s - dict : %@", __FUNCTION__, [dic JSONString]);
    [GiaoDichMang dangkyPKI:[dic JSONString] noiNhanKetQua:self];
}
- (IBAction)sukienXacNhan:(id)sender {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
        [self hienThiLoadingChuyenTien];
    }
    self.mDinhDanhKetNoi = @"TRANG_THAI_XAC_NHANH_DANG_KY_KPI";
    NSDictionary *dic = @{@"user" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                          @"valuePKI" : @"strDL"
                          };
    NSLog(@"%s - dict : %@", __FUNCTION__, [dic JSONString]);
    [GiaoDichMang xacnhanDangKyPKI:[dic JSONString] noiNhanKetQua:self];
}
- (IBAction)sukienHanMuc:(id)sender {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
        [self hienThiLoadingChuyenTien];
    }
    self.mDinhDanhKetNoi = @"TRANG_THAI_HANMUC_DANG_KY_KPI";
    NSDictionary *dic = @{@"user" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                          @"valuePKI" : @"strDL",@"hanMuc":@12
                          };
    NSLog(@"%s - dict : %@", __FUNCTION__, [dic JSONString]);
    [GiaoDichMang caidatHanMucPKI:[dic JSONString] noiNhanKetQua:self];
}
- (IBAction)sukienDoiMatKhau:(id)sender {
    
}
- (void)xuLyKetNoiThanhCong:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua {
    if ([self.mDinhDanhKetNoi isEqualToString:@"TRANG_THAI_XAC_NHANH_DANG_KY_KPI"]) {
    }
    else if ([self.mDinhDanhKetNoi isEqualToString:@"TRANG_THAI_HANMUC_DANG_KY_KPI"]){
        
    }
    else if ([self.mDinhDanhKetNoi isEqualToString:@"TRANG_THAI_DANG_KY_KPI"]){
        
    }
}

- (void)xuLyKetNoiThatBai:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
        [self anLoading];
    }
    [super xuLyKetNoiThatBai:sDinhDanhKetNoi thongBao:sThongBao ketQua:ketQua];
}

@end
