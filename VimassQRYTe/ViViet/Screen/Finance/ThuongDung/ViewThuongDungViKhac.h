//
//  ViewThuongDungViKhac.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 5/4/16.
//
//

#import <UIKit/UIKit.h>
#import "ExTextField.h"
#import "UmiTextView.h"
#import "DucNT_TaiKhoanThuongDungObject.h"

@protocol ViewThuongDungViKhacDelegate <NSObject>

- (void)capNhatLaiGiaoDienViKhac;

@end

@interface ViewThuongDungViKhac : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (retain, nonatomic) DucNT_TaiKhoanThuongDungObject *mTaiKhoanThuongDung;
@property (retain, nonatomic) IBOutlet ExTextField *edNameAlias;
@property (retain, nonatomic) IBOutlet ExTextField *edChonVi;
@property (retain, nonatomic) IBOutlet ExTextField *edSoTien;
@property (retain, nonatomic) IBOutlet ExTextField *edSoVi;
@property (retain, nonatomic) IBOutlet UmiTextView *tvNoiDung;
@property (retain, nonatomic) IBOutlet ExTextField *tfNoiDung;
@property (assign, nonatomic) id<ViewThuongDungViKhacDelegate> delegate;
- (IBAction)suKienChonDanhBaViKhac:(id)sender;
- (BOOL)kiemTraNoiDung;
- (DucNT_TaiKhoanThuongDungObject*)getTaiKhoanThuongDungDayLenServer;
@end
