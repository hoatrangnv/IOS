//
//  GiaoDienChuyenTienTanNha.m
//  ViViMASS
//
//  Created by nguyen tam on 7/2/15.
//
//

#import "GiaoDienChuyenTienTanNha.h"


typedef enum : NSUInteger {
    TF_ = 1,
    TF_NGAN_HANG_GUI_TK = 2,
    TF_KY_HAN_GUI_TK = 3,
    TF_KY_LINH_LAI = 4,
    TF_CACH_THUC_QUAY_VONG = 5,
    TF_DANH_SACH_NGAN_HANG= 6,
} TAG_TF;


@interface GiaoDienChuyenTienTanNha () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, retain) NSArray *arrDanhSachTinhThanh;

@end


@implementation GiaoDienChuyenTienTanNha

- (void)viewDidLoad {
    [super viewDidLoad];
    [self khoiTaoGiaoDien];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)khoiTaoGiaoDien {
    
    [self addButtonBack];
    self.title = @"Chuyển tiền tận nhà";
    
    [self.mtfHoTen setTextError:@"Vui lòng nhập họ và tên người nhận" forType:ExTextFieldTypeEmpty];
    [self.mtfHoTen setType:ExTextFieldTypeName];
    self.mtfHoTen.inputAccessoryView = nil;
    
    [self.mtfCMND setTextError:@"Vui lòng nhập CMND người nhận" forType:ExTextFieldTypeEmpty];
    self.mtfCMND.inputAccessoryView = nil;
    
    [self.mtfSoTien setTextError:@"Vui lòng nhập số tiền" forType:ExTextFieldTypeEmpty];
    [self.mtfSoTien setType:ExTextFieldTypeMoney];
    self.mtfSoTien.inputAccessoryView = nil;
    
    [self.mtfPhoneNumber setTextError:@"Vui lòng nhập số điện thoại người nhận" forType:ExTextFieldTypeEmpty];
    [self.mtfPhoneNumber setType:ExTextFieldTypePhone];
    self.mtfPhoneNumber.inputAccessoryView = nil;
    
    [self.mtfDiaChi setTextError:@"Vui lòng nhập địa chỉ nhận tiền" forType:ExTextFieldTypeEmpty];
    self.mtfDiaChi.inputAccessoryView = nil;
    
    CGRect rectVanTay = self.mbtnVanTay.frame;
    CGRect rectViewMain = self.mViewMain.frame;
    float fHeight = 0;
    float fWidth = self.mScrMain.frame.size.width;
    rectViewMain = CGRectMake(10, 10, rectViewMain.size.width, rectViewMain.size.height);
    fHeight = rectViewMain.origin.y + rectViewMain.size.height;
    
    if ([self kiemTraCoChucNangQuetVanTay]) {
        rectVanTay.origin.y = fHeight + 70;
        rectVanTay.origin.x = (fWidth - rectVanTay.size.width) / 2;
        fHeight = rectVanTay.origin.y + rectVanTay.size.height - 60;
    }
    else
        fHeight += 10;
    
    [self.mbtnVanTay removeFromSuperview];
    
    self.mViewMain.frame = rectViewMain;
    self.mbtnVanTay.frame = rectVanTay;
    
    [self.mScrMain addSubview:self.mViewMain];
    [self.mScrMain addSubview:self.mbtnVanTay];
    [self.mScrMain setContentSize:CGSizeMake(fWidth, fHeight)];
    
    NSString *dataTinhThanh = [[NSBundle mainBundle] pathForResource:@"ThongTinTinhThanhPho" ofType:@"plist"];
    NSDictionary *dicCity = [[NSDictionary alloc] initWithContentsOfFile:dataTinhThanh];
    NSLog(@"Plist tinh thanh value: %@", dicCity);
    self.arrDanhSachTinhThanh = [[NSArray alloc] initWithArray:[dicCity valueForKey:@"dsTinhThanh"]];
    [dicCity release];
    
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.tag = 1;
    picker.dataSource = self;
    picker.delegate = self;
    self.mtfTinhThanh.inputAccessoryView = nil;
    self.mtfTinhThanh.inputView = picker;
    [picker release];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView.tag == 1){
        if (self.arrDanhSachTinhThanh) {
            return [self.arrDanhSachTinhThanh count];
        }
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView.tag == 1){
        if(self.arrDanhSachTinhThanh){
            NSDictionary *dicTemp = [self.arrDanhSachTinhThanh objectAtIndex:row];
            return [dicTemp valueForKey:@"ten"];
        }
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 1) {
        NSDictionary *dicTemp = [self.arrDanhSachTinhThanh objectAtIndex:row];
        self.mtfTinhThanh.text = [dicTemp valueForKey:@"ten"];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_mtfPhi release];
    [_mtfPhoneNumber release];
    [_mtfTinhThanh release];
    [_mtfQuanHuyen release];
    [_mtfPhuongXa release];
    [_mtfDiaChi release];
    [_mtfNoiDung release];
    [_mScrMain release];
    [_mtfHoTen release];
    [_mtfCMND release];
    [_mtfSoTien release];
    [_arrDanhSachTinhThanh release];
    [super dealloc];
}
@end
