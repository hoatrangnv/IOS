//
//  HienThiChatViewController.m
//  ViMASS
//
//  Created by DucBT on 9/29/14.
//
//

#import "HienThiChatViewController.h"
#import "HPGrowingTextView.h"
#import "ChatTableViewCell.h"
#import "Appdelegate.h"
#import "DichVuNotification.h"
#import "DoiTuongNotification.h"
#import "DucNT_TaiKhoanViObject.h"

@interface HienThiChatViewController () <HPGrowingTextViewDelegate, UITableViewDataSource, UITableViewDelegate, DucNT_ServicePostDelegate>
{
    IBOutlet HPGrowingTextView *mtv;
    IBOutlet UIButton *mbtnGui;
    IBOutlet UIView *mviewContainer;
    IBOutlet UITableView *mtbHienThiTinNhan;
    NSMutableArray *mDanhSachTinNhan;
    NSMutableArray *mDanhSachTinNhanCanXoa;
    NSMutableDictionary *mMapTinNhanChuaGui;
    UIRefreshControl *mRefreshControl;
    
    NSString *mDinhDanhKetNoi;
    int mViTriBatDauLayTin;
    int mSoLuongTinCanLay;
    BOOL mTrangThaiDanhDauTinDaDoc;
    BOOL mDangGuiTinNhan;
    BOOL mDuocPhepCuonXuong;
    BOOL mTrangThaiXoa;
}



@end

@implementation HienThiChatViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        mDuocPhepCuonXuong = YES;
        mTrangThaiDanhDauTinDaDoc = NO;
        mDangGuiTinNhan = NO;
        mTrangThaiXoa = NO;
        mViTriBatDauLayTin = 0;
        mSoLuongTinCanLay = 50;
        mDanhSachTinNhan = [[NSMutableArray alloc] init];
        mDanhSachTinNhanCanXoa = [[NSMutableArray alloc] init];
        mMapTinNhanChuaGui = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addButtonBack];
    [self khoiTaoTieuDe];
    [self khoiTaoTextView];
    [self khoiTaoNutGui];
    [self khoiTaoDanhSachTinNhan];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    mRefreshControl = [[UIRefreshControl alloc] init];
    [mRefreshControl addTarget:self action:@selector(suKienRefresh:) forControlEvents:UIControlEventValueChanged];
    [mtbHienThiTinNhan addSubview:mRefreshControl];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - khoi tao
- (void)khoiTaoTextView
{
    mtv.layer.cornerRadius = 7.0f;
    
    mtv.isScrollable = NO;
    mtv.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    mtv.minNumberOfLines = 1;
    mtv.maxNumberOfLines = 4;
    mtv.font = [UIFont systemFontOfSize:17.0f];
    mtv.delegate = self;
    mtv.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    mtv.backgroundColor = [UIColor whiteColor];
    mtv.placeholder = [@"nhap_tin_nhan" localizableString];
}

- (void)khoiTaoNutGui
{
    [mbtnGui setEnabled:NO];
}

- (void)khoiTaoTieuDe
{
//    self.navigationItem.title = self.mNameAlias;
    [self addTitleView:self.mNameAlias];
//    CGRect frame = self.navigationItem.titleView.frame;
//    frame.origin.x = 10;
//    self.navigationItem.titleView.frame = frame;

    [self addButton:@"ic_action_delete" selector:@selector(suKienBamNutXoa) atSide:1];
}

- (void)khoiTaoDanhSachTinNhan
{
    if(!mDanhSachTinNhan)
        mDanhSachTinNhan = [[NSMutableArray alloc] init];
    mDinhDanhKetNoi = DINH_DANH_LAY_DANH_SACH_TIN;
    [[DichVuNotification shareService] dichVuLayDanhSachTinNhanTrongChucNang:self.mFuncID thoiGian:1 viTriBatDau:mViTriBatDauLayTin soLuongTin:mSoLuongTinCanLay nguoiNhan:self.mSendto kieuTimKiem:0 noiNhanKetQua:self];
}

- (void)khoiTaoQueueTinNhanChuaGuiDuoc
{

}

-(float) heightForCellAtIndexPath: (NSIndexPath *) indexPath
{
    CGSize messageSize = [ChatTableViewCell messageSize:[[mDanhSachTinNhan objectAtIndex:mDanhSachTinNhan.count - 1 -indexPath.row] alertContent]];
    CGFloat height = messageSize.height + 2*[ChatTableViewCell textMarginVertical] + 40.0f;
    return height;
}

#pragma mark - HPGrowingTextViewDelegate

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = mviewContainer.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    mviewContainer.frame = r;
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
    if(growingTextView.text.length > 0)
        [mbtnGui setEnabled:YES];
    else
        [mbtnGui setEnabled:NO];
}

#pragma mark - su Kien

- (void)didSelectBackButton
{
    if (mDanhSachTinNhan && mDanhSachTinNhan.count > 0) {
        DoiTuongNotification *doiTuongNotification = [mDanhSachTinNhan objectAtIndex:0];
        mDinhDanhKetNoi = DINH_DANH_XAC_NHAN_TIN_DA_DOC;
        [[DichVuNotification shareService] dichVuDanhDauThoiGianDocTin:[doiTuongNotification.time longLongValue] trongChucNang:self.mFuncID doiTac:self.mSendto noiNhanKetQua:self];
    }
    else{
        [[DichVuNotification shareService] xacNhanDaDocTinTrongChucNang:self.mFuncID];
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] reloadGiaoDienHome];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)suKienBamNutGui:(UIButton *)sender
{
//    DucNT_TaiKhoanViObject *obj = [DucNT_LuuRMS layThongTinTaiKhoanVi];
    DoiTuongNotification *doiTuongNotification = [[DoiTuongNotification alloc] init];
    doiTuongNotification.appId = [NSNumber numberWithInt:APP_ID];
    doiTuongNotification.funcID = [NSNumber numberWithInt:self.mFuncID];
    doiTuongNotification.alertId = @"";
    doiTuongNotification.alertContent = mtv.text;
    doiTuongNotification.alert = [DucNT_LuuRMS layThongTinDangNhap:KEY_NAME_ALIAS];
    NSTimeInterval fCurrentTime = [[NSDate date] timeIntervalSince1970];
    NSString *sCurrentTime = [NSString stringWithFormat:@"%f", fCurrentTime];
    long long nCurrentTime = [sCurrentTime longLongValue] * 1000;
    doiTuongNotification.time = [NSNumber numberWithLongLong:nCurrentTime];

    doiTuongNotification.totalFunc = [NSNumber numberWithInt:0];
    doiTuongNotification.badge = [NSNumber numberWithInt:0];
    doiTuongNotification.sender = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    doiTuongNotification.recipient = self.mSendto;
    doiTuongNotification.nameAlias = self.mNameAlias;
    doiTuongNotification.nameAliasRecipient = self.mNameAlias;
    doiTuongNotification.status = [NSNumber numberWithInt:0];
    doiTuongNotification.mTrangThai = DANG_GUI;

    [mDanhSachTinNhan insertObject:doiTuongNotification atIndex:0];
    [mMapTinNhanChuaGui setObject:doiTuongNotification forKey:sCurrentTime];

    [mtbHienThiTinNhan reloadData];
    [mtv setText:@""];
    
    [self xuLyGuiTinNhan];
    
    [doiTuongNotification release];
}

- (void)suKienCuonXuongDuoiCungCuaTable
{
    if(mDanhSachTinNhan.count > 0 && mDuocPhepCuonXuong)
    {
        if (mtbHienThiTinNhan.contentSize.height > mtbHienThiTinNhan.frame.size.height)
        {
            CGPoint offset = CGPointMake(0, mtbHienThiTinNhan.contentSize.height - mtbHienThiTinNhan.frame.size.height);
            [mtbHienThiTinNhan setContentOffset:offset animated:YES];
        }
    }
}

- (void)suKienSapXepDanhSachTinNhan
{
//    NSSortDescriptor *sortDes = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES];
//   [mDanhSachTinNhan sortUsingDescriptors:@[sortDes]];
    [mtbHienThiTinNhan reloadData];
    [self suKienCuonXuongDuoiCungCuaTable];
}

- (void)suKienCapNhatTableView:(NSInteger)nSoluongRowCanCapNhat
{
    CGPoint tableViewOffset = [mtbHienThiTinNhan contentOffset];
    
    //Turn of animations for the update block
    //to get the effect of adding rows on top of TableView
    [UIView setAnimationsEnabled:NO];
    
    [mtbHienThiTinNhan beginUpdates];
    
    NSMutableArray *rowsInsertIndexPath = [[NSMutableArray alloc] init];
    
    int heightForNewRows = 0;
    
    for (NSInteger i = 0; i < nSoluongRowCanCapNhat; i++) {
        
        NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [rowsInsertIndexPath addObject:tempIndexPath];
        
        heightForNewRows = heightForNewRows + [self heightForCellAtIndexPath:tempIndexPath];
    }
    
    [mtbHienThiTinNhan insertRowsAtIndexPaths:rowsInsertIndexPath withRowAnimation:UITableViewRowAnimationNone];
    
    tableViewOffset.y += heightForNewRows;
    
//    [mtbHienThiTinNhan reloadData];
    [mtbHienThiTinNhan endUpdates];
    
    [UIView setAnimationsEnabled:YES];
    
    [mtbHienThiTinNhan setContentOffset:tableViewOffset animated:NO];

    if(mDuocPhepCuonXuong)
        [self suKienCuonXuongDuoiCungCuaTable];
}

- (void)suKienRefresh:(UIRefreshControl *)refreshControl {

    mDuocPhepCuonXuong = NO;
    [self khoiTaoDanhSachTinNhan];

}

- (void)suKienBamNutXoa
{
    if(mDanhSachTinNhanCanXoa.count > 0)
    {
        //Xoa
        NSMutableArray *arrAlertIdCanXoa = [[NSMutableArray alloc] init];
        for(DoiTuongNotification *doiTuong in mDanhSachTinNhanCanXoa)
        {
//            DoiTuongNotification *doiTuong = [mDanhSachTinNhan objectAtIndex:mDanhSachTinNhan.count - 1 - indexPath.row];

            if(doiTuong.alertId.length > 0)
            {
                [arrAlertIdCanXoa addObject:doiTuong.alertId];
            }
        }
        
        mDinhDanhKetNoi = DINH_DANH_XOA_TIN;
        [[DichVuNotification shareService] dichVuXoaTinNhan:arrAlertIdCanXoa noiNhanKetQua:self];
    }
    else
    {
        mTrangThaiXoa = !mTrangThaiXoa;
        [mtbHienThiTinNhan reloadData];
    }
}

#pragma mark - keyboard notification

- (void)keyboardDidShow: (NSNotification *) notif
{
    // Do something here
    CGRect keyboardBounds;
    [[notif.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notif.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:self.view];
    
    // get a rect for the textView frame
    
    CGRect tbFrame = mtbHienThiTinNhan.frame;
    
    CGRect containerFrame = mviewContainer.frame;
    
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    
    
    tbFrame.size.height = self.view.bounds.size.height - containerFrame.origin.y - 20;
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];


    // set views with new info
    mviewContainer.frame = containerFrame;
    mtbHienThiTinNhan.frame = tbFrame;
    
    // commit animations
    [UIView commitAnimations];
    
    [self suKienCuonXuongDuoiCungCuaTable];
    
}

- (void)keyboardDidHide: (NSNotification *) notif
{
    // Do something here
    NSNumber *duration = [notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notif.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    CGRect tbFrame = mtbHienThiTinNhan.frame;
    
    CGRect containerFrame = mviewContainer.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    
    tbFrame.size.height = self.view.bounds.size.height - containerFrame.size.height;
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    mviewContainer.frame = containerFrame;
    mtbHienThiTinNhan.frame = tbFrame;
    // commit animations
    [UIView commitAnimations];
    
//    [self suKienCuonXuongDuoiCungCuaTable];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(mDanhSachTinNhan)
        return mDanhSachTinNhan.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"messagingCell";

    ChatTableViewCell * cell = (ChatTableViewCell*) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil) {
        cell = [[ChatTableViewCell alloc] initMessagingCellWithReuseIdentifier:cellIdentifier];
    }

    DoiTuongNotification *doiTuongNotification = [mDanhSachTinNhan objectAtIndex:mDanhSachTinNhan.count - 1 -indexPath.row];
    NSString *sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    if(sTaiKhoan.length > 0)
    {
        if([doiTuongNotification.sender isEqualToString:sTaiKhoan])
        {
            cell.sent = NO;
        }
        else
        {
            cell.sent = YES;
        }
        cell.messageLabel.text = doiTuongNotification.alertContent;
        if(doiTuongNotification.alertId.length > 0)
        {
            NSTimeInterval time = [doiTuongNotification.time doubleValue];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:time/1000];
            NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
            NSDateComponents *today = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
            NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
            if([today day] == [otherDay day] &&
               [today month] == [otherDay month] &&
               [today year] == [otherDay year] &&
               [today era] == [otherDay era]) {
                //do stuff
                [dateFormatter setDateFormat:@"HH:mm"];
            }
            else
            {
                [dateFormatter setDateFormat:@"HH:mm - dd/MM"];
            }
            [dateFormatter setLocale:[NSLocale currentLocale]];
            NSString *dateString = [dateFormatter stringFromDate:date];
            cell.timeLabel.text = dateString;
        }
        else if(doiTuongNotification.mTrangThai == DANG_GUI)
        {
            cell.timeLabel.text = [@"dang_gui" localizableString];
        }
        else if(doiTuongNotification.mTrangThai == THAT_BAI)
        {
            cell.timeLabel.text = [@"that_bai" localizableString];
        }
        cell.mDelete = mTrangThaiXoa;
        
//        NSUInteger nViTri = [mDanhSachTinNhanCanXoa indexOfObject:doiTuongNotification];
        
        cell.isChecked = [mDanhSachTinNhanCanXoa containsObject:doiTuongNotification];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize messageSize = [ChatTableViewCell messageSize:[[mDanhSachTinNhan objectAtIndex: mDanhSachTinNhan.count - 1 -indexPath.row ] alertContent]];
    CGFloat height = messageSize.height + 2*[ChatTableViewCell textMarginVertical] + 40.0f;
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!mTrangThaiXoa)
    {
        DoiTuongNotification *doiTuong = [[[mDanhSachTinNhan objectAtIndex:mDanhSachTinNhan.count - 1 -indexPath.row] retain] autorelease];
        if(doiTuong.mTrangThai == THAT_BAI)
        {
            doiTuong.mTrangThai = DANG_GUI;
            [mDanhSachTinNhan removeObjectAtIndex:mDanhSachTinNhan.count - 1 -indexPath.row];
            [mDanhSachTinNhan insertObject:doiTuong atIndex:0];
            [mMapTinNhanChuaGui setObject:doiTuong forKey:[NSString stringWithFormat:@"%@", doiTuong.time]];
            [mtbHienThiTinNhan reloadData];
            [self xuLyGuiTinNhan];
        }
    }
    else
    {
        DoiTuongNotification *doiTuong = [mDanhSachTinNhan objectAtIndex:mDanhSachTinNhan.count - 1 - indexPath.row];
        if(![mDanhSachTinNhanCanXoa containsObject:doiTuong])
        {
            [mDanhSachTinNhanCanXoa addObject:doiTuong];
        }
        else
        {
            [mDanhSachTinNhanCanXoa removeObject:doiTuong];
        }
        [mtbHienThiTinNhan reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - overriden BaseSceen
-(void)didReceiveRemoteNotification:(NSDictionary *)Info
{
    NSLog(@"info:%@: %@, abc", NSStringFromClass([self class]),NSStringFromSelector(_cmd));
    if (self.isViewLoaded && self.view.window)
    {
        // handle the notification
        NSDictionary *userInfo = [Info valueForKey:@"userInfo"];
        if(userInfo)
        {
            mDuocPhepCuonXuong = YES;
            DoiTuongNotification *doiTuongNotification = [[DoiTuongNotification alloc] initWithDict:userInfo];
            if([doiTuongNotification.sender isEqualToString:self.mSendto])
            {
//                [mDanhSachTinNhan addObject:doiTuongNotification];
                [mDanhSachTinNhan insertObject:doiTuongNotification atIndex:0];
                [self suKienSapXepDanhSachTinNhan];
//                mDinhDanhKetNoi = DINH_DANH_XAC_NHAN_TIN_DA_DOC;
//                [[DichVuNotification shareService] dichVuDanhDauThoiGianDocTin:[doiTuongNotification.time longLongValue] trongChucNang:self.mFuncID doiTac:self.mSendto noiNhanKetQua:self];
//                [(AppDelegate*)[[UIApplication sharedApplication] delegate] reloadGiaoDienHome];
                [doiTuongNotification release];
            }
        }
    }
}

#pragma mark - DucNT_ServicePostDelegate

-(void)ketNoiThanhCong:(NSString *)sKetQua
{
    NSDictionary *dicKetQua = [sKetQua objectFromJSONString];
    int nCode = [[dicKetQua objectForKey:@"msgCode"] intValue];
    NSString *message = [dicKetQua objectForKey:@"msgContent"];
    if(nCode == 1)
    {
        if([mDinhDanhKetNoi isEqualToString:DINH_DANH_LAY_DANH_SACH_TIN])
        {
            [mRefreshControl endRefreshing];
            NSArray *results = [dicKetQua objectForKey:@"result"];
            for(NSDictionary *dict in results)
            {
                DoiTuongNotification *doiTuongNotification = [[DoiTuongNotification alloc] initWithDict:dict];
                [mDanhSachTinNhan addObject:doiTuongNotification];
                mViTriBatDauLayTin ++;
                [doiTuongNotification release];
            }
            
            //Danh dau da doc
            if(mDanhSachTinNhan.count > 0)
            {
                if(!mTrangThaiDanhDauTinDaDoc)
                {

                    DoiTuongNotification *doiTuongNotification = [mDanhSachTinNhan objectAtIndex:0];

//                    mDinhDanhKetNoi = DINH_DANH_XAC_NHAN_TIN_DA_DOC;
//                    [[DichVuNotification shareService] dichVuDanhDauThoiGianDocTin:[doiTuongNotification.time longLongValue] trongChucNang:self.mFuncID doiTac:self.mSendto noiNhanKetQua:self];
//                    self.title = doiTuongNotification.nameAliasRecipient;
                    [self addTitleView:doiTuongNotification.nameAliasRecipient];

                }
//                [self suKienSapXepDanhSachTinNhan];
                if(results.count > 0)
                    [self suKienCapNhatTableView:results.count];
            }
        }
        else if([mDinhDanhKetNoi isEqualToString:DINH_DANH_XAC_NHAN_TIN_DA_DOC])
        {
//            mTrangThaiDanhDauTinDaDoc = YES;
            [[DichVuNotification shareService] xacNhanDaDocTinTrongChucNang:self.mFuncID];
            [(AppDelegate*)[[UIApplication sharedApplication] delegate] reloadGiaoDienHome];
            [self.navigationController popViewControllerAnimated:YES];
        }
//        else if ([mDinhDanhKetNoi containsString:DINH_DANH_GUI_TIN_CHAT])
        else if([mDinhDanhKetNoi rangeOfString:DINH_DANH_GUI_TIN_CHAT].location != NSNotFound)
        {
            mDangGuiTinNhan = NO;
            NSDictionary *result = [dicKetQua valueForKey:@"result"];
            NSString *sKey = [mDinhDanhKetNoi stringByReplacingOccurrencesOfString:DINH_DANH_GUI_TIN_CHAT withString:@""];
            [mDinhDanhKetNoi release];
            mDinhDanhKetNoi = nil;
            DoiTuongNotification *doiTuongNotification = [mMapTinNhanChuaGui objectForKey:sKey];
            NSString *alertId = [result valueForKey:@"alertId"];
            if(alertId)
                doiTuongNotification.alertId = alertId;
            NSNumber *time = [result valueForKey:@"time"];
            if(time)
                doiTuongNotification.time = time;
            doiTuongNotification.mTrangThai = DA_GUI;
            [mtbHienThiTinNhan reloadData];
            [self suKienCuonXuongDuoiCungCuaTable];
            
//            mDinhDanhKetNoi = DINH_DANH_XAC_NHAN_TIN_DA_DOC;
//            [[DichVuNotification shareService] dichVuDanhDauThoiGianDocTin:[doiTuongNotification.time longLongValue]
//                                                             trongChucNang:self.mFuncID
//                                                                    doiTac:self.mSendto
//                                                             noiNhanKetQua:self];
            
            //Xoa doi tuong
            [mMapTinNhanChuaGui removeObjectForKey:sKey];
            
            [self xuLyGuiTinNhan];
        }
        else if([mDinhDanhKetNoi isEqualToString:DINH_DANH_XOA_TIN])
        {
            for(DoiTuongNotification *doiTuong in mDanhSachTinNhanCanXoa)
            {
                [mDanhSachTinNhan removeObject:doiTuong];
            }
            [mDanhSachTinNhanCanXoa removeAllObjects];
            [mtbHienThiTinNhan reloadData];
        }
    }
    else
    {
        if([mDinhDanhKetNoi isEqualToString:DINH_DANH_LAY_DANH_SACH_TIN])
        {
            [mRefreshControl endRefreshing];
            [UIAlertView alert:message withTitle:[@"thong_bao" localizableString] block:nil];
        }
        else if ([mDinhDanhKetNoi rangeOfString:DINH_DANH_GUI_TIN_CHAT].location != NSNotFound)
        {
            NSString *sKey = [mDinhDanhKetNoi stringByReplacingOccurrencesOfString:DINH_DANH_GUI_TIN_CHAT withString:@""];
            [mDinhDanhKetNoi release];
            mDinhDanhKetNoi = nil;
            DoiTuongNotification *doiTuongNotification = [mMapTinNhanChuaGui objectForKey:sKey];
            doiTuongNotification.mTrangThai = THAT_BAI;
            //Day ra khoi map
            
            [mtbHienThiTinNhan reloadData];
            [self suKienCuonXuongDuoiCungCuaTable];
            
            mDangGuiTinNhan = NO;
            //Xoa doi tuong
            [mMapTinNhanChuaGui removeObjectForKey:sKey];
            
            [self xuLyGuiTinNhan];
        }
        else if([mDinhDanhKetNoi isEqualToString:DINH_DANH_XOA_TIN])
        {
            
        }
    }
}


#pragma mark - xu ly gui tin

- (void)xuLyGuiTinNhan
{
    if(!mDangGuiTinNhan)
    {
        NSArray *arrKey = [mMapTinNhanChuaGui allKeys];
        NSSortDescriptor *dblDescr= [[NSSortDescriptor alloc] initWithKey:@"doubleValue" ascending:YES];
        NSArray *sortedArray = [arrKey sortedArrayUsingDescriptors:@[dblDescr]];
        if(sortedArray.count > 0)
        {
            mDangGuiTinNhan = YES;
            NSString *sKey = [sortedArray objectAtIndex:0];
            DoiTuongNotification *notificationGui = [mMapTinNhanChuaGui objectForKey:sKey];
            mDinhDanhKetNoi = [[NSString stringWithFormat:@"%@%@", DINH_DANH_GUI_TIN_CHAT, sKey] retain];
            [[DichVuNotification shareService] dichVuChatVoi:notificationGui.recipient tinNhan:notificationGui.alertContent tieuDe:notificationGui.alert chucNang:self.mFuncID noiNhanKetQua:self];
        }
    }
}


#pragma mark - dealloc

- (void)dealloc {
    [_mNameAlias release];
    [_mSendto release];
    [mDanhSachTinNhan release];
    [mMapTinNhanChuaGui release];
    [mRefreshControl release];
    [mDanhSachTinNhanCanXoa release];
    [super dealloc];
}
- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    [mtv release];
    mtv = nil;
    [mbtnGui release];
    mbtnGui = nil;
    [mviewContainer release];
    mviewContainer = nil;
    [mtbHienThiTinNhan release];
    mtbHienThiTinNhan = nil;

    [super viewDidUnload];
}
@end
