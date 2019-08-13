//
//  GiaoDienDenKhac.m
//  ViViMASS
//
//  Created by Tam Nguyen on 2/23/18.
//

#import "GiaoDienDenKhac.h"
#import "DenKhacTableViewCell.h"
#import "ChuyenTienTanNhaViewController.h"
#import "GiaoDienChuyenTienDenCMND.h"
#import "ChuyenTienDenViMomoViewController.h"

@interface GiaoDienDenKhac () <UITableViewDelegate, UITableViewDataSource> {
}

@end

@implementation GiaoDienDenKhac

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Chuyển tiền đến ...";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DenKhacTableViewCell" bundle:nil] forCellReuseIdentifier:@"DenKhacTableViewCell"];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.arrDanhSach = @[@{@"name":@"Chuyển tiền đến tận nhà", @"image":@"icon_chuyen_den_tannhan"}, @{@"name":@"Chuyển tiền đến CMND", @"image":@"icon_chuyen_den_cmnd"}, @{@"name":@"Chuyển tiền đến Momo", @"image":@"icon_chuyen_den_momo"}, @{@"name":@"Chuyển tiền đến Ví việt", @"image":@"icon_chuyen_den_viviet"}, @{@"name":@"Chuyển tiền đến Zalopay", @"image":@"icon_chuyen_den_zalo"}, @{@"name":@"Chuyển tiền đến Ngân lượng", @"image":@"icon_chuyen_den_nganluong"}, @{@"name":@"Chuyển tiền đến Payoo", @"image":@"icon_chuyen_den_payoo"}, @{@"name":@"Chuyển tiền đến Vimo", @"image":@"icon_chuyen_den_vimo"}, @{@"name":@"Chuyển tiền đến VTC Pay", @"image":@"icon_chuyen_den_vtcpay"},
                    @{@"name":@"Chuyển tiền đến VNPT Pay", @"image":@"icon_sotay_vnpt"},
                    @{@"name":@"Chuyển tiền đến AIR Pay", @"image":@"icon_sotay_airpay"}];
}


#pragma mark - Navigation
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrDanhSach.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DenKhacTableViewCell *cell = (DenKhacTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DenKhacTableViewCell" forIndexPath:indexPath];
    NSDictionary *dict = [self.arrDanhSach objectAtIndex:indexPath.row];
    NSString *name = (NSString *)[dict valueForKey:@"name"];
    NSString *image = (NSString *)[dict valueForKey:@"image"];
    [cell.imgvDaiDien setImage:[UIImage imageNamed:image]];
    cell.lblName.text = name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s - indexPath : %d", __FUNCTION__, (int)indexPath.row);
    if (indexPath.row == 0) {
        ChuyenTienTanNhaViewController *chuyenTienTanNhaViewController = [[ChuyenTienTanNhaViewController alloc] initWithNibName:@"ChuyenTienTanNhaViewController" bundle:nil];
        [self.navigationController pushViewController:chuyenTienTanNhaViewController animated:YES];
        [chuyenTienTanNhaViewController release];
    }
    else if (indexPath.row == 1) {
        GiaoDienChuyenTienDenCMND *internet = [[GiaoDienChuyenTienDenCMND alloc] initWithNibName:@"GiaoDienChuyenTienDenCMND" bundle:nil];
        [self.navigationController pushViewController:internet animated:YES];
        [internet release];
    }
    else if (indexPath.row == 4) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Chức năng đang được phát triển"];
        return;
    }
    else {
        ChuyenTienDenViMomoViewController *vc = [[ChuyenTienDenViMomoViewController alloc] initWithNibName:@"ChuyenTienDenViMomoViewController" bundle:nil];
        if (indexPath.row == 2) {
            vc.nType = 1;
        }
        else if (indexPath.row == 5) {
            vc.nType = 2;
        }
        else if (indexPath.row == 6) {
            vc.nType = 3;
        }
        else if (indexPath.row == 7) {
            vc.nType = 4;
        }
        else if (indexPath.row == 8) {
            vc.nType = 5;
        }
        else if (indexPath.row == 3) {
            vc.nType = 6;
        }
        else if (indexPath.row == 9) {
            vc.nType = 7;
        }
        else if (indexPath.row == 10) {
            vc.nType = 8;
        }
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
@end
