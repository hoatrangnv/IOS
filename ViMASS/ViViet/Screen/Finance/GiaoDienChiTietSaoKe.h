//
//  GiaoDienChiTietSaoKe.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 4/6/16.
//
//

#import "GiaoDichViewController.h"
#import "DucNT_SaoKeObject.h"
#import "UmiTextView.h"

@interface GiaoDienChiTietSaoKe : GiaoDichViewController

@property (nonatomic, retain) NSString *sXauGuiMail;

@property (retain, nonatomic) IBOutlet UIWebView *webChiTiet;
@property (retain, nonatomic) DucNT_SaoKeObject *saoKe;
@property (retain, nonatomic) IBOutlet UIButton *btnMail;
@property (retain, nonatomic) IBOutlet UIView *viewKhieuNai;
@property (retain, nonatomic) IBOutlet UIView *viewBtnMail;
@property (retain, nonatomic) IBOutlet UmiTextView *tvKhieuNai;
@property (retain, nonatomic) IBOutlet ExTextField *edEmail;
@property (retain, nonatomic) IBOutlet UIButton *btnGuiKhieuNai;

- (IBAction)suKienBamKhieuNai:(id)sender;
- (IBAction)suKienBamNutGuiMail:(id)sender;
- (IBAction)suKienBamNutGuiKhieuNai:(id)sender;
@end
