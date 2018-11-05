//
//  ChuyenTienDenViMomoViewController.h
//  ViViMASS
//
//  Created by DucBui on 6/23/15.
//
//

#import "DucNT_TaiKhoanThuongDungObject.h"
#import "GiaoDichViewController.h"
#import "UmiTextView.h"
#import "TPKeyboardAvoidAcessory.h"

@interface ChuyenTienDenViMomoViewController : GiaoDichViewController

@property (nonatomic, assign) int nType;
@property (retain, nonatomic) IBOutlet TPKeyboardAvoidAcessory *scrMain;
@property (retain, nonatomic) IBOutlet ExTextField *mtfViMomo;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoTien;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoPhi;
@property (retain, nonatomic) IBOutlet ExTextField *tfNoiDung;
@property (retain, nonatomic) IBOutlet UmiTextView *mtvNoiDung;
@property (retain, nonatomic) IBOutlet ExTextField *edChonVi;
@property (retain, nonatomic) IBOutlet UIView *viewXacThuc;
@property (retain, nonatomic) IBOutlet UIView *viewThucHien;
@property (retain, nonatomic) IBOutlet UIView *viewSoTien;

@property (retain, nonatomic) DucNT_TaiKhoanThuongDungObject *mTaiKhoanThuongDung;

@end
