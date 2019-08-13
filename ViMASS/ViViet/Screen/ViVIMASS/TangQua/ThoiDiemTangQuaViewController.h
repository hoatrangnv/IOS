//
//  ThoiDiemTangQuaViewController.h
//  ViViMASS
//
//  Created by DucBT on 3/27/15.
//
//

#import "GiaoDichViewController.h"
#import "ExTextField.h"

@protocol ThoiDiemTangQuaViewControllerDelegate <NSObject>

//Chon tang ngay se tra ve date = nil.
- (void)suKienChonThoiDiemTangQua:(NSDate*)date;

@end

@interface ThoiDiemTangQuaViewController : GiaoDichViewController
@property (retain, nonatomic) IBOutlet UIView *mViewChuaCalendar;
@property (retain, nonatomic) IBOutlet UIButton *mbtnChonThoiGian;
@property (retain, nonatomic) IBOutlet UIButton *mbtnTangNay;
@property (retain, nonatomic) IBOutlet ExTextField *mtfThoiGianTangQua;

@property (assign, nonatomic) id<ThoiDiemTangQuaViewControllerDelegate> mDelegate;

- (IBAction)suKienBamNutThucHien:(id)sender;
- (IBAction)suKienBamNutTangNgay:(id)sender;
@end
