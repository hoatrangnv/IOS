//
//  HanMucMoiViewController.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 11/15/18.
//

#import "GiaoDichViewController.h"
#import "TPKeyboardAvoidAcessory.h"


@interface HanMucMoiViewController : GiaoDichViewController

@property (retain, nonatomic) IBOutlet TPKeyboardAvoidAcessory *scrMain;
@property (retain, nonatomic) IBOutlet UIView *viewUI;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *heightViewXacThuc;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *heightViewMaXacThuc;
@property (retain, nonatomic) IBOutlet UIButton *btnSMS;
@property (retain, nonatomic) IBOutlet UIButton *btnToken;
@property (retain, nonatomic) IBOutlet UIButton *btnMKPI;
@property (retain, nonatomic) IBOutlet UIView *viewMaXacThuc;
@property (retain, nonatomic) IBOutlet ExTextField *tfMaXacThuc;



- (IBAction)suKienChonSMS:(id)sender;
- (IBAction)suKienChonToken:(id)sender;
- (IBAction)suKienChonMKPI:(id)sender;
- (IBAction)suKienChonThucHien:(id)sender;


@end