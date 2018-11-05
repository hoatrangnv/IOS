//
//  ViewNavigationGiaoDienChinh.m
//  ViViMASS
//
//  Created by DucBT on 1/14/15.
//
//

#import "ViewNavigationGiaoDienChinh.h"
#import "DichVuNotification.h"

@implementation ViewNavigationGiaoDienChinh

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.mlblThongBaoBadgeNumber.layer.masksToBounds = YES;
    self.mlblThongBaoBadgeNumber.layer.cornerRadius = 12;
    [self.mlblThongBaoBadgeNumber setHidden:YES];
    self.mlblBadgeNumberTroChuyen.layer.masksToBounds = YES;
    self.mlblBadgeNumberTroChuyen.layer.cornerRadius = 12;
    [self.mlblBadgeNumberTroChuyen setHidden:YES];
}

- (IBAction)suKienBamNutThongBao:(UIButton *)sender
{
    if([self.mDelegate respondsToSelector:@selector(xuLySuKienBamNutThongBao)])
    {
        [self.mDelegate xuLySuKienBamNutThongBao];
    }
}

- (IBAction)suKienBamNutTroChuyen:(id)sender
{
    if([self.mDelegate respondsToSelector:@selector(xuLySuKienBamNutTroChuyen)])
    {
        [self.mDelegate xuLySuKienBamNutTroChuyen];
    }
}
- (IBAction)suKienBamNutSaoKe:(id)sender {
    if (self.mDelegate) {
        [self.mDelegate xuLySuKienBamNutSaoKe];
    }
}

- (void)hienThiBagdeNumber
{
    int nBagdeNumberQuangBa = [[DichVuNotification shareService] laySoLuongTinChuaDocTrongChucNang:TIN_QUANG_BA];
    NSLog(@"%s - nBagdeNumberQuangBa : %d", __FUNCTION__, nBagdeNumberQuangBa);
    if(nBagdeNumberQuangBa > 0)
    {
        [self.mlblThongBaoBadgeNumber setText:[NSString stringWithFormat:@"%d", nBagdeNumberQuangBa]];
        [self.mlblThongBaoBadgeNumber setHidden:NO];
    }
    else
    {
        [self.mlblThongBaoBadgeNumber setHidden:YES];
    }
}

- (void)hienThiSoTien:(NSString *)sSoTien {
    CGRect rectChinh = self.lblChinh.frame;
    if (sSoTien.length > 0) {
        rectChinh.size.height = self.frame.size.height - 19;
    }
    else {
        rectChinh.size.height = self.frame.size.height;
    }
    self.lblChinh.frame = rectChinh;
    self.lblSoDu.text = sSoTien;
}

- (void)dealloc {
    [_mlblThongBaoBadgeNumber release];
    [_mlblBadgeNumberTroChuyen release];
    [_lblSoDu release];
    [_lblChinh release];
    [super dealloc];
}
@end
