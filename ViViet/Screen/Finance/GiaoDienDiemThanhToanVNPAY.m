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

@interface GiaoDienDiemThanhToanVNPAY () <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    NSMutableArray *arrInfoDiaDiem;
    int nOption;
    int rowSelectedTinhThanh;
    int offset;
    int limit;
    CLLocation *mCurrentLocation;
}

@end

@implementation GiaoDienDiemThanhToanVNPAY

- (void)viewDidLoad {
    [super viewDidLoad];
    nOption = 0;
    rowSelectedTinhThanh = 0;
    offset = 0;
    limit = 100;
    [self.tableView registerNib:[UINib nibWithNibName:@"VNPAYDienDiemCell" bundle:nil] forCellReuseIdentifier:@"VNPAYDienDiemCell"];
    [self layDanhSachTinhThanh];
    [self layDiaDiemHienTai];
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
    [self timDiaDiem];
}

- (void)timDiaDiem {
    ItemInfoDiaDiem *itemGanDay = [arrInfoDiaDiem objectAtIndex:rowSelectedTinhThanh];
    if ([itemGanDay.ten isEqualToString:@"Gần đây"]) {
        itemGanDay.latude = mCurrentLocation.coordinate.latitude;
        itemGanDay.longtude = mCurrentLocation.coordinate.longitude;
    }
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
    if ([sDinhDanhKetNoi isEqualToString:@"LAY_DIA_DIEM_VNPAY"]) {
        [self anLoading];
    
    }
}

- (void)xuLyKetNoiThatBai:(NSString*)sDinhDanhKetNoi thongBao:(NSString*)sThongBao ketQua:(id)ketQua
{
    [self anLoading];
    [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (nOption == 0) {
        return arrInfoDiaDiem != nil ? arrInfoDiaDiem.count : 0;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (nOption == 0) {
        return 50.0;
    }
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
        return cell;
    }
}

- (void)dealloc {
    [_tableView release];
    [_tfKhoangCach release];
    [super dealloc];
}

@end
