//
//  TaoQRDonViViewController.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 12/1/17.
//

#import <UIKit/UIKit.h>
#import "ExTextField.h"
#import "GiaoDichViewController.h"
#import "TPKeyboardAvoidAcessory.h"
#import "UmiTextView.h"
@interface TaoQRDonViViewController : GiaoDichViewController

@property (nonatomic, assign) int nType;
@property (nonatomic, retain) NSString *sMaQRDonVi;
@property (retain, nonatomic) IBOutlet ExTextField *edTenDaiLy;
@property (retain, nonatomic) IBOutlet ExTextField *edCMND;
@property (retain, nonatomic) IBOutlet ExTextField *edEmail;
@property (retain, nonatomic) IBOutlet ExTextField *edSoDienThoai;
@property (retain, nonatomic) IBOutlet UIImageView *imgvAvatar;
@property (retain, nonatomic) IBOutlet ExTextField *edDiaChi;
@property (retain, nonatomic) IBOutlet TPKeyboardAvoidAcessory *scrMain;
@property (retain, nonatomic) IBOutlet ExTextField *tfNoiDung;
@property (retain, nonatomic) IBOutlet UmiTextView *umiNoiDung;
@property (retain, nonatomic) IBOutlet ExTextField *txtVilientket;
//HOANHNV UPDATE
@property (retain, nonatomic) IBOutlet ExTextField *edtVilienket1;
@property (retain, nonatomic) IBOutlet ExTextField *edtVilienket2;
@property (retain, nonatomic) IBOutlet ExTextField *edtVilienket3;
@property (retain, nonatomic) IBOutlet ExTextField *edtVilienket4;
@property (retain, nonatomic) IBOutlet ExTextField *edtVilienket5;

@property (retain, nonatomic) IBOutlet NSLayoutConstraint *heightMainContraint;



//@property (nonatomic, retain) NSString *sOTP;
- (IBAction)suKienChonChupAnh:(id)sender;
- (IBAction)suKienChonLayAnh:(id)sender;
- (IBAction)suKienChonTaoQRDonVi:(id)sender;
@end
