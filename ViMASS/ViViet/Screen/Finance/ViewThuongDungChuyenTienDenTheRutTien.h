//
//  ViewThuongDungChuyenTienDenTheRutTien.h
//  ViViMASS
//
//  Created by DucBT on 1/28/15.
//
//

#import "DucNT_LuuRMS.h"
#import <UIKit/UIKit.h>
#import "ExTextField.h"
#import "DucNT_TaiKhoanThuongDungObject.h"

@interface ViewThuongDungChuyenTienDenTheRutTien : UIView
@property (retain, nonatomic) IBOutlet ExTextField *mtfTenDaiDien;
@property (retain, nonatomic) IBOutlet ExTextField *mtfNganHang;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoThe;

@property (nonatomic, retain) DucNT_TaiKhoanThuongDungObject *mTaiKhoanThuongDung;

- (BOOL)validate;

- (DucNT_TaiKhoanThuongDungObject*)getTaiKhoanThuongDungDayLenServer;

@end
