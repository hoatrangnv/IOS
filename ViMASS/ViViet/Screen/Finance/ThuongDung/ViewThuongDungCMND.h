//
//  ViewThuongDungCMND.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 4/28/16.
//
//

#import <UIKit/UIKit.h>
#import "ExTextField.h"
#import "DucNT_TaiKhoanThuongDungObject.h"
#import "UmiTextView.h"

@protocol ViewThuongDungCMNDDelegate <NSObject>

- (void)layThongTinChiNhanhNganHang:(double)lat lng:(double)lng nKhoangCach:(int)nKC sKeyWord:(NSString *)sKeyWord;

@end

@interface ViewThuongDungCMND : UIView <UIPickerViewDelegate, UIPickerViewDataSource>
@property (retain, nonatomic) DucNT_TaiKhoanThuongDungObject *mTaiKhoanThuongDung;
@property (retain, nonatomic) IBOutlet ExTextField *edKhuVuc;
@property (retain, nonatomic) IBOutlet ExTextField *edQuanHuyen;
@property (retain, nonatomic) IBOutlet ExTextField *edNganHang;
@property (retain, nonatomic) IBOutlet ExTextField *edTenCN;
@property (retain, nonatomic) IBOutlet UmiTextView *tvDiaChi;
@property (retain, nonatomic) IBOutlet ExTextField *edTenNguoiNhan;
@property (retain, nonatomic) IBOutlet ExTextField *edSoCMND;
@property (retain, nonatomic) IBOutlet ExTextField *edNgayCap;
@property (retain, nonatomic) IBOutlet ExTextField *edNoiCap;
@property (retain, nonatomic) IBOutlet ExTextField *edSoTien;
@property (retain, nonatomic) IBOutlet UmiTextView *tvNoiDung;
@property (retain, nonatomic) IBOutlet ExTextField *edNameAlias;
@property (assign, nonatomic) id<ViewThuongDungCMNDDelegate> delegate;

- (void)capNhatThongTinChiNhanh:(NSString *)sMaChiNhanh sTenChiNhanh:(NSString *)sTen sDiaChi:(NSString *)sDiaChi;
- (IBAction)suKienTimChiNhanh:(id)sender;
- (BOOL)kiemTraNoiDung;
- (DucNT_TaiKhoanThuongDungObject*)getTaiKhoanThuongDungDayLenServer;

@end
