//
//  QRDonViHeaderCuaToi.m
//  ViViMASS
//
//  Created by Tam Nguyen on 3/1/18.
//

#import "QRDonViHeaderCuaToi.h"

@implementation QRDonViHeaderCuaToi

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [_imgvAvatar release];
    [_imgvQR release];
    [_lblName release];
    [_btnThemSanPham release];
    [_btnPhongToQR release];
    [_btnChonXemSanPham release];
    [super dealloc];
}
@end
