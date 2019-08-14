//
//  DucNT_ChangPrivateInformationViewController.m
//  ViMASS
//
//  Created by MacBookPro on 7/16/14.
//
//

#import "DucNT_ChangPrivateInformationViewController.h"
#import "Common.h"

#import "CropImageHelper.h"
#import "Base64.h"
#import "DucNT_ViewPicker.h"
#import "DucNT_Token.h"
#import "UIImageView+WebCache.h"
#import "DichVuNotification.h"
#import <objc/runtime.h>
#import "BankCoreData.h"
#import "GiaoDienThongTinPhim.h"
#import "CommonUtils.h"
#define KHOANG_CACH_GIUA_2_VIEW 8

@interface DucNT_ChangPrivateInformationViewController ()<UIAlertViewDelegate, UIGestureRecognizerDelegate>
{
    NSTimer *mTimer;
    NSString *mDinhDanhKetNoi;
    int mTypeAuthenticate;
    int nRowBank, nRowChiNhanh;
    BOOL mXacThucVanTay;
    NSArray *arrBank;
    NSMutableArray *arrChiNhanhBank;
    DucNT_TaiKhoanThuongDungObject *bankRutTien;
}
@property (retain, nonatomic) IBOutlet ExTextField *mtfTaiKhoan;
@property (retain, nonatomic) IBOutlet ExTextField *mtfTenGiaoDich;
@property (retain, nonatomic) IBOutlet ExTextField *mtfTenCMND;
@property (retain, nonatomic) IBOutlet UIImageView *mimgvDaiDien;
//@property (retain, nonatomic) DucNT_TaiKhoanViObject *thongTinTaiKhoan;

@property (retain, nonatomic) NSString *mPhoneAuthenticate;
@property (retain, nonatomic) NSString *mEmailAuthenticate;
@property (assign, nonatomic) NSString *mIsToken;

@property (assign, nonatomic) NSInteger mTongSoThoiGian;
@property (assign, nonatomic) BOOL mChayLanDau;

@property (retain, nonatomic) NSString *sLinkIdAnhTruocCMND;
@property (retain, nonatomic) NSString *sLinkIdAnhSauCMND;
@property (retain, nonatomic) NSString *sLinkIdAnhChuKy;
@property (retain, nonatomic) NSString *sLinkIdAnhDaiDien;

@end

@implementation DucNT_ChangPrivateInformationViewController
{
    int nTrangThaiXuLyKetNoi;

    bool bTrangThaiCoAnhMatTruocMoi;
    bool bTrangThaiCoAnhMatSauMoi;
    bool bTrangThaiCoAnhChuKyMoi;
    BOOL bTrangThaiCoAnhDaiDienMoi;
    int nSoAnhDaUp;
    NSMutableArray *dsAnhCanUp;
    NSMutableArray *dsTinhThanh;
    BOOL isLongPress;
}

@synthesize edtNgaySinh;
@synthesize edtThuDienTu;
@synthesize edtSoCMND;
@synthesize edtNgayCapCMND;
@synthesize edtNoiCapCMND;
@synthesize edtDiaChiNha;
@synthesize tvDiaChiNha;
@synthesize edtMatKhauToken;
@synthesize btnChupAnhMatTruocCMND;
@synthesize btnLayAnhMatTruocCMND;
@synthesize btnLayAnhMatSauCMND;
@synthesize btnChupAnhMatSauCMND;
@synthesize btnChupAnhChuKy;
@synthesize btnLayAnhChuKy;
@synthesize btnThucHien;
@synthesize imvMatTruocCMND;
@synthesize imvAnhMatSauCMND;
@synthesize imvAnhChuKy;
@synthesize scrollView;
@synthesize viewMain;
@synthesize mbtnVanTay;

const int DINH_DANH_THONG_BAO_THANH_CONG = 100;

#pragma mark - init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.sLinkIdAnhChuKy = @"";
        self.sLinkIdAnhDaiDien = @"";
        self.sLinkIdAnhSauCMND = @"";
        self.sLinkIdAnhTruocCMND = @"";
    }
    return self;
}


#pragma mark - life circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    mXacThucVanTay = NO;
    nRowChiNhanh = -1;
    nRowBank = -1;

    [self addButtonBack];

    [self addTitleView:[@"financer_viewer_bussiness_update_information" localizableString]];
    bTrangThaiCoAnhMatTruocMoi = false;
    bTrangThaiCoAnhMatSauMoi = false;
    bTrangThaiCoAnhChuKyMoi = false;
    bTrangThaiCoAnhDaiDienMoi = false;

    arrBank = [BankCoreData allBanks];
    [self khoiTaoUipickerView:100 edTemp:_edBank];
    [self khoiTaoUipickerView:101 edTemp:_edChiNhanh];

    [self themButtonHuongDanSuDung:@selector(suKienBamNutHuongDanThayDoi:)];

    isLongPress = NO;
    self.imgvQRCode.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longHander = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleHoldGesture:)];
    longHander.delegate = self;
    longHander.minimumPressDuration = 1;
    [self.imgvQRCode addGestureRecognizer:longHander];
    
    [self khoiTaoView];
    
    self.mbtnToken.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.edtDiaChiNha resignFirstResponder];
    [self.tvDiaChiNha resignFirstResponder];
    
    CGRect rectMain = viewMain.frame;
    [scrollView setContentSize:CGSizeMake(viewMain.frame.size.width, rectMain.origin.y + rectMain.size.height + 20)];
    [self hienThiDuLieu];
    [self khoiTaoViewCalendarNgaySinh];
    [self khoiTaoViewCalenderNgayCap];
    [self khoiTaoViewChonNoiCap];
//    [self khoiTaoGiaoDienChuyenTien];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self ketThucDemThoiGian];
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
        UIImage *img = self.imgvQRCode.image;
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

- (void)suKienBamNutHuongDanThayDoi:(UIButton *)sender {
    GiaoDienThongTinPhim *vc = [[GiaoDienThongTinPhim alloc] initWithNibName:@"GiaoDienThongTinPhim" bundle:nil];
    vc.nOption = HUONG_DAN_THAY_DOI_THONG_TIN_VI;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)khoiTaoUipickerView:(int)tag edTemp:(ExTextField *)edTemp{
    UIButton *btnRight2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 12)];
    [btnRight2 setBackgroundImage:[UIImage imageNamed:@"muiten35x21.png"] forState:UIControlStateNormal];
    edTemp.rightView = btnRight2;
    edTemp.rightViewMode = UITextFieldViewModeAlways;

    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneChonBank:)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelChonBank:)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

    [toolBar setItems:[NSArray arrayWithObjects:cancelButton, flexSpace, doneButton, nil]];
    UIPickerView *pickerChonRap = [[UIPickerView alloc] init];
    pickerChonRap.dataSource = self;
    pickerChonRap.delegate = self;
    pickerChonRap.tag = tag;
    edTemp.inputAccessoryView = toolBar;
    edTemp.inputView = pickerChonRap;
    [pickerChonRap release];

}

- (void)doneChonBank:(UIBarButtonItem *)sender {
    [_edBank resignFirstResponder];
    [_edChiNhanh resignFirstResponder];
}

- (void)cancelChonNhaMay:(UIBarButtonItem *)sender {
    [_edBank resignFirstResponder];
    [_edChiNhanh resignFirstResponder];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 101) {
        return arrChiNhanhBank.count / 2 + 1;
    }
    return arrBank.count + 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 101) {
        if (row == 0) {
            return @"Chọn chi nhánh";
        }
        nRowChiNhanh = (int)row - 1;
        NSString *sTenBank = @"";
        sTenBank = [arrChiNhanhBank objectAtIndex:nRowChiNhanh * 2];
        return sTenBank;
    }
    if (row == 0) {
        return @"Chọn ngân hàng rút tiền";
    }
    NSString *sTenBank = @"";
    Banks *bank = [arrBank objectAtIndex:row - 1];
    sTenBank = bank.bank_name;
    return sTenBank;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 101) {
        if (row == 0) {
            nRowChiNhanh = -1;
            _edChiNhanh.text = @"Chọn chi nhánh";
        }
        else {
            nRowChiNhanh = (int)row - 1;
            NSString *sTenBank = @"";
            sTenBank = [arrChiNhanhBank objectAtIndex:nRowChiNhanh * 2];
            _edChiNhanh.text = sTenBank;
        }
    }
    else {
        if (row == 0) {
            nRowBank = -1;
            _edBank.text = @"Chọn ngân hàng rút tiền";
            self.edChiNhanh.hidden = YES;
            self.lblChiNhanh.hidden = YES;
        }
        else {
            nRowBank = (int)row - 1;
            Banks *bank = [arrBank objectAtIndex:nRowBank];
            _edBank.text = bank.bank_name;
            if([bank.bank_name hasPrefix:@"AGR"]){
                self.lblChiNhanh.hidden = NO;
                self.edChiNhanh.hidden = NO;
            }
            else {
                nRowChiNhanh = -1;
                self.lblChiNhanh.hidden = YES;
                self.edChiNhanh.hidden = YES;
                [self khoiTaoPickerChiNhanhNganHang];
            }
        }
    }
}

#pragma mark - handler error
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Khoi tao

-(void)khoiTaoViewMain
{
    [_mlblTaiKhoan setText:[@"tai_khoan" localizableString]];
    [_mlblSoDienThoaiNhanMaXacThuc setText:[@"so_dien_thoai_nhan_ma_xac_thuc" localizableString]];
    [_mlblThuDienTuNhanMaXacThuc setText:[@"thu_dien_tu_nhan_ma_xac_thuc" localizableString]];
    [_mlblTenHienThi setText:[@"ten_hien_thi" localizableString]];
    [_mlblTenTrongCMND setText:[@"ten_cmnd" localizableString]];
    [_mlblNgaySinh setText:[@"ngay_sinh" localizableString]];
    [_mlblSoCMND setText:[@"so_cmnd" localizableString]];
    [_mlblNgayCap setText:[@"ngay_cap" localizableString]];
    [_mlblNoiCap setText:[@"noi_cap" localizableString]];
    [_mlblNoiThuongTru setText:[@"noi_thuong_tru" localizableString]];

    [_mlblAnhDaiDien setText:[NSString stringWithFormat:@"%@ (%@)", [@"anh_dai_dien" localizableString], [@"co_the_bo_qua" localizableString]]];
    [_mlblAnhMatTruocCMND setText:[NSString stringWithFormat:@"%@ (%@)", [@"anh_mat_truoc_cmnd" localizableString], [@"co_the_bo_qua" localizableString]]];
    [_mlblAnhMatSauCMND setText:[NSString stringWithFormat:@"%@ (%@)", [@"anh_mat_sau_cmnd" localizableString], [@"co_the_bo_qua" localizableString]]];
    [_mlblAnhChuKy setText:[NSString stringWithFormat:@"%@ (%@)", [@"anh_chu_ky" localizableString], [@"co_the_bo_qua" localizableString]]];
    
    self.mtfTaiKhoan.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[@"tai_khoan" localizableString] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    
    self.mtfSoDienThoaiNhanMaXacThuc.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[@"so_dien_thoai_nhan_ma_xac_thuc" localizableString] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    [self.mtfSoDienThoaiNhanMaXacThuc setTextError:[@"so_dien_thoai_nhan_ma_xac_thuc_khong_duoc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    [self.mtfSoDienThoaiNhanMaXacThuc setTextError:[@"reg - phone is invalid" localizableString] forType:ExTextFieldTypePhone];
    
    self.mtfTenGiaoDich.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[@"co_the_bo_qua_ten_giao_dich" localizableString] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    [self.mtfTenGiaoDich.inputAccessoryView setHidden:YES];
    
    self.mtfTenCMND.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[@"co_the_bo_qua_ten_CMND" localizableString] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    
    [edtThuDienTu setTextError:[@"thu_dien_tu_khong_duoc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    [edtThuDienTu setType:ExTextFieldTypeMail];
    [edtThuDienTu.inputAccessoryView setHidden:YES];
    
    edtMatKhauToken.max_length = 6;
    [edtMatKhauToken.inputAccessoryView setHidden:YES];
    edtMatKhauToken.placeholder = [@"mat_khau_token" localizableString];
    [edtMatKhauToken setTextError:[@"mat_khau_token_khong_dc_de_trong" localizableString]
                          forType:ExTextFieldTypeEmpty];
    
    edtNgaySinh.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[@"co_the_bo_qua_ngay_sinh" localizableString] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    [edtNgaySinh.inputAccessoryView setHidden:YES];
    
    edtThuDienTu.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[@"thu_dien_tu" localizableString] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    [edtThuDienTu.inputAccessoryView setHidden:YES];
    
    edtSoCMND.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[@"co_the_bo_qua_CMND" localizableString] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    [edtSoCMND.inputAccessoryView setHidden:YES];
    
    edtNgayCapCMND.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[@"co_the_bo_qua_ngay_cap" localizableString] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    [edtNgayCapCMND.inputAccessoryView setHidden:YES];
    
    edtNoiCapCMND.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[@"co_the_bo_qua_noi_cap" localizableString] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    [edtNoiCapCMND.inputAccessoryView setHidden:YES];
    
    edtDiaChiNha.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[@"co_the_bo_qua_noi_thuong_tru" localizableString] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    [edtDiaChiNha.inputAccessoryView setHidden:YES];
    
    self.mtfTenGiaoDich.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[@"ten_hien_thi" localizableString] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    [self.mtfTenGiaoDich.inputAccessoryView setHidden:YES];
    
    // HOANHNV FIX
    self.edtVilienket1.attributedPlaceholder =[[NSAttributedString alloc] initWithString:[@"co_the_bo_qua_vi_lien_ket_1" localizableString] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.edtVilienket2.attributedPlaceholder =[[NSAttributedString alloc] initWithString:[@"co_the_bo_qua_vi_lien_ket_2" localizableString] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.edtVilienket3.attributedPlaceholder =[[NSAttributedString alloc] initWithString:[@"co_the_bo_qua_vi_lien_ket_3" localizableString] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.edtVilienket4.attributedPlaceholder =[[NSAttributedString alloc] initWithString:[@"co_the_bo_qua_vi_lien_ket_4" localizableString] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.edtVilienket5.attributedPlaceholder =[[NSAttributedString alloc] initWithString:[@"co_the_bo_qua_vi_lien_ket_5" localizableString] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    //END
    [btnThucHien setTitle:[@"thuc_hien" localizableString] forState:UIControlStateNormal];
    [btnChupAnhMatTruocCMND setTitle:[@"chup_anh" localizableString] forState:UIControlStateNormal];
    [btnChupAnhMatSauCMND setTitle:[@"chup_anh" localizableString] forState:UIControlStateNormal];
    [btnChupAnhChuKy setTitle:[@"chup_anh" localizableString] forState:UIControlStateNormal];
    [btnLayAnhMatTruocCMND setTitle:[@"lay_anh" localizableString] forState:UIControlStateNormal];
    [btnLayAnhMatSauCMND setTitle:[@"lay_anh" localizableString] forState:UIControlStateNormal];
    [btnLayAnhChuKy setTitle:[@"lay_anh" localizableString] forState:UIControlStateNormal];
    [self.mbtnChupAnhDaiDien setTitle:[@"chup_anh" localizableString] forState:UIControlStateNormal];
    [self.mbtnLayAnhDaiDien setTitle:[@"lay_anh" localizableString] forState:UIControlStateNormal];
    
    
}

//- (void)khoiTaoGiaoDienChuyenTien
//{
//    //Kiem tra co 1 trong 3 loai xac thuc token, sms, email
//    //Xac thuc = dien thoai
//    self.mPhoneAuthenticate = [DucNT_LuuRMS layThongTinDangNhap:KEY_PHONE_AUTHENTICATE];
//    //Xac thuc = token
//    self.mIsToken = [[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_TRANG_THAI_CO_TOKEN] intValue];
//    //Xac thuc = email
//    self.mEmailAuthenticate = [DucNT_LuuRMS layThongTinDangNhap:KEY_EMAIL_AUTHENTICATE];
//
//    [self.mbtnXacThucBoiToken setTitle:@"TOKEN" forState:UIControlStateNormal];
//    [self.mbtnXacThucBoiToken setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
//    [self.mbtnXacThucBoiSMS setTitle:@"SMS" forState:UIControlStateNormal];
//    [self.mbtnXacThucBoiSMS setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
//    [self.mbtnXacThucBoiEmail setTitle:@"EMAIL" forState:UIControlStateNormal];
//    [self.mbtnXacThucBoiEmail setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
//
//    self.mbtnXacThucBoiSMS.selected = NO;
//    self.mbtnXacThucBoiToken.selected = NO;
//    self.mbtnXacThucBoiEmail.selected = NO;
//
//    if(_mIsToken > 0)
//    {
//        [self suKienBamNutToken:self.mbtnXacThucBoiToken];
//    }
//}

- (void)hideViewNhapToken {
    
}

-(void)khoiTaoView
{
    [self khoiTaoViewMain];
}
#pragma mark - khởi tạo dữ liệu đổ vào
-(void)hienThiDuLieu
{
    [CommonUtils displayImage:[NSURL URLWithString:self.mThongTinTaiKhoanVi.linkQR] toImageView:self.imgvQRCode placeHolder:[UIImage imageNamed:@"icon_danhba"]];
    int nHienThiQR = [self.mThongTinTaiKhoanVi.hienThiNoiDungThanhToanQR intValue];
    NSLog(@"%s - nHienThiQR : %d", __FUNCTION__, nHienThiQR);
    if (nHienThiQR == 0) {
        [self.checkNoiDungQR setOn:NO];
    }
    else {
        [self.checkNoiDungQR setOn:YES];
    }
    self.mTongSoThoiGian = 0;
    
    self.sLinkIdAnhTruocCMND = @"";
    self.sLinkIdAnhSauCMND = @"";
    self.sLinkIdAnhChuKy = @"";
    self.sLinkIdAnhDaiDien = @"";
    
    if(dsAnhCanUp == nil)
        dsAnhCanUp = [[NSMutableArray alloc] init];
    else
        [dsAnhCanUp removeAllObjects];
    
    NSString *sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    self.mtfTaiKhoan.text = sTaiKhoan;
    self.mtfTaiKhoan.userInteractionEnabled = NO;
    
    
    //Kiem tra fb va gg thi ko cho doi anh dai dien
    if([Common kiemTraLaSoDienThoai:sTaiKhoan])
    {
        [self.mtfSoDienThoaiNhanMaXacThuc setText:sTaiKhoan];
        self.mtfSoDienThoaiNhanMaXacThuc.userInteractionEnabled = NO;
        
    }
    else
    {
        self.mtfSoDienThoaiNhanMaXacThuc.text = self.mThongTinTaiKhoanVi.sPhoneAuthenticate;
        [edtThuDienTu setUserInteractionEnabled:NO];
        [self.mtfTenGiaoDich setUserInteractionEnabled:NO];
        [self.mbtnChupAnhDaiDien setUserInteractionEnabled:NO];
        [self.mbtnLayAnhDaiDien setUserInteractionEnabled:NO];
    }
    
    self.mtfTenGiaoDich.text = self.mThongTinTaiKhoanVi.sNameAlias;
    self.mtfTenCMND.text = self.mThongTinTaiKhoanVi.sTenCMND;

    edtThuDienTu.text = self.mThongTinTaiKhoanVi.sThuDienTu;
    edtNgaySinh.text = [self doiDinhDangNgayThangDuLieuNhanDuoc:self.mThongTinTaiKhoanVi.sNgaySinh];
    edtSoCMND.text = self.mThongTinTaiKhoanVi.sCMND;
    edtNgayCapCMND.text = [self doiDinhDangNgayThangDuLieuNhanDuoc:self.mThongTinTaiKhoanVi.sNgayCapCMND];
    edtNoiCapCMND.text = self.mThongTinTaiKhoanVi.sNoiCapCMND;
    if(self.mThongTinTaiKhoanVi.sDiaChiNha.length > 0)
        tvDiaChiNha.text = self.mThongTinTaiKhoanVi.sDiaChiNha;
    self.sLinkIdAnhTruocCMND = self.mThongTinTaiKhoanVi.sLinkAnhTruocCMND;
    self.sLinkIdAnhSauCMND = self.mThongTinTaiKhoanVi.sLinkAnhSauCMND;
    self.sLinkIdAnhChuKy = self.mThongTinTaiKhoanVi.sLinkAnhChuKy;
    self.sLinkIdAnhDaiDien = self.mThongTinTaiKhoanVi.sLinkAnhDaiDien;
    NSArray *arrVi = [self.mThongTinTaiKhoanVi.sdsTKNhanThongBaoBienDongSoDu componentsSeparatedByString:@","];
    if ([arrVi count] >0 && [CommonUtils isEmptyOrNull:self.mThongTinTaiKhoanVi.sdsTKNhanThongBaoBienDongSoDu]) {
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
//    NSLog(@"%s - tkRutTien : %@", __FUNCTION__, self.mThongTinTaiKhoanVi.tKRutTien);
    if (![self.mThongTinTaiKhoanVi.tKRutTien isEmpty]) {
        bankRutTien = [[DucNT_TaiKhoanThuongDungObject alloc] init];
        NSDictionary *dicTemp = [self.mThongTinTaiKhoanVi.tKRutTien objectFromJSONString];
        bankRutTien.sId = [dicTemp objectForKey:@"id"];
        bankRutTien.sPhoneOwner = [dicTemp objectForKey:@"phoneOwner"];
        bankRutTien.nType = [[dicTemp objectForKey:@"type"] intValue];
        bankRutTien.sAliasName = [Common URLDecode:[dicTemp objectForKey:@"aliasName"]];
        bankRutTien.nAmount = [[dicTemp objectForKey:@"amount"] doubleValue];
        bankRutTien.sDesc = [Common URLDecode:[dicTemp objectForKey:@"desc"]];
        bankRutTien.sToAccWallet = [dicTemp objectForKey:@"toAccWallet"];
        bankRutTien.sAccOwnerName = [dicTemp objectForKey:@"AccOwnerName"];
        bankRutTien.sBankName = [Common URLDecode:[dicTemp objectForKey:@"bankName"]];
        bankRutTien.sBankNumber = [dicTemp objectForKey:@"BankNumber"];
        bankRutTien.sProvinceName = [Common URLDecode:[dicTemp objectForKey:@"provinceName"]];
        bankRutTien.nProvinceCode = [[dicTemp objectForKey:@"provinceCode"] intValue];
        bankRutTien.nProvinceID = [[dicTemp objectForKey:@"provinceId"]intValue];
        bankRutTien.nBankCode = [[dicTemp objectForKey:@"bankCode"] intValue];
        bankRutTien.nBankId = [[dicTemp objectForKey:@"bankId"] intValue];
        bankRutTien.nBranchId = [[dicTemp objectForKey:@"branchId"] intValue];
        bankRutTien.sBranchName = [Common URLDecode:[dicTemp objectForKey:@"branchName"]];
        bankRutTien.sBranchCode = [dicTemp objectForKey:@"branchCode"];
//        bankRutTien.nCardId = [[dicTemp objectForKey:@"cardId"] intValue];
        bankRutTien.nDateExp = [[dicTemp objectForKey:@"dateExp"] longLongValue];
        bankRutTien.nDateReg = [[dicTemp objectForKey:@"dateReg"] longLongValue];
        bankRutTien.sCardNumber = [dicTemp objectForKey:@"cardNumber"];
        bankRutTien.sCardOwnerName = [dicTemp objectForKey:@"cardOwnerName"];
        bankRutTien.sCardTypeName = [dicTemp objectForKey:@"cardTypeName"];
        for (Banks *temp in arrBank) {
            if ([temp.bank_id intValue] == bankRutTien.nBankId) {
                self.edBank.text = temp.bank_name;
                break;
            }
        }
        self.edChuTaiKhoan.text = self.mThongTinTaiKhoanVi.sTenCMND;
        self.edSoTaiKhoanBank.text = bankRutTien.sBankNumber;
        if([bankRutTien.sBankName hasPrefix:@"AGR"]){
            self.lblChiNhanh.hidden = NO;
            self.edChiNhanh.hidden = NO;
        }
        else {
            self.lblChiNhanh.hidden = YES;
            self.edChiNhanh.hidden = YES;
            [self khoiTaoPickerChiNhanhNganHang];
            self.edChiNhanh.text = bankRutTien.sBranchName;
        }
        int nDem = 0;
        for (Banks *temp in arrBank) {
            NSLog(@"%s - bank_id : %d", __FUNCTION__, [temp.bank_id intValue]);
            if ([temp.bank_id intValue] == bankRutTien.nBankId) {
                UIPickerView *picker = (UIPickerView *)_edBank.inputView;
                [picker selectRow:nDem inComponent:0 animated:YES];
                break;
            }
            nDem ++;
        }
    }
    else {
        self.lblChiNhanh.hidden = YES;
        self.edChiNhanh.hidden = YES;
        [self khoiTaoPickerChiNhanhNganHang];
    }
    [self hienThiHinhAnhTuServer];
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
-(NSString *)doiDinhDangNgayThangDuLieuNhanDuoc:(NSString *)sDuLieuTuServer
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [df dateFromString:sDuLieuTuServer];
    [df setDateFormat:@"dd/MM/yyyy"];
    NSString *sKQ = [df stringFromDate:date];
    if(sKQ != nil && sKQ.length > 0)
        return sKQ;
    return @"";
}

-(NSString *)doiDinhDangNgayThangDuLieuUpLen:(NSString *)sDuLieuTuTextField
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy"];
    NSDate *date = [df dateFromString:sDuLieuTuTextField];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *sKQ = [df stringFromDate:date];
    if(sKQ != nil && sKQ.length > 0)
        return  sKQ;
    return @"";
}

#pragma mark - xuLySuKienVanTay

- (void)xuLyKhiKhongCoChucNangQuetVanTay
{
    [mbtnVanTay setHidden:YES];
}

- (void)xuLyKhiCoChucNangQuetVanTay
{
    [mbtnVanTay setHidden:NO];
}

- (void)xuLySuKienDangNhapVanTay
{
    [self xuLySuKienHienThiChucNangVanTayVoiTieuDe:[@"su_dung_van_tay_dang_nhap_tai_khoan_token_VIMASS" localizableString]];
}

- (void)xuLySuKienXacThucVanTayThanhCong
{
    if([edtThuDienTu validate])
    {
        mTypeAuthenticate = TYPE_AUTHENTICATE_TOKEN;
        mXacThucVanTay = YES;
        nSoAnhDaUp = 0;
        if (bTrangThaiCoAnhDaiDienMoi) {
            NSLog(@"%s ++++++++++> bTrangThaiCoAnhDaiDienMoi = YES", __FUNCTION__);
        }
        [self khoiTaoDanhSachAnhUpLoad];
        NSLog(@"%s - dsAnhCanUp.length : %ld", __FUNCTION__, (unsigned long)dsAnhCanUp.count);
        if(dsAnhCanUp != nil && dsAnhCanUp.count > 0)
            [self uploadAnh:[dsAnhCanUp objectAtIndex:nSoAnhDaUp]];
        else
        {
            [self capNhatThongTin];
        }
    }
    else
        [edtThuDienTu show_error];
}

- (void)hienThiThongBaoDienMatKhau
{
    [UIAlertView alert:[@"thong_bao_xac_thuc_van_tay_khong_dung" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
    [mbtnVanTay setHidden:YES];
}

#pragma mark - su kien action

- (void)didSelectBackButton
{
    [self ketThucDemThoiGian];
    [super didSelectBackButton];
    
}

- (IBAction)suKienBamNutXacThucVanTay:(UIButton *)sender
{
    [self xuLySuKienDangNhapVanTay];
}

- (IBAction)suKienChupAnhMatTruocCMND:(id)sender
{
    __block typeof (self) weak = self;
    [self capture:UIImagePickerControllerSourceTypeCamera withImageView:imvMatTruocCMND completed:^(BOOL change) {
        weak->bTrangThaiCoAnhMatTruocMoi = change;
    }];
}

- (IBAction)suKienLayAnhMatTruocCMND:(id)sender
{
    __block typeof (self) weak = self;
    [self capture:UIImagePickerControllerSourceTypePhotoLibrary withImageView:imvMatTruocCMND completed:^(BOOL change) {
        weak->bTrangThaiCoAnhMatTruocMoi = change;
    }];
}

- (IBAction)suKienChupAnhMatSauCMND:(id)sender {
    __block typeof (self) weak = self;
    [self capture:UIImagePickerControllerSourceTypeCamera withImageView:imvAnhMatSauCMND completed:^(BOOL change) {
        weak->bTrangThaiCoAnhMatSauMoi = change;
    }];
}

- (IBAction)suKienLayAnhMatSauCMND:(id)sender {
    __block typeof (self) weak = self;
    [self capture:UIImagePickerControllerSourceTypePhotoLibrary withImageView:imvAnhMatSauCMND completed:^(BOOL change) {
        weak->bTrangThaiCoAnhMatSauMoi = change;
    }];
    
}

- (IBAction)suKienChupAnhChuKy:(id)sender {
    __block typeof (self) weak = self;
    [self capture:UIImagePickerControllerSourceTypeCamera withImageView:imvAnhChuKy completed:^(BOOL change) {
        weak->bTrangThaiCoAnhChuKyMoi = change;
    }];
}

- (IBAction)suKienLayAnhChuKy:(id)sender {
    __block typeof (self) weak = self;
    [self capture:UIImagePickerControllerSourceTypePhotoLibrary withImageView:imvAnhChuKy completed:^(BOOL change) {
        weak->bTrangThaiCoAnhChuKyMoi = change;
    }];
}

- (IBAction)suKienThucHien:(id)sender
{
    if([self validate])
    {
        nSoAnhDaUp = 0;
        [self khoiTaoDanhSachAnhUpLoad];
        if(dsAnhCanUp != nil && dsAnhCanUp.count > 0)
            [self uploadAnh:[dsAnhCanUp objectAtIndex:nSoAnhDaUp]];
        else
        {
            [self capNhatThongTin];
        }
    }
}

- (IBAction)suKienThayDoiTenCMND:(id)sender {
    self.edChuTaiKhoan.text = self.mtfTenCMND.text;
}

- (IBAction)suKienOnOffNoiDungQR:(id)sender {
}
- (IBAction)suKienChupAnhDaiDien:(id)sender
{
    __block typeof (self) weak = self;
    [self capture:UIImagePickerControllerSourceTypeCamera withImageView:self.mimgvDaiDien completed:^(BOOL change) {
        weak->bTrangThaiCoAnhDaiDienMoi = change;
    }];
}

- (IBAction)suKienLayAnhDaiDien:(id)sender {
    NSLog(@"%s - suKienLayAnhDaiDien =======> START", __FUNCTION__);
    __block typeof (self) weak = self;
    [self capture:UIImagePickerControllerSourceTypePhotoLibrary withImageView:self.mimgvDaiDien completed:^(BOOL change) {
        NSLog(@"%s - lay anh dai dien change : %d", __FUNCTION__, change);
        weak->bTrangThaiCoAnhDaiDienMoi = change;
        if (weak->bTrangThaiCoAnhDaiDienMoi) {
            NSLog(@"%s ======== bTrangThaiCoAnhDaiDienMoi == YES", __FUNCTION__);
        }
    }];
}

//- (IBAction)suKienBamNutToken:(UIButton *)sender
//{
//    [super suKienBamNutToken:sender];
//        if(!self.mbtnXacThucBoiToken.selected)
//        {
//            mTypeAuthenticate = TYPE_AUTHENTICATE_TOKEN;
//            [self.mbtnXacThucBoiToken setSelected:YES];
//            [self.mbtnXacThucBoiToken setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//            
//            if(self.mbtnXacThucBoiSMS.enabled)
//            {
//                [self.mbtnXacThucBoiSMS setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
//                [self.mbtnXacThucBoiSMS setTitleColor:nil forState:UIControlStateNormal];
//                [self.mbtnXacThucBoiSMS setSelected:NO];
//            }
//            
//            if(self.mbtnXacThucBoiEmail.enabled)
//            {
//                [self.mbtnXacThucBoiEmail setSelected:NO];
//                [self.mbtnXacThucBoiEmail setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
//                [self.mbtnXacThucBoiEmail setTitleColor:nil forState:UIControlStateNormal];
//            }
//            
//            edtMatKhauToken.placeholder = [@"mat_khau_token" localizableString];
//            [edtMatKhauToken setTextError:[@"@mat_khau_token_khong_dc_de_trong" localizableString]
//                                  forType:ExTextFieldTypeEmpty];
//        }
//}

- (IBAction)suKienBamNutSMS:(UIButton *)sender
{
    if([self validateKhongToken])
    {
        if(!self.mbtnXacThucBoiSMS.selected)
        {
            [self hienThiHopThoaiHaiNutBamKieu:HOP_THOAI_XAC_NHAN_XAC_THUC_SMS cauThongBao:[NSString stringWithFormat:@"%@ %@", [@"thong_bao_ma_xac_thuc_duoc_gui_ve_so_dien_thoai" localizableString], self.mPhoneAuthenticate]];
        }
    }
}

- (IBAction)suKienBamNutEmail:(UIButton *)sender
{
    if([self validateKhongToken])
    {
        if(!self.mbtnXacThucBoiEmail.selected)
        {
            [self hienThiHopThoaiHaiNutBamKieu:HOP_THOAI_XAC_NHAN_XAC_THUC_EMAIL cauThongBao:[NSString stringWithFormat:@"%@ %@", [@"thong_bao_ma_xac_thuc_duoc_gui_ve_thu_dien_tu" localizableString], self.mEmailAuthenticate]];
        }
    }
}

#pragma mark - UIAlertViewDelegate

- (void)hienThiHopThoaiHaiNutBamKieu:(int)nKieu cauThongBao:(NSString*)sCauThongBao
{
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:[@"thong_bao" localizableString] message:sCauThongBao delegate:self cancelButtonTitle:[@"huy" localizableString] otherButtonTitles:[@"dong_y" localizableString], nil] autorelease];
    alertView.tag = nKieu;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        if(alertView.tag == HOP_THOAI_XAC_NHAN_XAC_THUC_SMS)
        {
            [self xuLySuKienXacThucBangSMS];
        }
        else if(alertView.tag == HOP_THOAI_XAC_NHAN_XAC_THUC_EMAIL)
        {
            [self xuLySuKienXacThucBangEmail];
        }
        
    }
    else if(buttonIndex == 0)
    {
        if(alertView.tag == HOP_THOAI_XAC_NHAN_CHUYEN_TIEN_THANH_CONG)
            [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - xuLySuKienChonXacThuc

- (void)xuLySuKienXacThucBangEmail
{
    if(!self.mbtnXacThucBoiEmail.selected)
    {
        mTypeAuthenticate = TYPE_AUTHENTICATE_EMAIL;
        [self.mbtnXacThucBoiEmail setSelected:YES];
        [self.mbtnXacThucBoiEmail setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        self.mTongSoThoiGian = THOI_GIAN_CHO_XAC_THUC_EMAIL;
        [self.mbtnXacThucBoiEmail setTitle:[NSString stringWithFormat:@"%ld s", (long)self.mTongSoThoiGian] forState:UIControlStateNormal];
        [self.mbtnVanTay setHidden:YES];
        
        if(self.mbtnXacThucBoiToken.enabled)
        {
            [self.mbtnXacThucBoiToken setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
            [self.mbtnXacThucBoiToken setTitleColor:nil forState:UIControlStateNormal];
            [self.mbtnXacThucBoiToken setSelected:NO];
            [self.mbtnXacThucBoiToken setEnabled:NO];
        }
        
        if(self.mbtnXacThucBoiSMS.enabled)
        {
            [self.mbtnXacThucBoiSMS setSelected:NO];
            [self.mbtnXacThucBoiSMS setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
            [self.mbtnXacThucBoiSMS setTitleColor:nil forState:UIControlStateNormal];
            [self.mbtnXacThucBoiSMS setEnabled:NO];
        }
        
        edtMatKhauToken.placeholder = [@"ma_xac_thuc" localizableString];
        [edtMatKhauToken setTextError:[@"ma_xac_thuc_khong_duoc_de_trong" localizableString]
                              forType:ExTextFieldTypeEmpty];
        
        [self xuLyKetNoiLayMaXacThucChuyenDenTaiKhoan:self.mEmailAuthenticate];
        
    }
    
}

- (void)xuLySuKienXacThucBangSMS
{
    if(!self.mbtnXacThucBoiSMS.selected)
    {
        mTypeAuthenticate = TYPE_AUTHENTICATE_SMS;
        [self.mbtnXacThucBoiSMS setSelected:YES];
        [self.mbtnXacThucBoiSMS setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        self.mTongSoThoiGian = THOI_GIAN_CHO_XAC_THUC_SMS;
        [self.mbtnXacThucBoiSMS setTitle:[NSString stringWithFormat:@"%ld s", (long)self.mTongSoThoiGian] forState:UIControlStateNormal];
        
        [self.mbtnVanTay setHidden:YES];
        
        if(self.mbtnXacThucBoiToken.enabled)
        {
            [self.mbtnXacThucBoiToken setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
            [self.mbtnXacThucBoiToken setTitleColor:nil forState:UIControlStateNormal];
            [self.mbtnXacThucBoiToken setSelected:NO];
            [self.mbtnXacThucBoiToken setEnabled:NO];
        }
        
        if(self.mbtnXacThucBoiEmail.enabled)
        {
            [self.mbtnXacThucBoiEmail setSelected:NO];
            [self.mbtnXacThucBoiEmail setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
            [self.mbtnXacThucBoiEmail setTitleColor:nil forState:UIControlStateNormal];
            [self.mbtnXacThucBoiEmail setEnabled:NO];
        }
        
        edtMatKhauToken.placeholder = [@"ma_xac_thuc" localizableString];
        [edtMatKhauToken setTextError:[@"ma_xac_thuc_khong_duoc_de_trong" localizableString]
                              forType:ExTextFieldTypeEmpty];
        
        [self xuLyKetNoiLayMaXacThucChuyenDenTaiKhoan:self.mPhoneAuthenticate];
    }
}

- (void)xuLyKetNoiLayMaXacThucChuyenDenTaiKhoan:(NSString*)sSendTo
{
    NSString *sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    int typeAuthenticate = 1;
    if([Common kiemTraLaMail:sSendTo])
        typeAuthenticate = 2;
    
    NSMutableString *sUrl = [[NSMutableString alloc] init];
    [sUrl appendFormat:@"https://vimass.vn/vmbank/services/account/getOTP?"];
    [sUrl appendFormat:@"id=%@&", sTaiKhoan];
    [sUrl appendFormat:@"appId=%d&", APP_ID];
    [sUrl appendFormat:@"funcId=%d&", FUNC_ID_THAY_DOI_THONG_TIN_TAI_KHOAN];
    [sUrl appendFormat:@"typeAuthenticate=%d&", typeAuthenticate];
    [sUrl appendFormat:@"sendTo=%@", sSendTo];
    
    //    mDinhDanhKetNoi = DINH_DANH_KET_NOI_LAY_MA_XAC_THUC;
    nTrangThaiXuLyKetNoi = TRANG_THAI_KET_NOI_LAY_MA_XAC_THUC;
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:self];
    [connect connectGet:sUrl withContent:@""];
    [connect release];
    [sUrl release];
}

#pragma mark - cac ham khoi tao

- (BOOL)kiemTraDaNhapSoDienThoaiNhanMa
{
    BOOL flg = YES;
    ExTextField *first = nil;
    NSArray *tfs = @[self.mtfSoDienThoaiNhanMaXacThuc];
    for (ExTextField *tf in tfs)
    {
        flg = [tf validate] && flg;
        if (flg == NO && first == nil)
            first = tf;
    }
    if (first)
    {
        [first show_error];
        [first becomeFirstResponder];
    }
    return flg;
}

-(BOOL)validateKhongToken
{
    //    NSArray *tfs = @[edtTenTaiKhoan, edtThuDienTu, edtTaiKhoanNganHang, edtSoCMND, edtDiaChiNha, edtMatKhauToken];
    NSArray *tfs = @[ edtThuDienTu, self.mtfSoDienThoaiNhanMaXacThuc];
    ExTextField *first = nil;
    BOOL flg = YES;
    for (ExTextField *tf in tfs)
    {
        flg = [tf validate] && flg;
        if (flg == NO && first == nil)
            first = tf;
    }
    if (first)
    {
        [first show_error];
        [first becomeFirstResponder];
    }
    return flg;
}


-(BOOL)validate
{
    //    NSArray *tfs = @[edtTenTaiKhoan, edtThuDienTu, edtTaiKhoanNganHang, edtSoCMND, edtDiaChiNha, edtMatKhauToken];
    NSArray *tfs = @[ edtThuDienTu, edtMatKhauToken];
    ExTextField *first = nil;
    BOOL flg = YES;
    for (ExTextField *tf in tfs)
    {
        flg = [tf validate] && flg;
        if (flg == NO && first == nil)
            first = tf;
    }
    if (first)
    {
        [first show_error];
        [first becomeFirstResponder];
    }
    // Validate for Vi lien ket
//    NSString *strInput = self.edtVilienket.text;
//        if (strInput == nil || strInput == [NSNull class]
//            || [strInput isEqualToString:@""]
//            || [strInput isEqualToString:@"(null)"]) {
//            flg = YES;
//        }
//        else{
//            NSArray *arrVi = [strInput componentsSeparatedByString:@","];
//            for (NSString *str in arrVi) {
//                if (str) {
//                    NSPredicate *pinTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", kPATTERN_PHONE];
//
//                    BOOL pinValidates = [pinTest evaluateWithObject:str];
//                    if(pinValidates == false){
//                        flg = NO;
//                        self.edtVilienket.textError = @"Số ví không hợp lệ";
//                        [self.edtVilienket show_error];
//                        return flg;
//                    }
//                }
//            }
//        }
    return flg;
}

-(void)khoiTaoViewCalendarNgaySinh
{
    //    if(!vDatePickerNgaySinh)
    //    {
    DucNT_ViewDatePicker *vDatePickerNgaySinh = [[DucNT_ViewDatePicker alloc] initWithNib];
    //    }
    
    __block DucNT_ChangPrivateInformationViewController *blockSELF = self;
    [vDatePickerNgaySinh truyenThongSoThoiGian:^(NSString *sThoiGian) {
        [blockSELF->edtNgaySinh resignFirstResponder];
        if(sThoiGian != nil && sThoiGian.length > 0)
        {
            blockSELF->edtNgaySinh.text = sThoiGian;
            //            [edtTaiKhoanNganHang becomeFirstResponder];
        }
    }];
    edtNgaySinh.inputView = vDatePickerNgaySinh;
    [vDatePickerNgaySinh release];
}

-(void)khoiTaoViewCalenderNgayCap
{
    //    if(!vDatePickerNgayCap)
    //    {
    DucNT_ViewDatePicker *vDatePickerNgayCap = [[DucNT_ViewDatePicker alloc] initWithNib];
    //    }
    __block DucNT_ChangPrivateInformationViewController *blockSELF = self;
    [vDatePickerNgayCap truyenThongSoThoiGian:^(NSString *sThoiGian) {
        [blockSELF->edtNgayCapCMND resignFirstResponder];
        if(sThoiGian != nil && sThoiGian.length > 0)
        {
            blockSELF->edtNgayCapCMND.text = sThoiGian;
            [blockSELF->edtNoiCapCMND becomeFirstResponder];
        }
    }];
    edtNgayCapCMND.inputView = vDatePickerNgayCap;
    [vDatePickerNgayCap release];
}

-(void)khoiTaoViewChonNoiCap
{
    if(dsTinhThanh == nil)
        dsTinhThanh = [[NSMutableArray alloc] init];
    NSArray *dsTemp = [Common job_work_locations];
    for(NSDictionary *dic in dsTemp)
    {
        [dsTinhThanh addObject:[dic objectForKey:@"title"]];
    }
    __block DucNT_ChangPrivateInformationViewController *blockSELF = self;
    DucNT_ViewPicker *viewPicker = [[DucNT_ViewPicker alloc] initWithNib];
    [viewPicker khoiTaoDuLieu:dsTinhThanh];
    [viewPicker capNhatKetQuaLuaChon:^(int nGiaTri) {
        [blockSELF->edtNoiCapCMND resignFirstResponder];
        if(nGiaTri != -1)
        {
            blockSELF->edtNoiCapCMND.text = [blockSELF->dsTinhThanh objectAtIndex:nGiaTri];
            [blockSELF->edtDiaChiNha becomeFirstResponder];
        }
    }];
    edtNoiCapCMND.inputView = viewPicker;
    [viewPicker release];
}

#pragma mark - lay anh va chup anh
// tạo thêm 1 cái block trả về giá trị void với tham số là biến bool trả ra giá trị bên ngoài dùng
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

-(void)hienThiHinhAnhTuServer
{
    if(_sLinkIdAnhTruocCMND != nil && _sLinkIdAnhTruocCMND.length > 0)
    {
//        imvMatTruocCMND.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://203.162.235.66:8080/vmbank/services/media/getImage?id=%@", _sLinkIdAnhTruocCMND]]]];
        [imvMatTruocCMND setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://vimass.vn/vmbank/services/media/getImage?id=%@", _sLinkIdAnhTruocCMND]]];
    }
    if(_sLinkIdAnhSauCMND != nil && _sLinkIdAnhSauCMND.length > 0)
    {
//        imvAnhMatSauCMND.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://203.162.235.66:8080/vmbank/services/media/getImage?id=%@", _sLinkIdAnhSauCMND]]]];
        [imvAnhMatSauCMND setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://vimass.vn/vmbank/services/media/getImage?id=%@", _sLinkIdAnhSauCMND]]];
    }
    if(_sLinkIdAnhChuKy != nil && _sLinkIdAnhChuKy.length > 0)
    {
//        imvAnhChuKy.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://203.162.235.66:8080/vmbank/services/media/getImage?id=%@", _sLinkIdAnhChuKy]]]];
        [imvAnhChuKy setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://vimass.vn/vmbank/services/media/getImage?id=%@", _sLinkIdAnhChuKy]]];
    }
    if(_sLinkIdAnhDaiDien && _sLinkIdAnhDaiDien.length > 0)
    {
        if([self.mThongTinTaiKhoanVi.sLinkAnhDaiDien rangeOfString:@"http"].location != NSNotFound)
            [self.mimgvDaiDien setImageWithURL:[NSURL URLWithString:_sLinkIdAnhDaiDien]];
        else
            [self.mimgvDaiDien setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://vimass.vn/vmbank/services/media/getImage?id=%@", _sLinkIdAnhDaiDien]]];
    }
}

#pragma mark - khởi tạo dữ liệu gửi xác nhận
/*
 * Upload ảnh thành công hay ko cũng thực hiện tiếp -> lấy id sau khi upload thành công -> đẩy vào link***
 * rồi đẩy thông tin lên
 */
-(void)capNhatThongTin
{
    dispatch_async(dispatch_get_main_queue(), ^{
        nTrangThaiXuLyKetNoi = TRANG_THAI_UP_DU_LIEU_THONG_TIN;
        
        NSString *sToken = @"";
        NSString *sOtpConfirm = @"";
        
        if(mTypeAuthenticate == TYPE_AUTHENTICATE_TOKEN)
        {
            NSString *sMatKhau = edtMatKhauToken.text;
            if(mXacThucVanTay)
            {
                mXacThucVanTay = NO;
                mTypeAuthenticate = TYPE_AUTHENTICATE_TOKEN;
                sMatKhau = [DucNT_Token layMatKhauVanTayToken];
                
            }
            
            NSString *sSeed = [DucNT_Token laySeedTokenHienTai];
            sToken = [DucNT_Token OTPFromPIN:sMatKhau seed:sSeed];
        }
        else if(mTypeAuthenticate == TYPE_AUTHENTICATE_SMS || mTypeAuthenticate == TYPE_AUTHENTICATE_EMAIL)
        {
            sOtpConfirm = edtMatKhauToken.text;
        }
        
        NSString *sDiaChi = @"";
        if(![tvDiaChiNha.text isEqualToString:[@"dia_chi_nha" localizableString]])
            sDiaChi = tvDiaChiNha.text;
        
        NSString *sID = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
        NSString *sSoCMND = edtSoCMND.text;
        NSString *sTenCMND = self.mtfTenCMND.text;
        NSString *sNgaySinh = [self doiDinhDangNgayThangDuLieuUpLen:edtNgaySinh.text];
        NSString *sNoiCap = edtNoiCapCMND.text;
        NSString *sNgayCap = [self doiDinhDangNgayThangDuLieuUpLen:edtNgayCapCMND.text];
        NSString *sEmail = edtThuDienTu.text;
        //HOANHNV FIX
        NSString *sViLienKet = [self dsNhanThongBao];
        
        if (!bankRutTien) {
            bankRutTien = [[DucNT_TaiKhoanThuongDungObject alloc] init];
        }
        if (nRowBank != -1) {
            Banks *bank = [arrBank objectAtIndex:nRowBank];
            NSLog(@"%s - bank : %@ - %@", __FUNCTION__, bank.bank_name, bank.bank_sms);
            bankRutTien.nBankCode = [bank.bank_code intValue];
            bankRutTien.nBankId = [bank.bank_id intValue];
            //        bankRutTien.sBankName = bank.bank_name;
            if (nRowChiNhanh != -1) {
                bankRutTien.sBranchName = [arrChiNhanhBank objectAtIndex:nRowChiNhanh];
                bankRutTien.sBranchCode = [arrChiNhanhBank objectAtIndex:(nRowChiNhanh + 1)];
            }
        }
        //0491000025790
        bankRutTien.sBankNumber = self.edSoTaiKhoanBank.text;
        bankRutTien.sAccOwnerName = self.mtfTenCMND.text;
        bankRutTien.nType = 4;
        bankRutTien.sPhoneOwner = self.mtfSoDienThoaiNhanMaXacThuc.text;
        int nHienThiQR = 0;
        if (self.checkNoiDungQR.isOn) {
            nHienThiQR = 1;
        }
    
    NSString *nameAlias = self.mtfTenGiaoDich.text;
    NSString *phoneAuthenticate = self.mtfSoDienThoaiNhanMaXacThuc.text;
    NSLog(@"%s - phoneAuthenticate : %@", __FUNCTION__, phoneAuthenticate);
        NSDictionary *dicPost = @{
                                  @"id":sID,
                                  @"idCard": sSoCMND,
                                  @"accBank":@"",
                                  @"acc_name":sTenCMND,
                                  @"birthday":sNgaySinh,
                                  @"placeIdCard":sNoiCap,
                                  @"home":sDiaChi,
                                  @"dateIdCard": sNgayCap,
                                  @"linkFrontIdCard":_sLinkIdAnhTruocCMND,
                                  @"linkBackIdCard":_sLinkIdAnhSauCMND,
                                  @"linkSignature":_sLinkIdAnhChuKy,
                                  @"token":sToken,
                                  @"nameAlias":nameAlias,
                                  @"avatar" : _sLinkIdAnhDaiDien,
                                  @"phoneAuthenticate" : sID,
                                  @"otpConfirm" : sOtpConfirm,
                                  @"typeAuthenticate" : [NSNumber numberWithInt:mTypeAuthenticate],
                                  @"email": sEmail,
                                  @"pass":@"",
                                  @"appId":[NSNumber numberWithInt:APP_ID],
                                  @"VMApp" : [NSNumber numberWithInt:VM_APP],
                                  @"tKRutTien" : [bankRutTien toDict],
                                  @"hienThiNoiDungThanhToanQR":[NSNumber numberWithInt:nHienThiQR],
                                  @"dsTKNhanThongBaoBienDongSoDu":sViLienKet
                                  };

        NSString *sPost = [dicPost JSONString];
        NSLog(@"%s - sPost : %@", __FUNCTION__, sPost);
        [self hienThiLoadingChuyenTien];
        DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
        [connect setDucnt_connectDelegate:self];
        [connect connect:@"https://vimass.vn/vmbank/services/account/editAcc1" withContent:sPost];
        [connect release];
    });
}

-(void)uploadAnh:(NSString *)sDuLieuAnhBase64
{
    NSLog(@"%s - sDuLieuAnhBase64.length : %ld", __FUNCTION__, (unsigned long)sDuLieuAnhBase64.length);
    nTrangThaiXuLyKetNoi = TRANG_THAI_UP_DU_LIEU_ANH;
    NSString *sUrl = [NSString stringWithFormat:@"%@%@", @"https://vimass.vn/vmbank/services/media/upload/", [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP]];
    NSLog(@"%s - sUrl : %@", __FUNCTION__, sUrl);
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:self];
    [connect connect:sUrl withContent:sDuLieuAnhBase64];
    [connect release];
}

-(void)khoiTaoDanhSachAnhUpLoad
{
    if(dsAnhCanUp)
        [dsAnhCanUp removeAllObjects];
    NSLog(@"%s >> %s line: %d >> %d -- %d -- %d ",__FILE__,__FUNCTION__ ,__LINE__, bTrangThaiCoAnhMatTruocMoi, bTrangThaiCoAnhMatSauMoi, bTrangThaiCoAnhChuKyMoi);
    if(bTrangThaiCoAnhMatTruocMoi)
        [dsAnhCanUp addObject:[self convertImageToBase64:imvMatTruocCMND.image]];
    if(bTrangThaiCoAnhMatSauMoi)
        [dsAnhCanUp addObject:[self convertImageToBase64:imvAnhMatSauCMND.image]];
    if(bTrangThaiCoAnhChuKyMoi)
        [dsAnhCanUp addObject:[self convertImageToBase64:imvAnhChuKy.image]];
    if(bTrangThaiCoAnhDaiDienMoi){
        NSLog(@"%s - bTrangThaiCoAnhDaiDienMoi == YES", __FUNCTION__);
        [dsAnhCanUp addObject:[self convertImageToBase64:self.mimgvDaiDien.image]];
    }
}

-(NSString *)convertImageToBase64:(UIImage *)viewImage
{
    NSData *imageData = UIImagePNGRepresentation(viewImage);
    NSString *b64EncStr = [Base64 encode: imageData];
    return b64EncStr;
}

#pragma mark - xuLyTimer
- (void)batDauDemThoiGian
{
    mTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(capNhatDemThoiGianThayDoiThongTin) userInfo:nil repeats:YES];
}

- (void)ketThucDemThoiGian
{
    [self khoiTaoGiaoDienChuyenTien];
    if(mTimer)
    {
        [mTimer invalidate];
        mTimer = nil;
    }
}

- (void)capNhatDemThoiGianThayDoiThongTin
{
    _mTongSoThoiGian --;
    if(mTypeAuthenticate == TYPE_AUTHENTICATE_SMS)
    {
        [self.mbtnXacThucBoiSMS setTitle:[NSString stringWithFormat:@"%ld s", (long)self.mTongSoThoiGian] forState:UIControlStateNormal];
    }
    else if(mTypeAuthenticate == TYPE_AUTHENTICATE_EMAIL)
    {
        [self.mbtnXacThucBoiEmail setTitle:[NSString stringWithFormat:@"%ld s", (long)self.mTongSoThoiGian] forState:UIControlStateNormal];
    }
    if(_mTongSoThoiGian == 0)
    {
        [self ketThucDemThoiGian];
    }
}

#pragma mark - xử lý kết nối

- (void)xuLyKetNoiThayDoiThongTin
{
    
}

/**
 Xử lý quét có sự thay đổi ảnh (1 - 3 ảnh) thì thực hiện theo thứ tự up từng cái ảnh 1 -> lấy id ảnh đc up -> đẩy toàn bộ thông tin mới lên
 */
-(void)ketNoiThanhCong:(NSString *)sKetQua
{
    NSLog(@"%s - sKetQua : %@", __FUNCTION__, sKetQua);
    NSDictionary *dicKQ = [sKetQua objectFromJSONString];
    int nCode = [[dicKQ objectForKey:@"msgCode"] intValue];
    NSString *sThongBao = [dicKQ objectForKey:@"msgContent"];
    if(nTrangThaiXuLyKetNoi == TRANG_THAI_UP_DU_LIEU_ANH)
    {
        if(bTrangThaiCoAnhMatTruocMoi)
        {
            if(nCode == 1)
            {
                NSString *sIDAnh = [dicKQ objectForKey:@"result"];
                if(sIDAnh)
                {
                    self.sLinkIdAnhTruocCMND  = sIDAnh;
                    bTrangThaiCoAnhMatTruocMoi = false;
                }
            }

        }
        else if(bTrangThaiCoAnhMatSauMoi)
        {
            if(nCode == 1)
            {
                NSString *sIDAnh = [dicKQ objectForKey:@"result"];
                self.sLinkIdAnhSauCMND = sIDAnh;
//                [sLinkIdAnhSauCMND retain];
                bTrangThaiCoAnhMatSauMoi = false;
            }

        }
        else if(bTrangThaiCoAnhChuKyMoi)
        {
            if(nCode == 1)
            {
                NSString *sIDAnh = [dicKQ objectForKey:@"result"];
                if(sIDAnh)
                    self.sLinkIdAnhChuKy = sIDAnh;
                bTrangThaiCoAnhChuKyMoi = false;
//                [sLinkIdAnhChuKy retain];
            }

        }
        else if(bTrangThaiCoAnhDaiDienMoi)
        {
            if(nCode == 1)
            {
                NSLog(@"%s - up load anh dai dien moi thanh cong", __FUNCTION__);
                NSString *sIDanh = [dicKQ objectForKey:@"result"];
                if(sIDanh)
                    self.sLinkIdAnhDaiDien = sIDanh;
                bTrangThaiCoAnhDaiDienMoi = false;
            }
        }
        nSoAnhDaUp++;
        if(nSoAnhDaUp < dsAnhCanUp.count)
        {
            [self uploadAnh:[dsAnhCanUp objectAtIndex:nSoAnhDaUp]];
        }
        else
        {
            [self capNhatThongTin];
        }
    }
    else if(nTrangThaiXuLyKetNoi == TRANG_THAI_UP_DU_LIEU_THONG_TIN)
    {
        [self anLoading];
        if(nCode == 1)
        {
            [self luuThongTinTaiKhoanSauKhiThucHienThanhCong];
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:[@"thong_bao" localizableString]  message:sThongBao delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
            alert.tag = HOP_THOAI_XAC_NHAN_CHUYEN_TIEN_THANH_CONG;
            [alert show];
        }
        else
        {
            [[[[UIAlertView alloc] initWithTitle:[@"thong_bao" localizableString]  message:sThongBao delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
        }
        
    }
    else if (nTrangThaiXuLyKetNoi == TRANG_THAI_KET_NOI_LAY_MA_XAC_THUC)
    {
        if(nCode == 31)
        {
            //Chay giay thong bao
            self.mTongSoThoiGian = THOI_GIAN_CHO_XAC_THUC_SMS;
            [self batDauDemThoiGian];
        }
        else if(nCode == 32)
        {
            self.mTongSoThoiGian = THOI_GIAN_CHO_XAC_THUC_EMAIL;
            [self batDauDemThoiGian];
        }
        else
        {
            [UIAlertView alert:sThongBao withTitle:[@"thong_bao" localizableString] block:nil];
        }
    }
}

/*
 * lưu thông tin tài khoản sau khi thực hiện thành công (do chỉ cập nhật thông tin từ lúc đăng nhập) nên sau khi thành công phải lưu lại giá trị này cho lần vào sau (cùng phiên)
 */
-(void)luuThongTinTaiKhoanSauKhiThucHienThanhCong
{
    NSString *sDiaChi = @"";
    if(![tvDiaChiNha.text isEqualToString:[@"dia_chi_nha" localizableString]])
        sDiaChi = tvDiaChiNha.text;
    DucNT_TaiKhoanViObject *newThongTin = [[DucNT_TaiKhoanViObject alloc] init];
    newThongTin.sID = self.mThongTinTaiKhoanVi.sID;
    newThongTin.sTenTaiKhoan = @"";
    newThongTin.sTenNganHang = @"";
    newThongTin.sThuDienTu = edtThuDienTu.text;
    newThongTin.sNgaySinh = [self doiDinhDangNgayThangDuLieuUpLen:edtNgaySinh.text];
    newThongTin.sCMND = edtSoCMND.text;
    newThongTin.sNgayCapCMND = [self doiDinhDangNgayThangDuLieuUpLen:edtNgayCapCMND.text];
    newThongTin.sNoiCapCMND = edtNoiCapCMND.text;
    newThongTin.sDiaChiNha = sDiaChi;
    newThongTin.sLinkAnhTruocCMND = _sLinkIdAnhTruocCMND;
    newThongTin.sLinkAnhSauCMND = _sLinkIdAnhSauCMND;
    newThongTin.sLinkAnhChuKy = _sLinkIdAnhChuKy;
    newThongTin.sLinkAnhDaiDien = _sLinkIdAnhDaiDien;
    newThongTin.nIsToken = self.mThongTinTaiKhoanVi.nIsToken;
    newThongTin.sNameAlias = self.mtfTenGiaoDich.text;
    newThongTin.sPhone = self.mThongTinTaiKhoanVi.sPhone;
    newThongTin.sTenCMND = self.mtfTenCMND.text;
    newThongTin.sPhoneAuthenticate = self.mtfSoDienThoaiNhanMaXacThuc.text;
    newThongTin.sPass = self.mThongTinTaiKhoanVi.sPass;
    newThongTin.sPhoneToken = self.mThongTinTaiKhoanVi.sPhoneToken;
    newThongTin.nAmount = self.mThongTinTaiKhoanVi.nAmount;
    newThongTin.nPromotionStatus = self.mThongTinTaiKhoanVi.nPromotionStatus;
    newThongTin.nPromotionTotal = self.mThongTinTaiKhoanVi.nPromotionTotal;
    newThongTin.linkQR = self.mThongTinTaiKhoanVi.linkQR;
    newThongTin.pki3 = self.mThongTinTaiKhoanVi.pki3;
    newThongTin.hanMucPki3 = self.mThongTinTaiKhoanVi.hanMucPki3;
    int nHienThi = 0;
    if (self.checkNoiDungQR.isOn) {
        nHienThi = 1;
    }
    newThongTin.hienThiNoiDungThanhToanQR = [NSNumber numberWithInt:nHienThi];
    if (bankRutTien) {
        for (Banks *temp in arrBank) {
            if ([temp.bank_id intValue] == bankRutTien.nBankId) {
                bankRutTien.sBankName = temp.bank_name;
                break;
            }
        }
        newThongTin.tKRutTien = [[bankRutTien toDict] JSONString];
    }
    else
        newThongTin.tKRutTien = @"";
    [DucNT_LuuRMS luuThongTinTaiKhoanViSauDangNhap:newThongTin];
    //HOANHNV FIX
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    app.objUpdateProfile = newThongTin;
    //END
    self.mThongTinTaiKhoanVi = newThongTin;
    [newThongTin release];
}

- (void)khoiTaoPickerChiNhanhNganHang{
    if (!arrChiNhanhBank) {
        arrChiNhanhBank = [[NSMutableArray alloc] init];
        [arrChiNhanhBank addObject:@"CN Bà Rịa Vũng Tàu"];
        [arrChiNhanhBank addObject:@"77204001"];
        [arrChiNhanhBank addObject:@"CN Bắc Hà Nội"];
        [arrChiNhanhBank addObject:@"1204006"];
        [arrChiNhanhBank addObject:@"CN Bình Phước"];
        [arrChiNhanhBank addObject:@"70204001"];
        [arrChiNhanhBank addObject:@"CN Đồng Nai"];
        [arrChiNhanhBank addObject:@"75204001"];
        [arrChiNhanhBank addObject:@"CN Gia Lai"];
        [arrChiNhanhBank addObject:@"64204001"];
        [arrChiNhanhBank addObject:@"CN Hà Nội"];
        [arrChiNhanhBank addObject:@"1204003"];
        [arrChiNhanhBank addObject:@"CN Hà Nội"];
        [arrChiNhanhBank addObject:@"1204003"];
        [arrChiNhanhBank addObject:@"CN Hà Tây"];
        [arrChiNhanhBank addObject:@"1204036"];
        [arrChiNhanhBank addObject:@"CN Láng Hà Nội"];
        [arrChiNhanhBank addObject:@"1204010"];
        [arrChiNhanhBank addObject:@"CN Nam Hà Nội"];
        [arrChiNhanhBank addObject:@"1204017"];
        [arrChiNhanhBank addObject:@"CN Nghệ An"];
        [arrChiNhanhBank addObject:@"40204001"];
        [arrChiNhanhBank addObject:@"CN Sài Gòn"];
        [arrChiNhanhBank addObject:@"79204023"];
        [arrChiNhanhBank addObject:@"CN Sở giao dịch"];
        [arrChiNhanhBank addObject:@"1204002"];
        [arrChiNhanhBank addObject:@"CN TP Hồ Chí Minh"];
        [arrChiNhanhBank addObject:@"79204001"];
        [arrChiNhanhBank addObject:@"CN TT Thanh Toán"];
        [arrChiNhanhBank addObject:@"1204009"];
        [arrChiNhanhBank addObject:@"CN Thăng Long"];
        [arrChiNhanhBank addObject:@"1204011"];
        [arrChiNhanhBank addObject:@"CN Thừa Thiên Huế"];
        [arrChiNhanhBank addObject:@"46204001"];
        [arrChiNhanhBank addObject:@"CN tỉnh Bắc Giang"];
        [arrChiNhanhBank addObject:@"24204001"];
        [arrChiNhanhBank addObject:@"CN tỉnh Bình Dương"];
        [arrChiNhanhBank addObject:@"74204001"];
        [arrChiNhanhBank addObject:@"CN tỉnh Bình Thuận"];
        [arrChiNhanhBank addObject:@"60204001"];
        [arrChiNhanhBank addObject:@"CN tỉnh Cao Bằng"];
        [arrChiNhanhBank addObject:@"4204001"];
        [arrChiNhanhBank addObject:@"CN tỉnh Điện Biên"];
        [arrChiNhanhBank addObject:@"11204001"];
        [arrChiNhanhBank addObject:@"CN tỉnh Hà Nam"];
        [arrChiNhanhBank addObject:@"35204001"];
        [arrChiNhanhBank addObject:@"CN tỉnh Hà Tĩnh"];
        [arrChiNhanhBank addObject:@"42204001"];
        [arrChiNhanhBank addObject:@"CN tỉnh Hoà Bình"];
        [arrChiNhanhBank addObject:@"17204001"];
        [arrChiNhanhBank addObject:@"CN tỉnh Khánh Hoà"];
        [arrChiNhanhBank addObject:@"56204001"];
        [arrChiNhanhBank addObject:@"CN tỉnh Kon Tum"];
        [arrChiNhanhBank addObject:@"62204001"];
        [arrChiNhanhBank addObject:@"CN tỉnh Lào Cai"];
        [arrChiNhanhBank addObject:@"10204001"];
        [arrChiNhanhBank addObject:@"CN tỉnh Nam Định"];
        [arrChiNhanhBank addObject:@"36204001"];
        [arrChiNhanhBank addObject:@"CN tỉnh Ninh Bình"];
        [arrChiNhanhBank addObject:@"37204001"];
        [arrChiNhanhBank addObject:@"CN tỉnh Ninh Thuận"];
        [arrChiNhanhBank addObject:@"58204001"];
        [arrChiNhanhBank addObject:@"CN tỉnh Quảng Bình"];
        [arrChiNhanhBank addObject:@"44204001"];
        [arrChiNhanhBank addObject:@"CN tỉnh Sơn La"];
        [arrChiNhanhBank addObject:@"14204001"];
        [arrChiNhanhBank addObject:@"CN tỉnh Thái Bình"];
        [arrChiNhanhBank addObject:@"34204001"];
        [arrChiNhanhBank addObject:@"CN tỉnh Thái Nguyên"];
        [arrChiNhanhBank addObject:@"19204001"];
        [arrChiNhanhBank addObject:@"CN tỉnh Tuyên Quang"];
        [arrChiNhanhBank addObject:@"8204001"];
        [arrChiNhanhBank addObject:@"CN tỉnh Vĩnh Phúc"];
        [arrChiNhanhBank addObject:@"26204001"];
        [arrChiNhanhBank addObject:@"Tự nhập chi nhánh"];
        [arrChiNhanhBank addObject:@"11111111"];
    }
}

#pragma mark - dealloc
- (void)dealloc {
    if(dsTinhThanh)
        [dsTinhThanh release];
//    if(_thongTinTaiKhoan)
//        [_thongTinTaiKhoan release];
    if(scrollView)
        [scrollView release];
    if(edtThuDienTu)
        [edtThuDienTu release];
    if(edtNgaySinh)
        [edtNgaySinh release];
    if(edtSoCMND)
        [edtSoCMND release];
    if(edtNoiCapCMND)
        [edtNoiCapCMND release];
    if(edtDiaChiNha)
        [edtDiaChiNha release];
    if(btnChupAnhMatTruocCMND)
        [btnChupAnhMatTruocCMND release];
    if(btnLayAnhMatTruocCMND)
        [btnLayAnhMatTruocCMND release];
    if(imvMatTruocCMND)
        [imvMatTruocCMND release];
    if(btnChupAnhMatSauCMND)
        [btnChupAnhMatSauCMND release];
    if (btnLayAnhMatSauCMND)
        [btnLayAnhMatSauCMND release];
    if(imvAnhMatSauCMND)
        [imvAnhMatSauCMND release];
    if(btnChupAnhChuKy)
        [btnChupAnhChuKy release];
    if(btnLayAnhChuKy)
        [btnLayAnhChuKy release];
    if(imvAnhChuKy)
        [imvAnhChuKy release];
    if(edtMatKhauToken)
        [edtMatKhauToken release];
    if(btnThucHien)
        [btnThucHien release];
    if(viewMain)
        [viewMain release];
    if(edtNgayCapCMND)
        [edtNgayCapCMND release];
    if(_sLinkIdAnhTruocCMND)
        [_sLinkIdAnhTruocCMND release];
    if(_sLinkIdAnhSauCMND)
        [_sLinkIdAnhSauCMND release];
    if(_sLinkIdAnhChuKy)
        [_sLinkIdAnhChuKy release];
    if(_sLinkIdAnhDaiDien)
        [_sLinkIdAnhDaiDien release];
    if(tvDiaChiNha)
        [tvDiaChiNha release];
    [_mtfTaiKhoan release];
    [_mtfTenGiaoDich release];
    [_mtfTenCMND release];
    [_mimgvDaiDien release];
    [_mtfSoDienThoaiNhanMaXacThuc release];
    [_mbtnChupAnhDaiDien release];
    [_mbtnLayAnhDaiDien release];
    [_mimgAnhDaiDien release];
    [_mViewToken release];
    [_mViewThongTIn release];
    [_mViewThoiGianConLai release];
    [_mbtnXacThucBoiToken release];
    [_mbtnXacThucBoiEmail release];
    [_mbtnXacThucBoiSMS release];
    [_mlblXacThucBoi release];
    [mbtnVanTay release];
    [_mlblTaiKhoan release];
    [_mlblSoDienThoaiNhanMaXacThuc release];
    [_mlblThuDienTuNhanMaXacThuc release];
    [_mlblTenHienThi release];
    [_mlblTenTrongCMND release];
    [_mlblNgaySinh release];
    [_mlblSoCMND release];
    [_mlblNgayCap release];
    [_mlblNoiCap release];
    [_mlblNoiThuongTru release];
    [_mlblAnhDaiDien release];
    [_mlblAnhMatTruocCMND release];
    [_mlblAnhMatSauCMND release];
    [_mlblAnhChuKy release];
    [_edBank release];
    [_edSoTaiKhoanBank release];
    [_edChiNhanh release];
    [_lblChiNhanh release];
    [_edChuTaiKhoan release];
    [_imgvQRCode release];
    [_checkNoiDungQR release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setEdtThuDienTu:nil];
    [self setEdtNgaySinh:nil];
    [self setEdtSoCMND:nil];
    [self setEdtNgayCapCMND:nil];
    [self setEdtNoiCapCMND:nil];
    [self setEdtDiaChiNha:nil];
    [self setBtnChupAnhMatTruocCMND:nil];
    [self setBtnLayAnhMatTruocCMND:nil];
    [self setImvMatTruocCMND:nil];
    [self setBtnChupAnhMatSauCMND:nil];
    [self setBtnLayAnhMatSauCMND:nil];
    [self setImvAnhMatSauCMND:nil];
    [self setBtnChupAnhChuKy:nil];
    [self setBtnLayAnhChuKy:nil];
    [self setImvAnhChuKy:nil];
    [self setEdtMatKhauToken:nil];
    [self setBtnThucHien:nil];
    [self setViewMain:nil];
    [self setTvDiaChiNha:nil];
    [super viewDidUnload];
}
@end
