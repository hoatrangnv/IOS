//
//  GiaoDienHoTroThanhToan.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 9/8/19.
//

#import "GiaoDienHoTroThanhToan.h"
#import "ViVimass-Swift.h"

@interface GiaoDienHoTroThanhToan () {
    NhapInfoHoTroThanhToanViewController *vcInput;
    HoTroThanhToanViewController *vcInfo;
}

@end

@implementation GiaoDienHoTroThanhToan

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self khoiTaoViewInput];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)khoiTaoViewInput {
    if (vcInfo != nil) {
        [vcInfo.view setHidden:YES];
    }
    if (vcInput == nil) {
        vcInput = [[NhapInfoHoTroThanhToanViewController alloc] initWithNibName:@"NhapInfoHoTroThanhToanViewController" bundle:nil];
        [vcInput.view setFrame:CGRectMake(0, 0, self.viewShowMain.frame.size.width, self.viewShowMain.frame.size.height)];
        [self.viewShowMain addSubview:vcInput.view];
    }
    [vcInput.view setHidden:NO];
}

- (void)khoiTaoViewHuongDan {
    if (vcInput != nil) {
        [vcInput.view setHidden:YES];
    }
    if (vcInfo == nil) {
        vcInfo = [[HoTroThanhToanViewController alloc] initWithNibName:@"HoTroThanhToanViewController" bundle:nil];
        [vcInfo.view setFrame:CGRectMake(0, 0, self.viewShowMain.frame.size.width, self.viewShowMain.frame.size.height)];
        [self.viewShowMain addSubview:vcInfo.view];
    }
    [vcInfo.view setHidden:NO];
}

- (IBAction)suKienChonBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)suKienChonTraCuu:(id)sender {
    [self.btnTraCuu setBackgroundColor:[UIColor whiteColor]];
    [self.btnTraCuu setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.btnHuongDan setBackgroundColor:[UIColor clearColor]];
    [self.btnHuongDan setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self khoiTaoViewInput];
}

- (IBAction)suKienChonHuongDan:(id)sender {
    [self.btnHuongDan setBackgroundColor:[UIColor whiteColor]];
    [self.btnHuongDan setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.btnTraCuu setBackgroundColor:[UIColor clearColor]];
    [self.btnTraCuu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self khoiTaoViewHuongDan];
}

- (void)dealloc {
    [_viewShowMain release];
    [_btnTraCuu release];
    [_btnHuongDan release];
    [super dealloc];
}
@end
