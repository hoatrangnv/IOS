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
    HuongDanHoTroThanhToanViewController *vcInfoSearch;
}

@end

@implementation GiaoDienHoTroThanhToan

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (UIButton *btn in [_stackTop arrangedSubviews]) {
        [btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        btn.titleLabel.numberOfLines = 2;
    }
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_CA_NHAN) {
        [self.btnHuongDan setHidden:YES];
    }
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
    if (vcInfoSearch != nil) {
        [vcInfoSearch.view setHidden:YES];
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
    if (vcInfoSearch != nil) {
        [vcInfoSearch.view setHidden:YES];
    }
    if (vcInfo == nil) {
        vcInfo = [[HoTroThanhToanViewController alloc] initWithNibName:@"HoTroThanhToanViewController" bundle:nil];
        [vcInfo.view setFrame:CGRectMake(0, 0, self.viewShowMain.frame.size.width, self.viewShowMain.frame.size.height)];
        [self.viewShowMain addSubview:vcInfo.view];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(suKienChonIntro:) name:@"CHON_INTRO" object:nil];
    }
    [vcInfo.view setHidden:NO];
}

- (void)khoiTaoViewHuongDanTraCuu {
    if (vcInput != nil) {
        [vcInput.view setHidden:YES];
    }
    if (vcInfo != nil) {
        [vcInfo.view setHidden:YES];
    }
    if (vcInfoSearch == nil) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:10 forKey:@"INDEX_INTRO"];
        [defaults synchronize];
        vcInfoSearch = [[HuongDanHoTroThanhToanViewController alloc] initWithNibName:@"HuongDanHoTroThanhToanViewController" bundle:nil];
        [vcInfoSearch.view setFrame:CGRectMake(0, 0, self.viewShowMain.frame.size.width, self.viewShowMain.frame.size.height)];
        [self.viewShowMain addSubview:vcInfoSearch.view];
    }
    
    [vcInfoSearch.view setHidden:NO];
}

- (void)suKienChonIntro:(NSNotification *) notification {
    NSDictionary *dict = (NSDictionary *)notification.object;
    int nIndex = [[dict valueForKey:@"index"] intValue];
    NSLog(@"GiaoDienHoTroThanhToan : %s - nIndex : %d", __FUNCTION__, nIndex);

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:nIndex forKey:@"INDEX_INTRO"];
    [defaults synchronize];
    HuongDanHoTroThanhToanViewController *vc = [[HuongDanHoTroThanhToanViewController alloc] initWithNibName:@"HuongDanHoTroThanhToanViewController" bundle:nil];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (IBAction)suKienChonBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)suKienChonTraCuu:(id)sender {
    [self.btnTraCuu setBackgroundColor:[UIColor whiteColor]];
    [self.btnTraCuu setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.btnHuongDan setBackgroundColor:[UIColor clearColor]];
    [self.btnHuongDan setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnHuongDanTraCuu setBackgroundColor:[UIColor clearColor]];
    [self.btnHuongDanTraCuu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self khoiTaoViewInput];
}

- (IBAction)suKienChonHuongDan:(id)sender {
    [self.btnHuongDan setBackgroundColor:[UIColor whiteColor]];
    [self.btnHuongDan setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.btnTraCuu setBackgroundColor:[UIColor clearColor]];
    [self.btnTraCuu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnHuongDanTraCuu setBackgroundColor:[UIColor clearColor]];
    [self.btnHuongDanTraCuu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self khoiTaoViewHuongDan];
}

- (void)suKienChonHuongDanTraCuu:(id)sender {
    [self.btnTraCuu setBackgroundColor:[UIColor clearColor]];
    [self.btnTraCuu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnHuongDan setBackgroundColor:[UIColor clearColor]];
    [self.btnHuongDan setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnHuongDanTraCuu setBackgroundColor:[UIColor whiteColor]];
    [self.btnHuongDanTraCuu setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self khoiTaoViewHuongDanTraCuu];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_viewShowMain release];
    [_btnTraCuu release];
    [_btnHuongDan release];
    [_stackTop release];
    [_btnHuongDanTraCuu release];
    [super dealloc];
}
@end
