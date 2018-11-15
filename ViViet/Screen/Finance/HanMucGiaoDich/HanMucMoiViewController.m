//
//  HanMucMoiViewController.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 11/15/18.
//

#import "HanMucMoiViewController.h"

@interface HanMucMoiViewController ()

@end

@implementation HanMucMoiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    [_scrMain release];
    [_viewUI release];
    [super dealloc];
}
@end
