

#import "GiaodientaikhoantheViewController.h"
#import "GiaoDienDanhSachTaiKhoanLienKet.h"
@interface GiaodientaikhoantheViewController ()

@end

@implementation GiaodientaikhoantheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.edSoThe addTarget:self action:@selector(soTheDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.edNgayMoThe addTarget:self action:@selector(thoiDiemMoTheDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.edNamMoThe addTarget:self action:@selector(thoiDiemMoTheDidChange:) forControlEvents:UIControlEventEditingChanged];
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
-(void)taikhoanLienket:(ItemTaiKhoanLienKet*)tkLienket {
    _edSoThe.text = tkLienket.soThe;
    if (tkLienket.cardMonth > 0) {
        if (tkLienket.cardMonth < 10) {
            _edNgayMoThe.text = [NSString stringWithFormat:@"0%d", tkLienket.cardMonth];
        }
        else {
            _edNgayMoThe.text = [NSString stringWithFormat:@"%d", tkLienket.cardMonth];
        }
    }
    else {
        _edNgayMoThe.text = @"";
    }
    if (tkLienket.cardYear > 0) {
        if (tkLienket.cardYear < 10) {
            _edNamMoThe.text = [NSString stringWithFormat:@"0%d", tkLienket.cardYear];
        }
        else {
            _edNamMoThe.text = [NSString stringWithFormat:@"%d", tkLienket.cardYear];
        }
    }
    else {
        _edNamMoThe.text = @"";
    }
}

@end
