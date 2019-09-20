//
//  GiaoDienTinTuc.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 1/8/19.
//

#import "GiaoDienTinTuc.h"
#import "TinTucTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "GiaoDienChiTietTinTuc.h"

@interface GiaoDienTinTuc ()<UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *arrTinTuc;
    NSString *keyTitle;
    NSString *keyContent;
    NSString *keyImage;
    int langID;
}

@end

@implementation GiaoDienTinTuc

- (void)viewDidLoad {
    [super viewDidLoad];
    arrTinTuc = [[NSMutableArray alloc] init];
    keyTitle = @"title_vi";
    keyContent = @"shortContent_vi";
    keyImage = @"img_vi";
    langID = 1;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TinTucTableViewCell" bundle:nil] forCellReuseIdentifier:@"TinTucTableViewCell"];
    [arrTinTuc removeAllObjects];
    [self ketNoiLayTinTuc];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(suKienChonTitle)];
    [self.lblTitle setUserInteractionEnabled:YES];
    [self.lblTitle addGestureRecognizer:tap];
}

- (void)suKienChonTitle {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)ketNoiLayTinTuc {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hienThiLoading];
    });
    [arrTinTuc removeAllObjects];
    self.mDinhDanhKetNoi = @"LAY_TIN_TUC";
    [GiaoDichMang ketNoiLayTinTuc:langID idInput:@"1541494373838is4v3" noiNhanKetQua:self];
}

- (void)xuLyKetNoiThanhCong:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        [self anLoading];
    }
    if ([sDinhDanhKetNoi isEqualToString:@"LAY_TIN_TUC"]) {
        NSDictionary *dict = (NSDictionary *)ketQua;
        NSLog(@"%s - dict : %@", __FUNCTION__, [dict JSONString]);
        NSArray *arrDoc = (NSArray *)dict[@"listDoccument"];
        [arrTinTuc addObjectsFromArray:arrDoc];
        NSLog(@"%s - arrTinTuc.count : %ld", __FUNCTION__, arrTinTuc.count);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}

- (NSString *)decodeBase64:(NSString *)base64String {
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    return decodedString;
}

- (IBAction)suKienChonBack:(id)sender {
//    if (self.delegate) {
//        [self.delegate suKienChonBackTinTuc];
//    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)suKienChonVietNam:(id)sender {
    if (langID != 1) {
        keyTitle = @"title_vi";
        keyContent = @"shortContent_vi";
        keyImage = @"img_vi";
        langID = 1;
        [self ketNoiLayTinTuc];
    }
}

- (IBAction)suKienChonEnglish:(id)sender {
    if (langID != 2) {
        keyTitle = @"title_en";
        keyContent = @"shortContent_en";
        keyImage = @"img_en";
        langID = 2;
        [self ketNoiLayTinTuc];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrTinTuc.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TinTucTableViewCell *cell = (TinTucTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TinTucTableViewCell" forIndexPath:indexPath];
    NSDictionary *item = (NSDictionary *)arrTinTuc[indexPath.row];
    NSString *sTitle = (NSString *)[item valueForKey:keyTitle];
    NSString *sContent = (NSString *)[item valueForKey:keyContent];
    NSString *image = (NSString *)[item valueForKey:keyImage];
    cell.lblTitle.text = [self decodeBase64:sTitle];
    cell.lblContent.text = [self decodeBase64:sContent];
    
    [cell.imgvIcon setImageWithURL:[NSURL URLWithString:image]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *item = (NSDictionary *)arrTinTuc[indexPath.row];
    NSString *sID = (NSString *)item[@"id"];
    self.navigationController.navigationBar.hidden = NO;
    GiaoDienChiTietTinTuc *chiTiet = [[GiaoDienChiTietTinTuc alloc] initWithNibName:@"GiaoDienChiTietTinTuc" bundle:nil];
    chiTiet.langID = langID;
    chiTiet.sIDTinTuc = sID;
    [self.navigationController pushViewController:chiTiet animated:YES];
    [chiTiet release];
    
}

- (void)dealloc {
    [_tableView release];
    [_lblTitle release];
    [super dealloc];
}
@end
