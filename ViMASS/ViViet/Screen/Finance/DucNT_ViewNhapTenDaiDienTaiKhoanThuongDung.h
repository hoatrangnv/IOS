//
//  DucNT_ViewNhapTenDaiDienTaiKhoanThuongDung.h
//  ViMASS
//
//  Created by MacBookPro on 7/29/14.
//
//

#import <UIKit/UIKit.h>
#import "ExTextField.h"
#import "DucNT_TaiKhoanThuongDungObject.h"
#import "DucNT_ServicePost.h"

@interface DucNT_ViewNhapTenDaiDienTaiKhoanThuongDung : UIView<DucNT_ServicePostDelegate, UIAlertViewDelegate>

@property (retain, nonatomic) IBOutlet UIButton *btnCancel;
@property (retain, nonatomic) IBOutlet UIButton *btnOK;
@property (retain, nonatomic) IBOutlet ExTextField *edtTenHienThi;
@property (retain, nonatomic) IBOutlet ExTextField *edtMatKhauToken;
@property (retain, nonatomic) IBOutlet UILabel *lbTitle;
@property (retain, nonatomic) IBOutlet UIView *viewMain;

- (IBAction)suKienCancel:(id)sender;
- (IBAction)suKienOke:(id)sender;

-(id)initWithNib:(DucNT_TaiKhoanThuongDungObject *)doiTuong withType:(int)nLoaiVi;
@end
