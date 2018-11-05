//
//  ViewThuongDungTienDien.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 5/30/16.
//
//

#import <UIKit/UIKit.h>
#import "DucNT_TaiKhoanThuongDungObject.h"
#import "ExTextField.h"

@interface ViewThuongDungTienDien : UIView
@property (retain, nonatomic) IBOutlet ExTextField *edNameAlias;
@property (retain, nonatomic) IBOutlet ExTextField *edMaKhachHang;
@property (retain, nonatomic) DucNT_TaiKhoanThuongDungObject *mTaiKhoanThuongDung;
- (BOOL)kiemTraNoiDung;
- (DucNT_TaiKhoanThuongDungObject*)getTaiKhoanThuongDungDayLenServer;

@end
