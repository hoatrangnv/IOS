//
//  ViewDoiMatKhauTokenViewController.m
//  ViViMASS
//
//  Created by DucBT on 2/12/15.
//
//

#import "ViewDoiMatKhauTokenViewController.h"

@interface ViewDoiMatKhauTokenViewController ()

@end

@implementation ViewDoiMatKhauTokenViewController

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - handler error
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - dealloc
- (void)dealloc {
    [_mtfSoDienThoai release];
    [_mtfMatKhauTokenCu release];
    [_mtfMatKhauTokenMoi release];
    [_mtfNhapLaiMatKhauToken release];
    [_mbtnThucHien release];
    [_mViewMain release];
    [super dealloc];
}
@end
