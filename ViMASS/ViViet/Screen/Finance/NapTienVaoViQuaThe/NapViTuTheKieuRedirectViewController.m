//
//  NapViTuTheKieuRedirectViewController.m
//  ViViMASS
//
//  Created by DucBui on 4/23/15.
//
//

#import "NapViTuTheKieuRedirectViewController.h"

@interface NapViTuTheKieuRedirectViewController () <UIWebViewDelegate>

@end

@implementation NapViTuTheKieuRedirectViewController

#pragma mark - life circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addButtonBack];
//    self.title = [@"nap_vi_tu_the_ngan_hang" localizableString];
    [self addTitleView:[@"nap_vi_tu_the_ngan_hang" localizableString]];
    NSURL* url = [NSURL URLWithString:_mURLRedirect];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    
    [RoundAlert show];
    [_mwvHienThi loadRequest:request];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [RoundAlert hide];
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
    if(_mURLRedirect)
        [_mURLRedirect release];
    [_mwvHienThi release];
    [super dealloc];
}
@end
