//
//  GiaoDienDatVeMayBay.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 1/4/16.
//
//

#import "GiaoDienDatVeMayBay.h"
#import "CKCalendarView.h"
#import "ItemSanBay.h"
#import "ItemChuyenBay.h"
#import "CellChuyenBay.h"
#import "CellChuyenDi.h"
#import "GiaoDienChonChuyenBay.h"
#import "CellChuyenVe.h"
#import "GiaoDienThongTinPhim.h"
#import "DucNT_LoginSceen.h"
#import "DucNT_DanhSachTaiKhoanThuongDungControllerViewController.h"
#import "DucNT_TaiKhoanThuongDungObject.h"
#import "CommonUtils.h"

@interface GiaoDienDatVeMayBay ()<CKCalendarDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource, UITableViewDelegate, GiaoDienChonChuyenBayProtocol, CellChuyenDiProtocol, CellChuyenVeDelegate>{
//    NSCalendar *mCal;
    int nIndexChonCalendar, nIndexSanBayDi, nIndexSanBayDen, nTagPicker, nIndexNguoiLon, nIndexTreEm, nIndexEmbe;
    NSMutableArray *arrSanBay, *arrNguoiDi;

    ItemChuyenBay *itemChuyenDi, *itemChuyenDen;
    int nTongTien, nTongTienChuyenDi, nTongTienChuyenVe;
    GiaoDienChonChuyenBay *vcChonChuyenBay;
    UINavigationController *navigationController;
    ViewQuangCao *viewQC;
//    NSString *sTimeDi;
//    NSString *sTimeVe;
//    NSString *sIdVeMayBayGiaCao;
    MBProgressHUD *hubGiaCao;
    BOOL isShowGiaCao;
    UIAlertView *alertVeGiaCao;
    int countGiaCao;
    int nPhiVimass;
    BOOL isDem;
    double soTienPhaiThanhToan;
}
@end

@implementation GiaoDienDatVeMayBay

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRightButton];
    self.mFuncID = FUNC_DAT_VE_MAY_BAY;
    nIndexSanBayDi = -1;
    nIndexSanBayDen = -1;
    nIndexNguoiLon = 1;
    nIndexTreEm = 0;
    nIndexEmbe = 0;
    nTongTien = 0;
    nTongTienChuyenDi = 0;
    nTongTienChuyenVe = 0;
    countGiaCao = 0;
    nPhiVimass = 6600;
    self.timeGiaCao = 900;
    isShowGiaCao = NO;
    isDem = YES;
    self.sIdVeMayBayGiaCao = @"";
    self.sIdVeMayBayGiaCaoResult = @"";
    self.edToken.max_length = 6;

    [self addTitleView:@"Mua vé máy bay"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateThongTinHoaDonMayBay:) name:KEY_TAI_KHOAN_THUONG_DUNG object:nil];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor]];

    CKCalendarView *calendar = [[CKCalendarView alloc] init];
    calendar.onlyShowCurrentMonth = NO;
    calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    CGRect calendarFrame = self.viewCalendar.bounds;
    calendarFrame.origin.y = calendarFrame.origin.y + 10;
    calendar.frame = calendarFrame;
    [self.viewCalendar addSubview:calendar];
    calendar.delegate = self;
    [calendar selectDate:[NSDate date] makeVisible:YES];
    [calendar release];
    [self.viewCalendar bringSubviewToFront:self.btnCloseCalendarView];

    [self khoiTaoGiaoDienTextFeild:self.edSanBayDi nTag:100];
    [self khoiTaoGiaoDienTextFeild:self.edSanBayVe nTag:101];
    [self khoiTaoGiaoDienTextFeild:self.edNguoiLon nTag:102];
    [self khoiTaoGiaoDienTextFeild:self.edTreEm nTag:103];
    [self khoiTaoGiaoDienTextFeild:self.edEmBe nTag:104];

    arrNguoiDi = [[NSMutableArray alloc] init];
    [arrNguoiDi addObject:[NSNumber numberWithInt:0]];

    [self.tableNguoiDi registerNib:[UINib nibWithNibName:@"CellChuyenDi" bundle:nil] forCellReuseIdentifier:@"CellChuyenDi"];
    self.tableNguoiDi.separatorColor = [UIColor clearColor];

    [self.tableChuyenVe registerNib:[UINib nibWithNibName:@"CellChuyenVe" bundle:nil] forCellReuseIdentifier:@"CellChuyenVe"];
    self.tableChuyenVe.separatorColor = [UIColor clearColor];

    [self khoiTaoDuLieuBanDau];
    self.mbtnVanTay.hidden = YES;
    
    self.sThongBaoTangGia = @"";
//    self.sIdVeMayBayGiaCao = @"5518041490152869433";
//    NSLog(@"%s - sResult may bay : sIdVeMayBayGiaCao : %@", __FUNCTION__, self.sIdVeMayBayGiaCao);
//    [self traCuuVeMayBayGiaCao];
    self.edTenCty.inputAccessoryView = nil;
    self.edDiaChiCty.inputAccessoryView = nil;
    self.edMaSoThue.inputAccessoryView = nil;
    self.edDiaChiNhanHoaDon.inputAccessoryView = nil;

}

- (void)updateThongTinHoaDonMayBay:(NSNotification *)notification {
    if([[notification name] isEqualToString:KEY_TAI_KHOAN_THUONG_DUNG])
    {
        DucNT_TaiKhoanThuongDungObject *mTaiKhoanThuongDung = [notification object];
        self.edTenCty.text = mTaiKhoanThuongDung.tenCongTyXuatHoaDon;
        self.edMaSoThue.text = mTaiKhoanThuongDung.maSoThueCongTyXuatHoaDon;
        self.edDiaChiCty.text = mTaiKhoanThuongDung.diaChiCongTyXuatHoaDon;
        self.edDiaChiNhanHoaDon.text = mTaiKhoanThuongDung.diaChiNhanHoaDon;
//        [self khoiTaoTheoTaiKhoanThuongDung];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(![CommonUtils isEmptyOrNull:self.mThongTinTaiKhoanVi.pki3] && [self.mThongTinTaiKhoanVi.hanMucPki3 doubleValue] >0 ){
        self.mbtnPKI.hidden = NO;
    }
    else{
        self.mbtnPKI.hidden = YES;
    }
//    [self khoiTaoQuangCao];
    [self setAnimationChoSoTay:self.btnSoTay];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    UIImageView *imgSoTay = [self.btnSoTay imageView];
    [imgSoTay stopAnimating];
}


- (void)khoiTaoQuangCao {
    if (!viewQC) {
        viewQC = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ViewQuangCao class]) owner:self options:nil] objectAtIndex:0];
        viewQC.mDelegate = self;
        CGRect rectToken = self.btnChonVeMayBay.frame;
        CGRect rectQC = viewQC.frame;
        CGRect rectMain = self.mViewMain.frame;
        rectQC.origin.x = 0;
        CGFloat fW = rectMain.size.width;
        CGFloat fH = fW * 0.4533;
//        CGFloat fH = rectQC.size.height * (9.0 / 16.0);
        rectQC.origin.y = rectToken.origin.y + rectToken.size.height + 15.0;
        NSLog(@"%s - %d - fW : %f - fH : %f", __FUNCTION__, __LINE__, fW, fH);
        viewQC.frame = CGRectMake(0, rectQC.origin.y, fW, fH);
        viewQC.mDelegate = self;
        [viewQC updateSizeQuangCao];
        rectMain.size.height = rectQC.origin.y + rectQC.size.height;
        self.mViewMain.frame = rectMain;
        [self.mViewMain addSubview:viewQC];
        [self.scrMain setContentSize:CGSizeMake(_scrMain.frame.size.width, viewQC.frame.origin.y + viewQC.frame.size.height + 10)];
    }
}

- (void)addRightButton{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 34, 34);
    [button setImage:[UIImage imageNamed:@"hdsd-icon"]forState:UIControlStateNormal];

    button.backgroundColor = [UIColor clearColor];
    button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [button addTarget:self action:@selector(suKienBamNutHuongDanVeMayBay:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *leftItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];

    UIBarButtonItem *negativeSeperator = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];

    if (SYSTEM_VERSION_LESS_THAN(@"11"))
        negativeSeperator.width = -10;
    else {
        negativeSeperator.width = -15;
        [button.widthAnchor constraintEqualToConstant:34].active = YES;
        [button.heightAnchor constraintEqualToConstant:34].active = YES;
    }

    self.navigationItem.rightBarButtonItems = @[negativeSeperator, leftItem];
}

- (IBAction)suKienBamNutHuongDanVeMayBay:(UIButton *)sender
{
    GiaoDienThongTinPhim *vc = [[GiaoDienThongTinPhim alloc] initWithNibName:@"GiaoDienThongTinPhim" bundle:nil];
    vc.nOption = 2;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)khoiTaoGiaoDienTextFeild:(ExTextField *)edTemp nTag:(int)nTag{
    if (!edTemp.rightView) {
        UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 12)];
        [btnRight setBackgroundImage:[UIImage imageNamed:@"muiten35x21.png"] forState:UIControlStateNormal];
        edTemp.rightView = btnRight;
        edTemp.rightViewMode = UITextFieldViewModeAlways;

        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
        toolBar.barStyle = UIBarStyleBlackOpaque;
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneChonSanBay:)];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelChonSanBay:)];
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

        [toolBar setItems:[NSArray arrayWithObjects:cancelButton, flexSpace, doneButton, nil]];
        UIPickerView *pickerChonRap = [[UIPickerView alloc] init];
        pickerChonRap.dataSource = self;
        pickerChonRap.delegate = self;
        pickerChonRap.tag = nTag;
        edTemp.inputAccessoryView = toolBar;
        edTemp.inputView = pickerChonRap;
        [pickerChonRap release];
    }
}

- (void)doneChonSanBay:(UIBarButtonItem *)sender {
    if (nTagPicker == 100) {
        [self.edSanBayDi resignFirstResponder];
        if (nIndexSanBayDi == -1) {
            self.edSanBayDi.text = @"Chọn sân bay";
            return;
        }
        else{
            ItemSanBay *item = [arrSanBay objectAtIndex:nIndexSanBayDi];
            self.edSanBayDi.text = item.sTenSanBay;
        }
    }
    else if (nTagPicker == 101) {
        [self.edSanBayVe resignFirstResponder];
        if (nIndexSanBayDi == -1 || nIndexSanBayDen == -1) {
            self.edSanBayVe.text = @"Chọn sân bay";
            return;
        }
        else{
            ItemSanBay *item = [arrSanBay objectAtIndex:nIndexSanBayDi];
            self.edSanBayVe.text = [self layTenSanBayTheoMa:[item.arrSanBayDen objectAtIndex:nIndexSanBayDen]];
        }
    }
    else
    {
        if (nTagPicker == 102) {
            [self.edNguoiLon resignFirstResponder];
        }
        else if (nTagPicker == 103) {
            [self.edTreEm resignFirstResponder];
        }
        else if (nTagPicker == 104) {
            [self.edEmBe resignFirstResponder];
        }
        if (nIndexNguoiLon + nIndexTreEm > 9) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Đặt tối đa 9 vé"];
            nIndexTreEm = 0;
            self.edTreEm.text = @"0";
        }
        if (nIndexEmbe > nIndexNguoiLon) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"1 người lớn chỉ đi kèm 1 em bé"];
            nIndexEmbe = 0;
            self.edEmBe.text = @"0";
            return;
        }
        [arrNguoiDi removeAllObjects];
        for (int i = 0; i < nIndexNguoiLon; i ++) {
            [arrNguoiDi addObject:[NSNumber numberWithInt:0]];
        }
        for (int i = 0; i < nIndexTreEm; i ++) {
            [arrNguoiDi addObject:[NSNumber numberWithInt:1]];
        }
        for (int i = 0; i < nIndexEmbe; i ++) {
            [arrNguoiDi addObject:[NSNumber numberWithInt:2]];
        }

//        int nHeight = (int)arrNguoiDi.count * 80;
        int nHeight = 0;
        for (int i = 0; i < arrNguoiDi.count; i ++) {
            int temp = [[arrNguoiDi objectAtIndex:i] intValue];
            if (temp == 0 || temp == 2) {
                nHeight += 50;
            }
            else {
                nHeight += 80;
            }
        }
        CGRect rectTable = self.tableNguoiDi.frame;
        CGRect rectInfoDi = self.viewThongTinDi.frame;
        CGRect rectChuyenDi = self.viewChuyenDi.frame;
        CGRect rectMain = self.mViewMain.frame;
        CGRect rectToken = self.viewToken.frame;
        CGRect rectNhanVe = self.viewNhanVe.frame;
        CGRect rectHoaDon = self.viewNhanHoaDon.frame;
        
        rectTable.size.height = nHeight;
        rectInfoDi.origin.y = rectTable.size.height + rectTable.origin.y + 5;
        rectChuyenDi.size.height = rectInfoDi.origin.y + rectInfoDi.size.height;
        rectNhanVe.origin.y = rectChuyenDi.origin.y + rectChuyenDi.size.height + 8;
        rectHoaDon.origin.y = rectNhanVe.origin.y + rectNhanVe.size.height + 8;
        self.tableNguoiDi.frame = rectTable;
        self.viewThongTinDi.frame = rectInfoDi;
        self.viewChuyenDi.frame = rectChuyenDi;
        rectToken.origin.y = rectNhanVe.origin.y + rectNhanVe.size.height + 8;
        if(!itemChuyenDen){

        }
        else{
            NSLog(@"%s - itemChuyenDen.hangBay : %d", __FUNCTION__, itemChuyenDen.hangBay);
            CGRect rectChuyenVe = self.viewChuyenVe.frame;
            CGRect rectInfoVe = self.viewThongTinVe.frame;
            if (itemChuyenDen.hangBay == 2) {
                self.tableChuyenVe.hidden = YES;
                rectInfoVe.origin.y = self.tableChuyenVe.frame.origin.y;
                rectChuyenVe.size.height = rectInfoVe.origin.y + rectInfoVe.size.height + 5;
            }
            else{
                self.tableChuyenVe.hidden = NO;
                int nSL = [self.edNguoiLon.text intValue] + [self.edTreEm.text intValue];
                int nHeightChuyenVe = nSL * 44;
                CGRect rectTableVe = self.tableChuyenVe.frame;
                rectTableVe.size.height = nHeightChuyenVe;
                NSLog(@"%s - nHeightChuyenVe : %f", __FUNCTION__, nHeightChuyenVe);
                self.tableChuyenVe.frame = rectTableVe;
                rectInfoVe.origin.y = rectTableVe.origin.y + rectTableVe.size.height;
                rectChuyenVe.size.height = rectInfoVe.origin.y + rectInfoVe.size.height + 5;
            }
            self.viewThongTinVe.frame = rectInfoVe;
            rectChuyenVe.origin.y = rectChuyenDi.origin.y + rectChuyenDi.size.height + 8;
            rectNhanVe.origin.y = rectChuyenVe.origin.y + rectChuyenVe.size.height + 8;
            rectHoaDon.origin.y = rectNhanVe.origin.y + rectNhanVe.size.height + 8;
            rectToken.origin.y = rectHoaDon.origin.y + rectHoaDon.size.height + 8;
            self.viewChuyenVe.frame = rectChuyenVe;
            [self.tableChuyenVe reloadData];
            [self tinhTienVaPhiChuyenVe];
        }
        NSLog(@"%s - ============> xem lai view nhan ve", __FUNCTION__);
        self.viewNhanHoaDon.frame = rectHoaDon;
        self.viewNhanVe.frame = rectNhanVe;
        self.viewToken.frame = rectToken;
        CGRect rectQC = viewQC.frame;
        rectQC.origin.y = rectToken.origin.y + rectToken.size.height + 10;
        rectMain.size.height = rectQC.origin.y + rectQC.size.height + 10;
        viewQC.frame = rectQC;
        self.mViewMain.frame = rectMain;
        if ([self kiemTraCoChucNangQuetVanTay]){
            self.mbtnVanTay.hidden = NO;
            CGRect rectVanTay = self.mbtnVanTay.frame;
            rectVanTay.origin.y = rectMain.origin.y + rectMain.size.height + 5;
            self.mbtnVanTay.frame = rectVanTay;
            [self.scrMain setContentSize:CGSizeMake(self.scrMain.contentSize.width, rectVanTay.origin.y + rectVanTay.size.height + 10)];
        }
        else
            [self.scrMain setContentSize:CGSizeMake(self.scrMain.contentSize.width, rectMain.size.height + 20)];
        [self.tableNguoiDi reloadData];
        [self tinhTienVaPhiChuyenDi];

        double fSoTienDi = [[self.lblTongLuotDi.text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
        double fSoTienVe = [[self.lblTongLuotVe.text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
        nTongTien = 0;
        nTongTien += fSoTienDi;
        nTongTien += fSoTienVe;
        self.lblSoTienThanhToan.text = [Common hienThiTienTe:nTongTien];
    }
}

- (void)sapXepLaiNguoiDi{
    NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
    [arrNguoiDi sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
}

- (void)tinhTienVaPhiChuyenDi{
    nTongTien = 0;
    int nTongTienDi = 0;
    self.lblNguoiLon.text = [NSString stringWithFormat:@"%d x %@", nIndexNguoiLon, [Common hienThiTienTe:itemChuyenDi.gia]];
    int nTienNguoiLon = nIndexNguoiLon * itemChuyenDi.giaNguoiLon;
    int nTienTreEm = nIndexTreEm * itemChuyenDi.giaTreEm;
    int nTienEmBe = nIndexEmbe * itemChuyenDi.giaEmBe;
    //tinh thue va phi
    int nThueVaPhi = 0;
    int nPhiSanBay = 0;
    int nHanhLy = 0;
    int nPhi = 0;
    NSString *sTenSanBay = [self layTenSanBayTheoMa:itemChuyenDi.maSanBayDi];
    NSString *sSanBayHangA = @"Hà Nội, Đà Nẵng, Huế, Nha Trang, Tp. Hồ Chí Minh, Hải phòng, Cần Thơ, Phú Quốc, Đà Lạt, Buôn Mê Thuột, Pleiku";
    if ([sSanBayHangA containsString:sTenSanBay]) {
        nPhi = 80000;
    }
    else
        nPhi = 70000;
    //-- end tinh thue---

    if (itemChuyenDi.hangBay != 2) {
        NSLog(@"%s - nIndexTreEm : %d", __FUNCTION__, nIndexTreEm);
        if (nIndexTreEm > 0) {
            self.lblTreEm.text = [NSString stringWithFormat:@"%d x %@", nIndexTreEm, [Common hienThiTienTe:itemChuyenDi.giaTreEm]];
        }
        else {
            self.lblTreEm.text = @"0";
        }
        if (nIndexEmbe > 0) {
            self.lblEmBe.text = [NSString stringWithFormat:@"%d x %@", nIndexEmbe, [Common hienThiTienTe:itemChuyenDi.giaEmBe]];
        }
        else
        {
            self.lblEmBe.text = @"0";
        }
        nPhiSanBay = ceil((nIndexNguoiLon * nPhi) + (nIndexTreEm * ((nPhi * 50.0) / 100.0)));
        float fThueVaPhi = ((nTienNguoiLon + nTienTreEm + nTienEmBe) * 10.0 / 100.0) + ((nIndexNguoiLon + nIndexTreEm) * 110000);
        nThueVaPhi = ceil(fThueVaPhi / 1000.0) * 1000;

        for (int i = 0; i < [self.tableNguoiDi numberOfRowsInSection:0]; i ++) {
            CellChuyenDi *cell = [self.tableNguoiDi cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            ExTextField *edDanhXungTemp = [cell viewWithTag:1000];
            if (![edDanhXungTemp.text hasPrefix:@"Bé"]) {
                ExTextField *edDanhXungTemp1 = [cell viewWithTag:1002];
                if ([edDanhXungTemp1.text hasSuffix:@"kg"]) {
                    NSString *sKg = [edDanhXungTemp1.text stringByReplacingOccurrencesOfString:@"kg" withString:@""];
                    int nKg = [sKg intValue];
                    NSLog(@"%s - nKg : %d", __FUNCTION__, nKg);
                    nHanhLy += [self laySoTienHanhLy:itemChuyenDi.hangBay nCanHanhLy:nKg  itemChuyenBay:itemChuyenDi];
                    
                }
            }
        }
    }
    else{
        int nGiaTreEm = ceilf((itemChuyenDi.gia * 75.0) / 100.0);
        self.lblTreEm.text = [NSString stringWithFormat:@"%d x %@", nIndexTreEm, [Common hienThiTienTe:nGiaTreEm]];
        nTienTreEm = nIndexTreEm * nGiaTreEm;
        int nGiaEmBe = ceilf((itemChuyenDi.gia * 10.0) / 100.0);
        self.lblEmBe.text = [NSString stringWithFormat:@"%d x %@", nIndexEmbe, [Common hienThiTienTe:nGiaEmBe]];
        nTienEmBe = nIndexEmbe * nGiaEmBe;
        nPhiSanBay = ceil((nIndexNguoiLon * nPhi) + (nIndexTreEm * ((nPhi * 50.0) / 100.0)));
        float fThueVaPhi = ((nTienNguoiLon + nTienTreEm + nTienEmBe) * 10.0 / 100.0);
        nThueVaPhi = ceil(fThueVaPhi / 1000.0) * 1000;
    }
    int nPhiThanhToan = (nIndexTreEm + nIndexNguoiLon) * nPhiVimass;
    self.lblPhiVimass.text = [Common hienThiTienTe:nPhiThanhToan];
    self.lblThuePhi.text = [Common hienThiTienTe:nThueVaPhi];
    self.lblPhiSanBay.text = [Common hienThiTienTe:nPhiSanBay];
    self.lblPhiThanhToan.text = [NSString stringWithFormat:@"%d x %@", (nIndexTreEm + nIndexNguoiLon), [Common hienThiTienTe_1:itemChuyenDi.phiVimass]];
    self.lblHanhLy.text = [Common hienThiTienTe:nHanhLy];
//    nTongTienDi = nTienNguoiLon + nTienTreEm + nTienEmBe + nThueVaPhi + nHanhLy + nPhiThanhToan + nPhiSanBay;
    nTongTienDi = nTienNguoiLon + nTienTreEm + nTienEmBe + nHanhLy;
    //+ nPhiThanhToan
    nTongTienChuyenDi = nTongTienDi;
    
    nTongTien = nTongTienChuyenDi + nTongTienChuyenVe;
    
    self.lblTongLuotDi.text = [Common hienThiTienTe:nTongTienDi];
    self.lblSoTienThanhToan.text = [Common hienThiTienTe:nTongTien];
}

- (void)tinhTienVaPhiChuyenVe{
    int nTongTienDi = 0;
    self.lblNguoiLonVe.text = [NSString stringWithFormat:@"%d x %@", nIndexNguoiLon, [Common hienThiTienTe:itemChuyenDen.gia]];
    int nTienNguoiLon = nIndexNguoiLon * itemChuyenDen.giaNguoiLon;
    int nTienTreEm = nIndexTreEm * itemChuyenDen.giaTreEm;
    int nTienEmBe = nIndexEmbe * itemChuyenDen.giaEmBe;
    //tinh thue va phi
    int nThueVaPhi = 0;
    int nPhiSanBay = 0;
    int nHanhLy = 0;
    int nPhi = 0;
    NSString *sTenSanBay = [self layTenSanBayTheoMa:itemChuyenDen.maSanBayDi];
    NSString *sSanBayHangA = @"Hà Nội, Đà Nẵng, Huế, Nha Trang, Tp. Hồ Chí Minh, Hải phòng, Cần Thơ, Phú Quốc, Đà Lạt, Buôn Mê Thuột, Pleiku";
    if ([sSanBayHangA containsString:sTenSanBay]) {
        nPhi = 80000;
    }
    else
        nPhi = 70000;
    //-- end tinh thue---

    if (itemChuyenDen.hangBay != 2) {
        if (nIndexTreEm > 0) {
            self.lblTreEmVe.text = [NSString stringWithFormat:@"%d x %@", nIndexTreEm, [Common hienThiTienTe:itemChuyenDen.giaTreEm]];
        }
        else {
            self.lblTreEmVe.text = @"0";
        }
        
        if (nIndexEmbe > 0) {
            self.lblEmBeVe.text = [NSString stringWithFormat:@"%d x %@", nIndexEmbe, [Common hienThiTienTe:itemChuyenDen.giaEmBe]];
        }
        else {
            self.lblEmBeVe.text = @"0";
        }
        nPhiSanBay = ceil((nIndexNguoiLon * nPhi) + (nIndexTreEm * ((nPhi * 50.0) / 100.0)));
        float fThueVaPhi = ((nTienNguoiLon + nTienTreEm + nTienEmBe) * 10.0 / 100.0) + ((nIndexNguoiLon + nIndexTreEm) * 110000);
        nThueVaPhi = ceil(fThueVaPhi / 1000.0) * 1000;

        for (int i = 0; i < [self.tableChuyenVe numberOfRowsInSection:0]; i ++) {
            CellChuyenVe *cell = [self.tableChuyenVe cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if ([cell.edHanhLy.text hasSuffix:@"kg"]) {
                NSString *sKg = [cell.edHanhLy.text stringByReplacingOccurrencesOfString:@"kg" withString:@""];
                int nKg = [sKg intValue];
                nHanhLy += [self laySoTienHanhLy:itemChuyenDen.hangBay nCanHanhLy:nKg itemChuyenBay:itemChuyenDen];
            }
        }
    }
    else{
        int nGiaTreEm = ceilf((itemChuyenDen.gia * 75.0) / 100.0);
        self.lblTreEm.text = [NSString stringWithFormat:@"%d x %@", nIndexTreEm, [Common hienThiTienTe:nGiaTreEm]];
        nTienTreEm = nIndexTreEm * nGiaTreEm;
        int nGiaEmBe = ceilf((itemChuyenDen.gia * 10.0) / 100.0);
        self.lblEmBe.text = [NSString stringWithFormat:@"%d x %@", nIndexEmbe, [Common hienThiTienTe:nGiaEmBe]];
        nTienTreEm = nIndexEmbe * nGiaEmBe;
        nPhiSanBay = ceil((nIndexNguoiLon * nPhi) + (nIndexTreEm * ((nPhi * 50.0) / 100.0)));
        float fThueVaPhi = ((nTienNguoiLon + nTienTreEm + nTienEmBe) * 10.0 / 100.0);
        nThueVaPhi = ceil(fThueVaPhi / 1000.0) * 1000;
    }
    int nPhiThanhToan = (nIndexTreEm + nIndexNguoiLon) * nPhiVimass;
    self.lblPhiVimass.text = [Common hienThiTienTe:nPhiThanhToan];
    self.lblThuePhiVe.text = [Common hienThiTienTe:nThueVaPhi];
    self.lblPhiSanBayVe.text = [Common hienThiTienTe:nPhiSanBay];

    self.lblPhiThanhToanVe.text = [NSString stringWithFormat:@"%d x %@", (nIndexTreEm + nIndexNguoiLon), [Common hienThiTienTe:itemChuyenDen.phiVimass]];
    self.lblHanhLyVe.text = [Common hienThiTienTe:nHanhLy];
    
//    nTongTienDi = nTienNguoiLon + nTienTreEm + nTienEmBe + nThueVaPhi + nHanhLy + nPhiThanhToan + nPhiSanBay;
    nTongTienDi = nTienNguoiLon + nTienTreEm + nTienEmBe + nHanhLy;
    NSLog(@"%s - nTienNguoiLon : %d", __FUNCTION__, nTienNguoiLon);
    NSLog(@"%s - nTienTreEm : %d", __FUNCTION__, nTienTreEm);
    NSLog(@"%s - nTienEmBe : %d", __FUNCTION__, nTienEmBe);
    NSLog(@"%s - nHanhLy : %d", __FUNCTION__, nHanhLy);
    NSLog(@"%s - nTongTienDi : %d", __FUNCTION__, nTongTienDi);

    self.lblTongLuotVe.text = [Common hienThiTienTe:nTongTienDi];
    nTongTienChuyenVe = nTongTienDi;
    nTongTien = nTongTienChuyenDi + nTongTienChuyenVe;
    self.lblSoTienThanhToan.text = [Common hienThiTienTe:nTongTien];
}

- (int)laySoTienHanhLy:(int)nHangBay nCanHanhLy:(int)nKg itemChuyenBay:(ItemChuyenBay *)itemChuyenBay{
    NSLog(@"%s - nHangBay : %d", __FUNCTION__, nHangBay);
    int nHanhLy = 0;
    switch (nKg) {
        case 15:
            nHanhLy = itemChuyenBay.gia15KG;
            break;
        case 20:
            nHanhLy = itemChuyenBay.gia20KG;
            break;
        case 25:
            nHanhLy = itemChuyenBay.gia25KG;
            break;
        case 30:
            nHanhLy = itemChuyenBay.gia30KG;
            break;
        case 35:
            nHanhLy = itemChuyenBay.gia35KG;
            break;
        case 40:
            nHanhLy = itemChuyenBay.gia40KG;
            break;
        default:
            nHanhLy = 0;
            break;
    }
    return nHanhLy;
}

- (int)laySoTienHanhLy:(int)nHangBay nCanHanhLy:(int)nKg{
    NSLog(@"%s - nHangBay : %d", __FUNCTION__, nHangBay);
    int nHanhLy = 0;
    if (nHangBay == 0) {
        switch (nKg) {
            case 15:
                nHanhLy = 143000;
                break;
            case 20:
                nHanhLy = 165000;
                break;
            case 25:
                nHanhLy = 220000;
                break;
            case 30:
                nHanhLy = 330000;
                break;
            case 35:
                nHanhLy = 385000;
                break;
            case 40:
                nHanhLy = 440000;
                break;
            default:
                nHanhLy = 0;
                break;
        }
    }
    else{
        switch (nKg) {
            case 15:
                nHanhLy = 150000;
                break;
            case 20:
                nHanhLy = 170000;
                break;
            case 25:
                nHanhLy = 230000;
                break;
            case 30:
                nHanhLy = 300000;
                break;
            case 35:
                nHanhLy = 350000;
                break;
            case 40:
                nHanhLy = 400000;
                break;
            default:
                nHanhLy = 0;
                break;
        }
    }
    return nHanhLy;
}

- (void)cancelChonSanBay:(UIBarButtonItem *)sender
{
    if (nTagPicker == 100) {
        [self.edSanBayDi resignFirstResponder];
    }
    else if (nTagPicker == 101) {
        [self.edSanBayVe resignFirstResponder];
    }
    else if (nTagPicker == 102) {
        [self.edNguoiLon resignFirstResponder];
    }
    else if (nTagPicker == 103) {
        [self.edTreEm resignFirstResponder];
    }
    else if (nTagPicker == 104) {
        [self.edEmBe resignFirstResponder];
    }
}

- (void)khoiTaoDuLieuBanDau{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
        [self hienThiLoadingChuyenTien];
    }
    else {
        [self showLoadingScreen];
    }
    self.mDinhDanhKetNoi = DINH_DANH_TRA_CUU_SAN_BAY_DI_DEN;
    [GiaoDichMang traCuuSanBayDiDen:self];
}

- (void)xuLyKetNoiThanhCong:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua{
    [self hideLoadingScreen];
    if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_TRA_CUU_SAN_BAY_DI_DEN]) {
        NSArray *arrSanBayTemp = (NSArray *)ketQua;
        if (arrSanBayTemp && arrSanBayTemp.count > 0) {
            if (!arrSanBay) {
                arrSanBay = [[NSMutableArray alloc] init];
            }
            [arrSanBay removeAllObjects];
            NSString *sTemp = @"";
            for (int i = 0; i < arrSanBayTemp.count; i ++) {
                NSDictionary *item = [arrSanBayTemp objectAtIndex:i];
                if (![sTemp isEqualToString:[item objectForKey:@"maSanBayDi"]]) {
                    sTemp = [item objectForKey:@"maSanBayDi"];
                    ItemSanBay *temp = [[ItemSanBay alloc] khoiTaoBanDau];
                    temp.sMaSanBay = [item objectForKey:@"maSanBayDi"];
                    temp.sTenSanBay = [self layTenSanBayTheoMa:temp.sMaSanBay];
                    [arrSanBay addObject:temp];
                }
                ItemSanBay *temp = [arrSanBay objectAtIndex:arrSanBay.count - 1];
                [temp.arrSanBayDen addObject:[item objectForKey:@"maSanBayDen"]];
            }
            UIPickerView *picChonPhim = (UIPickerView *)self.edNgayDi.inputView;
            [picChonPhim reloadAllComponents];
            NSLog(@"%s - arrSanBay.count : %ld", __FUNCTION__, (long)arrSanBay.count);
        }
    }
    else if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_THANH_TOAN_MAY_BAY]) {
        NSString *sResult = (NSString *)ketQua;
        NSLog(@"%s - DINH_DANH_THANH_TOAN_MAY_BAY", __FUNCTION__);
        NSLog(@"%s - sResult may bay : sResult : %@", __FUNCTION__, sResult);
//        if (sResult.length > 0) {
//            self.sThongBaoTangGia = @"";
//            self.sIdVeMayBayGiaCao = sResult;
//            NSLog(@"%s - sResult may bay : sIdVeMayBayGiaCao : %@", __FUNCTION__, self.sIdVeMayBayGiaCao);
//            countGiaCao = 0;
//            isDem = YES;
//            [self traCuuVeMayBayGiaCao];
//        }
//        else {
            [self hienThiHopThoaiMotNutBamKieu:1101988 cauThongBao:sThongBao];
//        }
    }
    else if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_TRA_CUU_MAY_BAY_GIA_CAO]) {
        NSDictionary *dict = (NSDictionary *)ketQua;
        int nTrangThai = [[dict valueForKey:@"trangThai"] intValue];
        if (nTrangThai == 30) {
            NSString *sMaDatCho = (NSString *)[dict valueForKey:@"maDatCho"];
            if (![self.sIdVeMayBayGiaCaoResult containsString:sMaDatCho] && self.sIdVeMayBayGiaCaoResult.length > 0) {
                self.sIdVeMayBayGiaCaoResult = [self.sIdVeMayBayGiaCaoResult stringByAppendingString:@";"];
            }
            self.sIdVeMayBayGiaCaoResult = [self.sIdVeMayBayGiaCaoResult stringByAppendingString:sMaDatCho];
            countGiaCao++;
            NSString *tb = (NSString *)[dict valueForKey:@"moTaThayDoi"];
            self.sThongBaoTangGia = [self.sThongBaoTangGia stringByAppendingString:tb];
            self.sThongBaoTangGia = [self.sThongBaoTangGia stringByAppendingString:@"\n"];
            double tien = [[dict valueForKey:@"soTienPhaiThanhToan"] doubleValue];
            soTienPhaiThanhToan += tien;
            int count = 1;
            if ([self.sIdVeMayBayGiaCao containsString:@";"]) {
                count = 2;
            }
            if (countGiaCao == count) {
                isDem = NO;
                [alertVeGiaCao dismissWithClickedButtonIndex:-1 animated:YES];
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(capNhatThoiGianTraCuuGuaCao) object:nil];
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(traCuuVeMayBayGiaCao) object:nil];
                NSLog(@"%s - hien thi view thanh toan : %@", __FUNCTION__, ketQua);
                self.sThongBaoTangGia = [NSString stringWithFormat:@"%@\nSố tiền phải thanh toán: %@", self.sThongBaoTangGia, [Common hienThiTienTe_1:soTienPhaiThanhToan]];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:self.sThongBaoTangGia delegate:self cancelButtonTitle:@"Huỷ" otherButtonTitles: @"Tiếp tục mua", nil];
                alert.tag = 1102000;
                [alert show];
            }

//            [alertVeGiaCao dismissWithClickedButtonIndex:-1 animated:YES];
//            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(capNhatThoiGianTraCuuGuaCao) object:nil];
//            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(traCuuVeMayBayGiaCao) object:nil];
//            NSString *tb = [[dict valueForKey:@"moTaThayDoi"] stringValue];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:tb delegate:self cancelButtonTitle:@"Huỷ" otherButtonTitles: @"Tiếp tục mua", nil];
//            alert.tag = 1102000;
//            [alert show];
        }
        else if (nTrangThai == 0) {
//            NSLog(@"%s - hien thi view thanh toan : %@", __FUNCTION__, ketQua);
        }
        else {
            isDem = NO;
            self.sIdVeMayBayGiaCao = @"";
            self.sIdVeMayBayGiaCaoResult = @"";
            [alertVeGiaCao dismissWithClickedButtonIndex:-1 animated:YES];
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(capNhatThoiGianTraCuuGuaCao) object:nil];
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(traCuuVeMayBayGiaCao) object:nil];
            NSString *tb = (NSString *)[dict valueForKey:@"moTaThayDoi"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:tb delegate:nil cancelButtonTitle:@"Đóng" otherButtonTitles: nil];
            [alert show];
        }

    }
    else if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_TRA_CUU_CHUYEN_BAY]) {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
            [self anLoading];
        }
        else {
            [self hideLoadingScreen];
        }
        NSDictionary *dict = (NSDictionary *)ketQua;
        NSLog(@"%s - ", __FUNCTION__);
        if (dict != nil && [dict isKindOfClass:[NSDictionary class]]) {
            if (!vcChonChuyenBay) {
                vcChonChuyenBay = [[GiaoDienChonChuyenBay alloc] initWithNibName:@"GiaoDienChonChuyenBay" bundle:nil];
                vcChonChuyenBay.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                vcChonChuyenBay.delegate = self;
                navigationController = [[UINavigationController alloc] initWithRootViewController:vcChonChuyenBay];
            }
            vcChonChuyenBay.dicKetQua = (NSDictionary *)ketQua;
            [self.navigationController presentViewController:navigationController animated:YES completion:^{
            }];
        }
        else {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Hệ thống đang trong quá trình xử lý. Vui lòng thử lại sau."];
        }
    }
    else if ([sDinhDanhKetNoi isEqualToString:@"MUA_VE_GIA_CAO"]) {

    }
}

- (void)xuLyKetNoiThatBai:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua {
    NSLog(@"%s - =======>", __FUNCTION__);
    [self hideLoadingScreen];
    if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_TRA_CUU_MAY_BAY_GIA_CAO]) {
        isDem = NO;
        self.sIdVeMayBayGiaCao = @"";
        [alertVeGiaCao dismissWithClickedButtonIndex:-1 animated:YES];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(capNhatThoiGianTraCuuGuaCao) object:nil];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(traCuuVeMayBayGiaCao) object:nil];
    }
    else if ([sDinhDanhKetNoi isEqualToString:@"MUA_VE_GIA_CAO"]) {
        self.viewThanhToanGiaCao.hidden = YES;
    }
    [super xuLyKetNoiThatBai:sDinhDanhKetNoi thongBao:sThongBao ketQua:ketQua];
}

- (void)traCuuVeMayBayGiaCao {
//    NSLog(@"========>");
    if (self.sIdVeMayBayGiaCao.length == 0 || !isDem) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(traCuuVeMayBayGiaCao) object:nil];
        return;
    }
    if (!alertVeGiaCao) {
        alertVeGiaCao = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:@"Đang tiến hành đặt vé, thời gian còn 15:00" delegate:self cancelButtonTitle:@"Huỷ" otherButtonTitles: nil];
        alertVeGiaCao.tag = 1101989;
    }
    [alertVeGiaCao show];
    [self performSelector:@selector(capNhatThoiGianTraCuuGuaCao) withObject:nil afterDelay:1];
    self.mDinhDanhKetNoi = DINH_DANH_TRA_CUU_MAY_BAY_GIA_CAO;
    if ([self.sIdVeMayBayGiaCao containsString:@";"]) {
        NSArray *arrResult = [self.sIdVeMayBayGiaCao componentsSeparatedByString:@";"];
        for (NSString *sIdTemp in arrResult) {
            [GiaoDichMang traCuuTrangThaiVeMayBay:sIdTemp noiNhanKetQua:self];
        }
    }
    else {
        [GiaoDichMang traCuuTrangThaiVeMayBay:self.sIdVeMayBayGiaCao noiNhanKetQua:self];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(traCuuVeMayBayGiaCao) object:nil];
    [self performSelector:@selector(traCuuVeMayBayGiaCao) withObject:nil afterDelay:1];
}

- (void)capNhatThoiGianTraCuuGuaCao {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(capNhatThoiGianTraCuuGuaCao) object:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.timeGiaCao -= 1;
        if (self.timeGiaCao <= 1) {

        }
        else {
            int phut = self.timeGiaCao / 60;
            int giay = self.timeGiaCao % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (giay < 10) {
                    [alertVeGiaCao setMessage:[NSString stringWithFormat:@"Đang tiến hành đặt vé, thời gian còn %d:0%d", phut, giay]];
                }
                else {
                    [alertVeGiaCao setMessage:[NSString stringWithFormat:@"Đang tiến hành đặt vé, thời gian còn %d:%d", phut, giay]];
                }
                [self performSelector:@selector(capNhatThoiGianTraCuuGuaCao) withObject:nil afterDelay:1];
            });
        }
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    if (alertView.tag == 1101988) {
        NSLog(@"%s - hien thi progress view loading", __FUNCTION__);
    }
    else if (alertView.tag == 1101989) {
        self.timeGiaCao = 900;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(traCuuVeMayBayGiaCao) object:nil];
    }
    else if (alertView.tag == 1102000) {
        if (buttonIndex == 1) {
            NSLog(@"%s - show form token", __FUNCTION__);
            if (![self.view.subviews containsObject:self.viewThanhToanGiaCao]) {
                self.viewThanhToanGiaCao.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                [self.view addSubview:self.viewThanhToanGiaCao];
            }
            self.viewThanhToanGiaCao.hidden = NO;
        }
    }
}

- (NSString *)layTenSanBayTheoMa:(NSString *)sMa{
    NSString *sTen = @"";
    if ([sMa isEqualToString:@"SGN"]) {
        sTen = @"Tp. Hồ Chí Minh";
    }
    else if ([sMa isEqualToString:@"HAN"]) {
        sTen = @"Hà Nội";
    }
    else if ([sMa isEqualToString:@"DAD"]) {
        sTen = @"Đà Nẵng";
    }
    else if ([sMa isEqualToString:@"CXR"]) {
        sTen = @"Nha Trang";
    }
    else if ([sMa isEqualToString:@"HPH"]) {
        sTen = @"Hải Phòng";
    }
    else if ([sMa isEqualToString:@"HUI"]) {
        sTen = @"Huế";
    }
    else if ([sMa isEqualToString:@"PQC"]) {
        sTen = @"Phú Quốc";
    }
    else if ([sMa isEqualToString:@"DLI"]) {
        sTen = @"Đà Lạt";
    }
    else if ([sMa isEqualToString:@"BMV"]) {
        sTen = @"Buôn Ma Thuột";
    }
    else if ([sMa isEqualToString:@"CAH"]) {
        sTen = @"Cà Mau";
    }
    else if ([sMa isEqualToString:@"DIN"]) {
        sTen = @"Điện Biên Phủ";
    }
    else if ([sMa isEqualToString:@"PXU"]) {
        sTen = @"Pleiku";
    }
    else if ([sMa isEqualToString:@"TBB"]) {
        sTen = @"Tuy Hòa";
    }
    else if ([sMa isEqualToString:@"THD"]) {
        sTen = @"Thanh Hóa";
    }
    else if ([sMa isEqualToString:@"UIH"]) {
        sTen = @"Quy Nhơn";
    }
    else if ([sMa isEqualToString:@"VCA"]) {
        sTen = @"Cần Thơ";
    }
    else if ([sMa isEqualToString:@"VCL"]) {
        sTen = @"Quảng Nam-Chu Lai";
    }
    else if ([sMa isEqualToString:@"VCS"]) {
        sTen = @"Côn Đảo";
    }
    else if ([sMa isEqualToString:@"VDH"]) {
        sTen = @"Đồng Hới";
    }
    else if ([sMa isEqualToString:@"VII"]) {
        sTen = @"Vinh";
    }
    else if ([sMa isEqualToString:@"BKK"]) {
        sTen = @"Bangkok";
    }
    else if ([sMa isEqualToString:@"SIN"]) {
        sTen = @"Singpore";
    }
    else if ([sMa isEqualToString:@"VKG"]) {
        sTen = @"Rạch Giá";
    }

    return sTen;
}

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    return [calendar dateIsInCurrentMonth:date];
}

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date {
    return YES;
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date{
    NSDate *today = [NSDate date];
    NSCalendar *mCal = [NSCalendar currentCalendar];
    NSDateComponents *components = [mCal components:(NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
    NSDateComponents *components2 = [mCal components:(NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:today];

    NSString *sDate = [NSString stringWithFormat:@"%ld/%ld/%ld", (long)components.day, (long)components.month, (long)components.year];
    NSString *sTimeCanLay = [NSString stringWithFormat:@"%ld%ld%ld", (long)components.year, (long)components.month, (long)components.day];
    if (components.day <= 9 && components.month <= 9) {
        sDate = [NSString stringWithFormat:@"0%ld/0%ld/%ld", (long)components.day, (long)components.month, (long)components.year];
        sTimeCanLay = [NSString stringWithFormat:@"%ld0%ld0%ld", (long)components.year, (long)components.month, (long)components.day];
    }
    else if (components.day <= 9){
        sDate = [NSString stringWithFormat:@"0%ld/%ld/%ld", (long)components.day, (long)components.month, (long)components.year];
        sTimeCanLay = [NSString stringWithFormat:@"%ld%ld0%ld", (long)components.year, (long)components.month, (long)components.day];
    }
    else if (components.month <=  9){
        sDate = [NSString stringWithFormat:@"%ld/0%ld/%ld", (long)components.day, (long)components.month, (long)components.year];
        sTimeCanLay = [NSString stringWithFormat:@"%ld0%ld%ld", (long)components.year, (long)components.month, (long)components.day];
    }
    if (nIndexChonCalendar == 0) {
        self.edNgayDi.text = sDate;
        if (![self checkNgayChonChuyen:components date2:components2]) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Thời điểm được chọn phải lớn hơn hoặc bằng thời điểm hiện tại"];
            return;
        }
    }
    else
    {
        NSLog(@"%s - self.edNgayDi.text : %@", __FUNCTION__, self.edNgayDi.text);
        if (self.edNgayDi.text.length > 0) {
//            NSLog(@"%s - sTimeDi : %@", __FUNCTION__, _sTimeDi);
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"dd/MM/yyyy"];
            NSDate *myDate = [df dateFromString: self.edNgayDi.text];
            NSDateComponents *components3 = [mCal components:(NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit) fromDate:myDate];
//            NSLog(@"%s - %d : %d : %d", __FUNCTION__, components3.day, components3.month, components3.year);
            [df release];
            if ([self checkNgayChonChuyen:components date2:components3]) {
//                sTimeVe = sTimeCanLay;
                self.edNgayVe.text = sDate;
            }
            else
                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Thời gian về phải lớn hơn thời gian đi"];
        }
        else{
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng chọn thời gian đi trước"];
        }
    }
    self.viewCalendar.hidden = YES;
}

- (BOOL)checkNgayChonChuyen:(NSDateComponents *)date1 date2:(NSDateComponents *)date2{
    NSLog(@"%s - 1: %ld - 2: %ld", __FUNCTION__, (long)date1.month, (long)date2.month);
    NSLog(@"%s - 1: %ld - 2: %ld", __FUNCTION__, (long)date1.day, (long)date2.day);
    if (date1.year == date2.year) {
        if (date1.month < date2.month) {
            return NO;
        }
        else if (date1.month == date2.month && date1.day < date2.day) {
            return NO;
        }
    }
    return YES;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 100) {
        return arrSanBay.count + 1;
    }
    else if (pickerView.tag == 101) {
        if (nIndexSanBayDi == -1) {
            return 1;
        }
        else{
            ItemSanBay *temp = [arrSanBay objectAtIndex:nIndexSanBayDi];
            return temp.arrSanBayDen.count + 1;
        }
    }
    else if (pickerView.tag == 102) {
        return 9;
    }
    else if (pickerView.tag == 103) {
        if (nIndexNguoiLon <= 9) {
            return 9 - (nIndexNguoiLon - 1);
        }
        return 0;
    }
    else if (pickerView.tag == 104) {
        return 3;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    nTagPicker = (int)pickerView.tag;
    if (pickerView.tag == 100) {
        if (row == 0) {
            return @"Chọn sân bay";
        }
        ItemSanBay *temp = [arrSanBay objectAtIndex:row - 1];
        return temp.sTenSanBay;
    }
    else if (pickerView.tag == 101) {
        if (row == 0) {
            return @"Chọn sân bay";
        }
        ItemSanBay *temp = [arrSanBay objectAtIndex:nIndexSanBayDi];
        NSString *sMa = [temp.arrSanBayDen objectAtIndex:row - 1];
        return [self layTenSanBayTheoMa:sMa];
    }
    else if (pickerView.tag == 102) {
        NSString *sTitle = [NSString stringWithFormat:@"%d", (int)row + 1];
        return sTitle;
    }
    else if (pickerView.tag == 103 || pickerView.tag == 104) {
        NSString *sTitle = [NSString stringWithFormat:@"%ld", (long)row];
        return sTitle;
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    nTagPicker = (int)pickerView.tag;
    if (nTagPicker == 100) {
        nIndexSanBayDi = (int)row - 1;
    }
    else if (nTagPicker == 101) {
         nIndexSanBayDen = (int)row - 1;
    }
    else if (pickerView.tag == 102) {
        NSString *sTitle = [NSString stringWithFormat:@"%ld", (long)(row + 1)];
        self.edNguoiLon.text = sTitle;
        nIndexNguoiLon = (int)row + 1;
    }
    else if (pickerView.tag == 103) {
        NSString *sTitle = [NSString stringWithFormat:@"%ld", (long)row];
        self.edTreEm.text = sTitle;
        nIndexTreEm = (int)row;
    }
    else if (pickerView.tag == 104) {
        NSString *sTitle = [NSString stringWithFormat:@"%ld", (long)row];
        self.edEmBe.text = sTitle;
        nIndexEmbe = (int)row;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.tableChuyenVe]) {
//        NSLog(@"%s =============> tableChuyenVe : %d", __FUNCTION__, [self.edNguoiLon.text intValue] + [self.edTreEm.text intValue]);
        return [self.edNguoiLon.text intValue] + [self.edTreEm.text intValue];
    }
//    int nCount = [self.edNguoiLon.text intValue] + [self.edTreEm.text intValue] + [self.edEmBe.text intValue];
    return arrNguoiDi.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tableNguoiDi]) {
        int nKieu = [[arrNguoiDi objectAtIndex:indexPath.row] intValue];
        if (nKieu == 0) {
            return 40.0;
        }
        return 80.0;
    }
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.tableNguoiDi]) {
        static NSString *cellIdentifier = @"CellChuyenDi";
        CellChuyenDi *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        if (!cell.delegate) {
            cell.delegate = self;
        }
        if (itemChuyenDi.hangBay == 2) {
            cell.edOptionHanhLy.hidden = YES;
        }
        else{
            cell.edOptionHanhLy.hidden = NO;
        }
        int nKieu = [[arrNguoiDi objectAtIndex:indexPath.row] intValue];
//        NSLog(@"%s - nKieu : %d", __FUNCTION__, nKieu);
        cell.nKieu = nKieu;
        [cell khoiTaoNguoiLon];
        return cell;
    }
    static NSString *cellIdentifierVe = @"CellChuyenVe";
    CellChuyenVe *cellVe = [tableView dequeueReusableCellWithIdentifier:cellIdentifierVe forIndexPath:indexPath];
    if (!cellVe) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifierVe owner:self options:nil];
        cellVe = [nib objectAtIndex:0];
    }
    cellVe.lblKhachHang.text = [NSString stringWithFormat:@"Khách hàng %d", (int)indexPath.row + 1];
    if (!cellVe.delegate) {
        cellVe.delegate = self;
    }
    return cellVe;
}

- (void)suKienThayDoiChonHanhLy{
    NSLog(@"%s - thay doi chon hanh ly", __FUNCTION__);
    [self tinhTienVaPhiChuyenDi];
}

- (void)suKienChonHanhLyChuyenVe{
    [self tinhTienVaPhiChuyenVe];
}

- (NSString *)layTenHangBay:(int)nHang{
    NSString *sTen = @"";
    switch (nHang) {
        case 0:
            sTen = @"VietJet Air";
            break;
        case 1:
            sTen = @"Jetstart";
            break;
        case 2:
            sTen = @"Vietnam Airlines";
            break;
        default:
            break;
    }
    return sTen;
}

- (IBAction)suKienChonNgayDi:(id)sender {
    nIndexChonCalendar = 0;
    self.viewCalendar.hidden = NO;
}

- (IBAction)suKienChonNgayVe:(id)sender {
    nIndexChonCalendar = 1;
    self.viewCalendar.hidden = NO;
}

- (IBAction)suKienBamNutCloseCalendar:(id)sender {
    self.viewCalendar.hidden = YES;
    if (nIndexChonCalendar == 0) {
        self.edNgayDi.text = @"";
//        sTimeDi = @"";
    }
    else{
        self.edNgayVe.text = @"";
//        sTimeVe = @"";
    }
}

- (NSString *)getThoiGianTruyenLenServer:(NSString *)sDate {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy"];
    NSDate *myDate = [df dateFromString: sDate];
    NSString *sThang = [NSString stringWithFormat:@"%d", myDate.month];
    NSString *sDay = [NSString stringWithFormat:@"%d", myDate.day];
    if (myDate.month <= 9) {
        sThang = [NSString stringWithFormat:@"0%d", myDate.month];
    }
    if (myDate.day <= 9) {
        sDay = [NSString stringWithFormat:@"0%d", myDate.day];
    }
    return [NSString stringWithFormat:@"%d%@%@", myDate.year, sThang, sDay];
}

- (IBAction)suKienChonTraCuu:(id)sender {
    if (!arrSanBay || arrSanBay.count == 0) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Có lỗi khi lấy danh sách sân bay"];
        return;
    }
    if (nIndexSanBayDi < 0) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng chọn sân bay đi"];
        return;
    }
    if (nIndexSanBayDen < 0) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng chọn sân bay đến"];
        return;
    }
    if ([self.edNgayDi.text isEmpty]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng chọn thời gian đi"];
        return;
    }
    nTongTien = 0;
    ItemSanBay *item = [arrSanBay objectAtIndex:nIndexSanBayDi];
    NSString *sMaSanBayDi = item.sMaSanBay;
    NSString *sMaSanBayDen = [item.arrSanBayDen objectAtIndex:nIndexSanBayDen];
    NSLog(@"%s - sMaSanBayDi : %@", __FUNCTION__, sMaSanBayDi);
    NSLog(@"%s - sMaSanBayDen : %@", __FUNCTION__, sMaSanBayDen);
    NSLog(@"%s - ngay di : %@", __FUNCTION__, [self getThoiGianTruyenLenServer:self.edNgayDi.text]);
    NSLog(@"%s - ngay ve : %@", __FUNCTION__, [self getThoiGianTruyenLenServer:self.edNgayVe.text]);
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
        [self hienThiLoadingChuyenTien];
    }
    else {
        [self showLoadingScreen];
    }
    self.mDinhDanhKetNoi = DINH_DANH_TRA_CUU_CHUYEN_BAY;
    [GiaoDichMang traCuuChuyenBay:sMaSanBayDi sMaSanBayDen:sMaSanBayDen sTimeDi:[self getThoiGianTruyenLenServer:self.edNgayDi.text] sTimeDen:[self getThoiGianTruyenLenServer:self.edNgayVe.text] slNguoiLon:nIndexNguoiLon slTreEm:nIndexTreEm slEmBe:nIndexEmbe noiNhanKetQua:self];
//    [GiaoDichMang traCuuChuyenBay:sMaSanBayDi sMaSanBayDen:sMaSanBayDen sTimeDi:[self getThoiGianTruyenLenServer:self.edNgayDi.text] sTimeDen:[self getThoiGianTruyenLenServer:self.edNgayVe.text] noiNhanKetQua:self];
}

- (IBAction)suKienChonSoTayHoaDon:(id)sender {
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return;
    }
    DucNT_DanhSachTaiKhoanThuongDungControllerViewController *vc = [[DucNT_DanhSachTaiKhoanThuongDungControllerViewController alloc] initWithType:TAI_KHOAN_HOA_DON_MAY_BAY];
    [self.navigationController presentViewController:vc animated:YES completion:^{}];
    [vc release];
}

- (void)chonChuyenBay:(ItemChuyenBay *)itemDi itemDen:(ItemChuyenBay *)itemDen{
    if (itemDi) {
        itemChuyenDi = itemDi;
        itemChuyenDen = itemDen;
        NSLog(@"%s - itemChuyenDi : %@", __FUNCTION__, itemChuyenDi.thoiGian);
        NSLog(@"%s - itemChuyenDen : %@", __FUNCTION__, itemChuyenDen.thoiGian);
        int nHeight = 0;
        for (int i = 0; i < arrNguoiDi.count; i ++) {
            int temp = [[arrNguoiDi objectAtIndex:i] intValue];
            if (temp == 0 || temp == 2) {
                nHeight += 55;
            }
            else {
               nHeight += 80;
            }
        }
//        int nHeight = (int)arrNguoiDi.count * 80;
        CGRect rectTable = self.tableNguoiDi.frame;
        CGRect rectInfoDi = self.viewThongTinDi.frame;
        CGRect rectChuyenDi = self.viewChuyenDi.frame;
        CGRect rectMain = self.mViewMain.frame;
        CGRect rectToken = self.viewToken.frame;
        CGRect rectNhanVe = self.viewNhanVe.frame;
        CGRect rectOption = self.btnChonVeMayBay.frame;
        rectTable.size.height = nHeight;
        self.tableNguoiDi.alwaysBounceVertical = NO;
        rectInfoDi.origin.y = rectTable.size.height + rectTable.origin.y + 5;
        rectChuyenDi.size.width = rectMain.size.width;
        rectChuyenDi.origin.y = rectOption.origin.y + rectOption.size.height + 8;
        rectChuyenDi.size.height = rectInfoDi.origin.y + rectInfoDi.size.height;
        rectNhanVe.origin.y = rectChuyenDi.origin.y + rectChuyenDi.size.height + 8;
        self.tableNguoiDi.frame = rectTable;
        self.viewThongTinDi.frame = rectInfoDi;
        self.viewChuyenDi.frame = rectChuyenDi;
        
        CGRect rectNhanHoaDon = self.viewNhanHoaDon.frame;
        rectNhanHoaDon.origin.y = rectNhanVe.origin.y + rectNhanVe.size.height + 8;
        rectToken.origin.y = rectNhanHoaDon.origin.y + rectNhanHoaDon.size.height + 8;

        if (![self.mViewMain.subviews containsObject:self.viewChuyenDi]) {
            [self.mViewMain addSubview:self.viewChuyenDi];
        }
        self.viewChuyenDi.hidden = NO;
        
        if (![self.mViewMain.subviews containsObject:self.viewNhanHoaDon]) {
            rectNhanHoaDon.size.width = rectMain.size.width;
            [self.mViewMain addSubview:self.viewNhanHoaDon];
        }
        self.viewNhanHoaDon.hidden = NO;
        
        [self.scrMain setContentSize:CGSizeMake(self.scrMain.contentSize.width, rectMain.size.height + 10)];
        self.lblChuyenDi.text = [NSString stringWithFormat:@"Đi %@ %@-%@ %@ %@ %@ %@", [self getNgayBay:[self getThoiGianTruyenLenServer:self.edNgayDi.text]], itemChuyenDi.maSanBayDi, itemChuyenDi.maSanBayDen, [self layTenHangBay:itemChuyenDi.hangBay], itemChuyenDi.maChuyenBay, itemChuyenDi.gioBay, itemChuyenDi.gioDen];
        [self tinhTienVaPhiChuyenDi];
        if (itemChuyenDen) {
            self.lblChuyenVe.text = [NSString stringWithFormat:@"Về %@ %@-%@ %@ %@ %@ %@", [self getNgayBay:[self getThoiGianTruyenLenServer:self.edNgayVe.text]], itemChuyenDen.maSanBayDi, itemChuyenDen.maSanBayDen, [self layTenHangBay:itemChuyenDen.hangBay], itemChuyenDen.maChuyenBay, itemChuyenDen.gioBay, itemChuyenDen.gioDen];

            CGRect rectChuyenVe = self.viewChuyenVe.frame;
            CGRect rectInfoVe = self.viewThongTinVe.frame;
            CGRect rectTableChuyenVe = self.tableChuyenVe.frame;
            
            if (itemChuyenDen.hangBay == 2) {
                self.tableChuyenVe.hidden = YES;
                rectInfoVe.origin.y = self.tableChuyenVe.frame.origin.y;
                rectChuyenVe.size.height = rectInfoVe.origin.y + rectInfoVe.size.height + 8;
            }
            else{
                self.tableChuyenVe.hidden = NO;
                int nSL = [self.edNguoiLon.text intValue] + [self.edTreEm.text intValue];
                int nHeightChuyenVe = nSL * 44;
                rectTableChuyenVe.size.height = nHeightChuyenVe;
                NSLog(@"%s - nSL : %d - nHeightChuyenVe : %d", __FUNCTION__, nSL, nHeightChuyenVe);
                rectInfoVe.origin.y = rectTableChuyenVe.origin.y + rectTableChuyenVe.size.height;
                rectChuyenVe.size.height = rectInfoVe.origin.y + rectInfoVe.size.height + 5;
            }
            rectChuyenVe.size.width = rectMain.size.width;
            rectChuyenVe.origin.y = rectChuyenDi.origin.y + rectChuyenDi.size.height + 8;

            rectNhanVe.size.width = rectMain.size.width - 5;
            rectNhanVe.origin.y = rectChuyenVe.origin.y + rectChuyenVe.size.height + 8;
            rectToken.size.width = rectMain.size.width - 5;
            rectNhanHoaDon.origin.y = rectNhanVe.origin.y + rectNhanVe.size.height + 8;
            rectToken.origin.y = rectNhanHoaDon.origin.y + rectNhanHoaDon.size.height + 8;
            
            self.tableChuyenVe.frame = rectTableChuyenVe;
            self.viewChuyenVe.frame = rectChuyenVe;
            self.viewThongTinVe.frame = rectInfoVe;
            if (![self.mViewMain.subviews containsObject:self.viewChuyenVe]) {
                [self.mViewMain addSubview:self.viewChuyenVe];
            }
            self.viewChuyenVe.hidden = NO;
            [self tinhTienVaPhiChuyenVe];
        }
        else {
            rectNhanHoaDon.origin.y = rectNhanVe.origin.y + rectNhanVe.size.height + 8;
            rectToken.origin.y = rectNhanHoaDon.origin.y + rectNhanHoaDon.size.height + 8;
        }
        if (![self.mViewMain.subviews containsObject:self.viewNhanVe]) {
            [self.mViewMain addSubview:self.viewNhanVe];
        }
        if (![self.mViewMain.subviews containsObject:self.viewToken]) {
            [self.mViewMain addSubview:self.viewToken];
        }
        self.viewNhanVe.frame = rectNhanVe;
        self.viewToken.frame = rectToken;
        self.viewNhanHoaDon.frame = rectNhanHoaDon;
        self.viewToken.hidden = NO;
        CGRect rectQC = viewQC.frame;
        rectQC.origin.y = rectToken.origin.y + rectToken.size.height + 10;
        rectMain.size.height = rectQC.origin.y + rectQC.size.height + 10;
        viewQC.frame = rectQC;
        self.mViewMain.frame = rectMain;
        if ([self kiemTraCoChucNangQuetVanTay]){
            self.mbtnVanTay.hidden = NO;
            CGRect rectVanTay = self.mbtnVanTay.frame;
            rectVanTay.origin.y = rectMain.origin.y + rectMain.size.height + 5;
            self.mbtnVanTay.frame = rectVanTay;
            [self.scrMain setContentSize:CGSizeMake(self.scrMain.contentSize.width, rectVanTay.origin.y + rectVanTay.size.height + 10)];
        }
        else
            [self.scrMain setContentSize:CGSizeMake(self.scrMain.contentSize.width, rectMain.size.height + 20)];

        self.edSDT.text = [DucNT_LuuRMS layThongTinDangNhap:KEY_PHONE_AUTHENTICATE];
        self.edEmail.text = [DucNT_LuuRMS layThongTinDangNhap:KEY_EMAIL_AUTHENTICATE];

        double fSoTienDi = [[self.lblTongLuotDi.text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
        double fSoTienVe = [[self.lblTongLuotVe.text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
        nTongTien = 0;
        nTongTien += fSoTienDi;
        nTongTien += fSoTienVe;
        self.lblSoTienThanhToan.text = [Common hienThiTienTe:nTongTien];
        if(![CommonUtils isEmptyOrNull:self.mThongTinTaiKhoanVi.pki3] && [self.mThongTinTaiKhoanVi.hanMucPki3 doubleValue] >0 ){
            if(fSoTienDi+ fSoTienVe > [self.mThongTinTaiKhoanVi.hanMucPki3 doubleValue]){
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
    }
    [self.tableNguoiDi reloadData];
}

- (NSString *)getNgayBay:(NSString *)sTime{
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    NSDate *date = [[NSDate alloc] init];
    date = [dateFormat dateFromString:sTime];
    NSDateComponents *dateComponents = [sysCalendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:date];
    return [NSString stringWithFormat:@"%ld/%ld/%ld", (long)dateComponents.day, (long)dateComponents.month, (long)dateComponents.year];
}

- (BOOL)validateVanTay{
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return NO;
    }
    for (int i = 0; i < [self.tableNguoiDi numberOfRowsInSection:0]; i ++) {
        CellChuyenDi *cell = [self.tableNguoiDi cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        ExTextField *edDanhXungTemp = [cell viewWithTag:1001];
        if ([edDanhXungTemp.text isEmpty]) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập họ và tên người đi"];
            return NO;
        }
    }
    if ([self.edSDT.text isEmpty]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập số điện thoại nhận mã đặt chỗ"];
        return NO;
    }
    else if (self.edSDT.text.length < 10 || self.edSDT.text.length > 11) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Số điện thoại nhận mã đặt chỗ không đúng định dạng"];
        return NO;
    }
    if ([self.edEmail.text isEmpty]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập email nhận vé"];
        return NO;
    }
    else if (![self NSStringIsValidEmail:self.edEmail.text]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Email nhận vé không đúng định dạng"];
        return NO;
    }
    return YES;
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (IBAction)suKienXacThucMuaVeGiaCao:(id)sender {
    if (self.edToken.text.length == 0) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập mã xác thực"];
    }
    else {
        NSString *token = @"";
        NSString *otp = @"";
        if(self.mTypeAuthenticate == TYPE_AUTHENTICATE_TOKEN)
        {
            NSString *sMatKhau = @"";
            sMatKhau = self.edToken.text;
            NSString *sSeed = [DucNT_Token laySeedTokenHienTai];
            if(sSeed != nil && sSeed.length > 0)
            {
                token = [DucNT_Token OTPFromPIN:sMatKhau seed:sSeed];
            }
            else
            {
                [[[[UIAlertView alloc] initWithTitle:[@"@thong_bao" localizableString]  message:[@"@can_tao_token" localizableString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
                return;
            }
        }
        else
        {
            otp = self.mtfMatKhauToken.text;
        }
        self.mDinhDanhKetNoi = @"MUA_VE_GIA_CAO";
        [self showLoadingScreen];
//        [GiaoDichMang muaVeMayBayGiaCao:self.sIdVeMayBayGiaCao token:token otpConfirm:otp typeAuthenticate:self.mTypeAuthenticate noiNhanKetQua:self];
        [GiaoDichMang muaVeMayBayGiaCao:self.sIdVeMayBayGiaCaoResult token:token otpConfirm:otp typeAuthenticate:self.mTypeAuthenticate noiNhanKetQua:self];
    }
}

- (void)xuLyThucHienKhiKiemTraThanhCongTraVeToken:(NSString *)sToken otp:(NSString *)sOtp{
    NSMutableArray *arrNguoiBay1 = [[NSMutableArray alloc] init];
    NSMutableArray *arrTreEm1 = [[NSMutableArray alloc] init];
    NSMutableArray *arrEmBe1 = [[NSMutableArray alloc] init];
    NSMutableArray *arrNguoiBay2 = [[NSMutableArray alloc] init];
    NSMutableArray *arrTreEm2 = [[NSMutableArray alloc] init];
    NSMutableArray *arrEmBe2 = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.tableNguoiDi numberOfRowsInSection:0]; i ++) {
        CellChuyenDi *cell = [self.tableNguoiDi cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        ExTextField *edDanhXungTemp = [cell viewWithTag:1000];
        ExTextField *edHoTenTemp = [cell viewWithTag:1001];
        ExTextField *edHanhLyTemp = [cell viewWithTag:1002];
        ExTextField *edNgaySinh = [cell viewWithTag:1003];
        int nIndexDanhXung = 1;
        if ([edDanhXungTemp.text isEqualToString:@"Bà"]) {
            nIndexDanhXung = 2;
        }
        else if ([edDanhXungTemp.text isEqualToString:@"Trai"]) {
            nIndexDanhXung = 3;
        }
        else if ([edDanhXungTemp.text isEqualToString:@"Gái"]) {
            nIndexDanhXung = 4;
        }
        else if ([edDanhXungTemp.text hasPrefix:@"Bé"]){
            nIndexDanhXung = 5;
        }
        int nMaHanhLy = 0;
        NSString *sNgaySinh = @"";
        if ([edHanhLyTemp.text hasSuffix:@"kg"]) {
            NSString *sKg = [edHanhLyTemp.text stringByReplacingOccurrencesOfString:@"kg" withString:@""];
            int nKg = [sKg intValue];
            nMaHanhLy = [self getMaHanhLy:nKg];
        }
//        else if (![edHanhLyTemp.text hasPrefix:@"Ko"]){
//            sNgaySinh = edNgaySinh.text;
//        }
        
        sNgaySinh = edNgaySinh.text;
        
        NSDictionary *dicNguoiBay = @{@"xungDanh" : [NSNumber numberWithInt:nIndexDanhXung],
                                    @"ten" : edHoTenTemp.text,
                                    @"maHanhLy" : [NSNumber numberWithInt:nMaHanhLy],
                                    @"ngaySinh" : sNgaySinh};
        if (nIndexDanhXung == 1 || nIndexDanhXung == 2) {
            [arrNguoiBay1 addObject:dicNguoiBay];
            if ([self.tableChuyenVe numberOfRowsInSection:0] > i) {
                CellChuyenVe *cellVe = [self.tableChuyenVe cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                int nMaHanhLy2 = 0;
                if ([cellVe.edHanhLy.text hasSuffix:@"kg"]) {
                    NSString *sKg2 = [cellVe.edHanhLy.text stringByReplacingOccurrencesOfString:@"kg" withString:@""];
                    nMaHanhLy2 = [self getMaHanhLy:[sKg2 intValue]];
                }
                NSDictionary *dicNguoiBayTemp = @{@"xungDanh" : [NSNumber numberWithInt:nIndexDanhXung],
                                                  @"ten" : edHoTenTemp.text,
                                                  @"maHanhLy" : [NSNumber numberWithInt:nMaHanhLy2],
                                                  @"ngaySinh" : sNgaySinh};
                [arrNguoiBay2 addObject:dicNguoiBayTemp];
            }
        }
        else if (nIndexDanhXung == 3 || nIndexDanhXung == 4) {
            [arrTreEm1 addObject:dicNguoiBay];
            if ([self.tableChuyenVe numberOfRowsInSection:0] > i) {
                CellChuyenVe *cellVe = [self.tableChuyenVe cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                int nMaHanhLy2 = 0;
                if ([cellVe.edHanhLy.text hasSuffix:@"kg"]) {
                    NSString *sKg2 = [cellVe.edHanhLy.text stringByReplacingOccurrencesOfString:@"kg" withString:@""];
                    nMaHanhLy2 = [self getMaHanhLy:[sKg2 intValue]];
                }
                NSDictionary *dicNguoiBayTemp = @{@"xungDanh" : [NSNumber numberWithInt:nIndexDanhXung],
                                                  @"ten" : edHoTenTemp.text,
                                                  @"maHanhLy" : [NSNumber numberWithInt:nMaHanhLy2],
                                                  @"ngaySinh" : sNgaySinh};
                [arrTreEm2 addObject:dicNguoiBayTemp];
            }
        }
        else{
            [arrEmBe1 addObject:dicNguoiBay];
            [arrEmBe2 addObject:dicNguoiBay];
        }
    }
    int fSoTienDi = [[self.lblTongLuotDi.text stringByReplacingOccurrencesOfString:@"." withString:@""] intValue];
    int fSoTienVe = [[self.lblTongLuotVe.text stringByReplacingOccurrencesOfString:@"." withString:@""] intValue];

    NSMutableDictionary *dic1 = [[NSMutableDictionary alloc] init];
    [dic1 setValue:[NSNumber numberWithInt:self.mFuncID] forKey:@"funcId"];
    [dic1 setValue:[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP] forKey:@"user"];
    [dic1 setValue:sToken forKey:@"token"];
    [dic1 setValue:sOtp forKey:@"otpConfirm"];
    [dic1 setValue:[NSNumber numberWithInt:self.mTypeAuthenticate] forKey:@"typeAuthenticate"];
    [dic1 setValue:[NSNumber numberWithInt:APP_ID] forKey:@"appId"];
    [dic1 setValue:[NSNumber numberWithInt:VM_APP] forKey:@"VMApp"];
    [dic1 setValue:itemChuyenDi.maSanBayDi forKey:@"maSanBayDi"];
    [dic1 setValue:itemChuyenDi.maSanBayDen forKey:@"maSanBayDen"];
    [dic1 setValue:[NSNumber numberWithInt:itemChuyenDi.hangBay] forKey:@"hangBay1"];
    [dic1 setValue:itemChuyenDi.maChuyenBay forKey:@"maChuyenBay1"];
    [dic1 setValue:itemChuyenDi.thoiGian forKey:@"thoiGian1"];
    [dic1 setValue:itemChuyenDi.gioBay forKey:@"gioBayDi1"];
    [dic1 setValue:arrNguoiBay1 forKey:@"dsNguoiLon1"];
    [dic1 setValue:[NSNumber numberWithInteger:arrNguoiBay1.count] forKey:@"slNguoiLon"];
    if (arrTreEm1.count > 0) {
        [dic1 setValue:arrTreEm1 forKey:@"dsTreEm1"];
        [dic1 setValue:[NSNumber numberWithInteger:arrTreEm1.count] forKey:@"slTreEm"];
    }
    if (arrEmBe1.count > 0) {
        [dic1 setValue:arrEmBe1 forKey:@"dsEmBe1"];
        [dic1 setValue:[NSNumber numberWithInteger:arrEmBe1.count] forKey:@"slEmBe"];
    }
    [dic1 setValue:[NSNumber numberWithInt:fSoTienDi] forKey:@"soTien1"];
    int nPhiThanhToan = (nIndexTreEm + nIndexNguoiLon) * itemChuyenDi.phiVimass;
    [dic1 setValue:[NSNumber numberWithInt:nPhiThanhToan] forKey:@"fee1"];
    [dic1 setValue:self.edEmail.text forKey:@"emailLienHe"];
    [dic1 setValue:self.edSDT.text forKey:@"sdtLienHe"];
    [dic1 setValue:self.edTenCty.text forKey:@"tenCongTyXuatHoaDon"];
    [dic1 setValue:self.edDiaChiCty.text forKey:@"diaChiCongTyXuatHoaDon"];
    [dic1 setValue:self.edMaSoThue.text forKey:@"maSoThueCongTyXuatHoaDon"];
    [dic1 setValue:self.edDiaChiNhanHoaDon.text forKey:@"diaChiNhanHoaDon"];
    if (itemChuyenDen) {
        [dic1 setValue:[NSNumber numberWithInt:itemChuyenDen.hangBay] forKey:@"hangBay2"];
        [dic1 setValue:itemChuyenDen.maChuyenBay forKey:@"maChuyenBay2"];
        [dic1 setValue:itemChuyenDen.thoiGian forKey:@"thoiGian2"];
        [dic1 setValue:itemChuyenDen.gioBay forKey:@"gioBayDi2"];
        [dic1 setValue:[NSNumber numberWithInt:fSoTienVe] forKey:@"soTien2"];
        int nPhiThanhToanVe = (nIndexTreEm + nIndexNguoiLon) * itemChuyenDen.phiVimass;
        [dic1 setValue:[NSNumber numberWithInt:nPhiThanhToanVe] forKey:@"fee2"];

        [dic1 setValue:arrNguoiBay2 forKey:@"dsNguoiLon2"];
        if (arrTreEm2.count > 0) {
            [dic1 setValue:arrTreEm2 forKey:@"dsTreEm2"];
        }
        if (arrEmBe2.count > 0) {
            [dic1 setValue:arrEmBe2 forKey:@"dsEmBe2"];
        }
    }
    NSLog(@"%s - [dic1 JSONString] : %@", __FUNCTION__, [dic1 JSONString]);
    self.mDinhDanhKetNoi = DINH_DANH_THANH_TOAN_MAY_BAY;
    [GiaoDichMang thanhToanMayBay:[dic1 JSONString] noiNhanKetQua:self];
    [self showLoadingScreen];
}

- (int)getMaHanhLy:(int)nKg{
    int nMaHanhLy = 0;
    if (nKg == 15) {
        nMaHanhLy = 1;
    }
    else if (nKg == 20) {
        nMaHanhLy = 2;
    }
    else if (nKg == 25) {
        nMaHanhLy = 3;
    }
    else if (nKg == 30) {
        nMaHanhLy = 4;
    }
    else if (nKg == 35) {
        nMaHanhLy = 5;
    }
    else if (nKg == 40) {
        nMaHanhLy = 6;
    }
    return nMaHanhLy;
}

- (void)dealloc {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(capNhatThoiGianTraCuuGuaCao) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(traCuuVeMayBayGiaCao) object:nil];
    [viewQC dungChayQuangCao];
    [_viewCalendar release];
    [_edNgayDi release];
    [_edNgayVe release];
    [_edSanBayDi release];
    [_edSanBayVe release];
    [_edNguoiLon release];
    [_edTreEm release];
    [_edEmBe release];
    [_btnCloseCalendarView release];
    [_viewToken release];
    [_viewChuyenDi release];
    [_tableNguoiDi release];
    [_viewThongTinDi release];
    [_lblNguoiLon release];
    [_lblTreEm release];
    [_lblEmBe release];
    [_lblPhiSanBay release];
    [_lblThuePhi release];
    [_lblHanhLy release];
    [_lblPhiThanhToan release];
    [_lblTongLuotDi release];
    [_scrMain release];
    [_lblChuyenDi release];
    [_viewChuyenVe release];
    [_tableChuyenVe release];
    [_lblChuyenVe release];
    [_lblNguoiLonVe release];
    [_viewThongTinVe release];
    [_lblTreEmVe release];
    [_lblEmBeVe release];
    [_lblPhiSanBayVe release];
    [_lblThuePhiVe release];
    [_lblHanhLyVe release];
    [_lblPhiThanhToanVe release];
    [_lblTongLuotVe release];
    [_btnChonVeMayBay release];
    [_viewNhanVe release];
    [_edSDT release];
    [_edEmail release];
    [_lblSoTienThanhToan release];

    [_viewThanhToanGiaCao release];
    [_edToken release];
    [_viewNhanHoaDon release];
    [_edTenCty release];
    [_edDiaChiCty release];
    [_edMaSoThue release];
    [_edDiaChiNhanHoaDon release];
    [_lblPhiVimass release];
    [super dealloc];
}
@end
