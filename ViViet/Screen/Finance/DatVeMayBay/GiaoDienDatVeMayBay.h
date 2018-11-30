//
//  GiaoDienDatVeMayBay.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 1/4/16.
//
//

#import "GiaoDichViewController.h"
#import "TPKeyboardAvoidAcessory.h"

@interface GiaoDienDatVeMayBay : GiaoDichViewController
@property (nonatomic, assign) int timeGiaCao;
@property (nonatomic, retain) NSString *sIdVeMayBayGiaCao;
@property (nonatomic, retain) NSString *sIdVeMayBayGiaCaoResult;
@property (nonatomic, retain) NSString *sThongBaoTangGia;
@property (retain, nonatomic) IBOutlet TPKeyboardAvoidAcessory *scrMain;
@property (retain, nonatomic) IBOutlet UIView *viewCalendar;
@property (retain, nonatomic) IBOutlet ExTextField *edNgayDi;
@property (retain, nonatomic) IBOutlet ExTextField *edNgayVe;
@property (retain, nonatomic) IBOutlet ExTextField *edSanBayDi;
@property (retain, nonatomic) IBOutlet ExTextField *edSanBayVe;
@property (retain, nonatomic) IBOutlet ExTextField *edNguoiLon;
@property (retain, nonatomic) IBOutlet ExTextField *edTreEm;
@property (retain, nonatomic) IBOutlet ExTextField *edEmBe;
@property (retain, nonatomic) IBOutlet UIButton *btnCloseCalendarView;
@property (retain, nonatomic) IBOutlet UIView *viewToken;
@property (retain, nonatomic) IBOutlet UIButton *btnChonVeMayBay;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *heightMain;

//view chuyen di
@property (retain, nonatomic) IBOutlet UILabel *lblChuyenDi;
@property (retain, nonatomic) IBOutlet UIView *viewChuyenDi;
@property (retain, nonatomic) IBOutlet UITableView *tableNguoiDi;
@property (retain, nonatomic) IBOutlet UIView *viewThongTinDi;
@property (retain, nonatomic) IBOutlet UILabel *lblNguoiLon;
@property (retain, nonatomic) IBOutlet UILabel *lblTreEm;
@property (retain, nonatomic) IBOutlet UILabel *lblEmBe;
@property (retain, nonatomic) IBOutlet UILabel *lblPhiSanBay;
@property (retain, nonatomic) IBOutlet UILabel *lblThuePhi;
@property (retain, nonatomic) IBOutlet UILabel *lblHanhLy;
@property (retain, nonatomic) IBOutlet UILabel *lblPhiThanhToan;
@property (retain, nonatomic) IBOutlet UILabel *lblTongLuotDi;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *heightTableDi;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *heightViewDi;

//view chuyen ve
@property (retain, nonatomic) IBOutlet UIView *viewChuyenVe;
@property (retain, nonatomic) IBOutlet UILabel *lblChuyenVe;
@property (retain, nonatomic) IBOutlet UITableView *tableChuyenVe;
@property (retain, nonatomic) IBOutlet UIView *viewThongTinVe;
@property (retain, nonatomic) IBOutlet UILabel *lblNguoiLonVe;
@property (retain, nonatomic) IBOutlet UILabel *lblTreEmVe;
@property (retain, nonatomic) IBOutlet UILabel *lblEmBeVe;
@property (retain, nonatomic) IBOutlet UILabel *lblPhiSanBayVe;
@property (retain, nonatomic) IBOutlet UILabel *lblThuePhiVe;
@property (retain, nonatomic) IBOutlet UILabel *lblHanhLyVe;
@property (retain, nonatomic) IBOutlet UILabel *lblPhiThanhToanVe;
@property (retain, nonatomic) IBOutlet UILabel *lblTongLuotVe;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *heightViewVe;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *heightTableVe;

//view thong tin nhan ve
@property (retain, nonatomic) IBOutlet UIView *viewNhanVe;
@property (retain, nonatomic) IBOutlet ExTextField *edSDT;
@property (retain, nonatomic) IBOutlet ExTextField *edEmail;
@property (retain, nonatomic) IBOutlet UILabel *lblSoTienThanhToan;
//view thanh toan gia cao
@property (retain, nonatomic) IBOutlet UIView *viewThanhToanGiaCao;
@property (retain, nonatomic) IBOutlet ExTextField *edToken;
- (IBAction)suKienXacThucMuaVeGiaCao:(id)sender;
//view nhan hoa don
@property (retain, nonatomic) IBOutlet UIView *viewNhanHoaDon;
@property (retain, nonatomic) IBOutlet ExTextField *edTenCty;
@property (retain, nonatomic) IBOutlet ExTextField *edDiaChiCty;
@property (retain, nonatomic) IBOutlet ExTextField *edMaSoThue;
@property (retain, nonatomic) IBOutlet ExTextField *edDiaChiNhanHoaDon;
@property (retain, nonatomic) IBOutlet UILabel *lblPhiVimass;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *heightInfoNhanVe;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *heightNhanHoaDon;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *heightViewToken;


- (IBAction)suKienChonNgayDi:(id)sender;
- (IBAction)suKienChonNgayVe:(id)sender;
- (IBAction)suKienBamNutCloseCalendar:(id)sender;
- (IBAction)suKienChonTraCuu:(id)sender;
- (IBAction)suKienChonSoTayHoaDon:(id)sender;

@end
