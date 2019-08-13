//
//  TraCuuSoTietKiemView.h
//  ViViMASS
//
//  Created by DucBui on 5/19/15.
//
//

#import <UIKit/UIKit.h>
#import "DucNT_ServicePost.h"
#import "ExTextField.h"

@class SoTietKiem;
@protocol TraCuuSoTietKiemViewDelegate <NSObject>

- (void)suKienChonSoTietKiem:(SoTietKiem*)soTietKiem;

@end

@interface TraCuuSoTietKiemView : UIView <UITableViewDataSource, UITableViewDelegate, DucNT_ServicePostDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *mtbHienThi;
@property (retain, nonatomic) NSArray *mDanhSachSoTietKiem;
@property (retain, nonatomic) NSMutableArray *mDanhSachHienThi;
@property (retain, nonatomic) NSString *secssion;
@property (retain, nonatomic) NSString *mDinhDanhKetNoi;
@property (assign, nonatomic) id<TraCuuSoTietKiemViewDelegate> mDelegate;
@property (retain, nonatomic) IBOutlet ExTextField *mtfTuNGay;
@property (retain, nonatomic) IBOutlet ExTextField *mtfDenNgay;
@property (retain, nonatomic) IBOutlet UIButton *mbtnTraCuu;
@property (retain, nonatomic) IBOutlet ExTextField *edOption;


- (void)layDanhSachSoTietKiem;

@end
