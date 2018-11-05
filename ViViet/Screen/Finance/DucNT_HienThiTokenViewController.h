//
//  DucNT_HienThiTokenViewController.h
//  ViMASS
//
//  Created by MacBookPro on 7/9/14.
//
//

#import "GiaoDichViewController.h"
#import "DucNT_ViewHienThiToken.h"
#import "DucNT_ViewQuenMatKhauToken.h"
#import "DucNT_ViewDoiMatKhauToken.h"
enum
{
    VIEW_HIEN_TOKEN = 0,
    VIEW_QUEN_MAT_KHAU_TOKEN = 1,
    VIEW_DOI_MAT_KHAU_TOKEN = 2
};
@interface DucNT_HienThiTokenViewController : GiaoDichViewController

@property(nonatomic, retain) DucNT_ViewHienThiToken *viewHienThiToken;
@property(nonatomic, retain) DucNT_ViewQuenMatKhauToken *viewQuenMatKhauToken;
@property(nonatomic, retain) DucNT_ViewDoiMatKhauToken *viewDoiMatKhauToken;
@property(nonatomic, retain) UIButton *btnSetting;
@property(nonatomic, retain) UIView *viewSetting;
@property(nonatomic, assign) int nViewDangHienThi;

@property(nonatomic, retain) UIButton *btnViewHienThi;
@property(nonatomic, retain) UIButton *btnViewQuenMatKhau;
@property(nonatomic, retain) UIButton *btnViewDoiMatKhau;
@property(nonatomic, retain) UIView *viewSeperator;

@end
