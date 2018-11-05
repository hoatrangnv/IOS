//
//  DucNT_DanhSachTaiKhoanThuongDungControllerViewController.h
//  ViMASS
//
//  Created by MacBookPro on 7/24/14.
//
//

#import "GiaoDichViewController.h"
#import "DucNT_ServicePost.h"
#import "DucNT_LuuRMS.h"
#import "FixIOS7StatusBarRootView.h"
#import "DucNT_TaiKhoanThuongDungCell.h"

extern NSString *KEY_TAI_KHOAN_THUONG_DUNG;
extern NSString *KEY_TAI_KHOAN_NAP_TIEN;

enum DINH_DANH_KET_NOI
{
    KET_NOI_LAY_DANH_SACH_TAI_KHOAN = 0,
    KET_NOI_XOA_TAI_KHOAN = 1,
    KET_NOI_DANG_KY_DINH_KY = 2,
    KET_NOI_HUY_DINH_KY = 3
};

@interface DucNT_DanhSachTaiKhoanThuongDungControllerViewController : GiaoDichViewController<UITableViewDataSource, UITableViewDelegate, DucNT_ServicePostDelegate, TaiKhoanThuongDungCellDelegate, UIAlertViewDelegate>
@property (nonatomic, assign) BOOL bChuyenGiaoDien;
@property (retain, nonatomic) IBOutlet FixIOS7StatusBarRootView *rootView;
@property (retain, nonatomic) IBOutlet UILabel *lbTitle;
@property (retain, nonatomic) IBOutlet UITableView *lvDanhSachTaiKhoan;

@property (assign, nonatomic) int nLoaiTaiKhoan;
@property (retain, nonatomic) NSMutableArray *dsTaiKhoanThuongDung;
@property (retain, nonatomic) IBOutlet UIButton *btnBack;

- (IBAction)suKienBack:(id)sender;
-(id)initWithType:(int)nLoaiVi;
- (IBAction)suKienBamTitle:(id)sender;
@end
