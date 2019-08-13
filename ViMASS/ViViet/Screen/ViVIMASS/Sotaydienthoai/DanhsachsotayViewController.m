

#import "DanhsachsotayViewController.h"
#import "SotaydienthoaiTableViewCell.h"
#import "SotaydienthoaiDialogViewController.h"
#import "SVPullToRefresh.h"
#import "GiaoDichMang.h"
#import "JSONKit.h"
#import "DucNT_LuuRMS.h"
#import "DucNT_Token.h"
#import "GiaoDichViewController.h"
#import "Contact.h"
#import "MoneyContact.h"
@interface DanhsachsotayViewController ()<UITableViewDelegate,UITableViewDataSource,SotaydienthoaiTableViewCell,DucNT_ServicePostDelegate,SotaydienthoaiDialogViewControllerDelegate>{
    int nTrangThaiXuLyKetNoi;//0 = traCuuSoTay,1 = xoaSoTay,2 = suaThongTinSoTay
}
@property (retain, nonatomic) IBOutlet UITableView *danhsachsodienthoai;
@property (retain, nonatomic) NSMutableArray *arrData;
@property (assign, nonatomic) int mTypeAuthenticate;
@property (assign, nonatomic) int mFuncID;

@end

@implementation DanhsachsotayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_danhsachsodienthoai registerNib:[UINib nibWithNibName:@"SotaydienthoaiTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.arrData = [NSMutableArray array];
    __block DanhsachsotayViewController *weak = self;
    [_danhsachsodienthoai addPullToRefreshWithActionHandler:^{
        [weak.danhsachsodienthoai.pullToRefreshView stopAnimating];
    }];
    self.navigationItem.title = @"Sổ tay chuyển tiền điện thoại";
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getSotay];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {
        NSLog(@"New view controller was pushed");
    } else if ([viewControllers indexOfObject:self] == NSNotFound) {
        NSLog(@"View controller was popped");
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ClickBackSoTay" object:nil];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrData count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SotaydienthoaiTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *dictData = [self.arrData objectAtIndex:indexPath.row];
    cell.delegate = self;
    cell.indexPath = indexPath;
    if (indexPath.row > 0) {
        if (indexPath.row == [tableView numberOfRowsInSection:0] - 1) {
             [cell setHiddenBottomLine:YES];
        } else {
            [cell setHiddenBottomLine:(indexPath.row % 2 == 0)];
        }
    } else {
        [cell setHiddenBottomLine:YES];
    }
    cell.idGiaodich = [dictData objectForKey:@"id"];
    cell.lblTitle.text = [dictData objectForKey:@"tenLuu"];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController popViewControllerAnimated:YES];
    NSDictionary *dictData = [self.arrData objectAtIndex:indexPath.row];
    NSArray *dsItem = [dictData objectForKey:@"dsItem"];
    NSMutableArray *arrContact = [NSMutableArray array];
    if (_delegate) {
        for (NSDictionary *dict in dsItem) {
            MoneyContact * contact = [MoneyContact new];
            contact.money = [[dict objectForKey:@"soTien"] stringValue];
            contact.fee = [[dict objectForKey:@"fee"] doubleValue];
            contact.contact = [Contact new];
            contact.loaiMapping =[[dict objectForKey:@"loaiMapping"] intValue];
            contact.manganhang = [[dict objectForKey:@"maNganHang"] stringValue];
            contact.contact.firstName = [dict objectForKey:@"tenHienThi"];
            contact.contact.phone = [dict objectForKey:@"sdt"];
            contact.fromSotay = YES;
            [arrContact addObject:contact];
        }
        [_delegate didSeletedContact:arrContact andNoiDung:[dictData objectForKey:@"noiDung"]];
    }
}
- (void)actionEdit:(NSString*)nameEdit andIdGiaoDich:(NSString *)idGiaodich {
    SotaydienthoaiDialogViewController * dialog = [self createDialog];
    dialog.isDelete = NO;
    dialog.idGiaoDich = idGiaodich;
    dialog.delegate = self;
    [dialog showPopupEdit];
    [dialog setTextNameInput:nameEdit];
}
- (void)actionDelete:(NSString*)nameDelete andIdGiaoDich:(NSString *)idGiaodich {
    SotaydienthoaiDialogViewController * dialog = [self createDialog];
    dialog.delegate = self;
    dialog.isDelete = YES;
    dialog.idGiaoDich = idGiaodich;
    [dialog showPopupDelete];
    [dialog setNameDelete:nameDelete];
}
-(SotaydienthoaiDialogViewController*)createDialog {
    SotaydienthoaiDialogViewController * dialog = [[[SotaydienthoaiDialogViewController alloc] initWithNibName:@"SotaydienthoaiDialogViewController" bundle:nil] autorelease];
    [dialog removeFromParentViewController];
    dialog.view.frame = [UIScreen mainScreen].bounds;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:dialog.view];
    [self addChildViewController:dialog];
    return dialog;
}
- (void)dealloc {
    [_danhsachsodienthoai release];
    [super dealloc];
}
- (void)getSotay{
    [self hienThiLoadingLayDanhBa];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:-5];
    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    
    long long timeFrom = [[NSNumber numberWithDouble:([minDate timeIntervalSince1970] *1000)] longLongValue];
    long long timeTo = [[NSNumber numberWithDouble:([[NSDate date] timeIntervalSince1970] *1000)] longLongValue];

    NSDictionary *param = @{ @"user" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                             @"session" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_SECSSION],@"timeFrom":[NSNumber numberWithLong:timeFrom],@"timeTo":[NSNumber numberWithLong:timeTo],@"offset":@1,@"limit":@1000};
    
    NSString *sPost = [param JSONString];
    NSLog(@"%s - sPost : %@", __FUNCTION__, sPost);
    nTrangThaiXuLyKetNoi = 0;
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:self];
    [connect connect:@"https://vimass.vn/vmbank/services/danhBa/traCuuSoTay" withContent:sPost];
    [connect release];
}

- (void)ketNoiThanhCong:(NSString *)sKetQua{
    NSLog(@"%s - sKetQua : %@", __FUNCTION__, sKetQua);
    NSDictionary *dicKQ = [sKetQua objectFromJSONString];
    int nCode = [[dicKQ objectForKey:@"msgCode"] intValue];
    NSString *sThongBao = [dicKQ objectForKey:@"msgContent"];
    if(nTrangThaiXuLyKetNoi == 0)
    {
        NSArray *result = [dicKQ objectForKey:@"result"];
        [self.arrData addObjectsFromArray:result];
        [self.danhsachsodienthoai reloadData];
    }
    [self anLoading];
}

#pragma mark - SotaydienthoaiDialogViewControllerDelegate
- (void)actionDeleleSotay:(NSString*)parameter andCode:(int)nCode andMessage:(NSString*)sThongBao  {
    if(nCode == 1){
        [self getSotay];
    }
    else{
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:[@"thong_bao" localizableString] message:sThongBao delegate:self cancelButtonTitle:[@"dong" localizableString] otherButtonTitles:nil, nil] autorelease];
        alertView.tag = 100;
        [alertView show];
    }
    
}
- (void)actionEditSotay:(NSString*)parameter andCode:(int)nCode andMessage:(NSString*)sThongBao {
    if(nCode == 1){
        [self getSotay];
    }
    else{
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:[@"thong_bao" localizableString] message:sThongBao delegate:self cancelButtonTitle:[@"dong" localizableString] otherButtonTitles:nil, nil] autorelease];
        alertView.tag = 100;
        [alertView show];
    }
}

@end
