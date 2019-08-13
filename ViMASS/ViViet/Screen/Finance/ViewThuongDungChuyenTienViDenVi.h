//
//  ViewThuongDungViDenVi.h
//  ViViMASS
//
//  Created by DucBT on 1/21/15.
//
//

#import <UIKit/UIKit.h>
#import "ExTextField.h"
#import "UmiTextView.h"
#import "DucNT_TaiKhoanThuongDungObject.h"

@protocol ViewThuongDungChuyenTienViDenViDelegate <NSObject>

- (void)xuLySuKienBamNutDanhBa;

@end


@interface ViewThuongDungChuyenTienViDenVi : UIView

@property (retain, nonatomic) IBOutlet ExTextField *mtfTenDaiDien;
@property (retain, nonatomic) IBOutlet ExTextField *mtfTenTaiKhoan;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoTien;
@property (retain, nonatomic) IBOutlet UmiTextView *mtvNoiDungGiaoDich;
@property (retain, nonatomic) IBOutlet ExTextField *mtfNoiDungGiaoDich;

@property (assign, nonatomic) id<ViewThuongDungChuyenTienViDenViDelegate> mDelegate;
@property (retain, nonatomic) DucNT_TaiKhoanThuongDungObject *mTaiKhoanThuongDung;

- (BOOL)validate;
- (void)setTaiKhoan:(NSString*)sTaiKhoan;
- (DucNT_TaiKhoanThuongDungObject*)getTaiKhoanThuongDungDayLenServer;

@end
