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

- (void)ketNoiLayChiTietTinTuc {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hienThiLoading];
    });
    self.mDinhDanhKetNoi = @"LAY_CHI_TIET_TIN_TUC";
    
//    [GiaoDichMang ketNoiLayTinTuc:self.langID idInput:self.sIDTinTuc noiNhanKetQua:self];
    [GiaoDichMang ketNoiLayChiTietTinTuc:self.langID sIDTinTuc:self.sIDTinTuc noiNhanKetQua:self];
}

- (void)xuLyKetNoiThanhCong:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua {
    [self anLoading];
    if ([sDinhDanhKetNoi isEqualToString:@"LAY_CHI_TIET_TIN_TUC"]) {
        NSDictionary *dict = (NSDictionary *)ketQua;
//        NSLog(@"%s - dict : %@", __FUNCTION__, [dict JSONString]);
        NSString *sTile = (NSString *)[dict valueForKey:keyTitle];
        self.navigationItem.title = [self decodeBase64:sTile];
        
        NSString *sContent = (NSString *)[dict valueForKey:keyContent];
        NSString *html = [self decodeBase64:sContent];
        NSLog(@"%s - html : %@", __FUNCTION__, html );
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
