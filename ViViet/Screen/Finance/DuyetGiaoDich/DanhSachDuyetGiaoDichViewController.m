//
//  DanhSachDuyetGiaoDichViewController.m
//  ViViMASS
//
//  Created by DucBui on 6/9/15.
//
//

#import "DanhSachDuyetGiaoDichViewController.h"
#import "GiaoDichMang.h"
#import "DoiTuongGiaoDich.h"
#import "DuyetGiaoDichTableViewCell.h"
#import "ChiTietDuyetGiaoDichViewController.h"

#define DINH_DANH_KET_NOI_LAY_DANH_SACH_DUYET_GIAO_DICH @"DINH_DANH_KET_NOI_LAY_DANH_SACH_DUYET_GIAO_DICH"

@interface DanhSachDuyetGiaoDichViewController () <DucNT_ServicePostDelegate, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, ChiTietDuyetGiaoDichViewControllerDelegate>
{
    BOOL mFirst;
}

@property (nonatomic, retain) NSArray *mDanhSachKieuHienThi;
@property (nonatomic, assign) NSInteger mKieuHienThiDanhSachDuyetGD;
//@property (nonatomic, retain) NSString *mDinhDanhKetNoi;
@property (nonatomic, retain) NSMutableArray *mDanhSachDuyetGiaoDich;
@property (nonatomic, retain) NSArray *mDanhSachHienThi;
@end

@implementation DanhSachDuyetGiaoDichViewController

#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self khoiTaoBanDau];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.mDanhSachDuyetGiaoDich) {
        [self.mDanhSachDuyetGiaoDich removeAllObjects];
    }
    mFirst = YES;
    self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_LAY_DANH_SACH_DUYET_GIAO_DICH;
    [GiaoDichMang ketNoiLayDanhSachDuyetGiaoDichTuNgay:0 denNgay:0 viTri:0 soLuong:50 noiNhanKetQua:self];
}

#pragma mark - khoiTao

- (void)khoiTaoBanDau
{
    [self addButtonBack];
    [self addTitleView:@"Duyệt giao dịch"];
    [self khoiTaoDanhSachKieuHienThi];
    [self khoiTaoDatePickerDenNgay];
    [self khoiTaoDatePickerTuNgay];
    self.mDanhSachDuyetGiaoDich = [[NSMutableArray alloc] init];
}

- (void)khoiTaoDanhSachKieuHienThi
{
    self.mKieuHienThiDanhSachDuyetGD = 0;
    self.mDanhSachKieuHienThi = @[@"Tất cả", @"Đang chờ duyệt", @"Đã hết hạn", @"Đã huỷ", @"Đã duyệt"];
    _mtfLuaChonDanhSachGiaoDich.text = [_mDanhSachKieuHienThi objectAtIndex:0];
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.dataSource = self;
    picker.delegate = self;
    
    _mtfLuaChonDanhSachGiaoDich.inputView = picker;
    _mtfLuaChonDanhSachGiaoDich.inputAccessoryView = nil;
    [picker selectRow:0 inComponent:0 animated:YES];
    [picker release];

}

- (void)khoiTaoDatePickerTuNgay
{
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.locale = [NSLocale currentLocale];
    

    [datePicker addTarget:self action:@selector(suKienThayDoiNgayBatDau:) forControlEvents:UIControlEventValueChanged];
    _mtfNgayBatDau.inputView = datePicker;
    [datePicker release];
}

- (void)khoiTaoDatePickerDenNgay
{
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.locale = [NSLocale currentLocale];
    [datePicker addTarget:self action:@selector(suKienThayDoiNgayKetThuc:) forControlEvents:UIControlEventValueChanged];
    _mtfNgayKetThuc.inputView = datePicker;
    [datePicker release];
}

#pragma mark - DucNT_ServicePostDelegate

-(void)ketNoiThanhCong:(NSString *)sKetQua
{
    NSDictionary *dicKetQua = [sKetQua objectFromJSONString];
    int nCode = [[dicKetQua objectForKey:@"msgCode"] intValue];
    NSString *message = [dicKetQua objectForKey:@"msgContent"];
    id result = [dicKetQua objectForKey:@"result"];
    if(nCode == 1)
    {
        if([self.mDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_LAY_DANH_SACH_DUYET_GIAO_DICH])
        {
            NSArray *danhSachDuyetGiaoDich = [DoiTuongGiaoDich layDanhSachDuyetGiaoDich:(NSArray*)result];
            if(danhSachDuyetGiaoDich)
            {
                [self.mDanhSachDuyetGiaoDich addObjectsFromArray:danhSachDuyetGiaoDich];
                self.mDanhSachHienThi = [self layDanhSachDuyetGiaoDichTheoKieuHienThi];
                [_mtbDanhSachGiaoDich reloadData];
            }
        }
    }
    else
    {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:message];
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    DuyetGiaoDichTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DuyetGiaoDichTableViewCell" owner:self options:nil] objectAtIndex:0];
    DoiTuongGiaoDich *doiTuong = [_mDanhSachHienThi objectAtIndex:indexPath.row];
    [cell setMDoiTuongGiaoDich:doiTuong];
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_mDanhSachHienThi)
        return _mDanhSachHienThi.count;
    return 0;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DoiTuongGiaoDich *doiTuong = [_mDanhSachHienThi objectAtIndex:indexPath.row];
    ChiTietDuyetGiaoDichViewController *chiTietDuyetGiaoDich = [[ChiTietDuyetGiaoDichViewController alloc] initWithNibName:@"ChiTietDuyetGiaoDichViewController" bundle:nil];
    chiTietDuyetGiaoDich.mDoiTuongGiaoDich = doiTuong;
    chiTietDuyetGiaoDich.mDelegate = self;
    [self.navigationController pushViewController:chiTietDuyetGiaoDich animated:YES];
    [chiTietDuyetGiaoDich release];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(_mDanhSachKieuHienThi)
        return _mDanhSachKieuHienThi.count;
    return 0;
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_mDanhSachKieuHienThi objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.mKieuHienThiDanhSachDuyetGD = row;
    _mtfLuaChonDanhSachGiaoDich.text = [_mDanhSachKieuHienThi objectAtIndex:_mKieuHienThiDanhSachDuyetGD];

    self.mDanhSachHienThi = [self layDanhSachDuyetGiaoDichTheoKieuHienThi];

    [_mtbDanhSachGiaoDich reloadData];
}

#pragma mark - ChiTietDuyetGiaoDichViewControllerDelegate

- (void)suKienDuyetGiaoDichThanhCong
{
    [_mtbDanhSachGiaoDich reloadData];
}

- (void)suKienHuyDuyetGiaoDichThanhCong
{
    [_mtbDanhSachGiaoDich reloadData];
}

#pragma mark - suKien

- (void)suKienThayDoiNgayBatDau:(UIDatePicker*)sender
{
    _mtfNgayBatDau.text = [Common date:sender.date toStringWithFormat:@"dd-MM-yyyy"];
}

- (void)suKienThayDoiNgayKetThuc:(UIDatePicker*)sender
{
    _mtfNgayKetThuc.text = [Common date:sender.date toStringWithFormat:@"dd-MM-yyyy"];
}

- (IBAction)suKienBamNutTraCuu:(UIButton *)sender
{
    [self.view endEditing:YES];
    [_mDanhSachDuyetGiaoDich removeAllObjects];
    NSDate *dtNgayBatDau = [(UIDatePicker*)_mtfNgayBatDau.inputView date];
    long long nNgayBatDau = [dtNgayBatDau timeIntervalSince1970] * 1000;
    NSDate *dtNgayKetThuc = [(UIDatePicker*)_mtfNgayKetThuc.inputView date];
    long long nNgayKetThuc = [dtNgayKetThuc timeIntervalSince1970] * 1000;
    mFirst = YES;
    self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_LAY_DANH_SACH_DUYET_GIAO_DICH;
    [GiaoDichMang ketNoiLayDanhSachDuyetGiaoDichTuNgay:nNgayBatDau denNgay:nNgayKetThuc viTri:0 soLuong:50 noiNhanKetQua:self];
}


#pragma mark - xuLy

- (NSArray*)layDanhSachDuyetGiaoDichTheoKieuHienThi
{
    NSMutableArray *temp = [[[NSMutableArray alloc] init] autorelease];
    if(_mKieuHienThiDanhSachDuyetGD != 0)
    {
        for(DoiTuongGiaoDich *doiTuong in self.mDanhSachDuyetGiaoDich)
        {
            if([doiTuong.trangThai intValue] == _mKieuHienThiDanhSachDuyetGD)
            {
                [temp addObject:doiTuong];
            }
        }
    }
    else
    {
        [temp addObjectsFromArray:self.mDanhSachDuyetGiaoDich];
    }
    if(mFirst)
    {
        mFirst = NO;
        NSInteger nFirst = 0;
        NSInteger nLast = temp.count - 1;
        if(temp.count > 0)
        {
            DoiTuongGiaoDich *doiTuongDau = [temp objectAtIndex:nFirst];
            DoiTuongGiaoDich *doiTuongCuoi = [temp objectAtIndex:nLast];
            NSDate *dtNgayBatDau = [doiTuongCuoi layThoiGianLapTraVeNSDate];
            NSDate *dtNgayKetThuc = [doiTuongDau layThoiGianLapTraVeNSDate];
            _mtfNgayBatDau.text = [Common date:dtNgayBatDau toStringWithFormat:@"dd-MM-yyyy"];
            [(UIDatePicker*)_mtfNgayBatDau.inputView setDate:dtNgayBatDau];
            
            _mtfNgayKetThuc.text = [Common date:dtNgayKetThuc toStringWithFormat:@"dd-MM-yyyy"];
            [(UIDatePicker*)_mtfNgayKetThuc.inputView setDate:dtNgayKetThuc];
        }
    }
    return temp;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - dealloc

- (void)dealloc {
    [_mDanhSachHienThi release];
    [_mDanhSachKieuHienThi release];
    [_mDanhSachDuyetGiaoDich release];
    [_mtfNgayBatDau release];
    [_mtfNgayKetThuc release];
    [_mtfLuaChonDanhSachGiaoDich release];
    [_mtbDanhSachGiaoDich release];
    [super dealloc];
}
@end
