//
//  DanhSachNguoiDangChatTaiChinhViewController.h
//  ViViMASS
//
//  Created by DucBui on 7/21/15.
//
//

#import "GiaoDichViewController.h"
#import "ExTextField.h"

@interface DanhSachNguoiDangChatTaiChinhViewController : GiaoDichViewController
@property (retain, nonatomic) IBOutlet UILabel *mlblXinChao;
@property (retain, nonatomic) IBOutlet ExTextField *mtfChonVi;
@property (retain, nonatomic) IBOutlet UIButton *mbtnChonVi;
@property (retain, nonatomic) IBOutlet UITableView *mtbHienThiDanhSach;
@property (retain, nonatomic) IBOutlet UIView *mViewThongBaoChuaCoGiaoDich;
@property (retain, nonatomic) IBOutlet UILabel *mlblThongBaoChuaCoGiaoDich;

@end
