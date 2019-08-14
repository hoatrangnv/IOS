//
//  GiaoDienDatVeXemPhim.h
//  ViViMASS
//
//  Created by nguyen tam on 9/17/15.
//
//

#import "GiaoDichViewController.h"
#import "TPKeyboardAvoidAcessory.h"

@interface GiaoDienDatVeXemPhim : GiaoDichViewController<UICollectionViewDataSource, UICollectionViewDelegate>
@property (retain, nonatomic) IBOutlet UIWebView *webPhongChieu;
@property (retain, nonatomic) IBOutlet ExTextField *edChonTinhThanh;
@property (retain, nonatomic) IBOutlet TPKeyboardAvoidAcessory *scrMain;
@property (retain, nonatomic) IBOutlet ExTextField *edChonRap;
@property (retain, nonatomic) IBOutlet ExTextField *edChonPhim;
@property (retain, nonatomic) IBOutlet UIView *viewInfo;
@property (retain, nonatomic) IBOutlet UICollectionView *collectionNgayChieu;
@property (retain, nonatomic) IBOutlet UICollectionView *collectionGioChieu;
@property (retain, nonatomic) IBOutlet UIView *viewThongTinThanhToan;
@property (retain, nonatomic) IBOutlet UIView *viewThongTinRapQuocGia;
@property (retain, nonatomic) IBOutlet UILabel *lblRap;
@property (retain, nonatomic) IBOutlet UILabel *lblPhim;
@property (retain, nonatomic) IBOutlet UILabel *lblPhongChieu;
@property (retain, nonatomic) IBOutlet UIButton *btnChonGhe;
@property (retain, nonatomic) IBOutlet UILabel *lblGioChieu;
@property (retain, nonatomic) IBOutlet UILabel *lblSoGhe;
@property (retain, nonatomic) IBOutlet UILabel *lblSoTien;
@property (retain, nonatomic) IBOutlet UILabel *lblPhi;
@property (retain, nonatomic) IBOutlet ExTextField *edTinhThanh;
@property (retain, nonatomic) IBOutlet UIWebView *webTrailer;
@property (nonatomic, retain) NSString *sTenThanhPhoCurrent;
@property (nonatomic, retain) NSString *sTenFilmTimKiem;
//rao quoc gia
@property (retain, nonatomic) IBOutlet ExTextField *edHo;
@property (retain, nonatomic) IBOutlet ExTextField *edTen;
@property (retain, nonatomic) IBOutlet ExTextField *edEmail;
@property (retain, nonatomic) IBOutlet ExTextField *edDienThoaiLienHe;
@property (retain, nonatomic) IBOutlet ExTextField *edTinhThanhQuocGia;
@property (retain, nonatomic) IBOutlet ExTextField *edPhuongXa;
@property (retain, nonatomic) IBOutlet ExTextField *edDiaChi;



- (IBAction)suKienChonThongTin:(id)sender;
- (IBAction)suKienChonTrailer:(id)sender;
- (IBAction)suKienBamChonGhe:(id)sender;
@end
