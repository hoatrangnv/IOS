//
//  HienThiDanhSachTinQuangBaViewController.m
//  BIDV
//
//  Created by Mac Mini on 9/22/14.
//
//

#import "HienThiDanhSachTinQuangBaViewController.h"
#import "HienThiNotificationTableViewCell.h"
#import "HienThiChiTietNotificationViewController.h"
#import "DichVuNotification.h"
#import "DoiTuongNotification.h"
#import "GiaoDichMang.h"
#import "DucNT_TaiKhoanThuongDungObject.h"
#import "DucNT_ChuyenTienViDenViViewController.h"
#import "TraCuuTienDienViewController.h"
#import "DoiTuongThanhToanCuocDienThoaiViettel.h"
#import "ThanhToanDienThoaiViettelViewController.h"
#import "DoiTuongGiaoDich.h"
#import "ChiTietDuyetGiaoDichViewController.h"
#import "ThanhToanDienThoaiKhacViewController.h"
#import "GiaoDienThanhToanSauTraCuuInternet.h"
#import "GiaoDienThanhToanNuoc.h"
#import "GiaoDienTraCuuTruyenHinh.h"
#import "GiaoDienTraCuuTienVay.h"
#import "Reachability.h"
#import "MenuThongBaoCell.h"

#define DINH_DANH_KET_NOI_LAY_CHI_TIET_TIN_DUYET_GIAO_DICH @"DINH_DANH_KET_NOI_LAY_CHI_TIET_TIN_DUYET_GIAO_DICH"

typedef enum : int {
    ENUM_THONG_BAO_ALL = 0,
    ENUM_THONG_BAO_QUANG_CAO = 2,
    ENUM_THONG_BAO_GIAO_DICH = 1,
    ENUM_THONG_BAO_GD_TAI_CHINH = 3,
    ENUM_THONG_BAO_TT_HOA_DON = 4,
    ENUM_THONG_BAO_GD_MUA_VE = 5,
    ENUM_THONG_BAO_GD_MUA_SAM = 6,
    ENUM_THONG_BAO_GD_KHAC = 7,
} ENUM_THONG_BAO;

@interface HienThiDanhSachTinQuangBaViewController () <UITableViewDataSource, UITableViewDelegate, DucNT_ServicePostDelegate, HienThiNotificationTableViewCellDelegate, UIScrollViewDelegate, HienThiChiTietNotificationViewControllerDelegate>
{
    NSMutableArray *mDanhSachTinQuangBa;
    BOOL mTrangThaiXoa;
    int mViTriBatDauLayTin;
    int mSoLuongTinCanLay;
    int mViTriTinCanXoa;
    IBOutlet UITableView *mtbHienThi;
    NSString *mDinhDanhKetNoi;
    BOOL mTrangThaiReload;
    BOOL mTrangThaiDanhDauTinDaDoc;
    BOOL mDuocPhepLayThemDuLieu;
    UIRefreshControl *mRefreshControl;
    int mViTriTinMuonTien;
    int mViTriTinHoaDonDien;
    int nKieuThongBaoDangChon;
    NSArray *arrMenu;
}
@property (nonatomic, retain) DucNT_TaiKhoanThuongDungObject *mTaiKhoanThuongDung;
@property (nonatomic, retain) NSMutableArray *mDanhSachTinCanXoa;

@end

@implementation HienThiDanhSachTinQuangBaViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.mDanhSachTinCanXoa = [[NSMutableArray alloc] init];
        mRefreshControl = [[UIRefreshControl alloc] init];
        mDanhSachTinQuangBa = [[NSMutableArray alloc] init];
        [self khoiTaoBanDau];
    }
    return self;
}

- (void)khoiTaoBanDau {
    mViTriBatDauLayTin = 0;
    mSoLuongTinCanLay = 50;
    mTrangThaiXoa = NO;
    mTrangThaiReload = NO;
    mTrangThaiDanhDauTinDaDoc = YES;
    mDuocPhepLayThemDuLieu = NO;
    mViTriTinCanXoa = -1;
    mViTriTinMuonTien = -1;
    mViTriTinHoaDonDien = -1;
}

#pragma mark - life circle
- (void)viewDidLoad
{
    [super viewDidLoad];
//
    arrMenu = @[@{@"name":@"Tất cả thông báo", @"icon":@"icon-tacathongbao-trang"}, @{@"name":@"Thông tin, quảng cáo", @"icon":@"icon-thongtinquangcao-trang"}, @{@"name":@"Tất cả giao dịch", @"icon":@"icon-tatcagiaodich-trang"}, @{@"name":@"Giao dịch tài chính", @"icon":@"icon-giaodichtaichinh-trang"}, @{@"name":@"Thanh toán hoá đơn", @"icon":@"icon-thanhtoanhoadon-trang"}, @{@"name":@"Giao dịch mua vé", @"icon":@"icon-muave-trang"}, @{@"name":@"Giao dịch mua sắm", @"icon":@"icon-muasam-trang"}, @{@"name":@"Giao dịch khác", @"icon":@"icon-khac-trang"}];
    nKieuThongBaoDangChon = ENUM_THONG_BAO_ALL;
    
    mtbHienThi.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableMenu registerNib:[UINib nibWithNibName:@"MenuThongBaoCell" bundle:nil] forCellReuseIdentifier:@"MenuThongBaoCell"];
    [self.tableMenu setHidden:YES];
    self.tableMenu.alwaysBounceVertical = NO;
    [mtbHienThi setDataSource:self];
    [mtbHienThi setDelegate:self];
    mtbHienThi.allowsMultipleSelectionDuringEditing = NO;
    
    [mRefreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    [mtbHienThi addSubview:mRefreshControl];
    [self khoiTaoThanhBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self kiemTraKetNoiMang];
    [self khoiTaoDanhSachTinQuangBa];
    if(mTrangThaiReload)
    {
        [self khoiTaoDanhSachTinQuangBa];
    }
//    [self refreshData];
}

- (void)kiemTraKetNoiMang {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];

    NetworkStatus status = [reachability currentReachabilityStatus];

    if(status == NotReachable)
    {
        mSoLuongTinCanLay = 20;
    }
    else if (status == ReachableViaWiFi)
    {
        NSLog(@"%s - internet la wifi", __FUNCTION__);
        mSoLuongTinCanLay = 20;
    }
    else if (status == ReachableViaWWAN)
    {
        NSLog(@"%s - internet la 3G", __FUNCTION__);
        mSoLuongTinCanLay = 10;
    }
}

#pragma mark - overriden basesceen
- (void)reloadGiaoDien:(NSNotification *)notification
{
    [mtbHienThi reloadData];
}

#pragma mark - khoiTao
- (void)khoiTaoThanhBar
{
    self.navigationItem.title = [@"thong_bao" localizableString];
    UIBarButtonItem *btnDelete = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_del"] style:UIBarButtonItemStyleDone target:self action:@selector(suKienBamNutXoaTin:)];
    btnDelete.imageInsets = UIEdgeInsetsMake(0.0, 20.0, 0.0, 0.0);
    
    UIBarButtonItem *barButtonMore = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_more"] style:UIBarButtonItemStylePlain target:self action:@selector(suKienBamNutMore:)];
    self.navigationItem.rightBarButtonItems = @[barButtonMore, btnDelete];
    
//    [self addTitleView:@"Thông báo"];
//    [self addButton:@"ic_action_delete" selector:@selector(suKienBamNutXoaTin) atSide:1];
//    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(0, 0, 36, 36);
//    button.backgroundColor = [UIColor clearColor];
//    [button addTarget:self action:@selector(suKienBamNutXoaTin) forControlEvents:UIControlEventTouchUpInside];
//
//    [button setImage:[UIImage imageNamed:@"ic_action_delete"] forState:UIControlStateNormal];
//    button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
//
//    UIBarButtonItem *rightItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
//    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//
//    if (SYSTEM_VERSION_LESS_THAN(@"11"))
//        negativeSeperator.width = -10;
//    else {
//        negativeSeperator.width = -15;
//        [button.widthAnchor constraintEqualToConstant:34].active = YES;
//        [button.heightAnchor constraintEqualToConstant:34].active = YES;
//    }
//
//    if(mTrangThaiXoa)
//    {
//        UIButton * button2 = [UIButton buttonWithType:UIButtonTypeCustom];
//        button2.frame = CGRectMake(0, 0, 32, 32);
//        button2.backgroundColor = [UIColor clearColor];
//        [button2 addTarget:self action:@selector(suKienChonTatCa) forControlEvents:UIControlEventTouchUpInside];
//        [button2 setImage:[UIImage imageNamed:@"tickall48"] forState:UIControlStateNormal];
//        button2.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
//        UIBarButtonItem *rightItem2 = [[[UIBarButtonItem alloc] initWithCustomView:button2] autorelease];
//        self.navigationItem.rightBarButtonItems = @[negativeSeperator, rightItem, rightItem2];
//    }
//    else
//    {
//        self.navigationItem.rightBarButtonItems = @[negativeSeperator, rightItem];
//    }
}

- (void)khoiTaoDanhSachTinQuangBa
{
    //TODO: HIEUTRINH COMMENT
//    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
//        [self hienThiLoadingChuyenTien];
//    }
    NSString *sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    if(sTaiKhoan)
        sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LAST_ID_LOGIN];
    mDinhDanhKetNoi = DINH_DANH_LAY_DANH_SACH_TIN;
    nKieuThongBaoDangChon = 8;
    NSString *sKieuNhanThongBao = [NSString stringWithFormat:@"%d", nKieuThongBaoDangChon];
    [[DichVuNotification shareService] dichVuLayDanhSachTinNhanTrongChucNang:TIN_QUANG_BA thoiGian:1 viTriBatDau:mViTriBatDauLayTin soLuongTin:mSoLuongTinCanLay nguoiNhan:@"" kieuTimKiem:0 phanLoaiTinNhan:sKieuNhanThongBao noiNhanKetQua:self];
}

#pragma mark - suKien
- (void)chuyenTienDenVi
{
    DucNT_ChuyenTienViDenViViewController *chuyenTienViDenVi = [[DucNT_ChuyenTienViDenViViewController alloc] initWithNibName:@"DucNT_ChuyenTienViDenViViewController" bundle:nil];
    chuyenTienViDenVi.mTaiKhoanThuongDung = self.mTaiKhoanThuongDung;
    [self.navigationController pushViewController:chuyenTienViDenVi animated:YES];
    [chuyenTienViDenVi release];
}

- (void)refreshData
{
    mTrangThaiReload = YES;
    [mRefreshControl endRefreshing];
    mViTriBatDauLayTin = 0;
    [_mDanhSachTinCanXoa removeAllObjects];
    if(mDanhSachTinQuangBa)
        [mDanhSachTinQuangBa removeAllObjects];
    else
        mDanhSachTinQuangBa = [[NSMutableArray alloc] init];
    [mtbHienThi reloadData];
    [self khoiTaoDanhSachTinQuangBa];
}

- (void)suKienBamNutMore:(UIBarButtonItem *)sender {
    [self.tableMenu setHidden:!self.tableMenu.isHidden];
}

- (void)suKienBamNutXoaTin:(UIBarButtonItem *)sender
{
    if(!mTrangThaiXoa)
    {
        mTrangThaiXoa = YES;
        [mtbHienThi reloadData];
    }
    else if(mTrangThaiXoa && _mDanhSachTinCanXoa.count == 0)
    {
        mTrangThaiXoa = NO;
        [mtbHienThi reloadData];
    }
    else if(mTrangThaiXoa && _mDanhSachTinCanXoa.count > 0)
    {
        mDinhDanhKetNoi = DINH_DANH_XOA_TIN;
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for(DoiTuongNotification *doiTuong in _mDanhSachTinCanXoa)
            [arr addObject:doiTuong.alertId];
        [[DichVuNotification shareService] dichVuXoaTinNhan:arr noiNhanKetQua:self];
        [arr release];
    }
    else
    {
        mTrangThaiXoa = YES;
        [mtbHienThi reloadData];
    }
//    [self khoiTaoThanhBar];
}


- (void)suKienChonTatCa
{
    if(mTrangThaiXoa && _mDanhSachTinCanXoa.count < mDanhSachTinQuangBa.count)
    {
        //Chon tat ca
        self.mDanhSachTinCanXoa = [NSMutableArray arrayWithArray:mDanhSachTinQuangBa];
        [mtbHienThi reloadData];
    }
    else if(mTrangThaiXoa && _mDanhSachTinCanXoa.count == mDanhSachTinQuangBa.count)
    {
        //Bo chon tat ca
        [self.mDanhSachTinCanXoa removeAllObjects];
        [mtbHienThi reloadData];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableMenu) {
        return arrMenu.count;
    }
    if(mDanhSachTinQuangBa)
        return mDanhSachTinQuangBa.count;
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableMenu) {
        return 50.0;
    }
    DoiTuongNotification *notification = [mDanhSachTinQuangBa objectAtIndex:indexPath.row];
    int typeShow = [[notification typeShow] intValue];
    int statusShow = [[notification statusShow] intValue];
    if(typeShow == KIEU_NOTIFICATION_MUON_TIEN && statusShow == TRANG_THAI_SHOW_NOTIFICATION_CHUA_XU_LY)
    {
        return 140.0f;
    }
    return 110.0f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableMenu) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        DoiTuongNotification *doiTuongNotification = [mDanhSachTinQuangBa objectAtIndex:indexPath.row];
        mDinhDanhKetNoi = DINH_DANH_XOA_TIN;
        NSArray *arrayTinCanXoa = @[doiTuongNotification.alertId];
        [[DichVuNotification shareService] dichVuXoaTinNhan:arrayTinCanXoa noiNhanKetQua:self];
        mViTriTinCanXoa = (int)indexPath.row;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableMenu) {
        MenuThongBaoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuThongBaoCell" forIndexPath:indexPath];
        NSLog(@"%s- indexPath.row : %d", __FUNCTION__, (int)indexPath.row);
        NSDictionary *dict = [arrMenu objectAtIndex:indexPath.row];
        NSString *name = (NSString *)[dict valueForKey:@"name"];
        NSString *icon = (NSString *)[dict valueForKey:@"icon"];
        cell.titleLabel.text = name;
        cell.imageView.image = [UIImage imageNamed:icon];
        return cell;
    }
    
    static NSString *cellIndentifier = @"cellIndentifier";
    HienThiNotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if(!cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"HienThiNotificationTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.mDelegate = self;
    }
    
    DoiTuongNotification *notification = [mDanhSachTinQuangBa objectAtIndex:indexPath.row];
    cell.mDoiTuongNotification = notification;
    cell.mTrangThaiXoa = mTrangThaiXoa;
    
    BOOL co = [self.mDanhSachTinCanXoa containsObject:notification];
    if(co)
        [cell.mbtnDaiDien setImage:[UIImage imageNamed:@"icon_tick_thong_bao"] forState:UIControlStateNormal];
    cell.mViTri = (int)indexPath.row + 1;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableMenu) {
        [tableView setHidden:YES];
        
        int qcChoose = ENUM_THONG_BAO_ALL;
        switch (indexPath.row) {
            case 1:
                qcChoose = ENUM_THONG_BAO_QUANG_CAO;
                break;
            case 2:
                qcChoose = ENUM_THONG_BAO_GIAO_DICH;
                break;
            case 3:
                qcChoose = ENUM_THONG_BAO_GD_TAI_CHINH;
                break;
            case 4:
                qcChoose = ENUM_THONG_BAO_TT_HOA_DON;
                break;
            case 5:
                qcChoose = ENUM_THONG_BAO_GD_MUA_VE;
                break;
            case 6:
                qcChoose = ENUM_THONG_BAO_GD_MUA_SAM;
                break;
            case 7:
                qcChoose = ENUM_THONG_BAO_GD_KHAC;
                break;
                
            default:
                break;
        }
        if (qcChoose != nKieuThongBaoDangChon) {
            [mDanhSachTinQuangBa removeAllObjects];
            dispatch_async(dispatch_get_main_queue(), ^{
                [mtbHienThi reloadData];
            });
            nKieuThongBaoDangChon = qcChoose;
            [self khoiTaoBanDau];
            [self khoiTaoDanhSachTinQuangBa];
        }
        return;
    }
    if (!self.tableMenu.isHidden) {
        [self.tableMenu setHidden:YES];
        return;
    }
    
    DoiTuongNotification *doiTuongNotification = [mDanhSachTinQuangBa objectAtIndex:indexPath.row];
    NSLog(@"%s - doiTuongNotification.typeShow : %@", __FUNCTION__, doiTuongNotification.typeShow);
    if([doiTuongNotification.funcID intValue] != TYPE_SHOW_TRA_CUU_HOA_DON_DIEN  && [doiTuongNotification.typeShow intValue] != KIEU_NOTIFICATION_TIEN_TRUYEN_HINH && [doiTuongNotification.typeShow intValue] != TYPE_SHOW_HIEN_THI_THONG_BAO_DOANH_NGHIEP && [doiTuongNotification.typeShow intValue] != TYPE_SHOW_TRA_CUU_HOA_DON_INTERNET && [doiTuongNotification.typeShow intValue] != TYPE_SHOW_TRA_CUU_TRA_TIEN_VAY)
    {
        HienThiChiTietNotificationViewController *hienThiChiTietNotification = [[HienThiChiTietNotificationViewController alloc] initWithNibName:@"HienThiChiTietNotificationViewController" bundle:nil];
        hienThiChiTietNotification.mDoiTuongNotification = doiTuongNotification;
        hienThiChiTietNotification.mDelegate = self;
        [self.navigationController pushViewController:hienThiChiTietNotification animated:YES];
        [hienThiChiTietNotification release];
    }
    else if ([doiTuongNotification.typeShow intValue] == KIEU_NOTIFICATION_TRA_CUU_HOA_DON_VIETTEL) {
        HienThiChiTietNotificationViewController *hienThiChiTietNotification = [[HienThiChiTietNotificationViewController alloc] initWithNibName:@"HienThiChiTietNotificationViewController" bundle:nil];
        hienThiChiTietNotification.mDoiTuongNotification = doiTuongNotification;
        hienThiChiTietNotification.mDelegate = self;
        [self.navigationController pushViewController:hienThiChiTietNotification animated:YES];
        [hienThiChiTietNotification release];
    }
    else if([doiTuongNotification.typeShow intValue] == TYPE_SHOW_TRA_CUU_HOA_DON_INTERNET && ![doiTuongNotification.idShow isEqualToString:@"-1"]){
        GiaoDienThanhToanSauTraCuuInternet *vc = [[GiaoDienThanhToanSauTraCuuInternet alloc] initWithNibName:@"GiaoDienThanhToanSauTraCuuInternet" bundle:nil];
        vc.idTypeShow = doiTuongNotification.idShow;
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
    else if ([doiTuongNotification.typeShow intValue] == TYPE_SHOW_TRA_CUU_TRA_TIEN_VAY) {
        GiaoDienTraCuuTienVay *vc = [[GiaoDienTraCuuTienVay alloc] initWithNibName:@"GiaoDienTraCuuTienVay" bundle:nil];
        vc.sIdShow = doiTuongNotification.idShow;
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
    else
    {
        NSLog(@"%s - click click!!!!! Line : %d", __FUNCTION__, __LINE__);
        mViTriTinHoaDonDien = (int)indexPath.row;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
            [self hienThiLoadingChuyenTien];
        }
        mDinhDanhKetNoi = DINH_DANH_LAY_CHI_TIET_MOT_TIN;
        [[DichVuNotification shareService] dichVuLayChiTietMotTin:doiTuongNotification.alertId noiNhanKetQua:self];
        mTrangThaiReload = YES;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark - HienThiNotificationTableViewCellDelegate

- (void)xuLySuKienBamNutDaiDien:(UIButton*)sender
{
    if(mTrangThaiXoa)
    {
        mViTriTinCanXoa = (int)sender.tag - 1;
        DoiTuongNotification *doiTuongNotification = [mDanhSachTinQuangBa objectAtIndex:mViTriTinCanXoa];
        BOOL co = [self.mDanhSachTinCanXoa containsObject:doiTuongNotification];
        if(!co)
        {
            [self.mDanhSachTinCanXoa addObject:doiTuongNotification];
            [sender setImage:[UIImage imageNamed:@"icon_tick_thong_bao"] forState:UIControlStateNormal];
        }
        else
        {
            [self.mDanhSachTinCanXoa removeObject:doiTuongNotification];
            [sender setImage:[UIImage imageNamed:@"icon_un_tick_thong_bao"] forState:UIControlStateNormal];
        }

    }
}

-(void)xuLySuKienBamNutDongYMuonTienTai:(HienThiNotificationTableViewCell*)cell
{
    mViTriTinMuonTien = (int)[mtbHienThi indexPathForCell:cell].row;
    mDinhDanhKetNoi = DINH_DANH_LAY_CHI_TIET_TIN_MUON_TIEN;
    [GiaoDichMang ketNoiLayChiTietTinMuonTien:cell.mDoiTuongNotification.idShow noiNhanKetQua:self];
}

- (void)xuLySuKienBamNutTuChoiMuonTienTai:(HienThiNotificationTableViewCell*)cell
{
    mViTriTinMuonTien = (int)[mtbHienThi indexPathForCell:cell].row;
    mDinhDanhKetNoi = DINH_DANH_KET_NOI_XAC_NHAN_TIN_MUON_TIEN;
    int mTrangThaiHienThi = 0;
    cell.mDoiTuongNotification.statusShow = [NSNumber numberWithInt:mTrangThaiHienThi];
    [[DichVuNotification shareService] dichVuXacNhanTrangThaiTinNotificationMuonTien:cell.mDoiTuongNotification.alertId
                                                                           trangThai:mTrangThaiHienThi
                                                                       noiNhanKetQua:self];
}

#pragma mark - DucNT_ServicePostDelegate

- (void)ketNoiThanhCong:(NSString *)sKetQua
{
    NSLog(@"%s - mDinhDanhKetNoi : %@", __FUNCTION__, mDinhDanhKetNoi);
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
        [self anLoading];
    }
    mDuocPhepLayThemDuLieu = NO;
//    NSLog(@"%s - sKetQua : %@", __FUNCTION__, sKetQua);
    if ([mDinhDanhKetNoi isEqualToString:DINH_DANH_LAY_CHI_TIET_TIN_MUON_TIEN])
    {
        if(mViTriTinMuonTien > -1)
        {
            NSDictionary *dict = [sKetQua objectFromJSONString];
            DoiTuongNotification *doiTuong = [mDanhSachTinQuangBa objectAtIndex:mViTriTinMuonTien];
            mDinhDanhKetNoi = DINH_DANH_KET_NOI_XAC_NHAN_TIN_MUON_TIEN;
            _mTaiKhoanThuongDung = [[DucNT_TaiKhoanThuongDungObject alloc] init];
            [_mTaiKhoanThuongDung fillDataWithDictionary:dict loaiTaiKhoan:TAI_KHOAN_VI];
            int mTrangThaiHienThi = 1;
            doiTuong.statusShow = [NSNumber numberWithInt:mTrangThaiHienThi];
            [[DichVuNotification shareService] dichVuXacNhanTrangThaiTinNotificationMuonTien:doiTuong.alertId trangThai:mTrangThaiHienThi noiNhanKetQua:self];
            return;
        }
    }
    
    if(mTrangThaiReload)
        mTrangThaiReload = !mTrangThaiReload;
    
    NSDictionary *dicKetQua = [sKetQua objectFromJSONString];
    int nCode = [[dicKetQua objectForKey:@"msgCode"] intValue];
    NSString *message = [dicKetQua objectForKey:@"msgContent"];
    if(nCode == 1)
    {
        if([mDinhDanhKetNoi isEqualToString:DINH_DANH_LAY_DANH_SACH_TIN])
        {
            NSArray *results = [dicKetQua objectForKey:@"result"];
            NSLog(@"%s - results : %ld", __FUNCTION__, (long)results.count);
            for(NSDictionary *dict in results)
            {
                DoiTuongNotification *doiTuongNotification = [[DoiTuongNotification alloc] initWithDict:dict];
                [mDanhSachTinQuangBa addObject:doiTuongNotification];
                mViTriBatDauLayTin++;
                [doiTuongNotification release];
            }
            
            //Danh dau da doc
            if(mDanhSachTinQuangBa != nil && mDanhSachTinQuangBa.count > 0)
            {

//                if(!mTrangThaiDanhDauTinDaDoc)
//                {
//                    mDinhDanhKetNoi = DINH_DANH_XAC_NHAN_TIN_DA_DOC;
//                    DoiTuongNotification *doiTuongNotification = [mDanhSachTinQuangBa objectAtIndex:0];
//                    [[DichVuNotification shareService] dichVuDanhDauThoiGianDocTin:[doiTuongNotification.time longLongValue] trongChucNang:TIN_QUANG_BA doiTac:@"" noiNhanKetQua:self];
//                }
            }
            [[DichVuNotification shareService] luuSoLuongTinChuaDoc:@""];
            [mtbHienThi reloadData];
            long long milliseconds = (long long)([[NSDate date] timeIntervalSince1970] * 1000);
            [[DichVuNotification shareService] dichVuDanhDauAllTin:milliseconds trongChucNang:TIN_QUANG_BA noiNhanKetQua:nil];
        }
        else if ([mDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_XAC_NHAN_TIN_MUON_TIEN])
        {
            DoiTuongNotification *doiTuongNotification = [mDanhSachTinQuangBa objectAtIndex:mViTriTinMuonTien];
            if([doiTuongNotification.statusShow intValue] == 1)
                [self chuyenTienDenVi];
            [mtbHienThi reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:mViTriTinMuonTien inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
        else if([mDinhDanhKetNoi isEqualToString:DINH_DANH_XAC_NHAN_TIN_DA_DOC])
        {
            mTrangThaiDanhDauTinDaDoc = YES;
            [[DichVuNotification shareService] xacNhanDaDocTinTrongChucNang:TIN_QUANG_BA];
            [(AppDelegate*)[[UIApplication sharedApplication] delegate] reloadGiaoDienHome];
        }
        else if ([mDinhDanhKetNoi isEqualToString:DINH_DANH_XOA_TIN])
        {
            if(_mDanhSachTinCanXoa.count == 0)
            {
                if(mViTriTinCanXoa > -1 && mViTriTinCanXoa < mDanhSachTinQuangBa.count)
                {
                    [mDanhSachTinQuangBa removeObjectAtIndex:mViTriTinCanXoa];
                    [mtbHienThi deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:mViTriTinCanXoa inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [mtbHienThi reloadData];
                    mViTriTinCanXoa = - 1;
                    [(AppDelegate*)[[UIApplication sharedApplication] delegate] reloadGiaoDienHome];
                }
            }
            else
            {

                for(DoiTuongNotification *doiTuong in _mDanhSachTinCanXoa)
                {
                    NSInteger nViTriCanXoa = [mDanhSachTinQuangBa indexOfObject:doiTuong];
                    [mDanhSachTinQuangBa removeObjectAtIndex:nViTriCanXoa];
                    [mtbHienThi deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:nViTriCanXoa inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                [_mDanhSachTinCanXoa removeAllObjects];
                mTrangThaiXoa = NO;
                

                [mtbHienThi reloadData];
                mViTriTinCanXoa = - 1;
                [(AppDelegate*)[[UIApplication sharedApplication] delegate] reloadGiaoDienHome];
            }
        }
        else if ([mDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_LAY_CHI_TIET_TIN_DUYET_GIAO_DICH])
        {
            NSDictionary *result = [dicKetQua valueForKey:@"result"];
            if(result)
            {
                DoiTuongGiaoDich *doiTuongGiaoDich = [[DoiTuongGiaoDich alloc] initWithDict:result];
                ChiTietDuyetGiaoDichViewController *chiTietDuyetGiaoDichViewController = [[ChiTietDuyetGiaoDichViewController alloc] initWithNibName:@"ChiTietDuyetGiaoDichViewController" bundle:nil];
                chiTietDuyetGiaoDichViewController.mDoiTuongGiaoDich = doiTuongGiaoDich;
                [self.navigationController pushViewController:chiTietDuyetGiaoDichViewController animated:YES];
                [doiTuongGiaoDich release];
                [chiTietDuyetGiaoDichViewController release];
            }
            else {
                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Có lỗi trong quá trình lấy thông tin"];
            }

        }
        else if ([mDinhDanhKetNoi isEqualToString:DINH_DANH_LAY_CHI_TIET_MOT_TIN])
        {
            NSLog(@"%s - mViTriTinHoaDonDien : %d", __FUNCTION__, mViTriTinHoaDonDien);

            if(mViTriTinHoaDonDien > -1)
            {
                DoiTuongNotification *doiTuongNofitication = [mDanhSachTinQuangBa objectAtIndex:mViTriTinHoaDonDien];
                NSLog(@"%s - [doiTuongNofitication.typeShow intValue] : %d", __FUNCTION__, [doiTuongNofitication.typeShow intValue]);
                doiTuongNofitication.status = [NSNumber numberWithInt:1];
                [(AppDelegate*)[[UIApplication sharedApplication] delegate] reloadGiaoDienHome];
                [mtbHienThi reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:mViTriTinHoaDonDien inSection:0]] withRowAnimation:UITableViewRowAnimationFade];

                if(![doiTuongNofitication.idShow isEqualToString:@""] && [doiTuongNofitication.typeShow intValue] == KIEU_NOTIFICATION_TIEN_DIEN)
                {
                    TraCuuTienDienViewController *traCuuTienDienViewController = [[TraCuuTienDienViewController alloc] initWithNibName:@"TraCuuTienDienViewController" bundle: nil];
                    traCuuTienDienViewController.mIdShow = doiTuongNofitication.idShow;
                    [self.navigationController pushViewController:traCuuTienDienViewController animated:YES];
                    [traCuuTienDienViewController release];
                }
                else if (![doiTuongNofitication.idShow isEqualToString:@""] && [doiTuongNofitication.typeShow intValue] == KIEU_NOTIFICATION_TIEN_NUOC) {
                    GiaoDienThanhToanNuoc *vc = [[GiaoDienThanhToanNuoc alloc] initWithNibName:@"GiaoDienThanhToanNuoc" bundle:nil];
                    vc.mIdShow = doiTuongNofitication.idShow;
                    [self.navigationController pushViewController:vc animated:YES];
                    [vc release];
                }
                else if (![doiTuongNofitication.idShow isEqualToString:@""] && [doiTuongNofitication.typeShow intValue] == KIEU_NOTIFICATION_TIEN_TRUYEN_HINH) {
                    NSDictionary *result = [dicKetQua objectForKey:@"result"];
                    NSDictionary *aps = [result objectForKey:@"aps"];
                    doiTuongNofitication.alertContent = [aps objectForKey:@"alertContent"];
                    GiaoDienTraCuuTruyenHinh *vc = [[GiaoDienTraCuuTruyenHinh alloc] initWithNibName:@"GiaoDienTraCuuTruyenHinh" bundle:nil];
                    vc.mDoiTuongNotification = doiTuongNofitication;
                    [self.navigationController pushViewController:vc animated:YES];
                    [vc release];
                }
                else if (![doiTuongNofitication.idShow isEqualToString:@""] && [doiTuongNofitication.typeShow intValue] == KIEU_NOTIFICATION_TRA_CUU_HOA_DON_VIETTEL)
                {
                    NSString *idShow = doiTuongNofitication.idShow;
                    NSArray *arrTemp = [idShow componentsSeparatedByString:@"_"];
                    @try {
                        DoiTuongThanhToanCuocDienThoaiViettel *doiTuongThanhToanCuocDienThoaiViettel = [[DoiTuongThanhToanCuocDienThoaiViettel alloc] initWithMaGiaoDich:arrTemp[0] soDienThoai:arrTemp[1] tienCuocPhaiThanhToan:arrTemp[2]];
                        if([doiTuongThanhToanCuocDienThoaiViettel.tienCuocPhaiThanhToan doubleValue] > 0)
                        {
                            ThanhToanDienThoaiKhacViewController *tt = [[ThanhToanDienThoaiKhacViewController alloc] initWithNibName:@"ThanhToanDienThoaiKhacViewController" bundle:nil];
                            tt.mNhaMang = NHA_MANG_VIETTEL;
                            tt.mDoiTuongThanhToanCuocDienThoaiViettel = doiTuongThanhToanCuocDienThoaiViettel;
                            [self.navigationController pushViewController:tt animated:YES];
                            [doiTuongThanhToanCuocDienThoaiViettel release];
                            [tt release];
                        }
                        else
                        {
                            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:doiTuongNofitication.alertContent];
                        }
                    }
                    @catch (NSException *exception) {
                        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:doiTuongNofitication.alertContent];
                    }
                    @finally {
                        
                    }

                }
                else if (![doiTuongNofitication.idShow isEqualToString:@""] && [doiTuongNofitication.typeShow intValue] == TYPE_SHOW_HIEN_THI_THONG_BAO_DOANH_NGHIEP)
                {
                    mDinhDanhKetNoi = DINH_DANH_KET_NOI_LAY_CHI_TIET_TIN_DUYET_GIAO_DICH;
                    [GiaoDichMang ketNoiLayChiTietDuyetGiaoDich:doiTuongNofitication.idShow noiNhanKetQua:self];
                }
                else
                {
                    [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:doiTuongNofitication.alertContent];
                }

            }
        }
    }
    else
    {
        //Thong bao loi neu can
        if([mDinhDanhKetNoi isEqualToString:DINH_DANH_LAY_DANH_SACH_TIN] || [mDinhDanhKetNoi isEqualToString:DINH_DANH_XOA_TIN])
        {
            [UIAlertView alert:message withTitle:[@"thong_bao" localizableString] block:nil];
        }
    }
}

- (void)xuLyKetNoiThatBai:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua{
    mDuocPhepLayThemDuLieu = NO;
    [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
}

//- (void)ketNoiBatThanh{
//    
//    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
//        [self anLoading];
//    }
//}
#pragma mark - UIScrollViewDelegate

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    if (scrollView.contentOffset.y <= - 65.0f) {
//        [self reloadGiaoDien:nil];
//    }
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (endScrolling >= scrollView.contentSize.height)
    {
//        if(!mTrangThaiReload)
//        {
//            [self khoiTaoDanhSachTinQuangBa];
//        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableMenu) {
        return;
    }
    if (!self.tableMenu.isHidden) {
        [self.tableMenu setHidden:YES];
    }
    int nChieuCao = 60;
    if (mSoLuongTinCanLay == 15) {
        nChieuCao = 100;
    }
//    NSLog(@"%s - nChieuCao : %d", __FUNCTION__, nChieuCao);
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height + nChieuCao)
    {
        if (!mDuocPhepLayThemDuLieu)
        {
            mDuocPhepLayThemDuLieu = YES;
            if(!mTrangThaiReload)
            {
                [self khoiTaoDanhSachTinQuangBa];
            }
            else {
//                NSLog(@"%s --------------> mTrangThaiReload == YES", __FUNCTION__);
            }
            // call some method that handles more rows
        }
        else {
//            NSLog(@"%s --------------> mDuocPhepLayThemDuLieu == YES", __FUNCTION__);
        }
    }
    else {
//        NSLog(@"%s --------------> chieu cao chua du", __FUNCTION__);
    }
}


#pragma mark - HienThiChiTietNotificationViewControllerDelegate

- (void)layDuocChiTietTinNotification:(DoiTuongNotification *)doiTuongNotification
{
    doiTuongNotification.status = [NSNumber numberWithInt:1];
    NSInteger nIndex = [mDanhSachTinQuangBa indexOfObject:doiTuongNotification];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:nIndex inSection:0];
    [mtbHienThi reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)xacNhanTinMuonTien:(DoiTuongNotification*)doiTuongNotification
{
    NSInteger nIndex = [mDanhSachTinQuangBa indexOfObject:doiTuongNotification];
    [mtbHienThi reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:nIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}


#pragma mark - dealloc
-(void)dealloc
{
    if(_mDanhSachTinCanXoa)
        [_mDanhSachTinCanXoa release];
    if(_mTaiKhoanThuongDung)
        [_mTaiKhoanThuongDung release];
    [mRefreshControl release];
    [mDanhSachTinQuangBa release];
    [mtbHienThi release];
    [_tableMenu release];
    [super dealloc];
}

- (void)viewDidUnload {
    [mtbHienThi release];
    mtbHienThi = nil;
    [super viewDidUnload];
}
@end
