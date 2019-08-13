//
//  GiaoDienGioiThieuVi.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 11/17/17.
//

#import "GiaoDienGioiThieuVi.h"
#import "CommonUtils.h"
@interface GiaoDienGioiThieuVi () <UIGestureRecognizerDelegate,UIWebViewDelegate>{
    BOOL isLongPress;
}

@end

@implementation GiaoDienGioiThieuVi

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"GIỚI THIỆU";
    NSString *fileName = @"hd_gioi_thieu_qr_yte";
    NSString *sType = @"html";
    if (_nType == 1) {
        fileName = @"gioi_thieu_qr_vimass";
    } else if (_nType == 3) {
        fileName = @"huongdannaptien";
        sType = @"txt";
    }
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:fileName ofType:sType];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [_webHuongDan loadHTMLString:htmlString baseURL: [[NSBundle mainBundle] bundleURL]];

}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *fontSize=@"143";
    NSString *jsString = [[NSString alloc]      initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'",[fontSize intValue]];
    [_webHuongDan stringByEvaluatingJavaScriptFromString:jsString];
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
