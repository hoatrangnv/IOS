//
//  GiaoDienChiTietTinTuc.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 1/11/19.
//

#import "GiaoDienChiTietTinTuc.h"

@interface GiaoDienChiTietTinTuc () {
    NSString *keyTitle;
    NSString *keyContent;
    NSString *keyImage;
}

@end

@implementation GiaoDienChiTietTinTuc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    keyTitle = @"title_vi";
    keyContent = @"content_vi";
    keyImage = @"img_vi";
    if (self.langID == 2) {
        keyTitle = @"title_en";
        keyContent = @"content_en";
        keyImage = @"img_en";
    }
    [self ketNoiLayChiTietTinTuc];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBarHidden = NO;
}

- (void)ketNoiLayChiTietTinTuc {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hienThiLoading];
    });
    self.mDinhDanhKetNoi = @"LAY_CHI_TIET_TIN_TUC";
    
//    [GiaoDichMang ketNoiLayTinTuc:self.langID idInput:self.sIDTinTuc noiNhanKetQua:self];
    [GiaoDichMang ketNoiLayChiTietTinTuc:self.langID sIDTinTuc:self.sIDTinTuc noiNhanKetQua:self];
}

- (void)xuLyKetNoiThanhCong:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self anLoading];
    });
    if ([sDinhDanhKetNoi isEqualToString:@"LAY_CHI_TIET_TIN_TUC"]) {
        NSDictionary *dict = (NSDictionary *)ketQua;
//        NSLog(@"%s - dict : %@", __FUNCTION__, [dict JSONString]);
        NSString *sTile = (NSString *)[dict valueForKey:keyTitle];
//        self.navigationItem.title = [self decodeBase64:sTile];
        [self addTitleView:[self decodeBase64:sTile]];
        
        NSString *sContent = (NSString *)[dict valueForKey:keyContent];
        NSString *sContentDecode = [self decodeBase64:sContent];
        NSString *html = [NSString stringWithFormat:@"<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" /><meta name=\"viewport\" content=\"width=device-width\" /><style type=\"text/css\">body {font-size: medium; text-align: justify; font-size: 16pt !important;} p {font-size: 16pt !important;} a {font-size: 16pt !important;}div {font-size: 16pt !important;} span {font-size: 16pt !important;} img {max-width: 100%% !important; height: auto !important; width: auto !important;} iframe { max-width: 100%% !important; height: auto !important;}</style></head><body>%@</body></html>", sContentDecode];
        NSLog(@"%s - html : %@", __FUNCTION__, html);
        [self.webChiTiet loadHTMLString:html baseURL:nil];
    }
}

- (NSString *)decodeBase64:(NSString *)base64String {
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    return decodedString;
}

- (void)dealloc {
    [_webChiTiet release];
    [super dealloc];
}
@end
