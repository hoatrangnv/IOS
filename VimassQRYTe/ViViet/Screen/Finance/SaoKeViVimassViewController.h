//
//  SaoKeViVimassViewController.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 8/21/19.
//

#import "GiaoDichViewController.h"
#import "DucNT_ServicePost.h"
#import "DucNT_SaoKeObject.h"
#import "DucNT_SaoKeCell.h"
#import "DucNT_SaoKe_ViewChiTiet.h"
#import "DucNT_ViewDatePicker.h"
NS_ASSUME_NONNULL_BEGIN

@interface SaoKeViVimassViewController : GiaoDichViewController <DucNT_ServicePostDelegate, UITableViewDataSource, UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UILabel *lblTitleSoDu;
@property (retain, nonatomic) IBOutlet UILabel *lblUserBalance;
@property (retain, nonatomic) IBOutlet UILabel *lblTitleKhuyenMai;
@property (retain, nonatomic) IBOutlet UILabel *mlblSoTienKhuyenMai;
@property (retain, nonatomic) IBOutlet UITextField *edtFromTime;
@property (retain, nonatomic) IBOutlet UILabel *lblToTime;
@property (retain, nonatomic) IBOutlet UITextField *edtToTime;
@property (retain, nonatomic) IBOutlet UIButton *btnSearch;
@property (retain, nonatomic) IBOutlet UITableView *lvHistory;


- (IBAction)suKienChonSearch:(id)sender;

@property (nonatomic, retain)DucNT_ViewDatePicker *viewDatePickerTuNgay;
@property (nonatomic, retain)DucNT_ViewDatePicker *viewDatePickerToiNgay;
@property (nonatomic, retain)DucNT_SaoKe_ViewChiTiet *viewThongTinChiTiet;

@property (nonatomic, assign)int nTrangThaiXem;
@end

NS_ASSUME_NONNULL_END
