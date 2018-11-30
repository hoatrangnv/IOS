//
//  HanMucMoiViewController.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 11/15/18.
//

#import "HanMucMoiViewController.h"

@interface HanMucMoiViewController ()<UITextFieldDelegate>

@end

@implementation HanMucMoiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Hạn mức";
    self.tfTimeMPKI.delegate = self;
    self.tfDayMPKI.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (![self.scrMain.subviews containsObject:self.viewUI]) {
        self.viewUI.frame = CGRectMake(8, 8, self.scrMain.frame.size.width - 16, self.viewUI.frame.size.height - self.heightViewMaXacThuc.constant);
        self.viewUI.layer.cornerRadius = 8.0;
        [self.scrMain addSubview:self.viewUI];
        self.heightViewXacThuc.constant -= self.heightViewMaXacThuc.constant;
        self.heightViewMaXacThuc.constant = 0.0;
        [self.viewMaXacThuc setHidden:YES];
        [self.scrMain setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, self.viewUI.frame.size.height)];
    }
    
    if (self.mThongTinTaiKhoanVi) {
        self.tfTimeSoftToken.text = [Common hienThiTienTe:[self.mThongTinTaiKhoanVi.hanMucTimeSoftToken doubleValue]];
        self.tfDaySoftToken.text = [Common hienThiTienTe:[self.mThongTinTaiKhoanVi.hanMucDaySoftToken doubleValue]];
        
        self.tfTimeVanTay.text = [Common hienThiTienTe:[self.mThongTinTaiKhoanVi.hanMucTimeVanTay doubleValue]];
        self.tfDayVanTay.text = [Common hienThiTienTe:[self.mThongTinTaiKhoanVi.hanMucDayVanTay doubleValue]];
        
        self.tfTimeMPKI.text = @"";
        self.tfDayMPKI.text = @"";
    }
}

- (void)hideViewNhapToken {
    
}

- (BOOL)validateVanTay {
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    [self.viewSMS setHidden:![textField.text isEmpty]];
    [self.viewToken setHidden:![textField.text isEmpty]];
    return YES;
}

- (IBAction)suKienChonSMS:(id)sender {
    if (self.heightViewMaXacThuc.constant > 0) {
        CGRect frame = self.viewUI.frame;
        self.heightViewXacThuc.constant -= self.heightViewMaXacThuc.constant;
        frame.size.height -= self.heightViewMaXacThuc.constant;
        self.viewUI.frame = frame;
        self.heightViewMaXacThuc.constant = 0;
    }
    [self.viewMaXacThuc setHidden:YES];
}

- (IBAction)suKienChonToken:(id)sender {
    if (self.heightViewMaXacThuc.constant == 0.0) {
        self.heightViewMaXacThuc.constant = 40.0;
        self.heightViewXacThuc.constant += self.heightViewMaXacThuc.constant;
        CGRect frame = self.viewUI.frame;
        frame.size.height += self.heightViewMaXacThuc.constant;
        self.viewUI.frame = frame;
    }
    [self.tfMaXacThuc setPlaceholder:@"Mật khẩu token"];
    [self.viewMaXacThuc setHidden:NO];
}

- (IBAction)suKienChonMKPI:(id)sender {
    if (self.heightViewMaXacThuc.constant == 0.0) {
        self.heightViewMaXacThuc.constant = 40.0;
        self.heightViewXacThuc.constant += self.heightViewMaXacThuc.constant;
        CGRect frame = self.viewUI.frame;
        frame.size.height += self.heightViewMaXacThuc.constant;
        self.viewUI.frame = frame;
    }
    [self.tfMaXacThuc setPlaceholder:@"Chữ ký mPKI"];
    [self.viewMaXacThuc setHidden:NO];
}

- (IBAction)suKienChonThucHien:(id)sender {
}

- (void)dealloc {
    [_scrMain release];
    [_viewUI release];
    [_heightViewXacThuc release];
    [_heightViewMaXacThuc release];
    [_btnSMS release];
    [_btnToken release];
    [_btnMKPI release];
    [_viewMaXacThuc release];
    [_tfMaXacThuc release];
    [_tfTimeSoftToken release];
    [_tfDaySoftToken release];
    [_tfTimeVanTay release];
    [_tfDayVanTay release];
    [_tfTimeMPKI release];
    [_tfDayMPKI release];
    [_viewSMS release];
    [_viewToken release];
    [_viewMPKI release];
    [super dealloc];
}
@end
