//
//  ChiTietSoTietKiemViewController.h
//  ViViMASS
//
//  Created by DucBui on 5/21/15.
//
//

#import "GiaoDichViewController.h"
#import "SoTietKiem.h"

@interface ChiTietSoTietKiemViewController : GiaoDichViewController
@property (nonatomic, retain) SoTietKiem *mSoTietKiem;
@property (retain, nonatomic) IBOutlet UIWebView *mwvHienThi;
@property (retain, nonatomic) IBOutlet UIButton *mbtnRutGocTruochan;
@property (retain, nonatomic) IBOutlet UIScrollView *mscrView;
@property (retain, nonatomic) IBOutlet UILabel *mlblRutDungHan;
@property (retain, nonatomic) IBOutlet UILabel *mlblRutTruocHan;
@property (retain, nonatomic) IBOutlet UIView *mViewChuaThongBao;
@property (retain, nonatomic) IBOutlet UIView *mViewDen;

@end
