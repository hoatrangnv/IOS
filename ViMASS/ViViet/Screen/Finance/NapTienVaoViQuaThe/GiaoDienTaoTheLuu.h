//
//  GiaoDienTaoTheLuu.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 11/18/15.
//
//

#import "GiaoDichViewController.h"
#import "TPKeyboardAvoidAcessory.h"
#import "UmiTextView.h"
#import "DucNT_TaiKhoanThuongDungObject.h"
#import "GiaoDienBangMaZipCode.h"
#import "RadioButton.h"

@interface GiaoDienTaoTheLuu : GiaoDichViewController

@property (retain, nonatomic) DucNT_TaiKhoanThuongDungObject *objTheLuu;

//@property (retain, nonatomic) IBOutlet UmiTextView *tvDiaChi;
@property (nonatomic, assign) int nTrangThai;
@property (retain, nonatomic) IBOutlet ExTextField *edChonLoaiThe2;
@property (retain, nonatomic) IBOutlet TPKeyboardAvoidAcessory *scrMain;
@property (retain, nonatomic) IBOutlet UIView *viewTheVisa;
@property (retain, nonatomic) IBOutlet UIView *viewXacNhan;
@property (retain, nonatomic) IBOutlet ExTextField *edSoThe;
@property (retain, nonatomic) IBOutlet ExTextField *edCVV;
@property (retain, nonatomic) IBOutlet ExTextField *edThangHetHan;
@property (retain, nonatomic) IBOutlet ExTextField *edNamHetHan;
@property (retain, nonatomic) IBOutlet ExTextField *edHo;
//@property (retain, nonatomic) IBOutlet ExTextField *edTen;
//@property (retain, nonatomic) IBOutlet ExTextField *edDiaCho;
//@property (retain, nonatomic) IBOutlet ExTextField *edThanhPho;
//@property (retain, nonatomic) IBOutlet ExTextField *edCountry;
//@property (retain, nonatomic) IBOutlet ExTextField *edZipcode;
//@property (retain, nonatomic) IBOutlet ExTextField *edSDT;
//@property (retain, nonatomic) IBOutlet ExTextField *edEmail;

//view the noi dia
@property (retain, nonatomic) IBOutlet UIView *viewNoiDia;
@property (retain, nonatomic) IBOutlet ExTextField *edBank;
@property (retain, nonatomic) IBOutlet ExTextField *edSoTheNoiDia;
@property (retain, nonatomic) IBOutlet ExTextField *edTenChuThe;
@property (retain, nonatomic) IBOutlet ExTextField *edThangMo;
@property (retain, nonatomic) IBOutlet ExTextField *edNamMo;
@property (retain, nonatomic) IBOutlet RadioButton *rbSMS;
@property (retain, nonatomic) IBOutlet RadioButton *rbToken;
@property (retain, nonatomic) IBOutlet ExTextField *edNameAlias;
@property (retain, nonatomic) IBOutlet ExTextField *edNameAliasQT;


- (IBAction)suKienXemZipCode:(id)sender;
@end
