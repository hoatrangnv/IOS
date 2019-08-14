//
//  GiaoDienChuyenTienATM.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 2/5/16.
//
//

#import "GiaoDichViewController.h"
#import "UmiTextView.h"
#import "TPKeyboardAvoidAcessory.h"

@interface GiaoDienChuyenTienATM : GiaoDichViewController

@property (retain, nonatomic) IBOutlet ExTextField *edViNhan;
@property (retain, nonatomic) IBOutlet ExTextField *edSoTien;
@property (retain, nonatomic) IBOutlet ExTextField *edNoiDung;
@property (retain, nonatomic) IBOutlet UmiTextView *tvNoiDung;
@property (retain, nonatomic) IBOutlet UIButton *btnSacomBank;
@property (retain, nonatomic) IBOutlet UIButton *btnTechcombank;
@property (retain, nonatomic) IBOutlet UIButton *btnVietinbank;
@property (retain, nonatomic) IBOutlet UILabel *lblPhi;
@property (retain, nonatomic) IBOutlet TPKeyboardAvoidAcessory *scrMain;
@property (nonatomic, assign) int nIndexBank;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *heightViewMain;

- (IBAction)hienThiSoTien:(id)sender;
- (IBAction)suKienChonDanhBa:(id)sender;
- (IBAction)suKienChonSoTay:(id)sender;
- (IBAction)suKienChonSacombank:(id)sender;
- (IBAction)suKienChonTechcombank:(id)sender;
- (IBAction)suKienChonVietinbank:(id)sender;

@end
