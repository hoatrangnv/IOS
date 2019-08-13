//
//  HienThiChatTongViewController.m
//  ViMASS
//
//  Created by DucBT on 10/30/14.
//
//

#import "HienThiChatTongViewController.h"
#import "HienThiChatTongTableViewCell.h"
#import "DichVuNotification.h"
#import "Common.h"
#import "DanhSachNguoiDangChatViewController.h"
#import "DucNT_LoginSceen.h"

@interface HienThiChatTongViewController () <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *mtbHienThi;
    
}

@end

@implementation HienThiChatTongViewController

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addButtonBack];
//    self.navigationItem.title = [@"lich_su_giao_dich" localizableString];
    [self addTitleView:[@"lich_su_giao_dich" localizableString]];

}

#pragma mark - handler error
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"HienThiChatTongCellIdentifier";
    HienThiChatTongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HienThiChatTongTableViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    NSString *sAnhDaiDien = @"";
    NSString *sHexColor = @"";
    NSString *sTieuDe = @"";
    int nSoLuongTinChuaDoc = 0;
    if(indexPath.row == 2)
    {
        sAnhDaiDien = @"home_icon_title_bds_white";
        sTieuDe = [@"tin_bat_dong_san" localizableString];
        sHexColor = @"#BE5FD9";
        nSoLuongTinChuaDoc = [[DichVuNotification shareService] laySoLuongTinChuaDocTrongChucNang:TIN_CHAT_BDS];
    }
    else if (indexPath.row == 3)
    {
        sAnhDaiDien = @"home_icon_title_viec_lam_white";
        sTieuDe = [@"tin_viec_lam" localizableString];
        sHexColor = @"#43ab38";
        nSoLuongTinChuaDoc = [[DichVuNotification shareService] laySoLuongTinChuaDocTrongChucNang:TIN_CHAT_VIEC_LAM];
    }
    else if(indexPath.row == 4)
    {
        sAnhDaiDien = @"home_icon_title_tim_viec_white";
        sTieuDe = [@"tin_tim_viec" localizableString];
        sHexColor = @"#7b7b78";
        nSoLuongTinChuaDoc = [[DichVuNotification shareService] laySoLuongTinChuaDocTrongChucNang:TIN_CHAT_TIM_VIEC];
    }
    else if (indexPath.row == 1)
    {
        sAnhDaiDien = @"home_icon_title_rao_vat_white";
        sTieuDe = [@"tin_rao_vat" localizableString];
        sHexColor = @"#2691c7";
        nSoLuongTinChuaDoc = [[DichVuNotification shareService] laySoLuongTinChuaDocTrongChucNang:TIN_CHAT_RAO_VAT];
    }
    else if (indexPath.row == 0)
    {
        sAnhDaiDien = @"home_icon_title_thuong_mai_white";
        sTieuDe = [@"tin_thuong_mai" localizableString];
        sHexColor = @"#ff9305";
        nSoLuongTinChuaDoc = [[DichVuNotification shareService] laySoLuongTinChuaDocTrongChucNang:TIN_CHAT_THUONG_MAI];
    }
    
    cell.mimgvDaiDien.image = [UIImage imageNamed:sAnhDaiDien];
    cell.contentView.backgroundColor = [UIColor colorWithHexString:sHexColor];
    cell.mlblTieuDe.text = sTieuDe;
    if(nSoLuongTinChuaDoc > 0)
    {
        [cell.mlblBadgeNumber setHidden:NO];
        [cell.mlblBadgeNumber setText:[NSString stringWithFormat:@"%d", nSoLuongTinChuaDoc]];
    }
    else
    {
        [cell.mlblBadgeNumber setHidden:YES];
    }
    
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int nFuncID = -1;
    if(indexPath.row == 0)
    {
        nFuncID = TIN_CHAT_THUONG_MAI;
    }
    else if (indexPath.row == 1)
    {
        nFuncID = TIN_CHAT_RAO_VAT;
    }
    else if(indexPath.row == 2)
    {
        nFuncID = TIN_CHAT_BDS;
    }
    else if (indexPath.row == 3)
    {
        nFuncID = TIN_CHAT_VIEC_LAM;
    }
    else if (indexPath.row == 4)
    {
        nFuncID = TIN_CHAT_TIM_VIEC;
    }
    NSString *sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    if(sTaiKhoan.length > 0)
    {
        DanhSachNguoiDangChatViewController *danhSachNguoiDangChatViewController = [[DanhSachNguoiDangChatViewController alloc] initWithNibName:@"DanhSachNguoiDangChatViewController" bundle:nil];
        danhSachNguoiDangChatViewController.mFuncID = nFuncID;
        [self.navigationController pushViewController:danhSachNguoiDangChatViewController animated:YES];
        [danhSachNguoiDangChatViewController release];
    }
    else
    {
        DucNT_LoginSceen *login = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
//        [self presentModalViewController:login animated:YES];
        [self presentViewController:login animated:YES completion:^{}];
        [login release];
    }
}

#pragma mark - overriden baseScreen

- (void)reloadGiaoDien:(NSNotification *)notification
{
    [mtbHienThi reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (void)dealloc {
    [super dealloc];
}
- (void)viewDidUnload {
    [mtbHienThi release];
    mtbHienThi = nil;
    [super viewDidUnload];
}
@end
