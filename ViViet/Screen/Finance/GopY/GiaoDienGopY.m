//
//  GiaoDienGopY.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 11/9/15.
//
//

#import "GiaoDienGopY.h"

@interface GiaoDienGopY ()

@end

@implementation GiaoDienGopY

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"Góp ý";
    [self addTitleView:@"Góp ý"];
    [self addButtonBack];
}

- (void)dealloc {
    [_edGopY release];
    [super dealloc];
}
- (IBAction)suKienGuiGopY:(id)sender {
    NSString *sNoiDung = @"Người gửi: %@<br/>Email: %@<br/>SDT: %@<br/>Góp ý: %@";
    sNoiDung = [NSString stringWithFormat:sNoiDung, self.mThongTinTaiKhoanVi.sNameAlias, [self.mThongTinTaiKhoanVi layThuDienTu], self.mThongTinTaiKhoanVi.sPhone, self.edGopY.text];
    NSLog(@"%s - %s : sNoiDung : %@", __FILE__, __FUNCTION__, sNoiDung);
    self.mDinhDanhKetNoi = @"GOP_Y";
    [GiaoDichMang ketNoiGuiMailSaoKeDen:@"hotro@vimass.vn"
                             tieuDeMail:@"Khiếu nại giao dịch Ví điện tử"
                                noiDung:sNoiDung
                          noiNhanKetQua:self];
}

- (void)xuLyKetNoiThanhCong:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua{
    if ([sDinhDanhKetNoi isEqualToString:@"GOP_Y"]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Gửi góp ý thành công"];
    }
}

- (void)xuLyKetNoiThatBai:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua{
    if ([sDinhDanhKetNoi isEqualToString:@"GOP_Y"]) {
        [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Gửi góp ý thất bại. Vui lòng thử lại sau."];
    }
}

@end
