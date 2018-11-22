//
//  DucNT_ChuyenTienDenTaiKhoanViewController.m
//  ViMASS
//
//  Created by MacBookPro on 7/30/14.
//
//

#import "DucNT_ChuyenTienDenTaiKhoanViewController.h"
#import "DucNT_DanhSachTaiKhoanThuongDungControllerViewController.h"
#import "DucNT_TaiKhoanThuongDungObject.h"
#import "DucNT_ViewNhapTenDaiDienTaiKhoanThuongDung.h"
#import "DucNT_ViewPicker.h"
#import "ProvinceCoreData.h"
#import "BranchCoreData.h"
#import "BankCoreData.h"
#import "ContactScreen.h"
#import "DucNT_Token.h"
#import "ViewNhapTenDaiDienXacThucThemTaiKhoanThuongDung.h"
#import "TPKeyboardAvoidAcessory.h"
#import "GiaoDienThongTinPhim.h"
#import "ViewQuangCao.h"
#import "DucNT_LoginSceen.h"
#import "CommonUtils.h"
@interface DucNT_ChuyenTienDenTaiKhoanViewController ()<UITextFieldDelegate>
{
    ViewNhapTenDaiDienXacThucThemTaiKhoanThuongDung *mViewNhapTenDaiDien;
    DucNT_ViewPicker *mViewPickerNganHang;
    int mViTriNganHangDuocChon;
    IBOutlet TPKeyboardAvoidAcessory *mScrv;
    ExTextField *mtfChiNhanh;
    ExTextField *mtfChiNhanhKhac;
    NSMutableArray *arrChiNhanhBank;
    ViewQuangCao *viewQC;
}

@end

@implementation DucNT_ChuyenTienDenTaiKhoanViewController


#pragma mark - init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        mViTriNganHangDuocChon = -1;
    }
    return self;
}

#pragma mark - life circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self khoiTaoBanDau];
    [self khoiTaoTextField];
    [self khoiTaoViewPickerNganHang];
    [self khoiTaoViewNhapTenDaiDienXacThucTaiKhoan];
    [self xuLyKetNoiLaySoDuTaiKhoan];
    if(_mTaiKhoanThuongDung)
        [self xuLyCapNhatTaiKhoanThuongDung];
    else
        [self xuLyHienThiSoTienPhiCuaSoTien:@"0"];
    [self themButtonHuongDanSuDung:@selector(huongDanChuyenTienDenTaiKhoan:)];
    [self addRightButtonForPicker:_edtNganHang];
}

- (void)khoiTaoQuangCao {
    if (!viewQC) {
        NSLog(@"%s - [UIScreen mainScreen].bounds.size.height : %f", __FUNCTION__, [UIScreen mainScreen].bounds.size.height);
        viewQC = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ViewQuangCao class]) owner:self options:nil] objectAtIndex:0];
        CGRect rectToken = self.mViewNhapToken.frame;
        CGRect rectQC = viewQC.frame;
        CGRect rectMain = self.mViewMain.frame;
        CGFloat fW = rectMain.size.width;
        CGFloat fH = fW * 0.45333;
        rectQC.origin.y = rectToken.origin.y + rectToken.size.height + 10;
        viewQC.frame = CGRectMake(0, rectQC.origin.y, fW, fH);
        NSLog(@"%s - fW : %f - fH : %f", __FUNCTION__, fW, fH);
        viewQC.mDelegate = self;
        [viewQC updateSizeQuangCao];
        float fThem = 70;
        if ([UIScreen mainScreen].bounds.size.width == 320) {
            fThem = 15;
        }
//        if ([UIScreen mainScreen].bounds.size.height >= 736.0) {
//            fThem = 80;
//        }
        NSLog(@"%s - fThem : %f", __FUNCTION__, fThem);
        rectMain.size.height = rectQC.origin.y + rectQC.size.height + fThem;
        self.mViewMain.frame = rectMain;
        [self.mViewMain addSubview:viewQC];
        self.heightViewMain.constant += rectQC.size.height;
        [self.scrMain setContentSize:CGSizeMake(_scrMain.frame.size.width, rectMain.origin.y + rectMain.size.height + self.viewOptionTop.frame.origin.y + self.viewOptionTop.frame.size.height + 10)];
    }
    
}

- (void)updateXacThucKhac {
    [super updateXacThucKhac];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (viewQC != nil) {
            CGRect rectToken = self.mViewNhapToken.frame;
            CGRect rectQC = viewQC.frame;
            rectQC.origin.y = rectToken.origin.y + self.heightViewNhapXacThuc.constant + 15.0;
            viewQC.frame = rectQC;
        }
    });
}

- (void)suKienChonQuangCao:(NSString *)sNameImage {
    [self suKienQuangCaoGoc:sNameImage];
}

- (void)huongDanChuyenTienDenTaiKhoan:(UIButton *)sender {
    GiaoDienThongTinPhim *vc = [[GiaoDienThongTinPhim alloc] initWithNibName:@"GiaoDienThongTinPhim" bundle:nil];
    vc.nOption = HUONG_DAN_CHUYEN_TIEN_TAI_KHOAN;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)suKienBamNutHuongDanGiaoDichViewController:(UIButton *)sender {
    GiaoDienThongTinPhim *vc = [[GiaoDienThongTinPhim alloc] initWithNibName:@"GiaoDienThongTinPhim" bundle:nil];
    vc.nOption = HUONG_DAN_CHUYEN_TIEN_TAI_KHOAN;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setAnimationChoSoTay:self.btnSoTay];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view endEditing:YES];
    [mScrv setContentOffset:CGPointMake(0, 0) animated:NO];
    [self khoiTaoQuangCao];
    if(![CommonUtils isEmptyOrNull:self.mThongTinTaiKhoanVi.pki3] && [self.mThongTinTaiKhoanVi.hanMucPki3 doubleValue] >0 ){
        self.mbtnPKI.hidden = NO;
    }
    else{
        self.mbtnPKI.hidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.btnSoTay.imageView stopAnimating];
}

#pragma mark - handler error

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - khoi Tao

- (void)khoiTaoBanDau
{
    [self addButtonBack];
    [self addTitleView:[@"@title_chuyen_tien_den_tai_khoan" localizableString]];
    self.mFuncID = FUNC_TRANSACTION_TO_BANK;
    NSLog(@"%s - mFuncID : %d", __FUNCTION__, self.mFuncID);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateThongTin:) name:KEY_TAI_KHOAN_THUONG_DUNG object:nil];
//    UIBarButtonItem *rItem = [[[UIBarButtonItem alloc] initWithCustomView:_btnLuuTaiKhoanThuongDung] autorelease];
//    rItem.width = (_btnLuuTaiKhoanThuongDung).bounds.size.width;
//    self.navigationItem.rightBarButtonItems = @[[self negative_baritem_at_side:NO], rItem];
}

-(void)khoiTaoTextField
{
    [self.mlblPhi setText:[NSString stringWithFormat:@"%@:",[@"phi" localizableString]]];
    
    [_edtTenChuTaiKhoan setTextError:[@"@ten_tai_khoan_khong_duoc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    _edtTenChuTaiKhoan.inputAccessoryView = nil;
    
    [_edtSoTaiKhoan setTextError:[@"@so_tai_khoan_khong_dc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    [_edtSoTaiKhoan setType:ExTextFieldTypeBankNumber];
    _edtSoTaiKhoan.inputAccessoryView = nil;
    
    [_edtSoTien setTextError:[@"so_tien_khong_duoc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    [_edtSoTien setTextError:[@"@so_tien_khong_hop_le" localizableString]forType:ExTextFieldTypeMoney];
    _edtSoTien.inputAccessoryView = nil;

    [_edtNganHang setTextError:[@"ten_ngan_hang_khong_duoc_de_trong" localizableString] forType:ExTextFieldTypeEmpty];
    _edtNganHang.inputAccessoryView = nil;

    _tvNoiDung.inputAccessoryView = nil;
}

- (void)khoiTaoViewPickerNganHang
{
    if(!mViewPickerNganHang)
        mViewPickerNganHang = [[DucNT_ViewPicker alloc] initWithNib];

    self.mDanhSachNganHang = [BankCoreData allBanks];
    if(_mDanhSachNganHang && _mDanhSachNganHang.count > 0)
    {
        NSMutableArray *dsTenNganHang = [[NSMutableArray alloc] init];
        for(int i = 0; i < _mDanhSachNganHang.count; i++)
        {
            Banks *bank = [_mDanhSachNganHang objectAtIndex:i];
            NSString *sTenNganHang = bank.bank_name;
            [dsTenNganHang addObject:sTenNganHang];
            NSLog(@"%s - bank : %@", __FUNCTION__, bank.bank_name);
        }
        
        [_edtNganHang becomeFirstResponder];
        __block DucNT_ChuyenTienDenTaiKhoanViewController *blockSELF = self;
        [mViewPickerNganHang khoiTaoDuLieu:dsTenNganHang];
        [mViewPickerNganHang capNhatKetQuaLuaChon:^(int nGiaTri) {
            [blockSELF.edtNganHang resignFirstResponder];
            if(nGiaTri != -1)
            {
                blockSELF.edtNganHang.text = [dsTenNganHang objectAtIndex:nGiaTri];
                if(nGiaTri != blockSELF->mViTriNganHangDuocChon)
                {
                    blockSELF->mViTriNganHangDuocChon = nGiaTri;
                    NSString *sSoTien = [blockSELF.edtSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""];
                    [blockSELF xuLyHienThiSoTienPhiCuaSoTien:sSoTien];
                    if([blockSELF.edtNganHang.text hasPrefix:@"AGR"]){
                        [self hienThiGiaoDienThemChiNhanh];
                    }
                    else{
                        [self hienThiGiaoDienTruChiNhanh];
                        [self hienThiGiaoDienTruChiNhanhKhac];
                    }
                }
            }
        }];
        [dsTenNganHang release];
    }
    _edtNganHang.inputView = mViewPickerNganHang;
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
        [arrChiNhanhBank addObject:@"Chi nhánh khác"];
        [arrChiNhanhBank addObject:@"11111111"];
    }
    NSMutableArray *arrTemp = [[NSMutableArray alloc] init];
    for (int i = 0; i < arrChiNhanhBank.count; i += 2) {
        [arrTemp addObject:[arrChiNhanhBank objectAtIndex:i]];
    }
    DucNT_ViewPicker *brankPicker = [[DucNT_ViewPicker alloc] initWithNib];
    [brankPicker khoiTaoDuLieu:arrTemp];
    mtfChiNhanh.inputView = brankPicker;
    [brankPicker capNhatKetQuaLuaChon:^(int nIndex) {
        [mtfChiNhanh resignFirstResponder];
        if (nIndex > -1) {
            NSString *sBranch = [arrTemp objectAtIndex:nIndex];
            [mtfChiNhanh setText:sBranch];
            if (nIndex != [arrTemp count] - 1) {
                [self hienThiGiaoDienTruChiNhanhKhac];
            }
            else{
//                mtfChiNhanh.inputView = nil;
//                [mtfChiNhanh becomeFirstResponder];
                [self hienThiGiaoDienThemChiNhanhKhac];
            }
        }
    }];
    [arrTemp release];
    [brankPicker release];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField isEqual:mtfChiNhanh]) {
        if (mtfChiNhanh.text.length == 0) {
            [self khoiTaoPickerChiNhanhNganHang];
        }
    }
}

- (void)hienThiGiaoDienThemChiNhanh{
    if (!mtfChiNhanh) {
        mtfChiNhanh = [[ExTextField alloc] initWithFrame:CGRectMake(10, 44, 282, 35)];
        [self addRightButtonForPicker:mtfChiNhanh];
//        [mtfChiNhanh setDelegate:self];
    }
    if (!mtfChiNhanhKhac) {
        mtfChiNhanhKhac = [[ExTextField alloc] initWithFrame:CGRectMake(10, 87, 282, 35)];
    }
    [self khoiTaoPickerChiNhanhNganHang];
    [mtfChiNhanh setPlaceholder:@"Chọn chi nhánh"];
    
    [self.viewThongTin addSubview:mtfChiNhanh];

    CGPoint point1 = self.edtTenChuTaiKhoan.frame.origin;
    CGSize size1 = self.edtTenChuTaiKhoan.frame.size;
    int nPixelThem = 8;
    [self.edtTenChuTaiKhoan setFrame:CGRectMake(point1.x, point1.y + size1.height + nPixelThem, size1.width, size1.height)];
    
    CGPoint point2 = self.edtSoTaiKhoan.frame.origin;
    CGSize size2 = self.edtSoTaiKhoan.frame.size;
    [self.edtSoTaiKhoan setFrame:CGRectMake(point2.x, point2.y + size2.height + nPixelThem, size2.width, size2.height)];
    
    CGPoint point3 = self.edtSoTien.frame.origin;
    CGSize size3 = self.edtSoTien.frame.size;
    [self.edtSoTien setFrame:CGRectMake(point3.x, point3.y + size3.height + nPixelThem, size3.width, size3.height)];
    
    CGPoint point5 = self.mlblPhi.frame.origin;
    CGSize size5 = self.mlblPhi.frame.size;
    [self.mlblPhi setFrame:CGRectMake(point5.x, point5.y + size5.height + nPixelThem, size5.width, size5.height)];
    
    CGPoint point51 = self.mtfPhiGiaoDich.frame.origin;
    CGSize size51 = self.mtfPhiGiaoDich.frame.size;
    [self.mtfPhiGiaoDich setFrame:CGRectMake(point51.x, point51.y + size51.height + nPixelThem, size51.width, size51.height)];
    
    CGPoint point4 = self.tvNoiDung.frame.origin;
    CGSize size4 = self.tvNoiDung.frame.size;
    [self.tvNoiDung setFrame:CGRectMake(point4.x, point4.y + size1.height + nPixelThem, size4.width, size4.height)];
    
    [self.mtfNoiDug setFrame:CGRectMake(point4.x, self.tvNoiDung.frame.origin.y, size4.width, size4.height)];
    
    CGPoint point6 = self.viewButtonOption.frame.origin;
    CGSize size6 = self.viewButtonOption.frame.size;
    [self.viewButtonOption setFrame:CGRectMake(point6.x, point6.y + size6.height + nPixelThem, size6.width, size6.height)];
    
    CGPoint point7 = self.viewToken.frame.origin;
    CGSize size7 = self.viewToken.frame.size;
    [self.viewToken setFrame:CGRectMake(point7.x, point7.y + size7.height + nPixelThem, size7.width, size7.height)];

    CGPoint point17 = viewQC.frame.origin;
    CGSize size17 = viewQC.frame.size;
    [viewQC setFrame:CGRectMake(point17.x, self.viewToken.frame.origin.y + self.viewToken.frame.size.height + 60, size17.width, size17.height)];

    CGPoint point8 = self.viewThongTin.frame.origin;
    CGSize size8 = self.viewThongTin.frame.size;
    [self.viewThongTin setFrame:CGRectMake(point8.x, point8.y, size8.width, size8.height + size1.height + nPixelThem)];
    
    CGPoint point9 = self.mViewMain.frame.origin;
    CGSize size9 = self.mViewMain.frame.size;
    [self.mViewMain setFrame:CGRectMake(point9.x, point9.y, size9.width, size9.height + size1.height + nPixelThem)];
    
    CGPoint point10 = self.mbtnVanTay.frame.origin;
    CGSize size10 = self.mbtnVanTay.frame.size;
    [self.mbtnVanTay setFrame:CGRectMake(point10.x, point10.y + size1.height + nPixelThem, size10.width, size10.height)];

    [self.scrMain setContentSize:CGSizeMake(_scrMain.frame.size.width, viewQC.frame.origin.y + viewQC.frame.size.height + self.viewOptionTop.frame.origin.y + self.viewOptionTop.frame.size.height + 10)];
}

- (void)hienThiGiaoDienTruChiNhanh{
    if (!mtfChiNhanh) {
        return;
    }
    [mtfChiNhanh removeFromSuperview];
    
    CGPoint point1 = self.edtTenChuTaiKhoan.frame.origin;
    CGSize size1 = self.edtTenChuTaiKhoan.frame.size;
    int nPixelThem = 8;
    [self.edtTenChuTaiKhoan setFrame:CGRectMake(point1.x, point1.y - size1.height - nPixelThem, size1.width, size1.height)];
    
    CGPoint point2 = self.edtSoTaiKhoan.frame.origin;
    CGSize size2 = self.edtSoTaiKhoan.frame.size;
    [self.edtSoTaiKhoan setFrame:CGRectMake(point2.x, point2.y - size2.height - nPixelThem, size2.width, size2.height)];
    
    CGPoint point3 = self.edtSoTien.frame.origin;
    CGSize size3 = self.edtSoTien.frame.size;
    [self.edtSoTien setFrame:CGRectMake(point3.x, point3.y - size3.height - nPixelThem, size3.width, size3.height)];
    
    CGPoint point5 = self.mlblPhi.frame.origin;
    CGSize size5 = self.mlblPhi.frame.size;
    [self.mlblPhi setFrame:CGRectMake(point5.x, point5.y - size5.height - nPixelThem, size5.width, size5.height)];
    
    CGPoint point51 = self.mtfPhiGiaoDich.frame.origin;
    CGSize size51 = self.mtfPhiGiaoDich.frame.size;
    [self.mtfPhiGiaoDich setFrame:CGRectMake(point51.x, point51.y - size51.height - nPixelThem, size51.width, size51.height)];
    
    CGPoint point4 = self.tvNoiDung.frame.origin;
    CGSize size4 = self.tvNoiDung.frame.size;
    [self.tvNoiDung setFrame:CGRectMake(point4.x, point4.y - size1.height - nPixelThem, size4.width, size4.height)];
    
    [self.mtfNoiDug setFrame:CGRectMake(point4.x, self.tvNoiDung.frame.origin.y, size4.width, size4.height)];
    
    CGPoint point6 = self.viewButtonOption.frame.origin;
    CGSize size6 = self.viewButtonOption.frame.size;
    [self.viewButtonOption setFrame:CGRectMake(point6.x, point6.y - size6.height - nPixelThem, size6.width, size6.height)];
    
    CGPoint point7 = self.viewToken.frame.origin;
    CGSize size7 = self.viewToken.frame.size;
    [self.viewToken setFrame:CGRectMake(point7.x, point7.y - size7.height - nPixelThem, size7.width, size7.height)];

    CGPoint point17 = viewQC.frame.origin;
    CGSize size17 = viewQC.frame.size;
    [viewQC setFrame:CGRectMake(point17.x, self.viewToken.frame.origin.y + self.viewToken.frame.size.height + 60, size17.width, size17.height)];

    CGPoint point8 = self.viewThongTin.frame.origin;
    CGSize size8 = self.viewThongTin.frame.size;
    [self.viewThongTin setFrame:CGRectMake(point8.x, point8.y, size8.width, size8.height - size1.height - nPixelThem)];
    
    CGPoint point9 = self.mViewMain.frame.origin;
    CGSize size9 = self.mViewMain.frame.size;
    [self.mViewMain setFrame:CGRectMake(point9.x, point9.y, size9.width, size9.height - size1.height - nPixelThem)];
    
    CGPoint point10 = self.mbtnVanTay.frame.origin;
    CGSize size10 = self.mbtnVanTay.frame.size;
    [self.mbtnVanTay setFrame:CGRectMake(point10.x, point10.y - size1.height - nPixelThem, size10.width, size10.height)];

    [self.scrMain setContentSize:CGSizeMake(_scrMain.frame.size.width, viewQC.frame.origin.y + viewQC.frame.size.height + self.viewOptionTop.frame.origin.y + self.viewOptionTop.frame.size.height + 10)];
}

- (void)hienThiGiaoDienThemChiNhanhKhac {
    if (!mtfChiNhanhKhac) {
        mtfChiNhanhKhac = [[ExTextField alloc] initWithFrame:CGRectMake(10, 87, 282, 35)];
    }
    [mtfChiNhanhKhac setPlaceholder:@"Tên chi nhánh khác"];
    if ([self.viewThongTin.subviews containsObject:mtfChiNhanhKhac]) {
        return;
    }
    [self.viewThongTin addSubview:mtfChiNhanhKhac];

    CGPoint point1 = self.edtTenChuTaiKhoan.frame.origin;
    CGSize size1 = self.edtTenChuTaiKhoan.frame.size;
    int nPixelThem = 8;
    [self.edtTenChuTaiKhoan setFrame:CGRectMake(point1.x, point1.y + size1.height + nPixelThem, size1.width, size1.height)];

    CGPoint point2 = self.edtSoTaiKhoan.frame.origin;
    CGSize size2 = self.edtSoTaiKhoan.frame.size;
    [self.edtSoTaiKhoan setFrame:CGRectMake(point2.x, point2.y + size2.height + nPixelThem, size2.width, size2.height)];

    CGPoint point3 = self.edtSoTien.frame.origin;
    CGSize size3 = self.edtSoTien.frame.size;
    [self.edtSoTien setFrame:CGRectMake(point3.x, point3.y + size3.height + nPixelThem, size3.width, size3.height)];

    CGPoint point5 = self.mlblPhi.frame.origin;
    CGSize size5 = self.mlblPhi.frame.size;
    [self.mlblPhi setFrame:CGRectMake(point5.x, point5.y + size5.height + nPixelThem, size5.width, size5.height)];

    CGPoint point51 = self.mtfPhiGiaoDich.frame.origin;
    CGSize size51 = self.mtfPhiGiaoDich.frame.size;
    [self.mtfPhiGiaoDich setFrame:CGRectMake(point51.x, point51.y + size51.height + nPixelThem, size51.width, size51.height)];

    CGPoint point4 = self.tvNoiDung.frame.origin;
    CGSize size4 = self.tvNoiDung.frame.size;
    [self.tvNoiDung setFrame:CGRectMake(point4.x, point4.y + size1.height + nPixelThem, size4.width, size4.height)];

    [self.mtfNoiDug setFrame:CGRectMake(point4.x, self.tvNoiDung.frame.origin.y, size4.width, size4.height)];

    CGPoint point6 = self.viewButtonOption.frame.origin;
    CGSize size6 = self.viewButtonOption.frame.size;
    [self.viewButtonOption setFrame:CGRectMake(point6.x, point6.y + size6.height + nPixelThem, size6.width, size6.height)];

    CGPoint point7 = self.viewToken.frame.origin;
    CGSize size7 = self.viewToken.frame.size;
    [self.viewToken setFrame:CGRectMake(point7.x, point7.y + size7.height + nPixelThem, size7.width, size7.height)];

    CGPoint point8 = self.viewThongTin.frame.origin;
    CGSize size8 = self.viewThongTin.frame.size;
    [self.viewThongTin setFrame:CGRectMake(point8.x, point8.y, size8.width, size8.height + size1.height + nPixelThem)];

    CGPoint point9 = self.mViewMain.frame.origin;
    CGSize size9 = self.mViewMain.frame.size;
    [self.mViewMain setFrame:CGRectMake(point9.x, point9.y, size9.width, size9.height + size1.height + nPixelThem)];

    CGPoint point10 = self.mbtnVanTay.frame.origin;
    CGSize size10 = self.mbtnVanTay.frame.size;
    [self.mbtnVanTay setFrame:CGRectMake(point10.x, point10.y + size1.height + nPixelThem, size10.width, size10.height)];
}

- (void)hienThiGiaoDienTruChiNhanhKhac{
    if (!mtfChiNhanhKhac) {
        return;
    }
    if (![self.viewThongTin.subviews containsObject:mtfChiNhanhKhac]) {
        return;
    }
    [mtfChiNhanhKhac removeFromSuperview];

    CGPoint point1 = self.edtTenChuTaiKhoan.frame.origin;
    CGSize size1 = self.edtTenChuTaiKhoan.frame.size;
    int nPixelThem = 8;
    [self.edtTenChuTaiKhoan setFrame:CGRectMake(point1.x, point1.y - size1.height - nPixelThem, size1.width, size1.height)];

    CGPoint point2 = self.edtSoTaiKhoan.frame.origin;
    CGSize size2 = self.edtSoTaiKhoan.frame.size;
    [self.edtSoTaiKhoan setFrame:CGRectMake(point2.x, point2.y - size2.height - nPixelThem, size2.width, size2.height)];

    CGPoint point3 = self.edtSoTien.frame.origin;
    CGSize size3 = self.edtSoTien.frame.size;
    [self.edtSoTien setFrame:CGRectMake(point3.x, point3.y - size3.height - nPixelThem, size3.width, size3.height)];

    CGPoint point5 = self.mlblPhi.frame.origin;
    CGSize size5 = self.mlblPhi.frame.size;
    [self.mlblPhi setFrame:CGRectMake(point5.x, point5.y - size5.height - nPixelThem, size5.width, size5.height)];

    CGPoint point51 = self.mtfPhiGiaoDich.frame.origin;
    CGSize size51 = self.mtfPhiGiaoDich.frame.size;
    [self.mtfPhiGiaoDich setFrame:CGRectMake(point51.x, point51.y - size51.height - nPixelThem, size51.width, size51.height)];

    CGPoint point4 = self.tvNoiDung.frame.origin;
    CGSize size4 = self.tvNoiDung.frame.size;
    [self.tvNoiDung setFrame:CGRectMake(point4.x, point4.y - size1.height - nPixelThem, size4.width, size4.height)];

    [self.mtfNoiDug setFrame:CGRectMake(point4.x, self.tvNoiDung.frame.origin.y, size4.width, size4.height)];

    CGPoint point6 = self.viewButtonOption.frame.origin;
    CGSize size6 = self.viewButtonOption.frame.size;
    [self.viewButtonOption setFrame:CGRectMake(point6.x, point6.y - size6.height - nPixelThem, size6.width, size6.height)];

    CGPoint point7 = self.viewToken.frame.origin;
    CGSize size7 = self.viewToken.frame.size;
    [self.viewToken setFrame:CGRectMake(point7.x, point7.y - size7.height - nPixelThem, size7.width, size7.height)];

    CGPoint point8 = self.viewThongTin.frame.origin;
    CGSize size8 = self.viewThongTin.frame.size;
    [self.viewThongTin setFrame:CGRectMake(point8.x, point8.y, size8.width, size8.height - size1.height - nPixelThem)];

    CGPoint point9 = self.mViewMain.frame.origin;
    CGSize size9 = self.mViewMain.frame.size;
    [self.mViewMain setFrame:CGRectMake(point9.x, point9.y, size9.width, size9.height - size1.height - nPixelThem)];

    CGPoint point10 = self.mbtnVanTay.frame.origin;
    CGSize size10 = self.mbtnVanTay.frame.size;
    [self.mbtnVanTay setFrame:CGRectMake(point10.x, point10.y - size1.height - nPixelThem, size10.width, size10.height)];
}

- (void)khoiTaoViewNhapTenDaiDienXacThucTaiKhoan
{
    if(!mViewNhapTenDaiDien)
    {
        mViewNhapTenDaiDien = [[[[NSBundle mainBundle] loadNibNamed:@"ViewNhapTenDaiDienXacThucThemTaiKhoanThuongDung" owner:self options:nil] objectAtIndex:0] retain];

    }
}

#pragma mark - get & set

- (void)setMTaiKhoanThuongDung:(DucNT_TaiKhoanThuongDungObject *)mTaiKhoanThuongDung
{
    if(_mTaiKhoanThuongDung)
        [_mTaiKhoanThuongDung release];
    _mTaiKhoanThuongDung = [mTaiKhoanThuongDung retain];
    _mTaiKhoanThuongDung.sId = @"";
}

#pragma mark - overriden GiaoDichViewController

-(BOOL)validateVanTay
{
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return NO;
    }
    NSArray *tfs = @[_edtNganHang, _edtTenChuTaiKhoan, _edtSoTaiKhoan, _edtSoTien];
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
        return NO;
    }

    double fSoTien = [[_edtSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
//    && fSoTien > 1000000000
    if(fSoTien < 50000)
    {
        [UIAlertView alert:@"Số tiền chuyển đi tối thiểu là 50.000 đồng" withTitle:[@"thong_bao" localizableString] block:nil];
        return NO;
    }
    else if (fSoTien >= [self.mThongTinTaiKhoanVi.nAmount doubleValue]) {
        [UIAlertView alert:@"Số dư trong tài khoản không đủ" withTitle:[@"thong_bao" localizableString] block:nil];
        return NO;
    }
    else if (fSoTien > [self.mThongTinTaiKhoanVi.nHanMucDenTaiKhoan doubleValue]) {
        [UIAlertView alert:@"Số tiền chuyển đi vượt quá hạn mức. Bạn có thể thay đổi hạn mức tại mục Thay đổi" withTitle:[@"thong_bao" localizableString] block:nil];
        return NO;
    }
    return flg;
}

- (void)xuLyThucHienKhiKiemTraThanhCongTraVeToken:(NSString*)sToken otp:(NSString*)sOtp
{
    self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_CHUYEN_TIEN_VE_TAI_KHOAN_NGAN_HANG;
    NSString *sBankCode = @"";
    NSString *sBrachName = @"";
    NSString *sBrachCode = @"";
    if(mViTriNganHangDuocChon > -1)
    {
        Banks *bank = [_mDanhSachNganHang objectAtIndex:mViTriNganHangDuocChon];
        sBankCode = bank.bank_sms;
        if ([bank.bank_name hasPrefix:@"AGR"] && arrChiNhanhBank) {
            if ([mtfChiNhanh.text isEqualToString:@"Chi nhánh khác"] && mtfChiNhanhKhac.text.isEmpty) {
                [mtfChiNhanhKhac setTextError:@"Vui lòng nhập tên chi nhánh"];
                [mtfChiNhanhKhac show_error];
                return;
            }
            for (int i = 0; i < arrChiNhanhBank.count; i+=2) {
                NSString *sTemp = [arrChiNhanhBank objectAtIndex:i];
                if ([sTemp isEqualToString:[mtfChiNhanh.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]) {
                    sBrachName = [arrChiNhanhBank objectAtIndex:i];
                    sBrachCode = [arrChiNhanhBank objectAtIndex:(i + 1)];
                    break;
                }
            }
            if (sBrachName.isEmpty || [sBrachCode isEqualToString:@"11111111"]) {
                sBrachName = [mtfChiNhanhKhac.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                sBrachCode = [arrChiNhanhBank objectAtIndex:arrChiNhanhBank.count - 1];
            }
        }
    }
    double fSoTien = [[[_edtSoTien.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self hienThiLoading];
    }
    [GiaoDichMang ketNoiChuyenTienDenTaiKhoanNganHangThemChiNhanh:_edtSoTaiKhoan.text bankCode:sBankCode brachName:sBrachName brachCode:sBrachCode tenChuTaiKhoan:_edtTenChuTaiKhoan.text noiDungChuyenTien:_tvNoiDung.text soTien:fSoTien token:sToken otp:sOtp typeAuthenticate:self.mTypeAuthenticate noiNhanKetQua:self];
    
//    [GiaoDichMang ketNoiChuyenTienDenTaiKhoanNganHang:_edtSoTaiKhoan.text
//                                             bankCode:sBankCode
//                                       tenChuTaiKhoan:_edtTenChuTaiKhoan.text
//                                    noiDungChuyenTien:_tvNoiDung.text
//                                               soTien:fSoTien
//                                                token:sToken
//                                                  otp:sOtp
//                                     typeAuthenticate:self.mTypeAuthenticate
//                                        noiNhanKetQua:self];
    
}

- (void)xuLyKetNoiThanhCong:(NSString*)sDinhDanhKetNoi thongBao:(NSString*)sThongBao ketQua:(id)ketQua
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self anLoading];
    }
    if([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_CHUYEN_TIEN_VE_TAI_KHOAN_NGAN_HANG])
    {
        [self hienThiHopThoaiMotNutBamKieu:HOP_THOAI_XAC_NHAN_CHUYEN_TIEN_THANH_CONG cauThongBao:sThongBao];
    }
}


#pragma mark - sự kiện

- (IBAction)editSoTien:(id)sender
{
    NSString *sText = [Common hienThiTienTeFromString:[_edtSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""]];
    _edtSoTien.text = sText;
    NSString *sSoTien = [[sText componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
    
    if(![CommonUtils isEmptyOrNull:self.mThongTinTaiKhoanVi.pki3] && [self.mThongTinTaiKhoanVi.hanMucPki3 doubleValue] >0 ){
        if([sSoTien doubleValue] > [self.mThongTinTaiKhoanVi.hanMucPki3 doubleValue]){
            self.mbtnSMS.hidden = YES;
            self.mbtnToken.hidden = YES;
            self.mbtnEmail.hidden = YES;
            self.mbtnPKI.hidden = NO;
        }
        else{
            self.mbtnSMS.hidden = NO;
            
            self.mbtnToken.hidden = NO;
            
            self.mbtnEmail.hidden = NO;
            
            self.mbtnPKI.hidden = NO;
        }
    }
    else{
        self.mbtnPKI.hidden = YES;
        self.mbtnToken.hidden = NO;
        self.mbtnSMS.hidden = NO;
        self.mbtnEmail.hidden = NO;
    }
    [self xuLyHienThiSoTienPhiCuaSoTien:sSoTien];
}

- (IBAction)suKienLuuTaiKhoanThuongDung:(id)sender
{
    [self themTaiKhoanThuongDung];
}

- (IBAction)suKienLayDanhSachThuongDung:(id)sender {
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return;
    }
    DucNT_DanhSachTaiKhoanThuongDungControllerViewController *vc = [[DucNT_DanhSachTaiKhoanThuongDungControllerViewController alloc] initWithType:TAI_KHOAN_NGAN_HANG];
    [self.navigationController presentViewController:vc animated:YES completion:^{}];
    [vc release];
}


#pragma mark - xuLy

-(void)updateThongTin:(NSNotification *)notification
{
    if([[notification name] isEqualToString:KEY_TAI_KHOAN_THUONG_DUNG])
    {
        self.mTaiKhoanThuongDung = [notification object];
        [self xuLyCapNhatTaiKhoanThuongDung];
    }
    else
    {
        NSLog(@"%s >> %s line: %d >> ko nhan notification ",__FILE__,__FUNCTION__ ,__LINE__);
    }
}

- (void)xuLyHienThiSoTienPhiCuaSoTien:(NSString*)sSoTien
{
    NSString *sBankCode = @"";
    if(mViTriNganHangDuocChon > -1)
    {
        Banks *bank = [_mDanhSachNganHang objectAtIndex:mViTriNganHangDuocChon];
        sBankCode = bank.bank_sms;
    }
    double fSoPhi = [Common layPhiChuyenTienCuaSoTien:[sSoTien doubleValue] kieuChuyenTien:KIEU_CHUYEN_TIEN_DEN_TAI_KHOAN_NGAN_HANG maNganHang:sBankCode];
    self.mtfPhiGiaoDich.text = [Common hienThiTienTe_1:fSoPhi];
}

#pragma mark - sửa giao diện nếu là edit
- (void)xuLyCapNhatTaiKhoanThuongDung
{
    if(_mTaiKhoanThuongDung.nAmount > 0)
        _edtSoTien.text = [Common hienThiTienTe:_mTaiKhoanThuongDung.nAmount];
    else
        _edtSoTien.text = @"";
    _edtTenChuTaiKhoan.text = _mTaiKhoanThuongDung.sAccOwnerName;
    _edtSoTaiKhoan.text = _mTaiKhoanThuongDung.sBankNumber;

    for(int i = 0; i < _mDanhSachNganHang.count; i++)
    {
        Banks *bank = [_mDanhSachNganHang objectAtIndex:i];
        NSLog(@"%s - [bank.bank_id intValue] : %d", __FUNCTION__, [bank.bank_id intValue]);
        if([bank.bank_id intValue] == _mTaiKhoanThuongDung.nBankId)
        {
            NSString *sTenNganHang = bank.bank_name;
            _edtNganHang.text = sTenNganHang;
            mViTriNganHangDuocChon = i;
            if ([bank.bank_id intValue] == 1) {
                [self hienThiGiaoDienThemChiNhanh];
                NSLog(@"%s - _mTaiKhoanThuongDung.maChiNhanh : %@", __FUNCTION__, _mTaiKhoanThuongDung.maChiNhanh);
                if(_mTaiKhoanThuongDung.maChiNhanh.length > 0){
//                    if ([_mTaiKhoanThuongDung.maChiNhanh isEqualToString:@"11111111"]) {
//                        mtfChiNhanh.text = @"Chi nhánh khác";
//                    }
//                    else {
                        for (int i = 0; i < arrChiNhanhBank.count; i++) {
                            NSString *sChiNhanhTemp = [arrChiNhanhBank objectAtIndex:i];
                            NSLog(@"%s - _mTaiKhoanThuongDung.maChiNhanh : %@ - sChiNhanhTemp : %@", __FUNCTION__, _mTaiKhoanThuongDung.maChiNhanh, sChiNhanhTemp);
                            if (i > 0 && [sChiNhanhTemp isEqualToString:_mTaiKhoanThuongDung.maChiNhanh]) {
                                mtfChiNhanh.text = [arrChiNhanhBank objectAtIndex:i - 1];
                                break;
                            }
                        }
//                    }
                }
            }
            break;
        }
    }
    
    _tvNoiDung.text = _mTaiKhoanThuongDung.sDesc;
    [self xuLyHienThiSoTienPhiCuaSoTien:[NSString stringWithFormat:@"%f", _mTaiKhoanThuongDung.nAmount]];
}


-(void)themTaiKhoanThuongDung
{
    if([self validateVanTay] && !mViewNhapTenDaiDien.superview)
    {
        if(!_mTaiKhoanThuongDung)
            _mTaiKhoanThuongDung = [[DucNT_TaiKhoanThuongDungObject alloc] init];
        
        mViewNhapTenDaiDien.frame = self.view.bounds;
        _mTaiKhoanThuongDung.sBankNumber = _edtSoTaiKhoan.text;
        _mTaiKhoanThuongDung.nAmount = [[_edtSoTien.text stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [_edtSoTien.text length])] doubleValue];
        _mTaiKhoanThuongDung.sDesc = _tvNoiDung.text;
        _mTaiKhoanThuongDung.sPhoneOwner = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
        _mTaiKhoanThuongDung.nType = TAI_KHOAN_NGAN_HANG;
        _mTaiKhoanThuongDung.sAccOwnerName = _edtTenChuTaiKhoan.text;
        if(mViTriNganHangDuocChon > -1)
        {
            Banks *bank = [_mDanhSachNganHang objectAtIndex:mViTriNganHangDuocChon];
            NSLog(@"ChuyenTienDenTaiKhoanViewController : themTaiKhoanThuongDung : bank name : %@", bank.bank_name);
            _mTaiKhoanThuongDung.sBankName = bank.bank_name;
            _mTaiKhoanThuongDung.nBankCode = bank.bank_code.intValue;
            _mTaiKhoanThuongDung.nBankId = bank.bank_id.intValue;
            if ([bank.bank_name hasPrefix:@"AGR"]) {
                if (mtfChiNhanh.text.length == 0) {
                    [mtfChiNhanh setTextError:@"Vui lòng chọn chi nhánh"];
                    [mtfChiNhanh show_error];
                    return;
                }
                _mTaiKhoanThuongDung.sBranchName = [mtfChiNhanh.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                if (arrChiNhanhBank) {
                    for (int i = 0; i < arrChiNhanhBank.count; i+= 2) {
                        NSString *sTemp = [arrChiNhanhBank objectAtIndex:i];
                        if([sTemp isEqualToString:[mtfChiNhanh.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]){
                            _mTaiKhoanThuongDung.sBranchCode = [arrChiNhanhBank objectAtIndex:(i + 1)];
                            break;
                        }
                    }
                    if (_mTaiKhoanThuongDung.sBranchCode.isEmpty) {
                        _mTaiKhoanThuongDung.sBranchCode = [arrChiNhanhBank objectAtIndex:arrChiNhanhBank.count - 1];
                    }
                }
            }
        }

        mViewNhapTenDaiDien.mTaiKhoanThuongDung = _mTaiKhoanThuongDung;
        mViewNhapTenDaiDien.mThongTinVi = self.mThongTinTaiKhoanVi;
        
        [self.view addSubview:mViewNhapTenDaiDien];
        [self.view endEditing:YES];
    }
}

#pragma mark - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [viewQC release];
    [_edtNganHang release];
    [_edtTenChuTaiKhoan release];
    [_edtSoTaiKhoan release];
    [_edtSoTien release];
    [_tvNoiDung release];
    [_btnLuuTaiKhoanThuongDung release];
    if(_mDanhSachNganHang)
        [_mDanhSachNganHang release];
    if(mViewPickerNganHang)
        [mViewPickerNganHang release];
    [_mtfPhiGiaoDich release];
    [_mlblPhi release];
    [mScrv release];
    [_viewThongTin release];
    [_viewToken release];
    [_viewButtonOption release];
    [_mtfNoiDug release];
    if (arrChiNhanhBank) {
        [arrChiNhanhBank release];
    }
    [mtfChiNhanh release];
    [mtfChiNhanhKhac release];
    [_scrMain release];
    [_viewTaiKhoan release];
    [_heightViewMain release];
    [super dealloc];
}

@end
