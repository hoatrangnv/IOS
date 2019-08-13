//
//  GiaoDienChonGheCGV.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 6/23/16.
//
//

#import "GiaoDienChonGheCGV.h"
#import "CellChonGheCGV.h"
#import "Common.h"
#import "ItemGiaVeCGV.h"

@interface GiaoDienChonGheCGV()

@end

@implementation GiaoDienChonGheCGV

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Chọn ghế";

    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 80, 34);
    [button setTitle:@"Xong" forState:UIControlStateNormal];

    button.backgroundColor = [UIColor clearColor];
    button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [button addTarget:self action:@selector(suKienBamNutXong:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *leftItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];

    UIBarButtonItem *negativeSeperator = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];

    if (SYSTEM_VERSION_LESS_THAN(@"7"))
        negativeSeperator.width = -5;
    else
        negativeSeperator.width = -10;

    self.navigationItem.rightBarButtonItems = @[negativeSeperator, leftItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)suKienBamNutXong:(id)sender {
    [self.view endEditing:YES];
    if (!_arrGiaTien) {
        NSLog(@"%s - arrGiaTien is nil", __FUNCTION__);
    }
    else {
        NSLog(@"%s - arrGiaTien.count : %ld", __FUNCTION__, (long)_arrGiaTien.count);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CHON_GHE_CGV" object:_arrGiaTien];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellChonGheCGV";
    CellChonGheCGV *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CellChonGheCGV" owner:self options:nil] objectAtIndex:0];
    ItemGiaVeCGV *dic = [_arrGiaTien objectAtIndex:indexPath.row];
//    NSLog(@"%s - dic.tenVe : %@", __FUNCTION__, dic.tenVe);
    cell.lblLoaiVe.text = dic.hienThi;
    if (cell.lblLoaiVe.text.length == 0) {
        cell.lblLoaiVe.text = dic.tenVe;
    }
    cell.lblGia.text = [Common hienThiTienTe:dic.gia];
    cell.edSoLuong.text = [NSString stringWithFormat:@"%d", dic.sl];
    NSLog(@"%s - idVe : %@", __FUNCTION__, dic.idVe);
    UITextField *edSL = [cell viewWithTag:102];
    edSL.delegate = self;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrGiaTien ? _arrGiaTien.count : 0;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"%s - START", __FUNCTION__);
    [self tongHopLaiDuLieu];
}

- (void)tongHopLaiDuLieu {
    if (!_arrGiaTien) {
        return;
    }
    int nSL = 0;
    double nSoTien = 0.0;
    for (int i = 0; i < _arrGiaTien.count; i++) {
        CellChonGheCGV *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        UITextField *edSL = [cell viewWithTag:102];
        ItemGiaVeCGV *dic = [_arrGiaTien objectAtIndex:i];
        if (edSL.text.length > 0) {
            dic.sl = [edSL.text intValue];
        }
        else
            dic.sl = 0;
        NSLog(@"%s - idVe : %@ - %d", __FUNCTION__, dic.tenVe, dic.sl);
        nSL += dic.sl;
        nSoTien += dic.sl * dic.gia;
    }
}

- (void)dealloc {
    [_tableView release];
    [_arrGiaTien release];
    [super dealloc];
}
@end
