//
//  ViewChiTietMotGiaoDichTheoLo.m
//  ViViMASS
//
//  Created by DucBui on 6/30/15.
//
//

#import "ViewChiTietMotGiaoDichTheoLo.h"
#import "RoundAlert.h"

@implementation ViewChiTietMotGiaoDichTheoLo

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setMXauHtmlHienThi:(NSString *)mXauHtmlHienThi
{
    if(_mXauHtmlHienThi)
        [_mXauHtmlHienThi release];
    _mXauHtmlHienThi = [mXauHtmlHienThi retain];
    [RoundAlert show];
    [_mWvHienThi loadHTMLString:_mXauHtmlHienThi baseURL:nil];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{

    CGRect frame = _mWvHienThi.frame;
    frame.size.height = 1;
    _mWvHienThi.frame = frame;
    CGSize fittingSize = [_mWvHienThi sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    _mWvHienThi.frame = frame;
    _mWvHienThi.center = self.center;    
    [RoundAlert hide];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if(touch.view == _mViewNen)
    {
        [self removeFromSuperview];
    }
}

- (void)dealloc {
    [_mXauHtmlHienThi release];
    [_mWvHienThi release];
    [_mViewNen release];
    [super dealloc];
}
@end
