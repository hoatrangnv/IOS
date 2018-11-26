

#import "Giaodienlienket1ViewController.h"
#import "GiaodientaikhoannganhangViewController.h"
#import "GiaodientaikhoantheViewController.h"
@interface Giaodienlienket1ViewController (){
    GiaodientaikhoannganhangViewController * taikhoanNH;
    GiaodientaikhoantheViewController * taikhoanthe;
}
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (retain, nonatomic) IBOutlet UIView *viewContain;

@end

@implementation Giaodienlienket1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Liên kết tài khoản / thẻ";
    self.segmentControl.selectedSegmentIndex = 0;
    if (!taikhoanNH) {
        taikhoanNH = [[GiaodientaikhoannganhangViewController alloc] initWithNibName:@"GiaodientaikhoannganhangViewController" bundle:nil];
        [taikhoanNH removeFromParentViewController];
        taikhoanNH.view.frame = self.viewContain.bounds;
        [self.viewContain addSubview:taikhoanNH.view];
        [self addChildViewController:taikhoanNH];
        [taikhoanNH release];
    }

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:nil];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)segmentAction:(id)sender {
    if (self.segmentControl.selectedSegmentIndex == 0) {
        [taikhoanthe.view removeFromSuperview];
        taikhoanthe = nil;
        if (!taikhoanNH) {
            taikhoanNH = [[GiaodientaikhoannganhangViewController alloc] initWithNibName:@"GiaodientaikhoannganhangViewController" bundle:nil];
            [taikhoanNH removeFromParentViewController];
            taikhoanNH.view.frame = self.viewContain.bounds;
            [self.viewContain addSubview:taikhoanNH.view];
            [self addChildViewController:taikhoanNH];
            [taikhoanNH release];
        }
    } else {
        [taikhoanNH.view removeFromSuperview];
        taikhoanNH = nil;
        if (!taikhoanthe) {
            taikhoanthe = [[GiaodientaikhoantheViewController alloc] initWithNibName:@"GiaodientaikhoantheViewController" bundle:nil];
            [taikhoanthe removeFromParentViewController];
            taikhoanthe.view.frame = self.viewContain.bounds;
            [self.viewContain addSubview:taikhoanthe.view];
            [self addChildViewController:taikhoanthe];
            [taikhoanthe release];
        }
    }
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
    [_segmentControl release];
    [_viewContain release];
    [super dealloc];
}
@end
