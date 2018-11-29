//
//  CellChuyenDi.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 1/12/16.
//
//

#import "CellChuyenDi.h"

@implementation CellChuyenDi

- (void)awakeFromNib {
    // Initialization code
    self.edHoTen.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    self.edHoTen.delegate = self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSRange lowercaseCharRange = [string rangeOfCharacterFromSet:[NSCharacterSet lowercaseLetterCharacterSet]];

    if (lowercaseCharRange.location != NSNotFound) {
        textField.text = [textField.text stringByReplacingCharactersInRange:range
                                                                 withString:[string uppercaseString]];
        return NO;
    }

    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)khoiTaoNguoiLon{
    UIPickerView *pickerDanh = [[UIPickerView alloc] init];
    pickerDanh.tag = 100;
    pickerDanh.delegate = self;
    pickerDanh.dataSource = self;
    self.edDanhXung.inputView = pickerDanh;
    [pickerDanh release];

    if (self.nKieu != 2) {
        if (self.nKieu == 0) {
            self.edDanhXung.text = @"Ông";
            [self.edNgaySinh setHidden:YES];
//            self.edOptionHanhLy.frame = self.edNgaySinh.frame;
            self.heightNgaySinh.constant = 0;
            self.topHanhLy.constant = 0;
        }
        else{
            self.edDanhXung.text = @"Trai";
            self.heightNgaySinh.constant = 30;
            self.topHanhLy.constant = 8;
            [self.edNgaySinh setHidden:NO];
        }
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
        toolBar.barStyle = UIBarStyleBlackOpaque;
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneChonNamSinhTreEm:)];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelChonNamSinhTreEm:)];
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [toolBar setItems:[NSArray arrayWithObjects:cancelButton, flexSpace, doneButton, nil]];
        
        UIDatePicker *pickerHanhLy = [[UIDatePicker alloc] init];
        pickerHanhLy.tag = 105;
        pickerHanhLy.datePickerMode = UIDatePickerModeDate;
        [pickerHanhLy addTarget:self action:@selector(onDatePickerTreEmValueChanged:) forControlEvents:UIControlEventValueChanged];
        self.edNgaySinh.inputAccessoryView = toolBar;
        self.edNgaySinh.inputView = pickerHanhLy;
        [pickerHanhLy release];
        self.edNgaySinh.text = @"";
        self.edNgaySinh.placeholder = @"Ngày sinh (Năm/Tháng/Ngày)";
        
        UIPickerView *pickerHanhLy1 = [[UIPickerView alloc] init];
        pickerHanhLy1.tag = 101;
        pickerHanhLy1.delegate = self;
        pickerHanhLy1.dataSource = self;
        self.edOptionHanhLy.inputView = pickerHanhLy1;
        self.edOptionHanhLy.text = @"Ko hành lý";
        [pickerHanhLy1 release];
        [self.edOptionHanhLy setHidden:NO];
    }
    else{
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
        toolBar.barStyle = UIBarStyleBlackOpaque;
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneChonNamSinh:)];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelChonNamSinh:)];
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [toolBar setItems:[NSArray arrayWithObjects:cancelButton, flexSpace, doneButton, nil]];

        UIDatePicker *pickerHanhLy = [[UIDatePicker alloc] init];
        pickerHanhLy.tag = 102;
        pickerHanhLy.datePickerMode = UIDatePickerModeDate;
        [pickerHanhLy addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        self.edOptionHanhLy.inputAccessoryView = toolBar;
        self.edOptionHanhLy.inputView = pickerHanhLy;
        [pickerHanhLy release];
        self.edDanhXung.text = @"Bé Trai";
        self.edOptionHanhLy.text = @"";
        self.edOptionHanhLy.placeholder = @"Ngày sinh (Năm/Tháng/Ngày)";
        [self.edOptionHanhLy setHidden:YES];
    }
}

-(void)onDatePickerTreEmValueChanged:(UIDatePicker *)datePicker{
    NSDateFormatter __autoreleasing *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormat setDateFormat:@"YYYYMMdd"];
    NSString *dateString =  [dateFormat stringFromDate:datePicker.date];
    self.edOptionHanhLy.text = dateString;
}

-(void)onDatePickerValueChanged:(UIDatePicker *)datePicker{
    NSDateFormatter __autoreleasing *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormat setDateFormat:@"YYYYMMdd"];
    NSString *dateString =  [dateFormat stringFromDate:datePicker.date];
    self.edOptionHanhLy.text = dateString;
}

- (void)doneChonNamSinhTreEm:(UIBarButtonItem *)sender{
    [self.edNgaySinh resignFirstResponder];
}

- (void)cancelChonNamSinhTreEm:(UIBarButtonItem *)sender{
    [self.edNgaySinh resignFirstResponder];
}

- (void)doneChonNamSinh:(UIBarButtonItem *)sender{
    [self.edOptionHanhLy resignFirstResponder];
}

- (void)cancelChonNamSinh:(UIBarButtonItem *)sender{
    [self.edOptionHanhLy resignFirstResponder];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 100) {
        return 2;
    }
    else if (pickerView.tag == 101) {
        return 7;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self getChucDanh:(int)pickerView.tag nRow:(int)row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString *sChucDanh = [self getChucDanh:(int)pickerView.tag nRow:(int)row];
    if (pickerView.tag == 100) {
        self.edDanhXung.text = sChucDanh;
        [self.edDanhXung resignFirstResponder];
    }
    else{
        self.edOptionHanhLy.text = sChucDanh;
        [self.edOptionHanhLy resignFirstResponder];
        if (self.delegate) {
            [self.delegate suKienThayDoiChonHanhLy];
        }
    }
}

- (NSString *)getChucDanh:(int)tag nRow:(int)row{
    if (tag == 100) {
        if (self.nKieu == 0) {
            if (row == 0) {
                return @"Ông";
            }
            else{
                return @"Bà";
            }
        }
        else if (self.nKieu == 1) {
            if (row == 0) {
                return @"Trai";
            }
            else{
                return @"Gái";
            }
        }
        else{
            if (row == 0) {
                return @"Bé Trai";
            }
            else{
                return @"Bé Gái";
            }
        }
    }
    else if (tag == 101) {
        if (row == 0) {
            return @"Ko hành lý";
        }
        else if (row == 1) {
            return @"15kg";
        }
        else if (row == 2) {
            return @"20kg";
        }
        else if (row == 3) {
            return @"25kg";
        }
        else if (row == 4) {
            return @"30kg";
        }
        else if (row == 5) {
            return @"40kg";
        }
        else if (row == 6) {
            return @"45kg";
        }
    }
    return @"";
}

- (void)dealloc {
    [_edDanhXung release];
    [_edHoTen release];
    [_edOptionHanhLy release];
    [_edNgaySinh release];
    [_heightNgaySinh release];
    [_topHanhLy release];
    [super dealloc];
}
@end
