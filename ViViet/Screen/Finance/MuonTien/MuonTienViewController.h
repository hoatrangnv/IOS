//
//  MuonTienViewController.h
//  ViViMASS
//
//  Created by DucBT on 2/4/15.
//
//

#import "GiaoDichViewController.h"
#import "ExTextField.h"
#import "UmiTextView.h"
#import "TPKeyboardAvoidAcessory.h"

@interface MuonTienViewController : GiaoDichViewController

@property (retain, nonatomic) IBOutlet TPKeyboardAvoidAcessory *scrMain;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoTien;
@property (retain, nonatomic) IBOutlet ExTextField *mtfTenTKCanMuonTien;
@property (retain, nonatomic) IBOutlet UmiTextView *mtvNoiDung;
- (IBAction)suKienClickSoTayMuonTien:(id)sender;

@end
