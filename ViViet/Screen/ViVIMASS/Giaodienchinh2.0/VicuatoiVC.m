//
//  VicuatoiVC.m
//  ViViMASS
//
//  Created by Mac Mini on 10/11/18.
//

#import "VicuatoiVC.h"
#import "ItemListCell.h"
#import "Localization.h"
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
//    @{@"name":@"Chuyển tiền đến điện thoại", @"image":@"ic_chuyentien_dienthoai"},
    self.arrDanhSach =@[@{@"name":[Localization languageSelectedStringForKey:@"sao_ke"],@"image":@"ic_vicuatoi_saoke"},
                        @{@"name":[Localization languageSelectedStringForKey:@"financer_viewer_wallet_to_wallet"],@"image":@"vimass"},
                        @{@"name":[Localization languageSelectedStringForKey:@"tai_khoan_lien_ket"], @"image":@"ic_vicuatoi_lienket"},
                        @{@"name":[Localization languageSelectedStringForKey:@"chuyen_tien_den_vi_tk_an_sau_dien_thoai"], @"image":@"icon_vicuatoi_vi_an"},
                        @{@"name":[Localization languageSelectedStringForKey:@"nap_tien_tu_the_bank2"], @"image":@"icon_grid_cachnapvi"},
                        @{@"name":[Localization languageSelectedStringForKey:@"rut_tien"], @"image":@"ic_vicuatoi_ruttien"},
                        @{@"name":[Localization languageSelectedStringForKey:@"muon_tien"], @"image":@"icon_chuyen_tien_tan_nha_64x64"},
                        @{@"name":[Localization languageSelectedStringForKey:@"financer_viewer_bussiness_update_information"], @"image":@"icon_edit_the_luu"},
                        @{@"name":[Localization languageSelectedStringForKey:@"dangki_pki"], @"image":@"pki"},
                        @{@"name":[Localization languageSelectedStringForKey:@"financer_viewer_transaction_limit_xacthuc"], @"image":@"ic_vicuatoi_hanmuc"}
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
    return self.view.frame.size.height / 10.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemListCell *cell = (ItemListCell *)[tableView dequeueReusableCellWithIdentifier:@"ItemListCell" forIndexPath:indexPath];
    NSDictionary *dict = [self.arrDanhSach objectAtIndex:indexPath.row];
    NSString *name = (NSString *)[dict valueForKey:@"name"];
    NSString *image = (NSString *)[dict valueForKey:@"image"];
    [cell.imgTitle setImage:[UIImage imageNamed:image]];
    cell.lblName.text = name;
    if (indexPath.row == 8) {
        cell.imgTitle.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:1];
        cell.imgTitle.layer.cornerRadius = 8.0;
    }
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
