//
//  DucNT_TaiKhoanThuongDungCell.h
//  ViMASS
//
//  Created by MacBookPro on 7/25/14.
//
//

#import <UIKit/UIKit.h>

@protocol TaiKhoanThuongDungCellDelegate <NSObject>
@optional
-(void)deleteCell:(id)sender;
-(void)editCell:(id)sender;
@end

@interface DucNT_TaiKhoanThuongDungCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *lbTenTaoKhoan;
@property (retain, nonatomic) IBOutlet UIImageView *imvLoaiTaiKhoan;
@property (retain, nonatomic) IBOutlet UIButton *btnDelete;
@property (retain, nonatomic) IBOutlet UIButton *btnEdit;
@property (retain, nonatomic) IBOutlet UIButton *btnCheckThongBao;

- (IBAction)suKienEditTKTD:(id)sender;
- (IBAction)suKienDeleteTKTD:(id)sender;

@property (retain, nonatomic) id <TaiKhoanThuongDungCellDelegate> delegate;

@end
