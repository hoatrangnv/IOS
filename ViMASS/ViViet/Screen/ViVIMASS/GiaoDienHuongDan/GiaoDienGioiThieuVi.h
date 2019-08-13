//
//  GiaoDienGioiThieuVi.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 11/17/17.
//

#import <UIKit/UIKit.h>
#import "GiaoDichViewController.h"
@interface GiaoDienGioiThieuVi : GiaoDichViewController
@property (retain, nonatomic) IBOutlet UIWebView *webHuongDan;
@property (retain, nonatomic) IBOutlet UIView *viewQR;
@property (retain, nonatomic) IBOutlet UIImageView *imgvQR;
@property (retain, nonatomic) IBOutlet UIImageView *imgvAvatar;
@property (retain, nonatomic) IBOutlet UILabel *lblName;
@property (assign) int nType;

@end
