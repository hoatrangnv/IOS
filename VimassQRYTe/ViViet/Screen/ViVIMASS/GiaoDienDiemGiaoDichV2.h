//
//  GiaoDienDiemGiaoDichV2.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 11/5/15.
//
//

#import "BaseScreen.h"
#import "DucNT_ServicePost.h"
#import <CoreLocation/CoreLocation.h>
#import "GiaoDichViewController.h"
@interface GiaoDienDiemGiaoDichV2 : GiaoDichViewController<CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) int nIndexLuaChon;
@property (nonatomic, retain) NSString *mDinhDanhKetNoi;
@property (nonatomic, retain) NSString *sKeyWord;
@property (nonatomic, retain) NSMutableArray *arrInfoDiaDiem;
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (retain, nonatomic) IBOutlet UIView *viewThongTin;
@property (retain, nonatomic) IBOutlet UITextView *tvName;
@property (retain, nonatomic) IBOutlet UIButton *btnCloseInfo;
@property (retain, nonatomic) IBOutlet UIView *viewTimKiem;
@property (retain, nonatomic) IBOutlet UIView *viewNganHang;
@property (retain, nonatomic) IBOutlet UIView *viewBuuDien;
@property (retain, nonatomic) IBOutlet UIView *viewATM;
@property (retain, nonatomic) IBOutlet UIImageView *imgCheckBank;
@property (retain, nonatomic) IBOutlet UIImageView *imgCheckATM;
@property (retain, nonatomic) IBOutlet UIImageView *imgCheckPost;
@property (retain, nonatomic) IBOutlet UILabel *tvDiaDiem;
@property (retain, nonatomic) IBOutlet UITextField *edRadius;
@property (retain, nonatomic) IBOutlet UITableView *tableDanhSachTinhThanh;
@property (retain, nonatomic) IBOutlet UITableView *tableSubTinhThanh;
@property (retain, nonatomic) IBOutlet UITableView *tableDiaDiem;

- (IBAction)suKienBamNutDongThongTin:(id)sender;
- (IBAction)suKienBamNutTimKiem:(id)sender;

@end
