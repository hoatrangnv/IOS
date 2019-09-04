//
//  DucNT_ChuyenTienDenTheViewController.h
//  ViMASS
//
//  Created by MacBookPro on 8/2/14.
//
//

#import "GiaoDich/GiaoDichViewController.h"
#import "DucNT_ServicePost.h"
#import "ExTextField.h"
#import "UmiTextView.h"
#import "DucNT_DanhSachTaiKhoanThuongDungControllerViewController.h"
#import "DucNT_TaiKhoanThuongDungObject.h"
#import "DucNT_ViewDatePicker.h"
#import "DucNT_ViewPicker.h"
#import "DucNT_LuuRMS.h"
#import "DucNT_Token.h"

@interface DucNT_ChuyenTienDenTheViewController : GiaoDichViewController

@property (retain, nonatomic) IBOutlet ExTextField *mtfSoTheNganHang;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoTien;
@property (retain, nonatomic) IBOutlet UIButton *mbtnLuuTaiKhoanThuongDung;
@property (retain, nonatomic) IBOutlet UIView *viewCenter;
@property (nonatomic, assign) int nOption;
- (IBAction)suKienLuuTaiKhoanThuongDung:(id)sender;
- (IBAction)suKienLayDanhSachThuongDung:(id)sender;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *heightMain;

@property (nonatomic, retain) DucNT_TaiKhoanThuongDungObject *mTaiKhoanThuongDung;

@end
