//
//  ChonTinhThanhViewController.m
//  ViViMASS
//
//  Created by DucBui on 7/13/15.
//
//

#import "ChonTinhThanhViewController.h"

@interface ChonTinhThanhViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ChonTinhThanhViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.mlblTitle setText:self.mTitle];
    [_mtbHienThiDiaDiem reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - suKien

- (IBAction)suKienBamNutBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_mDanhSachDiaDiem)
    {
        if(_mKieuChon == KIEU_CHON_TINH_THANH)
            return _mDanhSachDiaDiem.count;
        else
            return _mDanhSachDiaDiem.count + 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    if(_mKieuChon == KIEU_CHON_TINH_THANH)
    {
        DoiTuongDiaDiem *doiTuong = [_mDanhSachDiaDiem objectAtIndex:indexPath.row];
        cell.textLabel.text = doiTuong.mTen;
    }
    else
    {
        if(indexPath.row == _mDanhSachDiaDiem.count)
        {
            if(_mKieuChon == KIEU_CHON_PHUONG_XA)
                cell.textLabel.text = @"Tên Phường/Xã nhập tay";
            else if (_mKieuChon == KIEU_CHON_QUAN_HUYEN)
                cell.textLabel.text = @"Tên Quận/Huyện nhập tay";
        }
        else
        {
            DoiTuongDiaDiem *doiTuong = [_mDanhSachDiaDiem objectAtIndex:indexPath.row];
            cell.textLabel.text = doiTuong.mTen;
        }
    }

    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DoiTuongDiaDiem *doiTuongDiaDiem = nil;
    if(_mKieuChon == KIEU_CHON_TINH_THANH)
    {
        doiTuongDiaDiem = [_mDanhSachDiaDiem objectAtIndex:indexPath.row];
    }
    else
    {
        if(indexPath.row < _mDanhSachDiaDiem.count)
            doiTuongDiaDiem = [_mDanhSachDiaDiem objectAtIndex:indexPath.row];
    }

    if([self.mDelegate respondsToSelector:@selector(suKienChonDoiTuongDiaDiem:kieuChon:)])
    {
        [self.mDelegate suKienChonDoiTuongDiaDiem:doiTuongDiaDiem kieuChon:_mKieuChon];
    }
    [self suKienBamNutBack:nil];
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
    [_mtbHienThiDiaDiem release];
    [_mlblTitle release];
    [super dealloc];
}
@end
