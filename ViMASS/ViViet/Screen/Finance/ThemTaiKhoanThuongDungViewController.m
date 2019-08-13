//
//  ThemTaiKhoanThuongDungViewController.m
//  ViViMASS
//
//  Created by DucBT on 1/21/15.
//
//

#import "ContactScreen.h"
#import "DucNT_LuuRMS.h"
#import "ExTextField.h"
#import "DucNT_ServicePost.h"
#import "TPKeyboardAvoidAcessory.h"
#import "ViewThuongDungChuyenTienDenThe.h"
#import "ViewThuongDungChuyenTienViDenVi.h"
#import "ViewThuongDungChuyenTienDenTaiKhoan.h"
#import "ThemTaiKhoanThuongDungViewController.h"
#import "ViewThuongDungChuyenTienDenTheRutTien.h"
#import "ViewThuongDungChuyenTienDenTaiKhoanRutTien.h"
#import "ViewThuongDungChuyenTienTanNha.h"
#import "ThemTaiKhoanThuongDungDienThoai.h"
#import "ViewThuongDungATM.h"
#import "ViewThuongDungCMND.h"
#import "GiaoDienDanhSachChiNhanhBank.h"
#import "ItemDiaDiemGiaoDich.h"
#import "ViewThuongDungViKhac.h"
#import "ViewThuongDungTietKiem.h"
#import "NganHangGuiTietKiem.h"
#import "ViewThuongDungTienDien.h"
#import "ViewThuongDungNuoc.h"
#import "ViewThuongDungInternet.h"
#import "ViewThuongDungMuonTien.h"

#define KHOANG_CANH_NGAN_NHAT_GIUA_VIEW_MAIN_VA_NUT_XAC_THUC_VAN_TAY 30.0f
#define KHOANG_CANH_GIUA_CAC_VIEW 8.0f
#define DO_CAO_CELL 44.0f

@interface ThemTaiKhoanThuongDungViewController () <UITableViewDataSource, UITableViewDelegate, DucNT_ServicePostDelegate, UIAlertViewDelegate, ViewThuongDungChuyenTienViDenViDelegate, ViewThuongDungCMNDDelegate, ViewThuongDungViKhacDelegate, ViewThuongDungTietKiemDelegate, ViewThuongDungInternetDelegate, ViewThuongDungMuonTienDelegate>
{
    ViewThuongDungChuyenTienDenTaiKhoan *mViewThuongDungChuyenTienDenTaiKhoan;
    ViewThuongDungChuyenTienDenTaiKhoanRutTien *mViewThuongDungChuyenTienDenTaiKhoanRutTien;
    ViewThuongDungChuyenTienDenThe *mViewThuongDungChuyenTienDenThe;
    ViewThuongDungChuyenTienDenTheRutTien *mViewThuongDungChuyenTienDenTheRutTien;
    ViewThuongDungChuyenTienViDenVi *mViewThuongDungChuyenTienViDenVi;
    ViewThuongDungChuyenTienViDenVi *mViewThuongDungChuyenTienViDenMomo;
    ViewThuongDungChuyenTienTanNha *mViewThuongDungChuyenTienTanNha;
    ThemTaiKhoanThuongDungDienThoai *viewThemDienThoai;
    ViewThuongDungATM *viewATM;
    ViewThuongDungCMND *viewCMND;
    ViewThuongDungViKhac *viewViKhac;
    ViewThuongDungTietKiem *viewTietKiem;
    ViewThuongDungTienDien *viewTienDien;
    ViewThuongDungNuoc *viewTienNuoc;
    ViewThuongDungInternet *viewInternet;
    ViewThuongDungMuonTien *viewMuonTien;
    NSTimer *mTimer;
    NSString *mDinhDanhKetNoi;
    int mTypeAuthenticate;

    NSInteger mKieuXacThuc;
    BOOL mXacThucVanTay;
}

@property (retain, nonatomic) IBOutlet UIView *mViewThayDoiThongTin;
@property (retain, nonatomic) IBOutlet UIView *mViewThoiGianConLai;
//@property (retain, nonatomic) IBOutlet UIView *mViewNhapToken;
@property (retain, nonatomic) IBOutlet UIView *mViewChonTenChucNang;
@property (retain, nonatomic) IBOutlet UITableView *mtbChonChucNang;
@property (retain, nonatomic) IBOutlet TPKeyboardAvoidAcessory *mscrvHienThi;

@property (retain, nonatomic) IBOutlet UIButton *mbtnVanTay;
@property (retain, nonatomic) IBOutlet ExTextField *mtfTenChucNangChuyenTien;
@property (retain, nonatomic) IBOutlet UILabel *mlblTieuDe;

//@property (retain, nonatomic) DucNT_TaiKhoanThuongDungObject *mTaiKhoanThuongDungDuocChon;
@property (retain, nonatomic) NSArray *mDanhSachMaChucNang;
@property (retain, nonatomic) NSArray *mDanhSachChucNang;
@property (assign, nonatomic) NSInteger mTongSoThoiGian;


@end

@implementation ThemTaiKhoanThuongDungViewController

@synthesize mbtnVanTay;

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
//    [self addBackButton:YES];
    [self addBack];
    [self khoiTaoBanDau];
    [self xuLyAnTableViewChonChucNang];
    [self khoiTaoGiaoDien];

}

- (void)addBack {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(-5, 0, 35, 44);
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(didSelectBackButton) forControlEvents:UIControlEventTouchUpInside];

    //    [button setImage:[UIImage imageNamed:@"login-btn-back-white.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
    button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    UIBarButtonItem *leftItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    leftItem.width = 35;

    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
        [button.widthAnchor constraintEqualToConstant:35].active = YES;
        [button.heightAnchor constraintEqualToConstant:44].active = YES;
        negativeSeperator.width = -15;
    }
    else {
        negativeSeperator.width = -10;
    }

    self.navigationItem.leftBarButtonItems = @[negativeSeperator, leftItem];
    [self add_transparent_baritem:YES];
    [self.navigationItem setHidesBackButton:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([self.mThongTinTaiKhoanVi.nIsToken intValue] > 0)
    {
        [self suKienBamNutXacThucBoiToken:self.mbtnToken];
    }
}

#pragma mark - khoiTao

- (void)khoiTaoBanDau
{
    NSLog(@"ThemTaiKhoanThuongDungViewController : khoiTaoBanDau : START");
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    if(_mTaiKhoanThuongDung)
    {
        self.navigationItem.title = @"Cập nhật sổ tay";
        self.mKieuThemTaiKhoanThuongDung = _mTaiKhoanThuongDung.nType;
        [self khoiTaoKhiThayDoiTaiKhoanThuongDung];
    }
    else
    {
        self.navigationItem.title = @"Thêm sổ tay";
//        self.mKieuThemTaiKhoanThuongDung = TAI_KHOAN_VI;
    }
    
    mXacThucVanTay = NO;
    [self.mViewMain.layer setCornerRadius:4.0f];
    [self.mViewMain.layer setMasksToBounds:YES];

    self.mtbChonChucNang.layer.borderWidth = 1.0;
    self.mtbChonChucNang.layer.borderColor = [UIColor lightGrayColor].CGColor;
    int nDoCao = self.mDanhSachChucNang.count * DO_CAO_CELL;
    self.mtbChonChucNang.contentSize = CGSizeMake(self.mtbChonChucNang.contentSize.width, nDoCao + 10);
    NSLog(@"ThemTaiKhoanThuongDungViewController : khoiTaoBanDau : END");
}

- (void)khoiTaoKhiThayDoiTaiKhoanThuongDung
{
    CGRect rViewThayDoiThongTin = self.mViewThayDoiThongTin.frame;
    CGRect rViewChonChucNang = self.mViewChonTenChucNang.frame;
    rViewThayDoiThongTin.origin.y = rViewChonChucNang.origin.y;
    self.mViewThayDoiThongTin.frame = rViewThayDoiThongTin;
    [self.mViewChonTenChucNang setHidden:YES];
}

- (void)khoiTaoGiaoDien
{
    NSLog(@"%s - self.mKieuThemTaiKhoanThuongDung : %ld", __FUNCTION__, (long)self.mKieuThemTaiKhoanThuongDung);
    if(self.mViewThayDoiThongTin.subviews.count > 0)
    {
        for(UIView *view in self.mViewThayDoiThongTin.subviews)
        {
            [view removeFromSuperview];
        }
    }

    CGRect rViewThayDoiThongTin = self.mViewThayDoiThongTin.frame;
    UIView *viewThemTaiKhoanThuongDung = nil;
    
    if(self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_VI)
    {
        if(!mViewThuongDungChuyenTienViDenVi)
        {
            mViewThuongDungChuyenTienViDenVi = [[[[NSBundle mainBundle] loadNibNamed:@"ViewThuongDungChuyenTienViDenVi" owner:self options:nil] objectAtIndex:0] retain];
            mViewThuongDungChuyenTienViDenVi.mDelegate = self;
        }
        if(_mTaiKhoanThuongDung)
            mViewThuongDungChuyenTienViDenVi.mTaiKhoanThuongDung = self.mTaiKhoanThuongDung;
        rViewThayDoiThongTin.size = mViewThuongDungChuyenTienViDenVi.frame.size;
        viewThemTaiKhoanThuongDung = mViewThuongDungChuyenTienViDenVi;
    }
    else if(self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_THE)
    {
        if(!mViewThuongDungChuyenTienDenThe)
        {
            mViewThuongDungChuyenTienDenThe = [[[[NSBundle mainBundle] loadNibNamed:@"ViewThuongDungChuyenTienDenThe" owner:self options:nil] objectAtIndex:0] retain];
        }
        rViewThayDoiThongTin.size = mViewThuongDungChuyenTienDenThe.frame.size;
        if(_mTaiKhoanThuongDung)
            mViewThuongDungChuyenTienDenThe.mTaiKhoanThuongDung = self.mTaiKhoanThuongDung;
        viewThemTaiKhoanThuongDung = mViewThuongDungChuyenTienDenThe;
    }
    else if(self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_NGAN_HANG)
    {
        if(!mViewThuongDungChuyenTienDenTaiKhoan)
        {
            mViewThuongDungChuyenTienDenTaiKhoan = [[[[NSBundle mainBundle] loadNibNamed:@"ViewThuongDungChuyenTienDenTaiKhoan" owner:self options:nil] objectAtIndex:0] retain];
        }
        rViewThayDoiThongTin.size = mViewThuongDungChuyenTienDenTaiKhoan.frame.size;
        if(_mTaiKhoanThuongDung)
            mViewThuongDungChuyenTienDenTaiKhoan.mTaiKhoanThuongDung = self.mTaiKhoanThuongDung;
        viewThemTaiKhoanThuongDung = mViewThuongDungChuyenTienDenTaiKhoan;
    }
    else if ( self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_NGAN_HANG_RUT_TIEN)
    {
        if(!mViewThuongDungChuyenTienDenTaiKhoanRutTien)
        {
            mViewThuongDungChuyenTienDenTaiKhoanRutTien = [[[[NSBundle mainBundle] loadNibNamed:@"ViewThuongDungChuyenTienDenTaiKhoanRutTien" owner:self options:nil] objectAtIndex:0] retain];
        }

        if(_mTaiKhoanThuongDung)
            mViewThuongDungChuyenTienDenTaiKhoanRutTien.mTaiKhoanThuongDung = self.mTaiKhoanThuongDung;
        
        rViewThayDoiThongTin.size = mViewThuongDungChuyenTienDenTaiKhoanRutTien.frame.size;
        viewThemTaiKhoanThuongDung = mViewThuongDungChuyenTienDenTaiKhoanRutTien;
    }
    else if ( self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_THE_RUT_TIEN)
    {
        if(!mViewThuongDungChuyenTienDenTheRutTien)
        {
            mViewThuongDungChuyenTienDenTheRutTien = [[[[NSBundle mainBundle] loadNibNamed:@"ViewThuongDungChuyenTienDenTheRutTien" owner:self options:nil] objectAtIndex:0] retain];
        }
        if(_mTaiKhoanThuongDung)
            mViewThuongDungChuyenTienDenTheRutTien.mTaiKhoanThuongDung = self.mTaiKhoanThuongDung;
        
        rViewThayDoiThongTin.size = mViewThuongDungChuyenTienDenTheRutTien.frame.size;
        viewThemTaiKhoanThuongDung = mViewThuongDungChuyenTienDenTheRutTien;
    }
    else if ( self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_MOMO)
    {
        if(!mViewThuongDungChuyenTienViDenMomo)
        {
            mViewThuongDungChuyenTienViDenMomo = [[[[NSBundle mainBundle] loadNibNamed:@"ViewThuongDungChuyenTienViDenVi" owner:self options:nil] objectAtIndex:0] retain];
            mViewThuongDungChuyenTienViDenMomo.mDelegate = self;
        }
        if(_mTaiKhoanThuongDung)
            mViewThuongDungChuyenTienViDenMomo.mTaiKhoanThuongDung = self.mTaiKhoanThuongDung;
        rViewThayDoiThongTin.size = mViewThuongDungChuyenTienViDenMomo.frame.size;
        viewThemTaiKhoanThuongDung = mViewThuongDungChuyenTienViDenMomo;
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_TAN_NHA){
        if(!mViewThuongDungChuyenTienTanNha){
            mViewThuongDungChuyenTienTanNha = [[[[NSBundle mainBundle] loadNibNamed:@"ViewThuongDungChuyenTienTanNha" owner:self options:nil] objectAtIndex:0] retain];
        }
        if(_mTaiKhoanThuongDung)
            mViewThuongDungChuyenTienTanNha.mTaiKhoanThuongDung = self.mTaiKhoanThuongDung;
        rViewThayDoiThongTin.size = mViewThuongDungChuyenTienTanNha.frame.size;
        viewThemTaiKhoanThuongDung = mViewThuongDungChuyenTienTanNha;
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_DIEN_THOAI){
        if (!viewThemDienThoai) {
            viewThemDienThoai = [[[[NSBundle mainBundle] loadNibNamed:@"ThemTaiKhoanThuongDungDienThoai" owner:self options:nil] objectAtIndex:0] retain];
        }
        if (_mTaiKhoanThuongDung) {
            viewThemDienThoai.mTaiKhoanThuongDung = self.mTaiKhoanThuongDung;
        }
        rViewThayDoiThongTin.size = viewThemDienThoai.frame.size;
        viewThemTaiKhoanThuongDung = viewThemDienThoai;
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_CHUYEN_TIEN_ATM) {
        if (!viewATM) {
            viewATM = [[[[NSBundle mainBundle] loadNibNamed:@"ViewThuongDungATM" owner:self options:nil] objectAtIndex:0] retain];
        }
        if(_mTaiKhoanThuongDung)
            viewATM.mTaiKhoanThuongDung = self.mTaiKhoanThuongDung;
        rViewThayDoiThongTin.size = viewATM.frame.size;
        viewThemTaiKhoanThuongDung = viewATM;
        NSLog(@"%s - khoi tao xong view atm", __FUNCTION__);
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_CHUYEN_TIEN_CMND) {
        if (!viewCMND) {
            viewCMND = [[[[NSBundle mainBundle] loadNibNamed:@"ViewThuongDungCMND" owner:self options:nil] objectAtIndex:0] retain];
            viewCMND.delegate = self;
        }
        if(_mTaiKhoanThuongDung)
            viewCMND.mTaiKhoanThuongDung = self.mTaiKhoanThuongDung;
        rViewThayDoiThongTin.size = viewCMND.frame.size;
        viewThemTaiKhoanThuongDung = viewCMND;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateThongTinChiNhanh:) name:@"KEY_THONG_TIN_CHI_NHANH" object:nil];
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_VI_KHAC) {
        if (!viewViKhac) {
            viewViKhac = [[[[NSBundle mainBundle] loadNibNamed:@"ViewThuongDungViKhac" owner:self options:nil] objectAtIndex:0] retain];
            viewViKhac.delegate = self;
        }
        if(_mTaiKhoanThuongDung)
            viewViKhac.mTaiKhoanThuongDung = self.mTaiKhoanThuongDung;
        rViewThayDoiThongTin.size = viewViKhac.frame.size;
        viewThemTaiKhoanThuongDung = viewViKhac;
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_GUI_TIET_KIEM) {
        if (!viewTietKiem) {
            viewTietKiem = [[[[NSBundle mainBundle] loadNibNamed:@"ViewThuongDungTietKiem" owner:self options:nil] objectAtIndex:0] retain];
            viewTietKiem.delegate = self;
        }
        if(_mTaiKhoanThuongDung)
            viewTietKiem.mTaiKhoanThuongDung = self.mTaiKhoanThuongDung;
        rViewThayDoiThongTin.size = viewTietKiem.frame.size;
        viewThemTaiKhoanThuongDung = viewTietKiem;
        mDinhDanhKetNoi = DINH_DANH_LAY_DANH_SACH_NGAN_HANG_GUI_TIET_KIEM;
        [GiaoDichMang ketNoiLayDanhSachNganHangGuiTietKiem:self];
        [self hienThiLoading];
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_NAP_TIEN_DIEN) {
        if (!viewTienDien) {
            viewTienDien = [[[[NSBundle mainBundle] loadNibNamed:@"ViewThuongDungTienDien" owner:self options:nil] objectAtIndex:0] retain];
        }
        if(_mTaiKhoanThuongDung)
            viewTienDien.mTaiKhoanThuongDung = self.mTaiKhoanThuongDung;
        rViewThayDoiThongTin.size = viewTienDien.frame.size;
        viewThemTaiKhoanThuongDung = viewTienDien;
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_HOA_DON_NUOC) {
        if (!viewTienNuoc) {
            viewTienNuoc = [[[[NSBundle mainBundle] loadNibNamed:@"ViewThuongDungNuoc" owner:self options:nil] objectAtIndex:0] retain];
        }
        if(_mTaiKhoanThuongDung)
            viewTienNuoc.mTaiKhoanThuongDung = self.mTaiKhoanThuongDung;
        rViewThayDoiThongTin.size = viewTienNuoc.frame.size;
        viewThemTaiKhoanThuongDung = viewTienNuoc;
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_NAP_TIEN_INTERNET) {
        if (!viewInternet) {
            viewInternet = [[[[NSBundle mainBundle] loadNibNamed:@"ViewThuongDungInternet" owner:self options:nil] objectAtIndex:0] retain];
            viewInternet.delegate = self;
        }
        if(_mTaiKhoanThuongDung)
            viewInternet.mTaiKhoanThuongDung = self.mTaiKhoanThuongDung;
        rViewThayDoiThongTin.size = viewInternet.frame.size;
        viewThemTaiKhoanThuongDung = viewInternet;
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_MUON_TIEN) {
        if (!viewMuonTien) {
            viewMuonTien = [[[[NSBundle mainBundle] loadNibNamed:@"ViewThuongDungMuonTien" owner:self options:nil] objectAtIndex:0] retain];
            viewMuonTien.mDelegate = self;
        }
        if(_mTaiKhoanThuongDung)
            viewMuonTien.mTaiKhoanThuongDung = self.mTaiKhoanThuongDung;
        rViewThayDoiThongTin.size = viewMuonTien.frame.size;
        viewThemTaiKhoanThuongDung = viewMuonTien;
    }
    CGRect rViewNhapToken = self.mViewNhapToken.frame;
    CGRect rViewThoiGianConLai = self.mViewThoiGianConLai.frame;
    CGRect rViewMain = self.mViewMain.frame;
    CGRect rBtnVanTay = self.mbtnVanTay.frame;
    
    rViewThoiGianConLai.origin.y = rViewThayDoiThongTin.origin.y + rViewThayDoiThongTin.size.height + KHOANG_CANH_GIUA_CAC_VIEW;
    rViewNhapToken.origin.y = rViewThoiGianConLai.origin.y + rViewThoiGianConLai.size.height + KHOANG_CANH_GIUA_CAC_VIEW;
    rViewMain.size.height = rViewNhapToken.origin.y + rViewNhapToken.size.height + 2*KHOANG_CANH_GIUA_CAC_VIEW;
    
    //Khoi tao lai content size cua scrollview
    [self.mscrvHienThi setContentSize:CGSizeMake(self.mscrvHienThi.frame.size.width, self.mscrvHienThi.frame.size.height)];
    
    //reset lai vi tri cua nut van tay
    rBtnVanTay.origin.y = self.mscrvHienThi.frame.size.height - KHOANG_CANH_GIUA_CAC_VIEW - rBtnVanTay.size.height;
    
    //Kiem tra neu ViewMan co do cao + khoang cach voi nut xac thuc van tay > do cao cua scrollview
    //thi thay doi contentsize cua scrollview

    float fDoCaoMoi = rViewMain.origin.y + rViewMain.size.height + rBtnVanTay.size.height + KHOANG_CANH_NGAN_NHAT_GIUA_VIEW_MAIN_VA_NUT_XAC_THUC_VAN_TAY + KHOANG_CANH_GIUA_CAC_VIEW;
    if(fDoCaoMoi > self.mscrvHienThi.frame.size.height)
    {
        [self.mscrvHienThi setContentSize:CGSizeMake(self.mscrvHienThi.frame.size.width, fDoCaoMoi)];
        rBtnVanTay.origin.y = fDoCaoMoi - rBtnVanTay.size.height - KHOANG_CANH_GIUA_CAC_VIEW;
    }
    
    self.mViewThoiGianConLai.frame = rViewThoiGianConLai;
    self.mViewNhapToken.frame = rViewNhapToken;
    self.mViewMain.frame = rViewMain;
    self.mbtnVanTay.frame = rBtnVanTay;
    
    self.mViewThayDoiThongTin.frame = rViewThayDoiThongTin;
    if (![self.mViewThayDoiThongTin.subviews containsObject:viewThemTaiKhoanThuongDung]) {
        [self.mViewThayDoiThongTin addSubview:viewThemTaiKhoanThuongDung];
    }

    NSInteger nIndex = [_mDanhSachMaChucNang indexOfObject:[NSNumber numberWithInteger:self.mKieuThemTaiKhoanThuongDung]];
    [self.mtfTenChucNangChuyenTien setText:[_mDanhSachChucNang objectAtIndex:nIndex]];

    [self.mtbChonChucNang reloadData];
    [self khoiTaoGiaoDienChuyenTien];
    NSLog(@"%s - end khoi tao giao dien", __FUNCTION__);
}

- (void)capNhatLaiGiaoDienViKhac {
    CGRect rViewThayDoiThongTin = self.mViewThayDoiThongTin.frame;
    rViewThayDoiThongTin.size = viewViKhac.frame.size;

    CGRect rViewNhapToken = self.mViewNhapToken.frame;
    CGRect rViewThoiGianConLai = self.mViewThoiGianConLai.frame;
    CGRect rViewMain = self.mViewMain.frame;
    CGRect rBtnVanTay = self.mbtnVanTay.frame;

    rViewThoiGianConLai.origin.y = rViewThayDoiThongTin.origin.y + rViewThayDoiThongTin.size.height + KHOANG_CANH_GIUA_CAC_VIEW;
    rViewNhapToken.origin.y = rViewThoiGianConLai.origin.y + rViewThoiGianConLai.size.height + KHOANG_CANH_GIUA_CAC_VIEW;
    rViewMain.size.height = rViewNhapToken.origin.y + rViewNhapToken.size.height + 2*KHOANG_CANH_GIUA_CAC_VIEW;

    //Khoi tao lai content size cua scrollview
    [self.mscrvHienThi setContentSize:CGSizeMake(self.mscrvHienThi.frame.size.width, self.mscrvHienThi.frame.size.height)];

    //reset lai vi tri cua nut van tay
    rBtnVanTay.origin.y = self.mscrvHienThi.frame.size.height - KHOANG_CANH_GIUA_CAC_VIEW - rBtnVanTay.size.height;

    //Kiem tra neu ViewMan co do cao + khoang cach voi nut xac thuc van tay > do cao cua scrollview
    //thi thay doi contentsize cua scrollview

    float fDoCaoMoi = rViewMain.origin.y + rViewMain.size.height + rBtnVanTay.size.height + KHOANG_CANH_NGAN_NHAT_GIUA_VIEW_MAIN_VA_NUT_XAC_THUC_VAN_TAY + KHOANG_CANH_GIUA_CAC_VIEW;
    if(fDoCaoMoi > self.mscrvHienThi.frame.size.height)
    {
        [self.mscrvHienThi setContentSize:CGSizeMake(self.mscrvHienThi.frame.size.width, fDoCaoMoi)];
        rBtnVanTay.origin.y = fDoCaoMoi - rBtnVanTay.size.height - KHOANG_CANH_GIUA_CAC_VIEW;
    }

    self.mViewThoiGianConLai.frame = rViewThoiGianConLai;
    self.mViewNhapToken.frame = rViewNhapToken;
    self.mViewMain.frame = rViewMain;
    self.mbtnVanTay.frame = rBtnVanTay;
}

- (void)capNhatLaiGiaoDienTietKiem {
    CGRect rViewThayDoiThongTin = self.mViewThayDoiThongTin.frame;
    rViewThayDoiThongTin.size = viewTietKiem.frame.size;

    CGRect rViewNhapToken = self.mViewNhapToken.frame;
    CGRect rViewThoiGianConLai = self.mViewThoiGianConLai.frame;
    CGRect rViewMain = self.mViewMain.frame;
    CGRect rBtnVanTay = self.mbtnVanTay.frame;

    rViewThoiGianConLai.origin.y = rViewThayDoiThongTin.origin.y + rViewThayDoiThongTin.size.height + KHOANG_CANH_GIUA_CAC_VIEW;
    rViewNhapToken.origin.y = rViewThoiGianConLai.origin.y + rViewThoiGianConLai.size.height + KHOANG_CANH_GIUA_CAC_VIEW;
    rViewMain.size.height = rViewNhapToken.origin.y + rViewNhapToken.size.height + 2*KHOANG_CANH_GIUA_CAC_VIEW;

    //Khoi tao lai content size cua scrollview
    [self.mscrvHienThi setContentSize:CGSizeMake(self.mscrvHienThi.frame.size.width, self.mscrvHienThi.frame.size.height)];

    //reset lai vi tri cua nut van tay
    rBtnVanTay.origin.y = self.mscrvHienThi.frame.size.height - KHOANG_CANH_GIUA_CAC_VIEW - rBtnVanTay.size.height;

    //Kiem tra neu ViewMan co do cao + khoang cach voi nut xac thuc van tay > do cao cua scrollview
    //thi thay doi contentsize cua scrollview

    float fDoCaoMoi = rViewMain.origin.y + rViewMain.size.height + rBtnVanTay.size.height + KHOANG_CANH_NGAN_NHAT_GIUA_VIEW_MAIN_VA_NUT_XAC_THUC_VAN_TAY + KHOANG_CANH_GIUA_CAC_VIEW;
    if(fDoCaoMoi > self.mscrvHienThi.frame.size.height)
    {
        [self.mscrvHienThi setContentSize:CGSizeMake(self.mscrvHienThi.frame.size.width, fDoCaoMoi)];
        rBtnVanTay.origin.y = fDoCaoMoi - rBtnVanTay.size.height - KHOANG_CANH_GIUA_CAC_VIEW;
    }

    self.mViewThoiGianConLai.frame = rViewThoiGianConLai;
    self.mViewNhapToken.frame = rViewNhapToken;
    self.mViewMain.frame = rViewMain;
    self.mbtnVanTay.frame = rBtnVanTay;
}

- (void)capNhatLaiGiaoDienNapTienInternet {
    [self capNhatLaiGiaoDienTheoChucNang:viewInternet];
}

- (void)capNhatLaiGiaoDienTheoChucNang:(UIView *)viewCapNhat {
    CGRect rViewThayDoiThongTin = self.mViewThayDoiThongTin.frame;
    rViewThayDoiThongTin.size = viewCapNhat.frame.size;
    CGRect rViewNhapToken = self.mViewNhapToken.frame;
    CGRect rViewThoiGianConLai = self.mViewThoiGianConLai.frame;
    CGRect rViewMain = self.mViewMain.frame;
    CGRect rBtnVanTay = self.mbtnVanTay.frame;

    rViewThoiGianConLai.origin.y = rViewThayDoiThongTin.origin.y + rViewThayDoiThongTin.size.height + KHOANG_CANH_GIUA_CAC_VIEW;
    rViewNhapToken.origin.y = rViewThoiGianConLai.origin.y + rViewThoiGianConLai.size.height + KHOANG_CANH_GIUA_CAC_VIEW;
    rViewMain.size.height = rViewNhapToken.origin.y + rViewNhapToken.size.height + 2 * KHOANG_CANH_GIUA_CAC_VIEW;

    //Khoi tao lai content size cua scrollview
    [self.mscrvHienThi setContentSize:CGSizeMake(self.mscrvHienThi.frame.size.width, self.mscrvHienThi.frame.size.height)];

    //reset lai vi tri cua nut van tay
    rBtnVanTay.origin.y = self.mscrvHienThi.frame.size.height - KHOANG_CANH_GIUA_CAC_VIEW - rBtnVanTay.size.height;

    //Kiem tra neu ViewMan co do cao + khoang cach voi nut xac thuc van tay > do cao cua scrollview
    //thi thay doi contentsize cua scrollview

    float fDoCaoMoi = rViewMain.origin.y + rViewMain.size.height + rBtnVanTay.size.height + KHOANG_CANH_NGAN_NHAT_GIUA_VIEW_MAIN_VA_NUT_XAC_THUC_VAN_TAY + KHOANG_CANH_GIUA_CAC_VIEW;
    if(fDoCaoMoi > self.mscrvHienThi.frame.size.height)
    {
        [self.mscrvHienThi setContentSize:CGSizeMake(self.mscrvHienThi.frame.size.width, fDoCaoMoi)];
        rBtnVanTay.origin.y = fDoCaoMoi - rBtnVanTay.size.height - KHOANG_CANH_GIUA_CAC_VIEW;
    }

    self.mViewThoiGianConLai.frame = rViewThoiGianConLai;
    self.mViewNhapToken.frame = rViewNhapToken;
    self.mViewMain.frame = rViewMain;
    self.mbtnVanTay.frame = rBtnVanTay;

    [self.mViewMain bringSubviewToFront:self.mViewThoiGianConLai];
}

- (void)layThongTinChiNhanhNganHang:(double)lat lng:(double)lng nKhoangCach:(int)nKC sKeyWord:(NSString *)sKeyWord {
    GiaoDienDanhSachChiNhanhBank *vc = [[GiaoDienDanhSachChiNhanhBank alloc] initWithNibName:@"GiaoDienDanhSachChiNhanhBank" bundle:nil];
    vc.lat = lat;
    vc.lng = lng;
    vc.nKc = nKC;
    vc.sKeyword = sKeyWord;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

-(void)updateThongTinChiNhanh:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"KEY_THONG_TIN_CHI_NHANH"]) {
        ItemDiaDiemGiaoDich *item = [notification object];
        if (viewCMND) {
            [viewCMND capNhatThongTinChiNhanh:item.audio sTenChiNhanh:item.name sDiaChi:item.address];
        }
    }
}

- (void)khoiTaoGiaoDienChuyenTien
{
    [self.mbtnToken setTitle:@"TOKEN" forState:UIControlStateNormal];
    [self.mbtnToken setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
    [self.mbtnSMS setTitle:@"SMS" forState:UIControlStateNormal];
    [self.mbtnSMS setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
    [self.mbtnEmail setTitle:@"EMAIL" forState:UIControlStateNormal];
    [self.mbtnEmail setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
    
    self.mbtnSMS.selected = NO;
    self.mbtnToken.selected = NO;
    self.mbtnEmail.selected = NO;
    self.mbtnEmail.enabled = YES;
    self.mbtnSMS.enabled = YES;
    self.mbtnToken.enabled = YES;
    [self.mtfMatKhauToken setText:@""];
    self.mtfMatKhauToken.max_length = 6;
    self.mtfMatKhauToken.inputAccessoryView = nil;
    self.mtfMatKhauToken.placeholder = [@"mat_khau_token" localizableString];
    [self.mtfMatKhauToken setTextError:[@"mat_khau_token_khong_dc_de_trong" localizableString]
                               forType:ExTextFieldTypeEmpty];
}

#pragma mark - suKien

- (void)didSelectBackButton
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)suKienBamNutXacThucBoiToken:(UIButton *)sender
{

    if([self.mThongTinTaiKhoanVi.nIsToken intValue] > 0)
    {
        if(!self.mbtnToken.selected)
        {
            mTypeAuthenticate = TYPE_AUTHENTICATE_TOKEN;
            [self.mbtnToken setSelected:YES];
            [self.mbtnToken setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            
            if(self.mbtnSMS.enabled)
            {
                [self.mbtnSMS setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
                [self.mbtnSMS setTitleColor:nil forState:UIControlStateNormal];
                [self.mbtnSMS setSelected:NO];
            }
            
            if(self.mbtnEmail.enabled)
            {
                [self.mbtnEmail setSelected:NO];
                [self.mbtnEmail setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
                [self.mbtnEmail setTitleColor:nil forState:UIControlStateNormal];
            }
            
            self.mtfMatKhauToken.placeholder = [@"mat_khau_token" localizableString];
            [self.mtfMatKhauToken setTextError:[@"mat_khau_token_khong_dc_de_trong" localizableString]
                                    forType:ExTextFieldTypeEmpty];
        }
    }
    else
    {
        [UIAlertView alert:[@"thong_bao_loi_chua_dang_ky_token" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
    }

}

- (IBAction)suKienBamNutXacThucBoiSMS:(UIButton *)sender
{
    if(![self.mThongTinTaiKhoanVi.sPhoneAuthenticate isEqualToString:@""])
    {
        BOOL validate = [self kiemTraTruocKhiDayLen];
        if(!self.mbtnSMS.selected && validate)
        {
            [self hienThiHopThoaiHaiNutBamKieu:HOP_THOAI_XAC_NHAN_XAC_THUC_SMS cauThongBao:[NSString stringWithFormat:@"%@ %@", [@"thong_bao_ma_xac_thuc_duoc_gui_ve_so_dien_thoai" localizableString], self.mThongTinTaiKhoanVi.sPhoneAuthenticate]];
        }
    }
    else
    {
        [UIAlertView alert:[@"thong_bao_chua_dang_ky_so_dien_thoai" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
    }
}

- (IBAction)suKienBamNutXacThucBoiEmail:(UIButton *)sender
{
    if(![self.mThongTinTaiKhoanVi.sThuDienTu isEqualToString:@""])
    {
        BOOL validate = [self kiemTraTruocKhiDayLen];

        if(!self.mbtnEmail.selected && validate)
        {
            [self hienThiHopThoaiHaiNutBamKieu:HOP_THOAI_XAC_NHAN_XAC_THUC_EMAIL cauThongBao:[NSString stringWithFormat:@"%@ %@", [@"thong_bao_ma_xac_thuc_duoc_gui_ve_thu_dien_tu" localizableString], self.mThongTinTaiKhoanVi.sThuDienTu]];
        }
    }
    else
    {
        [UIAlertView alert:[@"thong_bao_chua_dang_ky_thu_dien_tu" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
    }
}

- (BOOL)kiemTraTruocKhiDayLen {
    if(self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_VI)
    {
        return [mViewThuongDungChuyenTienViDenVi validate];
    }
    else if(self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_THE)
    {
        return [mViewThuongDungChuyenTienDenThe validate];
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_THE_RUT_TIEN)
    {
        return [mViewThuongDungChuyenTienDenTheRutTien validate];
    }
    else if(self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_NGAN_HANG)
    {
        return [mViewThuongDungChuyenTienDenTaiKhoan validate];
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_NGAN_HANG_RUT_TIEN)
    {
        return [mViewThuongDungChuyenTienDenTaiKhoanRutTien validate];
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_TAN_NHA)
    {
        return [mViewThuongDungChuyenTienTanNha validate];
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_DIEN_THOAI)
    {
        return [viewThemDienThoai kiemTraNoiDung];
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_CHUYEN_TIEN_ATM)
    {
        return [viewATM kiemTraNoiDung];
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_CHUYEN_TIEN_CMND)
    {
        return [viewCMND kiemTraNoiDung];
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_VI_KHAC)
    {
        return [viewViKhac kiemTraNoiDung];
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_GUI_TIET_KIEM)
    {
        return [viewTietKiem kiemTraNoiDung];
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_NAP_TIEN_GAME)
    {

    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_NAP_TIEN_DIEN)
    {
        return [viewTienDien kiemTraNoiDung];
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_HOA_DON_NUOC)
    {
        return [viewTienNuoc kiemTraNoiDung];
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_NAP_TIEN_INTERNET)
    {
        return [viewInternet kiemTraNoiDung];
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_MUON_TIEN) {
        return [viewMuonTien kiemTraNoiDung];
    }
    return NO;
}

- (IBAction)suKienBamNutXacThucBoiVanTay:(UIButton *)sender
{
    BOOL validate = [self kiemTraTruocKhiDayLen];
    if(validate)
        [self xuLySuKienDangNhapVanTay];
    else
        NSLog(@"%s - chua validate dau", __FUNCTION__);
}

- (IBAction)suKienBamNutThucHien:(UIButton *)sender
{
    BOOL validate = NO;
    DucNT_TaiKhoanThuongDungObject *taiKhoanThuongDung = nil;
    if(self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_VI)
    {
        validate = [mViewThuongDungChuyenTienViDenVi validate];
        taiKhoanThuongDung = [mViewThuongDungChuyenTienViDenVi getTaiKhoanThuongDungDayLenServer];
    }
    else if(self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_THE)
    {
        validate = [mViewThuongDungChuyenTienDenThe validate];
        taiKhoanThuongDung = [mViewThuongDungChuyenTienDenThe getTaiKhoanThuongDungDayLenServer];
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_THE_RUT_TIEN)
    {
        validate = [mViewThuongDungChuyenTienDenTheRutTien validate];
        taiKhoanThuongDung = [mViewThuongDungChuyenTienDenTheRutTien getTaiKhoanThuongDungDayLenServer];
    }
    else if(self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_NGAN_HANG)
    {
        validate = [mViewThuongDungChuyenTienDenTaiKhoan validate];
        taiKhoanThuongDung = [mViewThuongDungChuyenTienDenTaiKhoan getTaiKhoanThuongDungDayLenServer];
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_NGAN_HANG_RUT_TIEN)
    {
        validate = [mViewThuongDungChuyenTienDenTaiKhoanRutTien validate];
        taiKhoanThuongDung = [mViewThuongDungChuyenTienDenTaiKhoanRutTien getTaiKhoanThuongDungDayLenServer];
    }
    else if(self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_MOMO)
    {
        validate = [mViewThuongDungChuyenTienViDenMomo validate];
        taiKhoanThuongDung = [mViewThuongDungChuyenTienViDenMomo getTaiKhoanThuongDungDayLenServer];
        taiKhoanThuongDung.nType = TAI_KHOAN_MOMO;
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_TAN_NHA)
    {
        validate = [mViewThuongDungChuyenTienTanNha validate];
        taiKhoanThuongDung = [mViewThuongDungChuyenTienTanNha getTaiKhoanThuongDungDayLenServer];
        taiKhoanThuongDung.nType = TAI_KHOAN_TAN_NHA;
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_DIEN_THOAI) {
        validate = [viewThemDienThoai kiemTraNoiDung];
        taiKhoanThuongDung = [viewThemDienThoai getTaiKhoanThuongDungDayLenServer];
        taiKhoanThuongDung.nType = TAI_KHOAN_DIEN_THOAI;
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_CHUYEN_TIEN_ATM)
    {
        validate = [viewATM kiemTraNoiDung];
        taiKhoanThuongDung = [viewATM getTaiKhoanThuongDungDayLenServer];
        taiKhoanThuongDung.nType = TAI_KHOAN_CHUYEN_TIEN_ATM;
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_CHUYEN_TIEN_CMND)
    {
        validate = [viewCMND kiemTraNoiDung];
        taiKhoanThuongDung = [viewCMND getTaiKhoanThuongDungDayLenServer];
        taiKhoanThuongDung.nType = TAI_KHOAN_CHUYEN_TIEN_CMND;
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_VI_KHAC)
    {
        validate = [viewViKhac kiemTraNoiDung];
        taiKhoanThuongDung = [viewViKhac getTaiKhoanThuongDungDayLenServer];
        taiKhoanThuongDung.nType = TAI_KHOAN_VI_KHAC;
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_GUI_TIET_KIEM)
    {
        validate = [viewTietKiem kiemTraNoiDung];
        taiKhoanThuongDung = [viewTietKiem getTaiKhoanThuongDungDayLenServer];
        taiKhoanThuongDung.nType = TAI_KHOAN_GUI_TIET_KIEM;
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_NAP_TIEN_DIEN)
    {
        validate = [viewTienDien kiemTraNoiDung];
        taiKhoanThuongDung = [viewTienDien getTaiKhoanThuongDungDayLenServer];
        taiKhoanThuongDung.nType = TAI_KHOAN_NAP_TIEN_DIEN;
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_HOA_DON_NUOC)
    {
        validate = [viewTienNuoc kiemTraNoiDung];
        taiKhoanThuongDung = [viewTienNuoc getTaiKhoanThuongDungDayLenServer];
        taiKhoanThuongDung.nType = TAI_KHOAN_HOA_DON_NUOC;
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_NAP_TIEN_INTERNET)
    {
        validate = [viewInternet kiemTraNoiDung];
        taiKhoanThuongDung = [viewInternet getTaiKhoanThuongDungDayLenServer];
        taiKhoanThuongDung.nType = TAI_KHOAN_NAP_TIEN_INTERNET;
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_MUON_TIEN) {
        validate = [viewMuonTien kiemTraNoiDung];
        taiKhoanThuongDung = [viewMuonTien getTaiKhoanThuongDungDayLenServer];
        taiKhoanThuongDung.nType = TAI_KHOAN_MUON_TIEN;
    }
    if(validate && [self validate])
    {
        [self xuLyKetNoiThemCapNhatTaiKhoanThuongDung:taiKhoanThuongDung];
    }
}

- (IBAction)suKienBamNutChonChucNangChuyenTien:(UIButton *)sender
{
    self.mtbChonChucNang.hidden = !self.mtbChonChucNang.hidden;
//    if([self tableViewChonChucNangDangHienThi])
//        [self xuLyAnTableViewChonChucNang];
//    else
//        [self xuLyHienThiTableViewChonChucNang];
}

- (IBAction)suKienBamNutBack:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
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
    [RoundAlert show];
    DucNT_TaiKhoanThuongDungObject *taiKhoanThuongDung = nil;
    if(self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_VI)
    {
        taiKhoanThuongDung = [mViewThuongDungChuyenTienViDenVi getTaiKhoanThuongDungDayLenServer];
    }
    else if(self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_THE)
    {
        taiKhoanThuongDung = [mViewThuongDungChuyenTienDenThe getTaiKhoanThuongDungDayLenServer];
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_THE_RUT_TIEN)
    {
        taiKhoanThuongDung = [mViewThuongDungChuyenTienDenTheRutTien getTaiKhoanThuongDungDayLenServer];
    }
    else if(self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_NGAN_HANG)
    {
        taiKhoanThuongDung = [mViewThuongDungChuyenTienDenTaiKhoan getTaiKhoanThuongDungDayLenServer];
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_NGAN_HANG_RUT_TIEN)
    {
        taiKhoanThuongDung = [mViewThuongDungChuyenTienDenTaiKhoanRutTien getTaiKhoanThuongDungDayLenServer];
    }
    else if(self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_MOMO)
    {
        taiKhoanThuongDung = [mViewThuongDungChuyenTienViDenMomo getTaiKhoanThuongDungDayLenServer];
        taiKhoanThuongDung.nType = TAI_KHOAN_MOMO;
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_TAN_NHA)
    {
        taiKhoanThuongDung = [mViewThuongDungChuyenTienTanNha getTaiKhoanThuongDungDayLenServer];
        taiKhoanThuongDung.nType = TAI_KHOAN_TAN_NHA;
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_DIEN_THOAI)
    {
        taiKhoanThuongDung = [viewThemDienThoai getTaiKhoanThuongDungDayLenServer];
        taiKhoanThuongDung.nType = TAI_KHOAN_DIEN_THOAI;
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_CHUYEN_TIEN_ATM)
    {
        taiKhoanThuongDung = [viewATM getTaiKhoanThuongDungDayLenServer];
        taiKhoanThuongDung.nType = TAI_KHOAN_CHUYEN_TIEN_ATM;
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_CHUYEN_TIEN_CMND)
    {
        taiKhoanThuongDung = [viewCMND getTaiKhoanThuongDungDayLenServer];
        taiKhoanThuongDung.nType = TAI_KHOAN_CHUYEN_TIEN_CMND;
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_VI_KHAC)
    {
        taiKhoanThuongDung = [viewViKhac getTaiKhoanThuongDungDayLenServer];
        taiKhoanThuongDung.nType = TAI_KHOAN_VI_KHAC;
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_GUI_TIET_KIEM)
    {
        taiKhoanThuongDung = [viewTietKiem getTaiKhoanThuongDungDayLenServer];
        taiKhoanThuongDung.nType = TAI_KHOAN_GUI_TIET_KIEM;
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_NAP_TIEN_DIEN)
    {
        taiKhoanThuongDung = [viewTienDien getTaiKhoanThuongDungDayLenServer];
        taiKhoanThuongDung.nType = TAI_KHOAN_NAP_TIEN_DIEN;
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_HOA_DON_NUOC)
    {
        taiKhoanThuongDung = [viewTienNuoc getTaiKhoanThuongDungDayLenServer];
        taiKhoanThuongDung.nType = TAI_KHOAN_HOA_DON_NUOC;
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_NAP_TIEN_INTERNET)
    {
        taiKhoanThuongDung = [viewInternet getTaiKhoanThuongDungDayLenServer];
        taiKhoanThuongDung.nType = TAI_KHOAN_NAP_TIEN_INTERNET;
    }
    else if (self.mKieuThemTaiKhoanThuongDung == TAI_KHOAN_MUON_TIEN) {
        taiKhoanThuongDung = [viewMuonTien getTaiKhoanThuongDungDayLenServer];
        taiKhoanThuongDung.nType = TAI_KHOAN_MUON_TIEN;
    }
    mXacThucVanTay = YES;
    mTypeAuthenticate = TYPE_AUTHENTICATE_TOKEN;
    [RoundAlert hide];
    [self xuLyKetNoiThemCapNhatTaiKhoanThuongDung:taiKhoanThuongDung];
}

- (void)hienThiThongBaoDienMatKhau
{
    [UIAlertView alert:[@"thong_bao_xac_thuc_van_tay_khong_dung" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
    [mbtnVanTay setHidden:YES];
}

#pragma mark - xuLyTimer
- (void)batDauDemThoiGian
{
    mTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(capNhatDemThoiGian) userInfo:nil repeats:YES];
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

- (void)capNhatDemThoiGian
{
    _mTongSoThoiGian --;
    if(mTypeAuthenticate == TYPE_AUTHENTICATE_SMS)
    {
        self.mbtnSMS.enabled = NO;
        [self.mbtnSMS setTitle:[NSString stringWithFormat:@"%ld s", (long)self.mTongSoThoiGian] forState:UIControlStateNormal];
        self.mbtnSMS.enabled = YES;
    }
    else if(mTypeAuthenticate == TYPE_AUTHENTICATE_EMAIL)
    {
        self.mbtnEmail.enabled = NO;
        [self.mbtnEmail setTitle:[NSString stringWithFormat:@"%ld s", (long)self.mTongSoThoiGian] forState:UIControlStateNormal];
        self.mbtnEmail.enabled = YES;
    }
    if(_mTongSoThoiGian == 0)
    {
        [self ketThucDemThoiGian];
    }
}

#pragma mark - xu ly su kien

- (BOOL)validate
{
    if([self.mtfMatKhauToken validate])
    {
        return YES;
    }
    [self.mtfMatKhauToken show_error];
    return NO;
}

- (BOOL)tableViewChonChucNangDangHienThi
{
    CGRect rTableViewChonChucNang = self.mtbChonChucNang.frame;
    if(rTableViewChonChucNang.size.height > 0)
        return YES;
    return NO;
}

- (void)xuLyAnTableViewChonChucNang
{
    self.mtbChonChucNang.hidden = YES;
//    CGRect rTableViewChonChucNang = self.mtbChonChucNang.frame;
//    if(rTableViewChonChucNang.size.height > 0)
//    {
//        __block ThemTaiKhoanThuongDungViewController *blockSELF = self;
//        [UIView animateWithDuration:0.25 animations:^{
//            CGRect rTableViewChonChucNang = blockSELF.mtbChonChucNang.frame;
//            rTableViewChonChucNang.size.height = 0;
//            blockSELF.mtbChonChucNang.frame = rTableViewChonChucNang;
//        }];
//    }
}

- (void)xuLyHienThiTableViewChonChucNang
{
    self.mtbChonChucNang.hidden = NO;
//    CGRect rTableViewChonChucNang = self.mtbChonChucNang.frame;
//    if(rTableViewChonChucNang.size.height == 0)
//    {
//        __block ThemTaiKhoanThuongDungViewController *blockSELF = self;
//        [UIView animateWithDuration:0.25 animations:^{
//            CGRect rTableViewChonChucNang = blockSELF.mtbChonChucNang.frame;
//            rTableViewChonChucNang.size.height = _mDanhSachChucNang.count*DO_CAO_CELL;
//            blockSELF.mtbChonChucNang.frame = rTableViewChonChucNang;
//        }];
//    }
}

- (void)xuLySuKienXacThucBangEmail
{
    if(!self.mbtnEmail.selected)
    {
        mTypeAuthenticate = TYPE_AUTHENTICATE_EMAIL;
        [self.mbtnEmail setSelected:YES];
        [self.mbtnEmail setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        self.mTongSoThoiGian = THOI_GIAN_CHO_XAC_THUC_EMAIL;
        [self.mbtnEmail setTitle:[NSString stringWithFormat:@"%ld s", (long)self.mTongSoThoiGian] forState:UIControlStateNormal];
        [self.mbtnVanTay setHidden:YES];
        
        if(self.mbtnToken.enabled)
        {
            [self.mbtnToken setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
            [self.mbtnToken setTitleColor:nil forState:UIControlStateNormal];
            [self.mbtnToken setSelected:NO];
            [self.mbtnToken setEnabled:NO];
        }
        
        if(self.mbtnSMS.enabled)
        {
            [self.mbtnSMS setSelected:NO];
            [self.mbtnSMS setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
            [self.mbtnSMS setTitleColor:nil forState:UIControlStateNormal];
            [self.mbtnSMS setEnabled:NO];
        }
        
        self.mtfMatKhauToken.placeholder = [@"ma_xac_thuc" localizableString];
        [self.mtfMatKhauToken setTextError:[@"ma_xac_thuc_khong_duoc_de_trong" localizableString]
                                forType:ExTextFieldTypeEmpty];
        
        
        NSString *sEmailAuthenticate = self.mThongTinTaiKhoanVi.sThuDienTu;
        int nKieuNhanXacThuc = 0;
        nKieuNhanXacThuc = FUNC_THEM_CAP_NHAT_TAI_KHOAN_THUONG_DUNG;
        [self xuLyKetNoiLayMaXacThucChuyenDenTaiKhoan:sEmailAuthenticate kieuXacThuc:nKieuNhanXacThuc];
    }
}

- (void)xuLySuKienXacThucBangSMS
{
    if(!self.mbtnSMS.selected)
    {
        mTypeAuthenticate = TYPE_AUTHENTICATE_SMS;
        [self.mbtnSMS setSelected:YES];
        [self.mbtnSMS setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        self.mTongSoThoiGian = THOI_GIAN_CHO_XAC_THUC_SMS;
        [self.mbtnSMS setTitle:[NSString stringWithFormat:@"%ld s", (long)self.mTongSoThoiGian] forState:UIControlStateNormal];
        
        [self.mbtnVanTay setHidden:YES];
        
        if(self.mbtnToken.enabled)
        {
            [self.mbtnToken setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
            [self.mbtnToken setTitleColor:nil forState:UIControlStateNormal];
            [self.mbtnToken setSelected:NO];
            [self.mbtnToken setEnabled:NO];
        }
        
        if(self.mbtnEmail.enabled)
        {
            [self.mbtnEmail setSelected:NO];
            [self.mbtnEmail setBackgroundImage:[UIImage imageNamed:@"bg-nuttrang"] forState:UIControlStateNormal];
            [self.mbtnEmail setTitleColor:nil forState:UIControlStateNormal];
            [self.mbtnEmail setEnabled:NO];
        }
        
        self.mtfMatKhauToken.placeholder = [@"ma_xac_thuc" localizableString];
        [self.mtfMatKhauToken setTextError:[@"ma_xac_thuc_khong_duoc_de_trong" localizableString]
                                forType:ExTextFieldTypeEmpty];
        
        NSString *sPhoneAuthenticate = self.mThongTinTaiKhoanVi.sPhoneAuthenticate;
        int nKieuNhanXacThuc = 0;
        nKieuNhanXacThuc = FUNC_THEM_CAP_NHAT_TAI_KHOAN_THUONG_DUNG;
        
        [self xuLyKetNoiLayMaXacThucChuyenDenTaiKhoan:sPhoneAuthenticate kieuXacThuc:nKieuNhanXacThuc];
    }
}

- (void)xuLyKetNoiLayMaXacThucChuyenDenTaiKhoan:(NSString*)sSendTo kieuXacThuc:(int)nKieu
{
    NSString *sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    int typeAuthenticate = 1;
    //    if(![Common kiemTraLaSoDienThoai:sSendTo])
    if([Common kiemTraLaMail:sSendTo])
        typeAuthenticate = 2;
    
    NSMutableString *sUrl = [[NSMutableString alloc] init];
    [sUrl appendFormat:@"https://vimass.vn/vmbank/services/account/getOTP?"];
    [sUrl appendFormat:@"id=%@&", sTaiKhoan];
    [sUrl appendFormat:@"appId=%d&", APP_ID];
    [sUrl appendFormat:@"funcId=%d&", nKieu];
    [sUrl appendFormat:@"typeAuthenticate=%d&", typeAuthenticate];
    [sUrl appendFormat:@"sendTo=%@", sSendTo];
    
    mDinhDanhKetNoi = DINH_DANH_KET_NOI_LAY_MA_XAC_THUC;
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:self];
    [connect connectGet:sUrl withContent:@""];
    [connect release];
    [sUrl release];
}

- (void)xuLyKetNoiThemCapNhatTaiKhoanThuongDung:(DucNT_TaiKhoanThuongDungObject*)taiKhoanThuongDung
{
    NSString *sToken = @"";
    NSString *sOtp = @"";
    if(mTypeAuthenticate == TYPE_AUTHENTICATE_TOKEN)
    {
        NSString *sMatKhau = @"";
        if(mXacThucVanTay)
        {
            mXacThucVanTay = NO;
            sMatKhau = [DucNT_Token layMatKhauVanTayToken];
        }
        else
        {
            sMatKhau = self.mtfMatKhauToken.text;
        }
        
        NSString *sSeed = [DucNT_Token laySeedTokenHienTai];
        if(sSeed != nil && sSeed.length > 0)
        {
            sToken = [DucNT_Token OTPFromPIN:sMatKhau seed:sSeed];
        }
        else
        {
            [[[[UIAlertView alloc] initWithTitle:[@"thong_bao" localizableString]  message:[@"can_tao_token" localizableString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
            return;
        }
    }
    else
    {
        sOtp = self.mtfMatKhauToken.text;
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[taiKhoanThuongDung toDict]];
    [dict setValue:sOtp forKey:@"otpConfirm"];
    [dict setValue:[NSNumber numberWithInt:mTypeAuthenticate] forKey:@"typeAuthenticate"];
    [dict setValue:sToken forKey:@"token"];
    [dict setValue:[NSNumber numberWithInt:APP_ID] forKey:@"appId"];
    NSString *sMaDoanhNghiep = @"";
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sMaDoanhNghiep = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_COMPANY_ID];
    }
    [dict setValue:sMaDoanhNghiep forKey:@"companyCode"];

    NSLog(@"%s - [dict JSONString] : %@", __FUNCTION__, [dict JSONString]);

    mDinhDanhKetNoi = DINH_DANH_KET_NOI_THEM_CAP_NHAT_TAI_KHOAN_THUONG_DUNG;
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:self];
    [connect connect:@"https://vimass.vn/vmbank/services/account/addAccUsed" withContent:[dict JSONString]];
    [connect release];
}

#pragma mark - xuLy Touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if(![touch.view isEqual:self.mtbChonChucNang] && [self tableViewChonChucNangDangHienThi])
        [self xuLyAnTableViewChonChucNang];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _mDanhSachChucNang.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if(indexPath.row == self.mKieuThemTaiKhoanThuongDung - 1)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    NSString *sTieuDe = [_mDanhSachChucNang objectAtIndex:indexPath.row];

    cell.textLabel.text = sTieuDe;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return DO_CAO_CELL;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.mKieuThemTaiKhoanThuongDung = [[_mDanhSachMaChucNang objectAtIndex:indexPath.row] integerValue];
    [self.mtfTenChucNangChuyenTien setText:[_mDanhSachChucNang objectAtIndex:indexPath.row]];
    [self xuLyAnTableViewChonChucNang];
    [self khoiTaoGiaoDien];
    [self suKienBamNutXacThucBoiToken:self.mbtnToken];
}

#pragma mark - ViewThuongDungChuyenTienViDenViDelegate

- (void)xuLySuKienBamNutDanhBa
{
    ContactScreen *danhBa = [[[ContactScreen alloc] initWithNibName:@"ContactScreen" bundle:nil] autorelease];
    danhBa.mKieuHienThiLienHe = KIEU_HIEN_THI_LIEN_HE_THUONG;
    [self.navigationController pushViewController:danhBa animated:YES];
    __block ThemTaiKhoanThuongDungViewController *blockSELF = self;
    [danhBa selectContact:^(NSString *phone, Contact *contact)
     {
         if (phone != nil && phone.length > 0)
         {
             NSString *sTaiKhoan = @"";
             if([Common kiemTraLaMail:phone])
             {
                 sTaiKhoan = phone;
             }
             else
             {
                 sTaiKhoan = [phone stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [phone length])];
             }
             if(blockSELF->_mKieuThemTaiKhoanThuongDung == TAI_KHOAN_VI)
                 [blockSELF->mViewThuongDungChuyenTienViDenVi setTaiKhoan:sTaiKhoan];
             else if (blockSELF->_mKieuThemTaiKhoanThuongDung == TAI_KHOAN_MOMO)
                 [blockSELF->mViewThuongDungChuyenTienViDenMomo setTaiKhoan:sTaiKhoan];
         }
         
         [danhBa.navigationController popViewControllerAnimated:YES];
     }];
    
}

#pragma mark - ViewThuongDungMuonTienDelegate
- (void)xuLySuKienBamNutDanhBaMuonTien {
    ContactScreen *danhBa = [[[ContactScreen alloc] initWithNibName:@"ContactScreen" bundle:nil] autorelease];
    danhBa.mKieuHienThiLienHe = KIEU_HIEN_THI_LIEN_HE_THUONG;
    [self.navigationController pushViewController:danhBa animated:YES];
    __block ThemTaiKhoanThuongDungViewController *blockSELF = self;
    [danhBa selectContact:^(NSString *phone, Contact *contact)
     {
         if (phone != nil && phone.length > 0)
         {
             NSString *sTaiKhoan = @"";
             if([Common kiemTraLaMail:phone])
             {
                 sTaiKhoan = phone;
             }
             else
             {
                 sTaiKhoan = [phone stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [phone length])];
             }
             [blockSELF->viewMuonTien capNhatViMuonTien:sTaiKhoan];
         }

         [danhBa.navigationController popViewControllerAnimated:YES];
     }];
}

#pragma mark - DucNT_ServicePostDelegate
-(void)ketNoiThanhCong:(NSString *)sKetQua
{
//    NSLog(@"%s - %@ - sKetQua : %@", __FUNCTION__, mDinhDanhKetNoi, sKetQua);
    NSDictionary *dicKetQua = [sKetQua objectFromJSONString];
    int nCode = [[dicKetQua objectForKey:@"msgCode"] intValue];
    NSString *message = [dicKetQua objectForKey:@"msgContent"];
    if([mDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_LAY_MA_XAC_THUC])
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
            [UIAlertView alert:message withTitle:[@"thong_bao" localizableString] block:nil];
        }
    }
    else if ([mDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_THEM_CAP_NHAT_TAI_KHOAN_THUONG_DUNG])
    {
        if(nCode == 1)
        {
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:[@"thong_bao" localizableString] message:message delegate:self cancelButtonTitle:[@"dong" localizableString] otherButtonTitles:nil, nil] autorelease];
            alert.tag = HOP_THOAI_XAC_NHAN_CHUYEN_TIEN_THANH_CONG;
            [alert show];
        }
        else
        {
            [UIAlertView alert:message withTitle:[@"thong_bao" localizableString] block:nil];
        }
    }
    else if ([mDinhDanhKetNoi isEqualToString:DINH_DANH_LAY_DANH_SACH_NGAN_HANG_GUI_TIET_KIEM])
    {
        [self anLoading];
        if(nCode == 1)
        {
            if (viewTietKiem) {
                NSDictionary* ketQua = [dicKetQua objectForKey:@"result"];
                NSLog(@"%s - ketQua : %@", __FUNCTION__, [ketQua JSONString]);
                viewTietKiem.mDanhSachNganHangGuiTietKiem = [NganHangGuiTietKiem layDanhSachNganHangGuiTietKiem:(NSDictionary*)ketQua];
                [viewTietKiem capNhatThongTin];
            }
        }
    }
}

#pragma mark - UIAlertViewDelegate
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
        {
            if([self.mDelegate respondsToSelector:@selector(xuLySuKienThem_CapNhatTaiKhoanThuongDungThanhCong)])
            {
                [self.mDelegate xuLySuKienThem_CapNhatTaiKhoanThuongDungThanhCong];
            }
            [self suKienBamNutBack:nil];
        }
    }
}


#pragma mark - handler error
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - dealloc

- (void)dealloc
{
    if(_mDanhSachMaChucNang)
        [_mDanhSachMaChucNang release];
    if(_mDanhSachChucNang)
        [_mDanhSachChucNang release];
    if(_mTaiKhoanThuongDung)
        [_mTaiKhoanThuongDung release];
    if(mViewThuongDungChuyenTienDenTaiKhoan)
        [mViewThuongDungChuyenTienDenTaiKhoan release];
    if(mViewThuongDungChuyenTienDenTaiKhoanRutTien)
        [mViewThuongDungChuyenTienDenTaiKhoanRutTien release];
    if(mViewThuongDungChuyenTienDenThe)
        [mViewThuongDungChuyenTienDenThe release];
    if(mViewThuongDungChuyenTienDenTheRutTien)
        [mViewThuongDungChuyenTienDenTheRutTien release];
    if(mViewThuongDungChuyenTienViDenVi)
        [mViewThuongDungChuyenTienViDenVi release];
    if(mViewThuongDungChuyenTienViDenMomo)
        [mViewThuongDungChuyenTienViDenMomo release];
    if(mViewThuongDungChuyenTienTanNha)
       [mViewThuongDungChuyenTienTanNha release];
    if (viewCMND) {
        [viewCMND release];
    }
    if (viewATM) {
        [viewATM release];
    }
    if (viewCMND) {
        [viewCMND release];
    }
    if (viewViKhac) {
        [viewViKhac release];
    }
    if (viewTietKiem) {
        [viewTietKiem release];
    }

    [_mViewThayDoiThongTin release];
    [_mViewThoiGianConLai release];
    [mbtnVanTay release];
    [_mViewChonTenChucNang release];
    [_mtfTenChucNangChuyenTien release];
    [_mtbChonChucNang release];
    [_mlblTieuDe release];
    [_mscrvHienThi release];
    [super dealloc];
}
@end
