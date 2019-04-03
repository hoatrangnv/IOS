//
//  ViDienTuVC.m
//  ViViMASS
//
//  Created by Mac Mini on 10/11/18.
//

#import "ViDienTuVC.h"
#import "ItemListCell.h"
#import "Localization.h"
@interface ViDienTuVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ViDienTuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ItemListCell" bundle:nil] forCellReuseIdentifier:@"ItemListCell"];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.arrDanhSach = @[@{@"name":[Localization languageSelectedStringForKey:@"financer_viewer_wallet_to_wallet"],@"image":@"vimass"},
                         @{@"name":[Localization languageSelectedStringForKey:@"financer_viewer_wallet_to_airpay"], @"image":@"air"},
                         @{@"name":[Localization languageSelectedStringForKey:@"financer_viewer_wallet_to_momo"], @"image":@"momo"},
                          @{@"name":[Localization languageSelectedStringForKey:@"financer_viewer_wallet_to_nganluong"], @"image":@"nganluong"},
                          @{@"name":[Localization languageSelectedStringForKey:@"financer_viewer_wallet_to_payoo"], @"image":@"payoo"},
                          @{@"name":[Localization languageSelectedStringForKey:@"financer_viewer_wallet_to_viettel_pay"], @"image":@"viettel"},
                          @{@"name":[Localization languageSelectedStringForKey:@"financer_viewer_wallet_to_vimo"], @"image":@"vimo"},
                         @{@"name":[Localization languageSelectedStringForKey:@"financer_viewer_wallet_to_viviet"], @"image":@"viviet"},
                          @{@"name":[Localization languageSelectedStringForKey:@"financer_viewer_wallet_to_vnpt_pay"], @"image":@"vnpt"},
                         @{@"name":[Localization languageSelectedStringForKey:@"financer_viewer_wallet_to_vtc_pay"], @"image":@"vtc"},
                         @{@"name":[Localization languageSelectedStringForKey:@"financer_viewer_wallet_to_zalo_pay"], @"image":@"zalo"}
                        ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrDanhSach.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.height/ 11.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemListCell *cell = (ItemListCell *)[tableView dequeueReusableCellWithIdentifier:@"ItemListCell" forIndexPath:indexPath];
    NSDictionary *dict = [self.arrDanhSach objectAtIndex:indexPath.row];
    NSString *name = (NSString *)[dict valueForKey:@"name"];
    NSString *image = (NSString *)[dict valueForKey:@"image"];
    [cell.imgTitle setImage:[UIImage imageNamed:image]];
    cell.lblName.text = name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s - indexPath : %d", __FUNCTION__, (int)indexPath.row);
    [self.delegate didSelectRow:(int)indexPath.row withTab:1];
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
@end
