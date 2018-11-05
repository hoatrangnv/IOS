//
//  GiaoDienDatVeXemPhim.m
//  ViViMASS
//
//  Created by nguyen tam on 9/17/15.
//
//

#import "GiaoDienDatChoXemPhim.h"
#import "ItemPhongXemFilm.h"
#import "ItemHangXemFilm.h"
#import "ItemGheXemFilm.h"
#import "ObjectFilm.h"
#import "ObjectGioChieu.h"
#import "CellGroupNgayChieuPhim.h"
#import "CellGioChieuPhim.h"
#import "WebViewJavascriptBridge.h"
#import "ItemChonGheCGV.h"
#import "ItemGiaVeCGV.h"

@import WebKit;
@interface GiaoDienDatChoXemPhim () <UIWebViewDelegate, UIScrollViewDelegate>{
    BOOL isLounge, is3D, isTiepTuc;
    NSMutableArray *arrGheChon;
    BOOL bPhongTo;
}
@property WebViewJavascriptBridge *bridge;
@end

@implementation GiaoDienDatChoXemPhim

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addButtonBack];
    isTiepTuc = NO;
    bPhongTo = NO;
    [self.webPhongChieu setScalesPageToFit:YES];
//    self.webPhongChieu.scrollView.maximumZoomScale = 10;
    self.webPhongChieu.delegate = self;
    self.webPhongChieu.scrollView.delegate = self;
    for (ItemHangXemFilm *itemTemp in self.phongHienTai.arrDayGhe) {
        for (ItemGheXemFilm *temp in itemTemp.arrGhe) {

            NSLog(@"%s - itemTemp.stt : %@ - temp.gia : %@", __FUNCTION__, itemTemp.stt, temp.gia);

        }
    }

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%s - self.sHeaderRap : %@", __FUNCTION__, self.sHeaderRap);
    if ([self.sHeaderRap hasPrefix:@"CGV"]) {
        self.viewGheCGV.hidden = NO;
        self.viewGhePlatium.hidden = YES;
        NSLog(@"%s - _arrGheCGV.count : %ld", __FUNCTION__, (long)_arrGheCGV.count);
        if (self.phongHienTai) {
            [self addTitleView:[NSString stringWithFormat:@"Phòng chiếu %@", self.phongHienTai.phong]];
            NSString *sHtml = [self hienThiPhongChieu];

            [self.webPhongChieu loadHTMLString:sHtml baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
        }
    }
    else if ([self.sHeaderRap.lowercaseString isEqualToString:@"trung tâm chiếu phim quốc gia"]) {
        self.viewGheCGV.hidden = YES;
        self.viewGhePlatium.hidden = YES;
        if (self.phongHienTai) {
            [self addTitleView:[NSString stringWithFormat:@"Phòng chiếu %@", self.phongHienTai.phong]];
            NSString *sHtml = [self hienThiPhongChieu];

            [self.webPhongChieu loadHTMLString:sHtml baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
        }
    }
    else {
        self.viewGheCGV.hidden = YES;
        self.viewGhePlatium.hidden = NO;
        if (self.phongHienTai) {
            [self addTitleView:[NSString stringWithFormat:@"Phòng chiếu %@", self.phongHienTai.phong]];
            NSString *sHtml = [self hienThiPhongChieu];

            [self.webPhongChieu loadHTMLString:sHtml baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
            if ([self.sTenFilm containsString:@"D Lounge"]) {
                isLounge = YES;
            }
            else{
                isLounge = NO;
            }
            if ([self.sTenFilm hasPrefix:@"3D"]) {
                is3D = YES;
            }
            else{
                is3D = NO;
            }
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    bPhongTo = NO;
//    if ([self.sHeaderRap hasPrefix:@"CGV"]) {
//        if (!isTiepTuc) {
//            for (ItemGheXemFilm *item in arrGheChon) {
//                if (item.trangthai > 1) {
//                    item.trangthai = 0;
//                }
//            }
//            [arrGheChon removeAllObjects];
//        }
//    }
//    else {
        if (self.delegate) {
            NSLog(@"%s - self.delegate != nil", __FUNCTION__);
            [self.delegate sendLaiRapPhim:self.phongHienTai gheChon:arrGheChon];
        }
//    }
}

- (NSString *)hienThiPhongChieu{
    NSLog(@"%s - START", __FUNCTION__);
    NSString *html = @"";
    NSString *sTenFileCss = @"rapphim";
    if ([self.sHeaderRap hasPrefix:@"CGV"] || [self.sHeaderRap hasPrefix:@"BHD"] || [self.sHeaderRap.lowercaseString containsString:@"galaxy"]) {
        html = [self getHtmlPhongChieuCGV2:self.phongHienTai];
        sTenFileCss = @"raphimcgvtam";
    }
    else if ([self.sHeaderRap.lowercaseString isEqualToString:@"trung tâm chiếu phim quốc gia"]) {
        sTenFileCss = @"rapphimquocgia";
        html = [self getHtmlPhongChieuQuocGia:self.phongHienTai];
    }
    else
        html = [self getHtmlPhongChieu:self.phongHienTai];

    NSString *HTML_HEADER=@"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"><html xmlns=\"http://www.w3.org/1999/xhtml\"><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" /><meta name=\"viewport\" content=\"width=720\"><title>Untitled Document</title><style>%@</style><script type='text/javascript'>function locationChange(data1, data2){ var temp = 'tamnv://' + data1 + '&' + data2; window.location=temp;}</script></head><body>";

    NSString *HTML_FOOTER=@"</body></html>";
    NSString *path2 = [[NSBundle mainBundle] pathForResource:sTenFileCss ofType:@"css"];
    NSString *css = [NSString stringWithContentsOfFile:path2 encoding:NSUTF8StringEncoding error:nil];
    NSString *cache = [self absolutePathToCacheDirectory];
    css = [css stringByReplacingOccurrencesOfString:@"tamnv" withString:cache];
    NSString *headerWithCss = [NSString stringWithFormat:HTML_HEADER, css];
    NSString *htmlString = [NSString stringWithFormat:@"%@%@%@",headerWithCss, html, HTML_FOOTER];
//    NSLog(@"%s - htmlString : %@", __FUNCTION__, htmlString);
    return htmlString;
}

- (NSString *) getHtmlPhongChieu:(ItemPhongXemFilm*)item{
    NSString *html = @"";
    if (item) {
        html = [NSString stringWithFormat:@"<div class=\"screen\">Màn hình - phòng chiếu %@</div><div class=\"row\">", item.phong];
        for (int i = 0; i < item.arrDayGhe.count; i++) {
            ItemHangXemFilm *hang = [item.arrDayGhe objectAtIndex:i];
            html = [html stringByAppendingString:@"<ul>\n"];
            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li class=\"anpha\">%@</li>\n", hang.stt]];
            for (int j = (int)hang.arrGhe.count - 1; j >= 0; j --) {
                ItemGheXemFilm *ghe = [hang.arrGhe objectAtIndex:j];
                if ([ghe.hienThi isEqualToString:@"1"]) {
                    if ([ghe.vip isEqualToString:@"0"]) {
                        if (ghe.trangthai == 0) {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)'>%@</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt, ghe.stt]];
                        }
                        else{
                            if (![arrGheChon containsObject:ghe]) {
                                html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"lovebook\">&nbsp;</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt]];
                            }
                            else{
                                html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"book\">&nbsp;</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt]];
                            }
                        }
                    }
                    else if ([ghe.vip isEqualToString:@"1"]) {
                        if (ghe.trangthai == 0) {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"vip\">%@</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt, ghe.stt]];
                        }
                        else{
                            if (![arrGheChon containsObject:ghe]) {
                                html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"lovebook\">&nbsp;</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt]];
                            }
                            else{
                                html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"book\">&nbsp;</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt]];
                            }
                        }
                    }
                    else {
                        if (ghe.trangthai == 0) {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"love\">%@</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt, ghe.stt]];
                        }
                        else{
                            if (![arrGheChon containsObject:ghe]) {
                                html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"lovebook\">&nbsp;</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt]];
                            }
                            else{
                                html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"book\">&nbsp;</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt]];
                            }
                        }
                    }
                }
                else {
                    html = [html stringByAppendingString:@"<li class=\"trang\"><a href=\"\">&nbsp;</a></li>\n"];
                }
            }
            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li class=\"anpha2\">%@</li></ul>\n", hang.stt]];
        }
        html = [html stringByAppendingString:@"</div>"];
    }

    return html;
}

- (NSString *) getHtmlPhongChieuCGV2:(ItemPhongXemFilm*)item{
    NSString *html = @"";
    if (item) {
        html = [NSString stringWithFormat:@"<div class=\"screen\">Màn hình - phòng chiếu <span id=\"soPhong\">%@</span></div>", item.phong];
        if ([self.sHeaderRap hasPrefix:@"BHD"]) {
            html = [NSString stringWithFormat:@"<div class=\"screen\">Màn hình - <span id=\"soPhong\">%@</span></div>", item.phong];
        }
        html = [html stringByAppendingString:@"<div class=\"rowcgv\">\n"];
        for (int i = 0; i < item.arrDayGhe.count; i++) {
            ItemHangXemFilm *hang = [item.arrDayGhe objectAtIndex:i];
            NSLog(@"%s =================== hang : %@", __FUNCTION__, hang.stt);
            html = [html stringByAppendingString:@"<ul>"];
            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li class=\"anpha\">%@</li>\n", hang.stt]];
            for (int j = 0; j < hang.arrGhe.count; j ++) {
                ItemGheXemFilm *ghe = [hang.arrGhe objectAtIndex:j];
                NSLog(@"%s - hang : %@ - ghe : %@ - type : %@ - vip : %@ - hienThi : %@ - ghe.trangthai : %d", __FUNCTION__, hang.stt, ghe.stt, ghe.type, ghe.vip, ghe.hienThi, ghe.trangthai);
                if (![ghe.type isEmpty] && ghe.stt.length > 0) {
                    if (ghe.trangthai != 1) {
                        if ([ghe.type.lowercaseString containsString:@"vip"]) {
                            NSString *class = @"vip";
                            if (ghe.trangthai != 0) {
                                class = @"book";
                            }
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%d\" onclick='javascript:locationChange(%d, %d)' class=\"%@\">%@</li>\n", hang.stt, j, [self getMaChuyenTuChuCaiSangSo:hang.stt], j, class, ghe.stt]];
                        }
                        else if ([ghe.type.lowercaseString containsString:@"standard"] || [ghe.type.lowercaseString containsString:@"happy day"]) {
                            NSString *class = @"";
                            if (ghe.trangthai != 0) {
                                class = @"class=\"book\"";
                            }
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%d\" onclick='javascript:locationChange(%d, %d)' %@>%@</li>\n", hang.stt, j, [self getMaChuyenTuChuCaiSangSo:hang.stt], j, class, ghe.stt]];
                        }
                        else if ([ghe.type.lowercaseString containsString:@"sweetbox"] || [ghe.type.lowercaseString containsString:@"couple"]) {
                            NSString *class = @"love";
                            if (ghe.trangthai != 0) {
                                class = @"book";
                            }
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%d\" onclick='javascript:locationChange(%d, %d)' class=\"%@\">%@</li>\n", hang.stt, j, [self getMaChuyenTuChuCaiSangSo:hang.stt], j, class, ghe.stt]];
                        }
                    }
                    else {
                        html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"book\">&nbsp;</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt]];
                    }
                }
                else {
                    html = [html stringByAppendingString:@"<li class=\"trang\">&nbsp;</li>\n"];
                }
            }
            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li class=\"anpha2\">%@</li></ul>\n", hang.stt]];
        }
        html = [html stringByAppendingString:@"</div>"];
    }
    return html;
}

- (NSString *) getHtmlPhongChieuCGV:(ItemPhongXemFilm*)item{
    NSString *html = @"";
    if (item) {
        html = [NSString stringWithFormat:@"<div class=\"screen\">Màn hình - phòng chiếu <span id=\"soPhong\">%@</span></div>", item.phong];
        html = [html stringByAppendingString:@"<div class=\"rowcgv\">\n"];
        for (int i = 0; i < item.arrDayGhe.count; i++) {
            ItemHangXemFilm *hang = [item.arrDayGhe objectAtIndex:i];
            NSLog(@"%s =================== hang : %@", __FUNCTION__, hang.stt);
            html = [html stringByAppendingString:@"<ul>"];
            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li class=\"anpha\">%@</li>\n", hang.stt]];
            for (int j = (int)hang.arrGhe.count - 1; j >= 0; j --) {
                ItemGheXemFilm *ghe = [hang.arrGhe objectAtIndex:j];
                NSLog(@"%s - hang : %@ - ghe : %@ - type : %@ - vip : %@ - hienThi : %@", __FUNCTION__, hang.stt, ghe.stt, ghe.type, ghe.vip, ghe.hienThi);
                if ([ghe.hienThi isEqualToString:@"1"]) {
                    if ([ghe.vip isEqualToString:@"0"]) {
                        if (ghe.trangthai == 0) {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)'>%@</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt, ghe.stt]];
                        }
                        else {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"book\">&nbsp;</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt]];
                        }
                    }
                    else if ([ghe.vip isEqualToString:@"1"]) {
                        if (ghe.trangthai == 0) {
                            if ([ghe.type containsString:@"vip"]) {
                                html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"vip\">%@</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt, ghe.stt]];
                            }
                            else if ([ghe.type containsString:@"deluxe"]) {
                                html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"deluxe\">%@</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt, ghe.stt]];
                            }
                            else if ([ghe.type containsString:@"couple"]) {
                                html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"couple\">%@</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt, ghe.stt]];
                            }
                            else {
                                html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"vip\">%@</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt, ghe.stt]];
                            }
                        }
                        else {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"vip book\">&nbsp;</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt]];
                        }
                    }
                    else if ([ghe.vip isEqualToString:@"2"]) {
                        if (ghe.trangthai == 0) {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"love\">%@</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt, ghe.stt]];
                        }
                        else {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"love book\">&nbsp;</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt]];
                        }
                    }
                    else if ([ghe.vip isEqualToString:@"3"]) {
                        if (ghe.trangthai == 0) {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"premium\">%@</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt, ghe.stt]];
                        }
                        else {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"premium book\">&nbsp;</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt]];
                        }
                    }
                    else if ([ghe.vip isEqualToString:@"4"]) {
                        if (ghe.trangthai == 0) {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"handicap\">%@</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt, ghe.stt]];
                        }
                        else {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"handicap book\">&nbsp;</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt]];
                        }
                    }
                    else if ([ghe.vip isEqualToString:@"5"]) {
                        if (ghe.trangthai == 0) {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"bond\">%@</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt, ghe.stt]];
                        }
                        else {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"bond book\">&nbsp;</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt]];
                        }
                    }
                    else if ([ghe.vip isEqualToString:@"6"]) {
                        if (ghe.trangthai == 0) {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"couple\">%@</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt, ghe.stt]];
                        }
                        else {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"book\">&nbsp;</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt]];
                        }
                    }
                    else if ([ghe.vip isEqualToString:@"7"]) {
                        if (ghe.trangthai == 0) {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"deluxe\">%@</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt, ghe.stt]];
                        }
                        else {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"book\">&nbsp;</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt]];
                        }
                    }
                    else if ([ghe.vip isEqualToString:@"8"]) {
                        if (ghe.trangthai == 0) {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"coupleS\">%@</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt, ghe.stt]];
                        }
                        else {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"book\">&nbsp;</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt]];
                        }
                    }
                    else if ([ghe.vip isEqualToString:@"9"]) {
                        if (ghe.trangthai == 0) {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"gold\">%@</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt, ghe.stt]];
                        }
                        else {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"gold book\">&nbsp;</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt]];
                        }
                    }
                }
                else {
                    html = [html stringByAppendingString:@"<li class=\"trang\">&nbsp;</li>\n"];
                }
            }
            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li class=\"anpha2\">%@</li></ul>\n", hang.stt]];
        }
        html = [html stringByAppendingString:@"</div>"];
    }
    return html;
}

- (NSString *) getHtmlPhongChieuQuocGia:(ItemPhongXemFilm*)item{
    NSString *html = @"";
    if (item) {
        html = [NSString stringWithFormat:@"<div class=\"screen\">Màn hình - phòng chiếu %@</div><div class=\"rowquocgia\">", item.phong];
        for (int i = 0; i < item.arrDayGhe.count; i++) {
            ItemHangXemFilm *hang = [item.arrDayGhe objectAtIndex:i];
            html = [html stringByAppendingString:@"<ul>\n"];
            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li class=\"anpha\">%@</li>\n", hang.stt]];
            for (int j = (int)hang.arrGhe.count - 1; j >= 0; j --) {
                ItemGheXemFilm *ghe = [hang.arrGhe objectAtIndex:j];
                if ([ghe.hienThi isEqualToString:@"1"] && ghe.stt.length > 0) {
                    if ([ghe.name.lowercaseString isEqualToString:@"ghế thường"]) {
                        if (ghe.trangthai == 0) {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)'>%@</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt, ghe.stt]];
                        }
                        else{
                            if (![arrGheChon containsObject:ghe]) {
                                html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"lovebook\">&nbsp;</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt]];
                            }
                            else{
                                html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"book\">&nbsp;</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt]];
                            }
                        }
                    }
                    else if ([ghe.name.lowercaseString isEqualToString:@"ghế vip"]) {
                        if (ghe.trangthai == 0) {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"vip\">%@</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt, ghe.stt]];
                        }
                        else{
                            if (![arrGheChon containsObject:ghe]) {
                                html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"lovebook\">&nbsp;</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt]];
                            }
                            else{
                                html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"book\">&nbsp;</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt]];
                            }
                        }
                    }
                    else {
                        if (ghe.trangthai == 0) {
                            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"love\">%@</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt, ghe.stt]];
                        }
                        else{
                            if (![arrGheChon containsObject:ghe]) {
                                html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"lovebook\">&nbsp;</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt]];
                            }
                            else{
                                html = [html stringByAppendingString:[NSString stringWithFormat:@"<li id=\"%@%@\" onclick='javascript:locationChange(%d, %@)' class=\"book\">&nbsp;</li>\n", hang.stt, ghe.stt, [self getMaChuyenTuChuCaiSangSo:hang.stt], ghe.stt]];
                            }
                        }
                    }
                }
                else {
                    html = [html stringByAppendingString:@"<li class=\"trang\"><a href=\"\">&nbsp;</a></li>\n"];
                }
            }
            html = [html stringByAppendingString:[NSString stringWithFormat:@"<li class=\"anpha2\">%@</li></ul>\n", hang.stt]];
        }
        html = [html stringByAppendingString:@"</div>"];
    }

    return html;
}

- (NSString *)absolutePathToCacheDirectory{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [cachePath stringByExpandingTildeInPath];
    if ([path characterAtIndex:0] != '/') {
        path = [[NSString stringWithFormat:@"~/Documents/%@", path] stringByExpandingTildeInPath];
    }
    return path;
}

#pragma mark - UIWebviewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"%s - click click navigationType : %ld", __FUNCTION__, (long)navigationType);
    if (navigationType == UIWebViewNavigationTypeOther) {
        NSURL *url = request.URL;
        if (![url.absoluteString hasPrefix:@"tamnv://"]) {
            if ([url.absoluteString hasPrefix:@"file://"]) {
                return YES;
            }
            return NO;
        }
        NSString *sLastPath = [url.absoluteString stringByReplacingOccurrencesOfString:@"tamnv://" withString:@""];
        NSLog(@"%s - url : %@", __FUNCTION__, sLastPath);
        NSArray *arrTemp = [sLastPath componentsSeparatedByString:@"&"];
        if (arrTemp && arrTemp.count > 1)
        {
            NSString *sHangGheTemp = [arrTemp objectAtIndex:0];
            NSLog(@"%s - sHangGhe : %d", __FUNCTION__, [sHangGheTemp intValue]);
            NSString *sHangGhe = [self getMaChuyenTuSoSangChu:[sHangGheTemp intValue]];
            NSString *sGhe = [arrTemp objectAtIndex:1];
            if ([self.sHeaderRap hasPrefix:@"CGV"] || [self.sHeaderRap hasPrefix:@"BHD"] || [self.sHeaderRap.lowercaseString containsString:@"galaxy"]) {
                [self capNhatPhongKhiChonGheCGV2:sHangGhe ghe:[sGhe intValue]];
            }
            else if ([self.sHeaderRap.lowercaseString isEqualToString:@"trung tâm chiếu phim quốc gia"]) {
                [self capNhatPhongKhiChonGheQuocGia:sHangGhe ghe:[sGhe intValue]];
            }
            else
                [self capNhatPhongKhiChonGhe:sHangGhe ghe:[sGhe intValue]];
        }
        return YES;
    }
    return NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"%s - load xong roi", __FUNCTION__);
    [self.webPhongChieu.scrollView setZoomScale:2.5 animated:YES];
//    self.webPhongChieu.scalesPageToFit = YES;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    NSLog(@"%s ======> zoom", __FUNCTION__);
    if (!bPhongTo) {
        CGSize sizeWeb = scrollView.contentSize;
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        int nX = (sizeWeb.width - width) / 2;
        self.webPhongChieu.scrollView.contentOffset = CGPointMake(nX, 0);
        bPhongTo = YES;
    }
}

#pragma mark - Xu Ly
- (void)capNhatPhongKhiChonGheCGV2:(NSString*)sHang ghe:(int)ghe{
    NSLog(@"%s ========== sHang : %@ - ghe : %d", __FUNCTION__, sHang, ghe);
    if (!self.arrGheCGV) {
        return;
    }
    if (!arrGheChon) {
        arrGheChon = [[NSMutableArray alloc] init];
    }
    NSString *sID = [NSString stringWithFormat:@"%@%d", sHang, ghe];
    NSLog(@"%s - sID : %@", __FUNCTION__, sID);

    for (ItemHangXemFilm *itemHangGhe in self.phongHienTai.arrDayGhe) {
        if ([itemHangGhe.stt isEqualToString:sHang]) {
            if (itemHangGhe.arrGhe.count > ghe) {
                ItemGheXemFilm *itemGhe = [itemHangGhe.arrGhe objectAtIndex:ghe];
                NSLog(@"%s - click ghe : itemGhe.trangthai: %d - itemGhe.type : %@", __FUNCTION__, itemGhe.trangthai, itemGhe.type);

                 if (itemGhe.trangthai == 0) {
                     if ([itemGhe.type.lowercaseString containsString:@"sweetbox"] || [itemGhe.type.lowercaseString containsString:@"couple"]) {
                         NSLog(@"%s - sweetbox : %d", __FUNCTION__, [self kiemTraDieuKienGheSweetBox:itemHangGhe ghe:ghe]);
                         if ([self kiemTraDieuKienGheSweetBox:itemHangGhe ghe:ghe] == 4) {
                             NSLog(@"%s - lua chon ghe ben phai", __FUNCTION__);
                             ItemGheXemFilm *itemGhePhai = [itemHangGhe.arrGhe objectAtIndex:ghe - 1];
                             itemGhe.trangthai = 4;
                             itemGhePhai.trangthai = 4;
                             [arrGheChon addObject:itemGhe];
                             [arrGheChon addObject:itemGhePhai];
                             NSString *sQuerry1 = [NSString stringWithFormat:@"document.getElementById(\"%@\").className = \"%@\";", sID, @"book"];
                             NSString *sIDPhai = [NSString stringWithFormat:@"%@%d", sHang, ghe - 1];
                             NSString *sQuerry2 = [NSString stringWithFormat:@"document.getElementById(\"%@\").className = \"%@\";", sIDPhai, @"book"];
                             NSLog(@"%s - sQuerry1 : %@", __FUNCTION__, sQuerry1);
                             NSLog(@"%s - sQuerry2 : %@", __FUNCTION__, sQuerry2);
                             [self.webPhongChieu stringByEvaluatingJavaScriptFromString:sQuerry1];
                             [self.webPhongChieu stringByEvaluatingJavaScriptFromString:sQuerry2];
                             [self.webPhongChieu reload];
                         }
                         else if ([self kiemTraDieuKienGheSweetBox:itemHangGhe ghe:ghe] == 5) {
                             NSLog(@"%s - lua chon ghe ben trai", __FUNCTION__);
                             ItemGheXemFilm *itemGheTrai = [itemHangGhe.arrGhe objectAtIndex:ghe + 1];
                             itemGhe.trangthai = 5;
                             itemGheTrai.trangthai = 5;
                             [arrGheChon addObject:itemGhe];
                             [arrGheChon addObject:itemGheTrai];
                             NSString *sQuerry1 = [NSString stringWithFormat:@"document.getElementById(\"%@\").className = \"%@\";", sID, @"book"];
                             NSString *sIDTrai = [NSString stringWithFormat:@"%@%d", sHang, ghe + 1];
                             NSString *sQuerry2 = [NSString stringWithFormat:@"document.getElementById(\"%@\").className = \"%@\";", sIDTrai, @"book"];
                             NSLog(@"%s - sQuerry1 : %@", __FUNCTION__, sQuerry1);
                             NSLog(@"%s - sQuerry2 : %@", __FUNCTION__, sQuerry2);
                             [self.webPhongChieu stringByEvaluatingJavaScriptFromString:sQuerry1];
                             [self.webPhongChieu stringByEvaluatingJavaScriptFromString:sQuerry2];
                             [self.webPhongChieu reload];
                         }
                     }
                     else {
                         if ([itemGhe.type.lowercaseString containsString:@"standard"]) {
                             if ([self kiemTraDieuKienGheThuongCGV:itemHangGhe ghe:ghe] == 2) {
                                 NSLog(@"%s - click ghe thuong", __FUNCTION__);
                                 itemGhe.trangthai = 2;
                             }
                         }
                         else if ([itemGhe.type.lowercaseString containsString:@"vip"]) {
                             if ([self kiemTraDieuKienGheVipCGV:itemHangGhe ghe:ghe] == 3) {
                                 NSLog(@"%s - click ghe vip", __FUNCTION__);
                                 itemGhe.trangthai = 3;
                             }
                         }

                         NSLog(@"%s - click ghe : itemGhe.trangthai: %d", __FUNCTION__, itemGhe.trangthai);
                         if (itemGhe.trangthai > 1) {
                             [arrGheChon addObject:itemGhe];
                             if (sID.length > 0) {
                                 NSString *sQuerry = [NSString stringWithFormat:@"document.getElementById(\"%@\").className = \"%@\";", sID, @"book"];
                                 [self.webPhongChieu stringByEvaluatingJavaScriptFromString:sQuerry];
                                 [self.webPhongChieu reload];
                             }
                         }
                     }

                 }
                 else if (itemGhe.trangthai == 2 || itemGhe.trangthai == 3) {
                     itemGhe.trangthai = 0;
                     NSString *sQuerry = @"";
                     if ([itemGhe.type.lowercaseString containsString:@"standard"]) {
                         sQuerry = [NSString stringWithFormat:@"document.getElementById(\"%@\").className = \"%@\";", sID, @""];
                     }
                     else {
                         sQuerry = [NSString stringWithFormat:@"document.getElementById(\"%@\").className = \"%@\";", sID, @"vip"];
                     }
                     NSLog(@"%s - sQuerry : %@", __FUNCTION__, sQuerry);
                     [self.webPhongChieu stringByEvaluatingJavaScriptFromString:sQuerry];
                     [self.webPhongChieu reload];
                     [arrGheChon removeObject:itemGhe];
                     NSLog(@"%s - arrGheChon.count : %d", __FUNCTION__, (int)arrGheChon.count);
                 }
                 else if (itemGhe.trangthai == 4 || itemGhe.trangthai == 5) {
                     NSLog(@"%s - itemGhe.trangthai : %d", __FUNCTION__, itemGhe.trangthai);
                     int nDemGheChon = 0;
                     for (int i = ghe + 1; i < itemHangGhe.arrGhe.count; i ++) {
                         ItemGheXemFilm *temp = [itemHangGhe.arrGhe objectAtIndex:i];
                         if (temp.trangthai >= 4) {
                             nDemGheChon ++;
                         }
                         else {
                             break;
                         }
                     }
                     if (nDemGheChon % 2 == 0) {
                         ItemGheXemFilm *gheTrai = [itemHangGhe.arrGhe objectAtIndex:ghe - 1];
                         gheTrai.trangthai = 0;
                         [arrGheChon removeObject:gheTrai];
                         NSString *sIDTrai = [NSString stringWithFormat:@"%@%d", sHang, ghe - 1];
                         NSLog(@"%s - sIDTrai : %@", __FUNCTION__, sIDTrai);
                         NSString *sQuerry1 = [NSString stringWithFormat:@"document.getElementById(\"%@\").className = \"%@\";", sIDTrai, @"love"];
                         [self.webPhongChieu stringByEvaluatingJavaScriptFromString:sQuerry1];
                     }
                     else {
                         ItemGheXemFilm *ghePhai = [itemHangGhe.arrGhe objectAtIndex:ghe + 1];
                         ghePhai.trangthai = 0;
                         [arrGheChon removeObject:ghePhai];
                         NSString *sIDPhai = [NSString stringWithFormat:@"%@%d", sHang, ghe + 1];
                         NSLog(@"%s - sIDPhai : %@", __FUNCTION__, sIDPhai);
                         NSString *sQuerry1 = [NSString stringWithFormat:@"document.getElementById(\"%@\").className = \"%@\";", sIDPhai, @"love"];
                         [self.webPhongChieu stringByEvaluatingJavaScriptFromString:sQuerry1];
                     }
                     itemGhe.trangthai = 0;
                     [arrGheChon removeObject:itemGhe];
                     NSString *sQuerry = [NSString stringWithFormat:@"document.getElementById(\"%@\").className = \"%@\";", sID, @"love"];
                     [self.webPhongChieu stringByEvaluatingJavaScriptFromString:sQuerry];
                     [self.webPhongChieu reload];
                 }
            }
        }
    }
    [self capNhatDanhSachGheChonCGV];
    [self tinhToanTongSoTienPhaiTra];
}

- (int)kiemTraDieuKienGheThuongCGV:(ItemHangXemFilm*)itemHangGhe ghe:(int)nIndexGhe {
    for (ItemGheXemFilm *itemChonGhe in arrGheChon) {
        NSLog(@"%s - itemChonGhe.trangThai : %d", __FUNCTION__, itemChonGhe.trangthai);
    }
    ItemGheXemFilm *temp = [itemHangGhe.arrGhe objectAtIndex:nIndexGhe];
    NSLog(@"%s - temp.trangthai : %d - arrGheChon.count : %d", __FUNCTION__, temp.trangthai, (int)arrGheChon.count);
    for (ItemGiaVeCGV *itemVe in _arrGheCGV) {
        if ([itemVe.tenVe.lowercaseString containsString:@"standard"] || [itemVe.tenVe.lowercaseString containsString:@"happy day"]) {
            if (itemVe.sl > 0) {
                int nDemGheDaChon = 0;
                for (ItemGheXemFilm *itemChonGhe in arrGheChon) {
                    if (itemChonGhe.trangthai == 2) {
                        nDemGheDaChon ++;
                    }
                }
                NSLog(@"%s - nDemGheDaChon : %d", __FUNCTION__, nDemGheDaChon);
                if (nDemGheDaChon < itemVe.sl) {
                    return 2;
                }
            }
            break;
        }
    }
    return 0;
}

- (int)kiemTraDieuKienGheVipCGV:(ItemHangXemFilm*)itemHangGhe ghe:(int)nIndexGhe {
    ItemGheXemFilm *temp = [itemHangGhe.arrGhe objectAtIndex:nIndexGhe];
    NSLog(@"%s - temp.trangthai : %d - arrGheChon.count : %d", __FUNCTION__, temp.trangthai, (int)arrGheChon.count);
    for (ItemGiaVeCGV *itemVe in _arrGheCGV) {
        if ([itemVe.tenVe.lowercaseString containsString:@"vip"]) {
            NSLog(@"%s - so luong ve vip : %d", __FUNCTION__, itemVe.sl);
            if (itemVe.sl > 0) {
                NSLog(@"%s - bat dau dem", __FUNCTION__);
                int nDemGheDaChon = 0;
                for (ItemGheXemFilm *itemChonGhe in arrGheChon) {
                    if (itemChonGhe.trangthai == 3) {
                        nDemGheDaChon ++;
                    }
                }
                NSLog(@"%s - nDemGheDaChon : %d", __FUNCTION__, nDemGheDaChon);
                if (nDemGheDaChon < itemVe.sl) {
                    return 3;
                }
            }
            break;
        }
    }
    return 0;
}

- (int)kiemTraDieuKienGheSweetBox:(ItemHangXemFilm*)itemHangGhe ghe:(int)nIndexGhe {
    NSLog(@"%s - nIndexGhe : %d - arrGheChon.count : %d", __FUNCTION__, nIndexGhe, (int)arrGheChon.count);
    //ItemGheXemFilm *gheHienTai = [itemHangGhe.arrGhe objectAtIndex:nIndexGhe];
    for (ItemGiaVeCGV *itemVe in _arrGheCGV) {
        if ([itemVe.tenVe.lowercaseString containsString:@"sweetbox"] || [itemVe.tenVe.lowercaseString containsString:@"couple"]) {
            NSLog(@"%s - so luong ve sweet : %d", __FUNCTION__, itemVe.sl);
            if (itemVe.sl > 0) {
                NSLog(@"%s - bat dau dem", __FUNCTION__);
                int nDemGheDaChon = 0;
                for (ItemGheXemFilm *itemChonGhe in arrGheChon) {
                    if (itemChonGhe.trangthai == 4 || itemChonGhe.trangthai == 5) {
                        nDemGheDaChon ++;
                    }
                }
                NSLog(@"%s - nDemGheDaChon : %d - nIndexGhe %% 2 : %d", __FUNCTION__, nDemGheDaChon, nIndexGhe % 2);
                if (nDemGheDaChon / 2 < itemVe.sl) {
                    int nDemGheChuaDat = 0;
                    for (int i = nIndexGhe; i < itemHangGhe.arrGhe.count; i ++) {
                        ItemGheXemFilm *temp = [itemHangGhe.arrGhe objectAtIndex:i];
                        if (![temp.type isEmpty]) {
                            nDemGheChuaDat ++;
                        }
                    }
                    NSLog(@"%s - nDemGheChuaDat : %d", __FUNCTION__, nDemGheChuaDat);
                    if (nDemGheChuaDat % 2 == 0) {
                        ItemGheXemFilm *ghePhai = [itemHangGhe.arrGhe objectAtIndex:nIndexGhe + 1];
                        if (ghePhai.trangthai == 0 && ![ghePhai.type isEmpty]) {
                            return 5;
                        }
                        else if ([ghePhai.type isEmpty]) {
                            ItemGheXemFilm *gheTrai = [itemHangGhe.arrGhe objectAtIndex:nIndexGhe - 1];
                            if (gheTrai.trangthai == 0 && ![gheTrai.type isEmpty]) {
                                return 4;
                            }
                        }
                    }
                    else {
                        ItemGheXemFilm *gheTrai = [itemHangGhe.arrGhe objectAtIndex:nIndexGhe - 1];
                        if (gheTrai.trangthai == 0 && ![gheTrai.type isEmpty]) {
                            return 4;
                        }
                        else if ([gheTrai.type isEmpty]) {
                            ItemGheXemFilm *ghePhai = [itemHangGhe.arrGhe objectAtIndex:nIndexGhe + 1];
                            if (ghePhai.trangthai == 0 && ![ghePhai.type isEmpty]) {
                                return 5;
                            }
                        }
                    }
                }
            }
            break;
        }
    }
    return 0;
}

- (int)kiemTraDieuKienGheDeluxeCGV:(ItemHangXemFilm*)itemHangGhe ghe:(int)nIndexGhe {
    if (!arrGheChon) {
        arrGheChon = [[NSMutableArray alloc] init];
    }
    if (_arrGheCGV) {
        ItemGheXemFilm *temp = [itemHangGhe.arrGhe objectAtIndex:nIndexGhe];
        if (temp.trangthai == 1) {
            return 0;
        }
        for (ItemGiaVeCGV *item in _arrGheCGV) {
            NSLog(@"%s - item.idVe : %@ - item.sl : %d", __FUNCTION__, item.idVe, item.sl);
            if (item.sl > 0) {
                if ([item.tenVe.lowercaseString containsString:@"deluxe"] || [item.tenVe.lowercaseString containsString:@"delx"] || [item.tenVe.lowercaseString containsString:@"dlx"]) {
                    if ([item.tenVe.lowercaseString containsString:@"couple"] || [item.tenVe containsString:@"cpl"]) {
                        //chon 2 ghe; neu trai co thi lay phai, va nguoc lai
                        int nDemGheDaChon = 0;
                        for (ItemChonGheCGV *itemChonGhe in arrGheChon) {
                            if (itemChonGhe.nGiaTri == 8) {
                                nDemGheDaChon ++;
                            }
                        }
                        if (nDemGheDaChon < item.sl) {
                            return 8;
                        }
                    }
                    else {
                        //chon 1 ghe
                        int nDemGheDaChon = 0;
                        for (ItemChonGheCGV *itemChonGhe in arrGheChon) {
                            NSLog(@"%s - itemChonGhe.nGiaTri : %d", __FUNCTION__, itemChonGhe.nGiaTri);
                            if (itemChonGhe.nGiaTri == 7) {
                                nDemGheDaChon ++;
                            }
                        }
                        NSLog(@"%s - nDemGheDaChon : %d", __FUNCTION__, nDemGheDaChon);
                        if (nDemGheDaChon < item.sl) {
                            return 7;
                        }
                    }
                }
            }
        }
    }
    return 0;
}

- (int)kiemTraDieuKienGheCapPhiaSauCGV:(ItemHangXemFilm*)itemHangGhe ghe:(int)nIndexGhe {
    if (!arrGheChon) {
        arrGheChon = [[NSMutableArray alloc] init];
    }
    if (_arrGheCGV) {
        ItemGheXemFilm *temp = [itemHangGhe.arrGhe objectAtIndex:nIndexGhe];
        if (temp.trangthai == 1) {
            return 0;
        }
        for (ItemGiaVeCGV *item in _arrGheCGV) {
            NSLog(@"%s - item.idVe : %@ - item.sl : %d", __FUNCTION__, item.idVe, item.sl);
            if (item.sl > 0) {
                if (([item.tenVe.lowercaseString containsString:@"couple"] || [item.tenVe.lowercaseString containsString:@"cpl"]) && ([item.tenVe.lowercaseString containsString:@"standard"] || [item.tenVe.lowercaseString containsString:@"std"]) && ([item.tenVe.lowercaseString containsString:@"vip"]) && ([item.tenVe.lowercaseString containsString:@"delexu"] || [item.tenVe.lowercaseString containsString:@"delx"]) && [item.tenVe.lowercaseString containsString:@"gold class"] && [item.tenVe.lowercaseString containsString:@"4dx"]) {
                    int nDemGheDaChon = 0;
                    for (ItemChonGheCGV *itemChonGhe in arrGheChon) {
                        if (itemChonGhe.nGiaTri == 10) {
                            nDemGheDaChon ++;
                        }
                    }
                    if (nDemGheDaChon < item.sl) {
                        return 10;
                    }
                }
            }
        }
    }
    return 0;
}

- (int)kiemTraDieuKienGheGoldClassCGV:(ItemHangXemFilm*)itemHangGhe ghe:(int)nIndexGhe {
    if (!arrGheChon) {
        arrGheChon = [[NSMutableArray alloc] init];
    }
    if (_arrGheCGV) {
        ItemGheXemFilm *temp = [itemHangGhe.arrGhe objectAtIndex:nIndexGhe];
        if (temp.trangthai == 1) {
            return 0;
        }
        for (ItemGiaVeCGV *item in _arrGheCGV) {
            NSLog(@"%s - item.idVe : %@ - item.sl : %d", __FUNCTION__, item.idVe, item.sl);
            if (item.sl > 0) {
                if ([item.tenVe.lowercaseString containsString:@"gold class"]) {
                    if ([item.tenVe.lowercaseString containsString:@"couple"] || [item.tenVe.lowercaseString containsString:@"cpl"]) {
                        int nDemGheDaChon = 0;
                        for (ItemChonGheCGV *itemChonGhe in arrGheChon) {
                            if (itemChonGhe.nGiaTri == 12) {
                                nDemGheDaChon ++;
                            }
                        }
                        if (nDemGheDaChon < item.sl) {
                            return 12;
                        }
                    }
                    else {
                        int nDemGheDaChon = 0;
                        for (ItemChonGheCGV *itemChonGhe in arrGheChon) {
                            NSLog(@"%s - itemChonGhe.nGiaTri : %d", __FUNCTION__, itemChonGhe.nGiaTri);
                            if (itemChonGhe.nGiaTri == 11) {
                                nDemGheDaChon ++;
                            }
                        }
                        NSLog(@"%s - nDemGheDaChon : %d", __FUNCTION__, nDemGheDaChon);
                        if (nDemGheDaChon < item.sl) {
                            return 11;
                        }
                    }
                }
            }
        }
    }
    return 0;
}

- (int)kiemTraDieuKienGhe4DXCGV:(ItemHangXemFilm*)itemHangGhe ghe:(int)nIndexGhe {
    if (!arrGheChon) {
        arrGheChon = [[NSMutableArray alloc] init];
    }
    if (_arrGheCGV) {
        ItemGheXemFilm *temp = [itemHangGhe.arrGhe objectAtIndex:nIndexGhe];
        if (temp.trangthai == 1) {
            return 0;
        }
        for (ItemGiaVeCGV *item in _arrGheCGV) {
            NSLog(@"%s - item.idVe : %@ - item.sl : %d", __FUNCTION__, item.idVe, item.sl);
            if (item.sl > 0) {
                if ([item.tenVe.lowercaseString containsString:@"4dx"]) {
                    if ([item.tenVe.lowercaseString containsString:@"couple"] || [item.tenVe.lowercaseString containsString:@"cpl"]) {
                        int nDemGheDaChon = 0;
                        for (ItemChonGheCGV *itemChonGhe in arrGheChon) {
                            if (itemChonGhe.nGiaTri == 14) {
                                nDemGheDaChon ++;
                            }
                        }
                        if (nDemGheDaChon < item.sl) {
                            return 14;
                        }
                    }
                    else {
                        int nDemGheDaChon = 0;
                        for (ItemChonGheCGV *itemChonGhe in arrGheChon) {
                            NSLog(@"%s - itemChonGhe.nGiaTri : %d", __FUNCTION__, itemChonGhe.nGiaTri);
                            if (itemChonGhe.nGiaTri == 13) {
                                nDemGheDaChon ++;
                            }
                        }
                        NSLog(@"%s - nDemGheDaChon : %d", __FUNCTION__, nDemGheDaChon);
                        if (nDemGheDaChon < item.sl) {
                            return 13;
                        }
                    }
                }
            }
        }
    }
    return 0;
}

- (BOOL)kiemTraTonTaiGheTrongDieuKienCapVe:(NSMutableArray *)dsGheChon gheKiemTra:(ItemGheXemFilm*) gheKiemTra{
    for (ItemGheXemFilm *temp in dsGheChon) {
        NSLog(@"%s - temp.sId : %@", __FUNCTION__, temp.sId);
        if ([temp.sId isEqualToString:gheKiemTra.sId]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)chonGheThuongDoiCGV:(ItemHangXemFilm*)itemHangGhe nIndexGhe:(int)nIndex {
    if (nIndex < 0 || nIndex >= itemHangGhe.arrGhe.count) {
        return NO;
    }
    ItemGheXemFilm *itemGheTrai = [itemHangGhe.arrGhe objectAtIndex:nIndex];
    if (itemGheTrai.trangthai == 0 && [itemGheTrai.vip isEqualToString:@"0"]) {
        return YES;
    }
    return NO;
}

- (BOOL)chonGheVIPDoiCGV:(ItemHangXemFilm*)itemHangGhe nIndexGhe:(int)nIndex {
    if (nIndex < 0 || nIndex >= itemHangGhe.arrGhe.count) {
        return NO;
    }
    ItemGheXemFilm *itemGheTrai = [itemHangGhe.arrGhe objectAtIndex:nIndex];
    if (itemGheTrai.trangthai == 0 && [itemGheTrai.vip isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

- (BOOL)chonGheSweetBoxDoiCGV:(ItemHangXemFilm*)itemHangGhe nIndexGhe:(int)nIndex {
    if (nIndex < 0 || nIndex >= itemHangGhe.arrGhe.count) {
        return NO;
    }
    ItemGheXemFilm *itemGheTrai = [itemHangGhe.arrGhe objectAtIndex:nIndex];
    if (itemGheTrai.trangthai == 0 && [itemGheTrai.vip isEqualToString:@"2"]) {
        return YES;
    }
    return NO;
}

- (BOOL)chonGheDeluxeBoxDoiCGV:(ItemHangXemFilm*)itemHangGhe nIndexGhe:(int)nIndex {
    if (nIndex < 0 || nIndex >= itemHangGhe.arrGhe.count) {
        return NO;
    }
    ItemGheXemFilm *itemGheTrai = [itemHangGhe.arrGhe objectAtIndex:nIndex];
    if (itemGheTrai.trangthai == 0 && [itemGheTrai.vip isEqualToString:@"7"]) {
        return YES;
    }
    return NO;
}

- (BOOL)chonGheCapPhiaSauCGV:(ItemHangXemFilm*)itemHangGhe nIndexGhe:(int)nIndex {
    if (nIndex < 0 || nIndex >= itemHangGhe.arrGhe.count) {
        return NO;
    }
    ItemGheXemFilm *itemGheTrai = [itemHangGhe.arrGhe objectAtIndex:nIndex];
    if (itemGheTrai.trangthai == 0 && [itemGheTrai.vip isEqualToString:@"6"]) {
        return YES;
    }
    return NO;
}

- (BOOL)chonGheDoiGoldClassCGV:(ItemHangXemFilm*)itemHangGhe nIndexGhe:(int)nIndex {
    if (nIndex < 0 || nIndex >= itemHangGhe.arrGhe.count) {
        return NO;
    }
    ItemGheXemFilm *itemGheTrai = [itemHangGhe.arrGhe objectAtIndex:nIndex];
    NSLog(@"%s - itemGheTrai.vip : %@", __FUNCTION__, itemGheTrai.vip);
    if (itemGheTrai.trangthai == 0 && [itemGheTrai.vip isEqualToString:@"9"]) {
        return YES;
    }
    return NO;
}

- (BOOL)chonGheDoi4DCCGV:(ItemHangXemFilm*)itemHangGhe nIndexGhe:(int)nIndex {
    if (nIndex < 0 || nIndex >= itemHangGhe.arrGhe.count) {
        return NO;
    }
    ItemGheXemFilm *itemGheTrai = [itemHangGhe.arrGhe objectAtIndex:nIndex];
    NSLog(@"%s - itemGheTrai.vip : %@", __FUNCTION__, itemGheTrai.vip);
    if (itemGheTrai.trangthai == 0 && [itemGheTrai.vip isEqualToString:@"5"]) {
        return YES;
    }
    return NO;
}

- (void)capNhatPhongKhiChonGhe:(NSString*)sHang ghe:(int)ghe{
    NSLog(@"%s - sHang : %@", __FUNCTION__, sHang);
    if (!arrGheChon) {
        arrGheChon = [[NSMutableArray alloc] init];
    }
    NSString *sID = @"";
    int nDem = 0;
    for (ItemHangXemFilm *itemHangGhe in self.phongHienTai.arrDayGhe) {
        if ([itemHangGhe.stt isEqualToString:sHang]) {
            for (ItemGheXemFilm *itemGhe in itemHangGhe.arrGhe) {
                if ([itemGhe.stt intValue] == ghe) {
                    if ([arrGheChon containsObject:itemGhe]) {
                        NSLog(@"%s =======================> ton tai trong danh sach : trang thai vip : %@ - itemGhe.trangthai : %d", __FUNCTION__, itemGhe.vip, itemGhe.trangthai);
                        if (![self kIemTraDieuKienKhiBoGhe:itemHangGhe ghe:nDem]) {
                            return;
                        }
                        if (itemGhe.trangthai == 1) {
                            itemGhe.trangthai = 0;
                            sID = [NSString stringWithFormat:@"%@%@", itemHangGhe.stt, itemGhe.stt];
                            NSLog(@"%s =======================> sID : %@", __FUNCTION__, sID);
                            [arrGheChon removeObject:itemGhe];
                            if (sID.length > 0) {
                                NSString *sClassName = @"";
                                NSString *sQuerry = @"";
                                if ([itemGhe.vip isEqualToString:@"0"]) {
                                    sClassName = @"";
                                    sQuerry = [NSString stringWithFormat:@"document.getElementById(\"%@\").className = \"%@\";", sID, @""];
                                }
                                else if ([itemGhe.vip isEqualToString:@"1"])
                                {
                                    if ([itemGhe.vip isEqualToString:@"1"]){
                                        sClassName = @"vip";
                                    }
                                    else{
                                        sClassName = @"love";
                                    }
                                    sQuerry = [NSString stringWithFormat:@"document.getElementById(\"%@\").className = \"%@\";", sID, @"vip"];
                                }
                                else{
                                    NSLog(@"%s ==============> vao trong khu vuc love : sID : %@", __FUNCTION__, sID);
                                    if (ghe % 2 != 0) {
                                        NSLog(@"%s ==============> vao trong khu vuc love : ghe chia 2 != 0)", __FUNCTION__);
                                        ItemGheXemFilm *itemGheLove2 = [itemHangGhe.arrGhe objectAtIndex:(itemHangGhe.arrGhe.count - (ghe + 1))];
                                        [arrGheChon removeObject:itemGheLove2];
                                        NSString *sId2 = [NSString stringWithFormat:@"%@%@", itemHangGhe.stt, itemGheLove2.stt];
                                        NSString *sQuerry2 = [NSString stringWithFormat:@"document.getElementById(\"%@\").className = \"%@\";", sId2, @"love"];
                                        NSLog(@"%s - sQuerry2 : %@", __FUNCTION__, sQuerry2);
                                        [self.webPhongChieu stringByEvaluatingJavaScriptFromString:sQuerry2];
                                    }
                                    else{
                                        NSLog(@"%s ==============> vao trong khu vuc love : ghe chia 2 == 0)", __FUNCTION__);
                                        ItemGheXemFilm *itemGheLove2 = [itemHangGhe.arrGhe objectAtIndex:(itemHangGhe.arrGhe.count - (ghe - 1))];
                                        [arrGheChon removeObject:itemGheLove2];
                                        NSString *sId2 = [NSString stringWithFormat:@"%@%@", itemHangGhe.stt, itemGheLove2.stt];
                                        NSString *sQuerry2 = [NSString stringWithFormat:@"document.getElementById(\"%@\").className = \"%@\";", sId2, @"love"];
                                        [self.webPhongChieu stringByEvaluatingJavaScriptFromString:sQuerry2];
                                    }
                                    sQuerry = [NSString stringWithFormat:@"document.getElementById(\"%@\").className = \"%@\";", sID, @"love"];
                                }
                                NSString *sTemp = [self.webPhongChieu stringByEvaluatingJavaScriptFromString:sQuerry];
                                NSLog(@"%s - sTemp : %@", __FUNCTION__, sTemp);
                                [self.webPhongChieu reload];
                            }
                        }
                    }
                    else{
                        if (itemGhe.trangthai == 0) {
                            if (arrGheChon.count > 12) {
                                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Số vé tối đa là 12 vé."];
                                return;
                            }
                            if ([itemGhe.vip isEqualToString:@"1"] || [itemGhe.vip isEqualToString:@"0"]) {
                                if ([self kiemTraDieuKienGhe:itemHangGhe ghe:nDem]) {
                                    itemGhe.trangthai = 1;
                                    sID = [NSString stringWithFormat:@"%@%@", itemHangGhe.stt, itemGhe.stt];
                                    [arrGheChon addObject:itemGhe];

                                    if (sID.length > 0) {
                                        NSString *sQuerry = [NSString stringWithFormat:@"document.getElementById(\"%@\").className = \"%@\";", sID, @"vip select"];
                                        [self.webPhongChieu stringByEvaluatingJavaScriptFromString:sQuerry];
                                        [self.webPhongChieu reload];
                                    }
                                }
                                else{
                                    return;
                                }
                            }
                            else{
                                if (ghe % 2 != 0) {
                                    ItemGheXemFilm *itemGheLove2 = [itemHangGhe.arrGhe objectAtIndex:(itemHangGhe.arrGhe.count - (ghe + 1))];
                                    [arrGheChon addObject:itemGhe];
                                    [arrGheChon addObject:itemGheLove2];
                                    itemGhe.trangthai = 1;
                                    itemGheLove2.trangthai = 1;
                                    sID = [NSString stringWithFormat:@"%@%@", itemHangGhe.stt, itemGhe.stt];
                                    NSString *sQuerry = [NSString stringWithFormat:@"document.getElementById(\"%@\").className = \"%@\";", sID, @"vip select"];

                                    NSString *sId2 = [NSString stringWithFormat:@"%@%@", itemHangGhe.stt, itemGheLove2.stt];
                                    NSString *sQuerry2 = [NSString stringWithFormat:@"document.getElementById(\"%@\").className = \"%@\";", sId2, @"vip select"];

                                    [self.webPhongChieu stringByEvaluatingJavaScriptFromString:sQuerry];
                                    [self.webPhongChieu stringByEvaluatingJavaScriptFromString:sQuerry2];
                                    [self.webPhongChieu reload];
                                }
                                else{
                                    NSLog(@"%s - ghe : %d - ghe - 1 : %d", __FUNCTION__, ghe, ghe - 1);
                                    ItemGheXemFilm *itemGheLove2 = [itemHangGhe.arrGhe objectAtIndex:(itemHangGhe.arrGhe.count - (ghe - 1))];
                                    NSLog(@"%s - itemGheLove2 : %@", __FUNCTION__, itemGheLove2.stt);
                                    [arrGheChon addObject:itemGhe];
                                    [arrGheChon addObject:itemGheLove2];
                                    itemGhe.trangthai = 1;
                                    itemGheLove2.trangthai = 1;
                                    sID = [NSString stringWithFormat:@"%@%@", itemHangGhe.stt, itemGhe.stt];
                                    NSString *sQuerry = [NSString stringWithFormat:@"document.getElementById(\"%@\").className = \"%@\";", sID, @"vip select"];
                                    NSLog(@"%s - sQuerry : %@", __FUNCTION__, sQuerry);

                                    NSString *sId2 = [NSString stringWithFormat:@"%@%@", itemHangGhe.stt, itemGheLove2.stt];
                                    NSLog(@"%s - sId2 : %@", __FUNCTION__, sId2);
                                    NSString *sQuerry2 = [NSString stringWithFormat:@"document.getElementById(\"%@\").className = \"%@\";", sId2, @"vip select"];
                                    NSLog(@"%s - sQuerry2 : %@", __FUNCTION__, sQuerry2);

                                    [self.webPhongChieu stringByEvaluatingJavaScriptFromString:sQuerry];
                                    [self.webPhongChieu stringByEvaluatingJavaScriptFromString:sQuerry2];
                                    [self.webPhongChieu reload];
                                }
                            }
                        }
                    }
                    break;
                }
                nDem ++;
            }
            break;
        }
    }
    [self capNhatDanhSachGheChon];
    [self tinhToanTongSoTienPhaiTra];
}

- (void)capNhatPhongKhiChonGheQuocGia:(NSString*)sHang ghe:(int)ghe{
    NSLog(@"%s - sHang : %@", __FUNCTION__, sHang);
    if (!arrGheChon) {
        arrGheChon = [[NSMutableArray alloc] init];
    }
    NSString *sID = @"";
    int nDem = 0;
    for (ItemHangXemFilm *itemHangGhe in self.phongHienTai.arrDayGhe) {
        if ([itemHangGhe.stt isEqualToString:sHang]) {
            for (ItemGheXemFilm *itemGhe in itemHangGhe.arrGhe) {
                if ([itemGhe.stt intValue] == ghe) {
                    if ([arrGheChon containsObject:itemGhe]) {
                        NSLog(@"%s =======================> ton tai trong danh sach : trang thai vip : %@ - itemGhe.trangthai : %d", __FUNCTION__, itemGhe.vip, itemGhe.trangthai);
                        if (![self kIemTraDieuKienKhiBoGhe:itemHangGhe ghe:nDem]) {
                            return;
                        }
                        if (itemGhe.trangthai == 1) {
                            itemGhe.trangthai = 0;
                            sID = [NSString stringWithFormat:@"%@%@", itemHangGhe.stt, itemGhe.stt];
                            NSLog(@"%s =======================> sID : %@", __FUNCTION__, sID);
                            [arrGheChon removeObject:itemGhe];
                            if (sID.length > 0) {
                                NSString *sClassName = @"";
                                NSString *sQuerry = @"";
                                if ([itemGhe.vip isEqualToString:@"0"]) {
                                    sClassName = @"";
                                    sQuerry = [NSString stringWithFormat:@"document.getElementById(\"%@\").className = \"%@\";", sID, @""];
                                }
                                else if ([itemGhe.vip isEqualToString:@"1"])
                                {
                                    if ([itemGhe.vip isEqualToString:@"1"]){
                                        sClassName = @"vip";
                                    }
                                    else{
                                        sClassName = @"love";
                                    }
                                    sQuerry = [NSString stringWithFormat:@"document.getElementById(\"%@\").className = \"%@\";", sID, @"vip"];
                                }
                                else{
                                    NSLog(@"%s ==============> vao trong khu vuc love : sID : %@", __FUNCTION__, sID);
                                    if (ghe % 2 != 0) {
                                        NSLog(@"%s ==============> vao trong khu vuc love : ghe chia 2 != 0)", __FUNCTION__);
                                        ItemGheXemFilm *itemGheLove2 = [itemHangGhe.arrGhe objectAtIndex:(itemHangGhe.arrGhe.count - (ghe + 1))];
                                        [arrGheChon removeObject:itemGheLove2];
                                        NSString *sId2 = [NSString stringWithFormat:@"%@%@", itemHangGhe.stt, itemGheLove2.stt];
                                        NSString *sQuerry2 = [NSString stringWithFormat:@"document.getElementById(\"%@\").className = \"%@\";", sId2, @"love"];
                                        NSLog(@"%s - sQuerry2 : %@", __FUNCTION__, sQuerry2);
                                        [self.webPhongChieu stringByEvaluatingJavaScriptFromString:sQuerry2];
                                    }
                                    else{
                                        NSLog(@"%s ==============> vao trong khu vuc love : ghe chia 2 == 0)", __FUNCTION__);
                                        ItemGheXemFilm *itemGheLove2 = [itemHangGhe.arrGhe objectAtIndex:(itemHangGhe.arrGhe.count - (ghe - 1))];
                                        [arrGheChon removeObject:itemGheLove2];
                                        NSString *sId2 = [NSString stringWithFormat:@"%@%@", itemHangGhe.stt, itemGheLove2.stt];
                                        NSString *sQuerry2 = [NSString stringWithFormat:@"document.getElementById(\"%@\").className = \"%@\";", sId2, @"love"];
                                        [self.webPhongChieu stringByEvaluatingJavaScriptFromString:sQuerry2];
                                    }
                                    sQuerry = [NSString stringWithFormat:@"document.getElementById(\"%@\").className = \"%@\";", sID, @"love"];
                                }
                                NSString *sTemp = [self.webPhongChieu stringByEvaluatingJavaScriptFromString:sQuerry];
                                NSLog(@"%s - sTemp : %@", __FUNCTION__, sTemp);
                                [self.webPhongChieu reload];
                            }
                        }
                    }
                    else{
                        if (itemGhe.trangthai == 0) {
                            if (arrGheChon.count > 8) {
                                [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Số vé tối đa là 8 vé."];
                                return;
                            }
                            if ([itemGhe.vip isEqualToString:@"1"] || [itemGhe.vip isEqualToString:@"0"]) {
                                if ([self kiemTraDieuKienGhe:itemHangGhe ghe:nDem]) {
                                    itemGhe.trangthai = 1;
                                    sID = [NSString stringWithFormat:@"%@%@", itemHangGhe.stt, itemGhe.stt];
                                    [arrGheChon addObject:itemGhe];

                                    if (sID.length > 0) {
                                        NSString *sQuerry = [NSString stringWithFormat:@"document.getElementById(\"%@\").className = \"%@\";", sID, @"vip select"];
                                        [self.webPhongChieu stringByEvaluatingJavaScriptFromString:sQuerry];
                                        [self.webPhongChieu reload];
                                    }
                                }
                                else{
                                    return;
                                }
                            }
                            else{
                                if (ghe % 2 != 0) {
                                    ItemGheXemFilm *itemGheLove2 = [itemHangGhe.arrGhe objectAtIndex:(itemHangGhe.arrGhe.count - (ghe + 1))];
                                    [arrGheChon addObject:itemGhe];
                                    [arrGheChon addObject:itemGheLove2];
                                    itemGhe.trangthai = 1;
                                    itemGheLove2.trangthai = 1;
                                    sID = [NSString stringWithFormat:@"%@%@", itemHangGhe.stt, itemGhe.stt];
                                    NSString *sQuerry = [NSString stringWithFormat:@"document.getElementById(\"%@\").className = \"%@\";", sID, @"vip select"];

                                    NSString *sId2 = [NSString stringWithFormat:@"%@%@", itemHangGhe.stt, itemGheLove2.stt];
                                    NSString *sQuerry2 = [NSString stringWithFormat:@"document.getElementById(\"%@\").className = \"%@\";", sId2, @"vip select"];

                                    [self.webPhongChieu stringByEvaluatingJavaScriptFromString:sQuerry];
                                    [self.webPhongChieu stringByEvaluatingJavaScriptFromString:sQuerry2];
                                    [self.webPhongChieu reload];
                                }
                                else{
                                    NSLog(@"%s - ghe : %d - ghe - 1 : %d", __FUNCTION__, ghe, ghe - 1);
                                    ItemGheXemFilm *itemGheLove2 = [itemHangGhe.arrGhe objectAtIndex:(itemHangGhe.arrGhe.count - (ghe - 1))];
                                    NSLog(@"%s - itemGheLove2 : %@", __FUNCTION__, itemGheLove2.stt);
                                    [arrGheChon addObject:itemGhe];
                                    [arrGheChon addObject:itemGheLove2];
                                    itemGhe.trangthai = 1;
                                    itemGheLove2.trangthai = 1;
                                    sID = [NSString stringWithFormat:@"%@%@", itemHangGhe.stt, itemGhe.stt];
                                    NSString *sQuerry = [NSString stringWithFormat:@"document.getElementById(\"%@\").className = \"%@\";", sID, @"vip select"];
                                    NSLog(@"%s - sQuerry : %@", __FUNCTION__, sQuerry);

                                    NSString *sId2 = [NSString stringWithFormat:@"%@%@", itemHangGhe.stt, itemGheLove2.stt];
                                    NSLog(@"%s - sId2 : %@", __FUNCTION__, sId2);
                                    NSString *sQuerry2 = [NSString stringWithFormat:@"document.getElementById(\"%@\").className = \"%@\";", sId2, @"vip select"];
                                    NSLog(@"%s - sQuerry2 : %@", __FUNCTION__, sQuerry2);

                                    [self.webPhongChieu stringByEvaluatingJavaScriptFromString:sQuerry];
                                    [self.webPhongChieu stringByEvaluatingJavaScriptFromString:sQuerry2];
                                    [self.webPhongChieu reload];
                                }
                            }
                        }
                    }
                    break;
                }
                nDem ++;
            }
            break;
        }
    }
    [self capNhatDanhSachGheChon];
//    [self tinhToanTongSoTienPhaiTra];
    int nTongTien = 0;
    for (ItemGheXemFilm *item in arrGheChon) {
        int nSoTien = [item.gia intValue];
        NSLog(@"%s - nSoTien : %d", __FUNCTION__, nSoTien);
        nTongTien += nSoTien;
    }
    self.lblSoTien.text = [NSString stringWithFormat:@"Tổng tiền: %@đ", [Common hienThiTienTe:nTongTien]];
}

- (BOOL)kiemTraDieuKienGhe:(ItemHangXemFilm*)itemHangGhe ghe:(int)nIndexGhe{
    NSLog(@"%s - nIndexGhe : %d", __FUNCTION__, nIndexGhe);

    if (nIndexGhe == 1) {
        ItemGheXemFilm *temp = [itemHangGhe.arrGhe objectAtIndex:0];
        if (temp.trangthai != 1) {
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng để chừa ít nhất 2 ghế ở giữa"];
            return NO;
        }
    }
    else if (nIndexGhe > 1){
        int nTinhTuTraiQua = nIndexGhe - 2;
        ItemGheXemFilm *temp = [itemHangGhe.arrGhe objectAtIndex:nTinhTuTraiQua];
        if (![temp.hienThi isEqualToString:@"1"] ){
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Vui lòng để chừa ít nhất 2 ghế ở giữa"];
            return NO;
        }
    }
    return YES;
}

- (BOOL)kIemTraDieuKienKhiBoGhe:(ItemHangXemFilm*)itemHangGhe ghe:(int)nIndexGhe{
    NSLog(@"%s - nIndexGhe : %d", __FUNCTION__, nIndexGhe);
    if (nIndexGhe == 0) {
        ItemGheXemFilm *temp = [itemHangGhe.arrGhe objectAtIndex:1];
        ItemGheXemFilm *temp1 = [arrGheChon objectAtIndex:nIndexGhe];
        if ([temp1.vip isEqualToString:@"2"]) {
            return YES;
        }
        NSLog(@"%s - temp.trangthai : %d", __FUNCTION__, temp.trangthai);
        if (temp.trangthai == 1 && [arrGheChon containsObject:temp]) {
            [self boGheKhiDuDieuKien:temp1 itemHangGhe:itemHangGhe];
            [self boGheKhiDuDieuKien:temp itemHangGhe:itemHangGhe];
            return NO;
        }
    }
    else{
        ItemGheXemFilm *temp1 = [itemHangGhe.arrGhe objectAtIndex:nIndexGhe - 1];
        ItemGheXemFilm *temp2 = [itemHangGhe.arrGhe objectAtIndex:nIndexGhe + 1];
        if ([temp1.vip isEqualToString:@"2"]) {
            return YES;
        }
        if ([arrGheChon containsObject:temp2]) {
            if (![temp1.hienThi isEqualToString:@"1"] && temp2.trangthai == 1) {
                [self boGheKhiDuDieuKien:temp1 itemHangGhe:itemHangGhe];
                [self boGheKhiDuDieuKien:temp2 itemHangGhe:itemHangGhe];
                return NO;
            }
        }
    }
    return YES;
}

- (void)boGheKhiDuDieuKien:(ItemGheXemFilm *) itemGhe itemHangGhe:(ItemHangXemFilm *)itemHangGhe{
    if (itemGhe.trangthai == 1) {
        itemGhe.trangthai = 0;
        NSString *sID = [NSString stringWithFormat:@"%@%@", itemHangGhe.stt, itemGhe.stt];
        [arrGheChon removeObject:itemGhe];
        if (sID.length > 0) {
            NSString *sClassName = @"";
            NSString *sQuerry = @"";
            if ([itemGhe.vip isEqualToString:@"0"]) {
                sClassName = @"";
                sQuerry = [NSString stringWithFormat:@"document.getElementById(\"%@\").className = \"%@\";", sID, @""];
            }
            else if ([itemGhe.vip isEqualToString:@"1"])
            {
                if ([itemGhe.vip isEqualToString:@"1"]){
                    sClassName = @"vip";
                }
                else{
                    sClassName = @"love";
                }
                sQuerry = [NSString stringWithFormat:@"document.getElementById(\"%@\").className = \"%@\";", sID, @"vip"];
            }
            NSString *sTemp = [self.webPhongChieu stringByEvaluatingJavaScriptFromString:sQuerry];
            NSLog(@"%s - sTemp : %@", __FUNCTION__, sTemp);
            [self.webPhongChieu reload];
        }
    }
}

- (void)capNhatDanhSachGheChon {
    NSString *sDanhSachGhe = @"";
    for (int i = 0; i < arrGheChon.count; i ++) {
        ItemGheXemFilm *item = [arrGheChon objectAtIndex:i];
        if (i == arrGheChon.count - 1) {
            sDanhSachGhe = [sDanhSachGhe stringByAppendingString:[NSString stringWithFormat:@" %@%@", item.sHangGhe, item.stt]];
        }
        else{
            sDanhSachGhe = [sDanhSachGhe stringByAppendingString:[NSString stringWithFormat:@" %@%@, ", item.sHangGhe, item.stt]];
        }
    }
    self.lblSoGhe.text = [NSString stringWithFormat:@"Số ghế: %@", sDanhSachGhe];
}

- (void)capNhatDanhSachGheChonCGV{
    NSString *sDanhSachGhe = @"";
    for (int i = 0; i < arrGheChon.count; i ++) {
        ItemGheXemFilm *item = [arrGheChon objectAtIndex:i];
        if (i == 0 && sDanhSachGhe.length == 0) {
            sDanhSachGhe = [sDanhSachGhe stringByAppendingString:item.stt];
        }
        else{
            sDanhSachGhe = [sDanhSachGhe stringByAppendingString:[NSString stringWithFormat:@", %@ ", item.stt]];
        }
    }
    self.lblSoGhe.text = [NSString stringWithFormat:@"Số ghế: %@", sDanhSachGhe];
}

- (void)tinhToanTongSoTienPhaiTra{
    int nTongTien = 0;
    for (ItemGheXemFilm *item in arrGheChon) {
        int nSoTien = [item.gia intValue];
        nTongTien += nSoTien;
    }
    self.lblSoTien.text = [NSString stringWithFormat:@"Tổng tiền: %@đ", [Common hienThiTienTe:nTongTien]];
    NSLog(@"%s - nTongTien : %d", __FUNCTION__, nTongTien);
}

- (int)getMaChuyenTuChuCaiSangSo:(NSString *)sChu{
    return [sChu characterAtIndex:0];
}

- (NSString *)getMaChuyenTuSoSangChu:(int)nSo{
    return [NSString stringWithFormat:@"%c", (char)nSo];
}

- (IBAction)suKienChonTiepTuc:(id)sender {
    NSLog(@"%s - START", __FUNCTION__);
    isTiepTuc = YES;
    if (self.delegate) {
        NSLog(@"%s - self.delegate != nil", __FUNCTION__);
        [self.delegate sendLaiRapPhim:self.phongHienTai gheChon:arrGheChon];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
//    [_arrGheChon release];
    [_webPhongChieu release];
    [_phongHienTai release];
    [_lblSoGhe release];
    [_lblSoTien release];
    [_arrGheCGV release];
    [_viewGheCGV release];
    [_viewGhePlatium release];
    [super dealloc];
}
@end
