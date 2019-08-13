//
//  ViewDoiMatKhauTokenViewController.h
//  ViViMASS
//
//  Created by DucBT on 2/12/15.
//
//

#import "BaseScreen.h"
#import "ExTextField.h"


@interface ViewDoiMatKhauTokenViewController : BaseScreen

@property (retain, nonatomic) IBOutlet ExTextField *mtfSoDienThoai;
@property (retain, nonatomic) IBOutlet ExTextField *mtfMatKhauTokenCu;
@property (retain, nonatomic) IBOutlet ExTextField *mtfMatKhauTokenMoi;
@property (retain, nonatomic) IBOutlet ExTextField *mtfNhapLaiMatKhauToken;
@property (retain, nonatomic) IBOutlet UIButton *mbtnThucHien;
@property (retain, nonatomic) IBOutlet UIView *mViewMain;

@end
