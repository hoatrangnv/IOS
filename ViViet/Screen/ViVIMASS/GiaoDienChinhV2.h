//
//  GiaoDienChinhV2.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 10/30/15.
//
//

#import "GiaoDichViewController.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface GiaoDienChinhV2 : GiaoDichViewController<UICollectionViewDelegate, UICollectionViewDataSource>

@property (retain, nonatomic) IBOutlet UICollectionView *collectionMain;
@property (retain, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrMain;
@property (retain, nonatomic) IBOutlet UIView *viewMain1;
@property (retain, nonatomic) IBOutlet UIView *viewMain2;
@property (retain, nonatomic) IBOutlet UIView *viewMain;


- (void)xuLySuKienDangNhapThanhCong:(NSNotification *)notification;
- (IBAction)suKienBamChuyenTienDenViNoiBo:(id)sender;
- (IBAction)suKienBamNutChuyenTienDenTaiKhoan:(id)sender;
- (IBAction)suKienBamNutChuyenTienDenThe:(id)sender;
- (IBAction)suKienBamNutChuyenTienTanNha:(id)sender;
- (IBAction)suKienBamNutChuyenTienDenViKhac:(id)sender;
- (IBAction)suKienBamNutChuyenTienTietKiem:(id)sender;
- (IBAction)suKienBamNutChuyenTienTuThien:(id)sender;
- (IBAction)suKienBamNutThanhToanDienThoai:(id)sender;
- (IBAction)suKienBamNutVePhim:(id)sender;
- (IBAction)suKienBamNutVeMayBay:(id)sender;
- (IBAction)suKienBamNutVeTau:(id)sender;
- (IBAction)suKienBamNutDien:(id)sender;
- (IBAction)suKienBamNutNuoc:(id)sender;
- (IBAction)suKienBamNutInternet:(id)sender;
- (IBAction)suKienBamNutTruyenHinh:(id)sender;
- (IBAction)suKienBamNutBaoHiem:(id)sender;
- (IBAction)suKienBamNutChungKhoan:(id)sender;
- (IBAction)suKienBamNutTraTienVay:(id)sender;
- (IBAction)suKienBamNutHocPhi:(id)sender;
- (IBAction)suKienBamNutTangQua:(id)sender;
- (IBAction)suKienBamNutPhoneToKen:(id)sender;
- (IBAction)suKienBamNutCachNapVi:(id)sender;
- (IBAction)suKienBamNutChuyenTienATM:(id)sender;
- (IBAction)suKienBamChuyenTienDenCMND:(id)sender;
- (IBAction)suKienBamNutXeKhach:(id)sender;
- (IBAction)suKienBamNutMuaSam:(id)sender;
- (IBAction)suKienKetThucSpeak:(id)sender;
- (IBAction)suKienChonPhoneTokenLan2:(id)sender;
- (IBAction)suKienChonLixi:(id)sender;
- (IBAction)suKienChonXemGiayPhep:(id)sender;

@end
