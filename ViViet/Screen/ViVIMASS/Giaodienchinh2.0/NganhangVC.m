//
//  NganhangVC.m
//  ViViMASS
//
//  Created by Mac Mini on 10/11/18.
//

#import "NganhangVC.h"
#import "ItemListCell.h"
#import "ChuyenTienTanNhaViewController.h"
#import "GiaoDienChuyenTienDenCMND.h"


@interface NganhangVC ()<UITableViewDelegate,UITableViewDataSource>
@end

@implementation NganhangVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ItemListCell" bundle:nil] forCellReuseIdentifier:@"ItemListCell"];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];

//    self.arrDanhSach =@[@{@"name":[Localization languageSelectedStringForKey:@"financer_viewer_wallet_to_dienthoai"],@"image":@"ic_chuyentien_dienthoai"},
//      @{@"name":[Localization languageSelectedStringForKey:@"financer_viewer_wallet_to_bank"], @"image":@"icon_grid_dentaikhoan"},
//      @{@"name":[Localization languageSelectedStringForKey:@"financer_viewer_wallet_to_BankCard"], @"image":@"icon_grid_denthe"},
//      @{@"name":[Localization languageSelectedStringForKey:@"financer_viewer_wallet_to_ATM"], @"image":@"icon_grid_den_atm"},
//      @{@"name":[Localization languageSelectedStringForKey:@"financer_viewer_wallet_to_home"], @"image":@"icon_grid_dentannha"},
//      @{@"name":[Localization languageSelectedStringForKey:@"financer_viewer_cmnd"], @"image":@"icon_grid_den_cmnd"},
//      @{@"name":[Localization languageSelectedStringForKey:@"financer_viewer_wallet_saving"], @"image":@"icon_grid_guitietkiem"},
//      @{@"name":[Localization languageSelectedStringForKey:@"financer_viewer_tra_tien_vay"], @"image":@"icon_grid_naptientuthe"},
//      @{@"name":[Localization languageSelectedStringForKey:@"diem_giao_dich"], @"image":@"ic_diem_giao_dich"}, @{@"name":[@"register_token_hint_token" localizableString], @"image":@"ic_vicuatoi_soft_token"}];
    self.arrDanhSach = @[@{@"name":[@"financer_viewer_wallet_to_wallet" localizableString], @"image":@"vimass"},
                         @{@"name":[@"financer_viewer_wallet_to_dienthoai" localizableString], @"image":@"ic_chuyentien_dienthoai"},
                         @{@"name":[@"financer_viewer_wallet_to_bank" localizableString], @"image":@"icon_grid_dentaikhoan"},
                         @{@"name":[@"financer_viewer_wallet_to_BankCard" localizableString], @"image":@"icon_grid_denthe"},
                         @{@"name":[@"financer_viewer_wallet_to_ATM" localizableString], @"image":@"icon_grid_den_atm"},
                         @{@"name":[@"financer_viewer_wallet_to_home" localizableString], @"image":@"icon_grid_dentannha"},
                         @{@"name":[@"financer_viewer_cmnd" localizableString], @"image":@"icon_grid_den_cmnd"},
                         @{@"name":[@"financer_viewer_wallet_saving" localizableString], @"image":@"icon_grid_guitietkiem"},
                         @{@"name":[@"financer_viewer_transaction_limit_xacthuc" localizableString], @"image":@"ic_vicuatoi_hanmuc"},
                         @{@"name":[@"register_token_hint_token" localizableString], @"image":@"ic_vicuatoi_soft_token"}];
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
    return self.view.frame.size.height/ 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemListCell *cell = (ItemListCell *)[tableView dequeueReusableCellWithIdentifier:@"ItemListCell" forIndexPath:indexPath];
    NSDictionary *dict = [self.arrDanhSach objectAtIndex:indexPath.row];
    NSString *name = (NSString *)[dict valueForKey:@"name"];
    NSString *image = (NSString *)[dict valueForKey:@"image"];
    if([UIImage imageNamed:image] != nil){
        [cell.imgTitle setImage:[UIImage imageNamed:image]];
    }
    cell.lblName.text = name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s - indexPath : %d", __FUNCTION__, (int)indexPath.row);
    [self.delegate didSelectRow:(int)indexPath.row withTab:0];
    return;
//    if (indexPath.row == 0) {
//        ChuyenTienTanNhaViewController *chuyenTienTanNhaViewController = [[ChuyenTienTanNhaViewController alloc] initWithNibName:@"ChuyenTienTanNhaViewController" bundle:nil];
//        [self.navigationController pushViewController:chuyenTienTanNhaViewController animated:YES];
//        [chuyenTienTanNhaViewController release];
//    }
//    else if (indexPath.row == 1) {
//        GiaoDienChuyenTienDenCMND *internet = [[GiaoDienChuyenTienDenCMND alloc] initWithNibName:@"GiaoDienChuyenTienDenCMND" bundle:nil];
//        self.navigationController.navigationBar.hidden = NO;
//        [self.navigationController pushViewController:internet animated:YES];
//        [internet release];
//    }
//    else if (indexPath.row == 4) {
//        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Chức năng đang được phát triển"];
//        return;
//    }
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
@end
