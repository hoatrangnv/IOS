//
//  ViewChiTietMotGiaoDichTheoLo.h
//  ViViMASS
//
//  Created by DucBui on 6/30/15.
//
//

#import <UIKit/UIKit.h>

@interface ViewChiTietMotGiaoDichTheoLo : UIView <UIWebViewDelegate>

@property (retain, nonatomic) IBOutlet UIWebView *mWvHienThi;
@property (retain, nonatomic) NSString *mXauHtmlHienThi;
@property (retain, nonatomic) IBOutlet UIView *mViewNen;
@end
