//
//  GiaoDienDiemThanhToanVNPAY.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 5/6/19.
//

#import "GiaoDienDiemThanhToanVNPAY.h"
#import "VNPAYDienDiemCell.h"
#import "ItemInfoDiaDiem.h"
#import <CoreLocation/CoreLocation.h>
#import "SVPullToRefresh.h"

@interface GiaoDienDiemThanhToanVNPAY () <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    NSMutableArray *arrInfoDiaDiem;
    NSMutableArray *arrDiaDiemQR;
    NSMutableArray *arrInfoDiaDiemChild;
    int nOption;
    int rowSelectedTinhThanh;
    int offset;
    int limit;
    CLLocation *mCurrentLocation;
    bool bPullToRefresh;
}

@end

@implementation GiaoDienDiemThanhToanVNPAY

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = [@"diem_giao_dich_vnpay" localizableString];
    if (_nType == 0) {
        [self addTitleView: [@"diem_giao_dich_vnpay" localizableString]];
    } else {
        [self addTitleView: @"Điểm giao dịch QR y tế"];
    }
    nOption = 0;
    rowSelectedTinhThanh = 0;
    offset = 0;
    limit = 100;
    [self.tableView registerNib:[UINib nibWithNibName:@"VNPAYDienDiemCell" bundle:nil] forCellReuseIdentifier:@"VNPAYDienDiemCell"];
    [self layDanhSachTinhThanh];
    [self layDiaDiemHienTai];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        if (!bPullToRefresh) {
            bPullToRefresh = YES;
            [self pullToRefresh];
            
        }
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(suKienChonTitleDiaDiem:)];
    [tap setNumberOfTapsRequired:1];
    [self.lblTitle addGestureRecognizer:tap];
    self.lblTitle.userInteractionEnabled = YES;
}

- (void)suKienChonTitleDiaDiem:(UITapGestureRecognizer *)tapGesture {
    nOption = 0;
    [arrDiaDiemQR removeAllObjects];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)pullToRefresh{
    offset += (int)arrDiaDiemQR.count;
    [self timDiaDiem];
}

- (void) layDiaDiemHienTai{
    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    NSLog(@"GiaoDienDiemGiaoDichV2 : didChangeAuthorizationStatus : status : %d", status);
    if (locationManager && status != kCLAuthorizationStatusNotDetermined) {
        [locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    if (locations && locations.count > 0) {
        CLLocation *temp = [locations objectAtIndex:0];
        mCurrentLocation = [[CLLocation alloc] initWithLatitude:temp.coordinate.latitude longitude:temp.coordinate.longitude];
        [manager stopUpdatingLocation];
//        CLLocationCoordinate2D zoomLocation;
//        zoomLocation.latitude = mCurrentLocation.coordinate.latitude;
//        zoomLocation.longitude = mCurrentLocation.coordinate.longitude;
//        MKCircle *circle = [MKCircle circleWithCenterCoordinate:zoomLocation radius:radius * KHOANG_CACH_MAC_DINH];
//        [self.mapView addOverlay:circle];
//        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, radius * 2 * KHOANG_CACH_MAC_DINH, radius * 2 * KHOANG_CACH_MAC_DINH);
//        [self.mapView setRegion:viewRegion animated:YES];
//
//        if (bLayLanDau == NO) {
//            bLayLanDau = YES;
//            [self ketNoiLayDanhSachDiaDiem];
//        }
    }
}

- (void)layDanhSachTinhThanh {
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"DanhSachDiaDiemGiaoDich" ofType:@"plist"];
    NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSArray *arrTemp = [plist objectForKey:@"MainItem"];
    if (arrInfoDiaDiem == nil) {
        arrInfoDiaDiem = [[NSMutableArray alloc] init];
    }
    ItemInfoDiaDiem *itemGanDay = [[ItemInfoDiaDiem alloc] init];
    itemGanDay.ten = @"Gần đây";
    itemGanDay.latude = 0;
    itemGanDay.longtude = 0;
    itemGanDay.dsCon = nil;
    [arrInfoDiaDiem addObject:itemGanDay];
    
    for (int i = 0; i < arrTemp.count; i++) {
        NSDictionary *dicTemp = [arrTemp objectAtIndex:i];
        ItemInfoDiaDiem *item = [[ItemInfoDiaDiem alloc] init];
        [item khoiTaoDoiTuong:dicTemp];
        [arrInfoDiaDiem addObject:item];
    }
    NSLog(@"%s - arrInfoDiaDiem : %d", __FUNCTION__, (int)arrInfoDiaDiem.count);
}

- (IBAction)suKienChonTimDiaDiem:(id)sender {
    nOption = 1;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    [self timDiaDiem];
}

- (void)timDiaDiem:(ItemInfoDiaDiem *)itemGanDay {
//    ItemInfoDiaDiem *itemGanDay = [arrInfoDiaDiem objectAtIndex:rowSelectedTinhThanh];
    if ([itemGanDay.ten isEqualToString:@"Gần đây"]) {
        itemGanDay.latude = mCurrentLocation.coordinate.latitude;
        itemGanDay.longtude = mCurrentLocation.coordinate.longitude;
    }
    self.lblTitle.text = itemGanDay.ten;
    NSDictionary *dictPost = @{
                               @"km":[NSNumber numberWithDouble:[self.tfKhoangCach.text doubleValue]],
                               @"lat":[NSNumber numberWithDouble:itemGanDay.latude],
                               @"lng" : [NSNumber numberWithDouble:itemGanDay.longtude],
                               @"offset" : [NSNumber numberWithInt:offset],
                               @"limit" : [NSNumber numberWithInt:limit]
                               };
    NSString *sDict = [dictPost JSONString];
    NSLog(@"%s - sDict : %@", __FUNCTION__, sDict);
    [self hienThiLoading];
    self.mDinhDanhKetNoi = @"LAY_DIA_DIEM_VNPAY";
    [GiaoDichMang ketNoiLayDanhSachDiaDiemVNPAY:sDict noiNhanKetQua:self];
    
}

- (void)xuLyKetNoiThanhCong:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua {
    bPullToRefresh = NO;
    if ([sDinhDanhKetNoi isEqualToString:@"LAY_DIA_DIEM_VNPAY"]) {
        [self anLoading];
        NSArray *arrTemp = (NSArray *)ketQua;
        if (!arrDiaDiemQR) {
            arrDiaDiemQR = [[NSMutableArray alloc] init];
        }
        [arrDiaDiemQR addObjectsFromArray:arrTemp];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}

- (void)xuLyKetNoiThatBai:(NSString*)sDinhDanhKetNoi thongBao:(NSString*)sThongBao ketQua:(id)ketQua
{
    bPullToRefresh = NO;
    [self anLoading];
    [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _tableViewChild && rowSelectedTinhThanh >= 0) {
        ItemInfoDiaDiem *itemParent = [arrInfoDiaDiem objectAtIndex:rowSelectedTinhThanh];
        return itemParent.dsCon.count;
    }
    if (nOption == 0) {
        return arrInfoDiaDiem != nil ? arrInfoDiaDiem.count : 0;
    }
    return arrDiaDiemQR != nil ? arrDiaDiemQR.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tableViewChild) {
        return 50.0;
    }
    if (nOption == 0) {
        return 50.0;
    }
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tableViewChild) {
        static NSString *cellIdentifier = @"cellIdentifierChild";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(!cell)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setBackgroundColor:[UIColor colorWithRed:3.0/255.0 green:132.0/255.0 blue:252.0/255.0 alpha:1]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        ItemInfoDiaDiem *itemParent = [arrInfoDiaDiem objectAtIndex:rowSelectedTinhThanh];
        ItemInfoDiaDiem *itemChild = [itemParent.dsCon objectAtIndex:indexPath.row];
        cell.textLabel.text = itemChild.ten;
        return cell;
    } else {
        if (nOption == 0) {
            static NSString *cellIdentifier = @"cellIdentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!cell)
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            [cell.textLabel setFont:[UIFont systemFontOfSize:17.0f]];
            ItemInfoDiaDiem *item = [arrInfoDiaDiem objectAtIndex:indexPath.row];
            cell.textLabel.text = item.ten;
            return cell;
        } else {
            VNPAYDienDiemCell *cell = (VNPAYDienDiemCell *)[tableView dequeueReusableCellWithIdentifier:@"VNPAYDienDiemCell" forIndexPath:indexPath];
            NSDictionary *item = [arrDiaDiemQR objectAtIndex:indexPath.row];
            cell.lblTitle.text = [item valueForKey:@"diemGiaoDich"];
            cell.lblDiaChi.text = [item valueForKey:@"diaChi"];
            cell.lblKhoangCach.text = [NSString stringWithFormat:@"%.2f km", [[item valueForKey:@"distance"] doubleValue]];
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tableViewChild) {
        nOption = 1;
        [arrDiaDiemQR removeAllObjects];
        [_tableViewChild setHidden:YES];
        ItemInfoDiaDiem *itemParent = [arrInfoDiaDiem objectAtIndex:rowSelectedTinhThanh];
        ItemInfoDiaDiem *itemChild = [itemParent.dsCon objectAtIndex:indexPath.row];
        [self timDiaDiem:itemChild];
    } else {
        if (nOption == 0) {
            rowSelectedTinhThanh = (int)indexPath.row;
            ItemInfoDiaDiem *item = [arrInfoDiaDiem objectAtIndex:rowSelectedTinhThanh];
            if (item.dsCon.count > 0) {
                [_tableViewChild setHidden:NO];
                [_tableViewChild reloadData];
            } else {
                [_tableViewChild setHidden:YES];
                nOption = 1;
                [tableView reloadData];
                [arrDiaDiemQR removeAllObjects];
                [self timDiaDiem:item];
            }
        }
    }
}

- (void)xuLyQuanHuyenHaNoi {
    
}

- (void)dealloc {
    [_tableView release];
    [_tfKhoangCach release];
    [_lblTitle release];
    [_tableViewChild release];
    [super dealloc];
}

@end
