//
//  GiaoDienChinhV2.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 10/30/15.
//
//

#import "GiaoDichViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "KRLCollectionViewGridLayout.h"

@interface GiaoDienChinhV2 : GiaoDichViewController<UICollectionViewDelegate, UICollectionViewDataSource>
@property (retain, nonatomic) IBOutlet UICollectionViewLayout *collectionViewLayout;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *slideShowHeigt;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *topSlideConstraint;
@property (retain, nonatomic) IBOutlet UIView *quangcaoView;
@property (retain, nonatomic) IBOutlet UIView *vVicuatoi;
@property (retain, nonatomic) IBOutlet UIView *vHuongDan;
@property (retain, nonatomic) IBOutlet UIView *vSoTay;
@property (retain, nonatomic) IBOutlet UIView *vUuDai;
@property (retain, nonatomic) IBOutlet UIView *vCenter;

@property (retain, nonatomic) IBOutlet UICollectionView *collectionMain;

@property (retain, nonatomic) IBOutlet UIButton *lblTheVID;
@property (retain, nonatomic) IBOutlet UIButton *lblSoTayGD;
@property (retain, nonatomic) IBOutlet UIButton *lblHuongDan;
@property (retain, nonatomic) IBOutlet UIButton *lblTinTuc;


- (IBAction)doBack:(id)sender;
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
- (IBAction)suKienChonTinTuc:(id)sender;


@end
