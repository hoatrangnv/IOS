//
//  HuongDanNapTienViewController.m
//  ViViMASS
//
//  Created by DucBT on 2/27/15.
//
//

#import "HuongDanNapTienViewController.h"
#import "NapViTuTheNganHangViewController.h"
#import "MuonTienViewController.h"
#import "DucNT_ChuyenTienViDenViViewController.h"
#import "DanhSachQuaTangViewController.h"

@interface HuongDanNapTienViewController () <UIWebViewDelegate>

@property (retain, nonatomic) IBOutlet UIWebView *mwvHienThiNoiDung;
@end

@implementation HuongDanNapTienViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addButtonBack];
//    self.navigationItem.title = @"Hướng dẫn nạp tiền vào ví";
    [self addTitleView:@"Hướng dẫn nạp tiền vào ví"];
    [RoundAlert show];
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"huongdannaptien" ofType:@"txt"]];
    
    NSString *sXauHtml = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    
    [self.mwvHienThiNoiDung loadHTMLString:sXauHtml baseURL:nil];
    [sXauHtml release];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSURL *url = request.URL;
        NSLog(@"%s - url : %@", __FUNCTION__, [url lastPathComponent]);
        switch ([[url lastPathComponent] intValue]) {
            case 1:{
                NapViTuTheNganHangViewController *napViTuTheNganHangViewController = [[NapViTuTheNganHangViewController alloc] initWithNibName:@"NapViTuTheNganHangViewController" bundle:nil];
                [self.navigationController pushViewController:napViTuTheNganHangViewController animated:YES];
                [napViTuTheNganHangViewController release];
                break;
            }
            case 2:{
                NapViTuTheNganHangViewController *napViTuTheNganHangViewController = [[NapViTuTheNganHangViewController alloc] initWithNibName:@"NapViTuTheNganHangViewController" bundle:nil];
                [self.navigationController pushViewController:napViTuTheNganHangViewController animated:YES];
                [napViTuTheNganHangViewController release];
                break;
            }
            case 3:{
                NapViTuTheNganHangViewController *napViTuTheNganHangViewController = [[NapViTuTheNganHangViewController alloc] initWithNibName:@"NapViTuTheNganHangViewController" bundle:nil];
                [self.navigationController pushViewController:napViTuTheNganHangViewController animated:YES];
                [napViTuTheNganHangViewController release];
                break;
            }
            case 4:{
                if([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue])
                {
                    MuonTienViewController *muonTienViewController = [[MuonTienViewController alloc] initWithNibName:@"MuonTienViewController" bundle:nil];
                    [self.navigationController pushViewController:muonTienViewController animated:YES];
                    [muonTienViewController release];
                }
                else
                {
                    [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng đăng nhập trước khi thực hiện yêu cầu."];
                }
                break;
            }
            case 5:{
                if([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue])
                {
                    DucNT_ChuyenTienViDenViViewController *chuyenTienDenVi = [[DucNT_ChuyenTienViDenViViewController alloc] initWithNibName:@"DucNT_ChuyenTienViDenViViewController" bundle:nil];
                    [self.navigationController pushViewController:chuyenTienDenVi animated:YES];
                    [chuyenTienDenVi release];
                }
                else
                {
                    [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng đăng nhập trước khi thực hiện yêu cầu."];
                }
                break;
            }
            case 6:{
                if([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue])
                {
                    DanhSachQuaTangViewController *danhSachQuaTangViewController = [[DanhSachQuaTangViewController alloc] initWithNibName:@"DanhSachQuaTangViewController" bundle:nil];
                    [self.navigationController pushViewController:danhSachQuaTangViewController animated:YES];
                    [danhSachQuaTangViewController release];
                }
                else
                {
                    [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng đăng nhập trước khi thực hiện yêu cầu."];
                }
                break;
            }
            default:
                break;
        }
    }
    return YES;
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [RoundAlert hide];
}

- (void)dealloc {
    [_mwvHienThiNoiDung release];
    [super dealloc];
}
@end
