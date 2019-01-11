//
//  QRVC.m
//  ViViMASS
//
//  Created by Mac Mini on 10/11/18.
//

#import "QRVC.h"
#import "ItemListCell.h"
@interface QRVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation QRVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ItemListCell" bundle:nil] forCellReuseIdentifier:@"ItemListCell"];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.arrDanhSach =@[@{@"name":@"Vimass QR",@"image":@"vimass-qr"}];
//    self.arrDanhSach =@[@{@"name":@"Vimass QR",@"image":@"vimass-qr"},
//                        @{@"name":@"VNPAY QR", @"image":@"vnpt-qr"},
//                        @{@"name":@"Momo QR", @"image":@"momo-qr"},
//                        @{@"name":@"VCB Pay QR", @"image":@"vcb-pay"},
//                        @{@"name":@"Viettel Pay QR", @"image":@"viettel-qr"},
//                        @{@"name":@"Zalo Pay QR", @"image":@"zalo-qr"},
//                        @{@"name":@"Giao dịch QR", @"image":@"ic_qr_giaodich"}
//                        ];
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
    return self.view.frame.size.height / 7.0;
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
    [self.delegate didSelectRow:(int)indexPath.row withTab:2];

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
