//
//  DangKyTheDaNangViewController.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 5/23/19.
//

#import "DangKyTheDaNangViewController.h"
#import "DucNT_ViewDatePicker.h"

@interface DangKyTheDaNangViewController () <UITextFieldDelegate> {
    NSString *resultVID;
}

@end

@implementation DangKyTheDaNangViewController
static NSString *dongYDieuKhoan = @"<span style=\"color:#000; text-align:center; width:100%; float:left\">Tôi đồng ý với các <a style=\"color:#000; font-weight:bold; text-decoration:none\" target=\"_blank\" href=\"http://tmdd.vn/news/70-dieu-khoan-su-dung.aspx\">điều khoản</a> đăng ký tài khoản</span>";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Đăng ký thẻ đa năng";
    
    [self.webDieuKhoan loadHTMLString:dongYDieuKhoan baseURL:nil];
    
    [_tfMatKhau setMax_length:20];
    [_tfNhacLaiMatKhau setMax_length:20];
    
    _tfNgaySinh.inputAccessoryView = nil;
    DucNT_ViewDatePicker *vDatePickerNgaySinh = [[DucNT_ViewDatePicker alloc] initWithNib];
    __block DangKyTheDaNangViewController *blockSELF = self;
    [vDatePickerNgaySinh truyenThongSoThoiGian:^(NSString *sThoiGian) {
        [blockSELF->_tfNgaySinh resignFirstResponder];
        if(sThoiGian != nil && sThoiGian.length > 0)
        {
            blockSELF->_tfNgaySinh.text = sThoiGian;
        }
    }];
    _tfNgaySinh.inputView = vDatePickerNgaySinh;
    [vDatePickerNgaySinh release];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"%s - START", __FUNCTION__);
    return YES;
}

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (BOOL)validateVanTay {
    if ([_tfHoTen.text isEmpty]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Họ tên không được để trống"];
        return NO;
    } else if (_tfHoTen.text.length < 5){
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Họ tên phải lớn hơn hoặc bằng 5 ký tự"];
        return NO;
    }
    if ([_tfCMND.text isEmpty]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"CMND không được để trống"];
        return NO;
    } else if (_tfCMND.text.length < 5){
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"CMND phải lớn hơn hoặc bằng 5 ký tự"];
        return NO;
    }
    if ([_tfNgaySinh.text isEmpty]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Ngày sinh không được để trống"];
        return NO;
    } else if (_tfNgaySinh.text.length < 8){
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"CMND phải lớn hơn hoặc bằng 8 ký tự"];
        return NO;
    }
    if ([_tfEmail.text isEmpty]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Email không được để trống"];
        return NO;
    } else if (![self validateEmailWithString:_tfEmail.text]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Email không đúng định dạng"];
        return NO;
    }
    if ([_tfMatKhau.text isEmpty]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Mật khẩu không được để trống"];
        return NO;
    } else if (_tfMatKhau.text.length < 6) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Mật khẩu phải lớn hơn hoặc bằng 6 ký tự"];
        return NO;
    }
    if ([_tfNhacLaiMatKhau.text isEmpty]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Mật khẩu nhắc lại không được để trống"];
        return NO;
    } else if (_tfNhacLaiMatKhau.text.length < 6) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Mật khẩu phải lớn hơn hoặc bằng 6 ký tự"];
        return NO;
    }
    if (![_tfMatKhau.text containsString:_tfNhacLaiMatKhau.text]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Mật khẩu nhắc lại không trùng nhau"];
        return NO;
    }
    if ([_tfSoSeri.text isEmpty]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Số seri không được để trống"];
        return NO;
    } else if (_tfSoSeri.text.length < 6) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Số seri phải lớn hơn hoặc bằng 6 ký tự"];
        return NO;
    }
    return YES;
}

- (IBAction)suKienChonDangKy:(id)sender {
    if ([self validateVanTay]) {
        NSDictionary *dict = @{@"VMApp" : [NSNumber numberWithInt:VM_APP],
                               @"hoTenDayDu" : _tfHoTen.text,
                               @"cmnd" : _tfCMND.text,
                               @"ngaySinh" : [_tfNgaySinh.text stringByReplacingOccurrencesOfString:@"-" withString:@""],
                               @"email" : _tfEmail.text,
                               @"pass" : _tfMatKhau.text,
                               @"seri" : _tfSoSeri.text
                               };
        NSString *sJsonDict = [dict JSONString];
        NSLog(@"%s - sJsonDict : %@", __FUNCTION__, sJsonDict);
        [self hienThiLoadingChuyenTien];
        self.mDinhDanhKetNoi = @"DANG_KY_THE_DA_NANG";
        [GiaoDichMang ketNoiDangKyTheDaNang:sJsonDict noiNhanKetQua:self];
    }
}

- (void)ketNoiXacThucOTP:(NSString *)sOtpConfirm {
    [self hienThiLoadingChuyenTien];
    self.mDinhDanhKetNoi = @"CONFIRM_THE_DA_NANG";
    NSDictionary *dict = @{@"VMApp" : [NSNumber numberWithInt:VM_APP],
                           @"mm" : sOtpConfirm,
                           @"idVid" : resultVID
                           };
    NSString *sJsonDict = [dict JSONString];
    [GiaoDichMang ketNoiConfirmDangKyTheDaNang:sJsonDict noiNhanKetQua:self];
}

- (void)xuLyKetNoiThanhCong:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua {
    if ([sDinhDanhKetNoi isEqualToString:@"DANG_KY_THE_DA_NANG"]) {
        [self anLoading];
        resultVID = [[NSString alloc] initWithString:(NSString *)ketQua];
        NSLog(@"%s - resultVID : %@", __FUNCTION__, resultVID);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[@"thong_bao" localizableString] message:sThongBao preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Mã OTP confirm";
        }];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Xác thực" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *tf = alert.textFields.firstObject;
            if (tf.text.length != 6) {
                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"OTP confirm phải có độ dài là 6 ký tự"];
            } else {
                [self ketNoiXacThucOTP:tf.text];
            }
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Huỷ" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    } else if ([sDinhDanhKetNoi isEqualToString:@"CONFIRM_THE_DA_NANG"]) {
        [self anLoading];
        NSLog(@"%s - ketQua : %@", __FUNCTION__, (NSString *)ketQua);
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
    }
}

- (void)dealloc {
    [_webDieuKhoan release];
    [_tfHoTen release];
    [_tfCMND release];
    [_tfNgaySinh release];
    [_tfEmail release];
    [_tfMatKhau release];
    [_tfNhacLaiMatKhau release];
    [_tfSoSeri release];
    [super dealloc];
}
@end
