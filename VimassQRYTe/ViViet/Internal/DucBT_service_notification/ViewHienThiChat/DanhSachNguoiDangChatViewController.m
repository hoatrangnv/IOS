//
//  DanhSachNguoiDangChatViewController.m
//  ViMASS
//
//  Created by DucBT on 10/1/14.
//
//

#import "DanhSachNguoiDangChatViewController.h"
#import "DanhSachNguoiChatTableViewCell.h"
#import "HienThiChatViewController.h"
#import "DichVuNotification.h"
#import "DoiTuongNotification.h"
#import "ContactChat.h"
#import "ViewDoiTenGiaoDich.h"

@interface DanhSachNguoiDangChatViewController () <UITableViewDataSource, UITableViewDelegate, DucNT_ServicePostDelegate, ViewDoiTenGiaoDichDelegate>
{
    NSMutableArray *mDanhSachNguoiChat;
    IBOutlet UITableView *mtbHienThiDanhSachNguoiChat;
    NSString *mDinhDanhGiaoDich;
    BOOL mDangHienThiViewDoiTenGiaoDich;
    ViewDoiTenGiaoDich *mViewDoiTenGiaoDich;
    IBOutlet UIView *mViewThongBaoChuaCoGiaoDich;
    IBOutlet UILabel *mlblThongBaoChuaCoGiaoDich;
}

@end

@implementation DanhSachNguoiDangChatViewController

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    mDangHienThiViewDoiTenGiaoDich = NO;
    NSLog(@"DanhSachNguoiDangChatViewController : viewDidLoad : START");
    [self khoiTaoThanhTieuDe];
    [self khoiTaoViewDoiTenGiaoDich];
    [self khoiTaoLabelXinChao];
    [self khoiTaoViewThongBaoChuaCoGiaoDich];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self khoiTaoDanhSachNguoiChat];
}

#pragma mark - handler error
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}


#pragma mark - khoi tao

- (void)khoiTaoThanhTieuDe
{
    [self addBackButton:YES];
    NSString *sTieuDe = @"";
    if(self.mFuncID == TIN_CHAT_RAO_VAT)
    {
        sTieuDe = [NSString stringWithFormat:@"%@ %@", [@"lich_su_giao_dich" localizableString], [@"tin_rao_vat" localizableString]];
    }
    else if(self.mFuncID == TIN_CHAT_VIEC_LAM)
    {
        sTieuDe = [NSString stringWithFormat:@"%@ %@", [@"lich_su_giao_dich" localizableString], [@"tin_viec_lam" localizableString]];
    }
    else if(self.mFuncID == TIN_CHAT_BDS)
    {
        sTieuDe = [NSString stringWithFormat:@"%@ %@", [@"lich_su_giao_dich" localizableString], [@"tin_bat_dong_san" localizableString]];
    }
    else if(self.mFuncID == TIN_CHAT_TIM_VIEC)
    {
        sTieuDe = [NSString stringWithFormat:@"%@ %@", [@"lich_su_giao_dich" localizableString], [@"tin_tim_viec" localizableString]];
    }
    else if(self.mFuncID == TIN_CHAT_THUONG_MAI)
    {
        sTieuDe = [NSString stringWithFormat:@"%@ %@", [@"lich_su_giao_dich" localizableString], [@"tin_thuong_mai" localizableString]];
    }
//    self.navigationItem.title = sTieuDe;
    [self addTitleView:sTieuDe];
    [self addSettingButton];
}

- (void)khoiTaoLabelXinChao
{
//    NSString *sNameAlias = [DucNT_LuuRMS layThongTinDangNhap:KEY_NAME_ALIAS];
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
//    [self.mlblXinChao setText:[NSString stringWithFormat:@"%@: %@", [@"xin_chao" localizableString], sNameAlias]];
}

- (void)khoiTaoDanhSachNguoiChat
{
    if(!mDanhSachNguoiChat)
        mDanhSachNguoiChat = [[NSMutableArray alloc] init];
    else
        [mDanhSachNguoiChat removeAllObjects];
    
    mDinhDanhGiaoDich = DINH_DANH_LAY_DANH_SACH_GIAO_DICH;
    [[DichVuNotification shareService] dichVuLayDanhSachNguoiChatTrongChucNang:self.mFuncID noiNhanKetQua:self];
}

- (void)khoiTaoViewDoiTenGiaoDich
{
    mViewDoiTenGiaoDich = [[[NSBundle mainBundle] loadNibNamed:@"ViewDoiTenGiaoDich" owner:self options:nil] objectAtIndex:0];
    
    CGRect viewDoiTenGiaoDichFrame = mViewDoiTenGiaoDich.frame;
    viewDoiTenGiaoDichFrame = mtbHienThiDanhSachNguoiChat.frame;
    viewDoiTenGiaoDichFrame.origin.y = _mlblXinChao.frame.origin.y;
    viewDoiTenGiaoDichFrame.size.height = mtbHienThiDanhSachNguoiChat.frame.size.height + _mlblXinChao.frame.size.height;
    mViewDoiTenGiaoDich.frame = viewDoiTenGiaoDichFrame;
    mViewDoiTenGiaoDich.hidden = YES;
    mViewDoiTenGiaoDich.mDelegate = self;
    [self.view addSubview:mViewDoiTenGiaoDich];
}

- (void)khoiTaoViewThongBaoChuaCoGiaoDich
{
    [mViewThongBaoChuaCoGiaoDich setHidden:YES];
    [mlblThongBaoChuaCoGiaoDich setText:[@"thong_bao_chua_co_giao_dich" localizableString]];
    mlblThongBaoChuaCoGiaoDich.numberOfLines = 0;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(mDanhSachNguoiChat)
        return mDanhSachNguoiChat.count;
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
    
    ContactChat *contactChat = [mDanhSachNguoiChat objectAtIndex:indexPath.row];
    
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
    ContactChat *contactChat = [mDanhSachNguoiChat objectAtIndex:indexPath.row];
    HienThiChatViewController *hienThiChat = [[HienThiChatViewController alloc] initWithNibName:@"HienThiChatViewController" bundle:nil];
    hienThiChat.mSendto = contactChat.idChat;
    hienThiChat.mFuncID = self.mFuncID;
    hienThiChat.mNameAlias = contactChat.nameAlias;
    hienThiChat.mThoiGianChatCuoiCung = contactChat.mTime;
    [self.navigationController pushViewController:hienThiChat animated:YES];
    [hienThiChat release];
}


#pragma mark - DucNT_ServicePostDelegate

- (void)ketNoiThanhCong:(NSString *)sKetQua
{
    NSDictionary *dicKetQua = [sKetQua objectFromJSONString];
    int nCode = [[dicKetQua objectForKey:@"msgCode"] intValue];
    NSString *message = [dicKetQua objectForKey:@"msgContent"];
    if(nCode == 1)
    {
        if([mDinhDanhGiaoDich isEqualToString:DINH_DANH_LAY_DANH_SACH_GIAO_DICH])
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
            [mDanhSachNguoiChat addObjectsFromArray:danhSachSauSort];
            if(mDanhSachNguoiChat.count > 0)
            {
                [mViewThongBaoChuaCoGiaoDich setHidden:YES];
                [mtbHienThiDanhSachNguoiChat reloadData];
            }
            else
            {
                [mViewThongBaoChuaCoGiaoDich setHidden:NO];
            }

        }
    }
    else
    {
        [UIAlertView alert:message withTitle:[@"thong_bao" localizableString] block:nil];
    }
}

#pragma mark - ViewDoiTenGiaoDichDelegate
- (void)suKienThayDoiThanhCongTenGiaoDich
{
    mDangHienThiViewDoiTenGiaoDich = NO;
    mViewDoiTenGiaoDich.hidden = YES;
    [self khoiTaoLabelXinChao];
}

#pragma mark - private

- (void)reload
{


}

#pragma mark - overriden BaseSceen

- (void)didSelectBackButton
{
    if(mDangHienThiViewDoiTenGiaoDich)
    {
        [self didSelectSetting];
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

- (void)didSelectSetting
{
    if(mDangHienThiViewDoiTenGiaoDich)
    {
        mDangHienThiViewDoiTenGiaoDich = NO;
        [mViewDoiTenGiaoDich.mtfMatKhau resignFirstResponder];
        [mViewDoiTenGiaoDich.mtfTenGiaoDich resignFirstResponder];
        mViewDoiTenGiaoDich.hidden = YES;
        
    }
    else
    {
        mDangHienThiViewDoiTenGiaoDich = YES;
        NSString *sNameAlias = [DucNT_LuuRMS layThongTinDangNhap:KEY_NAME_ALIAS];
        mViewDoiTenGiaoDich.mtfTenGiaoDich.text = sNameAlias;
        mViewDoiTenGiaoDich.mtfMatKhau.text = @"";
        [mViewDoiTenGiaoDich.mtfTenGiaoDich becomeFirstResponder];
        mViewDoiTenGiaoDich.hidden = NO;
    }
}

#pragma mark - dealloc

- (void)dealloc
{
    [mDanhSachNguoiChat release];
    [_mlblXinChao release];
    [mViewThongBaoChuaCoGiaoDich release];
    [mlblThongBaoChuaCoGiaoDich release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [mtbHienThiDanhSachNguoiChat setEditing:NO];
    [mtbHienThiDanhSachNguoiChat release];
    mtbHienThiDanhSachNguoiChat = nil;
    [self setMlblXinChao:nil];
    [mViewThongBaoChuaCoGiaoDich release];
    mViewThongBaoChuaCoGiaoDich = nil;
    [mlblThongBaoChuaCoGiaoDich release];
    mlblThongBaoChuaCoGiaoDich = nil;
    [super viewDidUnload];
}
@end
