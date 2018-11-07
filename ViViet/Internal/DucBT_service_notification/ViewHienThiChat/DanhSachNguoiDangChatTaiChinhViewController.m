//
//  DanhSachNguoiDangChatTaiChinhViewController.m
//  ViViMASS
//
//  Created by DucBui on 7/21/15.
//
//

#import "DanhSachNguoiDangChatTaiChinhViewController.h"
#import "DanhSachNguoiChatTableViewCell.h"
#import "HienThiChatViewController.h"
#import "ContactChat.h"
#import "DichVuNotification.h"
#import "ViewDoiTenGiaoDich.h"
#import "ContactScreen.h"

@interface DanhSachNguoiDangChatTaiChinhViewController () <ViewDoiTenGiaoDichDelegate, DucNT_ServicePostDelegate, UIScrollViewDelegate>


@property (nonatomic, assign) BOOL mDangHienThiViewDoiTenGiaoDich;
@property (nonatomic, retain) ViewDoiTenGiaoDich *mViewDoiTenGiaoDich;
@property (nonatomic, assign) NSInteger mFuncID;
@property (nonatomic, retain) NSArray *mDanhSachNguoiDangChat;
@property (nonatomic, retain) NSString *mDinhDanhGiaoDich;
@end

@implementation DanhSachNguoiDangChatTaiChinhViewController


#pragma mark - overriden BaseSceen

- (void)didSelectBackButton
{
    if(self.mDangHienThiViewDoiTenGiaoDich)
    {
        [self suKienBamNutSetting:nil];
        return;
    }
    [super didSelectBackButton];
}

-(void)didReceiveRemoteNotification:(NSDictionary *)Info
{
    if (self.isViewLoaded && self.view.window)
    {
        [self khoiTaoDanhSachNguoiChat];
    }
}

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self khoiTaoBanDau];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - khoiTao

- (void)khoiTaoBanDau
{
    self.mFuncID = TIN_CHAT_TAI_CHINH;
    [self khoiTaoThanhBar];
    [self khoiTaoViewDoiTenGiaoDich];
    [self khoiTaoLabelXinChao];
    [self khoiTaoViewDoiTenGiaoDich];
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"DanhSachNguoiDangChatTaiChinhViewController : viewWillAppear : ======> START");
    [self khoiTaoViewThongBaoChuaCoGiaoDich];
    [self khoiTaoDanhSachNguoiChat];
}

- (void)khoiTaoViewDoiTenGiaoDich
{
    self.mViewDoiTenGiaoDich = [[[NSBundle mainBundle] loadNibNamed:@"ViewDoiTenGiaoDich" owner:self options:nil] objectAtIndex:0];
    
    CGRect viewDoiTenGiaoDichFrame = self.mViewDoiTenGiaoDich.frame;
    viewDoiTenGiaoDichFrame = self.mtbHienThiDanhSach.frame;
    viewDoiTenGiaoDichFrame.origin.y = _mlblXinChao.frame.origin.y;
    viewDoiTenGiaoDichFrame.size.height = self.mtbHienThiDanhSach.frame.size.height + _mlblXinChao.frame.size.height;
    self.mViewDoiTenGiaoDich.frame = viewDoiTenGiaoDichFrame;
    self.mViewDoiTenGiaoDich.hidden = YES;
    self.mViewDoiTenGiaoDich.mDelegate = self;
    [self.view addSubview:self.mViewDoiTenGiaoDich];
}

- (void)khoiTaoLabelXinChao
{
    NSString *sNameAlias = [DucNT_LuuRMS layThongTinDangNhap:KEY_NAME_ALIAS];
//    if(sNameAlias.length <= 4)
//    {
//        sNameAlias = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
//        int nStart = 7, nLength = 4;
//        if(sNameAlias.length == 10)
//        {
//            nStart = 6;
//        }
//        NSRange range = NSMakeRange(nStart, nLength);
//        NSString *sNoiDungThayThe = @"xxxx";
//        sNameAlias = [sNameAlias stringByReplacingCharactersInRange:range withString:sNoiDungThayThe];
//    }
    [self.mlblXinChao setText:[NSString stringWithFormat:@"%@: %@", [@"xin_chao" localizableString], sNameAlias]];
}

- (void)khoiTaoDanhSachNguoiChat
{
    self.mDinhDanhGiaoDich = DINH_DANH_LAY_DANH_SACH_GIAO_DICH;
    if (_mDanhSachNguoiDangChat) {
        _mDanhSachNguoiDangChat = nil;
        [_mDanhSachNguoiDangChat release];
    }
    [[DichVuNotification shareService] dichVuLayDanhSachNguoiChatTrongChucNang:TIN_CHAT_TAI_CHINH noiNhanKetQua:self];
}

- (void)khoiTaoViewThongBaoChuaCoGiaoDich
{
    [self.mViewThongBaoChuaCoGiaoDich setHidden:YES];
    [self.mlblThongBaoChuaCoGiaoDich setText:[@"thong_bao_chua_co_giao_dich" localizableString]];
    self.mlblThongBaoChuaCoGiaoDich.numberOfLines = 0;
}

- (void)khoiTaoThanhBar
{
    [self addButtonBack];
    [self addTitleView:@"Trò chuyện"];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 36, 36);
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(suKienBamNutSetting:) forControlEvents:UIControlEventTouchUpInside];
    
    [button setImage:[UIImage imageNamed:@"setting-bar-button"] forState:UIControlStateNormal];
    button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    
    UIBarButtonItem *rightItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if (SYSTEM_VERSION_LESS_THAN(@"7"))
        negativeSeperator.width = -5;
    else
        negativeSeperator.width = -16;
    
    UIButton * button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(0, 0, 32, 32);
    button2.backgroundColor = [UIColor clearColor];
    [button2 addTarget:self action:@selector(suKienBamNutDanhBa:) forControlEvents:UIControlEventTouchUpInside];
    
    [button2 setImage:[UIImage imageNamed:@"icon_danhba_chat"] forState:UIControlStateNormal];
    button2.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    UIBarButtonItem *rightItem2 = [[[UIBarButtonItem alloc] initWithCustomView:button2] autorelease];
    self.navigationItem.rightBarButtonItems = @[negativeSeperator, rightItem, rightItem2];

}


#pragma mark - suKien
- (IBAction)suKienBamNutChonNguoiChat:(id)sender {
    [self.mtfChonVi resignFirstResponder];
    HienThiChatViewController *hienThiChat = [[HienThiChatViewController alloc] initWithNibName:@"HienThiChatViewController" bundle:nil];
    hienThiChat.mSendto = _mtfChonVi.text;
    hienThiChat.mFuncID = TIN_CHAT_TAI_CHINH;
    hienThiChat.mNameAlias = _mtfChonVi.text;
    hienThiChat.mThoiGianChatCuoiCung = 0;
    [self.navigationController pushViewController:hienThiChat animated:YES];
    [hienThiChat release];
}

- (void)suKienBamNutSetting:(id)sender
{
    if(_mDangHienThiViewDoiTenGiaoDich)
    {
        _mDangHienThiViewDoiTenGiaoDich = NO;
        [self.mViewDoiTenGiaoDich.mtfMatKhau resignFirstResponder];
        [self.mViewDoiTenGiaoDich.mtfTenGiaoDich resignFirstResponder];
        self.mViewDoiTenGiaoDich.hidden = YES;
        
    }
    else
    {
        _mDangHienThiViewDoiTenGiaoDich = YES;
        NSString *sNameAlias = [DucNT_LuuRMS layThongTinDangNhap:KEY_NAME_ALIAS];
        self.mViewDoiTenGiaoDich.mtfTenGiaoDich.text = sNameAlias;
        self.mViewDoiTenGiaoDich.mtfMatKhau.text = @"";
        [self.mViewDoiTenGiaoDich.mtfTenGiaoDich becomeFirstResponder];
        self.mViewDoiTenGiaoDich.hidden = NO;
    }
}

- (void)suKienBamNutDanhBa:(id)sender
{
    if(self.mDangHienThiViewDoiTenGiaoDich)
    {
        [self suKienBamNutSetting:nil];
    }
    ContactScreen *danhBa = [[[ContactScreen alloc] initWithNibName:@"ContactScreen" bundle:nil] autorelease];
    danhBa.mKieuHienThiLienHe = KIEU_HIEN_THI_LIEN_HE_THUONG;
    [self.navigationController pushViewController:danhBa animated:YES];
    __block DanhSachNguoiDangChatTaiChinhViewController *weakSelf = self;
    [danhBa selectContact:^(NSString *phone,Contact *contact)
     {
         if (phone != nil && phone.length > 0)
         {
             if([Common kiemTraLaMail:phone])
             {
                 weakSelf.mtfChonVi.text = phone;
             }
             else
             {
                 weakSelf.mtfChonVi.text = [phone stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [phone length])];
             }
         }
         [danhBa.navigationController popViewControllerAnimated:YES];
     }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_mDanhSachNguoiDangChat)
        return _mDanhSachNguoiDangChat.count;
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"DanhSachNguoiChatTableViewCellIdentifier";
    DanhSachNguoiChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DanhSachNguoiChatTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    
    ContactChat *contactChat = [_mDanhSachNguoiDangChat objectAtIndex:indexPath.row];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:contactChat.mTime / 1000];
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
    cell.mlblThoiGianTinCuoi.text = dateString;
    cell.mlblThoiGianTinCuoi.textColor = [UIColor blueColor];
    cell.mlblTen.text = contactChat.nameAlias;
    if([contactChat.slTinChuaDoc intValue] > 0)
    {
        cell.mlblTen.textColor = [UIColor redColor];
    }
    else
    {
        cell.mlblTen.textColor = [UIColor blueColor];
    }
    if([contactChat.slTinChuaDoc intValue] > 0)
    {
        cell.mlblTinNhanCuoi.font = [UIFont boldSystemFontOfSize:14.0f];
    }
    else
    {
        cell.mlblTinNhanCuoi.font = [UIFont italicSystemFontOfSize:14.0f];
    }
    cell.mlblTinNhanCuoi.text = contactChat.mess;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        //        Notification *notification = [mDanhSachNguoiChat objectAtIndex:indexPath.row];
        //        NSError *err = [[DucBT_Notification_Service shareService] xoaNotification:notification];
        //        if(!err)
        //        {
        //            [mDanhSachNguoiChat removeObjectAtIndex:indexPath.row];
        //            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        //            [tableView reloadData];
        //        }
        //        else
        //        {
        //            [UIAlertView alert:err.localizedDescription withTitle:[@"thong_bao" localizableString] block:nil];
        //        }
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    ContactChat *contactChat = [_mDanhSachNguoiDangChat objectAtIndex:indexPath.row];
    HienThiChatViewController *hienThiChat = [[HienThiChatViewController alloc] initWithNibName:@"HienThiChatViewController" bundle:nil];
    hienThiChat.mSendto = contactChat.idChat;
    hienThiChat.mFuncID = TIN_CHAT_TAI_CHINH;
    hienThiChat.mNameAlias = contactChat.nameAlias;
    hienThiChat.mThoiGianChatCuoiCung = contactChat.mTime;
    [self.navigationController pushViewController:hienThiChat animated:YES];
    [hienThiChat release];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - ViewDoiTenGiaoDichDelegate
- (void)suKienThayDoiThanhCongTenGiaoDich
{
    _mDangHienThiViewDoiTenGiaoDich = NO;
    self.mViewDoiTenGiaoDich.hidden = YES;
    [self khoiTaoLabelXinChao];
}

#pragma mark - DucNT_ServicePostDelegate

- (void)ketNoiThanhCong:(NSString *)sKetQua
{
    NSDictionary *dicKetQua = [sKetQua objectFromJSONString];
    int nCode = [[dicKetQua objectForKey:@"msgCode"] intValue];
    NSString *message = [dicKetQua objectForKey:@"msgContent"];
    if(nCode == 1)
    {
        if([self.mDinhDanhGiaoDich isEqualToString:DINH_DANH_LAY_DANH_SACH_GIAO_DICH])
        {
            NSArray *results = [dicKetQua valueForKey:@"result"];
            NSMutableArray *arrTemp = [[NSMutableArray alloc] init];
            for (NSDictionary *result in results)
            {
                ContactChat *contactChat = [[ContactChat alloc] initWithDict:result];
                [arrTemp addObject:contactChat];
                [contactChat release];
            }
            NSSortDescriptor *sortDescription = [NSSortDescriptor sortDescriptorWithKey:@"mTime" ascending:NO];
            NSArray *danhSachSauSort = [arrTemp sortedArrayUsingDescriptors:@[sortDescription]];
            NSLog(@"DanhSachNguoiDangChatTaiChinhViewController : ketNoiThanhCong : danhSachSauSort.count : %ld", (unsigned long)danhSachSauSort.count);
            self.mDanhSachNguoiDangChat = danhSachSauSort;
            if(_mDanhSachNguoiDangChat.count > 0)
            {
                [self.mViewThongBaoChuaCoGiaoDich setHidden:YES];
                [self.mtbHienThiDanhSach reloadData];
            }
            else
            {
                [self.mViewThongBaoChuaCoGiaoDich setHidden:NO];
            }
            
        }
    }
    else
    {
        [UIAlertView alert:message withTitle:[@"thong_bao" localizableString] block:nil];
    }
}


#pragma mark - dealloc
- (void)dealloc {
    if(_mDanhSachNguoiDangChat)
        [_mDanhSachNguoiDangChat release];
    [_mlblXinChao release];
    [_mtfChonVi release];
    [_mbtnChonVi release];
    [_mtbHienThiDanhSach release];
    [_mViewThongBaoChuaCoGiaoDich release];
    [_mlblThongBaoChuaCoGiaoDich release];
    [super dealloc];
}
@end
