//
//  ViewThuongDungCMND.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 4/28/16.
//
//

#import "ViewThuongDungCMND.h"
#import "Common.h"
#import "ItemInfoDiaDiem.h"
#import "Banks.h"
#import "BankCoreData.h"
#import "Alert+Block.h"
#import "DucNT_LuuRMS.h"

@implementation ViewThuongDungCMND {
    NSMutableArray *mDanhSachNganHang;
    NSString *sMaChiNhanh;
    NSString *sMaBank;
    NSMutableArray *arrInfoDiaDiem;
    int nTagPicker;
    int indexKhuVuc;
    int indexQuanHuyen;
    int indexBank;
}

- (void)awakeFromNib {
    indexKhuVuc = -1;
    indexQuanHuyen = -1;
    indexBank = -1;

    [_edSoTien setType:ExTextFieldTypeMoney];
    _edSoTien.inputAccessoryView = nil;

    [self khoiTaoTextFeildTheoYChuTit:self.edKhuVuc nTag:100 dataPicker:self delegatePicker:self];
    [self khoiTaoTextFeildTheoYChuTit:self.edQuanHuyen nTag:101 dataPicker:self delegatePicker:self];
    [self khoiTaoTextFeildTheoYChuTit:self.edNganHang nTag:102 dataPicker:self delegatePicker:self];

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

    mDanhSachNganHang = [[NSMutableArray alloc] initWithArray:[BankCoreData allBanks]];
}

- (void)khoiTaoTextFeildTheoYChuTit:(ExTextField *)edTemp nTag:(int)nTag dataPicker : (id<UIPickerViewDataSource>) dataSource delegatePicker : (id<UIPickerViewDelegate>) delegate{
    if (!edTemp.rightView) {
        UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 12)];
        [btnRight setBackgroundImage:[UIImage imageNamed:@"muiten35x21.png"] forState:UIControlStateNormal];
        edTemp.rightView = btnRight;
        edTemp.rightViewMode = UITextFieldViewModeAlways;

        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
        toolBar.barStyle = UIBarStyleBlackOpaque;
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(suKienDonePicker:)];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(suKienCancelPicker:)];
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

        [toolBar setItems:[NSArray arrayWithObjects:cancelButton, flexSpace, doneButton, nil]];
        UIPickerView *pickerChonRap = [[UIPickerView alloc] init];
        pickerChonRap.dataSource = dataSource;
        pickerChonRap.delegate = delegate;
        pickerChonRap.tag = nTag;
        edTemp.inputAccessoryView = toolBar;
        edTemp.inputView = pickerChonRap;
        [pickerChonRap release];
    }
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
        self.edQuanHuyen.enabled = YES;
        ItemInfoDiaDiem* itemSub = [item.dsCon objectAtIndex:0];
        self.edQuanHuyen.text = itemSub.ten;
//        CGRect rect1 = self.frame;
//        CGRect rect2 = self.edQuanHuyen.frame;
//        rect1.origin.y = rect2.origin.y + rect2.size.height;
//        self.frame = rect1;
    }
    else {
        indexQuanHuyen = -1;
        self.edQuanHuyen.text = @"";
        self.edQuanHuyen.enabled = NO;
//        CGRect rect1 = self.frame;
//        CGRect rect2 = self.edQuanHuyen.frame;
//        rect1.origin.y = rect2.origin.y;
//        self.frame = rect1;
    }
}

#pragma mark - UIPickerViewDelegate

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

- (void)setMTaiKhoanThuongDung:(DucNT_TaiKhoanThuongDungObject *)mTaiKhoanThuongDung{
    if(mTaiKhoanThuongDung)
    {
        if(_mTaiKhoanThuongDung)
            [_mTaiKhoanThuongDung release];
        _mTaiKhoanThuongDung = [mTaiKhoanThuongDung retain];
        _edNameAlias.text = mTaiKhoanThuongDung.sAliasName;
        self.tvNoiDung.text = mTaiKhoanThuongDung.noiDung;
        self.edKhuVuc.text = mTaiKhoanThuongDung.tinhThanh;
        indexKhuVuc = 0;
        for (ItemInfoDiaDiem *item in arrInfoDiaDiem) {
            if ([item.ten isEqualToString:mTaiKhoanThuongDung.tinhThanh]) {
                if (item.dsCon && item.dsCon.count > 0) {
                    [self capNhatGiaoDienKhiChonKhuVuc];
                    self.edQuanHuyen.text = mTaiKhoanThuongDung.quanHuyen;
                    for (int i = 0; i < item.dsCon.count; i ++) {
                        ItemInfoDiaDiem* itemSub = [item.dsCon objectAtIndex:i];
                        NSLog(@"%s - itemSub.ten : %@", __FUNCTION__, itemSub.ten);
                        if ([itemSub.ten isEqualToString:mTaiKhoanThuongDung.quanHuyen]) {
                            indexQuanHuyen = i;
                            break;
                        }
                    }
                }
                break;
            }
            indexKhuVuc ++;
        }
        sMaChiNhanh = mTaiKhoanThuongDung.maChiNhanh;
        int i = 0;
        for (Banks *bank in mDanhSachNganHang) {
            if ([bank.bank_sms isEqualToString:mTaiKhoanThuongDung.maNganHang]) {
                indexBank = i;
                self.edNganHang.text = bank.bank_name;
                sMaBank = bank.bank_sms;
                break;
            }
            i ++;
        }
        self.edTenCN.text = mTaiKhoanThuongDung.tenChiNhanh;
        self.tvDiaChi.text = mTaiKhoanThuongDung.diaChiChiNhanh;
        self.edTenNguoiNhan.text = mTaiKhoanThuongDung.tenNguoiThuHuong;
        self.edSoCMND.text = mTaiKhoanThuongDung.cmnd;
        self.edNgayCap.text = [self doiDinhDangNgayThangDuLieuNhanDuoc:mTaiKhoanThuongDung.ngayCap];
        self.edNoiCap.text = mTaiKhoanThuongDung.noiCap;
        self.edSoTien.text = [Common hienThiTienTe:mTaiKhoanThuongDung.soTien];
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
    if (_delegate) {
        [_delegate layThongTinChiNhanhNganHang:lat lng:lng nKhoangCach:nKC sKeyWord:sKeyWord];
    }
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

- (void)capNhatThongTinChiNhanh:(NSString *)sMaChiNhanhTemp sTenChiNhanh:(NSString *)sTen sDiaChi:(NSString *)sDiaChi {
    self.edTenCN.text = sTen;
    self.tvDiaChi.text = sDiaChi;
    sMaChiNhanh = sMaChiNhanhTemp;
}

- (BOOL)kiemTraNoiDung {
    if (self.edNameAlias.text.isEmpty) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng nhập tên hiển thị"];
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
    if (self.edSoCMND.text.isEmpty) {
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
    return YES;
}

- (void)hienThiHopThoaiMotNutBamKieu:(int)nIndex cauThongBao:(NSString *)sThongBao {
    [UIAlertView alert:sThongBao withTitle:@"Thông báo" block:nil];
}

- (DucNT_TaiKhoanThuongDungObject*)getTaiKhoanThuongDungDayLenServer{
    DucNT_TaiKhoanThuongDungObject *taiKhoanThuongDung = nil;
    if([self kiemTraNoiDung])
    {
        if(_mTaiKhoanThuongDung)
        {
            taiKhoanThuongDung = _mTaiKhoanThuongDung;
        }
        else
        {
            taiKhoanThuongDung = [[[DucNT_TaiKhoanThuongDungObject alloc] init] autorelease];
        }
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
        taiKhoanThuongDung.sPhoneOwner = sID;
        taiKhoanThuongDung.nType = TAI_KHOAN_CHUYEN_TIEN_CMND;
        taiKhoanThuongDung.sAliasName = self.edNameAlias.text;
        taiKhoanThuongDung.noiDung = self.tvNoiDung.text;
        taiKhoanThuongDung.tinhThanh = self.edKhuVuc.text;
        taiKhoanThuongDung.quanHuyen = self.edQuanHuyen.text;
        taiKhoanThuongDung.maChiNhanh = sMaChiNhanh;
        taiKhoanThuongDung.maNganHang = sMaBank;
        taiKhoanThuongDung.tenChiNhanh = self.edTenCN.text;
        taiKhoanThuongDung.diaChiChiNhanh = self.tvDiaChi.text;
        taiKhoanThuongDung.tenNguoiThuHuong = self.edTenNguoiNhan.text;
        taiKhoanThuongDung.cmnd = self.edSoCMND.text;

        NSString *sNgayCap = self.edNgayCap.text;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd-MM-yyyy"];
        NSDate *date = [dateFormat dateFromString:sNgayCap];
        long long lNgayCap = [date timeIntervalSince1970] * 1000;
        taiKhoanThuongDung.ngayCap = lNgayCap;

        taiKhoanThuongDung.noiCap = self.edNoiCap.text;
        double fSoTien = [[[self.edSoTien.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
        taiKhoanThuongDung.soTien = fSoTien;

    }
    return taiKhoanThuongDung;
}

- (void)dealloc {
    [_edKhuVuc release];
    [_edQuanHuyen release];
    [_edNganHang release];
    [_edTenCN release];
    [_tvDiaChi release];
    [_edTenNguoiNhan release];
    [_edSoCMND release];
    [_edNgayCap release];
    [_edNoiCap release];
    [_edSoTien release];
    [_tvNoiDung release];
    [_edNameAlias release];
    [super dealloc];
}
@end
