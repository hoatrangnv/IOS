//
//  SaoKeViVimassViewController.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 8/21/19.
//

#import "SaoKeViVimassViewController.h"
#import "DucNT_SaoKe_ViewChiTiet.h"
#import "DucNT_ViewDatePicker.h"
#import "Common.h"
#import "DichVuNotification.h"
#import "GiaoDichMang.h"
#import "GiaoDienThongTinPhim.h"
#import "SaoKe_QuaTang.h"
#import "GiaoDienChiTietSaoKe.h"
#import "Reachability.h"
#import "SaoKeViVimassCell.h"

#define DINH_DANH_KET_NOI_GUI_MAIL_SAO_KE @"DINH_DANH_KET_NOI_GUI_MAIL_SAO_KE"
@interface SaoKeViVimassViewController ()<UIAlertViewDelegate, UIScrollViewDelegate> {
    NSTimer *mTimer;
    BOOL mTrangThaiDuocPhepKetNoi;
    BOOL mTrangThaiTimKiem;
    BOOL mLanDauTien;
    int indexSaoKe;
    int limit;
}

@property (nonatomic, retain) DucNT_SaoKeObject *mObjSaoKeQuaTang;
@property (nonatomic, retain) SaoKe_QuaTang *mViewSaoKeQuaTang;
@property (nonatomic, retain) NSMutableArray *mDanhSachGiaoDichVi;
@property (nonatomic, retain) NSMutableArray *mDanhSachGiaoDichKhuyenMai;
@property (nonatomic, retain) NSMutableArray *mDanhSachGiaoDichNhanQua;
@property (nonatomic, retain) NSMutableArray *mDanhSachGiaoDichTangQua;
@property (nonatomic, retain) NSArray *mDanhSachHienThi;
@end

@implementation SaoKeViVimassViewController {
    NSString *mDinhDanhKetNoi;
}

@synthesize btnSearch;
@synthesize lblToTime;
@synthesize lblUserBalance;
@synthesize lvHistory;
@synthesize edtToTime;
@synthesize edtFromTime;
@synthesize viewDatePickerTuNgay;
@synthesize viewDatePickerToiNgay;
@synthesize viewThongTinChiTiet;
@synthesize nTrangThaiXem;

//int limit = 50;
static NSString *simpleTableIdentifier = @"DucNT_SaoKeCellID";
static NSString *DINH_DANH_LAY_SAO_KE_VI = @"DINH_DANH_LAY_SAO_KE_VI";
static NSString *DINH_DANH_LAY_SAO_KE_KHUYEN_MAI = @"DINH_DANH_LAY_SAO_KE_KHUYEN_MAI";
static NSString *DINH_DANH_LAY_SAO_KE_NHAN_QUA = @"DINH_DANH_LAY_SAO_KE_NHAN_QUA";
static NSString *DINH_DANH_LAY_SAO_KE_TANG_QUA = @"DINH_DANH_LAY_SAO_KE_TANG_QUA";
static NSString *DINH_DANH_LAY_CHI_TIET_SAO_KE_QUA_TANG = @"DINH_DANH_LAY_CHI_TIET_SAO_KE_QUA_TANG";

#pragma mark - init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        mTrangThaiDuocPhepKetNoi = YES;
        mTrangThaiTimKiem = NO;
        mLanDauTien = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    indexSaoKe = 0;
    limit = 50;
    [[DichVuNotification shareService] xacNhanDaDocTinTrongChucNang:TIN_TAI_CHINH];
    [self addTitleView:[@"saoke_giao_dich" localizableString]];
    [self addButtonBack];
    
    NSString *sID = @"";
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sID = [DucNT_LuuRMS layThongTinDangNhap:KEY_DINH_DANH_DOANH_NGHIEP];
    }
    else if(nKieuDangNhap == KIEU_CA_NHAN)
    {
        sID = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    }

    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:16.0f], UITextAttributeFont, nil];
    self.navigationController.navigationBar.titleTextAttributes = size;

    self.lvHistory.delegate = self;
    self.lvHistory.dataSource = self;

    if(!_mViewSaoKeQuaTang)
    {
        self.mViewSaoKeQuaTang = [[[NSBundle mainBundle] loadNibNamed:@"SaoKe_QuaTang" owner:self options:nil] objectAtIndex:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.mViewSaoKeQuaTang.frame = self.view.bounds;
        });
    }

    [self.lvHistory registerNib:[UINib nibWithNibName:@"SaoKeViVimassCell" bundle:nil] forCellReuseIdentifier:simpleTableIdentifier];

    [lblToTime setText:[@"den" localizableString]];
    _lblTitleSoDu.text = [NSString stringWithFormat:@"%@:", [@"inquiry_balance_value" localizableString]];
    [self.btnSearch setTitle:[@"inquiry_search" localizableString] forState:UIControlStateNormal];
    [self khoiTaoViewDatePickerTuNgay];
    [self khoiTaoViewDatePickerToiNgay];

    /*Dùng để dismiss bàn phím khi lựa chọn các view khác không phải textfield*/
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeTextInput)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture release];

    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button setImage:[UIImage imageNamed:@"ic_action_email"]forState:UIControlStateNormal];

    button.backgroundColor = [UIColor clearColor];
    button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [button addTarget:self action:@selector(suKienBamNutGuiMailNew) forControlEvents:UIControlEventTouchUpInside];

    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, 0, 30, 30);
    [button1 setImage:[UIImage imageNamed:@"ic_question_32"]forState:UIControlStateNormal];

    button1.backgroundColor = [UIColor clearColor];
    button1.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [button1 addTarget:self action:@selector(suKienBamNutHuongDanSaoKe:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *leftItem1 = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    UIBarButtonItem *leftItem = [[[UIBarButtonItem alloc] initWithCustomView:button1] autorelease];

    UIBarButtonItem *negativeSeperator = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];

    if (SYSTEM_VERSION_LESS_THAN(@"11"))
        negativeSeperator.width = -10;
    else {
        negativeSeperator.width = -15;
        [button.widthAnchor constraintEqualToConstant:30].active = YES;
        [button.heightAnchor constraintEqualToConstant:30].active = YES;
        [button1.widthAnchor constraintEqualToConstant:30].active = YES;
        [button1.heightAnchor constraintEqualToConstant:30].active = YES;
    }
    self.navigationItem.rightBarButtonItems = @[negativeSeperator, leftItem, leftItem1];

    [self kiemTraKetNoiMang];

    [self xuLyHienThiSoDuVaKhuyenMai];
    if(viewThongTinChiTiet == nil)
    {
        viewThongTinChiTiet = [[DucNT_SaoKe_ViewChiTiet alloc] initWithNib];
        viewThongTinChiTiet.frame = self.view.bounds;
        viewThongTinChiTiet.mThongTinTaiKhoan = self.mThongTinTaiKhoanVi;
    }

    mTrangThaiTimKiem = NO;
    [self xuLySuKienChonKieuXemSaoKe];
}

- (void)suKienBamNutHuongDanSaoKe:(UIButton *)btn {
    GiaoDienThongTinPhim *vc = [[GiaoDienThongTinPhim alloc] initWithNibName:@"GiaoDienThongTinPhim" bundle:nil];
    vc.nOption = HUONG_DAN_SAO_KE;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    for(UIView *lb in self.view.subviews){
        if ([lb isKindOfClass:[UILabel class]]) {
            [(UILabel *)lb setAdjustsFontSizeToFitWidth:YES];
        }
    }
}

- (void)kiemTraKetNoiMang {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];

    NetworkStatus status = [reachability currentReachabilityStatus];

    if(status == NotReachable)
    {
        //No internet
    }
    else if (status == ReachableViaWiFi)
    {
        NSLog(@"%s - internet la wifi", __FUNCTION__);
        limit = 20;
    }
    else if (status == ReachableViaWWAN)
    {
        NSLog(@"%s - internet la 3G", __FUNCTION__);
        limit = 10;
    }
}

#pragma mark - khoi tao view date picker

-(void)khoiTaoViewDatePickerTuNgay
{
    if(viewDatePickerTuNgay == nil)
    {
        viewDatePickerTuNgay = [[DucNT_ViewDatePicker alloc] initWithNib];
    }

    __block SaoKeViVimassViewController *blockSELF = self;
    [viewDatePickerTuNgay truyenThongSoThoiGian:^(NSString *sThoiGian)
     {
         if(sThoiGian != nil && sThoiGian.length > 0)
         {
             int nKQ = [Common compareDate1:sThoiGian andDate2:blockSELF.edtToTime.text withFormat:@"dd-MM-yyyy"];
             if(nKQ == SMALLER_THAN || nKQ == EQUAL)
             {
                 [blockSELF.edtFromTime resignFirstResponder];
                 blockSELF.edtFromTime.text = sThoiGian;
             }
             else
             {
                 [blockSELF hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:[@"ngay_bat_dau_phai_nho_hon_hoac_bang_ngay_ket_thuc" localizableString]];
             }
         }
         else
             [blockSELF.edtFromTime resignFirstResponder];
     }];
    edtFromTime.inputView = viewDatePickerTuNgay;
    edtFromTime.text = @"01-05-2017";
}

-(void)khoiTaoViewDatePickerToiNgay
{
    if(viewDatePickerToiNgay == nil)
    {
        viewDatePickerToiNgay = [[DucNT_ViewDatePicker alloc] initWithNib];
    }

    __block SaoKeViVimassViewController *blockSELF = self;
    [viewDatePickerToiNgay truyenThongSoThoiGian:^(NSString *sThoiGian) {
        if(sThoiGian != nil && sThoiGian.length > 0)
        {
            int nKQ = [Common compareDate1:blockSELF.edtFromTime.text andDate2:sThoiGian withFormat:@"dd-MM-yyyy"];
            if(nKQ == SMALLER_THAN || nKQ == EQUAL)
            {
                [blockSELF.edtToTime resignFirstResponder];
                blockSELF.edtToTime.text = sThoiGian;
            }
            else
            {
                [blockSELF hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:[@"ngay_bat_dau_phai_nho_hon_hoac_bang_ngay_ket_thuc" localizableString]];
            }
        }
        else
        {
            [blockSELF.edtToTime resignFirstResponder];
        }
    }];
    edtToTime.inputView = viewDatePickerToiNgay;
    edtToTime.text = [Common date:[NSDate date] toStringWithFormat:@"dd-MM-yyyy"];
}

#pragma mark - connect delegate
-(void)ketNoiThanhCong:(NSString *)sKetQua
{
    NSLog(@"%s - sKetQua : %@", __FUNCTION__, sKetQua);
    mTrangThaiDuocPhepKetNoi = YES;
    NSDictionary *dict = [sKetQua objectFromJSONString];
    int nCode = [[dict objectForKey:@"msgCode"] intValue];
    NSString *sMessage = [dict objectForKey:@"msgContent"];
    NSDictionary *dictSaoKe = [dict objectForKey:@"result"];
    if(nCode == 1)
    {
        if([mDinhDanhKetNoi isEqualToString:DINH_DANH_XAC_NHAN_TIN_DA_DOC])
        {
            [[DichVuNotification shareService] xacNhanDaDocTinTrongChucNang:TIN_TAI_CHINH];
            [(AppDelegate*)[[UIApplication sharedApplication] delegate] reloadGiaoDienHome];
        }
        else if([mDinhDanhKetNoi isEqualToString:DINH_DANH_LAY_CHI_TIET_SAO_KE_QUA_TANG])
        {
            ItemQuaTang *itemQuaTang = [[[ItemQuaTang alloc] initWithDictionary:dictSaoKe] autorelease];
            [_mViewSaoKeQuaTang updateView:self.mObjSaoKeQuaTang itemQuaTang:itemQuaTang];
            [self.view addSubview:_mViewSaoKeQuaTang];
        }
        else if ([mDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_GUI_MAIL_SAO_KE])
        {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sMessage];
        }
        else
        {
            [self xuLyLaySaoKeThanhCong:dictSaoKe];
        }
    }
    else
    {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sMessage];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        if(alertView.tag == HOP_THOAI_XAC_NHAN_CHUYEN_SAO_KE_DEN_THU_DIEN_TU)
        {
            long nNgayBatDau = [Common convertDateToLong:edtFromTime.text];
            long nNgayKetThu = [Common convertDateToLong:edtToTime.text];
            mDinhDanhKetNoi = DINH_DANH_KET_NOI_GUI_MAIL_SAO_KE;
            [GiaoDichMang ketNoiGuiMailSaoKeDen:self.mThongTinTaiKhoanVi.sID
                                          email:self.mThongTinTaiKhoanVi.sThuDienTu
                                         tuNgay:nNgayBatDau
                                        denNgay:nNgayKetThu
                                  noiNhanKetQua:self];
        }
    }
}

#pragma mark - su kien click control

- (void)suKienBamNutGuiMailNew
{
    if([self.mThongTinTaiKhoanVi kiemTraCoThuDienTu])
    {

        [self hienThiHopThoaiHaiNutBamKieu:HOP_THOAI_XAC_NHAN_CHUYEN_SAO_KE_DEN_THU_DIEN_TU
                               cauThongBao:[NSString stringWithFormat:@"Sao kê từ ngày %@ đến ngày %@ sẽ được gửi về thư điện tử %@", edtFromTime.text, edtToTime.text, self.mThongTinTaiKhoanVi.sThuDienTu]];
    }
    else
    {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:[@"thong_bao_chua_dang_ky_thu_dien_tu" localizableString]];
    }
}

- (IBAction)suKienChonVi:(id)sender
{
    mTrangThaiTimKiem = NO;
    [self xuLySuKienChonKieuXemSaoKe];
}

- (IBAction)suKienChonKhuyenMai:(id)sender
{

    mTrangThaiTimKiem = NO;
//    [self xuLySuKienChonKieuXemSaoKe:SAO_KE_KHUYEN_MAI];
}

- (IBAction)suKienChonNhanQua:(id)sender
{
    mTrangThaiTimKiem = NO;
//    [self xuLySuKienChonKieuXemSaoKe:SAO_KE_NHAN_QUA];
}

- (IBAction)suKienChonTangQua:(id)sender
{
    mTrangThaiTimKiem = NO;
//    [self xuLySuKienChonKieuXemSaoKe:SAO_KE_TANG_QUA];
}

- (IBAction)suKienChonSearch:(id)sender
{
    mTrangThaiDuocPhepKetNoi = YES;
    mTrangThaiTimKiem = YES;
    indexSaoKe = 0;
    if (self.mDanhSachGiaoDichVi) {
        [self.mDanhSachGiaoDichVi removeAllObjects];
    }
    [self khoiTaoKetNoiLaySaoKeVi];
}

#pragma mark - khởi tạo kết nối

- (void)khoiTaoKetNoiLayChiTietSaoKeQuaTang
{
    if(mTrangThaiDuocPhepKetNoi)
    {
        mTrangThaiDuocPhepKetNoi = NO;
        mDinhDanhKetNoi = DINH_DANH_LAY_CHI_TIET_SAO_KE_QUA_TANG;
        [GiaoDichMang ketNoiLaySaoKeQuaTangBoiID:self.mObjSaoKeQuaTang.idIcon noiNhanKetQua:self];
    }

}

-(void)khoiTaoKetNoiLaySaoKeVi
{
    if(mTrangThaiDuocPhepKetNoi)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mTrangThaiDuocPhepKetNoi = NO;
        [self batDauDemThoiGian];
        mDinhDanhKetNoi = DINH_DANH_LAY_SAO_KE_VI;
        NSString *sDate = [Common date:[NSDate date] toStringWithFormat:@"dd-MM-yyyy"];
        long long nThoiGianBatDau = [Common convertDateToLong:@"01-05-2012"];
        long long nThoiGianKetThuc = [Common convertDateToLong:sDate] + THOI_GIAN_MILISECOND_MOT_NGAY;
        if(mTrangThaiTimKiem)
        {
            nThoiGianBatDau = [Common convertDateToLong:edtFromTime.text];
            nThoiGianKetThuc = [Common convertDateToLong:edtToTime.text] + THOI_GIAN_MILISECOND_MOT_NGAY;
        }
        
        [GiaoDichMang ketNoiLaySaoKeVi:nThoiGianBatDau
                       thoiGianKetThuc:nThoiGianKetThuc
                           viTribatDau:indexSaoKe
                               gioiHan:limit
                               kieuLay:GET_ALL_INQUIRY
                         noiNhanKetQua:self];

    }
}

- (void)khoiTaoKetNoiLaySaoKeKhuyenMai
{
    if(mTrangThaiDuocPhepKetNoi)
    {
        mTrangThaiDuocPhepKetNoi = NO;
        [self batDauDemThoiGian];
        mDinhDanhKetNoi = DINH_DANH_LAY_SAO_KE_KHUYEN_MAI;
        NSString *sDate = [Common date:[NSDate date] toStringWithFormat:@"dd-MM-yyyy"];
        long long nThoiGianBatDau = [Common convertDateToLong:@"01-05-2012"];
        long long nThoiGianKetThuc = [Common convertDateToLong:sDate] + THOI_GIAN_MILISECOND_MOT_NGAY;
        if(mTrangThaiTimKiem)
        {
            nThoiGianBatDau = [Common convertDateToLong:edtFromTime.text];
            nThoiGianKetThuc = [Common convertDateToLong:edtToTime.text] + THOI_GIAN_MILISECOND_MOT_NGAY;
        }
        [GiaoDichMang ketNoiLaySaoKeKhuyenMai:nThoiGianBatDau
                              thoiGianKetThuc:nThoiGianKetThuc
                                  viTribatDau:indexSaoKe
                                      gioiHan:limit
                                      kieuLay:GET_ALL_INQUIRY
                              typeTransaction:0
                                noiNhanKetQua:self];
    }
}

- (void)khoiTaoKetNoiLaySaoKeNhanQua
{
    if(mTrangThaiDuocPhepKetNoi)
    {
        mTrangThaiDuocPhepKetNoi = NO;
        [self batDauDemThoiGian];
        mDinhDanhKetNoi = DINH_DANH_LAY_SAO_KE_NHAN_QUA;
        NSString *sDate = [Common date:[NSDate date] toStringWithFormat:@"dd-MM-yyyy"];
        long long nThoiGianBatDau = [Common convertDateToLong:@"01-05-2012"];
        long long nThoiGianKetThuc = [Common convertDateToLong:sDate] + THOI_GIAN_MILISECOND_MOT_NGAY;
        if(mTrangThaiTimKiem)
        {
            nThoiGianBatDau = [Common convertDateToLong:edtFromTime.text];
            nThoiGianKetThuc = [Common convertDateToLong:edtToTime.text] + THOI_GIAN_MILISECOND_MOT_NGAY;
        }
        [GiaoDichMang ketNoiLaySaoKeTangQua:nThoiGianBatDau
                            thoiGianKetThuc:nThoiGianKetThuc
                                viTribatDau:indexSaoKe
                                    gioiHan:limit
                                    kieuLay:GET_ALL_INCOMMING_INQUIRY
                            typeTransaction:0
                              noiNhanKetQua:self];
    }
}

- (void)khoiTaoKetNoiLaySaoKeTangQua
{
    if(mTrangThaiDuocPhepKetNoi)
    {
        mTrangThaiDuocPhepKetNoi = NO;
        [self batDauDemThoiGian];
        mDinhDanhKetNoi = DINH_DANH_LAY_SAO_KE_TANG_QUA;
        NSString *sDate = [Common date:[NSDate date] toStringWithFormat:@"dd-MM-yyyy"];
        long long nThoiGianBatDau = [Common convertDateToLong:@"01-05-2012"];
        long long nThoiGianKetThuc = [Common convertDateToLong:sDate] + THOI_GIAN_MILISECOND_MOT_NGAY;
        if(mTrangThaiTimKiem)
        {
            nThoiGianBatDau = [Common convertDateToLong:edtFromTime.text];
            nThoiGianKetThuc = [Common convertDateToLong:edtToTime.text] + THOI_GIAN_MILISECOND_MOT_NGAY;
        }
        [GiaoDichMang ketNoiLaySaoKeTangQua:nThoiGianBatDau
                            thoiGianKetThuc:nThoiGianKetThuc
                                viTribatDau:indexSaoKe
                                    gioiHan:limit
                                    kieuLay:GET_ALL_OUTCOMMING_INQUIRY
                            typeTransaction:0
                              noiNhanKetQua:self];
    }
}


#pragma mark - xuLyTimer

- (void)batDauDemThoiGian
{
    //    mTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(capNhatDemThoiGian) userInfo:nil repeats:YES];
}

- (void)ketThucDemThoiGian
{
    [RoundAlert hide];
    if(mTimer)
    {
        [mTimer invalidate];
        mTimer = nil;
    }
}

- (void)capNhatDemThoiGian
{
    if(!mTrangThaiDuocPhepKetNoi)
        [RoundAlert show];
    else
    {
        [self ketThucDemThoiGian];
    }
}


#pragma mark - xuLySuKien

- (void)xuLyLaySaoKeThanhCong:(NSDictionary*)dictKetQua
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [RoundAlert hide];
    NSLog(@"%s - nTrangThaiXem : %d", __FUNCTION__, nTrangThaiXem);
    NSArray *transactionList = [dictKetQua objectForKey:@"transactionList"];
    NSMutableArray *dsSaoKe = [[NSMutableArray alloc] initWithCapacity:transactionList.count];
    for(NSDictionary *dict in transactionList)
    {
        DucNT_SaoKeObject *objSaoKe = [[DucNT_SaoKeObject alloc] initWithDictionary:dict];
        [dsSaoKe addObject:objSaoKe];
        [objSaoKe release];
    }

    if (self.mDanhSachGiaoDichVi == nil) {
        self.mDanhSachGiaoDichVi = [[NSMutableArray alloc] init];
    }
    
    [self.mDanhSachGiaoDichVi addObjectsFromArray:dsSaoKe];
    
    if(dsSaoKe.count > 0 && mLanDauTien)
    {
        mLanDauTien = NO;
        NSNumber *promotionStatus = [dictKetQua objectForKey:@"promotionStatus"];
        NSNumber *promotionTotal = [dictKetQua objectForKey:@"promotionTotal"];
        NSNumber *toTalGift = [dictKetQua objectForKey:@"toTalGift"];
        NSNumber *totalCreateGift = [dictKetQua objectForKey:@"totalCreateGift"];
        NSString *userbalance = [dictKetQua objectForKey:@"userbalance"];
        self.mThongTinTaiKhoanVi.nPromotionStatus = promotionStatus;
        self.mThongTinTaiKhoanVi.nPromotionTotal = promotionTotal;
        self.mThongTinTaiKhoanVi.toTalGift = toTalGift;
        self.mThongTinTaiKhoanVi.totalCreateGift = totalCreateGift;
        self.mThongTinTaiKhoanVi.nAmount = [NSNumber numberWithDouble:[userbalance doubleValue]];
        [DucNT_LuuRMS luuThongTinTaiKhoanViSauDangNhap:self.mThongTinTaiKhoanVi];
        [self xuLyHienThiSoDuVaKhuyenMai];
        mTrangThaiDuocPhepKetNoi = NO;
        mDinhDanhKetNoi = DINH_DANH_XAC_NHAN_TIN_DA_DOC;
        [[DichVuNotification shareService] dichVuDanhDauThoiGianDocTin:[[[dsSaoKe objectAtIndex:0] transTime] longLongValue]
                                                         trongChucNang:TIN_TAI_CHINH
                                                                doiTac:@""
                                                             showAlert:NO
                                                         noiNhanKetQua:nil];
    }
    self.mDanhSachHienThi = self.mDanhSachGiaoDichVi;
    NSLog(@"%s - self.mDanhSachHienThi.count : %ld", __FUNCTION__, (long)self.mDanhSachHienThi.count);
    mTrangThaiDuocPhepKetNoi = YES;
    [self datTrangThaiChoButtonKhiLuaChon];

    [self hienThiThoiGian];
    [dsSaoKe release];
    [lvHistory reloadData];
}

- (void)xuLyHienThiSoDuVaKhuyenMai
{
    self.lblUserBalance.text = [Common hienThiTienTe_1:[self.mThongTinTaiKhoanVi.nAmount doubleValue]];
    self.mlblSoTienKhuyenMai.text = [Common hienThiTienTe_1:[self.mThongTinTaiKhoanVi.nPromotionTotal doubleValue]];
}

- (void)hienThiThoiGian
{
    if(self.mDanhSachHienThi.count > 0 && !mTrangThaiTimKiem)
    {
        DucNT_SaoKeObject *objSaoKeGanNhat = [self.mDanhSachHienThi objectAtIndex:0];
        DucNT_SaoKeObject *objSaoKeXaNhat = [self.mDanhSachHienThi objectAtIndex:self.mDanhSachHienThi.count - 1];

        NSDate *dtGanNhat = [NSDate dateWithTimeIntervalSince1970:[objSaoKeGanNhat.transTime longLongValue] / 1000];
        NSDate *dtXaNhat = [NSDate dateWithTimeIntervalSince1970:[objSaoKeXaNhat.transTime longLongValue] / 1000];

        viewDatePickerTuNgay.datePicker.date = dtXaNhat;
        viewDatePickerToiNgay.datePicker.date = dtGanNhat;

        edtFromTime.text = [Common date:dtXaNhat toStringWithFormat:@"dd-MM-yyyy"];
        edtToTime.text = [Common date:dtGanNhat toStringWithFormat:@"dd-MM-yyyy"];
    }
}

-(void)datTrangThaiChoButtonKhiLuaChon
{

}


- (void)xuLySuKienChonKieuXemSaoKe
{
    NSArray *arr = nil;
    arr = _mDanhSachGiaoDichVi;
    if(!arr)
    {
        indexSaoKe = 0;
        mTrangThaiDuocPhepKetNoi = YES;
        [self khoiTaoKetNoiLaySaoKeVi];
    }
}


-(void)closeTextInput
{
    [[self view] endEditing:YES];
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SaoKeViVimassCell *cell = (SaoKeViVimassCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

    if (cell == nil) {
        cell = [[SaoKeViVimassCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }

    DucNT_SaoKeObject *item = [self.mDanhSachHienThi objectAtIndex:indexPath.row];
    cell.lbSoTien.text = [Common hienThiTienTe:[item.amount doubleValue]];
    cell.lbSoTien.textColor = [UIColor blackColor];

    cell.lbNoiDung.text = [item layNoiDung];
    cell.lbNoiDung.textColor = [UIColor blackColor];

    cell.lbThoiGian.text = [item layNgayThangChuyenTien];
    //    cell.lbThoiGian.textColor = [UIColor blueColor];

    if([item.feeAmount doubleValue] > 0)
        cell.mlblSoPhi.text = [Common hienThiTienTe:[item.feeAmount doubleValue]];
    else
        cell.mlblSoPhi.text = @"";

    cell.mlblSoGio.text = [item layNgayGioChuyenTien];
    //    cell.mlblSoGio.textColor = [UIColor blueColor];

    CGRect rViewChua = cell.mViewChua.frame;
    CGRect rImgv = cell.imvAnhDaiDienHuongDiChuyen.frame;

    [cell.imvAnhDaiDienHuongDiChuyen setHidden:NO];

    rViewChua.origin.x = rImgv.origin.x + rImgv.size.width + 2;
    rViewChua.size.width = cell.frame.size.width - rViewChua.origin.x;
    DucNT_TaiKhoanViObject *objLogin = [DucNT_LuuRMS layThongTinTaiKhoanVi];
    NSString *idVi = objLogin.sID;

    if([item.feeAmount intValue] > 0)
    {
        //            NSLog(@"SaoKeViewcontroller : item.fromAcc : %@", item.fromAcc);
        cell.imvAnhDaiDienHuongDiChuyen.image = [UIImage imageNamed:@"sao-ke-di"];
    }
    else
    {
        cell.imvAnhDaiDienHuongDiChuyen.image = [UIImage imageNamed:@"sao-ke-den"];
    }
    cell.mViewChua.frame = rViewChua;
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_mDanhSachHienThi)
        return _mDanhSachHienThi.count;
    return 0;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DucNT_SaoKeObject *obj = [self.mDanhSachHienThi objectAtIndex:indexPath.row];
    GiaoDienChiTietSaoKe *vc = [[GiaoDienChiTietSaoKe alloc] initWithNibName:@"GiaoDienChiTietSaoKe" bundle:nil];
    vc.saoKe = obj;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
    NSLog(@"%s - endScrolling : %f -  scrollView.contentSize.height : %f", __FUNCTION__, endScrolling, scrollView.contentSize.height);
    if (endScrolling >= scrollView.contentSize.height)
    {
        NSLog(@"%s - lay them du lieu =======> Loading", __FUNCTION__);
        //        if (mTrangThaiDuocPhepKetNoi) {
        //            indexSaoKe += 10;
        //            [self khoiTaoKetNoiLaySaoKeVi];
        //        }
        //        else {
        //            NSLog(@"%s - mTrangThaiDuocPhepKetNoi == NO", __FUNCTION__);
        //        }
        //        if(!mTrangThaiReload)
        //        {
        //            [self khoiTaoDanhSachTinQuangBa];
        //        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height + 80)
    {
        if (mTrangThaiDuocPhepKetNoi) {
            indexSaoKe += limit;
            [self khoiTaoKetNoiLaySaoKeVi];
        }
        else {
            NSLog(@"%s - mTrangThaiDuocPhepKetNoi == NO", __FUNCTION__);
        }
    }
}

- (void)dealloc {
    [_lblTitleSoDu release];
    [lblUserBalance release];
    [_lblTitleKhuyenMai release];
    [_mlblSoTienKhuyenMai release];
    [edtFromTime release];
    [lblToTime release];
    [edtToTime release];
    [btnSearch release];
    [lvHistory release];
    [super dealloc];
}
@end
