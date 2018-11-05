//
//  GiaoDienDanhSachTaiKhoanLienKet.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 10/11/16.
//
//

#import "GiaoDichViewController.h"
#import "ItemTaiKhoanLienKet.h"
@protocol GiaoDienDanhSachTaiKhoanLienKetDelegate <NSObject>
- (void)suKienChinhSuaTaiKhoanLienKet:(ItemTaiKhoanLienKet *)taiKhoan;
@end
@interface GiaoDienDanhSachTaiKhoanLienKet : GiaoDichViewController<UITableViewDelegate, UITableViewDataSource>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) id<GiaoDienDanhSachTaiKhoanLienKetDelegate> delegate;
@property (nonatomic, assign) BOOL bChinhSua;
@property (nonatomic, assign) int nType;
- (IBAction)suKienChonNutBack:(id)sender;
@end
