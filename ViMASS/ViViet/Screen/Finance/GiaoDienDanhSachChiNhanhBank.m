//
//  GiaoDienDanhSachChiNhanhBank.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 3/15/16.
//
//

#import "GiaoDienDanhSachChiNhanhBank.h"
#import "CellDiemGiaoDich.h"
#import "SVPullToRefresh.h"
#import "ItemDiaDiemGiaoDich.h"

@interface GiaoDienDanhSachChiNhanhBank () {
    int nPage;
    bool bPullToRefresh;
    NSMutableArray *arrDiaDiem;
}
@end

@implementation GiaoDienDanhSachChiNhanhBank

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitleView:[@"danh_sach_cn_pgd" localizableString]];
    nPage = 1;
    bPullToRefresh = NO;
    [self.tableDanhSach addInfiniteScrollingWithActionHandler:^{
        if (!bPullToRefresh) {
            bPullToRefresh = YES;
            [self pullToRefresh];
        }
    }];
    NSLog(@"%s - lat : %f - lng : %f", __FUNCTION__, self.lat, self.lng);

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showLoadingScreen];
    self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_DANH_SACH_DIA_DIEM;
    [GiaoDichMang ketNoiLayDanhSachDiaDiem:self.sKeyword langId:1 limit:100 page:nPage status:2 compress:0 lat:self.lat lng:self.lng r:self.nKc categoryId:@"603" noiNhanKetQua:self];
}

- (void)pullToRefresh{
    self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_DANH_SACH_DIA_DIEM;
    [GiaoDichMang ketNoiLayDanhSachDiaDiem:self.sKeyword langId:1 limit:100 page:nPage status:2 compress:0 lat:self.lat lng:self.lng r:self.nKc categoryId:@"603" noiNhanKetQua:self];
}

- (void)xuLyKetNoiThanhCong:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua{
    bPullToRefresh = NO;
    if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_DANH_SACH_DIA_DIEM]) {
        NSArray *arrDanhSach = ketQua;
        if(!arrDiaDiem)
            arrDiaDiem = [[NSMutableArray alloc] init];
        NSLog(@"%s - %s : arrDanhSach.count : %ld", __FILE__, __FUNCTION__, (unsigned long)arrDanhSach.count);
        for (int i = 0; i < arrDanhSach.count; i++) {
            ItemDiaDiemGiaoDich *item = [[ItemDiaDiemGiaoDich alloc] init];
            [item taoThongTinDiaDiem:[arrDanhSach objectAtIndex:i]];
            if ([item.name containsString:@"-"]) {
                NSArray *arrTemp = [item.name componentsSeparatedByString:@"-"];
                if (arrTemp && arrTemp.count > 0) {
                    item.name = [arrTemp objectAtIndex:0];
                }
            }
            [arrDiaDiem addObject:item];
        }
        if (self.tableDanhSach.isHidden == NO)
            [self.tableDanhSach reloadData];
        nPage ++;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ItemDiaDiemGiaoDich *item = [arrDiaDiem objectAtIndex:indexPath.row];
    if (!item.phone.isEmpty) {
        return 105.0f;
    }
    else {
        return 80.0f;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%s - bat dau tableview", __FUNCTION__);
    return arrDiaDiem.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"CellDiemGiaoDich";
    CellDiemGiaoDich *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    ItemDiaDiemGiaoDich *item = [arrDiaDiem objectAtIndex:indexPath.row];
    cell.lblName.text = item.name;
    cell.lblAdress.text = item.address;
    cell.lblDistance.hidden = YES;
    if (!item.phone.isEmpty) {
        cell.lblPhone.hidden = NO;
        cell.lblPhone.text = item.phone;
    }
    else {
        cell.lblPhone.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ItemDiaDiemGiaoDich *item = [arrDiaDiem objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KEY_THONG_TIN_CHI_NHANH" object:item];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [_tableDanhSach release];
    [super dealloc];
}
@end
