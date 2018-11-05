//
//  GiaoDienGioiThieuVi.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 11/17/17.
//

#import "GiaoDienGioiThieuVi.h"
#import "CommonUtils.h"
@interface GiaoDienGioiThieuVi () <UIGestureRecognizerDelegate>{
    BOOL isLongPress;
}

@end

@implementation GiaoDienGioiThieuVi

- (void)viewDidLoad {
    [super viewDidLoad];
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"QR của tôi", @"Hướng dẫn"]];

    segment.selectedSegmentIndex = 0;
    [segment addTarget:self action:@selector(suKienThayDoiSegment:) forControlEvents:UIControlEventValueChanged];
    CGRect rectSegment = segment.frame;
    NSLog(@"%s - rectSegment : %f", __FUNCTION__, rectSegment.size.height);
    rectSegment.size.width += 10;
    rectSegment.size.height = 34;
    segment.frame = rectSegment;
    self.navigationItem.titleView = segment;
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"hd_quang_cao_vi" ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [_webHuongDan loadHTMLString:htmlString baseURL: [[NSBundle mainBundle] bundleURL]];

    UIColor *selectedColor = [UIColor whiteColor];
    UIColor *deselectedColor = [UIColor lightGrayColor];
    for (UIControl *subview in [segment subviews]) {
        if ([subview isSelected]) {
            [subview setTintColor:selectedColor];
        }
        else {
            [subview setTintColor:deselectedColor];
        }
    }

    isLongPress = NO;
    self.imgvQR.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longHander = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleHoldGesture:)];
    longHander.delegate = self;
    longHander.minimumPressDuration = 1;
    [self.imgvQR addGestureRecognizer:longHander];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%s - self.mThongTinTaiKhoanVi.linkQR : %@", __FUNCTION__, self.mThongTinTaiKhoanVi.linkQR);
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache removeImageForKey:self.mThongTinTaiKhoanVi.linkQR fromDisk:YES withCompletion:^{
        NSLog(@"%s - linkQR : %@", __FUNCTION__, self.mThongTinTaiKhoanVi.linkQR);
        [CommonUtils displayImage:[NSURL URLWithString:self.mThongTinTaiKhoanVi.linkQR] toImageView:self.imgvQR placeHolder:nil];
    }];

    self.lblName.text = self.mThongTinTaiKhoanVi.sNameAlias;
    NSString *sDuongDanAnhDaiDien = self.mThongTinTaiKhoanVi.sLinkAnhDaiDien;
    [self.imgvAvatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://vimass.vn/vmbank/services/media/getImage?id=%@", sDuongDanAnhDaiDien]] placeholderImage:[UIImage imageNamed:@"icon_danhba"]];
}

- (void) handleHoldGesture:(UILongPressGestureRecognizer *)gestureRecognizer
{
    NSLog(@"%s - START", __FUNCTION__);
    if (!isLongPress) {
        isLongPress = YES;
        [self showThongBaoLuuQRCode];
    }
}

- (void)showThongBaoLuuQRCode {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Thông báo" message:@"Lưu ảnh QRCode vào thư viện ảnh của điện thoại?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Đóng" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        isLongPress = NO;
    }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Lưu" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImage *img = self.imgvQR.image;
        if (img != nil) {
            UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
        }
        [alert dismissViewControllerAnimated:YES completion:^{
        }];
    }];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)suKienThayDoiSegment:(UISegmentedControl *)segment {
    if (segment.selectedSegmentIndex == 0) {
        [self.webHuongDan setHidden:YES];
        [self.viewQR setHidden:NO];
    }
    else {
        [self.webHuongDan setHidden:NO];
        [self.viewQR setHidden:YES];
    }
    UIColor *selectedColor = [UIColor whiteColor];
    UIColor *deselectedColor = [UIColor lightGrayColor];
    for (UIControl *subview in [segment subviews]) {
        if ([subview isSelected]) {
            [subview setTintColor:selectedColor];
        }
        else {
            [subview setTintColor:deselectedColor];
        }
    }
}

- (void)dealloc {
    [_webHuongDan release];
    [_viewQR release];
    [_imgvQR release];
    [_imgvAvatar release];
    [_lblName release];
    [super dealloc];
}
@end
