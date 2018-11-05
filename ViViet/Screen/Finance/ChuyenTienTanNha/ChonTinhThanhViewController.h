//
//  ChonTinhThanhViewController.h
//  ViViMASS
//
//  Created by DucBui on 7/13/15.
//
//

#import "DoiTuongDiaDiem.h"


typedef enum : NSUInteger {
    KIEU_CHON_TINH_THANH = 300,
    KIEU_CHON_QUAN_HUYEN = 301,
    KIEU_CHON_PHUONG_XA = 302,
} KIEU_CHON_DIA_DIEM;

@protocol ChonTinhThanhViewControllerDelegate <NSObject>

//Tra ve doi tuong tinh thanh, quan huyen hoac phuong xa.
//Neu tra ve nil la chon bang tay
- (void)suKienChonDoiTuongDiaDiem:(DoiTuongDiaDiem*)doiTuongDiaDiem kieuChon:(NSInteger)nKieuChon;

@end

@interface ChonTinhThanhViewController : UIViewController

@property (nonatomic, retain) NSArray *mDanhSachDiaDiem;
@property (nonatomic, retain) NSString *mTitle;
@property (nonatomic, assign) NSInteger mKieuChon;

@property (retain, nonatomic) IBOutlet UITableView *mtbHienThiDiaDiem;
@property (retain, nonatomic) IBOutlet UILabel *mlblTitle;
@property (assign, nonatomic) id<ChonTinhThanhViewControllerDelegate> mDelegate;

@end
