//
//  GiaoDienBaoHiem.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 6/27/17.
//
//

#import "GiaoDienBaoHiem.h"

@interface GiaoDienBaoHiem ()<UIPickerViewDataSource, UIPickerViewDelegate> {
    ViewQuangCao *viewQC;
    int indexLoai;
    NSArray *arrLoaiBaoHiem;
}

@end

@implementation GiaoDienBaoHiem

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitleView:@"Bảo hiểm"];
    indexLoai = 0;
    arrLoaiBaoHiem = [[NSArray alloc] initWithObjects:@"Trả phí bảo hiểm Liberty", @"Trả phí bảo hiểm nhân thọ ACE Life VN", @"Trả phí bảo hiểm nhân thọ AIA VN", @"Trả phí bảo hiểm nhân thọ Prudential VN", @"Trả phí bảo hiểm AIG VN", @"Trả phí bảo hiểm Hanwha Life VN", @"Trả phí bảo hiểm nhân thọ Dai-ichi VN", @"Trả phí bảo hiểm nhân thọ PVI Sun Life", @"Trả phí bảo hiểm Manulife VN", @"Trả phí bảo hiểm Vietcombank Cardif (VCLI)", nil];
//    arrLoaiBaoHiem = @[@"Trả phí bảo hiểm Liberty", @"Trả phí bảo hiểm nhân thọ ACE Life VN", @"Trả phí bảo hiểm nhân thọ AIA VN", @"Trả phí bảo hiểm nhân thọ Prudential VN", @"Trả phí bảo hiểm AIG VN", @"Trả phí bảo hiểm Hanwha Life VN", @"Trả phí bảo hiểm nhân thọ Dai-ichi VN", @"Trả phí bảo hiểm nhân thọ PVI Sun Life", @"Trả phí bảo hiểm Manulife VN", @"Trả phí bảo hiểm Vietcombank Cardif (VCLI)"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self khoiTaoQuangCao];

    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 12)];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"muiten35x21.png"] forState:UIControlStateNormal];
    _tfLoaiBaoHiem.rightView = btnRight;
    _tfLoaiBaoHiem.rightViewMode = UITextFieldViewModeAlways;

    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneChonNhaMay:)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelChonNhaMay:)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

    [toolBar setItems:[NSArray arrayWithObjects:cancelButton, flexSpace, doneButton, nil]];
    UIPickerView *pickerChonRap = [[UIPickerView alloc] init];
    pickerChonRap.dataSource = self;
    pickerChonRap.delegate = self;
    pickerChonRap.tag = 100;
    _tfLoaiBaoHiem.inputAccessoryView = toolBar;
    _tfLoaiBaoHiem.inputView = pickerChonRap;
    [pickerChonRap release];
    
    [self.tvNoiDung resignFirstResponder];
}

- (void)khoiTaoQuangCao {
    if (viewQC) {
        return;
    }
    viewQC = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ViewQuangCao class]) owner:self options:nil] objectAtIndex:0];
    viewQC.mDelegate = self;
    CGRect rectToken = self.viewThanhToan.frame;
    CGRect rectQC = viewQC.frame;
    CGRect rectMain = self.mViewMain.frame;
    rectQC.origin.x += 2;
    CGFloat fW = rectMain.size.width;
    CGFloat fH = fW * 0.45333;
    rectQC.origin.y = rectToken.origin.y + rectToken.size.height;
    viewQC.frame = CGRectMake(0, rectQC.origin.y, fW, fH);
    viewQC.mDelegate = self;
    [viewQC updateSizeQuangCao];
    rectMain.size.height = rectQC.origin.y + rectQC.size.height;
    self.mViewMain.frame = rectMain;
    [self.mViewMain addSubview:viewQC];
    [self.scrMain setContentSize:CGSizeMake(_scrMain.frame.size.width, rectMain.origin.y + rectMain.size.height + self.viewOptionTop.frame.origin.y + self.viewOptionTop.frame.size.height + 50)];
}

- (void)hideViewNhapToken {
    
}

- (BOOL)validateVanTay {
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return NO;
    }
    if (_tfMaKhachHang.text.isEmpty) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Mã khách hàng không được để trống"];
        return NO;
    }
    if (_tfTenKhachHang.text.isEmpty) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Tên khách hàng không được để trống"];
        return NO;
    }
    if (_tfSoTien.text.isEmpty) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Số tiền không được để trống"];
        return NO;
    }
    return YES;
}

- (void)xuLyThucHienKhiKiemTraThanhCongTraVeToken:(NSString *)sToken otp:(NSString *)sOtp {
    [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Chức năng đang được phát triển"];
}

#pragma mark - UIPickerDelegate
- (void)doneChonNhaMay:(UIBarButtonItem *)sender {
    [_tfLoaiBaoHiem resignFirstResponder];
    _tfLoaiBaoHiem.text = [arrLoaiBaoHiem objectAtIndex:indexLoai];
}

- (void)cancelChonNhaMay:(UIBarButtonItem *)sender {
    [_tfLoaiBaoHiem resignFirstResponder];
    _tfLoaiBaoHiem.text = @"";
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return arrLoaiBaoHiem.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [arrLoaiBaoHiem objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    indexLoai = (int)row;
    _tfLoaiBaoHiem.text = [arrLoaiBaoHiem objectAtIndex:row];
}

- (void)dealloc {
    [viewQC release];
    [_tfLoaiBaoHiem release];
    [_tfMaKhachHang release];
    [_tfTenKhachHang release];
    [_tfSoTien release];
    [super dealloc];
}
@end
