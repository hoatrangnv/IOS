//
//  GiaoDienChonChuyenBay.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 1/7/16.
//
//

#import "GiaoDienChonChuyenBay.h"
#import "CellChuyenBay.h"
#import "CellHeaderChuyenBay.h"
#import "ItemTongChuyenBay.h"

@interface GiaoDienChonChuyenBay ()<UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>{
    NSMutableArray *arrChuyenBay, *arrChuyenDi, *arrChuyenVe;
    ItemChuyenBay *itemChuyenDi, *itemChuyenVe;
    
}

@end

@implementation GiaoDienChonChuyenBay

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Chọn chuyến bay";
    [self addTitleView:@"Chọn chuyến bay"];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0 green:114/255.0 blue:187/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTranslucent:NO];

//    self.navigationItem.hidesBackButton = YES;
    
    UIBarButtonItem *btnLeft = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(suKienChonTiepTuc:)];
    btnLeft.imageInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    self.navigationItem.leftBarButtonItem = btnLeft;
//    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(0, 0, 34, 40);
//    button.backgroundColor = [UIColor clearColor];
//    [button addTarget:self action:@selector(suKienChonTiepTuc:) forControlEvents:UIControlEventTouchUpInside];
//
//    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    button.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
//    button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    UIBarButtonItem *leftItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
//
//
//    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//
//    if (SYSTEM_VERSION_LESS_THAN(@"11"))
//        negativeSeperator.width = -10;
//    else {
//        negativeSeperator.width = -15;
//    }
//
//    [leftItem.customView.widthAnchor constraintEqualToConstant:34].active = YES;
//    [leftItem.customView.heightAnchor constraintEqualToConstant:40].active = YES;
//
//    self.navigationItem.leftBarButtonItems = @[negativeSeperator, leftItem];

    [self addRightButton];
    if (!self.edLuaChon.rightView) {
        UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 12)];
        [btnRight setBackgroundImage:[UIImage imageNamed:@"muiten35x21.png"] forState:UIControlStateNormal];
        self.edLuaChon.rightView = btnRight;
        self.edLuaChon.rightViewMode = UITextFieldViewModeAlways;
    }

    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.tag = 100;
    picker.delegate = self;
    picker.dataSource = self;
    self.edLuaChon.inputView = picker;
    [picker release];
    
    [self.tableChonChuyen registerNib:[UINib nibWithNibName:@"CellChuyenBay" bundle:nil] forCellReuseIdentifier:@"CellChuyenBay"];
    [self.tableChonChuyen registerNib:[UINib nibWithNibName:@"CellHeaderChuyenBay" bundle:nil] forHeaderFooterViewReuseIdentifier:@"CellHeaderChuyenBay"];
}

- (void)addRightButton{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 40);
    [button setTitle:@"Xong" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [button addTarget:self action:@selector(suKienChonTiepTuc:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *leftItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];

    UIBarButtonItem *negativeSeperator = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];

    if (SYSTEM_VERSION_LESS_THAN(@"7"))
        negativeSeperator.width = -5;
    else
        negativeSeperator.width = -10;

    self.navigationItem.rightBarButtonItems = @[negativeSeperator, leftItem];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self xuLyHienThiChuyenBay:self.dicKetQua];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 5;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self layLuaChon:(int)row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *sText = [self layLuaChon:(int)row];
    self.edLuaChon.text = sText;
    [self.edLuaChon resignFirstResponder];
    if (arrChuyenBay && arrChuyenBay.count > 0) {
        if (row == 0 || row == 1) {
            if (arrChuyenBay.count > 1) {
                [arrChuyenVe removeAllObjects];
                ItemTongChuyenBay *itemTong = [arrChuyenBay objectAtIndex:1];
//                for (ItemChuyenBay *item in itemTong.arrItemChuyenBay) {
//                    [arrChuyenVe addObject:item];
//                }
                if (row == 0) {
                    for (int i = 0; i < itemTong.arrItemChuyenBay.count; i ++) {
                        ItemChuyenBay *item = [itemTong.arrItemChuyenBay objectAtIndex:i];
                        [arrChuyenVe addObject:item];
                    }
                }
                else{
                    for (int i = (int)itemTong.arrItemChuyenBay.count - 1; i >= 0; i --) {
                        ItemChuyenBay *item = [itemTong.arrItemChuyenBay objectAtIndex:i];
                        [arrChuyenVe addObject:item];
                    }
                }
            }
            [arrChuyenDi removeAllObjects];
            ItemTongChuyenBay *itemTong = [arrChuyenBay objectAtIndex:0];
            if (row == 0) {
                for (int i = 0; i < itemTong.arrItemChuyenBay.count; i ++) {
                    ItemChuyenBay *item = [itemTong.arrItemChuyenBay objectAtIndex:i];
                    [arrChuyenDi addObject:item];
                }
            }
            else{
                for (int i = (int)itemTong.arrItemChuyenBay.count - 1; i >= 0; i --) {
                    ItemChuyenBay *item = [itemTong.arrItemChuyenBay objectAtIndex:i];
                    [arrChuyenDi addObject:item];
                }
            }
            [self sapXepChuyenBayTheoGia:(int)row];
        }
        else {
            int nIdHang = 0;
            if (row == 2) {
                nIdHang = 2;
            }
            else if (row == 3) {
                nIdHang = 0;
            }
            else if (row == 4) {
                nIdHang = 1;
            }
            if (arrChuyenBay.count > 1) {
                [arrChuyenVe removeAllObjects];
                ItemTongChuyenBay *itemTong = [arrChuyenBay objectAtIndex:1];
                for (ItemChuyenBay *item in itemTong.arrItemChuyenBay) {
                    if (item.hangBay == nIdHang) {
                        [arrChuyenVe addObject:item];
                    }
                }
            }
            [arrChuyenDi removeAllObjects];
            ItemTongChuyenBay *itemTong = [arrChuyenBay objectAtIndex:0];
            for (ItemChuyenBay *item in itemTong.arrItemChuyenBay) {
                if (item.hangBay == nIdHang) {
                    [arrChuyenDi addObject:item];
                }
            }
        }
    }
    [self.tableChonChuyen reloadData];
}

- (NSString *)layLuaChon:(int)row{
    if (row == 0) {
        return @"Giá tăng dần";
    }
    else if (row == 1) {
        return @"Giá giảm dần";
    }
    else if (row == 2) {
        return @"VN Airlines";
    }
    else if (row == 3) {
        return @"VietJet Air";
    }
    else if (row == 4) {
        return @"JetStar Pacific";
    }
    return @"";
}

- (void)xuLyKetNoiThanhCong:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua{
    
    if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_TRA_CUU_CHUYEN_BAY]) {
        NSDictionary *dic = (NSDictionary *)ketQua;
        [self xuLyHienThiChuyenBay:dic];

    }
}

- (void)xuLyHienThiChuyenBay:(NSDictionary *)dic{
    ItemTongChuyenBay *itemDi = nil;
    ItemTongChuyenBay *itemDen = nil;
    NSArray *arrDiTemp = (NSArray *)[dic objectForKey:@"dsDi"];
    NSLog(@"%s - arrDiTemp.count : %ld", __FUNCTION__, (long)arrDiTemp.count);
    if (!arrChuyenDi) {
        arrChuyenDi = [[NSMutableArray alloc] init];
    }
    [arrChuyenDi removeAllObjects];
    for (int i = 0; i < arrDiTemp.count; i ++) {
        if (!itemDi) {
            itemDi = [[ItemTongChuyenBay alloc] khoiTao];
            itemDi.nDinhDanh = 0;
        }
        NSDictionary *dicTemp = [arrDiTemp objectAtIndex:i];
        ItemChuyenBay *item = [[ItemChuyenBay alloc] khoiTaoThongTin:dicTemp];
        [itemDi.arrItemChuyenBay addObject:item];
        [arrChuyenDi addObject:item];
    }

    NSArray *arrDenTemp = (NSArray *)[dic objectForKey:@"dsVe"];
    if (!arrChuyenVe) {
        arrChuyenVe = [[NSMutableArray alloc] init];
    }
    [arrChuyenVe removeAllObjects];
    for (int i = 0; i < arrDenTemp.count; i ++) {
        if (!itemDen) {
            itemDen = [[ItemTongChuyenBay alloc] khoiTao];
            itemDen.nDinhDanh = 1;
        }
        NSDictionary *dicTemp = [arrDenTemp objectAtIndex:i];
        ItemChuyenBay *item = [[ItemChuyenBay alloc] khoiTaoThongTin:dicTemp];
        [itemDen.arrItemChuyenBay addObject:item];
        [arrChuyenVe addObject:item];
    }

//    [self sapXepChuyenBayTheoGia:0];

    if (!arrChuyenBay) {
        arrChuyenBay = [[NSMutableArray alloc] init];
    }
    [arrChuyenBay removeAllObjects];
    if (itemDi) {
        [arrChuyenBay addObject:itemDi];
    }
    if (itemDen) {
        [arrChuyenBay addObject:itemDen];
    }
    [self.tableChonChuyen reloadData];
}

- (void)sapXepChuyenBayTheoGia:(int)nKieu {
    if (nKieu == 0) {
        if (arrChuyenDi.count > 0) {
            [arrChuyenDi sortUsingComparator:^NSComparisonResult(ItemChuyenBay *obj1, ItemChuyenBay *obj2) {
                if (obj1.gia > obj2.gia) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                return NSOrderedAscending;
            }];
        }

        if (arrChuyenVe.count > 0) {
            [arrChuyenVe sortUsingComparator:^NSComparisonResult(ItemChuyenBay *obj1, ItemChuyenBay *obj2) {
                if (obj1.gia > obj2.gia) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                return NSOrderedAscending;
            }];
        }
    }
    else{
        if (arrChuyenDi.count > 0) {
            [arrChuyenDi sortUsingComparator:^NSComparisonResult(ItemChuyenBay *obj1, ItemChuyenBay *obj2) {
                if (obj1.gia < obj2.gia) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                return NSOrderedAscending;
            }];
        }

        if (arrChuyenVe.count > 0) {
            [arrChuyenVe sortUsingComparator:^NSComparisonResult(ItemChuyenBay *obj1, ItemChuyenBay *obj2) {
                if (obj1.gia < obj2.gia) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                return NSOrderedAscending;
            }];
        }
    }
}

- (void)xuLyKetNoiThatBai:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua{
    [self hideLoadingScreen];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (arrChuyenBay) {
        return arrChuyenBay.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    ItemTongChuyenBay *arrTemp = [arrChuyenBay objectAtIndex:section];
//    return arrTemp.arrItemChuyenBay.count;
    if (section == 0) {
        return arrChuyenDi.count;
    }
    else{
        return arrChuyenVe.count;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *headerIdentifier = @"CellHeaderChuyenBay";
    CellHeaderChuyenBay *cell = [tableView dequeueReusableCellWithIdentifier:headerIdentifier];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:headerIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    ItemTongChuyenBay *item = [arrChuyenBay objectAtIndex:section];
    if (item.nDinhDanh == 0) {
        cell.lblChuyen.text = @"Chuyến đi";
    }
    else{
        cell.lblChuyen.text = @"Chuyến về";
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"CellChuyenBay";
    CellChuyenBay *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSMutableArray *arrItem = nil;
    if (indexPath.section == 0) {
        arrItem = arrChuyenDi;
    }
    else
        arrItem = arrChuyenVe;
    ItemChuyenBay *item = [arrItem objectAtIndex:indexPath.row];
    cell.lblHang.text = [self layTenHangBay:item.hangBay];
    cell.lblSoHieu.text = item.maChuyenBay;
    cell.lblGioDi.text = item.gioBay;
    cell.lblGioDen.text = item.gioDen;
    cell.lblGiaTien.text = [Common hienThiTienTe:item.gia];
//    NSLog(@"%s - indexDi : %d - %d", __FUNCTION__, (int)self.indexDi.section, (int)indexPath.row);
    if ((self.indexDi != nil && (indexPath.section == self.indexDi.section && indexPath.row == self.indexDi.row)) || (self.indexVe != nil && (indexPath.section == self.indexVe.section && indexPath.row == self.indexVe.row))) {
        cell.lblGiaTien.backgroundColor = [UIColor colorWithRed:0 green:114/255.0 blue:187/255.0 alpha:1];
        cell.lblGiaTien.textColor = [UIColor whiteColor];
    }
    else {
        cell.lblGiaTien.backgroundColor = [UIColor clearColor];
        cell.lblGiaTien.textColor = [UIColor blackColor];
    }
//    if ((indexDi != nil && [indexPath isEqual:indexDi]) || (indexVe != nil && [indexPath isEqual:indexVe])) {
//        cell.lblGiaTien.backgroundColor = [UIColor colorWithRed:0 green:114/255.0 blue:187/255.0 alpha:1];
//        cell.lblGiaTien.textColor = [UIColor whiteColor];
//    }
//    else{
//        cell.lblGiaTien.backgroundColor = [UIColor clearColor];
//        cell.lblGiaTien.textColor = [UIColor blackColor];
//    }
    if (item.hangBay == 0) {
        [cell doiMauChuTheoHang:[UIColor redColor]];
    }
    else if (item.hangBay == 1){
        [cell doiMauChuTheoHang:[UIColor blackColor]];
    }
    else if (item.hangBay == 2){
        [cell doiMauChuTheoHang:[UIColor blueColor]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
//        self.indexDi = nil;
//        [self.indexDi release];
//        self.indexDi = [[NSIndexPath alloc] init];
        self.indexDi = indexPath;
        itemChuyenDi = [arrChuyenDi objectAtIndex:indexPath.row];
    }
    else{
        self.indexVe = indexPath;
        itemChuyenVe = [arrChuyenVe objectAtIndex:indexPath.row];
    }
    [tableView reloadData];
}

- (NSString *)getNgayBay:(NSString *)sTime{
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    NSDate *date = [[NSDate alloc] init];
    date = [dateFormat dateFromString:sTime];
    NSDateComponents *dateComponents = [sysCalendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:date];
    return [NSString stringWithFormat:@"%ld/%ld/%ld", (long)dateComponents.day, (long)dateComponents.month, (long)dateComponents.year];
}

- (NSString *)layTenHangBay:(int)nHang{
    NSString *sTen = @"";
    switch (nHang) {
        case 0:
            sTen = @"VietJet Air";
            break;
        case 1:
            sTen = @"Jetstart";
            break;
        case 2:
            sTen = @"VN Airlines";
            break;
        default:
            break;
    }
    return sTen;
}

- (IBAction)suKienChonTiepTuc:(id)sender {
//    if (!itemChuyenDi) {
//        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng chọn chuyến bay"];
//        return;
//    }
    NSLog(@"%s ==========> back ve dat cho", __FUNCTION__);
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.delegate) {
            [self.delegate chonChuyenBay:itemChuyenDi itemDen:itemChuyenVe];
        }
    }];
}

- (void)dealloc {
    [arrChuyenDi release];
    [arrChuyenVe release];
    [arrChuyenBay release];
    [_tableChonChuyen release];
    [_edLuaChon release];
    [super dealloc];
}
@end
