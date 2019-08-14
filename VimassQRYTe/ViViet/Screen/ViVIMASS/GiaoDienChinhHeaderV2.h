//
//  GiaoDienChinhHeaderV2.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 11/2/15.
//
//

#import <UIKit/UIKit.h>
#import "KASlideShow.h"
#import "DucNT_TaiKhoanViObject.h"

@protocol GiaoDienChinhHeaderV2Delegate <NSObject>
@required
- (void)xuLySuKienBamNutNapTien;
- (void)xuLySuKienBamNutChuyenTien;
- (void)xuLySuKienbamNutRutTien;
- (void)xuLySuKienBamNutMuonTien;
- (void)xuLySuKienDieuKhienGiongNoi;
- (void)xuLySuKienXemSaoKe:(UIButton*)sender;
- (void)suKienChonQuangCao:(NSString *)sNameImage;
@optional
- (void)suKienChonQRCode;
@end

@interface GiaoDienChinhHeaderV2 : UIView<KASlideShowDelegate>

@property (retain, nonatomic) DucNT_TaiKhoanViObject *mThongTinTaiKhoanVi;
@property (assign, nonatomic) id<GiaoDienChinhHeaderV2Delegate> mDelegate;
@property (retain, nonatomic) IBOutlet UIButton *btnNapTien;
@property (retain, nonatomic) IBOutlet UIButton *btnRutTien;
@property (retain, nonatomic) IBOutlet UIButton *btnMuonTien;
@property (retain, nonatomic) IBOutlet UILabel *lblTen;
@property (retain, nonatomic) IBOutlet UILabel *lblSoDu;
@property (retain, nonatomic) IBOutlet UILabel *lblKM;
@property (retain, nonatomic) IBOutlet UIView *slideShow;
@property (retain, nonatomic) IBOutlet UIButton *btnSaoKeChinh;
@property (retain, nonatomic) IBOutlet UILabel *lblSaoKeChinh;
@property (retain, nonatomic) IBOutlet UIButton *btnSaoKeKM;
@property (retain, nonatomic) IBOutlet UIButton *btnSaoKe;
@property (retain, nonatomic) NSArray *arrImageQC;
@property (retain, nonatomic) IBOutlet UIImageView *imgHeader;

- (void)capNhatSoDu:(double)fSoDu soDuKhuyenMai:(double)fSoDuKhuyenMai theQuaTang:(double)fTheQuaTang;
- (IBAction)suKienChonNapTien:(id)sender;
- (IBAction)suKienChonRutTien:(id)sender;
- (IBAction)suKienChonMuonTien:(id)sender;
- (IBAction)suKienChonQuangCao:(id)sender;
- (IBAction)suKienChonQRCode:(id)sender;


- (void)updateFontChu;
- (void)updateTrangThaiAnhSlide;
- (IBAction)suKienChonDieuKhienGiongNoi:(id)sender;
- (void)setAnhQuangCao:(NSArray *)arrQC;
- (void)tamDungQuangCao;
- (void)capNhatFrameSlide;
@end
