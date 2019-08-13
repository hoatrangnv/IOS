//
//  GiaoDienDiemGiaoDichV2.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 11/5/15.
//
//

#import "GiaoDienDiemGiaoDichV2.h"
#import "ItemDiaDiemGiaoDich.h"
#import "ItemInfoDiaDiem.h"
#import "CellDiemGiaoDich.h"
#import "SVPullToRefresh.h"
#import "DucNT_LuuRMS.h"
#import "ExTextField.h"
#import "GiaoDichMang.h"

@interface GiaoDienDiemGiaoDichV2 (){
    CLLocationManager *locationManager;
    CLLocation *mCurrentLocation;
    ExTextField *textFeildSearch;
    NSMutableArray *arrDiaDiem;
    NSMutableArray *arrSubDiaDiem;
    NSString *sTenTPDuocChon;
    NSString *sCateId;
    ItemInfoDiaDiem *itemHienTai;
    bool bLayLanDau;
    bool bPullToRefresh;
    double radius;
    int nPage;
}

@end

@implementation GiaoDienDiemGiaoDichV2

#define kDO_CAO_CELL_GIAO_DIEN_BEN_TRAI 40.0f
#define KHOANG_CACH_MAC_DINH 1000
#define KEY_LUU_CATE @"tamnv_cate_dia_diem"

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addButtonBack];
    [self khoiTaoNavigationBar];
    [self.tableDiaDiem setHidden:YES];
    [self khoiTaoViewTimKiem];

    nPage = 1;
    sTenTPDuocChon = @"";
    bLayLanDau = NO;
    bPullToRefresh = NO;
    radius = 5;

    [self.mapView setDelegate:self];
    [self layDiaDiemHienTai];

    [self.tableDiaDiem addInfiniteScrollingWithActionHandler:^{
        if (!bPullToRefresh) {
            bPullToRefresh = YES;
            [self pullToRefresh];
            
        }
    }];

    self.tvDiaDiem.userInteractionEnabled = YES;
    UITapGestureRecognizer *clickTvDiaDiem = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelDiaDiemClick)];
    [self.tvDiaDiem addGestureRecognizer:clickTvDiaDiem];
    [clickTvDiaDiem release];
}

- (void)khoiTaoViewTimKiem{
    UITapGestureRecognizer *singerTapBank = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(suKiemChonViewTimKiemBank:)];
    singerTapBank.delegate = self;
    [self.viewNganHang addGestureRecognizer:singerTapBank];

    UITapGestureRecognizer *singerTapATM = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(suKiemChonViewTimKiemATM:)];
    singerTapATM.delegate = self;
    [self.viewATM addGestureRecognizer:singerTapATM];

    UITapGestureRecognizer *singerTapPOST = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(suKiemChonViewTimKiemPOST:)];
    singerTapPOST.delegate = self;
    [self.viewBuuDien addGestureRecognizer:singerTapPOST];

    [singerTapBank release];
    [singerTapATM release];
    [singerTapPOST release];
}

- (void)suKiemChonViewTimKiemBank:(UITapGestureRecognizer *)recoginer{
    [self.imgCheckBank setHidden:![self.imgCheckBank isHidden]];
}

- (void)suKiemChonViewTimKiemATM:(UITapGestureRecognizer *)recoginer{
    [self.imgCheckATM setHidden:![self.imgCheckATM isHidden]];
}

- (void)suKiemChonViewTimKiemPOST:(UITapGestureRecognizer *)recoginer{
    [self.imgCheckPost setHidden:![self.imgCheckPost isHidden]];
}

- (void)khoiTaoNavigationBar{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 28, 28);
    button.backgroundColor = [UIColor clearColor];
    [button setImage:[UIImage imageNamed:@"icon_switch_list.png"] forState:UIControlStateNormal];
    button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [button addTarget:self action:@selector(suKienSwitchMap:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];

    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];

    if (SYSTEM_VERSION_LESS_THAN(@"11"))
        negativeSeperator.width = -10;
    else {
        negativeSeperator.width = -15;
        [button.widthAnchor constraintEqualToConstant:28].active = YES;
        [button.heightAnchor constraintEqualToConstant:28].active = YES;

    }
    self.navigationItem.rightBarButtonItems = @[negativeSeperator, rightItem];

    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    textFeildSearch = [[ExTextField alloc] initWithFrame:CGRectMake(0, 0, 220 * (width / 320), 30)];
    textFeildSearch.delegate = self;
    textFeildSearch.returnKeyType = UIReturnKeySearch;
    UIColor *color = [UIColor grayColor];
    textFeildSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Tìm kiếm" attributes:@{NSForegroundColorAttributeName: color}];
    [textFeildSearch setTextColor:[UIColor whiteColor]];
    self.navigationItem.titleView = textFeildSearch;

    if (![self.sKeyWord isEmpty]) {
        textFeildSearch.text = self.sKeyWord;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"%s - tim kiem : %@", __FUNCTION__, textField.text);
    [self suKienBamNutTimKiem:nil];
    return YES;
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
        CLLocationCoordinate2D zoomLocation;
        zoomLocation.latitude = mCurrentLocation.coordinate.latitude;
        zoomLocation.longitude = mCurrentLocation.coordinate.longitude;
//
        MKCircle *circle = [MKCircle circleWithCenterCoordinate:zoomLocation radius:radius * KHOANG_CACH_MAC_DINH];
        [self.mapView addOverlay:circle];
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, radius * 2 * KHOANG_CACH_MAC_DINH, radius * 2 * KHOANG_CACH_MAC_DINH);
        [self.mapView setRegion:viewRegion animated:YES];

        if (bLayLanDau == NO) {
            bLayLanDau = YES;
            [self ketNoiLayDanhSachDiaDiem];
        }
    }
}

- (void)pullToRefresh{
    _sKeyWord = [textFeildSearch.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_DANH_SACH_DIA_DIEM;
    if (!itemHienTai || [itemHienTai.ten isEqualToString:@"Gần đây"]) {
        [GiaoDichMang ketNoiLayDanhSachDiaDiem:_sKeyWord langId:1 limit:100 page:nPage status:2 compress:0 lat:mCurrentLocation.coordinate.latitude lng:mCurrentLocation.coordinate.longitude r:radius categoryId:sCateId noiNhanKetQua:self];
    }
    else{
        [GiaoDichMang ketNoiLayDanhSachDiaDiem:_sKeyWord langId:1 limit:100 page:nPage status:2 compress:0 lat:itemHienTai.latude lng:itemHienTai.longtude r:radius categoryId:sCateId noiNhanKetQua:self];
    }
}

- (void)didSelectBackButton{
    [super didSelectBackButton];
    sCateId = [self getCategoriesId];
    [[NSUserDefaults standardUserDefaults] setValue:sCateId forKey:KEY_LUU_CATE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)ketNoiLayDanhSachDiaDiem{
    sCateId = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_LUU_CATE];
    if (self.nIndexLuaChon == 1) {
        sCateId = @"601";
    }
    else {
        if (!sCateId || sCateId.length == 0) {
            sCateId = @"601,602,603";
        }
        else{
            if (![sCateId containsString:@"601"]) {
                [self.imgCheckATM setHidden:YES];
            }
            else
                [self.imgCheckATM setHidden:NO];
            if (![sCateId containsString:@"602"]) {
                [self.imgCheckPost setHidden:YES];
            }
            else
                [self.imgCheckPost setHidden:NO];
            if (![sCateId containsString:@"603"]) {
                [self.imgCheckBank setHidden:YES];
            }
            else
                [self.imgCheckBank setHidden:NO];
        }
    }
    self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_DANH_SACH_DIA_DIEM;
    [GiaoDichMang ketNoiLayDanhSachDiaDiem:_sKeyWord langId:1 limit:100 page:nPage status:2 compress:0 lat:mCurrentLocation.coordinate.latitude lng:mCurrentLocation.coordinate.longitude r:radius categoryId:sCateId noiNhanKetQua:self];

}

- (void)ketNoiTimKiemDanhSachDiaDiem:(NSString*)keyWord latude:(double)lat longtude:(double)lng categoryId:(NSString*)cateId page:(int)page{
    self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_DANH_SACH_DIA_DIEM;
    if (self.edRadius.text.length == 0) {
        self.edRadius.text = @"5";
    }
    radius = [self.edRadius.text doubleValue];
    [GiaoDichMang ketNoiLayDanhSachDiaDiem:keyWord langId:1 limit:100 page:page status:2 compress:0 lat:lat lng:lng r:radius categoryId:cateId noiNhanKetQua:self];
}

- (void)xuLyKetNoiThanhCong:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua{
    bPullToRefresh = NO;
    bLayLanDau = YES;
    if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_DANH_SACH_DIA_DIEM]) {
        nPage ++;
        NSArray *arrDanhSach = ketQua;
        if(!arrDiaDiem)
            arrDiaDiem = [[NSMutableArray alloc] init];
        NSLog(@"%s - %s : arrDanhSach.count : %ld", __FILE__, __FUNCTION__, (unsigned long)arrDanhSach.count);
        if (arrDanhSach.count > 0) {
            for (int i = 0; i < arrDanhSach.count; i++) {
                ItemDiaDiemGiaoDich *item = [[ItemDiaDiemGiaoDich alloc] init];
                [item taoThongTinDiaDiem:[arrDanhSach objectAtIndex:i]];
                BOOL isCheck = NO;
                for (ItemDiaDiemGiaoDich *item2 in arrDiaDiem) {
                    if ([item.name isEqualToString:item2.name]) {
                        isCheck = YES;
                    }
                }
                if (!isCheck) {
                    [arrDiaDiem addObject:item];
                    [self.mapView addAnnotation:item];
                }
            }
        }
        if (self.tableDiaDiem.isHidden == NO) {
            [self.tableDiaDiem.infiniteScrollingView stopAnimating];
            [self.tableDiaDiem reloadData];
        }
    }
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay{
    MKOverlayView *overlayView = [mapView viewForOverlay:overlay];
    overlayView.hidden = YES;
    [overlayView setNeedsDisplay];
    [mapView removeOverlay:overlay];
    
    MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
    [circleView setFillColor:[UIColor clearColor]];
    [circleView setStrokeColor:[UIColor blueColor]];

    return circleView;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    static NSString *identifier = @"ItemDiaDiemGiaoDich";
    if ([annotation isKindOfClass:[ItemDiaDiemGiaoDich class]]) {
        ItemDiaDiemGiaoDich *temp = (ItemDiaDiemGiaoDich*)annotation;
        MKAnnotationView *annoView = (MKAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if(!annoView){
            annoView = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
            annoView.enabled = YES;
            annoView.canShowCallout = NO;
        }
        else
            annoView.annotation = annotation;
        if (temp.categoryId == 601) {
            annoView.image = [UIImage imageNamed:@"flag_cateid_601.png"];
        }
        else if (temp.categoryId == 602){
            annoView.image = [UIImage imageNamed:@"flag_cateid_602.png"];
        }
        else if (temp.categoryId == 603){
            annoView.image = [UIImage imageNamed:@"flag_cateid_603.png"];
        }
        else
            annoView.image = [UIImage imageNamed:@"flag_1.png"];
        if([annotation isEqual:self.mapView.userLocation]){
            return nil;
        }
        return annoView;
    }
    else if([annotation isKindOfClass:[MKUserLocation class ]]){
        MKAnnotationView *annoView = (MKAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"MKUserLocation"];
        if(!annoView){
            annoView = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
            annoView.enabled = YES;
            annoView.canShowCallout = NO;
        }
        else
            annoView.annotation = annotation;
        annoView.image = [UIImage imageNamed:@"flag_1.png"];
        return annoView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    id<MKAnnotation> anno = view.annotation;
    if ([anno isKindOfClass:[ItemDiaDiemGiaoDich class]]) {
        ItemDiaDiemGiaoDich *temp = (ItemDiaDiemGiaoDich *)anno;
        [self hienThiViewThongTin:temp];
    }
}

- (void)hienThiViewThongTin:(ItemDiaDiemGiaoDich *)temp{
    if ([self.viewThongTin isHidden]) {
        [self.viewThongTin setHidden:NO];
        [self.btnCloseInfo setHidden:NO];
    }
    NSString *sHienThi = [NSString stringWithFormat:@"%@\nĐc: %@", temp.name, temp.address];
    self.tvName.text = sHienThi;
}

- (IBAction)suKienBamNutDongThongTin:(id)sender {
    [self.btnCloseInfo setHidden:YES];
    [self.viewThongTin setHidden:YES];
}

- (NSString *)getCategoriesId{
    NSString *sCateIdTemp = @"";
    if (![self.imgCheckATM isHidden]) {
        sCateIdTemp = @"601";
    }
    if (![self.imgCheckBank isHidden]) {
        if (sCateIdTemp.length == 0) {
            sCateIdTemp = @"603";
        }
        else{
            sCateIdTemp = [NSString stringWithFormat:@"%@,%@", sCateIdTemp, @"603"];
        }
    }
    if (![self.imgCheckPost isHidden]) {
        if (sCateIdTemp.length == 0) {
            sCateIdTemp = @"602";
        }
        else{
            sCateIdTemp = [NSString stringWithFormat:@"%@,%@", sCateIdTemp, @"602"];
        }
    }
    return sCateIdTemp;
}

- (void)suKienSwitchMap:(id)btn{
    if (self.tableDiaDiem.isHidden == NO) {
        [btn setImage:[UIImage imageNamed:@"icon_switch_list.png"] forState:UIControlStateNormal];
        [self.tableDiaDiem setHidden:YES];
        return;
    }
    [btn setImage:[UIImage imageNamed:@"icon_switch_ban_do.png"] forState:UIControlStateNormal];
    [self.tableDiaDiem setHidden:NO];
    [self.tableDiaDiem reloadData];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([textField isEqual:textFeildSearch]) {
        NSLog(@"%s - [textField isEqual:textFeildSearch] : ============>", __FUNCTION__);
        if (!_arrInfoDiaDiem) {
            _arrInfoDiaDiem = [[NSMutableArray alloc] init];
            NSString* filePath = [[NSBundle mainBundle] pathForResource:@"DanhSachDiaDiemGiaoDich" ofType:@"plist"];
            NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:filePath];
            NSArray *arrTemp = [plist objectForKey:@"MainItem"];

            ItemInfoDiaDiem *itemGanDay = [[ItemInfoDiaDiem alloc] init];
            itemGanDay.ten = @"Gần đây";
            itemGanDay.latude = 0;
            itemGanDay.longtude = 0;
            itemGanDay.dsCon = nil;
            [_arrInfoDiaDiem addObject:itemGanDay];

            for (int i = 0; i < arrTemp.count; i++) {
                NSDictionary *dicTemp = [arrTemp objectAtIndex:i];
                ItemInfoDiaDiem *item = [[ItemInfoDiaDiem alloc] init];
                [item khoiTaoDoiTuong:dicTemp];
                [_arrInfoDiaDiem addObject:item];
            }
            NSLog(@"%s - _arrInfoDiaDiem.count : %d", __FUNCTION__, (int)_arrInfoDiaDiem.count);
        }
        [self.tableDanhSachTinhThanh setHidden:NO];
        [self.tableSubTinhThanh setHidden:YES];
        [self.tableDanhSachTinhThanh reloadData];
        CGRect rectTimKiem = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.viewTimKiem.frame = rectTimKiem;
        [self.view addSubview:self.viewTimKiem];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tableDiaDiem]) {
        return 80.0f;
    }
    return kDO_CAO_CELL_GIAO_DIEN_BEN_TRAI;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%s - bat dau tableview", __FUNCTION__);
    if ([tableView isEqual:self.tableSubTinhThanh]) {
        if (!arrSubDiaDiem) {
            return 0;
        }
        return arrSubDiaDiem.count;
    }
    else if ([tableView isEqual:self.tableDiaDiem]) {
        if (arrDiaDiem) {
            return arrDiaDiem.count;
        }
        return 0;
    }
    if (_arrInfoDiaDiem) {
        NSLog(@"%s - _arrInfoDiaDiem.count : %ld", __FUNCTION__, (unsigned long)_arrInfoDiaDiem.count);
        return _arrInfoDiaDiem.count;
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.tableDiaDiem]) {
        static NSString *cellIdentifier = @"CellDiemGiaoDich";
        CellDiemGiaoDich *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        ItemDiaDiemGiaoDich *item = [arrDiaDiem objectAtIndex:indexPath.row];
        cell.lblName.text = item.name;
        cell.lblAdress.text = item.address;
        NSString *kc = [NSString stringWithFormat:@"%@", item.distance];
        if (kc.length > 4) {
            kc = [kc substringToIndex:4];
        }
        cell.lblDistance.text = [NSString stringWithFormat:@"%@ km", kc];
        return cell;
    }
    else{
        static NSString *cellIdentifier = @"cellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(!cell)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell.textLabel setFont:[UIFont systemFontOfSize:15.0f]];
        if ([tableView isEqual:self.tableSubTinhThanh]) {
            ItemInfoDiaDiem *item = [arrSubDiaDiem objectAtIndex:indexPath.row];
            cell.textLabel.text = item.ten;
        }
        else{
            ItemInfoDiaDiem *item = [_arrInfoDiaDiem objectAtIndex:indexPath.row];
            cell.textLabel.text = item.ten;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.tableDanhSachTinhThanh]) {
        ItemInfoDiaDiem *item = [_arrInfoDiaDiem objectAtIndex:indexPath.row];
        if (item.dsCon && item.dsCon.count > 0) {
            sTenTPDuocChon = item.ten;
            if (arrSubDiaDiem) {
                [arrSubDiaDiem removeAllObjects];
            }
            else
                arrSubDiaDiem = [[NSMutableArray alloc] init];
            for (ItemInfoDiaDiem* itemSub in item.dsCon) {
                [arrSubDiaDiem addObject:itemSub];
            }
            [self.tableSubTinhThanh setHidden:NO];
            [self.tableSubTinhThanh reloadData];
        }
        else{
            sTenTPDuocChon = @"";
            [self.tableSubTinhThanh setHidden:YES];
            [self.tvDiaDiem setText:item.ten];
            itemHienTai = item;
        }
    }
    else if([tableView isEqual:self.tableSubTinhThanh]){
        ItemInfoDiaDiem *item = [arrSubDiaDiem objectAtIndex:indexPath.row];
        NSString *sTenHienThi = @"";
        if (sTenTPDuocChon.length > 0) {
            sTenHienThi = [NSString stringWithFormat:@"%@ - %@", sTenTPDuocChon, item.ten];
        }
        else
            sTenHienThi = item.ten;
        [self.tvDiaDiem setText:sTenHienThi];
        itemHienTai = item;
    }
    else{
        ItemDiaDiemGiaoDich *item = [arrDiaDiem objectAtIndex:indexPath.row];
        [self hienThiViewThongTin:item];
    }
}

- (IBAction)suKienBamNutTimKiem:(id)sender {

    nPage = 1;
    if (arrDiaDiem) {
        [arrDiaDiem removeAllObjects];
    }
    //    NSArray *pointsArray = [self.mapView overlays];
    //    [self.mapView removeOverlays:pointsArray];
    [self.mapView removeAnnotations:self.mapView.annotations];
    sCateId = @"";
    sCateId = [self getCategoriesId];
    //    if (![self.imgCheckATM isHidden]) {
    //        sCateId = @"601";
    //    }
    //    if (![self.imgCheckBank isHidden]) {
    //        if (sCateId.length == 0) {
    //            sCateId = @"603";
    //        }
    //        else{
    //            sCateId = [NSString stringWithFormat:@"%@,%@", sCateId, @"603"];
    //        }
    //    }
    //    if (![self.imgCheckPost isHidden]) {
    //        if (sCateId.length == 0) {
    //            sCateId = @"602";
    //        }
    //        else{
    //            sCateId = [NSString stringWithFormat:@"%@,%@", sCateId, @"602"];
    //        }
    //    }

    _sKeyWord = [textFeildSearch.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    NSLog(@"%s - %s : sCateId : %@", __FILE__, __FUNCTION__, sCateId);
    CLLocationCoordinate2D zoomLocation;
    if (!itemHienTai || [itemHienTai.ten isEqualToString:@"Gần đây"]) {
        zoomLocation.latitude = mCurrentLocation.coordinate.latitude;
        zoomLocation.longitude = mCurrentLocation.coordinate.longitude;
        [GiaoDichMang ketNoiLayDanhSachDiaDiem:_sKeyWord langId:1 limit:100 page:1 status:2 compress:0 lat:mCurrentLocation.coordinate.latitude lng:mCurrentLocation.coordinate.longitude r:radius categoryId:sCateId noiNhanKetQua:self];
    }
    else{
        zoomLocation.latitude = itemHienTai.latude;
        zoomLocation.longitude = itemHienTai.longtude;
        [GiaoDichMang ketNoiLayDanhSachDiaDiem:_sKeyWord langId:1 limit:100 page:1 status:2 compress:0 lat:itemHienTai.latude lng:itemHienTai.longtude r:radius categoryId:sCateId noiNhanKetQua:self];
    }

    [self.viewTimKiem removeFromSuperview];

    MKCircle *circle = [MKCircle circleWithCenterCoordinate:zoomLocation radius:radius * KHOANG_CACH_MAC_DINH];
    [self.mapView addOverlay:circle];
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, radius * 2 * KHOANG_CACH_MAC_DINH, radius * 2 * KHOANG_CACH_MAC_DINH);
    [self.mapView setRegion:viewRegion animated:YES];
    
    [textFeildSearch endEditing:YES];
}

- (void)dealloc {
    [_mapView release];
    [_sKeyWord release];
    if (locationManager) {
        [locationManager release];
    }
    if (mCurrentLocation) {
        [mCurrentLocation release];
    }
    [_viewThongTin release];
    [_tvName release];
    [_btnCloseInfo release];
    if (textFeildSearch) {
        [textFeildSearch release];
    }
    [_viewTimKiem release];
    [_viewNganHang release];
    [_viewBuuDien release];
    [_viewATM release];
    [_imgCheckBank release];
    [_imgCheckATM release];
    [_imgCheckPost release];
    [_tvDiaDiem release];
    [_edRadius release];
    [_tableDanhSachTinhThanh release];
    if (arrDiaDiem) {
        [arrDiaDiem release];
    }
    if (_arrInfoDiaDiem) {
        [_arrInfoDiaDiem release];
    }

    [_tableSubTinhThanh release];
    [_tableDiaDiem release];
    [super dealloc];
}

@end
