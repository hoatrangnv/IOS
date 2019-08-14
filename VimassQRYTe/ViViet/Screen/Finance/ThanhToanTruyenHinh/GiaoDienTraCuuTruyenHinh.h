//
//  GiaoDienTraCuuTruyenHinh.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 2/26/16.
//
//

#import "GiaoDichViewController.h"
#import "DoiTuongNotification.h"
#import "MoTaChiTietKhachHang.h"
#import "DucNT_LoginSceen.h"

@interface GiaoDienTraCuuTruyenHinh : GiaoDichViewController
@property (retain, nonatomic) IBOutlet ExTextField *edOptionTruyenHinh;
@property (retain, nonatomic) IBOutlet ExTextField *edMaThueBao;
@property (retain, nonatomic) IBOutlet UIWebView *webInfo;
@property (retain, nonatomic) IBOutlet UIButton *btnTraCuu;
@property (nonatomic, retain) NSString *mIdShow;
@property (nonatomic, retain) MoTaChiTietKhachHang *mMoTaChiTietKhachHang;
@property (nonatomic, retain) DoiTuongNotification *mDoiTuongNotification;
@property (retain, nonatomic) IBOutlet UIView *viewThanhToanKPlus;

- (IBAction)suKienBamNutTraCuu:(id)sender;
- (IBAction)suKienBamNutSoTay:(id)sender;
- (IBAction)suKienBamNutTraCuuKPlus:(id)sender;
- (IBAction)suKienBamNutThanhToanKPlus:(id)sender;

@end
