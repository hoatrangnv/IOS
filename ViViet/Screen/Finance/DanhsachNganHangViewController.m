//
//  DanhsachNganHangViewController.m
//  ViViMASS
//
//  Created by Dao Minh Nha on 11/26/18.
//

#import "DanhsachNganHangViewController.h"
#import "TkNganhangTableViewCell.h"
@interface DanhsachNganHangViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *arrBank;
}
@property (retain, nonatomic) IBOutlet UITableView *danhsachnganhang;

@end

@implementation DanhsachNganHangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Chọn ngân hàng";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:17.0/255.0 green:116.0/255.0 blue:185.0/255.0 alpha:1];
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    NSString *sDsBank = @"TPB - Ngân hàng Tiên Phong/ACB - Á châu/BID - Đầu tư và phát triển Việt Nam/CTG - Công thương Việt Nam/LPB - Bưu điện Liên Việt/NAB - Nam á/TCB - Kỹ thương Việt Nam/VCB - Ngoại thương Việt Nam/ABB - An bình/BAB - Bắc á/BVB - Bảo Việt/EAB - Đông á/EIB - Xuất nhập khẩu Việt Nam/GPB - Dầu khí toàn cầu/HDB - Phát triển TPHCM/KLB - Kiên Long/MB - Quân đội/MSB - Hàng hải/NCB - Quốc dân/OCB - Phương đông/OJB - Đại dương/PGB - Xăng dầu Petrolimex/PVB - Đại chúng Việt Nam/SCB - Sài Gòn/SEAB - Đông nam á/SGB - Sài Gòn công thương/SHB - Sài Gòn Hà Nội/STB - Sài Gòn thương tín/VAB - Việt á/VB - Việt Nam thương tín/VCCB - Bản Việt/VIB - Quốc tế/VPB - Việt Nam thịnh vượng/Visa/MasterCard/JCB";
    NSArray *arrTemp = [sDsBank componentsSeparatedByString:@"/"];
    arrBank = [[NSArray alloc] initWithArray:arrTemp];
    [self buttonLeft];
    [_danhsachnganhang registerNib:[UINib nibWithNibName:@"TkNganhangTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    // Do any additional setup after loading the view from its nib.
}
-(void)buttonLeft {
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0, 0, 24, 24);
    [leftButton addTarget:self action:@selector(dismisControll) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftBaritem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBaritem;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dismisControll {
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrBank.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identifier = @"cell";
    TkNganhangTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.textLabel.text = arrBank[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (_delegate) {
        [_delegate didSeletedBank:indexPath.row];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)dealloc {
    [_danhsachnganhang release];
    [super dealloc];
}
@end
