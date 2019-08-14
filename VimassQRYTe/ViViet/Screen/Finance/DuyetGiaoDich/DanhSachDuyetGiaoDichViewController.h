//
//  DanhSachDuyetGiaoDichViewController.h
//  ViViMASS
//
//  Created by DucBui on 6/9/15.
//
//

#import "GiaoDichViewController.h"
#import "ExTextField.h"

@interface DanhSachDuyetGiaoDichViewController : GiaoDichViewController

@property (retain, nonatomic) IBOutlet ExTextField *mtfNgayBatDau;
@property (retain, nonatomic) IBOutlet ExTextField *mtfNgayKetThuc;
@property (retain, nonatomic) IBOutlet ExTextField *mtfLuaChonDanhSachGiaoDich;
@property (retain, nonatomic) IBOutlet UITableView *mtbDanhSachGiaoDich;
@end
