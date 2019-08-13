//
//  GiaoDienThanhToanInternet.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 10/16/15.
//
//

#import "GiaoDichViewController.h"
#import "DucNT_LoginSceen.h"

@interface GiaoDienThanhToanInternet : GiaoDichViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property (retain, nonatomic) IBOutlet UIView *viewMain;
@property (retain, nonatomic) IBOutlet UIButton *btnVNPT;
@property (retain, nonatomic) IBOutlet UIButton *btnFPT;
@property (retain, nonatomic) IBOutlet UIButton *btnViettel;
@property (retain, nonatomic) IBOutlet UIButton *btnCMC;
@property (retain, nonatomic) IBOutlet UITextField *mtfChonVNPT;
@property (retain, nonatomic) IBOutlet UITextField *mtfMaKH;
@property (retain, nonatomic) IBOutlet UIButton *btnTraCuu;
@property (nonatomic, assign) int nChucNang;

- (IBAction)suKienChonVNPT:(id)sender;
- (IBAction)suKienChonFPT:(id)sender;
- (IBAction)suKienChonViettel:(id)sender;
- (IBAction)suKienBamNutTraCuu:(id)sender;
- (IBAction)suKienBamNutCMC:(id)sender;
- (IBAction)suKienBamNutSoTay:(id)sender;

@end
