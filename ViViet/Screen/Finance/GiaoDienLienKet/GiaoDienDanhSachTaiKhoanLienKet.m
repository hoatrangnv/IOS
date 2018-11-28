//
//  GiaoDienDanhSachTaiKhoanLienKet.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 10/11/16.
//
//

#import "GiaoDienDanhSachTaiKhoanLienKet.h"
#import "DucNT_TaiKhoanThuongDungCell.h"
#import "ViewXacThuc.h"
#import "DialogXoaTKLienketViewController.h"
@interface GiaoDienDanhSachTaiKhoanLienKet () <TaiKhoanThuongDungCellDelegate, ViewXacThucDelegate>{
    NSMutableArray *arrTaiKhoan;
    int nIndexDelete;
}
@property (nonatomic, retain) ViewXacThuc *mViewXacThuc;
@end

@implementation GiaoDienDanhSachTaiKhoanLienKet

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"DucNT_TaiKhoanThuongDungCell" bundle:nil] forCellReuseIdentifier:@"DucNT_TaiKhoanThuongDungCellId"];
    [self layDanhSachTaiKhoanLienKet];
}

- (void)layDanhSachTaiKhoanLienKet {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self hienThiLoading];
    }
    self.mDinhDanhKetNoi = @"LAY_DANH_SACH_LIEN_KET";
    [GiaoDichMang layDanhSachTaiKhoanLienKet:self];
}

#pragma mark - Xu ly ket noi thanh cong
- (void)xuLyKetNoiThanhCong:(NSString*)sDinhDanhKetNoi thongBao:(NSString*)sThongBao ketQua:(id)ketQua
{
//    NSLog(@"%s - sDinhDanhKetNoi : %@", __FUNCTION__, sDinhDanhKetNoi);
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self anLoading];
    }
    if ([sDinhDanhKetNoi isEqualToString:@"LAY_DANH_SACH_LIEN_KET"]) {
        NSLog(@"%s - self.nType : %d", __FUNCTION__, self.nType);
        if (!arrTaiKhoan) {
            arrTaiKhoan = [[NSMutableArray alloc] init];
        }
        [arrTaiKhoan removeAllObjects];
        NSArray *arrTemp = (NSArray *)ketQua;
        for (NSDictionary *dict in arrTemp) {
            ItemTaiKhoanLienKet *item = [[ItemTaiKhoanLienKet alloc] khoiTao:dict];
            if (self.nType == 1 && [item.soThe isEmpty]) {
                NSLog(@"%s - item : %@", __FUNCTION__, item.soThe);
                [arrTaiKhoan addObject:item];
            }
            else if(self.nType != 1){
                [arrTaiKhoan addObject:item];
            }
        }
        [self.tableView reloadData];
    }
    else if ([sDinhDanhKetNoi isEqualToString:@"XOA_TAI_KHOAN_LIEN_KET"]) {
        [arrTaiKhoan removeObjectAtIndex:nIndexDelete];
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (arrTaiKhoan) ? arrTaiKhoan.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sReuseId = @"DucNT_TaiKhoanThuongDungCellId";
    DucNT_TaiKhoanThuongDungCell *cell = [tableView dequeueReusableCellWithIdentifier:sReuseId];
    if (cell == nil) {
        cell = [[DucNT_TaiKhoanThuongDungCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sReuseId];
    }
    ItemTaiKhoanLienKet *item = [arrTaiKhoan objectAtIndex:indexPath.row];
    NSString *sDsBank = @"BID - Đầu tư và phát triển Việt Nam/CTG - Công thương Việt Nam/VCB - Ngoại thương Việt Nam/ABB - An bình/ACB - Á châu/BAB - Bắc á/BVB - Bảo Việt/EAB - Đông á/EIB - Xuất nhập khẩu Việt Nam/GPB - Dầu khí toàn cầu/HDB - Phát triển TPHCM/KLB - Kiên Long/LPB - Bưu điện Liên Việt/MB - Quân đội/MSB - Hàng hải/NAB - Nam á/NCB - Quốc dân/OCB -  Phương đông/OJB - Đại dương/PGB - Xăng dầu Petrolimex/PVB - Đại chúng Việt Nam/SCB - Sài Gòn/SEAB - Đông nam á/SGB - Sài Gòn công thương/SHB - Sài Gòn - Hà Nội/STB - Sài Gòn thương tín/TCB - Kỹ thương Việt Nam/TPB - Tiên Phong/VAB - Việt Á/VB - Việt Nam thương tín/VCCB - Bản Việt/VIB - Quốc tế/VPB - Việt Nam thịnh vượng/VISA/MasterCar/JCB";
    NSArray *arrTemp = [sDsBank componentsSeparatedByString:@"/"];
    for (NSString *sBank in arrTemp) {
        if ([sBank hasPrefix:item.maNganHang]) {
            cell.lbTenTaoKhoan.text = sBank;
            break;
        }
    }
    NSString *sImageName = [NSString stringWithFormat:@"%@.png", item.maNganHang.lowercaseString];
    if (![item.soThe isEmpty]) {
        sImageName = [NSString stringWithFormat:@"%@-the", item.maNganHang.lowercaseString];
        cell.imvLoaiTaiKhoan.image = [UIImage imageNamed:sImageName];
    }
    else{
        sImageName = [NSString stringWithFormat:@"%@-nh", item.maNganHang.lowercaseString];
        cell.imvLoaiTaiKhoan.image = [UIImage imageNamed:sImageName];
    }
    cell.lbTenTaoKhoan.textColor = [UIColor blackColor];
    cell.delegate = self;
    if (self.bChinhSua) {
        cell.btnEdit.hidden = YES;
        cell.btnEdit.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate) {
        ItemTaiKhoanLienKet *item = [arrTaiKhoan objectAtIndex:indexPath.row];
        NSLog(@"%s - item : %@", __FUNCTION__, [item toDict]);
        [self.delegate suKienChinhSuaTaiKhoanLienKet:item];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - DucNT_TaiKhoanThuongDungDelegate
-(void)deleteCell:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    nIndexDelete = (int)indexPath.row;
//    [self khoiTaoViewXacThuc];
//    [self hienThiViewXacThuc];
    DialogXoaTKLienketViewController * dialog = [[DialogXoaTKLienketViewController alloc] initWithNibName:@"DialogXoaTKLienketViewController" bundle:nil];
    [dialog removeFromParentViewController];
    dialog.view.frame = [UIScreen mainScreen].bounds;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:dialog.view];
    [self addChildViewController:dialog];
    DucNT_TaiKhoanThuongDungCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    [dialog setitleLable:[NSString stringWithFormat:@"Xóa %@",cell.lbTenTaoKhoan.text]];
}

-(void)editCell:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    NSLog(@"%s - indexPath : %@", __FUNCTION__, indexPath);
    if (self.delegate) {
        ItemTaiKhoanLienKet *item = [arrTaiKhoan objectAtIndex:indexPath.row];
        NSLog(@"%s - item : %@", __FUNCTION__, [item toDict]);
        [self.delegate suKienChinhSuaTaiKhoanLienKet:item];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - xu Ly view xac thuc
- (void)khoiTaoViewXacThuc
{
    if(!_mViewXacThuc)
    {
        self.mViewXacThuc = [[[NSBundle mainBundle] loadNibNamed:@"ViewXacThuc" owner:self options:nil] objectAtIndex:0];
        self.mViewXacThuc.mDelegate = self;
        self.mViewXacThuc.mThongTinVi = self.mThongTinTaiKhoanVi;
        self.mViewXacThuc.frame = self.view.bounds;

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
    if(!_mViewXacThuc.superview)
        [self.view addSubview:_mViewXacThuc];
    _mViewXacThuc.hidden = NO;
}

- (void)xuLySuKienXacThucVoiKieu:(NSInteger)nKieuXacThuc token:(NSString*)sToken otp:(NSString*)sOtp {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self hienThiLoadingChuyenTien];
    }
    ItemTaiKhoanLienKet *item = [arrTaiKhoan objectAtIndex:nIndexDelete];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:item.sId forKey:@"id"];
    [dic setValue:item.idVi forKey:@"idVi"];
    [dic setValue:sToken forKey:@"token"];
    [dic setValue:sOtp forKey:@"otpConfirm"];
    [dic setValue:[NSNumber numberWithInteger:nKieuXacThuc] forKey:@"typeAuthenticate"];
    [dic setValue:[NSNumber numberWithInt:APP_ID] forKey:@"appId"];
    [dic setValue:[NSNumber numberWithInt:VM_APP] forKey:@"VMApp"];
    self.mDinhDanhKetNoi = @"XOA_TAI_KHOAN_LIEN_KET";
    [GiaoDichMang xoaTaiKhoanLienKet:[dic JSONString] noiNhanKetQua:self];
}

- (void)xuLySuKienBamNutVanTay {
    [self xuLySuKienDangNhapVanTay];
}

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

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
- (IBAction)suKienChonNutBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
