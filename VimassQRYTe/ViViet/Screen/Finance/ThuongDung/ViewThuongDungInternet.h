//
//  ViewThuongDungInternet.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 6/2/16.
//
//

#import <UIKit/UIKit.h>
#import "ExTextField.h"
#import "DucNT_TaiKhoanThuongDungObject.h"

@protocol ViewThuongDungInternetDelegate <NSObject>

- (void)capNhatLaiGiaoDienNapTienInternet;

@end

@interface ViewThuongDungInternet : UIView<UIPickerViewDelegate, UIPickerViewDataSource>
@property (assign, nonatomic) id<ViewThuongDungInternetDelegate> delegate;
@property (retain, nonatomic) IBOutlet UIButton *btnVNPT;
@property (retain, nonatomic) IBOutlet UIButton *btnViettel;
@property (retain, nonatomic) IBOutlet UIButton *btnFPT;
@property (retain, nonatomic) IBOutlet UIButton *btnCMC;
@property (retain, nonatomic) IBOutlet ExTextField *edNameAlias;
@property (retain, nonatomic) IBOutlet ExTextField *edMaKhachHang;
@property (retain, nonatomic) IBOutlet ExTextField *mtfChonVNPT;
@property (retain, nonatomic) DucNT_TaiKhoanThuongDungObject *mTaiKhoanThuongDung;
- (BOOL)kiemTraNoiDung;
- (DucNT_TaiKhoanThuongDungObject*)getTaiKhoanThuongDungDayLenServer;
- (IBAction)suKienChonVNPT:(id)sender;
- (IBAction)suKienViettel:(id)sender;
- (IBAction)suKienChonFPT:(id)sender;
- (IBAction)suKienChonCMC:(id)sender;
@end
