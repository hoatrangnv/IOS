//
//  ChiTietTangQuaTheDienThoaiViewController.h
//  ViViMASS
//
//  Created by DucBT on 4/6/15.
//
//

#import "TPKeyboardAvoidAcessory.h"
#import "GiaoDichViewController.h"
#import "ItemQuaTang.h"
#import "UmiTextView.h"

@interface ChiTietTangQuaTheDienThoaiViewController : GiaoDichViewController

@property (retain, nonatomic) IBOutlet ExTextField *mtfTieuDe;
@property (retain, nonatomic) IBOutlet ExTextField *mtfTaiKhoanNhanQua;
@property (retain, nonatomic) IBOutlet ExTextField *mtfMaThe;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoSeriThe;
@property (retain, nonatomic) IBOutlet UmiTextView *mtvNoiDung;
@property (retain, nonatomic) IBOutlet ExTextField *mtfNoiDung;
@property (retain, nonatomic) IBOutlet ExTextField *mtfThoiGianTangQua;
@property (retain, nonatomic) IBOutlet TPKeyboardAvoidAcessory *mscrvHienThi;

@property (retain, nonatomic) IBOutlet UIImageView *mimgvHienThi;
@property (retain, nonatomic) IBOutlet UILabel *mlblTieuDe;
@property (retain, nonatomic) IBOutlet UILabel *mlblMaThe;
@property (retain, nonatomic) IBOutlet UILabel *mlblSoSeriThe;
@property (retain, nonatomic) IBOutlet UILabel *mlblNoiDungQuaTang;



@property (nonatomic, retain) ItemQuaTang *mItemQuaTang;
@property (nonatomic, retain) NSString *mMaSoThe;
@property (nonatomic, retain) NSString *mSoSeriThe;

@end
