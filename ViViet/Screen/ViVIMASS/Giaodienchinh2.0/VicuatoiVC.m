//
//  VicuatoiVC.m
//  ViViMASS
//
//  Created by Mac Mini on 10/11/18.
//

#import "VicuatoiVC.h"
#import "ItemListCell.h"
@interface VicuatoiVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation VicuatoiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ItemListCell" bundle:nil] forCellReuseIdentifier:@"ItemListCell"];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.arrDanhSach =@[@{@"name":@"Sao kê",@"image":@"ic_vicuatoi_saoke"},
                        @{@"name":@"Liên kết ví với tk,thẻ", @"image":@"ic_vicuatoi_lienket"},
                        @{@"name":@"Chọn ví,thẻ,tk ẩn sau điện thoại", @"image":@"icon_vicuatoi_vi_an"},
                        @{@"name":@"Chuyển tiền đến điện thoại", @"image":@"ic_chuyentien_dienthoai"},
                        @{@"name":@"Nạp tiền từ TK liên kết", @"image":@"icon_grid_cachnapvi"},
                        @{@"name":@"Rút tiền về TK liên kết", @"image":@"ic_vicuatoi_ruttien"},
                        @{@"name":@"Mượn tiền", @"image":@"icon_chuyen_tien_tan_nha_64x64"},
                        @{@"name":@"Tặng quà", @"image":@"icon_grid_tangqua"},
                        @{@"name":@"Thay đổi thông tin", @"image":@"icon_edit_the_luu"},
                        @{@"name":@"Soft Token", @"image":@"ic_vicuatoi_soft_token"},
                        @{@"name":@"Hạn mức giao dịch", @"image":@"ic_vicuatoi_hanmuc"}
                        ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrDanhSach.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.height / 11.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemListCell *cell = (ItemListCell *)[tableView dequeueReusableCellWithIdentifier:@"ItemListCell" forIndexPath:indexPath];
    NSDictionary *dict = [self.arrDanhSach objectAtIndex:indexPath.row];
    NSString *name = (NSString *)[dict valueForKey:@"name"];
    NSString *image = (NSString *)[dict valueForKey:@"image"];
    [cell.imgTitle setImage:[UIImage imageNamed:image]];
    cell.lblName.text = name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s - indexPath : %d", __FUNCTION__, (int)indexPath.row);
    [self.delegate didSelectRow:(int)indexPath.row withTab:3];

    //    if (indexPath.row == 0) {
    //        ChuyenTienTanNhaViewController *chuyenTienTanNhaViewController = [[ChuyenTienTanNhaViewController alloc] initWithNibName:@"ChuyenTienTanNhaViewController" bundle:nil];
    //        [self.navigationController pushViewController:chuyenTienTanNhaViewController animated:YES];
    //        [chuyenTienTanNhaViewController release];
    //    }
    //    else if (indexPath.row == 1) {
    //        GiaoDienChuyenTienDenCMND *internet = [[GiaoDienChuyenTienDenCMND alloc] initWithNibName:@"GiaoDienChuyenTienDenCMND" bundle:nil];
    //        [self.navigationController pushViewController:internet animated:YES];
    //        [internet release];
    //    }
    //    else if (indexPath.row == 4) {
    //        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Chức năng đang được phát triển"];
    //        return;
    //    }
    //    else {
    //        ChuyenTienDenViMomoViewController *vc = [[ChuyenTienDenViMomoViewController alloc] initWithNibName:@"ChuyenTienDenViMomoViewController" bundle:nil];
    //        if (indexPath.row == 2) {
    //            vc.nType = 1;
    //        }
    //        else if (indexPath.row == 5) {
    //            vc.nType = 2;
    //        }
    //        else if (indexPath.row == 6) {
    //            vc.nType = 3;
    //        }
    //        else if (indexPath.row == 7) {
    //            vc.nType = 4;
    //        }
    //        else if (indexPath.row == 8) {
    //            vc.nType = 5;
    //        }
    //        else if (indexPath.row == 3) {
    //            vc.nType = 6;
    //        }
    //        else if (indexPath.row == 9) {
    //            vc.nType = 7;
    //        }
    //        else if (indexPath.row == 10) {
    //            vc.nType = 8;
    //        }
    //        [self.navigationController pushViewController:vc animated:YES];
    //        [vc release];
    //    }
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}

@end
