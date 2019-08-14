//
//  TraCuuSoTietKiemView.m
//  ViViMASS
//
//  Created by DucBui on 5/19/15.
//
//

#import "Common.h"
#import "GiaoDichMang.h"
#import "TraCuuSoTietKiemView.h"
#import "TraCuuSoTietKiemTableViewCell.h"
#import "JSONKit.h"

@implementation TraCuuSoTietKiemView {
    int nIndexOption;
    double nSoTienHieuLuc;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {

    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    NSLog(@"info:%@: %@", NSStringFromClass([self class]),NSStringFromSelector(_cmd));
    [self khoiTaoDatePickerTuNgay];
    [self khoiTaoDatePickerDenNgay];
    nSoTienHieuLuc = 0;
    nIndexOption = 1;
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 12)];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"muiten35x21.png"] forState:UIControlStateNormal];
    _edOption.rightView = btnRight;
    _edOption.rightViewMode = UITextFieldViewModeAlways;

    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneChonOption:)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelChonOption:)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

    [toolBar setItems:[NSArray arrayWithObjects:cancelButton, flexSpace, doneButton, nil]];
    UIPickerView *pickerChonRap = [[UIPickerView alloc] init];
    pickerChonRap.dataSource = self;
    pickerChonRap.delegate = self;
    pickerChonRap.tag = 100;
    [pickerChonRap selectRow:1 inComponent:0 animated:YES];
    _edOption.inputAccessoryView = toolBar;
    _edOption.inputView = pickerChonRap;
    [pickerChonRap release];

}

- (void)doneChonOption:(UIBarButtonItem *)sender {
    [_edOption resignFirstResponder];
    [self taoDanhSachHienThi];
}

- (void)cancelChonOption:(UIBarButtonItem *)sender {
    [_edOption resignFirstResponder];
}

- (void)taoDanhSachHienThi {
    if (!_mDanhSachHienThi) {
        _mDanhSachHienThi = [[NSMutableArray alloc] init];
    }
    [_mDanhSachHienThi removeAllObjects];
    if (nIndexOption == 0) {
        for (SoTietKiem *temp in _mDanhSachSoTietKiem) {
            [_mDanhSachHienThi addObject:temp];
        }
    }
    else if (nIndexOption == 1) {
        for (SoTietKiem *temp in _mDanhSachSoTietKiem) {
            if ([temp.trangThai intValue] == 1) {
                [_mDanhSachHienThi addObject:temp];
            }
        }
    }
    [self.mtbHienThi reloadData];
}

- (void)khoiTaoDatePickerTuNgay
{
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.locale = [NSLocale currentLocale];
    
    _mtfTuNGay.inputView = datePicker;
    [datePicker addTarget:self action:@selector(suKienThayDoiNgayBatDau:) forControlEvents:UIControlEventValueChanged];
    [datePicker release];
}

- (void)khoiTaoDatePickerDenNgay
{
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.locale = [NSLocale currentLocale];
    [datePicker addTarget:self action:@selector(suKienThayDoiNgayKetThuc:) forControlEvents:UIControlEventValueChanged];
    _mtfDenNgay.inputView = datePicker;
    [datePicker release];
}

- (void)layDanhSachSoTietKiem
{
    NSLog(@"%s - bat dau lay danh sach so tiet kiem", __FUNCTION__);
    if(_secssion && ![_secssion isEmpty])
    {
        NSLog(@"%s - ==============> bat dau lay danh sach so tiet kiem", __FUNCTION__);
        self.mDinhDanhKetNoi = DINH_DANH_LAY_DANH_SACH_SO_TIET_KIEM;
        [GiaoDichMang ketNoiLayDanhSachSoTietKiem:_secssion noiNhanKetQua:self];
    }
    else
    {
//        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:[@"thong_bao" localizableString]
//                                                         message:@"Vui lòng đăng nhập lại để thực hiện chức năng này"
//                                                        delegate:nil
//                                               cancelButtonTitle:[@"dong" localizableString]
//                                               otherButtonTitles:nil, nil] autorelease];
//        [alert show];
    }
}

- (void)setSecssion:(NSString *)secssion
{
    if (_secssion) {
        [_secssion release];
    }
    _secssion = [secssion retain];
    [self layDanhSachSoTietKiem];
}

#pragma mark - suKien

- (IBAction)suKienBamNutTraCuu:(id)sender
{
    [_mtbHienThi reloadData];
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:[@"thong_bao" localizableString]
                                                    message:@"Đang phát triển"
                                                   delegate:nil
                                          cancelButtonTitle:[@"dong" localizableString]
                                          otherButtonTitles:nil, nil] autorelease];
    [alert show];
}

- (void)suKienThayDoiNgayBatDau:(UIDatePicker*)sender
{
    _mtfTuNGay.text = [Common date:sender.date toStringWithFormat:@"dd/MM/yyyy"];
}

- (void)suKienThayDoiNgayKetThuc:(UIDatePicker*)sender
{
    _mtfDenNgay.text = [Common date:sender.date toStringWithFormat:@"dd/MM/yyyy"];
}

#pragma mark - UIPickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row == 0) {
        return @"Tất cả";
    }
    else if (row == 1) {
        return @"Đang hiệu lực";
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    nIndexOption = (int)row;
    if (row == 0) {
        _edOption.text = @"Tất cả";
    }
    else{
        _edOption.text = @"Đang hiệu lực";
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_mDanhSachHienThi)
        return _mDanhSachHienThi.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *traCuuSoTietKiemTableViewCellIdentifier = @"traCuuSoTietKiemTableViewCellIdentifier";
    TraCuuSoTietKiemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:traCuuSoTietKiemTableViewCellIdentifier];
    if(!cell)
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TraCuuSoTietKiemTableViewCell" owner:self options:nil] objectAtIndex:0];
    SoTietKiem *soTietKiem = [_mDanhSachHienThi objectAtIndex:indexPath.row];
    cell.mSoTietKiem = soTietKiem;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SoTietKiem *soTietKiem = [_mDanhSachHienThi objectAtIndex:indexPath.row];
    if([self.mDelegate respondsToSelector:@selector(suKienChonSoTietKiem:)])
    {
        [self.mDelegate suKienChonSoTietKiem:soTietKiem];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (nIndexOption == 1 && _mDanhSachHienThi && _mDanhSachHienThi.count > 0) {
        return 40.0f;
    }
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (nIndexOption == 1 && _mDanhSachHienThi && _mDanhSachHienThi.count > 0) {
        UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
        UILabel *customLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, [UIScreen mainScreen].bounds.size.width / 2 - 15, 40)];
        customLabel.backgroundColor = [UIColor clearColor];
        NSString *sTitle = [NSString stringWithFormat:@"Số sổ: %lu", (unsigned long)_mDanhSachHienThi.count];
//        [Common hienThiTienTe:nSoTienHieuLuc]
        [customLabel setText:sTitle];

        UILabel *customLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width / 2 - 10, 0, [UIScreen mainScreen].bounds.size.width / 2 + 12, 40)];
        customLabel2.backgroundColor = [UIColor clearColor];
        NSString *sTitle2 = [NSString stringWithFormat:@"Số dư: %@", [Common hienThiTienTe:nSoTienHieuLuc]];
        [customLabel2 setText:sTitle2];
        customLabel2.font = [customLabel2.font fontWithSize:15.0f];
        customLabel2.textAlignment = NSTextAlignmentRight;
        [viewHeader addSubview:customLabel];
        [viewHeader addSubview:customLabel2];
        return viewHeader;
    }
    return nil;
}

#pragma mark - DucNT_ServicePostDelegate

-(void)ketNoiThanhCong:(NSString *)sKetQua
{
//    NSLog(@"%s - sKetQua : %@", __FUNCTION__, sKetQua);
    NSDictionary *dicKetQua = [sKetQua objectFromJSONString];
    int nCode = [[dicKetQua objectForKey:@"msgCode"] intValue];
    NSString *message = [dicKetQua objectForKey:@"msgContent"];
    NSArray *result = [dicKetQua objectForKey:@"result"];
    if(nCode == 1)
    {
        if([_mDinhDanhKetNoi isEqualToString:DINH_DANH_LAY_DANH_SACH_SO_TIET_KIEM])
        {
            NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:result.count];
            for(NSDictionary *dictSoTietKiem in result)
            {
                SoTietKiem *soTietKiem = [[SoTietKiem alloc] initWithDictionary:dictSoTietKiem];
                [temp addObject:soTietKiem];
                [soTietKiem release];
            }
            self.mDanhSachSoTietKiem = temp;
            if (!_mDanhSachHienThi) {
                _mDanhSachHienThi = [[NSMutableArray alloc] init];
            }
            [_mDanhSachHienThi removeAllObjects];
            NSLog(@"%s - self.mDanhSachSoTietKiem : %d", __FUNCTION__, (int)self.mDanhSachSoTietKiem.count);
            nSoTienHieuLuc = 0;
            for (SoTietKiem *soTemp in self.mDanhSachSoTietKiem) {
                if (nIndexOption == 1){
                    if ([soTemp.trangThai intValue] == 1) {
                        [_mDanhSachHienThi addObject:soTemp];
                        nSoTienHieuLuc += [soTemp.soTien intValue];
                    }
                }
                else{
                    [_mDanhSachHienThi addObject:soTemp];
                }
            }
            if (self.mDanhSachSoTietKiem.count > 0 && _mDanhSachHienThi.count == 0) {
                for (SoTietKiem *soTemp in self.mDanhSachSoTietKiem) {
                    [_mDanhSachHienThi addObject:soTemp];
                }
                self.edOption.text = @"Tất cả";
                nIndexOption = 0;
                UIPickerView *picker = (UIPickerView *)_edOption.inputView;
                [picker selectRow:0 inComponent:0 animated:YES];
            }
            if(temp.count > 0)
            {
                SoTietKiem *soBatDau = [temp objectAtIndex:temp.count - 1];
                _mtfTuNGay.text = [soBatDau layNgayGui];
                NSDate *dtNgayBatDau = [soBatDau layNgayGuiTraVeNSDate];
                if(dtNgayBatDau)
                    [(UIDatePicker*)_mtfTuNGay.inputView setDate:dtNgayBatDau];
                SoTietKiem *soKetThuc = [temp objectAtIndex:0];
                _mtfDenNgay.text = [soKetThuc layNgayGui];
                NSDate *dtNgayKetThuc = [soKetThuc layNgayGuiTraVeNSDate];
                if(dtNgayKetThuc)
                    [(UIDatePicker*)_mtfDenNgay.inputView setDate:dtNgayKetThuc];
            }
            [temp release];
            NSLog(@"%s - _mDanhSachHienThi : %d", __FUNCTION__, (int)_mDanhSachHienThi.count);
            [_mtbHienThi reloadData];
        }
    }
    else
    {
        UIAlertView *alert = [[[UIAlertView alloc]
                               initWithTitle:[@"thong_bao" localizableString]
                               message:message
                               delegate:nil
                               cancelButtonTitle:[@"dong" localizableString]
                               otherButtonTitles:nil, nil] autorelease];
        [alert show];
    }
}

#pragma mark - dealloc

- (void)dealloc
{
    if(_mDanhSachSoTietKiem)
        [_mDanhSachSoTietKiem release];
    if (_mDanhSachHienThi) {
        [_mDanhSachHienThi release];
    }
    [_mtbHienThi release];
    [_mtfTuNGay release];
    [_mtfDenNgay release];
    [_mbtnTraCuu release];
    [_edOption release];
    [super dealloc];
}
@end
