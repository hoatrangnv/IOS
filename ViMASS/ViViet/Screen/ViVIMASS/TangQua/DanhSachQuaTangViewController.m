//
//  DanhSachQuaTangViewController.m
//  ViViMASS
//
//  Created by DucBT on 2/27/15.
//
//

#import "DanhSachQuaTangViewController.h"
#import "ChiTietTangQuaViewController.h"
#import "ChiTietTangQuaTheDienThoaiViewController.h"
#import "ItemQuaTang.h"
#import "ViewQuaTang.h"
#import "GiaoDienThongTinPhim.h"
#import "DucNT_DanhSachTaiKhoanThuongDungControllerViewController.h"

@interface DanhSachQuaTangViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSString *toAccWallet;
}

@property (retain, nonatomic) IBOutlet UITableView *mtbHienThi;
@property (retain, nonatomic) NSArray *mDanhSachViewQuaTang;

@end

@implementation DanhSachQuaTangViewController

#pragma mark - life circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self khoiTaoBanDau];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - khoiTao

- (void)khoiTaoBanDau
{
    [self addButtonBack];
//    self.navigationItem.title = [@"tang_qua" localizableString];
    [self addTitleView:[@"tang_qua" localizableString]];
    [self xuLyKetNoiLayDanhSachQuaTang];
    toAccWallet = @"";

    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 34, 34);
    [button setImage:[UIImage imageNamed:@"hdsd-icon"]forState:UIControlStateNormal];

    button.backgroundColor = [UIColor clearColor];
    button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [button addTarget:self action:@selector(suKienBamNutHuongDanGiaoDichViewController:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *leftItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];

    UIButton * button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(0, 0, 34, 32);
    [button2 setImage:[UIImage imageNamed:@"iconSoTay.png"]forState:UIControlStateNormal];

    button2.backgroundColor = [UIColor clearColor];
    button2.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [button2 addTarget:self action:@selector(suKienBamNutSoTayQuaTang:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *leftItem2 = [[[UIBarButtonItem alloc] initWithCustomView:button2] autorelease];

    UIBarButtonItem *negativeSeperator = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];

    if (SYSTEM_VERSION_LESS_THAN(@"11"))
        negativeSeperator.width = -10;
    else {
        negativeSeperator.width = -15;
        [button.widthAnchor constraintEqualToConstant:34].active = YES;
        [button.heightAnchor constraintEqualToConstant:34].active = YES;
        [button2.widthAnchor constraintEqualToConstant:34].active = YES;
        [button2.heightAnchor constraintEqualToConstant:34].active = YES;
    }

    self.navigationItem.rightBarButtonItems = @[negativeSeperator, leftItem, leftItem2];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateThongTinQuaTang:) name:KEY_TAI_KHOAN_THUONG_DUNG object:nil];
    
    [self.mtbHienThi registerNib:[UINib nibWithNibName:@"ViewQuaTang" bundle:nil] forCellReuseIdentifier:@"ViewQuaTang"];
}

-(void)updateThongTinQuaTang:(NSNotification *)notification {
    if([[notification name] isEqualToString:KEY_TAI_KHOAN_THUONG_DUNG])
    {
        DucNT_TaiKhoanThuongDungObject *temp = [notification object];
        NSLog(@"%s - temp.idIcon : %d", __FUNCTION__, temp.idIcon);
        if (_mDanhSachViewQuaTang && _mDanhSachViewQuaTang.count > 0) {
            toAccWallet = temp.sToAccWallet;
            int indexQuaTang = 0;
            Boolean bTimThay = NO;
            for (ViewQuaTang *viewQuaTang in _mDanhSachViewQuaTang) {
                NSLog(@"%s - viewQuaTang.mItemQuaTang.mId : %d", __FUNCTION__, [viewQuaTang.mItemQuaTang.mId intValue]);
                if ([viewQuaTang.mItemQuaTang.mId intValue] == temp.idIcon) {
                    viewQuaTang.mItemQuaTang.mAmount.content = [NSString stringWithFormat:@"%d", temp.soTien];
                    NSLog(@"%s - viewQuaTang.mItemQuaTang.mAmount.content : %@", __FUNCTION__, viewQuaTang.mItemQuaTang.mAmount.content);
                    viewQuaTang.mItemQuaTang.mMessage.content = temp.noiDung;
                    viewQuaTang.mItemQuaTang.mName.content = temp.giftName;
                    bTimThay = YES;
                    break;
                }
                indexQuaTang ++;
            }
            if (!bTimThay) {
                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Không tìm thấy chi tiết quà tặng"];
                return;
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self tableView:self.mtbHienThi didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:indexQuaTang inSection:0]];
            });

//            [self tableView:self.mtbHienThi didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:indexQuaTang inSection:0]];
        }
    }
}

- (void)chuyen {
    ViewQuaTang *viewQuaTang = [_mDanhSachViewQuaTang objectAtIndex:0];
    ChiTietTangQuaViewController *chiTietQuaTangViewController = [[ChiTietTangQuaViewController alloc] initWithNibName:@"ChiTietTangQuaViewController" bundle:nil];
    chiTietQuaTangViewController.mItemQuaTang = viewQuaTang.mItemQuaTang;
    [self.navigationController pushViewController:chiTietQuaTangViewController animated:YES];
    [chiTietQuaTangViewController release];
}

- (void)suKienBamNutSoTayQuaTang:(UIButton *)sender {
    if (![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue]) {
        DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
        [self presentViewController:loginSceen animated:YES completion:^{}];
        [loginSceen release];
        return;
    }
    DucNT_DanhSachTaiKhoanThuongDungControllerViewController *vc = [[DucNT_DanhSachTaiKhoanThuongDungControllerViewController alloc] initWithType:TAI_KHOAN_QUA_TANG];
    [self.navigationController presentViewController:vc animated:YES completion:^{}];
    [vc release];
}

- (void)suKienBamNutHuongDanGiaoDichViewController:(UIButton *)sender {
    GiaoDienThongTinPhim *vc = [[GiaoDienThongTinPhim alloc] initWithNibName:@"GiaoDienThongTinPhim" bundle:nil];
    vc.nOption = HUONG_DAN_TANG_QUA;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

#pragma mark - overriden GiaoDichViewController

- (void)xuLyKetNoiThanhCong:(NSString*)sDinhDanhKetNoi thongBao:(NSString*)sThongBao ketQua:(id)ketQua
{
    if([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_LAY_DANH_SACH_QUA_TANG])
    {
        NSDictionary *dict = (NSDictionary*)ketQua;
        NSArray *dsDictQuaTang = [dict valueForKey:@"list"];
        if(dsDictQuaTang && dsDictQuaTang.count > 0)
        {
            NSMutableArray *dsViewQuaTang = [[NSMutableArray alloc] initWithCapacity:dsDictQuaTang.count];
            for(NSDictionary *dictQuaTang in dsDictQuaTang)
            {
                ItemQuaTang *itemQuaTang = [[ItemQuaTang alloc] initWithDictionary:dictQuaTang];
//                ViewQuaTang *viewQuaTang = [[[NSBundle mainBundle] loadNibNamed:@"ViewQuaTang" owner:self options:nil] objectAtIndex:0];
//                viewQuaTang.mItemQuaTang = itemQuaTang;
//                viewQuaTang.frame = CGRectMake(0.0f, 5.0f, viewQuaTang.frame.size.width, viewQuaTang.frame.size.height);
                [dsViewQuaTang addObject:itemQuaTang];
//                [itemQuaTang release];
            }
            self.mDanhSachViewQuaTang = dsViewQuaTang;
            [dsViewQuaTang release];
        }
        [self.mtbHienThi reloadData];
    }
}

- (void)xuLyKetNoiThatBai:(NSString*)sDinhDanhKetNoi thongBao:(NSString*)sThongBao ketQua:(id)ketQua
{
    [super xuLyKetNoiThatBai:sDinhDanhKetNoi thongBao:sThongBao ketQua:ketQua];
}

#pragma mark - xuLyKetNoi
- (void)xuLyKetNoiLayDanhSachQuaTang
{
    self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_LAY_DANH_SACH_QUA_TANG;
    [GiaoDichMang ketNoiLayDanhSachQuaTang:self];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_mDanhSachViewQuaTang)
        return _mDanhSachViewQuaTang.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ViewQuaTang *cell = (ViewQuaTang *)[tableView dequeueReusableCellWithIdentifier:@"ViewQuaTang" forIndexPath:indexPath];
//    static NSString *cellIdentifier = @"cellIdentifier";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if(!cell)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//    }
//    else
//    {
//        [[cell viewWithTag:500] removeFromSuperview];
//    }
//    ViewQuaTang *viewQuaTang = [_mDanhSachViewQuaTang objectAtIndex:indexPath.row];
//    viewQuaTang.tag = 500;
//    [cell.contentView addSubview:viewQuaTang];
//    viewQuaTang.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
    cell.mItemQuaTang = [_mDanhSachViewQuaTang objectAtIndex:indexPath.row];
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s - indexPath.row : %ld", __FUNCTION__, (long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    ViewQuaTang *viewQuaTang = [_mDanhSachViewQuaTang objectAtIndex:indexPath.row];
//    NSLog(@"%s - viewQuaTang.mItemQuaTang.mAmount.content : %@", __FUNCTION__, viewQuaTang.mItemQuaTang.mAmount.content);
    ChiTietTangQuaViewController *chiTietQuaTangViewController = [[ChiTietTangQuaViewController alloc] initWithNibName:@"ChiTietTangQuaViewController" bundle:nil];
    chiTietQuaTangViewController.mItemQuaTang = [_mDanhSachViewQuaTang objectAtIndex:indexPath.row];
    chiTietQuaTangViewController.sToAccWallet = toAccWallet;
        [self.navigationController pushViewController:chiTietQuaTangViewController animated:YES];
        [chiTietQuaTangViewController release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (tableView.frame.size.width / 320.0) * 90.0;
}

- (void)dealloc {
    if(_mDanhSachViewQuaTang)
        [_mDanhSachViewQuaTang release];
    [_mtbHienThi release];
    [super dealloc];
}
@end
