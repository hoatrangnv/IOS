//
//  GiaoDienChuyenTienDenCMND.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 3/15/16.
//
//

#import "GiaoDienChuyenTienDenCMND.h"
#import "BankCoreData.h"
#import "ItemInfoDiaDiem.h"
#import "DucNT_ViewDatePicker.h"
#import "GiaoDienDanhSachChiNhanhBank.h"
#import "ItemDiaDiemGiaoDich.h"
#import "GiaoDienThongTinPhim.h"
#import "DucNT_DanhSachTaiKhoanThuongDungControllerViewController.h"
#import "DucNT_LoginSceen.h"

@interface GiaoDienChuyenTienDenCMND ()<UIPickerViewDataSource, UIPickerViewDelegate> {
    NSMutableArray *mDanhSachNganHang;
    NSString *sMaChiNhanh;
    NSString *sMaBank;
    NSMutableArray *arrInfoDiaDiem;
    int nTagPicker;
    int indexKhuVuc;
    int indexQuanHuyen;
    int indexBank;
    ViewQuangCao *viewQC;
}

@end

@implementation GiaoDienChuyenTienDenCMND
@synthesize edNgayCap;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitleView:@"Chuyển tiền đến CMND"];
    
    indexKhuVuc = -1;
    indexQuanHuyen = -1;
    indexBank = -1;

    [_edSoTien setType:ExTextFieldTypeMoney];
    _edSoTien.inputAccessoryView = nil;

    [self.scrMain addSubview:self.mViewMain];

    [self khoiTaoTextFeildTheoYChuTit:self.edKhuVuc nTag:100 dataPicker:self delegatePicker:self];
    [self khoiTaoTextFeildTheoYChuTit:self.edQuanHuyen nTag:101 dataPicker:self delegatePicker:self];
    [self khoiTaoTextFeildTheoYChuTit:self.edNganHang nTag:102 dataPicker:self delegatePicker:self];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateThongTinChiNhanh:) name:@"KEY_THONG_TIN_CHI_NHANH" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateThongTinCMND:) name:KEY_TAI_KHOAN_THUONG_DUNG object:nil];
    [self themButtonHuongDanSuDung:@selector(suKienBamNutHuongDanCMND:)];

    [self khoiTaoBanDau];
}

- (void)khoiTaoQuangCao {
    if (!viewQC) {
        viewQC = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ViewQuangCao class]) owner:self options:nil] objectAtIndex:0];
        viewQC.mDelegate = self;
//        CGRect rectToken = self.mViewNhapToken.frame;
        CGRect rectQC = viewQC.frame;
        CGRect rectMain = self.mViewMain.frame;
        CGRect rectGuiThongTin = self.viewThongTinNhan.frame;
        CGFloat fW = rectMain.size.width;
        CGFloat fH = fW * 0.46;
        rectQC.origin.y = rectGuiThongTin.origin.y + rectGuiThongTin.size.height + 5;
        viewQC.frame = CGRectMake(0, rectQC.origin.y, fW, fH);
        viewQC.mDelegate = self;
        [viewQC updateSizeQuangCao];
//        rectGuiThongTin.size.height = rectQC.origin.y + rectQC.size.height;
//        rectMain.size.height = rectGuiThongTin.origin.y + rectGuiThongTin.size.height;
//        self.viewThongTinNhan.frame = rectGuiThongTin;
        self.heightViewMain.constant += (fH + 5.0);
//        self.mViewMain.frame = rectMain;
        [self.mViewMain addSubview:viewQC];
        [self.scrMain setContentSize:CGSizeMake(_scrMain.frame.size.width, self.mViewMain.frame.origin.y + self.heightViewMain.constant + 20)];
    }
}

- (void)suKienBamNutHuongDanCMND:(UIButton *)sender {
    GiaoDienThongTinPhim *vc = [[GiaoDienThongTinPhim alloc] initWithNibName:@"GiaoDienThongTinPhim" bundle:nil];
    vc.nOption = HUONG_DAN_CHUYEN_TIEN_CMND;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setAnimationChoSoTay:self.btnSoTay];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.rfNoiDung resignFirstResponder];
    [self.tvNoiDung resignFirstResponder];
    [self khoiTaoQuangCao];
//    CGRect rectMain = self.mViewMain.frame;
//    CGRect rectVanTay = self.mbtnVanTay.frame;
//    [self.viewOptionTop setHidden:YES];
//    
//    rectMain.origin.x = 5;
//    rectMain.origin.y = 5;
//    rectMain.size.width = [UIScreen mainScreen].bounds.size.width - 10.0;
//    rectVanTay.origin.y = rectMain.origin.y + rectMain.size.height + 8;
//    self.mbtnVanTay.frame = rectVanTay;
//    self.mViewMain.frame = rectMain;
//    [self.scrMain setContentSize:CGSizeMake(self.scrMain.frame.size.width, rectVanTay.origin.y + rectVanTay.size.height + 10)];
//    [self.scrMain bringSubviewToFront:self.viewOptionTop];
//
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.btnSoTay.imageView stopAnimating];
}

- (void)updateThongTinCMND:(NSNotification *)notification
{
    if([[notification name] isEqualToString:KEY_TAI_KHOAN_THUONG_DUNG])
    {
        DucNT_TaiKhoanThuongDungObject *temp = [notification object];
        self.tvNoiDung.text = temp.noiDung;
        self.edKhuVuc.text = temp.tinhThanh;
        indexKhuVuc = 0;
        for (ItemInfoDiaDiem *item in arrInfoDiaDiem) {
            if ([item.ten isEqualToString:temp.tinhThanh]) {
                if (item.dsCon && item.dsCon.count > 0) {
                    [self capNhatGiaoDienKhiChonKhuVuc];
                    self.edQuanHuyen.text = temp.quanHuyen;
                    for (int i = 0; i < item.dsCon.count; i ++) {
                        ItemInfoDiaDiem* itemSub = [item.dsCon objectAtIndex:i];
                        NSLog(@"%s - itemSub.ten : %@", __FUNCTION__, itemSub.ten);
                        if ([itemSub.ten isEqualToString:temp.quanHuyen]) {
                            indexQuanHuyen = i;
                            break;
                        }
                    }
                }
                break;
            }
            indexKhuVuc ++;
        }
        sMaChiNhanh = temp.maChiNhanh;
        int i = 0;
        for (Banks *bank in mDanhSachNganHang) {
            if ([bank.bank_sms isEqualToString:temp.maNganHang]) {
                indexBank = i;
                self.edNganHang.text = bank.bank_name;
                sMaBank = bank.bank_sms;
                break;
            }
            i ++;
        }
        
        self.edTenCN.text = temp.tenChiNhanh;
        self.edDiaChiCN.text = temp.diaChiChiNhanh;
        self.edTenNguoiNhan.text = temp.tenNguoiThuHuong;
        self.edCMND.text = temp.cmnd;
        self.edNgayCap.text = [self doiDinhDangNgayThangDuLieuNhanDuoc:temp.ngayCap];
        self.edNoiCap.text = temp.noiCap;
        self.edSoTien.text = [Common hienThiTienTe:temp.soTien];
    }
}

-(NSString *)doiDinhDangNgayThangDuLieuNhanDuoc:(long long)sDuLieuTuServer
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:sDuLieuTuServer / 1000.0];
    NSString *sKQ = [df stringFromDate:date];
    return sKQ;
}

-(void)updateThongTinChiNhanh:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"KEY_THONG_TIN_CHI_NHANH"]) {
        ItemDiaDiemGiaoDich *item = [notification object];
        self.edTenCN.text = item.name;
        self.tvDiaChi.text = item.address;
        sMaChiNhanh = item.audio;
    }
}

- (void)khoiTaoBanDau {
    DucNT_ViewDatePicker *vDatePickerNgayCap = [[DucNT_ViewDatePicker alloc] initWithNib];
    __block GiaoDienChuyenTienDenCMND *blockSELF = self;
    [vDatePickerNgayCap truyenThongSoThoiGian:^(NSString *sThoiGian) {
        [blockSELF->edNgayCap resignFirstResponder];
        if(sThoiGian != nil && sThoiGian.length > 0)
        {
            blockSELF->edNgayCap.text = sThoiGian;
        }
    }];
    edNgayCap.inputView = vDatePickerNgayCap;
    [vDatePickerNgayCap release];
    mDanhSachNganHang = [[NSMutableArray alloc] initWithArray:[BankCoreData allBanks]];

    NSLog(@"%s - mDanhSachNganHang : %ld", __FUNCTION__, (unsigned long)mDanhSachNganHang.count);
    arrInfoDiaDiem = [[NSMutableArray alloc] init];
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"DanhSachDiaDiemGiaoDich" ofType:@"plist"];
    NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSArray *arrTemp = [plist objectForKey:@"MainItem"];

    ItemInfoDiaDiem *itemTemp = [[ItemInfoDiaDiem alloc] init];
    itemTemp.ten = @"Chọn khu vực";
    [arrInfoDiaDiem addObject:itemTemp];

    for (int i = 0; i < arrTemp.count; i++) {
        NSDictionary *dicTemp = [arrTemp objectAtIndex:i];
        ItemInfoDiaDiem *item = [[ItemInfoDiaDiem alloc] init];
        [item khoiTaoDoiTuong:dicTemp];
        [arrInfoDiaDiem addObject:item];
    }

    ItemInfoDiaDiem *item = [arrInfoDiaDiem objectAtIndex:0];
    self.edKhuVuc.text = item.ten;
    indexKhuVuc = 0;
    [self capNhatGiaoDienKhiChonKhuVuc];

}

- (void)suKienDonePicker:(UIButton *)btn {
    if (nTagPicker == 100) {
        [self.edKhuVuc resignFirstResponder];
        ItemInfoDiaDiem *item = [arrInfoDiaDiem objectAtIndex:indexKhuVuc];
        self.edKhuVuc.text = item.ten;
        [self capNhatGiaoDienKhiChonKhuVuc];
    }
    else if (nTagPicker == 101) {
        [self.edQuanHuyen resignFirstResponder];
        ItemInfoDiaDiem *item = [arrInfoDiaDiem objectAtIndex:indexKhuVuc];
        ItemInfoDiaDiem* itemSub = [item.dsCon objectAtIndex:indexQuanHuyen];
        self.edQuanHuyen.text = itemSub.ten;
    }
    else if (nTagPicker == 102) {
        [self.edNganHang resignFirstResponder];
        if (indexBank == -1) {
            sMaBank = @"";
            self.edNganHang.text = @"Chọn ngân hàng";
        }
        else {
            Banks *bank = [mDanhSachNganHang objectAtIndex:indexBank];
            NSString *sTenNganHang = bank.bank_name;
            sMaBank = bank.bank_sms;
            self.edNganHang.text = sTenNganHang;
        }
    }
}

- (void)suKienCancelPicker:(UIButton *)btn {
    if (nTagPicker == 100) {
        [self.edKhuVuc resignFirstResponder];
    }
    else if (nTagPicker == 101) {
        [self.edQuanHuyen resignFirstResponder];
    }
    else if (nTagPicker == 102) {
        [self.edNganHang resignFirstResponder];
    }
}

- (void)capNhatGiaoDienKhiChonKhuVuc {
    ItemInfoDiaDiem *item = [arrInfoDiaDiem objectAtIndex:indexKhuVuc];
    if (item.dsCon.count > 0) {
        indexQuanHuyen = 0;
        self.edQuanHuyen.hidden = NO;
        ItemInfoDiaDiem* itemSub = [item.dsCon objectAtIndex:0];
        self.edQuanHuyen.text = itemSub.ten;
        if (self.heightEdQuanHuyen.constant == 0) {
            self.heightEdQuanHuyen.constant = 35.0;
            self.heightViewMain.constant += self.heightEdQuanHuyen.constant;
            CGRect rectQC = viewQC.frame;
            rectQC.origin.y += self.heightEdQuanHuyen.constant;
            viewQC.frame = rectQC;
        }
//        CGRect rect1 = self.viewThongTinNhan.frame;
//        CGRect rect2 = self.edQuanHuyen.frame;
//        CGRect rectMain = self.mViewMain.frame;
//        rect1.origin.y = rect2.origin.y + rect2.size.height;
//        rectMain.size.height = rect1.origin.y + rect1.size.height + 10;
//        self.viewThongTinNhan.frame = rect1;
//        self.mViewMain.frame = rectMain;
//        [self.scrMain setContentSize:CGSizeMake(_scrMain.frame.size.width, self.mViewMain.frame.origin.y + self.mViewMain.frame.size.height + 10)];
    }
    else {
        indexQuanHuyen = -1;
        self.edQuanHuyen.text = @"";
        self.edQuanHuyen.hidden = YES;
        if (self.heightEdQuanHuyen.constant > 0) {
            self.heightViewMain.constant -= self.heightEdQuanHuyen.constant;
            CGRect rectQC = viewQC.frame;
            rectQC.origin.y -= self.heightEdQuanHuyen.constant;
            viewQC.frame = rectQC;
            self.heightEdQuanHuyen.constant = 0.0;
        }
//        CGRect rect1 = self.viewThongTinNhan.frame;
//        CGRect rect2 = self.edQuanHuyen.frame;
//        CGRect rectMain = self.mViewMain.frame;
//        rect1.origin.y = rect2.origin.y;
//        rectMain.size.height = rect1.origin.y + rect1.size.height + 10;
//        self.viewThongTinNhan.frame = rect1;
//        self.mViewMain.frame = rectMain;
//        [self.scrMain setContentSize:CGSizeMake(_scrMain.frame.size.width, self.mViewMain.frame.origin.y + self.mViewMain.frame.size.height + 10)];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 100) {
        return arrInfoDiaDiem.count;
    }
    else if (pickerView.tag == 101) {
        ItemInfoDiaDiem *item = [arrInfoDiaDiem objectAtIndex:indexKhuVuc];
        return item.dsCon.count;
    }
    else if (pickerView.tag == 102) {
        return mDanhSachNganHang.count + 1;
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 100) {
        ItemInfoDiaDiem *item = [arrInfoDiaDiem objectAtIndex:row];
        return item.ten;
    }
    else if (pickerView.tag == 101) {
        ItemInfoDiaDiem *item = [arrInfoDiaDiem objectAtIndex:indexKhuVuc];
        ItemInfoDiaDiem* itemSub = [item.dsCon objectAtIndex:row];
        return itemSub.ten;
    }
    else if (pickerView.tag == 102) {
        if (row == 0) {
            return @"Chọn ngân hàng";
        }
        Banks *bank = [mDanhSachNganHang objectAtIndex:row - 1];
        NSString *sTenNganHang = bank.bank_name;
        return sTenNganHang;
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    nTagPicker = (int)pickerView.tag;
    if (pickerView.tag == 100) {
        indexKhuVuc = (int)row;
    }
    else if (pickerView.tag == 101) {
        indexQuanHuyen = (int)row;
    }
    else if (pickerView.tag == 102) {
        indexBank = (int)row - 1;
    }
}

- (IBAction)suKienTimChiNhanh:(id)sender {
    if (indexKhuVuc < 1) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng chọn khu vực"];
        return;
    }
    else {
        ItemInfoDiaDiem *item = [arrInfoDiaDiem objectAtIndex:indexKhuVuc];
        if (item.dsCon.count > 0) {
            if (indexQuanHuyen < 0) {
                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng chọn quận/huyện"];
                return;
            }
        }
    }
    if (indexBank < 0) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng chọn ngân hàng"];
        return;
    }
    double lat = 0.0;
    double lng = 0.0;
    int nKC = 5;
    NSString *sKeyWord = @"";

    ItemInfoDiaDiem *item = [arrInfoDiaDiem objectAtIndex:indexKhuVuc];
    if (item.dsCon.count > 0) {
        if (indexQuanHuyen >= 0) {
            ItemInfoDiaDiem* itemSub = [item.dsCon objectAtIndex:indexQuanHuyen];
            lat = itemSub.latude;
            lng = itemSub.longtude;
            nKC = itemSub.kc;
        }
    }
    else {
        lat = item.latude;
        lng = item.longtude;
        nKC = item.kc;
    }

    Banks *bank = [mDanhSachNganHang objectAtIndex:indexBank];
    sKeyWord = [self getKeyWord:bank.bank_sms];

    GiaoDienDanhSachChiNhanhBank *vc = [[GiaoDienDanhSachChiNhanhBank alloc] initWithNibName:@"GiaoDienDanhSachChiNhanhBank" bundle:nil];
    vc.lat = lat;
    vc.lng = lng;
    vc.nKc = nKC;
    vc.sKeyword = sKeyWord;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (IBAction)suKienThayDoiSoTien:(id)sender {
    NSString *sSoTien = [_edSoTien.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    _edSoTien.text = [Common hienThiTienTeFromString:sSoTien];
//    GiaoDichMang
}

- (IBAction)suKienBamNutSoTay:(id)sender {
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return;
    }
    DucNT_DanhSachTaiKhoanThuongDungControllerViewController *vc = [[DucNT_DanhSachTaiKhoanThuongDungControllerViewController alloc] initWithType:TAI_KHOAN_CHUYEN_TIEN_CMND];
    [self.navigationController presentViewController:vc animated:YES completion:^{}];
    [vc release];
}

- (NSString *)getKeyWord:(NSString *)sKeyWord {
    if([sKeyWord isEqualToString:@"AGR"])
    {
        return @"Agribank";
    }
    else if ([sKeyWord isEqualToString:@"CTG"])
    {
        return @"Vietinbank";
    }
    else if([sKeyWord isEqualToString:@"EIB"])
    {
        return @"Eximbank";
    }
    else if([sKeyWord isEqualToString:@"BID"])
    {
        return @"BIDV";
    }
    else if([sKeyWord isEqualToString:@"NASB"])
    {
        return @"BacABank";
    }
    else if([sKeyWord isEqualToString:@"OJB"])
    {
        return @"Ocean Bank";
    }
    else if([sKeyWord isEqualToString:@"PVB"])
    {
        return @"PVcomBank";
    }
    else if([sKeyWord isEqualToString:@"SGB"])
    {
        return @"Saigonbank";
    }
    else if([sKeyWord isEqualToString:@"STB"])
    {
        return @"Sacombank";
    }
    else if([sKeyWord isEqualToString:@"TCB"])
    {
        return @"Techcombank";
    }
    else if([sKeyWord isEqualToString:@"VIETCAPITAL"])
    {
        return @"Viet Capital Bank";
    }
    else if([sKeyWord isEqualToString:@"BBL"])
    {
        return @"Bangkok";
    }
    else if([sKeyWord isEqualToString:@"BIDCHCM"])
    {
        return @"Campuchia";
    }
    else if([sKeyWord isEqualToString:@"BIDCHN"])
    {
        return @"Campuchia";
    }
    else if([sKeyWord isEqualToString:@"CBA"])
    {
        return @"Commonwealth";
    }
    else if([sKeyWord isEqualToString:@"CITIHCM"])
    {
        return @"Citibank";
    }
    else if([sKeyWord isEqualToString:@"CITIHN"])
    {
        return @"Citibank";
    }
    else if([sKeyWord isEqualToString:@"DB"])
    {
        return @"Deutsche";
    }
    else if([sKeyWord isEqualToString:@"HLB"])
    {
        return @"Hong Leong";
    }
    else if([sKeyWord isEqualToString:@"MIZUHOHCM"])
    {
        return @"Mizuho";
    }
    else if([sKeyWord isEqualToString:@"MIZUHOHN"])
    {
        return @"MIZUHOHN";
    }
    else if([sKeyWord isEqualToString:@"SC"])
    {
        return @"Standard";
    }
    else if([sKeyWord isEqualToString:@"BIDCHN"])
    {
        return @"Campuchia";
    }
    else if([sKeyWord isEqualToString:@"VSB"])
    {
        return @"Vinasiam";
    }
    else {
        return sKeyWord;
    }
}

- (BOOL)validateVanTay {
    return YES;
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return NO;
    }
    if (self.edTenCN.text.isEmpty) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng chọn chi nhánh ngân hàng"];
        return NO;
    }
    if (self.tvDiaChi.text.isEmpty) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập địa chỉ chi nhánh"];
        return NO;
    }
    if (self.edTenNguoiNhan.text.isEmpty) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập tên người nhận tiền"];
        return NO;
    }
    if (self.edCMND.text.isEmpty) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập số CMND người nhận tiền"];
        return NO;
    }
    if (self.edNgayCap.text.isEmpty) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng chọn ngày cấp CMND"];
        return NO;
    }
    if (self.edNoiCap.text.isEmpty) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập nơi cấp CMND"];
        return NO;
    }
    if (self.tvNoiDung.text.isEmpty) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập nội dung chuyển tiền"];
        return NO;
    }
    else if (self.tvNoiDung.text.length > 70) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Nội dung chuyển tiền tối đa 70 ký tự"];
        return NO;
    }
    if (self.edSoTien.text.isEmpty) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập số tiền muốn chuyển"];
        return NO;
    }
    else {
        double fSoTien = [[[self.edSoTien.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
        if (fSoTien < 50000 && fSoTien > 1000000000) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Số tiền chuyển đi phải lớn hơn 50.000 đ"];
            return NO;
        }
        else if (fSoTien >= [self.mThongTinTaiKhoanVi.nAmount doubleValue]) {
            [UIAlertView alert:@"Số dư trong tài khoản không đủ" withTitle:[@"thong_bao" localizableString] block:nil];
            return NO;
        }
        else if (fSoTien > [self.mThongTinTaiKhoanVi.nHanMucDenTaiKhoan doubleValue]) {
            [UIAlertView alert:@"Số tiền chuyển đi phải nhỏ hơn hạn mức giao dịch" withTitle:[@"thong_bao" localizableString] block:nil];
            return NO;
        }
    }
    return YES;
}

- (void)xuLyThucHienKhiKiemTraThanhCongTraVeToken:(NSString*)sToken otp:(NSString*)sOtp
{
    NSLog(@"%s- sMaChiNhanh : %@", __FUNCTION__, sMaChiNhanh);

    NSString *sNgayCap = self.edNgayCap.text;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    NSDate *date = [dateFormat dateFromString:sNgayCap];
    long long lNgayCap = [date timeIntervalSince1970] * 1000;
    double fSoTien = [[[self.edSoTien.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
    NSString *sMaDoanhNghiep = @"";
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sMaDoanhNghiep = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_COMPANY_ID];
    }
//    edSDTNguoiNhan
    NSDictionary *dic = @{@"tenNguoiHuongThu": self.edTenNguoiNhan.text,
                          @"appId": [NSNumber numberWithInt:APP_ID],
                          @"noiCap": self.edNoiCap.text,
                          @"noiDung": self.tvNoiDung.text,
                          @"ngayCap": [NSNumber numberWithLongLong:lNgayCap],
                          @"typeAuthenticate": [NSNumber numberWithInt:self.mTypeAuthenticate],
                          @"maChiNhanh": sMaChiNhanh,
                          @"diaChiChiNhanh": self.tvDiaChi.text,
                          @"soTien": [NSNumber numberWithDouble:fSoTien],
                          @"token": sToken,
                          @"otpConfirm": sOtp,
                          @"cmnd": self.edCMND.text,
                          @"tinhThanh": self.edKhuVuc.text,
                          @"quanHuyen": self.edQuanHuyen.text,
                          @"maNganHang": sMaBank,
                          @"user": [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                          @"tenChiNhanh": self.edTenCN.text,
                          @"companyCode"   :sMaDoanhNghiep,
                          @"VMApp" : [NSNumber numberWithInt:VM_APP]};
    NSString *sJson = [dic JSONString];
    NSLog(@"%s - sJson : %@", __FUNCTION__, sJson);
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self hienThiLoading];
    }
    self.mDinhDanhKetNoi = DINH_DANH_CHUYEN_TIEN_CMND;
    [GiaoDichMang chuyenTienDenCMND:sJson noiNhanKetQua:self];
}

- (void)xuLyKetNoiThanhCong:(NSString*)sDinhDanhKetNoi thongBao:(NSString*)sThongBao ketQua:(id)ketQua
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self anLoading];
    }
    if([sDinhDanhKetNoi isEqualToString:DINH_DANH_CHUYEN_TIEN_CMND])
    {
        [self hienThiHopThoaiMotNutBamKieu:HOP_THOAI_XAC_NHAN_CHUYEN_TIEN_THANH_CONG cauThongBao:sThongBao];
    }
}

- (void)dealloc {
    [viewQC release];
    [_edKhuVuc release];
    [_edQuanHuyen release];
    [_edNganHang release];
    [mDanhSachNganHang release];
    [arrInfoDiaDiem release];
    [_viewThongTinNhan release];
    [edNgayCap release];
    [_edTenCN release];
    [_edDiaChiCN release];
    [_edTenNguoiNhan release];
    [_edCMND release];
    [_edNoiCap release];
    [_edSoTien release];
    [_rfNoiDung release];
    [_tvNoiDung release];
    [_tvDiaChi release];
//    [_scrMain release];
    [_edSDTNguoiNhan release];
    [_heightEdQuanHuyen release];
    [_heightViewMain release];
    [super dealloc];
}
@end
