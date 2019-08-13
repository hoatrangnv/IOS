//
//  ViewThuongDungThe.h
//  ViViMASS
//
//  Created by DucBT on 1/21/15.
//
//

#import "DucNT_LuuRMS.h"
#import <UIKit/UIKit.h>
#import "ExTextField.h"
#import "Banks.h"
#import "UmiTextView.h"
#import "DucNT_TaiKhoanThuongDungObject.h"

@interface ViewThuongDungChuyenTienDenThe : UIView

@property (retain, nonatomic) IBOutlet ExTextField *mtfTenDaiDien;
@property (retain, nonatomic) IBOutlet ExTextField *mtfNganHang;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoThe;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoTien;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoPhiChuyenTien;
@property (retain, nonatomic) IBOutlet UmiTextView *mtvNoiDungGiaoDich;
@property (retain, nonatomic) IBOutlet ExTextField *mtfNoiDungGiaoDich;


@property (nonatomic, retain) DucNT_TaiKhoanThuongDungObject *mTaiKhoanThuongDung;


- (Banks*)getBanks;
- (BOOL)validate;
- (DucNT_TaiKhoanThuongDungObject*)getTaiKhoanThuongDungDayLenServer;

@end
