//
//  GiaoDienHuongDanDangNhap.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 9/1/16.
//
//

#import "GiaoDienHuongDanDangNhap.h"

@interface GiaoDienHuongDanDangNhap ()<UIWebViewDelegate>

@end

@implementation GiaoDienHuongDanDangNhap

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webThongTin.delegate = self;
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"hd_dang_nhap_vi" withExtension:@"html"];
    NSError *error;
    NSString *html = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    [self.webThongTin loadHTMLString:html baseURL:baseURL];

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

- (void)dealloc {
    [_webThongTin release];
    [super dealloc];
}
- (IBAction)suKienBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
