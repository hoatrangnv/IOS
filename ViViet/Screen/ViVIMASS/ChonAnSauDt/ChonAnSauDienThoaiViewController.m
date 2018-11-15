

#import "ChonAnSauDienThoaiViewController.h"
#import "ChonAnSauDtTableViewCell.h"
#import "ActionTableViewCell.h"
#import "CommonUtils.h"
@interface ChonAnSauDienThoaiViewController ()<UITableViewDataSource,UITableViewDelegate,ActionTableViewCellDelegate,ChonAnSauDtTableViewCellDelegate>
{
    NSMutableArray * danhsach;
    NSMutableArray * selected;
    NSString * mkToken;
    int typeReques;//0 - loaddata , 1 - register
    BOOL isShowKeyBoard;
    CGSize keyboardSize;
    CGRect rectTable;
}
@property (retain, nonatomic) IBOutlet UITableView *tbvDanhsach;

@end

@implementation ChonAnSauDienThoaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_tbvDanhsach registerNib:[UINib nibWithNibName:@"ChonAnSauDtTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [_tbvDanhsach registerNib:[UINib nibWithNibName:@"ActionTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellaction"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    danhsach = [NSMutableArray new];
    selected = [NSMutableArray new];
    [self setButtonRightNav];
    [self getDanhsach];
    _tbvDanhsach.tableFooterView = [UIView new];
    self.navigationItem.title = @"Chọn ví,thẻ,tk ẩn sau điện thoại";
    isShowKeyBoard = false;
}
-(void)viewWillAppear:(BOOL)animated{
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)setButtonRightNav {
    UIButton * custom = [UIButton buttonWithType:UIButtonTypeCustom];
    custom.tintColor = [UIColor clearColor];
    [custom setImage:[UIImage imageNamed:@"ic_question_32"] forState:UIControlStateNormal];
    custom.frame = CGRectMake(0, 0, 40, 40);
    UIBarButtonItem * right = [[[UIBarButtonItem alloc] initWithCustomView:custom] autorelease];
    self.navigationItem.rightBarButtonItem = right;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (danhsach.count == 0) {
        return 0;
    }
    return danhsach.count + 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [tableView numberOfRowsInSection:0] - 1) {
        ActionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellaction" forIndexPath:indexPath];
        cell.delegate = self;
        [cell setupView];
        return cell;
    } else
    {
        ChonAnSauDtTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.delegate = self;
        NSDictionary * dic = danhsach[indexPath.row];
        [cell setDataForCell:dic];
        [cell dataSelected:[selected containsObject:dic]];
        return cell;

    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (danhsach.count > 0) {
        if (indexPath.row == [tableView numberOfRowsInSection:0] - 1) {
            return 112;
        } else {
            return 75;
        }
    }
    return 0;
}
- (void)dealloc {
    [_tbvDanhsach release];
    [super dealloc];
}
- (void)keyboardDidShow:(NSNotification *)notification{
    keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    rectTable = _tbvDanhsach.frame;
    if ((_tbvDanhsach.contentSize.height - keyboardSize.height) > 0) {
        CGFloat margin = rectTable.size.height -  keyboardSize.height;
        rectTable.size.height = margin;
        _tbvDanhsach.frame = rectTable;
    }
}
-(void)keyboardDidHide:(NSNotification *)notification{
    _tbvDanhsach.frame = self.view.bounds;
}
#pragma mark - ActionTableViewCellDelegate
- (void)actionVantay {
    self.mTypeAuthenticate = TYPE_AUTHENTICATE_TOKEN;
    NSString *sKeyDangNhap = [DucNT_LuuRMS layThongTinDangNhap:KEY_DANG_NHAP];
    if(sKeyDangNhap.length > 0)
    {
        [self xuLySuKienHienThiChucNangDangNhapVanTayVoiTieuDe:[@"su_dung_van_tay_dang_nhap_tai_khoan_VIMASS" localizableString]];
    }
    else
    {
        [UIAlertView alert:[@"thong_bao_chua_co_xac_thuc_van_tay" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
    }
}
- (void)actionThucHien:(NSString*)token {
    self.mTypeAuthenticate = TYPE_AUTHENTICATE_TOKEN;
    if([CommonUtils isEmptyOrNull:token]){
        [UIAlertView alert:@"Vui lòng nhập mật khẩu " withTitle:[@"thong_bao" localizableString] block:nil];
        return;
    }
    mkToken = token;
    [self xuLySuKienXacThucVanTayThanhCong];
}
- (void)huyXacThucVanTay {
    ActionTableViewCell * cell = [_tbvDanhsach cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[_tbvDanhsach numberOfRowsInSection:0] - 1 inSection:0]];
    [cell doToken:self];
}

- (void)xuLySuKienXacThucVanTayThanhCong {
    typeReques = 1;
    NSString *user = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    NSString *sToken = @"";
    NSString *sMatKhau = mkToken;
    sMatKhau = [DucNT_Token layMatKhauVanTayToken];
    
    NSString *sSeed = [DucNT_Token laySeedTokenHienTai];
    sToken = [DucNT_Token OTPFromPIN:sMatKhau seed:sSeed];
    NSDictionary * dic = [selected firstObject];
    NSDictionary *dictPost = @{
                               @"user" : user,
                               @"token" : sToken,
                               @"otpConfirm" : @"",
                               @"typeAuthenticate" : [NSNumber numberWithInt:self.mTypeAuthenticate],
                               @"appId" : [NSNumber numberWithInt:APP_ID],
                               @"loaiMapping": [dic objectForKey:@"loaiMapping"],
                               @"idMapping": [dic objectForKey:@"idMapping"]
                               };

    NSString *sPost = [dictPost JSONString];
    NSLog(@"%s - sPost : %@", __FUNCTION__, sPost);
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:self];
    [connect connect:@"https://vimass.vn/vmbank/services/danhBa/dangKyDuLieu" withContent:sPost];
    [connect release];

}

#pragma mark - call api
- (void)getDanhsach {
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
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:self];
    [connect connect:@"https://vimass.vn/vmbank/services/danhBa/getListSelect" withContent:sPost];
    [connect release];
}
- (void)ketNoiThanhCong:(NSString *)sKetQua{
    NSLog(@"%s - sKetQua : %@", __FUNCTION__, sKetQua);
    NSDictionary *dicKQ = [sKetQua objectFromJSONString];
    int nCode = [[dicKQ objectForKey:@"msgCode"] intValue];
    NSString *sThongBao = [dicKQ objectForKey:@"msgContent"];
    if (nCode != 1) {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:[@"thong_bao" localizableString] message:sThongBao delegate:self cancelButtonTitle:[@"dong" localizableString] otherButtonTitles:nil, nil] autorelease];
        [alertView show];
    } else {
        if (typeReques == 0) {
            NSArray *result = [dicKQ objectForKey:@"result"];
            [danhsach addObjectsFromArray:result];
            for (NSDictionary * dic in result) {
                if ([dic[@"isSelect"] boolValue] == YES) {
                    [selected addObject:dic];
                }
            }
            [_tbvDanhsach reloadData];
        }
    }
}
#pragma mark - ChonAnSauDtTableViewCellDelegate
-(void)actionSelect:(NSDictionary*)dicData {
    [selected removeAllObjects];
    [selected addObject:dicData];
    [_tbvDanhsach reloadData];
}
@end
