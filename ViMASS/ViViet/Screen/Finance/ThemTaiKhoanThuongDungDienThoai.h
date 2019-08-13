//
//  ThemTaiKhoanThuongDungDienThoai.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 1/13/16.
//
//

#import <UIKit/UIKit.h>
#import "ExTextField.h"
#import "DucNT_TaiKhoanThuongDungObject.h"

@interface ThemTaiKhoanThuongDungDienThoai : UIView<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, assign) int nNhaMang;
@property (nonatomic, assign) int nLoaiThueBao;
@property (retain, nonatomic) IBOutlet ExTextField *edNhaMang;
@property (retain, nonatomic) IBOutlet ExTextField *edSDT;
@property (retain, nonatomic) IBOutlet ExTextField *edTenHienThi;
@property (retain, nonatomic) DucNT_TaiKhoanThuongDungObject *mTaiKhoanThuongDung;

- (IBAction)suKienBamNutDanhBa:(id)sender;
- (BOOL)kiemTraNoiDung;
- (DucNT_TaiKhoanThuongDungObject*)getTaiKhoanThuongDungDayLenServer;
@end
