//
//  GiaoDienTraCuuTienVay.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 3/31/16.
//
//

#import "GiaoDichViewController.h"
#import "TPKeyboardAvoidAcessory.h"
#import "DucNT_LoginSceen.h"

@interface GiaoDienTraCuuTienVay : GiaoDichViewController
@property (retain, nonatomic) IBOutlet ExTextField *edQuyTraTien;
@property (retain, nonatomic) IBOutlet ExTextField *edMaHopDong;
@property (retain, nonatomic) IBOutlet ExTextField *edCMNDFE;
@property (retain, nonatomic) IBOutlet UIButton *btnTraCuu;
@property (retain, nonatomic) IBOutlet UIView *viewThanhToan;
@property (retain, nonatomic) IBOutlet ExTextField *edHoTen;
@property (retain, nonatomic) IBOutlet ExTextField *edSoTien;
@property (retain, nonatomic) IBOutlet TPKeyboardAvoidAcessory *scrMain;

@property (nonatomic, retain) NSString *sIdShow;

- (IBAction)suKienBamNutTraCuu:(id)sender;
- (IBAction)suKienBamNutSoTay:(id)sender;

@end
