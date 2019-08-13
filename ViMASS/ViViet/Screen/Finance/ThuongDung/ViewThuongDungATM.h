//
//  ViewThuongDungATM.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 4/25/16.
//
//

#import <UIKit/UIKit.h>
#import "ExTextField.h"
#import "DucNT_TaiKhoanThuongDungObject.h"

@interface ViewThuongDungATM : UIView<UIPickerViewDataSource, UIPickerViewDelegate>

@property (retain, nonatomic) DucNT_TaiKhoanThuongDungObject *mTaiKhoanThuongDung;

@property (retain, nonatomic) IBOutlet UIButton *btnSacombank;
@property (retain, nonatomic) IBOutlet UIButton *btnTechcombank;
@property (retain, nonatomic) IBOutlet UIButton *btnVietin;
@property (retain, nonatomic) IBOutlet ExTextField *edNameAlias;
@property (retain, nonatomic) IBOutlet ExTextField *btnSDT;
@property (retain, nonatomic) IBOutlet ExTextField *edATM;
@property (retain, nonatomic) IBOutlet ExTextField *edSoTien;
@property (retain, nonatomic) IBOutlet UILabel *lblPhi;

- (BOOL)kiemTraNoiDung;
- (void)layThongTinSoDienThoai:(NSString *)sSDT;
- (DucNT_TaiKhoanThuongDungObject*)getTaiKhoanThuongDungDayLenServer;
@end
