//
//  ViewDoiTenGiaoDich.h
//  ViMASS
//
//  Created by DucBT on 10/21/14.
//
//

#import "DucNT_ServicePost.h"
#import "ExTextField.h"
@protocol ViewDoiTenGiaoDichDelegate <NSObject>

- (void)suKienThayDoiThanhCongTenGiaoDich;

@end

@interface ViewDoiTenGiaoDich : UIView <UITextFieldDelegate, DucNT_ServicePostDelegate>

@property (nonatomic, assign) id<ViewDoiTenGiaoDichDelegate> mDelegate;
@property (retain, nonatomic) IBOutlet UIView *mViewChua;
@property (retain, nonatomic) IBOutlet UILabel *mblTieuDe;
@property (retain, nonatomic) IBOutlet ExTextField *mtfTenGiaoDich;
@property (retain, nonatomic) IBOutlet ExTextField *mtfMatKhau;
@property (retain, nonatomic) IBOutlet UIButton *mbtnThayDoi;

@end
