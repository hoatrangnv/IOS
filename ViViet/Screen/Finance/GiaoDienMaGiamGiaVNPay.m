//
//  GiaoDienMaGiamGiaVNPay.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 5/2/19.
//

#import "GiaoDienMaGiamGiaVNPay.h"
#import "MaKhuyenMaiTableViewCell.h"

@interface GiaoDienMaGiamGiaVNPay () <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *arrKM;
}

@end

@implementation GiaoDienMaGiamGiaVNPay

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [@"ma_khuyen_mai_vnpay" localizableString];
    [self.tableView registerNib:[UINib nibWithNibName:@"MaKhuyenMaiTableViewCell" bundle:nil] forCellReuseIdentifier:@"MaKhuyenMaiTableViewCell"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self readFileKhuyenMai];
}

- (void)readFileKhuyenMai {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"json_ma_km_vnpay"
                                                     ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    NSArray *arrContent = [content objectFromJSONString];
    arrKM = [[NSMutableArray alloc] initWithArray:arrContent];
    NSLog(@"%s - arrKM : %d", __FUNCTION__, (int)arrKM.count);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrKM.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MaKhuyenMaiTableViewCell *cell = (MaKhuyenMaiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MaKhuyenMaiTableViewCell" forIndexPath:indexPath];
    NSDictionary *item = (NSDictionary *)[arrKM objectAtIndex:indexPath.row];
    cell.lblMaKM.text = (NSString *)[item valueForKey:@"maKM"];
    cell.lblDonViApDung.text = (NSString *)[item valueForKey:@"donviApDung"];
    cell.lblUuDai.text = (NSString *)[item valueForKey:@"uuDai"];
    cell.lblSoLuong.text = (NSString *)[item valueForKey:@"soluot"];
    return cell;
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
@end
