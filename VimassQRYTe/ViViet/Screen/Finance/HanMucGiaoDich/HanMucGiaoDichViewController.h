//
//  ViewController.h
//  ViViMASS
//
//  Created by DucBT on 2/7/15.
//
//

#import "GiaoDichViewController.h"
#import "ExTextField.h"
#import "TPKeyboardAvoidAcessory.h"

@interface HanMucGiaoDichViewController : GiaoDichViewController


@property (retain, nonatomic) IBOutlet UIView *mViewMain2;
@property (retain, nonatomic) IBOutlet TPKeyboardAvoidAcessory *mScrollview;
//@property (retain, nonatomic) IBOutlet UIView *mViewMain;
@property (retain, nonatomic) IBOutlet ExTextField *mtfHanMucGiaoDichMotLanVoiTKNganHang;
@property (retain, nonatomic) IBOutlet ExTextField *mtfHanMucGiaoDichMotNgayVoiTKNganHang;
@property (retain, nonatomic) IBOutlet ExTextField *mtfHanMucGiaoDichMotThangVoiTKNganHang;

@property (retain, nonatomic) IBOutlet ExTextField *mtfHanMucGiaoDichMotLanVoiTKThe;
@property (retain, nonatomic) IBOutlet ExTextField *mtfHanMucGiaoDichMotNgayVoiTKThe;
@property (retain, nonatomic) IBOutlet ExTextField *mtfHanMucGiaoDichMotThangVoiTKThe;

@property (retain, nonatomic) IBOutlet ExTextField *mtfHanMucGiaoDichMotLanVoiVi;
@property (retain, nonatomic) IBOutlet ExTextField *mtfHanMucGiaoDichMotNgayVoiVi;
@property (retain, nonatomic) IBOutlet ExTextField *mtfHanMucGiaoDichMotThangVoiVi;
@property (retain, nonatomic) IBOutlet ExTextField *edChuyenTienDenViKhac;

//@property (retain, nonatomic) IBOutlet ExTextField *mtfMatKhauToken;
//@property (retain, nonatomic) IBOutlet UIButton *mbtnToken;
//@property (retain, nonatomic) IBOutlet UIButton *mbtnSMS;
//@property (retain, nonatomic) IBOutlet UIButton *mbtnEmail;
//@property (retain, nonatomic) IBOutlet UIButton *mbtnThucHien;
@property (retain, nonatomic) IBOutlet UIButton *mbtnVanTay;

@end
