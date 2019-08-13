//
//  GiaoDienThanhToanNuoc.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 2/3/16.
//
//

#import "GiaoDichViewController.h"

@interface GiaoDienThanhToanNuoc : GiaoDichViewController
@property (retain, nonatomic) IBOutlet ExTextField *edChonNhaMay;
@property (retain, nonatomic) IBOutlet ExTextField *edMaKH;
@property (retain, nonatomic) IBOutlet UIWebView *webInfo;
@property (retain, nonatomic) IBOutlet UIButton *btnTraCuu;

@property (nonatomic, retain) NSString *mIdShow;
- (IBAction)suKienBamNutTraCuu:(id)sender;
- (IBAction)suKienBamSoTayNuoc:(id)sender;
@end
