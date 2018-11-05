//
//  DucNT_SaoKeViewController.h
//  ViMASS
//
//  Created by MacBookPro on 7/10/14.
//
//

#import "GiaoDichViewController.h"
#import "DucNT_ServicePost.h"
#import "DucNT_SaoKeObject.h"
#import "DucNT_SaoKeCell.h"
#import "DucNT_SaoKe_ViewChiTiet.h"
#import "DucNT_ViewDatePicker.h"

enum{
    SAO_KE_VI = 0,
    SAO_KE_KHUYEN_MAI = 1,
    SAO_KE_NHAN_QUA = 2,
    SAO_KE_TANG_QUA = 3
};

@interface DucNT_SaoKeViewController : GiaoDichViewController <DucNT_ServicePostDelegate, UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UILabel *lbUserBalance;
@property (retain, nonatomic) IBOutlet UILabel *lbFromTime;
@property (retain, nonatomic) IBOutlet UILabel *lbToTime;
@property (retain, nonatomic) IBOutlet UIButton *btnSearch;
@property (retain, nonatomic) IBOutlet UIButton *mbtnVi;
@property (retain, nonatomic) IBOutlet UIButton *mbtnKhuyenMai;
@property (retain, nonatomic) IBOutlet UIButton *mbtnNhanQua;
@property (retain, nonatomic) IBOutlet UIButton *mbtnTangQua;
@property (retain, nonatomic) IBOutlet UITableView *lvHistory;
@property (retain, nonatomic) IBOutlet UITextField *edtToTime;
@property (retain, nonatomic) IBOutlet UITextField *edtFromTime;
@property (retain, nonatomic) IBOutlet UILabel *mlblSoTienKhuyenMai;

- (IBAction)suKienChonVi:(id)sender;
- (IBAction)suKienChonKhuyenMai:(id)sender;
- (IBAction)suKienChonNhanQua:(id)sender;
- (IBAction)suKienChonTangQua:(id)sender;
- (IBAction)suKienChonSearch:(id)sender;

@property (nonatomic, retain)DucNT_ViewDatePicker *viewDatePickerTuNgay;
@property (nonatomic, retain)DucNT_ViewDatePicker *viewDatePickerToiNgay;
@property (nonatomic, retain)DucNT_SaoKe_ViewChiTiet *viewThongTinChiTiet;

@property (nonatomic, assign)int nTrangThaiXem;
@end
