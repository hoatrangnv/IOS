//
//  CellChuyenVe.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 1/18/16.
//
//

#import "CellChuyenVe.h"

@implementation CellChuyenVe

- (void)awakeFromNib {
    UIPickerView *pickerDanh = [[UIPickerView alloc] init];
    pickerDanh.tag = 100;
    pickerDanh.delegate = self;
    pickerDanh.dataSource = self;
    self.edHanhLy.inputView = pickerDanh;
    [pickerDanh release];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 7;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self getChucDanh:(int)pickerView.tag nRow:(int)row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString *sChucDanh = [self getChucDanh:(int)pickerView.tag nRow:(int)row];
    self.edHanhLy.text = sChucDanh;
    [self.edHanhLy resignFirstResponder];
    if (self.delegate) {
        [self.delegate suKienChonHanhLyChuyenVe];
    }
}

- (NSString *)getChucDanh:(int)tag nRow:(int)row{
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
    return @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
    [_edHanhLy release];
    [_lblKhachHang release];
    [super dealloc];
}
@end
