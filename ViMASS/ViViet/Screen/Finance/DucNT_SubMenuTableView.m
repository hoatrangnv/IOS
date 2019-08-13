//
//  DucNT_SubMenuTableView.m
//  ViMASS
//
//  Created by DucBT on 10/8/14.
//
//

#import "DucNT_SubMenuTableView.h"
#import "DucNT_FinanceItemCell.h"
#import "SubItemTaiChinh.h"

@implementation DucNT_SubMenuTableView
static NSString *cellSubItemIdentifier = @"cellSubItemIdentifier";
#pragma mark - init
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self _init];
    }
    return self;
}

- (void)_init
{
    [self registerNib:[UINib nibWithNibName:@"DucNT_FinanceItemCell" bundle:nil] forCellReuseIdentifier:cellSubItemIdentifier];
    self.delegate = self;
    self.dataSource = self;
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(_mDanhSachSubItem)
        return [_mDanhSachSubItem count];
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    DucNT_FinanceItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellSubItemIdentifier];
    
    if (cell == nil) {
        cell = [[DucNT_FinanceItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellSubItemIdentifier];
    }
    SubItemTaiChinh *item = [_mDanhSachSubItem objectAtIndex:indexPath.row];
    [cell setBackgroundColor:[UIColor blackColor]];
    cell.lbItem.textColor = [UIColor whiteColor];
    cell.lbItem.text = [item.mTieuDe localizableString] ;

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self deselectRowAtIndexPath:indexPath animated:YES];
    if(_mDanhSachSubItem)
    {
        SubItemTaiChinh *item = [_mDanhSachSubItem objectAtIndex:indexPath.row];
        
        if([self.mDelegate respondsToSelector:@selector(suKienChonSubMenuItemTaiChinh:)])
        {
            [self.mDelegate suKienChonSubMenuItemTaiChinh:item];
        }
    }
//    DucNT_ItemSubMenuTaiChinh *item = [dsSubMenu objectAtIndex:indexPath.row];
//    bool bDaDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue];
//    if(bDaDangNhap)
//    {
//        if([item.sTenItem isEqualToString:@"token"])
//        {
//            /*Kiểm tra xem đã có token chưa -> chưa có thì vào đăng ký
//             * còn có rồi thì vào giao diện kiểm tra tiếp bên trong
//             */
//            NSString *sKQ = [[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_TRANG_THAI_CO_TOKEN] intValue];
//            if(sKQ != 0)
//                [self callViewControllerFromString:item.sViewControllerItem withMode:item.sKieuHienThi];
//            else
//            {
//                DucNT_DangKyToken *vc = [[DucNT_DangKyToken alloc] init];
//                [self.navigationController pushViewController:vc animated:YES];
//                [vc release];
//            }
//        }
//        else
//        {
//            [self callViewControllerFromString:item.sViewControllerItem withMode:item.sKieuHienThi];
//        }
//    }
//    else
//    {
//        DucNT_LoginSceen *ctrl = [[DucNT_LoginSceen alloc] init];
//        ctrl.sTenViewController = item.sViewControllerItem;
//        ctrl.sKieuChuyenGiaoDien = item.sKieuHienThi;
//        [self.navigationController presentModalViewController:ctrl animated:YES];
//        [ctrl release];
//    }
}

- (void)dealloc
{
    [_mDanhSachSubItem release];
    [super dealloc];
}

@end
