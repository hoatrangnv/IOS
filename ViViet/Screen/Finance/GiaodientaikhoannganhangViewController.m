

#import "GiaodientaikhoannganhangViewController.h"
#import "GiaoDienDanhSachTaiKhoanLienKet.h"
@interface GiaodientaikhoannganhangViewController ()

@end

@implementation GiaodientaikhoannganhangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.edTenDangNhap addTarget:self action:@selector(tenDangNhapDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.edMatKhau addTarget:self action:@selector(matKhauDidChange:) forControlEvents:UIControlEventEditingChanged];

    // Do any additional setup after loading the view from its nib.
}

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
- (void)tenDangNhapDidChange:(UITextField *)tf {
}

- (void)matKhauDidChange:(UITextField *)tf {
}
-(void)taikhoanLienket:(ItemTaiKhoanLienKet*)tkLienket {
    _edSoTK.text = tkLienket.soTaiKhoan;
    _edTenDangNhap.text = tkLienket.u;
    _edMatKhau.text = tkLienket.p;
}
@end
